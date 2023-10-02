part of 'brand_stadium_bloc.dart';

enum FetchStatus {
  fetching,
  success,
  failed,
  init,
  showDeleteConfirmation
}

class BrandStadiumState extends Equatable {
  final List<CreateBrand> brandData;
  final FetchStatus status;

  const BrandStadiumState({
    this.brandData = const [],
    this.status = FetchStatus.init,
  });

  BrandStadiumState copyWith({
    List<CreateBrand>? brandData,
    FetchStatus? status,
  }) {
    return BrandStadiumState(
      brandData: brandData ?? this.brandData,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        brandData,
        status,
      ];
}
