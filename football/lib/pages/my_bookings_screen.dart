import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyBookings extends StatefulWidget {
  const MyBookings({super.key});

  @override
  State<MyBookings> createState() => _MyBookings();
}

class _MyBookings extends State<MyBookings> {
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
  TextStyle textStyle1 =
      TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold);

  final supabase = Supabase.instance.client;
  List<dynamic>? bookingsData;
  bool isLoading = true;
  DateTime serverTime = DateTime.now();

  @override
  void initState() {
    fetchMyBookingsData();

    super.initState();
  }

  void confirmCancelBooking(BuildContext context, obj) {
    //show diaglog

    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: Colors.black),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Confirm", style: TextStyle(color: Colors.black)),
      onPressed: () async {
        handleCancelBooking(obj);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Cancel Booking"),
      content: Text("Are you sure that you want to cancel the booking?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showMessageFromServerAfterCancel(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => const AlertDialog(
              title: Text('Message from server'),
              content: Text("To be implemented!!"),
            ));
  }

  Future handleCancelBooking(obj) async {
    try {
      await supabase
          .from('bookings')
          .update({'booking_state': 1})
          .eq('ground_id', obj['ground_id'])
          .or('booking_date.eq.${obj['booking_date']}');

      obj['booking_state'] = 1;
      setState(() {});

      showMessageFromServerAfterCancel(context);
    } catch (e) {
      print(e);
    }
  }

  Future fetchMyBookingsData() async {
    if (supabase.auth.currentUser == null) return;
    try {
      dynamic serverTime_ = await supabase.rpc('get_current_timestamp');
      serverTime = DateTime.parse(serverTime_);
      // print(serverTime_);

      bookingsData = await supabase
          .from("bookings")
          .select('ground(ground_name, price), *')
          .match({'user_id': supabase.auth.currentUser!.id}).order(
              "current_timestamp",
              ascending: false);

      setState(() {
        isLoading = false;
      });
    } catch (e) {}
    //print(bookingsData);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle1 =
        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    return Scaffold(
        appBar: AppBar(
          title: Text("My Bookings"),
        ),
        body: SafeArea(
            child: isLoading
                ? Skeletonizer(
                    enabled: isLoading,
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Skeleton.unite(
                              child: Card(
                            child: ListTile(
                              title: Text('Item number $index as title'),
                              subtitle: const Text('Subtitle here'),
                              trailing: const Icon(Icons.ac_unit),
                            ),
                          )),
                        );
                      },
                    ),
                  )
                : RefreshIndicator(
                    color: Colors.black,
                    child: ListView(
                        children: bookingsData!.length == 0
                            ? [
                                Center(
                                    child: Text("You don't have any bookings"))
                              ]
                            : bookingsData!.map((item) {
                                DateTime dateTime =
                                    DateTime.parse(item['booking_date'])
                                        .toLocal();

                                String fromTime = (dateTime.hour % 12) == 0
                                    ? '12 PM'
                                    : '${dateTime.hour % 12} ${dateTime.hour > 12 ? 'PM' : 'AM'}';

                                String toTime = ((dateTime.hour + 1) % 12) == 0
                                    ? '12 PM'
                                    : '${(dateTime.hour + 1) % 12} ${(dateTime.hour + 1) > 12 ? 'PM' : 'AM'}';

                                return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Card(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(10),
                                        width: MediaQuery.sizeOf(context).width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(item['ground']['ground_name'],
                                                style: textStyle1),
                                            Column(children: [
                                              Text(
                                                  "${dateTime.day} ${monthsShort[dateTime.month - 1]}",
                                                  style: textStyle1),
                                              Text("${fromTime} - ${toTime}",
                                                  style: textStyle1),
                                            ]),
                                            Text(
                                              '₹ ${item['ground']['price']}',
                                              style: textStyle1,
                                            ),
                                            dateTime.isAfter(serverTime)
                                                ? InkWell(
                                                    onTap:
                                                        (item['booking_state'] ==
                                                                0)
                                                            ? () async {
                                                                // await handleCancelBooking(
                                                                //     item[
                                                                //         'ground_id'],
                                                                //     item[
                                                                //         'booking_date'],
                                                                //     item);
                                                                confirmCancelBooking(
                                                                    context,
                                                                    item);
                                                              }
                                                            : null,
                                                    child: Ink(
                                                      width: 120,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      decoration: BoxDecoration(
                                                          border: item[
                                                                      'booking_state'] ==
                                                                  2
                                                              ? Border.all(
                                                                  color: Colors
                                                                      .black26)
                                                              : null,
                                                          color: item['booking_state'] ==
                                                                  1
                                                              ? Colors
                                                                  .lightGreen
                                                              : (item['booking_state']) ==
                                                                      2
                                                                  ? Colors
                                                                      .transparent
                                                                  : Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: Text(
                                                          item['booking_state'] ==
                                                                  1
                                                              ? "Pending"
                                                              : (item['booking_state']) ==
                                                                      2
                                                                  ? 'Canceled'
                                                                  : 'Cancel',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color: (item[
                                                                          'booking_state'] ==
                                                                      2)
                                                                  ? Colors
                                                                      .black26
                                                                  : Colors
                                                                      .white,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                  )
                                                : SizedBox(width: 120)
                                          ],
                                        ),
                                      ),
                                    ));
                              }).toList()),
                    onRefresh: () async {
                      try {
                        fetchMyBookingsData();
                      } catch (e) {}
                    })));
  }
}
