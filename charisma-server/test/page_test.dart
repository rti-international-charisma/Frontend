
import 'package:charisma_server/content.dart';
import 'package:test/test.dart';
import 'package:contentful/contentful.dart';

void main() {

  test('it should test', () async {
    final repo = PageRepository(Client('5lkmroeaw7nj', 'c0JOePfprGTcMTvUcYT3pwvEtmKm0nY7sAV5G1Dq01Q'));
    final page = await repo.findByPageId('charisma-home');
    print('Title: ${page.fields.title}');
  });
}