//
//  AppDelegate.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 12.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //
    // MARK: repository/model related variables
    //
    
    var memes: [Meme] = []
    enum memeOrder {
        case asc
        case desc
        case rand
    }
    
    //
    // MARK: repository/model related functions
    //
    
    // append meme to current struct array and sort my array to comply tableView latest-item-first rendering
    func addMeme(meme: Meme) {
        unfreshMemes()
        memes.append(meme)
        sortMemes(direction: memeOrder.asc)
    }
    
    // replace the icoming image on corresponding position, execute sortMemes(ASC) to show this item on top of tableView
    func replaceMeme(meme: Meme, index: Int) {
        memes[index] = meme
        sortMemes(direction: memeOrder.asc)
    }
    
    // remove meme from current struct array and (re) sort corresponding array
    func removeMeme(index: Int) {
        memes.remove(at: index)
        sortMemes(direction: memeOrder.asc)
    }
    
    func sortMemes(direction: memeOrder) {
        
        switch direction {
        case .asc:
            memes.sort { $0.created! > $1.created! }
        case .desc:
            memes.sort { $0.created! < $1.created! }
        case .rand:
            memes.shuffle()
        }
    }
    
    func unfreshMemes() {
        for index in 0..<memes.count {
            memes[index].fresh = false
        }
    }
    
    //
    // MARK: repository/model fixture load related functions
    //
    
    // loading fixtures for testing tableView/editView/collectionView without creating memes manually
    func loadFixtures() {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: NSLocale.current.languageCode!)
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        let memeFixtureData = [
            // 0: textTop, 1: textBottom, 2: imageOrigin, 3: image, 4: created
            ("I'm on a strict diet", "Whiskey and rare steak", "sample-meme-1", "sample-meme-1", "2016-10-21 06:00:00"),
            ("Feelings?", "Never heard of them", "sample-meme-2", "sample-meme-2", "2016-10-21 07:00:00"),
            ("Salad?", "Thats what my food eats!", "sample-meme-3", "sample-meme-3", "2016-10-21 08:00:00"),
            ("How would you like your steak?", "Breathing!", "sample-meme-4", "sample-meme-4", "2016-10-21 09:00:00"),
            ("Breaks?", "You mean the coward pedal", "sample-meme-5", "sample-meme-5", "2016-10-21 10:00:00"),
            ("Therapist?", "You mean bartender", "sample-meme-6", "sample-meme-6", "2016-10-21 11:00:00"),
        ]
        
        var meme: Meme
        
        for (_textTop, _textBottom, _imageOrigin, _image, _created) in memeFixtureData {

            meme = Meme(
                textTop: _textTop,
                textBottom: _textBottom,
                imageOrigin:  UIImage(named: _imageOrigin),
                image:  UIImage(named: _image),
                created: dateFormatter.date(from: _created)!,
                fresh: false
            )
            
            addMeme(meme: meme)
        }
    }

    //
    // MARK: application entryPoint functions
    //
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        loadFixtures()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

