import 'package:flutter/material.dart';
import 'package:player_position_predictor/position/view/position_page.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final inputs = <String>[
      "Pace",
      "Shooting",
      "Passing",
      "Dribbling",
    ];
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Padding(
          padding: EdgeInsets.only(
            left: size.width * 0.1,
            right: size.width * 0.1,
            top: size.height * 0.05,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  splashRadius: 20,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: size.height * 0.05),
                    child: const Text(
                      "Enter Player Details",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  ...inputs.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: ValueInput(hintText: e),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const PositionPage();
                          },
                        ),
                      );
                    },
                    child: const Text("PREDICT"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ValueInput extends StatelessWidget {
  const ValueInput({
    Key? key,
    required this.hintText,
  }) : super(key: key);

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }
}
