
import UIKit
import CoreActionSheetPicker

class NewNotificationVC: UIViewController {
    static let segueIdent = "segueNewNotification"
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

    @IBOutlet weak var lblTitleNotificacion: UILabel!
    @IBOutlet weak var txtDescripcion: UITextField!
    @IBOutlet weak var txtMascota: UITextField!
    @IBOutlet weak var txtFecha: UITextField!
    @IBOutlet weak var txtHorario: UITextField!
    @IBOutlet weak var txtTipo: UITextField!
    @IBOutlet weak var txtFrecuencia: UITextField!

    let mascotaManager = MascotaManager()
    let notificacionManager = NotificacionManager()

    var onNotificacionAdded: (() -> Void)?
    var selectedDate: Date = Date()
    var typeOperation: TypeOperation = .add
    var mascotas: [Mascota] = []
    var selectedMascota: Mascota?
    var frecuencias : [(nombre: String, valor: Int)] = (
        [
            ("Sin repetir", 0),
            ("Diario", 1),
            ("Cada 2 días", 2),
            ("Cada 5 días", 5),
            ("Semanalmente", 7),
            ("Cada dos semanas", 14),
            ("Cada mes", 30),
            ("Cada 6 meses", 180),
            ("Cada año", 365)
        ]
    )
    var selectedDateString = ""
    var tipos: [String] = ["Comida", "Vacuna", "Medicina"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtFecha.text = "\(selectedDateString)"
        configureKeyboardHandling()
        cargarMascotas()
        configurarPickerTxtMascota()
        configurarPickerTxtHorario()
        configurarPickerTxtFrecuencia()
        configurarPickerTxtTipo()
        self.btnSave.applyIconStyle()
        self.btnCancel.applyDangerStyle()
    }

    func configurarPickerTxtMascota() {
        txtMascota.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mostrarPickerMascotas))
        txtMascota.addGestureRecognizer(tapGesture)
    }

    func configurarPickerTxtHorario() {
        txtHorario.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mostrarPickerHorario))
        txtHorario.addGestureRecognizer(tapGesture)
    }

    func configurarPickerTxtFrecuencia() {
        txtFrecuencia.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mostrarPickerFrecuencia))
        txtFrecuencia.addGestureRecognizer(tapGesture)
    }

    func configurarPickerTxtTipo() {
        txtTipo.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mostrarPickerTipo))
        txtTipo.addGestureRecognizer(tapGesture)
    }

    @objc func mostrarPickerMascotas() {
        let nombresMascotas = mascotas.map { $0.name ?? "Sin Nombre" }

        ActionSheetStringPicker.show(
            withTitle: "Seleccionar Mascota",
            rows: nombresMascotas,
            initialSelection: 0,
            doneBlock: { _, index, _ in
                self.selectedMascota = self.mascotas[index]
                self.txtMascota.text = self.mascotas[index].name
            },
            cancel: { _ in },
            origin: self.view
        )
    }

    @objc func mostrarPickerHorario() {
        let horas = Array(0...23).map { String(format: "%02d", $0) }
        let minutos = Array(0...59).map { String(format: "%02d", $0) }

        ActionSheetMultipleStringPicker.show(
            withTitle: "Seleccionar Horario",
            rows: [horas, minutos],
            initialSelection: [0, 0],
            doneBlock: { _, selections, _ in
                if let selectedValues = selections as? [Int],
                   selectedValues.count == 2 {
                    let hora = horas[selectedValues[0]]
                    let minuto = minutos[selectedValues[1]]
                    self.txtHorario.text = "\(hora):\(minuto)"
                }
            },
            cancel: { _ in },
            origin: self.view
        )
    }

    @objc func mostrarPickerFrecuencia() {
        let nombresFrecuencias = frecuencias.map { $0.nombre }

        ActionSheetStringPicker.show(
            withTitle: "Seleccionar Frecuencia",
            rows: nombresFrecuencias,
            initialSelection: 0,
            doneBlock: { _, index, _ in
                let frecuenciaSeleccionada = self.frecuencias[index]
                self.txtFrecuencia.text = frecuenciaSeleccionada.nombre
                self.txtFrecuencia.accessibilityValue = "\(frecuenciaSeleccionada.valor)"
            },
            cancel: { _ in },
            origin: self.view
        )
    }

    @objc func mostrarPickerTipo() {
        ActionSheetStringPicker.show(
            withTitle: "Seleccionar Tipo",
            rows: tipos,
            initialSelection: 0,
            doneBlock: { _, index, _ in
                self.txtTipo.text = self.tipos[index]
            },
            cancel: { _ in },
            origin: self.view
        )
    }

    func cargarMascotas() {
        do {
            mascotas = try mascotaManager.fetchMascotas()
            if mascotas.isEmpty {
                self.btnSave.isEnabled = false
                self.txtMascota.isEnabled = false
                showAlert(message: "No se podrá agregar una notificación ya que no hay mascotas registradas. Agregue una mascota y vuelva a intentarlo.")
            }
        } catch {
            print("Error al cargar las mascotas: \(error)")
            showAlert(message: "No se pudieron cargar las mascotas. Intente más tarde.")
        }
    }

    @IBAction func savePressed(_ sender: UIButton) {
        guard let descripcion = txtDescripcion.text, !descripcion.isEmpty else {
            showAlert(message: "El campo 'Descripción' no puede estar vacío.")
            return
        }

        guard let mascotaSeleccionada = selectedMascota else {
            showAlert(message: "Debe seleccionar una mascota.")
            return
        }

        /*guard let fechaText = txtFecha.text, !fechaText.isEmpty,
              let fecha = validarFecha(fechaText) else {
            showAlert(message: "El campo 'Fecha' debe tener un formato válido (YYYY-MM-DD).")
            return
        }*/

        guard let horarioText = txtHorario.text, !horarioText.isEmpty,
              validarHorario(horarioText) else {
            showAlert(message: "El campo 'Horario' debe tener un formato válido (HH:mm en 24 horas).")
            return
        }

        guard let frecuenciaText = txtFrecuencia.text, !frecuenciaText.isEmpty,
              let frecuenciaValor = txtFrecuencia.accessibilityValue,
              let frecuencia = Int64(frecuenciaValor) else {
            showAlert(message: "El campo 'Frecuencia' debe ser un valor válido.")
            return
        }

        guard let tipo = txtTipo.text, !tipo.isEmpty else {
            showAlert(message: "El campo 'Tipo' no puede estar vacío.")
            return
        }

        switch(typeOperation) {
        case .add:
            do {
                let _ = try notificacionManager.createNotificacion(
                    tipo: tipo,
                    descripcion: descripcion,
                    fecha: selectedDate,
                    frecuenciadias: frecuencia,
                    horario: horarioText,
                    mascota: mascotaSeleccionada
                )
                onNotificacionAdded?()
                limpiarFormulario()
                showAlert(message: "Notificación agregada con éxito.", isError: false){[weak self] in
                    guard let self = self else {return}
                    self.dismiss(animated: true)
                }
            } catch {
                showAlert(message: "Error al agregar notificación: \(error.localizedDescription)")
            }
        case .update:
            break
        }
    }

    @IBAction func cancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }

    func limpiarFormulario() {
        txtTipo.text = ""
        txtDescripcion.text = ""
        txtHorario.text = ""
        txtFrecuencia.text = ""
        txtMascota.text = ""
        selectedMascota = nil
    }

    func validarFecha(_ fecha: String) -> Date? {
        let dateFormatter = DateFormatter()
        return dateFormatter.date(from: fecha)
    }
    
    func validarHorario(_ horario: String) -> Bool {
        let horarioRegex = "^(?:[01][0-9]|2[0-3]):[0-5][0-9]$"
        let horarioPredicado = NSPredicate(format: "SELF MATCHES %@", horarioRegex)
        return horarioPredicado.evaluate(with: horario)
    }
}
