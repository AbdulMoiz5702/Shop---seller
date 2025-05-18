import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/const/fire_base_constants.dart';
import 'package:emart_seller/controllers/auth_controller.dart';
import 'package:emart_seller/services/fire_base_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../chat_screens/chat_screen.dart';
import '../shop_screen/shop_screnn.dart';
import '../widgets_common/customSized.dart';
import '../widgets_common/test_widgets.dart';
import 'edit_profile_screen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var controller = Get.put(AuthController());
    List<String> profileList = [
      'Shop Settings',
      'My Messages',
    ];

    List<IconData> profileListIcon = [
      Icons.store,
      Icons.messenger,
    ];
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: normalText(title: 'Settings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<DocumentSnapshot>(
                stream: FireBaseServices.getUser(currentUser!.uid),
                builder:(context,snapshot,){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(child: CupertinoActivityIndicator(),);
                  }else if (snapshot.hasData){
                    var data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                    data['imageUrl'] != 'none' ? Container(
                    height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: NetworkImage(data['imageUrl']),fit: BoxFit.cover),
                      )): Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: AssetImage(appLogo),fit: BoxFit.cover),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                normalText(title: data['name']),
                                smallText(title:data['email']),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(onPressed: (){
                              Get.to(()=> EditProfileScreen(email: data['email'],name: data['name'],imageUrl:data['imageUrl'],),transition: Transition.cupertino);
                            }, icon: Icon(Icons.edit,color: white,)),
                            InkWell(
                              onTap: ()async{
                                controller.logout(context: context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: white)
                                ),
                                child: smallText(color: white,title: 'Logout'),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  }else{
                    return Center(child: largeText(title: 'Something went wrong'),);
                  }
                }),
          ),
          CustomSized(),
          StreamBuilder<DocumentSnapshot>(
            stream: FireBaseServices.getUser(currentUser!.uid),
              builder:(context,snapshot,){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CupertinoActivityIndicator(),);
                }else if (snapshot.hasData){
                  var data = snapshot.data!.data() as Map<String, dynamic>? ?? {};
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context,index){
                            return ListTile(
                              onTap: (){
                                switch(index){
                                  case(0):
                                    Get.to(()=> ShopScreen(data: data,),transition: Transition.cupertino);
                                    break;
                                  case(1):
                                    Get.to(()=> ChatScreen(userId: currentUser!.uid,),transition: Transition.cupertino);
                                    break;
                                }
                              },
                              dense: true,
                              leading: Icon(profileListIcon[index],color: darkGrey,),
                              title: normalText(title: profileList[index],color: darkGrey),
                              trailing: Icon(Icons.arrow_forward_ios),
                            );
                          }, separatorBuilder: (context,index){
                        return Divider(color: darkGrey,);
                      }, itemCount: profileList.length),
                    ),
                  );
                }else{
                  return Center(child: largeText(title: 'Something went wrong'),);
                }
              }
          ),
        ],
      ),
    );
  }
}
