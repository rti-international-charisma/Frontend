import 'package:contentful/contentful.dart';
import 'page.dart';


class PageRepository {
  PageRepository(this.contentful);
  final Client contentful;

  Future<Page> findByPageId(String pageId) async {
    final collection = await contentful.getEntries<Page>({
      'content_type': 'homePage',
      'fields.pageid': pageId,
      'limit': '1',
      'include': '10',
    }, Page.fromJson);

    return collection.items.first;
  }
}

Future<void> main() async {
  //c0JOePfprGTcMTvUcYT3pwvEtmKm0nY7sAV5G1Dq01Q
  final repo = PageRepository(Client('5lkmroeaw7nj', 'c0JOePfprGTcMTvUcYT3pwvEtmKm0nY7sAV5G1Dq01Q'));
  final page = await repo.findByPageId('charisma-home');
  print('Title: ${page.fields.title}');
}
