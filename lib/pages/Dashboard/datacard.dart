import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String location;
  final String img1;
  final String timestamp; // Add timestamp parameter

  const CustomCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.location,
    required this.img1,
    required this.timestamp, // Include timestamp parameter
  });

  @override
  // ignore: library_private_types_in_public_api
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: const BorderSide(
          color: Color.fromARGB(255, 231, 228, 228),
          width: 1.0,
        ),
      ),
      elevation: 1,
      margin: const EdgeInsets.all(10),
      child: ExpansionTile(
        onExpansionChanged: (expanded) {
          setState(() {
            isExpanded = expanded;
          });
        },
        leading: SizedBox(
          width: 40,
          height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Image.network(
              widget.img1,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              isExpanded
                  ? Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  : Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
              const Spacer(),
              Text(
                widget.timestamp, // Display the timestamp
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey, // Adjust the text color as needed
                ),
              ),
            ],
          ),
        ),
        trailing: isExpanded ? null : const Icon(Icons.keyboard_arrow_down),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.subtitle,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.location,
                      style: const TextStyle(
                        color: Colors.grey, // Adjust the text color as needed
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
