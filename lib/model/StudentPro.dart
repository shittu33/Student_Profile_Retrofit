import 'package:flutter/material.dart';

class StudentPro {
  static String collectionName = "Students";
  static String fieldName = "Name";
  static String fieldNickName = "Nick name";
  static String fieldAge = "Age";
  static String fieldDept = "Department";
  static String fieldLevel = "Level";
  static String fieldHobby = "Hobby";
  static String fieldImg = "Image Path";
  static String fieldQuote = "Quote";
  @required
  String id;
  String fullName;
  String nickName;
  String dept;
  String imgPath;
  String level;
  String hobby;
  String quote;
  String age;

  StudentPro.simple(this.fullName, this.imgPath);

  StudentPro({
    this.fullName,
    this.nickName,
    this.dept,
    this.imgPath,
    this.level,
    this.hobby,
    this.quote,
    this.age,
  });

  StudentPro.full(this.fullName, this.nickName, this.dept, this.imgPath,
      this.level, this.hobby, this.quote, this.age);

  StudentPro.fullJson(this.id, this.fullName, this.nickName, this.dept,
      this.imgPath, this.level, this.hobby, this.quote, this.age);

  StudentPro.essential(
      this.fullName, this.dept, this.imgPath, this.level, this.age);

  Map<String, dynamic> toMap() => {
        fieldName: fullName.isNotEmpty ? fullName : 'Musa',
        fieldNickName: nickName.isNotEmpty ? nickName : 'Abu Maryam',
        fieldDept: dept.isNotEmpty ? dept : 'CMP',
        fieldImg: imgPath,
        fieldLevel: level.isNotEmpty ? level : '300L',
        fieldHobby: hobby.isNotEmpty ? hobby : 'Football',
        fieldQuote: quote.isNotEmpty ? quote : 'It\'s hard and it worth it',
        fieldAge: age
      };

  List<StudentItem> toBioDataList() {
    return _toConditionList(<bool>(String key) =>
        key == fieldName || key == fieldNickName || key == fieldAge);
  }

  List<StudentItem> toAcademicList() {
    return _toConditionList(
        <bool>(String key) => key == fieldDept || key == fieldLevel);
  }

  List<StudentItem> toSocialList() {
    return _toConditionList(
        <bool>(String key) => key == fieldHobby || key == fieldQuote);
  }

  List<StudentItem> _toConditionList(Function<bool>(String) conditions) {
    List<StudentItem> studentDetails = [];
    studentDetails.clear();
    toMap().forEach((key, value) {
      if (conditions(key)) {
//        if (key == fieldAge) {
//          value  = "${(value as Timestamp).toDate().toLocal()}".split(' ')[0];
//        }
        studentDetails.add(StudentItem(key, value));
      }
    });
    return studentDetails;
  }

  List<StudentItem> toList() {
    List<StudentItem> studentDetails = [];
    studentDetails.clear();
    toMap().forEach((String key, value) {
      if (key == fieldAge) {
        value = value.toString();
      }
      studentDetails.add(StudentItem(key, value));
    });
    return studentDetails;
  }

  factory StudentPro.fromMap(Map<String, dynamic> data) {
    if (data.isEmpty) {
      return null;
    }
    return StudentPro.full(
      data[fieldName],
      data[fieldNickName],
      data[fieldDept],
      data[fieldImg],
      data[fieldLevel],
      data[fieldHobby],
      data[fieldQuote],
      data[fieldAge],
    );
  }

  factory StudentPro.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return null;
    }
    var root = 'fields';

    List split = (json['name'] as String).split("/");
    return StudentPro.fullJson(
      split.last,
      json[root][fieldName]["stringValue"],
      json[root][fieldNickName]["stringValue"],
      json[root][fieldDept]["stringValue"],
      json[root][fieldImg]["stringValue"],
      json[root][fieldLevel]["stringValue"],
      json[root][fieldHobby]["stringValue"],
      json[root][fieldQuote]["stringValue"],
      json[root][fieldAge]["timestampValue"],
    );
  }

  Map<String, dynamic> toJson() => {
        "fields": {
          fieldName: {
            "stringValue": (fullName!=null && fullName.isNotEmpty) ? fullName : 'Mukaila Isa'
          },
          fieldNickName: {
            "stringValue": nickName!=null && nickName.isNotEmpty ? nickName : 'Abu Maryam'
          },
          fieldDept: {"stringValue": dept!=null &&  dept.isNotEmpty ? dept : 'CMP'},
          fieldImg: {
            "stringValue": imgPath!=null && imgPath.isNotEmpty
                ? imgPath
                : "https://firebasestorage.googleapis.com/v0/b/myflutter2-b7088.appspot.com/o/student_img%2Fimage_picker4159137354018842457.jpg?alt=media"
          },
          fieldLevel: {"stringValue": level!=null &&  level.isNotEmpty ? level : '300L'},
          fieldHobby: {"stringValue": hobby!=null && hobby.isNotEmpty ? hobby : 'Football'},
          fieldQuote: {
            "stringValue":quote!=null &&
                quote.isNotEmpty ? quote : 'It\'s hard and it worth it'
          },
          fieldAge: {
              "timestampValue": age!=null && age.isNotEmpty ? age : "1998-08-24T23:00:00Z"
          }
        }
      };
}

class StudentItem {
  String label;
  String content;

  StudentItem(this.label, this.content);
}
