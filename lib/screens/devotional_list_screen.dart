import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../logic/providers.dart';
import '../data/models/study_models.dart';
import '../data/models/bible_verse.dart';
import '../ui/screens/bible/bible_screen.dart';

class DevotionalListScreen extends ConsumerWidget {
  const DevotionalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(userNotesProvider);
    final bibleRepo = ref.watch(bibleRepositoryProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: Text('Meus Devocionais', 
          style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 24, color: const Color(0xFF1A1A1A))),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF5D4037)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        top: false,
        child: notesAsync.when(
          data: (notes) {
            if (notes.isEmpty) return _buildEmptyState();
            
            return ListView.builder(
              padding: EdgeInsets.only(left: 20, right: 20, top: 24, bottom: MediaQuery.of(context).padding.bottom + 24),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return _buildDevotionalCard(context, note, bibleRepo, ref);
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37))),
          error: (err, stack) => Center(child: Text('Erro ao carregar: $err')),
        ),
      ),
    );
  }

  Widget _buildDevotionalCard(BuildContext context, UserNote note, dynamic bibleRepo, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => _openDevotionalPopup(context, note.verseKey, readOnly: true),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<BibleVerse?>(
                  future: bibleRepo?.getVerseByKey(note.verseKey),
                  builder: (context, snapshot) {
                    final verse = snapshot.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title != null && note.title!.isNotEmpty ? note.title! : 'Sem tema',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1A1A),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          verse != null ? '${verse.bookName} ${verse.chapter}:${verse.verse}' : 'Referência indisponível',
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: const Color(0xFFD4AF37),
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Criado em ${_formatDate(note.lastModified)}',
                      style: GoogleFonts.lato(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _MiniActionButton(
                      label: 'VER',
                      icon: Icons.visibility_outlined,
                      color: const Color(0xFF5D4037),
                      onTap: () => _openDevotionalPopup(context, note.verseKey, readOnly: true),
                    ),
                    const SizedBox(width: 8),
                    _MiniActionButton(
                      label: 'EDITAR',
                      icon: Icons.edit_note_rounded,
                      color: const Color(0xFF5D4037),
                      onTap: () => _openDevotionalPopup(context, note.verseKey, readOnly: false),
                    ),
                    const SizedBox(width: 8),
                    _MiniActionButton(
                      label: 'APAGAR',
                      icon: Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                      onTap: () => _confirmDelete(context, bibleRepo, note.verseKey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openDevotionalPopup(BuildContext context, String verseKey, {required bool readOnly}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fechar',
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, anim1, anim2) => NoteEditorDialog(verseKey: verseKey, readOnly: readOnly),
      transitionBuilder: (context, anim1, anim2, child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8 * anim1.value, sigmaY: 8 * anim1.value),
        child: FadeTransition(
          opacity: anim1,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(CurvedAnimation(parent: anim1, curve: Curves.easeOutBack)),
            child: child
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, dynamic repo, String verseKey) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Apagar Devocional?", style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        content: Text("Deseja remover permanentemente esta anotação da sua biblioteca?", style: GoogleFonts.lato()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("CANCELAR", style: GoogleFonts.lato(color: Colors.grey, fontWeight: FontWeight.bold))),
          ElevatedButton(
            onPressed: () async {
              await repo?.deleteNote(verseKey);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Devocional removido com sucesso."),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  )
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, elevation: 0),
            child: const Text("APAGAR", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
            child: const Icon(Icons.history_edu_rounded, size: 80, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Text('Seu diário espiritual está vazio', style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(height: 8),
          Text('Comece a meditar na Palavra e grave suas reflexões.', style: GoogleFonts.lato(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

class _MiniActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MiniActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16, color: color),
        label: Text(
          label,
          style: GoogleFonts.lato(
            fontWeight: FontWeight.w800,
            fontSize: 11,
            color: color,
            letterSpacing: 0.6,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withOpacity(0.35)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          minimumSize: const Size(0, 40),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }
}
