import 'package:FlutterGalleryApp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/screens/photo_screen.dart';

const String kFlutterDash = "https://flutter.dev/assets/404/dash_nest-c64796b59b65042a2b40fae5764c13b7477a592db79eaf04c86298dcb75b78ea.png";

class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FeedState();
  }
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                _buildItem(index),
                Divider(
                  thickness: 2,
                  color: AppColors.mercury,
                ),
              ],
            );
          }),
    );
  }

  Widget _buildItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FullScreenImage(
                          photo: kFlutterDash,
                          name: 'Aleksandr',
                          userName: "ni032mas",
                          altDescription: "This is Flutter dash",
                          userPhoto: 'https://sun9-70.userapi.com/c628121/v628121093/b580/fYX7xll2-nI.jpg',
                          heroTag: "$kFlutterDash$index",
                        )));
          },
          child: Photo(
            photoLink: kFlutterDash,
            heroTag: "$kFlutterDash$index",
          ),
        ),
        _buildPhotoMeta(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            'This is Flutter dash. I love him :)',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppStyles.h3.copyWith(color: AppColors.manatee),
          ),
        )
      ],
    );
  }

  _buildPhotoMeta() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              UserAvatar('https://sun9-70.userapi.com/c628121/v628121093/b580/fYX7xll2-nI.jpg'),
              SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Aleksandr Marmyshev',
                    style: AppStyles.h2Black,
                  ),
                  Text(
                    '@ni032mas',
                    style: AppStyles.h2Black,
                  ),
                ],
              )
            ],
          ),
          LikeButton(
            likeCount: 10,
            isLiked: true,
          ),
        ],
      ),
    );
  }
}
