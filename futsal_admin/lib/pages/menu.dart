import 'package:flutter/material.dart';
import 'package:futsal_admin/pages/add_new_ground.dart';
import 'package:futsal_admin/pages/ground_card.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreen();
}

class _MenuScreen extends State<MenuScreen> {
  List<Map<String, dynamic>>? groundData;
  bool groundsDataLoading = true;

  Future handleLoadMyGrounds() async {
    setState(() {
      groundsDataLoading = true;
    });
    groundData = await Supabase.instance.client
        .from("ground")
        .select()
        .eq('owner_id', Supabase.instance.client.auth.currentUser!.id);

    setState(() {
      groundsDataLoading = false;
    });
  }

  @override
  @override
  void initState() {
    handleLoadMyGrounds();
    super.initState();
  }

  TextStyle textStyle1 = TextStyle(fontSize: 50, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
              width: MediaQuery.sizeOf(context).width,
              child: RefreshIndicator(
                color: Colors.black,
                onRefresh: () async {
                  groundsDataLoading = true;
                  groundData = null;
                  setState(() {});

                  await handleLoadMyGrounds();
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'BookMyPitch',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AddNewGround()));
                          },
                          child: Ink(
                              height: 50,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Center(
                                child: Text("Add new +"),
                              ))),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Your Grounds",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: groundsDataLoading
                            ? Skeletonizer(
                                child: Column(
                                  children: List.generate(
                                      1, (i) => GroundCardSkeleton()),
                                ),
                              )
                            : Column(
                                children: groundData!.isEmpty
                                    ? [
                                        const Center(
                                          child: Text(
                                              "You don't have any grounds"),
                                        )
                                      ]
                                    : groundData!
                                        .map<Widget>((item) =>
                                            GroundCard(GroundInfoModel(
                                              imageUrl: item["thumbnail"],
                                              address: item["address"],
                                              name: item["ground_name"],
                                              ownerId: item["owner_id"],
                                              price: item['price'],
                                              groundId: item["id"],
                                              latitude:
                                                  item["latitude"].toString(),
                                              longitude:
                                                  item["longitude"].toString(),
                                              ratings: item["ratings"],
                                            )))
                                        .toList(),
                              ),
                      )
                    ],
                  ),
                ),
              ))
        ],
      )),
    );
  }
}
