import 'dart:ui';
import 'package:flutter/material.dart';
import '../add_news/add_news_page.dart';
import 'components/news_card.dart';
import 'components/show_news_detail.dart';
import 'constants/fake_constants.dart';

// News Page
class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<dynamic> get _filteredNews {
    if (_searchQuery.isEmpty) return newsItems;
    return newsItems.where((news) {
      return news.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          news.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: _searchQuery.isEmpty
            ? const Text('Haberler', style: TextStyle(color: Colors.white))
            : Text('Arama: "$_searchQuery"',
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        actions: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                });
              },
            ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 1;
              if (constraints.maxWidth > 600 && constraints.maxWidth <= 900) {
                crossAxisCount = 2;
              } else if (constraints.maxWidth > 900) {
                crossAxisCount = 2;
              }

              return RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 1));
                  setState(() {});
                },
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _filteredNews.length,
                  itemBuilder: (context, index) {
                    final news = _filteredNews[index];
                    return NewsCard(
                      news: news,
                      onTap: () => showNewsDetail(news, context),
                    );
                  },
                ),
              );
            },
          ),
          if (_isSearching)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSearching = false;
                });
              },
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Haber ara...',
                          border: InputBorder.none,
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                _isSearching = false;
                                _searchController.clear();
                              });
                            },
                          ),
                        ),
                        onSubmitted: (value) {
                          // Arama işlemi
                          setState(() {
                            _searchQuery = value;
                            _isSearching = false;
                          });
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
        ],
      ),
    );
  }
}