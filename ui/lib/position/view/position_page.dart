import 'package:flutter/material.dart';

final positionsMap = {
  "GK":"Goalkeeper",
  "ST": "Striker",
  "LW": "Left Winger",
  "RW": "Right Winger",
  "LM": "Left Middle-Fielder",
  "RM": "Right Middle-Fielder",
  "CF": "Centre Forward",
  "LB": "Left Back",
  "RB": "Right Back",
  "CM": "Central Middle-Fielder",
  "CDM": "Central Defensive Middle-Fielder",
};

class PositionPage extends StatelessWidget {
  const PositionPage({
    super.key,
    required this.position,
  });

  final String position;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              Positioned(
                top: 15,
                left: 15,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                  icon: const Icon(Icons.clear),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      children: [
                        const TextSpan(
                          text: "Prediction: ",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: positionsMap[position] ?? position,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Stack(
                    children: [
                      Image.asset(
                        "assets/pitch/pitch1.jpg",
                      ),
                      Positioned.fill(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Padding(
                              padding:
                                  EdgeInsets.all(constraints.maxWidth * 0.03),
                              child: Positions(
                                selectedPosition: position,
                                size: Size(
                                  constraints.maxWidth -
                                      constraints.maxWidth * 0.06,
                                  constraints.maxHeight -
                                      constraints.maxWidth * 0.06,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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

class Positions extends StatelessWidget {
  const Positions({
    super.key,
    required this.size,
    this.selectedPosition,
  });

  final Size size;
  final String? selectedPosition;

  @override
  Widget build(BuildContext context) {
    final positions = <String, Offset Function(Size size)>{
      "GK": (size) => Offset(0, size.height / 2),
      "LM": (size) => Offset(size.width * 0.53, size.height * 0.2),
      "RM": (size) =>
          Offset(size.width * 0.53, size.height - size.height * 0.2),
      "CB": (size) => Offset(size.width * 0.18, size.height / 2),
      "LB": (size) => Offset(size.width * 0.18, size.height * 0.25),
      "RB": (size) =>
          Offset(size.width * 0.18, size.height - size.height * 0.25),
      "RWB": (size) =>
          Offset(size.width * 0.3, size.height - size.height * 0.1),
      "LWB": (size) => Offset(size.width * 0.3, size.height * 0.1),
      "CM": (size) => Offset(size.width * 0.53, size.height / 2),
      "CDM": (size) => Offset(size.width * 0.38, size.height / 2),
      "ST": (size) => Offset(size.width - size.width * 0.1, size.height / 2),
      "LW": (size) => Offset(size.width * 0.7, size.height * 0.1),
      "RW": (size) => Offset(size.width * 0.7, size.height - size.height * 0.1),
      "CAM": (size) => Offset(size.width * 0.65, size.height / 2),
      "CF": (size) => Offset(size.width - size.width * 0.2, size.height / 2),
    };
    return Stack(
      children: [
        ...positions.keys.map(
          (key) {
            final position = positions[key]!(size);
            return Positioned(
              left: position.dx,
              top: position.dy - 16, // minus font size height
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: key == selectedPosition ? Colors.red : Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: Text(
                    key,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: key == selectedPosition
                          ? Colors.white
                          : Colors.green.shade800,
                    ),
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ],
    );
  }
}
