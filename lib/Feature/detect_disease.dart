
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_vision/post.dart';
import 'package:plant_vision/style.dart';

class DetectDisease extends StatefulWidget {
  const DetectDisease({super.key});

  @override
  State<DetectDisease> createState() => _DetectDiseaseState();
}

class _DetectDiseaseState extends State<DetectDisease> {
  String prediction = "";
  double confidence = 0.0;
  String recommend_text = "";
  List<dynamic>? _recognitions;
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  final Post post = Post(
    url2: 'http://192.168.100.24:8000/',
    endpoint: 'plant/get'
    );

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return;

      setState(() {
        _imageFile = File(image.path);
      });

      if (_imageFile != null) {
        await _uploadImage();
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadImage() async {
    final primaryUrl = Uri.parse(post.getFallbackUrl()); // Primary URL
    final fallbackUrl = Uri.parse(post.getPrimaryUrl()); //fallback URL

    var request = http.MultipartRequest('POST', primaryUrl);
    request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var responseData = jsonDecode(responseBody);
        setState(() {
          prediction = responseData['prediction'];
          confidence = double.parse(responseData['confidence'])*100;
          recommend_text = responseData['recommend_text'];

          _recognitions = [{'label': prediction, 'confidence': confidence.toStringAsFixed(2), 'recommend_text': recommend_text}];
        });
      } else {
        var request = http.MultipartRequest('POST', fallbackUrl);
        request.files.add(await http.MultipartFile.fromPath('image', _imageFile!.path));
        var response = await request.send();
        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          var responseData = jsonDecode(responseBody);
          setState(() {
            prediction = responseData['prediction'];
            confidence = double.parse(responseData['confidence'])*100;
            recommend_text = responseData['recommend_text'];

            _recognitions = [{'label': prediction, 'confidence': confidence.toStringAsFixed(2), 'recommend_text': recommend_text}];
          });
          } else {
            print('Failed to upload image: ${response.statusCode}');
            }
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _showRecommendationDialog(String recommendation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.treatment),
          content: Text(recommend_text),
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
    String detection = AppLocalizations.of(context)!.prediction;
    String confidence = AppLocalizations.of(context)!.confidence;
    String percentage = AppLocalizations.of(context)!.percentage;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.detectDiseases,
          style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: kColorPakistanGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        titleSpacing: 4.0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.03),
              Text(
                AppLocalizations.of(context)!.detectDescription,
                style: TextStyle(
                  fontFamily: kMainFont,
                  color: kLicorice,
                  fontSize: screenWidth * 0.03,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Container(
                height: screenHeight * 0.35,
                width: screenWidth * 0.7,
                decoration: BoxDecoration(
                  color: kColorYellowGreen,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: _imageFile == null
                    ? Center(child: Text(AppLocalizations.of(context)!.noImage))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              SizedBox(height: screenHeight * 0.03),
              _recognitions == null
                  ? Container()
                  : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            '$detection: ${_recognitions![0]['label']}',
                            style: TextStyle(
                              color: kColorCalPolyGreen,
                              fontSize: screenWidth * 0.035,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          '$confidence: ${_recognitions![0]['confidence']} $percentage',
                          style: TextStyle(
                            color: kColorCalPolyGreen,
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        ElevatedButton(
                          onPressed: () {
                            _showRecommendationDialog(recommend_text);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.treatment,
                            style: TextStyle(
                              fontSize: screenWidth * 0.03,
                              color: kColorPakistanGreen,
                        ),
                      ),
                    ),
                      ],
                    ),
                  ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _pickImage(ImageSource.gallery),
                        child: Icon(
                          Icons.upload,
                          size: screenWidth * 0.15,
                          color: kColorPakistanGreen,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        AppLocalizations.of(context)!.uploadGallery,
                        style: TextStyle(
                          fontFamily: kMainFont,
                          color: kLicorice,
                          fontSize: screenWidth * 0.03,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => _pickImage(ImageSource.camera),
                        child: Icon(
                          Icons.camera_enhance_outlined,
                          size: screenWidth * 0.15,
                          color: kColorPakistanGreen,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        AppLocalizations.of(context)!.takePhoto,
                        style: TextStyle(
                          fontFamily: kMainFont,
                          color: kLicorice,
                          fontSize: screenWidth * 0.03,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}
