import 'package:buy_and_sell/constant/cons.dart';
import 'package:buy_and_sell/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController {


  Future<bool> signUp(User userData,) async{

  await  FirebaseFirestore.instance.collection(Constant.userTable).
      doc(userData.phoneNumber).
      set(userData.toJson()).
      // ignore: void_checks
      onError((e, _) {
        print("Error writing document: $e");
        return false;
      });

      return true;
  }

}