import 'dart:async';

import 'package:FlutterGalleryApp/main.dart';
import 'package:FlutterGalleryApp/res/app_icons.dart';
import 'package:FlutterGalleryApp/res/colors.dart';
import 'package:FlutterGalleryApp/res/styles.dart';
import 'package:FlutterGalleryApp/widgets/demo_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'feed_screen.dart';

class Home extends StatefulWidget {
  Home(this.onConnectivityChanged);

  final Stream<ConnectivityResult> onConnectivityChanged;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  StreamSubscription subscription;
  int currentTab = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  final ConnectivityOverlay _connectivityOverlay = ConnectivityOverlay();

  @override
  void initState() {
    super.initState();
    subscription = widget.onConnectivityChanged.listen((ConnectivityResult result) {
      switch (result) {
        case ConnectivityResult.wifi:
          _connectivityOverlay.removeOverlay(context);
          break;
        case ConnectivityResult.mobile:
          _connectivityOverlay.removeOverlay(context);
          break;
        case ConnectivityResult.none:
          var child = Positioned(
            top: MediaQuery.of(context).viewInsets.top + 50,
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                decoration: BoxDecoration(
                  color: AppColors.mercury,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('No connection internet', style: AppStyles.h3),
              ),
            ),
          );
          _connectivityOverlay.showOverlay(context, child);
          break;
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

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
          onItemSelected: (int index) async {
            if (index == 1) {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return DemoScreen();
              }));
            } else {
              setState(() {
                currentTab = index;
              });
            }
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
      this.curve = Curves.linear}) {
    assert(items != null);
    assert(items.length >= 2 && items.length <= 5);
    assert(onItemSelected != null);
    assert(curve != null);
  }

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
    final bgColor = (backgroundColor == null) ? Theme.of(context).bottomAppBarColor : backgroundColor;
    return Container(
      decoration: BoxDecoration(
          color: bgColor, boxShadow: [if (showElevation) const BoxShadow(color: Colors.black12, blurRadius: 2)]),
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
                backgroundColor: bgColor,
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
      {Key key,
      @required this.isSelected,
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
        assert(itemCornerRadius != null, 'itemCornerRadius is null'),
        super(key: key);

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
          color: isSelected ? item.activeColor.withOpacity(0.2) : backgroundColor,
          borderRadius: BorderRadius.circular(itemCornerRadius)),
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

  BottomNavyBarItem(
      {@required this.asset, @required this.title, this.activeColor = Colors.blue, this.inactiveColor, this.textAlign})
      : assert(asset != null, 'asset is null'),
        assert(title != null, 'title is null');
}
