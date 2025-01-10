//
//  LottieProgressView.swift
//  BreathControl
//
//  Created by Panagiotis Theodosiadis on 8/1/25.
//

import Foundation
import Lottie
import SwiftUI
import UIKit

struct LottieProgressView: UIViewRepresentable {
    
    var animationFileName: String?
    var animationUrl: String?
    let loopMode: LottieLoopMode = .playOnce
    var animationSpeed: CGFloat = 1.0
    let animationView = LottieAnimationView()
    var isPaused: Bool = false
    var fromFrame: CGFloat
    var toFrame: CGFloat

    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        if let animationFileName = animationFileName {
            animationView.animation = LottieAnimation.named(animationFileName)
        } else if let animationUrlString = animationUrl, let animationUrl = URL(string: animationUrlString) {
             LottieAnimation.loadedFrom(url: animationUrl, closure: { animation in
                 animationView.animation = animation
            }, animationCache: DefaultAnimationCache.sharedCache)
        }
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.clipsToBounds = true
        return animationView
    }
    
    func updateUIView(_ uiView: Lottie.LottieAnimationView, context: Context) {
        uiView.play(fromFrame: fromFrame, toFrame: toFrame, loopMode: .playOnce)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: LottieProgressView

        init(_ parent: LottieProgressView) {
            self.parent = parent
        }
    }
}
