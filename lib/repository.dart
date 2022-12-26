

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'repository.g.dart';

@Riverpod(keepAlive: true)
Repository repository(RepositoryRef ref) => Repository();
class Repository {
  //https://codewithandrea.com/articles/flutter-riverpod-data-caching-providers-lifecycle/

  // TODO: Isar and Dio both as dependencies
}