import 'package:newbytebank/database/dao/contact_dao.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  final String path = join(await getDatabasesPath(), 'bytebank.db');
  return openDatabase(path, onCreate: (db, version) {
        db.execute(ContactDao.tableSql); // o codigo SQL que vai criar a tabela com os dados e o tipo de dado
      }, version: 1,
        // onDowngrade: onDatabaseDowngradeDelete,
      );

  // return getDatabasesPath().then((dbPath) {
  //   final String path = join(dbPath, 'bytebank.db'); //implementando a callback do then. criando o arquivo que vai representar o banco de dados. esse Join é uma função do PATH que adicionamos no pubspec
  //
  // }); //essa chamada getDatabasesPath devolve um Future, que vai receber um caminho, que é uma string. acessamos o Future por meio do then
}

//esse código cria o banco de dados, cria a tabela e define que a versão é a 1

