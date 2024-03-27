//
//  LottieHelper.swift
//  HealthAppGOQii
//
//  Created by Apple on 27/03/24.
//

import Foundation
import Lottie
class LottieHelper{
  static func playLottieAnimation(named fileName: String, withExtension fileExtension: String, view: LottieAnimationView) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: fileExtension) else {
            print("Error: Animation file not found.")
            return
        }
        view.animation = LottieAnimation.filepath(path)
        view.loopMode = .loop
        view.animationSpeed = 1.0
        view.contentMode = .scaleAspectFit
        view.play()
    }
}
