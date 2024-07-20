import 'package:flutter/material.dart';

import 'package:skeletonizer/skeletonizer.dart';
import 'package:football/pages/ground_card.dart';
import 'package:football/pages/user_profile.dart';
import 'package:football/theme/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  // await dotenv.load(fileName: "assets/.env");
  await Supabase.initialize(
    url: 'https://koqpexhyqslmjawzxlvz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtvcXBleGh5cXNsbWphd3p4bHZ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAwMDIxMDMsImV4cCI6MjAzNTU3ODEwM30.FJtZyyMagSTKHIRHxZZAsdQr_vr6NFi8G5D623q0UVo',
  );

  // runApp(ChangeNotifierProvider(
  //   create: (context) => ThemeProvider(),
  //   child: const Menu(),
  // ));

  runApp(const Menu());
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => MyMenu();
  // This widget is the root of your application.
}

class MyMenu extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Football app',
        darkTheme: darkmode,
        theme: lightmode,
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final supabase = Supabase.instance.client;
  dynamic groundData;
  bool groundsDataLoading = true;

  Future<void> fetchData() async {
    try {
      groundData = await supabase.from('ground').select();
      //print(groundData);
      groundsDataLoading = false;
    } catch (e) {}

    setState(() {});
  }

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BookMyPitch',
      darkTheme: darkmode,
      theme: lightmode,
      home: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                  ),
                  Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfile()));
                        },
                        icon: const Icon(
                          Icons.account_circle,
                          size: 50,
                        ),
                      )),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("BookMyPitch",
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: 40,
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 30),
                        child: Text("Your Game, Your Pitch!",
                            style: TextStyle(
                                fontFamily: 'Prompt',
                                fontSize: 20,
                                fontWeight: FontWeight.w400)),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 20),
                      //   child: TextField(
                      //     autofocus: false,
                      //     cursorColor: Colors.black,
                      //     decoration: InputDecoration(
                      //         focusedBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //             borderSide: const BorderSide()),
                      //         enabledBorder: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //             borderSide: const BorderSide()),
                      //         border: OutlineInputBorder(
                      //             borderRadius: BorderRadius.circular(10),
                      //             borderSide: const BorderSide()),
                      //         hintText: "Search"),
                      //   ),
                      // )
                      //TournamentCard()
                    ],
                  )
                ],
              ),
              Expanded(
                child: groundsDataLoading
                    ? Skeletonizer(
                        child: ListView.builder(
                            itemCount: 2,
                            itemBuilder: (context, index) =>
                                GroundCardSkeleton()),
                      )
                    : RefreshIndicator(
                        color: Colors.black,
                        onRefresh: () async {
                          groundsDataLoading = true;
                          groundData = null;
                          setState(() {});

                          await fetchData();
                        },
                        child: ListView(
                          children: groundData
                              .map<Widget>((item) => GroundCard(GroundInfoModel(
                                    imageUrl: item["thumbnail"],
                                    address: item["address"],
                                    name: item["ground_name"],
                                    ownerId: item["owner_id"],
                                    price: item['price'],
                                    groundId: item["id"],
                                    latitude: item["latitude"].toString(),
                                    longitude: item["longitude"].toString(),
                                    ratings: item["ratings"],
                                  )))
                              .toList(),
                        ),
                      ),
              )
            ],
          ),
        )),
      ),
    );
  }
}

class TournamentCard extends StatelessWidget {
  const TournamentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        child: Stack(
          children: [
            Positioned(
                top: -10,
                right: 20,
                child: Image.asset(
                  "assets/logo1.png",
                  width: 200,
                )),
            SizedBox(
              height: 200,
              width: MediaQuery.sizeOf(context).width,
            )
          ],
        ),
      ),
    );
  }
}
