//
//  ViewController.swift
//  Ch15_CameraPhotoLibrary
//
//  Created by 손상준 on 2021/01/07.
//

import UIKit
//카메라와 포토 라이브러리를 사용하기 위한 헤더파일
import MobileCoreServices

//컨트롤러와 이 컨트롤러를 사용하기 위한 델리게이트 프로토콜 추가
class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    //UIImagePickerController의 인스턴스 변수 생성
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    //촬영을 하거나 포토 라이브러리에서 불러온 사진을 저장할 변수
    var captureImage: UIImage!
    //녹화한 비디오의 URL을 저장할 변수
    var videoURL: URL!
    //이미지 저장 여부를 나타낼 변수
    var flagImageSave = false
    
    @IBOutlet var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //사진 촬영
    @IBAction func btnCaptureImageFromCamera(_ sender: UIButton) {
        //카메라의 사용 가능 여부를 확인, 사용할 수 있는 경우에만 아래의 코드를 실행
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
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
    //사진 불러오기
    @IBAction func btnLoadImageFromLibrary(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
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
    //비디오 촬영
    @IBAction func btnRecordVideoFromCamera(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)) {
            flagImageSave = true
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            myAlert("Camera inaccessalbe", message: "Application cannot access the camera")
        }
    }
    //비디오 불러오기
    @IBAction func btnLoadVideoFromLibrary(_ sender: UIButton) {
        if(UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            flagImageSave = false
            
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
        else {
            myAlert("Photo album inaccessable", message: "Application cannot access the photo album")
        }
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
            
            imgView.image = captureImage
        }
        //미디어의 종류가 비디오인 경우
        else if mediaType.isEqual(to: kUTTypeMovie as NSString as String) {
            //flagImageSave가 true인 경우, 촬영한 비디오를 가져와 포토라이브러리에 저장
            if flagImageSave {
                videoURL = (info[UIImagePickerController.InfoKey.mediaURL] as! URL)
                
                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
            }
            
            //현재의 뷰 컨트롤러를 제거하고, 초기 뷰를 보여줌
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //사용자가 사진이나 비디오를 찍지 않고 취소하거나, 선택하지 않고 취소를 하는 경우 호출되는 메서드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

