

import Foundation
import UIKit
class ThemeManager {
    
    static func applyGlobalStyles() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "background")
        appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "title") ?? .white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor(named: "accent")

        UITabBar.appearance().barTintColor = UIColor(named: "background")
        UITabBar.appearance().tintColor = UIColor(named: "accent")
        
        UITableView.appearance().backgroundColor = UIColor(named: "background")
        UITableViewCell.appearance().backgroundColor = UIColor(named: "card")

        //UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = UIColor(named: "text")
    }
}
