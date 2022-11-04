//
//  WichAnimalAreYouReadingViewController.swift
//  Horoscope
//
//  Created by Polina Solovyova on 28.10.2022.
//

import UIKit

class WichAnimalAreYouReadingViewController: UIViewController {

	enum ScreenState {
		case dataRequest
		case content
	}

	private let endpoint: HoroscopeEndpoint

	private let horoscopeRepository: HoroscopeRepositoryProtocol

	private let loadingIndicator = UIActivityIndicatorView(style: .large)

	private var state: ScreenState = .dataRequest {
		didSet {
			switch state {
			case .dataRequest:
				UIView.animate(withDuration: 0.3) {
					self.dataRequestViewContainer.alpha = 1
				} completion: { _ in
					UIView.animate(withDuration: 0.3) {
						self.scrollView.alpha = 0
						self.contentView.alpha = 0
					}
				}
			case .content:
				UIView.animate(withDuration: 0.3) {
					self.dataRequestViewContainer.alpha = 0
				} completion: { _ in
					UIView.animate(withDuration: 0.3) {
						self.scrollView.alpha = 1
						self.contentView.alpha = 1
					}
				}
			}
		}
	}


	// For data request state
	private let nameLabel = UILabel()

	private let nameTextField = UITextField()

	private let dataRequestViewContainer = UIView()

	private let userBirthdateLabel = UILabel()

	private let userBirthdatePicker = UIDatePicker()

	private let okButton = UIButton()

	// For content state
	private let scrollView = UIScrollView()
	
	private let contentView = UIView()

	private let animalLabel = UILabel()

	private let resultLabel = UILabel()

	private let imageOfAnAnimal = UIImageView()


	override func viewDidLoad() {
		super.viewDidLoad()
		configureView()
		configureRequestView()
		configureScrollView()
		configureContentView()
		view.addSubview(loadingIndicator)
		loadingIndicator.center = self.view.center


	}
	
	init(endpoint: HoroscopeEndpoint, horoscopeRepository: HoroscopeRepositoryProtocol) {
		self.endpoint = endpoint
		self.horoscopeRepository = horoscopeRepository
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func showAlertButtonTapped() {

		let dialogMessage = UIAlertController(title: "Attention", message: "Please try again", preferredStyle: .alert)

		let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
		})

		dialogMessage.addAction(ok)
		self.present(dialogMessage, animated: true, completion: nil)
	}

}

private extension WichAnimalAreYouReadingViewController {
	func configureView()  {
		view.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 1.0, alpha: 1)
		state = .dataRequest
		loadingIndicator.hidesWhenStopped = true
	}

	func configureScrollView() {
		scrollView.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 1.0, alpha: 0.8)
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)

		scrollView.translatesAutoresizingMaskIntoConstraints = false
		contentView.translatesAutoresizingMaskIntoConstraints = false

		scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

		contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor).isActive = true
		contentView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor).isActive = true
		contentView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor).isActive = true

		contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true

		let heightConstraint = contentView.heightAnchor.constraint(
			equalTo: scrollView.frameLayoutGuide.heightAnchor
		)
		heightConstraint.priority = UILayoutPriority(rawValue: 250)
		heightConstraint.isActive = true
	}

	func configureRequestView() {
		view.addSubview(dataRequestViewContainer)
		dataRequestViewContainer.addSubview(nameLabel)
		dataRequestViewContainer.addSubview(nameTextField)
		dataRequestViewContainer.addSubview(userBirthdateLabel)
		dataRequestViewContainer.addSubview(userBirthdatePicker)
		dataRequestViewContainer.addSubview(okButton)

		dataRequestViewContainer.translatesAutoresizingMaskIntoConstraints = false
		userBirthdateLabel.translatesAutoresizingMaskIntoConstraints = false
		userBirthdatePicker.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameTextField.translatesAutoresizingMaskIntoConstraints = false
		okButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate(
			[
				dataRequestViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				dataRequestViewContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				dataRequestViewContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				dataRequestViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

				nameLabel.topAnchor.constraint(
					equalTo: dataRequestViewContainer.safeAreaLayoutGuide.topAnchor,
					constant: Constants.topOffset
				),
				nameLabel.leadingAnchor.constraint(
					equalTo: dataRequestViewContainer.leadingAnchor,
					constant: Constants.leadingOffset
				),
				nameLabel.trailingAnchor.constraint(
					equalTo: dataRequestViewContainer.trailingAnchor,
					constant: -Constants.leadingOffset
				),
				nameLabel.heightAnchor.constraint(
					equalToConstant: 40
				),

				nameTextField.topAnchor.constraint(
					equalTo: nameLabel.bottomAnchor,
					constant: 12
				),
				nameTextField.leadingAnchor.constraint(
					equalTo: dataRequestViewContainer.leadingAnchor,
					constant: Constants.leadingOffset
				),
				nameTextField.trailingAnchor.constraint(
					equalTo: dataRequestViewContainer.trailingAnchor,
					constant: -Constants.trailingOffset
				),
				nameTextField.heightAnchor.constraint(
					equalToConstant: 40
				),

				userBirthdateLabel.topAnchor.constraint(
					equalTo: nameTextField.bottomAnchor,
					constant: Constants.topOffset
				),
				userBirthdateLabel.leadingAnchor.constraint(
					equalTo: dataRequestViewContainer.leadingAnchor,
					constant: Constants.leadingOffset
				),
				userBirthdateLabel.trailingAnchor.constraint(
					equalTo: dataRequestViewContainer.trailingAnchor,
					constant: -Constants.trailingOffset
				),
				userBirthdateLabel.heightAnchor.constraint(
					equalToConstant: 40
				),

				userBirthdatePicker.topAnchor.constraint(
					equalTo: userBirthdateLabel.bottomAnchor,
					constant: 12
				),
				userBirthdatePicker.leadingAnchor.constraint(
					equalTo: dataRequestViewContainer.leadingAnchor,
					constant: Constants.leadingOffset
				),
				userBirthdatePicker.trailingAnchor.constraint(
					equalTo: dataRequestViewContainer.trailingAnchor,
					constant: -Constants.trailingOffset
				),
				userBirthdatePicker.heightAnchor.constraint(
					equalToConstant: 200
				),

				okButton.bottomAnchor.constraint(
					equalTo: dataRequestViewContainer.safeAreaLayoutGuide.bottomAnchor,
					constant: -Constants.bottomOffset
				),
				okButton.leadingAnchor.constraint(
					equalTo: dataRequestViewContainer.safeAreaLayoutGuide.leadingAnchor,
					constant: Constants.leadingOffset
				),
				okButton.trailingAnchor.constraint(
					equalTo: dataRequestViewContainer.safeAreaLayoutGuide.trailingAnchor,
					constant: -Constants.trailingOffset
				),
				okButton.heightAnchor.constraint(
					equalToConstant: 80
				)
			]
		)
		nameLabel.text = "Please enter your name:"
		nameLabel.font = UIFont.boldSystemFont(ofSize: 20)

		nameTextField.borderStyle = .roundedRect
		nameTextField.placeholder = "Name..."

		userBirthdateLabel.text = "Please, choose your birthdate:"
		userBirthdateLabel.font = UIFont.boldSystemFont(ofSize: 20)

		userBirthdatePicker.preferredDatePickerStyle = .wheels
		userBirthdatePicker.datePickerMode = .date

		okButton.setTitle("OK", for: .normal)
		okButton.backgroundColor = UIColor(red: 0.5, green: 0.3, blue: 0.5, alpha: 0.8)
		okButton.layer.cornerRadius = 12
		okButton.setTitleColor(.black, for: .normal)
		okButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
		okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
	}

	@objc
	func okButtonTapped(sender: UIButton) {
		loadingIndicator.startAnimating()
		title = userBirthdatePicker.date.zodiacSign.rawValue.capitalized
		nameTextField.resignFirstResponder()

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let dob = dateFormatter.string(from: userBirthdatePicker.date)

		switch endpoint {
		case .whichAnimalAreYouReading:
			horoscopeRepository.getWhichAnimalData(
				endpoint: endpoint,
				name: nameTextField.text ?? "",
				dateOfBirth: dob
			) { (result: Result<WhichAnimalAreYouReadingPrediction, Error>) -> Void in
				DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
					switch result {
					case let .success(data):
						self.animalLabel.text = data.animal
						self.resultLabel.text = data.result
						self.imageOfAnAnimal.downloaded(from: data.image)
						self.state = .content
					case .failure:
						self.showAlertButtonTapped()
					}
					self.loadingIndicator.stopAnimating()
				}
			}
		default:
			break
		}
	}

	func configureContentView() {
		animalLabel.numberOfLines = 0
		animalLabel.textColor = .purple
		animalLabel.textAlignment = .left
		animalLabel.font = UIFont.boldSystemFont(ofSize: 20)

		resultLabel.numberOfLines = 0
		resultLabel.textColor = .purple
		resultLabel.textAlignment = .left
		//resultLabel.font = UIFont.boldSystemFont(ofSize: 20)

		animalLabel.translatesAutoresizingMaskIntoConstraints = false
		resultLabel.translatesAutoresizingMaskIntoConstraints = false
		imageOfAnAnimal.translatesAutoresizingMaskIntoConstraints = false

		contentView.addSubview(animalLabel)
		contentView.addSubview(resultLabel)
		contentView.addSubview(imageOfAnAnimal)

		NSLayoutConstraint.activate(
			[
				animalLabel.topAnchor.constraint(
					equalTo: contentView.topAnchor,
					constant: Constants.topOffset
				),
				animalLabel.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor,
					constant: Constants.leadingOffset
				),
				animalLabel.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor,
					constant: -Constants.trailingOffset
				),

				resultLabel.topAnchor.constraint(
					equalTo: animalLabel.bottomAnchor,
					constant: Constants.topOffset
				),
				resultLabel.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor,
					constant: Constants.leadingOffset
				),
				resultLabel.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor,
					constant: -Constants.trailingOffset
				),

				imageOfAnAnimal.topAnchor.constraint(
					equalTo: resultLabel.bottomAnchor,
					constant: Constants.topOffset
				),
				imageOfAnAnimal.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor,
					constant: Constants.leadingOffset
				),
				imageOfAnAnimal.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor,
					constant: -Constants.leadingOffset
				),
				imageOfAnAnimal.heightAnchor.constraint(
					equalToConstant: 700
				),
				imageOfAnAnimal.bottomAnchor.constraint(
					equalTo: contentView.bottomAnchor,
					constant: Constants.bottomOffset
				)
			]
		)

	}

}

// MARK: - Constants

private extension WichAnimalAreYouReadingViewController {
	enum Constants {
		static let topOffset: CGFloat = 8
		static let leadingOffset: CGFloat = 16
		static let trailingOffset: CGFloat = 16
		static let bottomOffset: CGFloat = 8
	}
}

