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
    
    let TEN_MIN_SEC =  60 * 10
    let ANIMATION_DELAY = 0.2
    let PERCENTAGES = [0.18, 0.2, 0.22]
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appCameToForeground:", name:UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "appSentToBackground:", name:UIApplicationWillResignActiveNotification, object: nil)
        
        loadBillAmount()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        tipPercentageControl.selectedSegmentIndex = defaults.integerForKey(UserDefaultKeys.DEFAULT_TIP_INDEX)
        
        billField.becomeFirstResponder()
        updateUI()
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        updateUI()
    }
    
    @IBAction func onTap(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func appCameToForeground(notification: NSNotification) {
        loadBillAmount()
    }
    
    func appSentToBackground(notification: NSNotification) {
        saveBillAmount()
    }
    
    func saveBillAmount() {
        // Saves current bill amount for later loading.
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(billField.text, forKey: UserDefaultKeys.LAST_BILL_AMOUNT)
        defaults.setObject(NSDate(), forKey: UserDefaultKeys.SAVED_BILL_DATE)
        defaults.synchronize()
    }
    
    func loadBillAmount() {
        // Loads previous bill amount, but defaults to "" if it was saved >10 min ago.
        let defaults = NSUserDefaults.standardUserDefaults()
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
        
        updateUI()
    }
    
    func updateUI() {
        if billField.text == "" {
            // hide tip / total
            UIView.animateWithDuration(ANIMATION_DELAY, animations: {
                self.outputView.alpha = 0
            })
            return
        }
        
        // populate tip / total labels
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
}

