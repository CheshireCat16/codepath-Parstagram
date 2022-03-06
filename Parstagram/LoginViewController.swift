//
//  LoginViewController.swift
//  Parstagram
//
//  Created by John Cheshire on 3/6/22.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: self.usernameField.text!, password: self.passwordField.text!) {
                  (user, error) -> Void in
                  if user != nil {
                      self.performSegue(withIdentifier: "loginSegue", sender: nil)
                  } else {
                      print("Error: \(String(describing: error?.localizedDescription))")               }
                }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        
        user.username = usernameField.text
        user.password = passwordField.text
        
        user.signUpInBackground { success, error in
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
