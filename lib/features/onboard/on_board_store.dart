import 'package:mobx/mobx.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/setting/wallet_setting.dart';

part 'on_board_store.g.dart';

class OnBoardStore = _OnBoardStore with _$OnBoardStore;

abstract class _OnBoardStore with Store {

  @readonly
  int _pageSelectedIndex = 0;

  @action
  selectPage(int index) {
    _pageSelectedIndex = index;
  }

}
