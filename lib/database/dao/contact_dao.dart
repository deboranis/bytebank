import 'package:newbytebank/database/app_database.dart';
import 'package:newbytebank/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactDao {

  static const String tableSql = 'CREATE TABLE $_tableName(' // const é para valores que não mudam seu estado
      '$_id INTEGER PRIMARY KEY, '
      '$_name TEXT, '
      '$_accountNumber INTEGER)';
  static const String _tableName = 'contacts';
  static const String _id = 'id';
  static const String _name = 'name';
  static const String _accountNumber = 'account_number';

  Future<int> save(Contact contact) async {
    final Database db = await getDatabase();
    Map<String, dynamic> contactMap = _toMap(contact);
    return db.insert(_tableName, contactMap); //recebe o nome da tabela para inserir valores. recebe tbm values, que é um mapa de objeto. pra isso, estamos criando o mapa acima
  }

  Map<String, dynamic> _toMap(Contact contact) {
    final Map<String, dynamic> contactMap = Map();
    contactMap[_name] = contact.name; //aqui não deixamos a referência do id porque o próprio database vai criar Ids diferentes a cada inserção de contato
    contactMap[_accountNumber] = contact.accountNumber;
    return contactMap;
  }

  // return getDatabase().then((db) {
  //   final Map<String, dynamic> contactMap = Map();
  //   contactMap['name'] = contact.name; //aqui não deixamos a referência do id porque o próprio database vai criar Ids diferentes a cada inserção de contato
  //   contactMap['account_number'] = contact.accountNumber;
  //   return db.insert('contacts', contactMap); //recebe o nome da tabela para inserir valores. recebe tbm values, que é um mapa de objeto. pra isso, estamos criando o mapa acima
  // });
// }

  Future<List<Contact>> findAll() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    List<Contact> contacts = _toList(result);
    // final List<Contact> contacts = List();
    // for (Map<String, dynamic> row in result) {
    //   final Contact contact = Contact(
    //     row['id'],
    //     row['name'],
    //     row['account_number'],
    //   );
    //   contacts.add(contact);
    // } código extraído para o método _toList com ctrl+alt+m
    return contacts;

    // return getDatabase().then((db) {
    //   return db.query('contacts').then((maps) {
    //     final List<Contact> contacts = List();
    //     for (Map<String, dynamic> map in maps) {
    //       final Contact contact = Contact(
    //         map['id'],
    //         map['name'],
    //         map['account_number'],
    //       );
    //       contacts.add(contact);
    //     }
    //     return contacts;
    //   });
    // });
  }

  List<Contact> _toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = List();
    for (Map<String, dynamic> row in result) {
      final Contact contact = Contact(
        row[_id],
        row[_name],
        row[_accountNumber],
      );
      contacts.add(contact);
    }
    return contacts;
  }
}