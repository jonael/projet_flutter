import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:universal_platform/universal_platform.dart';

import 'models/task.dart';

class TaskApi {

  static Future getTasks() {
    String url = '';
    if(UniversalPlatform.isAndroid){
      url = "http://10.0.2.2/task/api/api_view_all_task.php";
    }else if (UniversalPlatform.isWeb) {
      url = "http://localhost/task/api/api_view_all_task.php";
    }
    return http.get(Uri.parse(url),);
  }

  static Future login(String login, String password) async {
    String url = '';
    if(UniversalPlatform.isAndroid){
      url = "http://10.0.2.2/test/api/login.php";
    }else if (UniversalPlatform.isWeb){
      url = "http://localhost/test/api/login.php";
    }
    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            "Accept": "application/json",
            "Access-Control_Allow_Origin": "*"
          },
          body: jsonEncode({
            "login_util": login,
            "mdp_util": password}),
      );
      print("top"+response.body);
      if (response.statusCode == 200) {
        return response;
      }
    } on Exception {
      print(Exception);
      print("Error occured");
    }
  }

  static Future register(String name, String firstname, String login, String password) async {
    String url = '';
    if(UniversalPlatform.isAndroid){
      url = "http://10.0.2.2/task/api/createUser.php";
    }else if (UniversalPlatform.isWeb){
      url = "http://localhost/task/api/createUser.php";
    }
    try {
      final response = await http.post(Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Access-Control_Allow_Origin": "*"
        },
        body: jsonEncode({
          "name_user": name,
          "first_name_user": firstname,
          "login_user": login,
          "mdp_user": password}),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print(response.body);
        print(response.statusCode);
        return false;
      }
    } on Exception {
      print(Exception);
      print("Error occured");
      return false;
    }
  }

  static Future addTask(String name, String content, String date) {
    String url = '';
    int valid = 0;
    int idUtil = 1;
    if(UniversalPlatform.isAndroid){
      url = "http://10.0.2.2/test/api/createTask.php";
    }else if (UniversalPlatform.isWeb){
      url = "http://localhost/test/api/createTask.php";
    }
    return http.post(Uri.parse(url),
      body: jsonEncode(<String, String>{
        "name_task": name,
        "content_task": content,
        "date_task": date,
        "validate_task": valid.toString(),
        "id_util": idUtil.toString()
      }),
    );
  }

  static Future updateTask(Task task) {
    String url = '';

    String? nameTask = task.nameTask;
    String? contentTask = task.contentTask;
    String? dateTask = task.dateTask;
    String? validTask = task.validateTask;
    String? idUtil = task.idUser;

    if(UniversalPlatform.isAndroid){
      url = "http://10.0.2.2/test/api/updateTask.php";
    }else if (UniversalPlatform.isWeb){
      url = "http://localhost/test/api/updateTask.php";
    }
    return http.post(Uri.parse(url),
      body: jsonEncode(<String, String>{
        "name_task": nameTask!,
        "content_task": contentTask!,
        "date_task": dateTask!,
        "valid_task": validTask.toString(),
        "id_util": idUtil.toString()
      }),
    );
  }
}