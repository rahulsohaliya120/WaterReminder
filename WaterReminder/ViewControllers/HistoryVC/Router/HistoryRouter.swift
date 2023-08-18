//
//  HistoryRouter.swift
//  WaterReminder
//
//  Created by DREAMWORLD on 18/08/23.
//  
//

import Foundation
import UIKit

class HistoryRouter: PresenterToRouterHistoryProtocol {
    
    // MARK: Static methods
    static func createModule(vc: HistoryVC) {
        
        let presenter: ViewToPresenterHistoryProtocol & InteractorToPresenterHistoryProtocol = HistoryPresenter()
        
        vc.presenter = presenter
        vc.presenter?.router = HistoryRouter()
        vc.presenter?.view = vc
        vc.presenter?.interactor = HistoryInteractor()
        vc.presenter?.interactor?.presenter = presenter
    }
}
