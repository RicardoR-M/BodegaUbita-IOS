import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.checkLoggedUser()
    }
    
    @IBAction func login(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        loginFirebase(email: email, password: password)
    }
    
    func loginFirebase (email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if result != nil {
                self.goToMenu()
            } else {
                self.mensajeError()
            }
        }
    }
    
    func goToMenu(){
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let menuView = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        menuView.modalPresentationStyle = .fullScreen
        self.present(menuView, animated: true)
    }
    
    func checkLoggedUser(){
        if Auth.auth().currentUser != nil {
            self.goToMenu()
        }
    }
    
    func mensajeError(){
        let alert = UIAlertController(title: "Inicio de sesión incorrecto", message: "Por favor, revise su correo electrónico y contraseña.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
