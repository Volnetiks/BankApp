class Transaction {
  final String name;
  final String category;
  final double price;
  final DateTime date;
  final String iconPath;

  Transaction(
      {required this.name,
      required this.category,
      required this.price,
      required this.date,
      required this.iconPath});
}
