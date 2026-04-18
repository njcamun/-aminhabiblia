import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../logic/providers.dart';
import '../../../data/models/hymn.dart';
import 'hymn_detail_screen.dart';

class HymnalListScreen extends ConsumerStatefulWidget {
  const HymnalListScreen({super.key});

  @override
  ConsumerState<HymnalListScreen> createState() => _HymnalListScreenState();
}

class _HymnalListScreenState extends ConsumerState<HymnalListScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  int _bottomNavIndex = 0; // 0: Hinos, 1: Favoritos
  
  List<Hymn>? _hymns;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHymns();
    });
  }

  Future<void> _loadHymns() async {
    final activeHymnal = ref.read(activeHymnalProvider);
    final hymnRepo = ref.read(hymnRepositoryProvider);

    setState(() => _isLoading = true);

    final results = _searchQuery.isEmpty 
        ? await hymnRepo.getHymns(activeHymnal)
        : await hymnRepo.searchHymns(activeHymnal, _searchQuery);
    
    if (mounted) {
      setState(() {
        if (_bottomNavIndex == 1) {
          _hymns = results.where((h) => h.isFavorite).toList();
        } else {
          _hymns = results;
        }
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeHymnal = ref.watch(activeHymnalProvider);
    final hymnRepo = ref.watch(hymnRepositoryProvider);
    final bool isHarpa = activeHymnal == 'HARPA';
    
    // Cores muito mais suaves mas notáveis para o fundo
    final Color scaffoldBgColor = isHarpa 
        ? const Color(0xFFF0F2F9) // Azul muito suave (pastel)
        : const Color(0xFFFFF5F5); // Vermelho muito suave (pastel)
        
    final Color primaryColor = isHarpa ? const Color(0xFF1A237E) : const Color(0xFFB71C1C);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF2D2D2D)),
          onPressed: () => Navigator.pop(context),
        ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Número, título ou letra...',
                  border: InputBorder.none,
                ),
                style: GoogleFonts.lato(fontSize: 16),
                onChanged: (val) {
                  _searchQuery = val;
                  _loadHymns();
                },
              )
            : Text(
                _bottomNavIndex == 0 ? (isHarpa ? 'Harpa Cristã' : 'Novo Cântico') : 'Meus Favoritos',
                style: GoogleFonts.playfairDisplay(
                  color: const Color(0xFF2D2D2D),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: primaryColor),
            onPressed: () {
              setState(() {
                if (_isSearching) { 
                  _searchController.clear();
                  _searchQuery = '';
                  _loadHymns();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_isSearching && _bottomNavIndex == 0) _buildHymnalSelector(activeHymnal),
          Expanded(
            child: _isLoading && (_hymns == null)
                ? Center(child: CircularProgressIndicator(color: primaryColor))
                : _hymns == null || _hymns!.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        itemCount: _hymns!.length,
                        itemBuilder: (context, index) => _buildHymnCard(_hymns![index], hymnRepo, primaryColor),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        selectedItemColor: primaryColor,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (index) {
          setState(() => _bottomNavIndex = index);
          _loadHymns();
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Hinos'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        ],
      ),
    );
  }

  Widget _buildHymnalSelector(String active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _selectorTab('Harpa Cristã', active == 'HARPA', const Color(0xFF1A237E), () {
            ref.read(activeHymnalProvider.notifier).state = 'HARPA';
            _loadHymns();
          }),
          const SizedBox(width: 12),
          _selectorTab('Novo Cântico', active == 'NOVO_CANTICO', const Color(0xFFB71C1C), () {
            ref.read(activeHymnalProvider.notifier).state = 'NOVO_CANTICO';
            _loadHymns();
          }),
        ],
      ),
    );
  }

  Widget _selectorTab(String label, bool active, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: active ? color : Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(label, style: GoogleFonts.lato(color: active ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildHymnCard(Hymn hino, dynamic hymnRepo, Color color) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), 
        side: BorderSide(color: color.withOpacity(0.1))
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color,
          child: Text('${hino.number}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        title: _buildHighlightedText(hino.title, _searchQuery, GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: _buildHighlightedText(
          '${hino.lyrics.replaceAll('\n', ' ').substring(0, hino.lyrics.length > 50 ? 50 : hino.lyrics.length)}...',
          _searchQuery,
          GoogleFonts.lato(fontSize: 13, color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: Icon(hino.isFavorite ? Icons.favorite : Icons.favorite_border, color: hino.isFavorite ? Colors.red : Colors.grey[400]),
          onPressed: () async {
            await hymnRepo.toggleFavorite(hino.id);
            _loadHymns();
          },
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HymnDetailScreen(hymn: hino))),
      ),
    );
  }

  Widget _buildHighlightedText(String text, String query, TextStyle baseStyle) {
    if (query.isEmpty || !text.toLowerCase().contains(query.toLowerCase())) {
      return Text(text, style: baseStyle);
    }
    final matches = query.toLowerCase().allMatches(text.toLowerCase());
    final List<TextSpan> spans = []; int lastMatchEnd = 0;
    for (final match in matches) {
      if (match.start > lastMatchEnd) spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
      spans.add(TextSpan(text: text.substring(match.start, match.end), style: const TextStyle(backgroundColor: Color(0xFFFFF176), fontWeight: FontWeight.bold)));
      lastMatchEnd = match.end;
    }
    if (lastMatchEnd < text.length) spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    return RichText(text: TextSpan(style: baseStyle.copyWith(color: Colors.black), children: spans));
  }

  Widget _buildEmptyState() {
    return Center(child: Text('Nenhum hino encontrado.', style: GoogleFonts.lato(color: Colors.grey)));
  }
}
