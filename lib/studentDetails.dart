import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'customWidget/TabWidgets.dart';
import 'customWidget/popUp.dart';
import 'model/student.dart';

class StudentDetailsScreen extends StatefulWidget {
  @override
  _StudentDetailsScreenState createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  int initial = 0;
  StudentDataType studentDataType = StudentDataType.BIO_DATA;
  Student student;

  @override
  Widget build(BuildContext context) {
    student = ModalRoute.of(context).settings.arguments as Student;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, isScroll) {
          return [
            CollapseAppBar(
              expandedHeight: 235,
              centerTitle: true,
              title: Text("Collapse It!!!"),
              background: Image.network(
                student.imgPath,
                fit: BoxFit.cover,
              ),
              actions: <Widget>[
                TextPopUpMenuButton(
                    icon: Icons.directions_run,
                    list: ["delete", "contact", "say Hi"],
                    onButtonTap: (choice) {}),
                TextPopUpMenuButton(
                    list: ["delete", "contact", "say Hi"],
                    onButtonTap: (choice) {}),
              ],
            ),
            TabWidget(
              ontap: (index) {
                print(index);
                setState(() {
                  studentDataType = (index == 0)
                      ? StudentDataType.BIO_DATA
                      : (index == 1
                          ? StudentDataType.ACADEMICS
                          : StudentDataType.SOCIAL);
                  initial = index;
                });
              },
              unselectedColor: Colors.grey,
              selectedColor: Colors.black,
              tabsList: [
                new Tab(
                  icon: Icon(Icons.person),
                  text: "Bio Data",
                ),
                new Tab(
                  icon: Icon(Icons.school),
                  text: "Academics",
                ),
                new Tab(
                  icon: Icon(Icons.games),
                  text: "Social",
                ),
              ],
            )
          ];
        },
        body: buildDetails(student, studentDataType),
      ),
    );
  }

  StudentDetailCardWidget buildDetails(
      Student student, StudentDataType dataType) {
    List dataList;
    String subTittleLabel;
    if (dataType == StudentDataType.BIO_DATA) {
      dataList = student.toBioDataList();
      subTittleLabel = "Bio Data";
    } else if (dataType == StudentDataType.ACADEMICS) {
      dataList = student.toAcademicList();
      subTittleLabel = "Academic Details";
    } else {
      dataList = student.toSocialList();
      subTittleLabel = "Social Details";
    }

    return StudentDetailCardWidget(
      "${student.fullName}\'s ",
      subTittle: subTittleLabel,
      child: Column(
//        shrinkWrap: true,
//        physics: AlwaysScrollableScrollPhysics(),
        children: dataList
            .map((item) => Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        item.label,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(item.content),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class StudentDetailCardWidget extends StatelessWidget {
  const StudentDetailCardWidget(this.tittle, {this.subTittle, this.child});

  final String tittle;
  final String subTittle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text("$tittle $subTittle",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(padding: const EdgeInsets.all(12.0), child: child),
        ],
      ),
    );
  }
}

class DetailCardWidget extends StatelessWidget {
  const DetailCardWidget(this.tittle, {this.subTittle, this.child});

  final String tittle;
  final String subTittle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
//      constraints: BoxConstraints.expand(height: 300.0),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Card(
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
//                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tittle, style: TextStyle(fontSize: 20)),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        subTittle,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ]),
              ),
              Container(
                height: 1.2,
                decoration: BoxDecoration(color: Colors.grey),
              ),
              Padding(padding: const EdgeInsets.all(32.0), child: child),
            ],
          ),
//            clipBehavior:,
        ),
      ),
    );
  }
}

enum StudentDataType { BIO_DATA, ACADEMICS, SOCIAL }
