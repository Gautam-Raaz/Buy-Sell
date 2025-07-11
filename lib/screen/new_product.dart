import 'dart:io';
import 'dart:math';

import 'package:buy_and_sell/constant/cons.dart';
import 'package:buy_and_sell/controller/user_controller.dart';
import 'package:buy_and_sell/models/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewProduct extends StatefulWidget {
  Product? data;
  NewProduct({super.key, this.data});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  String name = "";
  String selfilter = "";
  String buyPrice = "";
  String sellPrice = "";
  DateTime? buyDate;
  List<String> photos = [];
  String description = "";
  List<String> deletePic = [];
  bool isloading = false;

  final filters = [
  'Coolers & Fans', 'Books', 'Electronics', 'Cycles', 'Hostel Items',
  'Sports', 'Furniture', 'Miscellaneous','Other'
];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.data != null) getData();
  }

  getData() {
    setState(() {
      name = widget.data!.name;
      selfilter = widget.data!.filter;
      buyPrice = widget.data!.buyprice;
      sellPrice = widget.data!.sellprice;
      buyDate = widget.data!.buyDate;
      photos = widget.data!.photos;
      description = widget.data!.description;
    });
  }

    Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // default date
      firstDate: DateTime(2010), // earliest date
      lastDate: DateTime.now(), // latest date
    );

    if (picked != null && picked != buyDate) {
      setState(() {
        buyDate = picked;
      });
    }
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
        leading: BackButton(color: Colors.white,),
        title: Text(
          widget.data == null ? "New Product" : "Update Product",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
      ),
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
             
              // Product name
              SizedBox(height: 20),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Product Name',
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
                    name = value;
                  },
                  controller: TextEditingController(text: name),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your product name',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),

              // Product Buy Price
              SizedBox(height: 20),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Original Price',
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
                    buyPrice = value;
                  },
                  controller: TextEditingController(text: buyPrice),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Original Price of Product',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),


              // Product Selling
              SizedBox(height: 20),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Selling Price',
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
                    sellPrice = value;
                  },
                  controller: TextEditingController(text: sellPrice),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter Selling Price of Product',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),

              

             

              // Filter
              SizedBox(height: 20),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Category',
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
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selfilter.isEmpty ? null : selfilter,
                  hint: Text('Select a category', style: TextStyle(color: Colors.grey[600])),
                  items: filters.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.black)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selfilter = val!;
                    });
                  },
                ),
              ),

              // Date of birth
              SizedBox(height: 20),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Select buying date of Product',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {
                  _pickDate();
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.grey[200],
                  ),
                  child: Center(
                    child: Text(
                     buyDate == null ? "Please Select the product buy data" : DateFormat('dd/MM/yyyy').format(buyDate!),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              // Description
              SizedBox(height: 20),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Product Description',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 130,
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  onChanged: (value) {
                    description = value;
                  },
                  controller: TextEditingController(text: description),
                  maxLines: 6,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your Product Description',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),

              // Photos
              SizedBox(height: 20),
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  'Add product images',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Container(
                height: 350,
                child: GridView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: false,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: min(photos.length + 1, 8),
                  itemBuilder: (context, index) {
                    return ((photos.length < 8) &&
                            (index == photos.length))
                        ? GestureDetector(
                            onTap: () {
                              ImagePicker()
                                  .pickImage(
                                    source: ImageSource.gallery,
                                    imageQuality: 100,
                                  )
                                  .then((value) {
                                    if (value != null) {
                                      setState(() {
                                        photos.add(value.path);
                                      });
                                    }
                                  });
                            },
                            child: Card(
                              child: GridTile(
                                child: Center(
                                  child: Icon(Icons.photo, size: 34),
                                ), //just for testing, will fill with image later
                              ),
                            ),
                          )
                        : Card(
                            child: GridTile(
                              footer: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Delete"),
                                        content: Text(
                                          "Are you sure to delete the image",
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
                                            onPressed: () {
                                              Navigator.of(context).pop();

                                              if (photos[index]
                                                  .contains(
                                                    'firebasestorage',
                                                  )) {
                                                deletePic.add(
                                                  photos[index],
                                                );
                                              }

                                              setState(() {
                                                photos.removeAt(
                                                  index,
                                                );
                                              });
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  color: Colors.red,
                                  child: Center(
                                    child: Text(
                                      "Remove",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              child: Image(
                                image:
                                    photos[index].contains(
                                      'firebasestorage',
                                    )
                                    ? NetworkImage(photos[index])
                                    : FileImage(
                                        File(photos[index]),
                                      ),
                                fit: BoxFit.cover,
                              ), //just for testing, will fill with image later
                            ),
                          );
                  },
                ),
              ),

              SizedBox(height: 30),

              Center(
                child: InkWell(
                  onTap: () async {

                    if (name.trim().length < 3) {
                      showSnack("Product name must be atleast of 3 length");
                    } else if (buyPrice.trim().isEmpty) {
                      showSnack("Please Enter original price of product");
                    } else if (sellPrice.trim().isEmpty) {
                      showSnack("Please Enter Selling Price of Products");
                    } else if (selfilter.isEmpty) {
                      showSnack("Please select catogory of product");
                    } else if (buyDate == null) {
                      showSnack("Please select buying date of product");
                    } else if (photos.isEmpty) {
                      showSnack("Please slect atleast 1 photos");
                    } else if (description.trim().length < 8) {
                      showSnack("Please Enter detail of your product");
                    } else {
                      setState(() {
                        isloading = true;
                      });

                      try{

                      List<int> unavailableIndex = [];

                      deletePic.forEach((val) async {
                        int? index = extractIndex(val);

                        if (index != null) {
                          final ref = FirebaseStorage.instance.ref().child(
                            'buy_and_sell/product_photos/${widget.data!.id}/${index}_photo.jpg',
                          );

                          await ref.delete();
                        }
                      });

                      for (
                        int i = 0;
                        i < photos.length;
                        i++
                      ) {
                        if (photos[i].contains(
                          'firebasestorage',
                        )) {
                          int? index = extractIndex(
                            photos[i],
                          );

                          if (index != null) {
                            print("Unavailabe" + i.toString());
                            unavailableIndex.add(index);
                          }
                        }
                      }

                         List<int> available = [];

                        for (int i = 0; i < 8; i++) {

                          if (!unavailableIndex.contains(i)) {
                            print(i);

                            available.add(i);
                          }
                        }

                        int index = 0;
                        String id = (widget.data == null) ? (DateTime.now().millisecondsSinceEpoch.toString()) :  (widget.data!.id);

                        final storageRef = FirebaseStorage.instance.ref();

                        for (
                          int i = 0;
                          i < photos.length;
                          i++
                        ) {

                          if (!photos[i].contains(
                            'firebasestorage',
                          )) {

                            var temp = storageRef.child(
                              "buy_and_sell/product_photos/$id/${available[index]}_photo.jpg",
                            );

                            await temp.putFile(
                              File(photos[i]),
                            );

                            photos[i] = await temp
                                .getDownloadURL();

                            index++;
                          }
                        }


                        final SharedPreferences prefs = await SharedPreferences.getInstance();
                        final String? phone = prefs.getString(Constant.phone);





                        var data = Product(
                          id: id,
                          name: name,
                          filter: selfilter, 
                          phone: phone!, 
                          buyprice: buyPrice, 
                          sellprice: sellPrice, 
                          buyDate: buyDate!, 
                          photos: photos, 
                          description: description
                        );



                      bool sucess = await UserController().addProduct(
                        data
                      );

                      if (sucess) {
                        setState(() {
                          isloading = false;
                        });

                        showSnack("Product ${widget.data == null ? "Added" : "Updated"} successfully");

                        Navigator.pop(context, true);
                      } else {
                        setState(() {
                          isloading = false;
                        });

                        showSnack("Something went wrong");
                      }
                      } catch(e) {
                        setState(() {
                          isloading = false;
                           showSnack("Something went wrong");
                        });
                      }
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
                      child: Text(
                       widget.data == null ? "Add Products" : "Update",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
