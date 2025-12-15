class CreditPackage {
  final String id;
  final int baseCredits;
  final int bonusCredits;
  final double price;
  final double pricePerCredit;
  final bool isPopular;

  CreditPackage({
    required this.id,
    required this.baseCredits,
    required this.bonusCredits,
    required this.price,
    required this.pricePerCredit,
    this.isPopular = false,
  });

  int get totalCredits => baseCredits + bonusCredits;
}