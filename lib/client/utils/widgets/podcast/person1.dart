import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mined_2025/client/utils/theme/theme.dart';
import 'package:mined_2025/main.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

import '../audio_player.dart';

class Person1 extends StatefulWidget {
  // final Uint8List audioFile;
  const Person1({super.key,});

  @override
  State<Person1> createState() => _Person1State();
}

class _Person1State extends State<Person1> {
  double _sliderValue = 0.5; // Initial value for the slider

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
              child: Container(
                height: 100,
                width: mq.width * 0.3,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 1,
                      spreadRadius: 0.1,
                      offset: Offset(0, 1),
                    ),
                  ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Katherine",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      // Dummy Slider added below
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Slider(
                              value: _sliderValue,
                              min: 0.0,
                              max: 1.0,
                              divisions: 10,
                              onChanged: (double value) {
                                setState(() {
                                  _sliderValue = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 100,
              width: 5,
              color: AppColors.theme['deepPurpleColor'],
            ),
          ],
        ),
      ],
    );
  }
}
