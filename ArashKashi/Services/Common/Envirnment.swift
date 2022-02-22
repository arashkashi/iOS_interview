//
//  Envirnment.swift
//  ArashKashi
//
//  Created by Arash Kashi on 01.02.22.
//

import Foundation

enum Environment {
	case debug
	case release
	
	var host: String {
		return "poi-api.mytaxi.com"
	}
	var scheme: String {
		return "https"
	}
}

#if DEBUG
let currentEnvironment: Environment = .debug
#else
let currentEnvironment: Environment = .release
#endif
