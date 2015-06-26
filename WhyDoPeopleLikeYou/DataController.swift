//
//  DataController.swift
//  WhyDoPeopleLikeYou
//
//  Created by KHUN NINE on 6/23/15.
//  Copyright (c) 2015 KHUN NINE. All rights reserved.
//

import Foundation

public class DataController {
    
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

    
    class func getEmailFromUser () {
        
        let graphPath : String = "me?fields=email,first_name"
        
        var request: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: graphPath, parameters: nil, HTTPMethod: "GET")
        request.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil) {
                println("Error: \(error)")
            }
            else {
                
                var fname = result["first_name"]
                var email = result["emaiasdal"]
                
                if (email == nil || fname != nil) {
                    email = (fname as! String) + "@facebook.com"
                }
                else {
                    email = ""
                }
                
                println("Email: \(email)")
            }
        })
    }
    
    class func findMaximumPageCategoryCount () -> String {
        // For more complex open graph stories, use `FBSDKShareAPI`
        // with `FBSDKShareOpenGraphContent`
        /* make the API call */
        
        let graphPath : String = "me?fields=likes.limit(1000)"
        
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
                    
                    println("\(firstChar): \(category)")
                    
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
                
                /*
                // Showing
                for sortedKey in sortedKeys {
                let key   = sortedKey
                let value = categoryDic[sortedKey]
                if (value == 0) {
                continue
                }
                println("\(value!)\t : \(key)")
                self.makingResult(key)
                }
                */
                
                println("\(sortedKeys[0])\t : \(categoryDic[sortedKeys[0]]!)")
                returnResult = String("\(sortedKeys[0])")
            }
        })
        
        return returnResult
    }
    
    class func generateResult () -> String {
        
        let keyword     = findMaximumPageCategoryCount()
        
        var scalars     = keyword.lowercaseString.unicodeScalars
        let firstScalar = scalars[ scalars.startIndex ].hashValue
        let key         = firstScalar - 97
        
        return DataController.resultsEng[ key ] + "\n\n" + DataController.resultsThai[ key ]
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
                        categoryDic[category] = 0
                    } else {
                        categoryDic[category] = categoryDic[category]! + 1
                    }
                }
                
                // Sorting keys by value
                var sortedKeys = Array(categoryDic.keys).sorted({
                    categoryDic[$0] > categoryDic[$1]
                })
                
                // Showing
                for sortedKey in sortedKeys {
                    let key   = sortedKey
                    let value = categoryDic[sortedKey]
                    println("\(value!)\t : \(key)")
                }
            }
        })
    }
}