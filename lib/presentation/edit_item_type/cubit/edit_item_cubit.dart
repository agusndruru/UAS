import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pos/core/item_type_repository.dart';
import 'package:meta/meta.dart';

part 'edit_item_state.dart';

class EditItemCubit extends Cubit<EditItemState> {
  final itemTypeRepository = ItemTypeRepository();
  EditItemCubit() : super(EditItemInitial());

  void update(int id, String code, String name, String status) async {
    emit(EditItemLoading() as EditItemState);
    try {
      final params = {"name": name, "code": code, "status": status};
      final result = await itemTypeRepository.update(
        id,
        params,
      ); // pastikan endpoint ini ada
      emit(EditItemSuccess(message: result.message));
    } on DioError catch (e) {
      emit(EditItemError(message: "Masalah Koneksi"));
    } catch (e) {
      emit(EditItemError(message: e.toString()));
    }
  }
}
