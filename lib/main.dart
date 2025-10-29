// split o steal 1
import 'dart:math'; // import library untuk Random()
import 'package:flutter/material.dart';

void main() {
  runApp(const SplitStealApp());
}

// Root StatelessWidget
class SplitStealApp extends StatelessWidget {
  const SplitStealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Split or Steal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}

// StatefulWidget: main game page
class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

enum Choice { split, steal }
enum AiStrategy { random, titForTat, alwaysSplit, alwaysSteal }

class _GamePageState extends State<GamePage> {
  final Random _rng = Random();
  AiStrategy _selectedStrategy = AiStrategy.random;

  // Scores
  int playerScore = 0;
  int aiScore = 0;

  // History: list of (playerChoice, aiChoice, playerGain, aiGain)
  final List<Map<String, dynamic>> _history = [];

  // For Tit-for-Tat: remember player's last choice
  Choice? _playersLastChoice;

  // UI states
  bool _roundActive = true; // not much use but could be used for animations

  void _playRound(Choice playerChoice) {
    final Choice aiChoice = _aiPick();
    final pair = _payoff(playerChoice, aiChoice);

    setState(() {
      playerScore += pair['player'] as int;
      aiScore += pair['ai'] as int;
      _history.insert(0, {
        'player': playerChoice,
        'ai': aiChoice,
        'playerGain': pair['player'],
        'aiGain': pair['ai'],
        'time': DateTime.now(),
      });
      _playersLastChoice = playerChoice;
      _roundActive = !_roundActive; // toggle for a small UI effect possibility
    });
  }

  Choice _aiPick() {
    switch (_selectedStrategy) {
      case AiStrategy.random:
        return _rng.nextBool() ? Choice.split : Choice.steal;
      case AiStrategy.alwaysSplit:
        return Choice.split;
      case AiStrategy.alwaysSteal:
        return Choice.steal;
      case AiStrategy.titForTat:
      // if no previous move, start with split
        if (_playersLastChoice == null) return Choice.split;
        // mimic player's last move
        return _playersLastChoice!;
    }
  }

  // Payoff matrix (example values):
  // Both Split => each +2
  // Both Steal => each +0
  // Split vs Steal => Stealer +3, Splitter +0
  Map<String, int> _payoff(Choice p, Choice a) {
    if (p == Choice.split && a == Choice.split) return {'player': 2, 'ai': 2};
    if (p == Choice.steal && a == Choice.steal) return {'player': 0, 'ai': 0};
    if (p == Choice.steal && a == Choice.split) return {'player': 3, 'ai': 0};
    // p == split && a == steal
    return {'player': 0, 'ai': 3};
  }

  void _resetGame() {
    setState(() {
      playerScore = 0;
      aiScore = 0;
      _history.clear();
      _playersLastChoice = null;
    });
  }

  String _choiceToText(Choice c) => c == Choice.split ? 'Split' : 'Steal';
  IconData _choiceToIcon(Choice c) => c == Choice.split ? Icons.handshake : Icons.military_tech;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Split or Steal — Mini Game'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Header: Scores and AI strategy
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                child: Row(
                  children: [
                    // Player score
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('You', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('Score: $playerScore', style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),

                    // decoration image from asset (if missing, shows nothing)
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Image.asset(
                        'assets/images/con.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, err, stack) {
                          // fallback network image
                          return Image.network(
                            'https://cdn-icons-png.flaticon.com/512/1517/1517806.png',
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),

                    // AI score
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Opponent', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('Score: $aiScore', style: const TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Strategy selector
            Row(
              children: [
                const Text('Opponent strategy: ', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                DropdownButton<AiStrategy>(
                  value: _selectedStrategy,
                  items: const [
                    DropdownMenuItem(value: AiStrategy.random, child: Text('Random')),
                    DropdownMenuItem(value: AiStrategy.titForTat, child: Text('Tit-for-Tat')),
                    DropdownMenuItem(value: AiStrategy.alwaysSplit, child: Text('Always Split')),
                    DropdownMenuItem(value: AiStrategy.alwaysSteal, child: Text('Always Steal')),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() {
                      _selectedStrategy = v;
                    });
                  },
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _resetGame,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // The game area: big prompt + two choice buttons
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Prompt
                    Text(
                      'Choose: Split 🤝  or  Steal 🗡️',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Tip: Try Tit-for-Tat for a fair opponent!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 22),

                    // Buttons Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _playRound(Choice.split),
                          icon: Icon(_choiceToIcon(Choice.split)),
                          label: const Text('Split'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade600,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: () => _playRound(Choice.steal),
                          icon: Icon(_choiceToIcon(Choice.steal)),
                          label: const Text('Steal'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange.shade700,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Quick result preview (last round)
                    if (_history.isNotEmpty)
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              const Text('Last Round', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      const Text('You'),
                                      const SizedBox(height: 6),
                                      Icon(_choiceToIcon(_history.first['player'] as Choice), size: 28),
                                      Text(_choiceToText(_history.first['player'] as Choice)),
                                      Text('+${_history.first['playerGain']}', style: const TextStyle(color: Colors.green)),
                                    ],
                                  ),
                                  const SizedBox(width: 30),
                                  Column(
                                    children: [
                                      const Text('Opponent'),
                                      const SizedBox(height: 6),
                                      // use network image for opponent's mood
                                      Icon(_choiceToIcon(_history.first['ai'] as Choice), size: 28),
                                      Text(_choiceToText(_history.first['ai'] as Choice)),
                                      Text('+${_history.first['aiGain']}', style: const TextStyle(color: Colors.green)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 8),

            // History list (most recent first)
            SizedBox(
              height: 160,
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _history.isEmpty
                      ? const Center(child: Text('No rounds yet — play to start!'))
                      : ListView.builder(
                    reverse: false,
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final h = _history[index];
                      final p = h['player'] as Choice;
                      final a = h['ai'] as Choice;
                      final pg = h['playerGain'] as int;
                      final ag = h['aiGain'] as int;
                      final time = h['time'] as DateTime;
                      return ListTile(
                        dense: true,
                        leading: Icon(_choiceToIcon(p)),
                        title: Text('${_choiceToText(p)}  vs  ${_choiceToText(a)}'),
                        subtitle: Text('${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('You +$pg', style: const TextStyle(fontSize: 12)),
                            Text('AI +$ag', style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


