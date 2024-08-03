import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreen();
}

class _OtpScreen extends State<OtpScreen> {
  String errorMessage = '';
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = FocusNode();
  late List<FocusNode> focusList = List.generate(6, (i) => FocusNode());
  List<TextEditingController> controllerList =
      List.generate(6, (i) => TextEditingController());
  int pos = 0;
  double borderRadius1 = 5.0;
  TextStyle textStyle1 = const TextStyle(
      color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold);

  void handleChange(int i, String value) {
    //print(controllerList[i].text);
    if (value.length == 1) {
      if (i < 5) {
        focusList[i + 1].requestFocus();
        pos = i + 1;
      }
    } else {
      if (i > 0) {
        focusList[i - 1].requestFocus();
        pos = i - 1;
      }
    }
  }

  void handleTap(int i) {
    focusList[pos].requestFocus();
  }

  void handleOtpSubmit() {
    String otpValue = "";
    for (var x in controllerList) {
      otpValue += x.text;
    }
    if (otpValue == "123456") print("yes??");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Stack(
          children: [
            Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Enter OTP (Hint: 123456)",
                      style: textStyle1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                          6,
                          (i) => Padding(
                                padding: EdgeInsets.all(5),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: TextFormField(
                                    onChanged: (value) {
                                      handleChange(i, value);
                                    },
                                    onTap: () {
                                      handleTap(i);
                                    },
                                    validator: (value) {
                                      return null;
                                    },
                                    controller: controllerList[i],
                                    focusNode: focusList[i],
                                    maxLength: 1,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textAlign: TextAlign.center,
                                    enableSuggestions: false,
                                    keyboardType: TextInputType.phone,
                                    autocorrect: false,
                                    autofocus: false,
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            borderRadius1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              borderRadius1),
                                          borderSide: const BorderSide()),
                                    ),
                                  ),
                                ),
                              )),
                    ),
                    Text(
                      "$errorMessage",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                )),
            Positioned(
                bottom: 0,
                child: InkWell(
                    splashColor: Color.fromARGB(72, 255, 255, 255),
                    onTap: () {
                      for (var x in controllerList) {
                        if (x.text.length == 0) {
                          errorMessage = 'Please complete OTP';
                          Future.delayed(Duration(seconds: 3), () {
                            errorMessage = '';
                            setState(() {});
                          });
                          setState(() {});
                          return;
                        }
                      }

                      handleOtpSubmit();
                    },
                    child: Ink(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(borderRadius1)),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )))
          ],
        ),
      )),
    );
  }
}
