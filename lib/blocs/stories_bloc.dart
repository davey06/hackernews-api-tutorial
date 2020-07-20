import 'package:flutter/cupertino.dart';
import 'package:news_sqlite/model/item_model.dart';
import 'package:news_sqlite/resource/repo.dart';
import 'package:rxdart/rxdart.dart';

class StoriesBloc extends ChangeNotifier {
  final _repo = Repo();
  final _topIds = PublishSubject<List<int>>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemsFetcher = PublishSubject<int>();

  //GETTER
  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel>>> get items => _itemsOutput.stream;
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  StoriesBloc() {
    _itemsFetcher.stream.transform(_itemTransformer()).pipe(_itemsOutput);
  }

  fetchTopIds() async {
    final ids = await _repo.fetchTopIds();
    _topIds.sink.add(ids);
  }

  clearCache() {
    return _repo.clearCache();
  }

  _itemTransformer() {
    return ScanStreamTransformer(
      //cache harus di declare type nya biar gak errorr//
      (Map<int, Future<ItemModel>> cache, int id, index) {
//        print(index);
        cache[id] = _repo.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _topIds.close();
    _itemsOutput.close();
    _itemsFetcher.close();
  }
}
