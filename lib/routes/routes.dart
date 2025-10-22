import 'package:flutter/material.dart';
import 'package:note_arkadasim/pages/add_note/add_note_page.dart';
import 'package:note_arkadasim/pages/auth/change_password/change_password_page.dart';
import 'package:note_arkadasim/pages/auth/login/login_page.dart';
import '../pages/auth/email/email_page.dart';
import '../pages/auth/register/register_page.dart';
import '../pages/home/home_page.dart';
import '../pages/notes/notes_page.dart';
import '../pages/profile_menu/page_items/app_settings/account_settings/account_settings_page.dart';
import '../pages/profile_menu/page_items/app_settings/account_settings/personal_information/personal_information_page.dart';
import '../pages/profile_menu/page_items/app_settings/account_settings/privacy_settings/privacy_settings_page.dart';
import '../pages/profile_menu/page_items/app_settings/app_settings_page.dart';
import '../pages/profile_menu/page_items/app_settings/language_settings/language_settings_page.dart';
import '../pages/profile_menu/page_items/app_settings/notification_settings/notificiation_settings_page.dart';
import '../pages/profile_menu/page_items/app_settings/theme_settings/theme_settings_page.dart';
import '../pages/profile_menu/page_items/comments/comments_page.dart';
import '../pages/profile_menu/page_items/liked_notes/liked_notes_page.dart';
import '../pages/profile_menu/page_items/my_notes/my_notes_page.dart';
import '../pages/profile_menu/page_items/scores/scores_page.dart';
import '../pages/profile_menu/profile_menu_page/profile_menu_page.dart';

class AppRoutes {
  static const String home = '/home';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String email = '/email';
  static const String changePassword = '/change-password';
  static const String notes = '/notes';
  static const String addNote = '/add-note';
  static const String likedNotes = '/liked-notes';
  static const String comments = '/comments';
  static const String scores = '/scores';
  static const String myNotes = '/my-notes';
  static const String appSettings = '/app-settings';
  static const String accountSettings = '/app-settings/account-settings';
  static const String personalInformation = '/app-settings/account-settings/personal-information';
  static const String privacySettings = '/app-settings/account-settings/privacy-settings';
  static const String languageSettings = '/app-settings/language-settings';
  static const String notificationSettings = '/app-settings/notification-settings';
  static const String themeSettings = '/app-settings/theme-settings';


  // Route haritası
  static Map<String, WidgetBuilder> get routes => {
     register: (context) => const RegisterPage(),
     home: (context) => const HomePage(),
     login: (context) => const LoginPage(),
     email: (context) => const EmailPage(),
     notes: (context) => const NotesPage(),
     addNote: (context) => const AddNotePage(),
     changePassword: (context) => const ChangePasswordPage(),
     likedNotes: (context) => const LikedNotesPage(),
     comments: (context) => const CommentsPage(),
     scores: (context) => const ScoresPage(),
     myNotes: (context) => const MyNotesPage(),
     appSettings: (context) => const AppSettingsPage(),
     accountSettings: (context) => const AccountSettingsPage(),
     personalInformation: (context) => const PersonalInformationPage(),
     privacySettings: (context) => const PrivacySettingsPage(),
     languageSettings: (context) => const LanguageSettingsPage(),
     notificationSettings: (context) => const NotificiationSettingsPage(),
     themeSettings: (context) => const ThemeSettingsPage(),
     profile: (context) => const ProfileMenuPage(),
     settings: (context) => const ProfileMenuPage(),
  };


}

