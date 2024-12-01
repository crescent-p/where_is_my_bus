import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:where_is_my_bus/core/error/failure.dart';
import 'package:where_is_my_bus/core/entities/user.dart' as myUser;

abstract interface class AuthRemoteDataSouce {
  Future<Either<Failure, myUser.User>> signInWithGoogle();
  Future<Either<Failure, String>> signOut();
  Future<Either<Failure, myUser.User>> getCurrentUser();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDataSouce {
  final GoogleSignIn googleSignIn;
  final SharedPreferences prefs;
  AuthRemoteDatasourceImpl({required this.prefs, required this.googleSignIn});
  @override
  Future<Either<Failure, myUser.User>> getCurrentUser() async {
    try {
      await googleSignIn.signInSilently();
      final googleUser = googleSignIn.currentUser;
      if (googleUser != null) {
        final authenticate = await googleUser.authentication;
        String? idTok = authenticate.idToken;
        prefs.setString("idToken", idTok!);
      }
      if (googleUser == null) {
        return Left(Failure(message: "No User Logged In !"));
      }
      return Right(
        myUser.User(
            id: googleUser.id,
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
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final authenticate = await googleUser.authentication;
        String? idTok = authenticate.idToken;
        prefs.setString("idToken", idTok!);
      }
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
        return Left(Failure(message: "No idToken found"));
      }

      // final response = await client.auth.signInWithIdToken(
      //   provider: OAuthProvider.google,
      //   idToken: idToken,
      // );

      return Right(
        myUser.User(
          email: googleUser.email,
          id: googleUser.id,
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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("idToken");
      return const Right("Succefully Signed Out");
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
