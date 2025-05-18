import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/fire_base_constants.dart';


class HomeController extends GetxController {


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
     getUserName();
     getShopName();
  }
  var currentIndex = 0.obs;
  var userName = '';
  var shopName = '';

  var searchController = TextEditingController();

  getUserName() async {
    var name = await fireStore.collection(vendorCollection).where('id',isEqualTo: currentUser!.uid).get().then((value){
      if(value.docs.isNotEmpty){
        return value.docs.single['name'];
      }
    });
    userName = name ;
    print(userName.toString());
  }

  getShopName() async {
    var name = await fireStore.collection(vendorCollection).where('id',isEqualTo: currentUser!.uid).get().then((value){
      if(value.docs.isNotEmpty){
        return value.docs.single['shop_name'];
      }
    });
    shopName = name ;
    print(shopName.toString());
  }


}