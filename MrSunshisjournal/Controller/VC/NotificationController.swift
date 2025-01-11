//
//  NotificationController.swift
//  MrSunshisjournal
//
//  Created by DISMOV on 04/12/24.
//

import UIKit
import FSCalendar

class NotificationController: UIViewController {

    
    @IBOutlet var fondo: UIImageView!
    @IBOutlet var activityCalendary: FSCalendar!
    @IBOutlet var activityTable: UITableView!
    
    @IBOutlet var btnAddActivity: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Configurar la imagen de fondo
        fondo.setBackgroundImage()
        
        // Configurar delegados
        activityCalendary.delegate = self
        activityCalendary.dataSource = self
        activityTable.delegate = self
        activityTable.dataSource = self
        
        
        //  activityCell
        
        
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



extension NotificationController: FSCalendarDelegate, FSCalendarDataSource {
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // Lógica para manejar la selección de una fecha
        print("Fecha seleccionada: \(date)")
        // Aquí podrías mostrar un cuadro de diálogo para agregar una actividad
        
    }
    
    
    
}

extension NotificationController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        cell.textLabel?.text = "item"
        return cell
        
    }
    
    
}
