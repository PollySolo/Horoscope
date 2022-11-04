//
//  Date+Extension.swift
//  Horoscope
//
//  Created by Polina Solovyova on 22.10.2022.
//

import Foundation

extension Date {
	var zodiacSign: ZodiacSign {
		get {
			let calendar = Calendar.current
			let day = calendar.component(.day, from: self)
			let month = calendar.component(.month, from: self)

			switch (day, month) {
			case (21...31, 1), (1...19, 2):
				return .Aquarius
			case (20...29, 2), (1...20, 3):
				return .Pisces
			case (21...31, 3), (1...20, 4):
				return .Aries
			case (21...30, 4), (1...21, 5):
				return .Taurus
			case (22...31, 5), (1...21, 6):
				return .Gemini
			case (22...30, 6), (1...22, 7):
				return .Cancer
			case (23...31, 7), (1...22, 8):
				return .Leo
			case (23...31, 8), (1...23, 9):
				return .Virgo
			case (24...30, 9), (1...23, 10):
				return .Libra
			case (24...31, 10), (1...22, 11):
				return .Scorpio
			case (23...30, 11), (1...21, 12):
				return .Sagittarius
			default:
				return .Capricorn
			}
		}
	}
}
enum ZodiacSign: String {
	case Aries
	case Taurus
	case Gemini
	case Cancer
	case Leo
	case Virgo
	case Libra
	case Scorpio
	case Sagittarius
	case Capricorn
	case Aquarius
	case Pisces
}
