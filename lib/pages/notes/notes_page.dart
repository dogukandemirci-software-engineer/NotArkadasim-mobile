import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_arkadasim/services/api_services/note_api/note_api_service.dart';
import 'dart:ui';
import '../../models/Note.dart';
import 'components/note_card.dart'; // Bu component'in sizde olduğunu varsayıyorum
import 'note_view/note_view_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;

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


  @override
  void initState() {
    super.initState();

    // İlk sayfa verisini yükle
    _loadNotes();

    _scrollController.addListener(() {
      // Kaydırma çubuğu en dibe yaklaştığında ve
      // o anda başka bir yükleme işlemi yoksa ve
      // yüklenecek daha fazla not varsa
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 && // Eşik değeri
          !_isLoadingMore &&
          _hasMoreNotes) {
        _loadNotes();
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
        return _selectedHashtags.every((selectedTag) =>
            note.hashtags.any((tag) => tag.toLowerCase() == selectedTag.toLowerCase()));
      }).toList();
    }

    return filtered;
  }

  // Notları yükleyen ana fonksiyon (eski adı: getNotesWithPaginationByScrolling)
  Future<void> _loadNotes() async {
    // Zaten bir yükleme varsa tekrar tetikleme
    if (_isLoadingMore || !_hasMoreNotes) return;

    setState(() {
      _isLoadingMore = true;
    });

    final newNotes = await NoteApiService.instance.getNotesByPage();

    if (mounted) {
      setState(() {
        if (newNotes.isEmpty) {
          // API boş liste döndürdüyse, daha fazla not kalmamıştır
          _hasMoreNotes = false;
        } else {
          _notes.addAll(newNotes);
        }
        _isLoadingMore = false;
      });
    }
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
    });
    // İlk sayfayı tekrar yükle
    _loadNotes();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Listeyi ve API sayacını sıfırla
    _notes.clear();
    NoteApiService.instance.resetPagination();
    _hasMoreNotes = true;

    // API'den ilk sayfayı yeniden çek
    // _loadNotes() zaten setState yaptığı için _isRefreshing'i orada false yapmaya gerek yok
    await _loadNotes();

    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Notlar güncellendi'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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


  @override
  Widget build(BuildContext context) {
    final filteredNotes = _filteredNotes; // Doğrudan _filteredNotes kullanıyoruz

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
              ?  Expanded(
            child: Center(
              child: Text(
                "Notlarım",
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
              : Column(
            key: const ValueKey('search-info'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${filteredNotes.length} sonuç', // _filteredNotes kullanılıyor
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
              tooltip: 'Filtreyi Temizle',
            ),
          IconButton(
            icon: Icon(
              _selectedHashtags.isEmpty ? Icons.filter_list : Icons.filter_list_alt,
              color: Colors.white,
            ),
            onPressed: _showHashtagFilter,
            tooltip: 'Hashtag Filtrele',
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: _openSearch,
            tooltip: 'Ara',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (_selectedHashtags.isNotEmpty)
                Container(
                  // ... (Hashtag Chip kısmı aynı kalabilir)
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                // Boş durum kontrolü: _notes.isEmpty (hiçbir şey yüklenmemişse)
                // VEYA filteredNotes.isEmpty (filtre sonucu boşsa)
                child: (_notes.isEmpty && !_isLoadingMore) ||
                    (filteredNotes.isEmpty && (_searchQuery.isNotEmpty || _selectedHashtags.isNotEmpty))
                    ? _buildEmptyState()
                    : RefreshIndicator(
                  onRefresh: _handleRefresh,
                  color: Colors.purple,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: filteredNotes.length, // filteredNotes kullanılıyor
                            itemBuilder: (context, index) {
                              final note = filteredNotes[index]; // filteredNotes kullanılıyor
                              return Hero(
                                tag: 'note-${note.id}',
                                child: NoteCard(
                                  note: note,
                                  onTap: () => _navigateToNote(note),
                                ),
                              );
                            },
                          ),

                          // --- YENİ ---
                          // Yükleme göstergesi (sayfa sonu)
                          if (_isLoadingMore)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 24.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.purple.shade300,
                                ),
                              ),
                            ),

                          // --- YENİ ---
                          // Daha fazla not kalmadığında gösterilecek yazı
                          if (!_hasMoreNotes && _notes.isNotEmpty && _searchQuery.isEmpty && _selectedHashtags.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32.0),
                              child: Center(
                                child: Text(
                                  "Tüm notlar yüklendi",
                                  style: TextStyle(color: Colors.grey.shade500),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Arama arayüzü (Aynı kalabilir)
          if (_isSearching)
            GestureDetector(
              onTap: _closeSearch,
              child: AnimatedBuilder(
                animation: _searchAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _searchAnimation.value,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5 * _searchAnimation.value,
                        sigmaY: 5 * _searchAnimation.value,
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0.3 * _searchAnimation.value),
                        child: Center(
                          child: Transform.scale(
                            scale: 0.8 + (0.2 * _searchAnimation.value),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 24),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Colors.purple, Colors.blue],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purple.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  controller: _searchController,
                                  autofocus: true,
                                  style: const TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                    hintText: 'Not ara...',
                                    hintStyle: TextStyle(color: Colors.grey.shade400),
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search, color: Colors.purple.shade400),
                                    suffixIcon: _searchController.text.isNotEmpty
                                        ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() {
                                          _searchQuery = '';
                                        });
                                      },
                                    )
                                        : null,
                                  ),
                                  onSubmitted: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                    _closeSearch(); // Aramayı onayla ve kapat
                                  },
                                  onChanged: (value) {
                                    setState(() {
                                      _searchQuery = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
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
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
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