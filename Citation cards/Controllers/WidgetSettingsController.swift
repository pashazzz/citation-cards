//
//  WidgetSettingsController.swift
//  Citation cards
//
//  Created by Pavlo Malyshkin on 22.1.2024.
//

import UIKit

class WidgetSettingsController: UITableViewController {
    @IBOutlet var interval: UILabel!
    @IBOutlet var tags: UILabel!
    @IBOutlet var onlyFavourites: UISwitch!

    let settings = Settings()
    
    let formatter = DateComponentsFormatter()
    
    @objc private func onOnlyFavouritesChanged(_ onlyFavouritesSwitch: UISwitch) {
        settings.setWidgetOnlyFavourites(val: onlyFavouritesSwitch.isOn)
    }

    @IBAction func selectInterval() {
        let oldIntervalValue = settings.getWidgetUpdateInterval()
        let heightForPicker = "\n\n\n\n\n\n\n\n\n\n"
        let sheet = UIAlertController(title: "Set interval\(heightForPicker)", message: nil, preferredStyle: .alert)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.minuteInterval = 5
        datePicker.countDownDuration = oldIntervalValue
        datePicker.frame = CGRectMake(0, 24, 260, 250)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [self] _ in
            settings.setWidgetUpdateInterval(interval: oldIntervalValue)
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { [self] _ in
            settings.setWidgetUpdateInterval(interval: datePicker.countDownDuration)
            interval.text = formatter.string(from: datePicker.countDownDuration)
        }
        
        sheet.addAction(cancelAction)
        sheet.addAction(okAction)
        sheet.view.addSubview(datePicker)
        
        present(sheet, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onlyFavourites.addTarget(self, action: #selector(onOnlyFavouritesChanged(_:)), for: .valueChanged)
        
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [.hour, .minute]
        
        navigationItem.title = "Widget Settings"
        
        let intervalVal = settings.getWidgetUpdateInterval()
        interval.text = formatter.string(from: intervalVal)
        onlyFavourites.isOn = settings.getWidgetOnlyFavourites()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
