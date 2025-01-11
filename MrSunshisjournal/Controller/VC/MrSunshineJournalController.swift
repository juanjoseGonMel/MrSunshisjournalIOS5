//
//  MrSunshineJournalController.swift
//  MrSunshisjournal
//
//  Created by DISMOV on 20/12/24.
//

import UIKit

class MrSunshineJournalController: UIViewController {

    
    
    @IBOutlet var fondo: UIImageView!
    
    @IBOutlet var habitatCollection: UICollectionView!
    @IBOutlet var petsTableView: UITableView!
    
    
    let verticalItems = ["Item gato", "Item perro", "Item cuyo"]
    let horizontalItems = ["Item campo", "Item casa", "Item enfermeria", "","","","","","",""]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        // Configurar la imagen de fondo
        fondo.setBackgroundImage()
        
        
        // En caso de hacer delegate
        /*
        habitatTableView.delegate = self
        habitatTableView.dataSource = self
        
        petsTableView.delegate = self
        petsTableView.dataSource = self
        */
         
        
        
        // Configurar la tabla horizontal para desplazamiento horizontal
        /*if let layout = habitatTableView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            
        }
         */
        // Configurar el layout para la colección horizontal
        if let layout = habitatCollection.collectionViewLayout as? UICollectionViewFlowLayout { layout.scrollDirection = .horizontal }
        
        
        // Rotar la tabla para el desplazamiento horizontal
        //habitatTableView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        //habitatTableView.frame = self.view.frame
        
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




extension MrSunshineJournalController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return verticalItems.count
        
        //if tableView == petsTableView { return verticalItems.count } else { return horizontalItems.count }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "petsCell", for: indexPath) as! PetsViewCell
        
        cell.textLabel?.text = verticalItems[indexPath.row]
        return cell
        
        /*
        if tableView == petsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "petsCell", for: indexPath)
            cell.textLabel?.text = verticalItems[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "habitatCell", for: indexPath)
            cell.textLabel?.text = horizontalItems[indexPath.row]
            
            // Rotar la celda de vuelta para que el contenido sea legible
            cell.contentView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
            
            return cell
        }
        */
        
        
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
     */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    
    
}


extension MrSunshineJournalController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return horizontalItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitatCell", for: indexPath)
        cell.contentView.backgroundColor = .systemBlue
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Ajustar el tamaño de las celdas de la colección
        return CGSize(width: 100, height: collectionView.frame.height)
        
    }
    
    
}
