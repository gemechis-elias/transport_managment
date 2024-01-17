import 'package:equatable/equatable.dart';


abstract class DataEvent extends Equatable {
  const DataEvent();

  @override
  List<Object> get props => [];
}

class GetAllDataEvent extends DataEvent {}

class LoadDataEvent extends DataEvent {}


