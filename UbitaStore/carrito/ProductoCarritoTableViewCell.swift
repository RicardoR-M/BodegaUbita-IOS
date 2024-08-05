import UIKit

class ProductoCarritoTableViewCell: UITableViewCell {

    @IBOutlet weak var productoLabel: UILabel!
    @IBOutlet weak var unidadesLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var productoImageView: UIImageView!
    @IBOutlet weak var cantidadLabel: UILabel!
    
    weak var delegate: ProductoCarritoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func eliminarProducto(_ sender: Any) {
        delegate?.eliminarProductoEnCarrito(cell: self)
    }
    @IBAction func reducirProducto(_ sender: Any) {
        delegate?.reducirProductoEnCarrito(cell: self)
    }
    @IBAction func aumentarProducto(_ sender: Any) {
        delegate?.aumentarProductoEnCarrito(cell: self)
    }
}

protocol ProductoCarritoTableViewCellDelegate: AnyObject {
    func eliminarProductoEnCarrito(cell: ProductoCarritoTableViewCell)
    func reducirProductoEnCarrito(cell: ProductoCarritoTableViewCell)
    func aumentarProductoEnCarrito(cell: ProductoCarritoTableViewCell)}
