import 'package:buy_and_sell/constant/cons.dart';
import 'package:buy_and_sell/screen/dashboard_screen.dart';
import 'package:buy_and_sell/screen/signup_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isloading = false;
  String phone = '';
  String password = '';

  void showSnack(String text) {

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(   
      appBar: AppBar(
        title: Text("Login",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
        body: isloading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
         

            children: [


              // Phone Number
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
                    phone = value;
                  },
                  controller: TextEditingController(text: phone),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Phone Number',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

              // Password
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
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter password',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
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
                    
                    if(phone.length != 10) {
                      showSnack("Please Enter Correct Phone Number");
                    } else if(password.length < 8) {
                       showSnack("Please Enter Correct password");
                    } else {

                      setState(() {
                        isloading = true;
                      });


                      await FirebaseFirestore.instance.collection(Constant.userTable).doc(phone).get().then((doc) async{

                        if(doc.exists) {
                          
                         if(doc.data()!['password'] != password) {
                           showSnack("Incorrect Password");
                         } else {
                           final SharedPreferences prefs = await SharedPreferences.getInstance();
                           await prefs.setString(Constant.phone, phone);

                           Navigator.pushReplacement(
                             context,MaterialPageRoute(builder: (context) => Dashboard()),);

                         }
                        } else { 
                          showSnack("Phone Number not exists");
                        }
                      setState(() {
                        isloading = false;
                      });
                      }
                      );

                    }

                  },
                  child: Container(
                    height: 40,
                    width: 180,
                    child: Center(
                      child: Text("Login",style: TextStyle(color: Colors.white),),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20,),

              GestureDetector(
                onTap: () {

                     Navigator.push(
                             context,MaterialPageRoute(builder: (context) => SignupScreen()),);

                },
                child: Text("Doesn't has account, SingUp",
                    style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold,),),
              )





            ],
          ),
        ),
      ),
    );
  }
}
