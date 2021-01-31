import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  List _imageUrls = [
    'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3118158831,1502048080&fm=26&gp=0.jpg',
    'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=391552132,10057802&fm=26&gp=0.jpg',
    'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3551370719,1936559374&fm=26&gp=0.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 180,
              child: Swiper(
                  itemCount: _imageUrls.length,
                  autoplay: true,
                  itemBuilder: (BuildContext content, int index) {
                    return (Image.network(
                      _imageUrls[index],
                      fit: BoxFit.fill,
                    ));
                  },
                  pagination: SwiperPagination(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
