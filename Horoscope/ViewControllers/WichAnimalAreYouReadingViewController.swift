//
//  WichAnimalAreYouReadingViewController.swift
//  Horoscope
//
//  Created by Polina Solovyova on 28.10.2022.
//

import UIKit
import SnapKit

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
		scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
		contentView.snp.makeConstraints {
			$0.top.bottom.width.equalToSuperview()
			$0.left.right.equalTo(view)
			$0.height.equalToSuperview().priority(250)
		}
	}
	
	func configureRequestView() {
		view.addSubview(dataRequestViewContainer)
		dataRequestViewContainer.addSubview(nameLabel)
		dataRequestViewContainer.addSubview(nameTextField)
		dataRequestViewContainer.addSubview(userBirthdateLabel)
		dataRequestViewContainer.addSubview(userBirthdatePicker)
		dataRequestViewContainer.addSubview(okButton)
		
		dataRequestViewContainer.snp.makeConstraints { $0.edges.equalToSuperview() }
		
		nameLabel.snp.makeConstraints {
			$0.top.equalTo(dataRequestViewContainer.safeAreaLayoutGuide).offset(Constants.edges.top)
			$0.leading.trailing.equalTo(Constants.edges)
			$0.height.equalTo(40)
		}
		nameTextField.snp.makeConstraints {
			$0.top.equalTo(nameLabel.snp.bottom).offset(20)
			$0.leading.trailing.equalTo(Constants.edges)
		}
		userBirthdateLabel.snp.makeConstraints {
			$0.top.equalTo(nameTextField.snp.bottom).offset(20)
			$0.leading.trailing.equalTo(Constants.edges)
			$0.height.equalTo(40)
		}
		userBirthdatePicker.snp.makeConstraints {
			$0.top.equalTo(userBirthdateLabel.snp.bottom).offset(Constants.edges.top)
			$0.leading.trailing.equalTo(Constants.edges)
		}
		okButton.snp.makeConstraints {
			$0.bottom.equalTo(dataRequestViewContainer.safeAreaLayoutGuide.snp.bottom).inset(Constants.edges.bottom)
			$0.leading.trailing.equalTo(Constants.edges)
			$0.height.equalTo(80)
		}
		
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
		let edges = UIEdgeInsets(
			top: Constants.topOffset,
			left: Constants.leadingOffset,
			bottom: Constants.bottomOffset,
			right: Constants.leadingOffset
		)
		animalLabel.numberOfLines = 0
		animalLabel.textColor = .purple
		animalLabel.textAlignment = .left
		animalLabel.font = UIFont.boldSystemFont(ofSize: 20)
		
		resultLabel.numberOfLines = 0
		resultLabel.textColor = .purple
		resultLabel.textAlignment = .left
		
		contentView.addSubview(animalLabel)
		contentView.addSubview(resultLabel)
		contentView.addSubview(imageOfAnAnimal)
		
		animalLabel.snp.makeConstraints {
			$0.top.equalToSuperview().inset(edges.top)
			$0.leading.trailing.equalTo(edges)
		}
		resultLabel.snp.makeConstraints {
			$0.top.equalTo(animalLabel.snp.bottom).offset(edges.top)
			$0.leading.trailing.equalTo(edges)
		}
		imageOfAnAnimal.snp.makeConstraints {
			$0.top.equalTo(resultLabel.snp.bottom).inset(edges.top)
			$0.leading.trailing.equalTo(edges)
			$0.height.equalTo(700)
			$0.bottom.equalTo(contentView.snp.bottom).offset(edges.bottom)
		}
		
	}
}

// MARK: - Constants

private extension WichAnimalAreYouReadingViewController {
	enum Constants {
		static let topOffset: CGFloat = 8
		static let leadingOffset: CGFloat = 16
		static let trailingOffset: CGFloat = 16
		static let bottomOffset: CGFloat = 8
		static let edges = UIEdgeInsets(
			top: topOffset,
			left: leadingOffset,
			bottom: bottomOffset,
			right: leadingOffset
		)
	}
}
