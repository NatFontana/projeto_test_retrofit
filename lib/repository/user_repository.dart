import 'package:projeto_test_retrofit/models/user_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'user_repository.g.dart';

@RestApi(baseUrl: 'https://61bbe0dae943920017784fd5.mockapi.io/api/')
abstract class UserRepository {
  factory UserRepository(Dio dio, {required String baseUrl}) = _UserRepository;

  @GET('/users')
  Future<List<UserModel>> findAll();

  @GET('/users/{id}')
  Future<UserModel> findById(@Path('id') String id);

  @POST('/users')
  Future<void> save(@Body() UserModel user);
}
