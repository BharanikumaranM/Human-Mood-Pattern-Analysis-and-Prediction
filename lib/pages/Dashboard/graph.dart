import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Graph extends StatefulWidget {
  const Graph({super.key});

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
              child: PieChart(
                  swapAnimationDuration: const Duration(seconds: 1),
                  swapAnimationCurve: Curves.easeInOutQuint,
                  PieChartData(
                      // pieTouchData: PieTouchData(
                      //   touchCallback: tapOnPieChart,
                      // ),
                      sections: [
                        PieChartSectionData(value: 25, color: Colors.red),
                        PieChartSectionData(value: 25, color: Colors.blue),
                        PieChartSectionData(
                            value: 25, color: Colors.orangeAccent),
                        PieChartSectionData(value: 25, color: Colors.yellow),
                        PieChartSectionData(value: 25, color: Colors.green),
                      ])),
            )
          ],
        ),
      ),
    );
  }
}
