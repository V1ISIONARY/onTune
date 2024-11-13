// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ontune/backend/cubit/bnc_cubit.dart';
import 'package:ontune/backend/bloc/on_tune_bloc.dart';
import 'package:ontune/backend/services/repository.dart';

import 'resources/pockets/main_navigation.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => bnc()),
        BlocProvider(create: (context) => OnTuneBloc(OnTuneRepository())),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainWrapper(initialPage: 0),
      debugShowCheckedModeBanner: false, // Hides the debug banner
    );
  }
}