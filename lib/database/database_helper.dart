import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Classe responsável por gerenciar a conexão com o banco de dados SQLite
/// e realizar as transações de autenticação, inserção, consulta, alteração e deleção.
class DatabaseHelper {
  static final DatabaseHelper _instancia = DatabaseHelper._interno();
  static Database? _bancoDeDados;
  static DatabaseHelper get instancia => _instancia;

  factory DatabaseHelper() => _instancia;

  DatabaseHelper._interno();

  /// Inicia a conexão com o banco de dados.
  Future<Database> get bancoDeDados async {
    if (_bancoDeDados != null) return _bancoDeDados!;
    _bancoDeDados = await _iniciarBanco();
    return _bancoDeDados!;
  }

  /// Configura o caminho do banco no dispositivo e cria as tabelas se for a primeira execução.
  Future<Database> _iniciarBanco() async {
    String caminhoBanco = await getDatabasesPath();
    String caminhoCompleto = join(caminhoBanco, 'coma_bem.db');
    return await openDatabase(caminhoCompleto, version: 1, onCreate: _criarTabelas);
  }

  /// Cria a estrutura inicial do banco de dados (Tabelas do App Coma Bem).
  Future<void> _criarTabelas(Database db, int versao) async {
    // Tabela 1: usuario
    await db.execute('''
      CREATE TABLE usuario (
        usu_id_usuario INTEGER PRIMARY KEY AUTOINCREMENT,
        usu_nm_usuario TEXT NOT NULL,
        usu_tx_email TEXT NOT NULL UNIQUE,
        usu_tx_senha TEXT NOT NULL
      )
    ''');

    // Tabela 2: restaurante
    await db.execute('''
      CREATE TABLE restaurante (
        res_id_restaurante INTEGER PRIMARY KEY AUTOINCREMENT,
        res_nm_restaurante TEXT NOT NULL,
        res_nu_latitude TEXT NOT NULL,
        res_nu_longitude TEXT NOT NULL,
        res_ds_tipo_culinaria TEXT NOT NULL
      )
    ''');

    // Tabela 3: prato
    await db.execute('''
      CREATE TABLE prato (
        pra_id_prato INTEGER PRIMARY KEY AUTOINCREMENT,
        pra_nm_prato TEXT NOT NULL,
        pra_im_foto TEXT,
        pra_id_restaurante INTEGER NOT NULL,
        FOREIGN KEY (pra_id_restaurante) REFERENCES restaurante (res_id_restaurante)
      )
    ''');

    // Tabela 4: avaliacao
    await db.execute('''
      CREATE TABLE avaliacao (
        avl_id_avaliacao INTEGER PRIMARY KEY AUTOINCREMENT,
        avl_nu_ranking INTEGER NOT NULL,
        avl_tx_recomendacao TEXT NOT NULL,
        avl_id_prato INTEGER NOT NULL,
        avl_id_usuario INTEGER NOT NULL,
        FOREIGN KEY (avl_id_prato) REFERENCES prato (pra_id_prato),
        FOREIGN KEY (avl_id_usuario) REFERENCES usuario (usu_id_usuario)
      )
    ''');
  }

  // ================================================================
  // TRANSAÇÕES DE MANIPULAÇÃO DE DADOS (CRUD) E AUTENTICAÇÃO
  // ================================================================

  /// Realiza a AUTENTICAÇÃO do usuário.
  Future<Map<String, dynamic>?> autenticarUsuario(String email, String senha) async {
    Database db = await bancoDeDados;
    List<Map<String, dynamic>> resultado = await db.query(
      'usuario',
      where: 'usu_tx_email = ? AND usu_tx_senha = ?',
      whereArgs: [email, senha],
    );
    if (resultado.isNotEmpty) return resultado.first;
    return null;
  }

  /// Realiza a INSERÇÃO (Create) genérica de um novo registro.
  Future<int> inserirDados(String tabela, Map<String, dynamic> dados) async {
    Database db = await bancoDeDados;
    return await db.insert(tabela, dados);
  }

  /// Realiza a CONSULTA (Read) genérica de registros.
  Future<List<Map<String, dynamic>>> consultarDados(String tabela) async {
    Database db = await bancoDeDados;
    return await db.query(tabela);
  }

  /// Realiza a ALTERAÇÃO (Update) genérica de um registro existente.
  Future<int> alterarDados(String tabela, Map<String, dynamic> novosDados, String colunaId, int id) async {
    Database db = await bancoDeDados;
    return await db.update(
      tabela,
      novosDados,
      where: '$colunaId = ?',
      whereArgs: [id],
    );
  }

  /// Realiza a DELEÇÃO (Delete) genérica de um registro.
  Future<int> deletarDados(String tabela, String colunaId, int id) async {
    Database db = await bancoDeDados;
    return await db.delete(
      tabela,
      where: '$colunaId = ?',
      whereArgs: [id],
    );
  }

  // ================================================================
  // FUNÇÕES ESPECÍFICAS DE CRUD SOLICITADAS NOS PASSOS DA ATIVIDADE
  // ================================================================

  /// Passo 2: Insere um novo restaurante no banco de dados[cite: 43].
  Future<void> inserirRestaurante(Map<String, dynamic> dadosRestaurante) async {
    try {
      Database db = await bancoDeDados;
      int idGerado = await db.insert('restaurante', dadosRestaurante);
      print('Sucesso: Restaurante cadastrado com o ID $idGerado.');
    } catch (erro) {
      print('Erro ao tentar cadastrar o restaurante: $erro');
    }
  }

  /// Passo 3: Retorna uma lista de restaurantes filtrada pelo tipo de culinária[cite: 44].
  Future<List<Map<String, dynamic>>> listarRestaurantesPorTipo(String tipo) async {
    try {
      Database db = await bancoDeDados;
      List<Map<String, dynamic>> lista = await db.query(
        'restaurante',
        where: 'res_ds_tipo_culinaria = ?',
        whereArgs: [tipo],
      );
      print('Sucesso: Foram encontrados ${lista.length} restaurantes.');
      return lista;
    } catch (erro) {
      print('Erro ao buscar restaurantes do tipo $tipo: $erro');
      return [];
    }
  }

  /// Passo 4: Atualiza o ranking (nota) e o texto de recomendação de uma avaliação[cite: 45].
  Future<void> atualizarAvaliacao(int idAvaliacao, int novaNota, String novoTexto) async {
    try {
      Database db = await bancoDeDados;
      int linhasAfetadas = await db.update(
        'avaliacao',
        {'avl_nu_ranking': novaNota, 'avl_tx_recomendacao': novoTexto},
        where: 'avl_id_avaliacao = ?',
        whereArgs: [idAvaliacao],
      );

      if (linhasAfetadas > 0) {
        print('Sucesso: Avaliação atualizada.');
      } else {
        print('Aviso: Nenhum avaliaçao encontrada com o ID $idAvaliacao.');
      }
    } catch (erro) {
      print('Erro ao atualizar a avaliação: $erro');
    }
  }

  /// Passo 5: Exclui permanentemente um prato do cardápio utilizando seu ID[cite: 46].
  Future<void> removerPrato(int idPrato) async {
    try {
      Database db = await bancoDeDados;
      int linhasAfetadas = await db.delete(
        'prato',
        where: 'pra_id_prato = ?',
        whereArgs: [idPrato],
      );

      if (linhasAfetadas > 0) {
        print('Sucesso: Prato deletado do cardápio.');
      } else {
        print('Aviso: Nenhuma prato encontrado com o ID $idPrato.');
      }
    } catch (erro) {
      print('Erro ao tentar remover o prato: $erro');
    }
  }

  /// Passo 6: Retorna restaurantes cujo nome contenha o trecho digitado (Busca aproximada)[cite: 47].
  Future<List<Map<String, dynamic>>> buscarRestaurantePorNome(String termoBusca) async {
    try {
      Database db = await bancoDeDados;
      List<Map<String, dynamic>> lista = await db.query(
        'restaurante',
        where: 'res_nm_restaurante LIKE ?',
        whereArgs: ['%$termoBusca%'],
      );
      print('Sucesso: Foram encontrados ${lista.length} restaurantes contendo "$termoBusca".');
      return lista;
    } catch (erro) {
      print('Erro ao buscar restaurante por nome: $erro');
      return [];
    }
  }

  /// Passo 7: Retorna todos os pratos vinculados ao ID de um restaurante específico[cite: 48].
  Future<List<Map<String, dynamic>>> listarPratosPorRestaurante(int idRestaurante) async {
    try {
      Database db = await bancoDeDados;
      List<Map<String, dynamic>> cardapio = await db.query(
        'prato',
        where: 'pra_id_restaurante = ?',
        whereArgs: [idRestaurante],
      );
      print('Sucesso: ${cardapio.length} pratos carregados para o restaurante ID $idRestaurante.');
      return cardapio;
    } catch (erro) {
      print('Erro ao carregar o cardápio: $erro');
      return [];
    }
  }
}