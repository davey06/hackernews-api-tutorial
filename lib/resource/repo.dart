import 'package:news_sqlite/resource/news_api_provider.dart';
import 'package:news_sqlite/resource/news_db_provider.dart';

import '../model/item_model.dart';

final newsDbProvider = NewsdbProvider();

class Repo {
//  NewsApiProvider apiProvider = NewsApiProvider();
//  NewsdbProvider dbProvider = NewsdbProvider();

  List<Source> sources = <Source>[
    newsDbProvider,
    NewsApiProvider(),
  ];

  List<Cache> caches = <Cache>[
    newsDbProvider,
  ];

  Future<List<int>> fetchTopIds() async {
    List<int> ids;
    for (Source source in sources) {
      ids = await source.fetchTopIds();
      if (ids != null) break;
    }

    return ids;
  }

  Future<ItemModel> fetchItem(int _id) async {
    ItemModel item;
    var source;
    for (source in sources) {
      item = await source.fetchItem(_id);
      if (item != null) break;
    }

    for (var cache in caches) {
      if (cache != source) cache.addItem(item);
    }

    return item;
  }

  clearCache() async {
    for (var cache in caches) {
      await cache.clear();
    }
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int _id);
}

abstract class Cache {
  Future<int> addItem(ItemModel item);
  Future<int> clear();
}
