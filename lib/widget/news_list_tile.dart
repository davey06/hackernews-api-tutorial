import 'package:flutter/material.dart';
import 'package:news_sqlite/blocs/stories_bloc.dart';
import 'package:news_sqlite/model/item_model.dart';
import 'package:news_sqlite/widget/loading_container.dart';
import 'package:provider/provider.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;
  NewsListTile({this.itemId});

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<StoriesBloc>();
    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return ListTileLoadingContainer();
        }
        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return ListTileLoadingContainer();
            }
            return tileUI(context, itemSnapshot.data);
          },
        );
      },
    );
  }

  Widget tileUI(BuildContext context, ItemModel item) {
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/${item.id}');
          },
          title: Text(item.title),
          subtitle:
              Text('${item.score} ' + (item.score > 1 ? 'votes' : 'vote')),
          trailing: Container(
            child: Column(
              children: <Widget>[
                Icon(Icons.comment),
                Text(
                  '${item.descendants ?? 0}',
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
        ),
        Divider(
          height: 8,
          thickness: 2,
        ),
      ],
    );
  }
}
