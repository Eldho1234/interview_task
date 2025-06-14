import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String prodThumbnail;
  final String prodTitle;
  final String prodPrice;
  final String prodQty;
  final VoidCallback? onTap;

  const ProductTile({
    super.key,
    required this.prodThumbnail,
    required this.prodTitle,
    required this.prodPrice,
    required this.prodQty,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Image.network(prodThumbnail,
                  fit: BoxFit.cover, width: double.infinity),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(prodTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '\$ $prodPrice',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
              child: Text(
                prodQty,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
