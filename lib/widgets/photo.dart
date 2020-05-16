import 'package:FlutterGalleryApp/res/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Photo extends StatelessWidget {
  final String photoLink;
  @required
  final String heroTag;

  Photo({Key key, this.photoLink, this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: heroTag,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(17)),
            child: Container(
              color: AppColors.grayChateau,
              child: CachedNetworkImage(
                imageUrl: photoLink,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ));
  }
}
