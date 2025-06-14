import 'package:flutter/material.dart';
import 'package:interview_task/core/app/app_routes.dart';
import 'package:interview_task/feature/auth/view_model/auth_view_model.dart';
import 'package:interview_task/feature/product/view/custom_widget/cutom_product_tile.dart';
import 'package:interview_task/feature/product/view/product_details.dart';
import 'package:interview_task/feature/product/view_model/product_view_model.dart';
import 'package:provider/provider.dart';

class ProductView extends StatefulWidget {
  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
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
    if (width >= 900) return 4; // Desktop
    if (width >= 600) return 3; // Tablet
    return 2; // Mobile
  }

  @override
  Widget build(BuildContext context) {
    final username = context.watch<AuthViewModel>().username;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Hi, $username'),
        actions: [
          Center(
            child: IconButton(
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.login),
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
          return GridView.builder(
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
                      ));
                },
                prodThumbnail: product.thumbnail,
                prodTitle: product.title,
                prodPrice: product.price.toString(),
                prodQty: product.availabilityStatus.name,
              );
            },
          );
        },
      ),
    );
  }
}
