import 'package:flutter/material.dart';
import 'package:news_sqlite/blocs/comments_bloc.dart';
import 'package:news_sqlite/screen/news_list_detail.dart';
import 'package:provider/provider.dart';
import 'package:news_sqlite/screen/news_list.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider(create: (_) => StoriesBloc()),
        Provider(create: (_) => CommentsBloc()),
//        ChangeNotifierProvider(create: (_) => AttendanceData()),
      ],
//    return StoriesProvider(
      child: MaterialApp(
        title: "News API",
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(builder: (context) {
              context.watch<StoriesBloc>().fetchTopIds();
              return NewsList();
            });
          } else {
            return MaterialPageRoute(builder: (context) {
              final commentsBloc = context.watch<CommentsBloc>();
              final itemId = int.parse(settings.name.replaceAll('/', ''));
              commentsBloc.fetchItemWithComments(itemId);
              return NewsListDetail(itemID: itemId);
            });
          }
        },
      ),
    );
  }
}
