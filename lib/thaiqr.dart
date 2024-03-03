class ThaiQRGenerator {
  static const ID_PAYLOAD_FORMAT = "00";
  static const ID_POI_METHOD = "01";
  static const ID_MERCHANT_INFORMATION_BOT = "29";
  static const ID_TRANSACTION_CURRENCY = "53";
  static const ID_TRANSACTION_AMOUNT = "54";
  static const ID_COUNTRY_CODE = "58";
  static const ID_CRC = "63";

  static const PAYLOAD_FORMAT_EMV_QRCPS_MERCHANT_PRESENTED_MODE = "01";
  static const POI_METHOD_STATIC = "11";
  static const POI_METHOD_DYNAMIC = "12";
  static const MERCHANT_INFORMATION_TEMPLATE_ID_GUID = "00";
  static const BOT_ID_MERCHANT_PHONE_NUMBER = "01";
  static const BOT_ID_MERCHANT_TAX_ID = "02";
  static const BOT_ID_MERCHANT_EWALLET_ID = "03";
  static const GUID_PROMPTPAY = "A000000677010111";
  static const TRANSACTION_CURRENCY_THB = "764";
  static const COUNTRY_CODE_TH = "TH";

  // String generate(String code) {
  //   var qrCode = QrCode(1, QrErrorCorrectLevel.L);
  //   qrCode.addData(code);
  //   var image = QrImage(qrCode);
//
//   var qrImg = img.Image(qr.moduleCount, qr.moduleCount);
//   for (var y = 0; y < qr.moduleCount; y++) {
//     for (var x = 0; x < qr.moduleCount; x++) {
//       if (qr.isDark(y, x)) {
//         qrImg.setPixel(x, y, 0xFF000000);
//       } else {
//         qrImg.setPixel(x, y, 0xFFFFFFFF);
//       }
//     }
//   }
//
//   var logoImg =
//       img.decodeImage(File("${SCRIPT_PATH}assets/logo.png").readAsBytesSync());
//   var templateImg = img
//       .decodeImage(File("${SCRIPT_PATH}assets/template.png").readAsBytesSync());
//
//   var qrImageArea = qrImg.width * qrImg.height;
//   var logoImgArea = logoImg.width * logoImg.height;
//   var pctLogoArea = (logoImgArea / qrImageArea).ceil();
//
//   if (pctLogoArea > 0.05) {
//     var ratio = (qrImageArea * 0.05) / logoImgArea;
//     logoImg = img.copyResize(logoImg,
//         width: (logoImg.width * ratio).round(),
//         height: (logoImg.height * ratio).round());
//   }
//
//   var pos = ((qrImg.width - logoImg.width) ~/ 2);
//   qrImg = img.drawOn(
//     qrImg,
//     logoImg,
//     dstX: pos,
//     dstY: pos,
//   );
//
//   qrImg = img.copyResize(qrImg, width: 750, height: 750);
//   pos = img.Point(125, 407);
//   templateImg = img.copyInto(templateImg, qrImg, dstX: pos.x, dstY: pos.y);
//
//   var bytes = img.encodePng(templateImg);
//   return base64.encode(bytes);
// }

// void save(String code, String path) {
//   var imgStr = generate(code);
//   File(path).writeAsBytesSync(base64.decode(imgStr));
// }

// String toBase64(String code, {bool includeUri = false}) {
//   var imgStr = generate(code);
//   if (includeUri) {
//     return "data:image/png;base64,$imgStr";
//   }
//   return imgStr;

  String generateCodeFromMobile(String number, String amount) {
    var sanitizedNumber = sanitizeInput(number);
    var ppType = (sanitizedNumber.length >= 15)
        ? BOT_ID_MERCHANT_EWALLET_ID
        : (sanitizedNumber.length >= 13)
            ? BOT_ID_MERCHANT_TAX_ID
            : BOT_ID_MERCHANT_PHONE_NUMBER;

    var ppPayload = generateTxt(
        ID_PAYLOAD_FORMAT, PAYLOAD_FORMAT_EMV_QRCPS_MERCHANT_PRESENTED_MODE);
    var ppAmountType = generateTxt(ID_POI_METHOD,
        (amount.isNotEmpty) ? POI_METHOD_DYNAMIC : POI_METHOD_STATIC);
    var ppMerchantInfo = generateTxt(
        ID_MERCHANT_INFORMATION_BOT,
        generateTxt(MERCHANT_INFORMATION_TEMPLATE_ID_GUID, GUID_PROMPTPAY) +
            generateTxt(ppType, formatInput(sanitizedNumber)));
    var ppCountryCode = generateTxt(ID_COUNTRY_CODE, COUNTRY_CODE_TH);
    var ppCurrency =
        generateTxt(ID_TRANSACTION_CURRENCY, TRANSACTION_CURRENCY_THB);
    var ppDecimalValue = (isPositiveDecimal(amount))
        ? generateTxt(ID_TRANSACTION_AMOUNT, formatAmount(amount))
        : "";
    var rawData =
        "$ppPayload$ppAmountType$ppMerchantInfo$ppCountryCode$ppCurrency$ppDecimalValue${ID_CRC}04";

    return rawData +
        (crc16modem(rawData.codeUnits, 0xFFFF).toRadixString(16))
            .toUpperCase()
            .replaceAll("0x", "");
  }

  String sanitizeInput(String input) {
    return input.replaceAll(RegExp(r"(\D.*?)"), "");
  }

  String generateTxt(String id, String value) {
    return id + value.length.toString().padLeft(2, '0') + value;
  }

  String formatInput(String id) {
    var numbers = sanitizeInput(id);
    if (numbers.length >= 13) {
      return numbers;
    }
    return (numbers.replaceAll(RegExp(r"^0"), "66")).padLeft(13, '0');
  }

  String formatAmount(String amount) {
    return double.parse(amount).toStringAsFixed(2);
  }

  bool isPositiveDecimal(String n) {
    try {
      var a = double.parse(n);
      return a > 0;
    } catch (e) {
      return false;
    }
  }

  int crc16modem(List<int> bytes, int crc) {
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
