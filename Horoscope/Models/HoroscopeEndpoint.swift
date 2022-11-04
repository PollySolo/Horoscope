//
//  HoroscopeEndpoint.swift
//  Horoscope
//
//  Created by Polina Solovyova on 18.10.2022.
//

import Foundation

enum HoroscopeEndpoint: CaseIterable {

	case dailyHororsope
	case weeklyHoroscope
	case monthHoroscope
	case yearlyHoroscope
	case fortuneCookie
	case whichAnimalAreYouReading

	var url: URL {
		switch self {
		case .dailyHororsope:
			return URL(string: "https://divineapi.com/api/1.0/get_daily_horoscope.php")!
		case .weeklyHoroscope:
			return URL(string: "https://divineapi.com/api/1.0/get_weekly_horoscope.php")!
		case .monthHoroscope:
			return URL(string: "https://divineapi.com/api/1.0/get_monthly_horoscope.php")!
		case .yearlyHoroscope:
			return URL(string: "https://divineapi.com/api/1.0/get_yearly_horoscope.php")!
		case .fortuneCookie:
			return URL(string: "https://divineapi.com/api/1.0/get_fortune_cookie.php")!
		case .whichAnimalAreYouReading:
			return URL(string: "https://divineapi.com/api/1.0/get_which_animal_are_you_reading.php")!
		}
	}

	var name: String {
		switch self {
		case .dailyHororsope:
			return "Daily horoscope"
		case .weeklyHoroscope:
			return "Weekly horoscope"
		case .monthHoroscope:
			return "Month horoscope"
		case .yearlyHoroscope:
			return "Yearly horoscope"
		case .fortuneCookie:
			return "Fortune cookie"
		case .whichAnimalAreYouReading:
			return "Which animal are you reading"
		}
	}
}


