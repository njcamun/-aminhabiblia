import 'dart:math';
import '../data/models/bible_verse.dart';
import '../data/models/book.dart';
import '../data/repositories/bible_repository.dart';

enum QuestionType { fillInTheBlank, identifyReference }

class QuizQuestion {
  final String text;
  final String correctAnswer;
  final List<String> options;
  final QuestionType type;
  final BibleVerse verse;

  QuizQuestion({
    required this.text,
    required this.correctAnswer,
    required this.options,
    required this.type,
    required this.verse,
  });
}

class QuizGeneratorService {
  final BibleRepository repository;
  final Random _random = Random();

  QuizGeneratorService(this.repository);

  Future<List<QuizQuestion>> generateQuiz(String versionId) async {
    final favorites = await repository.getFavoriteVerses(versionId);
    if (favorites.length < 5) return [];

    final List<QuizQuestion> allPossibleQuestions = [];
    
    // Para cada favorito, geramos os dois tipos de perguntas para aumentar o pool
    for (var verse in favorites) {
      // Adiciona pergunta de completar lacuna
      allPossibleQuestions.add(_generateFillInTheBlank(verse, favorites));
      // Adiciona pergunta de identificar referência
      allPossibleQuestions.add(_generateReferenceQuestion(verse, favorites));
    }

    // Embaralha todas as combinações possíveis
    allPossibleQuestions.shuffle(_random);
    
    // Retorna exatamente 30 (ou o máximo possível se o pool for menor que 30)
    return allPossibleQuestions.take(30).toList();
  }

  QuizQuestion _generateFillInTheBlank(BibleVerse verse, List<BibleVerse> favorites) {
    final words = verse.text.split(' ')
        .where((w) => w.length > 5 && !w.contains(RegExp(r'[0-9]')))
        .toList();
    
    final targetWord = words.isEmpty ? verse.text.split(' ').last : words[_random.nextInt(words.length)];
    final cleanTarget = targetWord.replaceAll(RegExp(r'[^\wÀ-ú]'), '');
    final questionText = verse.text.replaceFirst(targetWord, '____');

    final distractors = favorites
        .where((v) => v.id != verse.id)
        .expand((v) => v.text.split(' '))
        .map((w) => w.replaceAll(RegExp(r'[^\wÀ-ú]'), ''))
        .where((w) => w.length > 4 && w.toLowerCase() != cleanTarget.toLowerCase())
        .toSet()
        .toList();
    
    distractors.shuffle(_random);
    final options = [cleanTarget, ...distractors.take(3)]..shuffle(_random);

    return QuizQuestion(
      text: questionText,
      correctAnswer: cleanTarget,
      options: options,
      type: QuestionType.fillInTheBlank,
      verse: verse,
    );
  }

  QuizQuestion _generateReferenceQuestion(BibleVerse verse, List<BibleVerse> favorites) {
    final correctRef = '${verse.bookName} ${verse.chapter}:${verse.verse}';
    final List<String> options = [correctRef];

    final otherRefs = favorites
        .where((v) => v.id != verse.id)
        .map((v) => '${v.bookName} ${v.chapter}:${v.verse}')
        .toSet()
        .toList();

    if (otherRefs.length >= 3) {
      otherRefs.shuffle(_random);
      options.addAll(otherRefs.take(3));
    } else {
      while (options.length < 4) {
        final randomBook = Book.allBooks[_random.nextInt(Book.allBooks.length)];
        final randomChapter = _random.nextInt(randomBook.chapters) + 1;
        final randomRef = '${randomBook.name} $randomChapter:${_random.nextInt(20) + 1}';
        if (!options.contains(randomRef)) {
          options.add(randomRef);
        }
      }
    }

    options.shuffle(_random);

    return QuizQuestion(
      text: '"${verse.text}"',
      correctAnswer: correctRef,
      options: options,
      type: QuestionType.identifyReference,
      verse: verse,
    );
  }
}
