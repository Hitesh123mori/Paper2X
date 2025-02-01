import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mined_2025/client/utils/theme/theme.dart';

class HoverCard extends StatefulWidget {
  final String title;
  final Color color;
  final IconData icon;
  final int counter;
  final String text;


  HoverCard(this.title, this.color, this.icon, {this.counter = 0, required this.text});

  @override
  _HoverCardState createState() => _HoverCardState();
}

class _HoverCardState extends State<HoverCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: Transform.scale(
          scale: isHovered ? 1.0 : 1.0,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.all(20),
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                  color: isHovered ? widget.color.withOpacity(0.3) : AppColors.theme['backgroundColor'],
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: widget.color, width: 2),
                  boxShadow: isHovered
                      ? [
                    BoxShadow(
                      color: widget.color.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 3,
                    )
                  ]
                      : [],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [

                        Transform.scale(
                          scale: isHovered ? 1.2 : 1.0,
                          child: Icon(
                            widget.icon,
                            size: 20,
                            color: isHovered ? widget.color : Colors.black,
                          ),
                        ),
                        SizedBox(width: 10),
                        AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          style: TextStyle(
                            color: isHovered ? widget.color : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          child: Text(widget.title),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Flexible(
                      child: Text(
                        widget.text,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: isHovered ? widget.color : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: -10,
                right: -10,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: widget.color,
                  child: Text(
                    widget.counter.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
