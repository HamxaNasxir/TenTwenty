import 'package:flutter/material.dart';
import 'package:tentwenty/views/widgets/customText.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../utils/colors.dart';

class VideoPlayer extends StatefulWidget {
  final String videoTitle;
  final String videoUrl;

  VideoPlayer(this.videoTitle, this.videoUrl);

  @override
  State<StatefulWidget> createState() {
    return _VideoPlayerState();
  }
}

class _VideoPlayerState extends State<VideoPlayer> {
  late YoutubePlayerController _controller;
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoUrl,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: pageBackgroundColor,
      appBar: AppBar(
        title: CustomText(
          text: widget.videoTitle,
        ),
        backgroundColor: whiteColor,
      ),
      body: YoutubePlayerBuilder(
        onExitFullScreen: () {
          // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        },
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: bottomNavColor,
          topActions: null,
          onReady: () {
            _isPlayerReady = true;
          },
          onEnded: (data) {
            Navigator.of(context).pop();
          },
        ),
        builder: (context, player) => player,
      ),
    );
  }
}
