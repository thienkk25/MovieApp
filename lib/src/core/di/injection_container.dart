import 'package:get_it/get_it.dart';
import '../global/settings_cubit.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/user_firestore_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_usecases.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/movie/data/datasources/movie_firestore_data_source.dart';
import '../../features/movie/data/datasources/movie_remote_data_source.dart';
import '../../features/movie/data/repositories/movie_repository_impl.dart';
import '../../features/movie/domain/repositories/movie_repository.dart';
import '../../features/movie/domain/usecases/movie_usecases.dart';
import '../../features/movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import '../../features/movie/presentation/bloc/movie_favorite/movie_favorite_bloc.dart';
import '../../features/movie/presentation/bloc/movie_home/movie_home_bloc.dart';
import '../../features/movie/presentation/bloc/movie_search/movie_search_bloc.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // Global Cubits / Blocs
  sl.registerLazySingleton(() => SettingsCubit());

  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
  sl.registerLazySingleton<UserFirestoreDataSource>(() => UserFirestoreDataSourceImpl());
  sl.registerLazySingleton<MovieRemoteDataSource>(() => MovieRemoteDataSourceImpl());
  sl.registerLazySingleton<MovieFirestoreDataSource>(() => MovieFirestoreDataSourceImpl());

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        authRemoteDataSource: sl(),
        userFirestoreDataSource: sl(),
      ));
  sl.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(
        remoteDataSource: sl(),
        firestoreDataSource: sl(),
      ));

  // UseCases - Auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithGoogleUseCase(sl()));
  sl.registerLazySingleton(() => SignInWithFacebookUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthStatusUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // UseCases - Movie
  sl.registerLazySingleton(() => GetNewlyUpdatedMoviesUseCase(sl()));
  sl.registerLazySingleton(() => GetMovieDetailUseCase(sl()));
  sl.registerLazySingleton(() => SearchMoviesUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoryMoviesUseCase(sl()));
  sl.registerLazySingleton(() => GetFavoriteMoviesUseCase(sl()));
  sl.registerLazySingleton(() => AddFavoriteMovieUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFavoriteMovieUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        registerUseCase: sl(),
        forgotPasswordUseCase: sl(),
        signOutUseCase: sl(),
        signInWithGoogleUseCase: sl(),
        signInWithFacebookUseCase: sl(),
        checkAuthStatusUseCase: sl(),
        getCurrentUserUseCase: sl(),
      ));

  sl.registerFactory(() => MovieHomeBloc(
        getNewlyUpdatedMoviesUseCase: sl(),
        getCategoryMoviesUseCase: sl(),
      ));

  sl.registerFactory(() => MovieDetailBloc(
        getMovieDetailUseCase: sl(),
        getFavoriteMoviesUseCase: sl(),
        addFavoriteMovieUseCase: sl(),
        removeFavoriteMovieUseCase: sl(),
        getCategoryMoviesUseCase: sl(),
      ));

  sl.registerFactory(() => MovieSearchBloc(
        searchMoviesUseCase: sl(),
      ));

  sl.registerFactory(() => MovieFavoriteBloc(
        getFavoriteMoviesUseCase: sl(),
        removeFavoriteMovieUseCase: sl(),
      ));
}
