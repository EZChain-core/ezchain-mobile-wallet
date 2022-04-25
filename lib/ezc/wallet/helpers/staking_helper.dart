import 'package:decimal/decimal.dart';
import 'package:wallet/ezc/sdk/utils/constants.dart';
import 'package:wallet/ezc/wallet/network/network.dart';

//ignore: constant_identifier_names
const SECONDS_PER_YEAR = 31536000;

//ignore: non_constant_identifier_names
final RAT_1 = Decimal.one;
//ignore: non_constant_identifier_names
final RAT_0 = Decimal.one;
//ignore: non_constant_identifier_names
final BIG_2 = Decimal.fromInt(2);
//ignore: non_constant_identifier_names
final BASE_TS = Decimal.parse("1000000000000000000000000");

//ignore: non_constant_identifier_names
final PC_BASE = Decimal.fromInt(50) / Decimal.fromInt(100);
//ignore: non_constant_identifier_names
final PC_STEP = Decimal.fromInt(4) / Decimal.fromInt(100);
//ignore: non_constant_identifier_names
final REWARD_POOL = Decimal.fromInt(15) / Decimal.fromInt(100);

/// amount, currentSupply in wei format
Future<BigInt> calculateStakingReward(
  BigInt amount,
  int duration,
  BigInt currentSupply,
) async {
  final totalOfStake = await pChain.getTotalOfStake();
  final networkId = ezc.getNetworkId();
  final defValues = networks[networkId];
  if (defValues == null) return BigInt.zero;
  final maxSupply = defValues.p.maxSupply * BigInt.from(10).pow(9);
  final remainingSupply = (maxSupply - currentSupply);
  return reward(
    duration,
    amount,
    totalOfStake * BigInt.from(10).pow(9),
    remainingSupply,
  );
}

/// https://github.com/EZChain-core/avalanchego/issues/1
/// @param:duration: number of seconds to stake
/// @param:stake: the stake amount to be locked
/// @param:totalStake: total locked stake before this stake is locked
/// @param:rewardPool: the remain reward pool
BigInt reward(
  int duration,
  BigInt stake,
  BigInt totalStake,
  BigInt rewardPool,
) {
  if (duration < 0) duration = 0;
  var ts = Decimal.fromBigInt(totalStake + stake);
  if (ts < BASE_TS) {
    ts = BASE_TS;
  }
  final p = rewardPercent(ts);
  var tr = p * ts;
  final cap = rewardPool.toDecimal() * REWARD_POOL.toDecimal();
  if (tr > cap) {
    tr = cap;
  }
  var reward = tr * stake.toDecimal() / ts;
  reward *= duration.toDecimal() / SECONDS_PER_YEAR.toDecimal();
  return reward.toBigInt();
}

/// x = ts / BASE_TS
/// b = floor(log2(x))
/// a = 2^b
/// r = b-1+x/a
/// p = 50% - 0.04%*r
Decimal rewardPercent(Decimal ts) {
  final x = ts / BASE_TS;
  final b = ts.toBigInt().bitLength - BASE_TS.toBigInt().bitLength;
  final a = BIG_2.pow(b);
  final r =
      b.toDecimal().toRational() - RAT_1.toRational() + x / a.toRational();
  var p = r * PC_STEP;
  if (PC_BASE > p) {
    p = PC_BASE - p;
  } else {
    p = RAT_0.toRational();
  }
  return p.toDecimal();
}
