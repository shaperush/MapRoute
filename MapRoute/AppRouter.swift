//
//  AppRouter.swift
//  MapRoute
//
//  Created by Dmitriy Zakharov on 21.04.2020.
//  Copyright © 2020 Dmitriy Zakharov. All rights reserved.
//

import Foundation
import UIKit

protocol AppRouterMainProtocol {
    
    var navigationController: UINavigationController? {get set}
    var appBuilder: AppBuilderProtocol? {get set}
}

protocol AppRouterProtocol {
    
    func popToRoot()
    func showRouteScreen(mainPresenter: MainPresenterProtocol)
    func initialViewController()
}

class AppRouter: AppRouterProtocol, AppRouterMainProtocol {
    
    var navigationController: UINavigationController?
    var appBuilder: AppBuilderProtocol?
    
    init(navigationController: UINavigationController, appBuilder: AppBuilderProtocol) {
        self.navigationController = navigationController
        self.appBuilder = appBuilder
    }
    
    func initialViewController() {
        if let navigationController = self.navigationController {
            guard let mainViewController = appBuilder?.createMainModule(router: self) else {return}
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func showRouteScreen(mainPresenter: MainPresenterProtocol) {
        if let navigationController = self.navigationController {
            guard let controller = appBuilder?.createRouteListModule(router: self, mainPresenter: mainPresenter) else  {
                return
            }
            navigationController.pushViewController(controller, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
}
