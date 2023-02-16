//
//  HomeLifeStyleVC.swift
//  Pods
//
//  Created by Ahmad Syauqi Albana on 04/10/22.
//  
//

import UIKit
import PrivyPassCore

public class HomeLifeStyleVC: UIViewController, BaseViewProtocol {
    
    private lazy var layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private lazy var refreshControl: UIRefreshControl = UIRefreshControl()
    
    var presenter: HomeLifeStyleViewToPresenterProtocol?
    private var isLoadingHomeLifeStyleSection: Bool = false
    private var isEmptyHomeLifeStyle: Bool = false
    
    private var isLoadingPerks: Bool = false
    private var isEmptyPerks: Bool = false
    
    private var isLoadingOffer: Bool = false
    private var isEmptyOffer: Bool = false
    
    private var isLoadingMarketplaceCategory: Bool = false
    private var isEmptyMarketplaceCategory: Bool = false
    private var isLoadingMarketplace: Bool = false
    private var isEmptyMarketplace: Bool = false
    private var selectedMarketplaceCategoryId: String = ""
    private var selectedIndexFilter: Int = 0
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavBar(title: "Privylege", insetPadding: .zero, withShadow: false)
        navigationItem.backButtonTitle = ""
        
        eventFunction(className: "HomeLifeStyleVC", functionName: "viewWillAppear")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadHomeLifeStyleSection()
        
        eventFunction(className: "HomeLifeStyleVC", functionName: "viewDidLoad")
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        collectionView.backgroundColor = ColorCore.light10
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        collectionView.register(WrapperPerksParentCell.self, forCellWithReuseIdentifier: WrapperPerksParentCell.identifier)
        collectionView.register(OfferParentCell.self, forCellWithReuseIdentifier: OfferParentCell.identifier)
        collectionView.register(MerchantExpoParentCell.self, forCellWithReuseIdentifier: MerchantExpoParentCell.identifier)
        collectionView.register(HealthCareViewController.self, forCellWithReuseIdentifier: HealthCareViewController.identifier)
        collectionView.register(HomeLifeStyleEmptyStateCell.self, forCellWithReuseIdentifier: HomeLifeStyleEmptyStateCell.identifier)
        collectionView.register(ErrorStateCollectionViewCell.self, forCellWithReuseIdentifier: ErrorStateCollectionViewCell.identifier)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: UICollectionViewCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.setConstraintEqualToSuperview(topTo: view.safeAreaLayoutGuide.topAnchor)
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    @objc func refreshData(_ sender: AnyObject) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            guard let self = self else { return }
            self.loadHomeLifeStyleSection()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func handleErrorState() {
        let isfirstLoadSucceed: Bool = (presenter?.isFirstLoad).ifNil(false)
        collectionView.reloadData()
        if isfirstLoadSucceed {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
                self?.presenter?.showNetworkFailedModal()
            }
        }
    }
    
    enum SectionType: String {
        case reward = "reward"
        case offer = "offer"
        case merchantExpo = "merchant_expo"
        case marketplace = "marketplace"
        case healthCare = "health_care"
    }
}

extension HomeLifeStyleVC {
    private func loadHomeLifeStyleSection() {
        presenter?.getHomeLifeStyleSection()
    }
    
    private func loadData() {
        presenter?.getPerksList()
        presenter?.getOfferList()
        presenter?.getMarketplaceCategory()
    }
}

extension HomeLifeStyleVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard !isLoadingHomeLifeStyleSection else {
            return 3
        }
        let isfirstLoadSucceed: Bool = (presenter?.isFirstLoad).ifNil(false)
        if let networkState = presenter?.networkState, networkState != .success, !isfirstLoadSucceed {
            return 1
        }
        let data = presenter?.homepageLifeStyleSection?.data
        return (data?.count).ifNil(0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isfirstLoadSucceed: Bool = (presenter?.isFirstLoad).ifNil(false)
        if (isLoadingHomeLifeStyleSection || isEmptyHomeLifeStyle || presenter?.networkState != .success), !isfirstLoadSucceed {
            return 1
        }
        let data = presenter?.homepageLifeStyleSection?.data?[safe: section]
        return (data?.visible).ifNil(false) ? 1 : 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isfirstLoadSucceed: Bool = (presenter?.isFirstLoad).ifNil(false)
        if isLoadingHomeLifeStyleSection, !isfirstLoadSucceed {
            return generateHomeLifeStyleSectionLoadingCell(collectionView, indexPath: indexPath)
        } else if let networkState = presenter?.networkState, isEmptyHomeLifeStyle, networkState != .success, !isfirstLoadSucceed  {
            let generalCell: UICollectionViewCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: UICollectionViewCell.identifier, for: indexPath
            )
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ErrorStateCollectionViewCell.identifier,
                for: indexPath) as? ErrorStateCollectionViewCell else { return generalCell }
            cell.setupState(networkState: networkState)
            return cell
        } else {
            let data = presenter?.homepageLifeStyleSection?.data?[safe: indexPath.section]
            let type = (data?.type).ifNil("").lowercased()
            return generateSectionCell(
                collectionView,
                indexPath: indexPath,
                type: type,
                homepageLifeStyleSectionData: data
            )
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isLoadingHomeLifeStyleSection {
            return generateHomeLifeStyleSectionLoadingSize(collectionView, layout: layout, indexPath: indexPath)
        } else if let networkState = presenter?.networkState, isEmptyHomeLifeStyle, networkState != .success {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height - 32)
        } else {
            let data = presenter?.homepageLifeStyleSection?.data?[safe: indexPath.section]
            let type = (data?.type).ifNil("").lowercased()
            return generateSectionSize(
                collectionView,
                layout: layout,
                indexPath: indexPath,
                type: type
            )
        }
    }
    
    private func generateHomeLifeStyleSectionLoadingCell(_ collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            return generateSectionCell(
                collectionView,
                indexPath: indexPath,
                type: SectionType.reward.rawValue,
                homepageLifeStyleSectionData: nil
            )
        case 1:
            return generateSectionCell(
                collectionView,
                indexPath: indexPath,
                type: SectionType.offer.rawValue,
                homepageLifeStyleSectionData: nil
            )
        default:
            return generateSectionCell(
                collectionView,
                indexPath: indexPath,
                type: SectionType.merchantExpo.rawValue,
                homepageLifeStyleSectionData: nil
            )
        }
    }
    
    private func generateHomeLifeStyleSectionLoadingSize(_ collectionView: UICollectionView, layout: UICollectionViewLayout, indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return generateSectionSize(
                collectionView,
                layout: layout,
                indexPath: indexPath,
                type: SectionType.reward.rawValue
            )
        case 1:
            return generateSectionSize(
                collectionView,
                layout: layout,
                indexPath: indexPath,
                type: SectionType.offer.rawValue
            )
        default:
            return generateSectionSize(
                collectionView,
                layout: layout,
                indexPath: indexPath,
                type: SectionType.merchantExpo.rawValue
            )
        }
    }
    
    private func generateSectionCell( _ collectionView: UICollectionView, indexPath: IndexPath, type: String, homepageLifeStyleSectionData: HomeLifeStyleSectionDataModel?) -> UICollectionViewCell {
        guard let sectionType = SectionType(rawValue: type) else {
            return generalUICollectionViewCell(collectionView, cellForItemAt: indexPath)
        }
        switch sectionType {
        case .reward:
            guard !isEmptyPerks else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeLifeStyleEmptyStateCell.identifier,
                    for: indexPath) as? HomeLifeStyleEmptyStateCell else {
                    return generalUICollectionViewCell(collectionView, cellForItemAt: indexPath)
                }
                cell.bindData(
                    title: (homepageLifeStyleSectionData?.title).ifNil(""),
                    desc: L10n.subtitleEmptyPerks,
                    image: BundleAssetLifeStyle.ill_empty_reward
                )
                return cell
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WrapperPerksParentCell.identifier, for: indexPath) as? WrapperPerksParentCell else {
                return generalUICollectionViewCell(collectionView, cellForItemAt: indexPath)
            }
            cell.isLoading = isLoadingHomeLifeStyleSection || isLoadingPerks
            cell.data = presenter?.perksList
            cell.homepageLifeStyleSectionData = homepageLifeStyleSectionData
            cell.onTapMore = { [weak self] in
                guard let self = self, let _ = self.presenter?.perksList else { return }
                eventFunction(className: "HomeLifeStyleVC", functionName: "onTapMorePerks")
                self.presenter?.goToPerksList(titlePage: (homepageLifeStyleSectionData?.title).ifNil(""))
            }
            cell.onTapDetail = { [weak self] perksId in
                guard let self = self else { return }
                eventFunction(className: "HomeLifeStyleVC", functionName: "onTapDetailPerks", parameters: ["perks_id": perksId])
                self.presenter?.goToPerksDetail(titlePage: (homepageLifeStyleSectionData?.title).ifNil(""), perksId: perksId)
            }
            return cell
        case .offer:
            guard !isEmptyOffer else {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeLifeStyleEmptyStateCell.identifier,
                    for: indexPath) as? HomeLifeStyleEmptyStateCell else {
                    return generalUICollectionViewCell(collectionView, cellForItemAt: indexPath)
                }
                cell.bindData(
                    title: (homepageLifeStyleSectionData?.title).ifNil(""),
                    desc: L10n.subtitleEmptyOffer,
                    image: BundleAssetLifeStyle.ill_empty_offer
                )
                return cell
            }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OfferParentCell.identifier, for: indexPath) as? OfferParentCell else {
                return generalUICollectionViewCell(collectionView, cellForItemAt: indexPath)
            }
            cell.isLoading = isLoadingHomeLifeStyleSection || isLoadingOffer
            cell.data = presenter?.offerList
            cell.homepageLifeStyleSectionData = homepageLifeStyleSectionData
            cell.onTapMore = { [weak self] in
                guard let self = self, let _ = self.presenter?.offerList else { return }
                eventFunction(className: "HomeLifeStyleVC", functionName: "onTapMoreOffer", parameters: [:])
                self.presenter?.goToOfferList(titlePage: (homepageLifeStyleSectionData?.title).ifNil(""))
            }
            cell.onTapDetail = { [weak self] offerId, idx in
                guard let self = self, let dt = self.presenter?.offerList?.data?[safe: idx] else { return }
                eventFunction(className: "HomeLifeStyleVC", functionName: "onTapDetailOffer", parameters: ["offer_id": offerId])
                self.presenter?.goToOfferDetail(titlePage: (homepageLifeStyleSectionData?.title).ifNil(""), offerId: offerId, offerDataModel: dt)
            }
            return cell
        case .merchantExpo, .marketplace:
            if !isLoadingHomeLifeStyleSection, isEmptyMarketplaceCategory {
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeLifeStyleEmptyStateCell.identifier,
                    for: indexPath) as? HomeLifeStyleEmptyStateCell else {
                    return generalUICollectionViewCell(collectionView, cellForItemAt: indexPath)
                }
                cell.bindData(
                    title: (homepageLifeStyleSectionData?.title).ifNil(""),
                    desc: L10n.subtitleEmptyMarketplace,
                    image: BundleAssetLifeStyle.ill_empty_marketplace
                )
                return cell
            }
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MerchantExpoParentCell.identifier, for: indexPath) as? MerchantExpoParentCell else {
                return generalUICollectionViewCell(collectionView, cellForItemAt: indexPath)
            }
            cell.isLoadingCategory = isLoadingHomeLifeStyleSection || isLoadingMarketplaceCategory
            cell.isLoading = isLoadingHomeLifeStyleSection || isLoadingMarketplace
            cell.homepageLifeStyleSectionData = homepageLifeStyleSectionData
            cell.isEmptyMarketplace = isEmptyMarketplace
            cell.data = presenter?.marketplaceList
            cell.selectedIndex = selectedIndexFilter
            cell.dataCategory = presenter?.marketplaceCategory
            cell.onTapFilter = { [weak self] (selectedIndex, categoryId) in
                guard let self = self, self.selectedMarketplaceCategoryId != categoryId else { return }
                eventFunction(className: "HomeLifeStyleVC", functionName: "onTapFilterMarketplace", parameters: ["category_id": categoryId])
                self.selectedIndexFilter = selectedIndex
                self.selectedMarketplaceCategoryId = categoryId
                self.presenter?.getMarketplaceList(categoryId: self.selectedMarketplaceCategoryId)
            }
            cell.onTapMore = { [weak self] in
                guard let self = self, let _ = self.presenter?.marketplaceCategory else { return }
                eventFunction(className: "HomeLifeStyleVC", functionName: "onTapMoreMarketplace", parameters: [:])
                self.presenter?.goToMarketplaceList(titlePage: (homepageLifeStyleSectionData?.title).ifNil(""))
            }
            cell.onTapDetail = { [weak self] marketplaceId in
                guard let self = self else { return }
                eventFunction(className: "HomeLifeStyleVC", functionName: "onTapDetailMarketplace", parameters: ["marketplace_id": marketplaceId])
                self.presenter?.goToMarketplaceDetail(titlePage: (homepageLifeStyleSectionData?.title).ifNil(""), marketplaceId: marketplaceId)
            }
            return cell
        case .healthCare:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HealthCareViewController.identifier, for: indexPath) as? HealthCareViewController else {
                return generalUICollectionViewCell(collectionView, cellForItemAt: indexPath)
            }
            cell.homepageLifeStyleSectionData = homepageLifeStyleSectionData
            cell.onTap = {
                eventFunction(className: "HomeLifeStyleVC", functionName: "onTapHeathCare", parameters: [:])
            }
            return cell
        }
    }
    
    private func generateSectionSize(
        _ collectionView: UICollectionView,
        layout: UICollectionViewLayout,
        indexPath: IndexPath,
        type: String
    ) -> CGSize {
        guard let sectionType = SectionType(rawValue: type) else {
            return .zero
        }
        switch sectionType {
        case .reward:
            if isEmptyPerks {
                let height = L10n.subtitleEmptyPerks.height(withConstrainedWidth: collectionView.bounds.width - 72, font: Font.regular.normal) + 256
                return CGSize(width: collectionView.bounds.width, height: height)
            }
            guard let total = presenter?.perksList?.meta?.total, total > 1 else {
                return CGSize(width: collectionView.bounds.width, height: 240)
            }
            return CGSize(width: collectionView.bounds.width, height: 240)
        case .offer:
            if isEmptyOffer {
                let height = L10n.subtitleEmptyOffer.height(withConstrainedWidth: collectionView.bounds.width - 72, font: Font.regular.normal) + 256
                return CGSize(width: collectionView.bounds.width, height: height)
            }
            guard let total = presenter?.perksList?.meta?.total, total > 1 else {
                return CGSize(width: collectionView.bounds.width, height: 340)
            }
            return CGSize(width: collectionView.bounds.width, height: 340)
        case .merchantExpo, .marketplace:
            if isEmptyMarketplaceCategory {
                let height = L10n.subtitleEmptyMarketplace.height(withConstrainedWidth: collectionView.bounds.width - 72, font: Font.regular.normal) + 256
                return CGSize(width: collectionView.bounds.width, height: height)
            }
            if isEmptyMarketplace {
                let height = L10n.subtitleEmptyMarketplace.height(withConstrainedWidth: collectionView.bounds.width - 72, font: Font.regular.normal) + 256 + 158
                return CGSize(width: collectionView.bounds.width, height: height)
            }
            return CGSize(width: collectionView.bounds.width, height: 472)
        case .healthCare:
            return CGSize(width: collectionView.bounds.width, height: 150)
        }
    }
    
}

extension HomeLifeStyleVC: HomeLifeStylePresenterToViewProtocol {
    
    func showLoadingHomeLifeStyleSection() {
        isLoadingHomeLifeStyleSection = true
        collectionView.reloadData()
    }
    
    func hideLoadingHomeLifeStyle() {
        isLoadingHomeLifeStyleSection = false
        collectionView.reloadData()
    }
    
    func getHomeLifeStyleSectionSuccess() {
        isEmptyHomeLifeStyle = (presenter?.homepageLifeStyleSection?.data?.count).ifNil(0) == 0
        if !isEmptyHomeLifeStyle {
            loadData()
        } else {
            isEmptyHomeLifeStyle = true
            collectionView.reloadData()
        }
    }
    
    func getHomeLifeStyleSectionFailed(message: String) {
        handleErrorState()
        isEmptyHomeLifeStyle = true
        collectionView.reloadData()
    }
    
    func showLoadingOffer() {
        isLoadingOffer = true
        collectionView.reloadData()
    }
    
    func hideLoadingOffer() {
        isLoadingOffer = false
        collectionView.reloadData()
    }
    
    func getOfferSuccess() {
        isEmptyOffer = false
        collectionView.reloadData()
    }
    
    func getOfferFailed(message: String) {
        isEmptyOffer = true
        collectionView.reloadData()
    }
    
    func showLoadingMerchantCategory() {
        isLoadingMarketplaceCategory = true
        collectionView.reloadData()
    }
    
    func hideLoadingMerchantCategory() {
        isLoadingMarketplaceCategory = false
        collectionView.reloadData()
    }
    
    func getMerchantCategorySuccess() {
        isEmptyMarketplaceCategory = (presenter?.marketplaceCategory?.data?.count).ifNil(0) == 0
        if !isEmptyMarketplaceCategory {
            presenter?.getMarketplaceList(categoryId: selectedMarketplaceCategoryId)
        }
        collectionView.reloadData()
    }
    
    func getMerchantCategoryFailed(message: String) {
        // TODO: handle when failed
        isEmptyMarketplaceCategory = true
        collectionView.reloadData()
    }
    
    func showLoadingMerchant() {
        isLoadingMarketplace = true
        collectionView.reloadData()
    }
    
    func hideLoadingMerchant() {
        isLoadingMarketplace = false
        collectionView.reloadData()
    }
    
    func getMerchantSuccess() {
        isEmptyMarketplace = (presenter?.marketplaceList?.data?.count).ifNil(0) == 0
        collectionView.reloadData()
    }
    
    func getMerchantFailed(message: String) {
        // TODO: handle when failed
        isEmptyMarketplace = true
        collectionView.reloadData()
    }
    
    func showLoadingPerks() {
        isLoadingPerks = true
        collectionView.reloadData()
    }
    
    func hideLoadingPerks() {
        isLoadingPerks = false
        collectionView.reloadData()
    }
    
    func getPerksListSuccess() {
        isEmptyPerks = (presenter?.perksList?.data?.count).ifNil(0) == 0
        collectionView.reloadData()
    }
    
    func getPerksListFailed(message: String) {
        isEmptyPerks = true
        handleErrorState()
        collectionView.reloadData()
    }
}
