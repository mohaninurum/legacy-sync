import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/features/social_proof/presentation/bloc/social_proof_bloc/credibility_cubit.dart';
import 'package:legacy_sync/features/social_proof/presentation/bloc/social_proof_state/credibility_state.dart';

class CredibilityScreen extends StatefulWidget {
  const CredibilityScreen({super.key});

  @override
  State<CredibilityScreen> createState() => _CredibilityScreenState();
}

class _CredibilityScreenState extends State<CredibilityScreen> {
  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    context.read<CredibilityCubit>().loadData();
  }

  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: Images.credibility,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: _buildAppBar()),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<CredibilityCubit, CredibilityState>(
                  builder: (context, state) {
                    return ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: state.items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return _SocialProofTile(name: item.authorName, quote: item.quote, avatarAsset: item.avatarAsset, isVerified: item.isVerified);
                      },
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

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: CustomButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutesName.CHOOSE_YOUR_GOALS_SCREEN);
        },
        enable: true,
        btnText: AppStrings.continueText,
      ),
    );
  }

  Widget _buildAppBar() {
    return LegacyAppBar(title: AppStrings.rewiringBenefits);
  }
}

class _SocialProofTile extends StatelessWidget {
  final String name;
  final String quote;
  final String avatarAsset;
  final bool isVerified;

  const _SocialProofTile({required this.name, required this.quote, required this.avatarAsset, required this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(radius: 16, backgroundImage: AssetImage(avatarAsset)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(child: Text(name, style: TextTheme.of(context).bodyMedium!.copyWith(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 6),
                  if (isVerified) SvgPicture.asset(Images.ic_verify_svg, height: 20, width: 20),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: AppColors.primaryBlueDark,
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12), topRight: Radius.circular(12)),
                ),
                child: Text(quote, style: TextTheme.of(context).bodyMedium!.copyWith(fontSize: 14, color: AppColors.whiteColor)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
