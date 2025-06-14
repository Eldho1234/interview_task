import 'package:flutter/material.dart';
import 'package:interview_task/core/app/app_routes.dart';
import 'package:interview_task/feature/auth/view_model/auth_view_model.dart';
import 'package:interview_task/feature/product/model/product_model.dart';
import 'package:interview_task/feature/product/view/custom_widget/cutom_product_tile.dart';
import 'package:interview_task/feature/product/view/product_details.dart';
import 'package:interview_task/feature/product/view_model/product_view_model.dart';
import 'package:provider/provider.dart';

class ProductView extends StatefulWidget {
  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final _searchController = TextEditingController();
  final _min = TextEditingController();
  final _max = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    _min.dispose();
    _max.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productVM = Provider.of<ProductViewModel>(context, listen: false);
      final authVM = Provider.of<AuthViewModel>(context, listen: false);
      productVM.fetchAllProducts();
      authVM.loadUsername();
    });
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    final username = context.watch<AuthViewModel>().username;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Hi, $username'),
        actions: [
          Center(
            child: IconButton(
              onPressed: () {
                authVM.logOut();
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ),
        ],
      ),
      body: Consumer<ProductViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(child: Text('Error: ${viewModel.error}'));
          }

          final products = viewModel.products;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              viewModel.searchProducts('');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: viewModel.searchProducts,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: _min,
                        decoration:
                            const InputDecoration(labelText: 'Min Price'),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          viewModel.filterByPrice(
                            min: double.tryParse(val),
                            max: double.tryParse(_max.text),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        controller: _max,
                        decoration:
                            const InputDecoration(labelText: 'Max Price'),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          viewModel.filterByPrice(
                            min: double.tryParse(_min.text),
                            max: double.tryParse(val),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: DropdownButtonFormField<Category>(
                        value: viewModel.selectedCategory,
                        isExpanded: true,
                        hint: const Text('Select Category'),
                        onChanged: viewModel.filterByCategory,
                        items: Category.values.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(cat.toString().split('.').last),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _min.clear();
                        _max.clear();
                        viewModel.clearFilters();
                      },
                    ),
                  )
                ],
              ),
              if (products!.isEmpty)
                const Expanded(child: Center(child: Text('No products found.')))
              else
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount(context),
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductTile(
                        onTap: () {
                          viewModel.fetchProductById(product.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetails(),
                            ),
                          );
                        },
                        prodThumbnail: product.thumbnail,
                        prodTitle: product.title,
                        prodPrice: product.price.toString(),
                        prodQty:
                            product.stock == 0 ? 'Out Of Stock' : 'In Stock',
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
