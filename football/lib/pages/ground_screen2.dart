import 'package:flutter/material.dart';
import 'package:football/pages/ground_card.dart';
import 'package:football/pages/login.dart';
import 'package:football/pages/payment_booking.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class BookNowButton extends StatefulWidget {
  final int selectedSlot;
  final DateTime selectedDay;
  final GroundInfoModel groundInfoModel;
  final supabase = Supabase.instance.client;
  final Function setStateMethod;

  BookNowButton(
      {super.key,
      required this.setStateMethod,
      required this.selectedDay,
      required this.groundInfoModel,
      required this.selectedSlot});

  Future handlePayment(DateTime time, BuildContext context) async {
    setStateMethod();

    Payment payment = Payment.obj(obj: {
      'user_id': supabase.auth.currentUser!.id,
      'ground_id': groundInfoModel.groundId,
      'amount': groundInfoModel.price * 100,
      'currency': 'inr',
      'timestamp': time.toIso8601String()
    });

    await payment.makePayment(context);

    setStateMethod();
  }

  @override
  State<StatefulWidget> createState() {
    return BookNowButtonState();
  }
}

class BookNowButtonState extends State<BookNowButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.white,
        onTap: () async {
          if (widget.selectedSlot == -1) {
            return;
          }
          if (widget.supabase.auth.currentUser == null) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Login()));
          } else {
            DateTime time = widget.selectedDay.copyWith(
                hour: widget.selectedSlot,
                minute: 0,
                second: 0,
                millisecond: 0,
                microsecond: 0);
            //print("day: $bookin");
            widget.handlePayment(time, context);
          }
        },
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          color: Theme.of(context).primaryColor,
          child: Center(
            child: Text(
              "Book Now",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}

class SkeletonDateTile extends StatelessWidget {
  SkeletonDateTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
        child: Padding(
            padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(70, 45, 40, 40), blurRadius: 10)
                  ]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("text",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 5, 5, 5))),
                  Text(
                    "text",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 18, 15, 15)),
                  )
                ],
              ),
            )));
  }
}

class GroundDescription extends StatefulWidget {
  GroundDescription({super.key, required this.groundInfoModel});

  final GroundInfoModel groundInfoModel;

  @override
  State<GroundDescription> createState() => _GroundDescriptionState();
}

class _GroundDescriptionState extends State<GroundDescription>
    with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  double angle = 0;
  dynamic descriptionData;
  TextStyle textStyle1 = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
  TextStyle textStyle2 = TextStyle(
    fontSize: 20,
  );

  Future fetchOwnerData() async {
    descriptionData = await Supabase.instance.client
        .from('owner')
        .select('*')
        .eq('owner_id', widget.groundInfoModel.ownerId);
  }

  @override
  void initState() {
    fetchOwnerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: (value) {
        isExpanded = !isExpanded;
        angle = angle == 0 ? 3.14 : 0;

        // rotationController.reset();
        setState(() {});
      },
      leading: SizedBox.shrink(),
      trailing: SizedBox.shrink(),
      title: Container(
        child: Transform.rotate(
          angle: angle,
          child: Transform.scale(
            scaleX: 1.7,
            child: Icon(
              Icons.keyboard_double_arrow_down,
              // color: Theme.of(context).primarySwatch,
              size: 40,
            ),
          ),
        ),
      ),
      children: descriptionData == null
          ? []
          : [
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Owner: ${descriptionData[0]['owner_first_name']} ${descriptionData[0]['owner_last_name']}",
                        style: textStyle1),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text("Contact: ", style: textStyle1),
                        SelectableText(
                            "+91 ${descriptionData[0]['owner_phone']}",
                            cursorColor: Colors.black,
                            showCursor: true,
                            style: textStyle1)
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Email: ${descriptionData[0]['owner_email'] ?? '-'}",
                        style: textStyle1),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Address: ${widget.groundInfoModel.address}',
                        overflow: TextOverflow.fade, style: textStyle1),
                    Center(
                      child: IconButton(
                        onPressed: () async {
                          if (widget.groundInfoModel.latitude == null ||
                              widget.groundInfoModel.longitude == null) return;

                          String googleUrl =
                              'https://www.google.com/maps/search/?api=1&query=${widget.groundInfoModel.latitude},${widget.groundInfoModel.longitude}';
                          //print(googleUrl);
                          if (await canLaunchUrl(Uri.parse(googleUrl))) {
                            await launchUrl(Uri.parse(googleUrl));
                          } else {
                            throw 'Could not open the map.';
                          }
                        },
                        icon: Icon(Icons.location_pin),
                      ),
                    )
                  ],
                ),
              )
            ],
    );
  }
}
