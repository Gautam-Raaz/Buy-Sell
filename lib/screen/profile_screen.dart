import 'package:buy_and_sell/controller/user_controller.dart';
import 'package:buy_and_sell/models/product.dart';
import 'package:buy_and_sell/models/user.dart';
import 'package:buy_and_sell/screen/edit_profile.dart';
import 'package:buy_and_sell/screen/login_screen.dart';
import 'package:buy_and_sell/widget/product_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/cons.dart';

class ProfileScreen extends StatefulWidget {
  final String? phone;
  const ProfileScreen({super.key,this.phone});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool isloading = true;

  User? data;

  List<Product> productsList = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();

  }

    getData() async{

      setState(() {
        isloading = true;
      });

      if(widget.phone != null) {
        data = await UserController().getUserData(widget.phone!);
        productsList = await UserController().getProductsList(widget.phone!);
      } else {
        data = await UserController().myUserData();
        productsList = await UserController().getmyProductsList();
      }

      setState(() {
        isloading = false;
      });

    }

 void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(); 
            },
          ),
          TextButton(
            child: Text("Logout"),
            onPressed: () async{
              Navigator.of(context).pop(); 

              final SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString(Constant.phone, '');

              Navigator.pushReplacement(
                context,MaterialPageRoute(builder: (context) => LoginScreen()),);
            },
          ),
        ],
      );
    },
  );
}






  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        leading: widget.phone != null ? BackButton(color: Colors.white,) : null,
        title: Text("Profile",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepOrangeAccent,
        actions: widget.phone == null ? [
          IconButton(onPressed: () {

            if(data != null) {
              Navigator.push(
                context,MaterialPageRoute(builder: (context) => EditProfile(data: data!,)),).then((val) {
                  if(val == true) {
                    getData();
                  }
                });              
            }

          }, icon: Icon(Icons.edit,color: Colors.white,)),
          IconButton(onPressed: () {
            _showLogoutDialog(context);

          }, icon: Icon(Icons.logout,color: Colors.white,)),
        ] : [],
      ),
      body: isloading ? Center(child: CircularProgressIndicator(),) : 
      
      data == null ? Center(child: Text("Something went wrong"),) : Column(
               crossAxisAlignment: CrossAxisAlignment.center,
              //  mainAxisAlignment: MainAxisAlignment.center,
          
                children: [

                    SizedBox(height: 20,),
           
                    /// profile pic
                    CircleAvatar(
                     radius: 50,
                     backgroundImage: NetworkImage(data!.profilePic),
                     backgroundColor: Colors.white,
                    ),
          
          
                    /// name
                    SizedBox(height: 20,),
                    Text(data!.name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),

                    Divider(thickness: 2,),   

                    productsList.isEmpty ? Center(child: Text("No Product Available"),) :

                 Expanded(
                   child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    shrinkWrap: false,
                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                             crossAxisCount: 2,
                             childAspectRatio: 0.7,
                             mainAxisSpacing: 15,
                             crossAxisSpacing: 10
                             
                             ),
                    itemCount: productsList.length,
                    itemBuilder: (context , index) {
                    return ProductCard(
                      isAllowed: false,
                      data: productsList[index],
                       onclick: (add) {
                        setState(() {
                          
                        });
                       },
                   );
                              },),
                 ),


    
              ],),
      
    );
  }
}