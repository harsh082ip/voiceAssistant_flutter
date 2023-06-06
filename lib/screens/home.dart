import 'package:chat_assistant/screens/featureBox.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechtoText = SpeechToText();
  @override
  void initState() {
    super.initState();
    initSpeechToText();
  }

  Future<void> initSpeechToText() async {
    await speechtoText.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Assistant'),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    height: 120.0,
                    width: 120.0,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 245, 194, 229),
                        shape: BoxShape.circle),
                  ),
                ),
              ),
              Container(
                height: 126.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/assistant_female.png'),
                  ),
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            margin:
                const EdgeInsets.symmetric(horizontal: 30).copyWith(top: 30),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius:
                  BorderRadius.circular(20.0).copyWith(topLeft: Radius.zero),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Hey there!🙋‍♂️ I\'m Virtual Assistant, What can I do for you',
                style: TextStyle(
                    color: Color.fromRGBO(19, 61, 95, 1),
                    fontSize: 20.0,
                    fontFamily: 'Cera Pro'),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 10, left: 22),
            child: Text(
              'Here are a few features',
              style: TextStyle(
                  fontFamily: 'Cera Pro',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
          // features container
          Column(
            children: [
              FeatureBox(
                  color: Color.fromARGB(255, 130, 207, 235),
                  headerText: 'ChatGPT',
                  descriptionText:
                      'Enhance productivity and awareness with ChatGPT\'s intelligent assistance.'),
              FeatureBox(
                  color: Color.fromARGB(255, 167, 129, 236),
                  headerText: 'Dall-E',
                  descriptionText:
                      'Unleash creativity and be inspired with your Dall-E powered personal assistant.'),
              FeatureBox(
                  color: Color.fromARGB(255, 68, 241, 189),
                  headerText: 'Smart Voice Assistant',
                  descriptionText:
                      'Experience ultimate synergy with a Dall-E and ChatGPT powered voice assistant.')
            ],
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.mic),
      ),
    );
  }
}
