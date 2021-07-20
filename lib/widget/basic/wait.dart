import 'package:flutter/material.dart';
import 'package:shopping/main.dart';
import 'package:shopping/widget/colorloader2.dart';

bSkinWait(BuildContext context, bool all){
  var windowWidth = MediaQuery.of(context).size.width;
  var windowHeight = MediaQuery.of(context).size.height;
  if (all)
    return Container(
      color: Color(0x80000000),
      width: windowWidth,
      height: windowHeight,
      child: Center(
        child: ColorLoader2(
          color1: theme.colorPrimary,
          color2: theme.colorCompanion,
          color3: theme.colorPrimary,
        ),
      ),
    );

  return Center(
    child: ColorLoader2(
      color1: theme.colorPrimary,
      color2: theme.colorCompanion,
      color3: theme.colorPrimary,
    ),
  );
}