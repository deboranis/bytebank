import 'package:flutter/material.dart';
import 'package:newbytebank/database/dao/contact_dao.dart';
import 'package:newbytebank/models/contact.dart';
import 'package:newbytebank/screens/contact_form.dart';

class ContactList extends StatefulWidget {

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final ContactDao _dao = ContactDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: FutureBuilder<List<Contact>>( //basicamente um stateful widget
        initialData: List(),
        future: _dao.findAll(), //vai buscar todas as ocorrencias de contatos na lista da database, mas sempre dando um delay porque quando inicia a aplicação vai retornar null
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              print('none');
              break;
            case ConnectionState.waiting: //quando tá carregando
              print('waiting');
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text('Loading'),
                  ],
                ),
              );
              break;
            case ConnectionState.active: //o snapshot tem um dado disponível, mas nao foi finalizado o Future. por exemplo, dados de um download. pra fazer barrinha de progresso.
              break;
            case ConnectionState.done: //quando ja rolou o future
              final List<Contact> contacts = snapshot.data; //estamos dizendo que a lista será o conteudo que é retornado da Future
              return ListView.builder(
                itemBuilder: (context, index) {
                  final Contact contact = contacts[index];
                  return _ContactItem(contact);
                },
                itemCount: contacts.length,
              );
              break;
          }
          return Text('Unknown error'); //nunca vai chegar aqui, pq já cobrimos todos os cenários do switch case. mas precisa ter um retorno de qualquer forma. é sempre bom evitar return null! devolva uma msg genérica de erro
        },
      ),
      //
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ContactForm(),
            ),
          ).then((value) => setState(() {}));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;

  _ContactItem(this.contact);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          title: Text(
        contact.name,
        style: TextStyle(fontSize: 24),
      ),
          subtitle: Text(
        contact.accountNumber.toString(),
        style: TextStyle(fontSize: 16),
      ),
    ));
  }
}
