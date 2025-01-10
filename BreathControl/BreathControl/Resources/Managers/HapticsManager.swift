//
//  HapticsManager.swift
//  BreathControl
//
//  Created by Panagiotis Theodosiadis on 8/1/25.
//

import Foundation
import CoreHaptics
import SwiftUI
import UIKit

class HapticManager: ObservableObject {
    private var hapticEngine: CHHapticEngine?
    
    private var timer: Timer?
    private var phaseTimer: Timer?
    private var elapsedTime: Double = 0
    private var currentCycle = 0
    var breathingMode: BreathingModeEnum
    var totalCycles: Int
    var cycleDuration: Double
    
    var player: CHHapticPatternPlayer?
    
    var dismissAction: (() -> Void)?

    // MARK: Init
    
    init(breathingMode: BreathingModeEnum, totalDuration: Int) {
        self.breathingMode = breathingMode
        
        self.cycleDuration = breathingMode.breathingTimes()[0] + breathingMode.breathingTimes()[1] + breathingMode.breathingTimes()[2]
        self.totalCycles = Int(totalDuration * 60 / Int(cycleDuration))
    }

    // MARK: - Methods
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func startBreathingExercise(updateUI: @escaping (String) -> Void) {
        do {
            let events = generateBreathingEvents()

            // Create the haptic pattern
            let pattern = try CHHapticPattern(events: events, parameters: [])
            player = try hapticEngine?.makePlayer(with: pattern)

            try player?.start(atTime: 0)
            
            startPhaseTimer()
            
            startElapsedTimeTimer(updateUI: updateUI)
            
        } catch {
            print("Failed to start haptic pattern: \(error.localizedDescription)")
        }
    }
    
    // Stop the breathing exercise
    func stopBreathingExercise() {
        timer?.invalidate()  // Stop the phase timer
        phaseTimer?.invalidate()  // Stop the elapsed time timer
        timer = nil
        phaseTimer = nil
        do {
            try player?.stop(atTime: 0)
        } catch {
            print("Failed to stop haptic pattern: \(error.localizedDescription)")
        }
    }

    // Generate haptic events for Inhale, Hold, Exhale
    private func generateBreathingEvents() -> [CHHapticEvent] {
        var events: [CHHapticEvent] = []
        
        for i in 0..<totalCycles {
            let delay = Double(i) * cycleDuration
            
            // Inhale
            events.append(CHHapticEvent(eventType: .hapticContinuous, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            ], relativeTime: delay, duration: self.breathingMode.breathingTimes()[0]))
            
            // Hold
            events.append(CHHapticEvent(eventType: .hapticContinuous, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
            ], relativeTime: delay + self.breathingMode.breathingTimes()[0], duration: self.breathingMode.breathingTimes()[1]))
            
            // Exhale
            events.append(CHHapticEvent(eventType: .hapticContinuous, parameters: [
                CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7),
                CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.8)
            ], relativeTime: delay + self.breathingMode.breathingTimes()[0] + self.breathingMode.breathingTimes()[1], duration: self.breathingMode.breathingTimes()[2]))
        }
        
        return events
    }

    // Start a timer that triggers phase updates at the right times
    private func startPhaseTimer() {
        
        let phaseDuration: TimeInterval = cycleDuration // Each cycle lasts 10 seconds
        
        phaseTimer = Timer.scheduledTimer(withTimeInterval: phaseDuration, repeats: true) { _ in
            self.elapsedTime = 0
            // Move to the next cycle
            self.currentCycle += 1
            
            // Stop after the total cycles are completed
            if self.currentCycle >= self.totalCycles {
                self.stopBreathingExercise()
                self.dismissScreen()
            }
        }
    }

    // Determine the current phase based on the cycle number
    private func phaseForCycle(_ elapsedTime: Double) -> String {
        if elapsedTime < self.breathingMode.breathingTimes()[0] {
            return "Inhale"
        } else if elapsedTime < self.breathingMode.breathingTimes()[0] + self.breathingMode.breathingTimes()[1] {
            return "Hold"
        } else if elapsedTime <= self.breathingMode.breathingTimes()[0] + self.breathingMode.breathingTimes()[1] + self.breathingMode.breathingTimes()[2] {
            return "Exhale"
        } else {
            return "Start"  // Should not reach this point if logic is correct
        }
    }
    
    // Start the elapsed time timer to track the seconds within each phase
    private func startElapsedTimeTimer(updateUI: @escaping (String) -> Void) {
        //elapsedTime = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.elapsedTime += 1
            
            let phase = self.phaseForCycle(self.elapsedTime)
            updateUI(phase)
        }
    }
    
    // Get the current second within the phase
    func getCurrentSecond() -> Int {
        return Int(elapsedTime)
    }
    
    private func dismissScreen() {
        DispatchQueue.main.async {
            self.dismissAction?()  // Call the dismiss action from the parent view
        }
    }
}
