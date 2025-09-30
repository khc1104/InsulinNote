//
//  SoundPlayer.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/16/24.
//

import AVKit

final class SoundPlayer {

  static let shared = SoundPlayer()
  
  private init() {
    try? AVAudioSession.sharedInstance().setActive(true)
    try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
    if let url = Bundle.main.url(forResource: "intent-click-sound", withExtension: "mp3") {
      self.player = try? AVAudioPlayer(contentsOf: url)
      self.player?.prepareToPlay()
    } else {
      player = nil
    }
  }
  
  private let player: AVAudioPlayer?

  func play() {
    guard let player else { return }
    if player.isPlaying {
      player.stop()
      player.currentTime = .zero // 사운드 시작점으로 이동
      player.prepareToPlay()
    }
    player.play()
  }
}
