import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/HomeController.dart';
import 'package:emart_seller/views/widgets_common/customSized.dart';
import 'package:emart_seller/views/widgets_common/test_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart' as intl;
import '../../services/fire_base_services.dart';
import '../products/products_detail_screen.dart';
import '../shop_screen/shop_screnn.dart';
import '../widgets_common/dashBoardButton.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: normalText(title: 'Dashboard',color: darkGrey),
        actions: [
          Center(
            child: Container(
              margin: EdgeInsets.only(right: 20),
                child: smallText(title: intl.DateFormat('EEE, MMM d,''yy').format(DateTime.now()),color: darkGrey)),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FireBaseServices.getProducts(),
          builder:(context, AsyncSnapshot<QuerySnapshot> snapshot,){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CupertinoActivityIndicator(),);
            }else if (snapshot.hasData){
              var data = snapshot.data!.docs;
              data= data.sortedBy((a, b) => b['p_wishList'].length.compareTo(a['p_wishList'].length));
              return  Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DashBoardButton(title: 'Products',counts: data.length.toString(),imagePath: icProduct,),
                        StreamBuilder(
                          stream: FireBaseServices.getOrders(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot,) {
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return DashBoardButton(title: 'Orders',counts: '--/--/-',imagePath: icOrders,);
                            }else{
                              var data = snapshot.data!.docs;
                              return DashBoardButton(title: 'Orders',counts: data.length.toString(),imagePath: icOrders,);
                            }
                          }
                        ),
                      ],
                    ),
                    CustomSized(),
                    Divider(),
                    CustomSized(),
                    normalText(title: 'Popular Products',color: darkGrey),
                    CustomSized(),
                    Expanded(
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: false,
                            itemCount: data.length,
                            itemBuilder: (context,index){
                              return Container(
                                margin: EdgeInsets.all(5),
                                child: ListTile(
                                  onTap: (){
                                    Get.to(()=> ProductDetailsScreen(data:data[index],),transition: Transition.cupertino);
                                  },
                                  tileColor: purpleColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  leading: Image.network(data[index]['p_images'][0]),
                                  title: normalText(title: data[index]['p_price'],),
                                  subtitle: smallText(title: '\$ ${data[index]['p_price']}',),
                                ),
                              );
                            })
                    )
                  ],
                ),
              );
            }else{
              return Center(child: largeText(title: 'Something went wrong'),);
            }
          }
      ),
    );
  }
}

