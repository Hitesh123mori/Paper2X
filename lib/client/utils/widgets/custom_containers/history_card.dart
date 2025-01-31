import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mined_2025/client/utils/theme/theme.dart';

class HistoryCard extends StatefulWidget {
  final String data;
  final VoidCallback onTap ;
  final VoidCallback onRemove;
  const HistoryCard({super.key, required this.data, required this.onTap, required this.onRemove});

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) {
            setState(() {
              isHover = true;
            });
          },
          onExit: (_) {
            setState(() {
              isHover = false;
            });
          },
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0, right: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 5),
                    Flexible(
                    child: Text(
                      widget.data,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.poppins(fontSize: 13),
                     ),
                   ),
                    // if(isHover)
                    //   IconButton(
                    //     onPressed:widget.onRemove,
                    //     icon: Icon(
                    //       Icons.remove_circle,
                    //       size: 15,
                    //       color: Colors.red
                    //     ),
                    //   )
                  ],
                ),
              ),
            ),
          ),
        ),
        Divider(color: AppColors.theme['secondaryColor'].withOpacity(0.2),),
      ],
    );
  }
}


