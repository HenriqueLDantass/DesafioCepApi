import 'package:desafiodiocep/API/cep_api.dart';
import 'package:desafiodiocep/models/backforapp.dart';
import 'package:desafiodiocep/screen/edit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool loading = false;
  List<MyModel> cepValues = [];

  void concluirEdicao(MyModel cepEditado) async {
    final store = Provider.of<ViaCepService>(context, listen: false);
    final novoCep = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return EditCepModal(
          initialValue: cepEditado.cep,
          onSave: (newCep) {
            cepEditado.cep = newCep;
            store.editarCep(cepEditado);
            loadCepValues();
          },
        );
      },
    );

    if (novoCep != null) {
      print('Novo CEP: $novoCep');
    }
  }

  @override
  void initState() {
    super.initState();
    loadCepValues();
  }

  Future<void> loadCepValues() async {
    setState(() {
      loading = true;
    });

    var repository = ViaCepService();
    var cepsList = await repository.obterCepsCadastrados();

    for (var cep in cepsList) {
      if (!cepValues.any((existingCep) => existingCep.cep == cep.cep)) {
        cepValues.add(cep);
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ViaCepService>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desafio CeEP'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: store.cepcontroller,
              decoration: const InputDecoration(labelText: 'Digite o CEP'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (store.endereco != null) {
                  showAddressModal(context, store);
                  store.criarCep(MyModel(
                    cep: store.endereco!.cep,
                    objectId: '',
                  ));
                  loadCepValues();
                }
                store.fetchCep(store.cepcontroller.text);
                store.cepcontroller.clear();
              },
              child: const Text('Buscar Endereço'),
            ),
            Expanded(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : cepValues.isEmpty
                      ? const Center(
                          child: Text("Não há ceps cadastrados"),
                        )
                      : ListView.builder(
                          itemCount: cepValues.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (cepValues.isEmpty) {
                              return Text("Não a ceps cadastrados");
                            } else {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(cepValues[index].cep),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          concluirEdicao(cepValues[index]);
                                          loadCepValues();
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          loadCepValues();
                                          store.excluirCep(
                                              cepValues[index].objectId);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }
                          },
                        ),
            )
          ],
        ),
      ),
    );
  }
}

void showAddressModal(BuildContext context, ViaCepService store) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Informações do Cep'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('CEP: ${store.endereco!.cep}'),
            Text('Logradouro: ${store.endereco!.logradouro}'),
            Text('Bairro: ${store.endereco!.bairro}'),
            Text('Localidade: ${store.endereco!.localidade}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Fechar'),
          ),
        ],
      );
    },
  );
}
