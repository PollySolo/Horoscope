//
//  UIImageView+Extension.swift
//  Horoscope
//
//  Created by Polina Solovyova on 28.10.2022.
//

import Foundation
import UIKit

extension UIImageView {
	func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
		contentMode = mode
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)
			else { return }
			DispatchQueue.main.async() { [weak self] in
				self?.image = image
			}
		}.resume()
	}
}
