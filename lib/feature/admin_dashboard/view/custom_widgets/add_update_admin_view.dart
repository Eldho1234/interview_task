import 'package:flutter/material.dart';
import 'package:interview_task/feature/product/model/product_model.dart';
import 'package:interview_task/feature/product/view_model/product_view_model.dart';
import 'package:provider/provider.dart';

class AddOrUpdateProductScreen extends StatefulWidget {
  final Product? product;

  const AddOrUpdateProductScreen({super.key, this.product});

  @override
  State<AddOrUpdateProductScreen> createState() =>
      _AddOrUpdateProductScreenState();
}

class _AddOrUpdateProductScreenState extends State<AddOrUpdateProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController thumbnailController;
  late TextEditingController stockController;

  late Category _selectedCategory;

  @override
  void initState() {
    super.initState();
    final product = widget.product;

    titleController = TextEditingController(text: product?.title ?? '');
    descriptionController =
        TextEditingController(text: product?.description ?? '');
    priceController =
        TextEditingController(text: product?.price.toString() ?? '');
    thumbnailController = TextEditingController(text: product?.thumbnail ?? '');
    stockController =
        TextEditingController(text: product?.stock.toString() ?? '');

    _selectedCategory = product?.category ?? Category.OTHERS;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    thumbnailController.dispose();
    stockController.dispose();
    super.dispose();
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = Provider.of<ProductViewModel>(context, listen: false);
      final isUpdate = widget.product != null;

      final product = Product(
        id: isUpdate ? widget.product!.id : null,
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        price: double.tryParse(priceController.text.trim()) ?? 0.0,
        thumbnail: thumbnailController.text.trim(),
        category: _selectedCategory,
        stock: int.tryParse(stockController.text.trim()) ?? 0,
      );

      if (isUpdate) {
        await viewModel.updateProduct(product);
      } else {
        await viewModel.addProduct(product);
      }

      if (context.mounted) {
        Navigator.pop(context, product);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isUpdate = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdate ? 'Update Product' : 'Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                minLines: 1,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter a description'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a price' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: thumbnailController,
                decoration: const InputDecoration(labelText: 'Thumbnail URL'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter a thumbnail URL'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter stock count' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Category>(
                value: _selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: Category.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat.name),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: handleSubmit,
                child: Text(isUpdate ? 'Update' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
