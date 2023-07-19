import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/movie/events.dart';
import 'package:movie_app/bloc/movie/states.dart';
import 'package:movie_app/global_keys.dart';
import 'package:movie_app/providers/common.dart';
import 'package:movie_app/services/api/index.dart';
import 'package:provider/provider.dart';

import '../../model/movie/index.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieInitial()) {
    on<MovieGetAll>((event, emit) async {
      if (Provider.of<CommonProvider>(GlobalKeys.navigatorKey.currentContext!,
              listen: false)
          .movies
          .isEmpty) {
        emit(MovieLoading());
        try {
          final api = ApiService();
          final res = await api.getRequest('/64911c08b89b1e2299b1e1b8');
          List<MovieModel> data = MovieModel.fromList(res.data['record']);
          Provider.of<CommonProvider>(GlobalKeys.navigatorKey.currentContext!,
                  listen: false)
              .setMovies(data);
          emit(MovieSuccess());
        } catch (ex) {
          print(ex);
          emit(MovieFailure(ex.toString()));
        }
      }
    });
    on<MovieGetInfo>((event, emit) async {
      emit(MovieLoading());
      try {
        final api = ApiService();
        final res = await api.getRequest('/649133738e4aa6225eb138c4', true);
        MovieModel data = MovieModel.fromJson(res.data['record']);

        emit(MovieSuccessDetail(data));
      } catch (ex) {
        print(ex);
        emit(MovieFailure(ex.toString()));
      }
    });
  }
}
