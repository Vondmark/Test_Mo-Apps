//
//  ProjectResponse.swift
//  Test_Mo'Apps
//
//  Created by Mark on 10.05.2020.
//  Copyright © 2020 Mark. All rights reserved.
//

import Foundation

struct ProjectResponse: Codable {
    var data: [ProjectData]
}

struct ProjectData: Codable {
    var applicationIcoUrl: String?
    var applicationName: String?
    var applicationUrl: String?
    var isPayment: Bool?
    var applicationStatus: Bool?
}

