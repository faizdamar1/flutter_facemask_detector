import 'package:camera/camera.dart';
import 'package:facemask_detector/main.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraController? controller;
  CameraImage? imgCamera;
  bool isworking = false;

  String result = '';

  runModelOnFrame() async {
    if (imgCamera != null) {
      var recognition = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((e) {
          return e.bytes;
        }).toList(),
        imageHeight: imgCamera!.height,
        imageWidth: imgCamera!.width,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 1,
        threshold: 0.1,
        asynch: true,
      );

      result = '';

      recognition?.forEach((element) {
        result += element["label"] + "\n";
      });

      setState(() {
        result;
      });

      isworking = false;
    }
  }

  initCamera() {
    controller = CameraController(cameras![0], ResolutionPreset.max);
    controller!.initialize().then((img) {
      if (!mounted) {
        return;
      }
      setState(() {
        controller!.startImageStream((image) {
          if (!isworking) {
            isworking = true;
            imgCamera = image;
            runModelOnFrame();
          }
        });
      });
    });
  }

  initModel() async {
    await Tflite.loadModel(
        model: "assets/model.tflite", labels: "assets/labels.txt");
  }

  @override
  void initState() {
    super.initState();
    initModel();
    initCamera();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text("Faiz Project"),
            const SizedBox(height: 5),
            Text(
              "Facemask Detector $result",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            (!controller!.value.isInitialized)
                ? Container()
                : CameraPreview(controller!),
          ],
        ),
      ),
    );
  }
}
