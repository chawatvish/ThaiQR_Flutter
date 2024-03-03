<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# Thai QR Code Generator

A Flutter package for generating Thai QR codes compliant with the PromptPay standard.

## Features

- Generate QR codes for PromptPay payments.
- Support for both static and dynamic QR codes.
- Built-in support for currency and country code formatting.
- Built-in widget for Thai QR can select show/hide header. 

## Getting Started

To use this package, add `thai_qr_code` as a dependency in your `pubspec.yaml` file.

```yaml
dependencies:
  flutter:
    sdk: flutter
  thai_qr_code: ^1.1.0
```

## Example
<table>
  <tr>
    <th>ShowHeader = false</th>
    <th>ShowHeader = true</th>
  </tr>
  <tr>
    <td><img src="https://github.com/chawatvish/ThaiQR_Flutter/assets/6084987/0cd21851-2564-4584-a93d-0ec6927d2fc3" width=200px height=434px></td>
    <td><img src="https://github.com/chawatvish/ThaiQR_Flutter/assets/6084987/18e833aa-8e49-4c61-bc69-ae257530e60c" width=200px height=434px></td>
  </tr>
</table>

# Outro
## Credits
Thanks to kittinan for his awesome [Thai QR for python](https://github.com/kittinan/thai-qr-payment) library. It's the reference of this library.

For author/contributor information, see the `AUTHORS` file.

## License

ThaiQR_Flutter is released under a BSD-3 license. See `LICENSE` for details.
