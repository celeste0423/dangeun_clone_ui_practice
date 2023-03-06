import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorageRepository{
  final storage = FlutterSecureStorage(); //스토리지 생성

  Future<String?> getStoredValue(String key) async { //정보 읽을 때 사용
    try{
      return await storage.read(key: key); //읽을때는 await해서, async로
    }catch(error){
      return null;
    }
  }

  Future<void> storeValue(String key, String value) async{
    try{
      return await storage.write(key: key, value: value);
    }catch(error){
      return null;
    }
  }

}
