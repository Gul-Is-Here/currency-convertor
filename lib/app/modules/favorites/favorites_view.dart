import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/format_utils.dart';
import '../../data/providers/crypto_api_provider.dart';
import 'dart:async';

class FavoritesView extends StatefulWidget {
  const FavoritesView({super.key});

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  final CryptoApiProvider _cryptoApi = CryptoApiProvider();
  Map<String, CryptoData> _cryptoData = {};
  bool _isLoading = true;
  String? _errorMessage;
  Timer? _refreshTimer;
  DateTime? _lastRefreshTime;

  final List<CryptoInfo> _cryptos = [
    CryptoInfo('bitcoin', 'BTC', 'Bitcoin', '₿', Colors.orange),
    CryptoInfo('ethereum', 'ETH', 'Ethereum', 'Ξ', Colors.blue),
    CryptoInfo('binancecoin', 'BNB', 'Binance Coin', 'BNB', Colors.amber),
    CryptoInfo('ripple', 'XRP', 'Ripple', 'XRP', Colors.blueGrey),
    CryptoInfo('cardano', 'ADA', 'Cardano', '₳', Colors.indigo),
    CryptoInfo('solana', 'SOL', 'Solana', 'SOL', Colors.purple),
    CryptoInfo('dogecoin', 'DOGE', 'Dogecoin', 'Ð', Colors.yellow.shade700),
    CryptoInfo('polkadot', 'DOT', 'Polkadot', 'DOT', Colors.pink),
  ];

  @override
  void initState() {
    super.initState();
    _loadCryptoData();
    // Auto-refresh every 2 minutes to avoid rate limits
    _refreshTimer = Timer.periodic(const Duration(minutes: 2), (_) {
      _loadCryptoData();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadCryptoData() async {
    // Prevent too frequent refreshes
    if (_lastRefreshTime != null) {
      final timeSinceLastRefresh = DateTime.now().difference(_lastRefreshTime!);
      if (timeSinceLastRefresh.inSeconds < 60) {
        // Don't refresh if less than 1 minute has passed
        return;
      }
    }

    try {
      setState(() {
        _errorMessage = null;
      });

      final prices = await _cryptoApi.getCryptoPrices();
      final Map<String, CryptoData> newData = {};

      // Load history for only first 4 cryptos to reduce API calls
      for (var i = 0; i < _cryptos.length; i++) {
        final crypto = _cryptos[i];
        try {
          final currentPrice = prices[crypto.id] ?? 0.0;

          if (currentPrice > 0) {
            // For demo purposes, generate simple mock history data to avoid rate limits
            final mockHistory = _generateMockHistory(currentPrice);

            final firstPrice = mockHistory.first['price'] as double;
            final change24h = ((currentPrice - firstPrice) / firstPrice) * 100;

            newData[crypto.id] = CryptoData(
              currentPrice: currentPrice,
              change24h: change24h,
              history: mockHistory,
            );
          }
        } catch (e) {
          print('Error loading ${crypto.name}: $e');
          // Continue loading other cryptos even if one fails
        }

        // Add delay between requests to avoid rate limiting
        if (i < _cryptos.length - 1) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
      }

      if (mounted) {
        setState(() {
          _cryptoData = newData;
          _isLoading = false;
          _lastRefreshTime = DateTime.now();
        });
      }
    } catch (e) {
      print('Error loading crypto data: $e');
      if (mounted) {
        setState(() {
          if (e.toString().contains('429')) {
            _errorMessage =
                'Rate limit exceeded. Please wait a moment and try again.';
          } else {
            _errorMessage =
                'Failed to load crypto data. Please check your connection.';
          }
          _isLoading = false;
        });
      }
    }
  }

  // Generate mock 24h history data based on current price
  // This reduces API calls while still showing realistic charts
  List<Map<String, dynamic>> _generateMockHistory(double currentPrice) {
    final history = <Map<String, dynamic>>[];
    final random = currentPrice.hashCode % 100; // Deterministic "randomness"

    // Generate 24 data points (hourly data for 24 hours)
    for (int i = 0; i < 24; i++) {
      final variance = (random + i * 7) % 10 - 5; // -5% to +5% variance
      final priceVariance = currentPrice * (variance / 100);
      final price =
          currentPrice + priceVariance - (currentPrice * 0.02 * (24 - i) / 24);

      history.add({
        'timestamp': DateTime.now()
            .subtract(Duration(hours: 24 - i))
            .millisecondsSinceEpoch,
        'price': price,
      });
    }

    return history;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.currency_bitcoin,
                        size: 32,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Crypto Market',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Live cryptocurrency prices',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppTheme.textSecondary),
                            ),
                            if (_lastRefreshTime != null)
                              Text(
                                'Updated ${_getTimeAgo(_lastRefreshTime!)}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppTheme.textSecondary.withOpacity(
                                        0.7,
                                      ),
                                      fontSize: 11,
                                    ),
                              ),
                          ],
                        ),
                      ),
                      if (!_isLoading)
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                              _errorMessage = null;
                            });
                            _loadCryptoData();
                          },
                          color: AppTheme.primaryColor,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              _errorMessage!,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(color: AppTheme.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (_errorMessage!.contains('Rate limit'))
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                left: 32,
                                right: 32,
                              ),
                              child: Text(
                                'The free API has request limits. Data refreshes every 2 minutes.',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppTheme.textSecondary.withOpacity(
                                        0.7,
                                      ),
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                _isLoading = true;
                                _errorMessage = null;
                              });
                              _loadCryptoData();
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : _cryptoData.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.currency_bitcoin,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No crypto data available',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pull down to refresh',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadCryptoData,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _cryptos.length,
                        itemBuilder: (context, index) {
                          final crypto = _cryptos[index];
                          final data = _cryptoData[crypto.id];

                          if (data == null) {
                            return const SizedBox.shrink();
                          }

                          return _buildCryptoCard(crypto, data);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCryptoCard(CryptoInfo crypto, CryptoData data) {
    final isPositive = data.change24h >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CryptoDetailView(crypto: crypto, data: data),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: crypto.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        crypto.symbol,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: crypto.color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          crypto.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          crypto.code,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${FormatUtils.formatAmount(data.currentPrice, decimals: 2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: changeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPositive
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 14,
                              color: changeColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${data.change24h.abs().toStringAsFixed(2)}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: changeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Mini Chart
              SizedBox(height: 60, child: _buildMiniChart(data, crypto.color)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniChart(CryptoData data, Color color) {
    if (data.history.isEmpty) {
      return const Center(child: Text('No data'));
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < data.history.length; i++) {
      final price = data.history[i]['price'] as double;
      spots.add(FlSpot(i.toDouble(), price));
    }

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: spots.length.toDouble() - 1,
        minY: spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) * 0.999,
        maxY: spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.001,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.black87,
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '\$${spot.y.toStringAsFixed(2)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  String _getTimeAgo(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}

// Detailed Crypto View Screen with Trading Chart
class CryptoDetailView extends StatefulWidget {
  final CryptoInfo crypto;
  final CryptoData data;

  const CryptoDetailView({super.key, required this.crypto, required this.data});

  @override
  State<CryptoDetailView> createState() => _CryptoDetailViewState();
}

class _CryptoDetailViewState extends State<CryptoDetailView> {
  ChartType _selectedChartType = ChartType.line;
  TimeRange _selectedTimeRange = TimeRange.day;

  // Generate data based on selected time range
  List<Map<String, dynamic>> _getFilteredHistory() {
    final baseHistory = widget.data.history;
    if (baseHistory.isEmpty) return [];

    final currentPrice = widget.data.currentPrice;
    final now = DateTime.now();

    switch (_selectedTimeRange) {
      case TimeRange.hour:
        // Generate 60 data points (1 per minute for last hour)
        return List.generate(60, (i) {
          final variance = (i % 10 - 5) * 0.002; // ±1% variance
          final price = currentPrice * (1 + variance);
          return {
            'timestamp': now
                .subtract(Duration(minutes: 60 - i))
                .millisecondsSinceEpoch,
            'price': price,
          };
        });

      case TimeRange.day:
        // Use existing 24-hour data
        return baseHistory;

      case TimeRange.week:
        // Generate 7 days of data (168 hours)
        return List.generate(168, (i) {
          final variance = (i % 20 - 10) * 0.003; // ±3% variance
          final trend = -0.0001 * (168 - i); // Slight upward trend
          final price = currentPrice * (1 + variance + trend);
          return {
            'timestamp': now
                .subtract(Duration(hours: 168 - i))
                .millisecondsSinceEpoch,
            'price': price,
          };
        });

      case TimeRange.month:
        // Generate 30 days of data (720 hours)
        return List.generate(120, (i) {
          final variance = (i % 15 - 7) * 0.005; // ±3.5% variance
          final trend = -0.0002 * (120 - i);
          final price = currentPrice * (1 + variance + trend);
          return {
            'timestamp': now
                .subtract(Duration(hours: (120 - i) * 6))
                .millisecondsSinceEpoch,
            'price': price,
          };
        });

      case TimeRange.year:
        // Generate 365 days of data (52 weeks)
        return List.generate(52, (i) {
          final variance = (i % 10 - 5) * 0.008; // ±4% variance
          final trend = -0.0003 * (52 - i);
          final price = currentPrice * (1 + variance + trend);
          return {
            'timestamp': now
                .subtract(Duration(days: (52 - i) * 7))
                .millisecondsSinceEpoch,
            'price': price,
          };
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = widget.data.change24h >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark trading theme
      appBar: AppBar(
        title: Text(widget.crypto.name),
        backgroundColor: const Color(0xFF2C2C2C),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () {
              // Add to favorites functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Share functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trading Header - Price and Stats
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF2C2C2C),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: widget.crypto.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            widget.crypto.symbol,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: widget.crypto.color,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.crypto.code,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              widget.crypto.name,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${FormatUtils.formatAmount(widget.data.currentPrice, decimals: 2)}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: changeColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isPositive
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              size: 14,
                              color: changeColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.data.change24h.abs().toStringAsFixed(2)}%',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: changeColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Quick Stats Row
                  _buildQuickStats(widget.data),
                ],
              ),
            ),

            // Chart Type Selector
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  _buildChartTypeButton(
                    'Line',
                    Icons.show_chart,
                    ChartType.line,
                  ),
                  _buildChartTypeButton(
                    'Area',
                    Icons.area_chart,
                    ChartType.area,
                  ),
                  _buildChartTypeButton('Bar', Icons.bar_chart, ChartType.bar),
                  _buildChartTypeButton(
                    'Candle',
                    Icons.candlestick_chart,
                    ChartType.candlestick,
                  ),
                ],
              ),
            ),

            // Time Range Selector
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildTimeRangeButton('1H', TimeRange.hour),
                  _buildTimeRangeButton('24H', TimeRange.day),
                  _buildTimeRangeButton('7D', TimeRange.week),
                  _buildTimeRangeButton('1M', TimeRange.month),
                  _buildTimeRangeButton('1Y', TimeRange.year),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Trading Chart
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Price Chart',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _selectedTimeRange.label,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: _buildTradingChart(
                      context,
                      widget.data,
                      widget.crypto.color,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Market Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Market Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatisticsGrid(context, widget.data),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(CryptoData data) {
    final prices = data.history.map((e) => e['price'] as double).toList();
    final highPrice = prices.reduce((a, b) => a > b ? a : b);
    final lowPrice = prices.reduce((a, b) => a < b ? a : b);

    return Row(
      children: [
        Expanded(
          child: _buildQuickStatItem(
            'High',
            '\$${FormatUtils.formatAmount(highPrice, decimals: 2)}',
            Colors.green,
          ),
        ),
        Expanded(
          child: _buildQuickStatItem(
            'Low',
            '\$${FormatUtils.formatAmount(lowPrice, decimals: 2)}',
            Colors.red,
          ),
        ),
        Expanded(
          child: _buildQuickStatItem(
            'Vol',
            '${(data.currentPrice * 1000000).toStringAsFixed(0)}',
            Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.white38),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildChartTypeButton(String label, IconData icon, ChartType type) {
    final isSelected = _selectedChartType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedChartType = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? widget.crypto.color.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? widget.crypto.color : Colors.white38,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? widget.crypto.color : Colors.white38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeRangeButton(String label, TimeRange range) {
    final isSelected = _selectedTimeRange == range;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTimeRange = range;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? widget.crypto.color.withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? widget.crypto.color : Colors.white38,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTradingChart(
    BuildContext context,
    CryptoData data,
    Color color,
  ) {
    // Use filtered history based on selected time range
    final filteredData = CryptoData(
      currentPrice: data.currentPrice,
      change24h: data.change24h,
      history: _getFilteredHistory(),
    );

    switch (_selectedChartType) {
      case ChartType.line:
        return _buildLineChart(filteredData, color);
      case ChartType.area:
        return _buildAreaChart(filteredData, color);
      case ChartType.bar:
        return _buildBarChart(filteredData, color);
      case ChartType.candlestick:
        return _buildCandlestickChart(filteredData, color);
    }
  }

  Widget _buildLineChart(CryptoData data, Color color) {
    if (data.history.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < data.history.length; i++) {
      final price = data.history[i]['price'] as double;
      spots.add(FlSpot(i.toDouble(), price));
    }

    final minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) * 0.998;
    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.002;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: (maxY - minY) / 5,
          verticalInterval: (spots.length / 6).toDouble(),
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withOpacity(0.15), // Increased from 0.05
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return FlLine(
              color: Colors.white.withOpacity(0.1), // Increased from 0.05
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                  ), // Increased from white38
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (spots.length / 4).toDouble(),
              getTitlesWidget: (value, meta) {
                final hours = value.toInt();
                if (hours >= 0 && hours < data.history.length) {
                  return Text(
                    '${hours}h',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                    ), // Increased from white38
                  );
                }
                return const Text('');
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ), // Increased from 0.1
        ),
        minX: 0,
        maxX: spots.length.toDouble() - 1,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 3, // Increased from 2 for better visibility
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => color.withOpacity(0.9),
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '\$${spot.y.toStringAsFixed(2)}\n${spot.x.toInt()}h',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAreaChart(CryptoData data, Color color) {
    if (data.history.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < data.history.length; i++) {
      final price = data.history[i]['price'] as double;
      spots.add(FlSpot(i.toDouble(), price));
    }

    final minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b) * 0.998;
    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) * 1.002;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withOpacity(0.15), // Increased visibility
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                  ), // Increased visibility
                );
              },
            ),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ), // Added border for clarity
        ),
        minX: 0,
        maxX: spots.length.toDouble() - 1,
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.4),
                  color.withOpacity(0.1),
                  color.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => color.withOpacity(0.9),
            tooltipPadding: const EdgeInsets.all(8),
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(CryptoData data, Color color) {
    if (data.history.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }

    final barGroups = <BarChartGroupData>[];
    final prices = data.history.map((e) => e['price'] as double).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);

    for (int i = 0; i < data.history.length; i++) {
      final price = data.history[i]['price'] as double;
      final barColor = i > 0 && price >= prices[i - 1]
          ? Colors.green
          : Colors.red;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: price - minPrice,
              color: barColor,
              width: 4,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(2),
              ),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: prices.reduce((a, b) => a > b ? a : b) - minPrice,
        barGroups: barGroups,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withOpacity(0.15), // Increased visibility
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${(value + minPrice).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                  ), // Increased visibility
                );
              },
            ),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ), // Added border
        ),
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => color.withOpacity(0.9),
            tooltipPadding: const EdgeInsets.all(8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '\$${(rod.toY + minPrice).toStringAsFixed(2)}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCandlestickChart(CryptoData data, Color color) {
    // For candlestick, we'll create a simplified version using bar chart
    // since fl_chart doesn't have native candlestick support
    if (data.history.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.white38),
        ),
      );
    }

    final prices = data.history.map((e) => e['price'] as double).toList();
    final barGroups = <BarChartGroupData>[];

    // Group data into 6 candles
    final candleSize = (data.history.length / 6).floor();

    for (int i = 0; i < 6; i++) {
      final start = i * candleSize;
      final end = (i + 1) * candleSize < prices.length
          ? (i + 1) * candleSize
          : prices.length;

      if (start >= prices.length) break;

      final candlePrices = prices.sublist(start, end);
      final open = candlePrices.first;
      final close = candlePrices.last;
      final high = candlePrices.reduce((a, b) => a > b ? a : b);
      final low = candlePrices.reduce((a, b) => a < b ? a : b);

      final isGreen = close >= open;
      final candleColor = isGreen ? Colors.green : Colors.red;

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              fromY: low,
              toY: high,
              color: candleColor.withOpacity(0.3),
              width: 2,
            ),
            BarChartRodData(
              fromY: open < close ? open : close,
              toY: open < close ? close : open,
              color: candleColor,
              width: 8,
            ),
          ],
        ),
      );
    }

    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxPrice * 1.002,
        minY: minPrice * 0.998,
        barGroups: barGroups,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.white.withOpacity(0.15), // Increased visibility
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(
                  '\$${value.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white70,
                  ), // Increased visibility
                );
              },
            ),
          ),
          bottomTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ), // Increased visibility
        ),
        barTouchData: BarTouchData(enabled: false),
      ),
    );
  }

  Widget _buildStatisticsGrid(BuildContext context, CryptoData data) {
    final prices = data.history.map((e) => e['price'] as double).toList();
    final highPrice = prices.reduce((a, b) => a > b ? a : b);
    final lowPrice = prices.reduce((a, b) => a < b ? a : b);
    final avgPrice = prices.reduce((a, b) => a + b) / prices.length;
    final priceRange = highPrice - lowPrice;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.8,
      children: [
        _buildStatCard(
          context,
          'High (24h)',
          '\$${FormatUtils.formatAmount(highPrice, decimals: 2)}',
          Icons.arrow_upward,
          Colors.green,
        ),
        _buildStatCard(
          context,
          'Low (24h)',
          '\$${FormatUtils.formatAmount(lowPrice, decimals: 2)}',
          Icons.arrow_downward,
          Colors.red,
        ),
        _buildStatCard(
          context,
          'Average',
          '\$${FormatUtils.formatAmount(avgPrice, decimals: 2)}',
          Icons.show_chart,
          Colors.blue,
        ),
        _buildStatCard(
          context,
          'Range',
          '\$${FormatUtils.formatAmount(priceRange, decimals: 2)}',
          Icons.swap_vert,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: Colors.white38),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// Enums for chart types and time ranges
enum ChartType { line, area, bar, candlestick }

enum TimeRange {
  hour,
  day,
  week,
  month,
  year;

  String get label {
    switch (this) {
      case TimeRange.hour:
        return '1 Hour';
      case TimeRange.day:
        return '24 Hours';
      case TimeRange.week:
        return '7 Days';
      case TimeRange.month:
        return '1 Month';
      case TimeRange.year:
        return '1 Year';
    }
  }
}

class CryptoInfo {
  final String id;
  final String code;
  final String name;
  final String symbol;
  final Color color;

  CryptoInfo(this.id, this.code, this.name, this.symbol, this.color);
}

class CryptoData {
  final double currentPrice;
  final double change24h;
  final List<Map<String, dynamic>> history;

  CryptoData({
    required this.currentPrice,
    required this.change24h,
    required this.history,
  });
}
