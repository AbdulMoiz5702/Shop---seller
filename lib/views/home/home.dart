import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/views/home/HomeScreen.dart';
import 'package:emart_seller/views/orders/orders_screen.dart';
import 'package:emart_seller/views/products/products_screen.dart';
import 'package:emart_seller/views/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/HomeController.dart';



class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var homeController = Get.put(HomeController());
    var navigationBar = [
      BottomNavigationBarItem(icon: Icon(Icons.dashboard_sharp),label: 'Dashboard'),
      BottomNavigationBarItem(icon: Icon(Icons.category_rounded),label: 'Products'),
      BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined),label: 'Orders'),
      BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Profile'),
    ];
    var screens = [
      HomeScreen(),
      ProductsScreen(),
      OrdersScreen(),
      ProfileScreen(),
    ];
    return WillPopScope(
      onWillPop: ()async {
        return false ;
      },
      child: Scaffold(
        body: Obx(()=> screens.elementAt(homeController.currentIndex.value)),
        bottomNavigationBar: Obx(
              ()=> BottomNavigationBar(
              onTap: (index){
                homeController.currentIndex.value = index;
              },
              currentIndex: homeController.currentIndex.value,
              selectedItemColor: purpleColor,
              unselectedItemColor: darkGrey,
              selectedLabelStyle: TextStyle(color: purpleColor),
              unselectedIconTheme: IconThemeData(color: darkGrey),
              selectedIconTheme: IconThemeData(color: purpleColor),
              unselectedLabelStyle:  TextStyle(color: darkGrey),
              backgroundColor: white,
              type: BottomNavigationBarType.fixed,
              items: navigationBar),
        ),
      ),
    );
  }
}

