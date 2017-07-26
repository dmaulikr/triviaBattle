//
//  QuizView.swift
//  Trivia Battle
//
//  Created by Najia Haider on 4/25/17.
//  Copyright © 2017 Najia Haider. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreMotion
class QuizView: UIViewController,  MCBrowserViewControllerDelegate, MCSessionDelegate   {

    static var motionManager = CMMotionManager()
    var AisTapped = false
    var BisTapped = false
    var CisTapped = false
    var DisTapped = false
    var left = false
    var right = false
    var yawBeingChecked = false
    var answerSubmitted = false
    let array = ["A", "B", "C", "D"]
    
    var MotionArrCheck = ["Z"]
    var subMax = 0
    var subArray = [String]()
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var player2Name: UILabel!
    @IBOutlet weak var player3Name: UILabel!
    @IBOutlet weak var player4Name: UILabel!
    
    @IBOutlet weak var restartButton: UIButton!
    
    var session: MCSession!
    var peerId: MCPeerID!
    
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!

    var timer = Timer()
    var timer2 = Timer()
    
    var restartCount = 0
    var answers = 0
    var otherAnswers = 0
    var questionsAsked = 0
    var i = 0
    var time = 0
    var quiz = 1
    var questionNumber = [Int]()
    var questionItself = [String]()
    var answersArray: [[String]] = []
    var correct = [String]()
    var submitted = " "
    var answerDict = [[String: String]]()
    
    var correctAnswerToCompare = " "
    
    var numberOfQuestions = 0
    @IBOutlet weak var devicePlayer: UIImageView!
    
    @IBOutlet weak var QuestionNum: UILabel!
    
    @IBOutlet weak var player2: UIImageView!
    
    @IBOutlet weak var player3: UIImageView!
    
    @IBOutlet weak var player4: UIImageView!
    
    
    @IBOutlet weak var devicePlayerAnswer: UILabel!
    
    @IBOutlet weak var player2Answer: UILabel!
    
    @IBOutlet weak var player3Answer: UILabel!
    
    @IBOutlet weak var player4Answer: UILabel!
    
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var optionA: UILabel!
    @IBOutlet weak var optionB: UILabel!
    @IBOutlet weak var optionC: UILabel!
    @IBOutlet weak var optionD: UILabel!
    
    
    @IBOutlet weak var devicePlayerPoint: UILabel!
    
    
    @IBOutlet weak var player2Point: UILabel!
    
    @IBOutlet weak var player3Point: UILabel!
    
    @IBOutlet weak var player4Point: UILabel!
    
    var playerArray = [String]()
    
    var tap = 1
    
    @IBOutlet weak var answerLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //QuizView.motionManager = CMMotionManager()

        self.peerId = ViewController.peerId
        self.session = ViewController.session
        self.browser = ViewController.browser
        self.assistant = ViewController.assistant
        
        assistant.start()
        session.delegate = self
        browser.delegate = self

        resetInfo()
        restartButton.isHidden = true
        restartCount = 0
        answers = 0
        otherAnswers = 0
        questionsAsked = 0
        i = 0
        
        
        disableButtons()
        
        resetArrays()
        answerLabel.text = "Please wait for the Quiz to begin."
        time = 5
        timeLabel.text = "5"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(labelTimer), userInfo: nil, repeats: true)
        
        let startTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(startGame), userInfo: nil, repeats: false)

        //single player game
        
        if ViewController.singlePlayer == true {
            
            subMax = 1
            
            deviceName.text = UIDevice.current.name
            
            player2.alpha = 0.3
            player3.alpha = 0.3
            player4.alpha = 0.3
            player2Answer.text = ""
            player3Answer.text = ""
            player4Answer.text = ""
            
            
            read()
            

            
            addGestures()
            

        
        }
        else if ViewController.singlePlayer == false {
        
            resetInfo()
            read()
            
            player3.alpha = 0.3
            player4.alpha = 0.3
            
            print("ASDASFASJFKVHKASFHLWBRQWHR")
            print(ViewController.PeerMax[0])
            print(session.connectedPeers)
            if ViewController.PeerMax.count > 0
            {
                subMax = 2
                deviceName.text = UIDevice.current.name
                player2Name.text = ViewController.PeerMax[0].displayName
                self.playerArray.append(ViewController.PeerMax[0].displayName)
                
            }
            
            if ViewController.PeerMax.count > 1
            {
                subMax = 3
                player3Name.text = ViewController.PeerMax[1].displayName
                self.playerArray.append(ViewController.PeerMax[1].displayName)
                player3.alpha = 1
                
            }
            if ViewController.PeerMax.count > 2
            {
                subMax = 4
                player4Name.text = ViewController.PeerMax[2].displayName
                self.playerArray.append(ViewController.PeerMax[2].displayName)
                
            }
 
                addGestures()

            }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        self.removeFromParentViewController()
        
    }
    
    
    //**********************************************************
    // required functions for MCBrowserViewControllerDelegate
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is dismissed
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is cancelled
        dismiss(animated: true, completion: nil)
    }
    //**********************************************************
    // required functions for MCSessionDelegate
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        // this needs to be run on the main thread
        
        DispatchQueue.main.async(execute: {
            
            
            if let string = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
                
                if string == "A" || string == "B" || string == "C" || string == "D"
                {
                print("ASDHGWJKRGHQWKHRGKWHQVBRKQWR")
                print(peerID)
                self.answers += 1
                self.otherAnswers += 1
                
                
                    if ViewController.PeerMax[0] == peerID
                    {
                        self.player2Answer.text = string
                    }
                    else if ViewController.PeerMax[1] == peerID
                    {
                        self.player3Answer.text = string
                    
                    }
                    else
                    {
                        self.player4Answer.text = string
                    }
                }
            else if string == "switch"
                {
                    self.displayAnswer()
                }
            else if string == "restart"
                {
                    self.restartCount += 1
                }
            
            }
            
        })}

    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        //dispatch
        
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        // Called when a connected peer changes state (for example, goes offline)
        
        switch state {
        case MCSessionState.connected:
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
        
    }
    //**********************************************************
    
    
    func disableButtons()
    {
        optionA.isEnabled = false
        optionB.isEnabled = false
        optionC.isEnabled = false
        optionD.isEnabled = false
        optionA.isUserInteractionEnabled = false
        optionB.isUserInteractionEnabled = false
        optionC.isUserInteractionEnabled = false
        optionD.isUserInteractionEnabled = false
    }
 
    func enableButtons()
    {
        optionA.isEnabled = true
        optionB.isEnabled = true
        optionC.isEnabled = true
        optionD.isEnabled = true
        optionA.isUserInteractionEnabled = true
        optionB.isUserInteractionEnabled = true
        optionC.isUserInteractionEnabled = true
        optionD.isUserInteractionEnabled = true
    }
    
    func labelTimer() {
        time-=1
       
//        if time < 0 {
//        time+=15
//        }
        
         timeLabel.text = "\(time)"
        
    }
    
    func startGame()
    {
        self.QuestionNum.text = "Question \(self.questionNumber[self.i])/\(self.numberOfQuestions) "
        self.questionLabel.text = " \(self.questionItself[self.i])"
        self.optionA.text = "\(self.answerDict[self.i]["A"]!)"
        self.optionB.text = "\(self.answerDict[self.i]["B"]!)"
        self.optionC.text = "\(self.answerDict[self.i]["C"]!)"
        self.optionD.text = "\(self.answerDict[self.i]["D"]!)"
        self.correctAnswerToCompare = "\(self.correct[self.i])"
        print(questionItself)
        enableButtons()
        left = false
        right = false
        yawBeingChecked = false
        answerSubmitted = false
        AisTapped = false
        BisTapped = false
        CisTapped = false
        DisTapped = false
        answerLabel.text = "Quiz has begun!"
        time = 15
        timeLabel.text = "15"
        timer2 = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(displayAnswer), userInfo: nil, repeats: true)
    }
    
    func resetArrays()
    {
        self.questionNumber.removeAll()
        self.questionItself.removeAll()
        self.answersArray.removeAll()
        self.correct.removeAll()
        self.answerDict.removeAll()
        
    }
    
  ////♡♡♡♡♡♡♡♡ SUBMISSION OF ALL LABELS DOUBLE TAP ♡♡♡♡♡♡♡♡♡♡
    func submitA() {
        answerSubmitted = true
        submitted = optionA.text!
        devicePlayerAnswer.text = "A"
        answers += 1
        checkAnswers()
        
        
        if ViewController.singlePlayer == false
        {
        
            let data = "A"
            let send = NSKeyedArchiver.archivedData(withRootObject: data)
            do
            {
                try self.session.send(send, toPeers: session.connectedPeers, with: .reliable)
    
            }
            catch let error {
                
            }

        }
        

        disableButtons()
        

        if submitted == answerDict[i][correctAnswerToCompare]
        {
            print("Correct")

        }
        else
        {
        }
        
    
    
    }
    func submitB() {
        answerSubmitted = true
        submitted = optionB.text!
        devicePlayerAnswer.text = "B"
        answers += 1
        checkAnswers()
        
        
        if ViewController.singlePlayer == false
        {
        
            
            //self.browser.performSegue(withIdentifier: "segue", sender: self.browser)
            let data = "B"
            let send = NSKeyedArchiver.archivedData(withRootObject: data)
            do
            {
                try self.session.send(send, toPeers: session.connectedPeers, with: .reliable)
                
            }
            catch let error {
                print(error)
            }
            
        }
        
       
        disableButtons()
        
        //print(answerDict[i][correctAnswerToCompare])
        //if submitted == answerDict[i][correctAnswerToCompare] {
           // print("Correct")
       // }
    
    
    }
    func submitC() {
        answerSubmitted = true
        submitted = optionC.text!
        devicePlayerAnswer.text = "C"
        answers += 1
        checkAnswers()
        
        
        if ViewController.singlePlayer == false
        {
            
            //self.browser.performSegue(withIdentifier: "segue", sender: self.browser)
            let data = "C"
            let send = NSKeyedArchiver.archivedData(withRootObject: data)
            do
            {
                try self.session.send(send, toPeers: session.connectedPeers, with: .reliable)
                
            }
            catch let error {
                
            }
            
        }
        
        
        disableButtons()
        
       // print(answerDict[i][correctAnswerToCompare])
        if submitted == answerDict[i][correctAnswerToCompare] {
            print("Correct")
     }
    }
    
    func submitD() {
        answerSubmitted = true
        submitted = optionD.text!
        devicePlayerAnswer.text = "D"
        answers += 1
        checkAnswers()
        
        
        if ViewController.singlePlayer == false
        {
            
            //self.browser.performSegue(withIdentifier: "segue", sender: self.browser)
            let data = "D"
            let send = NSKeyedArchiver.archivedData(withRootObject: data)
            do
            {
                try self.session.send(send, toPeers: session.connectedPeers, with: .reliable)
                
            }
            catch let error {
                
            }
            
        }
 
        disableButtons()
      //  print(answerDict[i][correctAnswerToCompare])
        if submitted == answerDict[i][correctAnswerToCompare]
        {
            print("Correct")
        }
    
    }

    func checkAnswers()
    {
        if answers == subMax
        {
//            if ViewController.singlePlayer == false && otherAnswers == subMax - 1
//            {
//                let data = "switch"
//                let send = NSKeyedArchiver.archivedData(withRootObject: data)
//                do
//                {
//                    try self.session.send(send, toPeers: session.connectedPeers, with: .reliable)
//                    
//                }
//                catch let error {
//                    
//                }
            //}
            if ViewController.singlePlayer == true
            {
                displayAnswer()
            }
        }
        
    }

    
    // ♡♡♡♡♡♡♡♡ TAPPING OF ALL LABELS ♡♡♡♡♡♡♡♡♡♡
    func changeColor() {
        AisTapped = true
        BisTapped = false
        CisTapped = false
        DisTapped = false
        optionA.backgroundColor = UIColor.orange
        optionB.backgroundColor = UIColor.blue
        optionC.backgroundColor = UIColor.blue
        optionD.backgroundColor = UIColor.blue
    }
    
    func changeColorB() {
        AisTapped = false
        BisTapped = true
        CisTapped = false
        DisTapped = false
        optionB.backgroundColor = UIColor.orange
        optionA.backgroundColor = UIColor.blue
        optionC.backgroundColor = UIColor.blue
        optionD.backgroundColor = UIColor.blue
    }
    func changeColorC() {
        AisTapped = false
        BisTapped = false
        CisTapped = true
        DisTapped = false
        optionC.backgroundColor = UIColor.orange
        optionA.backgroundColor = UIColor.blue
        optionB.backgroundColor = UIColor.blue
        optionD.backgroundColor = UIColor.blue
    }
    func changeColorD() {
        AisTapped = false
        BisTapped = false
        CisTapped = false
        DisTapped = true
        optionD.backgroundColor = UIColor.orange
        optionA.backgroundColor = UIColor.blue
        optionB.backgroundColor = UIColor.blue
        optionC.backgroundColor = UIColor.blue
    }
    func resetColors()
    {
        AisTapped = false
        BisTapped = false
        CisTapped = false
        DisTapped = false
        optionD.backgroundColor = UIColor.blue
        optionA.backgroundColor = UIColor.blue
        optionB.backgroundColor = UIColor.blue
        optionC.backgroundColor = UIColor.blue
    }
    
    
    func resetInfo()
    {
        devicePlayerPoint.text = "0"
        player2Point.text = "0"
        player3Point.text = "0"
        player4Point.text = "0"
        devicePlayerAnswer.text = ""
        player2Answer.text = ""
        player3Answer.text = ""
        player4Answer.text = ""
    }
    
    func displayAnswer() {
        
        answers = 0
        otherAnswers = 0
        score()
        questionsAsked += 1
        if questionsAsked == (questionNumber.count)
        {
            endGame()
        }
        else
        {
            timeLabel.text = "3"
            time = 3
            //timer.invalidate()
            timer2.invalidate()
            answerLabel.text = "Correct Answer: \(correct[i]) "
            let timerReset = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(resetTimers), userInfo: nil, repeats: false)
        }
    }
    
    func score()
    {
    
       if subMax == 1
       {
            if devicePlayerAnswer.text == correct[i]
            {
                devicePlayerPoint.text = String(Int(devicePlayerPoint.text!)! + 1)
            }
        }
        if subMax > 1
        {
            if player2Answer.text == correct[i]
            {
                player2Point.text = String(Int(player2Point.text!)! + 1)
            }
            if devicePlayerAnswer.text == correct[i]
            {
                devicePlayerPoint.text = String(Int(devicePlayerPoint.text!)! + 1)
            }
        }
        if subMax > 2
        {
            if player3Answer.text == correct[i]
            {
                player3Point.text = String(Int(player3Point.text!)! + 1)
            }
        }
        if subMax > 3
        {
            if player4Answer.text == correct[i]
            {
                player4Point.text = String(Int(player4Point.text!)! + 1)
            }
        }
    }
    
    func endGame()
    {
        restartButton.isHidden = false
        restartButton.isEnabled = true
        if ViewController.singlePlayer == false
        {
        checkWinner()
        }
        timer2.invalidate()
        time = 10
        timeLabel.text = "10"
        let endGameTimer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(checkRestart), userInfo: nil, repeats: false)
    }
    
    func checkWinner()
    {
        var scoreArray = [Int]()
        var winnerArray = [Int]()
        var winnerCount = 0
        var highScore = 0
        if subMax > 0
        {
            scoreArray.append(Int(devicePlayerPoint.text!)!)
            winnerArray.append(0)
        }
        if subMax > 1
        {
            scoreArray.append(Int(player2Point.text!)!)
            winnerArray.append(0)
        }
        if subMax > 2
        {
            scoreArray.append(Int(player3Point.text!)!)
            winnerArray.append(0)
        }
        if subMax > 3
        {
            scoreArray.append(Int(player4Point.text!)!)
            winnerArray.append(0)
        }
        
        for i in 0 ..< scoreArray.count
        {
            if scoreArray[i] > highScore
            {
                highScore = scoreArray[i]
            }
        }
        
        
        if subMax > 1
        {
            if (Int(devicePlayerPoint.text!)) == highScore
            {
                winnerArray[0] = 1
                winnerCount += 1
            }
            
            if (Int(player2Point.text!)) == highScore
            {
                winnerArray[1] = 1
                winnerCount += 1
            }
        }
        if subMax > 2
        {
            if (Int(player3Point.text!)) == highScore
            {
                winnerArray[2] = 1
                winnerCount += 1
            }
        }
        if subMax > 3
        {
            if (Int(player4Point.text!)) == highScore
            {
                winnerArray[3] = 1
                winnerCount += 1
            }
        }
        
        if winnerArray[0] == 1 && winnerCount == 1
        {
            answerLabel.text = "Congratulations, you win!"
        }
        else if winnerArray[0] == 1  && winnerCount > 1
        {
            answerLabel.text = "You are one of the winners!"
        }
        else if winnerArray[0] == 0
        {
            answerLabel.text = "Sorry, you lose."
        }
    }
    
    func checkRestart()
    {
        timer.invalidate()
        timer2.invalidate()
        if restartCount == subMax
        {
            quiz += 1
            if quiz == 3
            {
                quiz = 1
            }
            self.viewDidLoad()
        }
        else
        {
        performSegue(withIdentifier: "back", sender: self)
            
        }
    }
    
    
    @IBAction func restart(_ sender: Any)
    {
        restartCount += 1
        restartButton.isEnabled = false
        let data = "restart"
        let send = NSKeyedArchiver.archivedData(withRootObject: data)
        do
        {
            try self.session.send(send, toPeers: session.connectedPeers, with: .reliable)
            
        }
        catch let error {
            
        }

    }
    
    
    func resetTimers()
    {
        time = 15
        timeLabel.text = "15"
        changeQuestion()
        answerSubmitted = false
        //timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(labelTimer), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(displayAnswer), userInfo: nil, repeats: true)
    }

    
    func readLocalJSONData(){
        print("inside read local JSON")
        
        let url = Bundle.main.url(forResource: "quiz1sample", withExtension: "json")
        let data = try? Data(contentsOf: url!)
        
        do {
            
            let object = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            if let dictionary = object as? [String: AnyObject] {
                 readJSONData(dictionary)
            }
            
        } catch {
            // Handle Erro
            print("here")
        }
    }
  
    func readJSONData(_ object: [String: AnyObject]) {
        if let topic = object["topic"] as? String,
            let numbQuest = object["numberOfQuestions"] as? Int,
            let questions = object["questions"] as? [[String: AnyObject]] {
            numberOfQuestions = numbQuest
            
            
           for question in questions{
                
            
            questionNumber.append(question["number"]! as! Int)
            questionItself.append(question["questionSentence"]! as! String)
            answerDict.append(question["options"] as! [String : String])
            
           // answerDict["A"] = "\(question["options"]?["A"])"
            
            correct.append(question["correctOption"] as! String)
            
            
            }
        }
    }

    
    func changeQuestion() {
        
        resetColors()
        
        i+=1
//        time-=1
//        timeLabel.text = "\(time)"
        print("change")
        
        answerLabel.text = "Submit your answer!"
        if i < questionNumber.count {
            QuestionNum.text = "Question \(questionNumber[i])/\(numberOfQuestions) "
            questionLabel.text = " \(questionItself[i])"
            optionA.text = "\(answerDict[i]["A"]!)"
            optionB.text = "\(answerDict[i]["B"]!)"
            optionC.text = "\(answerDict[i]["C"]!)"
            optionD.text = "\(answerDict[i]["D"]!)"
            //            optionB.text = "\(answersArray[i][1])"
            //            optionC.text = "\(answersArray[i][2])"
            //            optionD.text = "\(answersArray[i][3])"
            
            correctAnswerToCompare = "\(correct[i])"
            print(submitted)
            
          
            print(answerDict[i][correctAnswerToCompare]!)
            enableButtons()
//            if submitted == answerDict[i][correctAnswerToCompare] {
//                print("Correct")
//            
//            }
            
            
        }
        
       
        
        
       
    
    }
    
    @IBAction func testInc(_ sender: Any) {
        
        
        }
    
    
    
    func addGestures() {
    //Color Single tap gestures
        var gesture = UITapGestureRecognizer(target: self, action: #selector(QuizView.changeColor))
        gesture.numberOfTapsRequired = 1
        // if labelView is not set userInteractionEnabled, you must do so
        optionA.addGestureRecognizer(gesture)
        
        var gestureB = UITapGestureRecognizer(target: self, action: #selector(QuizView.changeColorB))
        gestureB.numberOfTapsRequired = 1
        // if labelView is not set userInteractionEnabled, you must do so
        optionB.addGestureRecognizer(gestureB)
        
        var gestureC = UITapGestureRecognizer(target: self, action: #selector(QuizView.changeColorC))
        gestureC.numberOfTapsRequired = 1
        // if labelView is not set userInteractionEnabled, you must do so
        optionC.addGestureRecognizer(gestureC)
        
        var gestureD = UITapGestureRecognizer(target: self, action: #selector(QuizView.changeColorD))
        gestureD.numberOfTapsRequired = 1
        // if labelView is not set userInteractionEnabled, you must do so
        optionD.addGestureRecognizer(gestureD)
   //Double tap gestures
        
        var doubleGestureA = UITapGestureRecognizer(target: self, action: #selector(QuizView.submitA))
        doubleGestureA.numberOfTapsRequired = 2
        // if labelView is not set userInteractionEnabled, you must do so
        optionA.addGestureRecognizer(doubleGestureA)
        
        var doubleGestureB = UITapGestureRecognizer(target: self, action: #selector(QuizView.submitB))
        doubleGestureB.numberOfTapsRequired = 2
        optionB.addGestureRecognizer(doubleGestureB)
        
        var doubleGestureC = UITapGestureRecognizer(target: self, action: #selector(QuizView.submitC))
        doubleGestureC.numberOfTapsRequired = 2
        // if labelView is not set userInteractionEnabled, you must do so

        optionC.addGestureRecognizer(doubleGestureC)
        
        var doubleGestureD = UITapGestureRecognizer(target: self, action: #selector(QuizView.submitD))
        doubleGestureD.numberOfTapsRequired = 2
        optionD.addGestureRecognizer(doubleGestureD)
        
    
    }
    
    
    func randomize() ->String {
        var counter = UInt32(array.count)
        var x = arc4random() % counter
        var y = Int(x)
        
        var randChosen = array[y]
        return randChosen
        
    }
    
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("motionEnded")
            
            
            var rand = randomize()
            
        while rand == MotionArrCheck[0] {
                rand = randomize()
                
            }
            
            MotionArrCheck.removeAll()
            MotionArrCheck.append(rand)
            
            if rand == "A" {
                changeColor()
            }
            if rand == "B" {
                changeColorB()
            }
            if rand == "C"
            { changeColorC()}
            if rand == "D" {
                changeColorD()
            }
            
            
            
        }
    }
    
    
    
    func read() {
        
        // URL OTHER TEST
        let urlString = "http://www.people.vcu.edu/~ebulut/jsonFiles/quiz" + "\(quiz)" + ".json"
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) {(data,response,error) in
            if error != nil
            {
                print("error")
                
            }
                
            else
            {
                
                if let content = data {
                    
                    do
                    {
                        //Array
                        let myJson = try JSONSerialization.jsonObject(with: content, options: .allowFragments)
                        print(myJson)
                        
                        self.readJSONData(myJson as! [String : AnyObject])
//                        self.QuestionNum.text = "Question \(self.questionNumber[self.i])/\(self.numberOfQuestions) "
//                        self.questionLabel.text = " \(self.questionItself[self.i])"
//                        self.optionA.text = "\(self.answerDict[self.i]["A"]!)"
//                        self.optionB.text = "\(self.answerDict[self.i]["B"]!)"
//                        self.optionC.text = "\(self.answerDict[self.i]["C"]!)"
//                        self.optionD.text = "\(self.answerDict[self.i]["D"]!)"
//                        self.correctAnswerToCompare = "\(self.correct[self.i])"
                        
                    }
 
                    catch {
                 
                    }
                    
                }
                
            }
            
        }
        task.resume()
    }

    
    
    
    func updateDeviceMotion(){
        
        if let data = QuizView.motionManager.deviceMotion {
            
            // orientation of body relat    ive to a reference frame
            let attitude = data.attitude
            
            let userAcc = data.userAcceleration
            
            let gravity = data.gravity
            let rotation = data.rotationRate
            
            //print("pitch: \(attitude.pitch), roll: \(attitude.roll), yaw: \(attitude.yaw)")
            
            //            if attitude.roll > 1.3 && attitude.pitch > 0.5 {
            //                print("tilt?")
            //
            //            }
            //
            
            
            
            
            if AisTapped == true && attitude.roll > 0.4 && answerSubmitted == false {
                //right go to B
                changeColorB()
            }
            
            if AisTapped == true && attitude.pitch < -0.1 && answerSubmitted == false {
                changeColorC()
            }
            
            
            
            if CisTapped == true && attitude.roll > 0.4 && answerSubmitted == false
            {
                changeColorD()
            }
            
            if CisTapped == true && attitude.pitch > 1 && answerSubmitted == false{
                changeColor()
                
            }
            if BisTapped == true && attitude.pitch < -0.1 && answerSubmitted == false
            {
                changeColorD()
            }
            
            if BisTapped == true && attitude.roll < -0.4 && answerSubmitted == false
            {
                changeColor()
            }
            if DisTapped == true && attitude.pitch > 1 && answerSubmitted == false
            {
                changeColorB()
                
            }
            if DisTapped == true && attitude.roll < -0.4 && answerSubmitted == false
            {
                changeColorC()
            }
            
            
            //Acceleration
            if AisTapped == true && userAcc.z < -1.2 {
                if answerSubmitted == false
                {
                submitA()
                }
            }
            if BisTapped == true && userAcc.z < -1.2 {
                if answerSubmitted == false
                {
                submitB()
                }
            }
            if CisTapped == true && userAcc.z < -1.2 {
                if answerSubmitted == false
                {
                submitC()
                }
            }
            if DisTapped == true && userAcc.z < -1.2 {
                if answerSubmitted == false
                {
                submitD()
                }
            }
            
            //YAw
            if (attitude.yaw > 1.0 ){
                left = true
                if yawBeingChecked == false
                {
                let yawTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(checkYaw), userInfo: nil, repeats: false)
                yawBeingChecked = true
                }
                
                
                //then //attitude.yaw < -1.0
                ///
                
            }
            
            if (attitude.yaw < -1.0 ){
                right = true
                if yawBeingChecked == false
                {
                    let yawTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(checkYaw), userInfo: nil, repeats: false)
                    yawBeingChecked = true
                }
                
                
                //then //attitude.yaw < -1.0
                ///
                
            }
//            if BisTapped == true && (attitude.yaw > 1.0 || attitude.yaw < -1.0  ){
//                submitB()
//            }
//            if CisTapped == true && (attitude.yaw > 1.0 || attitude.yaw < -1.0  ){
//                submitC()
//            }
//            if DisTapped == true && (attitude.yaw > 1.0 || attitude.yaw < -1.0  ){
//                submitD()
//            }
            
            
            //print("is moving left and right?? ")
            
        }
        
    }
    
    func checkYaw()
    {
        if left == true && right == true && answerSubmitted == false
        {
            if AisTapped == true
            {
                submitA()
            }
            if BisTapped == true
            {
                submitB()
            }
            if CisTapped == true
            {
                submitC()
            }
            if DisTapped == true
            {
                submitD()
            }
        }
        left = false
        right = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        QuizView.motionManager.deviceMotionUpdateInterval = 1.0/60.0
        QuizView.motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical)
        
        
        Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateDeviceMotion), userInfo: nil, repeats: true)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
