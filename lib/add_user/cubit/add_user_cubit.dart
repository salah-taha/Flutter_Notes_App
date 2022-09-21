import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:notes_repository/exceptions/exceptions.dart';
import 'package:notes_repository/notes_repository.dart';

part 'add_user_state.dart';

enum FormStatus { initial, submitting, success, failure }

class AddUserCubit extends Cubit<AddUserState> {
  AddUserCubit(this._dataSource) : super(const AddUserState());

  final NotesRepository _dataSource;

  void imagePicked(Uint8List imageAsBase64) {
    emit(state.copyWith(imageAsBase64: imageAsBase64));
  }

  void insertUser() async {
    try {
      emit(state.copyWith(status: FormStatus.submitting));
      await _dataSource.insertUser(User(
        id: '',
        username: state.username,
        password: state.password,
        email: state.email,
        interestId: state.interestId,
        imageAsBase64: state.imageAsBase64 != null
            ? base64Encode(state.imageAsBase64!)
            : null,
      ));

      emit(state.copyWith(status: FormStatus.success));
    } on InsertUserException catch (e) {
      emit(state.copyWith(status: FormStatus.failure, error: e.message));
    }
  }

  void usernameChanged(String username) {
    emit(state.copyWith(username: username));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password));
  }

  void emailChanged(String email) {
    emit(state.copyWith(email: email));
  }

  void interestChanged(String interest) {
    emit(state.copyWith(interestId: interest));
  }

  void clear() {
    emit(const AddUserState());
  }
}
