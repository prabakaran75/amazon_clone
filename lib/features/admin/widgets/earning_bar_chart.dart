import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EarningBarChart extends StatelessWidget {
  final List<Sales> earnings;
  const EarningBarChart({super.key, required this.earnings});

  @override
  Widget build(BuildContext context) {
    if (earnings.isEmpty) {
      return const Center(child: Text("No earnings data"));
    }
    return AspectRatio(
      aspectRatio: 1.4,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _getMaxY(),
          // ---- AXIS TITLES ----
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: _getInterval(),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _bottomTiles,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          // ---- GRID ----
          gridData: FlGridData(show: true),
          // ---- BORDER ----
          borderData: FlBorderData(show: false),
          // ---- BARS ----
          barGroups: _barGroups(),
        ),
      ),
    );
  }

  // ---------------- COLORS ----------------
  Color getBarColor(String label) {
    switch (label) {
      case "Mobiles":
        return Colors.blue;
      case "Essentials":
        return Colors.green;
      case "Appliances":
        return Colors.orange;
      case "Books":
        return Colors.purple;
      case "Fashion":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Convert sales to bars
  List<BarChartGroupData> _barGroups() {
    return List.generate(earnings.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: earnings[index].earning.toDouble(),
            color: getBarColor(earnings[index].label),
            width: 18,
            borderRadius: BorderRadius.circular(5),
          ),
        ],
      );
    });
  }

  /// X-axis labels
  Widget _bottomTiles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index < 0 || index >= earnings.length) return SizedBox();
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Text(
        earnings[index].label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }

  /// Calculate max Y dynamically
  double _getMaxY() {
    final max = earnings.map((e) => e.earning).reduce((a, b) => a > b ? a : b);
    if (max == 0) {
      return 5; // 👈 so bars have visible height
    }
    return (max * 1.2).toDouble(); // add 20% space
  }

  // ---------------- INTERVAL ----------------
  double _getInterval() {
    final max = earnings.map((e) => e.earning).reduce((a, b) => a > b ? a : b);
    if (max == 0) {
      return 1; // 👈 IMPORTANT fallback
    }
    return (max / 5).ceilToDouble();
  }
}
