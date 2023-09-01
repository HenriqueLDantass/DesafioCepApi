import 'package:desafiodiocep/screen/cep_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'API/cep_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Desafio Cep',
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<ViaCepService>(create: (_) => ViaCepService()),
        ],
        child: const MyHomePage(),
      ),
    );
  }
}
