import 'package:flutter/material.dart';
import '../../core/widgets/currency_card.dart';
import '../../data/models/currency_model.dart';
import 'currency_controller.dart';

class CurrencySelectorSheet extends StatefulWidget {
  final Function(Currency) onSelect;
  final CurrencyController controller;

  const CurrencySelectorSheet({
    super.key,
    required this.onSelect,
    required this.controller,
  });

  @override
  State<CurrencySelectorSheet> createState() => _CurrencySelectorSheetState();
}

class _CurrencySelectorSheetState extends State<CurrencySelectorSheet> {
  String searchQuery = '';
  List<Currency> filteredCurrencies = [];

  @override
  void initState() {
    super.initState();
    filteredCurrencies = widget.controller.allCurrencies;
  }

  void _filterCurrencies(String query) {
    setState(() {
      searchQuery = query;
      filteredCurrencies = widget.controller.searchCurrencies(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Currency',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Search field
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search currency...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _filterCurrencies,
            ),
          ),

          // Currency list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredCurrencies.length,
              itemBuilder: (context, index) {
                final currency = filteredCurrencies[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CurrencyCard(
                    flag: currency.flag,
                    code: currency.code,
                    name: currency.name,
                    onTap: () => widget.onSelect(currency),
                    isSelected: false,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
