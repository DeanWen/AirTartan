//
//  Startable.swift
//  AirTartan
//
//  Copyright (c) 2014 Team Air Crew. All rights reserved.
//

// Start and stop animation
protocol Startable {
    func start() -> Startable
    func stop() -> Startable
}
