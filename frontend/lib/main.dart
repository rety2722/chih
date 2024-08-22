import 'package:flutter/material.dart';

import 'signin.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/': (context) => const LoginPage()},
    ));


