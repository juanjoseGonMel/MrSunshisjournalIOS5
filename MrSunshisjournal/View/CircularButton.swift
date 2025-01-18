

import Foundation
import UIKit

class CircularButton: UIButton {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        // Hacer el botón circular
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
        
        // Configurar la imagen del icono de Facebook
        setImage(UIImage(named: "facebookIcon"), for: .normal)
        
        // Ajustar el color de fondo (opcional)
        //backgroundColor = UIColor(named: "DodgerBlue")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Asegurarse de que el cornerRadius se ajuste correctamente después de que se hayan aplicado las restricciones
        layer.cornerRadius = frame.size.width / 2
    }
}
