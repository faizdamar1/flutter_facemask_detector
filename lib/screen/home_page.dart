import 'package:camera/camera.dart';
import 'package:facemask_detector/main.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraImage? imgCamera;
  CameraController cameraController =
      CameraController(cameras![0], ResolutionPreset.medium);

  bool isWorking = false;
  String result = '';

  initCamera() {
    cameraController.initialize().then((value) {
      if (!mounted) return;

      setState(() {
        cameraController.startImageStream((image) {
          if (!isWorking) {
            isWorking = true;
            imgCamera = image;
          }
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    cameraController.dispose();
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
            (cameraController.value.isInitialized)
                ? const Center(
                    child: Icon(Icons.camera_alt_rounded),
                  )
                : AspectRatio(
                    aspectRatio: cameraController.value.aspectRatio,
                    child: CameraPreview(cameraController),
                  )
          ],
        ),
      ),
    );
  }
}
