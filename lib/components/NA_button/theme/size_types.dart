import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/enums/NA_button_types.dart';

Size getSizeFromNAButtonType(NAButtonTypes nabtnType, Size mediaQuerySize) {
  switch (nabtnType) {
    case NAButtonTypes.ACCEPT:
      return Size(mediaQuerySize.width * 0.4, 56);
    case NAButtonTypes.REGISTER:
      return Size(mediaQuerySize.width * 0.8, 56);
    case NAButtonTypes.LOGIN:
      return Size(mediaQuerySize.width * 0.3, 56);
    default:
      return Size(mediaQuerySize.width * 0.4, 56);
  }
}
