import 'package:flutter/material.dart';
import '../../models/topper_talk_model.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_app_bar.dart';

class TopperVideoScreen extends StatefulWidget {
  final TopperTalkModel talk;

  const TopperVideoScreen({super.key, required this.talk});

  @override
  State<TopperVideoScreen> createState() => _TopperVideoScreenState();
}

class _TopperVideoScreenState extends State<TopperVideoScreen> {
  bool _isPlaying = false;
  double _position = 0.15;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final talk = widget.talk;

    return Scaffold(
      appBar: CustomAppBar(
        title: talk.topperName,
        showThemeToggle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mock Video Player Container
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                color: Colors.black,
                child: Stack(
                  children: [
                    if (talk.imageUrl != null)
                      Positioned.fill(
                        child: Image.asset(
                          talk.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const SizedBox(),
                        ),
                      ),
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(_isPlaying ? 0.4 : 0.65),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPlaying = !_isPlaying;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryOrange.withOpacity(0.9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isPlaying ? 'Streaming Topper Strategy...' : 'Tap to Play Strategy Session',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'FREE TO WATCH',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                          trackHeight: 2,
                        ),
                        child: Slider(
                          value: _position,
                          activeColor: AppColors.secondaryOrange,
                          inactiveColor: Colors.white24,
                          onChanged: (val) {
                            setState(() => _position = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Video Details
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.workspace_premium, color: Colors.amber, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        '${talk.topperName} (${talk.rankAndYear})',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const Spacer(),
                      Text(
                        '${talk.views} views • ${talk.duration}',
                        style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    talk.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    talk.description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Key Advice Points
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: AppColors.secondaryOrange, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Key Strategy Takeaways from ${talk.topperName.split(' ')[0]}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...talk.keyAdvice.map((advice) => Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                advice,
                                style: const TextStyle(fontSize: 13, height: 1.45),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        AppHelpers.showSnackBar(context, 'Study roadmap PDF saved to downloads!', isSuccess: true);
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Download Topper Study Schedule (PDF)'),
                    ),
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
