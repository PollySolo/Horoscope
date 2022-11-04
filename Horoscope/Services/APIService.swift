//
//  APIService.swift
//  Horoscope
//
//  Created by Polina Solovyova on 25.10.2022.
//

import Foundation

final class APIService: HoroscopeRepositoryProtocol {
	func getHoroscopeData<T>(
		endpoint: HoroscopeEndpoint,
		sign: ZodiacSign,
		timeInterval: HoroscopeViewController.TimeInterval?,
		completion: @escaping(Result<HoroscopeDataContainer<T>, Error>) -> Void
	) {
		let date = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let urlSession = URLSession(configuration: .default)
		var urlRequest = URLRequest(url: endpoint.url)
		urlRequest.httpMethod = "POST"
		urlRequest.setValue("*/*", forHTTPHeaderField: "Accept")
		urlRequest.setValue("ru-RU,ru;q=0.9,en-US;q=0.8,en;q=0.7", forHTTPHeaderField: "Accept-Language")
		urlRequest.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
		urlRequest.setValue("keep-alive", forHTTPHeaderField: "Connection")
		if endpoint == .dailyHororsope {
			urlRequest.httpBody = "api_key=2b8a61594b1f4c4db0902a8a395ced93&sign=\(sign.rawValue)&date=\(dateFormatter.string(from: date))".data(using: .utf8)
		}
		if endpoint == .weeklyHoroscope {
			urlRequest.httpBody =
				"api_key=2b8a61594b1f4c4db0902a8a395ced93&sign=\(sign.rawValue)&week=\(timeInterval?.requestQuery ?? "")".data(using: .utf8)
		}
		if endpoint == .monthHoroscope {
			urlRequest.httpBody =
				"api_key=2b8a61594b1f4c4db0902a8a395ced93&sign=\(sign.rawValue)&month=\(timeInterval?.requestQuery ?? "")".data(using: .utf8)

		}
		if endpoint == .yearlyHoroscope {
			urlRequest.httpBody =
				"api_key=2b8a61594b1f4c4db0902a8a395ced93&sign=\(sign.rawValue)&year=\(timeInterval?.requestQuery ?? "")".data(using: .utf8)

		}
		urlSession.dataTask(with: urlRequest) { data, resp, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let data = data else {
				completion(.failure(NSError()))
				return
			}
			do {
				let decodedData = try JSONDecoder().decode(
					HoroscopeDataContainer<T>.self,
					from: data
				)
				completion(.success(decodedData))
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}

	func getFortuneCookieData(
		endpoint: HoroscopeEndpoint,
		completion: @escaping(Result<FortuneCookieData, Error>) -> Void
	) {
		let urlSession = URLSession(configuration: .default)
		var urlRequest = URLRequest(url: endpoint.url)
		urlRequest.httpMethod = "POST"
		urlRequest.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
		urlRequest.httpBody =
				"api_key=2b8a61594b1f4c4db0902a8a395ced93".data(using: .utf8)
		urlSession.dataTask(with: urlRequest) { data, resp, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let data = data else {
				completion(.failure(NSError()))
				return
			}
			do {
				let decodedData = try JSONDecoder().decode(
					HoroscopeDataContainer<FortuneCookieData>.self,
					from: data
				)
				completion(.success(decodedData.data))
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}

	func getWhichAnimalData(
		endpoint: HoroscopeEndpoint,
		name: String,
		dateOfBirth: String,
		completion: @escaping(Result<WhichAnimalAreYouReadingPrediction, Error>) -> Void
	) {
		let urlSession = URLSession(configuration: .default)
		var urlRequest = URLRequest(url: endpoint.url)
		urlRequest.httpMethod = "POST"
		urlRequest.setValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
		urlRequest.httpBody =
			"api_key=2b8a61594b1f4c4db0902a8a395ced93&name=\(name)&dob=\(dateOfBirth)".data(using: .utf8)
		urlSession.dataTask(with: urlRequest) { data, resp, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			guard let data = data else {
				completion(.failure(NSError()))
				return
			}
			do {
				let decodedData = try JSONDecoder().decode(
					HoroscopeDataContainer<WhichAnimalAreYouReadingPrediction>.self,
					from: data
				)
				completion(.success(decodedData.data))
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}
}
