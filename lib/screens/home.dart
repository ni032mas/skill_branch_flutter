import 'package:FlutterGalleryApp/res/app_icons.dart';
import 'package:FlutterGalleryApp/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'feed_screen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 0;
  final PageStorageBucket bucket = PageStorageBucket();

  List<Widget> pages = [
    Feed(
      key: PageStorageKey('FeedPage'),
    ),
    Container(),
    Container()
  ];

  final List<BottomNavyBarItem> _tabs = [
    BottomNavyBarItem(
      asset: AppIcons.home,
      title: Text('Feed'),
      activeColor: AppColors.dodgerBlue,
      inactiveColor: AppColors.manatee,
    ),
    BottomNavyBarItem(
      asset: AppIcons.home,
      title: Text('Search'),
      activeColor: AppColors.dodgerBlue,
      inactiveColor: AppColors.manatee,
    ),
    BottomNavyBarItem(
      asset: AppIcons.home,
      title: Text('User'),
      activeColor: AppColors.dodgerBlue,
      inactiveColor: AppColors.manatee,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
          showElevation: true,
          itemCornerRadius: 8,
          curve: Curves.ease,
          currentTab: currentTab,
          onItemSelected: (int index) {
            setState(() {
              currentTab = index;
            });
          },
          items: _tabs),
      body: PageStorage(bucket: bucket, child: pages[currentTab]),
    );
  }
}

class BottomNavyBar extends StatelessWidget {
  BottomNavyBar(
      {Key key,
      this.currentTab,
      this.showElevation = true,
      this.backgroundColor = Colors.white,
      this.itemCornerRadius = 50,
      this.containerHeight = 56,
      this.animatedDuration = const Duration(microseconds: 270),
      this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
      @required this.items,
      @required this.onItemSelected,
      this.curve = Curves.linear})
      : super(key: key);

  final Color backgroundColor;
  final bool showElevation;
  final double containerHeight;
  final MainAxisAlignment mainAxisAlignment;
  final List<BottomNavyBarItem> items;
  final ValueChanged<int> onItemSelected;
  final int currentTab;
  final Duration animatedDuration;
  final double itemCornerRadius;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: backgroundColor, boxShadow: [if (showElevation) const BoxShadow(color: Colors.black12, blurRadius: 2)]),
      child: SafeArea(
          child: Container(
        width: double.infinity,
        height: containerHeight,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          children: items.map((item) {
            var index = items.indexOf(item);
            return GestureDetector(
              onTap: () => onItemSelected(index),
              child: _ItemWidget(
                isSelected: currentTab == index ? true : false,
                item: item,
                backgroundColor: backgroundColor,
                animationDuration: animatedDuration,
                itemCornerRadius: itemCornerRadius,
                curve: curve,
              ),
            );
          }).toList(),
        ),
      )),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  _ItemWidget(
      {@required this.isSelected,
      @required this.item,
      @required this.backgroundColor,
      @required this.animationDuration,
      this.curve = Curves.linear,
      @required this.itemCornerRadius})
      : assert(animationDuration != null, 'animationDuration is null'),
        assert(curve != null, 'curve is null'),
        assert(isSelected != null, 'isSelected is null'),
        assert(backgroundColor != null, 'backgroundColor is null'),
        assert(item != null, 'item is null'),
        assert(itemCornerRadius != null, 'itemCornerRadius is null');

  final bool isSelected;
  final BottomNavyBarItem item;
  final Color backgroundColor;
  final Duration animationDuration;
  final Curve curve;
  final double itemCornerRadius;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: isSelected ? 150 : (MediaQuery.of(context).size.width - 150 - 8 * 4 - 4 * 2) / 2,
      height: double.maxFinite,
      duration: animationDuration,
      curve: curve,
      decoration: BoxDecoration(
          color: isSelected ? item.activeColor.withOpacity(0.2) : backgroundColor, borderRadius: BorderRadius.circular(itemCornerRadius)),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            item.asset,
            size: 20,
            color: isSelected ? item.activeColor : item.inactiveColor,
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: DefaultTextStyle.merge(
                child: item.title,
                textAlign: item.textAlign,
                maxLines: 1,
                style: TextStyle(color: isSelected ? item.activeColor : item.inactiveColor, fontWeight: FontWeight.bold)),
          ))
        ],
      ),
    );
  }
}

class BottomNavyBarItem {
  final IconData asset;
  final Text title;
  final Color activeColor;
  final Color inactiveColor;
  final TextAlign textAlign;

  BottomNavyBarItem({@required this.asset, @required this.title, this.activeColor = Colors.blue, this.inactiveColor, this.textAlign})
      : assert(asset != null, 'asset is null'),
        assert(title != null, 'title is null');
}
