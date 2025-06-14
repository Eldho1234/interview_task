import 'package:flutter/material.dart';
import 'package:interview_task/feature/product/model/product_model.dart';
import 'package:interview_task/feature/product/repository/api_services.dart';

class ProductViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product>? _products = [];
  List<Product>? _allProducts = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _error;
  Category? _selectedCategory;
  double? _minPrice;
  double? _maxPrice;

  List<Product>? get products => _products;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Category? get selectedCategory => _selectedCategory;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;

  Future<void> fetchAllProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.fetchAllProducts();
      _allProducts = response.products;
      _products = response.products;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchProductById(int? id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedProduct = await _apiService.fetchProductById(id);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final maxId = _products!.isEmpty
          ? 0
          : _products!
              .where((p) => p.id != null)
              .map((p) => p.id!)
              .reduce((a, b) => a > b ? a : b);

      product.id = maxId + 1;
      await Future.delayed(const Duration(milliseconds: 300));

      _products!.add(product);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (product.id == null) {
        throw Exception('Cannot update product: ID is null.');
      }

      final updatedProduct = await _apiService.updateProduct(product);
      final index = _products?.indexWhere((p) => p.id == product.id) ?? -1;
      if (index != -1) {
        _products![index] = updatedProduct;
      } else {
        throw Exception('Product with ID ${product.id} not found locally.');
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(int? id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 300));

      _products!.removeWhere((p) => p.id == id);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      _products = List<Product>.from(_allProducts!);
    } else {
      _products = _allProducts!
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void filterByCategory(Category? category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void filterByPrice({double? min, double? max}) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
  }

  void clearFilters() {
    _selectedCategory = null;
    _minPrice = null;
    _maxPrice = null;
    _products = List<Product>.from(_allProducts ?? []);
    notifyListeners();
  }

  void _applyFilters() {
    List<Product> filtered = List<Product>.from(_allProducts ?? []);

    if (_selectedCategory != null) {
      filtered = filtered
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    if (_minPrice != null) {
      filtered =
          filtered.where((product) => product.price >= _minPrice!).toList();
    }

    if (_maxPrice != null) {
      filtered =
          filtered.where((product) => product.price <= _maxPrice!).toList();
    }

    _products = filtered;
    notifyListeners();
  }
}
