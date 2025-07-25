// This file is automatically generated, so please do not edit it.
// @generated by `flutter_rust_bridge`@ 2.11.1.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import '../lib.dart';
import 'history.dart';
import 'outputs.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';
import 'structs.dart';
import 'wallet/setup.dart';

// These function are ignored because they are on traits that is not defined in current crate (put an empty `#[frb]` on it to unignore): `clone`, `clone`, `clone`, `eq`, `eq`, `fmt`, `fmt`, `fmt`, `from`, `from`

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ApiScanKey>>
abstract class ApiScanKey implements RustOpaqueInterface {
  static ApiScanKey decode({required String encoded}) =>
      RustLib.instance.api.crateApiWalletApiScanKeyDecode(encoded: encoded);

  String encode();
}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<ApiSpendKey>>
abstract class ApiSpendKey implements RustOpaqueInterface {
  static ApiSpendKey decode({required String encoded}) =>
      RustLib.instance.api.crateApiWalletApiSpendKeyDecode(encoded: encoded);

  String encode();
}

// Rust type: RustOpaqueMoi<flutter_rust_bridge::for_generated::RustAutoOpaqueInner<SpWallet>>
abstract class SpWallet implements RustOpaqueInterface {
  static Future<String> broadcastTx(
          {required String tx, required String network}) =>
      RustLib.instance.api
          .crateApiWalletSpWalletBroadcastTx(tx: tx, network: network);

  static Future<String> broadcastUsingBlindbit(
          {required String blindbitUrl, required String tx}) =>
      RustLib.instance.api.crateApiWalletSpWalletBroadcastUsingBlindbit(
          blindbitUrl: blindbitUrl, tx: tx);

  ApiSilentPaymentUnsignedTransaction createDrainTransaction(
      {required Map<String, ApiOwnedOutput> apiOutputs,
      required String wipeAddress,
      required double feerate,
      required String network});

  ApiSilentPaymentUnsignedTransaction createNewTransaction(
      {required Map<String, ApiOwnedOutput> apiOutputs,
      required List<ApiRecipient> apiRecipients,
      required double feerate,
      required String network});

  static SpWallet decode({required String encodedWallet}) =>
      RustLib.instance.api
          .crateApiWalletSpWalletDecode(encodedWallet: encodedWallet);

  String encode();

  static ApiSilentPaymentUnsignedTransaction finalizeTransaction(
          {required ApiSilentPaymentUnsignedTransaction unsignedTransaction}) =>
      RustLib.instance.api.crateApiWalletSpWalletFinalizeTransaction(
          unsignedTransaction: unsignedTransaction);

  int getBirthday();

  String getChangeAddress();

  String getNetwork();

  String getReceivingAddress();

  ApiScanKey getScanKey();

  ApiSpendKey getSpendKey();

  /// Only call this when we expect this value to be present
  int? getWalletLastScan();

  /// Only call this when we expect this value to be present
  OwnedOutputs? getWalletOwnedOutputs();

  /// Only call this when we expect this value to be present
  TxHistory? getWalletTxHistory();

  static void interruptScanning() =>
      RustLib.instance.api.crateApiWalletSpWalletInterruptScanning();

  factory SpWallet(
          {required ApiScanKey scanKey,
          required ApiSpendKey spendKey,
          required String network,
          required int birthday}) =>
      RustLib.instance.api.crateApiWalletSpWalletNew(
          scanKey: scanKey,
          spendKey: spendKey,
          network: network,
          birthday: birthday);

  Future<void> scanToTip(
      {required String blindbitUrl,
      required int lastScan,
      required BigInt dustLimit,
      required OwnedOutPoints ownedOutpoints});

  static WalletSetupResult setupWallet({required WalletSetupArgs setupArgs}) =>
      RustLib.instance.api
          .crateApiWalletSpWalletSetupWallet(setupArgs: setupArgs);

  String signTransaction(
      {required ApiSilentPaymentUnsignedTransaction unsignedTransaction});
}
