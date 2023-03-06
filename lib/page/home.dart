import 'package:dangeun_clone_ui/page/detail.dart';
import 'package:dangeun_clone_ui/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../repository/contents_repository.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? currentLocation;
  ContentsRepository contentsRepository = ContentsRepository();
  final Map<String, String> locationTypeToString = {
    "ara": "아라동",
    "ora": "오라동",
    "donam": "도남동",
  }; // 지역 표시 형 변환

  @override
  void initState() {
    //앱 처음 구동 시 상태
    super.initState();
    currentLocation = "ara";
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      //leading은 정사각형으로 잘림 해결 불가..ㅠ
      title: GestureDetector(
        //드롭다운박스에는 InkWell, GestureDetector 2가지 주로 씀
        onTap: () {
          print("click");
        },
        child: PopupMenuButton<String>(
          offset: Offset(0, 40), // 박스 위치
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            1,
          ), // 드랍다운 박스 디자인
          onSelected: (String where) {
            setState(() {
              currentLocation = where;
            });
          },
          itemBuilder: (BuildContext context) {
            //드랍다운 박스에 표시할 아이템
            return [
              PopupMenuItem(
                value: "ara",
                child: Text("아라동"),
              ),
              PopupMenuItem(
                value: "ora",
                child: Text("오라동"),
              ),
              PopupMenuItem(
                value: "donam",
                child: Text("도남동"),
              ),
            ];
          },
          child: Row(
            children: [
              Text(locationTypeToString[currentLocation] ?? ""),
              // ??연산자는 앞에가 null이면 뒷값 출력, 아니면 앞값 출력
              Icon(Icons.arrow_drop_down),
            ],
          ),
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

  _loadContents() {
    return contentsRepository.loadContentsFromLocation(currentLocation ?? "");
  }

  _makeDataList(List<Map<String, String>> datas) { //datas를 contents_repository data에서 가져옴
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (BuildContext _context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return DetailContentView(
                data: datas[index],
                  );
                },
              ),
            );
            print(datas[index]["title"]);
          }, // 각 리스트 중 하나를 눌렀을 때
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                //child 마스크 효과, 해당 위젯 위를 덮어줌, borderRadius
                ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Hero( // 사진 연결 트랜지션
                      tag: 'image_${index}_${datas[index]["cid"]}',
                      child: Image.asset(
                        datas[index]["image"]!,
                        width: 100,
                        height: 100,
                      ),
                    )),
                Expanded(
                  child: Container(
                      height: 100,
                      padding: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            datas[index]["title"]!,
                            overflow: TextOverflow.ellipsis,
                            //넘치는 부분에 ...으로 오버플로우 시킴
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(height: 5),
                          Text(
                            datas[index]["location"]!,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.5)),
                          ),
                          SizedBox(height: 5),
                          Text(DataUtils.calcStringToWon(datas[index]["price"]!),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                              )),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/heart_off.svg",
                                  width: 13,
                                  height: 13,
                                ),
                                SizedBox(width: 5),
                                Text(datas[index]["likes"]!),
                              ],
                            ),
                          ),
                        ],
                      )),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext _context, int index) {
        return Container(height: 1, color: Colors.black.withOpacity(0.4));
      },
      itemCount: 10,
    );
  }

  Widget _bodyWidget() {
    return FutureBuilder(
        // 미래 값을 기다렸다가 빌드
        future: _loadContents(),
        builder: (BuildContext context, dynamic snapshot) {
          //snapshot을 이용하면 다양한 에러상황에 표시할 내용 대처 가능
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
                child: CircularProgressIndicator(
              color: Colors.orangeAccent,
            ));
          } // 화면에 오류가 뜰때 ( ConnectionState가 done이 아닐때) 로딩 창을 띄워줌
          if (snapshot.hasError == "Exception") {
            // 데이터가 없을 때 null값이 들어와 오류가 발생하므로 Exception으로 분리
            return Center(child: Text("데이터 오류"));
          } // 에러 화면일 때 띄워줄 것들
          if (snapshot.hasData) {
            return _makeDataList(snapshot.data);
          }

          return Center(child: Text("해당 지역에 데이터가 없습니다"));
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
