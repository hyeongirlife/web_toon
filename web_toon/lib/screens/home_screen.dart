import 'package:flutter/material.dart';
import 'package:web_toon/models/web_toon.dart';
import 'package:web_toon/services/api_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_toon/widgets/webtoon_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<WebtoonModel>> webtoons;

  @override
  void initState() {
    super.initState();
    webtoons = ApiService.getTodaysToons();
  }

  @override
  Widget build(BuildContext context) {
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
      return WebtoonDetail(
        title: webtoon.title,
        thumb: webtoon.thumb,
        id: webtoon.id,
      );
    },
    separatorBuilder: (context, index) => const SizedBox(width: 10),
  );
}
