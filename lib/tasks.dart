import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart' as http;
import 'package:projet_flutter/task_api.dart';

import 'models/task.dart';


class TasksPage extends StatefulWidget {
  const TasksPage({Key? key, this.title,}) : super(key: key);
  final String? title;

  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {

  bool visible = false;
  bool check = false;
  List<Task> tasks = <Task>[];

  final taskNameController = TextEditingController();
  final taskContentController = TextEditingController();

  void getTasksfromApi() async {
    TaskApi.getTasks().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        print(list);
        tasks = list.map((model) => Task.fromJson(model)).toList();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTasksfromApi();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("tasks"),
      ),
      body: body(),
    );
  }

  Widget body() {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: size.height * 0.02),
            const Text(
              "Ajouter une tâche",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width * 0.20,
                  child: TextFormField(
                    autocorrect: true,
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'nom tâche',
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.01),
                Container(
                  width: size.width * 0.70,
                  child: TextFormField(
                    autocorrect: true,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'description tâche',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
                elevation: 15,
                shadowColor: Colors.deepPurple,
              ),
              onPressed: () {
                String name = taskNameController.text.toString();
                String content = taskContentController.text.toString();
                createTask(name, content);
              },
              child: const Text(
                "Valider",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.03),
            NeumorphicButton(
                margin: const EdgeInsets.only(top: 12),
                onPressed: () {

                },
                style: NeumorphicStyle(
                  color: Colors.lightBlue,
                  shape: NeumorphicShape.flat,
                  boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
                ),
                padding: const EdgeInsets.all(12.0),
                child: const Text(
                  "Valider",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
            ),
            SizedBox(height: size.height * 0.02),
            const Text(
              "Mes tâches",
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            ListView.builder(
              padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, i) {
                return Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ListTile(
                        title: Text(tasks[i].nameTask!),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: ListTile(
                        title: Text(tasks[i].contentTask!),
                      ),
                    ),
                    NeumorphicCheckbox(value: checkValue(tasks[i].validateTask), onChanged: updateState(tasks[i])),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void createTask(String name, String content) async{
    String date = DateTime.now().toString();
    print(date);
    TaskApi.addTask(name, content, date);
  }

  updateState(Task task) {
    setState(() {
      tasks.remove(task);
      check = !check;
      TaskApi.updateTask(task);
    });
  }

  checkValue(String? validTask) {
    print(validTask);
    if(validTask != "0") {
      return check = true;
    } else {
      return check = false;
    }
  }
}