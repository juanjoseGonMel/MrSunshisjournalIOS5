

import UIKit
import CoreData
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "cuyoscaredb")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    

    // Acceso al DataManager compartido
    //let dataManager = DataManager.shared


    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /* if let storeURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent("cuyoscaredb.sqlite") {
         do {
         try FileManager.default.removeItem(at: storeURL)
         print("Base de datos eliminada exitosamente.")
         } catch {
         print("Error al eliminar la base de datos: \(error)")
         }
         }*/
        ThemeManager.applyGlobalStyles()
        let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        print("✅ Permiso de notificaciones concedido.")
                    } else {
                        print("❌ Permiso de notificaciones denegado.")
                    }
                }
                center.delegate = self
        let context = persistentContainer.viewContext
        print("Core Data está configurado con contexto: \(context)")
        return true
    }
    
    
    
    
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    

    

}


extension AppDelegate: UNUserNotificationCenterDelegate {

        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            
            let userInfo = notification.request.content.userInfo
            if let notificacionID = userInfo["notificacion_id"] as? Int64 {
                do {
                    let notificacion = try NotificacionManager().fetchNotificacion(byID: notificacionID)
                    if let notificacion = notificacion {
                        showAlertInApp(notification.request.content.title, message: notification.request.content.body, notificacion: notificacion)
                    }
                } catch {
                    print("❌ Error al recuperar la notificación de Core Data: \(error.localizedDescription)")
                }
            }

            completionHandler([.banner, .sound])
        }

        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
            
            let userInfo = response.notification.request.content.userInfo
            if let notificacionID = userInfo["notificacion_id"] as? Int64 {
                do {
                    let notificacion = try NotificacionManager().fetchNotificacion(byID: notificacionID)
                    if let notificacion = notificacion {
                        let sceneDelegate = UIApplication.shared.connectedScenes
                            .first?.delegate as? SceneDelegate
                        sceneDelegate?.navigateToRegistroController(notificacion: notificacion)
                    }
                } catch {
                    print("❌ Error al recuperar la notificación desde Core Data.")
                }
            }
            completionHandler()
        }

   
}

extension AppDelegate{
    func showAlertInApp(_ title: String, message: String, notificacion: Notificacion) {
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = scene.windows.first,
               let rootVC = window.rootViewController as? UITabBarController {

                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

                let irARegistro = UIAlertAction(title: "Registrar Evento", style: .default) { _ in
                    
                    rootVC.selectedIndex = 2
                    
                    if let navController = rootVC.viewControllers?[2] as? UINavigationController,
                       let historyVC = navController.viewControllers.first as? HistoryVC {
                        
                        historyVC.performSegue(withIdentifier: "segueNewActividad", sender: notificacion)
                    }
                }

                let cerrar = UIAlertAction(title: "Cerrar", style: .cancel, handler: nil)

                alert.addAction(irARegistro)
                alert.addAction(cerrar)

                rootVC.present(alert, animated: true, completion: nil)
            }
        }
    }

}
