//
//  ConfigurationViewController.swift
//  Delegate Task Four
//
//  Created by Ivan Behichev on 27.12.2022.
//

import UIKit

protocol ConfigurationViewControllerDelegate {
    func sendMessageToLabel(message: String)
    func switchStateDidChange(state: Bool, index: Int)
}

class ConfigurationViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var superViewCollection: UIView!
    @IBOutlet weak var configurationTextField: UITextField!
    @IBOutlet weak var configurationTableView: UITableView!
    @IBOutlet weak var configurationCollectionView: UICollectionView!
    
    var delegate: ConfigurationViewControllerDelegate?
    
    //MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationCollectionView.delegate = self
        configurationCollectionView.dataSource = self
        configurationCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        configurationTextField.delegate = self
        configurationTableView.delegate = self
        configurationTableView.dataSource = self
    }
    
    //MARK: - Actions
    
    @IBAction private func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

//MARK: - UICollectionViewDelegate

extension ConfigurationViewController: UICollectionViewDelegate {
    
}

//MARK: - UICollectionViewDataSource

extension ConfigurationViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.Identifieers.Cells.collectionView, for: indexPath) as? СonfigurationCollectionViewCell {
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ConfigurationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = 44.0
        let width = collectionView.bounds.width
        let witdhCell = width/1 - collectionView.contentInset.left - collectionView.contentInset.right
        let size = CGSize(width: witdhCell, height: height)
        return size
    }
}

//MARK: - UITextFieldDelegate

extension ConfigurationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        configurationTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.sendMessageToLabel(message: text)
        }
    }
}


//MARK: - UITableViewDataSorce

extension ConfigurationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate

extension ConfigurationViewController: UITableViewDelegate {
    
}
