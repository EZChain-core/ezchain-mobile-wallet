import 'package:mobx/mobx.dart';

part 'transaction_detail_store.g.dart';

class TransactionDetailStore = _TransactionDetailStore
    with _$TransactionDetailStore;

abstract class _TransactionDetailStore with Store {
  setTxId(String id) {}
}
