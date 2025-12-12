import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:legacy_sync/config/routes/routes_name.dart' show RoutesName;
import 'package:legacy_sync/core/components/comman_components/bg_image_stack.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/gradient_divider_single.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/images/lottie.dart';
import 'package:legacy_sync/features/paywall/presentation/bloc/paywall_cubit.dart';
import 'package:legacy_sync/features/paywall/presentation/bloc/paywall_state.dart';
import 'package:lottie/lottie.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});
  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return BgImageStack(
      imagePath: Images.bg_question,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<PaywallCubit, PaywallState>(
          builder: (context, state) {
            return  SingleChildScrollView(
              physics:const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [

                  // Stack(
                  //   children: [
                  //     Image.asset(Images.circal_gradiant),
                  //     Padding(
                  //       padding: const EdgeInsets.only(top: 120),
                  //         child: Image.asset(Images.img_legacy_mobile)),
                  //     Padding(
                  //       padding: const EdgeInsets.only(top: 80),
                  //       child: Column(
                  //         children: [
                  //           SvgPicture.asset(Images.ic_verify_svg, height: 32,width: 32),
                  //           _buildHeadingText("Your Custom Path to\na Timeless Legacy"),
                  //           SizedBox(height: 1.5.height),
                  //           _buildDescText("Create Your Priceless Legacy with Legacysync"),
                  //           Padding(
                  //             padding:  EdgeInsets.only(right: 20.width,left: 20.width),
                  //             child: const GradientDividerSingle(),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Column(
                      children: [
                        SvgPicture.asset(Images.ic_verify_svg, height: 32,width: 32),
                        _buildHeadingText("Your Custom Path to\na Timeless Legacy"),
                        SizedBox(height: 1.5.height),
                        _buildDescText("Create Your Priceless Legacy with Legacysync"),
                        SizedBox(height: 4.height),
                        Padding(
                          padding:  EdgeInsets.only(right: 20.width,left: 20.width),
                          child: const GradientDividerSingle(),
                        ),

                      ],
                    ),
                  ),
                  Image.asset(Images.frame_screens,height: 395,width: 500,fit: BoxFit.cover,),
                  SizedBox(height: 2.height),
                  Lottie.asset(LottieFiles.ratting_wings, height: 184),
                  SizedBox(height: 1.height),
                  _buildHeadingText("Your Custom Path to\na Timeless Legacy"),
                  SizedBox(height: 1.5.height),
                  _buildDescText("Create Your Priceless Legacy with Legacysync"),
                  SizedBox(height: 3.height),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.width),
                    child: const GradientDividerSingle(),
                  ),
                  SizedBox(height: 4.height),
                  _buildHeadingText("The LegacySync Annual Plan"),
                  SizedBox(height: 1.5.height),
                  _buildDescText(
                    '\$120/year That\'s just \$12.99/month! Unlimited Story & Memory Capture (Audio, Video, Text, Photos)',
                  ),
                  SizedBox(height: 2.height),
                  Image.asset(Images.chip_options_anual, height: 357,width: double.infinity),
                  SizedBox(height: 4.height),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.width),
                    child: const GradientDividerSingle(),
                  ),
                  SizedBox(height: 4.height),
                  Image.asset(Images.yoga_img, height: 120,width: 120),
                  SizedBox(height: 1.height),//rating_Interactive
                  _buildHeadingText("Discover Inner Fulfillment"),
                  SizedBox(height: 3.height),
                  _buildMiniPoint(image: Images.bullseye_arrow_svg,text: "Build a lasting sense of purpose."),
                  _buildMiniPoint(image: Images.leaf_eart_svg,text: "Gain profound self-understanding and clarity."),
                  _buildMiniPoint(image: Images.star_svg,text: "Boost your personal legacy and self-worth."),
                  _buildMiniPoint(image: Images.laurel_user_svg,text: "Fill each day with pride and lasting meaning."),
                  SizedBox(height: 2.height),
                  Image.asset(Images.rating_Interactive,width: 150,height: 40,),
                  SizedBox(height: 2.height),
                  _buildDescTextBold("'Sharing my story has given me such clarity about my life's journey. I feel a deep sense of accomplishment and peace I never expected.'"),
                  SizedBox(height: 4.height),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.width),
                    child: const GradientDividerSingle(),
                  ),
                  SizedBox(height: 2.height),
                  Lottie.asset(LottieFiles.img_family, height: 150,width: 140),
                  SizedBox(height: 1.height),//rating_Interactive
                  _buildHeadingText("Strengthen Family Bonds."),
                  SizedBox(height: 3.height),
                  _buildMiniPoint(size: 16,image: Images.arrow_trend_up,text: "Enhance intergenerational understanding."),
                  _buildMiniPoint(size: 16,image: Images.crystal_ball,text: "Be a trusted source of wisdom and guidance."),
                  _buildMiniPoint(size: 16,image: Images.people_network_partner,text: "Experience authentic connection with loved ones."),
                  _buildMiniPoint(size: 16,image: Images.user_crown,text: "Become the ancestor your family deserves."),
                  SizedBox(height: 2.height),
                  Image.asset(Images.rating_Interactive,width: 150,height: 40,),
                  SizedBox(height: 2.height),
                  _buildDescTextBold("'I worried my grandchildren wouldn't truly know me. Now, through my stories, I feel closer to them than ever, even across generations.'"),
                  SizedBox(height: 4.height),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.width),
                    child: const GradientDividerSingle(),
                  ),
                  SizedBox(height: 4.height),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset(Images.effortless_legacy_building,height: 540),
                  ),
                  SizedBox(height: 3.height),
                  Image.asset(Images.plant_small, height: 130,width: 120),
                  SizedBox(height: 1.height),//rating_Interactive
                  _buildHeadingText("A Gift That Lasts Generations."),
                   SizedBox(height: 3.height),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset(Images.gift_thate_frame,height: 228),
                  ),
                  SizedBox(height: 4.height),
                  Image.asset(Images.rating_Interactive,width: 150,height: 40,),
                  SizedBox(height: 2.height),
                  _buildDescTextBold("'Knowing my great-grandchildren will hear my voice and understand my journey brings me immeasurable joy. It’s truly the ultimate gift I can leave, and it keeps on giving.'"),
                  SizedBox(height: 4.height),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.width),
                    child: const GradientDividerSingle(),
                  ),
                  SizedBox(height: 4.height),
                  Lottie.asset(LottieFiles.winer_img, height: 120,width: 140),
                  SizedBox(height: 1.height),
                  _buildHeadingText("Empower Your Legacy Journey."),
                  SizedBox(height: 3.height),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset(Images.winer_frame,height: 228),
                  ),
                  SizedBox(height: 4.height),
                  Image.asset(Images.rating_Interactive,width: 150,height: 40,),
                  SizedBox(height: 2.height),
                  _buildDescTextBold("Creating a meaningful legacy requires more than just good intentions. You need a dedicated, guided path to thoughtfully capture your unique life experiences, articulate your wisdom, and ensure it enriches future generations."),
                  SizedBox(height: 2.height),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.width),
                    child: const GradientDividerSingle(),
                  ),
                  SizedBox(height: 4.height),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: _buildButton(),
      ),
    );
  }

  Widget _buildMiniPoint({required String image,required String text,double size = 14}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 6),
      child: Row(mainAxisSize: MainAxisSize.max,children: [
       SvgPicture.asset(image,height: size,width: size),const SizedBox(width: 10), Text(text,style: TextTheme.of(context).bodyMedium!.copyWith(fontSize: 12,fontWeight: FontWeight.w500)),
      ]),
    );
  }



  Widget _buildHeadingText(String text){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(text, style: Theme.of(context).textTheme.bodyLarge,textAlign: TextAlign.center),
    );
  }
  Widget _buildDescText(String text){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium,textAlign: TextAlign.center),
    );
  }
  Widget _buildDescTextBold(String text){
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium,textAlign: TextAlign.center),
    );
  }



  Widget _buildButton() {
    return BlocBuilder<PaywallCubit, PaywallState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 16,
            right: 16,
            top: 8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                btnText: "Unlock My Legacy",
                isLoadingState: false,
                enable: true,
                onPressed: () {
                  Navigator.pushNamed(context, RoutesName.POST_PAYWALL_SCREEN);

                },
              ),
             const SizedBox(height: 20),
              Image.asset(Images.cancel_anytime_img,height: 60),
            ],
          ),
        );
      },
    );
  }
}
