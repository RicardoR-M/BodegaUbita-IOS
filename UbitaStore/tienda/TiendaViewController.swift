import UIKit
import Firebase
import SDWebImage

class TiendaViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ProductoCollectionViewCellDelegate {

    @IBOutlet weak var tiendaCollectionView: UICollectionView!
    
    var productoList: [Producto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tiendaCollectionView.dataSource = self
        tiendaCollectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        listarProductos()
    }

    func listarProductos(){
        firebaseGetProducts(collection: "Producto") {(productos) in
            self.productoList = productos
            DispatchQueue.main.async {
                self.tiendaCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductoCollectionViewCell", for: indexPath) as! ProductoCollectionViewCell
        cell.delegate = self
        
        cell.layer.borderWidth = 0.3
        cell.layer.cornerRadius = 10
        cell.layer.borderColor = UIColor.lightGray.cgColor
        
        let producto = productoList[indexPath.row]
        
        if let url = URL(string: producto.productoImg) {
            cell.productoImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "logo_color"))
        }
        
        cell.productoLabel.text = producto.producto
        cell.unidadesLabel.text = producto.unidades
        cell.precioLabel.text = numToSol(num: producto.precio)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let producto = productoList[indexPath.row]
        self.goToDetail(producto: producto)
    }
    
    func goToDetail(producto: Producto){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductoDetalleViewController") as! ProductoDetalleViewController
        vc.producto = producto
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func agregarProductoEnCarrito(cell: ProductoCollectionViewCell) {
        guard let indexPath = tiendaCollectionView.indexPath(for: cell) else { return }
        
        let producto = productoList[indexPath.row]
        agregarProductoAlCarrito(producto: producto)
        
        mensajeAlerta(mensaje: "Se agregó el producto!", theme: .success)
    }
    
}
