import 'dart:math';

enum SubjectName {
  web,
  databases,
  computerNetworks,
}

enum TeacherName {
  ivanenko,
  petrenko,
  shevchenko,
}

enum CreditCount {
  three,
  four,
  five,
}

class Subject {
  final SubjectName name;
  final TeacherName teacher;
  final CreditCount credits;

  const Subject({
    required this.name,
    required this.teacher,
    required this.credits,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name.name,
      'teacher': teacher.name,
      'credits': credits.name,
    };
  }

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: SubjectName.values.byName(json['name'] as String),
      teacher: TeacherName.values.byName(json['teacher'] as String),
      credits: CreditCount.values.byName(json['credits'] as String),
    );
  }

  factory Subject.random() {
    final random = Random();

    return Subject(
      name: SubjectName.values[random.nextInt(SubjectName.values.length)],
      teacher: TeacherName.values[random.nextInt(TeacherName.values.length)],
      credits: CreditCount.values[random.nextInt(CreditCount.values.length)],
    );
  }

  String get displayName {
    switch (name) {
      case SubjectName.web:
        return 'Web програмування';
      case SubjectName.databases:
        return 'Бази даних';
      case SubjectName.computerNetworks:
        return 'Комп’ютерні мережі';
    }
  }

  String get displayTeacher {
    switch (teacher) {
      case TeacherName.ivanenko:
        return 'Іваненко';
      case TeacherName.petrenko:
        return 'Петренко';
      case TeacherName.shevchenko:
        return 'Шевченко';
    }
  }

  int get displayCredits => credits.index + 3;
}
