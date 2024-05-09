import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sleepwell/models/list_of_music.dart';

class SoundsWidget extends StatefulWidget {
  final String initSoundPath;
  final void Function(String? soundPath) onChangeSound;

  SoundsWidget({
    super.key,
    required this.onChangeSound,
    required this.initSoundPath,
  });

  final AudioPlayer audioPlayer = AudioPlayer();
  @override
  State<SoundsWidget> createState() => _SoundsWidgetState();
}

class _SoundsWidgetState extends State<SoundsWidget> {
  late String selectedAlarmSound;
  @override
  void initState() {
    selectedAlarmSound = widget.initSoundPath;
    super.initState();
  }

  @override
  void dispose() {
    widget.audioPlayer.pause();
    widget.audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.35,
      child: ListView.separated(
        itemCount: musicList.length,
        itemBuilder: (context, index) => _getOneSoundWidget(musicList[index]),
        separatorBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(),
        ),
      ),
    );
  }

  void playAudio(String source) async {
    source = source.substring(7);
    await widget.audioPlayer.play(AssetSource(source));
  }

  Widget _getOneSoundWidget(MusicModel music) {
    return SizedBox(
      height: 40,
      child: RadioListTile(
        value: music.musicPath,
        groupValue: selectedAlarmSound,
        fillColor: const MaterialStatePropertyAll(Colors.white),
        contentPadding: EdgeInsets.zero,
        onChanged: (value) {
          setState(
            () => selectedAlarmSound = value ?? musicList[0].musicPath,
          );
          playAudio(selectedAlarmSound);
          widget.onChangeSound(selectedAlarmSound);
        },
        title: Row(
          children: [
            const Icon(
              Icons.music_note_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                music.musicName,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
