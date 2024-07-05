import 'package:donationwallet/src/data/providers/chain_api.dart';
import 'package:donationwallet/src/data/providers/rust_api.dart';
import 'package:donationwallet/src/data/providers/secure_storage.dart';
import 'package:donationwallet/src/data/repositories/chain_repository.dart';
import 'package:donationwallet/src/data/repositories/transaction_repository.dart';
import 'package:donationwallet/src/data/repositories/wallet_repository.dart';
import 'package:donationwallet/src/domain/usecases/create_wallet_usecase.dart';
import 'package:donationwallet/src/domain/usecases/delete_wallet_usecase.dart';
import 'package:donationwallet/src/domain/usecases/get_chain_tip_usecase.dart';
import 'package:donationwallet/src/domain/usecases/get_wallet_info_usecase.dart';
import 'package:donationwallet/src/domain/usecases/load_raw_wallet_usecase.dart';
import 'package:donationwallet/src/domain/usecases/load_wallet_usecase.dart';
import 'package:donationwallet/src/domain/usecases/save_wallet_usecase.dart';
import 'package:donationwallet/src/domain/usecases/transactionfilloutputs_usecase.dart';
import 'package:donationwallet/src/domain/usecases/update_wallet_usecase.dart';
import 'package:donationwallet/src/domain/usecases/transactionupdatefees_usecase.dart';
import 'package:donationwallet/src/domain/usecases/create_transaction_usecase.dart';
import 'package:donationwallet/generated/rust/frb_generated.dart';
import 'package:donationwallet/src/presentation/notifiers/chain_notifier.dart';
import 'package:donationwallet/src/presentation/notifiers/transaction_notifier.dart';
import 'package:donationwallet/src/presentation/notifiers/wallet_notifier.dart';
import 'package:donationwallet/src/app.dart';
import 'package:donationwallet/src/utils/scan_stream.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();

  ScanProgressService();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
    final storage = FlutterSecureStorage(aOptions: getAndroidOptions(), lOptions: LinuxOptions.defaultOptions, iOptions: IOSOptions.defaultOptions);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WalletNotifier(
          CreateWalletUseCase(WalletRepository(SecureStorageProvider(storage), RustApi())),
          GetWalletInfoUsecase(WalletRepository(SecureStorageProvider(storage), RustApi())),
          SaveWalletUseCase(WalletRepository(SecureStorageProvider(storage), RustApi())),
          LoadWalletUseCase(WalletRepository(SecureStorageProvider(storage), RustApi())),
          DeleteWalletUseCase(WalletRepository(SecureStorageProvider(storage), RustApi())),
          UpdateWalletUseCase(WalletRepository(SecureStorageProvider(storage), RustApi())),
        )), 
        ChangeNotifierProvider(create: (_) => ChainNotifier(
          GetChainTipUseCase(ChainRepository(ChainApiProvider()))
          )
        ),
        ChangeNotifierProvider(create: (_) => TransactionNotifier(
          CreateTransactionUsecase(TransactionRepository(RustApi())),
          TransactionFilloutputsUsecase(TransactionRepository(RustApi())),
          TransactionUpdatefeesUsecase(TransactionRepository(RustApi())),
          LoadRawWalletUseCase(WalletRepository(SecureStorageProvider(storage), RustApi()))
          )
        )
      ],
      child: const SilentPaymentApp(),
    );
  }
}
