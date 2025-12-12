import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:legacy_sync/config/routes/routes_name.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/curved_header_clipper.dart';
import 'package:legacy_sync/core/components/comman_components/locked_question_dialog.dart';
import 'package:legacy_sync/core/components/comman_components/night_sky_background.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/images/images.dart';
import 'package:legacy_sync/core/images/lottie.dart';
import 'package:legacy_sync/features/friends_profile/presentation/bloc/profile_bloc/friends_profile_cubit.dart';
import 'package:legacy_sync/features/friends_profile/presentation/bloc/profile_state/friends_profile_state.dart';
import 'package:legacy_sync/features/friends_profile/presentation/widget/friends_journey_content_widget.dart';
import 'package:legacy_sync/features/home/domain/usecases/navigate_to_module_usecase.dart';
import 'package:lottie/lottie.dart';

class FriendsProfilePage extends StatefulWidget {
  int friendId;
   FriendsProfilePage({super.key,required this.friendId});

  @override
  State<FriendsProfilePage> createState() => _FriendsProfilePageState();
}

class _FriendsProfilePageState extends State<FriendsProfilePage> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _mainController;
  late Animation<double> _mainAnimation;

  // Animation controllers for pipe flow
  late List<AnimationController> _pipeControllers;
  late List<Animation<double>> _pipeAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();

    context.read<FriendsProfileCubit>().initializeProfile(context,widget.friendId);
  }

  void _setupAnimations() {
    _mainController = AnimationController(duration: const Duration(milliseconds: 2200), vsync: this);

    _mainAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeInOut));

    _mainController.repeat(reverse: true); // twinkle driver

    // Setup pipe animation controllers
    _pipeControllers = List.generate(7, (index) {
      return AnimationController(duration: const Duration(milliseconds: 2200), vsync: this);
    });

    _pipeAnimations =
        _pipeControllers.map((controller) {
          return Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
        }).toList();
  }

  void _onCardTapped(int index){
    final cubit = context.read<FriendsProfileCubit>();
    final state = cubit.state;
    if (state.journeyCards[index].isEnabled) {
      final card = state.journeyCards[index];
      final navigationArgs = NavigateToModuleUsecase.execute(card);
      navigationArgs.addAll({"fromFriends":true,"friendId":widget.friendId});
      Navigator.pushNamed(context, RoutesName.LIST_OF_MODULE, arguments: navigationArgs);
    } else {
      LockedQuestionDialog.show(context, title: "module");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const NightSkyBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildBgStackImageAndOptions(),
                const SizedBox(height: 30),
                 const CustomDropdown(),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text("Legacy Journey", style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(padding: const EdgeInsets.all(16), child: _buildCards()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCards() {
    return BlocBuilder<FriendsProfileCubit, FriendsProfileState>(
      builder: (context, state) {
        if(state.isLoading){
          return const Center(child: CircularProgressIndicator(color: Colors.white));
        }
        return FriendsJourneyContentWidget(cards: state.journeyCards, pipes: state.pipeAnimations, onCardTapped: _onCardTapped, pipeControllers: _pipeControllers, pipeAnimations: _pipeAnimations);
      },
    );
  }

  Widget _buildBgStackImageAndOptions() {
    return Container(
      color: Colors.transparent,
      height: 30.5.height,
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
                    LottieFiles.favorite_header,
                    height: 25.height, // match parent height
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 60,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppButton(
                    padding: const EdgeInsets.only(top: 14),
                    onPressed: () {

                        Navigator.pop(context);

                    },
                    child:  const Icon(Icons.arrow_back_ios_rounded, color:Colors.white),
                  ),
                  //Text("Profile", style: Theme.of(context).textTheme.bodyLarge),
                  const Spacer(),
                ],
              ),
            ),
          ),
          Positioned(bottom: 0, right: 0, left: 0, child: CircleAvatar(radius: 60, child: Image.asset(Images.user_image))),
        ],
      ),
    );
  }
}

class CustomDropdown extends StatefulWidget {
  const CustomDropdown({super.key});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> with SingleTickerProviderStateMixin {
  bool isOpen = false;
  String selectedTag = 'Add Tag';
  late AnimationController _animationController;
  late Animation<double> _animation;
  OverlayEntry? _overlayEntry;

  final List<String> tags = ['Mother', 'Father', 'Brother', 'Sister', 'Aunt', 'Grandmother', 'Grandfather', 'Nephew', 'Cousins', 'Grandaunt', 'Granduncle', 'Friend'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _toggleDropdown() {
    if (isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    setState(() {
      isOpen = true;
    });
    _animationController.forward();
    _createOverlay();
  }

  void _closeDropdown() {
    setState(() {
      isOpen = false;
    });
    _animationController.reverse();
    _removeOverlay();
  }

  void _createOverlay() {
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: _getButtonPosition().dy + 50,
            left: _getButtonPosition().dx,
            right: _getButtonPosition().dx,

            child: Material(
              color: Colors.transparent,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    alignment: Alignment.topCenter,
                    child: Opacity(
                      opacity: _animation.value,
                      child: Container(
                        width: 200,
                        constraints: const BoxConstraints(
                          maxHeight: 320, // Maximum height for the dropdown
                          minWidth: 200,
                          maxWidth: 200,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDD835),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: tags.length,
                            itemBuilder: (context, index) {
                              final tag = tags[index];
                              return InkWell(
                                onTap: () => _selectTag(tag),
                                child: Container(
                                  width: 200,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: const Color(0xFFF9A825), width: index == tags.length - 1 ? 0 : 1))),
                                  child: Center(child: Text(tag, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500))),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Offset _getButtonPosition() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  void _selectTag(String tag) {
    setState(() {
      selectedTag = tag;
    });
    _closeDropdown();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: Container(
        width: 200,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFDD835),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(selectedTag, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500)),
            const SizedBox(width: 10),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.rotate(angle: _animationController.value * 3.14159, child: const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 24));
              },
            ),
          ],
        ),
      ),
    );
  }
}
