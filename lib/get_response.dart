import 'dart:convert';
import 'dart:developer';

import 'package:flutter_gantt_chart/models.dart';
import 'package:http/http.dart' as http;

class BaseService {
  static getTasksData() async {
    String baseUrl = "https://staging.skillsewaapp.in";
    String token = "3|gCxwxedJEtSl7CELV3vW3HrnRqeBJ5rB091PvCg2";
    // String baseUrl = "192.168.18.25:8000";

    var uri = Uri.parse("$baseUrl/api/v1/tasks");

    http.Response response = await http.get(uri, headers: {
      'Authorization': "Bearer $token",
      "Accept": "application/json"
    });
    if (response.statusCode == 200) {
      log("Success message for task body: ${response.body}");
      return TasksModel.fromJson(jsonDecode(response.body));
    } else {
      log("Status code => ${response.statusCode}");
      return TasksModel.fromJson(jsonDecode(response.body));
    }
  }
}
