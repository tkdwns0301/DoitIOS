//
//  ViewController.swift
//  Ch13_Audio
//
//  Created by 손상준 on 2021/01/05.
//

import UIKit
//오디오를 재생하기 위한 헤더파일과 델리게이트를 위한 import
import AVFoundation

class ViewController: UIViewController ,AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    //실행모드를 위한 변수
    var audioPlayer : AVAudioPlayer!
    var audioFile : URL!
    let MAX_VOLUME : Float = 10.0
    var progressTimer : Timer!
    let timePlayerSelector:Selector = #selector(ViewController.updatePlayTime)
    
    @IBOutlet var pvProgressPlay: UIProgressView!
    @IBOutlet var lblCurrentTime: UILabel!
    @IBOutlet var lblEndTime: UILabel!
    @IBOutlet var btnPlay: UIButton!
    @IBOutlet var btnPause: UIButton!
    @IBOutlet var btnStop: UIButton!
    @IBOutlet var slVolume: UISlider!
    
    //녹음모드를 위한 변수
    var audioRecorder : AVAudioRecorder!
    //false를 통해 초기 실행 시 녹음모드가 아닌, 재생모드로 실행
    var isRecordMode = false
    let timeRecordSelector : Selector = #selector(ViewController.updateRecordTime)
    
    @IBOutlet var btnRecord: UIButton!
    @IBOutlet var lblRecordTime: UILabel!
    
    //imageView 변수
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        selectAudioFile()
        
        if !isRecordMode{
            initPlay()
            btnRecord.isEnabled = false
            lblRecordTime.isEnabled = false
        }
        else {
            initRecord()
        }
        
    }
    
    //오디오 재생을 위한 초기화 함수
    func initPlay() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError {
            print("Error-initPlay: \(error)")
        }
        
        imageView.image = UIImage(named: "stop.png")
        slVolume.maximumValue = MAX_VOLUME
        slVolume.value = 1.0
        pvProgressPlay.progress = 0
        
        audioPlayer.delegate = self
        audioPlayer.prepareToPlay()
        audioPlayer.volume = slVolume.value
        
        //총 재생시간
        lblEndTime.text = convertNSTimeInterval2String(audioPlayer.duration)
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        
        //초기에 Play버튼을 제외한 나머지를 비활성화
        setPlayButtons(true, pause: false, stop: false)
    }
    
    func convertNSTimeInterval2String(_ time:TimeInterval) -> String {
        let min = Int(time/60)
        //time값을 60으로 나눈 나머지 값을 정수로 변환하여 sec에 값 초기화
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        //시간을 00:00으로 표시
        let strTime = String(format: "%02d:%02d", min, sec)
        
        return strTime
    }
    
    func setPlayButtons(_ play:Bool, pause: Bool, stop: Bool) {
        btnPlay.isEnabled = play
        btnPause.isEnabled = pause
        btnStop.isEnabled = stop
    }
    //button Action
    @IBAction func btnPlayAudio(_ sender: UIButton) {
        audioPlayer.play()
        setPlayButtons(false, pause: true, stop: true)
        
        imageView.image = UIImage(named: "play.png")
        progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timePlayerSelector, userInfo: nil, repeats: true)
    }
    //시간에 따라 current label과 progress에 변화를 주기위한 함수
    @objc func updatePlayTime() {
        lblCurrentTime.text = convertNSTimeInterval2String(audioPlayer.currentTime)
        pvProgressPlay.progress = Float(audioPlayer.currentTime/audioPlayer.duration)
    }
    @IBAction func btnPauseAudio(_ sender: UIButton) {
        audioPlayer.pause()
        imageView.image = UIImage(named: "pause.png")
        setPlayButtons(true, pause: false, stop: true)
    }
    @IBAction func btnStopAudio(_ sender: UIButton) {
        audioPlayer.stop()
        initPlay()
        setPlayButtons(true, pause: false, stop: false)
    }
    
    //Volume slider Action
    @IBAction func slChangeVolume(_ sender: UISlider) {
        audioPlayer.volume = slVolume.value
    }
    
    //오디오 재생이 끝나면 맨 처음 상태로 돌아가기 위한 함수
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        //타이머 무효화
        progressTimer.invalidate()
        //play버튼 활성화, 나머지 비활성화
        setPlayButtons(true, pause: false, stop: false)
    }
    
    
    @IBAction func swRecordMode(_ sender: UISwitch) {
        if sender.isOn {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
            lblRecordTime!.text = convertNSTimeInterval2String(0)
            isRecordMode = true
            btnRecord.isEnabled = true
            lblRecordTime.isEnabled = true
        }
        else {
            isRecordMode = false
            btnRecord.isEnabled = false
            lblRecordTime.isEnabled = false
            lblRecordTime.text = convertNSTimeInterval2String(0)
        }
        
        selectAudioFile()
        
        if !isRecordMode {
            initPlay()
        }
        else {
            initRecord()
        }
    }
    @IBAction func btnRecord(_ sender: UIButton) {
        if(sender as AnyObject).titleLabel?.text == "Record" {
            audioRecorder.record()
            (sender as AnyObject).setTitle("Stop", for: UIControl.State())
            progressTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: timeRecordSelector, userInfo: nil, repeats: true)
        }
        else {
            audioRecorder.stop()
            progressTimer.invalidate()
            (sender as AnyObject).setTitle("Record", for: UIControl.State())
            btnPlay.isEnabled = true
            initPlay()
        }
    }
    
    @objc func updateRecordTime() {
        lblRecordTime.text = convertNSTimeInterval2String(audioRecorder.currentTime)
    }
    
    //녹음모드 초기화를 위한 함수
    func initRecord() {
        let recordSettings = [
            //format = Apple Lossless
            AVFormatIDKey : NSNumber(value: kAudioFormatAppleLossless as UInt32),
            //음질 최대
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue,
            //비트율 '320,000bps'
            AVEncoderBitRateKey : 320000,
            //오디오 채널 '2'
            AVNumberOfChannelsKey : 2,
            //샘플률 '44,100Hz'
            AVSampleRateKey : 44100.0
        ] as [String : Any]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFile, settings: recordSettings)
        }
        catch let error as NSError {
            print("Error-initRecord : \(error)")
        }
        
        audioRecorder.delegate = self
        
        imageView.image = UIImage(named: "record.png")
        slVolume.value = 1.0
        audioPlayer.volume = slVolume.value
        lblEndTime.text = convertNSTimeInterval2String(0)
        lblCurrentTime.text = convertNSTimeInterval2String(0)
        setPlayButtons(false, pause: false, stop: false)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch let error as NSError{
            print(" Error-setCategory : \(error)")
        }
        
        do {
            try session.setActive(true)
        }
        catch let error as NSError{
            print(" Error-setActive : \(error)")
        }
        
        
    }
    //녹음파일 생성 함수
    func selectAudioFile() {
        //녹음모드가 아닐 때, 재생모드를 실행
        if !isRecordMode {
            audioFile = Bundle.main.url(forResource: "Sicilian_Breeze", withExtension: "mp3")
        }
        else {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            audioFile = documentDirectory.appendingPathComponent("recordFile.m4a")
            
        }
    }
}

