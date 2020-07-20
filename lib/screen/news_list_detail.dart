import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_sqlite/blocs/comments_bloc.dart';
import 'package:news_sqlite/model/item_model.dart';
import 'package:news_sqlite/widget/comment.dart';
import 'package:provider/provider.dart';

class NewsListDetail extends StatelessWidget {
  int itemID;
  NewsListDetail({this.itemID = 0});

  @override
  Widget build(BuildContext context) {
    final commentBloc = context.watch<CommentsBloc>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CupertinoColors.systemGrey6,
        title: Text(
          "NewsDetail",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: buildStream(commentBloc),
    );
  }

  Widget buildStream(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CupertinoActivityIndicator(radius: 20));
        }
        final itemFuture = snapshot.data[itemID];
        return FutureBuilder(
          future: itemFuture,
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            return buildDetail(itemSnapshot.data, snapshot.data);
          },
        );
      },
    );
  }

  Widget buildDetail(ItemModel item, Map<int, Future<ItemModel>> itemMap) {
    final widgetList = <Widget>[];
    widgetList.add(buildTitle(item));
    final commentList = item.kids.map((kidID) {
      return Comments(
        itemID: kidID,
        itemMap: itemMap,
        depth: 0,
      );
    });
    widgetList.addAll(commentList);

    return ListView(
      children: widgetList,
    );
  }

  Widget buildTitle(ItemModel item) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.all(8),
      child: Text(
        item.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
        ),
      ),
    );
  }
}
