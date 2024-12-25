// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contributions_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$contributionServiceHash() =>
    r'fbb03b86ed65c7dbaddef1dedc257634ff5770ac';

/// See also [ContributionService].
@ProviderFor(ContributionService)
final contributionServiceProvider = NotifierProvider<ContributionService,
    PaginateResponse<Contribution>>.internal(
  ContributionService.new,
  name: r'contributionServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contributionServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ContributionService = Notifier<PaginateResponse<Contribution>>;
String _$contributionsFilterHash() =>
    r'414e8c29a70b8664959bfe709ccc3607cd35a6a1';

/// See also [ContributionsFilter].
@ProviderFor(ContributionsFilter)
final contributionsFilterProvider =
    NotifierProvider<ContributionsFilter, ContributionFilter>.internal(
  ContributionsFilter.new,
  name: r'contributionsFilterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$contributionsFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ContributionsFilter = Notifier<ContributionFilter>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
