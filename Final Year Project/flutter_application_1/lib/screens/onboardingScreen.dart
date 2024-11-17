import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/authn.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:flutter_application_1/screens/signup_screen.dart';
import 'package:flutter/services.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          _pageIndex != demoData.length - 1
              ? _pageController.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.ease)
              : Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
        },
        child: const Icon(
          Icons.arrow_forward_outlined,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            child: PageView.builder(
                itemCount: demoData.length,
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
                itemBuilder: (context, index) => OnboardContent(
                      image: demoData[index].image,
                      title: demoData[index].title,
                      description: demoData[index].description,
                      pageIndex: _pageIndex,
                    )),
          ),
          Row(
            children: [
              const SizedBox(
                width: 30,
              ),
              ...List.generate(
                  (demoData.length),
                  (index) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: DotIndicator(isActive: index == _pageIndex),
                      ))
            ],
          ),
          SizedBox(
            height: 16,
          ),
          // SizedBox(
          //   height: 50,
          //   width: 50,
          //   child: ElevatedButton(
          //     onPressed: () {},
          //     child: Icon(Icons.arrow_forward),
          //     style: ElevatedButton.styleFrom(
          //         shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(20))),
          //   ),
          // ),
          SizedBox(
            height: 15,
          )
        ],
      )),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({super.key, this.isActive = false});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isActive ? 20 : 8,
      width: 7,
      decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12)),
    );
  }
}

class Onboard {
  final String image, title, description;
  Onboard(
      {required this.image, required this.title, required this.description});
}

final List<Onboard> demoData = [
  Onboard(
      image: 'assets/images/social.png',
      title: 'Community Feed!',
      description:
          'Get and share real-time updates on campus whereabouts, issues, and new developments. Stay informed about neighbourhood events, public concerns, and community news'),
  Onboard(
      image: 'assets/images/emergency.png',
      title: 'Emergency Services!',
      description:
          'Stay protected and connected in critical situations with this comprehensive safety tool offering SOS support, including location tracking for trusted contacts and quick access to nearby police stations and hospitals'),
  Onboard(
      image: 'assets/images/events.png',
      title: 'Events Feed!',
      description:
          'Go-to app for discovering the latest events in your community. Stay updated on concerts, festivals, workshops. Never miss out on exciting happenings with real-time notifications and detailed event information'),
  Onboard(
      image: 'assets/images/launch.png',
      title: 'Get Started!',
      description:
          'So what are you waiting for? Join us on the awesome journery to make our Community a better place to live!'),
];

class OnboardContent extends StatelessWidget {
  const OnboardContent(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      required this.pageIndex});

  final String image, title, description;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              pageIndex != demoData.length - 1
                  ? TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
                        );
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.black),
                      ))
                  : SizedBox()
            ],
          ),
          const Spacer(),
          Image(
            image: AssetImage(
              image,
            ),
            height: 250,
          ),
          const Spacer(),
          SizedBox(
            width: 280,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 25,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            description,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
