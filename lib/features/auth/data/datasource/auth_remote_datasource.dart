import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/core/entities/user.dart' as myUser;

abstract interface class AuthRemoteDataSouce {
  Future<Either<Failure, myUser.User>> signInWithGoogle();
  Future<Either<Failure, String>> signOut();
  Future<Either<Failure, myUser.User>> getCurrentUser();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDataSouce {
  final SupabaseClient client;
  final GoogleSignIn googleSignIn;
  AuthRemoteDatasourceImpl({required this.client, required this.googleSignIn});
  @override
  Future<Either<Failure, myUser.User>> getCurrentUser() async {
    try {
      final currentSession = client.auth.currentSession;
      final googleUser = await googleSignIn.signIn();
      if (currentSession == null || googleUser == null) {
        return Left(Failure(message: "No User Logged In !"));
      }
      final user = client.auth.currentUser;
      return Right(
        myUser.User(
            id: user!.id,
            email: googleUser.email,
            name: googleUser.displayName ?? "No Name Found"),
      );
    } catch (e) {
      return Left(
        Failure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, myUser.User>> signInWithGoogle() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return Left(Failure(message: "Sign In Failed!"));
      }
      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;

      final idToken = googleAuth.idToken;
      if (accessToken == null) {
        return Left(Failure(message: "No access token found"));
      }
      if (idToken == null) {
        return left(Failure(message: "No idToken found"));
      }
      final response = await client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
      if (response == null) {
        return Left(Failure(message: "Supabase authentication Failed!"));
      }

      return Right(
        myUser.User(
          email: googleUser.email,
          id: response.user!.id,
          name: googleUser.displayName ?? "No Name Found",
        ),
      );
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> signOut() async {
    try {
      await client.auth.signOut();
      return const Right("Succefully Signed Out");
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
