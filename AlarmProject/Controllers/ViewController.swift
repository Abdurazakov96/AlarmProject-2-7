//
//  ViewController.swift
//  AlarmProject
//
//  Created by Магомед Абдуразаков on 14.12.2019.
//  Copyright © 2019 Магомед Абдуразаков. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UNUserNotificationCenterDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Public Properties
    
    var alarmTimeDatePicker: UIDatePicker!
    var image: UIImageView!
    var label: UILabel!
    var labelForDatePicker: UILabel!
    var labelForImage: UILabel!
    var labelForSound: UILabel!
    var pickerView: UIPickerView!
    var openCamera: UIButton!
    var scrollView: UIScrollView!
    var output:  ViewControllerOutputProtocol?
    var viewWithContent: UIView!
    var arrayOfAlarmsMusicForUser = ([NSLocalizedString("Барабан", comment: "sound"), NSLocalizedString("Будильник", comment: "sound"),
    NSLocalizedString("Дрель", comment: "sound"),
    NSLocalizedString("Звонок", comment: "sound"),
    NSLocalizedString("Мотоцикл", comment: "sound"),
    NSLocalizedString("Сверчок", comment: "sound"),
    NSLocalizedString("Птицы", comment: "sound"),
    NSLocalizedString("Тревога", comment: "sound")])
    var arrayOfAlarmsMusicForPrivate = ["Барабан", "Будильник",
    "Дрель", "Звонок", "Мотоцикл", "Сверчок", "Птицы", "Тревога"]
    var boolForScrollView = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmSong()
        initViews()
        createWindow()
        editProperties()
    }
    
    // MARK: - Private methods
    
    private func initViews() {
        
        self.label = UILabel()
        self.image = UIImageView()
        self.alarmTimeDatePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.pickerView = UIPickerView()
        self.labelForDatePicker = UILabel()
        self.labelForSound = UILabel()
        self.labelForImage = UILabel()
        self.openCamera = UIButton()
        self.scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 900))
        self.viewWithContent = UIView()
        
        label?.translatesAutoresizingMaskIntoConstraints = false
        image?.translatesAutoresizingMaskIntoConstraints = false
        alarmTimeDatePicker?.translatesAutoresizingMaskIntoConstraints = false
        pickerView?.translatesAutoresizingMaskIntoConstraints = false
        labelForDatePicker?.translatesAutoresizingMaskIntoConstraints = false
        labelForSound?.translatesAutoresizingMaskIntoConstraints = false
        labelForImage?.translatesAutoresizingMaskIntoConstraints = false
        openCamera?.translatesAutoresizingMaskIntoConstraints = false
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        viewWithContent?.translatesAutoresizingMaskIntoConstraints = false
        
        let saveButton = UIBarButtonItem(title: NSLocalizedString("Сохранить", comment: "Save"),
                                         style: .done,
                                         target: self,
                                         action: #selector(saveAlarm))
        
        navigationItem.rightBarButtonItem = saveButton
        
        openCamera.addTarget(.none, action: #selector(OpenCamera(_:)), for: .allTouchEvents)
        
        alarmTimeDatePicker.date = Date()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        scrollView.contentSize = viewWithContent.bounds.size
        
        view.addSubview(scrollView)
        scrollView.addSubview(viewWithContent)
        viewWithContent.addSubview(openCamera!)
        viewWithContent.addSubview(alarmTimeDatePicker!)
        viewWithContent.addSubview(image!)
        viewWithContent.addSubview(pickerView!)
        viewWithContent.addSubview(labelForDatePicker!)
        viewWithContent.addSubview(labelForSound!)
        viewWithContent.addSubview(labelForImage!)
    }
    
    private func createWindow(){
        
        let scrollViewTopConstraint = NSLayoutConstraint(item: scrollView!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0 )
        
        let scrollViewRightConstraint = NSLayoutConstraint(item: scrollView!, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0)
        
        let scrollViewLeftConstraint = NSLayoutConstraint(item: scrollView!, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0)
        
        let scrollViewBottomConstraint = NSLayoutConstraint(item: scrollView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        let scrollViewWidth = NSLayoutConstraint(item: scrollView!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0)
        
        let viewWithContentTopConstraint = NSLayoutConstraint(item: viewWithContent!, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1.0, constant: 0 )
        
        let viewWithContentBottomConstraint = NSLayoutConstraint(item: viewWithContent!, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1.0, constant: 0 )
        
        let viewWithContentRightConstraint = NSLayoutConstraint(item: viewWithContent!, attribute: .right, relatedBy: .equal, toItem: scrollView, attribute: .right, multiplier: 1.0, constant: 0)
        
        let viewWithContenLeftConstraint = NSLayoutConstraint(item: viewWithContent!, attribute: .left, relatedBy: .equal, toItem: scrollView, attribute: .left, multiplier: 1.0, constant: 0)
        
        let viewWithContentWidth = NSLayoutConstraint(item: viewWithContent!, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1.0, constant: 0)
        
        let labelForDatePickerTopConstraint = NSLayoutConstraint(item: labelForDatePicker!, attribute: .top, relatedBy: .equal, toItem: viewWithContent, attribute: .top, multiplier: 1.0, constant: 10 )
        
        let labelForDatePickerRightConstraint = NSLayoutConstraint(item: labelForDatePicker!, attribute: .right, relatedBy: .equal, toItem: viewWithContent, attribute: .right, multiplier: 1.0, constant: viewWithContent.bounds.width * 0.05)
        
        let labelForDatePickerLeftConstraint = NSLayoutConstraint(item: labelForDatePicker!, attribute: .left, relatedBy: .equal, toItem: viewWithContent, attribute: .left, multiplier: 1.0, constant: viewWithContent.bounds.width * 0.05)
        
        let labelForDatePickerPosition = NSLayoutConstraint(item: labelForDatePicker!, attribute: .centerX, relatedBy: .equal, toItem: viewWithContent, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let alarmTimeDatePickerTopConstraint = NSLayoutConstraint(item: alarmTimeDatePicker!, attribute: .top, relatedBy: .equal, toItem: self.labelForDatePicker, attribute: .bottom, multiplier: 1.0, constant: 0 )
        
        let alarmTimeDatePickerPosition = NSLayoutConstraint(item: alarmTimeDatePicker!, attribute: .centerX, relatedBy: .equal, toItem: viewWithContent, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let alarmTimeDatePickerHeight = NSLayoutConstraint(item: alarmTimeDatePicker!, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .height, multiplier: 1.0, constant: 120)
        
        let alarmTimeDatePickerWidth = NSLayoutConstraint(item: alarmTimeDatePicker!, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 140)
        
        let labelForSoundTopConstraint = NSLayoutConstraint(item: labelForSound!, attribute: .top, relatedBy: .equal, toItem: self.alarmTimeDatePicker, attribute: .bottom, multiplier: 1.0, constant: 0 )
        
        let labelForSoundRightConstraint = NSLayoutConstraint(item: labelForSound!, attribute: .right, relatedBy: .equal, toItem: viewWithContent, attribute: .right, multiplier: 1.0, constant: viewWithContent.bounds.width * 0.05)
        
        let labelForSoundLeftConstraint = NSLayoutConstraint(item: labelForSound!, attribute: .left, relatedBy: .equal, toItem: viewWithContent, attribute: .left, multiplier: 1.0, constant: viewWithContent.bounds.width * 0.05)
        
        let labelForSoundPosition = NSLayoutConstraint(item: labelForSound!, attribute: .centerX, relatedBy: .equal, toItem: viewWithContent, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let pickerTopConstraint = NSLayoutConstraint(item: pickerView!, attribute: .top, relatedBy: .equal, toItem: self.labelForSound, attribute: .bottom, multiplier: 1.0, constant: 0 )
        
        let pickerPosition = NSLayoutConstraint(item: pickerView!, attribute: .centerX, relatedBy: .equal, toItem: viewWithContent, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let pickerHeight = NSLayoutConstraint(item: pickerView!, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .height, multiplier: 1.0, constant: 120 )
        
        let pickerWidth = NSLayoutConstraint(item: pickerView!, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: 140)
        
        let labelForImageTopConstraint = NSLayoutConstraint(item: labelForImage!, attribute: .top, relatedBy: .equal, toItem: pickerView, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        let labelForImageRightConstraint = NSLayoutConstraint(item: labelForImage!, attribute: .right, relatedBy: .equal, toItem: viewWithContent, attribute: .right, multiplier: 1.0, constant: viewWithContent.bounds.width * 0.1)
        
        let labelForImageLeftConstraint = NSLayoutConstraint(item: labelForImage!, attribute: .left, relatedBy: .equal, toItem: viewWithContent, attribute: .left, multiplier: 1.0, constant: viewWithContent.bounds.width * 0.1)
        
        let labelForImagePosition = NSLayoutConstraint(item: labelForImage!, attribute: .centerX, relatedBy: .equal, toItem: viewWithContent, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let imageTopConstraint = NSLayoutConstraint(item: image!, attribute: .top, relatedBy: .equal, toItem: self.labelForImage, attribute: .bottom, multiplier: 1.0, constant: 20 )
        
        let imagePosition = NSLayoutConstraint(item: image!, attribute: .centerX, relatedBy: .equal, toItem: viewWithContent, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let imageHeight = NSLayoutConstraint(item: image!, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .height, multiplier: 1.0, constant: self.view.bounds.width / 2 )
        
        let imageWidth = NSLayoutConstraint(item: image!, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.bounds.width / 2)
        
        let buttonTopConstraint = NSLayoutConstraint(item: openCamera!, attribute: .top, relatedBy: .equal, toItem: self.image, attribute: .bottom, multiplier: 1.0, constant: 30 )
        
        let buttonPosition = NSLayoutConstraint(item: openCamera!, attribute: .centerX, relatedBy: .equal, toItem: viewWithContent, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let buttonHeight = NSLayoutConstraint(item: openCamera!, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .height, multiplier: 1.0, constant: 30)
        
        let buttonWidth = NSLayoutConstraint(item: openCamera!, attribute: .width, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1.0, constant: self.view.bounds.width / 1.5)
        
        let buttonBottomConstraint = NSLayoutConstraint(item: openCamera!, attribute: .bottom, relatedBy: .equal, toItem: viewWithContent, attribute: .bottom, multiplier: 1.0, constant: -20)
        
        self.view.addConstraints([labelForDatePickerTopConstraint, labelForDatePickerRightConstraint, labelForDatePickerLeftConstraint, alarmTimeDatePickerTopConstraint, alarmTimeDatePickerPosition, alarmTimeDatePickerHeight, alarmTimeDatePickerWidth, labelForSoundTopConstraint, labelForSoundRightConstraint, labelForSoundLeftConstraint, pickerTopConstraint, pickerPosition, pickerHeight, pickerWidth, labelForImageTopConstraint, labelForImageLeftConstraint, labelForImageRightConstraint,imageTopConstraint, imagePosition, imageHeight, imageWidth, buttonTopConstraint, buttonPosition, buttonHeight, buttonWidth, scrollViewTopConstraint, scrollViewRightConstraint, scrollViewLeftConstraint, buttonBottomConstraint, viewWithContentTopConstraint,  viewWithContentBottomConstraint, scrollViewBottomConstraint, scrollViewWidth, labelForDatePickerPosition, labelForSoundPosition, labelForImagePosition, viewWithContentRightConstraint, viewWithContenLeftConstraint, viewWithContentWidth])
    }
    
    private func editProperties() {
        labelForDatePicker.text = NSLocalizedString("Выбрать время", comment: "time")
        labelForSound.font = labelForSound.font.withSize(16)
        labelForDatePicker.lineBreakMode = .byWordWrapping
        labelForDatePicker.numberOfLines = 0
        labelForDatePicker.textAlignment = .center
        
        alarmTimeDatePicker.datePickerMode = .time
        
        labelForSound.text = NSLocalizedString("Выбрать мелодию", comment: "sound")
        labelForSound.font = labelForSound.font.withSize(16)
        labelForSound.lineBreakMode = .byWordWrapping
        labelForSound.numberOfLines = 0
        labelForSound.textAlignment = .center
        
        labelForImage.text = NSLocalizedString("Для использования пробуждения с фотографией, сфотографируйте объект", comment: "photo")
        labelForImage.font = labelForImage.font.withSize(16)
        labelForImage.lineBreakMode = .byWordWrapping
        labelForImage.numberOfLines = 0
        labelForImage.textAlignment = .center
        
        image.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
        image.layer.cornerRadius = self.view.bounds.width / 8
        
        openCamera.setTitle(NSLocalizedString("Сфотографировать объект", comment: "photo"), for: .normal)
        openCamera.backgroundColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1)
        openCamera.layer.cornerRadius = 12.5
        openCamera.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        openCamera.setTitleColor(.black, for: .normal)
        
    }
    
    private func identifaerForAlarm() -> String {
        let realm = try! Realm()
        let alarms = realm.objects(Alarm.self)
        var maxIdent = 1
        
        if alarms.count != 0 {
            for index in 0...alarms.count - 1  {
                if alarms[index].identifaer > maxIdent {
                    maxIdent = alarms[index].identifaer
                }
                
            }
            return ("\((maxIdent) + 8)")
        } else {
            return ("\(maxIdent)")
        }
        
    }
    
    private func alarmSong() {
        let alert = UIAlertController(title: NSLocalizedString("Для срабатывания будильника, беззвучный режим должен быть отключен", comment: "alarm sound"), message: nil , preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Public Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 8
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayOfAlarmsMusicForUser[row]
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image.image = pickedImage
            image.contentMode = .scaleToFill
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func saveAlarm(_ sender: Any) {
        
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        
        if Double(alarmTimeDatePicker.date.timeIntervalSinceNow) >= 0 {
            Notification.shared.requestNotification(identificator: nil, sound: "\(arrayOfAlarmsMusicForPrivate[selectedIndex]).mp3", timeForAlarm: Double(alarmTimeDatePicker.date.timeIntervalSinceNow))
            print("time for alarm = \(Double(alarmTimeDatePicker.date.timeIntervalSinceNow))")
        } else {
            Notification.shared.requestNotification(identificator: nil, sound: "\(arrayOfAlarmsMusicForPrivate[selectedIndex]).mp3", timeForAlarm: 24 * 60 * 60 + Double(alarmTimeDatePicker.date.timeIntervalSinceNow))
            print("time for alarm = \(Double(alarmTimeDatePicker.date.timeIntervalSinceNow))")
        }

        output?.addAlarmForDate(alarmTimeDatePicker.date, image.image?.jpegData(compressionQuality: 1), sound: "\(arrayOfAlarmsMusicForPrivate[selectedIndex]).mp3", identifaer: identifaerForAlarm())

        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func OpenCamera(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.showsCameraControls = true
            
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
    }
    
}








