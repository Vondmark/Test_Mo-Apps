//
//  CollectionViewController.swift
//  Test_Mo'Apps
//
//  Created by Mark on 17.05.2020.
//  Copyright © 2020 Mark. All rights reserved.
//

import UIKit
import SafariServices


class CollectionViewController: UICollectionViewController {

    let itemPerRow: CGFloat = 2
    let sectionsInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    var userToken: String?
    var projectResponse: ProjectResponse? = nil
    let networkService = NetworkingService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        request()
        print("usertoken", userToken!)
        setupTableView()
    }
    
    
    
    func setupTableView() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bgr"), for: .default)
        collectionView.backgroundView = UIImageView(image: UIImage(named: "bgr"))
    }

    func setupLayout () {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 70, height: 30)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1

        collectionView.showsVerticalScrollIndicator = false
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return projectResponse?.data.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "projectCell", for: indexPath) as! CollectionViewCell
        let project = projectResponse?.data[indexPath.row]
        cell.backgroundColor = .lightGray
        cell.nameOfProject.text = project?.applicationName
        cell.isReadyLabel.text = project?.applicationStatus == false ? "Не закончено" : "Закончено"
        cell.isReady.image = project?.applicationStatus == false ? UIImage(named: "noFinished") :
        UIImage(named: "finished")
        if let image = self.networkService.getImage(from: (project?.applicationIcoUrl)!) {
            cell.projectImageView.image = image
        }
    
        return cell
    }
    
    func request() {
        let urlString = "https://html5.mo-apps.com/api/application"
        let parameters = ["skip":"0", "take":"1000", "osType":"0","userToken": userToken!]
        self.networkService.projectRequest(urlString: urlString, parameters: parameters) { [weak self](result) in
            switch result {
            case .success(let projectResponse):
                self?.projectResponse = projectResponse
                self?.collectionView.reloadData()
                
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let link = projectResponse?.data[indexPath.row]
        
        let vc = SFSafariViewController(url: URL(string: (link?.applicationUrl)! )!)
        present(vc, animated: true)
    }
    
    

}





extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingWidth = sectionsInserts.left * (itemPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemPerRow
        return CGSize(width: widthPerItem, height: widthPerItem*1.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionsInserts
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionsInserts.left
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionsInserts.left
    }
}
