import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MovieVideo extends StatefulWidget {
  MovieVideo(this.videoId);
  final String videoId;

  @override
  _MovieVideoState createState() => _MovieVideoState();
}

class _MovieVideoState extends State<MovieVideo> {
  late YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: widget.videoId,
    params: const YoutubePlayerParams(
      autoPlay: true,
      showFullscreenButton: false,
      showVideoAnnotations: false,
    ),
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() {
        _controller = YoutubePlayerController(
          initialVideoId: widget.videoId, //widget.videoId,
          params: const YoutubePlayerParams(
            autoPlay: true,
            showFullscreenButton: false,
            showVideoAnnotations: false,
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16.0 / 9.0,
            child: ((_controller != null) && (widget.videoId != null))
                ? YoutubePlayerIFrame(
                    controller: _controller,
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 6.0,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
