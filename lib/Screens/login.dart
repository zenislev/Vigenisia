// ignore_for_file: avoid_print, file_names

import 'dart:async';

import 'package:vigenesia/constant/const.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:vigenesia/models/login_Model.dart';
import 'package:vigenesia/screens/mainScreens.dart';
import 'package:vigenesia/screens/register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String nama;
  late String idUser;

  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();

  Future<LoginModels> postLogin(String email, String password) async {
    var dio = Dio();
    String baseurl = url;

    Map<String, dynamic> data = {"email": email, "password": password};

    try {
      final response = await dio.post("$baseurl/vigenesia/api/login/",
          data: data,
          options: Options(headers: {'Content-type': 'application/json'}));
      print("Respon -> ${response.data} + ${response.statusCode}");

      if (response.statusCode == 200) {
        final loginModel = LoginModels.fromJson(response.data);
        return loginModel;
      }
    } catch (e) {
      print("Failed To Load $e");
    }
    return postLogin(email, password);
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login Area',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Form(
                      key: _fbKey,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Column(
                          children: [
                            FormBuilderTextField(
                              name: "Email",
                              controller: emailController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 10),
                                border: OutlineInputBorder(),
                                labelText: "Email",
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FormBuilderTextField(
                              obscureText: true,
                              name: "password",
                              controller: passwordController,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 10),
                                  border: OutlineInputBorder(),
                                  labelText: "Password"),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Dont Have Account ?',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                  TextSpan(
                                      text: 'Sign Up',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          const Register()));
                                        },
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueAccent,
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await postLogin(emailController.text,
                                            passwordController.text)
                                        .then((value) => {
                                              if (value != null)
                                                {
                                                  setState(() {
                                                    nama = value.data.nama;
                                                    idUser = value.data.iduser;

                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                MainScreens(
                                                                    idUser:
                                                                        idUser,
                                                                    nama:
                                                                        nama)));
                                                  })
                                                }
                                              else if (value == null)
                                                {
                                                  Flushbar(
                                                    message:
                                                        "Check Your Email / Password",
                                                    duration: const Duration(
                                                        seconds: 5),
                                                    backgroundColor:
                                                        Colors.redAccent,
                                                    flushbarPosition:
                                                        FlushbarPosition.TOP,
                                                  ).show(context)
                                                }
                                            });
                                  },
                                  child: const Text("Sign In")),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
