import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'Screens/chooesOperationScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red.shade100),
          useMaterial3: true,
        ),
        home: const ChooseOperationScreen(),
      ),
    );
  }
}
