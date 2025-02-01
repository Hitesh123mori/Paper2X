import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mined_2025/client/providers/bucket_provider.dart';
import 'package:mined_2025/client/utils/theme/theme.dart';
import 'package:mined_2025/client/utils/widgets/custom_containers/custom_contaner.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  static const route = "/";
  static const fullRoute = "/";
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isRegisterHover = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<BucketsProvider>(builder: (context, bucketProvider, child) {
      return Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.theme['backgroundColor'],
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50.0, top: 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Make your",
                              style: GoogleFonts.poppins(
                                fontSize: 40,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Research 2X",
                              style: GoogleFonts.poppins(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              "Paper2x provides you tools ",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "that helps you to make research easy",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "you can",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 3.0),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    onEnter: (_) =>
                                        setState(() => _isRegisterHover = true),
                                    onExit: (_) => setState(
                                        () => _isRegisterHover = false),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            context.go('/register');
                                            bucketProvider.isLoginEnabled =
                                                false;
                                          },
                                          child: Text(
                                            "Register here!",
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: !_isRegisterHover
                                                  ? AppColors
                                                      .theme['deepPurpleColor']
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 2.0),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            height: 2,
                                            width:
                                                (_isRegisterHover) ? 80.0 : 0.0,
                                            decoration: BoxDecoration(
                                              color: AppColors
                                                  .theme['deepPurpleColor'],
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
                    Image.asset("assets/illustrations/landing_page.png"),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Features",
                      style: GoogleFonts.poppins(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        HoverCard("Podcast", Colors.green, Icons.chat,counter: 1, text: 'Generate a personal podcast from research paper',),
                        HoverCard("Summary", Colors.deepPurple, Icons.picture_as_pdf_outlined,counter: 2, text: 'Get an extract summary of your paper.',),
                        HoverCard("PPT", Colors.pinkAccent, Icons.video_camera_back_outlined,counter: 3, text: 'Presentation from your research paper.',),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ));
    });
  }
}
