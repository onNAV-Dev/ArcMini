//
//  AppDelegate.swift
//  Arc Mini
//
//  Created by Matt Greenfield on 2/3/20.
//  Copyright © 2020 Matt Greenfield. All rights reserved.
//

import UIKit
import LocoKit
import SwiftNotes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var thermalState: ProcessInfo.ThermalState = .nominal

    static var highlander: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    // MARK: - App lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        logger.info("didFinishLaunchingWithOptions")

        CoreMLModelUpdater.highlander.store = RecordingManager.store
        LocomotionManager.highlander.coordinateAssessor = CoordinateTrustManager(store: RecordingManager.store)
        LocomotionManager.highlander.appGroup = AppGroup(appName: .arcMini, suiteName: "group.ArcApp")
        LocomotionManager.highlander.appGroup?.timeline = RecordingManager.recorder

        UIDevice.current.isBatteryMonitoringEnabled = true

        thermalStateChanged()
        TasksManager.highlander.registerBackgroundTasks()

        when(UIDevice.batteryStateDidChangeNotification) { _ in
            if UIDevice.current.batteryState != .unplugged {
                TasksManager.highlander.scheduleBackgroundTasks()
            }
        }

        when(ProcessInfo.thermalStateDidChangeNotification) { _ in
            self.thermalStateChanged()
            RecordingManager.highlander.updateSamplingFrequency()
        }
        
        when(.NSProcessInfoPowerStateDidChange) { _ in
            RecordingManager.highlander.updateSamplingFrequency()
        }

        applyUIAppearanceOverrides()

        // onboarding (barely. heh)
        LocomotionManager.highlander.requestLocationPermission(background: true)
        LocomotionManager.highlander.startCoreMotion()

        delay(6) { RecordingManager.highlander.startRecording() }
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        logger.info("applicationWillTerminate")
    }

    // MARK: -

    func applyUIAppearanceOverrides() {
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().showsVerticalScrollIndicator = false // TODO: want this per view, not global
    }

    func thermalStateChanged() {
        AppDelegate.thermalState = ProcessInfo.processInfo.thermalState
        logger.info("thermalState: \(AppDelegate.thermalState.stringValue)")
    }

    // MARK: - Memory footprint

    private static let memoryFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }()

    static var memoryString: String? {
        guard let footprint = ProcessInfo.processInfo.memoryFootprint else { return nil }
        return memoryFormatter.string(from: footprint.converted(to: .megabytes))
    }

}

