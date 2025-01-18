
import UIKit
import FSCalendar

class NotificationsVC: UIViewController {
    
    @IBOutlet weak var tblNotificaciones: UITableView!
    @IBOutlet weak var btnAdd: UIBarButtonItem!
    @IBOutlet weak var vwCalendar: FSCalendar!
    let notificacionManager = NotificacionManager()
    var fechasConEventos: [String] = []
    var notificacionesParaFechaSeleccionada: [Notificacion] = []
    var fechaSeleccionadaString: String? {
        didSet {
            actualizarListadoNotificaciones()
        }
    }
    
    var fechaSelected: Date? {
        didSet {
            actualizarListadoNotificaciones()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyTheme()
        do {
            try notificacionManager.convertirFechasExistentes()
        } catch {
            print("❌ No se pudieron convertir las fechas.")
        }
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                print("⏰ Notificación pendiente: \(request.identifier) - \(request.content.title) - \(request.trigger!)")
            }
        }
        vwCalendar.delegate = self
        vwCalendar.dataSource = self
        vwCalendar.appearance.calendar.delegate = self
        vwCalendar.allowsMultipleSelection = false
        configurarFechas()
        vwCalendar.reloadData()
    }
    
    func configurarFechas() {
        do {
            fechasConEventos = try notificacionManager.fetchDistinctFechas()
        } catch {
            print("Error al obtener las fechas con eventos: \(error.localizedDescription)")
        }
    }
    
    func actualizarListadoNotificaciones() {
        guard let fecha = fechaSeleccionadaString else {
            notificacionesParaFechaSeleccionada = []
            tblNotificaciones.reloadData()
            return
        }
        
        do {
            notificacionesParaFechaSeleccionada = try notificacionManager.fetchNotificaciones(for: fechaSeleccionadaString!)
                tblNotificaciones.reloadData()
        } catch {
            print("Error al obtener notificaciones para la fecha seleccionada: \(error.localizedDescription)")
        }
    }
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        if let fecha = fechaSelected,let fechaString =  fechaSeleccionadaString{
            let dataToSend = (fechaString, fecha, TypeOperation.add)
            self.performSegue(withIdentifier: NewNotificationVC.segueIdent, sender: dataToSend)
        } else {
            showAlert(message: "Debe seleccionar una fecha para agregar una nueva notificación.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == NewNotificationVC.segueIdent,
           let newNotificationVC = segue.destination as? NewNotificationVC, let (dateString,date, typeOperation) = sender as? (String, Date, TypeOperation) {
            newNotificationVC.selectedDateString = dateString
            newNotificationVC.selectedDate = date
            newNotificationVC.typeOperation = typeOperation
            newNotificationVC.onNotificacionAdded = { [weak self] in
                guard let self = self else {return}
                self.actualizarListadoNotificaciones()
            }
        }
    }
}

extension NotificationsVC: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance{
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return .black
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        fechaSelected = date
        fechaSeleccionadaString = dateFormatter.string(from: date)
        print("Fecha seleccionada (normalizada): \(fechaSeleccionadaString!)")
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        if let fechaSeleccionada = fechaSeleccionadaString, fechaSeleccionada == dateString {
            return .blue
        }
        if fechasConEventos.contains(dateString) {
            return UIColor(named: "accent")
        }
        if Calendar.current.isDateInToday(date) {
            return UIColor(named: "danger")
        }
        
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        if let fechaSeleccionada = fechaSeleccionadaString, fechaSeleccionada == dateString {
            return .blue
        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let todayFormatter = DateFormatter()
        todayFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = todayFormatter.string(from: Date())
        let selectedDateString = todayFormatter.string(from: date)
        
        if selectedDateString < todayString {
            showAlert(message: "No puede elegir fechas pasadas.")
            return false
        } else {
            return true
        }
    }
}

extension NotificationsVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificacionesParaFechaSeleccionada.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "notificacioncell", for: indexPath) as? NotificacionCell{
            let notificacion = notificacionesParaFechaSeleccionada[indexPath.row]
            cell.configNotificationCell(notificacion: notificacion)
            return cell
        }
        return UITableViewCell()
    }
}

