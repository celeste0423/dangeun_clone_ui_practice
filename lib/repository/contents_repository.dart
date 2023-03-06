import 'dart:convert';

import 'package:dangeun_clone_ui/repository/local_storage_repository.dart';

class ContentsRepository extends LocalStorageRepository{
  //LocalStorageRepository객체를 상속받음
  final String MY_FAVORITE_STORE_KEY = "MY_FAVORITE_STORE_KEY";
  //눈에 잘 띄게 키 선언

  Map<String, dynamic> data ={
    "ara" : [
      {
        "cid" : "1",
        "image": "assets/images/ara-1.jpg",
        "title": "네메시스 축구화275",
        "location": "제주 제주시 아라동",
        "price": "30000",
        "likes": "2"
      },
      {
        "cid" : "2",
        "image": "assets/images/ara-2.jpg",
        "title": "LA갈비 5kg팔아요~",
        "location": "제주 제주시 아라동",
        "price": "100000",
        "likes": "5"
      },
      {
        "cid" : "3",
        "image": "assets/images/ara-3.jpg",
        "title": "치약팝니다",
        "location": "제주 제주시 아라동",
        "price": "5000",
        "likes": "0"
      },
      {
        "cid" : "4",
        "image": "assets/images/ara-4.jpg",
        "title": "[풀박스]맥북프로16인치 터치바 스페이스그레이",
        "location": "제주 제주시 아라동",
        "price": "2500000",
        "likes": "6"
      },
      {
        "cid" : "5",
        "image": "assets/images/ara-5.jpg",
        "title": "디월트존기임팩",
        "location": "제주 제주시 아라동",
        "price": "150000",
        "likes": "2"
      },
      {
        "cid" : "6",
        "image": "assets/images/ara-6.jpg",
        "title": "갤럭시s10",
        "location": "제주 제주시 아라동",
        "price": "180000",
        "likes": "2"
      },
      {
        "cid" : "6",
        "image": "assets/images/ara-7.jpg",
        "title": "선반",
        "location": "제주 제주시 아라동",
        "price": "15000",
        "likes": "2"
      },
      {
        "cid" : "7",
        "image": "assets/images/ara-8.jpg",
        "title": "냉장 쇼케이스",
        "location": "제주 제주시 아라동",
        "price": "80000",
        "likes": "3"
      },
      {
        "cid" : "8",
        "image": "assets/images/ara-9.jpg",
        "title": "대우 미니냉장고",
        "location": "제주 제주시 아라동",
        "price": "30000",
        "likes": "3"
      },
      {
        "cid" : "9",
        "image": "assets/images/ara-10.jpg",
        "title": "멜킨스 풀업 턱걸이 판매합니다.",
        "location": "제주 제주시 아라동",
        "price": "50000",
        "likes": "7"
      },
    ],
    "ora" : [
      {
        "cid" : "1",
        "image": "assets/images/ora-1.jpg",
        "title": "LG 통돌이세탁기 15kg(내부",
        "location": "제주 제주시 오라동",
        "price": "150000",
        "likes": "13"
      },
      {
        "cid" : "2",
        "image": "assets/images/ora-2.jpg",
        "title": "3단책장 전면책장 가져가실분",
        "location": "제주 제주시 오라동",
        "price": "무료나눔",
        "likes": "6"
      },
      {
        "cid" : "3",
        "image": "assets/images/ora-3.jpg",
        "title": "브리츠 컴퓨터용 스피커",
        "location": "제주 제주시 오라동",
        "price": "1000",
        "likes": "4"
      },
      {
        "cid" : "4",
        "image": "assets/images/ora-4.jpg",
        "title": "안락 의자",
        "location": "제주 제주시 오라동",
        "price": "10000",
        "likes": "1"
      },
      {
        "cid" : "5",
        "image": "assets/images/ora-5.jpg",
        "title": "어린이책 무료드림",
        "location": "제주 제주시 오라동",
        "price": "무료나눔",
        "likes": "1"
      },
      {
        "cid" : "6",
        "image": "assets/images/ora-6.jpg",
        "title": "어린이책 무료드림",
        "location": "제주 제주시 오라동",
        "price": "무료나눔",
        "likes": "0"
      },
      {
        "cid" : "7",
        "image": "assets/images/ora-7.jpg",
        "title": "칼세트 재제품 팝니다",
        "location": "제주 제주시 오라동",
        "price": "20000",
        "likes": "5"
      },
      {
        "cid" : "8",
        "image": "assets/images/ora-8.jpg",
        "title": "아이팜장난감정리함팔아요",
        "location": "제주 제주시 오라동",
        "price": "30000",
        "likes": "29"
      },
      {
        "cid" : "9",
        "image": "assets/images/ora-9.jpg",
        "title": "한색책상책장수납장세트 팝니다.",
        "location": "제주 제주시 오라동",
        "price": "1500000",
        "likes": "1"
      },
      {
        "cid" : "10",
        "image": "assets/images/ora-10.jpg",
        "title": "순성 데일리 오가닉 카시트",
        "location": "제주 제주시 오라동",
        "price": "60000",
        "likes": "8"
      },
    ],
  };

  Future<List<Map<String, String>>> loadContentsFromLocation(String location) async{
    //API 통신 location갑을 보내주면서
    await Future.delayed(Duration(milliseconds: 1000));
    return data[location];
  }

  addMyFavoriteContent(Map<String, String> content) async{
    String? jsonString = await this.getStoredValue(MY_FAVORITE_STORE_KEY);
    List<dynamic> favoriteContentList = jsonDecode(jsonString!);
    favoriteContentList.add(content);
    //리스트화 시킴

    this.storeValue(MY_FAVORITE_STORE_KEY, jsonEncode(favoriteContentList));
    //부모가 상속을 받았기 때문에 this로 그대로 들고옴
    //key에는 위에서 선언한 key 들고옴
    //value에는 jsonEncode를 이용하면 알아서 content(String)의 내용을 json으로 인코딩해줌
    //따라서 저장이 됨

 }
 isMyFavoritecontents(String cid)async{
    String? jsonString = await this.getStoredValue(MY_FAVORITE_STORE_KEY);
    bool isMyFavoriteContents = false;
    if(jsonString != null){ //nullSafety
      List<dynamic> json = jsonDecode(jsonString); //null값이 아니면 String값으로 디코딩함
      if(json == null || !(json is List)) { //예외 처리
        return false;
      }else{
        for(dynamic data in json){
          if(data["cid"] == cid){
            isMyFavoriteContents = true;
            break; //리스트를 돌면서 true 인 것들은 다 바꿔줌
          }
        }
      }
      return isMyFavoriteContents; //같으면 true, 아니면 false 반환함
    }else{
      return null;
    }
    //정보 읽음
 }
}