//
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:legacy_sync/core/images/images.dart';
// import 'package:video_player/video_player.dart';
//
// class CustomVideoPlayer extends StatefulWidget {
//   final String url;
//   final double? width;
//   final double? height;
//   final BorderRadius? borderRadius;
//   final bool autoPlay;
//   final bool showControls;
//
//   const CustomVideoPlayer({
//     Key? key,
//     required this.url,
//     this.width,
//     this.height,
//     this.borderRadius,
//     this.autoPlay = false,
//     this.showControls = true,
//   }) : super(key: key);
//
//   @override
//   State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
// }
//
// class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;
//   bool _isPlaying = false;
//   bool _showControls = true;
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//   }
//
//   void _initializeVideo() {
//     setState(() {
//       _isLoading = true;
//     });
//
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
//
//     _controller.initialize().then((_) {
//       setState(() {
//         _isInitialized = true;
//         _isLoading = false;
//       });
//
//       if (widget.autoPlay) {
//         _controller.play();
//         setState(() {
//           _isPlaying = true;
//         });
//       }
//     }).catchError((error) {
//       setState(() {
//         _isLoading = false;
//       });
//       debugPrint('Video initialization error: $error');
//     });
//
//     _controller.addListener(() {
//       if (_controller.value.isPlaying != _isPlaying) {
//         setState(() {
//           _isPlaying = _controller.value.isPlaying;
//         });
//       }
//     });
//   }
//
//   void _togglePlayPause() {
//     setState(() {
//       if (_controller.value.isPlaying) {
//         _controller.pause();
//         _isPlaying = false;
//       } else {
//         _controller.play();
//         _isPlaying = true;
//       }
//     });
//   }
//
//   void _seekBackward() {
//     final currentPosition = _controller.value.position;
//     final newPosition = currentPosition - const Duration(seconds: 15);
//     _controller.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
//   }
//
//   void _seekForward() {
//     final currentPosition = _controller.value.position;
//     final duration = _controller.value.duration;
//     final newPosition = currentPosition + const Duration(seconds: 15);
//     _controller.seekTo(newPosition > duration ? duration : newPosition);
//   }
//
//   void _toggleControls() {
//     setState(() {
//       _showControls = !_showControls;
//     });
//   }
//
//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//
//     if (duration.inHours > 0) {
//       return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//     } else {
//       return "$twoDigitMinutes:$twoDigitSeconds";
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: widget.width ?? double.infinity,
//       height: widget.height ?? 200,
//       decoration: BoxDecoration(
//         borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
//         color: Colors.black,
//       ),
//       child: ClipRRect(
//         borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             // Video Player
//             if (_isInitialized)
//               GestureDetector(
//                 onTap: widget.showControls ? _toggleControls : null,
//                 child: SizedBox.expand(
//                   child: FittedBox(
//                     fit: BoxFit.cover,
//                     child: SizedBox(
//                       width: _controller.value.size.width,
//                       height: _controller.value.size.height,
//                       child: VideoPlayer(_controller),
//                     ),
//                   ),
//                 ),
//               )
//             else
//               Container(
//                 color: Colors.grey[300],
//                 child: const Center(
//                   child: Icon(
//                     Icons.play_circle_fill_rounded,
//                     size: 50,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//
//             // Loading Indicator
//             if (_isLoading)
//               Container(
//                 color: Colors.black54,
//                 child: const Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 ),
//               ),
//
//             // Play Button Overlay (when paused)
//             if (!_isPlaying && _isInitialized && !_isLoading)
//               GestureDetector(
//                 onTap: _togglePlayPause,
//                 child: Container(
//                   width: 50,
//                   height: 50,
//                   padding: const EdgeInsets.all(10),
//                   decoration: const BoxDecoration(
//                     color: Color(0xfff52b59),
//                     shape: BoxShape.circle,
//
//                   ),
//                   child:SizedBox(height: 20,width: 20,child: SvgPicture.asset(Images.ic_play_svg,height: 20,width: 20, fit: BoxFit.contain,)),
//                 ),
//               ),
//
//             // Video Controls (when playing) - Like your image
//              if (_isPlaying && _showControls && widget.showControls && _isInitialized)
//               Stack(
//                 children: [
//                   // Center Controls (15s buttons + play/pause)
//                   Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         // 15s Backward
//                         GestureDetector(
//                           onTap: _seekBackward,
//                           child: Container(
//                             width: 50,
//                             height: 50,
//                            padding: const EdgeInsets.all(10),
//                             child: SvgPicture.asset(
//                               Images.second_reverse_svg,
//                               height: 28,
//                               width: 28,
//                             ),
//                           ),
//                         ),
//
//                         // Play/Pause Button
//                         GestureDetector(
//                           onTap: _togglePlayPause,
//                           child: Container(
//                             width: 50,
//                             height: 50,
//                             padding: const EdgeInsets.all(12),
//                             decoration: const BoxDecoration(
//                               color: Color(0xff6f6f70),
//                               shape: BoxShape.circle,
//
//                             ),
//                             child:SizedBox(height: 20,width: 20,child: SvgPicture.asset(Images.ic_pause_svg,height: 20,width: 20, fit: BoxFit.contain,)),
//
//                           ),
//                         ),
//
//                         // 15s Forward
//                         GestureDetector(
//                           onTap: _seekForward,
//                           child: Container(
//                             width: 50,
//                             height: 50,
//                             padding: const EdgeInsets.all(10),
//                             child: SvgPicture.asset(
//                               Images.second_forward_svg,
//                               height: 28,
//                               width: 28,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Bottom Progress Bar and Duration (like your image)
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter,
//                           colors: [
//                             Colors.black.withOpacity(0.7),
//                             Colors.transparent,
//                           ],
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           // Progress Bar
//                           Expanded(
//                             child: VideoProgressIndicator(
//                               _controller,
//                               allowScrubbing: true,
//                               padding: EdgeInsets.zero,
//                               colors: const VideoProgressColors(
//                                 playedColor: Color(0xff866ffa),
//                                 bufferedColor: Color(0xffbbbbbb),
//                                 backgroundColor: Color(0xffbbbbbb),
//
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(width: 10),
//                           Text(
//                             _formatDuration(_controller.value.duration - _controller.value.position),
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           )
//
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//             // Error State
//             if (!_isInitialized && !_isLoading)
//               Container(
//                 color: Colors.grey[300],
//                 child: const Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         size: 50,
//                         color: Colors.grey,
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Failed to load video',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
/// New With Horizontal
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
   final String url;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool autoPlay;
  final bool showControls;
  final Duration? startPosition;

  const CustomVideoPlayer({
    Key? key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius,
    this.autoPlay = false,
    this.showControls = true,
    this.startPosition,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();

  }

  void _initializeVideo() {
    setState(() {
      _isLoading = true;
    });

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));

    _controller.initialize().then((_) {
      setState(() {
        print("video initialize...");
        _isInitialized = true;
        _isLoading = false;
      });

      // Seek to start position if provided
      if (widget.startPosition != null) {
        _controller.seekTo(widget.startPosition!);
      }

      if (widget.autoPlay) {
        _controller.play();
        setState(() {
          _isPlaying = true;
        });
      }
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Video initialization error: $error');
    });

    _controller.addListener(() {
      if (_controller.value.isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _seekBackward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 15);
    _controller.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void _seekForward() {
    final currentPosition = _controller.value.position;
    final duration = _controller.value.duration;
    final newPosition = currentPosition + const Duration(seconds: 15);
    _controller.seekTo(newPosition > duration ? duration : newPosition);
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _openFullScreen() async {
    // Pause the current video and get the position
    final currentPosition = _controller.value.position;
    final wasPlaying = _controller.value.isPlaying;
    _controller.pause();

    // Navigate to fullscreen page
    final returnedPosition = await Navigator.push<Duration>(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(
          url: widget.url,
          startPosition: currentPosition,
          autoPlay: wasPlaying,
        ),
      ),
    );
    setState(() {
      setState(() {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      });
    });

    // When returning from fullscreen, seek to the position
    if (returnedPosition != null && mounted) {
      await _controller.seekTo(returnedPosition);
      if (wasPlaying) {
        _controller.play();
      }
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 200,
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Video Player
            if (_isInitialized)
              GestureDetector(
                onTap: widget.showControls ? _toggleControls : null,
                child: SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                ),
              )
            else
              Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(
                    Icons.play_circle_fill_rounded,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),

            // Loading Indicator
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),

            // Play Button Overlay (when paused)
            if (!_isPlaying && _isInitialized && !_isLoading)
              GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xfff52b59),
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: SvgPicture.asset(
                      Images.ic_play_svg,
                      height: 20,
                      width: 20,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

            // Video Controls (when playing)
            if (_isPlaying && _showControls && widget.showControls && _isInitialized)
              Stack(
                children: [
                  // Center Controls (15s buttons + play/pause)
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 15s Backward
                        GestureDetector(
                          onTap: _seekBackward,
                          child: Container(
                            width: 50,
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              Images.second_reverse_svg,
                              height: 28,
                              width: 28,
                            ),
                          ),
                        ),

                        // Play/Pause Button
                        GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            width: 50,
                            height: 50,
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Color(0xff6f6f70),
                              shape: BoxShape.circle,
                            ),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                Images.ic_pause_svg,
                                height: 20,
                                width: 20,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        // 15s Forward
                        GestureDetector(
                          onTap: _seekForward,
                          child: Container(
                            width: 50,
                            height: 50,
                            padding: const EdgeInsets.all(10),
                            child: SvgPicture.asset(
                              Images.second_forward_svg,
                              height: 28,
                              width: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Progress Bar and Duration
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          // Progress Bar
                          Expanded(
                            child: VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              padding: EdgeInsets.zero,
                              colors: const VideoProgressColors(
                                playedColor: Color(0xff866ffa),
                                bufferedColor: Color(0xffbbbbbb),
                                backgroundColor: Color(0xffbbbbbb),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),
                          Text(
                            _formatDuration(_controller.value.duration - _controller.value.position),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(width: 10),
                          // Fullscreen Toggle Button
                          GestureDetector(
                            onTap: _openFullScreen,
                            child: const Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            // Error State
            if (!_isInitialized && !_isLoading)
              Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Failed to load video',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Fullscreen Video Player Page
class FullScreenVideoPlayer extends StatefulWidget {
  final String url;
  final Duration startPosition;
  final bool autoPlay;

  const FullScreenVideoPlayer({
    Key? key,
    required this.url,
    required this.startPosition,
    this.autoPlay = true,
  }) : super(key: key);

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setFullScreenMode();
    _initializeVideo();
  }

  void _setFullScreenMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void _initializeVideo() {
    setState(() {
      _isLoading = true;
    });

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));

    _controller.initialize().then((_) {
      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });

      // Seek to the position from the previous player
      _controller.seekTo(widget.startPosition);

      if (widget.autoPlay) {
        _controller.play();
        setState(() {
          _isPlaying = true;
        });
      }
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Video initialization error: $error');
    });

    _controller.addListener(() {
      if (_controller.value.isPlaying != _isPlaying) {
        setState(() {
          _isPlaying = _controller.value.isPlaying;
        });
      }
    });
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  void _seekBackward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - const Duration(seconds: 15);
    _controller.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
  }

  void _seekForward() {
    final currentPosition = _controller.value.position;
    final duration = _controller.value.duration;
    final newPosition = currentPosition + const Duration(seconds: 15);
    _controller.seekTo(newPosition > duration ? duration : newPosition);
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _exitFullScreen() {
    setState(() {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });
    Navigator.pop(context, _controller.value.position);

  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _exitFullScreen();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.center,
          children: [
            // Video Player
            if (_isInitialized)
              GestureDetector(
                onTap: _toggleControls,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            else
              Container(
                color: Colors.black,
                child: const Center(
                  child: Icon(
                    Icons.play_circle_fill_rounded,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
              ),

            // Loading Indicator
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),

            // Play Button Overlay (when paused)
            if (!_isPlaying && _isInitialized && !_isLoading)
              GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  width: 70,
                  height: 70,
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Color(0xfff52b59),
                    shape: BoxShape.circle,
                  ),
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: SvgPicture.asset(
                      Images.ic_play_svg,
                      height: 30,
                      width: 30,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

            // Video Controls (when playing)
            if (_isPlaying && _showControls && _isInitialized)
              Stack(
                children: [
                  // Center Controls (15s buttons + play/pause)
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 15s Backward
                        GestureDetector(
                          onTap: _seekBackward,
                          child: Container(
                            width: 60,
                            height: 60,
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              Images.second_reverse_svg,
                              height: 36,
                              width: 36,
                            ),
                          ),
                        ),

                        // Play/Pause Button
                        GestureDetector(
                          onTap: _togglePlayPause,
                          child: Container(
                            width: 60,
                            height: 60,
                            padding: const EdgeInsets.all(15),
                            decoration: const BoxDecoration(
                              color: Color(0xff6f6f70),
                              shape: BoxShape.circle,
                            ),
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: SvgPicture.asset(
                                Images.ic_pause_svg,
                                height: 30,
                                width: 30,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),

                        // 15s Forward
                        GestureDetector(
                          onTap: _seekForward,
                          child: Container(
                            width: 60,
                            height: 60,
                            padding: const EdgeInsets.all(12),
                            child: SvgPicture.asset(
                              Images.second_forward_svg,
                              height: 36,
                              width: 36,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Progress Bar and Duration
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Row(
                        children: [
                          // Progress Bar
                          Expanded(
                            child: VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              padding: EdgeInsets.zero,
                              colors: const VideoProgressColors(
                                playedColor: Color(0xff866ffa),
                                bufferedColor: Color(0xffbbbbbb),
                                backgroundColor: Color(0xffbbbbbb),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),
                          Text(
                            _formatDuration(_controller.value.duration - _controller.value.position),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(width: 12),
                          // Exit Fullscreen Button
                          GestureDetector(
                            onTap: _exitFullScreen,
                            child: const Icon(
                              Icons.fullscreen_exit,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            // Error State
            if (!_isInitialized && !_isLoading)
              Container(
                color: Colors.black,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Failed to load video',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
/// LATEST
///
///
///

// import 'package:cached_video_player_plus/cached_video_player_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:legacy_sync/core/images/images.dart';
// import 'package:video_player/video_player.dart';
//
// class CustomVideoPlayer extends StatefulWidget {
//   final String url;
//   final double? width;
//   final double? height;
//   final BorderRadius? borderRadius;
//   final bool autoPlay;
//   final bool showControls;
//   final Duration? startPosition;
//   final Duration? invalidateCacheIfOlderThan;
//
//   const CustomVideoPlayer({
//     Key? key,
//     required this.url,
//     this.width,
//     this.height,
//     this.borderRadius,
//     this.autoPlay = false,
//     this.showControls = true,
//     this.startPosition,
//     this.invalidateCacheIfOlderThan = const Duration(days: 7),
//   }) : super(key: key);
//
//   @override
//   State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
// }
//
// class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
//   late CachedVideoPlayerPlus _player;
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;
//   bool _isPlaying = false;
//   bool _showControls = true;
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//   }
//
//   void _initializeVideo() {
//     setState(() {
//       _isLoading = true;
//     });
//
//     _player = CachedVideoPlayerPlus.networkUrl(
//       Uri.parse(widget.url),
//       invalidateCacheIfOlderThan: widget.invalidateCacheIfOlderThan!,
//       viewType: VideoViewType.platformView,
//     );
//
//     _player.initialize().then((_) {
//       _controller = _player.controller;
//
//       setState(() {
//         _isInitialized = true;
//         _isLoading = false;
//       });
//
//       // Add listener after initialization
//       _controller.addListener(() {
//         if (_controller.value.isPlaying != _isPlaying) {
//           setState(() {
//             _isPlaying = _controller.value.isPlaying;
//           });
//         }
//       });
//
//       // Seek to start position if provided
//       if (widget.startPosition != null) {
//         _controller.seekTo(widget.startPosition!);
//       }
//
//       if (widget.autoPlay) {
//         _controller.play();
//         setState(() {
//           _isPlaying = true;
//         });
//       }
//     }).catchError((error) {
//       setState(() {
//         _isLoading = false;
//       });
//       debugPrint('Video initialization error: $error');
//     });
//   }
//
//   void _togglePlayPause() {
//     setState(() {
//       if (_controller.value.isPlaying) {
//         _controller.pause();
//         _isPlaying = false;
//       } else {
//         _controller.play();
//         _isPlaying = true;
//       }
//     });
//   }
//
//   void _seekBackward() {
//     final currentPosition = _controller.value.position;
//     final newPosition = currentPosition - const Duration(seconds: 15);
//     _controller.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
//   }
//
//   void _seekForward() {
//     final currentPosition = _controller.value.position;
//     final duration = _controller.value.duration;
//     final newPosition = currentPosition + const Duration(seconds: 15);
//     _controller.seekTo(newPosition > duration ? duration : newPosition);
//   }
//
//   void _toggleControls() {
//     setState(() {
//       _showControls = !_showControls;
//     });
//   }
//
//   void _openFullScreen() async {
//     // Pause the current video and get the position
//     final currentPosition = _controller.value.position;
//     final wasPlaying = _controller.value.isPlaying;
//     _controller.pause();
//
//     // Navigate to fullscreen page
//     final returnedPosition = await Navigator.push<Duration>(
//       context,
//       MaterialPageRoute(
//         builder: (context) => FullScreenVideoPlayer(
//           url: widget.url,
//           startPosition: currentPosition,
//           autoPlay: wasPlaying,
//           invalidateCacheIfOlderThan: widget.invalidateCacheIfOlderThan,
//         ),
//       ),
//     );
//
//     // When returning from fullscreen, seek to the position
//     if (returnedPosition != null && mounted) {
//       SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//       SystemChrome.setPreferredOrientations([
//         DeviceOrientation.portraitUp,
//         DeviceOrientation.portraitDown,
//       ]);
//       await _controller.seekTo(returnedPosition);
//       if (wasPlaying) {
//         _controller.play();
//       }
//       setState(() {});
//     }
//   }
//
//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//
//     if (duration.inHours > 0) {
//       return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//     } else {
//       return "$twoDigitMinutes:$twoDigitSeconds";
//     }
//   }
//
//   @override
//   void dispose() {
//     _player.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: widget.width ?? double.infinity,
//       height: widget.height ?? 200,
//       decoration: BoxDecoration(
//         borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
//         color: Colors.black,
//       ),
//       child: ClipRRect(
//         borderRadius: widget.borderRadius ?? BorderRadius.circular(16),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             // Video Player
//             if (_isInitialized)
//               GestureDetector(
//                 onTap: widget.showControls ? _toggleControls : null,
//                 child: SizedBox.expand(
//                   child: FittedBox(
//                     fit: BoxFit.cover,
//                     child: SizedBox(
//                       width: _controller.value.size.width,
//                       height: _controller.value.size.height,
//                       child: VideoPlayer(_controller),
//                     ),
//                   ),
//                 ),
//               )
//             else
//               Container(
//                 color: Colors.grey[300],
//                 child: const Center(
//                   child: Icon(
//                     Icons.play_circle_fill_rounded,
//                     size: 50,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//
//             // Loading Indicator
//             if (_isLoading)
//               Container(
//                 color: Colors.black54,
//                 child: const Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 ),
//               ),
//
//             // Play Button Overlay (when paused)
//             if (!_isPlaying && _isInitialized && !_isLoading)
//               GestureDetector(
//                 onTap: _togglePlayPause,
//                 child: Container(
//                   width: 50,
//                   height: 50,
//                   padding: const EdgeInsets.all(10),
//                   decoration: const BoxDecoration(
//                     color: Color(0xfff52b59),
//                     shape: BoxShape.circle,
//                   ),
//                   child: SizedBox(
//                     height: 20,
//                     width: 20,
//                     child: SvgPicture.asset(
//                       Images.ic_play_svg,
//                       height: 20,
//                       width: 20,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//               ),
//
//             // Video Controls (when playing)
//             if (_isPlaying && _showControls && widget.showControls && _isInitialized)
//               Stack(
//                 children: [
//                   // Center Controls (15s buttons + play/pause)
//                   Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         // 15s Backward
//                         GestureDetector(
//                           onTap: _seekBackward,
//                           child: Container(
//                             width: 50,
//                             height: 50,
//                             padding: const EdgeInsets.all(10),
//                             child: SvgPicture.asset(
//                               Images.second_reverse_svg,
//                               height: 28,
//                               width: 28,
//                             ),
//                           ),
//                         ),
//
//                         // Play/Pause Button
//                         GestureDetector(
//                           onTap: _togglePlayPause,
//                           child: Container(
//                             width: 50,
//                             height: 50,
//                             padding: const EdgeInsets.all(12),
//                             decoration: const BoxDecoration(
//                               color: Color(0xff6f6f70),
//                               shape: BoxShape.circle,
//                             ),
//                             child: SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: SvgPicture.asset(
//                                 Images.ic_pause_svg,
//                                 height: 20,
//                                 width: 20,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         // 15s Forward
//                         GestureDetector(
//                           onTap: _seekForward,
//                           child: Container(
//                             width: 50,
//                             height: 50,
//                             padding: const EdgeInsets.all(10),
//                             child: SvgPicture.asset(
//                               Images.second_forward_svg,
//                               height: 28,
//                               width: 28,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Bottom Progress Bar and Duration
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter,
//                           colors: [
//                             Colors.black.withOpacity(0.7),
//                             Colors.transparent,
//                           ],
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           // Progress Bar
//                           Expanded(
//                             child: VideoProgressIndicator(
//                               _controller,
//                               allowScrubbing: true,
//                               padding: EdgeInsets.zero,
//                               colors: const VideoProgressColors(
//                                 playedColor: Color(0xff866ffa),
//                                 bufferedColor: Color(0xffbbbbbb),
//                                 backgroundColor: Color(0xffbbbbbb),
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(width: 10),
//                           Text(
//                             _formatDuration(_controller.value.duration - _controller.value.position),
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//
//                           const SizedBox(width: 10),
//                           // Fullscreen Toggle Button
//                           GestureDetector(
//                             onTap: _openFullScreen,
//                             child: const Icon(
//                               Icons.fullscreen,
//                               color: Colors.white,
//                               size: 24,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//             // Error State
//             if (!_isInitialized && !_isLoading)
//               Container(
//                 color: Colors.grey[300],
//                 child: const Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         size: 50,
//                         color: Colors.grey,
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Failed to load video',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Fullscreen Video Player Page
// class FullScreenVideoPlayer extends StatefulWidget {
//   final String url;
//   final Duration startPosition;
//   final bool autoPlay;
//   final Duration? invalidateCacheIfOlderThan;
//
//   const FullScreenVideoPlayer({
//     Key? key,
//     required this.url,
//     required this.startPosition,
//     this.autoPlay = true,
//     this.invalidateCacheIfOlderThan = const Duration(days: 7),
//   }) : super(key: key);
//
//   @override
//   State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
// }
//
// class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
//   late CachedVideoPlayerPlus _player;
//   late VideoPlayerController _controller;
//   bool _isInitialized = false;
//   bool _isPlaying = false;
//   bool _showControls = true;
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _setFullScreenMode();
//     _initializeVideo();
//   }
//
//   void _setFullScreenMode() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//   }
//
//   void _initializeVideo() {
//     setState(() {
//       _isLoading = true;
//     });
//
//     _player = CachedVideoPlayerPlus.networkUrl(
//       Uri.parse(widget.url),
//       invalidateCacheIfOlderThan: widget.invalidateCacheIfOlderThan!,
//       viewType: VideoViewType.platformView,
//     );
//
//     _player.initialize().then((_) {
//       _controller = _player.controller;
//
//       setState(() {
//         _isInitialized = true;
//         _isLoading = false;
//       });
//
//       // Add listener after initialization
//       _controller.addListener(() {
//         if (_controller.value.isPlaying != _isPlaying) {
//           setState(() {
//             _isPlaying = _controller.value.isPlaying;
//           });
//         }
//       });
//
//       // Seek to the position from the previous player
//       _controller.seekTo(widget.startPosition);
//
//       if (widget.autoPlay) {
//         _controller.play();
//         setState(() {
//           _isPlaying = true;
//         });
//       }
//     }).catchError((error) {
//       setState(() {
//         _isLoading = false;
//       });
//       debugPrint('Video initialization error: $error');
//     });
//   }
//
//   void _togglePlayPause() {
//     setState(() {
//       if (_controller.value.isPlaying) {
//         _controller.pause();
//         _isPlaying = false;
//       } else {
//         _controller.play();
//         _isPlaying = true;
//       }
//     });
//   }
//
//   void _seekBackward() {
//     final currentPosition = _controller.value.position;
//     final newPosition = currentPosition - const Duration(seconds: 15);
//     _controller.seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
//   }
//
//   void _seekForward() {
//     final currentPosition = _controller.value.position;
//     final duration = _controller.value.duration;
//     final newPosition = currentPosition + const Duration(seconds: 15);
//     _controller.seekTo(newPosition > duration ? duration : newPosition);
//   }
//
//   void _toggleControls() {
//     setState(() {
//       _showControls = !_showControls;
//     });
//   }
//
//   void _exitFullScreen() {
//     // Return the current position to the previous player
//     Navigator.pop(context, _controller.value.position);
//   }
//
//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//
//     if (duration.inHours > 0) {
//       return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//     } else {
//       return "$twoDigitMinutes:$twoDigitSeconds";
//     }
//   }
//
//   @override
//   void dispose() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     _player.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         _exitFullScreen();
//         return false;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Stack(
//           alignment: Alignment.center,
//           children: [
//             // Video Player
//             if (_isInitialized)
//               GestureDetector(
//                 onTap: _toggleControls,
//                 child: Center(
//                   child: AspectRatio(
//                     aspectRatio: _controller.value.aspectRatio,
//                     child: VideoPlayer(_controller),
//                   ),
//                 ),
//               )
//             else
//               Container(
//                 color: Colors.black,
//                 child: const Center(
//                   child: Icon(
//                     Icons.play_circle_fill_rounded,
//                     size: 80,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//
//             // Loading Indicator
//             if (_isLoading)
//               Container(
//                 color: Colors.black54,
//                 child: const Center(
//                   child: CircularProgressIndicator(
//                     valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                   ),
//                 ),
//               ),
//
//             // Play Button Overlay (when paused)
//             if (!_isPlaying && _isInitialized && !_isLoading)
//               GestureDetector(
//                 onTap: _togglePlayPause,
//                 child: Container(
//                   width: 70,
//                   height: 70,
//                   padding: const EdgeInsets.all(15),
//                   decoration: const BoxDecoration(
//                     color: Color(0xfff52b59),
//                     shape: BoxShape.circle,
//                   ),
//                   child: SizedBox(
//                     height: 30,
//                     width: 30,
//                     child: SvgPicture.asset(
//                       Images.ic_play_svg,
//                       height: 30,
//                       width: 30,
//                       fit: BoxFit.contain,
//                     ),
//                   ),
//                 ),
//               ),
//
//             // Video Controls (when playing)
//             if (_isPlaying && _showControls && _isInitialized)
//               Stack(
//                 children: [
//                   // Center Controls (15s buttons + play/pause)
//                   Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         // 15s Backward
//                         GestureDetector(
//                           onTap: _seekBackward,
//                           child: Container(
//                             width: 60,
//                             height: 60,
//                             padding: const EdgeInsets.all(12),
//                             child: SvgPicture.asset(
//                               Images.second_reverse_svg,
//                               height: 36,
//                               width: 36,
//                             ),
//                           ),
//                         ),
//
//                         // Play/Pause Button
//                         GestureDetector(
//                           onTap: _togglePlayPause,
//                           child: Container(
//                             width: 60,
//                             height: 60,
//                             padding: const EdgeInsets.all(15),
//                             decoration: const BoxDecoration(
//                               color: Color(0xff6f6f70),
//                               shape: BoxShape.circle,
//                             ),
//                             child: SizedBox(
//                               height: 30,
//                               width: 30,
//                               child: SvgPicture.asset(
//                                 Images.ic_pause_svg,
//                                 height: 30,
//                                 width: 30,
//                                 fit: BoxFit.contain,
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         // 15s Forward
//                         GestureDetector(
//                           onTap: _seekForward,
//                           child: Container(
//                             width: 60,
//                             height: 60,
//                             padding: const EdgeInsets.all(12),
//                             child: SvgPicture.asset(
//                               Images.second_forward_svg,
//                               height: 36,
//                               width: 36,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   // Bottom Progress Bar and Duration
//                   Positioned(
//                     bottom: 0,
//                     left: 0,
//                     right: 0,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.bottomCenter,
//                           end: Alignment.topCenter,
//                           colors: [
//                             Colors.black.withOpacity(0.7),
//                             Colors.transparent,
//                           ],
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           // Progress Bar
//                           Expanded(
//                             child: VideoProgressIndicator(
//                               _controller,
//                               allowScrubbing: true,
//                               padding: EdgeInsets.zero,
//                               colors: const VideoProgressColors(
//                                 playedColor: Color(0xff866ffa),
//                                 bufferedColor: Color(0xffbbbbbb),
//                                 backgroundColor: Color(0xffbbbbbb),
//                               ),
//                             ),
//                           ),
//
//                           const SizedBox(width: 12),
//                           Text(
//                             _formatDuration(_controller.value.duration - _controller.value.position),
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//
//                           const SizedBox(width: 12),
//                           // Exit Fullscreen Button
//                           GestureDetector(
//                             onTap: _exitFullScreen,
//                             child: const Icon(
//                               Icons.fullscreen_exit,
//                               color: Colors.white,
//                               size: 28,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//             // Error State
//             if (!_isInitialized && !_isLoading)
//               Container(
//                 color: Colors.black,
//                 child: const Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.error_outline,
//                         size: 60,
//                         color: Colors.grey,
//                       ),
//                       SizedBox(height: 12),
//                       Text(
//                         'Failed to load video',
//                         style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }