//
//  UserConfigController.swift
//  MrSunshisjournal
//
//  Created by DISMOV on 04/12/24.
//

import UIKit

class UserConfigController:UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        <#code#>
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        <#code#>
    }
    

    
    @IBOutlet var Fondo: UIImageView!
    
    @IBOutlet var userImg: UIImageView!
    @IBOutlet var cameraImg: UIImageView!
    @IBOutlet var Perfil: UIView!
    
    
    @IBOutlet var mainScroll: UIScrollView!

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var nameEdTe: UITextField!
    
    @IBOutlet var apellidoLabel: UILabel!
    @IBOutlet var apellidoEdTe: UITextField!
    
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var emailEdTe: UITextField!
    
    @IBOutlet var phoneLabel: UILabel!
    @IBOutlet var phoneEdTe: UITextField!
    
    @IBOutlet var localizacionPickerView: UIPickerView!
    @IBOutlet var localizacionLabel: UILabel!
    
    @IBOutlet var saveBtn: UIButton!
    
    
    
    // Variable para almacenar el campo de texto activo
    var activeField: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        Fondo.setBackgroundImage()

        
        // Conectar el delegate y el datasource del UIPickerView
        localizacionPickerView.delegate = self
        localizacionPickerView.dataSource = self
        
        // Agregar un Tap Gesture para cerrar el teclado
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //view.addGestureRecognizer(tapGesture)
        
        // Registrar las notificaciones del teclado
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            // Obtener la altura del teclado
            if let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let keyboardHeight = keyboardFrame.height
                adjustScrollViewForKeyboard(show: true, keyboardHeight: keyboardHeight)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        adjustScrollViewForKeyboard(show: false, keyboardHeight: 0)
    }

    func adjustScrollViewForKeyboard(show: Bool, keyboardHeight: CGFloat) {
        let contentInsets = show ? UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0) : .zero
        mainScroll.contentInset = contentInsets
        mainScroll.scrollIndicatorInsets = contentInsets

        if show {
            // Scroll to the active text field or view
            if let activeField = activeField {
                let scrollViewRect = view.convert(mainScroll.frame, from: mainScroll.superview)
                if !scrollViewRect.contains(activeField.frame.origin) {
                    mainScroll.scrollRectToVisible(activeField.frame, animated: true)
                }
            }
        }
    }


    // Asigna el campo de texto activo al comenzar la edición
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }

    // Limpia el campo de texto activo al finalizar la edición
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }

    
    
    
    /*
    // Acción cuando el teclado está por aparecer
    @objc func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            // Calculamos la altura del teclado
            let keyboardHeight = keyboardFrame.height
            
            // Ajustamos la posición del scroll view para que suba
            var contentInset = mainScroll.contentInset
            contentInset.bottom = keyboardHeight
            mainScroll.contentInset = contentInset
            
            // También ajustamos el scrollView para asegurarnos de que el campo de texto sea visible
            //mainScroll.scrollToBottom(animated: true)
        }
    }

        // Acción cuando el teclado se oculta
    @objc func keyboardWillHide(notification: NSNotification) {
        // Restablecer el contentInset cuando el teclado desaparezca
        var contentInset = mainScroll.contentInset
        contentInset.bottom = 0
        mainScroll.contentInset = contentInset
    }

        // Asegurarnos de que el scroll view desplaza al campo de texto visible
    func scrollToBottom(animated: Bool) {
        let bottomOffset = CGPoint(x: 0, y: mainScroll.contentSize.height - mainScroll.bounds.size.height)
        mainScroll.setContentOffset(bottomOffset, animated: animated)
    }
        
        // Opcionalmente puedes agregar un método para manejar los toques fuera del campo de texto para cerrar el teclado
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    deinit {
        // Eliminar el observador cuando la vista es destruida
        NotificationCenter.default.removeObserver(self)
    }
    */
    

}
