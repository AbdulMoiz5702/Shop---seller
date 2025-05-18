import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import '../const/const.dart';
import '../const/fire_base_constants.dart';



class ProfileController extends GetxController {

  var profileImagePath = ''.obs;
  var profileImageLink = ''.obs;
  var name = TextEditingController();
  var isLoading = false.obs ;

  var shopName = TextEditingController();
  var shopAddress = TextEditingController();
  var shopMobile = TextEditingController();
  var shopWebsite = TextEditingController();
  var shopDescription = TextEditingController();


  changeImage(context) async {
    try{
      final image= await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image== null){
        return null;
      }else{
        profileImagePath.value = image.path.toString();
      }
    } on PlatformException catch(e){
      VxToast.show(context, msg: e.toString());
    }
  }

  Future uploadProfileImage() async{
    try {
      isLoading(true);
      var imageFile = basename(profileImagePath.value.toString());
      var destination = 'images/${currentUser!.uid}/$imageFile';
      Reference ref =  FirebaseStorage.instance.ref().child(destination);
      await ref.putFile(File(profileImagePath.value));
      profileImageLink.value = await ref.getDownloadURL().then((value){
        isLoading(false);
        return ref.getDownloadURL();
      });
    }catch(e){
      isLoading(false);
    }
  }


  updateProfile({required String imageUrl,required String name,required BuildContext context}) async{
   try{
     isLoading(true);
     print(currentUser!.uid);
     var store = fireStore.collection(vendorCollection).doc(currentUser!.uid);
     await store.update({
       'name':name,
       'imageUrl': imageUrl,
     }).then((value){
       isLoading(false);
       Navigator.pop(context);
     });
   }catch(e,s){
     print('Exception : $e');
     print('Exception : $s');
     isLoading(false);
   }
  }

  updateShop({required BuildContext context}) async{
    try{
      isLoading(true);
      print(currentUser!.uid);
      var store = fireStore.collection(vendorCollection).doc(currentUser!.uid);
      await store.update({
        'shop_name':shopName.text,
        'shop_address': shopAddress.text,
        'shop_mobile': shopMobile.text,
        'shop_website': shopWebsite.text,
        'shop_description': shopDescription.text,
      }).then((value){
        isLoading(false);
        Navigator.pop(context);
      });
    }catch(e,s){
      print('Exception : $e');
      print('Exception : $s');
      isLoading(false);
    }
  }



}