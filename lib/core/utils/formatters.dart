import 'package:intl/intl.dart';
import 'package:emun/core/constants/app_constants.dart';

String formatPrice(double price, {String currency = AppConstants.currency}) {
  final formatter = NumberFormat.currency(symbol: '', decimalDigits: 0);
  return '${formatter.format(price)} $currency';
}

String formatRelativeTime(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 60) {
    return '${diff.inMinutes}m ago';
  }
  if (diff.inHours < 24) {
    return '${diff.inHours}h ago';
  }
  if (diff.inDays < 7) {
    return '${diff.inDays}d ago';
  }
  return DateFormat('MMM d').format(date);
}
