import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sortika_budget_calculator/features/presentation/bloc/splash/splash_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 10,
          ),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Container(
              height: 95,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              width: 95,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/images/sortika_small.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text("USER"),
          ListTile(
            leading: FlutterLogo(
              style: FlutterLogoStyle.markOnly,
              curve: Curves.bounceInOut,
              duration: Duration(milliseconds: 500),
            ),
            title: Text("Built with Flutter"),
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            title: Text("Logout"),
            onTap: () => showDialog<bool?>(
                context: context,
                builder: (builder) => AlertDialog(
                      title: Text("Logout"),
                      content: Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("NO")),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: Text("AFFIRM")),
                      ],
                    )).then((value) {
              if (value != null && value) {
                BlocProvider.of<SplashBloc>(context).add(LogoutSplashEvent());
              }
            }),
          ),
        ],
      ),
    );
  }
}
