/// Classe que representa a tabela de Usuários do banco de dados.
abstract class Usuario {
  // Atributos privados (encapsulamento utilizando o prefixo _)
  final int _idUsuario;
  String _nomeUsuario;
  String _email;
  String _senha;

  // Construtor nomeado para inicializar os objetos
  Usuario(this._idUsuario, this._nomeUsuario, this._email, this._senha);

  // Getters: permitem ler os dados protegidos
  int get idUsuario => _idUsuario;
  String get nomeUsuario => _nomeUsuario;
  String get email => _email;
  String get senha => _senha;

  // Setters: permitem alterar os dados protegidos de forma controlada
  set nomeUsuario(String nome) {
    _nomeUsuario = nome;
  }

  set email(String email) {
    _email = email;
  }

  // O acesso à senha deve ser rigoroso. O setter permite alteração,
  // mas em um app real aqui entraria a lógica de criptografia.
 set senha(String novaSenha) {
  if (novaSenha.length >= 6) {
    _senha = novaSenha;
    print('✅ Senha alterada com sucesso!');
  } else {
    print('❌ Erro: A senha deve ter no mínimo 6 caracteres.');
  }
 }
  // Métodos Abstratos (Polimorfismo)
  void exibirMenu();
  void gerenciarConta();
  
}