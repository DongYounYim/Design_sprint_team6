import 'dart:async';
import 'package:culture_app/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'search.dart';
import 'homeMap.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bottomNav.dart';
import 'content.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class GetContentImageRandom extends StatelessWidget {
  Map myMap = new Map();
  List myList = [];

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseFirestore.instance
        .collection('contentCard')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc['img'] == null) {
          myMap.addEntries(
              [MapEntry(doc['realtitle'], const AssetImage('logo.png'))]);
        } else {
          myMap.addEntries(
              [MapEntry(doc['realtitle'], Image.network(doc['img']))]);
        }
        myList.add(doc['realtitle']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
        children: List.generate(6, (index) {
      if (index == 5) {
        return Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      )),
                  width: 110.0.w,
                  height: 210.0.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.more), Text("더 보기")],
                  ),
                ),
                Text("")
              ],
            ));
      } else {
        return Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(10.0))),
                width: 110.0.w,
                height: 210.0.h,
                child: myMap[myList[index]],
              ),
              //firevase에서 doc으로 가져와서 텍스트 넣기
              Text(myList[index]),
            ],
          ),
        );
      }
    }));
  }
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Widget myMargin = Container(margin: const EdgeInsets.only(top: 10));
  List<content> contents = [
    content(
        21012360,
        '백지영 전국투어 콘서트 <BAEK HUG>',
        'http://ticketimage.interpark.com/rz/image/play/goods/poster/21/21012360_p_s.jpg',
        '대전컨벤션센터(DCC)',
        '22.01.22-22.01.22')
  ];

  Map contentsMap = Map<String, dynamic>();
  List randomList = [];

  // void getImageData() async {
  //   //선언 async await 문제도 아니구
  //   await FirebaseFirestore.instance
  //       .collection('contentCard')
  //       .get()
  //       .then((QuerySnapshot querySnapshot) {
  //     for (var doc in querySnapshot.docs) {
  //       //doc['realtitle']
  //       if (doc['img'] == null) {
  //         contentsMap
  //             .addEntries([MapEntry(doc['realtitle'], AssetImage('logo.png'))]);
  //       } else {
  //         contentsMap.addEntries([
  //           MapEntry(
  //               doc['realtitle'],
  //               Image.network(
  //                 doc['img'],
  //                 fit: BoxFit.fill,
  //               ))
  //         ]);
  //         //Image.network(doc['img'][0]);
  //       }
  //       randomList.add(doc['realtitle']);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    //getImageData();
    return Scaffold(
      bottomNavigationBar: BottomNavigate(),
      body: Column(
        children: [
          Container(margin: const EdgeInsets.only(top: 35)), //top margin
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 20.w,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff6667AB), width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 5, top: 2, bottom: 4),
                      child: const Image(
                        image: AssetImage('images/logo.png'),
                      ),
                    ),
                    Container(
                      width: 260.0.w,
                    ),
                    //Expanded() 적용시 constraintsError 발생
                    //마찬가지로 때려넣으면 반응형으로 적응이 안되서,,
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Search()));
                        },
                        child: const Icon(Icons.search)),
                  ],
                ),
              ),
              Container(
                width: 20.0.w,
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.80,
            child: ListView(
              padding: EdgeInsets.only(top: 2),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text("진행중"),
                    Text("반경 1KM"),
                    Text("대전 광역시 유성구 대학로 99"),
                  ],
                ),
                myMargin,
                Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                    ),
                    Text(
                      "추천 콘텐츠",
                      style: Theme.of(context).textTheme.headline5,
                    )
                  ],
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: GetContentImageRandom(),
                      // Row(
                      //     children: List.generate(6, (index) {
                      //   if (index == 5) {
                      //     return Container(
                      //         padding: const EdgeInsets.all(10.0),
                      //         child: Column(
                      //           children: [
                      //             Container(
                      //               decoration: BoxDecoration(
                      //                   color: Colors.grey,
                      //                   borderRadius: const BorderRadius.all(
                      //                     Radius.circular(10.0),
                      //                   )),
                      //               width: 110.0.w,
                      //               height: 210.0.h,
                      //               child: Column(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.center,
                      //                 children: [
                      //                   Icon(Icons.more),
                      //                   Text("더 보기")
                      //                 ],
                      //               ),
                      //             ),
                      //             Text("")
                      //           ],
                      //         ));
                      //   } else {
                      //     return Container(
                      //       padding: const EdgeInsets.all(10.0),
                      //       child: Column(
                      //         children: [
                      //           Container(
                      //             decoration: BoxDecoration(
                      //                 borderRadius: const BorderRadius.all(
                      //                     Radius.circular(10.0))),
                      //             width: 110.0.w,
                      //             height: 210.0.h,
                      //             child: contentsMap[randomList[index]],
                      //           ),
                      //           //firevase에서 doc으로 가져와서 텍스트 넣기
                      //           Text(randomList[index]),
                      //         ],
                      //       ),
                      //     );
                      //   }
                      // })),
                    )),
                myMargin,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 110.w,
                          height: 50.h,
                          child: OutlinedButton(
                            child: Text("뮤지컬"),
                            onPressed: () => {},
                            //style: OutlineButton.styleFrom(), style적용안됨.
                          ),
                        ),
                        Container(
                          width: 110.w,
                          height: 50.h,
                          child: OutlinedButton(
                            child: Text("축제"),
                            onPressed: () => {},
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 110.w,
                          height: 50.h,
                          child: OutlinedButton(
                            child: Text("전시회"),
                            onPressed: () => {},
                          ),
                        ),
                        Container(
                          width: 110.w,
                          height: 50.h,
                          child: OutlinedButton(
                            child: Text("만들기 공방"),
                            onPressed: () => {},
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 110.w,
                          height: 50.h,
                          child: OutlinedButton(
                            child: Text("버스킹"),
                            onPressed: () => {},
                          ),
                        ),
                        Container(
                          width: 110.w,
                          height: 50.h,
                          child: OutlinedButton(
                            child: Text("시사회"),
                            onPressed: () => {},
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                myMargin,
                myMargin,
                Container(
                  width: 300.0,
                  height: 200.0,
                  //크기를 지정해줘야 오류가 없는데 반응형으로 나타나진 않음..
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(
                        "https://via.placeholder.com/288x188",
                        fit: BoxFit.fill,
                      );
                    },
                    itemCount: 10,
                    viewportFraction: 0.8,
                    scale: 0.9,
                    itemWidth: 288.0,
                    itemHeight: 188.0,
                    control: SwiperControl(
                        color: Colors.white, padding: EdgeInsets.all(50.0)),
                    pagination: SwiperPagination(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 80.w,
        height: 80.h,
        child: FloatingActionButton(
          backgroundColor: Color(0xff6667AB),
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeMap()),
            )
          },
          child: Icon(Icons.map, size: 30.w),
        ),
      ),
    );
  }
}
