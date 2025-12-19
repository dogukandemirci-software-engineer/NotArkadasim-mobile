import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_arkadasim/models/global_api_handler_result.dart';
import 'package:note_arkadasim/models/note_entity.dart';
import 'package:note_arkadasim/models/note_paging_request.dart';
import 'package:note_arkadasim/models/paging_request.dart';
import 'package:note_arkadasim/services/api_services/note_api/note_api_service.dart';
import 'package:note_arkadasim/services/api_services/baseapi/base_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import '../../models/Note.dart';
import '../../models/global_api_handler_result_status_codes.dart';
import 'components/note_card.dart'; // Bu component'in sizde olduğunu varsayıyorum
import 'note_view/note_view_page.dart';
import 'package:showcaseview/showcaseview.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      globalFloatingActionWidget: (showcaseContext) => FloatingActionWidget(
        bottom: 24,
        right: 24,
        child: ElevatedButton(
          onPressed: () => ShowCaseWidget.of(showcaseContext).dismiss(),
          child: const Text("Geç"),
        ),
      ),
      builder: (context) => const _NotesPageContent(),
    );
  }
}

class _NotesPageContent extends StatefulWidget {
  const _NotesPageContent();

  @override
  State<_NotesPageContent> createState() => _NotesPageContentState();
}

class _NotesPageContentState extends State<_NotesPageContent>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;
  GlobalKey firstNoteGlobalKey = GlobalKey();

  int _pageNumber = 0;
  int _pageSize = 6;
  int _minRating = 0;
  int _sortBy = 1;
  List<String> _tagIds = [];
  List<String> _lectureIds = [];
  List<String> _languageIds = [];
  List<String> _universityIds = [];

  // --- Değişiklikler Başlıyor ---

  // Tüm yüklenen notlar için tek bir liste
  List<Note> _notes = [];

  // O anda API'den veri çekilip çekilmediğini kontrol eder
  bool _isLoadingMore = false;
  // Tüm notların yüklenip yüklenmediğini kontrol eder
  bool _hasMoreNotes = true;

  bool _isSearching = false;
  String _searchQuery = '';
  Set<String> _selectedHashtags = {};

  // _isRefreshing değişkeni sizde zaten vardı, `_handleRefresh` içinde kullanılıyor.
  bool _isRefreshing = false;

  // _currentPage ve _itemsPerPage kaldırıldı.

  // --- Değişiklikler Bitiyor ---

  Future<bool> _shouldShowNoteShowcase() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool('note_showcase_shown') ?? false);
  }

  Future<void> _markNoteShowcaseShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('note_showcase_shown', true);
  }

  @override
  void initState() {
    super.initState();

    // İlk sayfa verisini yükle
    _fetchNoteByPagination();

    _scrollController.addListener(() {
      // Kaydırma çubuğu en dibe yaklaştığında ve
      // o anda başka bir yükleme işlemi yoksa ve
      // yüklenecek daha fazla not varsa
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 && // Eşik değeri
          !_isLoadingMore &&
          _hasMoreNotes) {
        _pageNumber++;
        _fetchNoteByPagination();
      }
    });

    _searchAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  // Yüklenen *tüm* notları filtreler
  List<Note> get _filteredNotes {
    List<Note> filtered = _notes;

    // Arama filtresi
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((note) {
        final searchLower = _searchQuery.toLowerCase();
        return note.title.toLowerCase().contains(searchLower) ||
            note.description.toLowerCase().contains(searchLower) ||
            note.hashtags.any((tag) => tag.toLowerCase().contains(searchLower));
      }).toList();
    }

    // Hashtag filtresi
    if (_selectedHashtags.isNotEmpty) {
      filtered = filtered.where((note) {
        return _selectedHashtags.every(
          (selectedTag) => note.hashtags.any(
            (tag) => tag.toLowerCase() == selectedTag.toLowerCase(),
          ),
        );
      }).toList();
    }

    return filtered;
  }

  // _paginatedNotes, _totalPages, _changePage fonksiyonları kaldırıldı.

  Set<String> get _allHashtags {
    final Set<String> hashtags = {};
    for (var note in _notes) {
      hashtags.addAll(note.hashtags);
    }
    return hashtags;
  }

  void _openSearch() {
    setState(() {
      _isSearching = true;
    });
    _searchAnimationController.forward();
  }

  void _closeSearch() {
    setState(() {
      _isSearching = false;
      // _searchController.clear(); // Arama sorgusunu hemen temizleme
    });
    _searchAnimationController.reverse();
    FocusScope.of(context).unfocus();
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _selectedHashtags.clear();

      // Listeyi ve API sayacını sıfırla
      _notes.clear();
      NoteApiService.instance.resetPagination();
      _hasMoreNotes = true;
      _pageNumber = 0;
    });
    // İlk sayfayı tekrar yükle
    _fetchNoteByPagination();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Listeyi ve API sayacını sıfırla
    _notes.clear();
    NoteApiService.instance.resetPagination();
    _hasMoreNotes = true;
    _pageNumber = 0;

    // API'den ilk sayfayı yeniden çek
    // _loadNotes() zaten setState yaptığı için _isRefreshing'i orada false yapmaya gerek yok
    await _fetchNoteByPagination();

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Notlar güncellendi'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.purple.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _navigateToNote(Note note) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteViewerPage(
          noteTitle: note.title,
          noteDescription: note.description,
          pdfUrl: note.pdfPath,
          hashtags: note.hashtags,
          language: note.language,
        ),
      ),
    );
  }

  void _toggleHashtagFilter(String hashtag) {
    setState(() {
      if (_selectedHashtags.contains(hashtag)) {
        _selectedHashtags.remove(hashtag);
      } else {
        _selectedHashtags.add(hashtag);
      }
      // _currentPage = 1; satırı kaldırıldı. Filtreleme mevcut liste üzerinde anlık yapılır.
    });
  }

  // _showHashtagFilter fonksiyonu sizde olduğu gibi kalabilir,
  // içindeki _toggleHashtagFilter çağrısı zaten _currentPage kullanmıyor.
  void _showHashtagFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Text(
                      'Hashtag Filtrele',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (_selectedHashtags.isNotEmpty)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedHashtags.clear();
                          });
                          Navigator.pop(context);
                        },
                        child: const Text('Temizle'),
                      ),
                  ],
                ),
              ),
              const Divider(),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: StatefulBuilder(
                  builder: (context, setModalState) => ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(20),
                    children: _allHashtags.map((hashtag) {
                      final isSelected = _selectedHashtags.contains(hashtag);
                      return CheckboxListTile(
                        title: Text('#$hashtag'),
                        value: isSelected,
                        activeColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onChanged: (value) {
                          // Bu setModalState'i kullanmak yerine ana setState'i kullanıyoruz
                          // ki _filteredNotes yeniden hesaplansın
                          _toggleHashtagFilter(hashtag);
                          // Modal'ın da güncellenmesi için
                          setModalState(() {});
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _fetchNoteByPagination() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final noteApiService = NoteApiService.instance;

    PagingRequest pagingRequest = PagingRequest(
      pageNumber: _pageNumber,
      pageSize: _pageSize,
    );

    NotePagingRequest notePagingRequest = NotePagingRequest(
      minRating: _minRating,
      searchText: _searchController.text.isEmpty
          ? null
          : _searchController.text,
      sortBy: _sortBy,
      tagIds: _tagIds,
      pagingRequest: pagingRequest,
      languageIds: _languageIds,
      lectureIds: _lectureIds,
      universityIds: _universityIds,
    );

    try {
      GlobalApiHandlerResult result = await noteApiService.getNoteByPagination(
        notePagingRequest,
      );

      if (result.global_api_handler_result_status_code ==
              GLOBAL_API_HANDLER_RESULT_STATUS_CODE.SUCCESS &&
          result.data != null) {
        final noteResponse = result.data as NoteResponse;
        final entities = noteResponse.entities;

        // Duplicate check to avoid "Multiple heroes that share the same tag" error
        final newNotes = entities
            .where((entity) => !_notes.any((note) => note.id == entity.id))
            .map((entity) {
              return Note(
                id: entity.id,
                title: entity.title,
                description: entity.shortDescription,
                // Assuming language is not available in entity, using a default or checking if it can be derived.
                // If language is crucial, it should be added to NoteEntity.
                language: "Türkçe",
                pdfPath: "${BaseApi.ip}/note/getFileStream/${entity.id}",
                hashtags:
                    [], // NoteEntity doesn't have tags/hashtags in the provided definition.
                owner:
                    "${entity.creatorAppUser.firstName} ${entity.creatorAppUser.lastName}",
                isPopular: entity.isPopular,
                imageUrl: entity.coverImageUrl,
              );
            })
            .toList();

        if (mounted) {
          setState(() {
            _notes.addAll(newNotes);
            if (_notes.isEmpty && newNotes.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                if (mounted && await _shouldShowNoteShowcase()) {
                  ShowCaseWidget.of(context).startShowCase([firstNoteGlobalKey]);
                  await _markNoteShowcaseShown();
                }
              });
            }

            _hasMoreNotes = entities.length >= _pageSize;
            _isLoadingMore = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _isLoadingMore = false;
          });
        }
        print("Hata oluştu: ${result.message}");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
      print("Exception in _fetchNoteByPagination: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = _filteredNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _searchQuery.isEmpty && _selectedHashtags.isEmpty
              ? Center(
                  child: Text(
                    "Notlarım",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : Column(
                  key: const ValueKey('search-info'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${filteredNotes.length} sonuç',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      Text(
                        '"$_searchQuery"',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
        ),
        actions: [
          if (_searchQuery.isNotEmpty || _selectedHashtags.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: _clearSearch,
            ),
          IconButton(
            icon: Icon(
              _selectedHashtags.isEmpty
                  ? Icons.filter_list
                  : Icons.filter_list_alt,
              color: Colors.white,
            ),
            onPressed: _showHashtagFilter,
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: _openSearch,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (_selectedHashtags.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.purple.shade100,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedHashtags.map((tag) {
                      return Chip(
                        label: Text('#$tag'),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () => _toggleHashtagFilter(tag),
                        backgroundColor: Colors.purple.shade100,
                        labelStyle: TextStyle(
                          color: Colors.purple.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              Expanded(
                child:
                    (_notes.isEmpty && !_isLoadingMore) ||
                        (filteredNotes.isEmpty &&
                            (_searchQuery.isNotEmpty ||
                                _selectedHashtags.isNotEmpty))
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _handleRefresh,
                        color: Colors.purple,
                        child: CustomScrollView(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.all(16),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.75,
                                    ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final note = filteredNotes[index];
                                    final card = Hero(
                                      tag: 'note-${note.id}',
                                      child: NoteCard(
                                        note: note,
                                        onTap: () => _navigateToNote(note),
                                      ),
                                    );

                                    if (index == 0) {
                                      return Showcase(
                                        key: firstNoteGlobalKey,
                                        title: 'Notları buradan açabilirsin',
                                        description:
                                            'Bir nota dokunarak detaylarını görüntüleyebilir, PDF’i okuyabilirsin.',
                                        targetPadding: const EdgeInsets.all(8),
                                        child: card,
                                      );
                                    }
                                    return card;
                                  },
                                  childCount: filteredNotes.length,
                                ),
                              ),
                            ),
                            if (_isLoadingMore)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.purple.shade300,
                                    ),
                                  ),
                                ),
                              ),
                            if (!_hasMoreNotes &&
                                _notes.isNotEmpty &&
                                _searchQuery.isEmpty &&
                                _selectedHashtags.isEmpty)
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 32,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Tüm notlar yüklendi",
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
          if (_isSearching)
            GestureDetector(
              onTap: _closeSearch,
              child: AnimatedBuilder(
                animation: _searchAnimation,
                builder: (context, _) {
                  return Opacity(
                    opacity: _searchAnimation.value,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5 * _searchAnimation.value,
                        sigmaY: 5 * _searchAnimation.value,
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(
                          0.3 * _searchAnimation.value,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // _buildPageButton fonksiyonu kaldırıldı.

  Widget _buildEmptyState() {
    bool isFiltering = _searchQuery.isNotEmpty || _selectedHashtags.isNotEmpty;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isFiltering ? Icons.search_off : Icons.note_add_outlined,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            isFiltering ? 'Sonuç bulunamadı' : 'Henüz not yok',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              isFiltering
                  ? 'Arama kriterlerinizi veya filtrelerinizi değiştirmeyi deneyin.'
                  : 'Görünüşe göre hiç not yüklenmemiş veya eklenmemiş.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            ),
          ),
          // Eğer filtre yoksa ama liste boşsa, yeniden yüklemeyi denemek için bir buton
          if (!isFiltering && _notes.isEmpty && !_isLoadingMore)
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: _handleRefresh, // Yenileme fonksiyonunu tetikle
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Yeniden Yükle'),
              ),
            ),
        ],
      ),
    );
  }
}
