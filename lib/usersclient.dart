import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

part 'usersclient.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com/")
abstract class UserClient {
  factory UserClient(Dio dio, {String baseUrl}) = _UserClient;

  @GET("/users")
  Future<List<User>> getUsers();
}

@JsonSerializable()
class User {
  int? id;
  String? name;
  String? email;

  User({
    this.id,
    this.name,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
