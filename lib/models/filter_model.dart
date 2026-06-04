class FilterModel {
  final String id;
  final String label;
  final bool isSelected;

  const FilterModel({
    required this.id,
    required this.label,
    this.isSelected = false,
  });

  FilterModel copyWith({bool? isSelected}) => FilterModel(
    id: id,
    label: label,
    isSelected: isSelected ?? this.isSelected,
  );
}