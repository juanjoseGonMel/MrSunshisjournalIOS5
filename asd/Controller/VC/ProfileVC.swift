
import UIKit
import CoreData
enum TypeOperation {
    case add
    case update
}
class ProfileVC: UIViewController {
    
    @IBOutlet weak var btnChangeProfile: UIButton!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtTelefono: UITextField!
    @IBOutlet weak var btnGuardar: UIButton!
    let usuarioManager = UsuarioManager()
    var typeOperations : TypeOperation = .add
    var userRegistered : Usuario?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyTheme()
        configureKeyboardHandling()
        checkExistUser()
        btnGuardar.applyIconStyle()
        imgProfile.applyCircularStyle()
        btnChangeProfile.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    func checkExistUser(){
            do {
                let userArray = try usuarioManager.fetchAllUsuarios()
                if !userArray.isEmpty{
                    typeOperations = .update
                    self.userRegistered = userArray.first
                    self.displayExistingUser(user: self.userRegistered ?? Usuario())
                }
            } catch {
                print("Error al obtener habitats: \(error)")
            }
    }
    
    func displayExistingUser(user : Usuario){
        self.txtNombre.text = user.nombre
        self.txtApellido.text = user.apellidos
        self.txtCorreo.text = user.correo
        self.txtTelefono.text = user.telefono
        if let imageData = user.foto, let image = UIImage(data: imageData) {
            imgProfile.image = image
        } else {
            print("No se pudo convertir la imagen de Binary Data a UIImage")
            imgProfile.image = UIImage(named: "defaultImage")
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        guard let nombre = txtNombre.text, !nombre.isEmpty else {
            showAlert(message: "Por favor, ingresa un nombre.")
               return
           }
           
           guard let apellido = txtApellido.text, !apellido.isEmpty else {
               showAlert(message: "Por favor, ingresa un apellido.")
               return
           }
           
           guard let correo = txtCorreo.text, !correo.isEmpty, validarCorreo(correo) else {
               showAlert(message: "Por favor, ingresa un correo válido.")
               return
           }
           
           guard let telefono = txtTelefono.text, !telefono.isEmpty, validarTelefono(telefono) else {
               showAlert(message: "Por favor, ingresa un número de teléfono válido de 10 dígitos.")
               return
           }
           
           guard let foto = imgProfile.image?.pngData() else {
               showAlert(message: "Por favor, selecciona una imagen de perfil.")
               return
           }
           
        switch typeOperations {
        case .add:
            do {
                try usuarioManager.createUsuario(apellidos: apellido, foto: foto, correo: correo, nombre: nombre, telefono: telefono, ubicacion: nil)
                showAlert(message: "Usuario agregado con éxito.", isError: false)
            }
            catch{
                showAlert(message: "Error al agregar usuario: \(error.localizedDescription)")
            }
        case .update:
            do {
                try usuarioManager.updateUsuario(id: self.userRegistered?.id ?? 0, apellidos: apellido, foto: foto, correo: correo, nombre: nombre, telefono: telefono, ubicacion: nil)
                showAlert(message: "Usuario modificado con éxito.", isError: false)
            }
            catch{
                showAlert(message: "Error al actualizar usuario: \(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func changeProfilePressed(_ sender: UIButton) {
        showImagePicker()
    }
    
    func validarCorreo(_ correo: String) -> Bool {
        let correoRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicado = NSPredicate(format: "SELF MATCHES %@", correoRegex)
        return predicado.evaluate(with: correo)
    }

    func validarTelefono(_ telefono: String) -> Bool {
        let telefonoRegex = "^[0-9]{10}$"
        let predicado = NSPredicate(format: "SELF MATCHES %@", telefonoRegex)
        return predicado.evaluate(with: telefono)
    }
    
    /*

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    */

}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            self.imgProfile.image = selectedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.imgProfile.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
