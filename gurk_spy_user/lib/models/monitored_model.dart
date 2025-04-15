class Monitored {
  final String nome;
  final int idade;
  final String endereco;
  final String codigoRastreamento;

  Monitored({
    required this.nome,
    required this.idade,
    required this.endereco,
    required this.codigoRastreamento,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'idade': idade,
      'endereco': endereco,
      'codigoRastreamento': codigoRastreamento,
    };
  }
}
