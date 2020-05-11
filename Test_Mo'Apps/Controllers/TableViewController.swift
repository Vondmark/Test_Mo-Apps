//
//  TableViewController.swift
//  Test_Mo'Apps
//
//  Created by Mark on 10.05.2020.
//  Copyright © 2020 Mark. All rights reserved.
//

import UIKit
import SafariServices

class TableViewController: UITableViewController {
    var userToken: String?
    var projectResponse: ProjectResponse? = nil
    let networkService = NetworkingService()
    var projectTableViewCell: ProjectTableViewCell? = nil
    
    private var timer:Timer?
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    @IBAction func backButon(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goBack", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = myRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        print(userToken!)
        setupTableView()
        
        request()
    }
    func setupTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            
        })
    }
    
    func setupTableView() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bgr"), for: .default)
        tableView.backgroundView = UIImageView(image: UIImage(named: "bgr"))
    }
    
    @objc private func refresh(sender: UIRefreshControl) {

        request()
        tableView.reloadData()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            sender.endRefreshing()
        })
        
    }
    
    
    //MARK: - Requests
    
    func request() {
        let urlString = "https://html5.mo-apps.com/api/application"
        let parameters = ["skip":"0", "take":"1000", "osType":"0","userToken": userToken!]
        self.networkService.projectRequest(urlString: urlString, parameters: parameters) { [weak self](result) in
            switch result {
            case .success(let projectResponse):
                self?.projectResponse = projectResponse
                self?.tableView.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projectResponse?.data.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "topcell", for: indexPath) as! ProjectTableViewCell
        let project = projectResponse?.data[indexPath.row]
        cell.nameLabel.text = project?.applicationName
        cell.creatingImage.image = project?.applicationStatus == false ? UIImage(named: "noFinished") :
            UIImage(named: "finished")
        cell.creatingLabel.text = project?.applicationStatus == false ? "Не закончено" : "Закончено"
        cell.payImage.image = project?.isPayment == false ? UIImage(named: "nopaid") : UIImage(named: "paid")
        cell.paylabel.text = project?.isPayment == false ? "Не оплачено" : "Оплачено"
        if let image = self.networkService.getImage(from: (project?.applicationIcoUrl)!) {
            cell.projectImage.image = image
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let link = projectResponse?.data[indexPath.row]
        
        let vc = SFSafariViewController(url: URL(string: (link?.applicationUrl)! )!)
        present(vc, animated: true)
    }
    
}

