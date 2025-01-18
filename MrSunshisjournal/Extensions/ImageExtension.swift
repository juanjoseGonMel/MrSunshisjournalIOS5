

import Foundation
import UIKit


extension UIImageView {
    
    
    func setBackgroundImage() {
            // Detecta si estamos en modo claro o modo oscuro
            let imageName: String
        let darkModeImageName = "fondooscuro"
        let lightModeImageName = "fondoclaro"
            
            if traitCollection.userInterfaceStyle == .dark {
                // Si es modo oscuro, usa la imagen para el modo oscuro
                imageName = darkModeImageName
            } else {
                // Si es modo claro, usa la imagen para el modo claro
                imageName = lightModeImageName
            }
            
            // Configura la imagen de fondo
            self.image = UIImage(named: imageName)
            self.contentMode = .scaleAspectFill
            self.clipsToBounds = true
        }
}



