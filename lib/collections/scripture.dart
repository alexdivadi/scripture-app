import 'package:isar/isar.dart';
part 'scripture.g.dart';

@collection
class Scripture{
  Id scriptureId = Isar.autoIncrement;

  late String reference;
  late String text;
  late String translation;

  @Index()
  String listName = "default";
}