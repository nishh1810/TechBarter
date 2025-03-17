import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_barter/components/custom_scaffold.dart';
import 'package:tech_barter/components/product_card.dart';
import 'package:tech_barter/models/Product.dart';
import 'package:tech_barter/providers/product_provider.dart';

class ProductCatalogPage extends StatefulWidget {
  const ProductCatalogPage({super.key});

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isLoading = false;
  String _currentFilter = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadInitialProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadInitialProducts() async {
    setState(() => _isLoading = true);
    await Provider.of<ProductProvider>(context, listen: false).getProducts();
    setState(() => _isLoading = false);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim().toLowerCase();
    });
  }

  Future<void> _applyFilter(String filter) async {
    setState(() {
      _currentFilter = filter;
      _isLoading = true;
    });

    try {
      final productProvider = Provider.of<ProductProvider>(context, listen: false);

      if (filter == 'Recyclable') {
        await productProvider.getRecyclableProducts();
      } else if (filter == 'Best Sellers') {
        await productProvider.loadBestSellingProducts();
      } else {
        await productProvider.getProducts();
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<Product> _filterProducts(List<Product> products) {
    if (_searchQuery.isEmpty) return products;

    return products.where((product) {
      return product.name?.toLowerCase().contains(_searchQuery) == true ||
          product.description?.toLowerCase().contains(_searchQuery) == true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    List<Product> products = _currentFilter == 'Recyclable'
        ? productProvider.recyclableProducts
        : productProvider.getBestSellingProducts;

    products = _filterProducts(products);

    return CustomScaffold(
      curIndex: 1,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: SearchBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16),
                ),
                hintText: 'Search products...',
                leading: const Icon(Icons.search),
                trailing: [
                  if (_searchQuery.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        _searchFocusNode.unfocus();
                      },
                    ),
                ],
              ),
            ),

            // Header Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Catalog',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _searchQuery.isEmpty
                        ? 'Browse our wide range of tech products'
                        : 'Search results for "$_searchQuery"',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            // Filter Chips
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFilterChip('All'),
                  _buildFilterChip('Recyclable'),
                  _buildFilterChip('Best Sellers'),
                ],
              ),
            ),

            // Product Count
            if (_searchQuery.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  '${products.length} products found',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ),

            // Product Grid
            _isLoading && products.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 60,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty
                        ? 'No products available'
                        : 'No products found for "$_searchQuery"',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (_searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        _searchFocusNode.unfocus();
                      },
                      child: const Text('Clear search'),
                    ),
                ],
              ),
            )
                : GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height * 2.3),
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(product: products[index]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _currentFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool value) {
          _applyFilter(label);
        },
        selectedColor: Colors.blue[100],
        checkmarkColor: Colors.blue,
        labelStyle: TextStyle(
          color: isSelected ? Colors.blue : Colors.grey[700],
        ),
        shape: StadiumBorder(
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
          ),
        ),
      ),
    );
  }
}