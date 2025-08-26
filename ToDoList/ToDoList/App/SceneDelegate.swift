//
//  SceneDelegate.swift
//  ToDoList
//
//  Created by Константин Шмондрик on 14.04.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.window?.overrideUserInterfaceStyle = .light

        let rootVC = MainScreenBuilder.build()

        let mainVC = MainScreenBuilder.build()

        let nav = UINavigationController(rootViewController: mainVC)
        nav.navigationBar.prefersLargeTitles = true
        nav.navigationBar.titleTextAttributes = [.foregroundColor: AppColor.white]
        nav.navigationBar.largeTitleTextAttributes = [.foregroundColor: AppColor.white]

        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

