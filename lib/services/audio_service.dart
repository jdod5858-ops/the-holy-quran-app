import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isInitialized = false;
  
  static AudioPlayer get player => _player;
  
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await JustAudioBackground.init(
        androidNotificationChannelId: 'com.voxin.hasanati.audio',
        androidNotificationChannelName: 'حسناتي - تلاوة القرآن',
        androidNotificationOngoing: true,
      );
      _isInitialized = true;
    } catch (e) {
      print('Error initializing audio service: $e');
    }
  }
  
  static Future<void> playQuranRecitation({
    required String url,
    required String surahName,
    required String reciterName,
    String? imageUrl,
  }) async {
    try {
      await initialize();
      
      final audioSource = AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: url,
          album: 'القرآن الكريم',
          title: surahName,
          artist: reciterName,
          artUri: imageUrl != null ? Uri.parse(imageUrl) : null,
        ),
      );
      
      await _player.setAudioSource(audioSource);
      await _player.play();
    } catch (e) {
      throw Exception('Failed to play audio: $e');
    }
  }
  
  static Future<void> playAdhkarAudio({
    required String url,
    required String dhikrText,
  }) async {
    try {
      await initialize();
      
      final audioSource = AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: url,
          album: 'الأذكار والأدعية',
          title: dhikrText,
          artist: 'حسناتي',
        ),
      );
      
      await _player.setAudioSource(audioSource);
      await _player.play();
    } catch (e) {
      throw Exception('Failed to play dhikr audio: $e');
    }
  }
  
  static Future<void> play() async {
    await _player.play();
  }
  
  static Future<void> pause() async {
    await _player.pause();
  }
  
  static Future<void> stop() async {
    await _player.stop();
  }
  
  static Future<void> seek(Duration position) async {
    await _player.seek(position);
  }
  
  static Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }
  
  static Future<void> setVolume(double volume) async {
    await _player.setVolume(volume);
  }
  
  static Future<void> setLoopMode(LoopMode loopMode) async {
    await _player.setLoopMode(loopMode);
  }
  
  static Stream<Duration> get positionStream => _player.positionStream;
  static Stream<Duration?> get durationStream => _player.durationStream;
  static Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  static Stream<double> get speedStream => _player.speedStream;
  static Stream<double> get volumeStream => _player.volumeStream;
  
  static bool get isPlaying => _player.playing;
  static Duration get position => _player.position;
  static Duration? get duration => _player.duration;
  static double get speed => _player.speed;
  static double get volume => _player.volume;
  
  static Future<void> dispose() async {
    await _player.dispose();
  }
  
  // Repeat functionality for learning
  static Future<void> repeatSection({
    required Duration start,
    required Duration end,
    required int repeatCount,
  }) async {
    for (int i = 0; i < repeatCount; i++) {
      await _player.seek(start);
      await _player.play();
      
      // Wait until we reach the end position
      await _player.positionStream
          .where((position) => position >= end)
          .first;
      
      await _player.pause();
      
      // Small delay between repeats
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
  
  // Background playback control
  static Future<void> enableBackgroundPlayback() async {
    // This is handled by just_audio_background automatically
    // when MediaItem is provided in setAudioSource
  }
  
  static Future<void> disableBackgroundPlayback() async {
    await _player.stop();
  }
}