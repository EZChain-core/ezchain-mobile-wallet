// ignore: implementation_imports
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:decimal/decimal.dart';
import 'package:mobx/mobx.dart';
import 'package:wallet/common/logger.dart';
import 'package:wallet/di/di.dart';
import 'package:wallet/ezc/wallet/helpers/address_helper.dart';
import 'package:wallet/ezc/wallet/helpers/gas_helper.dart';
import 'package:wallet/ezc/wallet/utils/number_utils.dart';
import 'package:wallet/ezc/wallet/wallet.dart';
import 'package:wallet/features/auth/pin/verify/pin_code_verify.dart';
import 'package:wallet/features/common/ext/extensions.dart';
import 'package:wallet/features/common/route/router.dart';
import 'package:wallet/features/common/route/router.gr.dart';
import 'package:wallet/features/common/store/token_store.dart';
import 'package:wallet/features/common/wallet_factory.dart';
import 'package:wallet/features/wallet/send/erc721/wallet_send_erc721.dart';
import 'package:wallet/features/wallet/send/evm/confirm/wallet_send_evm_confirm.dart';
import 'package:wallet/generated/l10n.dart';

part 'wallet_send_erc721_store.g.dart';

class WalletSendErc721Store = _WalletSendErc721Store
    with _$WalletSendErc721Store;

abstract class _WalletSendErc721Store with Store {
  final _walletFactory = getIt<WalletFactory>();
  final _tokenStore = getIt<TokenStore>();

  WalletProvider get _wallet => _walletFactory.activeWallet;

  late final WalletSendErc721Args _args;

  @readonly
  int _gasPriceNumber = 0;

  @readonly
  BigInt _gasLimit = BigInt.zero;

  @observable
  String address = '';

  @readonly
  String? _addressError;

  @readonly
  bool _confirmSuccess = false;

  @readonly
  Decimal _fee = Decimal.zero;

  @readonly
  bool _isLoading = false;

  @computed
  bool get isAddressFilled => validateAddressEvm(address);

  BigInt _gasPrice = BigInt.zero;

  setArgs(WalletSendErc721Args args) async {
    _args = args;
    _gasPrice = BigInt.from(225000000000);
    try {
      _gasPrice = await getAdjustedGasPrice();
    } catch (e) {
      logger.e(e);
    }
    _gasPriceNumber =
        int.tryParse(_gasPrice.toDecimalAvaxX().toStringAsFixed(0)) ?? 0;
  }

  @action
  confirm() async {
    final isAddressValid = validateAddressEvm(address);
    if (!isAddressValid) {
      _addressError = Strings.current.sharedInvalidAddress;
    }
    if (!isAddressValid) return;

    _gasLimit = await _wallet.estimateErc721TransferGas(
      _args.erc721,
      address,
      _args.tokenId,
    );

    _fee = (_gasPrice * _gasLimit).toDecimalAvaxC();

    _confirmSuccess = true;
  }

  @action
  removeAddressError() {
    if (_addressError != null) {
      _addressError = null;
    }
  }

  @action
  cancelDefaultFee() {
    _confirmSuccess = false;
  }

  @action
  Future sendErc721() async {
    final verified = await verifyPinCode();
    if (!verified) return;

    try {
      _isLoading = true;

      await _wallet.sendErc721(
        _args.erc721,
        address,
        _gasPrice,
        _gasLimit.toInt(),
        _args.tokenId,
      );

      _tokenStore.removeErc721Token(
          _args.erc721.contractAddress, _args.tokenId);
      _isLoading = false;

      walletContext?.router.push(
        WalletSendEvmConfirmRoute(
          args: WalletSendEvmConfirmArgs(
            address: address,
            gwei: _gasPriceNumber,
            gasPrice: _gasLimit,
            amount: Decimal.one,
            fee: _fee,
            symbol: _args.title,
            erc721: _args,
          ),
        ),
      );
    } catch (e) {
      logger.e(e);
      showSnackBar(e.toString());
      _isLoading = false;
      return false;
    }
  }
}
