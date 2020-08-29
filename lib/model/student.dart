import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:studentprofileretrofit/config.dart';
part 'student.g.dart';

const API_VERSION = "v1";
const COLLECTION_NAME = "Students";
const FIREBASE_BASE_URL = "firestore.googleapis.com";
const  collectionName = "Students";
const  fieldName = "Name";
const  fieldNickName = "Nick name";
const  fieldAge = "Age";
const  fieldDept = "Department";
const  fieldLevel = "Level";
const  fieldHobby = "Hobby";
const  fieldImg = "Image Path";
const  fieldQuote = "Quote";

@RestApi(
    baseUrl:
        "https://$FIREBASE_BASE_URL/$API_VERSION/projects/$PROJECT_NAME/databases/(default)/documents/")
abstract class StudentClient {
  factory StudentClient(Dio dio) = _StudentClient;

  @GET("/$COLLECTION_NAME/?key=$API_KEY")
  Future<FirebaseDocument> getDocuments();

  @GET("/$COLLECTION_NAME/{name}?key=$API_KEY")
  Future<StudentRecord> getStudent(@Path("name") String name);

  @POST("/$COLLECTION_NAME/?key=$API_KEY")
  Future<StudentRecord> addStudent(@Body() Map<String, dynamic> record);

  @PATCH("/$COLLECTION_NAME/{name}/?key=$API_KEY")
  Future<StudentRecord> updateStudent(
      @Path("name") String id, @Body() StudentRecord studentRecord);

  @DELETE("/$COLLECTION_NAME/{name}/?key=$API_KEY")
  Future<void> deleteStudent(@Path("name") String id);
}

class StudentDao {
  Dio dio;
  StudentClient client;

  StudentDao() {
    dio = Dio();
    client = StudentClient(dio);
  }

  Future<Student> addStudent(Student student) {
    var json = student.toRecords().toJson();
    json.remove("name");
    return client.addStudent(json).then((record) => record.toStudent());
  }

  Future<Student> updateStudent(Student student) {
    return client
        .updateStudent(student.id, student.toRecords())
        .then((record) => record.toStudent());
  }

  Future<void> deleteStudent(String id) {
    return client.deleteStudent(id);
  }

  Future<Student> getStudent(String name) {
    return client.getStudent(name).then((studentsRecord) {
      var studentDetails = studentsRecord.student;
      studentDetails.id = studentsRecord.name.split("/").last;
      return studentDetails.toStudent();
    });
  }

  Future<List<Student>> getStudents() => client
      .getDocuments()
      .then((documents) => documents.documents.map((studentsRecord) {
            var studentDetails = studentsRecord.student;
            studentDetails.id = studentsRecord.name.split("/").last;
            return studentDetails.toStudent();
          }).toList());
}

@JsonSerializable(explicitToJson: true)
class FirebaseDocument {
  @JsonKey(name: "documents")
  List<StudentRecord> documents;

  FirebaseDocument(this.documents);

  factory FirebaseDocument.fromJson(Map<String, dynamic> json) =>
      _$FirebaseDocumentFromJson(json);

  Map<String, dynamic> toJson() => _$FirebaseDocumentToJson(this);

  @override
  String toString() {
    return '{documents: $documents}';
  }
}

@JsonSerializable(explicitToJson: true)
class StudentRecord {
  String name;
  @JsonKey(name: "fields")
  StudentDetails student;
  String createTime;
  String updateTime;

  StudentRecord({this.name, this.student, this.createTime, this.updateTime});

  factory StudentRecord.fromJson(Map<String, dynamic> json) =>
      _$StudentRecordFromJson(json);

  Map<String, dynamic> toJson() => _$StudentRecordToJson(this);

  Student toStudent() {
    return student.toStudent();
  }

  @override
  String toString() {
    return 'StudentRecord{name: $name, student: $student, createTime: $createTime, updateTime: $updateTime}';
  }
}

@JsonSerializable(explicitToJson: true)
class StudentDetails {
  @JsonKey(ignore: true)
  String id;
  @JsonKey(name: fieldName)
  DetailValue fullName;
  @JsonKey(name: fieldNickName)
  DetailValue nickName;
  @JsonKey(name: fieldDept)
  DetailValue dept;
  @JsonKey(name: fieldImg)
  DetailValue imgPath;
  @JsonKey(name: fieldLevel)
  DetailValue level;
  @JsonKey(name: fieldHobby)
  DetailValue hobby;
  @JsonKey(name: fieldQuote)
  DetailValue quote;
  @JsonKey(name: fieldAge)
  DetailValue age;

  StudentDetails(
      {this.fullName,
      this.nickName,
      this.dept,
      this.imgPath,
      this.level,
      this.hobby,
      this.quote,
      this.age});

  Student toStudent() {
    return Student.full(
      this.id,
      this.fullName.stringValue,
      this.nickName.stringValue,
      this.dept.stringValue,
      this.imgPath.stringValue,
      this.level.stringValue,
      this.hobby.stringValue,
      this.quote.stringValue,
      this.age.timestampValue,
    );
  }

  StudentDetails.full(this.fullName, this.nickName, this.dept, this.imgPath,
      this.level, this.hobby, this.quote, this.age);

  factory StudentDetails.fromJson(Map<String, dynamic> json) =>
      _$StudentDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$StudentDetailsToJson(this);

  @override
  String toString() {
    return 'StudentDetails{ fullName: $fullName, nickName: $nickName, dept: $dept, imgPath: $imgPath, level: $level, hobby: $hobby, quote: $quote, age: $age}';
  }
}

@JsonSerializable()
class DetailValue {
  String stringValue;
  String timestampValue;

  DetailValue({this.stringValue, this.timestampValue});

  factory DetailValue.fromJson(Map<String, dynamic> json) =>
      _$DetailValueFromJson(json);

  Map<String, dynamic> toJson() => _$DetailValueToJson(this);

  @override
  String toString() {
    return 'DetailValue{stringValue: $stringValue, timestampValue: $timestampValue}';
  }
}

@JsonSerializable()
class Student {
  @JsonKey(ignore: true)
  String id;
  @JsonKey(name: fieldName)
  String fullName;
  @JsonKey(name: fieldNickName)
  String nickName;
  @JsonKey(name: fieldDept)
  String dept;
  @JsonKey(name: fieldImg)
  String imgPath;
  @JsonKey(name: fieldLevel)
  String level;
  @JsonKey(name: fieldHobby)
  String hobby;
  @JsonKey(name: fieldQuote)
  String quote;
  @JsonKey(name: fieldAge)
  String age;

  Student.optional(
      {this.id,
      this.fullName,
      this.nickName,
      this.dept,
      this.imgPath,
      this.level,
      this.hobby,
      this.quote,
      this.age});

  Student(this.fullName, this.nickName, this.dept, this.imgPath, this.level,
      this.hobby, this.quote, this.age);

  Student.full(this.id, this.fullName, this.nickName, this.dept, this.imgPath,
      this.level, this.hobby, this.quote, this.age);

  StudentRecord toRecords() {
    return StudentRecord(name: id, student: toDetails());
  }

  StudentDetails toDetails() {
    return StudentDetails.full(
      DetailValue(
          stringValue: (fullName != null && fullName.isNotEmpty)
              ? fullName
              : 'Mukaila Isa'),
      DetailValue(
          stringValue: nickName != null && nickName.isNotEmpty
              ? nickName
              : 'Abu Maryam'),
      DetailValue(stringValue: dept != null && dept.isNotEmpty ? dept : 'CMP'),
      DetailValue(
          stringValue: imgPath != null && imgPath.isNotEmpty
              ? imgPath
              : "https://firebasestorage.googleapis.com/v0/b/myflutter2-b7088.appspot.com/o/student_img%2Fimage_picker4159137354018842457.jpg?alt=media"),
      DetailValue(
          stringValue: level != null && level.isNotEmpty ? level : '300L'),
      DetailValue(
          stringValue: hobby != null && hobby.isNotEmpty ? hobby : 'Football'),
      DetailValue(
          stringValue: quote != null && quote.isNotEmpty
              ? quote
              : 'It\'s hard and it worth it'),
      DetailValue(
          timestampValue:
              age != null && age.isNotEmpty ? age : "1998-08-24T23:00:00Z"),
    );
  }

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);

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
    toJson().forEach((key, value) {
      if (conditions(key)) {
        studentDetails.add(StudentItem(key, value));
      }
    });
    return studentDetails;
  }

  List<StudentItem> toList() {
    List<StudentItem> studentDetails = [];
    studentDetails.clear();
    toJson().forEach((String key, value) {
      studentDetails.add(StudentItem(key, value));
    });
    return studentDetails;
  }

  @override
  String toString() {
    return 'Student{id: $id, fullName: $fullName, nickName: $nickName, dept: $dept, imgPath: $imgPath, level: $level, hobby: $hobby, quote: $quote, age: $age}';
  }
}

class StudentItem {
  String label;
  String content;

  StudentItem(this.label, this.content);
}
