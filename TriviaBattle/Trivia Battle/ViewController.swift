//
//  ViewController.swift
//  Trivia Battle
//
//  Created by Najia Haider on 4/24/17.
//  Copyright © 2017 Najia Haider. All rights reserved.
//

import UIKit
import MultipeerConnectivity
class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate  {

    
    @IBOutlet weak var singlePlayImage: UIImageView!
    
    
    @IBOutlet weak var multiPlayImage: UIImageView!
    
    static var session: MCSession!
    static var peerId: MCPeerID!
    
    static var browser: MCBrowserViewController!
    static var assistant: MCAdvertiserAssistant!
    var singlePlay = false
    var multiPlay = false
    static var singlePlayer = false
    static var PeerMax = [MCPeerID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        ViewController.PeerMax.removeAll()
        ViewController.singlePlayer = false
        ViewController.peerId = MCPeerID(displayName: UIDevice.current.name)
        ViewController.session = MCSession(peer: ViewController.peerId)
        ViewController.browser = MCBrowserViewController(serviceType: "chat", session: ViewController.session)
        ViewController.assistant = MCAdvertiserAssistant(serviceType: "chat", discoveryInfo: nil, session: ViewController.session)
        
        ViewController.assistant.start()
        ViewController.session.delegate = self
        ViewController.browser.delegate = self
        
    }
   
        
    @IBAction func connectPlayers(_ sender: Any)
    
    
    {
        
       // singlePlay = false
        //multiPlay = true
        present(ViewController.browser, animated: true, completion: nil)
        
        
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
    
    
    
    
    //**********************************************************
    // required functions for MCSessionDelegate
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        // this needs to be run on the main thread
      
        DispatchQueue.main.async(execute: {
            
            if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
                self.performSegue(withIdentifier: "segue", sender: self)
            }
            
        })
        
        
        
       
          
    }
    
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
             ViewController.PeerMax.append(peerID)
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
        
    }
    //**********************************************************
    
    
    
    
    @IBAction func singlePlayer(_ sender: Any) {
        singlePlay = true
        multiPlay = false
        singlePlayImage.alpha = 1.0
        multiPlayImage.alpha = 0.3
    
        
    }
    
    
    
    @IBAction func multiPlay(_ sender: Any) {
        singlePlay = false
        multiPlay = true
        multiPlayImage.alpha = 1.0
        singlePlayImage.alpha = 0.3
    }
    
    
    
    
    @IBAction func StartQuiz(_ sender: Any) {
    
        if singlePlay == true && multiPlay == false  {
              ViewController.singlePlayer = true
            performSegue(withIdentifier: "segue", sender: self)
           
        
        }
        
        if singlePlay == false && multiPlay == true {
            print(ViewController.PeerMax.count)
            if ViewController.session.connectedPeers.count == 0 {
            print("not going")
                let wonGame = UIAlertController(title: "No players connected!", message: "Connect a player", preferredStyle: UIAlertControllerStyle.alert)
                
                wonGame.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { (action) in wonGame.dismiss(animated: true, completion: nil)
                    
                  
                    
                }))
                //
                
                
                self.present(wonGame, animated: true, completion: nil)

                //print(PeerMax.count)
            }
            
            if ViewController.session.connectedPeers.count > 0 && ViewController.session.connectedPeers.count < 5 {
                performSegue(withIdentifier: "segue", sender: self)
                print("here")
                DispatchQueue.main.async(execute: {
                    
                   //self.browser.performSegue(withIdentifier: "segue", sender: self.browser)
                    let msg = "do segue"
                    let sendData = NSKeyedArchiver.archivedData(withRootObject: msg)
                    do {
                    try ViewController.session.send(sendData, toPeers: ViewController.session.connectedPeers, with: .unreliable)
                    
                    
                    }
                    catch let error {
                   
                    }
                    
                    
                    
                    
                })
                
            }
        
            
            if ViewController.session.connectedPeers.count > 4 {
                
                let wonGame = UIAlertController(title: "More than 4 Players!", message: "Disconnect", preferredStyle: UIAlertControllerStyle.alert)
                
                wonGame.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { (action) in wonGame.dismiss(animated: true, completion: nil)
                    
                    
                    
                }))
                //
                
                
                self.present(wonGame, animated: true, completion: nil)
                
            print("don't go")
            
            }
            
            
        }
        
    
    }
    
    
    func changeView() {
    performSegue(withIdentifier: "segue", sender: self)
    
    
    }
    
      
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

