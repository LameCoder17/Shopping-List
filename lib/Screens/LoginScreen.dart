import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_list/Screens/MainScreen.dart';
import 'package:shopping_list/Utils/Colors.dart';
import 'package:sizer/sizer.dart';
import '../Services/Auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  static final _pageController = PageController(
    initialPage: 0,
  );
  List<FocusNode> _focusNodes = [
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    _focusNodes.forEach((node){
      node.addListener(() {
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kolors.background,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 50.0.sp, horizontal: 25.0.sp),
          height: 85.h,
          child: Neumorphic(
            style: NeumorphicStyle(
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10.0.sp)),
                depth: 10,
                intensity: 0.6,
                lightSource: LightSource.bottom,
                color: Kolors.foreground
            ),
            child: PageView(
              controller: _pageController,
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 25.0.sp),
                          alignment: Alignment.center,
                          child: NeumorphicText(
                            'Shopping List',
                            style: NeumorphicStyle(
                                lightSource: LightSource.top,
                                color: Kolors.accent2
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontSize: 32.0.sp,
                            ),),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 30.0.sp, horizontal: 20.0.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Neumorphic(
                                child: TextField(
                                  focusNode: _focusNodes[0],
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  style: GoogleFonts.nunito(
                                      fontSize: 14.0.sp
                                  ),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Kolors.background,
                                      hintText: 'Enter Email',
                                      hintStyle: GoogleFonts.nunito(fontSize: 12.0.sp, color: Kolors.accent2),
                                      prefixIcon: Icon(Icons.email_outlined),
                                      prefixIconColor: _focusNodes[0].hasFocus ? Kolors.accent : Colors.grey,
                                      border: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Kolors.foreground)),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Kolors.foreground)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Kolors.foreground)),
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Kolors.foreground)),
                                      focusedErrorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Kolors.foreground)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0.sp,
                              ),
                              Neumorphic(
                                child: TextField(
                                  controller: _passwordController,
                                  style: GoogleFonts.nunito(
                                      fontSize: 14.0.sp
                                  ),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Kolors.background,
                                      hintText: 'Enter Password',
                                    hintStyle: GoogleFonts.nunito(fontSize: 12.0.sp, color: Kolors.accent2),
                                      prefixIcon: Icon(Icons.password_outlined),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.foreground)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.foreground)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.foreground)),
                                    errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.foreground)),
                                    focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.foreground)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              //width: 50.w,
                              child: NeumorphicButton(
                                child: _loading ?
                                    Container(
                                      width: 50.w,
                                      child: NeumorphicProgressIndeterminate(
                                        style: ProgressStyle(
                                            accent: Kolors.accent2,
                                            variant: Kolors.accent
                                        ),
                                      ),
                                    )
                                    :
                                Text('Sign In', style: GoogleFonts.nunito(fontSize: 16.0.sp, fontWeight: FontWeight.bold),),
                                style: NeumorphicStyle(
                                    lightSource: LightSource.bottom,
                                    color: Kolors.background
                                ),
                                onPressed: () async {
                                  setState(() {
                                    _loading = true;
                                  });
                                  await AuthenticationHelper()
                                      .signIn(email: _emailController.text, password: _passwordController.text)
                                      .then((result) {
                                    if (result == null) {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) => MainScreen()));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                          result,
                                          style: GoogleFonts.nunito(fontSize: 14.0.sp),
                                        ),
                                      ));
                                    }
                                    setState(() {
                                      _loading = false;
                                    });
                                  });
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 20.0.sp),
                              child: GestureDetector(
                                child: Text('Want to Sign Up ?', style: GoogleFonts.nunito(fontSize: 12.0.sp, color: Colors.white),),
                                onTap: (){
                                  _pageController.animateToPage(1, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 25.0.sp),
                          alignment: Alignment.center,
                          child: NeumorphicText(
                            'Shopping List',
                            style: NeumorphicStyle(
                                lightSource: LightSource.top,
                                color: Kolors.accent2
                            ),
                            textStyle: NeumorphicTextStyle(
                              fontSize: 32.0.sp,
                            ),),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 30.0.sp, horizontal: 20.0.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Neumorphic(
                                child: TextField(
                                  focusNode: _focusNodes[0],
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  style: GoogleFonts.nunito(
                                      fontSize: 14.0.sp
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Kolors.background,
                                    hintText: 'Enter Email',
                                    hintStyle: GoogleFonts.nunito(fontSize: 12.0.sp, color: Kolors.accent2),
                                    prefixIcon: Icon(Icons.email_outlined),
                                    prefixIconColor: _focusNodes[0].hasFocus ? Kolors.accent : Colors.grey,
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.foreground)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.foreground)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.foreground)),
                                    errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.foreground)),
                                    focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.foreground)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0.sp,
                              ),
                              Neumorphic(
                                child: TextField(
                                  controller: _passwordController,
                                  style: GoogleFonts.nunito(
                                      fontSize: 14.0.sp
                                  ),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Kolors.background,
                                    hintText: 'Enter Password',
                                    hintStyle: GoogleFonts.nunito(fontSize: 12.0.sp, color: Kolors.accent2),
                                    prefixIcon: Icon(Icons.password_outlined),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.foreground)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.foreground)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.foreground)),
                                    errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.foreground)),
                                    focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Kolors.foreground)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              //width: 50.w,
                              child: NeumorphicButton(
                                child: _loading ?
                                Container(
                                  width: 50.w,
                                  child: NeumorphicProgressIndeterminate(
                                    style: ProgressStyle(
                                        accent: Kolors.accent2,
                                        variant: Kolors.accent
                                    ),
                                  ),
                                )
                                    :
                                Text('Sign Up', style: GoogleFonts.nunito(fontSize: 16.0.sp, fontWeight: FontWeight.bold),),
                                style: NeumorphicStyle(
                                    lightSource: LightSource.bottom,
                                  depth: 3,
                                  color: Kolors.background
                                ),
                                onPressed: () async{
                                  setState(() {
                                    _loading = true;
                                  });
                                  await AuthenticationHelper()
                                      .signUp(email: _emailController.text, password: _passwordController.text)
                                      .then((result) {
                                    if (result == null) {
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (context) => MainScreen()));
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                          result,
                                          style: TextStyle(fontSize: 12.0.sp),
                                        ),
                                      ));
                                      setState(() {
                                        _loading = false;
                                      });
                                    }
                                  });
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 20.0.sp),
                              child: GestureDetector(
                                child: Text('Want to Sign In ?', style: GoogleFonts.nunito(fontSize: 12.0.sp, color: Colors.white),),
                                onTap: (){
                                  _pageController.animateToPage(0, curve: Curves.decelerate, duration: Duration(milliseconds: 300));
                                },
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}