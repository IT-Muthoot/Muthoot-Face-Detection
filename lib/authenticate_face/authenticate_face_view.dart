// import 'dart:convert';
// import 'dart:developer';
// import 'dart:math' as math;
//
// import 'package:audioplayers/audioplayers.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:face_auth/authenticate_face/scanning_animation/animated_view.dart';
// import 'package:face_auth/authenticate_face/user_details_view.dart';
// import 'package:face_auth/common/utils/custom_snackbar.dart';
// import 'package:face_auth/common/utils/extensions/size_extension.dart';
// import 'package:face_auth/common/utils/extract_face_feature.dart';
// import 'package:face_auth/constants/theme.dart';
// import 'package:face_auth/model/user_model.dart';
// // import 'package:face_camera/face_camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_face_api/face_api.dart' as regula;
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
//
// import '../common/views/camera_view.dart';
//
// class AuthenticateFaceView extends StatefulWidget {
//   const AuthenticateFaceView({Key? key}) : super(key: key);
//
//   @override
//   State<AuthenticateFaceView> createState() => _AuthenticateFaceViewState();
// }
//
// class _AuthenticateFaceViewState extends State<AuthenticateFaceView> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   final FaceDetector _faceDetector = FaceDetector(
//     options: FaceDetectorOptions(
//       enableLandmarks: true,
//       performanceMode: FaceDetectorMode.accurate,
//     ),
//   );
//   FaceFeatures? _faceFeatures;
//   var image1 = regula.MatchFacesImage();
//   var image2 = regula.MatchFacesImage();
//
//   final TextEditingController _nameController = TextEditingController();
//   String _similarity = "";
//   bool _canAuthenticate = false;
//   List<dynamic> users = [];
//   bool userExists = false;
//   UserModel? loggingUser;
//   bool isMatching = false;
//   int trialNumber = 1;
//
//   @override
//   void dispose() {
//     _faceDetector.close();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   get _playScanningAudio => _audioPlayer
//     ..setReleaseMode(ReleaseMode.loop)
//     ..play(AssetSource("scan_beep.wav"));
//
//   get _playFailedAudio => _audioPlayer
//     ..stop()
//     ..setReleaseMode(ReleaseMode.release)
//     ..play(AssetSource("failed.mp3"));
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: appBarColor,
//         title: const Text("Authenticate Face"),
//         elevation: 0,
//       ),
//       body: LayoutBuilder(
//         builder: (context, constrains) => Stack(
//           children: [
//             Container(
//               width: constrains.maxWidth,
//               height: constrains.maxHeight,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     scaffoldTopGradientClr,
//                     scaffoldBottomGradientClr,
//                   ],
//                 ),
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: SingleChildScrollView(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Container(
//                       height: 0.9.sh,
//                       width: double.infinity,
//                       padding:
//                           EdgeInsets.fromLTRB(0.05.sw, 0.025.sh, 0.05.sw, 0),
//                       decoration: BoxDecoration(
//                         color: overlayContainerClr,
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(0.03.sh),
//                           topRight: Radius.circular(0.03.sh),
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           Stack(
//                             children: [
//                               CameraView(
//                                 autoCapture: true,
//                                 onImage: (image) {
//                                   print(image);
//                                   _setImage(image);
//                                 },
//                                 onInputImage: (inputImage) async {
//                                   setState(() => isMatching = true);
//                                   _faceFeatures = await extractFaceFeatures(
//                                       inputImage, _faceDetector);
//                                   setState(() => isMatching = false);
//                                 },
//                               ),
//                               // SmartFaceCamera(
//                               //     autoCapture: true,
//                               //     defaultCameraLens: CameraLens.front,
//                               //     onCapture: (image) {
//                               //       setState(() => image);
//                               //     },
//                               //     onFaceDetected: (Face? inputImage) async {
//                               //       setState(() => isMatching = true);
//                               //       _faceFeatures = await extractFaceFeatures(
//                               //           inputImage as InputImage,
//                               //           _faceDetector);
//                               //       setState(() => isMatching = false);
//                               //     },
//                               //     messageBuilder: (context, inputImage) {
//                               //       if (inputImage == null) {
//                               //         return _message(
//                               //             'Place your face in the camera');
//                               //       }
//                               //       if (!inputImage.wellPositioned) {
//                               //         return _message(
//                               //             'Center your face in the square');
//                               //       }
//                               //       return const SizedBox.shrink();
//                               //     }),
//                               if (isMatching)
//                                 Align(
//                                   alignment: Alignment.center,
//                                   child: Padding(
//                                     padding: EdgeInsets.only(top: 0.064.sh),
//                                     child: const AnimatedView(),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           // const Spacer(),
//                           // if (_canAuthenticate)
//                           //   CustomButton(
//                           //     text: "Authenticate",
//                           //     onTap: () {
//                           //       setState(() => isMatching = true);
//                           //       _playScanningAudio;
//                           //       _fetchUsersAndMatchFace();
//                           //     },
//                           //   ),
//                           // SizedBox(height: 0.038.sh),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future _setImage(Uint8List imageToAuthenticate) async {
//     image2.bitmap = base64Encode(imageToAuthenticate);
//     image2.imageType = regula.ImageType.PRINTED;
//
//     setState(() {
//       _canAuthenticate = true;
//       isMatching = true;
//       _playScanningAudio;
//       _fetchUsersAndMatchFace();
//     });
//   }
//
//   double compareFaces(FaceFeatures face1, FaceFeatures face2) {
//     double distEar1 = euclideanDistance(face1.rightEar!, face1.leftEar!);
//     double distEar2 = euclideanDistance(face2.rightEar!, face2.leftEar!);
//
//     double ratioEar = distEar1 / distEar2;
//
//     double distEye1 = euclideanDistance(face1.rightEye!, face1.leftEye!);
//     double distEye2 = euclideanDistance(face2.rightEye!, face2.leftEye!);
//
//     double ratioEye = distEye1 / distEye2;
//
//     double distCheek1 = euclideanDistance(face1.rightCheek!, face1.leftCheek!);
//     double distCheek2 = euclideanDistance(face2.rightCheek!, face2.leftCheek!);
//
//     double ratioCheek = distCheek1 / distCheek2;
//
//     double distMouth1 = euclideanDistance(face1.rightMouth!, face1.leftMouth!);
//     double distMouth2 = euclideanDistance(face2.rightMouth!, face2.leftMouth!);
//
//     double ratioMouth = distMouth1 / distMouth2;
//
//     double distNoseToMouth1 =
//         euclideanDistance(face1.noseBase!, face1.bottomMouth!);
//     double distNoseToMouth2 =
//         euclideanDistance(face2.noseBase!, face2.bottomMouth!);
//
//     double ratioNoseToMouth = distNoseToMouth1 / distNoseToMouth2;
//
//     double ratio =
//         (ratioEye + ratioEar + ratioCheek + ratioMouth + ratioNoseToMouth) / 5;
//     log(ratio.toString(), name: "Ratio");
//
//     return ratio;
//   }
//
// // A function to calculate the Euclidean distance between two points
//   double euclideanDistance(Points p1, Points p2) {
//     final sqr =
//         math.sqrt(math.pow((p1.x! - p2.x!), 2) + math.pow((p1.y! - p2.y!), 2));
//     return sqr;
//   }
//
//   _fetchUsersAndMatchFace() {
//     FirebaseFirestore.instance.collection("users").get().catchError((e) {
//       log("Getting User Error: $e");
//       setState(() => isMatching = false);
//       _playFailedAudio;
//       CustomSnackBar.errorSnackBar("Something went wrong. Please try again.");
//     }).then((snap) {
//       if (snap.docs.isNotEmpty) {
//         users.clear();
//         log(snap.docs.length.toString(), name: "Total Registered Users");
//         for (var doc in snap.docs) {
//           UserModel user = UserModel.fromJson(doc.data());
//           double similarity = compareFaces(_faceFeatures!, user.faceFeatures!);
//           if (similarity >= 0.8 && similarity <= 1.5) {
//             users.add([user, similarity]);
//           }
//         }
//         log(users.length.toString(), name: "Filtered Users");
//         setState(() {
//           //Sorts the users based on the similarity.
//           //More similar face is put first.
//           users.sort((a, b) => (((a.last as double) - 1).abs())
//               .compareTo(((b.last as double) - 1).abs()));
//         });
//
//         _matchFaces();
//       } else {
//         _showFailureDialog(
//           title: "No Users Registered",
//           description:
//               "Make sure users are registered first before Authenticating.",
//         );
//       }
//     });
//   }

//   _matchFaces() async {
//     bool faceMatched = false;
//     for (List user in users) {
//       image1.bitmap = (user.first as UserModel).image;
//       image1.imageType = regula.ImageType.PRINTED;
//
//       //Face comparing logic.
//       var request = regula.MatchFacesRequest();
//       request.images = [image1, image2];
//       dynamic value = await regula.FaceSDK.matchFaces(jsonEncode(request));
//
//       var response = regula.MatchFacesResponse.fromJson(json.decode(value));
//       dynamic str = await regula.FaceSDK.matchFacesSimilarityThresholdSplit(
//           jsonEncode(response!.results), 0.75);
//
//       var split =
//           regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
//       setState(() {
//         _similarity = split!.matchedFaces.isNotEmpty
//             ? (split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)
//             : "error";
//         log("similarity: $_similarity");
//
//         if (_similarity != "error" && double.parse(_similarity) > 90.00) {
//           faceMatched = true;
//           loggingUser = user.first;
//         } else {
//           faceMatched = false;
//         }
//       });
//       if (faceMatched) {
//         _audioPlayer
//           ..stop()
//           ..setReleaseMode(ReleaseMode.release)
//           ..play(AssetSource("success.mp3"));
//
//         setState(() {
//           trialNumber = 1;
//           isMatching = false;
//         });
//
//         if (mounted) {
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => UserDetailsView(user: loggingUser!),
//             ),
//           );
//         }
//         break;
//       }
//     }
//     if (!faceMatched) {
//       if (trialNumber == 4) {
//         setState(() => trialNumber = 1);
//         _showFailureDialog(
//           title: "Redeem Failed",
//           description: "Face doesn't match. Please try again.",
//         );
//       } else if (trialNumber == 3) {
//         //After 2 trials if the face doesn't match automatically, the registered name prompt
//         //will be shown. After entering the name the face registered with the entered name will
//         //be fetched and will try to match it with the to be authenticated face.
//         //If the faces match, Viola!. Else it means the user is not registered yet.
//         _audioPlayer.stop();
//         setState(() {
//           isMatching = false;
//           trialNumber++;
//         });
//         showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: const Text("Enter Name"),
//                 content: TextFormField(
//                   controller: _nameController,
//                   cursorColor: accentColor,
//                   decoration: InputDecoration(
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         width: 2,
//                         color: accentColor,
//                       ),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         width: 2,
//                         color: accentColor,
//                       ),
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       if (_nameController.text.trim().isEmpty) {
//                         CustomSnackBar.errorSnackBar("Enter a name to proceed");
//                       } else {
//                         Navigator.of(context).pop();
//                         setState(() => isMatching = true);
//                         _playScanningAudio;
//                         _fetchUserByName(_nameController.text.trim());
//                       }
//                     },
//                     child: const Text(
//                       "Done",
//                       style: TextStyle(
//                         color: accentColor,
//                       ),
//                     ),
//                   )
//                 ],
//               );
//             });
//       } else {
//         setState(() => trialNumber++);
//         _showFailureDialog(
//           title: "Redeem Failed",
//           description: "Face doesn't match. Please try again.",
//         );
//       }
//     }
//   }
//
//   _fetchUserByName(String orgID) {
//     FirebaseFirestore.instance
//         .collection("users")
//         .where("organizationId", isEqualTo: orgID)
//         .get()
//         .catchError((e) {
//       log("Getting User Error: $e");
//       setState(() => isMatching = false);
//       _playFailedAudio;
//       CustomSnackBar.errorSnackBar("Something went wrong. Please try again.");
//     }).then((snap) {
//       if (snap.docs.isNotEmpty) {
//         users.clear();
//
//         for (var doc in snap.docs) {
//           setState(() {
//             users.add([UserModel.fromJson(doc.data()), 1]);
//           });
//         }
//         _matchFaces();
//       } else {
//         setState(() => trialNumber = 1);
//         _showFailureDialog(
//           title: "User Not Found",
//           description:
//               "User is not registered yet. Register first to authenticate.",
//         );
//       }
//     });
//   }
//
//   _showFailureDialog({
//     required String title,
//     required String description,
//   }) {
//     _playFailedAudio;
//     setState(() => isMatching = false);
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(description),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 "Ok",
//                 style: TextStyle(
//                   color: accentColor,
//                 ),
//               ),
//             )
//           ],
//         );
//       },
//     );
//   }
//
//   Widget _message(String msg) => Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
//         child: Text(msg,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//                 fontSize: 14, height: 1.5, fontWeight: FontWeight.w400)),
//       );
// }

import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_auth/authenticate_face/user_details_view.dart';
import 'package:face_auth/common/utils/extensions/size_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_api/face_api.dart' as Regula;
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../common/utils/custom_text_field.dart';
import '../constants/theme.dart';

class AuthenticateFaceView extends StatefulWidget {
  const AuthenticateFaceView({Key? key}) : super(key: key);

  @override
  State<AuthenticateFaceView> createState() => _AuthenticateFaceViewState();
}

class _AuthenticateFaceViewState extends State<AuthenticateFaceView> {
  // final AudioPlayer _audioPlayer = AudioPlayer();
  // final FaceDetector _faceDetector = FaceDetector(
  //   options: FaceDetectorOptions(
  //     enableLandmarks: true,
  //     performanceMode: FaceDetectorMode.accurate,
  //   ),
  // );
  // FaceFeatures? _faceFeatures;
  // var image1 = regula.MatchFacesImage();
  // var image2 = regula.MatchFacesImage();

  String? _image;
  // var image1 = new Regula.MatchFacesImage();
  // var image1 = new Regula.MatchFacesImage();
  // var img1 = Image.asset('assets/images/portrait.png');
  var image2 = new Regula.MatchFacesImage();
  var img2 = Image.asset('assets/images/portrait.png');

  final TextEditingController _empCodeController = TextEditingController();
  final _empCodeFieldKey = GlobalKey<FormFieldState>();
  String _similarity = "";
  bool _canAuthenticate = false;
  List<dynamic> users = [];
  bool userExists = false;
  // UserModel? loggingUser;
  bool isMatching = false;
  int trialNumber = 1;
  List<Map<String, dynamic>> userList = [];

  fetchData() {
    FirebaseFirestore.instance.collection("users").get().then((userListDoc) {
      print(userListDoc.docs);
      for (var list in userListDoc.docs) {
        // print(list.data());
        setState(() {
          userList.add(list.data());
        });
      }
      print("data lisr");
      print(userList);
    });
  }

  openFaceCamera() {
    // FirebaseFirestore.instance
    //     .collection("users")
    //     .get()
    //     .then((userListDoc) async {
    //   setState(() {
    //     userList = userListDoc;
    //   });
    // });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Regula.FaceSDK.presentFaceCaptureActivity().then((result) => setImage(
          false,
          base64Decode(Regula.FaceCaptureResponse.fromJson(json.decode(result))!
              .image!
              .bitmap!
              .replaceAll("\n", "")),
          Regula.ImageType.LIVE));
    });
  }

  @override
  void dispose() {
    // _faceDetector.close();
    // _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    // openFaceCamera();
  }
  //
  // get _playScanningAudio => _audioPlayer
  //   ..setReleaseMode(ReleaseMode.loop)
  //   ..play(AssetSource("scan_beep.wav"));
  //
  // get _playFailedAudio => _audioPlayer
  //   ..stop()
  //   ..setReleaseMode(ReleaseMode.release)
  //   ..play(AssetSource("failed.mp3"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: appBarColor,
        title: const Text("Authenticate Face"),
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
                                    img2.image != null
                                        ? CircleAvatar(
                                            radius: 0.15.sh,
                                            backgroundColor:
                                                const Color(0xffD9D9D9),
                                            backgroundImage: img2.image,
                                          )
                                        : CircleAvatar(
                                            radius: 0.15.sh,
                                            backgroundColor:
                                                const Color(0xffD9D9D9),
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
                                                    false,
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
                                    CustomTextField(
                                      formFieldKey: _empCodeFieldKey,
                                      controller: _empCodeController,
                                      hintText: "Employee Code",
                                      validatorText:
                                          "Employee code cannot be empty",
                                    ),
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

  matchFaces() async {
    SmartDialog.showLoading(msg: "Loading...");
    var registeredImage = Regula.MatchFacesImage();
    bool verified = false;
    var _similarity = "Processing...";
    var authJson;
    var name;
    for (var list = 0; list < userList.length; list++) {
      // if (_empCodeController.text == userList[list]['empCode']) {
        authJson = userList[list]['auth_json'];
        name = userList[list]['name'];

        print(userList[list]);
        // if (authJson != null) {
          print(authJson);
          print("started -------------------------------------");
          registeredImage.bitmap = authJson["bitmap"];
          registeredImage.imageType = authJson["imageType"];

          if (registeredImage.bitmap == null ||
              registeredImage.bitmap == "" ||
              image2.bitmap == null ||
              image2.bitmap == "") return;

          var request = Regula.MatchFacesRequest();

          request.images = [registeredImage, image2];
          var value = await Regula.FaceSDK.matchFaces(jsonEncode(request));
          var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
          var str = await Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
              jsonEncode(response!.results), 0.75);
          var split =
          Regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
          print(split);

          _similarity = split!.matchedFaces.length > 0
              ? ((split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2) +
              "%")
              : "error";

          print(_similarity);

          print("STATUS");
          print(_similarity);
          print("end -------------------------------------");
          if (_similarity != 'error') {
            print("DONE --");
            SmartDialog.dismiss();
            verified = true;
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => UserDetailsView(
                    image: img2,
                    user: name,
                  )),
            );
            verified = true;
            break;
          }

          // if (!verified) {
          //   SmartDialog.dismiss();
          //   _showFailureDialog(
          //     title: "No Users Registered",
          //     description:
          //     "Make sure users are registered first before Authenticating.",
          //   );
          // }
        // } else {
        //   SmartDialog.dismiss();
        //   _showFailureDialog(
        //     title: "No Users Registered",
        //     description:
        //     "Make sure users are registered first before Authenticating.",
        //   );
        // }

      // }
    }

    if (!verified) {
      SmartDialog.dismiss();
      _showFailureDialog(
        title: "No Users Registered",
        description:
        "Make sure users are registered first before Authenticating.",
      );
    }

  }

  _showFailureDialog({
    required String title,
    required String description,
  }) {
    // _playFailedAudio;
    setState(() => isMatching = false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Ok",
                style: TextStyle(
                  color: accentColor,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  setImage(bool first, Uint8List? imageFile, int type) {
    if (imageFile == null) return;
    setState(() => _similarity = "nil");
    // if (first) {
    //   // image1.bitmap = base64Encode(imageFile);
    //   // image1.imageType = type;
    //   // setState(() {
    //   //   img1 = Image.memory(imageFile);
    //   //   _liveness = "nil";
    //   // });
    // } else {

    setState(() {
      image2.bitmap = base64Encode(imageFile);
      image2.imageType = type;
      img2 = Image.memory(imageFile);
    });
    matchFaces();
    // }
  }
}
// matchFaces() async {
//   SmartDialog.showLoading(msg: "Loading...");
//
//   var registeredImage = Regula.MatchFacesImage();
//
//   bool verified = false;
//   var _similarity = "Processing...";
//
//   final userDataBox = Hive.box<userdata>('userDataDetails');
//   final userDataList = userDataBox.values.toList();
//   for (final userData in userDataList) {
//     print(
//         'Name: ${userData.name}, Employee: ${userData.empCode},Image: ${userData.image.bitmap}, Type: ${userData.image.type}');
//     var authJson = userData.image.toJson();
//     registeredImage.bitmap = authJson['bitmap'];
//     registeredImage.imageType = authJson['type'];
//
//     if (registeredImage.bitmap == null ||
//         registeredImage.bitmap == "" ||
//         image2.bitmap == null ||
//         image2.bitmap == "") return;
//
//     var request = Regula.MatchFacesRequest();
//
//     request.images = [registeredImage, image2];
//     var value = await Regula.FaceSDK.matchFaces(jsonEncode(request));
//     var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
//     var str = await Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
//         jsonEncode(response!.results), 0.75);
//     var split =
//         Regula.MatchFacesSimilarityThresholdSplit.fromJson(json.decode(str));
//     print(split);
//
//     _similarity = split!.matchedFaces.length > 0
//         ? ((split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2) +
//             "%")
//         : "error";
//
//     print(_similarity);
//
//     print("STATUS");
//     print(_similarity);
//     if (_similarity != 'error') {
//       print("DONE --");
//       // print(userList.docs[list]['name']);
//       SmartDialog.dismiss();
//       verified = true;
//       if (mounted) {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//               builder: (context) => UserDetailsView(
//                     image: img2,
//                     user: "${userData.name}",
//                   )),
//         );
//       }
//       break;
//     }
//   }
//   if (!verified) {
//     SmartDialog.dismiss();
//     _showFailureDialog(
//       title: "No Users Registered",
//       description:
//           "Make sure users are registered first before Authenticating.",
//     );
//   }
// }

//     for (var list = 0; list < userList.docs.length; list++) {
//       print("-----------------loop$list");
//       print(userList);
//
//       var authJson = userList.docs[list]["auth_json"];
//       print(authJson);
//       //----> final responsefront = await http.get(Uri.parse(url));
//       // final tempDir = await getTemporaryDirectory();
//       // File imageFirst = await File('${tempDir.path}/image.png').create();
//       // imageFirst.writeAsBytesSync(responsefront.bodyBytes);
//
//       registeredImage.bitmap = authJson["bitmap"];
//       registeredImage.imageType = authJson["imageType"];
//
//       if (registeredImage.bitmap == null ||
//           registeredImage.bitmap == "" ||
//           image2.bitmap == null ||
//           image2.bitmap == "") return;
//
//       var request = Regula.MatchFacesRequest();
//
//       request.images = [registeredImage, image2];
//       var value = await Regula.FaceSDK.matchFaces(jsonEncode(request));
//       var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
//       var str = await Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
//           jsonEncode(response!.results), 0.75);
//       var split = Regula.MatchFacesSimilarityThresholdSplit.fromJson(
//           json.decode(str));
//       print(split);
//
//       _similarity = split!.matchedFaces.length > 0
//           ? ((split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2) +
//               "%")
//           : "error";
//
//       print(_similarity);
//
//       print("STATUS");
//       print(_similarity);
//       if (_similarity != 'error') {
//         print("DONE --");
//         print(userList.docs[list]['name']);
//         SmartDialog.dismiss();
//         verified = true;
//         Navigator.of(context).push(
//           MaterialPageRoute(
//               builder: (context) => UserDetailsView(
//                     image: img2,
//                     user: userList.docs[list]['name'],
//                   )),
//         );
//         break;
//       }
//     }
//   if (!verified) {
//     SmartDialog.dismiss();
//     _showFailureDialog(
//       title: "No Users Registered",
//       description:
//           "Make sure users are registered first before Authenticating.",
//     );
//   }
// }
