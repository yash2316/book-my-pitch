import 'package:flutter/material.dart';
import 'package:football/pages/ground_screen.dart';

class GroundInfoModel {
  final String? imageUrl;
  final String address;
  final String name;
  final String? latitude;
  final String? longitude;
  final String? ratings;
  final String ownerId;
  final int groundId;
  final int price;

  GroundInfoModel({
    this.imageUrl,
    required this.address,
    required this.name,
    required this.ownerId,
    required this.groundId,
    required this.price,
    this.ratings,
    this.latitude,
    this.longitude,
  });
}

class GroundCard extends StatelessWidget {
  GroundCard(this.groundInfoModel, {super.key});

  final GroundInfoModel groundInfoModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Hero(
                    tag: groundInfoModel.imageUrl ?? "assets/bg.jpg",
                    child: groundInfoModel.imageUrl == null
                        ? Image.asset("assets/bg.jpg")
                        : FadeInImage.assetNetwork(
                            placeholder: "assets/bg.jpg",
                            image: groundInfoModel.imageUrl ?? "assets/bg.jpg",
                            fit: BoxFit.cover,
                          )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 5),
              child: Text(
                groundInfoModel.name,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.location_pin, color: Colors.grey.shade600),
                    Text(groundInfoModel.address,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600))
                  ],
                ))
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    GroundScreen(groundInfoModel: groundInfoModel)));
      },
    );
  }
}

class GroundCardSkeleton extends StatelessWidget {
  GroundCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Image.asset(
                "assets/bg.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 5),
            child: Text(
              "groundInfoModel.address",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                children: [
                  Icon(Icons.location_pin, color: Colors.grey.shade600),
                  Text('groundInfoModel.address',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600))
                ],
              ))
        ],
      ),
    );
  }
}
