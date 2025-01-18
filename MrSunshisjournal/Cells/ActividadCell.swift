
import UIKit

class ActividadCell: UITableViewCell {
    
    @IBOutlet weak var imgMascota: UIImageView!
    @IBOutlet weak var lblMascota: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblObservaciones: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgMascota.applyCircularStyle(borderColor: .clear)
    }
    
    func configureActividadCell(actividad: Actividad){
        self.lblMascota.text = actividad.notificacion?.mascota?.name
        self.lblFecha.text = (actividad.fechaString ?? "") + " " + (actividad.notificacion?.horario ?? "")
        self.lblObservaciones.text = actividad.observaciones
        if let imageData = actividad.notificacion?.mascota?.imagen, let image = UIImage(data: imageData) {
            imgMascota.image = image
        } else {
            print("No se pudo convertir la imagen de Binary Data a UIImage")
            imgMascota.image = UIImage(named: "defaultImage")
        }
        imgMascota.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
