import 'package:flutter/material.dart';
import 'package:football/pages/signup.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDataModelLogin {
  String phone = "";
  String password = "";
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  bool rememberMe = false;
  String? _errorMsg;
  bool passwordVisible = true;
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  UserDataModelLogin userDataModel = UserDataModelLogin();
  double borderRadius1 = 5.0;
  TextStyle textStyle1 =
      TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);

  Future<void> handleLogin(BuildContext context) async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        phone: "91${userDataModel.phone}",
        password: userDataModel.password,
      );

      if (supabase.auth.currentSession != null) {
        if (mounted) {
          Navigator.pop(context);
        }
      }
      print(res);
    } on AuthException catch (e) {
      setState(() {
        _errorMsg = e.message;
      });

      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          _errorMsg = null;
        });
      });

      print(e.message);
    } catch (e) {
      print("error");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Welcome Back!",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
                              fontWeight: FontWeight.bold)),
                      const Text("You've been missed",
                          style: TextStyle(
                              color: Colors.black38,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 30,
                      ),
                      Text("Phone", style: textStyle1),
                      IntlPhoneField(
                        autofocus: false,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: const BorderSide()),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: const BorderSide()),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: const BorderSide()),
                            errorText: _errorMsg),
                        initialCountryCode: 'IN',
                        onChanged: (phone) {
                          if (phone.number.length == 10)
                            userDataModel.phone = phone.number;
                          else
                            userDataModel.phone = "";
                          //print(phone);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Password", style: textStyle1),
                      TextFormField(
                        initialValue: "",
                        obscureText: passwordVisible,
                        enableSuggestions: false,
                        autocorrect: false,
                        autofocus: false,
                        validator: (value) {
                          if (value != null &&
                              value.length < 6 &&
                              value.isNotEmpty) return "Password too short";

                          return null;
                        },
                        onChanged: (value) {
                          if (value.length >= 6)
                            userDataModel.password = value;
                          else
                            userDataModel.password = "";
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          errorText: _errorMsg,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            icon: passwordVisible
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius1),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(borderRadius1),
                              borderSide: const BorderSide()),
                        ),
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    value: rememberMe,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        rememberMe = value ?? false;
                                      });
                                    }),
                                Text("Remember me")
                              ],
                            ),
                            Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                          splashColor: Color.fromARGB(72, 255, 255, 255),
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              // print(userDataModel.toString());
                              handleLogin(context);
                            }
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius:
                                    BorderRadius.circular(borderRadius1)),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Dont't have an account? ",
                            style: TextStyle(fontSize: 20),
                          ),
                          GestureDetector(
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signup()));
                            },
                          )
                        ],
                      )
                    ],
                  )),
            )),
      ),
    );
  }
}
