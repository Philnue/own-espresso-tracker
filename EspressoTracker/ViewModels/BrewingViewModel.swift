//
//  BrewingViewModel.swift
//  EspressoTracker
//
//  View model for brewing session with stopwatch functionality
//

import Foundation
import Combine
import SwiftUI

class BrewingViewModel: ObservableObject {
    @Published var isRunning = false
    @Published var elapsedTime: TimeInterval = 0
    @Published var doseIn: String = "18"
    @Published var targetRatio: Double = 2.0
    @Published var grindSetting: String = ""
    @Published var waterTemp: String = "93"
    @Published var pressure: String = "9.0"

    private var timer: Timer?
    private var startTime: Date?

    // Calculated properties
    var targetYield: Double {
        guard let dose = Double(doseIn) else { return 0 }
        return dose * targetRatio
    }

    var targetYieldString: String {
        String(format: "%.1f", targetYield)
    }

    var elapsedTimeString: String {
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        let milliseconds = Int((elapsedTime.truncatingRemainder(dividingBy: 1)) * 10)

        if minutes > 0 {
            return String(format: "%d:%02d.%d", minutes, seconds, milliseconds)
        } else {
            return String(format: "%02d.%d", seconds, milliseconds)
        }
    }

    // Preset ratios
    let ratioPresets: [(name: String, ratio: Double)] = [
        ("Ristretto", 1.5),
        ("Normale", 2.0),
        ("Lungo", 2.5),
        ("Custom", 3.0)
    ]

    func startTimer() {
        guard !isRunning else { return }

        isRunning = true
        startTime = Date()

        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.startTime else { return }
            self.elapsedTime = Date().timeIntervalSince(startTime)
        }
    }

    func stopTimer() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func resetTimer() {
        stopTimer()
        elapsedTime = 0
        startTime = nil
    }

    func toggleTimer() {
        if isRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }
}
