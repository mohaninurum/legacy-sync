import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legacy_sync/core/colors/colors.dart';
import 'package:legacy_sync/core/components/comman_components/app_button.dart';
import 'package:legacy_sync/core/components/comman_components/custom_button.dart';
import 'package:legacy_sync/core/components/comman_components/keyboard_dismiss_on_tap.dart';
import 'package:legacy_sync/core/components/comman_components/legacy_app_bar.dart';
import 'package:legacy_sync/core/components/comman_components/user_image_widget.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import 'package:legacy_sync/core/strings/strings.dart';
import 'package:legacy_sync/core/utils/utils.dart';
import 'package:legacy_sync/features/profile/presentation/bloc/profile_bloc/profile_cubit.dart';
import 'package:legacy_sync/features/profile/presentation/bloc/profile_state/profile_state.dart';
import '../../../../core/components/comman_components/bg_image_stack.dart';
import '../../../../core/components/comman_components/custom_text_field.dart';
import '../../../../core/images/images.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {


  DateTime? selectedDate;
  final DateTime currentDate = DateTime.now();
  late final DateTime minimumDate;
  late final DateTime maximumDate;

  @override
  void initState() {
    final now = DateTime.now();
    minimumDate = DateTime(now.year - 100, now.month, now.day);
    maximumDate = DateTime(now.year - 18, now.month, now.day);
    context.read<ProfileCubit>().loadProfile(context);

    super.initState();
  }

  void _showDatePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => Material(
            child: Container(
              height: 350,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    // Header with title and done button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: CupertinoColors.separator, width: 0.5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel', style: TextStyle(color: CupertinoColors.systemBlue, fontSize: 16)),
                          ),
                          const Text('Select Date of Birth', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              // Ensure validation is triggered when done is pressed
                              if (selectedDate != null) {}
                              Navigator.of(context).pop();
                            },
                            child: const Text('Done', style: TextStyle(color: CupertinoColors.systemBlue, fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    // Age requirement info
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: const Text('Must be at least 18 years old', style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 14)),
                    ),
                    // Date picker
                    Expanded(
                      child: CupertinoDatePicker(
                        initialDateTime: selectedDate ?? maximumDate,
                        mode: CupertinoDatePickerMode.date,
                        minimumDate: minimumDate,
                        maximumDate: maximumDate,
                        onDateTimeChanged: (DateTime newDate) {
                          setState(() {
                            selectedDate = newDate;
                            context.read<ProfileCubit>().dobController.text = _formatDate(newDate);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  void _showGenderPicker() {
    final genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];
    final currentIndex = genderOptions.indexOf(context.read<ProfileCubit>().genderController.text);
    final initialIndex = currentIndex >= 0 ? currentIndex : 0;

    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => Material(
            child: Container(
              height: 300,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    // Header with title and done button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: CupertinoColors.separator, width: 0.5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel', style: TextStyle(color: CupertinoColors.systemBlue, fontSize: 16)),
                          ),
                          const Text('Select Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Done', style: TextStyle(color: CupertinoColors.systemBlue, fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    // Gender picker
                    Expanded(
                      child: CupertinoPicker(
                        itemExtent: 50,
                        scrollController: FixedExtentScrollController(initialItem: initialIndex),
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            context.read<ProfileCubit>().genderController.text = genderOptions[index];
                          });
                        },
                        children: genderOptions.map((gender) => Center(child: Text(gender, style: const TextStyle(fontSize: 18)))).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

  void _saveProfile(BuildContext context) {
    // Validate inputs
    if (context.read<ProfileCubit>().firstNameController.text.trim().isEmpty) {
      Utils.showInfoDialog(context: context, title: "Please enter first name");
      return;
    }
    if (context.read<ProfileCubit>().lastNameController.text.trim().isEmpty) {
      Utils.showInfoDialog(context: context, title: "Please enter last name");
      return;
    }

    // Format date of birth for API (convert from DD-MM-YYYY to YYYY-MM-DD if needed)
    String formattedDob = "";
    if (context.read<ProfileCubit>().dobController.text.isNotEmpty) {
      try {
        // Parse DD-MM-YYYY format
        final parts = context.read<ProfileCubit>().dobController.text.split('-');
        if (parts.length == 3) {
          formattedDob = "${parts[2]}-${parts[1]}-${parts[0]}"; // Convert to YYYY-MM-DD
        }
      } catch (e) {
        formattedDob = context.read<ProfileCubit>().dobController.text;
      }
    }

    // Extract country code and phone number
    String countryCode = "+91"; // Default
    // You can enhance this to parse from phoneController if needed

    context.read<ProfileCubit>().editProfileDetail(
      context: context,
      firstName: context.read<ProfileCubit>().firstNameController.text.trim(),
      lastName: context.read<ProfileCubit>().lastNameController.text.trim(),
      countryCode: countryCode,
      gender: context.read<ProfileCubit>().genderController.text.trim(),
      dateOfBirth: formattedDob,
      mobile_number:context.read<ProfileCubit>().phoneController.text.trim() ,
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: BgImageStack(
        imagePath: Images.profile_bg,
        child: Scaffold(
          appBar: PreferredSize(preferredSize: const Size.fromHeight(60), child: _buildAppBar()),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [_buildUserInfoWidget(), _buildProfileForm(context)])),
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(right: 16, left: 16, top: 5),
              child: CustomButton(
                onPressed: () {
                  _saveProfile(context);
                },
                btnText: "Save",
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        print("PROFILE DATA :: ${state.profileData?.email}");
        return Column(
          children: [
            Row(
              children: [
                Expanded(child: CustomTextField(lableText: "First Name", bgColor: AppColors.etbg, hintText: AppStrings.firstName, controller: context.read<ProfileCubit>().firstNameController, onChanged: (value) {})),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextField(
                    lableText: "Last Name",
                    bgColor: AppColors.etbg,
                    hintText: AppStrings.lastName,
                    controller: context.read<ProfileCubit>().lastNameController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            Visibility(
              visible: state.isLoginByApple,
              child: CustomTextField(
                lableText: "Email",
                bgColor: AppColors.etbg,
                hintText: AppStrings.enterYourEmail,
                controller: context.read<ProfileCubit>().emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {},
              ),
            ),
            CustomTextField(
              lableText: "Birth Date",
              enabled: false,
              bgColor: AppColors.etbg,
              hintText: AppStrings.dateOfBirth,
              controller: context.read<ProfileCubit>().dobController,
              keyboardType: TextInputType.emailAddress,
              suffixImageWidgetPathSVG: Images.ic_calender_svg,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());

                _showDatePicker();
              },
              onChanged: (value) {},
            ),
            CustomTextField(
              lableText: "Gender",
              enabled: false,
              bgColor: AppColors.etbg,
              hintText: AppStrings.gender,
              controller: context.read<ProfileCubit>().genderController,
              suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.grey),
              suffixImageWidgetPathSVG: Images.arrow_dowan,
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _showGenderPicker();
              },
              onChanged: (value) {},
            ),

            CustomTextField(
              lableText: "Phone Number",
              bgColor: AppColors.etbg,
              hintText: "Phone Number",
              maxLength: 10,
              controller: context.read<ProfileCubit>().phoneController,
              keyboardType: TextInputType.phone,
              onChanged: (value) {},
            ),
          ],
        );
      },
    );
  }

  Widget _buildUserInfoWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        1.kh,
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return UserImageWidget(assetPlaceholder: Images.image_user, size: 100, filePath: state.imageFilePath, imageUrl: state.profileData?.profileImage);
          },
        ),
        // CircleAvatar(radius: 50, child: Image.asset(Images.image_user, fit: BoxFit.contain)),
        const SizedBox(height: 10),
        AppButton(
          onPressed: () {
            showImagePicker(context);
          },
          child: Text("Edit Profile", textAlign: TextAlign.center, style: TextTheme.of(context).bodyMedium!.copyWith(fontWeight: FontWeight.w500, color: AppColors.yellowfad, fontSize: 16)),
        ),
        2.kh,
      ],
    );
  }

  Widget _buildAppBar() {
    return LegacyAppBar(title: "Edit Profile");
  }



  void showImagePicker(BuildContext context) {
    final ImagePicker _picker = ImagePicker();
    Utils.showPhotoDialog(
      context: context,
      onCameraPressed: () async {
        final XFile? image = await _picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          context.read<ProfileCubit>().updateProfileImage(imagePath:image.path);
        }
      },
      onGalleryPressed: () async {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          context.read<ProfileCubit>().updateProfileImage(imagePath:image.path);

        }
      },
    );
  }
}
