class SavedProduct {
  String name;
  int price;
  int? promox2;
  int? promox3;
  int qty;

  SavedProduct({
    required this.name,
    required this.price,
    this.promox2,
    this.promox3,
    required this.qty,
  });
}
