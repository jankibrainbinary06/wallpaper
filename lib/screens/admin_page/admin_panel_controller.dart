import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallpaper/screens/home_page/home_screen.dart';
import 'package:wallpaper/utils/strings.dart';

class AdminPanelController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String emailError = "";
  String passError = "";
  String email = '';
  String password = '';
  bool isEdit = false ;

  bool isValidate = false;

  emailValidation() {
    if (emailController.text.trim() == "") {
      emailError = "Please enter email!";
      update(["admin"]);
    } else {
      if (RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailController.text)) {
        emailError = '';
        update(["admin"]);
      } else {
        emailError = Strings.emailError;
        update(["admin"]);
      }
    }
  }

  passValidation() {
    if (passwordController.text.trim() == "") {
      passError = 'Please enter password!';
      update(["admin"]);
    }
    else if(passwordController.text.length <=3){
      passError = 'Password must be atLeast 4 character!';
    }

    else {
      passError = "";
      update(["admin"]);
    }
  }

  signInValidation() {
    isValidate = color();
    update(["admin"]);
  }

  bool color() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  onTapLogin(BuildContext context ) async {
    await getData();
    if (validation()) {
      if(emailController.text == email  &&  passwordController.text == password){
        Get.off(() =>  HomeScreen(isAdmin: isEdit,));
        emailController.clear();
        passwordController.clear();
      }
      else
        {
          Get.snackbar('Invalid','Please enter correct credentials!',backgroundColor: Colors.red, colorText: Colors.white);

        }
    }
    update(["admin"]);
  }

  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('auth');

  Future<void> getData() async {
    await FirebaseFirestore.instance
        .collection('auth')
        .get()
        .then((querySnapshot) {
      email = querySnapshot.docs[0].data()['email'];
      password = querySnapshot.docs[0].data()['password'];
      isEdit = querySnapshot.docs[0].data()['isEditable'];


    });
  }

  bool validation() {
    emailValidation();
    passValidation();
    if (emailError == '' && passError == '') {
      return true;
    } else {
      return false;
    }
  }
}
