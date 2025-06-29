import 'balance.dart';

class Expense {
  final String id;
  final String groupId;
  final String description;
  final double amount;
  final String paidBy;
  final List<String> splitBetween;
  final DateTime date;
  final SplitType splitType;
  final Map<String, double>? customSplits;
  final String? category;
  final String? notes;

  Expense({
    required this.id,
    required this.groupId,
    required this.description,
    required this.amount,
    required this.paidBy,
    required this.splitBetween,
    required this.date,
    this.splitType = SplitType.equal,
    this.customSplits,
    this.category,
    this.notes,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      groupId: json['groupId'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      paidBy: json['paidBy'],
      splitBetween: List<String>.from(json['splitBetween']),
      date: DateTime.parse(json['date']),
      splitType: SplitType.values[json['splitType']],
      customSplits: json['customSplits'] != null
          ? Map<String, double>.from(json['customSplits'])
          : null,
      category: json['category'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'description': description,
      'amount': amount,
      'paidBy': paidBy,
      'splitBetween': splitBetween,
      'date': date.toIso8601String(),
      'splitType': splitType.index,
      'customSplits': customSplits,
      'category': category,
      'notes': notes,
    };
  }

  Map<String, double> getIndividualShares() {
    Map<String, double> shares = {};
    if (splitType == SplitType.equal) {
      double shareAmount = amount / splitBetween.length;
      for (String userId in splitBetween) {
        shares[userId] = shareAmount;
      }
    } else if (splitType == SplitType.custom && customSplits != null) {
      shares = Map.from(customSplits!);
    }
    return shares;
  }
}
