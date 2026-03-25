import 'package:equatable/equatable.dart';

class ModerationReport extends Equatable {
  final String id;
  final String listingTitle;
  final String reason;
  final DateTime reportedAt;
  final String status;

  const ModerationReport({
    required this.id,
    required this.listingTitle,
    required this.reason,
    required this.reportedAt,
    required this.status,
  });

  @override
  List<Object?> get props => [id, listingTitle, reason, reportedAt, status];
}
