import 'package:cep/domain/cep.dart';
import 'package:cep/utils/alert.dart';
import 'package:cep/utils/alert_cancel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';


class CepsListView extends StatelessWidget {
  const CepsListView(this.ceps, {super.key});

  final List<CEP>? ceps;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: ceps!.length ?? 0,
      itemBuilder: (context, index) {
        CEP cep = ceps![index];

        return Card(
          elevation: 12,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          color: Colors.white,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Slidable(
              startActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  /*SlidableAction(
                    // An action can be bigger than the others.
                    flex: 2,
                    onPressed: (ctx) {},
                    backgroundColor: const Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Editar',
                  ),*/
                  SlidableAction(
                    onPressed: (ctx) => _onClickDelete(ctx, cep),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Excluir',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                children: [
                  /*SlidableAction(
                    onPressed: (ctx) {},
                    backgroundColor: const Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Editar',
                  ),*/
                  SlidableAction(
                    onPressed: (ctx) => _onClickDelete(ctx, cep),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Excluir',
                  ),
                ],
              ),
              child: ListTile(
                title: Text(cep.logradouro!),
                subtitle: Text(
                  "Bairro: ${cep.bairro}\nCidade: ${cep.localidade}\nCEP: ${cep.cep}",
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _onClickDelete(BuildContext context, CEP cep) async {

    alertCancel(
      context,
      "Deseja excluir o CEP ${cep.cep}?\nATENÇÃO: Esta ação não pode ser desfeita.",
      callback: () async {
        var deletedCep = ParseObject('CEP')..objectId = cep.id;
        await deletedCep.delete();
      },
    );

  }
}
