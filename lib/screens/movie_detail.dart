import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/bloc/movie/events.dart';
import 'package:movie_app/model/movie/index.dart';
import 'package:movie_app/providers/common.dart';
import 'package:movie_app/utils/index.dart';
import 'package:provider/provider.dart';

import '../bloc/movie/bloc.dart';
import '../bloc/movie/states.dart';

class MovieDetailPage extends StatefulWidget {
  final int id;

  const MovieDetailPage(this.id, {super.key});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final _bloc = MovieBloc();
  MovieModel? data;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!Provider.of<CommonProvider>(context, listen: false).isLoggedIn) {
        Provider.of<CommonProvider>(context, listen: false).changeCurrentIdx(2);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Please login')));
        Navigator.pop(context);
      } else {
        _bloc.add(MovieGetInfo(widget.id));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return MultiBlocListener(
        listeners: [
          BlocListener<MovieBloc, MovieState>(
              bloc: _bloc,
              listener: ((context, state) {
                if (state is MovieLoading) {
                  setState(() {
                    _loading = true;
                  });
                }
                if (state is MovieSuccessDetail) {
                  setState(() {
                    data = state.data;
                    _loading = false;
                  });
                }
                if (state is MovieFailure) {
                  setState(() {
                    _loading = false;
                  });
                }
              }))
        ],
        child: Consumer<CommonProvider>(
          builder: ((context, provider, child) {
            return Scaffold(
              backgroundColor: Color.fromARGB(255, 33, 34, 37),
              body: _loading || data == null
                  ? Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              SizedBox(
                                width: width,
                                height: width * 1.5,
                                child: Stack(fit: StackFit.expand, children: [
                                  Image.network(data!.imgUrl,
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
                                          data!.title,
                                          style: TextStyle(
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          '${data!.publishedYear} | ${Utils.integerMintoString(data!.durationMin)} | ${data!.type}',
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
                                        onPressed: () =>
                                            {provider.addWishList(data!.id)},
                                        icon: Icon(
                                          provider.isWishMovie(data!)
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
                                    data!.description ?? "",
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
                    ),
            );
          }),
        ));
  }
}
