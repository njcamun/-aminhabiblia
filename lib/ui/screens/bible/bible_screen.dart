import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import '../../../logic/providers.dart';
import '../../../data/models/book.dart';
import '../../../data/models/bible_verse.dart';
import '../../../data/models/study_models.dart';

class BibleScreen extends ConsumerStatefulWidget {
  final int? initialBookId;
  final int? initialChapter;
  final String? highlightVerseKey;
  final String? searchTerm;
  final bool alwaysShowBookList;

  const BibleScreen({
    super.key,
    this.initialBookId,
    this.initialChapter,
    this.highlightVerseKey,
    this.searchTerm,
    this.alwaysShowBookList = false,
  });

  @override
  ConsumerState<BibleScreen> createState() => _BibleScreenState();
}

enum BookFilter { all, oldTestament, newTestament, chronological, size }

class _BibleScreenState extends ConsumerState<BibleScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _selectedBookId;
  String? _selectedBookName;
  int _selectedChapter = 1;
  bool _isReading = false;
  double _fontSize = 18.0;
  
  final Set<String> _selectedVerseKeys = {};
  late PageController _pageController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _searchController = TextEditingController();
  bool _isGlobalSearching = false;
  List<BibleVerse> _searchResults = [];
  bool _isLoadingSearch = false;
  String? _activeHighlightKey;
  String? _activeSearchTerm;
  bool _showColorToolbar = false;
  BookFilter _currentFilter = BookFilter.all;
  final Map<int, AsyncValue<Map<int, bool>>> _bookChapterStatuses = {};
  int? _expandedBookId;

  // Ordem cronológica aproximada dos livros (baseada em IDs)
  final List<int> _chronologicalIds = [
    18, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 13, 19, 11, 20, 21, 22, 12, 14, 31, 29, 32, 30, 28, 23, 33, 34, 36, 35, 24, 25, 26, 27, 37, 38, 17, 15, 16, 39, // VT
    59, 48, 52, 53, 46, 47, 45, 41, 40, 42, 44, 49, 51, 57, 50, 54, 56, 55, 60, 61, 58, 65, 43, 62, 63, 64, 66 // NT
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    if (widget.initialBookId != null && widget.initialChapter != null) {
      _selectedBookId = widget.initialBookId;
      _selectedBookName = Book.allBooks.firstWhere((b) => b.id == _selectedBookId).name;
      _selectedChapter = widget.initialChapter!;
      _isReading = true;
      _activeHighlightKey = widget.highlightVerseKey;
      _activeSearchTerm = widget.searchTerm;
      _pageController = PageController(initialPage: _selectedChapter - 1);
    } else if (widget.alwaysShowBookList) {
      _pageController = PageController();
    } else {
      _pageController = PageController();
      WidgetsBinding.instance.addPostFrameCallback((_) => _restoreLastPosition());
    }
  }

  Future<void> _restoreLastPosition() async {
    final bibleRepo = ref.read(bibleRepositoryProvider);
    final settings = await bibleRepo.getSettings();
    if (!mounted) return;
    if (settings.lastBookId != null && settings.lastChapter != null) {
      final bookList = Book.allBooks.where((b) => b.id == settings.lastBookId);
      if (bookList.isNotEmpty) {
        final book = bookList.first;
        setState(() {
          _selectedBookId = settings.lastBookId;
          _selectedBookName = book.name;
          _selectedChapter = settings.lastChapter!;
          _isReading = true;
        });
        Future.delayed(const Duration(milliseconds: 50), () {
          if (mounted && _pageController.hasClients) {
            _pageController.jumpToPage(_selectedChapter - 1);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) async {
    if (query.trim().length < 3) {
      setState(() { _searchResults = []; _isLoadingSearch = false; });
      return;
    }
    setState(() => _isLoadingSearch = true);
    final bibleRepo = ref.read(bibleRepositoryProvider);
    final activeVersion = ref.read(activeBibleVersionProvider);
    final results = await bibleRepo.searchVerses(activeVersion, query);
    setState(() { _searchResults = results; _isLoadingSearch = false; });
    }

  void _loadChapterStatuses(int bookId, String version) async {
    final bibleRepo = ref.read(bibleRepositoryProvider);
    setState(() => _bookChapterStatuses[bookId] = const AsyncValue.loading());
    try {
      final statuses = await bibleRepo.getBookChapterStatuses(version, bookId);
      setState(() => _bookChapterStatuses[bookId] = AsyncValue.data(statuses));
    } catch (e) {
      setState(() => _bookChapterStatuses[bookId] = AsyncValue.error(e, StackTrace.current));
    }
  }

  void _exitReadingToBookChooser() {
    final selectedBookId = _selectedBookId;
    setState(() {
      _isReading = false;
      _selectedVerseKeys.clear();
      _showColorToolbar = false;
      _activeHighlightKey = null;
      _activeSearchTerm = null;
      _expandedBookId = selectedBookId;
    });

    if (selectedBookId != null) {
      final activeVersion = ref.read(activeBibleVersionProvider);
      _loadChapterStatuses(selectedBookId, activeVersion);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeVersion = ref.watch(activeBibleVersionProvider);
    final bibleRepo = ref.watch(bibleRepositoryProvider);
    final progressesAsync = ref.watch(allBookProgressesProvider(activeVersion));
    final theme = ref.watch(readingThemeProvider).value ?? 'light';

    Color bgColor = const Color(0xFFFDFBF7);
    Color textColor = const Color(0xFF1A1A1A);
    if (theme == 'sepia') { bgColor = const Color(0xFFF4ECD8); textColor = const Color(0xFF5B4636); }
    else if (theme == 'dark') { bgColor = const Color(0xFF121212); textColor = const Color(0xFFE0E0E0); }

    return PopScope(
      canPop: !_isReading,
      onPopInvoked: (didPop) {
        if (didPop) return;
        if (_isReading) {
          _exitReadingToBookChooser();
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: bgColor,
        appBar: _selectedVerseKeys.isNotEmpty 
            ? _buildSelectionAppBar(bibleRepo) 
            : (_isReading ? null : _buildBookSelectionAppBar()),
        body: Column(
          children: [
            if (_selectedVerseKeys.isNotEmpty && _showColorToolbar) 
              _buildColorToolbar(bibleRepo),
            Expanded(
              child: _isReading 
                  ? _buildImmersiveReader(bibleRepo, activeVersion, bgColor, textColor, theme)
                  : _buildMainContent(bibleRepo, activeVersion, progressesAsync),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorToolbar(bibleRepo) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _colorOption(null, Icons.format_color_reset, bibleRepo),
          _colorOption(0xFFFFF176, null, bibleRepo),
          _colorOption(0xFFA5D6A7, null, bibleRepo),
          _colorOption(0xFF90CAF9, null, bibleRepo),
          _colorOption(0xFFF48FB1, null, bibleRepo),
        ],
      ),
    );
  }

  void _showStudySheet(String verseKey) {
    ref.read(selectedVerseKeyProvider.notifier).state = verseKey;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _StudyMenuSheet(
        verseKey: verseKey,
        onNavigateToRef: (v) => _navigateToVerse(v),
      ),
    ).then((_) {
      if (_selectedVerseKeys.isEmpty) {
        ref.read(selectedVerseKeyProvider.notifier).state = null;
      }
    });
  }

  PreferredSizeWidget _buildSelectionAppBar(bibleRepo) => AppBar(
    backgroundColor: const Color(0xFF2D2D2D), 
    leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => setState(() { _selectedVerseKeys.clear(); _showColorToolbar = false; })), 
    title: Text('${_selectedVerseKeys.length} selecionados', style: const TextStyle(color: Colors.white, fontSize: 16)), 
    actions: [
      IconButton(icon: const Icon(Icons.share, color: Colors.white), onPressed: () => _shareSelectedVerses(bibleRepo)), 
      IconButton(icon: const Icon(Icons.favorite_border, color: Colors.white), onPressed: () => _favoriteSelectedVerses(bibleRepo)), 
      IconButton(icon: const Icon(Icons.palette_outlined, color: Colors.white), onPressed: () => setState(() => _showColorToolbar = !_showColorToolbar)), 
      IconButton(icon: const Icon(Icons.history_edu, color: Colors.white), onPressed: () {
        if (_selectedVerseKeys.isNotEmpty) _showStudySheet(_selectedVerseKeys.first);
      })
    ]
  );

  PreferredSizeWidget _buildBookSelectionAppBar() => AppBar(
    title: _isGlobalSearching 
      ? TextField(controller: _searchController, autofocus: true, decoration: const InputDecoration(hintText: 'Pesquisar na Bíblia...', border: InputBorder.none), style: GoogleFonts.lato(fontSize: 16), onChanged: _performSearch) 
      : Text('Bíblia Sagrada', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A))), 
    backgroundColor: const Color(0xFFFDFBF7), 
    elevation: 0, 
    centerTitle: true, 
    actions: [
      if (!_isGlobalSearching)
        PopupMenuButton<BookFilter>(
          icon: const Icon(Icons.filter_list, color: Color(0xFF5D4037)),
          onSelected: (BookFilter result) {
            setState(() {
              _currentFilter = result;
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<BookFilter>>[
            const PopupMenuItem<BookFilter>(
              value: BookFilter.all,
              child: Text('Todos os Livros'),
            ),
            const PopupMenuItem<BookFilter>(
              value: BookFilter.oldTestament,
              child: Text('Velho Testamento'),
            ),
            const PopupMenuItem<BookFilter>(
              value: BookFilter.newTestament,
              child: Text('Novo Testamento'),
            ),
            const PopupMenuItem<BookFilter>(
              value: BookFilter.chronological,
              child: Text('Cronológico'),
            ),
            const PopupMenuItem<BookFilter>(
              value: BookFilter.size,
              child: Text('Por Tamanho (Menor ao Maior)'),
            ),
          ],
        ),
      IconButton(
        icon: Icon(_isGlobalSearching ? Icons.close : Icons.search, color: const Color(0xFF5D4037)), 
        onPressed: () { setState(() { if (_isGlobalSearching) { _searchController.clear(); _searchResults = []; } _isGlobalSearching = !_isGlobalSearching; }); }
      )
    ], 
    bottom: _isGlobalSearching ? null : TabBar(controller: _tabController, labelColor: const Color(0xFF5D4037), indicatorColor: const Color(0xFFD4AF37), tabs: const [Tab(text: "LIVROS"), Tab(text: "FAVORITOS")])
  );

  Widget _buildMainContent(bibleRepo, String version, AsyncValue<Map<int, double>> progressesAsync) => _isGlobalSearching ? _buildSearchResults(bibleRepo, version) : TabBarView(controller: _tabController, children: [_buildBookList(bibleRepo, version, progressesAsync), _buildFavoritesList(version)]);

  Widget _buildBookList(bibleRepo, String version, AsyncValue<Map<int, double>> progressesAsync) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return progressesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37))),
      error: (err, stack) => _emptyStudyState("Erro ao carregar progressos dos livros"),
      data: (progresses) {
        List<Book> filteredBooks = List.from(Book.allBooks);

        switch (_currentFilter) {
          case BookFilter.oldTestament:
            filteredBooks = filteredBooks.where((b) => !b.isNewTestament).toList();
            break;
          case BookFilter.newTestament:
            filteredBooks = filteredBooks.where((b) => b.isNewTestament).toList();
            break;
          case BookFilter.chronological:
            filteredBooks.sort((a, b) {
              final aIndex = _chronologicalIds.indexOf(a.id);
              final bIndex = _chronologicalIds.indexOf(b.id);
              return aIndex.compareTo(bIndex);
            });
            break;
          case BookFilter.size:
            // Ordenação do menor ao maior (crescente)
            filteredBooks.sort((a, b) => a.chapters.compareTo(b.chapters));
            break;
          case BookFilter.all:
            // Ordem original (bíblica padrão)
            break;
        }

        return ListView.builder(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 24 + bottomInset),
          itemCount: filteredBooks.length,
          itemBuilder: (context, index) {
            final book = filteredBooks[index];
            final progress = progresses[book.id] ?? 0.0;
            return Card(
              elevation: 0, color: Colors.white, margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
              child: ExpansionTile(
                key: ValueKey('book_${book.id}_${_expandedBookId == book.id}'),
                initiallyExpanded: _expandedBookId == book.id,
                title: Row(children: [Expanded(child: Text(book.name, style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.w600))), IconButton(icon: const Icon(Icons.info_outline, size: 20, color: Color(0xFFD4AF37)), onPressed: () => _showBookPanorama(context, book.name))]),
                subtitle: LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[200], color: Colors.green, minHeight: 4),
                leading: Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
                onExpansionChanged: (expanded) {
                  setState(() {
                    _expandedBookId = expanded
                        ? book.id
                        : (_expandedBookId == book.id ? null : _expandedBookId);
                  });
                  if (expanded && !_bookChapterStatuses.containsKey(book.id)) {
                    _loadChapterStatuses(book.id, version);
                  }
                },
                children: [
                  _bookChapterStatuses[book.id]?.when(
                    loading: () => const Padding(padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
                    error: (err, stack) => Padding(padding: const EdgeInsets.all(16), child: Text("Erro ao carregar capítulos")),
                    data: (statuses) => Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1,
                        ),
                        itemCount: book.chapters,
                        itemBuilder: (context, index) {
                          final chapterNumber = index + 1;
                          final isRead = statuses[chapterNumber] ?? false;
                          return GestureDetector(
                            onTap: () {
                              setState(() { _selectedBookId = book.id; _selectedBookName = book.name; _selectedChapter = chapterNumber; _isReading = true; _activeHighlightKey = null; _activeSearchTerm = null; _expandedBookId = book.id; });
                              Future.delayed(const Duration(milliseconds: 50), () { if (_pageController.hasClients) _pageController.jumpToPage(index); });
                              bibleRepo?.saveLastPosition(version, book.id, chapterNumber);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isRead ? Colors.green.withOpacity(0.1) : const Color(0xFFF5F5DC),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isRead ? Colors.green : Colors.brown.shade100, width: isRead ? 2 : 1),
                              ),
                              child: Text("$chapterNumber", style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: isRead ? Colors.green[800] : Colors.brown[900])),
                            ),
                          );
                        },
                      ),
                    ),
                  ) ?? const SizedBox.shrink(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFavoritesList(String version) {
    final favoritesAsync = ref.watch(favoriteVersesProvider(version));
    final bibleRepo = ref.read(bibleRepositoryProvider);
    return favoritesAsync.when(
      data: (favorites) {
        if (favorites.isEmpty) return _emptyStudyState("Nenhum versículo favorito.");
        return ListView.builder(
          padding: const EdgeInsets.all(16), itemCount: favorites.length,
          itemBuilder: (context, index) {
            final verse = favorites[index];
            return Card(elevation: 0, color: Colors.white, margin: const EdgeInsets.only(bottom: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)), child: ListTile(title: Text('${verse.bookName} ${verse.chapter}:${verse.verse}', style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: const Color(0xFFD4AF37))), subtitle: Text(verse.text, style: GoogleFonts.lora(fontSize: 15, height: 1.4)), trailing: IconButton(icon: const Icon(Icons.favorite, color: Colors.red), onPressed: () => bibleRepo.toggleFavorite(verse.verseKey)), onTap: () => _navigateToVerse(verse)));
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()), error: (err, stack) => _emptyStudyState("Erro ao carregar favoritos"),
    );
  }

  Widget _buildSearchResults(bibleRepo, String version) { if (_isLoadingSearch) return const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37))); final query = _searchController.text.trim(); if (query.length < 3) return _emptyStudyState("Digite pelo menos 3 caracteres."); if (_searchResults.isEmpty) return _emptyStudyState("Nenhum resultado encontrado."); return ListView.builder(padding: const EdgeInsets.all(16), itemCount: _searchResults.length, itemBuilder: (context, index) { final verse = _searchResults[index]; return Card(margin: const EdgeInsets.only(bottom: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)), child: InkWell(onTap: () => _navigateToVerse(verse, searchTerm: query), child: Padding(padding: const EdgeInsets.all(20), child: Column(children: [Text('${verse.bookName} ${verse.chapter}:${verse.verse}', textAlign: TextAlign.center, style: GoogleFonts.lato(fontWeight: FontWeight.bold, color: const Color(0xFFD4AF37))), const SizedBox(height: 12), _buildHighlightedSearchText(verse.text, query)])))); }); }

  Widget _emptyStudyState(String message) => Center(child: Padding(padding: const EdgeInsets.all(40), child: Text(message, textAlign: TextAlign.center, style: GoogleFonts.lato(color: Colors.grey, fontSize: 14))));

  void _navigateToVerse(BibleVerse verse, {String? searchTerm}) {
    setState(() {
      _selectedBookId = verse.bookId;
      _selectedBookName = verse.bookName;
      _selectedChapter = verse.chapter;
      _isReading = true;
      _isGlobalSearching = false;
      _activeHighlightKey = verse.verseKey;
      _activeSearchTerm = searchTerm;
      _expandedBookId = verse.bookId;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_pageController.hasClients) _pageController.jumpToPage(verse.chapter - 1);
    });
  }

  Widget _buildHighlightedSearchText(String text, String query) { final matches = query.toLowerCase().allMatches(text.toLowerCase()); if (matches.isEmpty) return Text(text, textAlign: TextAlign.center, style: GoogleFonts.lora(fontSize: 16)); final List<TextSpan> spans = []; int lastMatchEnd = 0; for (final match in matches) { if (match.start > lastMatchEnd) spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start))); spans.add(TextSpan(text: text.substring(match.start, match.end), style: const TextStyle(fontWeight: FontWeight.w900, backgroundColor: Color(0xFFFFF176)))); lastMatchEnd = match.end; } if (lastMatchEnd < text.length) spans.add(TextSpan(text: text.substring(lastMatchEnd))); return RichText(textAlign: TextAlign.center, text: TextSpan(style: GoogleFonts.lora(fontSize: 16, color: const Color(0xFF2D2D2D)), children: spans)); }

  Widget _buildImmersiveReader(bibleRepo, String version, Color bgColor, Color textColor, String currentTheme) {
    final book = Book.allBooks.firstWhere((b) => b.id == _selectedBookId);
    return Column(children: [
      _buildTopBar(version, bibleRepo, currentTheme),
      Expanded(child: PageView.builder(controller: _pageController, itemCount: book.chapters, onPageChanged: (page) { 
        setState(() { _selectedChapter = page + 1; _selectedVerseKeys.clear(); _showColorToolbar = false; _activeHighlightKey = null; });
        bibleRepo?.saveLastPosition(version, _selectedBookId!, page + 1); 
      }, itemBuilder: (context, index) => _ChapterReaderView(
        key: ValueKey('${_selectedBookId}_${index + 1}'),
        bibleRepo: bibleRepo, version: version, bookId: _selectedBookId!, chapter: index + 1,
        highlightVerseKey: _activeHighlightKey, selectedVerseKeys: _selectedVerseKeys, searchTerm: _activeSearchTerm, fontSize: _fontSize,
        textColor: textColor,
        onProgressUpdated: () {
          ref.invalidate(allBookProgressesProvider(version));
          _loadChapterStatuses(_selectedBookId!, version);
        },
        onVerseTap: (vKey) { if (_selectedVerseKeys.isNotEmpty) { setState(() { if (_selectedVerseKeys.contains(vKey)) {
          _selectedVerseKeys.remove(vKey);
        } else {
          _selectedVerseKeys.add(vKey);
        } }); } else { setState(() => _activeHighlightKey = null); _showStudySheet(vKey); } },
        onVerseLongPress: (vKey) { HapticFeedback.heavyImpact(); setState(() => _selectedVerseKeys.add(vKey)); },
      ))),
      Container(
        decoration: BoxDecoration(
          color: currentTheme == 'dark' ? const Color(0xFF1E1E1E) : (currentTheme == 'sepia' ? const Color(0xFFF4ECD8) : const Color(0xFFFDFBF7)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))]
        ),
        child: SafeArea(top: false, child: Column(mainAxisSize: MainAxisSize.min, children: [
          _buildBottomVerseTicker(bibleRepo, version, currentTheme),
          _buildBottomChapterTicker(currentTheme),
          const SizedBox(height: 32), 
        ])),
      )
    ]);
  }

  Widget _buildBottomChapterTicker(String currentTheme) {
    final book = Book.allBooks.firstWhere((b) => b.id == _selectedBookId);
    
    Color barColor = const Color(0xFFFDFBF7);
    Color textColor = Colors.black54;
    if (currentTheme == 'dark') { barColor = const Color(0xFF1E1E1E); textColor = Colors.white54; }
    else if (currentTheme == 'sepia') { barColor = const Color(0xFFF4ECD8); textColor = const Color(0xFF5B4636).withOpacity(0.7); }

    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: barColor,
        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: book.chapters,
        itemBuilder: (context, index) {
          final chapter = index + 1;
          bool isSelected = chapter == _selectedChapter;
          return GestureDetector(
            onTap: () {
              if (_pageController.hasClients) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                );
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Cap $chapter",
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                  color: isSelected ? const Color(0xFFD4AF37) : textColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomVerseTicker(bibleRepo, String version, String currentTheme) {
    return FutureBuilder<List<BibleVerse>>(
      future: bibleRepo?.getChapter(version, _selectedBookId!, _selectedChapter),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final verses = snapshot.data!;
        
        Color barColor = const Color(0xFFFDFBF7);
        Color textColor = Colors.black54;
        if (currentTheme == 'dark') { barColor = const Color(0xFF1E1E1E); textColor = Colors.white54; }
        else if (currentTheme == 'sepia') { barColor = const Color(0xFFF4ECD8); textColor = const Color(0xFF5B4636).withOpacity(0.7); }

        return Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            color: barColor,
            border: Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: verses.length,
            itemBuilder: (context, index) {
              final v = verses[index];
              bool isHighlighted = v.verseKey == _activeHighlightKey;
              return GestureDetector(
                onTap: () {
                  setState(() => _activeHighlightKey = v.verseKey);
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "${v.verse}",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: isHighlighted ? FontWeight.w900 : FontWeight.bold,
                      color: isHighlighted ? const Color(0xFFD4AF37) : textColor,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTopBar(String version, bibleRepo, String currentTheme) {
    Color barColor = const Color(0xFFF5F5DC);
    Color iconColor = Colors.brown;
    if (currentTheme == 'dark') { barColor = const Color(0xFF1E1E1E); iconColor = Colors.white70; }
    else if (currentTheme == 'sepia') { barColor = const Color(0xFFE8DFD0); iconColor = const Color(0xFF5B4636); }

    return SafeArea(child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: barColor, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))]), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [IconButton(icon: Icon(Icons.arrow_back_ios_new, size: 20, color: iconColor), onPressed: _exitReadingToBookChooser), Text('$_selectedBookName $_selectedChapter', style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: currentTheme == 'dark' ? Colors.white : const Color(0xFF2D2D2D))), Row(children: [IconButton(icon: Icon(Icons.text_fields, size: 20, color: iconColor), onPressed: () => _showFontSizeSelector()), IconButton(icon: Icon(Icons.palette_outlined, size: 20, color: iconColor), onPressed: () => _showThemeSelector(bibleRepo, currentTheme)), FutureBuilder<List<String>>(future: bibleRepo?.getImportedVersions(), builder: (context, snapshot) { final installedVersions = snapshot.data ?? [version]; return DropdownButton<String>(value: installedVersions.contains(version) ? version : installedVersions.first, underline: const SizedBox(), icon: Icon(Icons.keyboard_arrow_down, size: 18, color: iconColor), dropdownColor: barColor, items: installedVersions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 13, color: currentTheme == 'dark' ? Colors.white70 : Colors.black87)))).toList(), onChanged: (val) { if (val != null) { ref.read(activeBibleVersionProvider.notifier).state = val; bibleRepo?.saveLastPosition(val, _selectedBookId!, _selectedChapter); } }); })])])));
  }

  void _showFontSizeSelector() {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text("Tamanho do Texto", style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _fontSizeOption(16.0, 'Pequeno'),
            _fontSizeOption(18.0, 'Normal'),
            _fontSizeOption(22.0, 'Grande'),
          ]),
          const SizedBox(height: 20),
        ]),
      )
    );
  }

  Widget _fontSizeOption(double size, String label) {
    bool isSelected = _fontSize == size;
    return GestureDetector(
      onTap: () { setState(() => _fontSize = size); Navigator.pop(context); },
      child: Column(children: [
        Container(width: 60, height: 60, decoration: BoxDecoration(color: isSelected ? const Color(0xFFD4AF37).withOpacity(0.1) : Colors.grey[100], borderRadius: BorderRadius.circular(15), border: Border.all(color: isSelected ? const Color(0xFFD4AF37) : Colors.transparent, width: 2)), child: Center(child: Text("Aa", style: TextStyle(fontSize: size * 0.8, fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFFD4AF37) : Colors.black87)))),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.lato(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal))
      ]),
    );
  }

  void _showThemeSelector(bibleRepo, String currentTheme) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text("Tema de Leitura", style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _themeOption('light', 'Claro', Colors.white, Colors.black87, currentTheme == 'light', bibleRepo),
            _themeOption('sepia', 'Sépia', const Color(0xFFF4ECD8), const Color(0xFF5B4636), currentTheme == 'sepia', bibleRepo),
            _themeOption('dark', 'Escuro', const Color(0xFF121212), Colors.white70, currentTheme == 'dark', bibleRepo),
          ]),
          const SizedBox(height: 20),
        ]),
      )
    );
  }

  Widget _themeOption(String id, String label, Color bg, Color text, bool isSelected, bibleRepo) {
    return GestureDetector(
      onTap: () { bibleRepo.updateReadingTheme(id); Navigator.pop(context); },
      child: Column(children: [
        Container(width: 60, height: 60, decoration: BoxDecoration(color: bg, shape: BoxShape.circle, border: Border.all(color: isSelected ? const Color(0xFFD4AF37) : Colors.grey.shade300, width: isSelected ? 3 : 1), boxShadow: [if (isSelected) BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.3), blurRadius: 8)]), child: Center(child: Text("Aa", style: TextStyle(color: text, fontWeight: FontWeight.bold)))),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.lato(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal))
      ]),
    );
  }

  void _shareSelectedVerses(bibleRepo) async {
    final List<BibleVerse> selected = [];
    final List<String> sortedKeys = _selectedVerseKeys.toList()..sort();
    for (var k in sortedKeys) { final v = await bibleRepo.getVerseByKey(k); if (v != null) selected.add(v); }
    if (selected.isEmpty) return;
    String txt = ""; for (var i = 0; i < selected.length; i++) {
      txt += "${i + 1}. ${selected[i].text}\n";
    }
    txt += "(${selected.first.bookName}. ${selected.first.chapter})";
    Share.share(txt); setState(() => _selectedVerseKeys.clear());
  }

  void _favoriteSelectedVerses(bibleRepo) async {
    final List<BibleVerse> verses = [];
    for (var k in _selectedVerseKeys) { final v = await bibleRepo.getVerseByKey(k); if (v != null) verses.add(v); }
    if (verses.length == 1) {
      await bibleRepo.toggleFavorite(verses.first.verseKey);
    } else if (verses.length > 1) {
      final block = FavoriteBlock()..versionId = verses.first.versionId..bookId = verses.first.bookId..bookName = verses.first.bookName..chapter = verses.first.chapter..verses = (verses.map((v) => v.verse).toList()..sort())..text = verses.map((v) => v.text).join(' ')..timestamp = DateTime.now();
      await bibleRepo.saveFavoriteBlock(block); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bloco favoritado!')));
    }
    setState(() => _selectedVerseKeys.clear());
  }

  Widget _colorOption(int? color, IconData? icon, bibleRepo) {
    return GestureDetector(
      onTap: () async { for (var k in _selectedVerseKeys) {
        await bibleRepo.updateHighlightColor(k, color);
      } setState(() { _selectedVerseKeys.clear(); _showColorToolbar = false; }); },
      child: Container(width: 40, height: 40, decoration: BoxDecoration(color: color != null ? Color(color) : Colors.grey[200], shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!)), child: icon != null ? Icon(icon, color: Colors.grey[600], size: 20) : null),
    );
  }

  void _showBookPanorama(BuildContext context, String bookName) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/book_panoramas.json');
      final List<dynamic> data = jsonDecode(jsonString);
      final panorama = data.firstWhere((item) => item['livro'].toString().toLowerCase().trim() == bookName.toLowerCase().trim(), orElse: () => null);
      if (panorama == null || !context.mounted) return;
      showModalBottomSheet(
        context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(color: Color(0xFFFDFBF7), borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
          child: Column(children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(children: [
                const Icon(Icons.auto_stories_outlined, color: Color(0xFFD4AF37), size: 28),
                const SizedBox(width: 12),
                Expanded(child: Text("PANORAMA: ${panorama['livro']}".toUpperCase(), style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFF5D4037))))
              ])
            ),
            const Divider(height: 32),
            Expanded(child: ListView(padding: const EdgeInsets.symmetric(horizontal: 24), children: [
              _infoRow("Autor", panorama['autor']),
              _infoRow("Data Aproximada", panorama['data_aproximada']),
              _infoRow("Significado", panorama['significado_nome']),
              const SizedBox(height: 24),
              _sectionTitle("Propósito Principal"),
              Text(panorama['proposito_principal'], style: GoogleFonts.lora(fontSize: 16, height: 1.6, color: Colors.black87)),
              const SizedBox(height: 24),
              _sectionTitle("Temas Chave"),
              Wrap(spacing: 8, runSpacing: 8, children: (panorama['temas_chave'] as List).map((tema) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), decoration: BoxDecoration(color: const Color(0xFFD4AF37).withOpacity(0.1), borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2))), child: Text(tema, style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF5D4037))))).toList()),
              const SizedBox(height: 24),
              _sectionTitle("Divisões Principais"),
              ...(panorama['divisoes_principais'] as List).map((div) => Padding(padding: const EdgeInsets.only(bottom: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(div['titulo'], style: GoogleFonts.lato(fontWeight: FontWeight.w900, fontSize: 14, color: const Color(0xFF2D2D2D))),
                const SizedBox(height: 8),
                ...(div['topicos'] as List).map((topico) => Padding(padding: const EdgeInsets.only(left: 8, bottom: 4), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Padding(padding: EdgeInsets.only(top: 6), child: Icon(Icons.circle, size: 5, color: Color(0xFFD4AF37))), const SizedBox(width: 8), Expanded(child: Text(topico, style: GoogleFonts.lato(fontSize: 14, color: Colors.black87, height: 1.4)))])))
              ])))
            ])),
            const SizedBox(height: 40)
          ])
        ),
      );
    } catch (e) { debugPrint("Erro ao carregar panorama: $e"); }
  }

  Widget _sectionTitle(String title) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(title.toUpperCase(), style: GoogleFonts.lato(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: const Color(0xFFD4AF37))));
  Widget _infoRow(String label, String value) => Padding(padding: const EdgeInsets.only(bottom: 6), child: RichText(text: TextSpan(style: GoogleFonts.lato(color: Colors.black87, fontSize: 14), children: [TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5D4037))), TextSpan(text: value)])));
}

class _StudyMenuSheet extends ConsumerWidget {
  final String verseKey;
  final Function(BibleVerse) onNavigateToRef;
  const _StudyMenuSheet({required this.verseKey, required this.onNavigateToRef});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 24), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          _MenuOption(icon: Icons.history_edu, title: "Meu Devocional", subtitle: "Escreva o que Deus falou consigo", color: const Color(0xFF5D4037), onTap: () { Navigator.pop(context); _showNoteEditor(context, ref); }),
          const SizedBox(height: 16),
          _MenuOption(icon: Icons.auto_awesome_motion_outlined, title: "Referências Bíblicas", subtitle: "Versículos que explicam este texto", color: const Color(0xFFD4AF37), onTap: () { Navigator.pop(context); _showRefs(context, ref); }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showNoteEditor(BuildContext context, WidgetRef ref) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Fechar',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => NoteEditorDialog(verseKey: verseKey),
      transitionBuilder: (context, anim1, anim2, child) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5 * anim1.value, sigmaY: 5 * anim1.value),
        child: FadeTransition(opacity: anim1, child: ScaleTransition(scale: Tween<double>(begin: 0.9, end: 1.0).animate(anim1), child: child)),
      ),
    );
  }

  void _showRefs(BuildContext context, WidgetRef ref) {
    final activeVersion = ref.read(activeBibleVersionProvider);
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => _RefsSheet(verseKey: verseKey, versionId: activeVersion, onNavigate: onNavigateToRef));
  }
}

class _MenuOption extends StatelessWidget {
  final IconData icon; final String title; final String subtitle; final Color color; final VoidCallback onTap;
  const _MenuOption({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade100), borderRadius: BorderRadius.circular(15)),
        child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 16)), Text(subtitle, style: GoogleFonts.lato(color: Colors.grey, fontSize: 13))])), const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey)]),
      ),
    );
  }
}

class NoteEditorDialog extends ConsumerStatefulWidget {
  final String verseKey;
  final bool readOnly;
  const NoteEditorDialog({super.key, required this.verseKey, this.readOnly = false});
  @override ConsumerState<NoteEditorDialog> createState() => _NoteEditorDialogState();
}

class _NoteEditorDialogState extends ConsumerState<NoteEditorDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = true;
  BibleVerse? _currentVerse;
  DateTime? _noteDate;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final bibleRepo = ref.read(bibleRepositoryProvider);
    _currentVerse = await bibleRepo.getVerseByKey(widget.verseKey);
    
    // Busca a nota diretamente do banco para garantir que ela carregue sempre
    final note = await bibleRepo.getNoteSync(widget.verseKey);
    if (note != null) {
      _titleController.text = note.title ?? "";
      _contentController.text = note.content;
      _noteDate = note.lastModified;
    } else {
      _noteDate = DateTime.now();
    }
    
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _shareNote() {
    if (_currentVerse == null) return;
    final String title = _titleController.text.isNotEmpty ? "*${_titleController.text}*\n" : "";
    final String shareText = "$title"
        "Ref: ${_currentVerse!.bookName} ${_currentVerse!.chapter}:${_currentVerse!.verse}\n"
        "Texto: \"${_currentVerse!.text}\"\n\n"
        "*Meu Devocional:*\n"
        "${_contentController.text}";
    Share.share(shareText);
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final bibleRepo = ref.watch(bibleRepositoryProvider);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, spreadRadius: 5)]),
          child: Column(children: [
            // Cabeçalho do Pop-up
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 16, 12),
              child: Row(children: [
                Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFD4AF37).withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.history_edu, color: Color(0xFFD4AF37))),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.readOnly ? "Visualizar Devocional" : "Meu Devocional", style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF5D4037))), Text("Guardando a revelação", style: GoogleFonts.lato(fontSize: 13, color: Colors.grey))])),
                IconButton(icon: const Icon(Icons.close, color: Colors.grey), onPressed: () => Navigator.pop(context))
              ]),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: widget.readOnly
                  ? Text(
                      _titleController.text.isNotEmpty ? _titleController.text : 'Sem tema',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    )
                  : TextField(
                      controller: _titleController,
                      readOnly: false,
                      textCapitalization: TextCapitalization.sentences,
                      style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A)),
                      decoration: const InputDecoration(
                        hintText: "Tema do devocional...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
            ),
            
            // Texto do Versículo no topo (Referência Completa + Citação)
            if (_currentVerse != null)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BibleScreen(
                        initialBookId: _currentVerse!.bookId,
                        initialChapter: _currentVerse!.chapter,
                        highlightVerseKey: _currentVerse!.verseKey,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDFBF7),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${_currentVerse!.bookName} ${_currentVerse!.chapter}:${_currentVerse!.verse}",
                            style: GoogleFonts.lato(fontWeight: FontWeight.w900, fontSize: 14, color: const Color(0xFFD4AF37), letterSpacing: 0.5),
                          ),
                          const Icon(Icons.open_in_new, size: 14, color: Color(0xFFD4AF37)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "\"${_currentVerse!.text}\"",
                        style: GoogleFonts.lora(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.black87, height: 1.5),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),

            const Divider(height: 24),
            
            // Conteúdo completo do devocional
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : widget.readOnly
                      ? SingleChildScrollView(
                          child: Text(
                            _contentController.text,
                            style: GoogleFonts.lora(
                              fontSize: 17,
                              height: 1.7,
                              color: const Color(0xFF2D2D2D),
                            ),
                          ),
                        )
                      : TextField(
                          controller: _contentController,
                          readOnly: false,
                          textCapitalization: TextCapitalization.sentences,
                          maxLines: null,
                          expands: true,
                          textAlignVertical: TextAlignVertical.top,
                          style: GoogleFonts.lora(fontSize: 17, height: 1.6, color: const Color(0xFF2D2D2D)),
                          decoration: const InputDecoration(
                            hintText: "Escreva aqui todo o conteúdo do seu devocional...",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
              ),
            ),
            // Rodapé com botões de ação
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: const Color(0xFFFDFBF7), borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30))),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        'Criado em ${_formatDate(_noteDate ?? DateTime.now())}',
                        style: GoogleFonts.lato(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _shareNote,
                          icon: const Icon(Icons.share_outlined),
                          label: const Text('PARTILHAR'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF5D4037),
                            side: BorderSide(color: const Color(0xFF5D4037).withOpacity(0.35)),
                            minimumSize: const Size(0, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      if (!widget.readOnly) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await bibleRepo.saveNote(widget.verseKey, _contentController.text, title: _titleController.text);
                              if (mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Devocional guardado com sucesso!")));
                              }
                            },
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text("SALVAR"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5D4037),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              minimumSize: const Size(0, 48),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class _RefsSheet extends ConsumerWidget {
  final String verseKey; final String versionId; final Function(BibleVerse) onNavigate;
  const _RefsSheet({required this.verseKey, required this.versionId, required this.onNavigate});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bibleRepo = ref.watch(bibleRepositoryProvider);
    return DraggableScrollableSheet(
      initialChildSize: 0.6, minChildSize: 0.4, maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        child: Column(children: [
          Container(width: 40, height: 4, margin: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          Padding(padding: const EdgeInsets.only(bottom: 16), child: Text("REFERÊNCIAS RELACIONADAS", style: GoogleFonts.lato(fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.2, color: const Color(0xFFD4AF37)))),
          Expanded(child: FutureBuilder<List<BibleVerse>>(
            future: bibleRepo.getCrossReferences(verseKey, preferredVersionId: versionId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
              final refs = snapshot.data!;
              if (refs.isEmpty) {
                return FutureBuilder<int>(
                  future: bibleRepo.getCrossReferenceCount(),
                  builder: (context, countSnapshot) {
                    if (!countSnapshot.hasData) return const Center(child: CircularProgressIndicator());
                    final count = countSnapshot.data ?? 0;
                    if (count == 0) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            "As referências bíblicas estão a ser preparadas. Tente novamente em instantes.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    return const Center(child: Text("Nenhuma referência encontrada."));
                  },
                );
              }

              return ListView.builder(controller: scrollController, padding: const EdgeInsets.symmetric(horizontal: 20), itemCount: refs.length, itemBuilder: (context, i) {
                final v = refs[i];
                return Card(margin: const EdgeInsets.only(bottom: 10), elevation: 0, color: const Color(0xFFFDFBF7), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade100)), child: ListTile(title: Text("${v.bookName} ${v.chapter}:${v.verse}", style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFFD4AF37))), subtitle: Text(v.text, style: GoogleFonts.lora(fontSize: 15, height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis), onTap: () { Navigator.pop(context); onNavigate(v); }));
              });
            },
          ))
        ]),
      ),
    );
  }
}

class _ChapterReaderView extends ConsumerStatefulWidget {
  final dynamic bibleRepo; final String version; final int bookId; final int chapter; final String? highlightVerseKey; final Set<String> selectedVerseKeys; final String? searchTerm; final double fontSize; final Color textColor; final VoidCallback? onProgressUpdated; final Function(String) onVerseTap; final Function(String) onVerseLongPress;
  const _ChapterReaderView({super.key, required this.bibleRepo, required this.version, required this.bookId, required this.chapter, this.highlightVerseKey, required this.selectedVerseKeys, this.searchTerm, required this.fontSize, required this.textColor, this.onProgressUpdated, required this.onVerseTap, required this.onVerseLongPress});
  @override ConsumerState<_ChapterReaderView> createState() => _ChapterReaderViewState();
}

class _ChapterReaderViewState extends ConsumerState<_ChapterReaderView> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _verseKeys = {};
  String? _lastScrolledKey;

  @override
  void initState() {
    super.initState();
    if (widget.highlightVerseKey != null) {
      _scrollToHighlight(widget.highlightVerseKey);
    }
  }

  @override
  void didUpdateWidget(_ChapterReaderView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.highlightVerseKey != null && widget.highlightVerseKey != _lastScrolledKey) {
      _scrollToHighlight(widget.highlightVerseKey);
    }
  }

  void _scrollToHighlight(String? verseKey) {
    if (verseKey == null) return;
    _lastScrolledKey = verseKey;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Pequeno delay para garantir que o FutureBuilder já renderizou os itens
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted) return;
        final key = _verseKeys[verseKey];
        if (key?.currentContext != null) {
          Scrollable.ensureVisible(
            key!.currentContext!,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            alignment: 0.15,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeSelectionKey = ref.watch(selectedVerseKeyProvider);
    return FutureBuilder<List<BibleVerse>>(
      future: widget.bibleRepo?.getChapter(widget.version, widget.bookId, widget.chapter),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Colors.brown));
        final verses = snapshot.data!; 
        
        // Verificar se a lista está vazia
        if (verses.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Capítulo não encontrado ou versão não importada.\n\nVerificando: ${widget.version} - Livro ${widget.bookId} - Capítulo ${widget.chapter}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }
        
        // Garantir que as chaves existam antes do scroll
        for (var v in verses) {
          _verseKeys.putIfAbsent(v.verseKey, () => GlobalKey());
        }

        // Tentar scroll se houver destaque pendente
        if (widget.highlightVerseKey != null && _lastScrolledKey != widget.highlightVerseKey) {
          _scrollToHighlight(widget.highlightVerseKey);
        }

        return SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 200),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            ...verses.map((v) {
              final isSearchHighlight = v.verseKey == widget.highlightVerseKey;
              final isSelected = widget.selectedVerseKeys.contains(v.verseKey) || v.verseKey == activeSelectionKey;
              
              final vKey = _verseKeys[v.verseKey]!;

              return Consumer(builder: (context, ref, child) {
                final hasNote = ref.watch(verseNoteProvider(v.verseKey)).value != null;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      key: vKey, onTap: () => widget.onVerseTap(v.verseKey), onLongPress: () => widget.onVerseLongPress(v.verseKey),
                      child: AnimatedContainer(duration: const Duration(milliseconds: 300), padding: const EdgeInsets.all(8), margin: const EdgeInsets.only(bottom: 8), decoration: BoxDecoration(color: v.highlightColor != null ? Color(v.highlightColor!).withOpacity(0.3) : (isSelected || isSearchHighlight ? const Color(0xFFFFF176).withOpacity(0.3) : Colors.transparent), borderRadius: BorderRadius.circular(8), border: isSelected ? Border.all(color: const Color(0xFFD4AF37), width: 0.5) : null),
                      child: RichText(textAlign: TextAlign.left, text: TextSpan(style: GoogleFonts.lora(fontSize: widget.fontSize, height: 1.6, color: widget.textColor), children: [WidgetSpan(alignment: PlaceholderAlignment.middle, child: Row(mainAxisSize: MainAxisSize.min, children: [Text("${v.verse} ", style: GoogleFonts.lato(fontSize: 13, fontWeight: FontWeight.bold, color: v.isRead ? Colors.green : (isSelected ? const Color(0xFFD4AF37) : Colors.grey.shade400))), if (v.isFavorite) const Icon(Icons.favorite, size: 12, color: Colors.red), if (hasNote) const Icon(Icons.history_edu, size: 14, color: Color(0xFFD4AF37)), const SizedBox(width: 8)])), _buildVerseContent(v.text, isSearchHighlight ? widget.searchTerm : null)]))),
                    ),
                    Divider(height: 1, thickness: 1.0, color: widget.textColor.withOpacity(0.2)),
                    const SizedBox(height: 8),
                  ],
                );
              });
            }),
            const SizedBox(height: 20), _buildConfirmationButton(widget.bibleRepo, widget.version, widget.chapter),
          ]),
        );
      },
    );
  }
  TextSpan _buildVerseContent(String text, String? query) {
    if (query == null || query.isEmpty) return TextSpan(text: text);
    final matches = query.toLowerCase().allMatches(text.toLowerCase()); if (matches.isEmpty) return TextSpan(text: text);
    final List<TextSpan> spans = []; int lastMatchEnd = 0;
    for (final match in matches) { if (match.start > lastMatchEnd) spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start))); spans.add(TextSpan(text: text.substring(match.start, match.end), style: const TextStyle(fontWeight: FontWeight.w900, backgroundColor: Color(0xFFFFF176)))); lastMatchEnd = match.end; }
    if (lastMatchEnd < text.length) spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    return TextSpan(children: spans);
  }
  Widget _buildConfirmationButton(bibleRepo, String version, int chapter) => FutureBuilder<bool>(key: ValueKey('confirmBtn_$chapter'), future: bibleRepo?.isChapterFullyRead(version, widget.bookId, chapter), builder: (context, snapshot) { final isRead = snapshot.data ?? false; return Center(child: ElevatedButton.icon(onPressed: () async { await bibleRepo?.markChapterAsRead(version, widget.bookId, chapter, !isRead); ref.invalidate(allBookProgressesProvider(version)); widget.onProgressUpdated?.call(); setState(() {}); }, icon: Icon(isRead ? Icons.check_circle : Icons.check_circle_outline, color: Colors.white), label: Text(isRead ? 'CAPÍTULO LIDO' : 'CONFIRMAR LEITURA', style: GoogleFonts.lato(fontWeight: FontWeight.bold, letterSpacing: 1.2)), style: ElevatedButton.styleFrom(backgroundColor: isRead ? Colors.green : const Color(0xFF5D4037), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))))); });
}
