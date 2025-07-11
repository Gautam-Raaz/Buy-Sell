import 'dart:io';

import 'package:buy_and_sell/controller/user_controller.dart';
import 'package:buy_and_sell/models/product.dart';
import 'package:buy_and_sell/models/user.dart';
import 'package:buy_and_sell/screen/login_screen.dart';
import 'package:buy_and_sell/widget/product_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/cons.dart';

class EditProfile extends StatefulWidget {
  final User data;
  const EditProfile({super.key, required this.data});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isloading = false;

  bool isHidden = true;

  void showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white),
        title: Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  children: [
                    // profile pic
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        ImagePicker()
                            .pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 100,
                            )
                            .then((value) {
                              if (value != null) {
                                setState(() {
                                  widget.data.profilePic = value.path;
                                });
                              }
                            });
                      },
                      child: ClipOval(
                        child: Image(
                          image:
                              widget.data.profilePic.contains('firebasestorage')
                              ? NetworkImage(widget.data.profilePic)
                              : FileImage(File(widget.data.profilePic)),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // name
                    SizedBox(height: 20),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        'Profile Name',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey[200],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          widget.data.name = value;
                        },
                        controller: TextEditingController(
                          text: widget.data.name,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter your name',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),

                    // phoneNumber
                    SizedBox(height: 20),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        'Phone Number',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey[200],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          widget.data.phoneNumber = value;
                        },
                        controller: TextEditingController(
                          text: widget.data.phoneNumber,
                        ),
                        readOnly: true,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Phone Number',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text("+91")],
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),

                    // password
                    SizedBox(height: 20),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.grey[200],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          widget.data.password = value;
                        },
                        controller: TextEditingController(
                          text: widget.data.password,
                        ),
                        obscureText: isHidden,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter Password',
                          hintStyle: TextStyle(color: Colors.grey),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                isHidden = !isHidden;
                              });
                            },
                            child: Icon(
                              isHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),

                    SizedBox(height: 30),

                    InkWell(
                      onTap: () async {
                        if (widget.data.name.replaceAll(" ", '').length < 5) {
                          showSnack("Name must be minimum 5 character");
                        } else if (widget.data.password
                                .replaceAll(' ', '')
                                .length <
                            8) {
                          showSnack("Please Enter password of atleast 8 digit");
                        } else {
                          setState(() {
                            isloading = true;
                          });

                          if (!widget.data.profilePic.contains(
                            'firebasestorage',
                          )) {
                            final storageRef = FirebaseStorage.instance.ref();

                            final profile = storageRef.child(
                              "buy_and_sell/profile_img/${widget.data.phoneNumber}_prof.jpg",
                            );

                            try {
                              await profile.putFile(
                                File(widget.data.profilePic),
                              );

                              widget.data.profilePic = await profile
                                  .getDownloadURL();

                              bool success = await UserController()
                                  .updateUserData(widget.data.toJson());

                              if (success) {
                                setState(() {
                                  isloading = false;
                                });

                                 Navigator.pop(context, true);

                                 showSnack("Profile update successfuly");
                              } else {
                                setState(() {
                                  isloading = false;
                                });

                                 showSnack("Something went wrong");
                              }
                            } catch (e) {
                              setState(() {
                                isloading = false;
                              });

                              showSnack("Something went wrong");
                            }
                          }
                        }
                      },
                      child: Center(
                        child: Container(
                          height: 40,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
