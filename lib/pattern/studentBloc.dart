import 'dart:async';

import '../model/student.dart';

class StudentRepository {
  final studentDao = StudentDao();

  Future<Student> addStudent(Student student) => studentDao.addStudent(student);

  Future<List<Student>> getStudents() => studentDao.getStudents();

  Future<Student> getStudent(String id) => studentDao.getStudent(id);

  Future<void> deleteStudent(String id) => studentDao.deleteStudent(id);

  Future<Student> updateStudent(Student student) =>
      studentDao.updateStudent(student);
}

class StudentBloc {
  final studentRepo = StudentRepository();
  final studentController = StreamController<List<Student>>.broadcast();

  get students => studentController.stream;

  StudentBloc() {
    getStudents();
  }

  dispose() {
    studentController.close();
  }

  addStudent(Student student) async {
    await studentRepo.addStudent(student);
    getStudents();
  }

  getStudents() async {
    studentController.sink.add(await studentRepo.getStudents());
  }

  deleteStudent(Student student) async {
    await studentRepo.deleteStudent(student.id);
    getStudents();
  }

  updateStudent(Student student) async {
    await studentRepo.updateStudent(student);
    getStudents();
  }

  getStudent(String id) async {
    return await studentRepo.getStudent(id);
  }
}
