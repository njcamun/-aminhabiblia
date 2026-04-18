import 'dart:convert';
import '../models/hymn.dart';

class HymnJsonParser {
  static List<Hymn> parseJson(String jsonString, String defaultCategory) {
    final Map<String, dynamic> decoded = jsonDecode(jsonString);
    final List<Hymn> hymns = [];

    decoded.forEach((key, value) {
      // Ignora metadados (como a chave "-1")
      if (key == "-1") return;

      // Extrai o número do hino (trata casos como "400A")
      final int number = int.tryParse(key.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      final String fullTitle = value['hino'] ?? 'Sem Título';
      
      // Captura a URL do áudio se disponível
      final String? audioUrl = value['audio_url'] ?? value['audioUrl'];
      
      // Limpa o título (remove o número inicial se existir, ex: "1 - Doxologia")
      final String title = fullTitle.contains(' - ') 
          ? fullTitle.split(' - ').sublist(1).join(' - ') 
          : fullTitle;

      Map<String, dynamic> versesMap = {};
      if (value['verses'] is Map) {
        versesMap = Map<String, dynamic>.from(value['verses']);
      }

      // 1. Extrair o Coro (agora pode estar dentro do mapa 'verses' ou no nível superior)
      String rawCoro = value['coro']?.toString() ?? "";
      if (rawCoro.isEmpty && versesMap.containsKey('coro')) {
        rawCoro = versesMap['coro'].toString();
        versesMap.remove('coro'); // Remove para evitar erro na ordenação numérica das estrofes
      }

      // Adicionamos o marcador [CORO] para a UI aplicar o negrito
      final String cleanCoro = rawCoro.isNotEmpty 
          ? "[CORO]\n${rawCoro.replaceAll('<br>', '\n').trim()}" 
          : "";

      String lyrics = "";
      if (versesMap.isNotEmpty) {
        // 2. Filtrar e ordenar apenas as chaves numéricas das estrofes
        final numericKeys = versesMap.keys
            .where((k) => k.contains(RegExp(r'[0-9]')))
            .toList();

        numericKeys.sort((a, b) {
          int numA = int.tryParse(a.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          int numB = int.tryParse(b.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
          return numA.compareTo(numB);
        });
        
        List<String> parts = [];
        bool coroAdded = false;

        for (String k in numericKeys) {
          parts.add(versesMap[k].toString().replaceAll('<br>', '\n').trim());
          
          // 3. Regra: Inserir o coro sempre após a estrofe 1
          if ((k == "1" || k == "01") && cleanCoro.isNotEmpty) {
            parts.add(cleanCoro);
            coroAdded = true;
          }
        }

        // Caso o hino não tenha a estrofe "1" mas tenha coro, adicionamos no início
        if (cleanCoro.isNotEmpty && !coroAdded) {
          parts.insert(0, cleanCoro);
        }
        
        lyrics = parts.join('\n\n');
      } else if (cleanCoro.isNotEmpty) {
        lyrics = cleanCoro;
      }

      hymns.add(Hymn()
        ..category = defaultCategory
        ..number = number
        ..title = title
        ..lyrics = lyrics
        ..audioUrl = audioUrl);
    });

    return hymns;
  }
}
