import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/presentation/add_item_type/cubit/add_item_cubit.dart';

class AddItemTypePage extends StatefulWidget {
  const AddItemTypePage({Key? key}) : super(key: key);

  @override
  State<AddItemTypePage> createState() => _AddItemTypePageState();
}

class _AddItemTypePageState extends State<AddItemTypePage> {
  final codeController = TextEditingController();
  String? selectedStatus;
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add item type")),
      body: BlocProvider(
        create: (context) => AddItemCubit(),
        child: BlocConsumer<AddItemCubit, AddItemState>(
          builder: (context, state) {
            return Column(
              children: [
                TextField(
                  controller: codeController,
                  decoration: InputDecoration(label: Text("Code")),
                ), // TextField
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(label: Text("Name")),
                ), // TextField
                DropdownButtonFormField(
                  items: [
                    {"value": "Active", "label": "Active"},
                    {"value": "Non-Active", "label": "Non-Active"},
                  ].map((e) {
                    return DropdownMenuItem(
                      child: Text(e['label']!),
                      value: e['value'],
                    ); // DropdownMenuItem
                  }).toList(),
                  onChanged: (String? val) {
                    setState(() {
                      selectedStatus = val!;
                    });
                  },
                ), // DropdownButtonFormField
                ElevatedButton(
                  onPressed: () {
                    final code = codeController.text;
                    final name = nameController.text;
                    debugPrint(code);
                    debugPrint(name);

                    if (code.isEmpty ||
                        name.isEmpty ||
                        selectedStatus == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Semua field harus diisi"),
                          backgroundColor: Colors.orange,
                        ), // SnackBar
                      );
                      return;
                    }

                    context.read<AddItemCubit>().submit(
                          code,
                          name,
                          selectedStatus!,
                        );
                  },
                  child: Text("Simpan"),
                ),
              ],
            );
          },
          listener: (context, state) {
            if (state is AddItemSuccess) {
              final snackBar = SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ); // SnackBar
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pop(context);
            }
            if (state is AddItemError) {
              final snackBar = SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ); // SnackBar
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
        ),
      ),
    );
  }
}
