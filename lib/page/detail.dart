import 'package:carousel_slider/carousel_slider.dart'; //사진 슬라이드
import 'package:dangeun_clone_ui/components/manor_temperature_widget.dart';
import 'package:dangeun_clone_ui/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../repository/contents_repository.dart';

class DetailContentView extends StatefulWidget {
  Map<String, String> data;

  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with SingleTickerProviderStateMixin {
  //추가로 SingleTickerProviderStateMinxin을 상속받음 => animationController를 사용할때 필수
  //만약 여러개의 animationController를 쓸 경우 TickerProviderStateMinxin을 사용
  late Size size;
  late List<Map<String, String>> imgList;
  late int _current;
  late ScrollController _controller = ScrollController();

  double scrollpositionToAlpha = 0; //스크롤 위치를 통해 색상알파값 바꿀예정
  late AnimationController _animationController;
  late Animation _colorTween; //버튼 색상 전환 트랜지션을 위해 만들어놓음

  bool isMyFavoriteContent = false; //좋아요 여부를 판단하기 위해서
  ContentsRepository contentsRepository = ContentsRepository(); //생성자 ContentsRepository거 들고와서 선언

  double _currentSliderValue = 0;


  @override
  void initState() {
    super.initState();

    contentsRepository = ContentsRepository();

    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(
      begin: Colors.white,
      end: Colors.black,
    ).animate(_animationController);
    //colorTween메소드를 이용하여 색상이 변화하는 에니메이션을 기록해놓음

    _controller.addListener(() {
      setState(() {
        if(_controller.offset > 255){
          scrollpositionToAlpha = 255;
          //알파값이 255가 넘으면 그냥 최댓값으로 고정
        }
        else{
          scrollpositionToAlpha = _controller.offset; //초기값 세팅
          //_controller.offset => 스크롤 위치값을 반환함
        }
        _animationController.value = scrollpositionToAlpha / 255;
        //0과 1의 사이의 값을 갖게 함
      });
    });

    _loadMyFavoriteContentState(); //저장된 좋아요 정보 읽기
  }

  _loadMyFavoriteContentState()async{
    bool ck = await contentsRepository.isMyFavoritecontents(widget.data["cid"]!);
    //item의 cid를 통해 좋아한 아이템이 맞는 지 확인
    //contentsRepository 내부의 함수에서 불러옴
    setState(() {
      isMyFavoriteContent = ck;
    });
  }

  Widget _makeIcon(IconData icon){ //모든 아이콘에 사용하기 위해 아이콘 데이터를 위젯으로
    return AnimatedBuilder( //에니메이션이 있으면 AnimatedBuilder로 묶을것
      animation: _colorTween,
      builder:(context, child) => Icon( //필수로 Builder(context,child)를 받아야함
          icon,
          color: _colorTween.value //colortween.value로 해야함
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size;
    //디바이스의 가로,세로 폭을 따옴 -> 변수로 이용 size
    imgList = [
      {"id": "0", "url": widget.data["image"]!},
      {"id": "1", "url": widget.data["image"]!},
      {"id": "2", "url": widget.data["image"]!},
      {"id": "3", "url": widget.data["image"]!},
      {"id": "4", "url": widget.data["image"]!},
    ];
    _current = 0;
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
        backgroundColor: Colors.white.withAlpha(scrollpositionToAlpha.toInt()),
        //반환받은 스크롤 위치에 따른 알파값을 정수로 바꿔서 색상에 넣음
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context); // 뒤로가기 기능
            },
            icon: _makeIcon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: _makeIcon(Icons.share),
          ),
          IconButton(
            onPressed: () {},
            icon: _makeIcon(Icons.more_vert),
          ),
        ]);
  }

  Widget _makeSliderimage() {
    return Container(
      child: Stack(
        children: [
          Hero(
            //사진 연결 트랜지션, 사진별 cid 값 생성 후 그 값을 tag에 붙여놓으면 됨
            tag: 'cid_${widget.data["cid"]}',
            child: CarouselSlider(
              options: CarouselOptions(
                  height: size.width,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: imgList.map(
                (map) {
                  return Image.asset(
                    map["url"]!,
                    width: size.width,
                    fit: BoxFit.fill,
                  );
                },
              ).toList(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.map((map) {
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _current == int.parse(map["id"]!)
                          ? Colors.white
                          : Colors.white.withOpacity(0.4)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sellerSimpleInfo() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(50),
              //   child: Container(
              //     width: 50, height: 50, child: Image.asset("assets/image/user.png"),
              //   )
              // ) // ClipRRect를 이용하면 원형으로 사진 자르기 가능
              CircleAvatar(
                radius: 25,
                backgroundImage: Image.asset("assets/images/user.png").image,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "판매자",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "제주시 도담동",
                  )
                ],
              ),
              Expanded( //온도
                child: ManorTemperature(manorTemp: double.parse(_currentSliderValue.toStringAsFixed(1))),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: Slider(
              activeColor: Color(0xff08f4f).withOpacity(1),
              inactiveColor: Colors.black12,
              thumbColor: Color(0xff08f4f).withOpacity(1),
              value: _currentSliderValue,
              max: 99,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  } //판매자 정보

  Widget _line() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 1,
      color: Colors.grey.withOpacity(0.3),
    );
  } // 구분 선

  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            widget.data["title"]!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "디지털/가전 22시간 전",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "선물받은 새상품이고\n상품 꺼내보기만 했습니다\n거래는 직거래만 합니다.",
            style: TextStyle(
              height: 1.5,
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "채팅 3, 관심 17, 조회 295",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _reportButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            splashFactory: InkRipple.splashFactory,
            overlayColor: MaterialStateProperty.all<Color>(
              Colors.grey.withOpacity(0.5),
            ),
          ),
          child: Text(
            "이 게시글 신고하기",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          onPressed: () {
            print("신고하세요");
          },
        ),
      ),
    );
  }

  Widget _otherCellContents() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "판매자님의 판매 상품",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "모두보기",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(
      // 2열 리스트를 사용할 경우 SingleScrollLIstView 말고 CustomScrollView
      controller: _controller, //스크롤 위치를 알 수 있음
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _makeSliderimage(),
              _sellerSimpleInfo(),
              _line(),
              _contentDetail(),
              _line(),
              _reportButton(),
              _line(),
              _otherCellContents(),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            delegate: SliverChildListDelegate(List.generate(20, (index) {
              return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: Colors.grey,
                          height: 120,
                        ),
                      ),
                      Text(
                        "상품 제목",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        "금액",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  )
                );
              }
            ).toList()),
          ),
        ),
      ],
    );
  }

  Widget _bottombarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: size.width,
      height: 55,
      child: Row(
        children: [
          GestureDetector(
            onTap: (){
              print("관심상품 이벤트 발생");
              contentsRepository.addMyFavoriteContent(widget.data);
              //addMyFavoriteContent라는 함수를 ContentsRepository객체에서 선언한
              // contentsRepository에서 들고옴
              setState(() {
                isMyFavoriteContent = !isMyFavoriteContent;
                //좋아요 껐다 켰다
                final snackBar = SnackBar(
                  content: Text(
                      isMyFavoriteContent
                        ? "관심목록에 추가됐습니다."
                        : "관심목록에 제거됐습니다.",
                  ),
                  duration: Duration(milliseconds: 1000),
                );

                // Find the ScaffoldMessenger in the widget tree
                // and use it to show a SnackBar.
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            },
            child: SvgPicture.asset(
              isMyFavoriteContent
              ? "assets/svg/heart_on.svg"
              : "assets/svg/heart_off.svg",
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                  Color(0xff08f4f).withOpacity(1),
                  BlendMode.srcIn
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 10),
            width: 1, height: 40, color: Colors.grey.withOpacity(0.4),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
              DataUtils.calcStringToWon(widget.data["price"]!),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "가격제안불가",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                    decoration: BoxDecoration( //컨테이너의 경우 decoration 속성을 이용해서 ClipRRect 대체 가능
                      borderRadius: BorderRadius.circular(5),
                      color: Color(0xfff08f4f), //대신 color는 decoration 추가 시 decoration안으로 와야 함
                    ),
                    child: Text(
                      "채팅으로 거래하기",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, //body가 appbar까지 올라감
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottombarWidget(),
    );
  }
}
