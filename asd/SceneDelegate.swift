
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func navigateToRegistroController(notificacion: Notificacion) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let tabBarController = window?.rootViewController as? UITabBarController {
                
                tabBarController.selectedIndex = 2
                
                if let navController = tabBarController.viewControllers?[2] as? UINavigationController,
                   let historyVC = navController.viewControllers.first as? HistoryVC {
                    
                    historyVC.performSegue(withIdentifier: "segueNewActividad", sender: notificacion)
                }
            }
        }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

