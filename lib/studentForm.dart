import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'customWidget/TextItem.dart';
import 'model/StudentPro.dart';
import 'package:path/path.dart' as Path;

class ScoreFormScreen extends StatefulWidget {
  @override
  _ScoreFormScreenState createState() => _ScoreFormScreenState();
}

class _ScoreFormScreenState extends State<ScoreFormScreen> {

  final nameController = TextEditingController();
  final nickController = TextEditingController();
  final quoteController = TextEditingController();
  final hobbyController = TextEditingController();
  final levelController = TextEditingController();
  final deptController = TextEditingController();
  int currentStep = 0;
  bool complete = false;
  bool isFirst = true;
  List<FormData> forms;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    forms = [
      FormData("Math"),
      FormData("English"),
      for (int i = 0; i < 100; i++) FormData("Physics"),
      FormData("Chemistry"),
      FormData("Computer"),
      FormData("Computer"),
      FormData("Computer"),
      FormData("Computer"),
      FormData("Computer"),
      FormData("Computer"),
      FormData("Computer"),
      FormData("Computer"),
      FormData("Computer"),
      FormData("Computer"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    dynamic data = ModalRoute.of(context).settings.arguments;
    StudentPro student;
    if (data != null && data.isNotEmpty) {
      student = StudentPro.fromMap(data);
    }
    return Scaffold(
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
        body: GridView(
//            crossAxisCount: 4,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            children: forms
                .map((formData) => EditText(
                      initialText: isFirst
                          ? (student != null ? student.fullName : "")
                          : (formData.controller.text),
                      label: formData.label,
                      startDrawable: Icons.text_format,
                      txtController: formData.controller,
                    ))
                .toList()));
  }
}

class FormData {
  String label;
  String initText;
  TextEditingController controller = TextEditingController();

  FormData(this.label, {this.initText});
}
