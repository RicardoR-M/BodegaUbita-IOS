import UIKit
import Firebase

class CuentaViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var nombreUsuarioLabel: UILabel!
    @IBOutlet weak var correoLabel: UILabel!
    @IBOutlet weak var pedidosTableView: UITableView!
    
    var pedidoList: [Pedido] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pedidosTableView.dataSource = self
        cargarDatosUsuarioFirebase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cargarOrdenes()
    }
    
    @IBAction func salir(_ sender: Any) {
        salirFirebase()
    }
    
    func salirFirebase(){
        do {
            try Auth.auth().signOut()
            goToLogin()
        } catch let error as NSError{
            print("Se presento un error \(error)")
        }
    }
    
    func goToLogin(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginView = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        loginView.modalPresentationStyle = .fullScreen
        self.present(loginView, animated: true)
    }
    
    func cargarDatosUsuarioFirebase(){
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            self.correoLabel.text = user.email
            
            let db = Firestore.firestore()
            db.collection("User").document(uid).getDocument() {(querySnapshot, error) in
                if error != nil {
                    print("Se presentó un error")
                } else {
                    let data = querySnapshot?.data()
                    self.nombreUsuarioLabel.text = data?["fullname"] as? String ?? "Usuario"
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pedidoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pedidoCell", for: indexPath) as! PedidoTableViewCell
        
        let orden = pedidoList[indexPath.row]
        let estado: String
        
        if orden.estado == true {
            estado = "Entregado"
            cell.estadoLabel.textColor = UIColor.green
        } else {
            estado = "Pendiente"
            cell.estadoLabel.textColor = UIColor.red
        }
        
        
        cell.codigoPedidoLabel.text = orden.codigo
        cell.fechaLabel.text = orden.fecha
        cell.estadoLabel.text = estado
        
        return cell
    }
    
    func cargarOrdenes(){
        firebaseGetUserOrders() {(pedidos) in
            self.pedidoList = pedidos
            DispatchQueue.main.async {
                self.pedidosTableView.reloadData()
            }
        }
    }
}
