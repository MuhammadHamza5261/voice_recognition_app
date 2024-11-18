import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextScreen extends StatefulWidget {
  const SpeechToTextScreen({super.key});

  @override
  State<SpeechToTextScreen> createState() => _SpeechToTextState();

}

class _SpeechToTextState extends State<SpeechToTextScreen> {


  final SpeechToText _speechToText = SpeechToText();
  // final stt.SpeechToText  _speechToText  = stt.SpeechToText();

  bool _speechEnabled = false;
  String _wordsSpoken = "";
  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    initSpeech();
    _startListening();
  }

  void initSpeech() async{
    PermissionStatus status = await Permission.microphone.status ;
    if(status != PermissionStatus.granted) {
      await Permission.microphone.request() ;
    }
   _speechEnabled =  await _speechToText.initialize();
   setState(() {

   });

  }

  void _startListening() async{
   await _speechToText.listen(onResult: _onSpeechResult);
   setState(() {
     _confidenceLevel = 0;
   });

  }

  void _stopListening() async{

    await _speechToText.stop();
    setState(() {

    });
  }


  void _onSpeechResult(result){
    setState(() {

      _wordsSpoken = "${result.recognizedWords}";
      _confidenceLevel = result.confidence;

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
       onPressed: _speechToText.isListening ? _stopListening: _startListening,
        tooltip: 'Listen',
        child: Icon(
          _speechToText.isNotListening ? Icons.mic_off : Icons.mic,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('Speech Demo',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
        child: Center(
          child: Column(
            children: [
              Container(
                child: Text(_speechToText.isListening ? "Listening...."
                    :  _speechEnabled
                    ? "Tap the microphone and start the listening"
                    : "Speech not available",
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Text(_wordsSpoken,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

              ),
              ),
              if(_speechToText.isNotListening && _confidenceLevel > 0)
                Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Text(
                  "Confidence: ${(_confidenceLevel *100).toStringAsFixed(1)} %",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w200,
                  ),

                ),
              )
            ],
          ),
        ),

      ),
    );
  }
}
