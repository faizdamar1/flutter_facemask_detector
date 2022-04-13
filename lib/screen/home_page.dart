import 'package:camera/camera.dart';
import 'package:facemask_detector/main.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraController? controller;
  CameraImage? imgCamera;
  bool isworking = false;

  @override
  void initState() {
    super.initState();
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
          }
        });
      });
    });
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
            const Text(
              "Facemask Detector",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
