//
//  MainRouter.swift
//  MemoCloneApp
//
//  Created by MUN JEONG SEO on 2021/02/22.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol MainRoutingLogic {
    func routeToMemoListPage()
}

protocol MainDataPassing {
    var dataStore: MainDataStore? { get }
}

class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {
    weak var viewController: MainViewController?
    var dataStore: MainDataStore?
    
    // MARK: Routing
    func routeToMemoListPage() {
        print("Memo List 페이지로 이동")
        
        let destinationVC = MemoListPage()
        
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
}
