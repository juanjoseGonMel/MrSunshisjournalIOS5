
import UIKit

class NotificacionCell: UITableViewCell {
    
    @IBOutlet weak var lblFecha: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var vwColorType: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(named: "card")
    }
    
    func configNotificationCell(notificacion : Notificacion){
        self.lblFecha.text = (notificacion.fechaString ?? "") + " - " + (notificacion.horario ?? "")
        self.lblDescripcion.text = notificacion.descripcion
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
