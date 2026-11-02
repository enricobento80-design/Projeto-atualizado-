// ignore_for_file: unnecessary_getters_setters

import '/backend/schema/util/schema_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ProdutoStruct extends BaseStruct {
  ProdutoStruct({
    int? id,
    String? nome,
    String? descrivao,
    double? preco,
    String? urlImagem,
    String? categoria,
    int? qtdDisp,
  })  : _id = id,
        _nome = nome,
        _descrivao = descrivao,
        _preco = preco,
        _urlImagem = urlImagem,
        _categoria = categoria,
        _qtdDisp = qtdDisp;

  // "id" field.
  int? _id;
  int get id => _id ?? 0;
  set id(int? val) => _id = val;

  void incrementId(int amount) => id = id + amount;

  bool hasId() => _id != null;

  // "nome" field.
  String? _nome;
  String get nome => _nome ?? '';
  set nome(String? val) => _nome = val;

  bool hasNome() => _nome != null;

  // "descrivao" field.
  String? _descrivao;
  String get descrivao => _descrivao ?? '';
  set descrivao(String? val) => _descrivao = val;

  bool hasDescrivao() => _descrivao != null;

  // "preco" field.
  double? _preco;
  double get preco => _preco ?? 0.0;
  set preco(double? val) => _preco = val;

  void incrementPreco(double amount) => preco = preco + amount;

  bool hasPreco() => _preco != null;

  // "url_imagem" field.
  String? _urlImagem;
  String get urlImagem => _urlImagem ?? '';
  set urlImagem(String? val) => _urlImagem = val;

  bool hasUrlImagem() => _urlImagem != null;

  // "categoria" field.
  String? _categoria;
  String get categoria => _categoria ?? '';
  set categoria(String? val) => _categoria = val;

  bool hasCategoria() => _categoria != null;

  // "qtd_disp" field.
  int? _qtdDisp;
  int get qtdDisp => _qtdDisp ?? 0;
  set qtdDisp(int? val) => _qtdDisp = val;

  void incrementQtdDisp(int amount) => qtdDisp = qtdDisp + amount;

  bool hasQtdDisp() => _qtdDisp != null;

  static ProdutoStruct fromMap(Map<String, dynamic> data) => ProdutoStruct(
        id: castToType<int>(data['id']),
        nome: data['nome'] as String?,
        descrivao: data['descrivao'] as String?,
        preco: castToType<double>(data['preco']),
        urlImagem: data['url_imagem'] as String?,
        categoria: data['categoria'] as String?,
        qtdDisp: castToType<int>(data['qtd_disp']),
      );

  static ProdutoStruct? maybeFromMap(dynamic data) =>
      data is Map ? ProdutoStruct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'id': _id,
        'nome': _nome,
        'descrivao': _descrivao,
        'preco': _preco,
        'url_imagem': _urlImagem,
        'categoria': _categoria,
        'qtd_disp': _qtdDisp,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'id': serializeParam(
          _id,
          ParamType.int,
        ),
        'nome': serializeParam(
          _nome,
          ParamType.String,
        ),
        'descrivao': serializeParam(
          _descrivao,
          ParamType.String,
        ),
        'preco': serializeParam(
          _preco,
          ParamType.double,
        ),
        'url_imagem': serializeParam(
          _urlImagem,
          ParamType.String,
        ),
        'categoria': serializeParam(
          _categoria,
          ParamType.String,
        ),
        'qtd_disp': serializeParam(
          _qtdDisp,
          ParamType.int,
        ),
      }.withoutNulls;

  static ProdutoStruct fromSerializableMap(Map<String, dynamic> data) =>
      ProdutoStruct(
        id: deserializeParam(
          data['id'],
          ParamType.int,
          false,
        ),
        nome: deserializeParam(
          data['nome'],
          ParamType.String,
          false,
        ),
        descrivao: deserializeParam(
          data['descrivao'],
          ParamType.String,
          false,
        ),
        preco: deserializeParam(
          data['preco'],
          ParamType.double,
          false,
        ),
        urlImagem: deserializeParam(
          data['url_imagem'],
          ParamType.String,
          false,
        ),
        categoria: deserializeParam(
          data['categoria'],
          ParamType.String,
          false,
        ),
        qtdDisp: deserializeParam(
          data['qtd_disp'],
          ParamType.int,
          false,
        ),
      );

  @override
  String toString() => 'ProdutoStruct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is ProdutoStruct &&
        id == other.id &&
        nome == other.nome &&
        descrivao == other.descrivao &&
        preco == other.preco &&
        urlImagem == other.urlImagem &&
        categoria == other.categoria &&
        qtdDisp == other.qtdDisp;
  }

  @override
  int get hashCode => const ListEquality()
      .hash([id, nome, descrivao, preco, urlImagem, categoria, qtdDisp]);
}

ProdutoStruct createProdutoStruct({
  int? id,
  String? nome,
  String? descrivao,
  double? preco,
  String? urlImagem,
  String? categoria,
  int? qtdDisp,
}) =>
    ProdutoStruct(
      id: id,
      nome: nome,
      descrivao: descrivao,
      preco: preco,
      urlImagem: urlImagem,
      categoria: categoria,
      qtdDisp: qtdDisp,
    );
