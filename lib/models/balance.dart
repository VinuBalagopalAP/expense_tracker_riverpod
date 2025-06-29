class Balance {
  final String userId1;
  final String userId2;
  final double amount;
  final String groupId; // Optional group ID for grouping balances

  Balance({
    required this.userId1,
    required this.userId2,
    required this.amount,
    required this.groupId,
  });

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      userId1: json['userId1'],
      userId2: json['userId2'],
      amount: json['amount'].toDouble(),
      groupId: json['groupId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'userId1': userId1, 'userId2': userId2, 'amount': amount};
  }
}

enum SplitType { equal, custom }
