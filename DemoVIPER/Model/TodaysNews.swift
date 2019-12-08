//
//  TodaysNews.swift
//  DemoVIPER
//
//  Created by JOYAL SERRAO on 06/12/19.
//  Copyright © 2019 Joyal Serrao. All rights reserved.
//

import Foundation


struct TodaysNews : Codable {
	let status : String?
	let totalResults : Int?
	let articles : [Articles]?
	enum CodingKeys: String, CodingKey {
		case status = "status"
		case totalResults = "totalResults"
		case articles = "articles"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
		articles = try values.decodeIfPresent([Articles].self, forKey: .articles)
	}

}
