import 'dart:typed_data';
import 'package:flutter/material.dart' ;
import 'package:google_fonts/google_fonts.dart';
import 'package:mined_2025/client/utils/theme/theme.dart';
import 'package:mined_2025/client/utils/widgets/audio_player.dart';
import 'package:mined_2025/main.dart';

class Person2 extends StatefulWidget {
  // final Uint8List audioFile;

  const Person2({super.key});

  @override
  State<Person2> createState() => _Person2State();
}

class _Person2State extends State<Person2> {
  double _sliderValue = 0.5; // Initi
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 5,
              color: AppColors.theme['podcastColor'],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0,top: 10,bottom: 10),
              child: Container(
                height: 100,
                width: mq.width*0.3,
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
                  borderRadius:BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),

                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                  child: Column(
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Text("Clay",style: GoogleFonts.poppins(fontWeight: FontWeight.bold),),

                          // AudioPlayerWidget(audioBytes: widget.audioFile),
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
          ],
        ),

      ],
    );
  }
}
