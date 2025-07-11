import 'package:buy_and_sell/controller/user_controller.dart';
import 'package:buy_and_sell/models/product.dart';
import 'package:buy_and_sell/models/user.dart';
import 'package:buy_and_sell/widget/product_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<List<Product>> data = [];
  User? myData;

  bool isloading = false;

  List<Widget> tabs = [
              Tab(child: Text("All Products",style: TextStyle(color: Colors.white),),),
              Tab(child: Text("Coolers & Fans",style: TextStyle(color: Colors.white),),),
              Tab(child: Text("Books",style: TextStyle(color: Colors.white),),),
              Tab(child: Text("Electronics",style: TextStyle(color: Colors.white),),),
              Tab(child: Text("Cycles",style: TextStyle(color: Colors.white),),),
              Tab(child: Text("Hostel Items",style: TextStyle(color: Colors.white),),),
              Tab(child: Text("Sports",style: TextStyle(color: Colors.white),),),
              Tab(child: Text("Furniture",style: TextStyle(color: Colors.white),),),
              Tab(child: Text("Miscellaneous",style: TextStyle(color: Colors.white),),),
              Tab(child: Text("Other",style: TextStyle(color: Colors.white),),)
            ];

 List<String> filters = [
 'All Products', 'Coolers & Fans', 'Books', 'Electronics', 'Cycles', 'Hostel Items',
  'Sports', 'Furniture', 'Miscellaneous','Other'
];    


@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData () async{

    setState(() {
      isloading = true;
    });

    List<Product> temp = await UserController().getFilterProducts(filters[0]);

    data.add(temp);

    for(int i = 1 ; i < filters.length; i++) {

      List<Product> temp = data[0].where((product) => product.filter ==  filters[i]).toList();

      data.add(temp);

    }

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
    return DefaultTabController(
      initialIndex: 0,
      length: 10,
      child: Scaffold(
      appBar: AppBar(
        title: Text("Home Screen",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        bottom: TabBar(
          isScrollable: true,
            tabs: tabs
          ),
      ),
      body: isloading ? Center(child: CircularProgressIndicator(),) :  TabBarView(
          children: data.map((List<Product> productList) {
                return  productList.isEmpty ? Center(child: Text("No Product available"),) :  GridView.builder(
                  physics: BouncingScrollPhysics(),
                  
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  shrinkWrap: false,
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                           crossAxisCount: 2,
                           childAspectRatio: 0.7,
                           mainAxisSpacing: 15,
                           crossAxisSpacing: 10
                         ),
                  itemCount: productList.length,
                  itemBuilder: (context , index) {
                  return ProductCard(
                    data: productList[index],
                    isAllowed: true,
                    userData: myData,
                    onclick: (add) async{

                     
                        bool success = await UserController().updateUserData({
                          'watchlist': add ? FieldValue.arrayUnion([productList[index].id]) : FieldValue.arrayRemove([productList[index].id])
                          }
                        );

                        if(success) {
                          showSnack("Product ${add ? "added to watchlist" : "removed from watchlist"}");
                        } else {
                          showSnack("spmething went wrong");
                        }

                        setState(() {

                          if(add) {
                            myData!.watchlist.add(productList[index].id);
                          } else {
                             myData!.watchlist.remove(productList[index].id);
                          }

                          
                          
                        });
                      


                      

                      setState(() {
                        
                      });
                    },
                 );
           },);
              }).toList(),
      )
    )
  );
  }

}