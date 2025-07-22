import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/item_type.dart';
import 'package:flutter_pos/presentation/edit_item_type/cubit/edit_item_cubit.dart';

class EditItemPage extends StatefulWidget {
  final ItemType item;
  const EditItemPage({super.key, required this.item});

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController codeController;
  late TextEditingController nameController;
  String? selectedStatus;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController(text: widget.item.code);
    nameController = TextEditingController(text: widget.item.name);
    selectedStatus = widget.item.status;
  }

  @override
  void dispose() {
    codeController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Item")),
      body: BlocProvider(
        create: (context) => EditItemCubit(),
        child: BlocConsumer<EditItemCubit, EditItemState>(
          listener: (context, state) {
            if (state is EditItemSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.of(context).pop(); // kembali ke halaman sebelumnya
            } else if (state is EditItemError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: codeController,
                    decoration: const InputDecoration(labelText: "Code"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: const [
                      DropdownMenuItem(value: "Active", child: Text("Active")),
                      DropdownMenuItem(
                          value: "Non-Active", child: Text("Non-Active")),
                    ],
                    onChanged: (val) {
                      setState(() {
                        selectedStatus = val;
                      });
                    },
                    decoration: const InputDecoration(labelText: "Status"),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      final code = codeController.text.trim();
                      final name = nameController.text.trim();

                      if (code.isEmpty ||
                          name.isEmpty ||
                          selectedStatus == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Semua field harus diisi"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      context.read<EditItemCubit>().update(
                            widget.item.id,
                            code,
                            name,
                            selectedStatus!,
                          );
                    },
                    child: const Text("Update"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
