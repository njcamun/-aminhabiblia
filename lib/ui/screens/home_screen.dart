import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../logic/providers.dart';
import '../../logic/initialization_provider.dart';
import '../../data/models/bible_verse.dart';
import 'bible/bible_screen.dart';
import 'hymnal/hymnal_list_screen.dart';
import 'quiz/quiz_screen.dart';
import '../../screens/memorize_screen.dart'; 
import 'settings/settings_screen.dart';
import '../../screens/devotional_list_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initAsync = ref.watch(appInitializationProvider);

    return Scaffold(
      body: initAsync.when(
        data: (_) => const HomeContent(),
        loading: () => const LoadingScreen(),
        error: (err, stack) => ErrorScreen(error: err.toString()),
      ),
    );
  }
}

class HomeContent extends ConsumerStatefulWidget {
  const HomeContent({super.key});

  @override
  ConsumerState<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends ConsumerState<HomeContent> {
  Future<BibleVerse?>? _verseOfDayFuture;
  bool _isSyncing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _verseOfDayFuture ??= ref
        .read(bibleRepositoryProvider)
        .getRandomVerse(ref.read(activeBibleVersionProvider));
  }

  Future<void> _handleManualSync(BuildContext context) async {
    final syncService = ref.read(firebaseSyncServiceProvider);

    if (syncService == null || !syncService.isAuthenticated) {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Sincronização indisponível',
            style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Para sincronizar os seus dados, faça login primeiro em Definições > Sincronização Cloud > Entrar.',
            style: GoogleFonts.lato(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('FECHAR'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5D4037),
                foregroundColor: Colors.white,
              ),
              child: const Text('ABRIR DEFINIÇÕES'),
            ),
          ],
        ),
      );
      return;
    }

    if (_isSyncing) return;

    setState(() => _isSyncing = true);
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        content: Text('A sincronizar dados com a cloud...'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    try {
      await syncService.uploadLocalDataToCloud();
      await syncService.syncFromCloud();
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Sincronização concluída com sucesso.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Não foi possível concluir a sincronização.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeVersion = ref.watch(activeBibleVersionProvider);
    final bibleRepo = ref.watch(bibleRepositoryProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 40.0 : 24.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 32),
                  _buildVerseOfTheDay(bibleRepo, activeVersion, isTablet),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Biblioteca Sagrada'),
                  const SizedBox(height: 16),
                  _buildBibleCard(context, activeVersion),
                  const SizedBox(height: 12),
                  _buildDevotionalCard(context),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Hinários'),
                  const SizedBox(height: 16),
                  _buildHymnalGrid(context, ref, isTablet),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Desafios Bíblicos'),
                  const SizedBox(height: 16),
                  _buildActivityGrid(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Graça e Paz,',
              style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[600]),
            ),
            Text(
              'Bom dia!',
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: _isSyncing ? null : () => _handleManualSync(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: _isSyncing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation(Color(0xFF5D4037)),
                        ),
                      )
                    : const Icon(Icons.sync_outlined, color: Color(0xFF5D4037)),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: const Icon(Icons.settings_outlined, color: Color(0xFF5D4037)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerseOfTheDay(bibleRepo, String version, bool isTablet) {
    return FutureBuilder<BibleVerse?>(
      future: _verseOfDayFuture,
      builder: (context, snapshot) {
        final verse = snapshot.data;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isTablet ? 32 : 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              colors: [Color(0xFF2D2D2D), Color(0xFF4A4A4A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Color(0xFFD4AF37), size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'PALAVRA DO DIA',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.6),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                verse != null ? '"${verse.text}"' : '"Buscai primeiro o Reino de Deus..."',
                style: GoogleFonts.playfairDisplay(
                  fontSize: isTablet ? 24 : 20,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    verse != null ? '${verse.bookName} ${verse.chapter}:${verse.verse}' : 'Mateus 6:33',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFD4AF37),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (verse != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BibleScreen(
                                  initialBookId: verse.bookId,
                                  initialChapter: verse.chapter,
                                  highlightVerseKey: verse.verseKey,
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.visibility_outlined, color: Colors.white70, size: 20),
                        tooltip: 'Ver na Bíblia',
                      ),
                      IconButton(
                        onPressed: () {
                          if (verse != null) {
                            Share.share('${verse.bookName} ${verse.chapter}:${verse.verse} - ${verse.text}');
                          }
                        },
                        icon: const Icon(Icons.share_outlined, color: Colors.white70, size: 20),
                        tooltip: 'Compartilhar',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBibleCard(BuildContext context, String version) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5DC),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.menu_book, color: Color(0xFF5D4037), size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bíblia Sagrada', style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(version, style: GoogleFonts.lato(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BibleScreen(alwaysShowBookList: true),
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A1A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text('Ler', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDevotionalCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.history_edu, color: Colors.green, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Meus Devocionais', style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Suas anotações e reflexões', style: GoogleFonts.lato(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DevotionalListScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: const Text('Ver', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityGrid(BuildContext context) {
    return Row(
      children: [
        _ActivityMiniCard(
          title: 'Quiz',
          icon: Icons.quiz,
          color: const Color(0xFFFFF8E1),
          iconColor: const Color(0xFFD4AF37),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QuizScreen())),
        ),
        const SizedBox(width: 16),
        _ActivityMiniCard(
          title: 'Memorizar',
          icon: Icons.psychology,
          color: const Color(0xFFE8F5E9),
          iconColor: Colors.green,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MemorizeScreen())),
        ),
      ],
    );
  }

  Widget _buildHymnalGrid(BuildContext context, WidgetRef ref, bool isTablet) {
    return Row(
      children: [
        _HymnalMiniCard(
          title: 'Harpa Cristã',
          color: const Color(0xFF1A237E),
          onTap: () {
            ref.read(activeHymnalProvider.notifier).state = 'HARPA';
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HymnalListScreen()));
          },
        ),
        const SizedBox(width: 16),
        _HymnalMiniCard(
          title: 'Novo Cântico',
          color: const Color(0xFFB71C1C),
          onTap: () {
            ref.read(activeHymnalProvider.notifier).state = 'NOVO_CANTICO';
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HymnalListScreen()));
          },
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A)),
    );
  }
}

class _ActivityMiniCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActivityMiniCard({required this.title, required this.icon, required this.color, required this.iconColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HymnalMiniCard extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _HymnalMiniCard({required this.title, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.music_note, color: Colors.white70),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingScreen extends ConsumerWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final message = ref.watch(initializationMessageProvider);
    final progress = ref.watch(importProgressProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.auto_stories, size: 80, color: Color(0xFFD4AF37)),
              const SizedBox(height: 48),
              // Barra de Progresso Estilizada
              Stack(
                children: [
                  Container(
                    height: 6,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(3)),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    height: 6,
                    width: MediaQuery.of(context).size.width * 0.8 * progress,
                    decoration: BoxDecoration(color: const Color(0xFFD4AF37), borderRadius: BorderRadius.circular(3)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(fontSize: 18, fontStyle: FontStyle.italic, color: const Color(0xFF5D4037)),
              ),
              const SizedBox(height: 8),
              Text(
                "${(progress * 100).toInt()}%",
                style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Erro ao inicializar: $error')),
    );
  }
}
