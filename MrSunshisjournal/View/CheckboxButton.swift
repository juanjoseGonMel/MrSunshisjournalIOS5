

import Foundation
import UIKit

class CheckboxButton: UIButton {
    // Images
    let checkedImage = UIImage(systemName: "checkmark.square") // imagen para el estado marcado
    let uncheckedImage = UIImage(systemName: "square") // imagen para el estado desmarcado

    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }

    override func awakeFromNib() {
        self.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.isChecked = false
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
