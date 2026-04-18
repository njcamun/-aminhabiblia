import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import '../../../logic/providers.dart';
import '../../../logic/quiz_generator_service.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  List<QuizQuestion> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  bool _isLoading = true;
  bool _answered = false;
  String? _selectedOption;
  int _timerValue = 20;
  Timer? _timer;
  bool _quizFinished = false;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playBackgroundMusic();
    _startQuiz();
  }

  Future<void> _playBackgroundMusic() async {
    try {
      await _audioPlayer.setAsset('assets/quiz/quiz.mp3');
      await _audioPlayer.setLoopMode(LoopMode.one);
      await _audioPlayer.play();
    } catch (e) {
      debugPrint("Erro ao carregar áudio do quiz: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startQuiz() async {
    final generator = ref.read(quizGeneratorServiceProvider);
    final version = ref.read(activeBibleVersionProvider);
    if (generator == null) return;

    final generated = await generator.generateQuiz(version);

    setState(() {
      _questions = generated;
      _isLoading = false;
      if (generated.isNotEmpty) _startTimer();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timerValue = 20;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerValue > 0) {
        setState(() => _timerValue--);
      } else {
        _handleAnswer(null);
      }
    });
  }

  void _handleAnswer(String? option) {
    if (_answered) return;
    _timer?.cancel();

    final correct = option == _questions[_currentIndex].correctAnswer;
    
    setState(() {
      _answered = true;
      _selectedOption = option;
      if (correct) {
        _score++;
        _streak++;
        _maxStreak = max(_maxStreak, _streak);
      } else {
        _streak = 0;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
          _answered = false;
          _selectedOption = null;
          _startTimer();
        });
      } else {
        setState(() => _quizFinished = true);
        _audioPlayer.stop(); // Para a música ao finalizar
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFDFBF7),
        body: Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37))),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        backgroundColor: const Color(0xFFFDFBF7),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite_border, size: 80, color: Color(0xFFD4AF37)),
                const SizedBox(height: 24),
                Text(
                  'Quiz Desbloqueável',
                  style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  'Favorita pelo menos 5 versículos para desbloquear o teu quiz personalizado!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D4037),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Voltar para Favoritos', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_quizFinished) return _buildSummary();

    final currentQuestion = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: Column(
          children: [
            Text('Quiz Bíblico', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
            Text('${_currentIndex + 1} de ${_questions.length}', style: GoogleFonts.lato(fontSize: 12, color: Colors.grey)),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions.length,
            backgroundColor: Colors.grey[200],
            color: const Color(0xFFD4AF37),
            minHeight: 6,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildTimerWidget(),
                  const SizedBox(height: 32),
                  _buildQuestionCard(currentQuestion),
                  const SizedBox(height: 32),
                  ...currentQuestion.options.map((opt) => _buildOptionButton(opt, currentQuestion)),
                  if (_streak > 1) ...[
                    const SizedBox(height: 24),
                    _buildStreakBadge(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(
            value: _timerValue / 20,
            color: _timerValue <= 5 ? Colors.red : const Color(0xFFD4AF37),
            backgroundColor: Colors.grey[200],
            strokeWidth: 6,
          ),
        ),
        Text('$_timerValue', style: GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }

  Widget _buildQuestionCard(QuizQuestion question) {
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
            question.type == QuestionType.fillInTheBlank ? 'Complete o versículo:' : 'De onde é este versículo?',
            style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFD4AF37), letterSpacing: 1.2),
          ),
          const SizedBox(height: 20),
          Text(
            question.text,
            textAlign: TextAlign.center,
            style: GoogleFonts.lora(fontSize: 18, height: 1.5, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionButton(String option, QuizQuestion question) {
    bool isCorrect = option == question.correctAnswer;
    bool isSelected = option == _selectedOption;
    
    Color bgColor = Colors.white;
    Color borderColor = const Color(0xFFE8E2D8);
    Color textColor = const Color(0xFF2D2D2D);

    if (_answered) {
      if (isCorrect) {
        bgColor = Colors.green[50]!;
        borderColor = Colors.green;
        textColor = Colors.green[800]!;
      } else if (isSelected) {
        bgColor = Colors.red[50]!;
        borderColor = Colors.red;
        textColor = Colors.red[800]!;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _handleAnswer(option),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Row(
            children: [
              Expanded(child: Text(option, textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold, color: textColor))),
              if (_answered && isCorrect) const Icon(Icons.check_circle, color: Colors.green),
              if (_answered && isSelected && !isCorrect) const Icon(Icons.cancel, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF5D4037), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_fire_department, color: Color(0xFFD4AF37), size: 20),
          const SizedBox(width: 8),
          Text('SEQUÊNCIA: $_streak', style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSummary() {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events_outlined, size: 100, color: Color(0xFFD4AF37)),
              const SizedBox(height: 24),
              Text('Quiz Finalizado!', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)]),
                child: Column(
                  children: [
                    _buildSummaryRow('Acertos', '$_score / ${_questions.length}'),
                    const Divider(height: 32),
                    _buildSummaryRow('Melhor Sequência', '$_maxStreak'),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5D4037), minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text('Voltar ao Início', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[600])),
        Text(value, style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF5D4037))),
      ],
    );
  }
}
