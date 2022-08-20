
// Add this to the header of your file, e.g. in ViewController.swift
import FacebookLogin

// Add this to the body
class ViewController: UIViewController, LoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 100, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        loginButton.permissions = ["public_profile", "email"]
        
        let customButton = UIButton(type: .system)
        view.addSubview(customButton)
        customButton.backgroundColor = .systemPink
        customButton.setTitle("Custom Facebook Button", for: .normal)
        customButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        customButton.setTitleColor(.systemBackground, for: .normal)
        customButton.frame = CGRect(x: 16, y: 200, width: view.frame.width - 32, height: 50)
        
        customButton.addTarget(self, action: #selector(handleCustomButton), for: .touchUpInside)
        
    }
    
    @objc func handleCustomButton() {
        LoginManager().logIn(permissions: ["public_profile", "email"], from: self) { result, error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            self.showEmailAdres(token: result?.token?.tokenString)
        }
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?){
        
        if error != nil {
            print(error!.localizedDescription)
            return
        }
        
       
        
        showEmailAdres(token: result?.token?.tokenString)
      
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Did logout")
    }
    
    func showEmailAdres(token: String?) {
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                 parameters: ["fields" : "id, email, name"],
                                                 tokenString: token,
                                                 version: nil,
                                                 httpMethod: .get)
        
        request.start { connection, result, error in
            if error != nil {
                print("Failed to start GraphRequest")
                return
            }
            
            print(result)
        }
    }
}
