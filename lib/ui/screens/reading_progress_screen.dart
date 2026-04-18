import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/models/book.dart';
import '../../data/repositories/bible_repository.dart';

class ReadingProgressScreen extends StatefulWidget {
  final BibleRepository bibleRepo;
  final String activeVersion;

  const ReadingProgressScreen({
    super.key,
    required this.bibleRepo,
    required this.activeVersion,
  });

  @override
  State<ReadingProgressScreen> createState() => _ReadingProgressScreenState();
}

class _ReadingProgressScreenState extends State<ReadingProgressScreen> {
  late Map<int, double> _progresses;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgresses();
  }

  Future<void> _loadProgresses() async {
    setState(() => _isLoading = true);
    final progresses = await widget.bibleRepo.getAllBookProgresses(widget.activeVersion);
    setState(() {
      _progresses = progresses;
      _isLoading = false;
    });
  }

  Future<void> _clearBookProgress(int bookId) async {
    await widget.bibleRepo.clearBookProgress(bookId);
    await _loadProgresses();
  }

  Future<void> _clearAllProgress() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Limpar Tudo?'),
        content: const Text('Tem a certeza que deseja limpar o progresso de todos os livros?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('LIMPAR', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await widget.bibleRepo.clearAllProgress();
      await _loadProgresses();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Progresso de todos os livros removido.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Progresso de Leitura', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
          backgroundColor: const Color(0xFFFDFBF7),
          elevation: 0,
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final allBooks = Book.allBooks;
    final booksWithProgress = allBooks.where((book) => (_progresses[book.id] ?? 0) > 0).length;
    final hasAnyProgress = booksWithProgress > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Progresso de Leitura', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(
              'Livros Lidos: $booksWithProgress de ${allBooks.length}',
              style: GoogleFonts.lato(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFDFBF7),
        elevation: 0,
      ),
      body: ListView.builder(
        // Keep the last row visible above the FAB and system gesture area.
        padding: EdgeInsets.fromLTRB(16, 12, 16, hasAnyProgress ? 108 + bottomInset : 24 + bottomInset),
        itemCount: allBooks.length,
        itemBuilder: (ctx, idx) {
          final book = allBooks[idx];
          final progress = _progresses[book.id] ?? 0.0;
          final percent = (progress * 100).toStringAsFixed(0);
          final hasProgress = progress > 0;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.name,
                            style: GoogleFonts.lato(
                              fontSize: 14,
                              fontWeight: hasProgress ? FontWeight.w600 : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '$percent%',
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              color: hasProgress ? const Color(0xFF5D4037) : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (hasProgress)
                      IconButton(
                        icon: const Icon(Icons.close, size: 20, color: Colors.red),
                        onPressed: () async {
                          await _clearBookProgress(book.id);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Progresso de ${book.name} removido.'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        tooltip: 'Limpar progresso',
                      )
                    else
                      const SizedBox(width: 48),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      hasProgress ? const Color(0xFF5D4037) : Colors.grey[400]!,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: hasAnyProgress
          ? FloatingActionButton.extended(
              onPressed: _clearAllProgress,
              backgroundColor: Colors.red[400],
              icon: const Icon(Icons.delete_sweep),
              label: const Text('Limpar Tudo'),
            )
          : null,
    );
  }
}
