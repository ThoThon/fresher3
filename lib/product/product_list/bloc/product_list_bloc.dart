import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../category/category_list/repositories/category_repository.dart';
import '../repositories/product_list_repository.dart';
import 'product_list_event.dart';
import 'product_list_state.dart';

EventTransformer<Event> _debounce<Event>({
  Duration duration = const Duration(milliseconds: 300),
}) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductListRepository _productRepo;
  final CategoryRepository _categoryRepo;

  static const int _pageSize = 10;

  ProductListBloc(this._productRepo, this._categoryRepo)
      : super(const ProductListState()) {
    on<ProductListFetched>(_onFetched);
    on<ProductListRefreshed>(_onRefreshed);
    on<ProductListLoadMore>(_onLoadMore);
    on<ProductListSearchChanged>(
      _onSearchChanged,
      transformer: _debounce(),
    );
    on<ProductListCategoryChanged>(_onCategoryChanged);
    on<ProductListDeleteRequested>(_onDeleteRequested);
  }

  Future<void> _onFetched(
      ProductListFetched event, Emitter<ProductListState> emit) async {
    emit(state.copyWith(status: ProductListStatus.loading));
    try {
      await _fetchCategories(emit);
      final products = await _productRepo.getProducts(
        page: 1,
        limit: _pageSize,
        keyword: state.searchQuery,
        categoryId: state.selectedCategoryId,
      );
      emit(state.copyWith(
        status: ProductListStatus.success,
        products: products,
        currentPage: 1,
        hasReachedMax: products.length < _pageSize,
      ));
    } catch (e) {
      debugPrint("Lỗi fetchProducts: $e");
      emit(state.copyWith(
        status: ProductListStatus.failure,
        errorMessage: 'Không thể tải sản phẩm',
      ));
    }
  }

  Future<void> _onRefreshed(
      ProductListRefreshed event, Emitter<ProductListState> emit) async {
    emit(state.copyWith(status: ProductListStatus.loading));
    try {
      final products = await _productRepo.getProducts(
        page: 1,
        limit: _pageSize,
        keyword: state.searchQuery,
        categoryId: state.selectedCategoryId,
      );
      emit(state.copyWith(
        status: ProductListStatus.success,
        products: products,
        currentPage: 1,
        hasReachedMax: products.length < _pageSize,
      ));
    } catch (e) {
      debugPrint("Lỗi refreshProducts: $e");
      emit(state.copyWith(
        status: ProductListStatus.failure,
        errorMessage: 'Không thể tải sản phẩm',
      ));
    }
  }

  Future<void> _onLoadMore(
      ProductListLoadMore event, Emitter<ProductListState> emit) async {
    if (state.hasReachedMax) return;
    emit(state.copyWith(status: ProductListStatus.loadingMore));
    try {
      final nextPage = state.currentPage + 1;
      final newProducts = await _productRepo.getProducts(
        page: nextPage,
        limit: _pageSize,
        keyword: state.searchQuery,
        categoryId: state.selectedCategoryId,
      );
      emit(state.copyWith(
        status: ProductListStatus.success,
        products: [...state.products, ...newProducts],
        currentPage: nextPage,
        hasReachedMax: newProducts.length < _pageSize,
      ));
    } catch (e) {
      debugPrint("Lỗi loadMore: $e");
      emit(state.copyWith(status: ProductListStatus.failure));
    }
  }

  Future<void> _onSearchChanged(
      ProductListSearchChanged event, Emitter<ProductListState> emit) async {
    emit(state.copyWith(searchQuery: event.query));
    await _onRefreshed(const ProductListRefreshed(), emit);
  }

  Future<void> _onCategoryChanged(
      ProductListCategoryChanged event, Emitter<ProductListState> emit) async {
    if (event.categoryId == null) {
      emit(state.copyWith(clearCategoryId: true));
    } else {
      emit(state.copyWith(selectedCategoryId: event.categoryId));
    }
    add(const ProductListRefreshed());
  }

  Future<void> _onDeleteRequested(
      ProductListDeleteRequested event, Emitter<ProductListState> emit) async {
    try {
      final success = await _productRepo.deleteProduct(event.productId);
      if (success) {
        final updated =
            state.products.where((p) => p.id != event.productId).toList();
        emit(state.copyWith(products: updated, isDeleteSuccess: true));
        emit(state.copyWith(isDeleteSuccess: false));
      }
    } catch (e) {
      debugPrint("Lỗi deleteProduct: $e");
    }
  }

  Future<void> _fetchCategories(Emitter<ProductListState> emit) async {
    try {
      final result = await _categoryRepo.getCategories();
      emit(state.copyWith(categories: result));
    } catch (e) {
      debugPrint("Lỗi fetchCategories: $e");
    }
  }
}
