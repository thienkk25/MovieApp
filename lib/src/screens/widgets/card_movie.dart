import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/src/models/movie_model.dart';

class CardMovie extends StatelessWidget {
  final Function() onTap;
  final Function()? removeFavorite;
  final MovieData movie;
  final bool isLink;
  final bool? isNewMovie;
  const CardMovie(
      {super.key,
      required this.onTap,
      required this.movie,
      required this.isLink,
      this.removeFavorite,
      this.isNewMovie});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: isLink
                  ? movie.posterUrl.toString()
                  : "https://phimimg.com/${movie.posterUrl}",
              progressIndicatorBuilder: (context, url, progress) =>
                  const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.fill,
              memCacheHeight: 400,
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.orangeAccent, Colors.deepOrange],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .3),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.language,
                            size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          movie.lang ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .5),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .3),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.tv, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          movie.episodeCurrent ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(10.0),
                color: Colors.black.withValues(alpha: .4),
                child: Text(
                  movie.name ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            if (removeFavorite != null)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: removeFavorite,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: .4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.orange,
                      size: 26,
                    ),
                  ),
                ),
              ),
            if (isNewMovie != null && isNewMovie == true)
              Positioned(
                top: -5,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                  ),
                  child: Image.asset(
                    "assets/imgs/new-blinking.gif",
                    height: 30,
                    width: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
