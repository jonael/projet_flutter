import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:projet_flutter/task_api.dart';
import 'package:projet_flutter/tasks.dart';
import 'models/user.dart';

void main() {
  runApp(const MonApplication());
}

class MonApplication extends StatelessWidget {
  /// constructeur
  const MonApplication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// je retire la bannière debug
      debugShowCheckedModeBanner: false,
      /// nom de l'onglet
      title: 'Projet Flutter',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MaPageAccueil(title: 'Page Accueil'), /// titre dans app bar
    );
  }
}

class MaPageAccueil extends StatefulWidget {
  const MaPageAccueil({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MaPageAccueil> createState() => _MaPageAccueilState();
}

class _MaPageAccueilState extends State<MaPageAccueil> {

  bool choice = false;
  bool change = false;
  bool onlyCreate = false;
  bool visible = false;
  bool visibleError = false;

  String error = "";

  List<User> utilisateurs = <User>[];

  void loginApi(String login, String password) async {
    visible = !visible;
    TaskApi.login(login, password).then((response) {
      setState(() {
        var user = response.body;
        if(user != null) {
          visible = !visible;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) {
                    return TasksPage();
                  }
              )
          );
        } else {
          error = "identifiants incorrects";
          visible = !visible;
          visibleError = !visibleError;
        }
      });
    });
  }

  void registerApi(String name, String firstname, String login, String password) async {
    visible = !visible;
    TaskApi.register(name, firstname, login, password).then((response) {
      setState(() {
        if(response == true) {
          print(response.toString());
          visible = !visible;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const TasksPage();
                  }
              )
          );
        } else {
          error = "erreur lors de la création de compte";
          visible = !visible;
          visibleError = !visibleError;
        }
      });
    });
  }

  final nameController = TextEditingController();
  final firstnameController = TextEditingController();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(updateAppBarTitle()),
      ),
      body: body(),
    );
  }

  Widget body() {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 5.0, left: 10.0, right: 10.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: size.height * 0.02),
            //Header(size: size),
            NeumorphicText(
              updateAppBarTitle(),
              style: const NeumorphicStyle(
                border: NeumorphicBorder(color: Colors.purpleAccent),
                depth: 120,
                color: Colors.blue,
                //customize color here
              ),
              duration: const Duration(milliseconds: 1500),
              textStyle: NeumorphicTextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 30.0,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              width: size.width * 0.70,
              child: TextFormField(
                controller: loginController,
                autocorrect: true,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your pseudo or mail as login'
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Visibility(
                visible: visible,
                child: Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: const CircularProgressIndicator()
                )
            ),
            Visibility(
                child: SizedBox(
                    height: size.height * 0.01,
                ),
            ),
            Container(
              width: size.width * 0.70,
              child: TextFormField(
                controller: passwordController,
                autocorrect: true,
                obscureText: true,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter your password'
                ),
              ),
            ),
            Visibility(
                visible: onlyCreate,
                child: SizedBox(height: size.height * 0.01),
            ),
            Visibility(
              visible: onlyCreate,
              child: Container(
                width: size.width * 0.70,
                child: TextFormField(
                  controller: confirmPasswordController,
                  autocorrect: true,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Confirm your password'
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Visibility(
              visible: onlyCreate,
              child: Container(
                width: size.width * 0.70,
                child: TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter your name'
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Visibility(
              visible: onlyCreate,
              child: Container(
                width: size.width * 0.70,
                child: TextFormField(
                  controller: firstnameController,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter your firstname'
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Visibility(
                visible: visibleError,
                child: Text(
                  error,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
            ),
            SizedBox(height: size.height * 0.01),
            TextButton(
              onPressed: updateState,
              child: Text(
                updateChoice(),
                style: const TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                  fontSize: 16.0,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightBlue,
                elevation: 15,
                shadowColor: Colors.deepPurple,
              ),
              onPressed: () {
                String name = nameController.text.toString();
                String firstname = firstnameController.text.toString();
                String login = passwordController.text.toString();
                String password = passwordController.text.toString();
                String confirmPassword = confirmPasswordController.text.toString();
                loginOrRegister(name, firstname, login, password, confirmPassword);
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
            SizedBox(height: size.height * 0.05),
          ],
        ),
      ),
    );
  }


  String updateAppBarTitle(){
    return (choice)? "Créer un compte" : "Se connecter";
  }

  String updateChoice(){
    return (change)? "Déjà un compte?" : "Pas encore de compte?";
  }

  updateState() {
    setState(() {
      choice = !choice;
      change = !change;
      onlyCreate = !onlyCreate;
    });
  }

  void loginOrRegister(String name, String firstname, String login, String password, String confirmPassword) {
    if(onlyCreate == true){
      if(password == confirmPassword){
        if(name.isEmpty){
          setState(() {
            visibleError = !visibleError;
            error = "Veuillez renseigner un nom";
          });
        } else if(firstname.isEmpty){
          setState(() {
            visibleError = !visibleError;
            error = "Veuillez renseigner un prénom";
          });
        } else if(login.isEmpty){
          setState(() {
            visibleError = !visibleError;
            error = "Veuillez renseigner un mail ou un pseudo";
          });
        } else if(password.isEmpty){
          setState(() {
            visibleError = !visibleError;
            error = "Veuillez renseigner un mot de passe";
          });
        } else if(confirmPassword.isEmpty){
          setState(() {
            visibleError = !visibleError;
            error = "Veuillez confirmer votre mot de passe";
          });
        } else {
          registerApi(name, firstname, login, password);
        }
      } else {
        setState(() {
          visibleError = !visibleError;
          error = "Les mots de passes ne correspondent pas.";
        });
      }
    } else {
      loginApi(login, password);
    }
  }
}
