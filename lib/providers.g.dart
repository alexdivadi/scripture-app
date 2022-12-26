// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

String $databaseHash() => r'9773d98ade973283230fc9ba362813796cdeed6e';

/// See also [database].
final databaseProvider = Provider<Database>(
  database,
  name: r'databaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : $databaseHash,
);
typedef DatabaseRef = ProviderRef<Database>;
String $getResultHash() => r'aa3d154cc74e8f5a14f6ff89d9f68918604b5b88';

/// See also [getResult].
class GetResultProvider extends AutoDisposeFutureProvider<void> {
  GetResultProvider(
    this.text,
    this.currentList,
  ) : super(
          (ref) => getResult(
            ref,
            text,
            currentList,
          ),
          from: getResultProvider,
          name: r'getResultProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : $getResultHash,
        );

  final String text;
  final String currentList;

  @override
  bool operator ==(Object other) {
    return other is GetResultProvider &&
        other.text == text &&
        other.currentList == currentList;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, text.hashCode);
    hash = _SystemHash.combine(hash, currentList.hashCode);

    return _SystemHash.finish(hash);
  }
}

typedef GetResultRef = AutoDisposeFutureProviderRef<void>;

/// See also [getResult].
final getResultProvider = GetResultFamily();

class GetResultFamily extends Family<AsyncValue<void>> {
  GetResultFamily();

  GetResultProvider call(
    String text,
    String currentList,
  ) {
    return GetResultProvider(
      text,
      currentList,
    );
  }

  @override
  AutoDisposeFutureProvider<void> getProviderOverride(
    covariant GetResultProvider provider,
  ) {
    return call(
      provider.text,
      provider.currentList,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'getResultProvider';
}
