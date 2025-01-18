//
//  AppDelegate.swift
//  MrSunshisjournal
//
//  Created by DISMOV on 24/10/24.
//

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
    
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("🚀 Notificación recibida en primer plano:", notification.request.identifier)
        
        let userInfo = notification.request.content.userInfo
        print("🚀 Notificación recibida en primer plano user:", userInfo)
        if let notificacionID = userInfo["notificacion_id"] as? Int64{

            do {
                let notificacion = try NotificacionManager().fetchNotificacion(byID: notificacionID)
                if let notificacion = notificacion {
                    print("✅ Notificación encontrada en Core Data")
                    showAlertInApp(notification.request.content.title,
                                   message: notification.request.content.body,
                                   notificacion: notificacion)
                } else {
                    print("❌ No se encontró la notificación con ID:", notificacionID)
                }
            } catch {
                print("❌ Error al recuperar la notificación desde Core Data: \(error.localizedDescription)")
            }
        } else {
            print("❌ No se pudo obtener notificacion_id")
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
            print("🚀 Mostrando alerta en app") // 🔥 Debug
            
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
            } else {
                print("❌ No se pudo encontrar el rootViewController adecuado.") // 🔥 Debug
            }
        }
    }
}
