import 'package:flutter/material.dart';
import 'services/app_data_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppDataController controller;

  @override
  void initState() {
    super.initState();

    controller = AppDataController();
    controller.initialize();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test Input',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
      ),
      initialRoute: '/Home',
      routes: {
        '/Home': (context) => HomePage(
          controller: controller,
        ),
        '/Second': (context) => SecondPage(
          controller: controller,
        ),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final AppDataController controller;

  const HomePage({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student',
          style: TextStyle(
            fontSize: 30,
            color: Colors.purpleAccent,
          ),
        ),
        backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          if (controller.isLoading) {
            return const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Завантаження даних з PlayFab...'),
                ],
              ),
            );
          }

          if (controller.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      controller.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.initialize,
                      child: const Text('Спробувати ще раз'),
                    ),
                  ],
                ),
              ),
            );
          }

          final student = controller.student;

          if (student == null) {
            return const Center(
              child: Text('Дані студента відсутні.'),
            );
          }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.school,
                    size: 64,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Ім’я: ${student.displayName}',
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Спеціальність: ${student.displaySpecialty}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Курс: ${student.displayYear}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: controller.generateStudent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Згенерувати студента'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: controller.saveStudent,
                    child: const Text('Зберегти студента'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/Second');
                    },
                    child: const Text('Перейти до предмета'),
                  ),
                  if (controller.statusMessage != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      controller.statusMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final AppDataController controller;

  const SecondPage({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Subject',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.green,
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (controller.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: controller.initialize,
                      child: const Text('Спробувати ще раз'),
                    ),
                  ],
                ),
              ),
            );
          }

          final subject = controller.subject;

          if (subject == null) {
            return const Center(
              child: Text('Дані предмета відсутні'),
            );
          }

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.menu_book,
                    size: 64,
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Предмет: ${subject.displayName}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Викладач: ${subject.displayTeacher}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Кредити: ${subject.displayCredits}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: controller.generateSubject,
                    child: const Text('Згенерувати предмет'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: controller.saveSubject,
                    child: const Text('Зберегти предмет'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 18,
                      ),
                      shape: RoundedSuperellipseBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 6,
                    ),
                    child: const Text('Go back'),
                  ),
                  if (controller.statusMessage != null) ...[
                    const SizedBox(height: 20),
                    Text(
                      controller.statusMessage!,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
