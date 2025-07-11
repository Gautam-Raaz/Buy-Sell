import 'package:buy_and_sell/controller/user_controller.dart';
import 'package:buy_and_sell/models/product.dart' show Product;
import 'package:buy_and_sell/screen/new_product.dart';
import 'package:buy_and_sell/widget/product_card.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MyProductList extends StatefulWidget {
  const MyProductList({super.key});

  @override
  State<MyProductList> createState() => _MyProductListState();
}

class _MyProductListState extends State<MyProductList> {
  List<Product> productsList = [];
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isloading = true;
    });
    productsList = await UserController().getmyProductsList();

    setState(() {
      isloading = false;
    });
  }

  void showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  int? extractIndex(String url) {
    // Decode %2F to /
    String decodedUrl = Uri.decodeFull(url);

    // Now apply regex on the decoded URL
    RegExp regExp = RegExp(r'/(\d+)_photo\.jpg');
    Match? match = regExp.firstMatch(decodedUrl);

    if (match != null) {
      String index = match.group(1)!;

      return int.parse(index);
    } else {
      print("❌ No index found in: $decodedUrl");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewProduct()),
              ).then((val) {
                if (val == true) {
                  getData();
                }
              });
            },
            icon: Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : productsList.isEmpty
          ? Center(child: Text("No Product available"))
          : GridView.builder(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              shrinkWrap: false,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                mainAxisSpacing: 15,
                crossAxisSpacing: 10,
              ),
              itemCount: productsList.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ProductCard(
                      isAllowed: true,
                      data: productsList[index],
                      onclick: (add) {
                        setState(() {});
                      },
                    ),

                    Positioned(
                      right: 0,
                      top: 0,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Delete"),
                                    content: Text(
                                      "Are you sure you want to delete the product?",
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text("Delete"),
                                        onPressed: () async {

                                          productsList[index].photos.forEach((
                                            val,
                                          ) async {
                                            int? i = extractIndex(val);

                                            if (i != null) {
                                              final ref = FirebaseStorage
                                                  .instance
                                                  .ref()
                                                  .child(
                                                    'buy_and_sell/product_photos/${productsList[index].id}/${i}_photo.jpg',
                                                  );

                                              await ref.delete();
                                            }
                                          });

                                          bool success = await UserController()
                                              .deleteProduct(
                                                productsList[index].id,
                                              );

                                          if (success) {
                                            showSnack(
                                              "Product ${productsList[index].name} deleted successfuly",
                                            );
                                            setState(() {
                                              productsList.removeAt(index);
                                            });
                                            Navigator.of(context).pop();
                                          } else {
                                            showSnack("Something went wrong");

                                            Navigator.of(context).pop();
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.deepOrange,
                              ),
                              child: Center(
                                child: Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),

                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NewProduct(data: productsList[index]),
                                ),
                              ).then((val) {
                                if (val == true) {
                                  getData();
                                }
                              });
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(color: Colors.blue),
                              child: Center(
                                child: Icon(Icons.edit, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
