import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/common/router.gr.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/features/common/balance_store.dart';
import 'package:wallet/features/common/chain_type/ezc_type.dart';
import 'package:wallet/features/common/price_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/wallet/receive/wallet_receive.dart';
import 'package:wallet/roi/wallet/history/raw_types.dart';

part 'transaction_detail_store.g.dart';

class TransactionDetailStore = _TransactionDetailStore with _$TransactionDetailStore;

abstract class _TransactionDetailStore with Store {

  setTxId(String id) {

  }
}