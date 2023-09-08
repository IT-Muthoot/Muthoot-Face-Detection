//
// @HiveType(typeId: 0)
// class userdata {
//   @HiveField(0)
//   int id;
//   @HiveField(1)
//   String name;
//   @HiveField(2)
//   DateTime empCode;
//   @HiveField(3)
//   DateTime registeredOn;
//   userdata(this.id, this.name, this.empCode, this.registeredOn);
// }

// class UserModel {
//   String? id;
//   String? name;
//   String? empCode;
//   Image? image;
//   int? registeredOn;
//
//   UserModel({
//     this.id,
//     this.name,
//     this.empCode,
//     this.image,
//     this.registeredOn,
//   });
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['id'],
//       name: json['name'],
//       empCode: json['empCode'],
//       image: json['image'],
//       registeredOn: json['registeredOn'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'empCode': empCode,
//       'image': image,
//       'registeredOn': registeredOn,
//     };
//   }
// }

// class FaceFeatures {
//   Points? rightEar;
//   Points? leftEar;
//   Points? rightEye;
//   Points? leftEye;
//   Points? rightCheek;
//   Points? leftCheek;
//   Points? rightMouth;
//   Points? leftMouth;
//   Points? noseBase;
//   Points? bottomMouth;
//
//   FaceFeatures({
//     this.rightMouth,
//     this.leftMouth,
//     this.leftCheek,
//     this.rightCheek,
//     this.leftEye,
//     this.rightEar,
//     this.leftEar,
//     this.rightEye,
//     this.noseBase,
//     this.bottomMouth,
//   });
//
//   factory FaceFeatures.fromJson(Map<String, dynamic> json) => FaceFeatures(
//         rightMouth: Points.fromJson(json["rightMouth"]),
//         leftMouth: Points.fromJson(json["leftMouth"]),
//         leftCheek: Points.fromJson(json["leftCheek"]),
//         rightCheek: Points.fromJson(json["rightCheek"]),
//         leftEye: Points.fromJson(json["leftEye"]),
//         rightEar: Points.fromJson(json["rightEar"]),
//         leftEar: Points.fromJson(json["leftEar"]),
//         rightEye: Points.fromJson(json["rightEye"]),
//         noseBase: Points.fromJson(json["noseBase"]),
//         bottomMouth: Points.fromJson(json["bottomMouth"]),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "rightMouth": rightMouth?.toJson() ?? {},
//         "leftMouth": leftMouth?.toJson() ?? {},
//         "leftCheek": leftCheek?.toJson() ?? {},
//         "rightCheek": rightCheek?.toJson() ?? {},
//         "leftEye": leftEye?.toJson() ?? {},
//         "rightEar": rightEar?.toJson() ?? {},
//         "leftEar": leftEar?.toJson() ?? {},
//         "rightEye": rightEye?.toJson() ?? {},
//         "noseBase": noseBase?.toJson() ?? {},
//         "bottomMouth": bottomMouth?.toJson() ?? {},
//       };
// }
//
// class Points {
//   int? x;
//   int? y;
//
//   Points({
//     required this.x,
//     required this.y,
//   });
//
//   factory Points.fromJson(Map<String, dynamic> json) => Points(
//         x: (json['x'] ?? 0) as int,
//         y: (json['y'] ?? 0) as int,
//       );
//
//   Map<String, dynamic> toJson() => {'x': x, 'y': y};
// }