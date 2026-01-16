import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_svg/svg.dart';
import 'package:legacy_sync/core/extension/extension.dart';
import '../../../../../core/colors/colors.dart';
import '../../../../../core/images/images.dart';
import '../../bloc/play_podcast_cubit.dart';
import '../../bloc/play_podcast_state.dart';
import 'package:flutter_inset_shadow/flutter_inset_shadow.dart';

class AudioPlayController extends StatelessWidget {
  final PlayPodcastState state;
  final PlayPodcastCubit cubit;
  const AudioPlayController({
    super.key,
    required this.state,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                min: 0,
                max:
                state.duration.inSeconds.toDouble() == 0
                    ? 1
                    : state.duration.inSeconds.toDouble(),

                value: state.position.inSeconds.toDouble().clamp(
                  0,
                  state.duration.inSeconds.toDouble() == 0
                      ? 1
                      : state.duration.inSeconds.toDouble(),
                ),

                activeColor: Colors.white,
                inactiveColor: Colors.white24,

                onChanged: (v) {
                  cubit.seek(Duration(seconds: v.toInt()));
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          /// ⏱️ Time Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _format(state.position),
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  _format(state.duration),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// ▶️ Controls Row
          Padding(
            padding: const EdgeInsets.only(left: 3, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: cubit.changeSpeed,
                  child: Text(
                    "${state.speed}x",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 5.width),
                IconButton(
                  icon: Image.asset(Images.rotate_ccw, width: 32, height: 32),
                  color: Colors.white,
                  onPressed: cubit.rewind15,
                ),
                SizedBox(width: 5.width),
                InkWell(
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: cubit.playPause,
                  child: Container(
                    width:  75,
                    height: 75,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient:   const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryColorDark,
                          AppColors.primaryColorDark,
                        ],
                      ),


                      boxShadow:  const [

                         BoxShadow(
                          color: Color.fromRGBO(255, 255, 255, 0.30),
                          blurRadius:   15,
                          offset: Offset(0, -4),
                           inset: true,
                        ),

                         BoxShadow(
                          color: Color.fromRGBO(255, 255, 255, 0.22),
                          blurRadius: 15,
                          offset: Offset(0, 6),
                           inset: true,
                        ),
                      ],
                    ),
                    child: Center(
                      child: SvgPicture.asset(state.isPlaying? Images.pause:Images.play,height: 26,width: 26,),
                    ),
                  ),
                ),
                // IconButton(
                //   icon: Icon(
                //     state.isPlaying
                //         ? Icons.pause_circle_filled
                //         : Icons.play_circle_filled,
                //     size: 64,
                //   ),
                //   color: Colors.white,
                //   onPressed: ,
                // ),
                SizedBox(width: 5.width),
                IconButton(
                  icon: Image.asset(Images.rotate_cw, width: 32, height: 32),
                  color: Colors.white,
                  onPressed: cubit.forward15,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ⏱️ Time formatter
  static String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

}
