import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<String> board = List.filled(9, '');
  String currentPlayer = 'X';
  bool gameOver = false;

  void handleTap(int index) {
    if (board[index] == '' && !gameOver) {
      setState(() {
        board[index] = currentPlayer;
        checkGameState();
        if (!gameOver) {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  void checkGameState() {
    const winPositions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var pos in winPositions) {
      if (board[pos[0]] != '' &&
          board[pos[0]] == board[pos[1]] &&
          board[pos[1]] == board[pos[2]]) {
        gameOver = true;
        showResultDialog("🎉 Le Joueur '$currentPlayer' a gagné !");
        return;
      }
    }

    if (!board.contains('')) {
      gameOver = true;
      showResultDialog("🤝 Égalité !");
    }
  }

  void showResultDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Résultat"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              resetGame();
              Navigator.pop(context);
            },
            child: const Text("Rejouer"),
          )
        ],
      ),
    );
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      currentPlayer = 'X';
      gameOver = false;
    });
  }

  void logout() async {
    final auth = AuthService();
    await auth.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tic Tac Toe - Joueur: $currentPlayer"),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: "Déconnexion",
          ),
        ],
      ),
      backgroundColor: Colors.deepPurple.shade50,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              itemCount: 9,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => handleTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: board[index] == 'X'
                              ? Colors.deepPurple
                              : Colors.orange,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
