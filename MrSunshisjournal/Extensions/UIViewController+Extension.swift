
import UIKit

extension UIViewController : UITextFieldDelegate{
    func showAlert(message: String, isError: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: isError ? "Lo sentimos!" : "Éxito",
                message: message,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                if let completion = completion{
                    completion()
                }
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    func configureKeyboardHandling() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGesture)

            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

            findAllTextFields(in: view).forEach { $0.delegate = self }
        }

        func findAllTextFields(in view: UIView) -> [UITextField] {
            var textFields: [UITextField] = []
            for subview in view.subviews {
                if let textField = subview as? UITextField {
                    textFields.append(textField)
                } else {
                    textFields.append(contentsOf: findAllTextFields(in: subview))
                }
            }
            return textFields
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }

        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        @objc func keyboardWillShow(_ notification: Notification) {
            guard let userInfo = notification.userInfo,
                  let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

            if let scrollView = findScrollView(in: view) {
                let keyboardHeight = keyboardFrame.height
                scrollView.contentInset.bottom = keyboardHeight
                
                if #available(iOS 13.0, *) {
                    scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
                } else {
                    scrollView.scrollIndicatorInsets.bottom = keyboardHeight
                }
            }
        }

        @objc func keyboardWillHide(_ notification: Notification) {
            if let scrollView = findScrollView(in: view) {
                scrollView.contentInset.bottom = 0
                
                if #available(iOS 13.0, *) {
                    scrollView.verticalScrollIndicatorInsets.bottom = 0
                } else {
                    scrollView.scrollIndicatorInsets.bottom = 0
                }
            }
        }

        func findScrollView(in view: UIView) -> UIScrollView? {
            for subview in view.subviews {
                if let scrollView = subview as? UIScrollView {
                    return scrollView
                } else {
                    if let nestedScrollView = findScrollView(in: subview) {
                        return nestedScrollView
                    }
                }
            }
            return nil
        }
    
    func applyTheme() {
        view.backgroundColor = UIColor(named: "background")
        
        if let tableView = view as? UITableView {
            tableView.backgroundColor = UIColor(named: "background")
        }
        
        if let navBar = navigationController?.navigationBar {
            navBar.standardAppearance.backgroundColor = UIColor(named: "background")
        }
    }
}

extension UIImageView {
    func applyCircularStyle(borderColor: UIColor = UIColor(named: "accent") ?? .yellow, borderWidth: CGFloat = 2.0) {
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFit
    }
}


extension UIButton {
    func applyIconStyle() {
        self.backgroundColor = .clear
        self.setTitleColor(UIColor(named: "accent"), for: .normal)
        self.tintColor = UIColor(named: "accent")
    }
    
    func applyDangerStyle() {
        self.backgroundColor = .clear
        self.setTitleColor(UIColor(named: "danger"), for: .normal)
        self.tintColor = UIColor(named: "danger")
    }
}
