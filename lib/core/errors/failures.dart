import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure([
    super.message = 'Terjadi kesalahan pada penyimpanan lokal',
  ]);
}

class CalculationFailure extends Failure {
  const CalculationFailure([
    super.message = 'Gagal menghitung waktu sholat astronomis',
  ]);
}
