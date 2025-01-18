
import UIKit

class HabitatColCell: UICollectionViewCell {
    
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var btnEditar: UIButton!
    var editAction: (() -> Void)?
    
    func configHabitatCell(habitat : Habitat, onEdit: @escaping () -> Void){
        lblNombre.text = habitat.name
        self.layer.borderWidth = 0.0
        editAction = onEdit
        if let imageData = habitat.imagen, let image = UIImage(data: imageData) {
            imgCover.image = image
        } else {
            print("No se pudo convertir la imagen de Binary Data a UIImage")
            imgCover.image = UIImage(named: "defaultImage")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurarEstilo()
    }
    
    func configurarEstilo() {
        self.layer.cornerRadius = 12
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(named: "accent")?.cgColor
        
        
        imgCover.contentMode = .scaleAspectFill
        
        lblNombre.textColor = UIColor(named: "text")
        lblNombre.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.backgroundColor = .clear
        
        btnEditar.applyIconStyle()
        btnEditar.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        lblNombre.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        editAction?()
    }
}
