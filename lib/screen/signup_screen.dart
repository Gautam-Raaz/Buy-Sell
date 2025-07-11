import 'package:buy_and_sell/constant/cons.dart';
import 'package:buy_and_sell/controller/auth_controller.dart';
import 'package:buy_and_sell/models/user.dart';
import 'package:buy_and_sell/screen/dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignupScreen extends StatefulWidget {
   SignupScreen({super.key, });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {



  String name = "";
  String phoneNumber = "";
  String password = "";
  String profilePic = "";
  bool isloading = false;
  bool isHidden = true;


  void showSnack(String text) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.white,),
        title: Text("SignUp",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
      ),
      body: isloading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [

              // profile pic
              SizedBox(height: 20,),
              InkWell(
                onTap: () {

                  ImagePicker()
                      .pickImage(
                      source: ImageSource.gallery, imageQuality: 100)
                      .then((value) {

                    if(value != null) {
                      setState(() {
                        profilePic = value.path;
                      });
                    }

                  });
                },
                child: ClipOval(
                  child: profilePic.isEmpty
                      ? Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey[300],
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.person,size: 50,color: Colors.white,),

                      ],
                    ),
                  )
                      : Image(
                    image: FileImage(
                      File(profilePic),
                    ),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                ),
              ),

              // name
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Profile Name',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
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
                    name = value;
                  },
                  controller: TextEditingController(text: name),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

             

              // phoneNumber
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Phone Number',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
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
                    phoneNumber = value;
                  },
                  controller: TextEditingController(text: phoneNumber),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Phone Number',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    prefixIcon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("+91"),
                      ],
                    )
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

 
             

            


              // password
              SizedBox(height: 20,),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Password',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
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
                    password = value;
                  },
                  controller: TextEditingController(text: password),
                  obscureText: isHidden,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Password',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            isHidden = !isHidden;
                          });
                        },
                        child: Icon( isHidden ? Icons.visibility_off : Icons.visibility,color: Colors.black,),
                      )
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              SizedBox(height: 30,),

             Center(
                child: InkWell(
                  onTap: () async{

                    if(profilePic.isEmpty) {
                      showSnack("Please upload your profile pic");
                    } else if(name.replaceAll(" ",'').length < 5) {
                      showSnack("Name must be minimum 5 character");
                    } else if(phoneNumber.isEmpty) {
                      showSnack("Please Enter phone number");
                    }  else if(password.isEmpty) {
                      showSnack("Please Enter password");
                    }  else if(password.replaceAll(' ', '').length < 8) {
                      showSnack("Please Enter password of atleast 8 digit");
                    } else if(phoneNumber.replaceAll(' ', '').length != 10) {
                      showSnack("Please Enter Correct phone number");
                    } else {
                    phoneNumber = phoneNumber.trim();

                      setState(() {
                        isloading = true;
                      });

                     
                        await FirebaseFirestore.instance.collection(
                            Constant.userTable).doc(phoneNumber).get().then((
                            doc) async {
                          if (doc.exists) {
                            showSnack("Phone Number already exists");
                            setState(() {
                              isloading = false;
                            });
                          } else {
                            final storageRef = FirebaseStorage.instance.ref();

                            final profile = storageRef.child(
                                "buy_and_sell/profile_img/${phoneNumber}_prof.jpg");




                            try {
                              await profile.putFile(File(profilePic));

                              String profileUrl = await profile
                                  .getDownloadURL();

                               var data = User(
                                name: name,
                                phoneNumber: phoneNumber,
                                password: password,                                
                                profilePic: profileUrl,
                                watchlist: []
                               );



                             bool sucess = await AuthController().signUp(data);


                             if(sucess) {
                                setState(() {
                                isloading = false;
                              });
                                                            
                          showSnack("SignUp Successfuly");

                           final SharedPreferences prefs = await SharedPreferences.getInstance();
                           await prefs.setString(Constant.phone, phoneNumber);

                           Navigator.pushReplacement(
                             context,MaterialPageRoute(builder: (context) => Dashboard()),);
                              
                             } else {

                              setState(() {
                                isloading = false;
                              });

                               showSnack("Some error happen");
                             
                             }



                            } catch (e) {
                              showSnack("Something went wrong");
                              setState(() {
                                isloading = false;
                              });
                            }
                          }
                        }
                      );
                      
                    }
                  },
                  child: Container(
                    height: 40,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Text("Sign Up",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ),
              ),



              SizedBox(height: 30,),





            ],
          ),
        ),
      ),
    );
  }
}
