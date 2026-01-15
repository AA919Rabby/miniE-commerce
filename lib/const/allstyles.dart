import 'package:e_commerce/const/allcolors.dart';
import 'package:e_commerce/const/allsizes.dart';
import 'package:flutter/material.dart';

class AllStyles{
  static final headingStyle=TextStyle(
    fontSize: AllSizes.large,
    fontFamily: 'Roboto',
    color: AllColors.darkColor,
    fontWeight: FontWeight.w500,
  );
  static final titleTextStyle=TextStyle(
    fontSize: AllSizes.medium,
    fontFamily: 'Roboto',
    color: AllColors.darkColor,
    fontWeight: FontWeight.w400,
  );
  static final subtitleTextStyle=TextStyle(
    fontSize: AllSizes.small,
    fontFamily: 'Roboto',
    color: AllColors.darkColor,
    fontWeight: FontWeight.normal,
  );
}