part of 'add_user_cubit.dart';

class AddUserState extends Equatable {
  const AddUserState({
    this.username = '',
    this.password = '',
    this.email = '',
    this.interestId,
    this.imageAsBase64,
    this.status = FormStatus.initial,
    this.error,
  });

  final String username;
  final String password;
  final String email;
  final String? interestId;
  final Uint8List? imageAsBase64;

  final FormStatus status;
  final String? error;

  AddUserState copyWith({
    String? username,
    String? password,
    String? email,
    String? interestId,
    Uint8List? imageAsBase64,
    FormStatus? status,
    String? error,
  }) {
    return AddUserState(
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      interestId: interestId ?? this.interestId,
      imageAsBase64: imageAsBase64 ?? this.imageAsBase64,
      status: status ?? FormStatus.initial,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [username, password, email, interestId, imageAsBase64, status, error];
}
