import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'WeatherModel.dart';
import 'WeatherRepo.dart';

// Define WeatherEvent classes
abstract class WeatherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchWeather extends WeatherEvent {
  final String city;

  FetchWeather(this.city);

  @override
  List<Object?> get props => [city];
}

class ResetWeather extends WeatherEvent {}

// Define WeatherState classes
abstract class WeatherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WeatherIsNotSearched extends WeatherState {}

class WeatherIsLoading extends WeatherState {}

class WeatherIsLoaded extends WeatherState {
  final WeatherModel weather;

  WeatherIsLoaded(this.weather);

  @override
  List<Object?> get props => [weather];

  // Consider using a getter instead of a method
  WeatherModel get getWeather => weather;
}

class WeatherIsNotLoaded extends WeatherState {}

// WeatherBloc to handle events and states
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepo weatherRepo;

  WeatherBloc({required this.weatherRepo}) : super(WeatherIsNotSearched()) {
    on<FetchWeather>((event, emit) async {
      if (event is FetchWeather) {
        emit(WeatherIsLoading());
        try {
          WeatherModel weather = await weatherRepo.getWeather(event.city);
          emit(WeatherIsLoaded(weather));
        } catch (_) {
          emit(WeatherIsNotLoaded());
        }
      }
    });

    on<ResetWeather>((event, emit) {
      emit(WeatherIsNotSearched());
    });
  }
}