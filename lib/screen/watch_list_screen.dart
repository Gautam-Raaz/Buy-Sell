import 'package:buy_and_sell/controller/user_controller.dart';
import 'package:buy_and_sell/models/product.dart' show Product;
import 'package:buy_and_sell/models/user.dart';
import 'package:buy_and_sell/screen/new_product.dart';
import 'package:buy_and_sell/widget/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WatchListScreen extends StatefulWidget {
  const WatchListScreen({super.key});

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {

  List<Product> productsList = [];
  bool isloading = false;
  User? myData;

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
      productsList = await UserController().getMyWatchListPrduct();   
      myData = await UserController().myUserData();

      setState(() {
        isloading = false;
      });
  }

  void showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WatchList",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
      ),
      body: isloading ? Center(child: CircularProgressIndicator(),) : 
      
      productsList.isEmpty ? Center(child: Text("No Product available in the watchlist"),) :  GridView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  shrinkWrap: false,
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                           crossAxisCount: 2,
                           childAspectRatio: 0.75,
                           mainAxisSpacing: 15,
                           crossAxisSpacing: 10
                           ),
                  itemCount: productsList.length,
                  itemBuilder: (context , index) {
                  return ProductCard(
                    isAllowed: true,
                    data: productsList[index],
                    userData: myData,
                    onclick: (add) async{

                        bool success = await UserController().updateUserData({
                          'watchlist': add ? FieldValue.arrayUnion([productsList[index].id]) : FieldValue.arrayRemove([productsList[index].id])
                          }
                        );

                        if(success) {
                          showSnack("Product ${add ? "added to watchlist" : "removed from watchlist"}");
                        } else {
                          showSnack("spmething went wrong");
                        }



                        setState(() {

                          if(add) {
                            myData!.watchlist.add(productsList[index].id);
                          } else {
                             myData!.watchlist.remove(productsList[index].id);
                          }

                          
                          
                        });
                    },
                   
                 );
           },),
    );
  }
}