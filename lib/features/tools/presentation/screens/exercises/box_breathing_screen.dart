import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nafas/core/theme/app_theme.dart';
import 'package:nafas/core/theme/theme_provider.dart';

class BoxBreathingScreen extends ConsumerStatefulWidget {
  const BoxBreathingScreen({super.key});

  @override
  ConsumerState<BoxBreathingScreen> createState() => _BoxBreathingScreenState();
}

class _BoxBreathingScreenState extends ConsumerState<BoxBreathingScreen> {
  bool _isActive = false;
  int _currentPhase = 0; // 0: Inhale, 1: Hold, 2: Exhale, 3: Hold
  int _countdown = 4;
  Timer? _timer;
  int _completedCycles = 0;

  final List<String> _phases = ['Inhale', 'Hold', 'Exhale', 'Hold'];
  final List<IconData> _phaseIcons = [
    Icons.arrow_upward,
    Icons.pause,
    Icons.arrow_downward,
    Icons.pause,
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startExercise() {
    setState(() {
      _isActive = true;
      _currentPhase = 0;
      _countdown = 4;
      _completedCycles = 0;
    });
    _startTimer();
  }

  void _stopExercise() {
    _timer?.cancel();
    setState(() {
      _isActive = false;
      _currentPhase = 0;
      _countdown = 4;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          _currentPhase = (_currentPhase + 1) % 4;
          _countdown = 4;
          if (_currentPhase == 0) {
            _completedCycles++;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Box Breathing'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: isDarkMode
            ? AppTheme.backgroundGradient
            : AppTheme.lightBackgroundGradient,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Box Breathing',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: isDarkMode ? Colors.white : AppTheme.darkGreen,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Regulate your nervous system with 4-4-4-4 breathing',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                // Breathing Circle
                AnimatedContainer(
                  duration: const Duration(seconds: 4),
                  width: _isActive && (_currentPhase == 0 || _currentPhase == 1) ? 250 : 180,
                  height: _isActive && (_currentPhase == 0 || _currentPhase == 1) ? 250 : 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        isDarkMode ? AppTheme.sageGreen : AppTheme.mintGreen,
                        isDarkMode ? AppTheme.darkGreen : AppTheme.lightMint,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDarkMode ? AppTheme.sageGreen : AppTheme.mintGreen)
                            .withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _phaseIcons[_currentPhase],
                        size: 48,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _phases[_currentPhase],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$_countdown',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Stats
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Cycles',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white54 : Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$_completedCycles',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: isDarkMode ? Colors.white10 : Colors.black12,
                      ),
                      Column(
                        children: [
                          Text(
                            'Duration',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white54 : Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${(_completedCycles * 16) ~/ 60}:${((_completedCycles * 16) % 60).toString().padLeft(2, '0')}',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Control Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isActive ? _stopExercise : _startExercise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isActive
                          ? Colors.redAccent
                          : (isDarkMode ? AppTheme.sageGreen : AppTheme.mintGreen),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _isActive ? 'Stop' : 'Start',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
