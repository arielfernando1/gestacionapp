import 'package:flutter/widgets.dart';

import '../classes/post.dart';
import 'cards/audio_card.dart';
import 'cards/photo_card.dart';

class CardContainer extends StatefulWidget {
  final Post post;
  const CardContainer({super.key, required this.post});

  @override
  State<CardContainer> createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer> {
  @override
  Widget build(BuildContext context) {
    switch (widget.post.postType) {
      case 1:
        return PhotoCard(post: widget.post);
      case 2:
        return AudioCard(post: widget.post);
      case 3:
        return PhotoCard(post: widget.post);
      default:
        return const Text('Error');
    }
  }
}
