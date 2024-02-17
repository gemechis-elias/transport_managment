import 'package:bloc/bloc.dart';
import 'package:transport_app/bloc/data_event.dart';
import 'package:transport_app/bloc/data_state.dart';
import 'package:transport_app/models/bus.dart';
import 'package:transport_app/services/fetch_data.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final DataService dataService;

  DataBloc(this.dataService) : super(DataLoadingState()) {
    on<GetAllDataEvent>((event, emit) async {
      print('Fetch bloc is called!!');
      emit(DataLoadingState());
      try {
        await dataService.fetchData();
        emit(DataLoadedState());
      } catch (e) {
        emit(DataErrorState("Failed to load data: $e"));
      }
    });

    on<LoadDataEvent>((event, emit) async {
      emit(DataLoadingState());
      try {
        await dataService.fetchData();
        emit(DataLoadedState());
      } catch (e) {
        emit(DataErrorState("Failed to load of the transport app: $e"));
      }
    });
  }
}
