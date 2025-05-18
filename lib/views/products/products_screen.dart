import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/fire_base_constants.dart';
import 'package:emart_seller/controllers/product_controller.dart';
import 'package:emart_seller/views/products/products_detail_screen.dart';
import 'package:emart_seller/views/widgets_common/customSized.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../const/colors.dart';
import '../../services/fire_base_services.dart';
import '../widgets_common/test_widgets.dart';
import 'package:intl/intl.dart' as intl;
import 'Add_products.dart';


class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Supabase.initialize(url: AppConstants.supaBaseUrl, anonKey: AppConstants.apiKey,);
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await controller.getCategories();
          await controller.populateCategoryList();
          Get.to(()=>AddProducts(),transition: Transition.cupertino);
        },
        child: Icon(Icons.add,color: purpleColor,),
      ),
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
          builder:(context,AsyncSnapshot<QuerySnapshot> snapshot,){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CupertinoActivityIndicator(),);
            }else if (snapshot.hasData){
              var data = snapshot.data!.docs;
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    children: List.generate(data.length, (index){
                      return Container(
                        margin: EdgeInsets.all(5),
                        child: ListTile(
                          onTap: (){
                            Get.to(()=>ProductDetailsScreen(data: data[index],),transition: Transition.cupertino);
                          },
                          tileColor: purpleColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          trailing: VxPopupMenu(
                              child: Icon(Icons.format_list_bulleted,color: white,),
                              menuBuilder: (){
                                return Column(
                                  children: List.generate(menuList.length,(i){
                                    return Card(
                                        color: white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: InkWell(
                                            onTap: (){
                                              switch(i){
                                                case 0:
                                                  if(data[index]['id_featured'] == 'true'){
                                                    controller.unMarkFeatured(data[index].id);
                                                  }else{
                                                    controller.markFeatured(data[index].id);
                                                  }
                                                  break;
                                                case 1:
                                                  controller.deleteProduct(data[index].id);
                                                  break;
                                              }
                                            },
                                              child: normalText(title: menuList[i],color: data[index]['featured_id']  == currentUser!.uid && i == 0 ?  green : darkGrey)),
                                        ));
                                  }) ,
                                ) ;
                              }, clickType:VxClickType.singleClick ),
                          leading: Image.network(data[index]['p_images'][0]),
                          title: normalText(title: data[index]['p_name'],),
                          subtitle: Row(
                            children: [
                              smallText(title: '\$ ${data[index]['p_price']}',),
                              CustomSized(),
                              smallText(title: data[index]['id_featured'] == 'true' ? ' Featured':'Not - Featured'),
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
          }
      ),
    );
  }
}

