//
//  SettingsViewController.swift
//  tip_calc
//
//  Created by Charles Yeh on 12/20/15.
//  Copyright © 2015 Charles Yeh. All rights reserved.
//

import UIKit

struct UserDefaultKeys {
    static let DEFAULT_TIP_INDEX = "default_tip_index"
    static let LAST_BILL_AMOUNT = "last_bill_amount"
    static let SAVED_BILL_DATE = "saved_bill_date"
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipPercentageControl: UISegmentedControl!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        tipPercentageControl.selectedSegmentIndex = defaults.integerForKey(UserDefaultKeys.DEFAULT_TIP_INDEX)
    }
    
    @IBAction func onValueChanged(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(tipPercentageControl.selectedSegmentIndex, forKey: UserDefaultKeys.DEFAULT_TIP_INDEX)
        print(defaults.integerForKey(UserDefaultKeys.DEFAULT_TIP_INDEX))
        defaults.synchronize()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
