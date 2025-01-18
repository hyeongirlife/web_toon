import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:web_toon/models/webtoon_episode_model.dart';

class Episode extends StatelessWidget {
  final String webtoonId;
  final WebtoonEpisodeModel episode;

  const Episode({
    super.key,
    required this.webtoonId,
    required this.episode,
  });

  onButtonTap() async {
    final url =
        'https://comic.naver.com/webtoon/detail?titleId=$webtoonId&no=${episode.id}';

    try {
      await launchUrlString(
        url,
        mode: LaunchMode.platformDefault,
        webViewConfiguration: const WebViewConfiguration(
          enableJavaScript: true,
          enableDomStorage: true,
        ),
      );
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onButtonTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.green.shade400,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  episode.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
