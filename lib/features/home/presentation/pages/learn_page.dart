import 'package:flutter/material.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/gradient_divider_single.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/images/images.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
  List<Map<String, dynamic>> listData = [
    {"image": Images.l1, "title": "Getting Started with Your Legacy Journey", "description": "Learn how to set up your profile and begin capturing meaningful memories right from the start."},

    {"image": Images.l2, "title": "Answering Questions: Voice, Text, or Video", "description": "Discover the three ways to share your stories. choose what feels right for you."},

    {"image": Images.l3, "title": "Exploring Your Legacy Card", "description": "Understand how your answers shape your Legacy Card and what your family will see."},

    {"image": Images.l4, "title": "Inviting Loved Ones to Join Your Journey", "description": "Learn how to invite friends and family so they can follow, learn from, and be inspired by your stories."},

    {"image": Images.l5, "title": "How the AI Learns from You", "description": "See how your answers power an AI persona that can respond to future generations on your behalf."},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: Images.splash_bg_image,
      child: Scaffold(
        appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: _buildAppBar()),
        backgroundColor: Colors.transparent,
        body: ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: listData.length,
          itemBuilder: (context, index) {
            return _buildView(listData[index]);
          },
        ),
      ),
    );
  }

  Widget _buildView(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(data["image"]),
          const SizedBox(height: 20),
          Text(data["title"], style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20)),
          const SizedBox(height: 8),
          Text(data["description"], style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16)),
          const SizedBox(height: 20),
          const GradientDividerSingle(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return LegacyAppBar(title: "Learn");
  }
}
