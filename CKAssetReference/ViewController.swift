//
//  ViewController.swift
//  CKAssetReference
//
//  Created by Zel Marko on 4/7/16.
//  Copyright © 2016 Zel Marko. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		let imagePickerController = UIImagePickerController()
		imagePickerController.delegate = self
		imagePickerController.sourceType = .PhotoLibrary
		
		presentViewController(imagePickerController, animated: true, completion: nil)
	}

}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		
		let localPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).URLByAppendingPathComponent(NSUUID().UUIDString)
		
		let image = info[UIImagePickerControllerOriginalImage] as! UIImage
		let data = UIImageJPEGRepresentation(image, 0.1)
		data!.writeToURL(localPath, atomically: true)
		
		let asset = CKAsset(fileURL: localPath)
		let record = CKRecord(recordType: "Image")
		record["image"] = asset
		record["user"] = CKReference(recordID: CKRecordID(recordName: "UserID"), action: .DeleteSelf)
		// You can also use the CKReference(record: *userRecord*, action .DeleteSelf) if you alredy have the record
		
		CKContainer.defaultContainer().publicCloudDatabase.saveRecord(record) { (savedRecord, err) in
			if let err = err {
				print(err)
			} else {
				print(savedRecord)
			}
		}
		
	}
}

