//
//  ExerciseView.swift
//  BreathControl
//
//  Created by Panagiotis Theodosiadis on 8/1/25.
//

import SwiftUI

struct ExerciseView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var currentPhase: String = "Inhale"
    
    @ObservedObject var hapticManager: HapticManager
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                
                (colorScheme == .dark ? Color(hex: "#020116") : Color.white)
                    .ignoresSafeArea()
                
                VStack(alignment: .center) {
                    
                    PhaseTextView(currentPhase: $currentPhase)
                    
                    Spacer()
                    
                    
                    // Show Lottie animation based on the current phase
                    if currentPhase == "Inhale" {
                        LottieProgressView(animationFileName: "lottie_flower", animationSpeed: 0.9, fromFrame: 0, toFrame: 140)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    } else if currentPhase == "Hold" {
                        LottieProgressView(animationFileName: "lottie_flower", animationSpeed: 0.7, fromFrame: 140, toFrame: 210)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    } else if currentPhase == "Exhale" {
                        LottieProgressView(animationFileName: "lottie_flower", animationSpeed: 0.7, fromFrame: 210, toFrame: 360)
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                    }
                    
                    //                LottieView(animationFileName: "lottie_flower", loopMode: .loop, animationSpeed: 0.55)
                    //                    .aspectRatio(1, contentMode: .fit)
                    //                    .frame(width: 200, height: 200)
                    //                    .clipShape(Circle())
                    
                    Spacer()
                }
                .onAppear {
                    hapticManager.prepareHaptics()
                    hapticManager.startBreathingExercise { phase in
                        self.currentPhase = phase
                    }
                    hapticManager.dismissAction = {
                        self.dismiss()
                    }
                }
            }
            .navigationBarItems(leading: Button(action: {
                hapticManager.stopBreathingExercise()
                dismiss()
            }) {
                Image(systemName: "xmark.circle.fill") // Dismiss button
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color(hex: "#75caf7"))
            })
        }
    }
}

struct PhaseTextView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Binding var currentPhase: String  // Binding to update from the parent view

    var body: some View {
        Text(currentPhase)
            .font(.custom("Noteworthy-Bold", size: 40))
            .foregroundColor(colorScheme == .dark ? Color.white : Color(hex: "#75caf7"))
    }
}

#Preview {
    ExerciseView(hapticManager: HapticManager(breathingMode: .boxBreathing, totalDuration: 1))
}
