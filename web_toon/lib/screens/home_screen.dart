import 'package:flutter/material.dart';
import 'package:web_toon/models/web_toon.dart';
import 'package:web_toon/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    print(webtoons);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: Text(
          "뚱뚱뚱",
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, futureResult) {
          if (futureResult.hasData) {
            // return makeList(futureResult);
            return Column(
              children: [
                const SizedBox(height: 50),
                Expanded(child: makeList(futureResult)),
              ],
            );
          }
          // if (futureResult.hasData) {
          //   return ListView.builder(
          //     scrollDirection: Axis.horizontal,
          //     itemCount: futureResult.data!.length,
          //     itemBuilder: (context, index) {
          //       var webtoon = futureResult.data![index];
          //       return Padding(
          //         padding: const EdgeInsets.symmetric(horizontal: 5.0),
          //         child: Text(webtoon.title),
          //       );
          //     },
          //   );
          // }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

ListView makeList(AsyncSnapshot<List<WebtoonModel>> webtoons) {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: webtoons.data!.length,
    itemBuilder: (context, index) {
      var webtoon = webtoons.data![index];
      return Column(
        children: [
          Container(
            width: 250,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  blurRadius: 15,
                  offset: const Offset(10, 10),
                  color: Colors.black.withOpacity(0.5),
                ),
              ],
            ),
            child: Image.network(
              webtoon.thumb,
              headers: const {
                "Referer": "https://comic.naver.com",
                "User-Agent": "Mozilla/5.0",
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            webtoon.title,
            style: GoogleFonts.gaegu(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
              height: 1.2,
              color: Colors.black87,
            ),
          )
        ],
      );
    },
    separatorBuilder: (context, index) => const SizedBox(width: 10),
  );
}
