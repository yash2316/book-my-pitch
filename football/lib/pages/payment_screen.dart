import 'package:football/pages/ground_card.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final DateTime timings;
  final GroundInfoModel groundInfoModel;
  const PaymentScreen(
      {required this.timings, required this.groundInfoModel, super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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
  Map<String, dynamic>? paymentIntent;

  Future handleConfirmBooking(context) async {
    try {
      await supabase.from('bookings').insert({
        'user_id': supabase.auth.currentUser!.id,
        'ground_id': widget.groundInfoModel.groundId,
        // 'booking_date': '${widget.timings.year}-${widget.timings.month}-${widget.timings.year}'
        'booking_date': widget.timings.toIso8601String()
      });
      var snackBar = SnackBar(content: Text('Success'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on PostgrestException catch (e) {
      print(e);
      if (e.code == "23505") {
        var snackBar = SnackBar(content: Text('ALready booked'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 300,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.groundInfoModel.name,
                    style: textStyle1,
                  ),
                  Text(
                    '${widget.timings.day} ${monthsShort[widget.timings.month - 1]}',
                    style: textStyle1,
                  ),
                  Text(
                    "${widget.timings.hour} - ${widget.timings.hour + 1}",
                    style: textStyle1,
                  ),
                  Text(
                    "Amount: to be decided",
                    style: textStyle1,
                  )
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              child: InkWell(
                onTap: () async {
                  handleConfirmBooking(context);
                  //handlePayment();
                },
                child: Ink(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: Text(
                      "Confirm Payment",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
