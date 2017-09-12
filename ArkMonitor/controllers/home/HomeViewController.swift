//
//  HomeViewController.swift
//  ArkMonitor
//
//  Created by Andrew on 2017-09-11.
//  Copyright © 2017 vrlc92. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    fileprivate var account : Account = Account()
    fileprivate var delegate : Delegate = Delegate()
    fileprivate var forging : Forging = Forging()
    fileprivate var status : Status = Status()
    fileprivate var peerVersion : PeerVersion = PeerVersion()
    fileprivate var block : Block = Block()
    
    fileprivate var tableView      : ArkTableView!
    fileprivate var refreshControl : UIRefreshControl!
    
    private var balance         : Double?
    private var arkBTCValue     : Double?
    private var bitcoinUSDValue : Double?
    private var bitcoinEURValue : Double?
    
    private var settingsAcknowledged = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView          = UIImageView(image: #imageLiteral(resourceName: "whiteLogo"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "whiteGear"), style: .plain, target: self, action: #selector(settingsButtonTapped))
        
        tableView = ArkTableView(frame: CGRect.zero)
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = ArkColors.blue
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(homeUpdateNotificationRecieved), name: NSNotification.Name(rawValue: ArkNotifications.homeUpdated.rawValue), object: nil)
        getDataFromDataManager()
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        verifySettings()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func verifySettings() {
        guard settingsAcknowledged == false else {
            return
        }
        
        settingsAcknowledged = true
        let settings = Settings.getSettings()
        
        if settings.isValid() == false {
           settingsButtonTapped()
        }
    }
    
    @objc fileprivate func loadData() {
        ArkDataManager.shared.updateHomeInfo()
        
        delay(0.75) {
            self.refreshControl.endRefreshing()
        }
    }
    
    @objc private func settingsButtonTapped() {
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    @objc private func homeUpdateNotificationRecieved() {
        getDataFromDataManager()
    }
    
    private func getDataFromDataManager() {
        account         = ArkDataManager.Home.account
        delegate        = ArkDataManager.Home.delegate
        forging         = ArkDataManager.Home.forging
        status          = ArkDataManager.Home.status
        peerVersion     = ArkDataManager.Home.peerVersion
        block           = ArkDataManager.Home.block
        balance         = ArkDataManager.Home.balance
        arkBTCValue     = ArkDataManager.Home.arkBTCValue
        bitcoinUSDValue = ArkDataManager.Home.bitcoinUSDValue
        bitcoinEURValue = ArkDataManager.Home.bitcoinUSDValue
        tableView.reloadData()
    }
}


// MARK: UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let aCell = cell as? HomeDelegateTableViewCell {
            aCell.update(delegate)
        }
        
        if let aCell = cell as? HomeForgingTableViewCell {
            aCell.update(forging)
        }
        
        if let aCell = cell as? HomeLastBlockTableViewCell {
            aCell.update(block)
        }
        
        if let aCell = cell as? HomeBalanceTableViewCell {
            aCell.update(balance: balance, arkBTCValue: arkBTCValue, bitcoinUSDValue: bitcoinUSDValue, bitcoinEURValue: bitcoinEURValue)
        }
        
        if let aCell = cell as? HomeAddressTableViewCell {
            aCell.update(delegate)
        }
        
        if let aCell = cell as? HomeServerTableViewCell {
            aCell.update(status)
        }
        
        if let aCell = cell as? HomeVersionTableViewCell {
            aCell.update(peerVersion)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: _screenWidth, height: 40.0))
        headerView.backgroundColor = UIColor.white
        
        let headerLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: _screenWidth, height: 40.0))
        headerLabel.textColor = ArkColors.darkGray
        headerLabel.textAlignment = .center
        
        switch section {
        case 0:
            headerLabel.text = "Delegate"
        case 1:
            headerLabel.text = "Forging"
        case 2:
            headerLabel.text = "Account"
        default:
            headerLabel.text = "Server"
        }
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

// MARK: UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 5
            case 1:
                return 4
            case 2:
                return 5
            default:
                return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = HomeDelegateTableViewCell(indexPath.row)
            return cell
        case 1:
            if indexPath.row == 3 {
                let cell = HomeLastBlockTableViewCell(indexPath.row)
                return cell
            } else {
                let cell = HomeForgingTableViewCell(indexPath.row)
                return cell
            }
        case 2:
            if indexPath.row == 0 {
                let cell = HomeAddressTableViewCell(indexPath.row)
                return cell
            } else {
                let cell = HomeBalanceTableViewCell(indexPath.row)
                return cell
            }
        case 3:
            if indexPath.row == 2 {
                let cell = HomeVersionTableViewCell(indexPath.row)
                return cell
            } else {
                let cell = HomeServerTableViewCell(indexPath.row)
                return cell
            }
        default:
            let cell = UITableViewCell()
            return cell
        }
    }
}
