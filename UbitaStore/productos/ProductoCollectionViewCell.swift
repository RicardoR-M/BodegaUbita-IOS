import UIKit

class ProductoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var unidadesLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var productoImageView: UIImageView!
    @IBOutlet weak var productoLabel: UILabel!
    
    weak var delegate: ProductoCollectionViewCellDelegate?
    
    @IBAction func agregarProducto(_ sender: Any) {
        delegate?.agregarProductoEnCarrito(cell: self)
    }
}

protocol ProductoCollectionViewCellDelegate: AnyObject {
    func agregarProductoEnCarrito(cell: ProductoCollectionViewCell)
}
