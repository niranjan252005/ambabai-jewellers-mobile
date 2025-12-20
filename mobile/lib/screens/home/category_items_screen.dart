import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/jewelry_item.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/jewelry_card.dart';
import '../admin/add_jewelry_screen.dart';
import 'jewelry_detail_screen.dart';

class CategoryItemsScreen extends StatefulWidget {
  final String material;
  final String title;

  const CategoryItemsScreen({
    super.key,
    required this.material,
    required this.title,
  });

  @override
  State<CategoryItemsScreen> createState() => _CategoryItemsScreenState();
}

class _CategoryItemsScreenState extends State<CategoryItemsScreen> {
  List<JewelryItem> _allItems = [];
  bool _isLoading = true;
  String _searchQuery = '';
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadCurrentUser();
    await _loadJewelryItems();
  }

  Future<void> _loadCurrentUser() async {
    final user = await AuthService.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _loadJewelryItems() async {
    try {
      final items = await ApiService.getJewelryItems();
      setState(() {
        _allItems = items;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading jewelry items: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<JewelryItem> get _filteredItems {
    return _allItems.where((item) {
      final matchesMaterial = item.material.toLowerCase().contains(widget.material.toLowerCase());
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesMaterial && matchesSearch;
    }).toList();
  }

  Map<String, List<JewelryItem>> get _itemsByCategory {
    final Map<String, List<JewelryItem>> categoryMap = {};
    
    for (final item in _filteredItems) {
      if (!categoryMap.containsKey(item.category)) {
        categoryMap[item.category] = [];
      }
      categoryMap[item.category]!.add(item);
    }
    
    return categoryMap;
  }

  Future<void> _deleteItem(JewelryItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final result = await ApiService.deleteJewelryItem(item.id);
        if (result['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.green,
            ),
          );
          _loadJewelryItems();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['error']),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting item: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          if (_currentUser?.isAdmin == true)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddJewelryScreen(),
                  ),
                );
                if (result == true) {
                  _loadJewelryItems();
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search ${widget.material.toLowerCase()} jewelry...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredItems.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.diamond_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No ${widget.material.toLowerCase()} jewelry found',
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadJewelryItems,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _itemsByCategory.keys.length,
                          itemBuilder: (context, index) {
                            final category = _itemsByCategory.keys.elementAt(index);
                            final items = _itemsByCategory[category]!;
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category Header
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD4AF37),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          category,
                                          style: GoogleFonts.playfairDisplay(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        '${items.length} items',
                                        style: GoogleFonts.lato(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Category Items Grid
                                MasonryGridView.count(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  itemCount: items.length,
                                  itemBuilder: (context, itemIndex) {
                                    final item = items[itemIndex];
                                    return JewelryCard(
                                      item: item,
                                      isAdmin: _currentUser?.isAdmin == true,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => JewelryDetailScreen(item: item),
                                          ),
                                        );
                                      },
                                      onDelete: _currentUser?.isAdmin == true
                                          ? () => _deleteItem(item)
                                          : null,
                                    );
                                  },
                                ),
                                
                                const SizedBox(height: 24),
                              ],
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}