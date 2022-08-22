
// Add this to the header of your file, e.g. in ViewController.swift
import FacebookLogin

// Add this to the body
class ViewController: UIViewController, LoginButtonDelegate {
    
    let nameLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .white
        label.text = "Facebook User Name"
        label.font = UIFont.systemFont(ofSize: 33, weight: .bold)
        label.textAlignment = .center
        label.textColor = .label
        label.isHidden = true
        label.frame = CGRect(x: 58, y: 340, width: 270, height: 40)
        
        return label
    } ()
    
    let mailLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .white
        label.text = "Facebook User Email"
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.textAlignment = .center
        label.textColor = .label
        label.isHidden = true
        label.frame = CGRect(x: 70, y: 400, width: 250, height: 40)
        
        return label
    } ()
    
    let logoutButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(UIColor.systemBackground, for: .normal)
        button.frame = CGRect(x: 300, y: 270, width: 75, height: 50)
        button.isHidden = true
        button.backgroundColor = .orange
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewDidLoad()
    }
    
    func configureViewDidLoad() {
        view.addSubview(mailLabel)
        view.addSubview(nameLabel)
        view.addSubview(logoutButton)
        
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        let loginButton = FBLoginButton()
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 100, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        loginButton.permissions = ["public_profile", "email"]
        
        let customButton = UIButton(type: .system)
        view.addSubview(customButton)
        customButton.backgroundColor = .systemPink
        customButton.setTitle("Custom Login Facebook", for: .normal)
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
            self.logoutButton.isHidden  = false
        }
    }
    
    @objc func logoutButtonTapped() {
        LoginManager().logOut()
        logoutTapped()
    }
    
    func logoutTapped() {
        nameLabel.isHidden = true
        nameLabel.text = "Facebook User Name"
        
        mailLabel.isHidden = true
        mailLabel.text = "Facebook User Email"
        
        logoutButton.isHidden = true
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?){
        
        if error != nil {
            print(error!.localizedDescription)
            return
        }
        
        showEmailAdres(token: result?.token?.tokenString)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        logoutTapped()
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
            
            if let res = result {
                if let response = res as? [String: Any] {
                    let username = response["name"]
                    let email = response["email"]
                    
                    self.nameLabel.text = username as? String
                    self.nameLabel.isHidden = false
                    
                    self.mailLabel.text = email as? String
                    self.mailLabel.isHidden = false
                    
                }
            }
        }
    }
}
