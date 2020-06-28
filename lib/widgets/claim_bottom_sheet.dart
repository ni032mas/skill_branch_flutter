import 'package:FlutterGalleryApp/res/colors.dart';
import 'package:flutter/material.dart';

class ClaimBottomSheet extends StatelessWidget {
  final List<String> itemsBottomSheet = ['adult', 'harm', 'bully', 'spam', 'copyright', 'hate'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.mercury, borderRadius: BorderRadius.circular(10)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
              itemsBottomSheet.length,
              (index) => Material(
                  color: Colors.transparent,
                  child: InkWell(
                      child: Container(
                          padding: EdgeInsets.all(15),
                          child: Center(child: Text(itemsBottomSheet[index].toUpperCase(), style: Theme.of(context).textTheme.headline3))),
                      onTap: () {
                        Navigator.pop(context);
                      })))),
    );
  }
}
