import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_button.dart';

class DiscountCalculatorView extends StatefulWidget {
  const DiscountCalculatorView({super.key});

  @override
  State<DiscountCalculatorView> createState() => _DiscountCalculatorViewState();
}

class _DiscountCalculatorViewState extends State<DiscountCalculatorView> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _taxController = TextEditingController(text: '0');

  double _originalPrice = 0.0;
  double _discountAmount = 0.0;
  double _discountedPrice = 0.0;
  double _taxAmount = 0.0;
  double _finalPrice = 0.0;
  double _savedAmount = 0.0;

  void _calculate() {
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final discountPercent = double.tryParse(_discountController.text) ?? 0.0;
    final taxPercent = double.tryParse(_taxController.text) ?? 0.0;

    setState(() {
      _originalPrice = price;
      _discountAmount = price * (discountPercent / 100);
      _discountedPrice = price - _discountAmount;
      _taxAmount = _discountedPrice * (taxPercent / 100);
      _finalPrice = _discountedPrice + _taxAmount;
      _savedAmount = _discountAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discount & Tax Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Original Price
            Text(
              'Original Price',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: 'Enter original price',
                prefixText: '\$ ',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => _calculate(),
            ),

            const SizedBox(height: 24),

            // Discount Percentage
            Text(
              'Discount Percentage',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _discountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: 'Enter discount %',
                suffixText: '%',
                prefixIcon: const Icon(Icons.discount),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => _calculate(),
            ),

            const SizedBox(height: 16),

            // Preset discount buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [10, 20, 25, 30, 40, 50, 70].map((discount) {
                return ActionChip(
                  label: Text('$discount% OFF'),
                  onPressed: () {
                    _discountController.text = discount.toString();
                    _calculate();
                  },
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  labelStyle: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 24),

            // Tax Percentage
            Text(
              'Tax Percentage (Optional)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _taxController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: 'Enter tax %',
                suffixText: '%',
                prefixIcon: const Icon(Icons.receipt),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => _calculate(),
            ),

            const SizedBox(height: 32),

            // Results Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildResultRow(
                      'Original Price',
                      '\$${_originalPrice.toStringAsFixed(2)}',
                    ),
                    const Divider(height: 24),
                    _buildResultRow(
                      'Discount',
                      '- \$${_discountAmount.toStringAsFixed(2)}',
                      color: Colors.red,
                    ),
                    const Divider(height: 24),
                    _buildResultRow(
                      'Discounted Price',
                      '\$${_discountedPrice.toStringAsFixed(2)}',
                    ),
                    if (_taxAmount > 0) ...[
                      const Divider(height: 24),
                      _buildResultRow(
                        'Tax',
                        '+ \$${_taxAmount.toStringAsFixed(2)}',
                        color: Colors.orange,
                      ),
                    ],
                    const Divider(height: 24),
                    _buildResultRow(
                      'Final Price',
                      '\$${_finalPrice.toStringAsFixed(2)}',
                      highlight: true,
                    ),
                    const Divider(height: 24),
                    _buildResultRow(
                      'You Save',
                      '\$${_savedAmount.toStringAsFixed(2)}',
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Calculate Button
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                text: 'Calculate Savings',
                icon: Icons.calculate,
                onPressed: _calculate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(
    String label,
    String value, {
    bool highlight = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: highlight ? 18 : 16,
            fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: highlight ? 24 : 18,
            fontWeight: FontWeight.bold,
            color: color ?? (highlight ? AppTheme.primaryColor : Colors.black),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _discountController.dispose();
    _taxController.dispose();
    super.dispose();
  }
}
