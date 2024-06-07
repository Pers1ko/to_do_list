// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';


part 'group.g.dart';

@HiveType(typeId: 1)
class Group extends HiveObject{
// last used HiveField key 1
@HiveField(0)
  String name;


  Group({
    required this.name,

  });
}