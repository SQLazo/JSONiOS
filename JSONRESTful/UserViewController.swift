//
//  UserViewController.swift
//  JSONRESTful
//
//  Created by Emerson on 7/17/20.
//  Copyright © 2020 Emerson. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    @IBOutlet weak var nombre: UITextField!
    @IBOutlet weak var clave: UITextField!
    @IBOutlet weak var email: UITextField!
    
    var user:Users?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if user == nil {
            
        }else{
            nombre.text = self.user!.nombre
            clave.text = self.user!.clave
            email.text = self.user!.email
        }
    }
    
    @IBAction func actualizar(_ sender: Any) {
        let name = nombre.text!
        let cla = clave.text!
        let em = email.text!
        let datos = ["nombre":"\(name)","clave":"\(cla)","email":"\(em)"] as Dictionary<String, Any>
        let ruta = "http://localhost:3000/usuarios/\(user!.id)"
        metodoPUT(ruta: ruta, datos: datos)
        navigationController?.popViewController(animated: true)
    }
    
    func metodoPUT(ruta:String, datos:[String:Any]){
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "PUT"
        
        let params = datos
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request, completionHandler: {(data,response,error) in
            if (data != nil){
                do {
                    let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    print(dict)
                } catch {
                    
                }
            }
        })
        task.resume()
    }
}
