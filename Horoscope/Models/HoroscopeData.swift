//
//  HoroscopeData.swift
//  Horoscope
//
//  Created by Polina Solovyova on 21.10.2022.
//

import Foundation

enum MainSectionModel {
	case main
}

// Horoscope

struct HoroscopeDataContainer<T: Decodable>: Decodable {
	let data: T
}

struct DailyHoroscopePrediction: Decodable {
	let sign: String
	let prediction: HoroscopePrediction
}

struct WeeklyHoroscopePrediction: Decodable {
	let prediction: HoroscopePrediction

	enum CodingKeys: String, CodingKey {
		case prediction = "weekly_horoscope"
	}
}

struct MonthHoroscopePrediction: Decodable {
	let prediction: HoroscopePrediction

	enum CodingKeys: String, CodingKey {
		case prediction = "monthly_horoscope"
	}
}

struct YearlyHoroscopePrediction: Decodable {
	let prediction: HoroscopePrediction

	enum CodingKeys: String, CodingKey {
		case prediction = "yearly_horoscope"
	}
}

struct HoroscopePrediction: Decodable {
	let personal: String
	let profession: String
	let emotions: String
	let travel: String
	let luck: [String]
}

// Fortune Cookie

struct FortuneCookieData: Decodable {
	let prediction: FortuneCookiePrediction
}

struct FortuneCookiePrediction: Decodable {
	let result: String
}

// Which Animal Are You?

struct WhichAnimalAreYouReadingPrediction: Decodable {
	let animal: String
	let result: String
	let image: URL
}
