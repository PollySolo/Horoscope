//
//  HoroscopeViewController.swift
//  Horoscope
//
//  Created by Polina Solovyova on 18.10.2022.
//

import UIKit

final class HoroscopeViewController: UIViewController {

	enum ScreenState {
		case dataRequest
		case content
	}

	enum TimeInterval: String, CaseIterable {
		case previous
		case current
		case next

		var requestQuery: String {
			switch self {
			case .current:
				return "current"
			case .next:
				return "next"
			case .previous:
				return "prev"
			}
		}
	}

	//private var buttonInAllert = UIButton()

	private let segementedVariants = TimeInterval.allCases

	private let endpoint: HoroscopeEndpoint

	private let horoscopeRepository: HoroscopeRepositoryProtocol

	private var state: ScreenState = .dataRequest {
		didSet {
			switch state {
			case .dataRequest:
				UIView.animate(withDuration: 0.3) {
					self.dataRequestViewContainer.alpha = 1
				} completion: { _ in
					UIView.animate(withDuration: 0.3) {
						self.scrollView.alpha = 0
						(self.nameLabels + self.valueLabels).forEach {
							$0.alpha = 0
						}
					}
				}
			case .content:
				UIView.animate(withDuration: 0.3) {
					self.dataRequestViewContainer.alpha = 0
				} completion: { _ in
					UIView.animate(withDuration: 0.3) {
						self.scrollView.alpha = 1
						(self.nameLabels + self.valueLabels).forEach {
							$0.alpha = 1
						}
					}
				}
			}
		}
	}

	private let loadingIndicator = UIActivityIndicatorView(style: .large)

	// For data request state

	private let dataRequestViewContainer = UIView()

	private let userBirthdateLabel = UILabel()

	private let userBirthdatePicker = UIDatePicker()

	private let typeOfTimeIntervalLabel = UILabel()

	private let typeOfTimeIntervalSegmented = UISegmentedControl()

	private let okButton = UIButton()

	// For content state

	private var nameLabels: [UILabel] {
		[
			personalNameLabel,
			professionNameLabel,
			emotionsNameLabel,
			travelNameLabel,
			luckNameLabel
		]
	}

	private var valueLabels: [UILabel] {
		[
			personalValueLabel,
			professionValueLabel,
			emotionsValueLabel,
			travelValueLabel,
			luckValueLabel
		]
	}

	private let scrollView = UIScrollView()
	private let contentView = UIView()

	private let personalNameLabel = UILabel()
	private let personalValueLabel = UILabel()

	private let professionNameLabel = UILabel()
	private let professionValueLabel = UILabel()

	private let emotionsNameLabel = UILabel()
	private let emotionsValueLabel = UILabel()

	private let travelNameLabel = UILabel()
	private let travelValueLabel = UILabel()

	private let luckNameLabel = UILabel()
	private let luckValueLabel = UILabel()

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
}

// MARK: - Private

private extension HoroscopeViewController {
	func configureView()  {
		view.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 1.0, alpha: 1)
		state = .dataRequest
		loadingIndicator.hidesWhenStopped = true
	}

	func configureScrollView() {
		scrollView.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 1.0, alpha: 0.8)//.withAlphaComponent(0.8)
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)

		scrollView.translatesAutoresizingMaskIntoConstraints = false
		contentView.translatesAutoresizingMaskIntoConstraints = false

		scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

		contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
		contentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		contentView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
		contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
		contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

		let heightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
		heightConstraint.priority = UILayoutPriority(rawValue: 250)
		heightConstraint.isActive = true
	}

	func configureRequestView() {
		view.addSubview(dataRequestViewContainer)
		dataRequestViewContainer.addSubview(userBirthdateLabel)
		dataRequestViewContainer.addSubview(userBirthdatePicker)
		dataRequestViewContainer.addSubview(typeOfTimeIntervalLabel)
		dataRequestViewContainer.addSubview(typeOfTimeIntervalSegmented)
		dataRequestViewContainer.addSubview(okButton)

		dataRequestViewContainer.translatesAutoresizingMaskIntoConstraints = false
		userBirthdateLabel.translatesAutoresizingMaskIntoConstraints = false
		userBirthdatePicker.translatesAutoresizingMaskIntoConstraints = false
		typeOfTimeIntervalLabel.translatesAutoresizingMaskIntoConstraints = false
		typeOfTimeIntervalSegmented.translatesAutoresizingMaskIntoConstraints = false
		okButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate(
			[
				dataRequestViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
				dataRequestViewContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
				dataRequestViewContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
				dataRequestViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

				userBirthdateLabel.topAnchor.constraint(
					equalTo: dataRequestViewContainer.safeAreaLayoutGuide.topAnchor,
					constant: Constants.topOffset
				),
				userBirthdateLabel.leadingAnchor.constraint(
					equalTo: dataRequestViewContainer.leadingAnchor,
					constant: Constants.leadingOffset
				),
				userBirthdateLabel.trailingAnchor.constraint(
					equalTo: dataRequestViewContainer.trailingAnchor,
					constant: -Constants.leadingOffset
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
					constant: -Constants.leadingOffset
				),
				userBirthdatePicker.heightAnchor.constraint(
					equalToConstant: 200
				),

				typeOfTimeIntervalLabel.topAnchor.constraint(
					equalTo: userBirthdatePicker.bottomAnchor,
					constant: Constants.topOffset
				),
				typeOfTimeIntervalLabel.leadingAnchor.constraint(
					equalTo: dataRequestViewContainer.leadingAnchor,
					constant: Constants.leadingOffset
				),
				typeOfTimeIntervalLabel.trailingAnchor.constraint(
					equalTo: dataRequestViewContainer.trailingAnchor,
					constant: -Constants.trailingOffset
				),

				typeOfTimeIntervalSegmented.topAnchor.constraint(
					equalTo: typeOfTimeIntervalLabel.bottomAnchor,
					constant: Constants.topOffset
				),
				typeOfTimeIntervalSegmented.leadingAnchor.constraint(
					equalTo: dataRequestViewContainer.leadingAnchor,
					constant: Constants.leadingOffset
				),
				typeOfTimeIntervalSegmented.trailingAnchor.constraint(
					equalTo: dataRequestViewContainer.trailingAnchor,
					constant: -Constants.trailingOffset
				),
				typeOfTimeIntervalSegmented.heightAnchor.constraint(
					equalToConstant: 40
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

		userBirthdateLabel.text = "Please, choose your birthdate:"
		userBirthdateLabel.font = UIFont.boldSystemFont(ofSize: 20)

		userBirthdatePicker.preferredDatePickerStyle = .wheels
		userBirthdatePicker.datePickerMode = .date

		typeOfTimeIntervalLabel.font = UIFont.boldSystemFont(ofSize: 20)

		if endpoint == .weeklyHoroscope || endpoint == .monthHoroscope || endpoint == .yearlyHoroscope {
			let titleTextComponent: String
			switch endpoint {
			case .weeklyHoroscope:
				titleTextComponent = "week"
			case .monthHoroscope:
				titleTextComponent = "month"
			case .yearlyHoroscope:
				titleTextComponent = "year"
			default:
				titleTextComponent = ""
			}
			typeOfTimeIntervalLabel.text = "Select \(titleTextComponent):"
			typeOfTimeIntervalSegmented.insertSegment(withTitle: segementedVariants[0].rawValue, at: 0, animated: false)
			typeOfTimeIntervalSegmented.insertSegment(withTitle: segementedVariants[1].rawValue, at: 1, animated: false)
			typeOfTimeIntervalSegmented.insertSegment(withTitle: segementedVariants[2].rawValue, at: 2, animated: false)
		}

		typeOfTimeIntervalSegmented.selectedSegmentIndex = 1
		typeOfTimeIntervalSegmented.selectedSegmentTintColor = UIColor(red: 0.5, green: 0.3, blue: 0.5, alpha: 0.8)

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
		switch endpoint {
		case .dailyHororsope:
			horoscopeRepository.getHoroscopeData(
				endpoint: endpoint,
				sign: userBirthdatePicker.date.zodiacSign,
				timeInterval: nil
			) { (result: Result<HoroscopeDataContainer<DailyHoroscopePrediction>, Error>) -> Void in
				DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
					switch result {
					case let .success(data):
						self.personalValueLabel.text = data.data.prediction.personal
						self.professionValueLabel.text = data.data.prediction.profession
						self.emotionsValueLabel.text = data.data.prediction.emotions
						self.travelValueLabel.text = data.data.prediction.travel
						let luckString: String = data.data.prediction.luck.reduce(String(), { result, tempString in
							result.appending(tempString + "\n\n")
						})
						self.luckValueLabel.text = luckString
						self.state = .content
					case .failure:
						self.showAlertButtonTapped()
					}
					self.loadingIndicator.stopAnimating()
				}
			}
		case .weeklyHoroscope:
			horoscopeRepository.getHoroscopeData(
				endpoint: endpoint,
				sign: userBirthdatePicker.date.zodiacSign,
				timeInterval: segementedVariants[typeOfTimeIntervalSegmented.selectedSegmentIndex]
			) { (result: Result<HoroscopeDataContainer<WeeklyHoroscopePrediction>, Error>) -> Void in
				DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
					switch result {
					case let .success(data):
						self.personalValueLabel.text = data.data.prediction.personal
						self.professionValueLabel.text = data.data.prediction.profession
						self.emotionsValueLabel.text = data.data.prediction.emotions
						self.travelValueLabel.text = data.data.prediction.travel
						let luckString: String = data.data.prediction.luck.reduce(String(), { result, tempString in
							result.appending(tempString + "\n\n")
						})
						self.luckValueLabel.text = luckString
						self.state = .content
					case .failure:
						self.showAlertButtonTapped()
					}
					self.loadingIndicator.stopAnimating()
				}
			}
		case .monthHoroscope:
			horoscopeRepository.getHoroscopeData(
				endpoint: endpoint,
				sign: userBirthdatePicker.date.zodiacSign,
				timeInterval: segementedVariants[typeOfTimeIntervalSegmented.selectedSegmentIndex]
			) { (result: Result<HoroscopeDataContainer<MonthHoroscopePrediction>,Error>) -> Void in
				DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
					switch result {
					case let .success(data):
						self.personalValueLabel.text = data.data.prediction.personal
						self.professionValueLabel.text = data.data.prediction.profession
						self.emotionsValueLabel.text = data.data.prediction.emotions
						self.travelValueLabel.text = data.data.prediction.travel
						let luckString: String = data.data.prediction.luck.reduce(String(), { result, tempString in
							result.appending(tempString + "\n\n")
						})
						self.luckValueLabel.text = luckString
						self.state = .content
					case .failure:
						self.showAlertButtonTapped()
					}
					self.loadingIndicator.stopAnimating()
				}
			}
		case .yearlyHoroscope:
			horoscopeRepository.getHoroscopeData(
				endpoint: endpoint,
				sign: userBirthdatePicker.date.zodiacSign,
				timeInterval: segementedVariants[typeOfTimeIntervalSegmented.selectedSegmentIndex]
			) { (result: Result<HoroscopeDataContainer<YearlyHoroscopePrediction>,Error>) -> Void in
				DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
					switch result {
					case let .success(data):
						self.personalValueLabel.text = data.data.prediction.personal
						self.professionValueLabel.text = data.data.prediction.profession
						self.emotionsValueLabel.text = data.data.prediction.emotions
						self.travelValueLabel.text = data.data.prediction.travel
						let luckString: String = data.data.prediction.luck.reduce(String(), { result, tempString in
							result.appending(tempString + "\n\n")
						})
						self.luckValueLabel.text = luckString
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


		(nameLabels + valueLabels).forEach {
			$0.numberOfLines = 0
			$0.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview($0)
		}

		nameLabels.forEach {
			$0.textColor = .purple
            $0.numberOfLines = 1
			$0.font = UIFont.boldSystemFont(ofSize: 20)
			$0.textAlignment = .left
		}

		valueLabels.forEach {
			$0.textColor = .purple
			$0.textAlignment = .right
		}
		personalNameLabel.text = "Personal:"
		professionNameLabel.text = "Profession:"
		emotionsNameLabel.text = "Emotions:"
		travelNameLabel.text = "Travel:"
		luckNameLabel.text = "Luck:"

		NSLayoutConstraint.activate(
			[
				personalNameLabel.topAnchor.constraint(
					equalTo: contentView.topAnchor,
					constant: Constants.topOffset
				),
				personalNameLabel.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor,
					constant: Constants.leadingOffset
				),
				personalNameLabel.widthAnchor.constraint(
					greaterThanOrEqualTo: contentView.widthAnchor,
					multiplier: 0.25
				),
				personalValueLabel.topAnchor.constraint(
					equalTo: personalNameLabel.topAnchor
				),
				personalValueLabel.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor,
					constant: -Constants.trailingOffset
				),
				personalValueLabel.widthAnchor.constraint(
					greaterThanOrEqualTo: contentView.widthAnchor,
					multiplier: 0.1
				),
				personalValueLabel.leadingAnchor.constraint(
					equalTo: personalNameLabel.trailingAnchor,
					constant: Constants.minimumLabelOffset
				)
			]
		)

		NSLayoutConstraint.activate(
			[
				professionNameLabel.topAnchor.constraint(
					equalTo: personalValueLabel.bottomAnchor,
					constant: Constants.topOffset
				),
				professionNameLabel.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor,
					constant: Constants.leadingOffset
				),
				professionNameLabel.widthAnchor.constraint(
					greaterThanOrEqualTo: contentView.widthAnchor,
					multiplier: 0.25
				),
				professionValueLabel.topAnchor.constraint(
					equalTo: professionNameLabel.topAnchor
				),
				professionValueLabel.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor,
					constant: -Constants.trailingOffset
				),
				professionValueLabel.widthAnchor.constraint(
					greaterThanOrEqualTo: contentView.widthAnchor,
					multiplier: 0.1
				),
				professionValueLabel.leadingAnchor.constraint(
					equalTo: professionNameLabel.trailingAnchor,
					constant: Constants.minimumLabelOffset
				)
			]
		)

		NSLayoutConstraint.activate(
			[
				emotionsNameLabel.topAnchor.constraint(
					equalTo: professionValueLabel.bottomAnchor,
					constant: Constants.topOffset
				),
				emotionsNameLabel.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor,
					constant: Constants.leadingOffset
				),
				emotionsNameLabel.widthAnchor.constraint(
					greaterThanOrEqualTo: contentView.widthAnchor,
					multiplier: 0.25
				),
				emotionsValueLabel.topAnchor.constraint(
					equalTo: emotionsNameLabel.topAnchor
				),
				emotionsValueLabel.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor,
					constant: -Constants.trailingOffset
				),
				emotionsValueLabel.widthAnchor.constraint(
					greaterThanOrEqualTo: contentView.widthAnchor,
					multiplier: 0.1
				),
				emotionsValueLabel.leadingAnchor.constraint(
					equalTo: emotionsNameLabel.trailingAnchor,
					constant: Constants.minimumLabelOffset
				)
			]
		)

		NSLayoutConstraint.activate(
			[
				travelNameLabel.topAnchor.constraint(
					equalTo: emotionsValueLabel.bottomAnchor,
					constant: Constants.topOffset
				),
				travelNameLabel.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor,
					constant: Constants.leadingOffset
				),
				travelNameLabel.widthAnchor.constraint(
					greaterThanOrEqualTo: contentView.widthAnchor,
					multiplier: 0.25
				),
				travelValueLabel.topAnchor.constraint(
					equalTo: travelNameLabel.topAnchor
				),
				travelValueLabel.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor,
					constant: -Constants.trailingOffset
				),
				travelValueLabel.widthAnchor.constraint(
					greaterThanOrEqualTo: contentView.widthAnchor,
					multiplier: 0.1
				),
				travelValueLabel.leadingAnchor.constraint(
					equalTo: travelNameLabel.trailingAnchor,
					constant: Constants.minimumLabelOffset
				)
			]
		)

		NSLayoutConstraint.activate(
			[
				luckNameLabel.topAnchor.constraint(
					equalTo: travelValueLabel.bottomAnchor,
					constant: Constants.topOffset
				),
				luckNameLabel.leadingAnchor.constraint(
					equalTo: contentView.leadingAnchor,
					constant: Constants.leadingOffset
				),
				luckNameLabel.widthAnchor.constraint(
					greaterThanOrEqualTo: contentView.widthAnchor,
					multiplier: 0.25
				),
				luckValueLabel.topAnchor.constraint(
					equalTo: luckNameLabel.topAnchor
				),
				luckValueLabel.trailingAnchor.constraint(
					equalTo: contentView.trailingAnchor,
					constant: -Constants.trailingOffset
				),
				luckValueLabel.widthAnchor.constraint(
					greaterThanOrEqualTo: contentView.widthAnchor,
					multiplier: 0.1
				),
				luckValueLabel.leadingAnchor.constraint(
					equalTo: luckNameLabel.trailingAnchor,
					constant: Constants.minimumLabelOffset
				),
				luckValueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20)
			]
		)
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

private extension HoroscopeViewController {
	enum Constants {
		static let topOffset: CGFloat = 24
		static let leadingOffset: CGFloat = 16
		static let trailingOffset: CGFloat = 16
		static let minimumLabelOffset: CGFloat = 20
		static let bottomOffset: CGFloat = 12
		static let topPicker: CGFloat = 70
	}
}
