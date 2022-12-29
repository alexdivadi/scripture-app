import 'package:isar/isar.dart';
import 'package:scripture_app/collections/scripture.dart';
part 'scripturelist.g.dart';

@collection
class ScriptureList {
  Id scriptureListId = Isar.autoIncrement;

  @Index(unique: true)
  late String name;

  @Backlink(to:"collection")
  final scriptures = IsarLinks<Scripture>();
}
