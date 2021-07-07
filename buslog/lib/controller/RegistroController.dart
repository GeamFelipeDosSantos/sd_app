import 'package:ADMob/api/ApiRegistro.dart';
import 'package:ADMob/api/ApiUtil.dart';
import 'package:ADMob/model/Registro.dart';

class RegistroController {


  ///Busca SA's por filial e [PESSOA, SA, REQUISIÇÃO, OS].
  Future<List<Registro>> listarSolicitacoes(int EMPRESA, String FILTRO, String TIPO_FILTRO) async{

    String url =  ApiUtil.url+ApiUtil.urlRegistro+"/"+FILTRO+"/"+TIPO_FILTRO;

    return await new ApiRegistro().listarRegistros(url);
  }

}