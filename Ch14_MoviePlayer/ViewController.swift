//
//  ViewController.swift
//  Ch14_VideoPlayerMission
//
//  Created by 손상준 on 2021/01/06.
//

import UIKit
//비디오 관련 헤더파일
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnPlayInternalMovieMp4(_ sender: UIButton) {
        //비디오가 저장된 앱 내부의 파일 경로를 받아오기
        let filePath:String? = Bundle.main.path(forResource: "FastTyping", ofType: "mp4")
        //앱 내부의 파일명을 NSURL 형식으로 변경
        let url = NSURL(fileURLWithPath: filePath!)
        
        playVideo(url: url)
    }
    
    @IBAction func btnPlayInternalMovieMov(_ sender: UIButton) {
        //비디오가 저장된 앱 내부의 파일 경로를 받아오기
        let filePath:String? = Bundle.main.path(forResource: "Mountaineering", ofType: "mov")
        //앱 내부의 파일명을 NSURL 형식으로 변경
        let url = NSURL(fileURLWithPath: filePath!)
        
        playVideo(url: url)
    }
    
    @IBAction func btnPlayExternalMovieMp4(_ sender: UIButton) {
        //앱 외부의 파일명을 NSURL 형식으로 변경
        let url = NSURL(string: "https://dl.dropboxusercontent.com/s/e38auz050w2mvud/Fireworks.mp4")!
        
        playVideo(url: url)
    }
    @IBAction func btnPlayExternalMovieMov(_ sender: UIButton) {
        //앱 외부의 파일명을 NSURL 형식으로 변경
        let url = NSURL(string: "https://dl.dropboxusercontent.com/s/ijybpprsmx0bgre/Seascape.mov")!
        
        playVideo(url: url)
    }
    
    private func playVideo(url: NSURL) {
        //AVPlayerViewController의 인스턴스를 생성
        let playerController = AVPlayerViewController()
        //앞에서 얻은 비디오 URL로 초기화된 AVPlayer의 인스턴스를 생성
        let player = AVPlayer(url: url as URL)
        
        //AVPlayerController의 player속성에 앞에서 생성한 인스턴스를 할당
        playerController.player = player
        //비디오를 재생
        self.present(playerController, animated: true) {
            player.play()
        }
    }
}

