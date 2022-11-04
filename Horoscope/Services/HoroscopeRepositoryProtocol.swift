//
// HoroscopeRepositoryProtocol.swift
//  Horoscope
//
//  Created by Николай Спиридонов on 31.10.2022.
//

import Foundation

protocol HoroscopeRepositoryProtocol {
	func getHoroscopeData<T>(
		endpoint: HoroscopeEndpoint,
		sign: ZodiacSign,
		timeInterval: HoroscopeViewController.TimeInterval?,
		completion: @escaping(Result<HoroscopeDataContainer<T>, Error>) -> Void
	)

	func getFortuneCookieData(
		endpoint: HoroscopeEndpoint,
		completion: @escaping(Result<FortuneCookieData, Error>) -> Void
	)

	func getWhichAnimalData(
		endpoint: HoroscopeEndpoint,
		name: String,
		dateOfBirth: String,
		completion: @escaping(Result<WhichAnimalAreYouReadingPrediction, Error>) -> Void
	)
}
