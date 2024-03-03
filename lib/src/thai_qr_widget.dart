import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:thaiqr/thaiqr.dart';

class ThaiQRWidget extends StatelessWidget {
  final bool showHeader;
  final String mobileOrId;
  final String? amount;
  final generator = ThaiQRGenerator();
  ThaiQRWidget(
      {super.key,
      required this.mobileOrId,
      this.amount,
      this.showHeader = false});

  @override
  Widget build(BuildContext context) {
    var code = generator.generateCodeFromMobile(mobileOrId, amount ?? "");
    return Column(
      children: [
        if (showHeader)
          Image.asset(
            "assets/header.png",
            package: "thaiqr",
          ),
        QrImageView(
          padding: EdgeInsets.zero,
          data: code,
          embeddedImage: const AssetImage("assets/logo.png", package: "thaiqr"),
        )
      ],
    );
  }
}
