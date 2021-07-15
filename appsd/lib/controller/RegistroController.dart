

import 'package:appsd/api/ApiRegistro.dart';
import 'package:appsd/api/ApiUtil.dart';
import 'package:appsd/model/Registro.dart';

class RegistroController {



  Future<List<Registro>> listarRegistros( String filtro) async{

    String url =  ApiUtil.url+ApiUtil.urlRegistro+"/"+filtro;

    return await new ApiRegistro().listarRegistros(url);
  }

  Future<String> salvarRegistros( Registro registro) async{

    String url =  ApiUtil.url+ApiUtil.urlRegistro;
    Map<String, dynamic> registroMap = registro.toJson();
    if (registroMap.containsKey("id")) {
      registroMap.remove("id");
    }
    return await new ApiRegistro().apiRegistroPost(url,registroMap);
  }
  Future<String> atualizarRegistro(Registro registro) async {

    String url =  ApiUtil.url+ApiUtil.urlRegistro;

    return await new ApiRegistro().apiRegistroPut(url,registro);
  }

}