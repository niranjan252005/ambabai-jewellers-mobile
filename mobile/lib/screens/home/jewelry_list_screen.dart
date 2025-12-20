import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/jewelry_item.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../widgets/jewelry_card.dart';
import '../../widgets/custom_logo.dart';
import '../admin/add_jewelry_screen.dart';
import 'jewelry_detail_screen.dart';

class JewelryListScreen extends StatefulWidget {
  const JewelryListScreen({super.key});

  @override
  State<JewelryListScreen> createState() => _JewelryListScreenState();
}

class _JewelryListScreenState extends State<JewelryListScreen> {
  List<JewelryItem> _jewelryItems = [];
  List<JewelryItem> _searchResults = [];
  bool _isLoading = true;
  bool _isSearching = false;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  User? _currentUser;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Rings',
    'Necklaces',
    'Earrings',
    'Bracelets',
    'Watches',
  ];

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
        _jewelryItems = items;
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

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final result = await ApiService.searchJewelryItems(query);
      
      if (result['success']) {
        setState(() {
          _searchResults = result['items'];
          _isSearching = false;
        });
      } else {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Search error: ${result['error']}')),
          );
        }
      }
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Search failed: $e')),
        );
      }
    }
  }

  List<JewelryItem> get _filteredItems {
    // If we have search results, use them; otherwise use all items
    final itemsToFilter = _searchQuery.isNotEmpty ? _searchResults : _jewelryItems;
    
    return itemsToFilter.where((item) {
      final matchesCategory = _selectedCategory == 'All' || 
          item.category.toLowerCase() == _selectedCategory.toLowerCase();
      
      return matchesCategory;
    }).toList();
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
          _loadJewelryItems(); // Refresh the list
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
      body: Column(
        children: [
          // Search and Filter Section
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
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    // Perform search with debouncing
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (_searchController.text == value) {
                        _performSearch(value);
                      }
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by name, SKU, category, material...',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    prefixIcon: _isSearching 
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                                _searchResults = [];
                                _isSearching = false;
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 12),
                // Category Filter
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          selectedColor: const Color(0xFFD4AF37).withOpacity(0.2),
                          checkmarkColor: const Color(0xFFD4AF37),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Search Results Indicator
          if (_searchQuery.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFD4AF37).withOpacity(0.1),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: 16,
                    color: const Color(0xFFD4AF37),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isSearching 
                        ? 'Searching for "$_searchQuery"...'
                        : 'Found ${_searchResults.length} results for "$_searchQuery"',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFD4AF37),
                    ),
                  ),
                  const Spacer(),
                  if (!_isSearching)
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                          _searchResults = [];
                          _isSearching = false;
                        });
                      },
                      child: Text(
                        'Clear',
                        style: GoogleFonts.lato(
                          fontSize: 12,
                          color: const Color(0xFFD4AF37),
                        ),
                      ),
                    ),
                ],
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
                            CustomLogo(
                              size: 64,
                              color: Colors.grey[400]!,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No jewelry items found',
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
                        child: MasonryGridView.count(
                          crossAxisCount: 2,
                          padding: const EdgeInsets.all(16),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          itemCount: _filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = _filteredItems[index];
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
                      ),
          ),
        ],
      ),
      floatingActionButton: _currentUser?.isAdmin == true
          ? FloatingActionButton(
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
              backgroundColor: const Color(0xFFD4AF37),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}