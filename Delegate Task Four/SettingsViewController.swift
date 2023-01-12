//
//  ConfigurationViewController.swift
//  Delegate Task Four
//
//  Created by Ivan Behichev on 27.12.2022.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func sendMessageToLabel(message: String)
    func switchStateDidChange(state: Bool, index: Int)
}

class SettingsViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak private var superViewForStackView: UIView!
    @IBOutlet weak private var superViewForCollection: UIView!
    @IBOutlet weak private var superViewForTableView: UIView!
    @IBOutlet weak private var settingsTextField: UITextField!
    @IBOutlet weak private var settingsTableView: UITableView!
    @IBOutlet weak private var settingsCollectionView: UICollectionView!
    @IBOutlet weak private var settingsStackView: UIStackView!
    @IBOutlet weak private var setupSegmentedControl: UISegmentedControl!
    
    var delegate: SettingsViewControllerDelegate?
    
    //MARK: - Variables
    
    private var items: [ItemState] = []
    private var cellTitle = ""
    private var myView: SettingsView?
    private var firstScreenArrayOfStates: [Bool] = []
    private var textForTexfield: String?
    private var cellsState: [Int] = []
    
    //MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTextField.delegate = self
        setupUI(selectedIndex: setupSegmentedControl.selectedSegmentIndex)
        
        if let textForTexfield {
            settingsTextField.text = textForTexfield
        }
    }
    
    //MARK: - Functions
    
    func configure(with configuration: SettingsViewControllerConfiguration) {
        firstScreenArrayOfStates = configuration.bunchOfSwiftStates
        textForTexfield = configuration.textForTexfield
        items = transformStateArrayToStruct(array: firstScreenArrayOfStates)
    }
    
    private func transformStateArrayToStruct(array: [Bool]) -> [ItemState] {
        
        let transformedArray = array.enumerated().map ({ (index, element) in
            if element {
                cellTitle = "On"
            } else {
                cellTitle = "Off"
            }
            return ItemState(id: index, state: element, cellTitle: cellTitle)
        })
        return transformedArray
    }
    
    private func setupUI(selectedIndex: Int) {
        superViewForTableView.isHidden = true
        superViewForCollection.isHidden = true
        superViewForStackView.isHidden = true
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(UINib(nibName: AppConstants.Identifiers.Nibs.tableViewCellNib, bundle: nil),
                                   forCellReuseIdentifier: AppConstants.Identifiers.Cells.tableView)
        
        settingsCollectionView.dataSource = self
        settingsCollectionView.delegate = self
        settingsCollectionView.register(UINib(nibName: AppConstants.Identifiers.Nibs.collectionViewCellNib, bundle: nil),
                                        forCellWithReuseIdentifier: AppConstants.Identifiers.Cells.collectionView)
        settingsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        for item in items {
            if let myView = UINib.init(nibName: AppConstants.Identifiers.Nibs.uiViewNib, bundle: nil).instantiate(withOwner: self)[0] as? SettingsView {
                settingsStackView.addArrangedSubview(myView)
                myView.configure(with: item)
                myView.delegate = self
                myView.backgroundColor = .systemMint
            }
        }
        
        switch selectedIndex {
            
        case 0:
            superViewForTableView.isHidden = false
            settingsTableView.backgroundColor = .systemOrange
            view.backgroundColor = .systemOrange
            
        case 1:
            superViewForCollection.isHidden = false
            settingsCollectionView.backgroundColor = .systemPurple
            view.backgroundColor = .systemPurple
            
        case 2:
            superViewForStackView.isHidden = false
            settingsStackView.backgroundColor = .systemMint
            view.backgroundColor = .systemMint
            
        default:
            break
        }
    }
    
    private func updateUI(with index: Int) {
        
        let selectedIndex = setupSegmentedControl.selectedSegmentIndex
        
        switch  selectedIndex {
            
        case 0:
            settingsCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            let subRange = settingsStackView.arrangedSubviews[index] as? SettingsView
            subRange?.configure(with: items[index])
            
        case 1:
            settingsTableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
            let subRange = settingsStackView.arrangedSubviews[index] as? SettingsView
            subRange?.configure(with: items[index])
            
        case 2:
            settingsTableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
            settingsCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            
        default:
            break
        }
    }
    
    //MARK: - Actions
    
    @IBAction private func uiStateChanged(_ sender: UISegmentedControl) {
        setupUI(selectedIndex: sender.selectedSegmentIndex)
        
        for cellState in cellsState {
            updateUI(with: cellState)
        }
    }
    
    @IBAction private func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

//MARK: - UICollectionViewDataSource

extension SettingsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.Identifiers.Cells.collectionView, for: indexPath) as? SettingsCollectionViewCell {
            cell.delegate = self
            let item = items[indexPath.item]
            cell.configure(with: item)
            return cell
        }
        return UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
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

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        settingsTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            delegate?.sendMessageToLabel(message: text)
        }
    }
}


//MARK: - UITableViewDataSorce

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.Identifiers.Cells.tableView, for: indexPath) as? SettingsTableViewCell {
            cell.delegate = self
            let item = items[indexPath.row]
            cell.configure(with: item)
            return cell
        }
        return UITableViewCell()
    }
}

//MARK: - UITableViewDelegate

extension SettingsViewController: UITableViewDelegate {
}

//MARK: - SwitchStatmentDelegate

extension SettingsViewController: SwitchStatmentDelegate {
    func changeSwitchState(index: Int, switchState: Bool) {
        firstScreenArrayOfStates[index] = switchState
        items = transformStateArrayToStruct(array: firstScreenArrayOfStates)
        delegate?.switchStateDidChange(state: switchState, index: index)
        updateUI(with: index)
        cellsState.append(index)
    }
}
