import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gupshup/app/controllers/auth_controller.dart';
import 'app/utils/error_screen.dart';
import 'app/utils/loading_screen.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();

  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  //final Future<FirebaseApp> _initializtion = Firebase.initializeApp();

  final authC = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(
        Duration(
          seconds: 3,
        ),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Obx(() => GetMaterialApp(
                debugShowCheckedModeBanner: false,
                title: "Gup Shup",
                initialRoute: authC.isSkipIntro.isTrue
                    ? authC.isAuth.isTrue
                        ? Routes.HOME
                        : Routes.LOGIN
                    : Routes.INTRODUCTION,
                getPages: AppPages.routes,
              ));
        }
        return FutureBuilder(
            future: authC.firstInitialized(),
            builder: (context, snapshot) {
              return SplashScreen();
            });
      },
    );

    // return FutureBuilder(
    //     future: _initializtion,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) {
    //         return ErrorScreen();
    //       }
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         return FutureBuilder(
    //           future: Future.delayed(
    //             Duration(
    //               seconds: 3,
    //             ),
    //           ),
    //           builder: (context, snapshot) {
    //             if (snapshot.connectionState == ConnectionState.done) {
    //               return Obx(() => GetMaterialApp(
    //                     debugShowCheckedModeBanner: false,
    //                     title: "Gup Shup",
    //                     initialRoute: authC.isSkipIntro.isTrue
    //                         ? authC.isAuth.isTrue
    //                             ? Routes.HOME
    //                             : Routes.LOGIN
    //                         : Routes.INTRODUCTION,
    //                     getPages: AppPages.routes,
    //                   ));
    //             }
    //             return FutureBuilder(
    //                 future: authC.firstInitialized(),
    //                 builder: (context, snapshot) {
    //                   return SplashScreen();
    //                 });
    //           },
    //         );
    //       }

    //       return LoadingScreen();
    //     });
  }
}
