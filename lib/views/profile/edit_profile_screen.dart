// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/profile_controller.dart';
import 'package:emart_seller/views/widgets_common/test_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets_common/customSized.dart';
import '../widgets_common/custom_button.dart';
import '../widgets_common/customtextField.dart';



class EditProfileScreen extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl ;
  const EditProfileScreen({required this.email,required this.name,required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    controller.name.text = name ;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            margin: EdgeInsets.only(left: 5,right: 5,top: 100),
            color: white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Obx(
                  ()=> Column(
                      children: [
                       controller.profileImagePath.value.isEmpty ?  imageUrl != 'none' ? Container(
                          clipBehavior: Clip.antiAlias,
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child:Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(image: NetworkImage(imageUrl),fit: BoxFit.cover),
                            ),
                          ),
                        ) : Container(
                          clipBehavior: Clip.antiAlias,
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child:Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(image: AssetImage(appLogo),fit: BoxFit.cover),
                            ),
                          ),
                       ) : Container(
                         clipBehavior: Clip.antiAlias,
                         height: 100,
                         width: 100,
                         decoration: BoxDecoration(
                           shape: BoxShape.circle,
                         ),
                         child:Container(
                           height: 100,
                           width: 100,
                           decoration: BoxDecoration(
                             shape: BoxShape.circle,
                             image: DecorationImage(image: FileImage(File(controller.profileImagePath.value)),fit: BoxFit.cover),
                           ),
                         ),
                       ) ,
                        CustomButton(onTap: ()async{
                           await controller.changeImage(context);
                        }, title: 'Pick Image'),
                        CustomSized(),
                        CustomTextField(title: 'Name', hintText: 'exapmle@gmail.com', controller: controller.name),
                        CustomSized(),
                       controller.isLoading.value == true ? Center(child: CupertinoActivityIndicator(),) : CustomButton(onTap: ()async{
                          if(controller.profileImagePath.value.isNotEmpty){
                            await controller.uploadProfileImage().then((value){
                              controller.updateProfile(imageUrl: controller.profileImageLink.value, name: name, context: context);
                            });
                          }else{
                            await controller.updateProfile(imageUrl:imageUrl,name: name, context: context);
                          }
                        }, title: 'Update Info'),
                        CustomSized(),
                        CustomButton(onTap: (){
                        }, title: 'Reset Password'),

                      ],
                    ),
                ),
                ),
              ),
            ),
          ),
    );
  }
}
