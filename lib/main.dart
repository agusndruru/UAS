import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/presentation/item_type_list/cubit/item_type_index_cubit.dart';
import 'presentation/item_type_list/item_type_index_page.dart'; // arahkan ke file yg benar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Toko Sepatu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => ItemTypeIndexCubit(),
        child: const MyHomePage(title: 'Toko Sepatu'),
      ),
    );
  }
}
