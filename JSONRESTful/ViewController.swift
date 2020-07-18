//
//  ViewController.swift
//  JSONRESTful
//
//  Created by Emerson on 7/17/20.
//  Copyright © 2020 Emerson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtContrasena: UITextField!
    var users = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueLogeo"{
            let nav = segue.destination as! UINavigationController
            let svc = nav.topViewController as! BuscarViewController
            svc.users = sender as? Users
        }
    }
    
    func validarUsuario(ruta:String, completed: @escaping() -> ()){
        let url = URL(string: ruta)
        URLSession.shared.dataTask(with: url!){(data,response,error) in
            if error == nil {
                do{
                    self.users = try JSONDecoder().decode([Users].self, from: data!)
                    DispatchQueue.main.async {
                        completed()	
                    }
                }catch{
                    print("Error en JSON")
                }
            }
        }.resume()
    }

    @IBAction func logear(_ sender: Any) {
        let ruta = "http://localhost:3000/usuarios?"
        let usuario = txtUsuario.text!
        let constrasena = txtContrasena.text!
        let url = ruta + "nombre=\(usuario)&clave=\(constrasena)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        validarUsuario(ruta: (crearURL)){
            if self.users.count <= 0 {
                print("Nombre de usuario y/o contraseña es incorrecto")
            }else{
                let user:Users = self.users[0]
                print("Logeo Exitoso")
                for data in self.users{
                    print("id:\(data.id), nombre:\(data.nombre), email:\(data.email)")
                }
                print(user)
                self.performSegue(withIdentifier: "segueLogeo", sender: user)
            }
        }
    }
}

