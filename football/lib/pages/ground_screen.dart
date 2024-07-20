// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:football/pages/ground_card.dart';
import 'package:football/pages/ground_screen2.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GroundScreen extends StatefulWidget {
  final GroundInfoModel groundInfoModel;

  GroundScreen({super.key, required this.groundInfoModel});

  @override
  State<GroundScreen> createState() => GroundScreenUI();
}

class GroundScreenUI extends State<GroundScreen> {
  List<String> monthsShort = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC"
  ];
  DateTime? serverTime = DateTime.now();
  final supabase = Supabase.instance.client;
  late int selectedSlot = -1;
  DateTime selectedDay = DateTime.now();
  List<DateTime>? futuredates;
  List<DateTime>? slotsList;
  late List<bool> isSelectedDay;
  late List<bool> isSelectedSlot;
  late List<bool> isDisabledSlot;
  List<DateTime>? bookings;

  ScrollController controller = ScrollController();

  TextStyle textStyle1 = TextStyle(fontSize: 30, fontWeight: FontWeight.bold
      // color: const Color.fromARGB(255, 93, 93, 93)
      );

  Future<void> initialiseDates() async {
    isSelectedDay = List.generate(10, (i) => false);
    isSelectedSlot = List.generate(15, (i) => false);
    isDisabledSlot = List.generate((15), (i) => true);
    isSelectedDay[0] = true;

    dynamic serverTime_ = await supabase.rpc('get_current_timestamp');
    serverTime = DateTime.parse(serverTime_);
    //print("server time: $serverTime_ => $serverTime");
    selectedDay = serverTime ?? selectedDay;

    dynamic res = await supabase
        .from("bookings")
        .select('booking_date, user_id')
        .eq('ground_id', widget.groundInfoModel.groundId)
        .gt('booking_date', serverTime_);

    // print('response line 67 : $res');

    bookings = res
        .map<DateTime>((item) => DateTime.parse(item['booking_date']).toLocal())
        .toList();

    futuredates = List.generate(10, (i) => serverTime!.add(Duration(days: i)));
    slotsList = List.generate(
        15,
        (i) => DateTime.utc(
                serverTime!.year, serverTime!.month, serverTime!.day, 8, 0, 0)
            .add(Duration(hours: i)));
    if (mounted) setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateTimeSlots(0);
    });
  }

  @override
  void initState() {
    super.initState();

    initialiseDates();

    //updateTimeSlots(0);
  }

  Future<void> updateTimeSlots(int index) async {
    isSelectedSlot.fillRange(0, isSelectedSlot.length, false);
    isDisabledSlot.fillRange(0, isDisabledSlot.length, false);
    if (index == 0) {
      dynamic serverTime_ = await supabase.rpc('get_current_timestamp');
      // print(serverTime_);
      serverTime = DateTime.parse(serverTime_);
      for (int i = 0; i < slotsList!.length; i++) {
        if (serverTime!.hour >= slotsList![i].hour) isDisabledSlot[i] = true;
      }
    }

    for (int i = 0; i < bookings!.length; i++) {
      if (bookings![i].day == futuredates![index].day &&
          bookings![i].month == futuredates![index].month &&
          bookings![i].year == futuredates![index].year) {
        if (bookings![i].hour - 8 >= 0 &&
            bookings![i].hour - 8 < isDisabledSlot.length) {
          isDisabledSlot[bookings![i].hour - 8] = true;
        }
      }
    }

    int i = 0;
    while (i < isDisabledSlot.length && isDisabledSlot[i]) {
      i++;
    }
    if (i < isSelectedSlot.length) {
      isSelectedSlot[i] = true;
      selectedSlot = slotsList![i].hour;
      if (mounted) {
        controller.animateTo(i * 120.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut);
      }
    } else {
      selectedSlot = -1;
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Color uiColor1 = Theme.of(context).primaryColor;
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          RefreshIndicator(
              color: Colors.black,
              onRefresh: () async {
                await initialiseDates();
                setState(() {});
              },
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        elevation: 10,
                        child: Container(
                          height: 200,
                          width: double.infinity,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Hero(
                                  tag: widget.groundInfoModel.imageUrl
                                      .toString(),
                                  child: FadeInImage.assetNetwork(
                                    placeholder: "assets/bg.jpg",
                                    image: widget.groundInfoModel.imageUrl
                                        .toString(),
                                    fit: BoxFit.cover,
                                  )),
                              Container(
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                        colors: [
                                      Color.fromARGB(255, 0, 0, 0),
                                      Color.fromRGBO(0, 0, 0, 0)
                                    ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter)),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      widget.groundInfoModel.name,
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white),
                                    ),
                                  ),
                                  widget.groundInfoModel.ratings == null
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10, left: 10, right: 10),
                                          child: Row(
                                            children: [
                                              ...List.generate(
                                                  double.parse(widget
                                                                  .groundInfoModel
                                                                  .ratings ==
                                                              ""
                                                          ? "1.0"
                                                          : widget.groundInfoModel
                                                                  .ratings ??
                                                              "1.0")
                                                      .floor(),
                                                  (i) => Icon(
                                                        Icons.star,
                                                        color: Colors.yellow,
                                                      ))
                                            ],
                                          ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      GroundDescription(
                          groundInfoModel: widget.groundInfoModel),
                      Padding(
                        padding: EdgeInsets.only(top: 40, left: 20),
                        child: Text(
                          "Select Date",
                          style: textStyle1,
                        ),
                      ),
                      futuredates == null
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                    5, (index) => SkeletonDateTile()),
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  futuredates!.length,
                                  (index) => Padding(
                                    padding: EdgeInsets.only(
                                        left: 20, top: 10, bottom: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        //TODO
                                        updateTimeSlots(index);
                                        setState(() {
                                          isSelectedDay.fillRange(
                                              0, isSelectedDay.length, false);
                                          isSelectedDay[index] = true;
                                          selectedDay = futuredates![index];
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeIn,
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: isSelectedDay[index]
                                                  ? uiColor1
                                                  : Colors.transparent,
                                              width: 6,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            color: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      115, 75, 75, 75),
                                                  blurRadius: 10)
                                            ]),
                                        child: index == 0
                                            ? Center(
                                                child: Text("TODAY",
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255, 29, 29, 29))),
                                              )
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${futuredates![index].day.toString()}",
                                                    style: TextStyle(
                                                        fontSize: 40,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255, 29, 29, 29)),
                                                  ),
                                                  Text(
                                                    "${monthsShort[futuredates![index].month - 1]}",
                                                    style: TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color.fromARGB(
                                                            255,
                                                            120,
                                                            120,
                                                            120)),
                                                  )
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Text(
                          "Select Slot",
                          style: textStyle1,
                        ),
                      ),
                      slotsList == null
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                    5, (index) => SkeletonDateTile()),
                              ),
                            )
                          : SingleChildScrollView(
                              controller: controller,
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  slotsList!.length,
                                  (index) {
                                    int time1, time2;
                                    time1 = slotsList![index].hour % 12;
                                    time2 = (slotsList![index].hour + 1) % 12;
                                    String t1, t2;
                                    (slotsList![index].hour) < 12
                                        ? t1 = 'AM'
                                        : t1 = 'PM';
                                    (slotsList![index].hour + 1) < 12
                                        ? t2 = 'AM'
                                        : t2 = 'PM';

                                    if (time1 == 0) time1 = 12;
                                    if (time2 == 0) time2 = 12;

                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: 20, top: 10, bottom: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isDisabledSlot[index]) return;
                                            isSelectedSlot.fillRange(0,
                                                isSelectedSlot.length, false);
                                            isSelectedSlot[index] = true;
                                            selectedSlot =
                                                slotsList![index].hour;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.easeIn,
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: isSelectedSlot[index]
                                                  ? uiColor1
                                                  : Colors.white,
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Color.fromARGB(
                                                        70, 45, 40, 40),
                                                    blurRadius: 10)
                                              ]),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${(time1).toString()} $t1",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: isSelectedSlot[index]
                                                        ? Colors.white
                                                        : isDisabledSlot[index]
                                                            ? Colors.black12
                                                            : Color.fromARGB(
                                                                255,
                                                                29,
                                                                29,
                                                                29)),
                                              ),
                                              Text(
                                                "${(time2).toString()} $t2",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: isSelectedSlot[index]
                                                        ? Colors.white
                                                        : isDisabledSlot[index]
                                                            ? Colors.black12
                                                            : Color.fromARGB(
                                                                255,
                                                                29,
                                                                29,
                                                                29)),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )),
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Text(
                          "Price : ₹ ${widget.groundInfoModel.price} / hr",
                          style: textStyle1,
                        ),
                      ),
                      SizedBox(
                        height: 100,
                      )
                    ],
                  )
                ],
              )),
          Positioned(
              bottom: 0,
              child: BookNowButton(
                selectedDay: selectedDay,
                selectedSlot: selectedSlot,
                groundInfoModel: widget.groundInfoModel,
              )),
          Positioned(
              //back button
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  )))
        ],
      ),
    ));
  }
}
