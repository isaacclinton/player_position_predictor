import 'package:flutter/material.dart';
import 'package:predictor/predictor.dart' as predictor;
import 'package:player_position_predictor/position/view/position_page.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool isPredicting = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final inputs = <String>[
      "Shot power",
      "Acceleration",
      "Finishing",
      "Crossing",
      "Curve",
      "Dribbling",
      "GK Diving",
      "Sliding tackle",
    ];
    return Stack(
      children: [
        Body(
          size: size,
          inputs: inputs,
          predict: (values) {
            setState(() {
              isPredicting = true;
            });
            // print(values);
            predictor.predict(values).then(
              (value) {
                setState(() {
                  isPredicting = false;
                });
                return Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return PositionPage(position: value);
                    },
                  ),
                );
              },
            );
          },
        ),
        if (isPredicting)
          Positioned.fill(
            child: Container(
              color: Colors.black12,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}

class Body extends StatefulWidget {
  const Body({
    Key? key,
    required this.size,
    required this.inputs,
    required this.predict,
  }) : super(key: key);

  final Size size;
  final List<String> inputs;
  final void Function(Map<String, double> values) predict;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = Map.fromEntries(
      widget.inputs.map(
        (e) => MapEntry(
          e,
          TextEditingController(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 600,
          height: widget.size.height,
          child: Padding(
            padding: EdgeInsets.only(
              left: 0,
              right: 0,
              top: widget.size.height * 0.05,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 30),
                    IconButton(
                      padding: EdgeInsets.zero,
                      splashRadius: 20,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    const SizedBox(width: 30),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Enter Player Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ...widget.inputs.map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: ValueInput(
                              hintText: e,
                              controller: _controllers[e]!,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            widget.predict(
                              _controllers.map((key, value) {
                                return MapEntry(
                                    key, double.tryParse(value.text) ?? 0);
                              }),
                            );
                          },
                          child: const Text("PREDICT"),
                        ),
                        const SizedBox(height: 30),
                      ],
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

class ValueInput extends StatelessWidget {
  const ValueInput({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
    );
  }
}
