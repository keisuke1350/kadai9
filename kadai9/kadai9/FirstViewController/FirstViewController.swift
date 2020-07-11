//
//  FirstViewController.swift
//  kadai9
//
//  Created by 葛西　佳祐 on 2020/07/11.
//  Copyright © 2020 葛西　佳祐. All rights reserved.
//

import UIKit
import ChameleonFramework
import Firebase

class FirstViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate {

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var massageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    //スクリーンのサイズ
    let screenSize = UIScreen.main.bounds.size
    
    var chatArray = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        massageTextField.delegate = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "Cell")
        //セルが可変になる
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 75
        
        //キーボード
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.keyboardWillShow(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FirstViewController.keyboardWillHide(_ :)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //Firebaseからデータをfetchしてくる
        fetchChatData()
        
        //セルのハイライトを消す
        tableView.separatorStyle = .none
        
        
        
        // Do any additional setup after loading the view.
        
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification){
        
        let keyboardHeight = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as Any) as AnyObject).cgRectValue.height
        
        massageTextField.frame.origin.y = screenSize.height - keyboardHeight - massageTextField.frame.height
        
    }
    
    @objc func keyboardWillHide(_ notification:NSNotification){
        
        massageTextField.frame.origin.y = screenSize.height - massageTextField.frame.height
    
        guard let rect = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]as? TimeInterval else{return}
        
        UIView.animate(withDuration: duration){
            let transform = CGAffineTransform(translationX: 0, y: 0)
            self.view.transform = transform
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        massageTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //メッセージの数
        return chatArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        
        cell.messageLabel.text = chatArray[indexPath.row].message
        

        
        cell.userNameLabel.text = chatArray[indexPath.row].sender
        cell.iconImageView.image = UIImage(named:"profile")
        
        if cell.userNameLabel.text == Auth.auth().currentUser?.email!{
            
           cell.messageLabel.backgroundColor = UIColor.flatGreen()
           //メッセージを角丸に
           cell.messageLabel.layer.cornerRadius = 20
           cell.messageLabel.layer.masksToBounds = true
        } else {
            cell.messageLabel.backgroundColor = UIColor.flatBlue()
            //メッセージを角丸に
            cell.messageLabel.layer.cornerRadius = 20
            cell.messageLabel.layer.masksToBounds = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            chatArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @IBAction func sendAction(_ sender: Any) {
        
        massageTextField.endEditing(true)
        massageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        if massageTextField.text!.count > 15 {
            
            print("15文字以上です。")
            
            return
        }
        let chatDB = Database.database().reference().child("chats")
        
        //キーバリュー型で内容を送信（Dictionary型）
        let messageInfo = ["sender":Auth.auth().currentUser?.email,"message":massageTextField.text!]
        
        //chatDBに入れる
        chatDB.childByAutoId().setValue(messageInfo){ (error, result) in
            if error != nil{
                print(error)
            } else {
            print("送信完了！！")
            self.massageTextField.isEnabled = true
            self.sendButton.isEnabled = true
            self.massageTextField.text = ""
            }
        }
    }
    
    func fetchChatData(){
        //どこからデータを引っ張ってくるか
        let fetchDataRef = Database.database().reference().child("chats")
        
        //新しく更新があったときだけ取得したい
        fetchDataRef.observe(.childAdded) { (snapShot) in
            
            let snapShotData = snapShot.value as! AnyObject
            let text = snapShotData.value(forKey: "message")
            let sender = snapShotData.value(forKey: "sender")
            
            let message = Message()
            message.message = text as! String
            message.sender = sender as! String
            self.chatArray.append(message)
            self.tableView.reloadData()
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
