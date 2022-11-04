//
// 	PredictionsViewController.swift
//  Horoscope
//
//  Created by Polina Solovyova on 17.10.2022.
//

import UIKit

class PredictionsViewController: UIViewController {

	private typealias DiffableDataSource = UICollectionViewDiffableDataSource<MainSectionModel, HoroscopeEndpoint>

	private let horoscopeRepository: HoroscopeRepositoryProtocol = APIService()

	private lazy var dataSource: DiffableDataSource = .init(collectionView: collectionView) {
		(collectionView: UICollectionView, indexPath: IndexPath, identifier: HoroscopeEndpoint) -> UICollectionViewCell? in
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: HoroscopeItemCell.reuseIdentifier, for: indexPath
		) as? HoroscopeItemCell else {
			fatalError("Cannot create the cell")
		}
		cell.configure(with: identifier)
		return cell
	}

	private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

	private let layout: UICollectionViewCompositionalLayout = {
		let size: CGFloat = 300
		let leadingItem = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(0.6),
				heightDimension: .absolute(size)
			)
		)
		leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 70, leading: 20, bottom: 50, trailing: 5)

		let trailingItem = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(0.4),
				heightDimension: .absolute(size)
			)
		)
		trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 70, leading: 5, bottom: 50, trailing: 20)

		let bottomNestedGroup = NSCollectionLayoutGroup.horizontal(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(0.5)
			),
			subitems: [leadingItem, trailingItem])

		let topItem = NSCollectionLayoutItem(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(0.1)
			)
		)
		topItem.contentInsets = NSDirectionalEdgeInsets(top: 100, leading: 20, bottom: 70, trailing: 20)

		let nestedGroup = NSCollectionLayoutGroup.vertical(
			layoutSize: NSCollectionLayoutSize(
				widthDimension: .fractionalWidth(1.0),
				heightDimension: .fractionalHeight(0.4)
			),
			subitems: [bottomNestedGroup, topItem]
		)

		let section = NSCollectionLayoutSection(group: nestedGroup)
		section.interGroupSpacing = 10

		return UICollectionViewCompositionalLayout(section: section)
	}()

	override func loadView() {
		view = collectionView
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Predictions"
		view.backgroundColor = .white
		collectionView.backgroundColor = UIColor(red: 0.5, green: 0.3, blue: 0.5, alpha: 0.8)
		collectionView.delegate = self

		setupCollectionView()

		var snapshot = dataSource.snapshot()
		snapshot.appendSections([.main])
		snapshot.appendItems(HoroscopeEndpoint.allCases)
		dataSource.apply(snapshot, animatingDifferences: false)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.setNavigationBarHidden(true, animated: animated)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.setNavigationBarHidden(false, animated: animated)

	}
}

// MARK: - UICollectionViewDelegate

extension PredictionsViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let selectedHoroscope = dataSource.itemIdentifier(for: indexPath) else { return }
		switch selectedHoroscope {
		case .dailyHororsope, .weeklyHoroscope, .monthHoroscope, .yearlyHoroscope:
			let viewController = HoroscopeViewController(
				endpoint: selectedHoroscope,
				horoscopeRepository: horoscopeRepository
			)
			navigationController?.pushViewController(viewController, animated: true)
		case .fortuneCookie:
			navigationController?.pushViewController(
				FortuneCookieViewController(
					endpoint: selectedHoroscope,
					horoscopeRepository: horoscopeRepository
				), animated: true
			)
		case .whichAnimalAreYouReading:
			navigationController?.pushViewController(
				WichAnimalAreYouReadingViewController(
					endpoint: selectedHoroscope,
					horoscopeRepository: horoscopeRepository
				),
				animated: true
			)
		}
	}
}

// MARK: - Private

private extension PredictionsViewController {
	func setupCollectionView() {
		collectionView.dataSource = dataSource
		collectionView.register(
			HoroscopeItemCell.self,
			forCellWithReuseIdentifier: HoroscopeItemCell.reuseIdentifier
		)
	}
}
