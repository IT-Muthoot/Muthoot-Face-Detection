import 'package:hive/hive.dart';

part 'userdata.g.dart';

@HiveType(typeId: 0)
class userdata extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String empCode;
  @HiveField(2)
  ImageJson image;

  userdata(
    this.name,
    this.empCode,
    this.image,
  );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'empCode': empCode,
      'image': image.toJson(),
    };
  }
}

@HiveType(typeId: 0)
class ImageJson {
  @HiveField(0)
  final String bitmap;
  @HiveField(1)
  final int type;

  ImageJson(this.bitmap, this.type);

  Map<String, dynamic> toJson() {
    return {
      'bitmap': bitmap,
      'type': type,
    };
  }
}

// Map<String, dynamic> toJson() {
//   return {
//     'bitMap': bitMap,
//     'type': type,
//   };
// }
