import 'package:flutter/material.dart';
import 'package:player_position_predictor/details/details.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 70),
          const Text(
            "Football Player Position Predictor",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Image.asset("assets/icon-removebg.png"),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const DetailsPage();
                }));
              },
              child: const Text("PREDICT PLAYER POSITION"),
            ),
          ),
        ],
      ),
    );
  }
}
