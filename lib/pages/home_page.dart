import 'package:cep/domain/cep.dart';
import 'package:cep/domain/cep_api.dart';
import 'package:cep/pages/cep_bloc.dart';
import 'package:cep/utils/alert.dart';
import 'package:cep/utils/alert_cancel.dart';
import 'package:cep/utils/api_response.dart';
import 'package:cep/widget/app_button.dart';
import 'package:cep/widget/app_text.dart';
import 'package:cep/widget/text_error.dart';
import 'package:flutter/material.dart';

import 'ceps_list_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final _bloc = CepBloc();
  final _tCep = TextEditingController();
  final focusCep = FocusNode();

  @override
  void initState() {
    super.initState();
    _bloc.fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => _bloc.fetch(),
            icon: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.refresh, color: Colors.white),
            ),
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Busca CEP",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppText(
                "CEP",
                "Digite um cep (somente números)",
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                controller: _tCep,
                validator: (s) => _validateCep(s),
                focusNode: focusCep,
                mask: '#####-###',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton(
                "Pesquisar",
                width: double.infinity,
                onPressed: _onClickPesquisar,
              ),
            ),
            StreamBuilder(
                stream: _bloc.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return TextError("Não foi possivel recuperar os dados.");
                  } else if (!snapshot.hasData) {
                    return const Center(
                      child: SizedBox(child: CircularProgressIndicator()),
                    );
                  }

                  List<CEP>? ceps = snapshot.data;

                  return Expanded(
                    child: CepsListView(ceps),
                  );
                }),
          ],
        ),
      ),
    );
  }

  _validateCep(String? s) {
    if (s == null) {
      return "Por favor, digite um CEP válido";
    } else {
      if (s.isEmpty) {
        return "Por favor, digite um CEP válido";
      } else if (s.length != 9) {
        return "Por favor, digite um CEP válido";
      }
    }
  }

  _onClickPesquisar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    focusCep.unfocus();
    String cep = _tCep.text.replaceAll('-', '');

    CEP? response = await CEPApi.searchCep(cep);
    if (response == null) {
      alertCancel(
        context,
        "Ocorreu um erro ao cnsultar o CEP.\nGostaria de tentar novamente?",
        callback: () => _onClickPesquisar,
      );
    } else {
      alertCancel(
          context,
          "Deseja salvar o CEP?\n\n"
          "CEP: ${response.cep}\n"
          "Logradouro: ${response.logradouro}\n"
          "Complemento: ${response.complemento}\n"
          "Bairro: ${response.bairro}\n"
          "Localidade: ${response.localidade}\n"
          "UF: ${response.uf}\n"
          "DDD: ${response.ddd}",
          text: "Salvar",
          callback: () => _onClickSalvar(response));
    }
  }

  _onClickSalvar(CEP cep) async {
    ApiResponse<bool> response = await CEPApi.saveCep(cep);

    if (response.ok!) {
      _tCep.clear();
      const snackBar = SnackBar(
        content: Text('O CEP foi salvo com sucesso!'),
        elevation: 8,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      var snackBar = SnackBar(
        content: Text(response.msg!),
        elevation: 8,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
