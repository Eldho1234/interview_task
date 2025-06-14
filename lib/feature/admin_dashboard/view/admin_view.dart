import 'package:flutter/material.dart';
import 'package:interview_task/core/app/app_routes.dart';
import 'package:interview_task/feature/admin_dashboard/view/custom_widgets/add_update_admin_view.dart';
import 'package:interview_task/feature/admin_dashboard/view/custom_widgets/admin_product_tile.dart';
import 'package:interview_task/feature/auth/view_model/auth_view_model.dart';
import 'package:interview_task/feature/product/view_model/product_view_model.dart';
import 'package:provider/provider.dart';

class AdminDashBoard extends StatefulWidget {
  @override
  State<AdminDashBoard> createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoard> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final productVM = Provider.of<ProductViewModel>(context, listen: false);

      productVM.fetchAllProducts();
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
    final authVM = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Hi, Admin'),
        actions: [
          Center(
            child: IconButton(
                tooltip: 'Add Product',
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddOrUpdateProductScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.add)),
          ),
          const SizedBox(),
          Center(
            child: IconButton(
              tooltip: 'Log Out',
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
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: products!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(context),
              childAspectRatio: 0.7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return AdminProductTile(
                prodThumbnail: product.thumbnail,
                prodTitle: product.title,
                prodPrice: product.price.toString(),
                prodQty: product.stock == 0 ? 'Out Of Stock' : 'In Stock',
                onEdit: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          AddOrUpdateProductScreen(product: product),
                    ),
                  );
                },
                onDelete: () => viewModel.deleteProduct(product.id),
              );
            },
          );
        },
      ),
    );
  }
}
