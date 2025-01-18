
import UIKit

class AddHabitatVC: UIViewController {
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    static let segueIdentifier = "segueAddHabitat"
    @IBOutlet weak var lblTitleHabitat: UILabel!
    
    @IBOutlet weak var imgHabitat: UIImageView!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtDescripcion: UITextField!
    @IBOutlet weak var txtTipo: UITextField!
    @IBOutlet weak var txtCapacidad: UITextField!
    @IBOutlet weak var txtTamano: UITextField!
    @IBOutlet weak var txtTemperatura: UITextField!
    @IBOutlet weak var btnChangeImage: UIButton!
    
    let habitatManager = HabitatManager()
    var onHabitatAdded: (() -> Void)?
    var typeOperation : TypeOperation = .add
    var habitatSelected : Habitat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboardHandling()
        if(typeOperation == .update){
            if let imageData = habitatSelected?.imagen, let image = UIImage(data: imageData) {
                imgHabitat.image = image
            }
            self.lblTitleHabitat.text = "Modificar habitat"
            self.txtNombre.text = habitatSelected?.name ?? ""
            self.txtDescripcion.text = habitatSelected?.descripcion ?? ""
            self.txtTipo.text = habitatSelected?.tipo ?? ""
            self.txtCapacidad.text = "\(habitatSelected?.capacidad ?? 0)"
            self.txtTamano.text = "\(habitatSelected?.size ?? 0.0)"
            self.txtTemperatura.text = "\(habitatSelected?.temperatura ?? 0.0)"
        }
        self.btnSave.applyIconStyle()
        self.btnCancel.applyDangerStyle()
        self.imgHabitat.applyCircularStyle()
        self.imgHabitat.contentMode = .scaleAspectFill
        self.btnChangeImage.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
    }
    
    @IBAction func selectImagePressed(_ sender: UIButton) {
        showImagePicker()
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        guard let nombre = txtNombre.text, !nombre.isEmpty else {
            showAlert(message: "El campo 'Nombre' no puede estar vacío.")
            return
        }
        
        guard let descripcion = txtDescripcion.text, !descripcion.isEmpty else {
            showAlert(message: "El campo 'Descripción' no puede estar vacío.")
            return
        }
        
        guard let tipo = txtTipo.text, !tipo.isEmpty else {
            showAlert(message: "El campo 'Tipo' no puede estar vacío.")
            return
        }
        
        guard let capacidadText = txtCapacidad.text, let capacidad = Int64(capacidadText) else {
            showAlert(message: "El campo 'Capacidad' debe ser un número entero.")
            return
        }
        
        guard let tamanoText = txtTamano.text, let tamano = Double(tamanoText) else {
            showAlert(message: "El campo 'Tamaño' debe ser un número decimal.")
            return
        }
        
        guard let temperaturaText = txtTemperatura.text, let temperatura = Double(temperaturaText) else {
            showAlert(message: "El campo 'Temperatura' debe ser un número decimal.")
            return
        }
        
        guard let imagen = imgHabitat.image, let imageData = imagen.pngData() else {
            showAlert(message: "Debes seleccionar una imagen para el hábitat.")
            return
        }
        
        switch(typeOperation){
        case .add:
            do {
                let habitat = try habitatManager.createHabitat(
                    name: nombre,
                    descripcion: descripcion,
                    capacidad: capacidad,
                    tamano: tamano,
                    temperatura: temperatura,
                    tipo: tipo,
                    imagen: imageData
                )
                print("Hábitat creado con éxito: \(habitat)")
                onHabitatAdded?()
                limpiarFormulario()
                showAlert(message: "Hábitat agregado con éxito.", isError: false){[weak self] in
                    guard let self = self else {return}
                    self.dismiss(animated: true)
                }
                
            } catch {
                showAlert(message: "Error al agregar el hábitat: \(error.localizedDescription)")
            }
            break
        case .update:
            do {
                try habitatManager.updateHabitat(byID: habitatSelected?.id ?? 0, name: nombre, descripcion: descripcion, capacidad: capacidad, tamano: tamano, temperatura: temperatura, tipo: tipo, isOpened: false, imagen: imageData)
                onHabitatAdded?()
                showAlert(message: "Hábitat modificado con éxito.", isError: false)
            }
            catch{
                showAlert(message: "Error al modificar el hábitat: \(error.localizedDescription)")
            }
            break
        }
    }
    
    func limpiarFormulario() {
        txtNombre.text = ""
        txtDescripcion.text = ""
        txtTipo.text = ""
        txtCapacidad.text = ""
        txtTamano.text = ""
        txtTemperatura.text = ""
        imgHabitat.image = nil
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

extension AddHabitatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            self.imgHabitat.image = selectedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.imgHabitat.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
