import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  const UserModel({
    required this.id,
    this.name,
    this.email,
  });
  final String id;
  final String? email;
  final String? name;

  static const empty = UserModel(id: '');

  bool get isEmpty => this == UserModel.empty;
  bool get isNotEmpty => this != UserModel.empty;

  @override
  List<Object?> get props => [email, id, name];
}

Map<String, dynamic> toJson(UserModel user) => <String, dynamic>{
      'uid': user.id,
      'email': user.email,
    };
