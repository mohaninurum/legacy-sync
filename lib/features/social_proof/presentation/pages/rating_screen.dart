import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/features/social_proof/data/model/rating_item.dart';
import 'package:legacy_sync/features/social_proof/presentation/bloc/social_proof_bloc/rating_cubit.dart';
import 'package:legacy_sync/features/social_proof/presentation/bloc/social_proof_state/rating_state.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    context.read<RatingCubit>().loadData();

  }

  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: Images.bg_question,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: _buildAppBar(),
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<RatingCubit, RatingState>(
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.whiteColor,
                        ),
                      );
                    }

                    if (state.errorMessage != null) {
                      return Center(
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildRatingSection(),
                          const SizedBox(height: 24),
                          _buildUserCountSection(),
                          const SizedBox(height: 24),
                          _buildTestimonialsList(state.items),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildButton(),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return LegacyAppBar(title: AppStrings.giveUsRating);
  }

  Widget _buildRatingSection() {
    return Column(
      children: [
        const SizedBox(height: 20),

        Image.asset(Images.ratting_wings, height: 108),
        // Large golden laurel wreath with stars
        const SizedBox(height: 16),
        // Introductory text
        Text(
          'This app was designed for people like you',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: AppColors.whiteColor,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUserCountSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Three small circular profile pictures
        Image.asset(
          Images.frame_ratting_three,
          height: 28,
          width: 90,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 10),
        Text(
          '751,256 families',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: AppColors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTestimonialsList(List<RatingItem> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = items[index];
        return _TestimonialCard(item: item);
      },
    );
  }

  Widget _buildButton() {
    return BlocBuilder<RatingCubit, RatingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: CustomButton(
            onPressed: () {

              if(state.isRequested){
                Navigator.pushNamed(context, RoutesName.WELCOME_CARD_SCREEN);
              }else{
                context.read<RatingCubit>().requestReview();
              }


            },
            enable: true,
            btnText: AppStrings.next,
          ),
        );
      }
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final RatingItem item;

  const _TestimonialCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyBlue, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(item.avatarAsset),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.userName,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.whiteColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.userHandle,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating stars
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return const Icon(
                    Icons.star,
                    color: AppColors.yellow,
                    size: 18,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            item.testimonial,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.whiteColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
