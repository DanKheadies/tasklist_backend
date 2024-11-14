import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:tasklist_backend/repositories/session/session_repository.dart';
import 'package:tasklist_backend/repositories/user/user_repository.dart';

final userRepository = UserRepository();
final sessionRepository = SessionRepository();

Handler middleware(Handler handler) {
  return handler
      .use(
        bearerAuthentication<User>(
          authenticator: (context, token) async {
            final sessionRepo = context.read<SessionRepository>();
            final userRepo = context.read<UserRepository>();
            final session = sessionRepo.sessionFromToken(token);
            return session != null ? userRepo.userFromId(session.userId) : null;
          },
          applies: (RequestContext context) async =>
              context.request.method != HttpMethod.post &&
              context.request.method != HttpMethod.get,
        ),
      )
      .use(provider<UserRepository>((_) => userRepository))
      .use(provider<SessionRepository>((_) => sessionRepository));
}

// curl --request PATCH --url http://localhost:8080/authentication/bearer/599052ab62a707684c42240e75a85b268027376aba0385992681726028a1de66 --header 'Authorization: Bearer f2b5f27d50558663f95821fe3c176ed5974a3e1d3bac7383d6df5ce00915908d' --data '{"name": "Daniel Ian Kheadies", "username": "dan_kheadies"}'
// curl --request PATCH --url http://localhost:8080/authentication/bearer/599052ab62a707684c42240e75a85b268027376aba0385992681726028a1de66 --header 'Authorization: Bearer f2b5f27d50558663f95821fe3c176ed5974a3e1d3bac7383d6df5ce00915908d' --data '{"name": "Daniel Ian Kheadies", "username": "dan_kheadies"}'
// curl --request GET --url http://localhost:8080/authentication/bearer/599052ab62a707684c42240e75a85b268027376aba0385992681726028a1de66 --header 'Content-Type: application/json' 

// curl --request PATCH --url http://localhost:8080/authentication/bearer/599052ab62a707684c42240e75a85b268027376aba0385992681726028a1de66 --data '{"name": "Deese Mids", "username": "deesemids"}'
// curl --request DELETE --url http://localhost:8080/authentication/bearer/599052ab62a707684c42240e75a85b268027376aba0385992681726028a1de66
// curl --request DELETE --url http://localhost:8080/authentication/bearer/599052ab62a707684c42240e75a85b268027376aba0385992681726028a1de66 --header 'Authorization: Bearer f2b5f27d50558663f95821fe3c176ed5974a3e1d3bac7383d6df5ce00915908d'
