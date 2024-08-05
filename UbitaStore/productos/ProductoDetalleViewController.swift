import UIKit

class ProductoDetalleViewController: UIViewController {

    
    @IBOutlet weak var productoImageView: UIImageView!
    @IBOutlet weak var unidadesLabel: UILabel!
    @IBOutlet weak var productoLabel: UILabel!
    @IBOutlet weak var precioLabel: UILabel!
    @IBOutlet weak var descripcionLabel: UILabel!
    
    var producto: Producto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: producto?.productoImg ?? "") {
            productoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "logo_color"))
        }
        productoLabel.text = producto?.producto
        unidadesLabel.text = producto?.unidades
        precioLabel.text = numToSol(num: producto?.precio ?? 0)
        descripcionLabel.text = producto?.descripcion
    }
    
    @IBAction func agregarAlCarrito(_ sender: Any) {
        self.agregarProducto()
        navigationController?.popViewController(animated: true)
    }
    
    func agregarProducto(){
        agregarProductoAlCarrito(producto: producto!)
        mensajeAlerta(mensaje: "Se agregó el producto!", theme: .success)
    }
    
}
