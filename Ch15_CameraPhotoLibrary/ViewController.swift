//
//  ViewController.swift
//  Ch15_Collage
//
//  Created by 손상준 on 2021/01/07.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    //UIImagePickerController의 인스턴스 변수 생성
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    //촬영을 하거나 포토 라이브러리에서 불러온 사진을 저장할 변수
    var captureImage: UIImage!
    //이미지 저장 여부를 나타낼 변수
    var flagImageSave = false
    var numImage = 0;
    
    @IBOutlet var imgViewOne: UIImageView!
    @IBOutlet var imgViewTwo: UIImageView!
    @IBOutlet var imgViewThree: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func btnCaptureImageFromCamera(_ sender: UIButton) {
        //카메라의 사용 가능 여부를 확인, 사용할 수 있는 경우에만 아래의 코드를 실행
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            //최대 3이 넘어갈 경우 다시 1로 초기화
            numImage = numImage + 1
            if numImage>3 {
                numImage = 1
            }
            
            //카메라를 촬영 후 저장할 것이므로 true
            flagImageSave = true
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            //미디어 타입을 설정
            imagePicker.mediaTypes = [kUTTypeImage as String]
            
            //현재 뷰 컨트롤러를 imagePicker로 대체함
            present(imagePicker, animated: true, completion: nil)
            
            
        }//사용할 수 없는 경우 Alert 경고 창을 나타냄
        else {
            myAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    @IBAction func btnLoadImageFromLibrary(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            numImage = numImage + 1
            if numImage>3 {
                numImage = 1
            }
            
            flagImageSave = false
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            myAlert("Photo album inaccessable", message: "Application cannot access the photo album")
        }
    }
    @IBAction func btnResetImage(_ sender: UIButton) {
        numImage = 0
        
        imgViewOne.image = nil
        imgViewTwo.image = nil
        imgViewThree.image = nil
    }
    
    //경고 표시용 메서드
    func myAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    //델리게이트 메서드 구현
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //미디어의 종류를 확인
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        //미디어의 종류가 사진일 경우
        if mediaType.isEqual(to: kUTTypeImage as NSString as String) {
            //사진을 가져와 captureImage에 저장한다.
            captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            //flagImageSave가 true일 경우, 가져온 사진을 포토라이브러리에 저장
            if flagImageSave {
                UIImageWriteToSavedPhotosAlbum(captureImage, self, nil, nil)
            }
            
            if numImage == 1 {
                imgViewOne.image = captureImage
            }
            else if numImage == 2 {
                imgViewTwo.image = captureImage
            }
            else if numImage == 3 {
                imgViewThree.image = captureImage
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    //사용자가 사진이나 비디오를 찍지 않고 취소하거나, 선택하지 않고 취소를 하는 경우 호출되는 메서드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        numImage = numImage - 1;
        if numImage<0 {
            numImage = 0
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

