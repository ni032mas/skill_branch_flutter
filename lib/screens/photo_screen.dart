import 'package:FlutterGalleryApp/res/colors.dart';
import 'package:FlutterGalleryApp/res/res.dart';
import 'package:FlutterGalleryApp/widgets/claim_bottom_sheet.dart';
import 'package:FlutterGalleryApp/widgets/user_avatar.dart';
import 'package:FlutterGalleryApp/widgets/like_button.dart';
import 'package:FlutterGalleryApp/widgets/photo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

class FullScreenImageArguments {
  final String photo;
  final String altDescription;
  final String userName;
  final String name;
  final String userPhoto;
  final String heroTag;
  final Key key;
  final RouteSettings routeSettings;

  FullScreenImageArguments(
      {this.photo,
      this.altDescription,
      this.userName,
      this.name,
      this.userPhoto,
      this.heroTag,
      this.key,
      this.routeSettings});
}

class FullScreenImage extends StatefulWidget {
  FullScreenImage(
      {this.photo = '',
      this.altDescription = '',
      this.userName = '',
      this.name = '',
      this.userPhoto = '',
      Key key,
      this.heroTag})
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
    _opacityUserAvatar = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.5, curve: Curves.ease)));
    _opacityUserCredentials = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Interval(0.5, 1.0, curve: Curves.ease)));
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
            Hero(tag: widget.heroTag, child: Photo(photoLink: widget.photo)),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(widget.altDescription, maxLines: 3, overflow: TextOverflow.ellipsis, style: AppStyles.h3),
            ),
            const SizedBox(height: 9),
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
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.more_vert,
              color: AppColors.grayChateau,
            ),
            onPressed: () {
              showModalBottomSheet(context: context, builder: (context) => ClaimBottomSheet());
            })
      ],
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
          const SizedBox(
            width: 14,
          ),
          Expanded(
              child: GestureDetector(
            child: _buildButton('Save', () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Downloading photos'),
                      content: Text("Are you sure you want to upload a photo?"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Download"),
                          onPressed: () {
                            _savePhoto();
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ],
                    );
                  });
            }),
            onTap: () {},
          )),
          const SizedBox(width: 14),
          Expanded(
            child: _buildButton('Visit', () async {
              OverlayState overlayState = Overlay.of(context);
              OverlayEntry overlayEntry = OverlayEntry(builder: (BuildContext context) {
                return Positioned(
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
                      child: Text('SkillBranch'),
                    ),
                  ),
                );
              });
              overlayState.insert(overlayEntry);
              await new Future.delayed(Duration(seconds: 1));
              overlayEntry?.remove();
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        alignment: Alignment.center,
        height: 36,
        decoration: BoxDecoration(color: AppColors.dodgerBlue, borderRadius: BorderRadius.circular(7)),
        child: Text(
          text,
          style: AppStyles.h4.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  void _savePhoto() async {
    GallerySaver.saveImage(widget.photo).then((bool success) {
      setState(() {});
    });
  }
}
