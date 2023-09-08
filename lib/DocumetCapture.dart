import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class DocumentCaptureView extends StatefulWidget {
  const DocumentCaptureView({Key? key}) : super(key: key);

  @override
  State<DocumentCaptureView> createState() => _DocumentCaptureViewState();
}

class _DocumentCaptureViewState extends State<DocumentCaptureView> {
  // OverlayFormat format = OverlayFormat.cardID3;
  int tab = 0;
  late CameraController controller;
  List<CameraDescription>? _cameras;

  getimage() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras![1], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getimage();
  }

  // @override
  // void dispose() {
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: FutureBuilder<List<CameraDescription>?>(
        future: availableCameras(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == null) {
              return const Align(
                  alignment: Alignment.center,
                  child: LinearProgressIndicator());
            }
            return Stack(
              children: [
                Expanded(
                    child: !controller.value.isInitialized
                        ? Container()
                        : Container(
                            width: MediaQuery.of(context).size.width,
                            child: CameraPreview(controller))),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: InkWell(
                      onTap: () {
                        var data = controller.takePicture();
                        print(data);
                        Navigator.pop(context, data);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ))
              ],
            );
          } else {
            return const Align(
                alignment: Alignment.center, child: LinearProgressIndicator());
          }
        },
      ),
    );
  }
}
