import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/fire_base_constants.dart';
import 'package:emart_seller/views/auth_screen/login_screen.dart';
import 'package:emart_seller/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  checkUserStatus(){
    if(auth.currentUser != null && mounted){
      Future.delayed(Duration(seconds: 0),(){
        Get.to(()=> Home(),transition: Transition.cupertino);
      });
    }else{
      Future.delayed(Duration(seconds: 0),(){
        Get.to(()=> LoginScreen(),transition: Transition.cupertino);
      });
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserStatus();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Icon(Icons.shopping_cart_rounded,size: 100,color: purpleColor,),
      ),
    );
  }
}
