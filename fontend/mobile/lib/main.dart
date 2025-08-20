import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: StudentScorePage(),
    debugShowCheckedModeBanner: false,
  ));
}

class StudentScorePage extends StatefulWidget {
  @override
  _StudentScorePageState createState() => _StudentScorePageState();
}

class _StudentScorePageState extends State<StudentScorePage> with TickerProviderStateMixin {
  int? gender;
  int? race;
  int? education;
  int? lunch;
  int? testPrep;

  double? totalScore;
  String? error;
  bool isLoading = false;

  late AnimationController _scoreAnimationController;
  late Animation<double> _scoreAnimation;
  
  @override
  void initState() {
    super.initState();
    _scoreAnimationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _scoreAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scoreAnimationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    super.dispose();
  }

  Future<void> calculateScore() async {
    if ([gender, race, education, lunch, testPrep].contains(null)) {
      setState(() {
        error = 'Please fill in all fields';
        totalScore = null;
      });
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
      totalScore = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/student-score'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'gender': gender,
          'race': race,
          'education': education,
          'lunch': lunch,
          'test_prep': testPrep,
        }),
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        setState(() {
          totalScore = data['total_score']?.toDouble();
        });
        _scoreAnimationController.forward();
      } else {
        setState(() {
          error = data['detail']?.toString() ?? 'Error fetching data';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Unable to connect to API';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildModernDropdown<T>({
    required String label,
    required T? value,
    required List<Map<String, dynamic>> items,
    required Function(T?) onChanged,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [Colors.grey[50]!, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
            prefixIcon: Container(
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.purple[400]!],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
          borderRadius: BorderRadius.circular(20),
          items: items
              .map((item) => DropdownMenuItem<T>(
                    value: item['value'],
                    child: Text(
                      item['label'],
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[50]!,
              Colors.white,
              Colors.purple[50]!,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Container(
                constraints: BoxConstraints(maxWidth: 500),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 30,
                      offset: Offset(0, 15),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Section
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[500]!, Colors.purple[600]!],
                          ),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.school,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.grey[800]!, Colors.grey[600]!],
                        ).createShader(bounds),
                        child: Text(
                          'Student Score Calculator',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      Text(
                        'Predict academic performance based on student profile',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: 32),
                      
                      // Form Fields
                      buildModernDropdown<int>(
                        label: 'Gender',
                        value: gender,
                        icon: Icons.person,
                        items: [
                          {'label': 'Female', 'value': 1},
                          {'label': 'Male', 'value': 2},
                        ],
                        onChanged: (val) => setState(() => gender = val),
                      ),
                      
                      buildModernDropdown<int>(
                        label: 'Race/Ethnicity',
                        value: race,
                        icon: Icons.diversity_1,
                        items: List.generate(5, (i) => {
                          'label': 'Group ${String.fromCharCode(65 + i)}', 
                          'value': i + 1
                        }),
                        onChanged: (val) => setState(() => race = val),
                      ),
                      
                      buildModernDropdown<int>(
                        label: 'Parental Level of Education',
                        value: education,
                        icon: Icons.school_outlined,
                        items: [
                          {'label': 'Some High School', 'value': 1},
                          {'label': 'High School', 'value': 2},
                          {'label': 'Associate\'s Degree', 'value': 3},
                          {'label': 'Some College', 'value': 4},
                          {'label': 'Bachelor\'s Degree', 'value': 5},
                          {'label': 'Master\'s Degree', 'value': 6},
                        ],
                        onChanged: (val) => setState(() => education = val),
                      ),
                      
                      buildModernDropdown<int>(
                        label: 'Lunch Program',
                        value: lunch,
                        icon: Icons.restaurant,
                        items: [
                          {'label': 'Free/Reduced', 'value': 2},
                          {'label': 'Standard', 'value': 1},
                        ],
                        onChanged: (val) => setState(() => lunch = val),
                      ),
                      
                      buildModernDropdown<int>(
                        label: 'Test Preparation Course',
                        value: testPrep,
                        icon: Icons.quiz,
                        items: [
                          {'label': 'None', 'value': 1},
                          {'label': 'Completed', 'value': 2},
                        ],
                        onChanged: (val) => setState(() => testPrep = val),
                      ),
                      
                      SizedBox(height: 32),
                      
                      // Calculate Button
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.blue[500]!, Colors.purple[600]!],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: isLoading ? null : calculateScore,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: isLoading
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    Text(
                                      'Calculating...',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  'Calculate Score',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      
                      // Error Message
                      if (error != null)
                        Container(
                          margin: EdgeInsets.only(top: 24),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.red[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  error!,
                                  style: TextStyle(
                                    color: Colors.red[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // Score Result
                      if (totalScore != null)
                        AnimatedBuilder(
                          animation: _scoreAnimation,
                          builder: (context, child) {
                            return Container(
                              margin: EdgeInsets.only(top: 32),
                              padding: EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.green[50]!, Colors.green[50]!],
                                ),
                                borderRadius: BorderRadius.circular(28),
                                border: Border.all(color: Colors.green[200]!),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.green.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.green[400]!, Colors.green[500]!],
                                      ),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  
                                  Text(
                                    'Predicted Total Score',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  SizedBox(height: 12),
                                  
                                  ShaderMask(
                                    shaderCallback: (bounds) => LinearGradient(
                                      colors: [Colors.green[600]!, Colors.green[600]!],
                                    ).createShader(bounds),
                                    child: Text(
                                      '${(totalScore! * _scoreAnimation.value).toStringAsFixed(1)}',
                                      style: TextStyle(
                                        fontSize: 42,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  
                                  Text(
                                    '/ 300',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  
                                  SizedBox(height: 20),
                                  
                                  // Progress Bar
                                  Container(
                                    height: 12,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                          ),
                                          FractionallySizedBox(
                                            alignment: Alignment.centerLeft,
                                            widthFactor: ((totalScore! / 300) * _scoreAnimation.value).clamp(0.0, 1.0),
                                            child: Container(
                                              height: 12,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [Colors.green[400]!, Colors.green[500]!],
                                                ),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}