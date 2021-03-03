//
//  MemoListPresenter.swift
//  MemoCloneApp
//
//  Created by MUN JEONG SEO on 2021/02/08.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MemoListPresentationLogic {
    func presentMemoListSuccess(response: [MemoData]?) //MARK: 임시
    func presentMemoListFail()
    
    func presentDeleteSuccess()
    func presentDeleteFail()
    
    func presentChangeIsFixedSuccess(response: [MemoData]?)
    func presentChangeIsFixedFail()
}

class MemoListPresenter: MemoListPresentationLogic {
  weak var viewController: MemoListDisplayLogic?
  
  // MARK: Do something
  
    func presentMemoListSuccess(response: [MemoData]?) {
        let viewModel = response?.sorted(by: {
            $0.updatedDate ?? Date() < $1.updatedDate ?? Date()
        })
        
        viewController?.displayMemoListSuccess(viewModel: viewModel)
    }
    
    func presentMemoListFail() {
        viewController?.displayMemoListFail()
    }
    
    func presentDeleteSuccess() {
        viewController?.displayDeleteSuccess()
    }
    
    func presentDeleteFail() {
        viewController?.displayDeleteFail()
    }
    
    func presentChangeIsFixedSuccess(response: [MemoData]?) {
        viewController?.displayChangeIsFixedSuccess(viewModel: response)
    }
    
    func presentChangeIsFixedFail() {
        viewController?.displayChangeIsFixedFail()
    }
}
