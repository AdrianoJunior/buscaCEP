import 'dart:convert' as convert;
import 'package:cep/domain/cep.dart';
import 'package:cep/utils/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class CEPApi {
  static Future<CEP?> searchCep(String cep) async {
    try {
      var url = 'https://viacep.com.br/ws/$cep/json/';

      var response = await http.get(Uri.parse(url));

      String json = response.body;
      print(json);

      final cepString = convert.json.decode(json);

      final resultCep = CEP.fromMap(cepString);

      return resultCep;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<ApiResponse<bool>> saveCep(CEP c) async {
    try {

      List<CEP>? ceps = await getCeps();
      if(ceps != null) {
        for (int i = 0; i < ceps.length; i++) {
          if (c.cep == ceps[i].cep) {
            return ApiResponse.error(
                "O CEP informado já está cadastrado no aplicativo");
          }
        }
      }
      if(c.cep == null) {
        return ApiResponse.error("O CEP informado não existe, por isto não pode ser salvo.");
      }
          var cep = ParseObject('CEP')
            ..set("cep", c.cep)..set('logradouro', c.logradouro)..set(
                'complemento', c.complemento)..set('bairro', c.bairro)..set(
                'localidade', c.localidade)..set('uf', c.uf)..set(
                'ibge', c.ibge)..set('gia', c.gia)..set('ddd', c.ddd)..set(
                'siafi', c.siafi);
          var response = await cep.save();

          if (response.success) {
            return ApiResponse.ok(true);
          }


      return ApiResponse.error("Não foi possível salvar o CEP");
    } catch (e) {
      print(e);
      return ApiResponse.error("Não foi possivel salvar o CEP");
    }
  }

  static Future<List<CEP>?> getCeps() async {
    QueryBuilder<ParseObject> queryCeps =
    QueryBuilder<ParseObject>(ParseObject('CEP'));
    final ParseResponse apiResponse = await queryCeps.query();

    if (apiResponse.success && apiResponse.results != null) {
      var list = apiResponse.results as List<ParseObject>;
      final ceps = list.map<CEP>((map) => CEP.fromMap(map.toJson())).toList();

      return ceps;
    }
    return null;
  }
}
