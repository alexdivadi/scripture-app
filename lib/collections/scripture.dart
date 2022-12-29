import 'package:isar/isar.dart';
import 'package:scripture_app/collections/scripturelist.dart';
part 'scripture.g.dart';

@collection
class Scripture{
  Id scriptureId = Isar.autoIncrement;

  late String reference;
  late String text;
  late String translation;

  final collection = IsarLink<ScriptureList>();
}
