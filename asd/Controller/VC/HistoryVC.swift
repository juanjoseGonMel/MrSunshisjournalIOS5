
import UIKit

class HistoryVC: UIViewController {

    @IBOutlet weak var tbvActividades: UITableView!
    
    let actividadManager = ActividadManager()
    var actividades: [Actividad] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyTheme()
        tbvActividades.delegate = self
        tbvActividades.dataSource = self
        
        cargarActividades()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func cargarActividades() {
        do {
            actividades = try actividadManager.fetchActividades()
            tbvActividades.reloadData()
            
            if actividades.isEmpty {
                showAlert(message: "No hay actividades registradas.")
            }
        } catch {
            print("❌ Error al obtener actividades: \(error.localizedDescription)")
            showAlert(message: "Error al cargar actividades. Intente más tarde.")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueNewActividad",
           let addActividadVC = segue.destination as? AddActividadVC,
           let notificacion = sender as? Notificacion {
            addActividadVC.onActividadAdded = { [weak self] in
                guard let self = self else {return}
                self.cargarActividades()
            }
            addActividadVC.notificacionSender = notificacion
        }
    }
}

extension HistoryVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actividades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "actividadCell", for: indexPath) as? ActividadCell {
            
            let actividad = actividades[indexPath.row]
            cell.configureActividadCell(actividad: actividad)
            
            return cell
        }
        return UITableViewCell()
    }
}

