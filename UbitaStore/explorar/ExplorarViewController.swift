import UIKit


class ExplorarViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var explorarCollectionView: UICollectionView!
    
    
    var categoriaList:[Categoria] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        explorarCollectionView.dataSource = self
        explorarCollectionView.delegate = self
        listarCategorias()
    }
    
    func listarCategorias(){
        firebaseGetCategories(collection: "Category") {(categorias) in
            self.categoriaList = categorias
            DispatchQueue.main.async {
                self.explorarCollectionView.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriaList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriaCollectionViewCell", for: indexPath) as! CategoriaCollectionViewCell
        cell.layer.cornerRadius = 10
        
        let categoria = categoriaList[indexPath.row]
        
        cell.categoriaLabel.text = categoria.categoria
        if let url = URL(string: categoria.categoriaImg) {
            cell.categoriaImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "logo_color"))
        }
        cell.backgroundColor = hexStringToUIColor(hex: categoria.fondo)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let categoria = categoriaList[indexPath.row]
        self.goToDetail(categoriaId: categoria.categoriaId, categoria: categoria.categoria)
        
    }
    
    func goToDetail(categoriaId: String, categoria: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CategoriaDetalleViewController") as! CategoriaDetalleViewController
        vc.categoriaId = categoriaId
        vc.categoria = categoria
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
