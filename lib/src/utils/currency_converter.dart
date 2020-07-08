import 'package:easy_order/src/models/product/currency.dart';

class CurrencyConvertor {
  static String convert(Currency currency) {
    switch (currency) {
      case Currency.EURO:
        return "€";
        break;
      case Currency.DOLLAR:
        return "\$";
        break;
      case Currency.DIRHAM:
        return "MAD";
        break;
      case Currency.LIVRE:
        return "£";
        break;
      default:
        return "";
    }
  }

  static Currency toCurrency(String currency) {
    switch (currency) {
      case "€":
        return Currency.EURO;
        break;
      case "\$":
        return Currency.DOLLAR;
        break;
      case "MAD":
        return Currency.DIRHAM;
        break;
      case "£":
        return Currency.LIVRE;
        break;
      default:
        return null;
    }
  }

  static bool checkIfValidCurrency(String currency) {
    return currency == "€" ||
        currency == "\$" ||
        currency == "MAD" ||
        currency == "£";
  }

  static List<String> allValuesInString() {
    return List<String>.from([
      '€',
      '\$',
      'MAD',
      '£',
    ]);
  }

  static List<Currency> allValuesInCurrency() {
    return List<Currency>.from([
      Currency.EURO,
      Currency.DOLLAR,
      Currency.DIRHAM,
      Currency.LIVRE,
    ]);
  }
}
