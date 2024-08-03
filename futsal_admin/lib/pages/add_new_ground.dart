import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewGroundDataModel {
  String? groundName;
  String? address;
  int? price;
  double? lattitude;
  double? longitude;
  String? imageUrl;
}

class AddNewGround extends StatefulWidget {
  const AddNewGround({super.key});

  @override
  State<AddNewGround> createState() => _NewGround();
}

class _NewGround extends State<AddNewGround> {
  NewGroundDataModel newGroundDataModel = NewGroundDataModel();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  File? image;

  Future pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
// Pick an image.
      final XFile? res = await picker.pickImage(source: ImageSource.gallery);

      if (res != null) {
        setState(() {
          image = File(res.path);
        });
      } else {
        print("No file selected");
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future handleAddGround() async {
    setState(() {
      isLoading = true;
    });

    //print(newGroundDataModel);
    try {
      if (image != null) {
        await handleImageUpload();
      }

      await handleInsertDatabase();

      if (mounted) {
        showMessageModal(true, context);

        Future.delayed(Duration(seconds: 4), () {
          Navigator.of(context).pop();
          _formKey.currentState!.reset();
        });
      }
    } catch (e) {
      if (mounted) {
        showMessageModal(false, context);

        Future.delayed(Duration(seconds: 4), () {
          Navigator.of(context).pop();
        });
      }
    }

    await Future.delayed(Duration(milliseconds: 1), () {
      isLoading = false;
    });
    setState(() {});
  }

  Future handleInsertDatabase() async {
    try {
      await Supabase.instance.client.from('ground').insert({
        'ground_name': newGroundDataModel.groundName,
        'address': newGroundDataModel.address,
        'longitude': newGroundDataModel.longitude,
        'latitude': newGroundDataModel.lattitude,
        'owner_id': Supabase.instance.client.auth.currentUser!.id,
        'thumbnail': newGroundDataModel.imageUrl,
        'price': newGroundDataModel.price
      });
    } catch (e) {
      print('Error at insertdatabase: $e');
    }
  }

  Future handleImageUpload() async {
    String ext =
        image!.path.substring(image!.path.length - 4, image!.path.length);

    Random random = Random();

    try {
      String path =
          '${newGroundDataModel.groundName!.replaceAll(' ', '')}${random.nextInt(100)}${ext}';
      await Supabase.instance.client.storage.from('images').upload(
            path,
            image!,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      final String publicUrl = await Supabase.instance.client.storage
          .from('images')
          .getPublicUrl(path);

      newGroundDataModel.imageUrl = publicUrl;
    } catch (e) {
      print('error: $e');
    }
  }

  void showMessageModal(bool isSuccess, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("Message"),
              content: Row(
                children: [
                  isSuccess
                      ? const Icon(
                          Icons.check_circle_outline,
                          color: Colors.lightGreen,
                        )
                      : const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                  Text(isSuccess ? "Added Successfully" : "Error")
                ],
              ),
            ));
  }

  TextStyle textStyle1 =
      const TextStyle(fontSize: 50, fontWeight: FontWeight.bold);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.sizeOf(context).height;
    double width = MediaQuery.sizeOf(context).width;

    double borderRadius1 = 5;
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: SingleChildScrollView(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "Add new ground",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        autofocus: false,
                        enableSuggestions: false,
                        autocorrect: false,
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          newGroundDataModel.groundName = value;
                        },
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'Ground Name',
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(borderRadius1),
                              borderSide: const BorderSide()),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(borderRadius1),
                              borderSide: const BorderSide()),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLines: 4,
                        keyboardType: TextInputType.streetAddress,
                        autofocus: false,
                        enableSuggestions: false,
                        autocorrect: false,
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          newGroundDataModel.address = value;
                        },
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'Address',
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(borderRadius1),
                              borderSide: const BorderSide()),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(borderRadius1),
                              borderSide: const BorderSide()),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        enableSuggestions: false,
                        autocorrect: false,
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          newGroundDataModel.price = int.tryParse(value);
                        },
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return "Cannot be empty";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          labelText: 'Price',
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(borderRadius1),
                              borderSide: const BorderSide()),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(borderRadius1),
                              borderSide: const BorderSide()),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                              splashColor:
                                  const Color.fromARGB(72, 255, 255, 255),
                              onTap: () {
                                pickImage();
                              },
                              child: Ink(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Select Image",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          image == null
                              ? const SizedBox()
                              : Container(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  height: 200,
                                  width: 200,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.file(
                                        image!,
                                        height: 100,
                                      ),
                                      Positioned(
                                        top: -10,
                                        right: -10,
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.cancel,
                                            size: 30,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              image = null;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )),
          ),
          Positioned(
            bottom: 0,
            child: InkWell(
                splashColor: const Color.fromARGB(72, 255, 255, 255),
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    handleAddGround();
                  }
                },
                child: Ink(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                  height: 50,
                  width: width,
                  child: const Center(
                    child: Text(
                      "Add",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ),
          isLoading
              ? Container(
                  decoration:
                      const BoxDecoration(color: Color.fromARGB(62, 0, 0, 0)),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
              : const SizedBox()
        ],
      )),
    );
  }
}
