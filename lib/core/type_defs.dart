
import 'package:fpdart/fpdart.dart';
import 'package:spark_talk_reddit/core/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;
typedef FutureVoid = FutureEither<void>;