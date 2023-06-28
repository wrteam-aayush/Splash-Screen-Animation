import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Animations',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final Color gradientColorDart = const Color(0xFF143283);
  final Color gradientColorLight = const Color(0xFF2051D5);

  final int totalAnimationDurationSeconds = 6;
  final double containerFinalSize = 140.0;
  final double iconFilalSize = 85.0;

  late AnimationController _animationController;

  late Animation _whiteContainerScaleAnimation;
  late Animation _whiteContainerMoveUp;
  late Animation<double> _logoZoomIn;
  late Animation<double> _logoWhiteFade;
  late Animation _companyLogoMoveUp;
  late Animation _textLogoMoveDown;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: totalAnimationDurationSeconds),
    );
    _whiteContainerMoveUp = Tween<double>(
      begin: 0.0,
      end: 40,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.8,
          1.0,
          curve: Curves.linear,
        ),
      ),
    );
    _textLogoMoveDown = Tween<double>(
      begin: 0.0,
      end: 50,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.8,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _companyLogoMoveUp = Tween<double>(
      begin: 0.0,
      end: 40,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.8,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.85,
          1.0,
          curve: Curves.linear,
        ),
      ),
    );
    _logoZoomIn = Tween(begin: 5.0, end: iconFilalSize).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.1,
          0.4,
          curve: Curves.easeIn,
        ),
      ),
    );
    _logoWhiteFade = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(
          0.1,
          0.4,
          curve: Curves.ease,
        ),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //declaring it here to make use of the context for getting screen height
    _whiteContainerScaleAnimation = Tween(
      begin: containerFinalSize,
      end: MediaQuery.of(context).size.height,
    )
        .chain(
          TweenSequence(
            [
              TweenSequenceItem(
                tween: Tween(begin: 1.0, end: -0.02),
                weight: 5,
              ),
              TweenSequenceItem(
                tween: Tween(begin: -0.02, end: -0.02),
                weight: 0.5,
              ),
              TweenSequenceItem(
                tween: Tween(begin: -0.02, end: 0.0),
                weight: 4.5,
              ),
            ],
          ),
        )
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(
              0.0,
              0.7,
              curve: Curves.easeIn,
            ),
          ),
        );
    _animationController.repeat();
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              gradientColorLight,
              gradientColorDart,
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) => Positioned(
                top: (MediaQuery.of(context).size.height / 2) -
                    ((_whiteContainerScaleAnimation.value / 2) +
                        _whiteContainerMoveUp.value),
                child: AnimatedBuilder(
                    animation: _whiteContainerScaleAnimation,
                    builder: (context, child) {
                      return Container(
                        width: _whiteContainerScaleAnimation.value,
                        height: _whiteContainerScaleAnimation.value,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: AnimatedBuilder(
                          animation: _logoZoomIn,
                          builder: (context, _) {
                            return _logoZoomIn.value == 10
                                ? const SizedBox.shrink()
                                : Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/mainlogo.svg",
                                        fit: BoxFit.contain,
                                        width: _logoZoomIn.value,
                                        height: _logoZoomIn.value,
                                      ),
                                      AnimatedBuilder(
                                        animation: _logoWhiteFade,
                                        builder: (context, child) =>
                                            FadeTransition(
                                          opacity: _logoWhiteFade,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          },
                        ),
                      );
                    }),
              ),
            ),
            AnimatedBuilder(
              animation: _textLogoMoveDown,
              builder: (context, child) => Positioned(
                top: (MediaQuery.of(context).size.height / 2) +
                    _textLogoMoveDown.value,
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, _) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SvgPicture.asset(
                        "assets/textlogo.svg",
                      ),
                    );
                  },
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _companyLogoMoveUp,
              builder: (context, child) => Positioned(
                bottom: _companyLogoMoveUp.value,
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, _) {
                    return FadeTransition(
                      opacity: _fadeAnimation,
                      child: SvgPicture.asset(
                        "assets/companylogo.svg",
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
