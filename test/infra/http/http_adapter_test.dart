// @dart=2.10

import 'dart:convert';

import 'package:app/data/http/http.dart';
import 'package:app/infra/http/http_adapter.dart';
import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:meta/meta.dart';

class ClientSpy extends Mock implements Client {}

void main() {
  String url;
  HttpAdapter sut;
  ClientSpy client;

  setUp(() {
    client = ClientSpy();
    sut = HttpAdapter(client);
    url = faker.internet.httpUrl();
  });
  group('post', () {
    PostExpectation mockRequest() => when(
        client.post(any, body: anyNamed('body'), headers: anyNamed('headers')));

    void mockResponse(int statusCode,
        {String body = '{"any_key":"any_value"}'}) {
      mockRequest().thenAnswer((_) async => Response(body, statusCode));
    }

    setUp(() {
      mockResponse(200);
    });

    test('Should call post with correct values', () async {
      await sut.request(
          url: Uri.parse(url), method: 'post', body: {'any_key': 'any_value'});

      verify(client.post(Uri.parse(url),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any_key":"any_value"}'));
    });

    test('Should call post without body', () async {
      await sut.request(url: Uri.parse(url), method: 'post');

      verify(client.post(any, headers: anyNamed('headers')));
    });

    test('Should return data if post returns 200', () async {
      final response = await sut.request(url: Uri.parse(url), method: 'post');

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if post returns 200 with no data', () async {
      mockResponse(200, body: '');

      final response = await sut.request(url: Uri.parse(url), method: 'post');

      expect(response, null);
    });

    test('Should return null if post returns 204', () async {
      mockResponse(204, body: '');

      final response = await sut.request(url: Uri.parse(url), method: 'post');

      expect(response, null);
    });

    test('Should return null if post returns 204 with data', () async {
      mockResponse(204);

      final response = await sut.request(url: Uri.parse(url), method: 'post');

      expect(response, null);
    });

    test('Should return bad request error if post returns 400', () async {
      mockResponse(400);

      final future = sut.request(url: Uri.parse(url), method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return bad request error if post returns 400 without data',
        () async {
      mockResponse(400, body: '');

      final future = sut.request(url: Uri.parse(url), method: 'post');

      expect(future, throwsA(HttpError.badRequest));
    });

    test('Should return server error if post returns 401', () async {
      mockResponse(401);

      final future = sut.request(url: Uri.parse(url), method: 'post');

      expect(future, throwsA(HttpError.unauthorized));
    });

    test('Should return server error if post returns 500', () async {
      mockResponse(500);

      final future = sut.request(url: Uri.parse(url), method: 'post');

      expect(future, throwsA(HttpError.serverError));
    });
  });
}
