import 'package:connectino/core/box/view_model/box_provider.dart';
import 'package:connectino/core/models/notes_model.dart';
import 'package:connectino/core/api/view_model/api_provider.dart';
import 'package:connectino/features/home/view_model/home_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NoteActionSheet extends HookConsumerWidget {
  const NoteActionSheet({super.key, required this.note});
  final NotesModel note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleCtrl = useTextEditingController(text: note.title ?? '');
    final contentCtrl = useTextEditingController(text: note.content ?? '');
    final isLoading = useState(false);
    final homeNoti = ref.read(homeProvider.notifier);
    final apiNoti = ref.read(apiProvider.notifier);
    final boxNoti = ref.read(boxProvider.notifier);

    Future<void> onUpdate() async {
      final t = titleCtrl.text.trim();
      final c = contentCtrl.text.trim();
      if (t.isEmpty || c.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Başlık ve içerik gerekli')),
        );
        return;
      }
      isLoading.value = true;
      try {
        await apiNoti.updateData(note.id!, t, c);
        await homeNoti.updateNote(
          NotesModel(
            id: note.id,
            title: t,
            content: c,
            createdAt: note.createdAt,
          ),
          FirebaseAuth.instance.currentUser!.uid,
        );
        await boxNoti.updateNote({
          "id": note.id,
          "title": t,
          "content": c,
          "createdAt": note.createdAt?.toDate().toIso8601String(),
          "updatedAt": DateTime.now().toIso8601String(),
        }, isOnline: true);
        if (!context.mounted) return;
        Navigator.pop(context, 'updated');
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Güncellenemedi: $e')));
      } finally {
        isLoading.value = false;
      }
    }

    Future<void> onDelete() async {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Notu sil'),
          content: const Text('Bu notu silmek istediğine emin misin?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Vazgeç'),
            ),
            FilledButton.icon(
              onPressed: () => Navigator.pop(ctx, true),
              icon: const Icon(LucideIcons.trash),
              label: const Text('Sil'),
            ),
          ],
        ),
      );
      if (ok != true) return;

      isLoading.value = true;
      try {
        await ref.read(homeProvider.notifier).deleteNote(note.id!);
        await apiNoti.deleteData(note.id!);
        await boxNoti.deleteNote(note.id!);
        if (!context.mounted) return;
        Navigator.pop(context, 'deleted');
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Silinemedi: $e')));
      } finally {
        isLoading.value = false;
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Notu Düzenle / Sil",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: titleCtrl,
            decoration: const InputDecoration(
              labelText: "Başlık",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: contentCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: "İçerik",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: isLoading.value ? null : onUpdate,
                  icon: isLoading.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(LucideIcons.save),
                  label: Text(isLoading.value ? "Kaydediliyor..." : "Kaydet"),
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filledTonal(
                onPressed: isLoading.value ? null : onDelete,
                icon: const Icon(LucideIcons.trash),
                tooltip: 'Sil',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
