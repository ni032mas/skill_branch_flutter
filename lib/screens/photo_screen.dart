import 'package:FlutterGalleryApp/res/colors.dart';
import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/widgets/user_avatar.dart';
import 'package:FlutterGalleryApp/widgets/like_button.dart';
import 'package:FlutterGalleryApp/widgets/photo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatefulWidget {
  FullScreenImage({this.photo = '', this.altDescription = '', this.userName = '', this.name = '', this.userPhoto = '', Key key, this.heroTag})
      : super(key: key);

  final String photo;
  final String altDescription;
  final String userName;
  final String name;
  final String userPhoto;
  final String heroTag;

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _opacityUserAvatar;
  Animation<double> _opacityUserCredentials;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _opacityUserAvatar = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.5, curve: Curves.ease)));
    _opacityUserCredentials =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _controller, curve: Interval(0.5, 1.0, curve: Curves.ease)));
    _playAnimation();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await _controller.forward().orCancel;
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Photo(photoLink: widget.photo, heroTag: widget.heroTag),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.altDescription,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppStyles.h3,
              ),
            ),
            const SizedBox(
              height: 9,
            ),
            _buildPhotoMeta(),
            const SizedBox(
              height: 17,
            ),
            _buildActionButton()
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: AppColors.grayChateau,
          ),
          onPressed: () => Navigator.pop(context)),
      backgroundColor: AppColors.white,
      centerTitle: true,
      title: Text(
        'Photo',
        style: AppStyles.h2Black,
      ),
    );
  }

  Widget _buildPhotoMeta() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: <Widget>[
          AnimatedBuilder(
              animation: _controller,
              child: UserAvatar(widget.userPhoto),
              builder: (context, child) => FadeTransition(
                    opacity: _opacityUserAvatar,
                    child: child,
                  )),
          const SizedBox(
            width: 10,
          ),
          AnimatedBuilder(
              animation: _controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.name,
                    style: AppStyles.h1Black,
                  ),
                  Text(
                    "@${widget.userName}",
                    style: AppStyles.h5Black.copyWith(color: AppColors.manatee),
                  )
                ],
              ),
              builder: (context, child) => FadeTransition(
                    opacity: _opacityUserCredentials,
                    child: child,
                  )),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(child: LikeButton()),
          Expanded(
              child: GestureDetector(
            child: _buildButton('Save'),
            onTap: () {},
          )),
          const SizedBox(
            width: 12,
          ),
          Expanded(
              child: GestureDetector(
            child: _buildButton('Visit'),
            onTap: () {},
          )),
        ],
      ),
    );
  }

  Widget _buildButton(String text) {
    return Container(
      alignment: Alignment.center,
      height: 36,
      decoration: BoxDecoration(color: AppColors.dodgerBlue, borderRadius: BorderRadius.circular(7)),
      child: Text(
        text,
        style: AppStyles.h4.copyWith(color: AppColors.white),
      ),
    );
  }
}
