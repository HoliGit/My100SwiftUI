//
//  Haptics.swift
//  Flashzilla
//
//  Created by EO on 30/09/21.
//

import Foundation
import CoreHaptics

class HapticManager {
  // hold reference to CoreHaptics engine
  let hapticEngine: CHHapticEngine

  //the initializer could fail
  init?() {
    // check CH capability
    let hapticCapability = CHHapticEngine.capabilitiesForHardware()
    guard hapticCapability.supportsHaptics else {
      return nil
    }

    // the engine can throw, so we need a do/catch
    do {
      hapticEngine = try CHHapticEngine()
    } catch let error {
      print("Haptic engine Creation Error: \(error)")
      return nil
    }
  }
    
    func prepare() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            try hapticEngine.start()
        } catch {
            print("Error creating engine")
        }
    }
    
    func customHapticPattern() {
      do {
          //call the pattern
        let pattern = try hapticOne()
        
          // try to start engine
        try hapticEngine.start()
        
          // make a player for the pattern
        let player = try hapticEngine.makePlayer(with: pattern)
        
          // try to play immediately
        try player.start(atTime: CHHapticTimeImmediate)
        
          // after playing stop the engine
        hapticEngine.notifyWhenPlayersFinished { _ in
          return .stopEngine
        }
      } catch {
        print("Failed to play pattern: \(error)")
      }
    }

}

extension HapticManager {
  private func hapticOne() throws -> CHHapticPattern {
    let eventOne = CHHapticEvent(
      eventType: .hapticContinuous,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.45),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.35)
      ],
      relativeTime: 0,
      duration: 0.25)

    let eventTwo = CHHapticEvent(
      eventType: .hapticTransient,
      parameters: [
        CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),
        CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
      ],
      relativeTime: 0.08)

    return try CHHapticPattern(events: [eventOne, eventTwo], parameters: [])
  }
}

