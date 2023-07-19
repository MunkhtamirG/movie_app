import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_app/bloc/movie/bloc.dart';
import 'package:movie_app/bloc/movie/events.dart';
import 'package:movie_app/global_keys.dart';
import 'package:movie_app/providers/common.dart';
import 'package:movie_app/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _bloc = MovieBloc();

  @override
  void initState() {
    super.initState();
  }

  void _onChangeLanguage() {
    final context = GlobalKeys.navigatorKey.currentContext!;
    if (context.locale.languageCode == Locale('mn', 'MN').languageCode) {
      context.setLocale(Locale('en', 'US'));
    } else {
      context.setLocale(Locale('mn', 'MN'));
    }
  }

  void _onImagePick(ImageSource source) async {
    XFile? file = await ImagePicker().pickImage(source: source);
    print(file);
  }

  void _onHttpRequest() async {
    _bloc.add(MovieGetAll());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommonProvider>(
      builder: ((context, provider, child) {
        return provider.isLoggedIn
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () => _onHttpRequest(),
                        child: Text('Http Request')),
                    ElevatedButton(
                        onPressed: () => _onImagePick(ImageSource.gallery),
                        child: Text('Open photo library')),
                    ElevatedButton(
                        onPressed: () => _onImagePick(ImageSource.camera),
                        child: Text('Open camera')),
                    ElevatedButton(
                      onPressed: _onChangeLanguage,
                      child: Text(context.locale.languageCode),
                    ),
                    ElevatedButton(
                      onPressed: provider.onLogout,
                      child: Text('Гарах'),
                    ),
                  ],
                ),
              )
            : LoginPage();
      }),
    );
  }
}
