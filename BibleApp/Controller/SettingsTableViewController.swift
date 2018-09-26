//
//  SettingsTableViewController.swift
//  BibleApp
//
//  Created by Min Kim on 8/23/18.
//  Copyright © 2018 Min Kim. All rights reserved.
//

import UIKit
import Intents
import IntentsUI

class SettingsTableViewController: UITableViewController {
    
    var dominantHand: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        dominantHand = UserDefaults.standard.string(forKey: "DominantHand")
        if dominantHand == nil {
            UserDefaults.standard.set("Left", forKey: "DominantHand")
            dominantHand = "Left"
            tableView.reloadData()
        }
        tableView = UITableView(frame: .zero, style: .grouped)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Settings"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SettingsColorTableViewCell.self, forCellReuseIdentifier: "color")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return 1
        } else {
        return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Appearance"
        case 1:
            return "Dominant Hand"
        case 2:
            return "Siri Custom Shortcuts"
        default:
            return "Test"
        }
    }
    
    var heightOfColorRow: CGFloat = 0
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1 {
            return heightOfColorRow
        } else {
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Set Main Accent Color"
            return cell
        case (0,1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "color", for: indexPath) as! SettingsColorTableViewCell
            cell.selectionStyle = .none
            cell.containerView.isHidden = true
            cell.sendColor = { (color) -> () in
                guard let color = color else {return}
                self.receivedColor(color: color)
            }
            return cell
        case (1,0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Left Hand"
            if dominantHand == "Left" {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        case (1,1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Right Hand"
            if dominantHand == "Right" {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        case (2,0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Convert Clipboard to Search Bible Verse"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    
    func receivedColor(color: UIColor) {
//        let defaults = UserDefaults.standard
////        defaults.set(color, forKey: "MainColor")
//        tabBarController?.tabBar.tintColor = color
//        defaults.set(color, forKey: "MainColor")
//
//        let newColor = defaults.object(forKey: "MainColor") as! UIColor
//        print("New Color is \(newColor)")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            heightOfColorRow = 60
            tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            let index = IndexPath(row: 1, section: 0)
            let cell = tableView.cellForRow(at: index) as! SettingsColorTableViewCell
            cell.containerView.isHidden = false
        case (1,0):
            let cell = tableView.cellForRow(at: indexPath)
            if dominantHand == "Right" {
                cell?.accessoryType = .checkmark
                let defaults = UserDefaults.standard
                defaults.set("Left", forKey: "DominantHand")
                dominantHand = "Left"
                let otherIndex = IndexPath(row: 1, section: 1)
                let otherCell = tableView.cellForRow(at: otherIndex)
                otherCell?.accessoryType = .none
            }
        case (1,1):
            let cell = tableView.cellForRow(at: indexPath)
            if dominantHand == "Left" {
                cell?.accessoryType = .checkmark
                let defaults = UserDefaults.standard
                defaults.set("Right", forKey: "DominantHand")
                dominantHand = "Right"
                let otherIndex = IndexPath(row: 0, section: 1)
                let otherCell = tableView.cellForRow(at: otherIndex)
                otherCell?.accessoryType = .none
            }
        case (2,0):
            if #available(iOS 12.0, *) {
                let intent = SearchBibleIntentIntent()
                intent.book = "Matthew"
                intent.chapter = 1
                intent.verse = 10
                guard let shortcut = INShortcut(intent: intent) else {return}
                let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
                viewController.delegate = self
                present(viewController, animated: true)
            } else {
                // Fallback on earlier versions
            }
            
        default:
            return
        }
    }

}

@available(iOS 12.0, *)
extension SettingsTableViewController: INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
