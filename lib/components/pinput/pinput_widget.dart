import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/pinput/oncompleted/oncompleted.dart';
import 'package:note_arkadasim/components/pinput/theme/default_pin_theme.dart';
import 'package:note_arkadasim/components/pinput/theme/focused_pin_theme.dart';
import 'package:note_arkadasim/components/pinput/theme/submitted_pin_theme.dart';
import 'package:note_arkadasim/components/pinput/validator/validator.dart';
import 'package:pinput/pinput.dart';

Widget buildPinPut() {
  return Pinput(
    onCompleted: (pin) => onCompleted(pin),
    defaultPinTheme: defaultPinTheme,
    focusedPinTheme: focusedPinTheme,
    submittedPinTheme: submittedPinTheme,
    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
    validator: (s) {
      return pinPutValidator(s);
    },
    length: 6,
  );
}

