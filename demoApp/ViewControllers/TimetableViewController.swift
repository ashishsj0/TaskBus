//
//  ViewController.swift
//  demoApp
//
//  Created by Ashish Sharma on 05.07.21.
//

import UIKit

class TimetableViewController: UIViewController {
    
    @IBOutlet weak var timetableTableView: UITableView!
    
    var timeTableViewModel: TimeTableControllerViewModel!
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.setupBinding()
       
    }
    
    private func setup() {
        self.timetableTableView.dataSource = self
        self.timetableTableView.delegate = self
        self.timeTableViewModel = TimeTableControllerViewModel()
        self.timeTableViewModel.setSearchingCity(.berlin)
        self.timetableTableView.register(UINib(nibName: "TimetableTableViewCell", bundle: nil), forCellReuseIdentifier: "TimetableTableViewCell")
        activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped =  true
    
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: activityIndicator), animated: true)
    }
    
    private func setupBinding() {
        
        self.timeTableViewModel.tableDataSource.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.timetableTableView.reloadData()
                self?.navigationItem.title = self?.timeTableViewModel.getCurrentCityTitle()
            }
        }
        
        self.timeTableViewModel.currentRequestState.bind { [weak self] state in
            
            switch state {
            case .done:
                self?.showLoader(show: false)
                
            case .failedWithError(let err):
                self?.showLoader(show: false)
                self?.showError(err)
                
            case .loading:
                self?.showLoader(show: true)
                
            case .none:
                break
            }
        }
    }
    
    // could be an extension of UIView or UIViewController but is right for this use case.
    
    private func showLoader(show: Bool = false) {
        DispatchQueue.main.async {
            if show {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func showError(_ err: Error) {
        
        DispatchQueue.main.async {
            
            if self.presentedViewController == nil {
            
                let alert = UIAlertController.init(title: (err as? FlixError)?.title ?? "Error", message: (err as? FlixError)?.description ?? "Internal Error", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction.init(title: "Ok", style: .default, handler: { _ in  }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
  
    @IBAction func citySelectionChanged(_ sender: UISegmentedControl) {
        
        // for changing arrival/departure
        
        if sender.tag == 1 {
            self.timeTableViewModel.setOrderBasedOnArrivalTime(sender.selectedSegmentIndex == 1)
        }
        
        // for changing city
        
        else {
            self.timeTableViewModel.setSearchingCity(sender.selectedSegmentIndex == 0 ? .berlin : .munich)
        }
    }

    
}

//MARK: TABLE VIEW DATASOURCE/DELEGATE

extension TimetableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return timeTableViewModel.getNumberOfSections() > 0 ? timeTableViewModel.getNumberOfSections() : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeTableViewModel.getNumberOfRows(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimetableTableViewCell") as! TimetableTableViewCell
        
        if let model = self.timeTableViewModel.getItemAtIndex(indexPath) {
            cell.setup(TimetableTableViewCellViewModel.init(data: model))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.timeTableViewModel.getTitleForSection(section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        return self.timeTableViewModel.getFooterForSection(section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension 
    }
    
}
