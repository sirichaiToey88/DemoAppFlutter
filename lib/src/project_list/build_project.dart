import 'package:flutter/material.dart';

class ProjectHeadItem extends StatelessWidget {
  final String projectName;
  final String description;

  const ProjectHeadItem(this.projectName, this.description, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        projectName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(description),
    );
  }
}
