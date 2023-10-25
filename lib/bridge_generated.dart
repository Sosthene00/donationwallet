// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.82.1.
// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, unnecessary_import, prefer_single_quotes, prefer_const_constructors, use_super_parameters, always_use_package_imports, annotate_overrides, invalid_use_of_protected_member, constant_identifier_names, invalid_use_of_internal_member, prefer_is_empty, unnecessary_const

import "bridge_definitions.dart";
import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';

import 'dart:convert';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:uuid/uuid.dart';

import 'dart:ffi' as ffi;

class RustImpl implements Rust {
  final RustPlatform _platform;
  factory RustImpl(ExternalLibrary dylib) => RustImpl.raw(RustPlatform(dylib));

  /// Only valid on web/WASM platforms.
  factory RustImpl.wasm(FutureOr<WasmModule> module) =>
      RustImpl(module as ExternalLibrary);
  RustImpl.raw(this._platform);
  Stream<LogEntry> createLogStream({dynamic hint}) {
    return _platform.executeStream(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_create_log_stream(port_),
      parseSuccessData: _wire2api_log_entry,
      parseErrorData: null,
      constMeta: kCreateLogStreamConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kCreateLogStreamConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "create_log_stream",
        argNames: [],
      );

  Stream<int> createAmountStream({dynamic hint}) {
    return _platform.executeStream(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_create_amount_stream(port_),
      parseSuccessData: _wire2api_u32,
      parseErrorData: null,
      constMeta: kCreateAmountStreamConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kCreateAmountStreamConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "create_amount_stream",
        argNames: [],
      );

  Stream<ScanProgress> createScanProgressStream({dynamic hint}) {
    return _platform.executeStream(FlutterRustBridgeTask(
      callFfi: (port_) =>
          _platform.inner.wire_create_scan_progress_stream(port_),
      parseSuccessData: _wire2api_scan_progress,
      parseErrorData: null,
      constMeta: kCreateScanProgressStreamConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kCreateScanProgressStreamConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "create_scan_progress_stream",
        argNames: [],
      );

  Future<void> resetWallet({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_reset_wallet(port_),
      parseSuccessData: _wire2api_unit,
      parseErrorData: null,
      constMeta: kResetWalletConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kResetWalletConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "reset_wallet",
        argNames: [],
      );

  Future<void> setup({required String filesDir, dynamic hint}) {
    var arg0 = _platform.api2wire_String(filesDir);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_setup(port_, arg0),
      parseSuccessData: _wire2api_unit,
      parseErrorData: null,
      constMeta: kSetupConstMeta,
      argValues: [filesDir],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kSetupConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "setup",
        argNames: ["filesDir"],
      );

  Future<void> startNakamoto({required String filesDir, dynamic hint}) {
    var arg0 = _platform.api2wire_String(filesDir);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_start_nakamoto(port_, arg0),
      parseSuccessData: _wire2api_unit,
      parseErrorData: null,
      constMeta: kStartNakamotoConstMeta,
      argValues: [filesDir],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kStartNakamotoConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "start_nakamoto",
        argNames: ["filesDir"],
      );

  Future<int> getPeerCount({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_get_peer_count(port_),
      parseSuccessData: _wire2api_u32,
      parseErrorData: null,
      constMeta: kGetPeerCountConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kGetPeerCountConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "get_peer_count",
        argNames: [],
      );

  Future<void> scanNextNBlocks({required int n, dynamic hint}) {
    var arg0 = api2wire_u32(n);
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_scan_next_n_blocks(port_, arg0),
      parseSuccessData: _wire2api_unit,
      parseErrorData: null,
      constMeta: kScanNextNBlocksConstMeta,
      argValues: [n],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kScanNextNBlocksConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "scan_next_n_blocks",
        argNames: ["n"],
      );

  Future<void> scanToTip({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_scan_to_tip(port_),
      parseSuccessData: _wire2api_unit,
      parseErrorData: null,
      constMeta: kScanToTipConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kScanToTipConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "scan_to_tip",
        argNames: [],
      );

  Future<WalletStatus> getWalletInfo({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_get_wallet_info(port_),
      parseSuccessData: _wire2api_wallet_status,
      parseErrorData: null,
      constMeta: kGetWalletInfoConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kGetWalletInfoConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "get_wallet_info",
        argNames: [],
      );

  Future<int> getAmount({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_get_amount(port_),
      parseSuccessData: _wire2api_u32,
      parseErrorData: null,
      constMeta: kGetAmountConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kGetAmountConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "get_amount",
        argNames: [],
      );

  Future<String> getReceivingAddress({dynamic hint}) {
    return _platform.executeNormal(FlutterRustBridgeTask(
      callFfi: (port_) => _platform.inner.wire_get_receiving_address(port_),
      parseSuccessData: _wire2api_String,
      parseErrorData: null,
      constMeta: kGetReceivingAddressConstMeta,
      argValues: [],
      hint: hint,
    ));
  }

  FlutterRustBridgeTaskConstMeta get kGetReceivingAddressConstMeta =>
      const FlutterRustBridgeTaskConstMeta(
        debugName: "get_receiving_address",
        argNames: [],
      );

  void dispose() {
    _platform.dispose();
  }
// Section: wire2api

  String _wire2api_String(dynamic raw) {
    return raw as String;
  }

  LogEntry _wire2api_log_entry(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 1)
      throw Exception('unexpected arr length: expect 1 but see ${arr.length}');
    return LogEntry(
      msg: _wire2api_String(arr[0]),
    );
  }

  ScanProgress _wire2api_scan_progress(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 3)
      throw Exception('unexpected arr length: expect 3 but see ${arr.length}');
    return ScanProgress(
      start: _wire2api_u32(arr[0]),
      current: _wire2api_u32(arr[1]),
      end: _wire2api_u32(arr[2]),
    );
  }

  int _wire2api_u32(dynamic raw) {
    return raw as int;
  }

  int _wire2api_u8(dynamic raw) {
    return raw as int;
  }

  Uint8List _wire2api_uint_8_list(dynamic raw) {
    return raw as Uint8List;
  }

  void _wire2api_unit(dynamic raw) {
    return;
  }

  WalletStatus _wire2api_wallet_status(dynamic raw) {
    final arr = raw as List<dynamic>;
    if (arr.length != 3)
      throw Exception('unexpected arr length: expect 3 but see ${arr.length}');
    return WalletStatus(
      amount: _wire2api_u32(arr[0]),
      scanHeight: _wire2api_u32(arr[1]),
      blockTip: _wire2api_u32(arr[2]),
    );
  }
}

// Section: api2wire

@protected
int api2wire_u32(int raw) {
  return raw;
}

@protected
int api2wire_u8(int raw) {
  return raw;
}

// Section: finalizer

class RustPlatform extends FlutterRustBridgeBase<RustWire> {
  RustPlatform(ffi.DynamicLibrary dylib) : super(RustWire(dylib));

// Section: api2wire

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_String(String raw) {
    return api2wire_uint_8_list(utf8.encoder.convert(raw));
  }

  @protected
  ffi.Pointer<wire_uint_8_list> api2wire_uint_8_list(Uint8List raw) {
    final ans = inner.new_uint_8_list_0(raw.length);
    ans.ref.ptr.asTypedList(raw.length).setAll(0, raw);
    return ans;
  }
// Section: finalizer

// Section: api_fill_to_wire
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.
// ignore_for_file: type=lint

/// generated by flutter_rust_bridge
class RustWire implements FlutterRustBridgeWireBase {
  @internal
  late final dartApi = DartApiDl(init_frb_dart_api_dl);

  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  RustWire(ffi.DynamicLibrary dynamicLibrary) : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  RustWire.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void store_dart_post_cobject(
    DartPostCObjectFnType ptr,
  ) {
    return _store_dart_post_cobject(
      ptr,
    );
  }

  late final _store_dart_post_cobjectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(DartPostCObjectFnType)>>(
          'store_dart_post_cobject');
  late final _store_dart_post_cobject = _store_dart_post_cobjectPtr
      .asFunction<void Function(DartPostCObjectFnType)>();

  Object get_dart_object(
    int ptr,
  ) {
    return _get_dart_object(
      ptr,
    );
  }

  late final _get_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Handle Function(ffi.UintPtr)>>(
          'get_dart_object');
  late final _get_dart_object =
      _get_dart_objectPtr.asFunction<Object Function(int)>();

  void drop_dart_object(
    int ptr,
  ) {
    return _drop_dart_object(
      ptr,
    );
  }

  late final _drop_dart_objectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.UintPtr)>>(
          'drop_dart_object');
  late final _drop_dart_object =
      _drop_dart_objectPtr.asFunction<void Function(int)>();

  int new_dart_opaque(
    Object handle,
  ) {
    return _new_dart_opaque(
      handle,
    );
  }

  late final _new_dart_opaquePtr =
      _lookup<ffi.NativeFunction<ffi.UintPtr Function(ffi.Handle)>>(
          'new_dart_opaque');
  late final _new_dart_opaque =
      _new_dart_opaquePtr.asFunction<int Function(Object)>();

  int init_frb_dart_api_dl(
    ffi.Pointer<ffi.Void> obj,
  ) {
    return _init_frb_dart_api_dl(
      obj,
    );
  }

  late final _init_frb_dart_api_dlPtr =
      _lookup<ffi.NativeFunction<ffi.IntPtr Function(ffi.Pointer<ffi.Void>)>>(
          'init_frb_dart_api_dl');
  late final _init_frb_dart_api_dl = _init_frb_dart_api_dlPtr
      .asFunction<int Function(ffi.Pointer<ffi.Void>)>();

  void wire_create_log_stream(
    int port_,
  ) {
    return _wire_create_log_stream(
      port_,
    );
  }

  late final _wire_create_log_streamPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_create_log_stream');
  late final _wire_create_log_stream =
      _wire_create_log_streamPtr.asFunction<void Function(int)>();

  void wire_create_amount_stream(
    int port_,
  ) {
    return _wire_create_amount_stream(
      port_,
    );
  }

  late final _wire_create_amount_streamPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_create_amount_stream');
  late final _wire_create_amount_stream =
      _wire_create_amount_streamPtr.asFunction<void Function(int)>();

  void wire_create_scan_progress_stream(
    int port_,
  ) {
    return _wire_create_scan_progress_stream(
      port_,
    );
  }

  late final _wire_create_scan_progress_streamPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_create_scan_progress_stream');
  late final _wire_create_scan_progress_stream =
      _wire_create_scan_progress_streamPtr.asFunction<void Function(int)>();

  void wire_reset_wallet(
    int port_,
  ) {
    return _wire_reset_wallet(
      port_,
    );
  }

  late final _wire_reset_walletPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_reset_wallet');
  late final _wire_reset_wallet =
      _wire_reset_walletPtr.asFunction<void Function(int)>();

  void wire_setup(
    int port_,
    ffi.Pointer<wire_uint_8_list> files_dir,
  ) {
    return _wire_setup(
      port_,
      files_dir,
    );
  }

  late final _wire_setupPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(
              ffi.Int64, ffi.Pointer<wire_uint_8_list>)>>('wire_setup');
  late final _wire_setup = _wire_setupPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_start_nakamoto(
    int port_,
    ffi.Pointer<wire_uint_8_list> files_dir,
  ) {
    return _wire_start_nakamoto(
      port_,
      files_dir,
    );
  }

  late final _wire_start_nakamotoPtr = _lookup<
      ffi.NativeFunction<
          ffi.Void Function(ffi.Int64,
              ffi.Pointer<wire_uint_8_list>)>>('wire_start_nakamoto');
  late final _wire_start_nakamoto = _wire_start_nakamotoPtr
      .asFunction<void Function(int, ffi.Pointer<wire_uint_8_list>)>();

  void wire_get_peer_count(
    int port_,
  ) {
    return _wire_get_peer_count(
      port_,
    );
  }

  late final _wire_get_peer_countPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_get_peer_count');
  late final _wire_get_peer_count =
      _wire_get_peer_countPtr.asFunction<void Function(int)>();

  void wire_scan_next_n_blocks(
    int port_,
    int n,
  ) {
    return _wire_scan_next_n_blocks(
      port_,
      n,
    );
  }

  late final _wire_scan_next_n_blocksPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64, ffi.Uint32)>>(
          'wire_scan_next_n_blocks');
  late final _wire_scan_next_n_blocks =
      _wire_scan_next_n_blocksPtr.asFunction<void Function(int, int)>();

  void wire_scan_to_tip(
    int port_,
  ) {
    return _wire_scan_to_tip(
      port_,
    );
  }

  late final _wire_scan_to_tipPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_scan_to_tip');
  late final _wire_scan_to_tip =
      _wire_scan_to_tipPtr.asFunction<void Function(int)>();

  void wire_get_wallet_info(
    int port_,
  ) {
    return _wire_get_wallet_info(
      port_,
    );
  }

  late final _wire_get_wallet_infoPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_get_wallet_info');
  late final _wire_get_wallet_info =
      _wire_get_wallet_infoPtr.asFunction<void Function(int)>();

  void wire_get_amount(
    int port_,
  ) {
    return _wire_get_amount(
      port_,
    );
  }

  late final _wire_get_amountPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_get_amount');
  late final _wire_get_amount =
      _wire_get_amountPtr.asFunction<void Function(int)>();

  void wire_get_receiving_address(
    int port_,
  ) {
    return _wire_get_receiving_address(
      port_,
    );
  }

  late final _wire_get_receiving_addressPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_get_receiving_address');
  late final _wire_get_receiving_address =
      _wire_get_receiving_addressPtr.asFunction<void Function(int)>();

  ffi.Pointer<wire_uint_8_list> new_uint_8_list_0(
    int len,
  ) {
    return _new_uint_8_list_0(
      len,
    );
  }

  late final _new_uint_8_list_0Ptr = _lookup<
          ffi
          .NativeFunction<ffi.Pointer<wire_uint_8_list> Function(ffi.Int32)>>(
      'new_uint_8_list_0');
  late final _new_uint_8_list_0 = _new_uint_8_list_0Ptr
      .asFunction<ffi.Pointer<wire_uint_8_list> Function(int)>();

  void free_WireSyncReturn(
    WireSyncReturn ptr,
  ) {
    return _free_WireSyncReturn(
      ptr,
    );
  }

  late final _free_WireSyncReturnPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(WireSyncReturn)>>(
          'free_WireSyncReturn');
  late final _free_WireSyncReturn =
      _free_WireSyncReturnPtr.asFunction<void Function(WireSyncReturn)>();
}

final class _Dart_Handle extends ffi.Opaque {}

final class wire_uint_8_list extends ffi.Struct {
  external ffi.Pointer<ffi.Uint8> ptr;

  @ffi.Int32()
  external int len;
}

typedef DartPostCObjectFnType = ffi.Pointer<
    ffi.NativeFunction<
        ffi.Bool Function(DartPort port_id, ffi.Pointer<ffi.Void> message)>>;
typedef DartPort = ffi.Int64;
