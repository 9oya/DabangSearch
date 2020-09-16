//
//  HomeInteractor.swift
//  DabangSearch
//
//  Created by 9oya on 11/09/2020.
//  Copyright © 2020 Dymm. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeInteractor: HomeInteractorInput {
    
    let disposeBag = DisposeBag()
    weak var output: HomeInteractorOutput!
    
    // MARK: Private
    private let roomService = RoomService(coreDataStack: AverageService.shared.coreDataStack)
    private var fetchRooms: (() -> [Room])?
    
    private func numberOfHashTags(indexPath: IndexPath) -> Int {
        return roomAt!(indexPath)!.hashTags!.allObjects.count
    }
    
    private func hashTagAt(room: Room, indexPath: IndexPath) -> HashTag {
        return room.hashTags!.allObjects[indexPath.item] as! HashTag
    }
    
    private func configureTagCollectionCell(room: Room, cell: TagCollectionCell, indexPath: IndexPath) {
        let hashTag = hashTagAt(room: room, indexPath: indexPath)
        cell.tagLabel.text = hashTag.title
    }
    
    // MARK: HomeInteractorInput
    func importRoomsIfNeeded() {
        Observable.just(self.roomService.getRooms(fetchStart: 0, fetchSize: 11))
            .subscribe(onNext: { (rooms) in
                if rooms?.isEmpty ?? true {
                    FileService.shared.importRoomsJSONSeedData {
                        self.importRoomsIfNeeded()
                    }
                } else {
                    self.fetchRooms = {
                        return rooms!
                    }
                    self.numberOfRooms = {
                        return rooms!.count + 1
                    }
                    self.roomAt = { indexPath in
                        return rooms![indexPath.row]
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func loadRooms(keyword: String? = nil, fetchStart: Int, fetchSize: Int) {
        _ = Observable<[Room]>
            .create({ (observer) in
                observer.onNext(
                    self.roomService.getRooms(
                        roomTypes: FilterService.shared.getRoomTypeFilterCodes(),
                        sellTypes: FilterService.shared.getSellTypeFilterCodes(),
                        isPriceSortAscended: FilterService.shared.getSelectedPriceTypeFilter().code == 0 ? true : false,
                        keyword: keyword,
                        fetchStart: fetchStart,
                        fetchSize: fetchSize)!
                )
                observer.onCompleted()
                return Disposables.create { }
            })
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (rooms) in
                var oldRooms = [Room]()
                if fetchStart > 0 {
                    oldRooms = self.fetchRooms!()
                }
                self.fetchRooms = {
                    return oldRooms + rooms
                }
                self.numberOfRooms = {
                    return (oldRooms + rooms).count + 1
                }
                self.roomAt = { indexPath in
                    return (oldRooms + rooms)[indexPath.row]
                }
            }, onCompleted: {
                if fetchStart == 0 {
                    self.output.scrollToTopTableView()
                }
                self.output.reloadRoomTableView()
            }).disposed(by: disposeBag)
    }
    
    var numberOfRooms: (() -> Int)?
    
    var roomAt: ((_ indexPath: IndexPath) -> Room?)?
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRoomTypeFilters() -> Int {
        return FilterService.shared.getRoomTypes().count
    }
    
    func numberOfSellTypeFilters() -> Int {
        return FilterService.shared.getSellTypes().count
    }
    
    func numberOfPriceFilters() -> Int {
        return 1
    }
    
    func roomTypeFilterAt(indexPath: IndexPath) -> FilterModel {
        return FilterService.shared.getRoomTypes()[indexPath.row]
    }
    
    func sellTypeFilterAt(indexPath: IndexPath) -> FilterModel {
        return FilterService.shared.getSellTypes()[indexPath.row]
    }
    
    func getSelectedPriceTypeFilter() -> FilterModel {
        return FilterService.shared.getSelectedPriceTypeFilter()
    }
    
    func didSelectRoomTypeCollectionView(indexPath: IndexPath) {
        FilterService.shared.toggleRoomTypeFilter(indexPath: indexPath)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.output.reloadRoomCollectionView()
            }, onCompleted: {
                self.loadRooms(fetchStart: 0, fetchSize: 11)
            }).disposed(by: disposeBag)
    }
    
    func didSelectSellTypeCollectionView(indexPath: IndexPath) {
        FilterService.shared.toggleSellTypeFilter(indexPath: indexPath)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.output.reloadSellCollectionView()
            }, onCompleted: {
                self.loadRooms(fetchStart: 0, fetchSize: 11)
            }).disposed(by: disposeBag)
    }
    
    func didSelectPriceTypeCollectionView() {
        FilterService.shared.togglePriceFilter()
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { _ in
                self.output.reloadPriceCollectionView()
                self.loadRooms(fetchStart: 0, fetchSize: 11)
            }).disposed(by: disposeBag)
    }
    
    func configureFilterCollectionCell(cell: FilterCollectionCell, indexPath: IndexPath, getFilterAt: (_ indexPath: IndexPath) -> FilterModel) {
        let filterModel = getFilterAt(indexPath)
        
        if filterModel.title == "내림차순" || !filterModel.isSelected {
            cell.titleContainer.backgroundColor = .systemBackground
            cell.titleContainer.layer.borderColor = UIColor.systemGray6.cgColor
            cell.titleContainer.layer.borderWidth = 1.0
            cell.titleLabel.textColor = .label
        } else {
            cell.titleContainer.backgroundColor = .systemBlue
            cell.titleContainer.layer.borderColor = UIColor.clear.cgColor
            cell.titleContainer.layer.borderWidth = 0
            cell.titleLabel.textColor = .white
        }
        cell.titleLabel.text = filterModel.title
    }
    
    func getRoomTableCellHeight(indexPath: IndexPath) -> CGFloat {
        if (numberOfRooms!() > 12 && (indexPath.row + 1) == 12) || (numberOfRooms!() <= 12 && numberOfRooms!() == (indexPath.row + 1)) {
            return 80
        } else {
            return 115
        }
    }
    
    func configureRoomTableCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if (numberOfRooms!() > 12 && (indexPath.row + 1) == 12) || (numberOfRooms!() <= 12 && numberOfRooms!() == (indexPath.row + 1)) {
            let average = AverageService.shared.getAverage()!
            let cell = tableView.dequeueReusableCell(withIdentifier: avgTableCellId, for: indexPath) as! AvgTableCell
            cell.titleLabel.text = "평균 매물가"
            cell.avgMonthGuideLabel.text = "평균월세"
            cell.avgYearGuideLabel.text = "평균전세"
            cell.addressLabel.text = average.name
            cell.avgMonthPriceLabel.text = average.monthPrice
            cell.avgYearPriceLabel.text = average.yearPrice
            return cell
        }
        
        var customIdxPath = indexPath
        if indexPath.row > 11 {
            customIdxPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        }
        let room = roomAt!(customIdxPath)!
        var cell: RoomTableCell
        switch RoomType(rawValue: room.roomType)! {
        case .oneRoom, .twoThreeRoom:
            cell = tableView.dequeueReusableCell(withIdentifier: roomRightTableCellId, for: indexPath) as! RoomRightTableCell
        case .officetel, .apartment:
            cell = tableView.dequeueReusableCell(withIdentifier: roomLeftTableCellId, for: indexPath) as! RoomLeftTableCell
        }
        
        cell.room = room
        cell.numberOfItemsInSection = numberOfHashTags(indexPath: customIdxPath)
        cell.configureTagCollectionCell = { room, cell, indexPath in
            self.configureTagCollectionCell(room: room, cell: cell, indexPath: indexPath)
        }
        cell.sizeForItem = { indexPath in
            return CGSize(
                width: CGFloat(self.hashTagAt(room: room, indexPath: indexPath).title!.count * 12),
                height: 20
            )
        }
        
        let roomType: String = APIHelper.shared.getRoomTypeTxt(roomType: RoomType(rawValue: room.roomType)!)
        let sellType: String = APIHelper.shared.getSellTypeTxt(sellType: SellType(rawValue: room.sellingType)!)
        let title: String = {
            return "\(sellType) \(APIHelper.shared.convertPriceToPriceTitle(price: room.price))"
        }()
        
        cell.titleLabel.text = title
        cell.roomTypeLabel.text = roomType
        cell.descLabel.text = room.desc!
        
        DispatchQueue.global().async {
            let url = URL(string: room.imgUrl!)
            var image: UIImage? = nil
            if url != nil {
                if let data = try? Data(contentsOf: url!) {
                    image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.roomImgView.image = image
                    }
                }
            }
        }
        
        var image: UIImage!
        let config = UIImage.SymbolConfiguration(pointSize: UIFont.systemFontSize, weight: .regular, scale: .medium)
        if room.isCheck {
            image = UIImage(systemName: "star.fill", withConfiguration: config)?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
        } else {
            image = UIImage(systemName: "star", withConfiguration: config)?.withTintColor(.systemGray4, renderingMode: .alwaysOriginal)
        }
        cell.bookmarkButton.setImage(image, for: .normal)
        
        return cell
    }
}
