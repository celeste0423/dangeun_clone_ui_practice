import 'package:intl/intl.dart';

class DataUtils {
  //원단위로 바꿔주는
  static final oCcy = new NumberFormat(
      "#,###", "ko_KR"); //static 을 추가해주면 전역적으로 사용 가능 -> DataUtils.calcStringToWon 사용
  // intl 라이브러리 이용 형식 지정
  static String calcStringToWon(String priceString) {
    if (priceString == "무료나눔") return priceString;
    //원 붙여주는 함수
    return "${oCcy.format(int.parse(priceString))} 원";
    //int 형 자료로 형 변환 : int.parse()사용
    //format
    }
  }