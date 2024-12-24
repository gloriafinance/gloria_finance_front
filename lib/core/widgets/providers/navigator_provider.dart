import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navigator_provider.g.dart';

@Riverpod(keepAlive: true)
class Navigator extends _$Navigator {

  @override
  int build() => 0;

  void setIndexTab(int index) {
    state = index;
  }
}
