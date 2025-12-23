class CreditPackage {
  final String id;
  final int credits;
  final double price;
  final double discountPercent;
  final bool isPopular;

  CreditPackage({
    required this.id,
    required this.credits,
    required this.price,
    required this.discountPercent,
    this.isPopular = false,
  });

  double get pricePerCredit => price / credits;
}
