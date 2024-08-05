import UIKit

class CarritoViewController: UIViewController, UITableViewDataSource, ProductoCarritoTableViewCellDelegate {
    
    @IBOutlet weak var carritoTableView: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    
    var carritoList: [CarritoEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carritoTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cargarProductos()
    }
    
    func cargarProductos(){
        listarCarrito() {(productos) in
            self.carritoList = productos
            self.actualizaTotalLabel()
            
            DispatchQueue.main.async {
                self.carritoTableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carritoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productoCell", for: indexPath) as! ProductoCarritoTableViewCell
        cell.delegate = self
        
        let carrito = carritoList[indexPath.row]
        
        if let url = URL(string: carrito.productoImg ?? "") {
            cell.productoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "logo_color"))
        }
        cell.productoLabel.text = carrito.producto
        cell.unidadesLabel.text = carrito.unidades
        cell.precioLabel.text = numToSol(num: carrito.precio * Double(carrito.cantidad))
        cell.cantidadLabel.text = carrito.cantidad.formatted()
        
        return cell
    }
    
    func eliminarProductoEnCarrito(cell: ProductoCarritoTableViewCell) {
        guard let indexPath = carritoTableView.indexPath(for: cell) else { return }
        
        let productoEliminar = carritoList[indexPath.row]
        eliminarProducto(producto: productoEliminar)
        carritoList.remove(at: indexPath.row)
        carritoTableView.deleteRows(at: [indexPath], with: .fade)
        actualizaTotalLabel()
    }
    
    func reducirProductoEnCarrito(cell: ProductoCarritoTableViewCell) {
        guard let indexPath = carritoTableView.indexPath(for: cell) else { return }
        
        let producto = carritoList[indexPath.row]
        producto.cantidad = editarCantidadProducto(producto: producto, accion: "-")
        cell.cantidadLabel.text = producto.cantidad.formatted()
        cell.precioLabel.text = numToSol(num: producto.precio * Double(producto.cantidad))
        actualizaTotalLabel()
    }
    
    func aumentarProductoEnCarrito(cell: ProductoCarritoTableViewCell) {
        guard let indexPath = carritoTableView.indexPath(for: cell) else { return }
        
        let producto = carritoList[indexPath.row]
        producto.cantidad = editarCantidadProducto(producto: producto, accion: "+")
        cell.cantidadLabel.text = producto.cantidad.formatted()
        cell.precioLabel.text = numToSol(num: producto.precio * Double(producto.cantidad))
        actualizaTotalLabel()
        
    }
    func actualizaTotalLabel() {
        self.totalLabel.text = numToSol(num: self.carritoList.reduce(0, {$0 + ($1.precio * Double($1.cantidad))}))
    }
    
    @IBAction func checkout(_ sender: Any) {
        if carritoList.isEmpty {
            self.mensajeError()
        } else {
            firebaseSaveOrder(carrito: carritoList) {() in
                limpiarCarrito()
                self.cargarProductos()
            }
        }
    }
    
    func mensajeError(){
        let alert = UIAlertController(title: "Error", message: "El carrito de compras está vacio.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
