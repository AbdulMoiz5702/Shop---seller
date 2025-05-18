import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/controllers/profile_controller.dart';
import 'package:emart_seller/views/widgets_common/test_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets_common/customSized.dart';
import '../widgets_common/custom_button.dart';
import '../widgets_common/customtextField.dart';


class ShopScreen extends StatelessWidget {
  var data ;
  ShopScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    controller.shopName.text = data['shop_name'];
    controller.shopAddress.text = data['shop_address'];
    controller.shopMobile.text = data['shop_mobile'];
    controller.shopWebsite.text = data['shop_website'];
    controller.shopDescription.text = data['shop_description'];
    return Scaffold(
      appBar: AppBar(
        title: normalText(title: 'Shop Settings'),
      ),
      backgroundColor: purpleColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSized(height: 0.1,),
            Container(
              margin: EdgeInsets.all(5),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      CustomSized(),
                      CustomTextField(title: "Shop Name", hintText: 'Shop Name', controller: controller.shopName),
                      CustomSized(),
                      CustomTextField(title: "Shop Address", hintText: 'Shop Address', controller: controller.shopAddress),
                      CustomSized(),
                      CustomTextField(title: "Shop Mobile", hintText: 'Shop Mobile', controller: controller.shopMobile),
                      CustomSized(),
                      CustomTextField(title: "Shop Website", hintText: 'Shop website', controller: controller.shopWebsite),
                      CustomSized(),
                      CustomTextField(isDescription: true,title: "Shop Description", hintText: 'Shop Description', controller: controller.shopDescription),
                      CustomSized(),
                      Obx(
                          ()=> controller.isLoading.value == true ? const  Center(child: CupertinoActivityIndicator(),) :CustomButton(onTap: (){
                            controller.updateShop(context: context);
                        }, title: "Save"),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
