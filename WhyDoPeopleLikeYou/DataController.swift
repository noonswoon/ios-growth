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
    
    static var summation = 0
    static var summationDescription = ""
    
    static var questions = [String]()
    static var choices = [String]()
    static var list_questionViewController = [QuestionViewController]()
    
    static var userProfileImage: UIImage!
    static var userFirstNameText: String = "Error found"
    
    static let resultsEng = [
        ("You’ve got beautiful eyes, cute smile and silky hair."),
        ("You’ve got a nice skin, very good looking and adorable."),
        ("You’re so sexy that you make the others blush when they look at you."),
        ("You have glamorous lips and perfect body."),
        ("You’ve slim body and skinny legs. Also your mind is beautiful."),
        ("You’re homely looking but your possitive attitude make people like you."),
        ("You’re friendly, good-humored that make everyone wants to be with you."),
        ("You’ve got nice legs, curvy body and you’re easy-going with everyone."),
        ("You’re so stunning. You make others’ jaw drop when they look at you."),
        ("You’re funny person. You have sense of humor. Everyone wants to be close with you."),
        ("You’ve got adorable dimples. Your smile melt the other hearts."),
        ("You’re a little bit cheeky. your humor always make people laugh."),
        ("You’re rich and generous. That’s why people want to be with you."),
        ("You’re never look aged. You skin is very nice and you have no wrinkles."),
        ("You look very elegant yet adorable. Everyone wants to be with you."),
        ("You’ve got blushing cheeks. Everyone can fall in love with you easily when they see you."),
        ("You’re very attractive person and your curvy body make people like you."),
        ("You’re polite, quiet and modest. When people are with you, they’re happy."),
        ("You like adventurous activities and love to visit exciting places."),
        ("You’re extroverted person. Easy-going with everyone and you’re kind. That’s why people like you."),
        ("You’ve nice eyebrows, pretty lips and elegant hair. Moreover you’re funny."),
        ("You’ve good manner, friendly yet sometimes you’re a little bit naughty and cute."),
        ("You’re young and have beautiful mind. You’re kind to everyone. (NO LIKE)")]
    
    static let resultsThai = [
        ("คุณมีดวงตาที่สวยงาม มีรอยยิ้มที่น่ารัก และมีผมที่นุ่มสลวย"),
        ("คุณมีผิวพรรณที่ดี เป็นคนที่ดูดีและน่ารัก"),
        ("คุณมีความเซ็กซี่มากจนกระทั่ง ทำให้คนอื่นหน้าแดง เมื่อพวกเขามองมายังคุณ"),
        ("คุณมีริมฝีปากที่สวย และรูปร่างอันเพอร์เฟ็ค"),
        ("นอกจากนี้จิตใจคุณยังงดงามอีกด้วย"),
        ("หน้าตาของคุณก็งั้นๆแหละ แต่คุณเป็นคนคิดบวกเลยทำให้ผู้คนชอบคุณ"),
        ("คุณเป็นคนที่เป็นกันเอง มีความขบขัน ทำให้ทุกๆคนอยากจะเข้ามาอยู่ใกล้ๆคุณ"),
        ("คุณมีขาที่สวย รูปร่างดี และเข้ากับคนอื่นได้ทุกๆคน"),
        ("คุณสวยมาก! สวยจนกระทั่งทำให้คนอื่นอ้าปากค้างเมื่อพวกเขามองคุณ"),
        ("คุณเป็นคนตลก มีความขำขัน จนทุกๆคนอยากจะอยู่ใกล้ๆกับคุณ"),
        ("คุณมีลักยิ้มที่น่ารัก รอยยิ้มของคุณละลายใจของทุกๆคน"),
        ("คุณมีความทะเล้น มุกตลกของคุณทำให้คนอื่นขำได้เสมอ"),
        ("คุณรวยและเป็นคนใจกว้าง นี่แหละคือสาเหตุที่ผู้คนอยากอยู่ใกล้คุณ"),
        ("คุณดูไม่แก่ลงไปเลย ผิวพรรณของคุณนั้นดีเยี่ยม ไม่มีแม้กระทั่งรอยตีนกา"),
        ("คุณเป็นคนที่มีความสง่างาม แต่ยังมีความน่ารัก ทำให้ทุกๆคนอยากอยู่กับคุณ"),
        ("คุณมีแก้มที่แดงสวย ทุกๆคนสามารถตกหลุมรักคุณได้อย่างง่ายดายเมื่อเขาเห็นคุณ"),
        ("คุณเป็นคนที่มีเสน่ห์ดึงดูดมาก รูปร่างอันงดงามของคุณ ทำให้ผู้คนชอบคุณ"),
        ("คุณเป็นคนสุภาพ เงียบ และเจียมเนื้อเจียมตัว เมื่อคนอื่นอยู่กับคุณ พวกเขารู้สึกมีความสุข"),
        ("คุณเป็นคนที่ชอบกิจกรรมผจญภัย และชอบที่จะไปเยี่ยมชมสถานที่น่าตื่นตาตื่นใจ"),
        ("คุณเป็นคนเข้าสังคมเก่ง เข้ากับคนอื่นได้ทุกคน และคุณยังใจดีอีกต่างหาก นั่นคือเหตุผลที่ทำไมผู้คนถึงชอบคุณ"),
        ("คุณมีคิ้วที่ดูดี มีริมฝีปากที่รูปร่างสวย และมีผมที่นุ่มสลวย นอกจากนี้คุณยังเป็นคนที่มีความตลกอีกด้วย"),
        ("คุณเป็นคนที่มีมารยาทดี มีความเป็นกันเอง บางครั้งคุณก็ซุกซนนิดหน่อย และคุณก็น่ารักด้วย"),
        ("คุณดูเด็ก และมีจิตใจที่ดี คุณใจดีกับทุกๆคน (NO LIKE CASE)")]


    // MARK: Generate question view controller
    
    class func setQuestionAndChoice () {
        
        questions.append( "Question1" )
        
        choices.append( "Choice1_1" )
        choices.append( "Choice1_2" )
        choices.append( "Choice1_3" )
        choices.append( "Choice1_4" )
        
        questions.append( "Question2" )
        
        choices.append( "Choice2_1" )
        choices.append( "Choice2_2" )
        choices.append( "Choice2_3" )
        choices.append( "Choice2_4" )

        questions.append( "Question3" )
        
        choices.append( "Choice3_1" )
        choices.append( "Choice3_2" )
        choices.append( "Choice3_3" )
        choices.append( "Choice3_4" )

        questions.append( "Question4" )
        
        choices.append( "Choice4_1" )
        choices.append( "Choice4_2" )
        choices.append( "Choice4_3" )
        choices.append( "Choice4_4" )

        
    }
    
    class func setQuestionViewControllers () {
        
        println("number of question: \(questions.count)")
        
        let numberOfChoicePerQuestion = 4
        let numberOfQuestion = questions.count
        
        for (var i=0 ; i<numberOfQuestion ; i++) {
            
            var questionViewController = QuestionViewController()
            
            for (var j=0 ; j<numberOfChoicePerQuestion ; j++) {
                
                let choice = choices[ i * numberOfQuestion + j ]
                questionViewController.addChoice( choice )
            }
            
            questionViewController.setQuestionLabel( questions[i] )
            questionViewController.setChoicesLabels()
            questionViewController.setQuestionNumber( i )
            
            list_questionViewController.append( questionViewController )
        }
    }
    
    class func getStart (rootView: UIViewController) {
        
        DataController.summation = 0
        AdvertismentController.enableAds = false
        
        let timeDelay: Double = 0
        
        var firstQuestion = list_questionViewController[0]
        firstQuestion.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        
        let delay = timeDelay * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            rootView.presentViewController( firstQuestion, animated: true, completion: nil)
        }
        
    }
    
    
    
    // MARK: Generating result
    
    // User profile image from user ID
    
    class func loadUserProfileImage () {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                
                println("Error: \(error)")
            }
            else {
                
                let publicProfile = result as! NSDictionary
                let userID = publicProfile["id"] as! String
                println(userID)
                
                let urlString = "https://graph.facebook.com/\(userID)/picture?type=large"
                let nsURL = NSURL(string:  urlString)
                let nsData = NSData(contentsOfURL: nsURL!)
                
                self.userProfileImage = UIImage(data: nsData!)
                
            }
        })
    }
    
    // First name
    
    class func loadUserFirstName () {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                
                println("Error: \(error)")
            }
            else {
                
                let publicProfile = result as! NSDictionary
                let fname = publicProfile["first_name"] as! String
                println(fname)
                
                self.userFirstNameText = fname
            }
        })
    }
    
    
    class func loadUserProfile() {
        
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me?fields=id,email,first_name,last_name,birthday", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                // Process error
                println("Error: \(error)")
            }
            else {
                println("fetched user: \(result)")
                
                let id        : String = (result.valueForKey("id")         != nil)  ? result.valueForKey("id")          as! String : ""
                let firstname : String = (result.valueForKey("first_name") != nil)  ? result.valueForKey("first_name")  as! String : ""
                let lastname  : String = (result.valueForKey("last_name")  != nil)  ? result.valueForKey("last_name")   as! String : ""
                let email     : String = (result.valueForKey("emails")     != nil)  ? result.valueForKey("emails")      as! String : firstname + "." + lastname + "@facebook.com"
                let birthday  : String = (result.valueForKey("birthday")   != nil)  ? result.valueForKey("birthday")    as! String : ""
                
                UserLogged.saveUserInformation(id, firstname: firstname, lastname: lastname, email: email, birthday: birthday)
            }
        })
    }


}



// MARK: Generating result

extension DataController {
    
    // User information
    
    
    // MARK: Calculating result
    
    class func findMaximumPageCategoryCount () {
        
        var graphPath : String = "me?fields=likes.limit(1000)"
        var returnResult = ""
        
        var request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: nil, HTTPMethod: "GET")
        request.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                println("Error: \(error)")
            }
            else {
                var categoryDic = Dictionary<Character, Int>()
                
                // Getting all of the category of page that user liked
                let resultData = result as! NSDictionary
                let likes: NSDictionary = resultData["likes"] as! NSDictionary
                let datas:  NSArray = likes["data"] as! NSArray
                
                // Keep those data into dictionary named categoryDic. Use category name as key and among as value
                for data in datas {
                    let category = data[ "category" ] as! String
                    let firstChar = (Array(category))[0]
                    
                    //println("\(firstChar): \(category)")
                    
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
                
                
                // Generate result
                println( self.generateResult("\(sortedKeys[0])") )
                
                
                // Show result
                println("\nCouting the first character of fanpage category that user liked")
                for sortedKey in sortedKeys {
                    
                    let key   = sortedKey
                    let value = categoryDic[sortedKey]
                    
                    if (value == 0) {
                        continue
                    }
                    
                    println("\(value!)\t : \(key)")
                }
                
                
                // println("\(sortedKeys[0])\t : \(categoryDic[sortedKeys[0]]!)")
                
            }
        })
    }
    
    
    class func sortingFanpageUserLike () {
        // For more complex open graph stories, use `FBSDKShareAPI`
        // with `FBSDKShareOpenGraphContent`
        /* make the API call */
        
        let graphPath : String = "me?fields=likes.limit(1000)"
        
        var request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: nil, HTTPMethod: "GET")
        request.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                println("Error: \(error)")
            }
            else {
                var categoryDic = Dictionary<String, Int>()
                
                // Getting all of the category of page that user liked
                let resultData = result as! NSDictionary
                let likes: NSDictionary = resultData["likes"] as! NSDictionary
                let datas:  NSArray = likes["data"] as! NSArray
                
                // Keep those data into dictionary named categoryDic. Use category name as key and among as value
                for data in datas {
                    let category = data[ "category" ] as! String
                    if ( categoryDic[category] == nil ) {
                        categoryDic[category] = 1
                    } else {
                        categoryDic[category] = categoryDic[category]! + 1
                    }
                }
                
                // Sorting keys by value
                var sortedKeys = Array(categoryDic.keys).sorted({
                    categoryDic[$0] > categoryDic[$1]
                })
                
                
                // Show
                println("\nCouting category of fanpage that user liked")
                for sortedKey in sortedKeys {
                    let key   = sortedKey
                    let value = categoryDic[sortedKey]
                    
                    println("\(value!)\t : \(key)")
                }
            }
        })
    }
    
    
    class func generateResult (keyword: String) {
        
        var scalars     = keyword.lowercaseString.unicodeScalars
        let firstScalar = scalars[ scalars.startIndex ].hashValue
        let key         = firstScalar - 97
        
        setSummartion( key )
    }
    
    
    class func setSummartion (num: Int) {

        summation = (summation + num) % resultsEng.count
        
        println("summation: \(summation)")
    }
    
    class func getDescription () -> String {
        
        //summationDescription = DataController.resultsEng[ key ] + "\n\n" + DataController.resultsThai[ key ]
        
        summation = (summation < 1) ? 1 : summation
        
        return DataController.resultsThai[ summation ]
    }
    
}






