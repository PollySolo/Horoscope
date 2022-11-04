//
//  HoroscopeItemCell.swift
//  Horoscope
//
//  Created by Polina Solovyova on 17.10.2022.
//

import UIKit

final class HoroscopeItemCell: UICollectionViewCell {

	static let reuseIdentifier = String(describing: HoroscopeItemCell.self)

	private let titleLabel = UILabel()

	func configure(with horoscope: HoroscopeEndpoint) {
		titleLabel.text = horoscope.name
		backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 1.0, alpha: 0.8)
		titleLabel.textColor = .purple
		titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
		layer.cornerRadius = 10
	}


	override init(frame: CGRect) {
		super.init(frame: frame)
		setupView()
	}

	private func setupView() {
		titleLabel.textAlignment = .center
		titleLabel.numberOfLines = 0

		layer.borderColor = UIColor.black.cgColor
		layer.borderWidth = 1.0

		contentView.addSubview(titleLabel)
		configureConstraints()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configureConstraints() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate(
			[
				titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
				titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
				titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
				titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
				titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
				titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
			]
		)
	}

}
