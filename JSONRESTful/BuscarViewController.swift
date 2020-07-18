//
//  BuscarViewController.swift
//  JSONRESTful
//
//  Created by Emerson on 7/17/20.
//  Copyright © 2020 Emerson. All rights reserved.
//

import UIKit

class BuscarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var peliculas = [Peliculas]()
    var id:Int?
    var users:Users?
    
    @IBOutlet weak var txtBuscar: UITextField!
    
    @IBOutlet weak var tablaPeliculas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaPeliculas.delegate = self
        tablaPeliculas.dataSource = self
    
        let ruta = "http://localhost:3000/peliculas?"
        cargarPeliculas(ruta: ruta){
            self.tablaPeliculas.reloadData()
        }
        print("\(users!) dos")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ruta = "http://localhost:3000/peliculas/"
        cargarPeliculas(ruta: ruta){
            self.tablaPeliculas.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEditar"{
            let siguienteVC = segue.destination as! AgregarViewController
            siguienteVC.pelicula = sender as? Peliculas
        }
        if segue.identifier == "segueUser"{
            let siguienteVC = segue.destination as! UserViewController
            siguienteVC.user = sender as? Users
        }
    }
    
    @IBAction func btnBuscar(_ sender: Any) {
        let ruta = "http://localhost:3000/peliculas?"
        let nombre = txtBuscar.text!
        let url = ruta + "nombre_like=\(nombre)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        
        if nombre.isEmpty{
            let ruta = "http://localhost:3000/peliculas/"
            self.cargarPeliculas(ruta: ruta){
                self.tablaPeliculas.reloadData()
            }
        }else{
            cargarPeliculas(ruta: crearURL){
                if self.peliculas.count <= 0 {
                    self.mostrarAlerta(titulo: "Error", mensaje: "No se encontraron peliculas para : \(nombre)", accion: "cancel")
                }else{
                    self.tablaPeliculas.reloadData()
                }
            }
        }
    }
    
    @IBAction func btnSalir(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnUser(_ sender: Any) {
        performSegue(withIdentifier: "segueUser", sender: users)
    }
    func cargarPeliculas(ruta:String, completed: @escaping () -> ()){
        let url = URL(string: ruta)
        URLSession.shared.dataTask(with: url!){(data,response,error) in
            if error == nil {
                do{
                    self.peliculas = try JSONDecoder().decode([Peliculas].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("Error en JSON")
                }
            }
        }.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peliculas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(peliculas[indexPath.row].nombre)"
        cell.detailTextLabel?.text = "Genero: \(peliculas[indexPath.row].genero) Duracion: \(peliculas[indexPath.row].duracion)"
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pelicula = peliculas[indexPath.row]
        performSegue(withIdentifier: "segueEditar", sender: pelicula)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alerta = UIAlertController(title: "Eliminar Pelicula", message: "Estas seguro que quieres eliminar esta pelicula", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: {(UIAlertAction) in
                let pelicula = self.peliculas[indexPath.row]
                let ruta = "http://localhost:3000/peliculas/\(pelicula.id)"
                self.metodoDELETE(ruta: ruta)
                let ruta1 = "http://localhost:3000/peliculas/"
                self.cargarPeliculas(ruta: ruta1){
                    self.tablaPeliculas.reloadData()
                }
            })
            let btnCANCELAR = UIAlertAction(title: "No, Tengo miedo", style: .default, handler: nil)
            alerta.addAction(btnOK)
            alerta.addAction(btnCANCELAR)
            present(alerta, animated: true, completion: nil)
        }
    }
    
    func mostrarAlerta(titulo: String, mensaje:String, accion:String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnOK)
        present(alerta, animated: true, completion: nil)
    }

    
    func metodoDELETE(ruta:String){
        let url:URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "DELETE"
        
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
