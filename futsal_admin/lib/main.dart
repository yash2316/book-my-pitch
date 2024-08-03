import 'package:flutter/material.dart';
import 'package:futsal_admin/pages/login.dart';
import 'package:futsal_admin/pages/menu.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://koqpexhyqslmjawzxlvz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtvcXBleGh5cXNsbWphd3p4bHZ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAwMDIxMDMsImV4cCI6MjAzNTU3ODEwM30.FJtZyyMagSTKHIRHxZZAsdQr_vr6NFi8G5D623q0UVo',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookMyPitch Admin',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 255, 96, 38),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final supabase = Supabase.instance;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Supabase.instance.client.auth.currentUser == null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Login(
                      parentUpdateFunction: setState,
                    )));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Supabase.instance.client.auth.currentUser == null
              ? Container(
                  height: MediaQuery.sizeOf(context).height,
                  width: MediaQuery.sizeOf(context).width,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        "assets/bg1.jpg",
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            gradient: LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                                  Color.fromARGB(255, 0, 0, 0).withOpacity(0.0),
                                  Colors.black,
                                ],
                                stops: [
                                  0.0,
                                  1.0
                                ])),
                      ),
                      Positioned(
                        left: 100,
                        right: 100,
                        bottom: 100,
                        child: InkWell(
                            splashColor: Color.fromARGB(72, 255, 255, 255),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login(
                                            parentUpdateFunction: setState,
                                          )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 50,
                              width: 150,
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
                      ),
                    ],
                  ),
                )
              : MenuScreen()
          // : SafeArea(
          //     child: Center(
          //     child: Column(
          //       children: [
          //         TextButton(
          //             onPressed: () {
          //               Supabase.instance.client.auth.signOut();
          //               setState(() {});
          //             },
          //             child: Text("signout")),
          //         TextButton(
          //             onPressed: () {
          //               print(supabase.client.auth.currentUser!
          //                   .userMetadata!['admin']);
          //             },
          //             child: Text("flag"))
          //       ],
          //     ),
          //   ))

          ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
