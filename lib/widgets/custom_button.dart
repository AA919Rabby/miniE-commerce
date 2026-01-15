import 'package:e_commerce/const/allcolors.dart';
import 'package:e_commerce/const/allsizes.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  double height;
  double width;
  String label;
  Color color;
  Color ?labelColor=AllColors.darkColor;
  VoidCallback? onTap;
  VoidCallback? onPressed;
  CustomButton({
    required this.height,
    required this.width,
    required this.color,
    required this.label,
     this.onTap,
    this.onPressed,
    this.labelColor,

  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            label,style: TextStyle(
            color: labelColor,fontSize: AllSizes.large,
          ),
          ),
        ),
      ),
    );
  }
}
