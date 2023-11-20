import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:janin/theme.dart';
import 'package:janin/view/signin/wrapper.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late PageController _pageController;
  final int totalPages = 2;

  @override
  void initState() {
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: contents.length,
                itemBuilder: (context, index) => OnBoardingContent(
                  image: contents[index].image,
                  title: contents[index].title,
                  description: contents[index].description,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 40,
                width: 277,
                child: ElevatedButton(
                  child: Text(
                    "Lanjut",
                    style: TextStyle(fontSize: 14),
                  ),
                  onPressed: () {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 600),
                        curve: Curves.ease);
                    // Pindah ke halaman login setelah halaman terakhir onboarding
                    if (_pageController.page == totalPages - 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Wrapper()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    // side: BorderSide(
                    //         color: blackColor,
                    //         width: 1,
                    //       ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: pinkColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class OnBoardContent {
  final String image, title, description;

  OnBoardContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<OnBoardContent> contents = [
  OnBoardContent(
    image: "assets/image/doctor.svg",
    title: "Selamat datang di Prediksi Janin!",
    description:
        "Kami hadir untuk memberikan informasi akurat seputar perkembangan janin Anda selama kehamilan. ",
  ),
  OnBoardContent(
    image: "assets/image/baby.svg",
    title: "Rekam Jejak Kesehatan Janin",
    description:
        "Dengan aplikasi Prediksi Janin, anda dapat melacak perkembangan janin "
        "dan merasa lebih dekat dengan kehidupan kecil yang sedang tumbuh di dalam kandungan anda! ",
  ),
];

class OnBoardingContent extends StatelessWidget {
  const OnBoardingContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Spacer(),
          SvgPicture.asset(
            image,
            height: 250,
          ),
          const Spacer(),
          Text(
            title,
            textAlign: TextAlign.center,
            style: onboardTitle.copyWith(height: 1.25),
          ),
          SizedBox(height: 15),
          Text(
            description,
            textAlign: TextAlign.center,
            style: descriptionText,
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
