import 'dart:convert';
import 'package:interview_task/core/app/app_constants.dart';
import 'package:interview_task/feature/product/model/product_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<ProductModel> fetchAllProducts() async {
    try {
      var response =
          await http.get(Uri.parse('https://dummyjson.com/products'));
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        return ProductModel.fromJson(jsonBody);
      } else {
        throw Exception('Failed to load products.Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error: ${e.toString()}');
    }
  }

  Future<Product> fetchProductById(int? id) async {
    try {
      var response = await http.get(Uri.parse('${AppConstants.baseUrl}/$id'));
      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        return Product.fromJson(jsonBody);
      } else {
        throw Exception('Failed to load product. Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  Future<Product> addProduct(Product product) async {
    final Map<String, dynamic> body = {
      "title": product.title,
      "description": product.description,
      "price": product.price,
      "discountPercentage": product.discountPercentage,
      "rating": product.rating,
      "stock": product.stock,
      "brand": product.brand,
      "category": categoryValues.reverse[product.category],
      "thumbnail": product.thumbnail,
      "images": product.images,
    };

    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add product');
    }
  }

  Future<Product> updateProduct(Product product) async {
    final Map<String, dynamic> body = {
      "title": product.title,
      "description": product.description,
      "price": product.price,
      "discountPercentage": product.discountPercentage ?? 0.0,
      "rating": product.rating ?? 0.0,
      "stock": product.stock ?? 0,
      "brand": product.brand ?? '',
      "category": categoryValues.reverse[product.category] ?? 'others',
      "thumbnail": product.thumbnail,
      "availabilityStatus":
          availabilityStatusValues.reverse[product.availabilityStatus],
    };

    final url = '${AppConstants.baseUrl}/${product.id}';
    print('PUT to $url with body: $body');

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update product: ${response.body}');
    }
  }

  Future<bool> deleteProduct(int? id) async {
    final response =
        await http.delete(Uri.parse('${AppConstants.baseUrl}/$id'));

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete product');
    }
  }
}
