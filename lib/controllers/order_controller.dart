


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/fire_base_constants.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {

  var orders = [];

  var confirmed =  false.obs;
  var onDelivery =  false.obs;
  var delivered =  false.obs;

   getOrders(data){
     orders.clear();
     for(var item in data['orders']){
       if(item['vendor_id'] == currentUser!.uid){
         orders.add(item);
       }
     }
     print(orders);
   }

   markConfirmed(){
     confirmed(true);
   }

  markOnDelivered(){
    onDelivery(true);
  }

  markDelivered(){
    delivered(true);
  }

  unMarkConfirmed(){
    confirmed(false);
  }

  unMarkOnDelivered(){
    onDelivery(false);
  }

  unMarkDelivered(){
    delivered(false);
  }


  changeStatus({required  feild,required status,required docId})async {
     var store= fireStore.collection(ordersCollection).doc(docId);
    await store.set({
      feild:status,
     },SetOptions(merge: true));

}



}