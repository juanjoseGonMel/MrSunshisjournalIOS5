
import UIKit

class AddActividadVC: UIViewController {
    static let segueIdentifier = "segueNewActividad"
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var lblTitleActividad: UILabel!
    @IBOutlet weak var txtDescripcion: UITextField!
    @IBOutlet weak var lblMascota: UILabel!
    @IBOutlet weak var lblDescripcionNotificacion: UILabel!
    let actividadManager = ActividadManager()
    var onActividadAdded: (() -> Void)?
    var notificacionSender : Notificacion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboardHandling()
        if let notificacion = notificacionSender{
            self.lblMascota.text = "Mascota: \(notificacion.mascota?.name ?? "")"
            self.lblDescripcionNotificacion.text = "Descripcion: \(notificacion.descripcion ?? "")"
        }
        self.btnSave.applyIconStyle()
        self.btnCancel.applyDangerStyle()
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        guard let descripcion = txtDescripcion.text, !descripcion.isEmpty else {
            showAlert(message: "El campo 'Observaciones' no puede estar vacío.")
            return
        }
        do {
            let _ = try actividadManager.createActividad(fecha: Date(), observaciones: descripcion, notificacion: notificacionSender)
            
            onActividadAdded?()
            showAlert(message: "Actividad agregada con éxito.", isError: false){[weak self] in
                guard let self = self else {return}
                self.dismiss(animated: true)
            }
            
        } catch {
            showAlert(message: "Error al agregar el registro de actividad: \(error.localizedDescription)")
        }
    }
}
