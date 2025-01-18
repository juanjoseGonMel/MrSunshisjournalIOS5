import UIKit
import CoreActionSheetPicker

class AddMascotaVC: UIViewController {
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    static let segueIdentifier = "segueAddMascota"
    
    @IBOutlet weak var imgMascota: UIImageView!
    @IBOutlet weak var lblTitleMascota: UILabel!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtDescripcion: UITextField!
    @IBOutlet weak var txtHabitat: UITextField!
    @IBOutlet weak var txtFechaNac: UITextField!
    @IBOutlet weak var txtRaza: UITextField!
    @IBOutlet weak var txtGenero: UITextField!
    @IBOutlet weak var swEsteril: UISwitch!
    let mascotaManager = MascotaManager()
    var onMascotaAdded: (() -> Void)?
    var selectedHabitat: Habitat = Habitat()
    @IBOutlet weak var btnChangeImage: UIButton!
    var typeOperation : TypeOperation = .add
    var mascotaSelected : Mascota?
    let razasCuyos = ["Abisinio", "Americano", "Peruano", "Teddy", "Texel", "Silkie", "Crestado", "Baldwin", "Skinny", "Sheltie"]
    let generos = ["Hembra", "Macho"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureKeyboardHandling()
        self.txtHabitat.text = selectedHabitat.name ?? ""
        if(typeOperation == .update){
            if let imageData = mascotaSelected?.imagen, let image = UIImage(data: imageData) {
                imgMascota.image = image
            }
            self.lblTitleMascota.text = "Modificar mascota"
            self.txtNombre.text = mascotaSelected?.name ?? ""
            self.txtDescripcion.text = mascotaSelected?.descripcion ?? ""
            self.txtFechaNac.text = "\(mascotaSelected?.fechaNac ?? Date())"
            self.txtRaza.text = mascotaSelected?.raza ?? ""
            self.txtGenero.text = mascotaSelected?.genero ?? ""
            self.swEsteril.isOn = (mascotaSelected?.esteril ?? false)
        }
        self.btnSave.applyIconStyle()
        self.btnCancel.applyDangerStyle()
        self.imgMascota.applyCircularStyle()
        self.imgMascota.contentMode = .scaleAspectFill
        self.btnChangeImage.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        configurarPickers()
    }
    
    func configurarPickers() {
        configurarPickerRaza()
        configurarPickerGenero()
        configurarPickerFechaNacimiento()
    }
    
    func configurarPickerRaza() {
        txtRaza.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mostrarPickerRaza))
        txtRaza.addGestureRecognizer(tapGesture)
    }
    
    func configurarPickerGenero() {
        txtGenero.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mostrarPickerGenero))
        txtGenero.addGestureRecognizer(tapGesture)
    }
    
    func configurarPickerFechaNacimiento() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        datePicker.tintColor = .black
        datePicker.addTarget(self, action: #selector(fechaNacimientoSeleccionada(_:)), for: .valueChanged)
        txtFechaNac.inputView = datePicker
        txtFechaNac.inputAccessoryView = createToolbar(selector: #selector(donePressedFecha))
    }
    
    // MARK: - Mostrar Pickers
    @objc func mostrarPickerRaza() {
        let picker = ActionSheetStringPicker(
            title: "Seleccionar Raza",
            rows: razasCuyos,
            initialSelection: 0,
            doneBlock: { _, index, _ in
                self.txtRaza.text = self.razasCuyos[index]
            },
            cancel: { _ in },
            origin: self.view
        )
        picker?.show()
    }
    
    @objc func mostrarPickerGenero() {
        let picker = ActionSheetStringPicker(
            title: "Seleccionar Género",
            rows: generos,
            initialSelection: 0,
            doneBlock: { _, index, _ in
                self.txtGenero.text = self.generos[index]
            },
            cancel: { _ in },
            origin: self.view
        )
        
        picker?.pickerTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        picker?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        picker?.show()
    }
    
    @objc func fechaNacimientoSeleccionada(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        txtFechaNac.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func donePressedFecha() {
        view.endEditing(true)
    }
    
    func createToolbar(selector: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: selector)
        doneButton.tintColor = .black
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressedTool))
        cancelButton.tintColor = .red
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([cancelButton, flexSpace, doneButton], animated: false)
        
        return toolbar
    }
    
    @IBAction func cancelPressedTool(_ sender: UIButton) {
        self.dismiss(animated: true)
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
        
        guard let fechaNac = txtFechaNac.text,  !fechaNac.isEmpty else {
            showAlert(message: "El campo 'Fecha nacimiento' no puede estar vacío.")
            return
        }
        
        guard let razaText = txtRaza.text,  !razaText.isEmpty else {
            showAlert(message: "El campo 'Raza' no puede estar vacío.")
            return
        }
        
        guard let generoText = txtGenero.text,  !generoText.isEmpty else {
            showAlert(message: "El campo 'Género' no puede estar vacío.")
            return
        }
        
        guard let imagen = imgMascota.image, let imageData = imagen.pngData() else {
            showAlert(message: "Debes seleccionar una imagen para la mascota.")
            return
        }
        
        switch(typeOperation){
        case .add:
            do {
                let mascota = try mascotaManager.createMascota(name: nombre,
                                                               descripcion: descripcion,
                                                               peso: 0.0,
                                                               fechaNacimiento: Date(),
                                                               raza: razaText,
                                                               esterilizado: self.swEsteril.isOn,
                                                               genero: generoText,
                                                               imagen: imageData,
                                                               habitat: self.selectedHabitat)
                onMascotaAdded?()
                print("Mascota creada con éxito: \(mascota)")
                limpiarFormulario()
                showAlert(message: "Mascota agregada con éxito.", isError: false){[weak self] in
                    guard let self = self else {return}
                    self.dismiss(animated: true)
                }
                
            } catch {
                showAlert(message: "Error al agregar mascota: \(error.localizedDescription)")
            }
            break
        case .update:
            do {
                try mascotaManager.updateMascota(byID : mascotaSelected?.id ?? 0,
                                                 name: nombre,
                                                 descripcion: descripcion,
                                                 peso: nil,
                                                 fechaNacimiento: mascotaSelected?.fechaNac ?? Date(),
                                                 raza: razaText,
                                                 esterilizado: self.swEsteril.isOn,
                                                 genero: generoText,
                                                 imagen: imageData,
                                                 habitat: self.selectedHabitat)
                onMascotaAdded?()
                showAlert(message: "Mascota modificada con éxito.", isError: false)
            } catch {
                showAlert(message: "Error al agregar mascota: \(error.localizedDescription)")
            }
            break
        }
    }
    
    func limpiarFormulario() {
        txtNombre.text = ""
        txtDescripcion.text = ""
        txtFechaNac.text = ""
        txtRaza.text = ""
        txtGenero.text = ""
        swEsteril.isOn = false
        imgMascota.image = nil
    }
}


extension AddMascotaVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            self.imgMascota.image = selectedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            self.imgMascota.image = originalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
