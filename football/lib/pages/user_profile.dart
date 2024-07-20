import 'package:flutter/material.dart';
import 'package:football/pages/login.dart';
import 'package:football/pages/my_bookings_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfile();
}

class _UserProfile extends State<UserProfile> {
  final supabase = Supabase.instance.client;
  User? user;

  @override
  void initState() {
    user = supabase.auth.currentUser;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: RefreshIndicator(
        color: Colors.black,
        onRefresh: () {
          try {
            setState(() {});
            user = supabase.auth.currentUser;
          } catch (e) {
            print(e);
          }
          return Future.value(1);
        },
        child: ListView(
          children: [
            Container(
                height: MediaQuery.sizeOf(context).height - 80,
                width: MediaQuery.sizeOf(context).width,
                child: supabase.auth.currentUser != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  "assets/pfp.avif",
                                  width: 100,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                  "${user!.userMetadata!['first_name']} ${user!.userMetadata!['last_name']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              Text("+${user!.phone} ",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                              const SizedBox(
                                height: 20,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyBookings()));
                                },
                                child: Ink(
                                  width: MediaQuery.sizeOf(context).width - 40,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: const Text("My Bookings",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          )),
                          InkWell(
                              splashColor:
                                  const Color.fromARGB(72, 255, 255, 255),
                              onTap: () {
                                supabase.auth.signOut();

                                setState(() {});
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30)),
                                height: 50,
                                width: 200,
                                child: const Center(
                                  child: Text(
                                    "Logout",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                        ],
                      )
                    : Center(
                        child: InkWell(
                            splashColor: Color.fromARGB(72, 255, 255, 255),
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()));
                            },
                            child: Ink(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(30)),
                              height: 50,
                              width: 200,
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ))))
          ],
        ),
      )),
    );
  }
}

class BookingCard extends StatefulWidget {
  BookingCard({super.key});

  @override
  State<BookingCard> createState() => _BookingCard();
}

class _BookingCard extends State<BookingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      children: [Text("gname")],
    ));
  }
}
