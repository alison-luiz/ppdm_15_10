import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:mobile/widgets/custom_drawer.dart';
import 'package:mobile/services/transaction_service.dart';
import 'package:mobile/screens/transaction_form.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final TransactionService _transactionService = TransactionService();
  List<dynamic> _transactions = [];

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    try {
      String response = await _transactionService.getAll();
      setState(() {
        _transactions = jsonDecode(response);
      });
    } catch (error) {
      print('Oops! Ocorreu um erro ao buscar as transações: $error');
    }
  }

  Future<void> _deleteTransaction(String id) async {
    try {
      await _transactionService.delete(id);
      _fetchTransactions();
    } catch (error) {
      print('Oops! Ocorrreu um erro ao deletar a transação: $error');
    }
  }

  Future<void> _navigateToForm({Map<String, dynamic>? transaction}) async {
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionForm(transaction: transaction),
      ),
    );
    if (result == true) {
      _fetchTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicação Bancária'),
      ),
      drawer: const CustomDrawer(),
      body: _transactions.isEmpty
          ? const Center(child: Text('Não há transações!'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                var transaction = _transactions[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.account_circle),
                    title: Text(transaction['name']),
                    subtitle: Text(transaction['value'].toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _navigateToForm(transaction: transaction),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deleteTransaction(transaction['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
