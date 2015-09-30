//
//  WebViewController.swift
//  Social
//
//  Created by Matthew Lee on 23/05/2015.
//  Copyright (c) 2015 Matthew Lee. All rights reserved.
//

import UIKit
import WebKit

protocol WebViewControllerDelegate {
    func webViewController(dvc: WebViewController, contact: Contact)
}


class WebViewController: UIViewController, UITextFieldDelegate {
    
    //Variable for webView
    var webView: WKWebView!
    var contact: Contact!
    var delegate: WebViewControllerDelegate!

    
    //Textfeild to enter URL
    @IBOutlet weak var url_textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set webview within bounds of view
        webView = WKWebView(frame: view.bounds)
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        view.addSubview(webView)
        //Set Top, Height and Width constraints and add them to view
        let widthConstraint = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        
        let heightConstraint = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0)
        
        let topConstraint = NSLayoutConstraint(item: webView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 50)
        
        view.addConstraint(widthConstraint)
        view.addConstraint(heightConstraint)
        view.addConstraint(topConstraint)
        
        //Set delegate of url textfield
        url_textField.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let url = NSURL(string: contact.sites[0].identifier){
            let urlRequest = NSURLRequest(URL: url)
            webView.loadRequest(urlRequest)
            url_textField.text = contact.sites[0].identifier
        }
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        let urlstring = textField.text
        //convert entered url into NSURL
        if let url = NSURL(string: urlstring) {
            //Create web request from url
            let urlRequest = NSURLRequest(URL: url)
            //load webview
            webView.loadRequest(urlRequest)
            contact.sites[0].identifier = urlstring
            
            textField.resignFirstResponder()
        }
        
        return false
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
