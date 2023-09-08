// import 'dart:convert';
//
// import 'package:face_auth/common/utils/extensions/size_extension.dart';
// import 'package:face_auth/common/utils/extract_face_feature.dart';
// import 'package:face_auth/common/views/camera_view.dart';
// import 'package:face_auth/common/views/custom_button.dart';
// import 'package:face_auth/constants/theme.dart';
// import 'package:face_auth/model/user_model.dart';
// import 'package:face_auth/register_face/enter_details_view.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
//
// class RegisterFaceView extends StatefulWidget {
//   const RegisterFaceView({Key? key}) : super(key: key);
//
//   @override
//   State<RegisterFaceView> createState() => _RegisterFaceViewState();
// }
//
// class _RegisterFaceViewState extends State<RegisterFaceView> {
//   final FaceDetector _faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableLandmarks: true,
//       performanceMode: FaceDetectorMode.accurate,
//     ),
//   );
//   String? _image;
//   FaceFeatures? _faceFeatures;
//
//   @override
//   void dispose() {
//     _faceDetector.close();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: appBarColor,
//         title: const Text("Register User"),
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               scaffoldTopGradientClr,
//               scaffoldBottomGradientClr,
//             ],
//           ),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Container(
//               height: 0.82.sh,
//               width: double.infinity,
//               padding: EdgeInsets.fromLTRB(0.05.sw, 0.025.sh, 0.05.sw, 0.04.sh),
//               decoration: BoxDecoration(
//                 color: overlayContainerClr,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(0.03.sh),
//                   topRight: Radius.circular(0.03.sh),
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   CameraView(
//                     autoCapture: true,
//                     onImage: (image) {
//                       setState(() {
//                         _image = base64Encode(image);
//                       });
//                     },
//                     onInputImage: (inputImage) async {
//                       showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (context) => const Center(
//                           child: CircularProgressIndicator(
//                             color: accentColor,
//                           ),
//                         ),
//                       );
//                       _faceFeatures =
//                           await extractFaceFeatures(inputImage, _faceDetector);
//                       setState(() {});
//                       if (mounted) Navigator.of(context).pop();
//                     },
//                   ),
//                   const Spacer(),
//                   if (_image != null)
//                     CustomButton(
//                       text: "Start Registering",
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) => EnterDetailsView(
//                               image: _image!,
//                               faceFeatures: _faceFeatures!,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:face_auth/common/utils/extract_face_feature.dart';
// import 'package:face_auth/common/views/camera_view.dart';
// import 'package:face_auth/common/views/custom_button.dart';
// import 'package:face_auth/constants/theme.dart';
// import 'package:face_auth/model/user_model.dart';
// import 'package:face_auth/register_face/enter_details_view.dart';
import 'dart:convert';
import 'dart:io';

import 'package:face_auth/common/utils/extensions/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:path_provider/path_provider.dart';

import '../common/views/custom_button.dart';
import '../constants/theme.dart';
import 'enter_details_view.dart';

class RegisterFaceView extends StatefulWidget {
  const RegisterFaceView({Key? key}) : super(key: key);

  @override
  State<RegisterFaceView> createState() => _RegisterFaceViewState();
}

class _RegisterFaceViewState extends State<RegisterFaceView> {
  // final FaceDetector _faceDetector = FaceDetector(
  //   options: FaceDetectorOptions(
  //     enableLandmarks: true,
  //     performanceMode: FaceDetectorMode.accurate,
  //   ),
  // );
  File? temp;
  String? _image;

  var image1 = new Regula.MatchFacesImage();
  var img1 = Image.asset('assets/images/portrait.png');

  // FaceFeatures? _faceFeatures;

  // var image1 = new Regula.MatchFacesImage();

  bool? get first => null;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    const EventChannel('flutter_face_api/event/video_encoder_completion')
        .receiveBroadcastStream()
        .listen((event) {
      var response = jsonDecode(event);
      String transactionId = response["transactionId"];
      bool success = response["success"];
      print("video_encoder_completion:");
      print("    success: $success");
      print("    transactionId: $transactionId");
    });
  }

  Future<void> initPlatformState() async {
    Regula.FaceSDK.init().then((json) {
      var response = jsonDecode(json);
      if (!response["success"]) {
        print("Init failed: ");
        print(json);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text("Register User"),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constrains) => Stack(
          children: [
            Container(
              width: constrains.maxWidth,
              height: constrains.maxHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    scaffoldTopGradientClr,
                    scaffoldBottomGradientClr,
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 0.9.sh,
                      width: double.infinity,
                      padding:
                          EdgeInsets.fromLTRB(0.05.sw, 0.025.sh, 0.05.sw, 0),
                      decoration: BoxDecoration(
                        color: overlayContainerClr,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(0.03.sh),
                          topRight: Radius.circular(0.03.sh),
                        ),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 0.82.sh,
                                width: double.infinity,
                                padding: EdgeInsets.fromLTRB(
                                    0.05.sw, 0.025.sh, 0.05.sw, 0.04.sh),
                                decoration: BoxDecoration(
                                  color: overlayContainerClr,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(0.03.sh),
                                    topRight: Radius.circular(0.03.sh),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.camera_alt_outlined,
                                          color: primaryWhite,
                                          size: 0.038.sh,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 0.025.sh),
                                    img1.image != null
                                        ? CircleAvatar(
                                            radius: 0.15.sh,
                                            backgroundColor:
                                                const Color(0xffD9D9D9),
                                            backgroundImage: img1.image,
                                          )
                                        : CircleAvatar(
                                            radius: 0.15.sh,
                                            backgroundColor:
                                                const Color(0xffD9D9D9),
                                            backgroundImage: AssetImage(
                                                'assets/images/selfie.png'),
                                            child: Icon(
                                              Icons.camera_alt,
                                              size: 0.09.sh,
                                              color: const Color(0xff2E2E2E),
                                            ),
                                          ),
                                    Container(
                                      width: 60,
                                      height: 60,
                                      margin: const EdgeInsets.only(
                                          top: 44, bottom: 20),
                                      decoration: const BoxDecoration(
                                        gradient: RadialGradient(
                                          stops: [0.4, 0.65, 1],
                                          colors: [
                                            Color(0xffD9D9D9),
                                            primaryWhite,
                                            Color(0xffD9D9D9),
                                          ],
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: TextButton(
                                          child: Text(
                                            "",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color:
                                                  primaryWhite.withOpacity(0.9),
                                            ),
                                          ),
                                          onPressed: () {
                                            Regula.FaceSDK
                                                    .presentFaceCaptureActivity()
                                                .then((result) => setImage(
                                                    true,
                                                    base64Decode(
                                                        Regula.FaceCaptureResponse
                                                                .fromJson(json
                                                                    .decode(
                                                                        result))!
                                                            .image!
                                                            .bitmap!
                                                            .replaceAll(
                                                                "\n", "")),
                                                    Regula.ImageType.LIVE));
                                            // Navigator.pop(context);
                                          }),
                                    ),
                                    Text(
                                      "Click here to Capture",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: primaryWhite.withOpacity(0.9),
                                      ),
                                    ),
                                    // Text(_similarity),
                                    const Spacer(),
                                    img1.image != null
                                        ? CustomButton(
                                            text: "Start Registering",
                                            onTap: () {
                                              print(image1.toJson());

                                              Map tempData = image1.toJson();
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EnterDetailsView(
                                                    image: temp!,
                                                    imageJSON: tempData,
                                                    // faceFeatures: _faceFeatures!,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : Text("")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  setImage(bool first, Uint8List? imageFile, int type) async {
    print("start1 ");
    if (imageFile == null) return;
    print("start2  ");
    // setState(() => _similarity = "nil");
    // if (first) {
    print("start3  ");
    print(imageFile);
    Uint8List imageInUnit8List = imageFile; // store unit8List image here ;
    final tempDir = await getTemporaryDirectory();
    File temp2 = await File('${tempDir.path}/image.png').create();
    temp2.writeAsBytesSync(imageInUnit8List);
    setState(() {
      image1.bitmap = base64Encode(imageFile);
      image1.imageType = type;
      temp = temp2;
      img1 = Image.memory(imageFile);

      print(temp);
    });
  }
}
