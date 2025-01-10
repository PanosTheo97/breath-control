//
//  BreathingViewExtension.swift
//  BreathControl
//
//  Created by Panagiotis Theodosiadis on 8/1/25.
//

import Foundation
import CoreHaptics
import SwiftUI

//extension BreathingView {
//    
//    func prepareHaptics() {
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
//        
//        do {
//            engine = try CHHapticEngine()
//            try engine?.start()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func breathingExercise(mode: BreathingModeEnum, duration: Int) {
//        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
//        
//        var events = [CHHapticEvent]()
//        
//        let cycleTime = mode.breathingTimes()[0] + mode.breathingTimes()[1] + mode.breathingTimes()[2]
//        let numberOfReps = Int(duration * 60 / Int(cycleTime))
//        
//        for i in 0..<numberOfReps {
//            let delay = Double(i) * cycleTime
//            
//            title = "Breath in"
//            events.append(
//                CHHapticEvent(eventType: .hapticContinuous, parameters: [
//                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
//                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
//                ], relativeTime: delay, duration: mode.breathingTimes()[0]) // Inhale
//            )
//            
//            events.append(
//                CHHapticEvent(eventType: .hapticContinuous, parameters: [
//                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3),
//                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
//                ], relativeTime: delay + mode.breathingTimes()[0], duration: mode.breathingTimes()[1]) // Hold
//            )
//            
//            events.append(
//                CHHapticEvent(eventType: .hapticContinuous, parameters: [
//                    CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7),
//                    CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
//                ], relativeTime: delay + mode.breathingTimes()[0] + mode.breathingTimes()[1], duration: mode.breathingTimes()[2]) // Exhale
//            )
//        }
//        
//        do {
//            let pattern = try CHHapticPattern(events: events, parameters: [])
//            let player = try engine?.makePlayer(with: pattern)
//            try player?.start(atTime: 0)
//            
//            // Update UI during the cycle
//            //var progressValue: CGFloat = 0.0
//            for i in 0..<events.count {
//                let event = events[i]
//                DispatchQueue.main.asyncAfter(deadline: .now() + event.relativeTime) {
//                    print(event.relativeTime)
//                    if i % 3 == 0 {
//                        title = "Breath in"
//                        //updateUI("Inhale", progressValue)
//                    } else if i % 3 == 1 {
//                        title = "Hold"
//                        //updateUI("Hold", progressValue)
//                    } else {
//                        title = "Breath out"
//                        //updateUI("Exhale", progressValue)
//                    }
//                    //progressValue = CGFloat(event.relativeTime / 60.0) // Normalize the time for progress
//                }
//            }
//        } catch {
//            print("Failed to play haptic pattern: \(error.localizedDescription)")
//        }
//    }
//}
