# 🎤 NorumKaraoke

**NorumKaraoke** is a cross-platform karaoke app built with Flutter. It offers offline audio playback, synchronized lyrics, and a plugin-based architecture for custom effects and extensions.

## ✨ Features

- 🎵 Offline playback of local audio files
- 📝 Real-time synchronized lyrics (.lrc support)
- 🎨 Theme customization (dark/light modes)
- 🔌 Plugin system for audio/visual enhancements
- 📱 Cross-platform support: Android, iOS, macOS, Web
- 🧪 Unit and widget tests included

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0+)
- Dart 3.x
- Android Studio or Xcode for mobile builds

### Installation

```bash
git clone https://github.com/bnorum/norumkaraoke.git
cd norumkaraoke
flutter pub get
```

### Running the App

```bash
flutter run
```

To run on web:

```bash
flutter run -d chrome
```

## 🧩 Plugin System

NorumKaraoke supports optional plugins located in the `plugins/` directory. Plugins can be used for:

- Audio effects (pitch, reverb)
- Visualizations
- Custom lyric behaviors

To register a plugin, update `plugin_registry.dart`.

## 🧪 Testing

```bash
flutter test
```

Runs all unit and widget tests in the `test/` directory.

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.

## 🙌 Acknowledgements

- [Flutter](https://flutter.dev/)
- [Lyric](https://pub.dev/packages/lyric)
- [audioplayers](https://pub.dev/packages/audioplayers)

---

Contributions welcome! Submit an issue or pull request to get involved.



Video of the first demo: https://www.youtube.com/watch?v=Ei786pKJjOk 
