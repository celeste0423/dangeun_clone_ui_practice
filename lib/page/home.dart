import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, String>> datas = [];

  @override
  void initState() {
    super.initState();
    datas = [
      {
        "image": "assets/images/1.jpg",
        "title": "네메시스 축구화275",
        "location": "제주 제주시 아라동",
        "price": "30000",
        "likes": "2"
      },
      {
      "image": "assets/images/2.jpg",
      "title": "LA갈비 5kg팔아요~",
      "location": "제주 제주시 아라동",
      "price": "100000",
      "likes": "5"
      },
      {
      "image": "assets/images/3.jpg",
      "title": "치약팝니다",
      "location": "제주 제주시 아라동",
      "price": "5000",
      "likes": "0"
      },
      {
      "image": "assets/images/4.jpg",
      "title": "[풀박스]맥북프로16인치 터치바 스페이스그레이",
      "location": "제주 제주시 아라동",
      "price": "2500000",
      "likes": "6"
      },
      {
      "image": "assets/images/5.jpg",
      "title": "디월트존기임팩",
      "location": "제주 제주시 아라동",
      "price": "150000",
      "likes": "2"
      },
      {
      "image": "assets/images/6.jpg",
      "title": "갤럭시s10",
      "location": "제주 제주시 아라동",
      "price": "180000",
      "likes": "2"
      },
      {
      "image": "assets/images/7.jpg",
      "title": "선반",
      "location": "제주 제주시 아라동",
      "price": "15000",
      "likes": "2"
      },
      {
      "image": "assets/images/8.jpg",
      "title": "냉장 쇼케이스",
      "location": "제주 제주시 아라동",
      "price": "80000",
      "likes": "3"
      },
      {
      "image": "assets/images/9.jpg",
      "title": "대우 미니냉장고",
      "location": "제주 제주시 아라동",
      "price": "30000",
      "likes": "3"
      },
      {
      "image": "assets/images/10.jpg",
      "title": "멜킨스 풀업 턱걸이 판매합니다.",
      "location": "제주 제주시 아라동",
      "price": "50000",
      "likes": "7"
      },
    ];
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      //leading은 정사각형으로 잘림 해결 불가..ㅠ
      title: GestureDetector(
        //드롭다운박스에는 InkWell, GestureDetector 2가지 주로 씀
        onTap: () {
          print("click");
        },
        child: Row(
          children: [
            Text("아라동"),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
      elevation: 1,
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.tune),
        ),
        IconButton(
          onPressed: () {},
          icon: SvgPicture.asset("assets/svg/bell.svg"),
        ),
      ],
    );
  }

  Widget _bodyWidget() {
    return ListView.separated(
        itemBuilder: (BuildContext _context, int index){
          return Container(
            child: Text(index.toString()),);
        },
        separatorBuilder: (BuildContext _context, int index){
          return Container(
              height: 1,
              color: Color(0xff999999));
        },
        itemCount: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
