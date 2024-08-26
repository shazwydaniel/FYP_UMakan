class CafeDetailsData {
  final String name;
  final String logoPath;
  final String details;
  final List<CafeItemData> items;

  CafeDetailsData(
      {required this.name,
      required this.logoPath,
      required this.details,
      required this.items});
}

class CafeItemData {
  final String item;
  final double price;
  final int calories;
  final String image;
  final String location;

  CafeItemData({
    required this.item,
    required this.price,
    required this.calories,
    required this.image,
    required this.location,
  });
}
