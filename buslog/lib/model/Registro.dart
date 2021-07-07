
class Registro {

  int    id;
  String descricaoProblema;
  String cidade;
  String linha;
  String horarioLinha;
  String resolvido;
  String dtRegistro;
  String dtResolucao;


  Registro.padrao();
  Registro.opcional(this.descricaoProblema,this.cidade,this.linha,this.horarioLinha,this.resolvido, this.dtRegistro, this.dtResolucao);
  Registro({this.id, this.descricaoProblema,this.cidade,this.linha,this.horarioLinha,this.resolvido, this.dtRegistro, this.dtResolucao});
  Registro.opcionalJson({this.descricaoProblema,this.cidade,this.linha,this.horarioLinha,this.resolvido, this.dtRegistro, this.dtResolucao});

  factory Registro.fromJson(Map<String, dynamic> json) {
    return Registro(

        id:json['id'],
        descricaoProblema:json['descricao_problema'],
        cidade:json['cidade'],
        linha:json['linha'],
        horarioLinha:json['horario_linha'],
        resolvido:json['resolvido'],
        dtRegistro:json['dt_registro'],
        dtResolucao:json['dt_resolucao']
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'id':id,
        'descricao_problema':descricaoProblema,
        'cidade':cidade,
        'linha':linha,
        'horario_linha':horarioLinha,
        'resolvido':resolvido,
        'dt_registro':dtRegistro,
        'dt_resolucao':dtResolucao
      };



}