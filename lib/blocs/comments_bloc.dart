import 'package:news_sqlite/model/item_model.dart';
import 'package:news_sqlite/resource/repo.dart';
import 'package:rxdart/rxdart.dart';

class CommentsBloc {
  final _repo = Repo();
  final _commentFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel>>>();

  //STREAMS
  Stream<Map<int, Future<ItemModel>>> get itemWithComments =>
      _commentsOutput.stream;

  //SINKS
  Function(int) get fetchItemWithComments => _commentFetcher.sink.add;

  //Cnstructor
  CommentsBloc() {
    _commentFetcher.stream
        .transform(_commentTransformer())
        .pipe(_commentsOutput);
  }
  _commentTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, index) {
        cache[id] = _repo.fetchItem(id);
        cache[id].then((ItemModel item) =>
            item.kids.forEach((kidId) => fetchItemWithComments(kidId)));
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _commentFetcher.close();
    _commentsOutput.close();
  }
}
