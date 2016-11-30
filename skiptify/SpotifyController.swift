//
//  SpotifyController.swift
//  skiptify
//
//  Created by David Ungurean on 30/11/2016.
//  Copyright © 2016 David Ungurean. All rights reserved.
//

import Cocoa

/// Controller class that handles interaction with spotify using AppleScript
class SpotifyController {
    
    enum PlayerAction: String {
        case stop = "stop"
        case play = "play"
        case pause = "pause"
        case nextTrack = "next track"
        case previousTrack = "previous track"
        case shuffleOn = "set shuffling to shuffling"
        case shuffleOff = "set shuffling to not shuffling"
        case repeatOn = "set repeating to repeating"
        case repeatOff = "set repeating to not repeating"
    }
 
    @discardableResult
    func execute(action: PlayerAction) -> String? {
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e", "tell application \"Spotify\" to \(action.rawValue)"]
    
        let outPipe = Pipe()
        task.standardOutput = outPipe
        task.launch()
        task.waitUntilExit()
        let outHandle = outPipe.fileHandleForReading
        let output = NSString(data: outHandle.availableData, encoding: String.Encoding.ascii.rawValue) as NSString?
        
        return output?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
}
