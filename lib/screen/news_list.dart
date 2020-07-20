import 'package:flutter/cupertino.dart' as ios;
import 'package:flutter/material.dart';
import 'package:news_sqlite/blocs/stories_bloc.dart';
export 'package:news_sqlite/blocs/stories_bloc.dart';
import 'package:news_sqlite/widget/news_list_tile.dart';
import 'package:provider/provider.dart';

class NewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<StoriesBloc>();
    return Scaffold(
      appBar: AppBar(
        title: Text("News API"),
      ),
      body: buildList(bloc),
    );
    //      child: ApiData(),
    return Scaffold(
      appBar: AppBar(
        title: Text("News API"),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc _bloc) {
    return StreamBuilder(
      stream: _bloc.topIds,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: ios.CupertinoActivityIndicator());

        return RefreshIndicator(
          onRefresh: () async {
            await _bloc.clearCache();
            await _bloc.fetchTopIds();
          },
          child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                _bloc.fetchItem(snapshot.data[index]);

                return NewsListTile(
                  itemId: snapshot.data[index],
                );
              }),
        );
      },
    );
  }

  Widget ApiData() {
    return ListView.builder(
        itemCount: 500,
        itemBuilder: (context, int index) {
          return FutureBuilder(
            future: Future.delayed(Duration(seconds: 2), () => 'hi'),
            builder: (context, snapshot) {
              return Text(snapshot.hasData
                  ? "I'm HERE $index"
                  : "I'm NOT FETCH YET $index");
            },
          );
        });
  }
}
