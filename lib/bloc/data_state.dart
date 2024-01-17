import 'package:equatable/equatable.dart';
import 'package:transport_app/models/data.dart';

abstract class DataState extends Equatable {
  const DataState();

  @override
  List<Object> get props => [];
}

class DataInitialState extends DataState {}

class DataLoadingState extends DataState {}

class DataLoadedState extends DataState {}

class DataErrorState extends DataState {
  final String errorMessage;

  const DataErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
