import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:web_toon/screens/detail_screen.dart';

class WebtoonDetail extends StatelessWidget {
  final String title, thumb, id;
  const WebtoonDetail({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DetailScreen(title: title, thumb: thumb, id: id),
              fullscreenDialog: true),
        );
      },
      child: Column(
        children: [
          Hero(
            tag: id,
            child: Container(
              width: 200,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    offset: const Offset(10, 10),
                    color: Colors.black.withOpacity(0.5),
                  ),
                ],
              ),
              child: Image.network(
                thumb,
                headers: const {
                  "Referer": "https://comic.naver.com",
                  "User-Agent": "Mozilla/5.0",
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 200,
            child: Text(
              title,
              style: GoogleFonts.notoSansKr(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
