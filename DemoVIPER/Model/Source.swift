//
//  Source.swift
//  DemoVIPER
//
//  Created by JOYAL SERRAO on 06/12/19.
//  Copyright © 2019 Joyal Serrao. All rights reserved.
//

import Foundation
struct Source : Codable {
	let id : String?
	let name : String?

	enum CodingKeys: String, CodingKey {

		case id = "id"
		case name = "name"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		name = try values.decodeIfPresent(String.self, forKey: .name)
	}

}
