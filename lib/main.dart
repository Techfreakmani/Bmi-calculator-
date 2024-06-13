import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF12a644),
      ),
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  double _height = 170.0;
  double _weight = 70.0;
  double _bmi = 0.0;
  String _condition = '';
  bool _isButtonPressed = false;

  void _calculateBMI() {
    if (_height > 0 && _weight > 0) {
      double height = _height / 100; // Convert height to meters
      setState(() {
        _bmi = _weight / (height * height);
        if (_bmi < 18.5) {
          _condition = 'Underweight';
        } else if (_bmi < 24.9) {
          _condition = 'Normal weight';
        } else if (_bmi < 29.9) {
          _condition = 'Overweight';
        } else {
          _condition = 'Obesity';
        }
      });
    }
  }

  Color _getColor() {
    if (_bmi < 18.5) {
      return Colors.blue;
    } else if (_bmi < 24.9) {
      return Colors.green;
    } else if (_bmi < 29.9) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(size),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildSlider(
                    label: 'Height (cm)',
                    value: _height,
                    min: 100,
                    max: 250,
                    onChanged: (val) {
                      setState(() {
                        _height = val;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  _buildSlider(
                    label: 'Weight (kg)',
                    value: _weight,
                    min: 30,
                    max: 200,
                    onChanged: (val) {
                      setState(() {
                        _weight = val;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  GestureDetector(
                    onTapDown: (_) {
                      setState(() {
                        _isButtonPressed = true;
                      });
                    },
                    onTapUp: (_) {
                      setState(() {
                        _isButtonPressed = false;
                      });
                      _calculateBMI();
                    },
                    onTapCancel: () {
                      setState(() {
                        _isButtonPressed = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF12a644), Color(0xFF1de9b6)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _isButtonPressed
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 10),
                                ),
                              ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.calculate, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Calculate BMI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildResult(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Size size) {
    return Container(
      height: size.height * 0.40,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF12a644), Color(0xFF1de9b6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "BMI",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 60.0,
            ),
          ),
          Text(
            "Calculator",
            style: TextStyle(color: Colors.white, fontSize: 40.0),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: ((max - min) / 1).round(),
          label: value.round().toString(),
          onChanged: onChanged,
        ),
        Text(
          value.round().toString(),
          style: TextStyle(
            fontSize: 18.0,
          ),
        ),
      ],
    );
  }

  Widget _buildResult() {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          margin: EdgeInsets.symmetric(vertical: 16.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "BMI: ${_bmi.toStringAsFixed(1)}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: "Condition: ",
                    style: TextStyle(color: Colors.black, fontSize: 25.0),
                    children: <TextSpan>[
                      TextSpan(
                        text: _condition,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        LinearProgressIndicator(
          value: (_bmi / 40).clamp(0.0, 1.0),
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(_getColor()),
          minHeight: 10,
        ),
      ],
    );
  }
}
