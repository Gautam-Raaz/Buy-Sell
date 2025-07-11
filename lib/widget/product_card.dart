import 'package:buy_and_sell/models/product.dart';
import 'package:buy_and_sell/models/user.dart';
import 'package:buy_and_sell/screen/product_details.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final Product data;
  final User? userData;
  final bool isAllowed;
  final void Function(bool add) onclick;
 
  const ProductCard({super.key,required this.data,this.userData,required this.onclick,required this.isAllowed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 237, 222, 227),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {

              Navigator.push(
                context,MaterialPageRoute(builder: (context) => ProductDetails(data: data,isAllowed: isAllowed,)),);

              },
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(image: NetworkImage(data.photos[0]),fit: BoxFit.cover)
                ),
              ),
            ),
      
            SizedBox(height: 5,),
      
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(data.name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                       if(userData != null) 
                       IconButton(onPressed: () {

                        if(userData!.watchlist.contains(data.id)) {

                          onclick(false);


                        } else {

                           onclick(true);

                        }

                       }, icon: userData!.watchlist.contains(data.id) ? Icon(Icons.star , color: Colors.yellow,size: 28,) : 
                       Icon(Icons.star_border,color: Colors.grey,size: 28,))
                      ],
                    ),
            ),

            SizedBox(height: 5,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Text("Original Price",style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(width: 5,),
                  Text(data.buyprice)
                ],
              ),
            ),


            SizedBox(height: 5,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Text("Selling Price",style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(width: 5,),
                  Text(data.sellprice)
                ],
              ),
            ),

            SizedBox(height: 5,),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Text("Buying Date",style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(width: 5,),
                  Text(DateFormat('dd/MM/yyyy').format(data.buyDate))
                ],
              ),
            ),            
          ],
        ),
    );
  }
}