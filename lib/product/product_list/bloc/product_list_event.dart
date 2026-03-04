import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

class ProductListFetched extends ProductListEvent {
  const ProductListFetched();
}

class ProductListRefreshed extends ProductListEvent {
  const ProductListRefreshed();
}

class ProductListLoadMore extends ProductListEvent {
  const ProductListLoadMore();
}

class ProductListSearchChanged extends ProductListEvent {
  final String query;
  const ProductListSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class ProductListCategoryChanged extends ProductListEvent {
  final int? categoryId;
  const ProductListCategoryChanged(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class ProductListDeleteRequested extends ProductListEvent {
  final int productId;
  const ProductListDeleteRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}
