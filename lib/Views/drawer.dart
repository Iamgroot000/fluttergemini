import 'package:flutter/material.dart';
import 'package:fluttergemini/Ai%20controller/fluttergemini.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 1040,
            child: DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.blueGrey],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WidgetCircularAnimator(
                    size: 200,
                    innerIconsSize: 3,
                    outerIconsSize: 3,
                    innerAnimation: Curves.easeInOutBack,
                    outerAnimation: Curves.easeInOutBack,
                    innerColor: Colors.red,
                    outerColor: Colors.green,
                    innerAnimationSeconds: 10,
                    outerAnimationSeconds: 10,
                    child: ClipOval(
                      child: Image.asset(
                        'assests/grootx.jpg',
                        width: 250,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _animation.value,
                        child: const Text(
                          'I  AM GROOT',
                          style: TextStyle(
                            //fontFamily: FontFamily.capitalize,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      );
                    },
                  ),
    SizedBox(height: 20),
              IconButton(
                icon: Icon(Icons.arrow_drop_down_circle),
                onPressed: () {
                  // Navigate to the next screen
                  Get.to(() => MyGeminiSearchScreen());

                },
              ),
                ],
              ),
            ),
          ),
          // Add other Drawer items as needed
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:fluttergemini/Ai%20controller/fluttergemini.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:voice_to_text/voice_to_text.dart';
//
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const GetMaterialApp(
//       title: 'Flutter Demo',
//       home: SpeechDemo(),
//     );
//   }
// }
//
// class SpeechDemo extends StatefulWidget {
//   const SpeechDemo({Key? key}) : super(key: key);
//
//   @override
//   State<SpeechDemo> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<SpeechDemo> {
//   final VoiceToText _speech = VoiceToText();
//   String text = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _speech.initSpeech();
//     _speech.addListener(() {
//       setState(() {
//         text = _speech.speechResult;
//         if (text.toLowerCase() == " i am groot" ) {
//           Get.to(() => MyGeminiSearchScreen());
//         }
//         else {
//           Fluttertoast.showToast(
//               msg: " i am groot '",
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIosWeb: 1,
//               backgroundColor: Colors.green,);
//         }
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Speech Demo'),
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(10),
//         alignment: Alignment.center,
//         child: Column(
//           textBaseline: TextBaseline.alphabetic,
//           children: <Widget>[
//             Text(
//               _speech.isListening ? "Listening...." : 'Tap the microphone to start',
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             Text(
//               _speech.isNotListening ? (text.isNotEmpty ? text : "Try speaking again") : "",
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed:
//         // If not yet listening for speech start, otherwise stop
//         _speech.isNotListening ? _speech.startListening : _speech.stop,
//         tooltip: 'Listen',
//         child: Icon(_speech.isNotListening ? Icons.mic_off : Icons.mic),
//       ),
//     );
//   }
// }
//
