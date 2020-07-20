import 'package:flutter/material.dart';
import 'package:news_sqlite/model/item_model.dart';
import 'package:news_sqlite/widget/loading_container.dart';

class Comments extends StatelessWidget {
  final int itemID;
  final double depth;
  final Map<int, Future<ItemModel>> itemMap;

  Comments({this.itemID, this.itemMap, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemID],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData)
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8),
            child: singleLineLoadingContainer(150),
          );
        final item = snapshot.data;
        final childrenList = <Widget>[
          CommentWidget(
            indentab: depth * 20,
//            thumbnail: CircleAvatar(
//              radius: indent > 0 ? 15 : 20,
//              backgroundColor: Colors.grey,
//            ),
            title: item.by,
            titleSize: 18,
            subtitle: item.text == "" ? "Deleted" : ReplaceHtmlTag(item.text),
          ),
        ];

        item.kids.forEach((kidId) {
          childrenList.add(Comments(
            itemID: kidId,
            itemMap: itemMap,
            depth: depth + 1,
          ));
        });

        return Column(
          children: childrenList,
        );
      },
    );
  }
}

String ReplaceHtmlTag(String text) {
  return text
      .replaceAll('&#x27', "'")
      .replaceAll('<p>', '\n\n')
      .replaceAll("</p>", '');
}

class CommentWidget extends StatelessWidget {
  final Widget thumbnail;
  final String title, subtitle, date;
  final double titleSize, subtitleSize, dateSize, indentab;

  CommentWidget({
    this.thumbnail,
    @required this.title,
    this.subtitle = '',
    this.date = '',
    this.titleSize = 20.0,
    this.subtitleSize = 15.0,
    this.dateSize = 15.0,
    this.indentab = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: indentab),
          thumbnail ?? SizedBox(),
          Expanded(
            child: Container(
                padding: const EdgeInsets.fromLTRB(8.0, 0.0, 5.0, 0.0),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: Colors.black,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '$title ',
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(text: subtitle),
                    ],
                  ),
                )

//              Column(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.stretch,
//                children: <Widget>[
//                  Row(
//                    children: <Widget>[
//                      Text(
//                        '$title',
//                        maxLines: 2,
//                        overflow: TextOverflow.ellipsis,
//                        style: TextStyle(
//                          fontSize: titleSize,
//                          fontWeight: FontWeight.bold,
//                        ),
//                      ),
//                      SizedBox(width: 10),
//                      Text(
//                        '$date',
//                        maxLines: 1,
//                        overflow: TextOverflow.ellipsis,
//                        style: TextStyle(
//                          fontSize: dateSize,
//                          color: Colors.black54,
//                        ),
//                      ),
//                    ],
//                  ),
//                  SizedBox(height: 5),
//                  Text(
//                    '$subtitle',
//                    textAlign: TextAlign.justify,
//                    style: TextStyle(
//                      fontSize: subtitleSize,
//                      color: Colors.black,
//                    ),
//                  ),
//                ],
//              ),
                ),
          ),
        ],
      ),
    );
  }
}
