//
//  Settings.swift
//  LearnerCoacher
//
//  Created by Matt Greenfield on 9/08/16.
//  Copyright © 2016 Big Paua. All rights reserved.
//

import LocoKit
import HealthKit
import UserNotifications

enum SettingsKey: String {
    case buildNumber

    // sessions
    case recordingOn
    case sharingOn
    case backupsOn
    case isActiveBacker

    // onboarding
    case haveRequestedHealthPermissions
    case haveRequestedMotionPermissions

    case foursquareToken
    case lastFmUsername
    case lastSwarmCheckinDate
    case lastLastFmTrackDate

    case showEndTimesOnTimeline

    case allowMapRotate
    case allowMapTilt

    case showBackgroundLocationIndicator

    case taskStates

    static let sharedSettings: [SettingsKey] = [
        .recordingOn, .backupsOn, .isActiveBacker, .showBackgroundLocationIndicator
    ]
}

// MARK: -

class Settings {

    static let highlander = Settings()

    // MARK: -

    static let earliestAllowedDate = Date(timeIntervalSince1970: 946684800) // 01-1-2000 (earlier than Arc App, to allow Moves imports)
    static let restrictFoursquareQueriesToBackers = true

    // MARK: -

    static var recordingOn: Bool {
        get { highlander[.recordingOn] as? Bool ?? true }
        set { highlander[.recordingOn] = newValue }
    }
    static var sharingOn: Bool { return highlander[.sharingOn] as? Bool ?? true }
    static var backupsOn: Bool { return highlander[.backupsOn] as? Bool ?? false }
    static var isActiveBacker: Bool { return highlander[.isActiveBacker] as? Bool ?? false }
    static var showBackgroundLocationIndicator: Bool { highlander[.showBackgroundLocationIndicator] as? Bool ?? false }

    static var showEndTimesOnTimeline: Bool {
        get { return highlander[.showEndTimesOnTimeline] as? Bool ?? false }
        set(newValue) { highlander[.showEndTimesOnTimeline] = newValue }
    }

    static var allowMapRotate: Bool {
        get { return highlander[.allowMapRotate] as? Bool ?? false }
        set(newValue) { highlander[.allowMapRotate] = newValue }
    }

    static var allowMapTilt: Bool {
        get { return highlander[.allowMapTilt] as? Bool ?? false }
        set(newValue) { highlander[.allowMapTilt] = newValue }
    }

    // MARK: - Onboarding

    static var needsOnboarding: Bool {
        if !LocomotionManager.highlander.haveLocationPermission { return true }
        if !haveCoreMotionPermission && !haveRequestedMotionPermissions { return true }
        if !haveHealthKitPermission && !haveRequestedHealthPermissions { return true }
        return false
    }

    // MARK: - Permissions

    static var notificationsPermission: UNAuthorizationStatus?

    static var haveRequestedMotionPermissions: Bool {
        get { return highlander[.haveRequestedMotionPermissions] as? Bool ?? false }
        set(newValue) { highlander[.haveRequestedMotionPermissions] = newValue }
    }

    static var haveNecessaryPermissions: Bool {
        if !LocomotionManager.highlander.haveBackgroundLocationPermission { return false }
        if UIApplication.shared.backgroundRefreshStatus != .available { return false }
        if notificationsPermission != .authorized { return false }
        return true
    }

    static var haveCoreMotionPermission: Bool {
        return LocomotionManager.highlander.haveCoreMotionPermission
    }

    static var shouldAttemptToUseCoreMotion: Bool {
        return haveCoreMotionPermission || haveRequestedMotionPermissions
    }

    static var haveRequestedHealthPermissions: Bool {
        get { return highlander[.haveRequestedHealthPermissions] as? Bool ?? false }
        set(newValue) { highlander[.haveRequestedHealthPermissions] = newValue }
    }

    static func requestHealthKitPermissions() {
        Health.highlander.requestPermissions()
        haveRequestedHealthPermissions = true
    }

    static func requestNotificationPerms() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { granted, error in
            self.determineNotificationsPerms()
        }
    }

    static func determineNotificationsPerms() {
        guard notificationsPermission == nil else { return }
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            self.notificationsPermission = settings.authorizationStatus
        }
    }

    static var haveHealthKitPermission: Bool {
        if !HKHealthStore.isHealthDataAvailable() { return true }
        for permission in Health.readPermissions.values {
            if !permission { return false }
        }
        return true
    }

    static var shouldRequestNotificationPermission: Bool {
        guard let perms = notificationsPermission else { return true }
        return perms == .notDetermined
    }

    static var haveNotificationsPermission: Bool {
        return notificationsPermission == .authorized
    }
    
    static var canFoursquare: Bool = { return UIApplication.shared.canOpenURL(URL(string: "foursquare://")!) }()
    static var canSwarm: Bool = { return UIApplication.shared.canOpenURL(URL(string: "swarm://")!) }()
    static var haveFoursquareAuth: Bool { return Settings.highlander[.foursquareToken] != nil }

    // MARK: - Email debug info

    public static var emailFooter: String {
        return "\n\n\n"
            + "---------\n"
            + debugDeviceString + "\n"
            + debugProblemsString + "\n"
            + debugString + "\n"
            + "i: \(UIDevice.current.identifierForVendor?.uuidString ?? "nil")\n\n"
    }

    private static var debugDeviceString: String {
        return "arc: \(Bundle.versionNumber) (\(Bundle.buildNumber)), "
            + "dev: \(UIDevice.current.modelCode) (\(UIDevice.current.systemVersion)) \(Locale.preferredLanguages[0])"
    }

    private static var debugProblemsString: String {
        return ""
            .appendingCode("bl", boolValue: LocomotionManager.highlander.haveBackgroundLocationPermission, safeValue: true)
            .appendingCode("br", boolValue: UIApplication.shared.backgroundRefreshStatus == .available, safeValue: true)
            .appendingCode("no", boolValue: notificationsPermission == .authorized, safeValue: true)
    }

    private static var debugString: String {
        return "ro: \(Settings.recordingOn), "
            + "cs: \(Settings.sharingOn)\n"
    }

    // MARK: - Item getters

    static var dataDateRange: DateInterval {
        return DateInterval(start: firstDate.startOfDay(), end: .now)
    }

    static var firstDate: Date {
        guard let firstItemStartDate = firstTimelineItem?.startDate else { return Date() }
        return firstItemStartDate > earliestAllowedDate ? firstItemStartDate : earliestAllowedDate
    }

    static var _firstTimelineItem: TimelineItem?
    static var firstTimelineItem: TimelineItem? {
        if let cached = _firstTimelineItem, !cached.deleted, cached.startDate != nil { return cached }
        let firstItem = RecordingManager.store.item(where: "startDate IS NOT NULL AND deleted = 0 ORDER BY startDate")
        _firstTimelineItem = firstItem
        return _firstTimelineItem
    }

    // MARK: - Private settings getters

    static let configPlist: [String: Any]? = {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist") else { return nil }
        guard let data = FileManager.default.contents(atPath: path) else { return nil }
        do {
            return try PropertyListSerialization.propertyList(from: data, options: .mutableContainersAndLeaves, format: nil) as? [String: Any]
        } catch {
            logger.error("\(error)")
            return nil
        }
    }()

    static let foursquareAPIKey: String? = {
        return configPlist?["FoursquareAPIKey"] as? String
    }()

    static let foursquareClientId: String? = {
        return configPlist?["FoursquareClientId"] as? String
    }()

    static let foursquareClientSecret: String? = {
        return configPlist?["FoursquareClientSecret"] as? String
    }()

    // MARK: - Subscript

    subscript(key: SettingsKey) -> Any? {
        get {
            if SettingsKey.sharedSettings.contains(key) {
                let loco = LocomotionManager.highlander
                if let value = loco.appGroup?.get(setting: key.rawValue) as Any? {
                    return value
                }
                
                // if there's a local value, move it to the app group
                if let value = UserDefaults.standard.value(forKey: key.rawValue) as Any? {
                    loco.appGroup?.set(setting: key.rawValue, value: value)
                    UserDefaults.standard.removeObject(forKey: key.rawValue)
                    logger.info("moved shared setting to AppGroup (key: \(key.rawValue), value: \(value))", subsystem: .misc)
                    return value
                }
            }
            return UserDefaults.standard.value(forKey: key.rawValue) as Any?
        }
        
        set(value) {
            if SettingsKey.sharedSettings.contains(key) {
                LocomotionManager.highlander.appGroup?.set(setting: key.rawValue, value: value)
            } else {
                UserDefaults.standard.set(value, forKey: key.rawValue)
            }
        }
    }

}

// MARK: -

extension String {
    fileprivate func appendingCode(_ code: String, boolValue: Bool, safeValue: Bool) -> String {
        var mutated = self
        if !mutated.isEmpty { mutated += ", " }
        mutated += "\(code): \(boolValue)"
        if boolValue != safeValue { mutated += "*" }
        return mutated
    }
}
