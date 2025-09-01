import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'detailsformation.dart';

class EncoursPage extends StatelessWidget {
  final List<String> formations;
  final List<String> descriptions;
  final List<double> progressions;
  final String searchQuery;

  const EncoursPage({
    Key? key,
    required this.formations,
    required this.descriptions,
    required this.progressions,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filtrer les formations en cours
    final filteredIndices = List.generate(formations.length, (i) {
      final matchesSearch =
          formations[i].toLowerCase().contains(searchQuery.toLowerCase());
      return matchesSearch && progressions[i] < 1.0 ? i : -1;
    }).where((i) => i != -1).toList();

    return ListView.builder(
      itemCount: filteredIndices.length,
      itemBuilder: (context, index) {
        final i = filteredIndices[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FormationDetailsPage()),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formations[i],
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF23468E)),
                ),
                const SizedBox(height: 4),
                Text(
                  descriptions[i],
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                LinearPercentIndicator(
                  lineHeight: 6.0,
                  percent: progressions[i],
                  backgroundColor: Colors.grey[300]!,
                  progressColor: const Color(0xFF23468E),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}