
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

TextStyle headingStyle1({ color = Colors.black }){
  return TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: color
  );
}

TextStyle headingStyle2({ color = Colors.black }){
  return TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color
  );
}

TextStyle headingStyle3({ color = Colors.black }){
  return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: color
  );
}

TextStyle subHeading1({ color = Colors.black }){
  return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.normal,
      color: color
  );
}

TextStyle subHeading2({ color = Colors.black }){
  return TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color
  );
}

TextStyle smallText1({ color = Colors.black }){
  return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: color
  );
}

TextStyle smallText1Bold({ color = Colors.black }){
  return TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: color
  );
}

TextStyle smallText2({ color = Colors.black }){
  return TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color
  );
}

TextStyle smallText3({ color = Colors.black }){
  return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color
  );
}