import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/controllers/order_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../widgets_common/customSized.dart';
import '../widgets_common/custom_button.dart';
import '../widgets_common/order_details.dart';
import '../widgets_common/test_widgets.dart';



class OrdersDetailsScreen extends StatefulWidget {
   final dynamic  data;
  const OrdersDetailsScreen({required this.data});

  @override
  State<OrdersDetailsScreen> createState() => _OrdersDetailsScreenState();
}

class _OrdersDetailsScreenState extends State<OrdersDetailsScreen> {

  var controller = Get.put(OrdersController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getOrders(widget.data);
  }
  @override
  Widget build(BuildContext context) {
    // Parse the date string to a DateTime object

     DateTime date = widget.data['order_date'].toDate();
     DateTime parsedDate = DateTime.parse(date.toString());
    // // Format the date to the desired format
     String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return  Scaffold(
      bottomNavigationBar: Obx(
          ()=> controller.confirmed.value == false ? CustomButton(onTap: (){
            controller.markConfirmed();
            controller.changeStatus(feild: 'order_confirm', status: 'true', docId: widget.data.id);
            print(controller.confirmed.value);
          }, title: 'Confirm'):  Container(height: 1,width: 1,),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Obx(
              ()=> Column(
                children: [
                  CustomSized(height: 0.1,),
                  normalText(title: 'Order Status',color: darkGrey),
                  SwitchListTile(value: true, onChanged: (value){},title: smallText(title: 'Placed',color: darkGrey),activeColor: purpleColor,),
                  CustomSized(),
                  controller.confirmed.value == true ?  SwitchListTile(value: controller.confirmed.value, onChanged: (value){
                    controller.unMarkConfirmed();
                    controller.changeStatus(feild: 'order_confirm', status: 'false', docId: widget.data.id);
                  },title: smallText(title: 'Confirmed',color: darkGrey),activeColor: purpleColor,) : Container(height: 1,width: 1,),
                  CustomSized(),
                  controller.confirmed.value == true ?   Obx(
                    ()=> Column(
                    children: [
                      SwitchListTile(value: controller.onDelivery.value, onChanged: (value){
                        if(controller.onDelivery.value == false){
                          controller.markOnDelivered();
                          controller.changeStatus(feild:'order_on_delivery', status: 'true', docId: widget.data.id);
                        }else{
                          controller.unMarkOnDelivered();
                          controller.changeStatus(feild: 'order_on_delivery', status: 'false', docId: widget.data.id);
                        }
                      },title: smallText(title: 'on Delivery',color: darkGrey),activeColor: purpleColor,) ,
                      CustomSized(),
                      SwitchListTile( value: controller.delivered.value, onChanged: (value){
                        if(controller.delivered.value == false){
                          controller.markDelivered();
                          controller.changeStatus(feild: 'order_delivered', status: 'true', docId: widget.data.id);
                        }else{
                          controller.unMarkDelivered();
                          controller.changeStatus(feild:'order_delivered', status: 'false', docId: widget.data.id);
                        }
                      },title: smallText(title: 'Delivered',color: darkGrey),activeColor: purpleColor,) ,
                    ],
                ),
                  ) : Container(height: 1,width: 1,),
                ],
              ),
            ),
            CustomSized(),
            OrderDetails(icon: Icons.check_box,color: Colors.red,title:'Order Placed',lastIcon: Icons.check ,),
            CustomSized(),
            OrderDetails(icon: Icons.thumb_up_outlined,color: Colors.blue,title:'Order Confirmed',lastIcon:Icons.check ,),
            CustomSized(),
            OrderDetails(icon: Icons.local_shipping_outlined,color: Colors.yellow,title:'On Delivery',lastIcon:Icons.check ),
            CustomSized(),
            OrderDetails(icon: Icons.handshake_outlined,color: Colors.deepOrange,title:'Delivered',lastIcon:Icons.check ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      smallText(title: 'Order Code ',color: darkGrey),
                      smallText(title: "${widget.data['order_code']}",color: purpleColor),
                    ],
                  ),
                  Column(
                    children: [
                      smallText(title: 'Shipping Method ',color: darkGrey),
                      smallText(title: "${widget.data['shipping_method']}",color: purpleColor),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      smallText(title: 'Order Date ',color: darkGrey),
                      smallText(title:formattedDate,color: purpleColor),
                    ],
                  ),
                  Column(
                    children: [
                      smallText(title: 'Payment Method ',color: darkGrey),
                      smallText(title:"${ widget.data['paymentMethod']}",color: purpleColor),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  smallText(title: 'Total Price ',color: darkGrey),
                  normalText(title: "\$ ${widget.data['total_amount']}",color: purpleColor)
                ],
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    normalText(title: 'Shipping Address',color: darkGrey),
                    smallText(title: "${widget.data['order_by_address']}",color: darkGrey),
                    smallText(title:"${ widget.data['order_by_phoneNumber']}",color: darkGrey),
                    smallText(title: "${widget.data['order_by_city']}",color: darkGrey),
                    smallText(title:"${widget.data['order_by_address']}",color: darkGrey),
                    smallText(title: "${widget.data['order_by_state']}",color: darkGrey),
                    smallText(title: "${widget.data['order_by_email']}",color: darkGrey),
                  ],
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: controller.orders.length,
                //data['orders'].length,
                itemBuilder: (context,index){
                  return Container(
                    margin: EdgeInsets.all(5),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tileColor: lightGrey,
                      contentPadding: EdgeInsets.all(5),
                      title: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              height:70,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(image: NetworkImage(controller.orders[index]['image']),fit: BoxFit.cover),
                              ),
                            ),
                            CustomSized(),
                            normalText(title: "${controller.orders[index]['title']}",color: darkGrey,),
                          ],
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            normalText(title: 'Quantity : ${controller.orders[index]['quantity']}',color: darkGrey,),
                            Row(
                              children: [
                                smallText(
                                    title: 'color :  ',
                                    color: darkGrey
                                ),
                                Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:Color(int.parse(controller.orders[index]['color'])),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}
