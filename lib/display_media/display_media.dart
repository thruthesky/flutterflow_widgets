import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
// import 'package:fireflow/fireflow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart' as p;

const _kSupportedVideoMimes = {'video/mp4', 'video/mpeg'};

bool _isVideoPath(String path) => _kSupportedVideoMimes.contains(mime(path.split('?').first));

bool _isImagePath(String path) => mime(path.split('?').first)?.startsWith('image/') ?? false;

class FlutterFlowMediaDisplay extends StatelessWidget {
  const FlutterFlowMediaDisplay({
    Key? key,
    required this.path,
    required this.imageBuilder,
    required this.videoPlayerBuilder,
    required this.fileBuilder,
  }) : super(key: key);

  final String path;
  final Widget Function(String) imageBuilder;
  final Widget Function(String) videoPlayerBuilder;
  final Widget Function(String) fileBuilder;

  @override
  Widget build(BuildContext context) {
    if (_isVideoPath(path)) {
      return videoPlayerBuilder(path);
    } else if (_isImagePath(path)) {
      return imageBuilder(path);
    } else {
      return fileBuilder(path);
    }

    // return _isVideoPath(path) ? videoPlayerBuilder(path) : imageBuilder(path);
  }
}

const kDefaultAspectRatio = 16 / 9;

enum VideoType {
  asset,
  network,
}

Set<VideoPlayerController> _videoPlayers = {};

class FlutterFlowVideoPlayer extends StatefulWidget {
  const FlutterFlowVideoPlayer({
    Key? key,
    required this.path,
    this.videoType = VideoType.network,
    this.width,
    this.height,
    this.aspectRatio,
    this.autoPlay = false,
    this.looping = false,
    this.showControls = true,
    this.allowFullScreen = true,
    this.allowPlaybackSpeedMenu = false,
    this.lazyLoad = false,
  }) : super(key: key);

  final String path;
  final VideoType videoType;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final bool autoPlay;
  final bool looping;
  final bool showControls;
  final bool allowFullScreen;
  final bool allowPlaybackSpeedMenu;
  final bool lazyLoad;

  @override
  State<StatefulWidget> createState() => _FlutterFlowVideoPlayerState();
}

class _FlutterFlowVideoPlayerState extends State<FlutterFlowVideoPlayer> {
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _loggedError = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayers.remove(_videoPlayerController);
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  double get width => widget.width == null || widget.width! >= double.infinity ? MediaQuery.of(context).size.width : widget.width!;

  double get height => widget.height == null || widget.height! >= double.infinity ? width / aspectRatio : widget.height!;

  double get aspectRatio => _chewieController?.videoPlayerController.value.aspectRatio ?? kDefaultAspectRatio;

  Future initializePlayer() async {
    _videoPlayerController = widget.videoType == VideoType.network ? VideoPlayerController.network(widget.path) : VideoPlayerController.asset(widget.path);
    if (kIsWeb && widget.autoPlay) {
      // Browsers generally don't allow autoplay unless it's muted.
      // Ideally this should be configurable, but for now we just automatically
      // mute on web.
      // See https://pub.dev/packages/video_player_web#autoplay
      _videoPlayerController!.setVolume(0);
    }
    if (!widget.lazyLoad) {
      await _videoPlayerController?.initialize();
    }
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController!,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      aspectRatio: widget.aspectRatio,
      autoPlay: widget.autoPlay,
      looping: widget.looping,
      showControls: widget.showControls,
      allowFullScreen: widget.allowFullScreen,
      allowPlaybackSpeedChanging: widget.allowPlaybackSpeedMenu,
    );

    _videoPlayers.add(_videoPlayerController!);
    _videoPlayerController!.addListener(
      () {
        if (_videoPlayerController!.value.hasError && !_loggedError) {
          _loggedError = true;
        }
        // Stop all other players when one video is playing.
        if (_videoPlayerController!.value.isPlaying) {
          for (var otherPlayer in _videoPlayers) {
            if (otherPlayer != _videoPlayerController && otherPlayer.value.isPlaying) {
              setState(() {
                otherPlayer.pause();
              });
            }
          }
        }
      },
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) => FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          height: height,
          width: width,
          child: _chewieController != null && (widget.lazyLoad || _chewieController!.videoPlayerController.value.isInitialized)
              ? Chewie(controller: _chewieController!)
              : (_chewieController != null && _chewieController!.videoPlayerController.value.hasError)
                  ? const Text('Error playing video')
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Loading'),
                      ],
                    ),
        ),
      );
}

/// Display Media
///
/// It displays any kinds of files based on the given [url] string. It can be
/// used for the other pair of [UploadMedia] widget.
///
/// The [width] and [height] are respected. You may pass `Inf` to adjust its
/// size by parent.
///
/// Images are displayed with [CachedNetworkImage]. It means, it will cache
/// the image and display a placeholder while loading.
///
/// Videos are displayed with [Chewie]. It will not display the controller
/// if the width is less than 160.
///
class DisplayMedia extends StatefulWidget {
  const DisplayMedia({
    Key? key,
    this.width,
    this.height,
    required this.url,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String url;

  @override
  _UploadedMediaState createState() => _UploadedMediaState();
}

class _UploadedMediaState extends State<DisplayMedia> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(widget.url),
      child: FlutterFlowMediaDisplay(
        path: widget.url,
        imageBuilder: (path) => CachedNetworkImage(
          imageUrl: path,
          placeholder: (context, url) => const CircularProgressIndicator.adaptive(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        videoPlayerBuilder: (path) => FlutterFlowVideoPlayer(
          path: path,
          width: widget.width,
          height: widget.height,
          autoPlay: false,
          looping: true,
          showControls: (widget.width ?? double.infinity) > 160,
          allowFullScreen: true,
          allowPlaybackSpeedMenu: false,
        ),
        fileBuilder: (path) => SizedBox(
          width: widget.width,
          height: widget.height,
          // color: Colors.blue,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: LayoutBuilder(builder: (context, constraint) {
                  return Icon(Icons.insert_drive_file, size: constraint.biggest.height);
                }),
              ),
              SizedBox(
                width: widget.width,
                height: widget.height,
                child: Align(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 36.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          path.split('.').last.split('?').first.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        Text(
                          p.basename(path.replaceAll('%2F', '/').split('?').first),
                          style: const TextStyle(fontSize: 6, color: Colors.white),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
