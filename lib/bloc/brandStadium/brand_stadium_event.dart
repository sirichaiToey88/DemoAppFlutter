part of 'brand_stadium_bloc.dart';

class BrandStadiumEvent extends Equatable {
  const BrandStadiumEvent();

  @override
  List<Object> get props => [];
}

class BrandStadiumSaveEvent extends BrandStadiumEvent {
  final List<CreateBrand> brandData;
  final String toKen;

  const BrandStadiumSaveEvent(this.brandData, this.toKen);

  @override
  List<Object> get props => [
        brandData,
        toKen,
      ];
}
