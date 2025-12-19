import 'package:flutter/material.dart';
import 'package:note_arkadasim/components/NA_button/theme/box_decoration.dart';
import 'package:note_arkadasim/components/NA_button/theme/icon_types.dart';
import 'package:note_arkadasim/components/NA_button/theme/size_types.dart';
import 'package:note_arkadasim/components/enums/NA_button_types.dart';
import 'package:note_arkadasim/themes/theme.dart'; // Bu import'un dosyada mevcut olduğunu varsayıyoruz

Widget buildNAButton(
    ThemeData theme,
    bool isLoading,
    Future Function() handlerFunction,
    NAButtonTypes naButtonType,
    String title,
    Size mediaQuerySize, {
    Key? key,
  }) {
  Size naButtonSize = getSizeFromNAButtonType(naButtonType,mediaQuerySize);
  IconData iconData = getIconDataFromNAButtonType(naButtonType);

  return Container(
    key: key,
    height: naButtonSize.height,
    width: naButtonSize.width,
    decoration: naBoxDecoration,
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : handlerFunction,
        borderRadius: BorderRadius.circular(6),
        child: Center(
          child: isLoading
              ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: primaryFontFamily,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                iconData,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}