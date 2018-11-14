//
//  BarsListViewController.swift
//  Exercice Map
//
//  Created by Fady on 14/11/2018.
//  Copyright © 2018 SuperFadx. All rights reserved.
//

import UIKit
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
class BarsListViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
   
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var emptyView: UIView!
    
    var bars : [PenseBete.Bar] = []
    var currentBars : [PenseBete.Bar]! = []
    
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache:NSCache<AnyObject, AnyObject>!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.bars = Constants().getBarsFromJson()
        self.currentBars = self.bars
        tableView.delegate = self
        tableView.rowHeight = 170
        
        session = URLSession.shared
        task = URLSessionDownloadTask()
        self.cache = NSCache()
        self.searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.hideKeyboardWhenTappedAround()



    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        print(textField.text ?? "")
        if textField.text == "" || textField.text == nil {
            self.currentBars = self.bars
        } else {
            self.currentBars = self.bars.filter {
                ($0.name?.lowercased().contains(textField.text!.lowercased()))!
                ||
                    ( ($0.tags as! String).lowercased().contains(textField.text!.lowercased()))
            }
        }
        
        if self.currentBars.count == 0 {
            self.tableView.isHidden = true
            self.emptyView.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.emptyView.isHidden = true
            
        }
        self.tableView.reloadData()

    }

    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentBars.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "barCell", for: indexPath)
        
        
        let bar = self.currentBars[indexPath.row]
        
        (cell.contentView.viewWithTag(101) as! UILabel).text = bar.name
        (cell.contentView.viewWithTag(102) as! UILabel).text = bar.address
        
    
        (cell.contentView.viewWithTag(103) as! UILabel).text = bar.tags as? String
        (cell.contentView.viewWithTag(100) as! UIImageView).image = UIImage(named: "noimage")
        
        if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){

            //print("On importe l'image directement du cache")
            cell.imageView?.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
        }else{
            
            let url:URL! = URL(string: bar.imageUrl!)
            task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                if let data = try? Data(contentsOf: url){
                
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        (cell.contentView.viewWithTag(100) as! UIImageView).image = UIImage(data: data)
                        self.cache.setObject(UIImage(data: data)!, forKey: (indexPath as NSIndexPath).row as AnyObject)
                        
                    })
                }
            })
            task.resume()
        }
        
        
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow 
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let controller = mainStoryboard.instantiateViewController(withIdentifier:"BarOnMapViewController") as! BarOnMapViewController
        
        controller.bar = self.currentBars[(indexPath?.row)!]
        
        navigationController?.pushViewController(controller, animated: true)
        
        
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
