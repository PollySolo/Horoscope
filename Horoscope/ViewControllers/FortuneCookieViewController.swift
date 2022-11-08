//
//  FortuneCookieViewController.swift
//  Horoscope
//
//  Created by Polina Solovyova on 20.10.2022.
//

import UIKit
import SnapKit

class FortuneCookieViewController: UIViewController {

	private let endpoint: HoroscopeEndpoint

	private let horoscopeRepository: HoroscopeRepositoryProtocol

	private let messageLabel = UILabel()
	
	private let loadingIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
		configureLabel()
		makeRequest()
		view.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 1.0, alpha: 1)
		view.addSubview(loadingIndicator)
		loadingIndicator.center = self.view.center
		loadingIndicator.hidesWhenStopped = true
		loadingIndicator.startAnimating()
        super.viewDidLoad()
    }

	func configureLabel() {
		let edges = UIEdgeInsets(
			top: Constants.topOffset,
			left: Constants.leadingOffset,
			bottom: Constants.bottomOffset,
			right: Constants.leadingOffset
		)
		view.addSubview(messageLabel)
		messageLabel.textAlignment = .center
		messageLabel.numberOfLines = 0
		messageLabel.textColor = .purple
		messageLabel.font = UIFont.boldSystemFont(ofSize: 20)
		messageLabel.snp.makeConstraints {
			$0.centerY.equalToSuperview()
			$0.leading.trailing.equalToSuperview().inset(edges)
		}
	}

	init(endpoint: HoroscopeEndpoint, horoscopeRepository: HoroscopeRepositoryProtocol) {
		self.endpoint = endpoint
		self.horoscopeRepository = horoscopeRepository
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func makeRequest() {
		horoscopeRepository.getFortuneCookieData(endpoint: endpoint) {
		(result: Result<FortuneCookieData, Error>) -> Void in
			DispatchQueue.main.async { [weak self] in
				guard let self = self else { return }
				switch result {
				case let .success(data):
					self.messageLabel.text = data.prediction.result
				case .failure:
					self.showAlertButtonTapped()
				}
				self.loadingIndicator.stopAnimating()
			}
		}
	}
	private func showAlertButtonTapped() {

		let dialogMessage = UIAlertController(title: "Attention", message: "Please try again", preferredStyle: .alert)

		let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
		})

		dialogMessage.addAction(ok)
		self.present(dialogMessage, animated: true, completion: nil)
	}

}
// MARK: - Constants

private extension FortuneCookieViewController {
	enum Constants {
		static let topOffset: CGFloat = 320
		static let leadingOffset: CGFloat = 16
		static let trailingOffset: CGFloat = 16
		static let minimumLabelOffset: CGFloat = 20
		static let bottomOffset: CGFloat = 12
		static let topPicker: CGFloat = 70
	}
}
