//
//  ViewController.swift
//  Covid Tracker
//
//  Created by Dev Manaktala on 01/07/20.
//  Copyright © 2020 BeSingular. All rights reserved.
//

import UIKit

struct Day: Decodable {
    let date: String
    let dl: String
    let gj: String
    let ld: String
    let mh: String
    let ml: String
    let mp: String
    let pb: String
    let status: String
    let tn: String
    let up: String
    let wb: String
}

struct States:Decodable{
    let states_daily:[Day]
}


class ViewController: UIViewController {
    
    @IBOutlet weak var Header: UILabel!
    @IBOutlet weak var Analysis: UIButton!
    
    var states:States!
    @IBOutlet weak var Delhi: UIButton!
    
    @IBOutlet weak var WestBengal: UIButton!
    
    @IBOutlet weak var TamilNadu: UIButton!
    @IBOutlet weak var Maharashtra: UIButton!
    
    @IBOutlet weak var StateSelected: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Analysis.layer.cornerRadius = 10.0
        Header.textAlignment = .center
        
        let urlString = "https://api.covid19india.org/states_daily.json"

        self.loadJson(fromURLString: urlString) { (result) in
            switch result {
            case .success(let data):
                self.parse(jsonData: data)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    @IBAction func ButtonPress(_ sender: UIButton) {
        print(sender.tag)
        
        switch(sender.tag){
        case 0:
            performSegue(withIdentifier: "dl", sender: sender)
        case 1:
            performSegue(withIdentifier: "mh", sender: sender)
        case 2:
            performSegue(withIdentifier: "tn", sender: sender)
        case 3:
            performSegue(withIdentifier: "wb", sender: sender)
        default:
            print("Something went wrong")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        
        if segue.identifier != "analysis"{
            let vc = segue.destination as! StateViewController
            
            vc.button_pressed = (sender as! UIButton)
            vc.states = states
        }
        else{
             let vc = segue.destination as! AnalysisViewController
            vc.states = states
        }

    }
    
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            urlSession.resume()
        }
    }

    
    
    private func parse(jsonData: Data) {
        do {
            states = try JSONDecoder().decode(States.self, from: jsonData)
            
            print("Date = \(states.states_daily[states.states_daily.count-1].date)")
            print(states.states_daily[states.states_daily.count - 2])
            
            print("===================================")
        } catch {
            print("decode error")
        }
    }
    
}

