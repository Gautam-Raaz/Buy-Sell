import 'package:buy_and_sell/constant/cons.dart';
import 'package:buy_and_sell/screen/dashboard_screen.dart';
import 'package:buy_and_sell/screen/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2),() {

      nevigate();

    });
  }

  nevigate() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? phone = prefs.getString(Constant.phone);



    if(phone == null || phone == ''|| phone.length != 10) {

         Navigator.pushReplacement(
          context,MaterialPageRoute(builder: (context) => LoginScreen()),);

    } else {

    await FirebaseFirestore.instance.collection(Constant.userTable).doc(phone).get().then((val) {
      

      if(!val.exists) {
         Navigator.pushReplacement(
          context,MaterialPageRoute(builder: (context) => LoginScreen()),);        
      } else {
       Navigator.pushReplacement(
          context,MaterialPageRoute(builder: (context) => Dashboard()),);
      }
    });      
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(   
      backgroundColor: Colors.deepOrangeAccent,
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Image.asset("assets/splash.png"),
            )
            
          
          ],
        ),
      ),
    );
  }
}
