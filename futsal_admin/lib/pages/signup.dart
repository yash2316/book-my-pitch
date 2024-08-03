import 'package:flutter/material.dart';
import 'package:futsal_admin/pages/login.dart';
import 'package:futsal_admin/pages/otp_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserDataModel {
  String firstName = "";
  String lastName = "";
  String phone = "";
  String password = "";
  String confirmPassword = "";
  String email = "";

  @override
  toString() {
    return "firstName: $firstName lastName: $lastName phone: $phone password: $password";
  }

  bool validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value) ? false : true;
  }
}

class Signup extends StatefulWidget {
  final Function parentUpdateFunction;
  const Signup({super.key, required this.parentUpdateFunction});

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
  TextStyle textStyle1 = const TextStyle(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);

  Future<void> handleSignup() async {
    try {
      await supabase.auth.signUp(
          phone: "91${userDataModel.phone}",
          password: userDataModel.password,
          channel: OtpChannel.sms,
          data: {
            "first_name": userDataModel.firstName,
            "last_name": userDataModel.lastName,
            "email": userDataModel.email,
            "admin": true
          });

      if (supabase.auth.currentSession != null) {
        await supabase.from('owner').insert({
          "owner_first_name": userDataModel.firstName,
          "owner_last_name": userDataModel.lastName,
          "owner_email": userDataModel.email,
          'owner_phone': userDataModel.phone.toString(),
          'owner_id': supabase.auth.currentUser!.id
        });

        // print(supabase.auth.currentUser);
        if (mounted) {
          widget.parentUpdateFunction(() {});
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => OtpScreen()));
        }
      }
      // print(res);
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
                      const Text("Create Account",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40,
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
                          if (value != null && value.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: const BorderSide()),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: const BorderSide()),
                            hintText: ""),
                      ),
                      const SizedBox(
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
                          if (value != null && value.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: const BorderSide()),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: const BorderSide()),
                            hintText: ""),
                      ),
                      const SizedBox(
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
                                borderSide: const BorderSide()),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: const BorderSide()),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(borderRadius1),
                                borderSide: const BorderSide()),
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
                      const SizedBox(
                        height: 10,
                      ),
                      Text("Email", style: textStyle1),
                      TextFormField(
                        initialValue: "",
                        enableSuggestions: false,
                        autocorrect: false,
                        autofocus: false,
                        onChanged: (value) {
                          userDataModel.email = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty ||
                              !userDataModel.validateEmail(value))
                            return "Invalid Email";
                          return null;
                        },
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(borderRadius1),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(borderRadius1),
                              borderSide: const BorderSide()),
                        ),
                      ),
                      const SizedBox(
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
                              borderSide: const BorderSide()),
                        ),
                      ),
                      const SizedBox(
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
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
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
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                          splashColor: const Color.fromARGB(72, 255, 255, 255),
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
                                      builder: (context) => Login(
                                            parentUpdateFunction:
                                                widget.parentUpdateFunction,
                                          )));
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
