import 'package:contacts_service/contacts_service.dart';

extension SMS on Contact {
  String firstPhoneNumberWithLabel(String label) => phones
      ?.firstWhere(
        (x) => x.label == label,
        orElse: () => null,
      )
      ?.value;

  String get bestPhoneNumberForSms =>
      firstPhoneNumberWithLabel("mobile") ??
      firstPhoneNumberWithLabel("main") ??
      firstPhoneNumberWithLabel("home");
}
