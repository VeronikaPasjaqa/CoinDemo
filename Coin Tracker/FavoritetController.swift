//
//  FavoritetController.swift
//  Coin Tracker
//
//  Created by Rinor Bytyci on 11/13/17.
//  Copyright © 2017 Appbites. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON
import CoreData

//Klasa permbane tabele kshtuqe duhet te kete
//edhe protocolet per tabela
class FavoritetController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var coinCell = [CoinCellModel]()
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coinCell.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                fshij(coin: coinCell[indexPath.row].coinSymbol)
            self.coinCell.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "coinCell") as! CoinCell
        cell.lblEmri.text = coinCell[indexPath.row].coinName
        cell.lblTotali.text = coinCell[indexPath.row].totalSuppy
        cell.lblSymboli.text = coinCell[indexPath.row].coinSymbol
        cell.lblAlgoritmi.text = coinCell[indexPath.row].coinAlgo
        cell.imgFotoja.af_setImage(withURL: URL(string: coinCell[indexPath.row].imagePath)!)
        return cell
    }
    

   override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
         tableView.register(UINib.init(nibName: "CoinCell", bundle: nil), forCellReuseIdentifier: "coinCell")
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appdelegate.persistentContainer.viewContext
    
    let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Favorites")
    request.returnsObjectsAsFaults = false
    do {
       let rez = try!context.fetch(request)
        if rez.count > 0 {
            for item in rez as! [NSManagedObject]{
                let algo = item.value(forKey: "coinAlgo")
                let name = item.value(forKey: "coinName")
                let symbol = item.value(forKey: "coinSymbol")
                let imaage = item.value(forKey: "imagePath")
                let total = item.value(forKey: "totalSuppy")
                let allCoins = CoinCellModel(coinName: name as! String, coinSymbol: symbol as! String, coinAlgo: algo as! String, totalSuppy: total as! String, imagePath: imaage as! String)
                coinCell.append(allCoins)
            }
        }
        else {
            print("nuk ka elemente")
        }
    } catch  {
        print("gabim gjate leximit")
    }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func kthehu(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func fshij(coin: String) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:"Favorites")
        request.predicate = NSPredicate(format: "coinSymbol = %@", coin)
         request.returnsObjectsAsFaults = false
        do {
              let rez = try!context.fetch(request)
            if rez.count > 0{
                for elementi in rez as! [NSManagedObject]{
                   context.delete(elementi)
                
                }
             try! context.save()
            }
        } catch  {
            print("....")
        }
    
    }

}
