import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

cacheImageWidgetContain(String image, Color color){
  return Container(
    child: CachedNetworkImage(
      placeholder: (context, url) =>
          UnconstrainedBox(child:
          Container(
            alignment: Alignment.center,
            width: 40,
            height: 40,
            child: CircularProgressIndicator(backgroundColor: color,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 1,),
          )),
      imageUrl: image,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.contain,
          ),
        ),
      ),
      errorWidget: (context,url,error) => new Icon(Icons.error),
    ),
  );
}

cacheImageWidgetCover(String image, Color color){
  return Container(
    child: CachedNetworkImage(
      placeholder: (context, url) =>
          UnconstrainedBox(child:
          Container(
            alignment: Alignment.center,
            width: 40,
            height: 40,
            child: CircularProgressIndicator(backgroundColor: color,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 1,),
          )),
      imageUrl: image,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      errorWidget: (context,url,error) => new Icon(Icons.error),
    ),
  );
}