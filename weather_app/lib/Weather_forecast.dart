import "package:flutter/material.dart";

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icons;
  final String temp;
  const HourlyForecastItem({
    super.key,
    required this.time,
    required this.icons,
    required this.temp,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 100,
      width: 100,
      child: Card(
        elevation: 6,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(children: [
            Text(
              time,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icons,
              size: 32,
            ),
            Text(temp),
          ]),
        ),
      ),
    );
  }
}
