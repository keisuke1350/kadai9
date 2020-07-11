//
//  ViewController.swift
//  kadai9
//
//  Created by 葛西　佳祐 on 2020/07/07.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var splashImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3,
            delay: 1.0,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: { () in
                self.splashImage.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { (Bool) in
        })

        //拡大させて、消えるアニメーション
        UIView.animate(withDuration: 0.2,
            delay: 1.3,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: { () in
                self.splashImage.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
                self.splashImage.alpha = 0
            }, completion: { (Bool) in
                self.splashImage.removeFromSuperview()
                self.transition()
        })
        }
    @objc func transition() {
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
