import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:plant_vision/main.dart';
import 'package:plant_vision/style.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {

  final Map <String, String> languages = {
    "English": "en",
    "Burmese": "my"
  };

  String _selectedLanguageCode = "";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kBgColor,
      appBar: AppBar(
        backgroundColor: kBgColor,
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.abouttitle),
        titleSpacing: 2.0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18.0,
          color: kLicorice,
          fontWeight: FontWeight.bold,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: null,
                    icon: Icon(
                      Icons.language,
                      color: kColorYellowGreen,
                      size: 35,
                      ),
                    items: languages.keys.map((String language) {
                      return DropdownMenuItem<String>(
                        value: language,
                        child: Text(language),
                        );
                      }).toList(),
                    onChanged: (String? language) {
                      if (language != null) {
                        setState(() {
                          _selectedLanguageCode = languages[language]!;
                        });
                        MyApp.setLocale(context, Locale(_selectedLanguageCode));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0), // Add padding around the entire column
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Intro to our app
            Text(
              AppLocalizations.of(context)!.welcomeDisplay,
              style: TextStyle(
                color: kLicorice,
                fontSize: screenWidth * 0.05,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20), 
            //features
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        'images/disease.png', 
                        width: 60,
                        height: 60,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.detectFeature,
                          style: TextStyle(
                            color: kLicorice,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15), 
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        'images/sprout.png', 
                        width: 60,
                        height: 60,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.chatFeature,
                          style: TextStyle(
                            color: kLicorice,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 15), 
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Image.asset(
                        'images/chatbot.png', 
                        width: 60,
                        height: 60,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.recommendFeature,
                          style: TextStyle(
                            color: kLicorice,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            Text(
              AppLocalizations.of(context)!.motto,
              style: TextStyle(
                color: Colors.black,
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
