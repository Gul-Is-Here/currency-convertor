import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/widgets/admob_banner_widget.dart';

class CurrencyTipsView extends StatelessWidget {
  const CurrencyTipsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Currency Tips & Guide')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner Ad
          const AdMobBannerWidget(margin: EdgeInsets.only(bottom: 16)),

          // Travel Money Tips Section
          _buildSectionCard(
            context,
            icon: Icons.flight_takeoff,
            iconColor: Colors.blue,
            title: 'Travel Money Tips',
            children: [
              _buildTipItem(
                context,
                '💡',
                'Exchange Before You Travel',
                'Compare rates and exchange currency a few days before your trip. Airport exchange counters typically charge 5-15% more than online rates.',
                isDark,
              ),
              _buildTipItem(
                context,
                '💳',
                'Use No-Fee Cards Abroad',
                'Get a travel-friendly debit/credit card with no foreign transaction fees. This can save you 2-3% on every purchase.',
                isDark,
              ),
              _buildTipItem(
                context,
                '🏧',
                'ATM Withdrawals',
                'Withdraw larger amounts less frequently from ATMs to minimize per-transaction fees. Choose to be charged in local currency, not your home currency.',
                isDark,
              ),
              _buildTipItem(
                context,
                '📱',
                'Track Rates with Alerts',
                'Use the Rate Alerts feature in this app to get notified when rates hit your target. Buy when rates are favorable!',
                isDark,
              ),
              _buildTipItem(
                context,
                '🔄',
                'Avoid Double Conversion',
                'When paying in a foreign country, always choose to pay in the local currency. Paying in your home currency often uses a worse exchange rate.',
                isDark,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Understanding Exchange Rates
          _buildSectionCard(
            context,
            icon: Icons.school,
            iconColor: Colors.orange,
            title: 'Understanding Exchange Rates',
            children: [
              _buildTipItem(
                context,
                '📊',
                'What Affects Rates?',
                'Exchange rates are influenced by interest rates, inflation, political stability, trade balances, and market speculation.',
                isDark,
              ),
              _buildTipItem(
                context,
                '📈',
                'Bid vs Ask Spread',
                'The "bid" is what buyers pay, the "ask" is what sellers want. The spread is how exchanges make money. Lower spread = better deal for you.',
                isDark,
              ),
              _buildTipItem(
                context,
                '🕐',
                'Best Time to Exchange',
                'Currency markets are most active during overlapping trading hours (London & New York: 1-5 PM GMT). Rates can be more competitive during these times.',
                isDark,
              ),
              _buildTipItem(
                context,
                '🔔',
                'Set Target Rate Alerts',
                'Use our Rate Alerts feature to set your desired rate. The app monitors 24/7 and notifies you when the rate is reached.',
                isDark,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Saving Money Section
          _buildSectionCard(
            context,
            icon: Icons.savings,
            iconColor: Colors.green,
            title: 'Save Money on Currency',
            children: [
              _buildTipItem(
                context,
                '🏦',
                'Compare Multiple Sources',
                'Compare rates between banks, online services, and exchange bureaus. Online services often offer 1-3% better rates than physical locations.',
                isDark,
              ),
              _buildTipItem(
                context,
                '📉',
                'Buy on Dips',
                'Use the Charts feature to track historical trends. If a currency is trending lower, it might be a good time to buy.',
                isDark,
              ),
              _buildTipItem(
                context,
                '💰',
                'Bulk Exchange Discounts',
                'Exchanging larger amounts often gets you a better rate. Consider exchanging enough for your entire trip at once.',
                isDark,
              ),
              _buildTipItem(
                context,
                '🚫',
                'Avoid Hotel/Airport Exchange',
                'Hotels and airports charge the highest fees (up to 15%). Plan ahead and exchange at banks or reputable online services.',
                isDark,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Crypto Tips
          _buildSectionCard(
            context,
            icon: Icons.currency_bitcoin,
            iconColor: Colors.amber,
            title: 'Crypto Tips for Beginners',
            children: [
              _buildTipItem(
                context,
                '🔒',
                'Start Small & Learn',
                'Only invest what you can afford to lose. Start with small amounts and learn how the market works before making larger investments.',
                isDark,
              ),
              _buildTipItem(
                context,
                '📊',
                'Dollar Cost Averaging',
                'Instead of buying all at once, invest a fixed amount regularly (weekly/monthly). This reduces the impact of price volatility.',
                isDark,
              ),
              _buildTipItem(
                context,
                '🔐',
                'Secure Your Wallet',
                'Use two-factor authentication, strong passwords, and consider a hardware wallet for large holdings. Never share your private keys.',
                isDark,
              ),
              _buildTipItem(
                context,
                '📰',
                'Stay Informed',
                'Use the Crypto Market tab to track real-time prices. Understanding market trends helps make better decisions.',
                isDark,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Quick Reference - Popular Currency Symbols
          _buildSectionCard(
            context,
            icon: Icons.menu_book,
            iconColor: Colors.purple,
            title: 'Popular Currency Quick Reference',
            children: [
              _buildCurrencyRef(
                context,
                '🇺🇸',
                'USD',
                'US Dollar',
                '\$',
                isDark,
              ),
              _buildCurrencyRef(context, '🇪🇺', 'EUR', 'Euro', '€', isDark),
              _buildCurrencyRef(
                context,
                '🇬🇧',
                'GBP',
                'British Pound',
                '£',
                isDark,
              ),
              _buildCurrencyRef(
                context,
                '🇯🇵',
                'JPY',
                'Japanese Yen',
                '¥',
                isDark,
              ),
              _buildCurrencyRef(
                context,
                '🇨🇭',
                'CHF',
                'Swiss Franc',
                'CHF',
                isDark,
              ),
              _buildCurrencyRef(
                context,
                '🇨🇦',
                'CAD',
                'Canadian Dollar',
                'C\$',
                isDark,
              ),
              _buildCurrencyRef(
                context,
                '🇦🇺',
                'AUD',
                'Australian Dollar',
                'A\$',
                isDark,
              ),
              _buildCurrencyRef(
                context,
                '🇨🇳',
                'CNY',
                'Chinese Yuan',
                '¥',
                isDark,
              ),
              _buildCurrencyRef(
                context,
                '🇮🇳',
                'INR',
                'Indian Rupee',
                '₹',
                isDark,
              ),
              _buildCurrencyRef(
                context,
                '🇸🇦',
                'SAR',
                'Saudi Riyal',
                'ر.س',
                isDark,
              ),
              _buildCurrencyRef(
                context,
                '🇦🇪',
                'AED',
                'UAE Dirham',
                'د.إ',
                isDark,
              ),
              _buildCurrencyRef(
                context,
                '🇵🇰',
                'PKR',
                'Pakistani Rupee',
                '₨',
                isDark,
              ),
            ],
          ),

          // Banner Ad at bottom
          const SizedBox(height: 16),
          const AdMobBannerWidget(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(
    BuildContext context,
    String emoji,
    String title,
    String description,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyRef(
    BuildContext context,
    String flag,
    String code,
    String name,
    String symbol,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(flag, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          SizedBox(
            width: 45,
            child: Text(
              code,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
          Text(
            symbol,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
