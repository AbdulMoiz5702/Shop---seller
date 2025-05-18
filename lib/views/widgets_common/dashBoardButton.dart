import 'package:emart_seller/views/widgets_common/test_widgets.dart';
import 'package:flutter/material.dart';

import '../../const/colors.dart';
import 'customSized.dart';

class DashBoardButton extends StatelessWidget {
  final String title ;
  final String counts ;
  final String imagePath ;
  const DashBoardButton({required this.imagePath,required this.title,required this.counts});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: 70,
      width: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: purpleColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              normalText(title: title),
              CustomSized(height: 0.01,),
              smallText(title: counts),
            ],
          ),
          Image.asset(imagePath,width: 40,),
        ],
      ),
    );
  }
}
