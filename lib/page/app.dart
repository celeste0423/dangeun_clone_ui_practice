import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/page/home.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _currentPageIndex = 0; // 페이지 별 index 설정

  @override

  Widget _homeWidget() {
    switch(_currentPageIndex) {
      case 0:
        return Home();
        break;
      case 1:
        return Container();
        break;
      case 2:
        return Container();
        break;
      case 3:
        return Container();
        break;
      case 4:
        return Container();
        break;
    }
    return Container();
  }

  BottomNavigationBarItem _bottomNavigationBarItem(String iconName, String label) {
    return BottomNavigationBarItem(
        icon: Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: SvgPicture.asset("assets/svg/${iconName}_off.svg", width: 22),
        ),
        activeIcon: Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: SvgPicture.asset("assets/svg/${iconName}_on.svg", width: 22),
      ),
        label : label,
    );
  }// 바텀네비게이션 아이콘과 라벨 메소드화 시킴

  Widget _bottomNavigationBarwidget() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, // index 선택 시 애니메이션 종류
      selectedLabelStyle: TextStyle(fontSize: 12 ,color: Colors.black),
      selectedItemColor: Colors.black,
      onTap: (int index){
        setState(() {
          _currentPageIndex = index;
        });
      }, // 클릭시마다 해당하는 item index 불러옴
      currentIndex: _currentPageIndex,
      items: [
        _bottomNavigationBarItem("home", "홈"),
        _bottomNavigationBarItem("notes", "동네생활"),
        _bottomNavigationBarItem("location", "내 근처"),
        _bottomNavigationBarItem("chat", "채팅"),
        _bottomNavigationBarItem("user", "나의 당근"),
      ]
    );
  }

  @override // 메인 위젯 창
  Widget build(BuildContext context) {
    return Scaffold(
      body: _homeWidget(),
      bottomNavigationBar: _bottomNavigationBarwidget(),
    );
  }
}
