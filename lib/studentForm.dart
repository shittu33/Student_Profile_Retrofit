import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studentprofileretrofit/model/student.dart';
import 'config.dart';
import 'customWidget/TextItem.dart';
import 'helper/GoogleAPIHelper.dart';
import 'helper/GoogleAPIHelper.dart';
import 'helper/GoogleAPIHelper.dart';

class StdFormScreen extends StatefulWidget {
  @override
  _StdFormScreenState createState() => _StdFormScreenState();
}

class _StdFormScreenState extends State<StdFormScreen> {
  bool isLoading = false;
  final _picker = ImagePicker();
  PickedFile _pickedFile;
  final nameController = TextEditingController();
  final nickController = TextEditingController();
  final quoteController = TextEditingController();
  final hobbyController = TextEditingController();
  final levelController = TextEditingController();
  final deptController = TextEditingController();
  int currentStep = 0;
  bool complete = false;
  bool isFirst = true;
  bool isFirstLoad = true;
  bool isUpdate = false;
  String _imgPath = "";
  String _tmpImgPath = "";
  String date = "Date of Birth";
  dynamic student;

  @override
  Widget build(BuildContext context) {
    student = ModalRoute.of(context).settings.arguments;
    if (student != null && student is Student) {
      if (isFirstLoad) {
        isUpdate = true;
        _imgPath = student.imgPath;
        _tmpImgPath = student.imgPath;
        date = student.age;
        isFirstLoad = false;
      }
    }
    var steps = getSteps(student, context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Student Registration"),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.save),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.more_vert),
            )
          ],
        ),
        body: Builder(builder: (context) {
          return Column(
            children: [
              isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: 20,
                    ),
              Stepper(
                steps: steps,
                type: StepperType.vertical,
                currentStep: currentStep,
                onStepContinue: () => next(steps, context),
                onStepCancel: () => cancel(),
                onStepTapped: (step) => goTo(step),
              ),
            ],
          );
        }),
      ),
    );
  }

  getSteps(Student student, BuildContext context) {
    return <Step>[
      Step(
        subtitle: Text("Click on the circle to Select your image"),
        content: GestureDetector(
          onTap: () async {
            if (currentStep == 0) {
              await _picker
                  .getImage(source: ImageSource.gallery)
                  .then((pickedFile) {
                updateImage(pickedFile);
              });
            }
          },
          child: ImageStepWidget(imgPath: _imgPath),
        ),
        title: Text("Image"),
      ),
      Step(
        subtitle: Text("Type Student Bio Data"),
        content: Column(
          children: [
            EditText(
              initialText: isFirst
                  ? (student != null ? student.fullName : "")
                  : (nameController.text),
              label: "Full Name",
              startDrawable: Icons.text_format,
              txtController: nameController,
            ),
            DatePickerBox(
                onTap: () {
                  _selectDate(context);
                },
                label: date),
            EditText(
              initialText: isFirst
                  ? (student != null ? student.nickName : "")
                  : (nickController.text),
              label: "Nick Name",
              startDrawable: Icons.text_format,
              txtController: nickController,
            ),
          ],
        ),
        title: Text("Bio Data"),
      ),
      Step(
        subtitle: Text("Enter Academic Details"),
        content: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            children: [
              EditText(
                  initialText: isFirst
                      ? (student != null ? student.dept : "")
                      : (deptController.text),
                  txtController: deptController,
                  startDrawable: Icons.person_outline,
                  label: "Department"),
              EditText(
                  initialText: isFirst
                      ? (student != null ? student.level : "")
                      : (levelController.text),
                  txtController: levelController,
                  startDrawable: Icons.person_outline,
                  label: "Level"),
            ],
          ),
        ),
        title: Text("Academic Details"),
      ),
      Step(
          content: Column(
            children: [
              EditText(
                  initialText: isFirst
                      ? (student != null ? student.hobby : "")
                      : (hobbyController.text),
                  txtController: hobbyController,
                  startDrawable: Icons.note_add,
                  label: "Hobby"),
              EditText(
                  initialText: isFirst
                      ? (student != null ? student.quote : "")
                      : (quoteController.text),
                  txtController: quoteController,
                  startDrawable: Icons.note_add,
                  label: "Quote"),
            ],
          ),
          title: Text("Social Details"),
          subtitle: Text("Input Student's Social Details ")),
    ];
  }

  updateImage(PickedFile pickedFile) async {
    setState(() {
      this._pickedFile = pickedFile;
      _imgPath = pickedFile.path;
    });
  }

  startLoading() {
    setState(() {
      isLoading = true;
    });
  }

  stopLoading() {
    setState(() {
      isLoading = false;
    });
  }

  next(var steps, BuildContext context) async {
    currentStep + 1 != steps.length
        ? goTo(currentStep + 1)
        : setState(() => complete = true);
    if (complete) {
      if (_imgPath == null || _imgPath.isEmpty) {
        print("You need to add a profile picture");
        showSimpleSnackBar(context, 'You need to add a profile picture',
            actionLabel: 'ok');
        return;
      }
      if (isUpdate && (_tmpImgPath == _imgPath)) {
        quitAndSaveDetails(student.imgPath);
        return;
      }
      startLoading();
      if (isUpdate) {
        http.Response response =
            await deleteImageFromGoogleCloud(BUCKET_NAME, student.imgPath);
        if (response.statusCode > 204) print("unable to delete!!");
      }
      var uniquePath = uniqueStoragePath(_imgPath, folder: "student_img");
      print(uniquePath);
      var response = await uploadByteToGoogleCloud(
          BUCKET_NAME, uniquePath, await _pickedFile.readAsBytes());
      if (response.statusCode == 200) {
        print("Image Uploaded!!");
        print(uniquePath);
        quitAndSaveDetails(uniquePath);
      } else {
        stopLoading();
        print("Image Upload Failed!!!");
      }
//        readGoogleCloudImage(BUCKET_NAME, uniquePath).then((imgByte) {
//          setState(() {
//            this.imgByte = imgByte;
//            print("image loaded!!");
//          });
//        });
    }
  }

  void quitAndSaveDetails(String imgPath) {
    var downloadUrl = isPathUrl(imgPath)
        ? imgPath
        : getFirebaseDownloadUrl(BUCKET_NAME, imgPath);
    Navigator.pop(
        context,
        Student.optional(
          imgPath: downloadUrl,
          nickName: nickController.text,
          hobby: hobbyController.text,
          level: levelController.text,
          dept: deptController.text,
          age: date != "Date of Birth"
              ? date
              : selectedDate.toUtc().toIso8601String(),
          fullName: nameController.text,
          quote: quoteController.text,
        ));
  }

  goTo(int step) {
    setState(() {
      isFirst = false;
      return currentStep = step;
    });
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    nickController.dispose();
    quoteController.dispose();
    super.dispose();
  }

  DateTime selectedDate = DateTime.now().toUtc();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1793, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked.toUtc();
        date = selectedDate.toUtc().toIso8601String();
//        date = "${selectedDate.toLocal()}".split(' ')[0];
      });
  }

  Widget buildError(context, exception, stackTrace) {
    print(stackTrace);
//    setState(() {
//    });
    return Text('😢');
  }
}

class ImageStepWidget extends StatelessWidget {
  const ImageStepWidget({
    Key key,
    @required String imgPath,
  })  : _imgPath = imgPath,
        super(key: key);

  final String _imgPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: 150, width: 150),
      child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: CircleAvatar(
              radius: 30,
              child: Icon(
                Icons.photo_camera,
                size: 30,
              ),
              backgroundImage: NetworkImage(
                _imgPath,
              ))),
    );
  }
}
