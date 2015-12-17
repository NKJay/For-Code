//
//  DatePickerViewController.swift
//  Gank
//
//  Created by Findys on 15/12/16.
//  Copyright © 2015年 GeekTeen. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        let date = NSDate()
        datePicker.maximumDate = date
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirm(sender: AnyObject) {
        let dateformater = NSDateFormatter()
        dateformater.dateFormat = "EEE"
        let day = dateformater.stringFromDate(datePicker.date)
        if day == "Sat"||day == "Sun"{
            self.notice("周末休息", type: NoticeType.info, autoClear: true)
        }else{
            ifrefresh = true
            Date = datePicker.date
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        datePicker.date = Date
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
