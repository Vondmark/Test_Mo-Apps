//
//  AutorizationResponse.swift
//  Test_Mo'Apps
//
//  Created by Mark on 09.05.2020.
//  Copyright © 2020 Mark. All rights reserved.
//

import Foundation

struct AutorizationResponse: Codable {
    var code: Int
    var data: String
    var err: Bool
}
