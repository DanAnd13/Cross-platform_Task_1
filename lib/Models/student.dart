import 'dart:math';

enum StudentName {
  andrii,
  olena,
  maksym,
}

enum StudentSpecialty {
  computerScience,
  cybersecurity,
  design,
}

enum StudyYear {
  first,
  second,
  third,
  fourth,
}

class Student {
  final StudentName name;
  final StudentSpecialty specialty;
  final StudyYear year;

  const Student({
    required this.name,
    required this.specialty,
    required this.year,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name.name,
      'specialty': specialty.name,
      'year': year.name,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      name: StudentName.values.byName(json['name'] as String),
      specialty: StudentSpecialty.values.byName(json['specialty'] as String),
      year: StudyYear.values.byName(json['year'] as String),
    );
  }

  factory Student.random() {
    final random = Random();

    return Student(
      name: StudentName.values[random.nextInt(StudentName.values.length)],
      specialty: StudentSpecialty.values[random.nextInt(StudentSpecialty.values.length)],
      year: StudyYear.values[random.nextInt(StudyYear.values.length)],
    );
  }

  String get displayName {
    switch (name) {
      case StudentName.andrii:
        return 'Андрій';
      case StudentName.olena:
        return 'Олена';
      case StudentName.maksym:
        return 'Максим';
    }
  }

  String get displaySpecialty {
    switch (specialty) {
      case StudentSpecialty.computerScience:
        return 'Комп’ютерні науки';
      case StudentSpecialty.cybersecurity:
        return 'Кібербезпека';
      case StudentSpecialty.design:
        return 'Дизайн';
    }
  }

  String get displayYear => '${year.index + 1} курс';
}
