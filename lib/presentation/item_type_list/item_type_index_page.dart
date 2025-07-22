import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/model/item_type.dart';
import 'package:flutter_pos/presentation/add_item_type/add_item_type.dart';
import 'package:flutter_pos/presentation/edit_item_type/edit_item_page.dart';
import 'package:flutter_pos/presentation/item_type_list/cubit/item_type_index_cubit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: BlocConsumer<ItemTypeIndexCubit, ItemTypeIndexState>(
        listener: (context, state) {
          if (state is ItemTypeIndexError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is ItemTypeIndexLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ItemTypeIndexError) {
            return Center(child: Text(state.message));
          }

          if (state is ItemTypeIndexLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: state.itemTypes.length,
              itemBuilder: (context, index) {
                final ItemType itemType = state.itemTypes[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          itemType.name ?? 'No Name',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          itemType.status ?? 'No Status',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditItemPage(item: itemType),
                                      ),
                                    );
                                    context.read<ItemTypeIndexCubit>().index();
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text("Konfirmasi"),
                                        content: const Text(
                                            "Apakah Anda yakin ingin menghapus item ini?"),
                                        actions: [
                                          TextButton(
                                            child: const Text("Batal"),
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                          ),
                                          TextButton(
                                            child: const Text("Hapus",
                                                style: TextStyle(
                                                    color: Colors.red)),
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      context
                                          .read<ItemTypeIndexCubit>()
                                          .deleteItem(itemType.id);
                                    }
                                  },
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Memesan: ${itemType.name}")),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                              ),
                              child: const Text("Pesan"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemTypePage()),
          );
          context.read<ItemTypeIndexCubit>().index();
        },
        icon: const Icon(Icons.add),
        label: const Text("Tambah Pesanan"),
      ),
    );
  }
}