// lib/data/bible_data.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math';
// Import para debugPrint

// Mapeamento de abreviações para nomes completos dos livros da Bíblia
// É CRUCIAL QUE VOCÊ COMPLETE ESTE MAPA COM TODOS OS 66 LIVROS DA BÍBLIA ACF.

const Map<String, String> bookAbbreviationToFullName = {
  "Gn": "Gênesis", "Êx": "Êxodo", "Lv": "Levítico", "Nm": "Números", "Dt": "Deuteronômio",
  "Js": "Josué", "Jz": "Juízes", "Rt": "Rute", "1Sm": "1 Samuel", "2Sm": "2 Samuel",
  "1Rs": "1 Reis", "2Rs": "2 Reis", "1Cr": "1 Crônicas", "2Cr": "2 Crônicas",
  "Ed": "Esdras", "Ne": "Neemias", "Et": "Ester", "Jó": "Jó", "Sl": "Salmos",
  "Pv": "Provérbios", "Ec": "Eclesiastes", "Ct": "Cântico dos Cânticos", "Is": "Isaías",
  "Jr": "Jeremias", "Lm": "Lamentações", "Ez": "Ezequiel", "Dn": "Daniel", "Os": "Oséias",
  "Jl": "Joel", "Am": "Amós", "Ob": "Obadias", "Jn": "Jonas", "Mq": "Miquéias",
  "Na": "Naum", "Hc": "Habacuque", "Sf": "Sofonias", "Ag": "Ageu", "Zc": "Zacarias",
  "Ml": "Malaquias", "Mt": "Mateus", "Mc": "Marcos", "Lc": "Lucas", "Jo": "João",
  "At": "Atos dos Apóstolos", "Rm": "Romanos", "1Co": "1 Coríntios", "2Co": "2 Coríntios",
  "Gl": "Gálatas", "Ef": "Efésios", "Fp": "Filipenses", "Cl": "Colossenses",
  "1Ts": "1 Tessalonicenses", "2Ts": "2 Tessalonicenses", "1Tm": "1 Timóteo",
  "2Tm": "2 Timóteo", "Tt": "Tito", "Fm": "Filemon", "Hb": "Hebreus", "Tg": "Tiago",
  "1Pe": "1 Pedro", "2Pe": "2 Pedro", "1Jo": "1 João", "2Jo": "2 João",
  "3Jo": "3 João", "Jd": "Judas", "Ap": "Apocalipse",
};

// NOVO: Mapeamento de categorias de livros da Bíblia
const Map<String, String> bookCategories = {
  "Gn": "Pentateuco", "Êx": "Pentateuco", "Lv": "Pentateuco", "Nm": "Pentateuco", "Dt": "Pentateuco",
  "Js": "Históricos", "Jz": "Históricos", "Rt": "Históricos", "1Sm": "Históricos", "2Sm": "Históricos",
  "1Rs": "Históricos", "2Rs": "Históricos", "1Cr": "Históricos", "2Cr": "Históricos", "Ed": "Históricos",
  "Ne": "Históricos", "Et": "Históricos",
  "Jó": "Poéticos", "Sl": "Poéticos", "Pv": "Poéticos", "Ec": "Poéticos", "Ct": "Poéticos",
  "Is": "Profetas Maiores", "Jr": "Profetas Maiores", "Lm": "Profetas Maiores", "Ez": "Profetas Maiores", "Dn": "Profetas Maiores",
  "Os": "Profetas Menores", "Jl": "Profetas Menores", "Am": "Profetas Menores", "Ob": "Profetas Menores", "Jn": "Profetas Menores",
  "Mq": "Profetas Menores", "Na": "Profetas Menores", "Hc": "Profetas Menores", "Sf": "Profetas Menores", "Ag": "Profetas Menores",
  "Zc": "Profetas Menores", "Ml": "Profetas Menores",
  "Mt": "Evangelhos", "Mc": "Evangelhos", "Lc": "Evangelhos", "Jo": "Evangelhos",
  "At": "História da Igreja Primitiva",
  "Rm": "Cartas Paulinas", "1Co": "Cartas Paulinas", "2Co": "Cartas Paulinas", "Gl": "Cartas Paulinas", "Ef": "Cartas Paulinas",
  "Fp": "Cartas Paulinas", "Cl": "Cartas Paulinas", "1Ts": "Cartas Paulinas", "2Ts": "Cartas Paulinas",
  "1Tm": "Cartas Pastorais", "2Tm": "Cartas Pastorais", "Tt": "Cartas Pastorais", "Fm": "Cartas Paulinas",
  "Hb": "Cartas Gerais", "Tg": "Cartas Gerais", "1Pe": "Cartas Gerais", "2Pe": "Cartas Gerais",
  "1Jo": "Cartas Gerais", "2Jo": "Cartas Gerais", "3Jo": "Cartas Gerais", "Jd": "Cartas Gerais",
  "Ap": "Profecia/Apocalíptico",
};

// NOVO: Cores para cada categoria de livro
const Map<String, Color> categoryColors = {
  "Pentateuco": Colors.blue,
  "Históricos": Colors.green,
  "Poéticos": Colors.purple,
  "Profetas Maiores": Colors.orange,
  "Profetas Menores": Colors.red,
  "Evangelhos": Colors.teal,
  "História da Igreja Primitiva": Colors.indigo,
  "Cartas Paulinas": Colors.brown,
  "Cartas Pastorais": Colors.deepOrange, // Uma tonalidade diferente para pastorais
  "Cartas Gerais": Colors.cyan,
  "Profecia/Apocalíptico": Colors.deepPurple,
};

const List<String> canonicalBookOrderAbbrevs = [
  "Gn", "Êx", "Lv", "Nm", "Dt", "Js", "Jz", "Rt", "1Sm", "2Sm",
  "1Rs", "2Rs", "1Cr", "2Cr", "Ed", "Ne", "Et", "Jó", "Sl",
  "Pv", "Ec", "Ct", "Is", "Jr", "Lm", "Ez", "Dn", "Os",
  "Jl", "Am", "Ob", "Jn", "Mq", "Na", "Hc", "Sf", "Ag", "Zc",
  "Ml", "Mt", "Mc", "Lc", "Jo", "At", "Rm", "1Co", "2Co",
  "Gl", "Ef", "Fp", "Cl", "1Ts", "2Ts", "2Ts", "1Tm", "2Tm", // 2Ts e 2Tm estavam duplicados, ajustado aqui.
  "Tt", "Fm", "Hb", "Tg", "1Pe", "2Pe", "1Jo", "2Jo",
  "3Jo", "Jd", "Ap"
];

// Opcional: Criar um mapa de índice para busca rápida
final Map<String, int> bookOrderMap = {
  for (var i = 0; i < canonicalBookOrderAbbrevs.length; i++)
    canonicalBookOrderAbbrevs[i]: i
};


class Book {
  final String abbrev;
  final String fullName;
  final String category; // NOVO: Categoria do livro
  final List<List<String>> chapters;

  Book({required this.abbrev, required this.fullName, required this.category, required this.chapters});

  factory Book.fromJson(Map<String, dynamic> json) {
    String abbrev = json['abbrev'];
    String fullName = bookAbbreviationToFullName[abbrev] ?? abbrev;
    String category = bookCategories[abbrev] ?? "Outros"; // <--- Atribui categoria aqui

    List<List<String>> bookChapters = [];
    if (json['chapters'] is List) {
      for (var chapterJson in json['chapters']) {
        if (chapterJson is List) {
          List<String> chapterVerses = [];
          for (var verseJson in chapterJson) {
            chapterVerses.add(verseJson.toString());
          }
          bookChapters.add(chapterVerses);
        }
      }
    }

    return Book(
      abbrev: abbrev,
      fullName: fullName,
      category: category, // <--- Passa a categoria
      chapters: bookChapters,
    );
  }

  int get numberOfChapters => chapters.length;
}

List<Book> bibleBooks = [];

// Função para carregar os dados da Bíblia do arquivo JSON
Future<void> loadBibleData() async {
  try {
    // Carrega o conteúdo do arquivo JSON como uma string
    String jsonString = await rootBundle.loadString('assets/acf_bible.json');
    // Decodifica a string JSON em uma lista dinâmica
    List<dynamic> jsonList = json.decode(jsonString);

    // Mapeia a lista JSON para uma lista de objetos Book
    bibleBooks = jsonList.map((json) => Book.fromJson(json)).toList();
    debugPrint('Dados da Bíblia carregados com sucesso! Total de livros: ${bibleBooks.length}'); // Usar debugPrint
  } catch (e) {
    debugPrint('Erro ao carregar dados da Bíblia: $e'); // Usar debugPrint
  }
}

// Adaptação da função para obter versículos para usar os dados carregados
List<String> getChapterVerses(String bookAbbrev, int chapterNumber) {
  // Encontra o livro pela abreviação
  final book = bibleBooks.firstWhere(
        (b) => b.abbrev == bookAbbrev,
    orElse: () => throw Exception('Livro não encontrado: $bookAbbrev'),
  );

  // Verifica se o capítulo existe e retorna os versículos
  if (chapterNumber > 0 && chapterNumber <= book.chapters.length) {
    return book.chapters[chapterNumber - 1]; // -1 porque a lista é baseada em 0
  } else {
    throw Exception('Capítulo $chapterNumber não encontrado em ${book.fullName}');
  }
}

// Função para obter um livro pelo nome completo (útil para navegação)
Book getBookByFullName(String fullName) {
  return bibleBooks.firstWhere(
        (book) => book.fullName == fullName,
    orElse: () => throw Exception('Livro não encontrado: $fullName'),
  );
}

// Função para obter um livro pela abreviação (útil se você passar abreviação entre telas)
Book getBookByAbbrev(String abbrev) {
  return bibleBooks.firstWhere(
        (book) => book.abbrev == abbrev,
    orElse: () => throw Exception('Livro não encontrado: $abbrev'),
  );
}


final Random _random = Random();

String getRandomVerse() {
  if (bibleBooks.isEmpty) {
    debugPrint('Erro: Dados da Bíblia não carregados ao tentar obter versículo aleatório.'); // Usar debugPrint
    return 'João 3:16 - Porque Deus amou o mundo de tal maneira que deu o seu Filho unigénito, para que todo aquele que nele crê não pereça, mas tenha a vida eterna.'; // Fallback
  }

  // Seleciona um livro aleatório
  final randomBookIndex = _random.nextInt(bibleBooks.length);
  final Book randomBook = bibleBooks[randomBookIndex];

  // Garante que o livro tenha capítulos para evitar RangeError.
  // E que o capítulo tenha versículos.
  int randomChapterIndex;
  List<String> chapterVerses;
  do {
    // Garante que o índice não exceda o tamanho da lista e que o livro tenha capítulos
    randomChapterIndex = _random.nextInt(randomBook.chapters.length);
    chapterVerses = randomBook.chapters[randomChapterIndex];
  } while (chapterVerses.isEmpty); // Repete se o capítulo estiver vazio

  int randomChapterNumber = randomChapterIndex + 1; // Ajusta para número de capítulo (base 1)

  // Garante que o versículo não seja vazio
  int randomVerseIndex;
  do {
    randomVerseIndex = _random.nextInt(chapterVerses.length);
  } while (chapterVerses[randomVerseIndex].isEmpty); // Repete se o versículo estiver vazio

  int randomVerseNumber = randomVerseIndex + 1; // Ajusta para número de versículo (base 1)

  String verseText = chapterVerses[randomVerseIndex];
  String verseReference = '${randomBook.fullName} $randomChapterNumber:$randomVerseNumber';

  String formattedVerseText = verseText.startsWith('$randomVerseNumber ')
      ? verseText.substring('$randomVerseNumber '.length)
      : verseText;

  return '$verseReference - $formattedVerseText';
}