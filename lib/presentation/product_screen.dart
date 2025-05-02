import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_app/presentation/providers/products_provider.dart';

class ProductScreen extends ConsumerStatefulWidget {
  final String token;
  const ProductScreen(this.token, {super.key});

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(productsProvider);
      if (state.products.isEmpty &&
          !state.isLoading &&
          state.errorMessage.isEmpty) {
        ref.read(productsProvider.notifier).getProducts(widget.token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productsProvider);

    log(widget.token);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: state.isLoading
          ? const CircularProgressIndicator()
          : state.errorMessage.isNotEmpty
              ? Center(
                  child: Text(state.errorMessage),
                )
              : state.products.isEmpty
                  ? const Center(
                      child: Text('No products available'),
                    )
                  : ListView.builder(
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final products = state.products[index];
                        return ListTile(
                          leading: Image.network(products.imageUrl),
                          title: Text(products.title),
                          subtitle: Row(
                            children: [
                              Text(products.rating),
                              const Icon(Icons.star)
                            ],
                          ),
                        );
                      }),
    );
  }
}
