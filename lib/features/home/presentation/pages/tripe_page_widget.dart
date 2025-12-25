import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/components/comman_components/add_friend_dialog.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/curved_header_clipper.dart';
import 'package:legacy_sync/core/components/comman_components/custom_text_field.dart';
import 'package:legacy_sync/core/components/comman_components/gradient_divider_text.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/images/lottie.dart';
import 'package:legacy_sync/features/home/home.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/components/comman_components/custom_button.dart';

class TripePageWidget extends StatefulWidget {
  const TripePageWidget({super.key});

  @override
  State<TripePageWidget> createState() => _TripePageWidgetState();
}

class _TripePageWidgetState extends State<TripePageWidget> {

  TextEditingController mobileTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: Images.splash_bg_image,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBgStackImageAndOptions(),
              SizedBox(height: 4.height),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildImageContainer(
                      imagePath: LottieFiles.learn,
                      text: "Learn",
                      onPressed: () {
                        Navigator.pushNamed(context, RoutesName.LEARN_PAGE);
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _buildImageContainer(imagePath: LottieFiles.articles, text: "Articles")),
                        const SizedBox(width: 20),
                        Expanded(child: _buildImageContainer(imagePath: LottieFiles.pod_cast, text: "Podcast",    onPressed: () {
                          Navigator.pushNamed(context, RoutesName.PODCAST_SCREEN);
                        },)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text("Friend’s list", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        _buildAddFriendButton(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildFriendList(),
                    const SizedBox(height: 10),
                    Text("Share legacy", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildFeaturePreview(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddFriendButton() {
    return AppButton(
      onPressed: () async {
        AddFriendDialog.show(
          context,
          onOkayPressed: (value) {
            if (value != null && value.toString().isNotEmpty) {
              context.read<HomeCubit>().addFriend(context: context, code: value);
            }
          },
        );
      },
      child: Image.asset(Images.add_button, height: 50, width: 50),
    );
  }

  Widget _buildFeaturePreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color(0xff110e54).withOpacity(0.1), const Color(0xff110e54).withOpacity(0.05)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xff415072), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Pass on your legacy to family and firends.", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text("Send code via text", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CustomTextField(
                  bottomPadding: false,
                  hintText: "Phone Number",
                  controller: mobileTextController,
                  maxLength: 10,
                  keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: (){
                  context.read<HomeCubit>().openSms(mobileTextController.text,"Join legacy using this code ${context.read<HomeCubit>().state.referalCode}");
                },
                  child: Image.asset(Images.send_button, height: 50, width: 50)),
            ],
          ),
          const SizedBox(height: 20),
          Text("Send code via Email", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: CustomTextField(bottomPadding: false, hintText: "Email Address", controller: emailTextController, keyboardType: TextInputType.emailAddress)),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: (){
                  context.read<HomeCubit>().openEmail(emailTextController.text,context.read<HomeCubit>().state.referalCode);

                },
                  child: Image.asset(Images.send_button, height: 50, width: 50)),
            ],
          ),
          const SizedBox(height: 20),
          const GradientDividerText(text: "Copy your unique legacy code"),
          const SizedBox(height: 20),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return CustomTextField(enabled: false, bottomPadding: false, hintText: "Refer Code", controller: TextEditingController(text: state.referalCode ?? ""));
            },
          ),
          const SizedBox(height: 20),
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: state.referalCode));
                },
                child: Image.asset(Images.copy_link_btn, height: 50, width: double.infinity, fit: BoxFit.fill),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildFriendList() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.friendsList == null || state.friendsList!.isEmpty) {
          return const SizedBox();
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: state.friendsList!.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final friend = state.friendsList![index];
            return SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(radius: 18, backgroundImage: AssetImage(Images.user_ic_fixed)),
                  const SizedBox(width: 10),
                  Expanded(child: Text("${friend.firstName}", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500))),
                  Flexible(
                    child: CustomButton(
                      height: 40,
                      onPressed: () {
                        Map<String, dynamic> data = {"friendId": friend.userIdPK};
                        Navigator.pushNamed(context, RoutesName.FRIENDS_PROFILE_PAGE, arguments: data);
                      },
                      btnText: "View legacy profile",
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildImageContainer({required String imagePath, double height = 80, required String text, EdgeInsets margin = EdgeInsets.zero, Function? onPressed}) {
    return AppButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      child: Container(
        height: height,
        margin: margin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Lottie.asset(imagePath, height: 10.height, width: double.infinity, fit: BoxFit.fill),
              Center(child: Text(text, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBgStackImageAndOptions() {
    return Container(
      color: Colors.transparent,
      height: 32.5.height,
      width: double.infinity,
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipPath(
                clipper: CurvedHeaderClipper(),
                child: SizedBox(
                  height: 25.height,
                  child: Lottie.asset(
                    LottieFiles.tribe_header,
                    height: 25.height, // match parent height
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
          Positioned(top: 60, left: 16, child: Text("Tribe library", style: Theme.of(context).textTheme.bodyLarge)),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIconsOption(imagePath: Images.featured_article, title: "Featured\nArticle"),
                  _buildIconsOption(imagePath: Images.guided_wisdom, title: "Guided\nWisdom"),
                  _buildIconsOption(imagePath: Images.podcast_episode, title: "Podcast\nEpisode"),
                  _buildIconsOption(imagePath: Images.test_your_ai, title: "Test\nYour AI"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconsOption({required String imagePath, required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(imagePath, height: 60, width: 60),
        const SizedBox(height: 5),
        Text(title, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white, fontSize: 14), maxLines: 2, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
