//
//  ArKitViewController.swift
//  AlarmProject
//
//  Created by Магомед Абдуразаков on 24.02.2020.
//  Copyright © 2020 Магомед Абдуразаков. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import RealmSwift

class ArKitViewController: UIViewController,ARSCNViewDelegate {
    
    // MARK: - Public Properties
    
    let configuration = ARWorldTrackingConfiguration()
    var label: UILabel!
    var image: UIImageView!
    var sceneView: ARSCNView!
    var timer: Timer!
    static var data = Data()
    static var index = Int()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
        setupWindow()
        editProperties()
        
        // Set the view's delegate
        
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        
        sceneView.showsStatistics = true
        
        let realm = try! Realm()
        var alarmsList = realm.objects(Alarm.self)
        alarmsList = alarmsList.sorted(byKeyPath: "date", ascending: true)
        
        print("dasdasd")
        
        loadDynamicImageReferences()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //     Create a session configuration
        
        
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        
        sceneView.showsStatistics = false
        
        //     Run the view's session
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        
        sceneView.session.pause()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    // MARK: - Private Methods
    
    private func loadDynamicImageReferences(){
        //1. Get The Image From The Folder
        //   if ArKitViewController.data == nil  {print("изображение не передается")}
        
        guard let imageFromBundle = UIImage(data: ArKitViewController.data),
            //2. Convert It To A CIImage
            let imageToCIImage = CIImage(image: imageFromBundle),
            //3. Then Convert The CIImage To A CGImage
            let cgImage = convertCIImageToCGImage(inputImage: imageToCIImage) else { return }
        
        //4. Create An ARReference Image (Remembering Physical Width Is In Metres)
        let arImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.2)
        
        //5. Name The Image
        arImage.name = "CGImage Test"
        configuration.detectionImages = [arImage]
        print(ArKitViewController.data)
        image.image = UIImage(data: ArKitViewController.data)
        //5. Set The ARWorldTrackingConfiguration Detection Images
    }
    
    private func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        let context = CIContext(options: nil)
        
        if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
            return cgImage
        }
        
        return nil
    }
    
    private func initViews() {
        
        self.label = UILabel()
        self.image = UIImageView()
        self.sceneView = ARSCNView()
        
        label?.translatesAutoresizingMaskIntoConstraints = false
        image?.translatesAutoresizingMaskIntoConstraints = false
        sceneView?.translatesAutoresizingMaskIntoConstraints = false
        
        image?.backgroundColor = UIColor.white
        
        view.addSubview(label!)
        view.addSubview(sceneView!)
        view.addSubview(image!)
        
    }
    
    private func setupWindow(){
        
        let labelTopConstraint = NSLayoutConstraint(item: label!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: view.bounds.height/6)
        
        let labelRightConstraint = NSLayoutConstraint(item: label!, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 0.05, constant: view.bounds.width * 0.05)
        
        let labelLeftConstraint = NSLayoutConstraint(item: label!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: view.bounds.width * 0.05)
        
        let labelPosition = NSLayoutConstraint(item: label!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let imageHeight = NSLayoutConstraint(item: image!, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: view.bounds.height/2)
        
        let imageWidth = NSLayoutConstraint(item: image!, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: view.bounds.width * 0.8)
        
        let imageCenterXConstraint = NSLayoutConstraint(item: image!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let imageCenterYConstraint = NSLayoutConstraint(item: image!, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0)
        
        let sceneViewHeight = NSLayoutConstraint(item: sceneView!, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: view.bounds.height/2)
        
        let sceneViewWidth = NSLayoutConstraint(item: sceneView!, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: view.bounds.width * 0.8)
        
        let sceneViewCenterXConstraint = NSLayoutConstraint(item: sceneView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let sceneViewCenterYConstraint = NSLayoutConstraint(item: sceneView!, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0)
        
        self.view.addConstraints([imageHeight, imageWidth, imageCenterXConstraint, imageCenterYConstraint, sceneViewHeight, sceneViewWidth, sceneViewCenterXConstraint, sceneViewCenterYConstraint, labelTopConstraint, labelPosition, labelRightConstraint, labelLeftConstraint])
    }
    
    private func editProperties() {
        label.text = NSLocalizedString("Наведите чтобы выключить будильник", comment: "arkit")
        label.font = label.font.withSize(17)
        label.lineBreakMode = .byWordWrapping 
        label.numberOfLines = 0
        label.textAlignment = .center
        
        image.alpha = 0.3
    }
    
    // Public Method
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARImageAnchor else {return} // распознаем изображение которое лежит в нашей папке "AR Resources"
        print("Обнаружено")
        
        DispatchQueue.main.async { // Correct
            self.label.text = NSLocalizedString("Будильник выключен, переход на главный экран", comment: "alarm off")
            Notification.shared.stopAlarms(ArKitViewController.index)
            self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.timerFunc), userInfo: nil, repeats: false)
        }
        
    }
    
    
    // MARK: - Objc Method
    
    @objc func timerFunc(timer: Timer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "444")
        var backgroundTask = UIApplication.shared.beginBackgroundTask()
        
        UIApplication.shared.keyWindow?.rootViewController = vc1
        UserDefaults.standard.set(true, forKey: "status")
        print(timer.timeInterval.binade)
        
        if backgroundTask != UIBackgroundTaskIdentifier.invalid {
            if UIApplication.shared.applicationState == .active {
                UIApplication.shared.endBackgroundTask(backgroundTask)
                backgroundTask = UIBackgroundTaskIdentifier.invalid
            }
            
        }
        
    }
    
}

