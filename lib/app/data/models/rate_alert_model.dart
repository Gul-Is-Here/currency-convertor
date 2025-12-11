class RateAlert {
  final String id;
  final String baseCurrency;
  final String targetCurrency;
  final double targetRate;
  final String condition; // 'above' or 'below'
  final bool isActive;
  final DateTime createdAt;
  final DateTime? triggeredAt;

  RateAlert({
    required this.id,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.targetRate,
    required this.condition,
    this.isActive = true,
    required this.createdAt,
    this.triggeredAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'baseCurrency': baseCurrency,
    'targetCurrency': targetCurrency,
    'targetRate': targetRate,
    'condition': condition,
    'isActive': isActive,
    'createdAt': createdAt.toIso8601String(),
    'triggeredAt': triggeredAt?.toIso8601String(),
  };

  factory RateAlert.fromJson(Map<String, dynamic> json) => RateAlert(
    id: json['id'] as String,
    baseCurrency: json['baseCurrency'] as String,
    targetCurrency: json['targetCurrency'] as String,
    targetRate: (json['targetRate'] as num).toDouble(),
    condition: json['condition'] as String,
    isActive: json['isActive'] as bool? ?? true,
    createdAt: DateTime.parse(json['createdAt'] as String),
    triggeredAt: json['triggeredAt'] != null
        ? DateTime.parse(json['triggeredAt'] as String)
        : null,
  );

  RateAlert copyWith({
    String? id,
    String? baseCurrency,
    String? targetCurrency,
    double? targetRate,
    String? condition,
    bool? isActive,
    DateTime? createdAt,
    DateTime? triggeredAt,
  }) {
    return RateAlert(
      id: id ?? this.id,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      targetRate: targetRate ?? this.targetRate,
      condition: condition ?? this.condition,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      triggeredAt: triggeredAt ?? this.triggeredAt,
    );
  }

  String get conditionText =>
      condition == 'above' ? 'rises above' : 'falls below';

  String get alertDescription =>
      '${baseCurrency}/${targetCurrency} $conditionText $targetRate';
}
