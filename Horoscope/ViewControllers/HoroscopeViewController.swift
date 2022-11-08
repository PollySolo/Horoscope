//
//  HoroscopeViewController.swift
//  Horoscope
//
//  Created by Polina Solovyova on 18.10.2022.
//

import UIKit
import SnapKit

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
		scrollView.backgroundColor = UIColor(red: 1.0, green: 0.82, blue: 1.0, alpha: 0.8)
		view.addSubview(scrollView)
		scrollView.addSubview(contentView)
		scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
		contentView.snp.makeConstraints {
			$0.top.bottom.width.equalToSuperview()
			$0.left.right.equalTo(view)
			$0.height.equalToSuperview().priority(250)
		}
	}

	func configureRequestView() {
		view.addSubview(dataRequestViewContainer)
		dataRequestViewContainer.addSubview(userBirthdateLabel)
		dataRequestViewContainer.addSubview(userBirthdatePicker)
		dataRequestViewContainer.addSubview(typeOfTimeIntervalLabel)
		dataRequestViewContainer.addSubview(typeOfTimeIntervalSegmented)
		dataRequestViewContainer.addSubview(okButton)
		
		let edges = UIEdgeInsets(
			top: Constants.topOffset,
			left: Constants.leadingOffset,
			bottom: Constants.bottomOffset,
			right: Constants.leadingOffset
		)
		
		dataRequestViewContainer.snp.makeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
		
		userBirthdateLabel.snp.makeConstraints {
			$0.top.leading.trailing.equalToSuperview().inset(edges)
			$0.height.equalTo(40)
		}
		userBirthdatePicker.snp.makeConstraints {
			$0.top.equalTo(userBirthdateLabel.snp.bottom).offset(12)
			$0.leading.trailing.equalTo(edges)
		}
		typeOfTimeIntervalLabel.snp.makeConstraints {
			$0.top.equalTo(userBirthdatePicker.snp.bottom).offset(edges.top)
			$0.leading.trailing.equalTo(edges)
		}
		typeOfTimeIntervalSegmented.snp.makeConstraints {
			$0.top.equalTo(typeOfTimeIntervalLabel.snp.bottom).offset(edges.top)
			$0.leading.trailing.equalTo(edges)
			$0.height.equalTo(40)
		}
		okButton.snp.makeConstraints {
			$0.bottom.equalTo(dataRequestViewContainer.safeAreaLayoutGuide).inset(edges)
			$0.leading.trailing.equalTo(edges)
			$0.height.equalTo(80)
		}

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
		
		let edges = UIEdgeInsets(
			top: Constants.topOffset,
			left: Constants.leadingOffset,
			bottom: 0,
			right: Constants.leadingOffset
		)
		
		personalNameLabel.snp.makeConstraints {
			$0.top.leading.equalToSuperview().inset(edges)
			$0.width.equalToSuperview().multipliedBy(0.25)
		}
		
		personalValueLabel.snp.makeConstraints {
			$0.top.equalTo(personalNameLabel)
			$0.trailing.equalToSuperview().inset(edges)
			$0.width.greaterThanOrEqualToSuperview().multipliedBy(0.1)
			$0.leading.equalTo(personalNameLabel.snp.trailing).offset(Constants.minimumLabelOffset)
		}
		
		professionNameLabel.snp.makeConstraints {
			$0.top.equalTo(personalValueLabel.snp.bottom).offset(edges.top)
			$0.leading.equalToSuperview().inset(edges)
			$0.width.equalToSuperview().multipliedBy(0.25)
		}
		
		professionValueLabel.snp.makeConstraints {
			$0.top.equalTo(professionNameLabel)
			$0.trailing.equalToSuperview().inset(edges)
			$0.width.greaterThanOrEqualToSuperview().multipliedBy(0.1)
			$0.leading.equalTo(professionNameLabel.snp.trailing).offset(Constants.minimumLabelOffset)
		}
		
		emotionsNameLabel.snp.makeConstraints {
			$0.top.equalTo(professionValueLabel.snp.bottom).offset(edges.top)
			$0.leading.equalToSuperview().inset(edges)
			$0.width.equalToSuperview().multipliedBy(0.25)
		}
		
		emotionsValueLabel.snp.makeConstraints {
			$0.top.equalTo(emotionsNameLabel)
			$0.trailing.equalToSuperview().inset(edges)
			$0.width.greaterThanOrEqualToSuperview().multipliedBy(0.1)
			$0.leading.equalTo(emotionsNameLabel.snp.trailing).offset(Constants.minimumLabelOffset)
		}
		
		travelNameLabel.snp.makeConstraints {
			$0.top.equalTo(emotionsValueLabel.snp.bottom).offset(edges.top)
			$0.leading.equalToSuperview().inset(edges)
			$0.width.equalToSuperview().multipliedBy(0.25)
		}
		
		travelValueLabel.snp.makeConstraints {
			$0.top.equalTo(travelNameLabel)
			$0.trailing.equalToSuperview().inset(edges)
			$0.width.greaterThanOrEqualToSuperview().multipliedBy(0.1)
			$0.leading.equalTo(travelNameLabel.snp.trailing).offset(Constants.minimumLabelOffset)
		}
		
		luckNameLabel.snp.makeConstraints {
			$0.top.equalTo(travelValueLabel.snp.bottom).offset(edges.top)
			$0.leading.equalToSuperview().inset(edges)
			$0.width.equalToSuperview().multipliedBy(0.25)
		}
		
		luckValueLabel.snp.makeConstraints {
			$0.top.equalTo(luckNameLabel)
			$0.trailing.equalToSuperview().inset(edges)
			$0.width.greaterThanOrEqualToSuperview().multipliedBy(0.1)
			$0.leading.equalTo(luckNameLabel.snp.trailing).offset(Constants.minimumLabelOffset)
			$0.bottom.equalToSuperview().inset(20)
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
