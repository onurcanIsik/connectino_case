// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectino/core/box/view_model/box_provider.dart';
import 'package:connectino/core/models/notes_model.dart';
import 'package:connectino/core/api/view_model/api_provider.dart';
import 'package:connectino/features/home/view_model/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NoteAddSheet extends HookConsumerWidget {
  const NoteAddSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final contentController = useTextEditingController();
    final homeNoti = ref.read(homeProvider.notifier);
    final apiNoti = ref.read(apiProvider.notifier);
    final homeState = ref.watch(homeProvider);
    final boxNoti = ref.read(boxProvider.notifier);

    Future<void> onSave() async {
      final title = titleController.text.trim();
      final content = contentController.text.trim();

      if (title.isEmpty || content.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lütfen tüm alanları doldurun")),
        );
        return;
      }

      try {
        final id = await apiNoti.saveData(title, content);
        print("Saved with ID: $id");

        final note = NotesModel(
          id: id,
          title: title,
          content: content,
          createdAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
        );
        await homeNoti.addNote(note, id!);
        await boxNoti.addNote({
          "id": id,
          "title": title,
          "content": content,
          "createdAt": DateTime.now().toIso8601String(),
          "updatedAt": DateTime.now().toIso8601String(),
        }, isOnline: id.isNotEmpty);

        if (context.mounted) await homeNoti.fetchNotes();
        Navigator.pop(context, {"title": title, "content": content});
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Kaydedilemedi: $e")));
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
            "Yeni Not Ekle",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Başlık",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: contentController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: "İçerik",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton.icon(
              onPressed: homeState.isLoading == false ? onSave : null,
              icon: homeState.isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(LucideIcons.save),
              label: Text(
                homeState.isLoading ? "Kaydediliyor..." : "Notu Kaydet",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
