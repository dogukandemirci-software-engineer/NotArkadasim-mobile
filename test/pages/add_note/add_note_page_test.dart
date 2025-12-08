import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:note_arkadasim/pages/add_note/add_note_page.dart';
import 'package:note_arkadasim/services/api_services/note_api/note_api_service.dart';
import 'package:note_arkadasim/services/api_services/note_api/note_upsert_service.dart';
import 'package:provider/provider.dart';
import 'package:note_arkadasim/providers/photo_provider.dart';
import 'add_note_page_test.mocks.dart';
import 'package:note_arkadasim/models/note_upsert_data.dart';
import 'package:note_arkadasim/models/lecture.dart';
import 'package:note_arkadasim/models/language.dart';
import 'package:note_arkadasim/models/tag.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

@GenerateMocks([NoteUpsertService, NoteApiService, FilePicker, PhotoProvider])
void main() {
  late MockNoteUpsertService mockNoteUpsertService;
  late MockNoteApiService mockNoteApiService;
  late MockFilePicker mockFilePicker;
  late MockPhotoProvider mockPhotoProvider;

  setUp(() {
    mockNoteUpsertService = MockNoteUpsertService();
    mockNoteApiService = MockNoteApiService();
    mockFilePicker = MockFilePicker();
    mockPhotoProvider = MockPhotoProvider();
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PhotoProvider>(create: (_) => mockPhotoProvider),
      ],
      child: MaterialApp(
        home: AddNotePage(
          noteUpsertService: mockNoteUpsertService,
          noteApiService: mockNoteApiService,
        ),
      ),
    );
  }

  group('AddNotePage Widget Tests', () {
    final noteUpsertData = NoteUpsertData(
      lectures: [Lecture(id: '1', name: 'Math')],
      languages: [Language(id: '1', name: 'English')],
      tags: [Tag(id: '1', name: 'test')],
    );

    testWidgets('should show loading indicator when opening the page',
        (WidgetTester tester) async {
      when(mockNoteUpsertService.getNoteUpsertData()).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 1));
        return noteUpsertData;
      });

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpAndSettle();
    });
  });
}
