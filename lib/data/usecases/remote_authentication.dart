// @dart=2.10

import 'dart:io';

import 'package:app/data/http/http_error.dart';
import 'package:app/data/models/remote_account_model.dart';
import 'package:app/domain/entities/account_entity.dart';
import 'package:app/helpers/domain_error.dart';
import 'package:meta/meta.dart';
import '../../domain/usecases/usecases.dart';
import '../http/http.dart';

class RemoteAuthentication {
  final HttpClient httpClient;
  final String url;

  RemoteAuthentication({@required this.httpClient, @required this.url});

  Future<AccountEntity> auth(AuthenticationParams params) async {
    final body = RemoteAuthenticationParams.fromDomain(params).toJson();
    try {
      final HttpResponse = await httpClient.request(
          url: Uri.parse(url), method: 'get', body: body);

      return RemoteAccountModel.fromJson(HttpResponse).toEntity();
    } on HttpError catch (error) {
      error == HttpError.unauthorized
          ? throw DomainError.invalidCredentials
          : throw DomainError.unexpected;
    }
  }
}

class RemoteAuthenticationParams {
  final String email;
  final String secret;

  RemoteAuthenticationParams({@required this.email, @required this.secret});

  factory RemoteAuthenticationParams.fromDomain(AuthenticationParams entity) =>
      RemoteAuthenticationParams(email: entity.email, secret: entity.secret);

  Map toJson() => {'email': email, 'password': secret};
}
