import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/enums/NA_button_types.dart';

IconData getIconDataFromNAButtonType(NAButtonTypes naBtnType) {
  switch (naBtnType) {
    case NAButtonTypes.ACCEPT:
      return Icons.check_circle_outline;
    case NAButtonTypes.REGISTER:
      return Icons.app_registration;
    case NAButtonTypes.LOGIN:
      return Icons.login;
    default:
      return Icons.help_outline;
  }
}
