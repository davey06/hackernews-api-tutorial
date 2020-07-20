import 'package:flutter/material.dart';

Widget singleLineLoadingContainer(double width) {
  return Container(
    color: Colors.grey[200],
    height: 24,
    width: width,
    margin: EdgeInsets.only(top: 5, bottom: 5),
  );
}

class ListTileLoadingContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: singleLineLoadingContainer(150),
          subtitle: singleLineLoadingContainer(50),
          trailing: singleLineLoadingContainer(20),
        ),
        Divider(
          height: 8,
          thickness: 2,
        )
      ],
    );
  }
}
