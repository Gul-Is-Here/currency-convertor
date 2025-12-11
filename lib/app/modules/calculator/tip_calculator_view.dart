import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gradient_button.dart';

class TipCalculatorView extends StatefulWidget {
  const TipCalculatorView({super.key});

  @override
  State<TipCalculatorView> createState() => _TipCalculatorViewState();
}

class _TipCalculatorViewState extends State<TipCalculatorView> {
  final TextEditingController _billController = TextEditingController();
  final TextEditingController _peopleController = TextEditingController(
    text: '1',
  );
  double _tipPercentage = 15.0;
  double _totalAmount = 0.0;
  double _tipAmount = 0.0;
  double _perPersonAmount = 0.0;

  void _calculate() {
    final bill = double.tryParse(_billController.text) ?? 0.0;
    final people = int.tryParse(_peopleController.text) ?? 1;

    setState(() {
      _tipAmount = bill * (_tipPercentage / 100);
      _totalAmount = bill + _tipAmount;
      _perPersonAmount = people > 0 ? _totalAmount / people : _totalAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tip Calculator')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bill Amount
            Text('Bill Amount', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _billController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: InputDecoration(
                hintText: 'Enter bill amount',
                prefixText: '\$ ',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) => _calculate(),
            ),

            const SizedBox(height: 24),

            // Tip Percentage
            Text(
              'Tip Percentage: ${_tipPercentage.toStringAsFixed(0)}%',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            // Preset tip buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [10.0, 15.0, 18.0, 20.0, 25.0].map((tip) {
                return ChoiceChip(
                  label: Text('${tip.toInt()}%'),
                  selected: _tipPercentage == tip,
                  onSelected: (selected) {
                    setState(() {
                      _tipPercentage = tip;
                      _calculate();
                    });
                  },
                  selectedColor: AppTheme.primaryColor,
                  labelStyle: TextStyle(
                    color: _tipPercentage == tip ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Custom tip slider
            Slider(
              value: _tipPercentage,
              min: 0,
              max: 50,
              divisions: 50,
              label: '${_tipPercentage.toStringAsFixed(0)}%',
              onChanged: (value) {
                setState(() {
                  _tipPercentage = value;
                  _calculate();
                });
              },
            ),

            const SizedBox(height: 24),

            // Number of People
            Text(
              'Split Between',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _peopleController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Number of people',
                suffixIcon: const Icon(Icons.people),
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
                      'Tip Amount',
                      '\$${_tipAmount.toStringAsFixed(2)}',
                    ),
                    const Divider(height: 24),
                    _buildResultRow(
                      'Total Amount',
                      '\$${_totalAmount.toStringAsFixed(2)}',
                    ),
                    const Divider(height: 24),
                    _buildResultRow(
                      'Per Person',
                      '\$${_perPersonAmount.toStringAsFixed(2)}',
                      highlight: true,
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
                text: 'Calculate Tip',
                icon: Icons.calculate,
                onPressed: _calculate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {bool highlight = false}) {
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
            color: highlight ? AppTheme.primaryColor : Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _billController.dispose();
    _peopleController.dispose();
    super.dispose();
  }
}
