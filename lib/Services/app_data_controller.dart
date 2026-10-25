import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/student.dart';
import '../models/subject.dart';
import 'playfab_service.dart';

class AppDataController extends ChangeNotifier {
  final PlayFabService _playFab = PlayFabService();

  Student? student;
  Subject? subject;

  bool isLoading = true;
  String? errorMessage;
  String? statusMessage;

  Future<void> initialize() async {
    isLoading = true;
    errorMessage = null;
    statusMessage = null;
    notifyListeners();

    try {
      await _playFab.login();
      final records = await _playFab.loadData();

      final studentIsMissing = !records.containsKey('student');
      final subjectIsMissing = !records.containsKey('subject');

      student = studentIsMissing ? Student.random() : Student.fromJson(
        jsonDecode(records['student']!) as Map<String, dynamic>,
      );

      subject = subjectIsMissing ? Subject.random() : Subject.fromJson(
        jsonDecode(records['subject']!) as Map<String, dynamic>,
      );

      if (studentIsMissing || subjectIsMissing) {
        statusMessage = 'Відсутні моделі згенеровано';
      } else {
        statusMessage = 'Дані успішно завантажено з PlayFab';
      }
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void generateStudent() {
    student = Student.random();
    statusMessage = 'Студента згенеровано';
    notifyListeners();
  }

  void generateSubject() {
    subject = Subject.random();
    statusMessage = 'Предмет згенеровано';
    notifyListeners();
  }

  Future<void> saveStudent() async {
    try {
      final value = student;
      if (value == null) {
        return;
      }

      await _playFab.saveData(student: value);
      statusMessage = 'Студента збережено в PlayFab';
    } catch (error) {
      statusMessage = 'Помилка збереження студента: $error';
    }

    notifyListeners();
  }

  Future<void> saveSubject() async {
    try {
      final value = subject;
      if (value == null) {
        return;
      }

      await _playFab.saveData(subject: value);
      statusMessage = 'Предмет збережено в PlayFab.';
    } catch (error) {
      statusMessage = 'Помилка збереження предмета: $error';
    }

    notifyListeners();
  }
}
