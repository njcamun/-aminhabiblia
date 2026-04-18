import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/hymn.dart';
import '../../../logic/providers.dart';

class HymnDetailScreen extends ConsumerStatefulWidget {
  final Hymn hymn;
  const HymnDetailScreen({super.key, required this.hymn});

  @override
  ConsumerState<HymnDetailScreen> createState() => _HymnDetailScreenState();
}

class _HymnDetailScreenState extends ConsumerState<HymnDetailScreen> {
  static const List<double> _fontSizes = [18.0, 22.0, 26.0];
  int _fontSizeIndex = 1;

  double get _fontSize => _fontSizes[_fontSizeIndex];

  void _cycleFontSize() {
    setState(() {
      _fontSizeIndex = (_fontSizeIndex + 1) % _fontSizes.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeHymnal = ref.watch(activeHymnalProvider);
    final bool isHarpa = activeHymnal == 'HARPA';
    final Color primaryColor =
        isHarpa ? const Color(0xFF1A237E) : const Color(0xFFB71C1C);

    return Container(
      decoration: BoxDecoration(
        color: isHarpa ? const Color(0xFFF0F2F9) : const Color(0xFFFFF5F5),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black87, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Hino ${widget.hymn.number}',
            style: GoogleFonts.playfairDisplay(
                color: Colors.black87, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: Icon(
                  widget.hymn.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: widget.hymn.isFavorite ? Colors.red : Colors.grey),
              onPressed: () async {
                final hymnRepo = ref.read(hymnRepositoryProvider);
                await hymnRepo.toggleFavorite(widget.hymn.id);
                setState(() {
                  widget.hymn.isFavorite = !widget.hymn.isFavorite;
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.format_size, color: Colors.black87),
              onPressed: _cycleFontSize,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.95,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.65),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(alpha: 0.10),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 28,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            widget.hymn.title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 40),
                          ..._buildLyricsWidgets(const Color(0xFF1A1A1A)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLyricsWidgets(Color textColor) {
    // Divide a letra pelos marcadores [n] e [CORO], ocultando a numeração na UI.
    final List<_LyricBlock> parts = _parseLyricBlocks(widget.hymn.lyrics);
    final List<Widget> widgets = [];

    for (int i = 0; i < parts.length; i++) {
      final block = parts[i];
      final text = block.content.trim();
      if (text.isEmpty) continue;

      final String displayContent = _sanitizeLyricsForDisplay(text);

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 32),
          child: Text(
            displayContent,
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(
              fontSize: _fontSize,
              height: 1.7,
              // O Coro fica em Negrito
              fontWeight: block.isChorus ? FontWeight.bold : FontWeight.normal,
              // Itálico opcional para o coro para destacar ainda mais
              fontStyle: block.isChorus ? FontStyle.italic : FontStyle.normal,
              color: textColor,
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  List<_LyricBlock> _parseLyricBlocks(String lyrics) {
    final normalized = lyrics.replaceAll('\r\n', '\n');
    final lines = normalized.split('\n');
    final blocks = <_LyricBlock>[];

    final markerRegex = RegExp(r'^\[(CORO|\d+)\]$', caseSensitive: false);
    final currentLines = <String>[];
    bool currentIsChorus = false;

    void flushCurrent() {
      final content = currentLines.join('\n').trim();
      if (content.isNotEmpty) {
        blocks.add(_LyricBlock(content: content, isChorus: currentIsChorus));
      }
      currentLines.clear();
    }

    for (final rawLine in lines) {
      final line = rawLine.trimRight();
      final marker = markerRegex.firstMatch(line.trim());
      if (marker != null) {
        flushCurrent();
        currentIsChorus = marker.group(1)!.toUpperCase() == 'CORO';
        continue;
      }

      currentLines.add(line);
    }

    flushCurrent();

    // Fallback para letras sem marcador explícito.
    if (blocks.isEmpty) {
      final fallback = _sanitizeLyricsForDisplay(normalized).trim();
      if (fallback.isNotEmpty) {
        blocks.add(_LyricBlock(content: fallback, isChorus: false));
      }
    }

    return blocks;
  }

  String _sanitizeLyricsForDisplay(String content) {
    final lines = content.split('\n');
    final cleanedLines = <String>[];

    for (final rawLine in lines) {
      String line = rawLine;

      // Remove tokens numéricos soltos usados como notas (ex.: "figuras 2 dessa glória").
      line =
          line.replaceAll(RegExp(r'(?<=\S)\s+\d{1,2}(?=(\s|[.,;:!?]|$))'), '');
      line = line.replaceAll(RegExp(r'\s{2,}'), ' ').trimRight();

      // Ignora linhas que são apenas números.
      if (line.trim().isEmpty || RegExp(r'^\d+$').hasMatch(line.trim())) {
        continue;
      }

      cleanedLines.add(line);
    }

    return cleanedLines.join('\n');
  }
}

class _LyricBlock {
  final String content;
  final bool isChorus;

  const _LyricBlock({required this.content, required this.isChorus});
}
