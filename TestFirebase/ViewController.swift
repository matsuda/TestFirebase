//
//  ViewController.swift
//  TestFirebase
//
//  Created by matsuda on 2018/04/11.
//  Copyright © 2018年 matsuda. All rights reserved.
//

import UIKit
import Crashlytics
import Firebase
import FirebaseFirestore

class ViewController: UIViewController {
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        do {
            let button = UIButton(type: .roundedRect)
            button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
            button.setTitle("Crash", for: [])
            button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
            view.addSubview(button)
        }
        do {
            let button = UIButton(type: .roundedRect)
            button.frame = CGRect(x: 20, y: 100, width: 100, height: 30)
            button.setTitle("Set", for: [])
            button.addTarget(self, action: #selector(self.setButtonTapped(_:)), for: .touchUpInside)
            view.addSubview(button)
        }
        db = Firestore.firestore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }

    @IBAction func setButtonTapped(_ sender: AnyObject) {
        addAdaLovelace()
        addAlanTuring()
        getCollection()

        setDocument()
        dataTypes()
        setData()
        addDocument()
        newDocument()
        updateDocument()
        createIfMissing()
        updateDocumentNested()
        serverTimestamp()
    }
}

extension ViewController {
    func addAdaLovelace() {
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "Ada",
            "last": "Lovelace",
            "born": 1815
            ], completion: { (err) in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
        })
    }

    func addAlanTuring() {
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "Alan",
            "middle": "Mathison",
            "last": "Turing",
            "born": 1912
            ], completion: { (err) in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
        })
    }

    func getCollection() {
        db.collection("users").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
}

extension ViewController {
    func setDocument() {
        db.collection("cities").document("LA").setData([
            "name": "Los Angeles",
            "state": "CA",
            "country": "USA"
        ]) { (err) in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    func dataTypes() {
        let docData: [String: Any] = [
            "stringExample": "Hello world!",
            "booleanExample": true,
            "numberExample": 3.14159265,
            "dateExample": Date(),
            "arrayExample": [5, true, "hello"],
            "nullExample": NSNull(),
            "objectExample": [
                "a": 5,
                "b": [
                    "nested": "foo"
                ]
            ]
        ]
        db.collection("data").document("one").setData(docData) { (err) in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    func setData() {
        let data: [String: Any] = [:]
        db.collection("cities").document("new-city-id").setData(data)
    }
    func createIfMissing() {
        db.collection("cities").document("BJ").setData(["capital" : true], options: SetOptions.merge())
    }
    func addDocument() {
        var ref: DocumentReference? = nil
        ref = db.collection("cities").addDocument(data: [
            "name": "Tokyo",
            "country": "Japan"
        ]) { (err) in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    func newDocument() {
        let newCityRef = db.collection("cities").document()
        newCityRef.setData([
            "name": "Some City Name"
        ])
    }
    func updateDocument() {
        let washingtonRef = db.collection("cities").document("DC")
        washingtonRef.updateData([
            "capital": true
        ]) { (err) in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    func updateDocumentNested() {
        let frankDocRef = db.collection("users").document("frank")
        frankDocRef.setData([
            "name": "Frank",
            "favorites": ["food": "Pizza", "color": "Blue", "subject": "recess"],
            "age": 12
        ])

        db.collection("users").document("frank").updateData([
            "age": 13,
            "favorites.color": "Red"
        ]) { (err) in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    func serverTimestamp() {
        db.collection("objects").document("some-id").updateData([
            "lastUpdated": FieldValue.serverTimestamp()
        ]) { (err) in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}

extension ViewController {
    func exampleData() {
        let citiesRef = db.collection("cities")

        citiesRef.document("SF").setData([
            "name": "San Francisco",
            "state": "CA",
            "country": "USA",
            "capital": false,
            "population": 860000
        ])

        citiesRef.document("LA").setData([
            "name": "Los Angeles",
            "state": "CA",
            "country": "USA",
            "capital": false,
            "population": 3900000
        ])

        citiesRef.document("DC").setData([
            "name": "Washington D.C.",
            "country": "USA",
            "capital": true,
            "population": 680000
        ])

        citiesRef.document("TOK").setData([
            "name": "Tokyo",
            "country": "Japan",
            "capital": true,
            "population": 9000000
        ])

        citiesRef.document("BJ").setData([
            "name": "Beijing",
            "country": "China",
            "capital": true,
            "population": 21500000
        ])
    }

    func getDocument() {
        let docRef = db.collection("cities").document("SF")
        docRef.getDocument { (document, error) in
            if let document = document {
                print("Document data: \(document.data())")
            } else {
                print("Document does not exist")
            }
        }
    }
}
