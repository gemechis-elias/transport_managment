import 'package:equatable/equatable.dart';
import 'package:transport_app/models/report.dart';

abstract class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object> get props => [];
}

class UploadInitial extends UploadState {}

class UploadLoading extends UploadState {}

// class UserLoaded extends UserState {}

class UploadError extends UploadState {
  final String errorMessage;

  const UploadError(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class UploadedReportState extends UploadState {
  final ReportModel report;

  const UploadedReportState(this.report);

  @override
  List<Object> get props => [report];
}
