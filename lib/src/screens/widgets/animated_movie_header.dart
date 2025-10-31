import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class AnimatedMovieHeader extends StatefulWidget {
  final String profilePicture;
  final String userName;
  final String myselftEmail;

  const AnimatedMovieHeader({
    super.key,
    required this.profilePicture,
    required this.userName,
    required this.myselftEmail,
  });

  @override
  State<AnimatedMovieHeader> createState() => _AnimatedMovieHeaderState();
}

class _AnimatedMovieHeaderState extends State<AnimatedMovieHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _avatarScale;
  late Animation<double> _textOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _avatarScale = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _textOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      child: Container(
        height: 120,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            ScaleTransition(
              scale: _avatarScale,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Colors.white.withValues(alpha: .3), width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: CachedNetworkImage(
                    imageUrl: widget.profilePicture,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                    memCacheHeight: 100,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.black26,
                      child: Icon(Icons.person, color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            FadeTransition(
              opacity: _textOpacity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'app.hi'.tr(args: [widget.userName]),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'app.email'.tr(args: [widget.myselftEmail]),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .8),
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
