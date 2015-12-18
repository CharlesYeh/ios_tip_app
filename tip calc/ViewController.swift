//
//  ViewController.swift
//  tip calc
//
//  Created by Charles Yeh on 12/17/15.
//  Copyright © 2015 Charles Yeh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var calcView: UIView!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipPercentageControl: UISegmentedControl!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var outputView: UIView!
    
    let TEN_MIN_SEC = 5
    let ANIMATION_DELAY = 0.2
    let PERCENTAGES = [0.18, 0.2, 0.22]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        tipPercentageControl.selectedSegmentIndex = defaults.integerForKey(UserDefaultKeys.DEFAULT_TIP_INDEX)
        
        let oldDate: NSDate? = defaults.objectForKey(UserDefaultKeys.SAVED_BILL_DATE) as! NSDate?
        if var date = oldDate {
            date = date.dateByAddingTimeInterval(NSTimeInterval(TEN_MIN_SEC))
            if date.compare(NSDate()) == .OrderedAscending {
                // if saved over 10 minutes ago, don't use saved bill amount
                billField.text = ""
            } else {
                billField.text = defaults.stringForKey(UserDefaultKeys.LAST_BILL_AMOUNT)
            }
        }
        
        billField.becomeFirstResponder()
        updateUI()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(billField.text, forKey: UserDefaultKeys.LAST_BILL_AMOUNT)
        defaults.setObject(NSDate(), forKey: UserDefaultKeys.SAVED_BILL_DATE)
        defaults.synchronize()
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        updateUI()
    }
    
    func updateUI() {
        
        if billField.text == "" {
            UIView.animateWithDuration(ANIMATION_DELAY, animations: {
                self.outputView.alpha = 0
            })
            return
        }
        
        UIView.animateWithDuration(ANIMATION_DELAY, animations: {
            self.outputView.alpha = 1
        })
        
        let bill = ((billField.text ?? "") as NSString).doubleValue
        let tipPercentage = PERCENTAGES[tipPercentageControl.selectedSegmentIndex]
        let tip = bill * tipPercentage
        
        let formatter = NSNumberFormatter();
        formatter.numberStyle = .CurrencyStyle
        formatter.stringFromNumber(bill)
        
        tipLabel.text = formatter.stringFromNumber(tip)
        totalLabel.text = formatter.stringFromNumber(bill + tip)
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

