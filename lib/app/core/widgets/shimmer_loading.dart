// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';

// /// Beautiful Shimmer loading widget for currency cards - Clean & Aligned
// class CurrencyCardShimmer extends StatelessWidget {
//   const CurrencyCardShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       period: const Duration(milliseconds: 1500),
//       child: Card(
//         elevation: 2,
//         margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               // Flag/Icon placeholder
//               Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               // Text content
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 18,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Container(
//                       width: 120,
//                       height: 14,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Container(
//                       width: 100,
//                       height: 12,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // Favorite icon placeholder
//               Container(
//                 width: 24,
//                 height: 24,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   shape: BoxShape.circle,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Beautiful Shimmer for list items - Clean & Aligned
// class ListItemShimmer extends StatelessWidget {
//   const ListItemShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       period: const Duration(milliseconds: 1500),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     height: 16,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Container(
//                     width: 120,
//                     height: 12,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 12),
//             Container(
//               width: 60,
//               height: 24,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Beautiful Shimmer for charts - Clean & Aligned
// class ChartShimmer extends StatelessWidget {
//   const ChartShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       period: const Duration(milliseconds: 1800),
//       child: Container(
//         height: 300,
//         margin: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           children: [
//             // Time period buttons
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: List.generate(
//                   4,
//                   (index) => Container(
//                     width: 70,
//                     height: 32,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // Chart bars
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: List.generate(12, (index) {
//                     final heights = [
//                       100.0,
//                       120.0,
//                       80.0,
//                       150.0,
//                       90.0,
//                       130.0,
//                       110.0,
//                       95.0,
//                       140.0,
//                       105.0,
//                       125.0,
//                       115.0,
//                     ];
//                     return Container(
//                       width: 16,
//                       height: heights[index % heights.length],
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: const BorderRadius.vertical(
//                           top: Radius.circular(8),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Beautiful Shimmer for converter screen - Clean & Aligned
// class ConverterShimmer extends StatelessWidget {
//   const ConverterShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       period: const Duration(milliseconds: 1600),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             // From Currency Card
//             _buildCurrencyShimmerCard(),
//             const SizedBox(height: 20),
//             // Swap Button
//             Container(
//               width: 56,
//               height: 56,
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 shape: BoxShape.circle,
//               ),
//             ),
//             const SizedBox(height: 20),
//             // To Currency Card
//             _buildCurrencyShimmerCard(),
//             const SizedBox(height: 30),
//             // Convert Button
//             Container(
//               width: double.infinity,
//               height: 56,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildCurrencyShimmerCard() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       width: 80,
//                       height: 14,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Container(
//                       width: 120,
//                       height: 12,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(4),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           Container(
//             width: double.infinity,
//             height: 24,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// /// Beautiful Shimmer for calculator grid - Clean & Aligned
// class CalculatorGridShimmer extends StatelessWidget {
//   const CalculatorGridShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       period: const Duration(milliseconds: 1500),
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         padding: const EdgeInsets.all(16),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 1.5,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//         ),
//         itemCount: 6,
//         itemBuilder: (context, index) {
//           return Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 const Spacer(),
//                 Container(
//                   width: double.infinity,
//                   height: 14,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//                 const SizedBox(height: 6),
//                 Container(
//                   width: 80,
//                   height: 10,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// /// Generic shimmer loading widget - Clean & Aligned
// class ShimmerLoading extends StatelessWidget {
//   final double? width;
//   final double? height;
//   final BorderRadius? borderRadius;
//   final bool isCircle;

//   const ShimmerLoading({
//     super.key,
//     this.width,
//     this.height,
//     this.borderRadius,
//     this.isCircle = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       period: const Duration(milliseconds: 1500),
//       child: Container(
//         width: width,
//         height: height ?? 20,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: isCircle
//               ? null
//               : (borderRadius ?? BorderRadius.circular(8)),
//           shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
//         ),
//       ),
//     );
//   }
// }

// /// Beautiful Shimmer for crypto market cards - Clean & Aligned
// class CryptoCardShimmer extends StatelessWidget {
//   const CryptoCardShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       period: const Duration(milliseconds: 1500),
//       child: Card(
//         margin: const EdgeInsets.only(bottom: 16),
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               Row(
//                 children: [
//                   // Crypto icon
//                   Container(
//                     width: 48,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   // Name and code
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           width: 100,
//                           height: 16,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                         ),
//                         const SizedBox(height: 6),
//                         Container(
//                           width: 60,
//                           height: 12,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Price and change
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Container(
//                         width: 80,
//                         height: 16,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(4),
//                         ),
//                       ),
//                       const SizedBox(height: 6),
//                       Container(
//                         width: 60,
//                         height: 24,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               // Mini chart placeholder
//               Container(
//                 width: double.infinity,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
