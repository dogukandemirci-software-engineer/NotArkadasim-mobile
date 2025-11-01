import 'package:flutter/material.dart';
import 'package:note_arkadasim/themes/theme.dart';
import '../../services/navigation_service/navigation_service.dart';

Widget buildLoginLink(
    ThemeData theme,
    String description,
    String linkText,
    String route,
    ) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        description,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: bodyTextColor,
        ),
      ),
      GestureDetector(
        onTap: () {
          NavigationService.instance.go(route);
          print(route);
        },
        child: Text(
          linkText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}