
import UIKit

class MascotaCell: UITableViewCell {
    @IBOutlet weak var imgMascota: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblFechaNac: UILabel!
    @IBOutlet weak var lblGenero: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(mascota : Mascota){
        self.lblNombre.text = mascota.name
        self.lblFechaNac.text = "\(mascota.fechaNac ?? Date())"
        self.lblGenero.text = mascota.genero
        if let imageData = mascota.imagen, let image = UIImage(data: imageData) {
            imgMascota.image = image
        } else {
            print("No se pudo convertir la imagen de Binary Data a UIImage")
            imgMascota.image = UIImage(named: "defaultImage")
        }
        imgMascota.applyCircularStyle(borderColor: .clear, borderWidth: 0)
        self.imgMascota.contentMode = .scaleAspectFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
