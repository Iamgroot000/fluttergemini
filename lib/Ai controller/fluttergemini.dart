import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_gradient_app_bar/flutter_gradient_app_bar.dart';
import 'package:fluttergemini/Ai%20controller/speech2text.dart';
import 'package:fluttergemini/Views/drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  /// Initialize of gemini , with api key

  Gemini.init(apiKey: 'AIzaSyDMH3WQoYiAT3cBUxhIdbJ1yo9XMnDgV2A');
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CustomDrawer(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/// statefulwidget --- mutable state
class MyGeminiSearchScreen extends StatefulWidget {
  /// constructor
  const MyGeminiSearchScreen({super.key});

  @override
  State<MyGeminiSearchScreen> createState() => _MyGeminiSearchScreenState();
}

class _MyGeminiSearchScreenState extends State<MyGeminiSearchScreen> {
  bool isDarkMode = false;
  final ImagePicker picker = ImagePicker();/// FOR picking the image from the camera
  final controller = TextEditingController(); /// A controller for a text input field.
  final gemini = Gemini.instance; /// instance of gemini class
  String? searchedText, result; /// A nullable String variable to store the text being searched.

  bool loading = false;
  bool isTextWithImage = false;
  Uint8List? selectedImage;
 /// Stream use for handling asynchronous processing and loading animation , so increase the response level of ai
  late StreamController<String> responseStreamController;
  late StreamSubscription<String> responseStreamSubscription;

  @override
  void initState() {
    super.initState();
    responseStreamController = StreamController<String>();
    responseStreamSubscription = responseStreamController.stream.listen((response) {
      setState(() {
        result = response;
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    /// Stream controller are using for handling asynchronous processing of response
    responseStreamController.close();
    responseStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Gradient is using for using two colors in same appbar
      appBar: GradientAppBar(
        title: const Text("GROOT AI"),
        titleSpacing: 0.0,
        centerTitle: true,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(55),
            bottomLeft: Radius.circular(55),
          ),
        ),
        elevation: 0.00,
        gradient: LinearGradient(
          colors: [Colors.purple[400]!, Colors.blue[400]!],
        ),
        // leading: IconButton(
        //   onPressed: () {
        //     ///By calling customdrawer you can use drawer anywhere in your code
        //    // Get.to(() => CustomDrawer());
        //   },
        //   icon: Icon(Icons.chevron_left),
        // ),
        actions: [
          // IconButton(
          //   icon: Icon(isDarkMode ? Icons.light_mode : Icons.chalet),
          //   onPressed: () {
          //     //Get.to(CustomDrawer());
          //     // gemini.chat([
          //     //   Content(parts: [
          //     //     Parts(text: 'Write the first line of a story about a magic backpack.')],
          //     //       role: 'user'),
          //     //   Content(parts: [
          //     //     Parts(text: 'In the bustling city of Meadow brook, lived a young girl named Sophie. She was a bright and curious soul with an imaginative mind.')],
          //     //       role: 'model'),
          //     //   Content(parts: [
          //     //     Parts(text: 'Can you set it in a quiet village in 1600s France?')],
          //     //       role: 'user'),
          //     // ]);
          //   },
          // ),
          // IconButton(
          //   icon: Icon(Icons.dark_mode),
          //   onPressed: () {
          //     /// Getx query for applying dark theme
          //     Get.changeTheme(ThemeData.dark());
          //     //Get.changeTheme(ThemeData.light());
          //   },
          // ),

        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              Radio(
                  value: false,
                  groupValue: isTextWithImage,
                  onChanged: (val) {
                      isTextWithImage = val ?? false;
                  }),
              const Text("Search with Text",),
              Radio(
                  value: true,
                  groupValue: isTextWithImage,
                  onChanged: (val) {
                    setState(() {
                      isTextWithImage = val ?? false;
                    });
                  }),
              const Text("Search with Text and Image")
            ],
          ),
          if (searchedText != null)
            MaterialButton(
                color: Colors.green.shade200,
                onPressed: () {
                    searchedText = null;
                    result = null;
                },
                child: Text(
                  'Search: $searchedText',
                  style: const TextStyle(color: Colors.white),
                )),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: loading
                          ? const Center(child: CircularProgressIndicator())
                          : result != null
                          ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          result!,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                          :Center(
                        child: IconButton(
                          icon: Icon(Icons.voice_chat), // Replace with your desired icon
                          onPressed: () {
                            Get.to(() => SpeechtoText());
                          },
                        ),
                      ), ),
                    if (selectedImage != null)
                      Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: Image.memory(
                            selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(12),
            color: Theme.of(context).cardColor, // Use cardColor from theme
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: Theme.of(context).textTheme.bodyText1, // Use text style from theme
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      hintText: 'Write Something...',
                      border: InputBorder.none,
                      hintStyle: Theme.of(context).textTheme.caption, // Use hint text style from theme
                    ),
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                  ),
                ),
                if (isTextWithImage)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      onPressed: () async {
                        final ImagePicker picker =
                        ImagePicker();
                        final XFile? photo = await picker.pickImage(
                            source: ImageSource.camera);

                        if (photo != null) {
                          photo.readAsBytes().then((value) => setState(() {
                            selectedImage = value;
                          }));
                        }
                      },
                      icon: const Icon(Icons.file_copy_outlined),
                      color: Theme.of(context).iconTheme.color, // Use icon color from theme
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        if (isTextWithImage) {
                          if (selectedImage != null) {
                            searchedText = controller.text;
                            controller.clear();
                            loading = true;
                            setState(() {});

                            gemini.textAndImage(
                              text: searchedText!,
                              images: selectedImage != null ? [selectedImage!] : [],
                            ).then((value) {
                              responseStreamController.add(
                                  value?.content?.parts?.last.text ?? "No response");
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please select a picture");
                          }
                        } else {
                          searchedText = controller.text;
                          controller.clear();
                          loading = true;
                          setState(() {});
                          gemini.text(searchedText!).then((value) {
                            responseStreamController.add(
                                value?.content?.parts?.last.text ?? "No response");
                          });
                        }
                      } else {
                        Fluttertoast.showToast(msg: "Please enter something");
                      }
                    },
                    icon: const Icon(Icons.send_rounded),
                    color: Theme.of(context).iconTheme.color, // Use icon color from theme
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    onPressed: () {
                      if (result != null) {
                        Clipboard.setData(ClipboardData(text: result!));
                        Fluttertoast.showToast(
                            msg: "Response copied to clipboard");
                      }
                    },
                    icon: const Icon(Icons.content_copy),
                    color: Theme.of(context).iconTheme.color, // Use icon color from theme
                  ),
                )
              ],
            ),
          )

        ],
      ),
    );
  }
}
