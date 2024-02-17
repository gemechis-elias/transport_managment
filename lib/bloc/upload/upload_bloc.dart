
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_app/bloc/upload/upload_event.dart';
import 'package:transport_app/bloc/upload/upload_state.dart';
import 'package:transport_app/services/report_upload.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  UploadBloc(UploadState initialState) : super(UploadInitial()) {
    final uploadService = ReportService();

    on<UploadReportEvent>((event, emit) async {
      emit(UploadLoading());
      try {
        final response = await uploadService.upload(event.report);
        if (response != null) {
          emit(UploadedReportState(event.report));
        } else {
          emit(const UploadError('Error when registering user'));
        }
      } catch (e) {
        emit(const UploadError('Error logging in'));
      }
    });
  }
}
