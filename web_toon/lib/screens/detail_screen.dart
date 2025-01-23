import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_toon/models/webtoon_detail_model.dart';
import 'package:web_toon/models/webtoon_episode_model.dart';
import 'package:web_toon/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_toon/widgets/episode_widget.dart';

// !! 상세 페이지 접근할 때 마다 에피소드와 디테일 정보를 가져오기 위해 statefulWidget으로 변경
class DetailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<WebtoonDetailModel>? webtoonDetail;
  Future<List<WebtoonEpisodeModel>>? episodes;
  bool isLiked = false; // 좋아요 상태 관리
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    // 데이터 로딩 시작
    loadData();
    initPrefs();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs!.getStringList('likedToons') ?? [];
    setState(() {
      isLiked = likedToons.contains(widget.id);
    });
  }

  Future<void> toggleLike() async {
    // prefs가 초기화되지 않았다면 early return
    if (prefs == null) return;

    final likedToons = prefs!.getStringList('likedToons') ?? [];

    if (isLiked) {
      likedToons.remove(widget.id);
    } else {
      likedToons.add(widget.id);
    }

    await prefs!.setStringList('likedToons', likedToons);

    setState(() {
      isLiked = !isLiked;
    });
  }

  void loadData() {
    // Future.wait을 사용하여 병렬로 데이터 로딩
    final futures = Future.wait([
      ApiService.getToonById(widget.id),
      ApiService.getLatestEpisodesById(widget.id),
    ]);

    // 각각의 Future로 분리하여 할당
    webtoonDetail = futures.then((value) => value[0] as WebtoonDetailModel);
    episodes = futures.then((value) => value[1] as List<WebtoonEpisodeModel>);
  }

  onButtonTap(String id, String episodeId) async {
    final url = Uri.parse(
      'https://comic.naver.com/webtoon/detail?titleId=$id&no=$episodeId',
    );
    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () async {
              await toggleLike();
            },
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.green,
            ),
          ),
        ],
        title: Text(
          widget.title,
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 30,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      width: 150,
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
                        widget.thumb,
                        headers: const {
                          "Referer": "https://comic.naver.com",
                          "User-Agent": "Mozilla/5.0",
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              FutureBuilder(
                future: webtoonDetail,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text("...");
                },
              ),
              const SizedBox(height: 25),
              FutureBuilder<List<WebtoonEpisodeModel>>(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '최신 에피소드',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        for (var episode in snapshot.data!)
                          Episode(
                            webtoonId: widget.id,
                            episode: episode,
                          ),
                      ],
                    );
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
