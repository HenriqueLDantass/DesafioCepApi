import 'package:flutter/material.dart';

class EditCepModal extends StatefulWidget {
  final String initialValue;
  final Function(String) onSave;

  EditCepModal({required this.initialValue, required this.onSave});

  @override
  _EditCepModalState createState() => _EditCepModalState();
}

class _EditCepModalState extends State<EditCepModal> {
  late TextEditingController _cepController;

  @override
  void initState() {
    super.initState();
    _cepController = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _cepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar CEP'),
      content: TextField(
        controller: _cepController,
        decoration: InputDecoration(labelText: 'CEP'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            widget.onSave(_cepController.text);
            Navigator.pop(context);
          },
          child: Text('Salvar'),
        ),
      ],
    );
  }
}
