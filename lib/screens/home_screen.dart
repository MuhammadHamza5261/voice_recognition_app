import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // create a variable
  final stt.SpeechToText  _speechToText  = stt.SpeechToText();
  String _recognizedText = "";
  bool  _isListening = false;

  @override
  void initState() {
    super.initState();
    // call the method in initState
    _initSpeechState();
    // call the start listening method in initState
    _startListening();

  }

   // now we will create a method

    void _initSpeechState() async{

    bool available  = await _speechToText.initialize();

    if(!mounted) return;
    setState(() {

      _isListening = available;

    });

  }


  void _startListening(){
    _speechToText.listen(
      onResult: (result){
        setState(() {
          _recognizedText = result.recognizedWords;
        });
        setState(() {
          _isListening = true;
        });
      }
    );
  }


  void _copyText(){

    Clipboard.setData(ClipboardData(text: _recognizedText));
    _showSnakBar("Text Copied");

  }

  void _clearText(){
    setState(() {
      _recognizedText = "";

    });

  }

  void _showSnakBar(String message){

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(

        content: Text(message),duration: const Duration(seconds: 1),

    ),
    );
    
  }



  @override
  Widget build(BuildContext context) {

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Speech Recognition',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 30,
                fontWeight: FontWeight.w500,
              ),
            ),
           const SizedBox(
              height: 40,
            ),
            IconButton(
                onPressed: _startListening,
                icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
              iconSize: 100,
              color: _isListening ? Colors.red : Colors.grey,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: MediaQuery.of(context).size.height /4,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black45,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(_recognizedText.isNotEmpty ? _recognizedText : "Result here.....",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
           const  SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _recognizedText.isNotEmpty ? _copyText : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Copy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
               const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: _recognizedText.isNotEmpty ? _clearText: null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Clear',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),


        ),
    );
  }
}
