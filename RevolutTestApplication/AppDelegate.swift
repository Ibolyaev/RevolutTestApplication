//
//  AppDelegate.swift
//  RevolutTestApplication
//
//  Created by Admin on 28/02/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // To init first controller embedded with model view, we need to do it from the router or any assembly class, just for demo purpose we use do it in app delegate
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CurrencyListViewController") as? CurrencyListViewController
        guard let currencyListVC = viewController else {
            fatalError("Failed to load CurrencyListViewController")
        }
        let dataProvider = CurrencyListDataProviderDefault(requestFactory: RequestFactory())
        let listViewModel = CurrencyListViewModel(dataProvider: dataProvider)
        currencyListVC.viewModel = listViewModel
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = currencyListVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

