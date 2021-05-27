import 'package:newbytebank/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'bytebank.db');
  return openDatabase(path, onCreate: (db, version) {
        db.execute('CREATE TABLE contacts('
            'id INTEGER PRIMARY KEY, '
            'name TEXT, '
            'account_number INTEGER)'); // o codigo SQL que vai criar a tabela com os dados e o tipo de dado
      }, version: 1,
        // onDowngrade: onDatabaseDowngradeDelete,
      );

  // return getDatabasesPath().then((dbPath) {
  //   final String path = join(dbPath, 'bytebank.db'); //implementando a callback do then. criando o arquivo que vai representar o banco de dados. esse Join é uma função do PATH que adicionamos no pubspec
  //
  // }); //essa chamada getDatabasesPath devolve um Future, que vai receber um caminho, que é uma string. acessamos o Future por meio do then
}

//esse código cria o banco de dados, cria a tabela e define que a versão é a 1

Future<int> save(Contact contact) async {
  final Database db = await getDatabase();
    final Map<String, dynamic> contactMap = Map();
    contactMap['name'] = contact.name; //aqui não deixamos a referência do id porque o próprio database vai criar Ids diferentes a cada inserção de contato
    contactMap['account_number'] = contact.accountNumber;
    return db.insert('contacts', contactMap); //recebe o nome da tabela para inserir valores. recebe tbm values, que é um mapa de objeto. pra isso, estamos criando o mapa acima
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
  final List<Map<String, dynamic>> result = await db.query('contacts');
  final List<Contact> contacts = List();
    for (Map<String, dynamic> row in result) {
        final Contact contact = Contact(
          row['id'],
          row['name'],
          row['account_number'],
        );
        contacts.add(contact);
      }
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
