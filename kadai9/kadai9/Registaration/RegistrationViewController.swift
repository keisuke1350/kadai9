//
//  RegistrationViewController.swift
//  kadai9
//
//  Created by 葛西　佳祐 on 2020/07/11.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit
import Firebase
import Lottie

class RegistrationViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //lottieのアニメーションを使用
    let animationView = AnimationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //Firebaseにユーザーを登録する
    @IBAction func registerNewUser(_ sender: Any) {
        
        //アニメーションのスタート
        startAnimation()
        
        
        //新規登録
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error as Any)
            } else {
                print ("ユーザーの作成が成功しました")
            }
        }
        
        //アニメーションのストップ
        self.stopAnimation()
        
        //画面をチャット画面に遷移させる
        let vc = FirstViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func startAnimation(){
        let animation = Animation.named("loading")
        animationView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height/1.5)
        
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        view.addSubview(animationView)
    }
    
    func stopAnimation (){
        animationView.removeFromSuperview()
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
