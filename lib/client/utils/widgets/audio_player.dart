import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  final Uint8List audioBytes;

  const AudioPlayerWidget({Key? key, required this.audioBytes}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  html.AudioElement? _audio;
  String? _url;
  bool _isPlaying = false;
  double _progress = 0.0;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _initializeAudio();
  }

  void _initializeAudio() {
    final blob = html.Blob([widget.audioBytes]);
    _url = html.Url.createObjectUrlFromBlob(blob);
    _audio = html.AudioElement()
      ..src = _url!
      ..onEnded.listen((event) {
        setState(() => _isPlaying = false);
      })
      ..onTimeUpdate.listen((event) {
        if (_audio != null && _audio!.duration > 0) {
          setState(() => _progress = _audio!.currentTime / _audio!.duration);
        }
      });
  }

  void _playAudio() {
    _audio?.play();
    setState(() => _isPlaying = true);
  }

  void _pauseAudio() {
    _audio?.pause();
    setState(() => _isPlaying = false);
  }

  void _stopAudio() {
    _audio?.pause();
    _audio?.currentTime = 0;
    setState(() {
      _isPlaying = false;
      _progress = 0.0;
    });
  }

  void _seekAudio(double value) {
    if (_audio != null && _audio!.duration > 0) {
      _audio!.currentTime = value * _audio!.duration;
      setState(() => _progress = value);
    }
  }

  void _setPlaybackSpeed(double speed) {
    if (_audio != null) {
      _audio!.playbackRate = speed;
      setState(() => _playbackSpeed = speed);
    }
  }

  @override
  void dispose() {
    _audio?.pause();
    if (_url != null) html.Url.revokeObjectUrl(_url!);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: _isPlaying ? _pauseAudio : _playAudio,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          onPressed: _stopAudio,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Slider(
            value: _progress,
            onChanged: _seekAudio,
            min: 0.0,
            max: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: DropdownButton<double>(
            value: _playbackSpeed,
            onChanged: (speed) {
              if (speed != null) _setPlaybackSpeed(speed);
            },
            items: [0.5, 1.0, 1.5, 2.0].map((speed) {
              return DropdownMenuItem(
                value: speed,
                child: Text("${speed}x"),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

