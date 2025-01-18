
import UIKit
import CoreData

class HomeVC: UIViewController {
    
    @IBOutlet weak var lblTitleHabitats: UILabel!
    @IBOutlet weak var btnAddHabitats: UIButton!
    @IBOutlet weak var clvHabitats: UICollectionView!
    @IBOutlet weak var lblTitleMascotas: UILabel!
    @IBOutlet weak var btnAddMascotas: UIButton!
    @IBOutlet weak var tbvMascotas: UITableView!
    var mascotas: [Mascota] = []
    let mascotaManager = MascotaManager()
    var selectedHabitat: Habitat?
    
    let habitatManager = HabitatManager()
    var habitats: [Habitat] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyTheme()
        self.btnAddHabitats.applyIconStyle()
        self.btnAddMascotas.applyIconStyle()
        self.fetchHabitats()
        self.clvHabitats.allowsMultipleSelection = false
        tbvMascotas.tableFooterView = UIView()
    }
    
    @IBAction func addHabitatPressed(_ sender: UIButton) {
        let dataToSend = (Habitat(), TypeOperation.add)
        self.performSegue(withIdentifier: AddHabitatVC.segueIdentifier, sender: dataToSend)
    }
    
    
    @IBAction func addMascotaPressed(_ sender: UIButton) {
        if let habitat = selectedHabitat {
            let dataToSend = (habitat, TypeOperation.add, Mascota())
            self.performSegue(withIdentifier: AddMascotaVC.segueIdentifier, sender: dataToSend)
        } else {
            showAlert(message: "Debe de seleccionar un habitat.")
        }
    }
    
    func fetchHabitats() {
        do {
            habitats = try habitatManager.fetchHabitats()
            if !habitats.isEmpty{
                self.selectedHabitat = habitats.first
                self.changeSelectedHabitat(habitat: self.selectedHabitat!)
            }
            clvHabitats.reloadData()
        } catch {
            print("Error al obtener habitats: \(error)")
        }
    }
    
    func fetchMascotas() {
        do {
            if let habitat = selectedHabitat {
                mascotas = try mascotaManager.fetchMascotas(byHabitat: habitat)
            } else {
                mascotas = try mascotaManager.fetchMascotas()
            }
            tbvMascotas.reloadData()
        } catch {
            print("Error al obtener mascotas: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AddHabitatVC.segueIdentifier,
           let addHabitatVC = segue.destination as? AddHabitatVC, let (habitat, typeOperation) = sender as? (Habitat, TypeOperation) {
            addHabitatVC.habitatSelected = habitat
            addHabitatVC.typeOperation = typeOperation
            addHabitatVC.onHabitatAdded = { [weak self] in
                guard let self = self else {return}
                self.fetchHabitats()
            }
        }else if segue.identifier == AddMascotaVC.segueIdentifier,
                 let addMascotaVC = segue.destination as? AddMascotaVC, let (habitat, typeOperation, mascota) = sender as? (Habitat, TypeOperation, Mascota) {
            addMascotaVC.selectedHabitat = habitat
            addMascotaVC.typeOperation = typeOperation
            addMascotaVC.mascotaSelected = mascota
            addMascotaVC.onMascotaAdded = { [weak self] in
                guard let self = self else {return}
                self.fetchMascotas()
            }
        }
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mascotas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "mascotaCell", for: indexPath) as? MascotaCell{
            let mascota = mascotas[indexPath.row]
            cell.configCell(mascota: mascota)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let habitat = selectedHabitat {
            let mascota = mascotas[indexPath.row]
            let dataToSend = (habitat, TypeOperation.update, mascota)
            self.performSegue(withIdentifier: AddMascotaVC.segueIdentifier, sender: dataToSend)
        } else {
            showAlert(message: "Debe de seleccionar un habitat.")
        }
    }
}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return habitats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitatCell", for: indexPath) as? HabitatColCell{
            let habitat = habitats[indexPath.row]
            cell.configHabitatCell(habitat: habitat){ [weak self] in
                guard let self = self else {return}
                let dataToSend = (habitat, TypeOperation.update)
                self.performSegue(withIdentifier: AddHabitatVC.segueIdentifier, sender: dataToSend)
            }
            if habitat == selectedHabitat {
                styleSelectedItem(cell: cell)
            } else {
                styleDeselectedItem(cell: cell)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedHabitat = selectedHabitat,
           let previousIndex = habitats.firstIndex(of: selectedHabitat),
           let previousCell = collectionView.cellForItem(at: IndexPath(row: previousIndex, section: 0)) {
            styleDeselectedItem(cell: previousCell)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            styleSelectedItem(cell: cell)
            let habitat = habitats[indexPath.row]
            self.changeSelectedHabitat(habitat: habitat)
            self.selectedHabitat = habitat
            self.fetchMascotas()
            print("Seleccionaste: \(habitat.name ?? "Sin Nombre")")
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            styleDeselectedItem(cell: cell)
        }
    }
    
    func styleSelectedItem(cell: UICollectionViewCell) {
        cell.layer.borderColor = UIColor(named: "accent")?.cgColor
        cell.layer.borderWidth = 3.0
        cell.layer.cornerRadius = 8.0
    }
    
    func styleDeselectedItem(cell: UICollectionViewCell) {
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0.0
    }
    
    func changeSelectedHabitat(habitat : Habitat){
        self.lblTitleMascotas.text = "Mascotas del habitat \(habitat.name ?? "")"
        self.fetchMascotas()
    }
}
