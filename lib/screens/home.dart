import 'package:chat_assistant/screens/featureBox.dart';
import 'package:chat_assistant/screens/services-openAI.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final OpenAIService openAIService = OpenAIService();
  final speechtoText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  String? generatedContent;
  String? generatedUrl;
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechtoText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  Future<void> startListening() async {
    print('func called success');
    await speechtoText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    print('stopped');
    print(lastWords);
    await speechtoText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    print('onSpeech called');
    setState(() {
      lastWords = result.recognizedWords;
    });

    // if (result.finalResult) {
    //   // Check if this is the final result (end of speech)
    //   stopListening();
    // }
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechtoText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Assistant'),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
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
            Visibility(
              visible: generatedUrl == null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 30)
                    .copyWith(top: 30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(20.0)
                      .copyWith(topLeft: Radius.zero),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    generatedContent == null
                        ? 'Hey there!🙋‍♂️ I\'m Virtual Assistant, What can I do for you'
                        : generatedContent!,
                    style: TextStyle(
                        color: Color.fromRGBO(19, 61, 95, 1),
                        fontSize: generatedContent == null ? 20.0 : 15.0,
                        fontFamily: 'Cera Pro'),
                  ),
                ),
              ),
            ),
            if (generatedUrl != null)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Image.network(generatedUrl!)),
              ),
            Visibility(
              visible: generatedContent == null && generatedUrl == null,
              child: Container(
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
            ),
            // features container
            Visibility(
              visible: generatedContent == null && generatedUrl == null,
              child: Column(
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
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await speechtoText.hasPermission && speechtoText.isNotListening) {
            print('listening');
            await startListening();
          } else if (speechtoText.isListening) {
            final speech = await openAIService.isArtPrompt(lastWords);
            if (speech.contains('https')) {
              generatedUrl = speech;
              generatedContent = null;
              setState(() {});
            } else {
              generatedUrl = null;
              generatedContent = speech;
              setState(() {});
              systemSpeak(speech);
            }
            print(speech);
            print('stopped');
            await stopListening();
          } else {
            print('init called');
            initSpeechToText();
          }
        },
        child: speechtoText.isListening ? Icon(Icons.stop) : Icon(Icons.mic),
      ),
    );
  }
}
