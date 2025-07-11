import 'package:buy_and_sell/constant/cons.dart';
import 'package:buy_and_sell/models/product.dart';
import 'package:buy_and_sell/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {


  Future<User?> getUserData(String phone) async{


    final docSnapshot =  await FirebaseFirestore.instance.collection(Constant.userTable).
      doc(phone).get();

    if(docSnapshot.exists && docSnapshot.data() != null) {

     return User.fromJson(docSnapshot.data()!);

    }

    return null;

  }

  Future<List<Product>> getProductsList(String phone) async{

    List<Product> products = [];


    final docSnapshot =  await FirebaseFirestore.instance.collection(Constant.productTable).where('phone',isEqualTo: phone)
      .get();

      for(var doc in docSnapshot.docs) {

         products.add(Product.fromJson(doc.data()));

      }

    return products;

  }  


  Future<User?> myUserData() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? phone = prefs.getString(Constant.phone);

    final docSnapshot =  await FirebaseFirestore.instance.collection(Constant.userTable).
      doc(phone).get();

    if(docSnapshot.exists && docSnapshot.data() != null) {

     return User.fromJson(docSnapshot.data()!);
     
    }

    return null;

  }

  


  Future<List<Product>> getmyProductsList() async{

    List<Product> products = [];

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? phone = prefs.getString(Constant.phone);


    final docSnapshot =  await FirebaseFirestore.instance.collection(Constant.productTable).where('phone',isEqualTo: phone)
      .get();

      for(var doc in docSnapshot.docs) {

         products.add(Product.fromJson(doc.data()));

      }

    return products;

  }  


  Future<bool> addProduct(Product data) async{

  await  FirebaseFirestore.instance.collection(Constant.productTable).
      doc(data.id).
      set(data.toJson()).
      // ignore: void_checks
      onError((e, _) {
        return false;
      });

      return true;
  }

  Future<List<Product>> getFilterProducts(String category) async{

    List<Product> data = [];


    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? phone = prefs.getString(Constant.phone);

    if(category != 'All Products') {


    final docSnapshot = await FirebaseFirestore.instance.collection(Constant.productTable)
    .where('phone',isNotEqualTo: phone)
    .where('filter',isEqualTo: category)
     .get();

      for(var doc in docSnapshot.docs) {

         data.add(Product.fromJson(doc.data()));

      }

    } else {

    final docSnapshot = await FirebaseFirestore.instance.collection(Constant.productTable)
    .where('phone',isNotEqualTo: phone)
     .get();

      for(var doc in docSnapshot.docs) {

         data.add(Product.fromJson(doc.data()));

      }

    }




    return data;

  }


  Future<bool> updateUserData(Map<String,dynamic> data) async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? phone = prefs.getString(Constant.phone);

   await FirebaseFirestore.instance.collection(Constant.userTable).
      doc(phone).
      update(data).
      // ignore: void_checks
      onError((e, _) {
        print("Error writing document: $e");
        return false;
      });
      return true;
  }


  Future<List<Product>> getMyWatchListPrduct() async{

    List<Product> products = [];

    User? myData = await myUserData();

    if(myData != null) {

      final docSnapshot =  await FirebaseFirestore.instance.collection(Constant.productTable)
      .get();



      for(var doc in docSnapshot.docs) {

        if(myData.watchlist.contains(doc.data()['id'])) {
          products.add(Product.fromJson(doc.data()));
        }

      }

    }


    return products;

  }  


  Future<bool> deleteProduct(String id) async{

      await  FirebaseFirestore.instance.collection(Constant.productTable).
      doc(id).
      delete().
      // ignore: void_checks
      onError((e, _) {
        print("Error writing document: $e");
        return false;
      });

      return true;
   
  }



}
