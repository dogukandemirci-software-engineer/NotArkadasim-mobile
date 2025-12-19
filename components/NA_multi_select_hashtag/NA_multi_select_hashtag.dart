import 'package:flutter/material.dart';

class HashtagSelector extends StatefulWidget {
  final List<String> availableHashtags;
  final Set<String> selectedHashtags;
  final void Function(String) onToggle;
  final int maxSelection;

  const HashtagSelector({
    required this.availableHashtags,
    required this.selectedHashtags,
    required this.onToggle,
    this.maxSelection = 5,
    super.key,
  });

  @override
  State<HashtagSelector> createState() => _HashtagSelectorState();
}

class _HashtagSelectorState extends State<HashtagSelector> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredHashtags = [];

  @override
  void initState() {
    super.initState();
    _filteredHashtags = widget.availableHashtags;
    _searchController.addListener(_filterHashtags);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterHashtags() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        _filteredHashtags = widget.availableHashtags;
      } else {
        _filteredHashtags = widget.availableHashtags
            .where((hashtag) => hashtag.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _handleToggle(String hashtag) {
    if (!widget.selectedHashtags.contains(hashtag) &&
        widget.selectedHashtags.length >= widget.maxSelection) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('En fazla ${widget.maxSelection} hashtag seçebilirsiniz'),
          backgroundColor: const Color(0xFFFF8F3C),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    widget.onToggle(hashtag);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Arama input'u
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Hashtag ara...',
            prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7385)),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear, color: Color(0xFF6B7385)),
              onPressed: () {
                _searchController.clear();
              },
            )
                : null,
            filled: true,
            fillColor: const Color(0xFFF5F7FA),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.purple),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.purple),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF2F57EF), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Seçili hashtag sayısı göstergesi
        if (widget.selectedHashtags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              '${widget.selectedHashtags.length}/${widget.maxSelection} hashtag seçildi',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7385),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        // Scrollable chip listesi
        if (_filteredHashtags.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Text(
                'Hashtag bulunamadı',
                style: TextStyle(
                  color: Color(0xFF6B7385),
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _filteredHashtags.map((hashtag) {
                  final isSelected = widget.selectedHashtags.contains(hashtag);
                  return _HashtagChip(
                    label: hashtag,
                    selected: isSelected,
                    onSelected: () => _handleToggle(hashtag),
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}

class _HashtagChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _HashtagChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    const selectedColor = Color(0xFF2F57EF);
    const unselectedColor = Color(0xFF6B7385);

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? selectedColor : unselectedColor,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          fontSize: 14,
        ),
      ),
      selected: selected,
      onSelected: (_) => onSelected(),
      backgroundColor: Colors.white,
      selectedColor: selectedColor.withOpacity(0.1),
      checkmarkColor: selectedColor,
      side: BorderSide(
        color: selected ? selectedColor : Colors.purple,
        width: selected ? 2 : 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}