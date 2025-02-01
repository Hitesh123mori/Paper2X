import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mined_2025/client/helper_functions/toasts.dart';
import 'package:mined_2025/client/utils/theme/theme.dart';
import 'package:mined_2025/client/utils/widgets/podcast/person1.dart';
import 'package:mined_2025/client/utils/widgets/podcast/person2.dart';
import 'dart:convert';  // For base64 decoding
import 'dart:typed_data'; // For Uint8List

class PodCastPart extends StatefulWidget {
  final Map<String, dynamic> extractedFiles;

  const PodCastPart({super.key, required this.extractedFiles});

  @override
  State<PodCastPart> createState() => _PodCastPartState();
}

class _PodCastPartState extends State<PodCastPart> {
  int index = 0;
  final List<String> playedFiles = [];

  // Convert String (base64 or file path) to Uint8List
  Uint8List _convertToUint8List(dynamic data) {
    if (data is String) {
      // If it's a base64 string
      if (data.startsWith('data:audio/')) {
        return base64Decode(data.split(',')[1]);
      }
      // If it's a file path or URL, you need to load the file bytes (this part may vary based on how you load the data)
      return Uint8List(0); // Example, replace with actual file loading logic
    }
    return data as Uint8List; // Already Uint8List
  }

  void _nextAudio() {
    if (index < widget.extractedFiles.length) {
      setState(() {
        String currentFileName = widget.extractedFiles.keys.elementAt(index);
        var currentFile = widget.extractedFiles[currentFileName]!;
        Uint8List currentFileBytes = _convertToUint8List(currentFile);

        playedFiles.add(currentFileName);
        index++;
      });
    } else {
      WebToasts.showToastification(
        "Error",
        "No audio left",
        Icon(
          Icons.error_outline_outlined,
          color: Colors.red,
        ),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount:4,
            itemBuilder: (context, i) {
              // String currentFileName = playedFiles[i];
              //
              // var currentFile = widget.extractedFiles[currentFileName]!;
              // Uint8List currentFileBytes = currentFile;

              return (i % 2 == 0
                  ? Person1()
                  : Person2()
              );
              //
              // return currentFileBytes.isNotEmpty
              //     ? (i % 2 == 0
              //     ? Person1(audioFile: currentFileBytes)
              //     : Person2(audioFile: currentFileBytes))
              //     : const SizedBox.shrink();
            },
          ),
        ),
        if (widget.extractedFiles.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: _nextAudio,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  height: 30,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.theme['deepPurpleColor'],
                  ),
                  child: Center(
                    child: Text(
                      "Play Next",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

