import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_app/models/products_model.dart';
import 'package:sample_app/services/api_services.dart';

class ProductsState {
  final List<Product> products;
  final bool isLoading;
  final String errorMessage;

  ProductsState(
      {this.products = const [],
      this.isLoading = false,
      this.errorMessage = ''});

  ProductsState copyWith({
    final List<Product>? products,
    final bool? isLoading,
    final String? errorMessage,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ProductsProvider extends StateNotifier<ProductsState> {
  final ApiServices apiServices;

  ProductsProvider(this.apiServices) : super(ProductsState());

  Future<void> getProducts(String token) async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final products = await apiServices.fetchProducts(token);
      state = state.copyWith(products: products, isLoading: false);
    } catch (e) {
      state = state.copyWith(
          errorMessage: 'Failed to load products', isLoading: false);
    }
  }
}

final productsProvider = StateNotifierProvider<ProductsProvider, ProductsState>(
  (ref) => ProductsProvider(ApiServices()),
);
