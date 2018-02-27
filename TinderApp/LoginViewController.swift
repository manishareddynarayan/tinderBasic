//
//  LoginViewController.swift
//  TinderApp
//
//  Created by Manisha Reddy Narayan on 22/02/18.
//  Copyright © 2018 Manisha Reddy Narayan. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var switchLoginMode: UIButton!
    @IBOutlet weak var loginOrSignup: UIButton!
    var signUpMode = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginOrSignupButton(_ sender: Any) {
        if signUpMode {
            let user = PFUser()
            user.username = usernameTextField.text
            user.password = passwordTextField.text
            user.signUpInBackground(block: { (success, error) in
                
                if error != nil {
                    var errorMessage = "Sign Up Failed - Try Again"
                    
                    if let newError = error as NSError? {
                        if let detailError = newError.userInfo["error"] as? String {
                            errorMessage = detailError
                        }
                    }
                    self.errorLabel.isHidden = false
                    self.errorLabel.text = errorMessage
                    
                } else {
                    print("Sign Up Successful")
                    self.performSegue(withIdentifier: "updateSegue", sender: nil)
                }
            })
        } else {
            
            if let username = usernameTextField.text {
                if let password = passwordTextField.text {
                    PFUser.logInWithUsername(inBackground: username, password: password, block: { (user, error) in
                        if error != nil {
                            var errorMessage = "Login Failed - Try Again"
                            
                            if let newError = error as NSError? {
                                if let detailError = newError.userInfo["error"] as? String {
                                    errorMessage = detailError
                                }
                            }
                            self.errorLabel.isHidden = false
                            self.errorLabel.text = errorMessage
                        } else {
                            print("Login Successful")
                            self.performSegue(withIdentifier: "updateSegue", sender: nil)
                        }
                    })
                }
            }
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            if PFUser.current()?["isFemale"] != nil {
                self.performSegue(withIdentifier: "loginToDisplaySegue", sender: nil)
            } else {
                self.performSegue(withIdentifier: "updateSegue", sender: nil)
            }
        }
    }
    @IBAction func switchButton(_ sender: Any) {
        if signUpMode {
            loginOrSignup.setTitle("LogIn", for: .normal)
            switchLoginMode.setTitle("SignUp", for: .normal)
            signUpMode = false
        } else {
            loginOrSignup.setTitle("SignUp", for: .normal)
            switchLoginMode.setTitle("LogIn", for: .normal)
            signUpMode = true
        }
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}
