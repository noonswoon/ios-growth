//
//  DataController.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 6/23/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import Foundation
import Parse

public class DataController {
    
    static var result = 0
    static var summation = 0
    static var summationDescription = ""
    
    static var questions = [String]()
    static var choices = [String]()
    static var list_questionViewController = [QuestionViewController]()
    
    // Keep the user information such as firstname, lastname, email and birthdate 
    static var userInfo = Dictionary<String, String>()
    
    static var userProfileImage: UIImage!
    static var userFirstNameText: String!
    static var userProfileID: String!
    
    static let resultsThai = [
        ("ตาตี่ จิตใจเหี้ยม"),
        ("บั้นท้ายใหญ่ ยิ้มง่าย"),
        ("ขาใหญ่ ขำขัน"),
        ("รูจมูกบาน เซ็กซี่"),
        ("คิ้วดก พูดตรง"),
        ("รักแร้เหม็น ทะเล้น"),
        ("จ้ำม่ำ กินเก่ง"),
        ("ขนจมูกยาว รวย"),
        ("รักแร้ดำ จิตใจดี"),
        ("ริมฝีปากอวบ ถ่อมตน"),
        ("ไร้รอยตีนกา ขี้เหนียว"),
        ("หูกาง ชอบรับฟัง"),
        ("ขนหน้าแข้งดก เป็นกันเอง"),
        ("ขายาว ขี้งอน"),
        ("พุงนุ่มนิ่ม อ่อนโยน"),
        ("รักแร้ขาว กินจุ"),
        ("คิ้วบาง ตลก"),
        ("จมูกโด่ง ซน"),
        ("ขนแขนชูชัน ประหยัด"),
        ("เอวบาง เข้าสังคมเก่ง"),
        ("เท้าเหม็น อบอุ่น"),
        ("ฟันเหยิน จริงใจ"),
        ("หัวหยิก ล่ำสัน")]
    
    static let codeName = [
        ("ตี๋อำมหิต"),
        ("บั้นท้ายพิฆาต"),
        ("ขาหมูสะท้านฟ้า"),
        ("จมูกเครื่องดูดฝุ่น"),
        ("คิ้วสาหร่าย"),
        ("กลิ่นตัวสะท้านโลกา"),
        ("จอมเขมือบแห่งศตวรรษ"),
        ("เส้นขนทะยานฟ้า"),
        ("หมักหมมบ่มเชื้อรา"),
        ("จูบเย้ยจันทร์"),
        ("หน้าเด็กตลอดกาล"),
        ("หูกระด้ง"),
        ("ขาหัวไชเท้า"),
        ("ขาเรียวเกี่ยวสวาท"),
        ("มาร์ชเมลโล่"),
        ("วงแขนดวงจันทรา"),
        ("คิ้ว 0 มิติ"),
        ("พิน็อคคิโอ"),
        ("ขนแขนอเมซอน"),
        ("เอวเพรียวเกี่ยวใจ"),
        ("กลิ่นบาทาปราบมาร"),
        ("ฟันขูดมะพร้าว"),
        ("ฝอยขัดหม้อ")]
    
    // MARK: Generate question view controller
    class func setQuestionAndChoice () {
        
        questions.append("คุณคิดว่าตัวเองน่ารักรึเปล่า")
        
        choices.append( "ก็มีบ้างบางครั้งนะ" )
        choices.append( "แน่นอน ก็ฉันน่ารักอะ" )
        choices.append( "ไม่เลย ฉันไม่คิดว่าฉันน่ารัก" )
        
        questions.append( "คุณแต่งหน้าบ่อยแค่ไหน" )
        
        choices.append( "แต่งทุกวันเลย" )
        choices.append( "ไม่เคยเลย" )
        choices.append( "บางครั้งก็แต่ง" )

        questions.append( "คุณออกกำลังกายบ่อยแค่ไหน" )
        
        choices.append( "ไม่เคยเลย" )
        choices.append( "ออกทุกวันนะ" )
        choices.append( "เกือบทุกวัน บางวันก็ไม่ได้ออก" )

        questions.append( "คุณโกนหนวด/เครา/ขน ของคุณบ่อยแค่ไหน" )
        
        choices.append( "ทุกวัน" )
        choices.append( "ทุกสัปดาห์" )
        choices.append( "ไม่เคย" )
        
        questions.append( "ลองประเมิณความน่าดึงดูดของคุณ" )
        
        choices.append( "0 - 3" )
        choices.append( "4 - 6" )
        choices.append( "7 - 10" )
    }
    
    class func setQuestionViewControllers () {
        
        let numberOfChoicePerQuestion = choices.count/questions.count
        let numberOfQuestion = questions.count
        
        for (var i=0 ; i<numberOfQuestion ; i++) {
            
            var questionViewController = QuestionViewController()
            
            for (var j=0 ; j<numberOfChoicePerQuestion ; j++) {
                
                let choice = choices[i*numberOfChoicePerQuestion+j]
                questionViewController.addChoice( choice )
            }
            
            questionViewController.setQuestionNumber( i )
            questionViewController.setContentBackgroundImageView()
            questionViewController.setQuestionLabel( questions[i] )
            questionViewController.setChoicesLabels()
            questionViewController.setQuestionPhoto()
            
            list_questionViewController.append( questionViewController )
        }
    }
    
    class func getStartQuestion (rootView: UIViewController) {
    
        DataController.summation = result
        //AdvertismentController.disableAds()
        
        let timeDelay: Double = 0
        let delay = timeDelay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.presentFirstQuestion(rootView)
        }
        
    }
    
    class func presentFirstQuestion (rootView: UIViewController) {
        
        var firstQuestion = list_questionViewController[0]
        firstQuestion.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        rootView.presentViewController( firstQuestion, animated: true, completion: nil)
    }

    // MARK: Generating result
    class func loadUserProfile() {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me?fields=gender,id,email,first_name,last_name,birthday", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                println("Error: \(error)")
            }
            else {
                println("fetched user: \(result)")
                self.setUserInfo(result)
            }
        })
    }
    
    class func setUserInfo (result: AnyObject) {
        
        let id        : String = (result.valueForKey("id")         != nil) ? result.valueForKey("id")          as! String : ""
        let firstname : String = (result.valueForKey("first_name") != nil) ? result.valueForKey("first_name")  as! String : ""
        let lastname  : String = (result.valueForKey("last_name")  != nil) ? result.valueForKey("last_name")   as! String : ""
        let email     : String = (result.valueForKey("email")      != nil) ? result.valueForKey("email")       as! String : firstname + "." + lastname + "@facebook.com"
        let birthday  : String = (result.valueForKey("birthday")   != nil) ? result.valueForKey("birthday")    as! String : ""
        let gender    : String = (result.valueForKey("gender")     != nil) ? result.valueForKey("gender")      as! String : "male"
        
        self.setUserProfileImage(id)
        self.setUserFirstName(firstname)
        self.setUserProfileID(id)
        self.setupPushNotificationChannel(gender)
        
        self.userInfo["userId"] = id
        self.userInfo["first_name"] = firstname
        self.userInfo["last_name"] = lastname
        self.userInfo["email"] = email
        self.userInfo["birthday"] = birthday
    }
    
    class func setupPushNotificationChannel (gender: String) {
        // When users indicate they are Giants fans, we subscribe them to that channel.
        var currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject(gender, forKey: "channels")
        currentInstallation.saveInBackgroundWithBlock(nil)
    }
    
    class func setUserProfileID(ID: String) {
        self.userProfileID = ID
    }
    
    class func setUserProfileImage (userID: String) {
        
        let urlString = "https://graph.facebook.com/\(userID)/picture?type=large"
        let nsURL = NSURL(string:  urlString)
        let nsData = NSData(contentsOfURL: nsURL!)
        
        self.userProfileImage = UIImage(data: nsData!)
        
        closeLoadingIndicator()
    }
    
    class func setUserFirstName (fname: String) {
        
        self.userFirstNameText = fname
        closeLoadingIndicator()
    }
    
    class func closeLoadingIndicator () {
        
        if (userProfileImage != nil && userFirstNameText != nil) {
            
            NSNotificationCenter.defaultCenter().postNotificationName("LoadUserProfileConpleted", object: nil)
            SwiftSpinner.hide()
        }
    }
}

// MARK: Generating result
extension DataController {
    
    class func findMaximumPageCategoryCount () {

        var graphPath : String = "me?fields=likes.limit(1000)"
        var returnResult = ""
        
        var request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: nil, tokenString: FBSDKAccessToken.currentAccessToken().tokenString, version: "v2.3", HTTPMethod: "GET")
        request.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                println("Error: \(error)")
            }
            else {
                println(result)
                
                // Dictionay for temporary contain the category
                var categoryDic = Dictionary<Character, Int>()
                
                // Getting all of the category of page that user liked
                let resultData = result as! NSDictionary
                let likes: NSDictionary = resultData["likes"] as! NSDictionary
                let datas: NSArray = likes["data"] as! NSArray
                
                // Keep those data into dictionary named categoryDic. Use category name as key and among as value
                for data in datas {
                    var category: String! = data["category"] as! String
                    
                    let firstChar = (Array(category))[0]
                    
                    if ( categoryDic[firstChar] == nil ) {
                        categoryDic[firstChar] = 0
                    } else {
                        categoryDic[firstChar] = categoryDic[firstChar]! + 1
                    }
                }
                
                // Sorting keys by value
                var sortedKeys = Array(categoryDic.keys).sorted({
                    categoryDic[$0] > categoryDic[$1]
                })
                
                // Generate and set the result, after finish this line the result will be ready to use
                self.generateResult("\(sortedKeys[0])")
                
                // Just show the relation about unique character and how many of its
                println("\nCouting the first character of fanpage category that user liked")
                for sortedKey in sortedKeys {
                    
                    let key   = sortedKey
                    let value = categoryDic[sortedKey]
                    
                    if (value == 0) {
                        continue
                    }
                    
                    println("\(value!)\t : \(key)")
                }
                println("\(sortedKeys[0])\t : \(categoryDic[sortedKeys[0]]!)")
            }
        })
    }
    
    class func generateResult (keyword: String) {
        var scalars     = keyword.lowercaseString.unicodeScalars
        let firstScalar = scalars[ scalars.startIndex ].hashValue
        let key         = firstScalar - 97
        
        setResult( key )
    }
    
    class func setResult (num: Int) {
        result = (result + num) % resultsThai.count
        result = (result < 0) ? result*(-1) : result
    }
    
    class func setSummartion (num: Int) {
        summation = (self.summation + num) % resultsThai.count
        println("summation: \(summation)")
    }
    
    class func getPhotoResult () -> UIImage {
        summation = (summation < 1) ? 1 : summation
        summation = summation % codeName.count
        var imageString = "\(summation)"
        
        return UIImage(named: imageString)!
    }
    
    class func getDescription () -> String {
        summation = (summation < 1) ? 1 : summation
        summation = (summation > codeName.count-1) ? codeName.count-1 : summation
        
        return DataController.resultsThai[ summation - 1 ]
    }
    
    class func getCodeName () -> String {
        summation = (summation < 1) ? 1 : summation
        summation = (summation > codeName.count-1) ? codeName.count-1 : summation
        
        return DataController.codeName[ summation - 1 ]
    }
}

// Extension for UIColor

extension UIColor {
    
    class func mainColor () -> UIColor {
        return UIColor(red: 185/255, green: 0/255, blue: 52/255, alpha: 1)
    }
    
    class func appCreamColor () -> UIColor {
        return UIColor(red: 254/255, green: 255/255, blue: 187/255, alpha: 1)
    }
    
    class func appBrownColor () -> UIColor {
        return UIColor(red: 84/255, green: 32/255, blue: 0, alpha: 1)
    }
    
    class func appGreenColor () -> UIColor {
        return UIColor(red: 7/255, green: 89/255, blue: 1/255, alpha: 1)
    }
    
    class func appBlueColor () -> UIColor {
        return UIColor(red: 0, green: 0, blue: 234/255, alpha: 1)
    }
}
