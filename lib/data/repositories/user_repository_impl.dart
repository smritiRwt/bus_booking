import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local_database_datasource.dart';
import '../datasources/preferences_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final LocalDatabaseDataSource localDataSource;
  final PreferencesDataSource prefsDataSource;

  UserRepositoryImpl(this.localDataSource, this.prefsDataSource);

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userId = prefsDataSource.getCurrentUserId();
    final user = await localDataSource.getUserById(userId);
    if (user != null) return user;

    // Fallback to defaults
    return UserEntity(
      id: userId,
      name: prefsDataSource.getUserName(),
      email: prefsDataSource.getUserEmail(),
      phone: prefsDataSource.getUserPhone(),
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    final model = UserModel.fromEntity(user);
    await localDataSource.updateUser(model);
    await prefsDataSource.setUserName(user.name);
    await prefsDataSource.setUserEmail(user.email);
    await prefsDataSource.setUserPhone(user.phone);
    return user;
  }
}
