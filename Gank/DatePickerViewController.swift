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
    
    var changeDate:((date:String)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = NSDate()
        
        datePicker.maximumDate = date
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func confirm(sender: AnyObject) {
        
        let dateformater = NSDateFormatter()
        
        dateformater.dateFormat = "EEE"
        
        let day = NSCalendar(calendarIdentifier: NSCalendarIdentifierChinese)!.components(NSCalendarUnit.Weekday, fromDate: datePicker.date).weekday
        
//        如果今天是周六或周日则不获取数据
        if day == 1||day == 7{
            
            self.notice("周末休息", type: NoticeType.info, autoClear: true)
            
        }else{
            
            dateformater.dateFormat = "yyyy/MM/dd"
            
            let day = dateformater.stringFromDate(self.datePicker.date)
            
            self.changeDate!(date: day)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        datePicker.date = Date
    }


}
