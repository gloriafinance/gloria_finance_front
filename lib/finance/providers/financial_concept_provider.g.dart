// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_concept_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchFinancialConceptsHash() =>
    r'b48e5f63874dd35eca40c6daa63d898a2340118f';

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

/// See also [searchFinancialConcepts].
@ProviderFor(searchFinancialConcepts)
const searchFinancialConceptsProvider = SearchFinancialConceptsFamily();

/// See also [searchFinancialConcepts].
class SearchFinancialConceptsFamily
    extends Family<AsyncValue<List<FinancialConceptModel>>> {
  /// See also [searchFinancialConcepts].
  const SearchFinancialConceptsFamily();

  /// See also [searchFinancialConcepts].
  SearchFinancialConceptsProvider call(
    FinancialConceptType? type,
  ) {
    return SearchFinancialConceptsProvider(
      type,
    );
  }

  @override
  SearchFinancialConceptsProvider getProviderOverride(
    covariant SearchFinancialConceptsProvider provider,
  ) {
    return call(
      provider.type,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'searchFinancialConceptsProvider';
}

/// See also [searchFinancialConcepts].
class SearchFinancialConceptsProvider
    extends FutureProvider<List<FinancialConceptModel>> {
  /// See also [searchFinancialConcepts].
  SearchFinancialConceptsProvider(
    FinancialConceptType? type,
  ) : this._internal(
          (ref) => searchFinancialConcepts(
            ref as SearchFinancialConceptsRef,
            type,
          ),
          from: searchFinancialConceptsProvider,
          name: r'searchFinancialConceptsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$searchFinancialConceptsHash,
          dependencies: SearchFinancialConceptsFamily._dependencies,
          allTransitiveDependencies:
              SearchFinancialConceptsFamily._allTransitiveDependencies,
          type: type,
        );

  SearchFinancialConceptsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final FinancialConceptType? type;

  @override
  Override overrideWith(
    FutureOr<List<FinancialConceptModel>> Function(
            SearchFinancialConceptsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SearchFinancialConceptsProvider._internal(
        (ref) => create(ref as SearchFinancialConceptsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  FutureProviderElement<List<FinancialConceptModel>> createElement() {
    return _SearchFinancialConceptsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SearchFinancialConceptsProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SearchFinancialConceptsRef
    on FutureProviderRef<List<FinancialConceptModel>> {
  /// The parameter `type` of this provider.
  FinancialConceptType? get type;
}

class _SearchFinancialConceptsProviderElement
    extends FutureProviderElement<List<FinancialConceptModel>>
    with SearchFinancialConceptsRef {
  _SearchFinancialConceptsProviderElement(super.provider);

  @override
  FinancialConceptType? get type =>
      (origin as SearchFinancialConceptsProvider).type;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
