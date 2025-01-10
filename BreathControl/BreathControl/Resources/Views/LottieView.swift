//
//  LottieView.swift
//  BreathControl
//
//  Created by Panagiotis Theodosiadis on 7/1/25.
//

import Foundation
import Lottie
import SwiftUI
import UIKit

struct LottieView: UIViewRepresentable {
    
    var animationFileName: String?
    var animationUrl: String?
    let loopMode: LottieLoopMode
    var animationSpeed: CGFloat = 1.0
    let animationView = LottieAnimationView()
    var isPaused: Bool = false

    func updateUIView(_ uiView: UIViewType, context: Context) {
        if isPaused {
            context.coordinator.parent.animationView.pause()
        } else {
            context.coordinator.parent.animationView.play()
        }
    }
    
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
        animationView.play()
        
        return animationView
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: LottieView

        init(_ parent: LottieView) {
            self.parent = parent
        }
    }
    
    static func getFirstFrame(from animationName: String) -> UIImage? {
        // Load the animation
        guard let animation = LottieAnimation.named(animationName) else {
            print("Failed to load animation")
            return nil
        }
        
        // Create an animation view
        let animationView = LottieAnimationView(animation: animation)
        
        // Set the frame to match the animation size
        animationView.frame = CGRect(origin: .zero, size: animation.size)
        animationView.currentFrame = 357 // Set to the first frame
        animationView.layoutIfNeeded() // Ensure the layout is updated
        
        // Render the animation view as an image
        let renderer = UIGraphicsImageRenderer(size: animationView.bounds.size)
        let image = renderer.image { context in
            animationView.layer.render(in: context.cgContext)
        }
        
        return image
    }
}
