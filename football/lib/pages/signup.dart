import 'package:flutter/material.dart';
import 'package:football/pages/login.dart';
import 'package:football/pages/otp_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDataModel {
  String firstName = "";
  String lastName = "";
  String phone = "";
  String password = "";
  String confirmPassword = "";

  @override
  toString() {
    return "firstName: $firstName lastName: $lastName phone: $phone password: $password";
  }
}

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _Signup();
}

class _Signup extends State<Signup> {
  String? _errorMsg;
  bool passwordVisible = true;
  bool confirmPasswordVisible = true;
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final _phoneKey = GlobalKey<FormFieldState>();
  UserDataModel userDataModel = UserDataModel();
  double borderRadius1 = 5.0;
  TextStyle textStyle1 =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  Future<void> handleSignup() async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
          phone: "91${userDataModel.phone}",
          password: userDataModel.password,
          channel: OtpChannel.sms,
          data: {
            "first_name": userDataModel.firstName,
            "last_name": userDataModel.lastName
          });

      if (supabase.auth.currentSession != null) {
        if (mounted) {
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OtpScreen()));
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
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Create Account",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 40,
                              fontWeight: FontWeight.bold)),
                      Text("Score Your Spot!",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 25,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "First Name",
                        style: textStyle1,
                      ),
                      TextFormField(
                        autofocus: false,
                        enableSuggestions: false,
                        autocorrect: false,
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          userDataModel.firstName = value;
                        },
                        validator: (value) {
                          if (value != null && value.isEmpty)
                            return "Cannot be empty";
                          return null;
                        },
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                            hintText: ""),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Last Name", style: textStyle1),
                      TextFormField(
                        autofocus: false,
                        enableSuggestions: false,
                        autocorrect: false,
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          userDataModel.lastName = value;
                        },
                        validator: (value) {
                          if (value != null && value.isEmpty)
                            return "Cannot be empty";
                          return null;
                        },
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                            hintText: ""),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Phone", style: textStyle1),
                      IntlPhoneField(
                        key: _phoneKey,
                        autofocus: false,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            errorText: _errorMsg,
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                            hintText: ""),
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
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Confirm Password", style: textStyle1),
                      TextFormField(
                        obscureText: confirmPasswordVisible,
                        enableSuggestions: false,
                        autocorrect: false,
                        autofocus: false,
                        cursorColor: Colors.black,
                        validator: (value) {
                          if (value != null &&
                              value.isNotEmpty &&
                              value != userDataModel.password)
                            return "Password does not match";

                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                confirmPasswordVisible =
                                    !confirmPasswordVisible;
                              });
                            },
                            icon: confirmPasswordVisible
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius1),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(borderRadius1),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              )),
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
                              handleSignup();
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
                                "Sign Up",
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
                            "Already have an account? ",
                            style: TextStyle(fontSize: 20),
                          ),
                          GestureDetector(
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
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
