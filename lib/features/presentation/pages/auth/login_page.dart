import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sortika_budget_calculator/core/utils/constants.dart';
import 'package:sortika_budget_calculator/core/utils/debouncer.dart';
import 'package:sortika_budget_calculator/di/injection.dart';
import 'package:sortika_budget_calculator/features/presentation/bloc/auth/auth_bloc.dart';
import 'package:sortika_budget_calculator/features/presentation/components/rounded_button.dart';
import 'package:sortika_budget_calculator/features/presentation/components/toast_widget.dart';
import 'package:sortika_budget_calculator/core/routes/app_router.gr.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final _bloc = getIt<AuthBloc>();
  late final _btnController = RoundedLoadingButtonController();
  late final _nameController = TextEditingController();
  late final _phoneController = TextEditingController();
  late final _passController = TextEditingController();
  late final _formKey = GlobalKey<FormState>();
  late final _debouncer = Debouncer(seconds: 3);

  bool _isLogin = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _nameController.dispose();
    _phoneController.dispose();
    _passController.dispose();
    // _btnController.reset();
    _debouncer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    late final _colorScheme = Theme.of(context).colorScheme;
    final _textTheme = Theme.of(context).textTheme;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (create) => _bloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                _btnController.error();
                _debouncer.run(action: () {
                  _btnController.reset();
                });
                ScaffoldMessenger.maybeOf(context)
                  ?..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      backgroundColor: _colorScheme.error,
                      behavior: SnackBarBehavior.fixed,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      )),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "ERROR",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          // SizedBox(height: 3),
                          Text(
                            state.error,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  );
              }
              if (state is AuthSuccess) {
                //Nav to Home
                _btnController.reset();
                ScaffoldMessenger.maybeOf(context)?..hideCurrentSnackBar();
                print("Success");
                AutoRouter.of(context).replaceAll([HomePageRoute()]);
              }
              if (state is AuthInitial) {
                ScaffoldMessenger.maybeOf(context)?..hideCurrentSnackBar();
              }
            },
          )
        ],
        child: Scaffold(
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/sortika_small.png"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(child: child, opacity: animation);
                      },
                      child: Column(
                        key: ValueKey<bool>(_isLogin),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              enabled: !_isLogin,
                              decoration: InputDecoration(
                                labelText: "Name",
                                hintText: "Enter your nme",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (!RegExp(PHONE_REGEX).hasMatch(value!))
                                  return "Phone number format: '+999999999' upto 14 digits";
                              },
                              decoration: InputDecoration(
                                labelText: "Phone",
                                hintText: "Enter your phone",
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _passController,
                              keyboardType: TextInputType.visiblePassword,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              obscureText: true,
                              validator: (value) {
                                if (!RegExp(PASS_REGEX).hasMatch(value!))
                                  return "Password requires strength, try atleast 6 alphanumericals";
                              },
                              decoration: InputDecoration(
                                labelText: "Password",
                                hintText: "Enter your password",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Opacity(opacity: 0),
                          AnimatedOpacity(
                            opacity: _isLogin ? 1.0 : 0.0,
                            duration: Duration(milliseconds: 500),
                            child: TextButton(
                                onPressed: () {
                                  Overlay.of(context)?.insert(
                                    OverlayEntry(
                                      builder: (builder) => Positioned(
                                        child: ToastWidget(
                                            fadeSeconds: 5,
                                            child: Text(
                                              "Take a deep breath, close your eyes, try, and you will remember your password 😉️",
                                              maxLines: 2,
                                              style: _textTheme.bodyText2
                                                  ?.copyWith(
                                                      color: _colorScheme
                                                          .onPrimary),
                                            )),
                                        bottom: 50.0,
                                        left: 24.0,
                                        right: 24.0,
                                      ),
                                    ),
                                  );
                                },
                                child: Text("Forgot password?")),
                          )
                        ],
                      ),
                    ),
                    RoundedLoadingButton(
                      controller: _btnController,
                      color: _colorScheme.primary,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_isLogin) {
                            _bloc.add(AuthLoginEvent(
                                phone: _phoneController.text.trim(),
                                pass: _passController.text));
                            return;
                          }
                          _bloc.add(
                            AuthRegisterEvent(
                                name: _nameController.text.trim(),
                                phone: _phoneController.text.trim(),
                                pass: _passController.text),
                          );
                        }
                        _btnController.reset();
                      },
                      child: AnimatedSwitcher(
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return FadeTransition(
                              child: child, opacity: animation);
                        },
                        child: Container(
                          key: ValueKey<bool>(_isLogin),
                          child: _isLogin ? Text("SIGN IN") : Text("SIGN UP"),
                        ),
                        duration: Duration(milliseconds: 500),
                      ),
                    ),
                    AnimatedSwitcher(
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return FadeTransition(child: child, opacity: animation);
                      },
                      duration: Duration(milliseconds: 500),
                      child: Container(
                        key: ValueKey<bool>(_isLogin),
                        width: 300,
                        child: _isLogin
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(child: Text("You new here?")),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isLogin = !_isLogin;
                                      });
                                    },
                                    child: Text("Sign Up"),
                                  )
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(child: Text("Have we met before?")),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isLogin = !_isLogin;
                                      });
                                    },
                                    child: Text("Sign In"),
                                  )
                                ],
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
