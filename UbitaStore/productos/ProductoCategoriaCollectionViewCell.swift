import UIKit

class ProductoCategoriaCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var productoLabel: UILabel!
    @IBOutlet weak var unidadesLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var productoImageView: UIImageView!
    
    weak var delegate: ProductoCategoriaCollectionViewCellDelegate?
    
    @IBAction func agregarProductoCategoria(_ sender: Any) {
        delegate?.agregarProductoEnCarrito(cell: self)
    }
}

protocol ProductoCategoriaCollectionViewCellDelegate: AnyObject {
    func agregarProductoEnCarrito(cell: ProductoCategoriaCollectionViewCell)
}
