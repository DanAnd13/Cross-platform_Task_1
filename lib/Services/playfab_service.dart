import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';
import '../models/subject.dart';

class PlayFabService {
  static const String _titleId = '27367';
  static const String _customId = 'BE5CCBFA2A911252';
  static const String _baseUrl = 'https://$_titleId.playfabapi.com';

  String? _sessionTicket;

  Future<void> login() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/Client/LoginWithCustomID'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'TitleId': _titleId,
        'CustomId': _customId,
        'CreateAccount': false,
      }),
    );

    final body = _decodeResponse(response);

    final data = body['data'] as Map<String, dynamic>?;
    final ticket = data?['SessionTicket'] as String?;

    if (ticket == null || ticket.isEmpty) {
      throw Exception('PlayFab не повернув SessionTicket.');
    }

    _sessionTicket = ticket;
  }

  Future<Map<String, String>> loadData() async {
    final ticket = _requireTicket();

    final response = await http.post(
      Uri.parse('$_baseUrl/Client/GetUserData'),
      headers: {
        'Content-Type': 'application/json',
        'X-Authorization': ticket,
      },
      body: jsonEncode({
        'Keys': ['student', 'subject'],
      }),
    );

    final body = _decodeResponse(response);
    final data = body['data'] as Map<String, dynamic>?;
    final records = data?['Data'] as Map<String, dynamic>? ?? {};
    final result = <String, String>{};

    for (final key in ['student', 'subject']) {
      final record = records[key];

      if (record is Map<String, dynamic>) {
        final value = record['Value'];

        if (value is String) {
          result[key] = value;
        }
      }
    }

    return result;
  }

  Future<void> saveData({
    Student? student,
    Subject? subject,
  }) async {
    final ticket = _requireTicket();
    final data = <String, String>{};

    if (student != null) {
      data['student'] = jsonEncode(student.toJson());
    }

    if (subject != null) {
      data['subject'] = jsonEncode(subject.toJson());
    }

    if (data.isEmpty) {
      return;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/Client/UpdateUserData'),
      headers: {
        'Content-Type': 'application/json',
        'X-Authorization': ticket,
      },
      body: jsonEncode({'Data': data}),
    );

    _decodeResponse(response);
  }

  String _requireTicket() {
    final ticket = _sessionTicket;

    if (ticket == null || ticket.isEmpty) {
      throw Exception('Спочатку потрібно виконати вхід у PlayFab.');
    }

    return ticket;
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    Map<String, dynamic> body;

    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw Exception(
        'PlayFab повернув неочікувану відповідь (HTTP ${response.statusCode})',
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final error = body['errorMessage'] ?? body['error'] ?? 'HTTP ${response.statusCode}';
      throw Exception('Помилка PlayFab: $error');
    }

    return body;
  }
}
