import 'dart:io';

import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/controllers/product_controller.dart';
import 'package:emart_seller/views/widgets_common/test_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class ProductDropDown extends StatelessWidget {
  final String title;
  final List<String> list;
  final RxString dropValue;
  final ProductController controller;

  const ProductDropDown({
    super.key,
    required this.title,
    required this.dropValue,
    required this.list,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DropdownButtonHideUnderline(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Obx(() => DropdownButton<String>(
            value: dropValue.value.isEmpty ? null : dropValue.value,
            items: list
                .map((e) => DropdownMenuItem(
              value: e,
              child: smallText(title: e, color: purpleColor),
            ))
                .toList(),
            onChanged: (value) {
              if (title == 'Categories') {
                controller.subCategoryValue.value = '';
                controller.populateSubCategoryList(value!);
              }
              dropValue.value = value!;
            },
            isExpanded: true,
            hint: smallText(title: title, color: darkGrey),
          )),
        ),
      ),
    );
  }
}



class ProductImages extends StatelessWidget {
  final String index ;
  final VoidCallback onTap ;
  const ProductImages({required this.index,required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          alignment: Alignment.center,
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: smallText(title: index,color: darkGrey),
        ),
      ),
    );
  }
}

