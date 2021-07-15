import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:appsd/model/Registro.dart';


class ApiRegistro {


  Future<List<Registro>> listarRegistros(String url) async {

    HttpClient httpClient = new HttpClient();
    print("${url}");
    HttpClientRequest request = await httpClient.getUrl(Uri.parse("${url}")).timeout(const Duration(seconds: 30), onTimeout: () {
      throw TimeoutException(
          'Não recebemos resposta do servidor!\nPor favor, tente novamente mais tarde!');
    });
    request.headers.set('content-type','application/json' );
    //request.headers.set(HttpHeaders.authorizationHeader,"bearer ${Dados.token}");
    HttpClientResponse response = await request.close(); // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
    httpClient.close();
    if (response.statusCode == 200) {

      final items = json.decode(reply).cast<Map<String, dynamic>>();
      List<Registro> listaRegistros = [];
      listaRegistros = items.map<Registro>((json) {
          return Registro.fromJson(json);
        }).toList();


      return listaRegistros;
    } else {
      throw Exception('Ops... não foi possível trazer listar os registros!');
    }


  }


  Future<String> apiRegistroPut(String url, Registro registro) async {


      print("$url/${registro.id}");
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.putUrl(Uri.parse("$url/${registro.id}"))
          .timeout(const Duration(seconds: 30), onTimeout: () {
        throw TimeoutException(
            'Não recebemos resposta do servidor!\nPor favor, tente novamente mais tarde!');
      });
      request.headers.set('content-type', 'application/json');
      //request.headers.set(HttpHeaders.authorizationHeader, "bearer ${Dados.token}");
      request.add(utf8.encode(json.encode(registro.toJson())));
      HttpClientResponse response = await request
          .close(); // todo - you should check the response.statusCode
      String reply = await response.transform(utf8.decoder).join();
      //print(reply);
      httpClient.close();

      print("Status Code do put da api de registro ${response
          .statusCode} \n Retorno do put da api de registro $reply");
      print("Diferente de 201: " + response.statusCode.toString() != '201');
      if (response.statusCode.toString() != '201') {
        throw json.decode(reply); //Exception(reply);
      }
      return response.statusCode.toString();

  }

  Future<String> apiRegistroPost(String url, Map jsonMap) async {

    print(url);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url)).timeout(const Duration(seconds: 30), onTimeout: () {
      throw TimeoutException(
          'Não recebemos resposta do servidor!\nPor favor, tente novamente mais tarde!');
    });
    request.headers.set('content-type', 'application/json');
    //request.headers.set(HttpHeaders.authorizationHeader,"bearer ${Dados.token}");
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close(); // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    print(reply);
    httpClient.close();

    print("Status Code do post da api de registro ${response.statusCode} \nRetorno do post da api de registro $reply");

    if(response.statusCode.toString() != '201'){
      throw json.decode(reply);// Exception(reply);
    }
    return response.statusCode.toString();
  }


}


