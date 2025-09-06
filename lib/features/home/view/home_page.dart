// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectino/core/network/network_providers.dart';
import 'package:connectino/core/utils/router/app_router.gr.dart';
import 'package:connectino/features/auth/view_model/auth_provider.dart';
import 'package:connectino/features/home/view_model/home_provider.dart';
import 'package:connectino/widgets/homeWidget/bottom_sheet.dart';
import 'package:connectino/widgets/homeWidget/note_detail_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

@RoutePage()
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeNoti = ref.read(homeProvider.notifier);
    final homeState = ref.watch(homeProvider);
    final authNoti = ref.read(authProvider.notifier);
    final isMounted = useIsMounted();

    ref.listen<AsyncValue<NetworkStatus>>(netStatusProvider, (prev, next) {
      next.whenData((s) async {
        if (!isMounted()) return;
        if (s == NetworkStatus.offline) {
          context.router.replaceAll([const OfflineRoute()]);
        }
      });
    });

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final status = await ref
            .read(netStatusProvider.future)
            .timeout(
              const Duration(seconds: 6),
              onTimeout: () => NetworkStatus.offline,
            );

        if (!isMounted()) return;
        if (status == NetworkStatus.offline) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Şu anda çevrimdışı. Offline moda geçiliyor...'),
              ),
            );
          }
          await Future.delayed(const Duration(milliseconds: 300));
          if (!isMounted()) return;
          context.router.replaceAll([const OfflineRoute()]);
          return;
        }

        await homeNoti.fetchNotes();
      });
      return null;
    }, []);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          final _ = await showModalBottomSheet(
            useRootNavigator: false,
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder: (context) => NoteAddSheet(),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 10),
                Icon(LucideIcons.wifi, color: Colors.green),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Welcome to Connectino !',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ),
                IconButton(
                  onPressed: () async => authNoti.logoutUser(context),
                  icon: const Icon(LucideIcons.logOut),
                ),
              ],
            ),
            const Divider(),
            // içerik
            Expanded(
              child: (homeState.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: homeState.notes.length,
                      itemBuilder: (context, index) {
                        final note = homeState.notes[index];
                        final label = buildDateLabel(
                          note.createdAt,
                          note.updatedAt,
                        );
                        return Card(
                          child: ListTile(
                            title: Text(
                              note.title ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${note.content ?? ''} ',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  LucideIcons.calendar,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                Flexible(
                                  flex: 3,
                                  child: Text(
                                    label,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(
                                LucideIcons.menu,
                                color: Colors.blue,
                              ),
                              onPressed: () async {
                                final action = await showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                  ),
                                  builder: (ctx) => NoteActionSheet(note: note),
                                );
                                if (action == 'updated' ||
                                    action == 'deleted') {
                                  await homeNoti.fetchNotes();
                                }
                              },
                            ),
                          ),
                        );
                      },
                    )),
            ),
          ],
        ),
      ),
    );
  }
}

int? _tsToMs(Timestamp? t) {
  if (t == null) return null;
  return t.seconds * 1000 + (t.nanoseconds ~/ 1000000);
}

String buildDateLabel(Timestamp? createdAt, Timestamp? updatedAt) {
  final cMs = _tsToMs(createdAt);
  final uMs = _tsToMs(updatedAt);

  final isUpdated = (cMs != null && uMs != null && uMs > cMs);

  final tsMs = isUpdated ? uMs : (cMs ?? uMs);
  if (tsMs == null) return '';

  final dt = DateTime.fromMillisecondsSinceEpoch(tsMs);
  final formatted = DateFormat('dd.MM.yyyy - HH:mm').format(dt);

  return isUpdated ? ' Güncellendi: $formatted' : ' Oluşturuldu: $formatted';
}
