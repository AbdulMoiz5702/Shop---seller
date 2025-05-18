import 'package:emart_seller/const/colors.dart';
import 'package:emart_seller/views/widgets_common/test_widgets.dart';
import 'package:flutter/material.dart';

import 'customSized.dart';



class CustomTextField extends StatelessWidget {
  final String title;
  final String hintText ;
  final TextEditingController controller ;
  final bool isDescription ;
  final TextInputType keyboard ;
  CustomTextField({required this.title,required this.hintText,required this.controller , this.isDescription = false,this.keyboard = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        smallText(title: title,color: purpleColor,textSize: 16.0),
        CustomSized(height: 0.01,),
        TextFormField(
          keyboardType: keyboard,
          maxLines: isDescription == true ? 3 : 1,
          controller: controller,
          decoration: InputDecoration(
              filled: true,
              fillColor: lightGrey,
              isDense: true,
              hintText: hintText,
              hintStyle: TextStyle(
                color:textfieldGrey,
              ),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: purpleColor),
              )
          ),
        ),
      ],
    );
  }
}
