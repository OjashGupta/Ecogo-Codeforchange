import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:vibration/vibration.dart';

import 'utils/local_storage.dart';

class BarcodeProvider extends ChangeNotifier {
  String barcodeScanRes = '';
  bool isMuted = false;
  bool isVibrateOff = false;

  void refreshCode(String code) {
    barcodeScanRes = code;
    notifyListeners();
  }

  AudioPlayer player = AudioPlayer();

  Future scanBarcodeNormal() async {
    refreshCode('');
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    // if (!mounted) return;

    if (barcodeScanRes == "-1") {
      return refreshCode('');
    } else if (barcodeScanRes.isNotEmpty) {
      if (!isVibrateOff) {
        Vibration.vibrate(duration: 250);
      }
      if (!isMuted) {
        player.play(AssetSource('Barcode-scanner-beep-sound.mp3'), volume: .5);
      }
      return refreshCode(barcodeScanRes);
    } else {
      return refreshCode('');
    }
  }

  void playSound() {
    player.play(AssetSource('Barcode-scanner-beep-sound.mp3'), volume: .5);
  }

  Future toggleSound() async {
    isMuted = !isMuted;
    await LocalStorage.setBool("Sound", isMuted);
    notifyListeners();
  }

  Future toggleVibration() async {
    isVibrateOff = !isVibrateOff;
    await LocalStorage.setBool("Vibration", isVibrateOff);
    notifyListeners();
  }

  Future getSound() async {
    isMuted = await LocalStorage.getBool("Sound") ?? false;
    notifyListeners();
  }

  Future getVibration() async {
    isVibrateOff = await LocalStorage.getBool("Vibration") ?? false;
    notifyListeners();
  }
}
