import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:string_similarity/string_similarity.dart';
import '../logic/providers.dart';
import '../data/models/bible_verse.dart';

class MemorizeScreen extends ConsumerStatefulWidget {
  const MemorizeScreen({super.key});

  @override
  ConsumerState<MemorizeScreen> createState() => _MemorizeScreenState();
}

class _MemorizeScreenState extends ConsumerState<MemorizeScreen> {
  final Random _random = Random();
  final TextEditingController _textController = TextEditingController();
  
  BibleVerse? _currentVerse;
  bool _isTextToRef = true; // true: Texto -> Ref, false: Ref -> Texto
  bool _answered = false;
  bool _isCorrect = false;
  List<String> _options = [];
  String? _selectedOption;
  double _similarity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadNextVerse());
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadNextVerse() async {
    final repo = ref.read(bibleRepositoryProvider);
    final version = ref.read(activeBibleVersionProvider);
    if (repo == null) return;

    final favorites = await repo.getFavoriteVerses(version);
    if (favorites.length < 5) {
      if (mounted) setState(() => _currentVerse = null);
      return;
    }

    final verse = favorites[_random.nextInt(favorites.length)];
    final type = _random.nextBool(); // Sorteia o tipo de desafio

    List<String> options = [];
    if (type) {
      // Gerar opções para Referência
      options.add("${verse.bookName} ${verse.chapter}:${verse.verse}");
      while (options.length < 4) {
        final randomV = favorites[_random.nextInt(favorites.length)];
        final refStr = "${randomV.bookName} ${randomV.chapter}:${randomV.verse}";
        if (!options.contains(refStr)) options.add(refStr);
      }
      options.shuffle();
    }

    setState(() {
      _currentVerse = verse;
      _isTextToRef = type;
      _options = options;
      _answered = false;
      _selectedOption = null;
      _textController.clear();
      _similarity = 0.0;
    });
  }

  void _checkAnswer() {
    if (_currentVerse == null) return;

    if (_isTextToRef) {
      setState(() {
        _answered = true;
        _isCorrect = _selectedOption == "${_currentVerse!.bookName} ${_currentVerse!.chapter}:${_currentVerse!.verse}";
      });
    } else {
      final input = _textController.text.trim().toLowerCase();
      final target = _currentVerse!.text.trim().toLowerCase();
      final score = input.similarityTo(target);
      setState(() {
        _similarity = score;
        _answered = true;
        _isCorrect = score >= 0.8; // 80% de similaridade
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentVerse == null) return _buildLockedState();

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: Text('Memorização', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildChallengeCard(),
            const SizedBox(height: 32),
            if (_isTextToRef) _buildOptions() else _buildTextInput(),
            const SizedBox(height: 32),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Text(
            _isTextToRef ? "QUAL A REFERÊNCIA?" : "QUAL O TEXTO?",
            style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFD4AF37), letterSpacing: 1.5),
          ),
          const SizedBox(height: 20),
          Text(
            _isTextToRef ? "\"${_currentVerse!.text}\"" : "${_currentVerse!.bookName} ${_currentVerse!.chapter}:${_currentVerse!.verse}",
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(fontSize: _isTextToRef ? 18 : 26, fontStyle: _isTextToRef ? FontStyle.italic : FontStyle.normal, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    return Column(
      children: _options.map((opt) {
        final isCorrect = opt == "${_currentVerse!.bookName} ${_currentVerse!.chapter}:${_currentVerse!.verse}";
        final isSelected = opt == _selectedOption;
        
        Color color = const Color(0xFFE8E2D8);
        if (_answered) {
          if (isCorrect) color = Colors.green;
          else if (isSelected) color = Colors.red;
        } else if (isSelected) {
          color = const Color(0xFFD4AF37);
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: _answered ? null : () => setState(() => _selectedOption = opt),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 2),
                borderRadius: BorderRadius.circular(16),
                color: isSelected && !_answered ? color.withOpacity(0.1) : Colors.transparent,
              ),
              child: Text(opt, textAlign: TextAlign.center, style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextInput() {
    return Column(
      children: [
        TextField(
          controller: _textController,
          maxLines: 5,
          enabled: !_answered,
          style: GoogleFonts.lora(fontSize: 16),
          decoration: InputDecoration(
            hintText: "Escreva o versículo aqui...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2)),
          ),
        ),
        if (_answered) ...[
          const SizedBox(height: 16),
          Text("Precisão: ${(_similarity * 100).toInt()}%", style: TextStyle(color: _isCorrect ? Colors.green : Colors.orange, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Text("Correto: ${_currentVerse!.text}", style: GoogleFonts.lora(fontSize: 14, color: Colors.green[900])),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton() {
    return ElevatedButton(
      onPressed: _answered ? _loadNextVerse : ((_isTextToRef && _selectedOption == null) ? null : _checkAnswer),
      style: ElevatedButton.styleFrom(
        backgroundColor: _answered ? const Color(0xFF5D4037) : const Color(0xFFD4AF37),
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Text(
        _answered ? "PRÓXIMO DESAFIO" : "VERIFICAR",
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _buildLockedState() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Color(0xFFD4AF37)),
              const SizedBox(height: 24),
              Text('Memorização Bloqueada', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(
                'Favorita pelo menos 5 versículos na aba Bíblia para começar a treinar sua memória!',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("VOLTAR")),
            ],
          ),
        ),
      ),
    );
  }
}
