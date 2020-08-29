import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:studentprofileretrofit/model/student.dart';
import 'package:studentprofileretrofit/pattern/studentBloc.dart';
import 'package:studentprofileretrofit/studentDetails.dart';
import 'package:studentprofileretrofit/studentForm.dart';
import 'package:studentprofileretrofit/style.dart';
import 'package:studentprofileretrofit/testScreen.dart';
import 'customWidget/TabWidgets.dart';
import 'customWidget/popUp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const routeHome = '/';
  static const routeStdScreen = '/stdScreen';
  static const routeScoreFormScreen = '/stdFormScreen';
  static const routeStdDetailsScreen = '/stdDetails';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        routeHome: (context) => StdScoreScreen(),
//        routeScoreFormScreen: (context) => ScoreFormScreen(),
        routeScoreFormScreen: (context) => ImageTestScreen(),
        routeStdDetailsScreen: (context) => StudentDetailsScreen(),
      },
      title: 'Sample',
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(textTheme: TextTheme(headline6: AppBarTextStyle)),
        textTheme:
            TextTheme(headline6: TitleTextStyle, bodyText1: ContentTextStyle),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: routeHome,
    );
  }
}

class StdScoreScreen extends StatefulWidget {
  @override
  _StdScoreScreenState createState() => _StdScoreScreenState();
}

class _StdScoreScreenState extends State<StdScoreScreen> {
  StudentBloc studentBloc = StudentBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    studentBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Student Profiles"),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                  child: Container(
                      constraints: BoxConstraints.expand(),
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Image.asset("assets/bro.jpg"))),
              DrawerItem(title: "settings"),
              DrawerItem(title: "about"),
              DrawerItem(title: "tutorial"),
              DrawerItem(title: "Story"),
              DrawerItem(title: "Names"),
            ],
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, isScroll) {
            return <Widget>[
              TabWidget(
                tabsList: [
                  new Tab(
                    icon: Icon(Icons.all_inclusive),
                    text: "All Students",
                  ),
                  new Tab(
                    icon: Icon(Icons.border_top),
                    text: "Top Students",
                  ),
                ],
                unselectedColor: Colors.grey,
                selectedColor: Colors.black,
              ),
            ];
          },
          body: MainPage(studentBloc),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            print("start!!");
            dynamic result = await Navigator.pushNamed(
                context, MyApp.routeScoreFormScreen,);
//            await studentBloc.addStudent(Student.optional());
            print("inserted!!");
          },
        ));
  }
}

class MainPage extends StatefulWidget {
  final StudentBloc studentBloc;

  MainPage(this.studentBloc);

  @override
  _MainPageState createState() => _MainPageState(studentBloc);
}

class _MainPageState extends State<MainPage> {
  StudentBloc studentBloc;

  _MainPageState(this.studentBloc);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: TopCard(),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: StreamBuilder<List<Student>>(
            stream: studentBloc.students,
            builder: (context, AsyncSnapshot<List<Student>> snapshot) {
              if (snapshot.hasData)
                return new GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  children: snapshot.data.map((student) {
                    var name = student.fullName;
                    var quote = student.quote;
                    var img = student.imgPath;
                    return Card(
                      child: new ListTile(
                        onTap: () async {
                          dynamic result = await Navigator.pushNamed(
                              context, MyApp.routeStdDetailsScreen,
                              arguments: student);
                        },
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                          img,
                        )),
                        title: new Text(student != null
                            ? (name != null ? name : "null")
                            : "empty"),
                        subtitle: new Text(student != null
                            ? (quote != null ? quote : "null")
                            : "empty"),
                        trailing: TextPopUpMenuButton(
                          list: ["Add New Grade", "delete", "update"],
                          onButtonTap: (choice) async {
                            Navigator.pop(context);
                            switch (choice) {
                              case 'Add New Grade':
                                dynamic result = await Navigator.pushNamed(
                                    context, MyApp.routeScoreFormScreen,
                                    arguments: student);
//                                if (result.isNotEmpty) {
//                                  student.reference.update(result);
//                                }
                                break;
                              case 'delete':
                                print(student.id);
                                await studentBloc.deleteStudent(student);
                                print("Deleted!!");
//                                dynamic result = await Navigator.pushNamed(
//                                    context, MyApp.routeScoreFormScreen,
//                                    arguments: student);
//                                if (result.isNotEmpty) {
//                                  student.reference.update(result);
//                                }
                                break;
                              case 'update':
                                print(student.id);
                                await studentBloc.updateStudent(
                                    Student.optional(
                                        id: student.id, fullName: "Jumai"));
                                print("updated");
                            }
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return CircularProgressIndicator();
              }
            },
          ),
        ),
      ],
    );
  }
}

class TopCard extends StatelessWidget {
  const TopCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
//                    mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Best Scores",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Top Three",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Container(
                      height: 1.6,
                      decoration: BoxDecoration(color: Colors.grey),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 10.0,
                  percent: 0.95,
                  center: new Text("95%"),
                  progressColor: Colors.pinkAccent,
                ),
                SizedBox(
                  width: 30,
                ),
                CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 10.0,
                  percent: 0.6,
                  center: new Text("60%"),
                  progressColor: Colors.pinkAccent,
                ),
                SizedBox(
                  width: 30,
                ),
                CircularPercentIndicator(
                  radius: 100.0,
                  lineWidth: 10.0,
                  percent: 0.7,
                  center: new Text("70%"),
                  progressColor: Colors.pinkAccent,
                ),
                SizedBox(
                  width: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.pop(context),
      title: Text(title),
      leading:
          CircleAvatar(child: Image.asset("assets/img.PNG", fit: BoxFit.fill)),
    );
  }
}
