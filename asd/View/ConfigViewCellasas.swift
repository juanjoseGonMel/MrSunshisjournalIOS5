

import UIKit

class ConfigViewCellasdasd: UITableViewCell {

    
       
    @IBOutlet var imgConfig: UIImageView!
    
    @IBOutlet var cellTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        // Configurar el estilo de la celda
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        
        // Añadir sombra
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
