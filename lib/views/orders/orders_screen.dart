import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/services/fire_base_services.dart';
import 'package:emart_seller/views/widgets_common/customSized.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../../const/colors.dart';
import '../widgets_common/test_widgets.dart';
import 'package:intl/intl.dart' as intl;

import 'order_detail_screen.dart';


class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        centerTitle: false,
        title: normalText(title: 'Orders',color: darkGrey),
        actions: [
          Center(
            child: Container(
                margin: EdgeInsets.only(right: 20),
                child: smallText(title: intl.DateFormat('EEE, MMM d,''yy').format(DateTime.now()),color: darkGrey)),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FireBaseServices.getOrders(), builder:(context,AsyncSnapshot<QuerySnapshot> snapshot,){
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CupertinoActivityIndicator(),);
        }else if (snapshot.hasError){
          return Center(child: largeText(title: snapshot.error),);
        } else if (snapshot.hasData){
          var data = snapshot.data!.docs;
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
                children: List.generate(data.length, (index){
                  print('data length : ${data.length}');
                  var orderDate = (data[index]['order_date'] as Timestamp).toDate();
                  var formattedDate = DateFormat('EEE, MMM d, ''yy').format(orderDate);
                  return Container(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      onTap: (){
                        Get.to(()=> OrdersDetailsScreen(data: data[index],),transition: Transition.cupertino);
                      },
                      trailing: normalText(title: '\$ ${data[index]['total_amount']}',color: white),
                      tileColor: purpleColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0,top: 8),
                        child: normalText(title: ' Order Code : ${data[index]['order_code']}',),
                      ),
                      subtitle: Column(
                        children: [
                          Row(children: [
                            Icon(Icons.calendar_month,color: white,),
                            CustomSized(),
                            smallText(title: formattedDate,color: white),
                          ],),
                          CustomSized(height: 0.01,),
                          Row(children: [
                            Icon(Icons.payment,color: white,),
                            CustomSized(),
                            smallText(title:data[index]['order_payment_status'],color: white)
                          ],),
                        ],
                      ),
                    ),
                  );
                })
            ),
          );
        }else{
          return Center(child: largeText(title: 'Something went wrong'),);
        }
      }),
    );
  }
}
