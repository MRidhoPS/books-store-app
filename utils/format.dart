import 'package:intl/intl.dart';

class Format {

  String formatNumber(dynamic number, String? symbols) {
    double parsedNumber = 0;
    if (number is int) {
      parsedNumber = number.toDouble(); 
    } else if (number is String) {
      parsedNumber =
          double.tryParse(number) ?? 0; 
    }

    final formatCurrency = NumberFormat.currency(
      decimalDigits: 0,
      locale: 'id',
      symbol: (symbols == null || symbols.isEmpty) ? '' : 'Rp ',
    );

    return formatCurrency.format(parsedNumber);
  }


}
