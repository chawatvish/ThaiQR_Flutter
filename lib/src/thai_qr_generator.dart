class ThaiQRGenerator {
  static const String ID_PAYLOAD_FORMAT = "00";
  static const String ID_POI_METHOD = "01";
  static const String ID_MERCHANT_INFORMATION_BOT = "29";
  static const String ID_TRANSACTION_CURRENCY = "53";
  static const String ID_TRANSACTION_AMOUNT = "54";
  static const String ID_COUNTRY_CODE = "58";
  static const String ID_CRC = "63";

  static const String PAYLOAD_FORMAT_EMV_QRCPS_MERCHANT_PRESENTED_MODE = "01";
  static const String POI_METHOD_STATIC = "11";
  static const String POI_METHOD_DYNAMIC = "12";
  static const String MERCHANT_INFORMATION_TEMPLATE_ID_GUID = "00";
  static const String BOT_ID_MERCHANT_PHONE_NUMBER = "01";
  static const String BOT_ID_MERCHANT_TAX_ID = "02";
  static const String BOT_ID_MERCHANT_EWALLET_ID = "03";
  static const String GUID_PROMPTPAY = "A000000677010111";
  static const String TRANSACTION_CURRENCY_THB = "764";
  static const String COUNTRY_CODE_TH = "TH";

  String generateCodeFromMobile(String number, String amount) {
    var sanitizedNumber = _sanitizeInput(number);
    var ppType = (sanitizedNumber.length >= 15)
        ? BOT_ID_MERCHANT_EWALLET_ID
        : (sanitizedNumber.length >= 13)
            ? BOT_ID_MERCHANT_TAX_ID
            : BOT_ID_MERCHANT_PHONE_NUMBER;

    var ppPayload = _generateTxt(
        ID_PAYLOAD_FORMAT, PAYLOAD_FORMAT_EMV_QRCPS_MERCHANT_PRESENTED_MODE);
    var ppAmountType = _generateTxt(ID_POI_METHOD,
        (amount.isNotEmpty) ? POI_METHOD_DYNAMIC : POI_METHOD_STATIC);
    var ppMerchantInfo = _generateTxt(
        ID_MERCHANT_INFORMATION_BOT,
        _generateTxt(MERCHANT_INFORMATION_TEMPLATE_ID_GUID, GUID_PROMPTPAY) +
            _generateTxt(ppType, _formatInput(sanitizedNumber)));
    var ppCountryCode = _generateTxt(ID_COUNTRY_CODE, COUNTRY_CODE_TH);
    var ppCurrency =
        _generateTxt(ID_TRANSACTION_CURRENCY, TRANSACTION_CURRENCY_THB);
    var ppDecimalValue = (_isPositiveDecimal(amount))
        ? _generateTxt(ID_TRANSACTION_AMOUNT, _formatAmount(amount))
        : "";
    var rawData =
        "$ppPayload$ppAmountType$ppMerchantInfo$ppCountryCode$ppCurrency$ppDecimalValue${ID_CRC}04";

    return rawData +
        (_crc16modem(rawData.codeUnits, 0xFFFF).toRadixString(16))
            .toUpperCase()
            .replaceAll("0x", "");
  }

  String _sanitizeInput(String input) {
    return input.replaceAll(RegExp(r"(\D.*?)"), "");
  }

  String _generateTxt(String id, String value) {
    return id + value.length.toString().padLeft(2, '0') + value;
  }

  String _formatInput(String id) {
    var numbers = _sanitizeInput(id);
    if (numbers.length >= 13) {
      return numbers;
    }
    return (numbers.replaceAll(RegExp(r"^0"), "66")).padLeft(13, '0');
  }

  String _formatAmount(String amount) {
    return double.parse(amount).toStringAsFixed(2);
  }

  bool _isPositiveDecimal(String n) {
    try {
      var a = double.parse(n);
      return a > 0;
    } catch (e) {
      return false;
    }
  }

  int _crc16modem(List<int> bytes, int crc) {
    for (var byte in bytes) {
      crc ^= byte << 8;
      for (var i = 0; i < 8; i++) {
        if ((crc & 0x8000) != 0) {
          crc = (crc << 1) ^ 0x1021;
        } else {
          crc = crc << 1;
        }
      }
    }
    return crc & 0xFFFF;
  }
}
