import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/movie/index.dart';
import '../providers/common.dart';
import '../utils/index.dart';

class MyBottomSheet extends StatelessWidget {
  final MovieModel data;
  const MyBottomSheet(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<CommonProvider>(
      builder: ((context, provider, child) {
        return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  SizedBox(
                    width: width,
                    height: width * 1.5,
                    child: Stack(fit: StackFit.expand, children: [
                      Image.network(data.imgUrl,
                          width: width, fit: BoxFit.fill),
                      Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.play_circle,
                              color: Colors.grey.withOpacity(0.5),
                              size: 60,
                            ),
                            SizedBox(height: 50),
                            Text(
                              data.title,
                              style: TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${data.publishedYear} | ${Utils.integerMintoString(data.durationMin)} | ${data.type}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xff777777),
                              ),
                            ),
                            SizedBox(height: 70)
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.chevron_left,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            onPressed: () => {provider.addWishList(data.id)},
                            icon: Icon(
                              provider.isWishMovie(data)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                  Column(
                    children: [
                      Text(
                        'Тайлбар',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        data.description ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
