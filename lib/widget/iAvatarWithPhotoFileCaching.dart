import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class IAvatarWithPhotoFileCaching extends StatelessWidget {
  final String avatar;
  final Color color;
  final Color colorBorder;
  final Function callback;
  final Color colorProgressBar;
  IAvatarWithPhotoFileCaching({this.avatar, this.color = Colors.black, this.colorBorder = Colors.white,
    this.colorProgressBar = Colors.black,
    this.callback});

  @override
  Widget build(BuildContext context) {
    var windowHeight = MediaQuery
        .of(context)
        .size
        .height;

    return Container(
        margin: EdgeInsets.only(top: 20, bottom: 20),
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            Container(
              height: windowHeight*0.2+10,
              width: windowHeight*0.2+10,
              child: Container(
                height: windowHeight*0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(windowHeight*0.2),
                  child: Container(
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      imageUrl: avatar,
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
                  ),
                ),

//                CircleAvatar(backgroundImage: avatar,
//                  radius: windowHeight*0.1,
                //),
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(
                    color: colorBorder,
                    width: 4.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: windowHeight*0.2-30,
                  left: windowHeight*0.2-40),
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 3,
                          blurRadius: 3,
                          offset: Offset(1, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Icon(Icons.photo_camera, color: Colors.white, size: 30),
                  ),
                  Positioned.fill(
                    child: Material(
                        color: Colors.transparent,
                        shape: CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        child: InkWell(
                          splashColor: Colors.grey[400],
                          onTap: (){
                            if (callback != null)
                              callback();
                          }, // needed
                        )),
                  )
                ],
              ),),

          ],
        )
    );
  }
}