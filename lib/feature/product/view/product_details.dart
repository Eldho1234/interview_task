import 'package:flutter/material.dart';
import 'package:interview_task/feature/product/view/custom_widget/custom_details_page.dart';
import 'package:interview_task/feature/product/view_model/product_view_model.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProductViewModel>(context);
    final product = vm.selectedProduct;
    if (vm.isLoading || product == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      body: CustomProductDetailsPage(
        title: product.title,
        imageUrl: product.thumbnail,
        description: product.description,
        price: product.price.toString(),
      ),
    );
  }
}
