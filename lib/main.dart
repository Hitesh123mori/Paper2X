import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' ;
import 'package:flutter/services.dart';
import 'package:mined_2025/client/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'client/firebase_setup/firebase_options.dart';
import 'client/providers/bucket_provider.dart';
import 'client/router/router.dart';

late Size mq ;

void main()async {

  WidgetsFlutterBinding.ensureInitialized() ;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]).then((value){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky) ;
  });
  await _intializeFirebase() ;

  runApp(
      MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>BucketsProvider()),
        ChangeNotifierProvider(create: (context)=>WebUserProvider()),

      ],
      child: MyWebsite()));
}

class MyWebsite extends StatefulWidget {
  const MyWebsite({super.key});

  @override
  State<MyWebsite> createState() => _MyWebsiteState();
}

class _MyWebsiteState extends State<MyWebsite> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Paper2X',
      theme: ThemeData(
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

_intializeFirebase() async {

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

}