//
//  ViewController.swift
//  Ch11_Navigation
//
//  Created by 손상준 on 2021/01/01.
//

import UIKit

class ViewController: UIViewController, EditDelegate {
    let imgOn = UIImage(named: "lamp-on.png")
    let imgOff = UIImage(named: "lamp-off.png")
    
    var isOn = true
    var isZoom = false
    var orgZoom = false
    
    @IBOutlet var txMessage: UITextField!
    @IBOutlet var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imgView.image = imgOn
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let editviewController = segue.destination as! EditViewController
        
        if segue.identifier == "editButton" {
            editviewController.textWayValue = "segue : use button"
        }
        else if segue.identifier == "editBarButton" {
            editviewController.textWayValue = "segue : use Bar button"
        }
        
        editviewController.textMessage = txMessage.text!
        editviewController.isOn = isOn
        editviewController.delegate = self
        editviewController.isZoom = orgZoom
    }
    
    func didMessageEditDone(_ controller: EditViewController, message: String) {
        txMessage.text = message
    }
    
    func didImageOnOffDone(_ controller: EditViewController, isOn: Bool) {
        if isOn {
            imgView.image = imgOn
            self.isOn = true
        }
        else {
            imgView.image = imgOff
            self.isOn = false
        }
    }
    
    func didImageZoomDone(_ controller: EditViewController, isZoom: Bool) {
        let scale:CGFloat = 2.0
        var newWidth:CGFloat, newHeight: CGFloat
        
        if isZoom {
            if orgZoom {
                
            }
            else {
                self.isZoom = false
                self.orgZoom = true
                newWidth = imgView.frame.width*scale
                newHeight = imgView.frame.width*scale
                imgView.frame.size = CGSize(width: newWidth, height: newHeight)
            }
            
        }
        else {
            if orgZoom{
                self.isZoom = true
                self.orgZoom = false
                newWidth = imgView.frame.width/scale
                newHeight = imgView.frame.height/scale
                imgView.frame.size = CGSize(width: newWidth, height: newHeight)
            }
            else{
                
            }
        }
        
        
    }
}

