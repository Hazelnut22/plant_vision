import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_vision/post.dart';
import 'package:plant_vision/style.dart';

class CropRecommend extends StatefulWidget {
  const CropRecommend({super.key});

  @override
  State<CropRecommend> createState() => _CropRecommendState();
}

class _CropRecommendState extends State<CropRecommend> {
  String _recommendation = "";
  double n_value = 0;
  double p_value = 10;
  double k_value = 10;
  final tempController = TextEditingController();
  final humidityController = TextEditingController();
  final pHController = TextEditingController();
  final rainfallController = TextEditingController();
  List<dynamic> value = [];
  final _formkey = GlobalKey<FormState>();
  final Post post = Post(
    url2: 'http://192.168.100.24:8000/',
    endpoint: 'recommend/get'
    );

  Future<void> _recommend() async {
    value.clear();
    final primaryUrl = Uri.parse(post.getFallbackUrl()); // Primary URL
    final fallbackUrl = Uri.parse(post.getPrimaryUrl()); //fallback URL
    
    value.add(n_value);
    value.add(p_value);
    value.add(k_value);
    value.add(double.tryParse(tempController.text) ?? 0);
    value.add(double.tryParse(humidityController.text) ?? 0);
    value.add(double.tryParse(pHController.text) ?? 0);
    value.add(double.tryParse(rainfallController.text) ?? 0);

    try {
      Map<String,dynamic> recommendation = {"features": value};
      String jsonBody = jsonEncode(recommendation);
      final response = await http.post(primaryUrl, body: jsonBody, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        setState(() {
          _recommendation = responseData['prediction'];
        });
        _showRecommendationDialog(_recommendation);
      } else {
        final response = await http.post(fallbackUrl, body: jsonBody, headers: {'Content-Type': 'application/json'});
        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          setState(() {
            _recommendation = responseData['prediction'];
          });
          _showRecommendationDialog(_recommendation);
          } else{
            print('Failed to upload data: ${response.statusCode}');
          }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showRecommendationDialog(String recommendation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.recommendation),
          content: Text(recommendation),
          backgroundColor: kColorLavenderBlush,
          contentTextStyle: TextStyle(
            fontSize: 15.0,
            color: kLicorice
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.ok
                ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    String nitrogen = AppLocalizations.of(context)!.nitrogen;
    String phosphorus = AppLocalizations.of(context)!.phosphorus;
    String potassium = AppLocalizations.of(context)!.potassium;
    String error1 = AppLocalizations.of(context)!.errorValue;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        automaticallyImplyLeading: false,
        title: SafeArea(
          child: Text(
            AppLocalizations.of(context)!.cropRecommend,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: kColorPakistanGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        titleSpacing: 4.0,
        centerTitle: true,
      
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.recommendDescription,
                style: TextStyle(
                  fontSize: screenWidth * 0.03,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Slider(
                value: n_value,
                min: 0,
                max: 140,
                divisions: 140,
                label: n_value.round().toString(),
                activeColor: kColorYellowGreen,
                onChanged: (double value){
                  setState(() {
                    n_value = value;
                  });
                },
              ),
              Text('$nitrogen: ${n_value.round()}',
                style: TextStyle(
                  color: kColorCalPolyGreen,
                  fontSize: screenWidth * 0.03,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Slider(
                value: p_value,
                min: 5,
                max: 145,
                divisions: 140,
                label: p_value.round().toString(),
                activeColor: kColorYellowGreen,
                onChanged: (double value){
                  setState(() {
                    p_value = value;
                  });
                },
              ),
              Text('$phosphorus: ${p_value.round()}',
                style: TextStyle(
                  color: kColorCalPolyGreen,
                  fontSize: screenWidth * 0.03,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Slider(
                value: k_value,
                min: 5,
                max: 205,
                divisions: 200,
                label: k_value.round().toString(),
                activeColor: kColorYellowGreen,
                onChanged: (double value){
                  setState(() {
                    k_value = value;
                  });
                },
              ),
              Text('$potassium: ${k_value.round()}',
                style: TextStyle(
                  color: kColorCalPolyGreen,
                  fontSize: screenWidth * 0.03,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: tempController,
                      cursorColor: kColorPakistanGreen,
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return error1;
                        } else {
                          final temp = double.tryParse(value);
                          if (temp! >= 9 && temp <= 44) {
                            return null;
                          } else {
                            return AppLocalizations.of(context)!.errorRange(9, 44);
                          }
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kColorPakistanGreen)
                          ),
                        labelStyle: TextStyle(
                          color: kColorPakistanGreen,
                          fontSize: 15.0,
                          ),
                        labelText: AppLocalizations.of(context)!.temperature,
                        hintStyle: TextStyle(
                          color: kLicorice,
                          fontSize: 15.0,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kColorRed)
                        ),
                        hintText: AppLocalizations.of(context)!.enterValue(AppLocalizations.of(context)!.temperature),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: humidityController,
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return error1;
                        } else {
                          final humidity = double.tryParse(value);
                          if (humidity! >= 14 && humidity <= 100) {
                            return null;
                          } else {
                            return AppLocalizations.of(context)!.errorRange(14, 100);
                          }
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kColorPakistanGreen)
                        ),
                        labelStyle: TextStyle(
                          color: kColorPakistanGreen,
                          fontSize: 15.0,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kColorRed)
                        ),
                        labelText: AppLocalizations.of(context)!.humidity,
                        hintText: AppLocalizations.of(context)!.enterValue(AppLocalizations.of(context)!.humidity),
                        hintStyle: TextStyle(
                          color: kLicorice,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: pHController,
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return error1;
                        } else {
                          final pH = double.tryParse(value);
                          if (pH! >= 4 && pH <= 10) {
                            return null;
                          } else {
                            return AppLocalizations.of(context)!.errorRange(4, 10);
                          }
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kColorPakistanGreen)
                        ),
                        labelStyle: TextStyle(
                          color: kColorPakistanGreen,
                          fontSize: 15.0,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kColorRed)
                        ),
                        labelText: 'pH',
                        hintStyle: TextStyle(
                          color: kLicorice,
                          fontSize: 15.0,
                        ),
                        hintText: AppLocalizations.of(context)!.enterValue("pH level"),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: rainfallController,
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return error1;
                        } else {
                          final rainfall = double.tryParse(value);
                          if (rainfall! >= 20 && rainfall <= 299) {
                            return null;
                          } else {
                            return AppLocalizations.of(context)!.errorRange(20, 299);
                          }
                        }
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kColorPakistanGreen)
                        ),
                        labelStyle: TextStyle(
                          color: kColorPakistanGreen,
                          fontSize: 15.0,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: kColorRed)
                        ),
                        labelText: AppLocalizations.of(context)!.rainfall,
                        hintStyle: TextStyle(
                          color: kLicorice,
                          fontSize: 15.0,
                        ),
                        hintText: AppLocalizations.of(context)!.enterValue(AppLocalizations.of(context)!.rainfall),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    ElevatedButton(
                      onPressed: () {
                        if (_formkey.currentState!.validate()) {
                          _recommend();
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.recommend,
                        style: TextStyle(
                          fontSize: screenWidth * 0.03,
                          color: kColorPakistanGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
