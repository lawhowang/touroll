import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Pagination {
  static const _pageSize = 10;
  Future<void> fetchPage(Future<List<dynamic>> source,
      PagingController<int, dynamic> controller, int lastId) async {
    try {
      final newItems = await source;
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        controller.appendLastPage(newItems);
      } else {
        final nextLastId = newItems[newItems.length - 1].id;
        controller.appendPage(newItems, nextLastId);
      }
    } catch (error) {
      print(error);
      controller.error = error;
    }
  }
}
