

import '../const/fire_base_constants.dart';

class FireBaseServices {

  static getUser(userId){
    return fireStore.collection(vendorCollection).doc(userId).snapshots();
  }

  static getMessages(userId){
    return fireStore.collection(messagesCollections).where('toId',isEqualTo: currentUser!.uid).snapshots();
  }

  static getOrders(){
    return fireStore.collection(ordersCollection).where('vendors',arrayContains: currentUser!.uid).snapshots();
  }

  static getProducts(){
    return fireStore.collection(productsCollections).where('vendor_id',isEqualTo: currentUser!.uid).snapshots();
  }
  static getProductsFamous(){
    return fireStore.collection(productsCollections).where('vendor_id',isEqualTo: currentUser!.uid).orderBy('p_wishList'.length).snapshots();
  }



}