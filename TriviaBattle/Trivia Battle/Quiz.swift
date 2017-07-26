//
//  Quiz.swift
//  Trivia Battle
//
//  Created by Michael N Ackley on 5/5/17.
//  Copyright © 2017 Najia Haider. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class Quiz
{
    var questionNumber = [Int]()
    var questionItself = [String]()
    var answersArray: [[String]] = []
    var correct = [String]()
    var answerDict = [[String: String]]()
    
//    func read(string: String)
//    {
//        
//        // URL OTHER TEST
//        let urlString = string
//        let url = URL(string: urlString)
//        let task = URLSession.shared.dataTask(with: url!) {(data,response,error) in
//            if error != nil
//            {
//                print("error")
//                
//            }
//                
//            else
//            {
//                
//                if let content = data {
//                    
//                    do
//                    {
//                        //Array
//                        let myJson = try JSONSerialization.jsonObject(with: content, options: .allowFragments)
//                        print(myJson)
//                        
//                        self.readJSONData(myJson as! [String : AnyObject])
//                        self.QuestionNum.text = "Question \(self.questionNumber[self.i])/\(self.numberOfQuestions) "
//                        self.questionLabel.text = " \(self.questionItself[self.i])"
//                        self.optionA.text = "\(self.answerDict[self.i]["A"]!)"
//                        self.optionB.text = "\(self.answerDict[self.i]["B"]!)"
//                        self.optionC.text = "\(self.answerDict[self.i]["C"]!)"
//                        self.optionD.text = "\(self.answerDict[self.i]["D"]!)"
//                        self.correctAnswerToCompare = "\(self.correct[self.i])"
//                        
//                    }
//                        
//                    catch {
//                        
//                    }
//                    
//                }
//                
//            }
//            
//        }
//        task.resume()
//    }

}
