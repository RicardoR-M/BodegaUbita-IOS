import UIKit
import Firebase

class RegistrarViewController: UIViewController {

    @IBOutlet weak var nombreCompletoTextField: UITextField!
    @IBOutlet weak var direccionTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func registrar(_ sender: Any) {
        let nombre = nombreCompletoTextField.text!
        let direccion = direccionTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        self.registrarAuth(nombre: nombre, direccion: direccion, email: email, password: password)
    }
    
    func registrarAuth(nombre: String, direccion: String, email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let user = result {
                let uid = user.user.uid
                self.registrarFirestore(uid: uid, nombre: nombre, direccion: direccion, email: email)
            } else {
                print("Error al registrar")
            }
        }
    }
    
    func registrarFirestore(uid: String, nombre: String, direccion: String, email: String) {
        let db = Firestore.firestore()
        db.collection("User").document(uid).setData([
            "fullname": nombre,
            "address": direccion,
            "email": email
        ]) { error in
            if error != nil{
                print("Error al registrar en firestore")
            } else {
                self.dismiss(animated: true)
            }
        }
    }
    
}
