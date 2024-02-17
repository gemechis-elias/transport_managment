import 'package:equatable/equatable.dart';
import 'package:transport_app/models/report.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object> get props => [];
}

class UploadReportEvent extends UploadEvent {
  final ReportModel report;

  const UploadReportEvent({
    required this.report,
  });
}
