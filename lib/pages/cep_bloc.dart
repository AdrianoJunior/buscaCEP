import 'package:cep/domain/cep.dart';
import 'package:cep/domain/cep_api.dart';
import 'package:cep/utils/simple_bloc.dart';

class CepBloc extends SimpleBloc<List<CEP>?> {

  Future<List<CEP>?> fetch() async {
    try {
      List<CEP>? ceps = await CEPApi.getCeps();
      add(ceps);
      return ceps;
    } catch (e) {
      addError(e);
    }
    return null;
  }
}