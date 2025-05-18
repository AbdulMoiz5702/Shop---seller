import 'dart:io';

import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/const/const.dart';
import 'package:emart_seller/controllers/product_controller.dart';
import 'package:emart_seller/views/widgets_common/customSized.dart';
import 'package:emart_seller/views/widgets_common/customtextField.dart';
import 'package:emart_seller/views/widgets_common/test_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets_common/product_drop_down.dart';

class AddProducts extends StatelessWidget {
  const AddProducts({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProductController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleColor,
        actions: [
          Obx(
          ()=>controller.isLoading.value == true ? Center(child: CupertinoActivityIndicator(),) : TextButton(
                onPressed: () async{
                  await controller.uploadImages(context: context, images: controller.pImages).then((value){
                    controller.uploadProduct();
                    Get.back();
                  });
                }, child: Text('Save')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomSized(),
              CustomTextField(title: 'Name', hintText: 'Product Name', controller: controller.nameController),
              CustomSized(),
              CustomTextField(title: 'Description', hintText: 'Product Description', controller: controller.descriptionController,isDescription: true,),
              CustomSized(),
              CustomTextField(title: 'Price', hintText: 'Product Price', controller: controller.priceController,keyboard: TextInputType.number,),
              CustomSized(),
              CustomTextField(title: 'Quantity', hintText: 'Product Quantity', controller: controller.quantityController,keyboard: TextInputType.number,),
              CustomSized(),
              ProductDropDown(
                title: 'Categories',
                list: controller.categoryList,
                dropValue: controller.categoryValue,
                controller: controller,
              ),
              CustomSized(),
              ProductDropDown(
                title: 'Sub Categories',
                list: controller.subCategoryList,
                dropValue: controller.subCategoryValue,
                controller: controller,
              ),

              CustomSized(),
              smallText(title: 'First image is your display image that buyer see',color: darkGrey),
              CustomSized(),
              Obx(
                  () => controller.pImages.isEmpty ? InkWell(
                      onTap: (){
                        controller.pickMultipleImages(context: context);
                      },
                      child: Container(height: 150,width: 150,child: Icon(Icons.image,size: 35,),)) : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:List.generate(controller.pImages.length, (index){
                  return InkWell(
                      onTap: (){
                        controller.pickMultipleImages(context: context);
                      },
                      child: Container(height: 150,width: 150,child: Image.file(controller.pImages[index],fit: BoxFit.fill,),));
                }) ,
              ),
            ),
            CustomSized(),
              smallText(title: 'Select Colors',color: darkGrey),
              CustomSized(),
              Obx(
                ()=> Wrap(
                  direction: Axis.horizontal,
                  children: List.generate(15, (index){
                    return InkWell(
                      onTap: (){
                        controller.selectedIndex(index);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(2),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Vx.randomPrimaryColor,
                        ),
                        child: controller.selectedColorIndex.value == index ?Icon(Icons.check_circle,color: white,size: 30,) : null,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
