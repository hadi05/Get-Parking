//
//  ParkingStatusViewController.swift
//  Get Parking
//
//  Created by adil on 08/09/2018.
//

import UIKit
import FirebaseDatabase
import Firebase
import MapKit


class ParkingStatusViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ref = Database.database().reference()
    var path:String?
    
    @IBOutlet weak var occupiedParkingLots: UILabel!
    @IBOutlet weak var reservedParkingLots: UILabel!
    @IBOutlet weak var freeParkingLots: UILabel!
    @IBOutlet weak var totalParkingLots: UILabel!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var advanceBooking: UIButton!
    @IBOutlet weak var selectParkingDestination: UITextField!
    @IBOutlet weak var mallTitle: UILabel!
    
    var parkingAreas = ["Amanah Mall", "Emporium Mall", "Expo Centre", "Packages Mall", "University of Lahore"]
    var freeParkingSlots : String?
    
    //var selectedCarModel : String?
    
    //var carBrand: NSArray!
    //    var parkingStatus : NSArray!
    
    var locationManager = CLLocationManager()
    var userLocation = CLLocationCoordinate2D()
    var parkringHasRequested = false
    

    
    var parking = [Parking]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //setting picker to select parking area
        let picker = UIPickerView()
        picker.delegate = self
        picker.showsSelectionIndicator = true
        selectParkingDestination.inputView = picker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.donePicker))
        
        
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        selectParkingDestination.inputAccessoryView = toolBar
        
        // setting user location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.isScrollEnabled = true
        
        
        // function to cancel request after signOut
        if let email = Auth.auth().currentUser?.email{
            ref.child("parkingRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (snapshot) in
                self.parkringHasRequested = true
                self.advanceBooking.setTitle("Cancel Request", for: .normal)
                self.ref.child("parkingRequests").removeAllObservers()
            }
        }
    }
    
    // fetching status from firebase
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return parkingAreas.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return parkingAreas[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectParkingDestination.text = parkingAreas[row]
        //     self.view.endEditing(true)
        
    }
    
    @objc func donePicker(){
        
        
        var freeSlots = 0
        var reservedSlots = 0
        var occupiedSlots = 0
        var parkingStatus = [String]()
        var freelots : String?
        
        
        mallTitle.text = selectParkingDestination.text
        self.view.endEditing(true)
        
        let selectedparkingArea = selectParkingDestination.text
        path = "parkingAreas/\(selectedparkingArea ?? "" )"
        ref.child(path!).observe(.value, with: { snapshot in
            //     let values = snapshot.value as! [String : AnyObject]
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
         
            
            for (key, value) in postDict {
                parkingStatus.append("\(key) \(value)")
                
//                let parking = Parking()
//                parking.name = key as String
//                parking.status = value as? String
//                self.parking.append(parking)
                
                if (value as! String == "free") {
                    freeSlots += 1
                    break
                    freelots = key
                    
                } else if (value as! String == "reserved") {
                    reservedSlots += 1
                } else if (value as! String == "occupied") {
                    occupiedSlots += 1
                }
            }
            
           
            
            
            if freeSlots == 0{
                self.advanceBooking.isEnabled = true
            }
            self.freeParkingSlots = freelots
            self.totalParkingLots.text = String(parkingStatus.count)

//            print(freeSlots)
//            print(occupiedSlots)
//            print(reservedSlots)
            
//            print(self.parking)
            
            self.freeParkingLots.text = String(freeSlots)
            self.reservedParkingLots.text = String(reservedSlots)
            self.occupiedParkingLots.text = String(occupiedSlots)
            
            freeSlots = 0
            occupiedSlots = 0
            reservedSlots = 0
        
        })
    }
    
    // getting user location and setting Annotation
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = manager.location?.coordinate{
            let center = CLLocationCoordinate2D(latitude: coord.latitude, longitude: coord.longitude)
            userLocation = center
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            map.setRegion(region, animated: false)
            
            map.removeAnnotations(map.annotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = center
            annotation.title = "Your Location"
            map.addAnnotation(annotation)
        }
    }
    
    @IBAction func advanceBookingPressed(_ sender: Any) {
        
        let parkingLotPath = path! + "/\(freeParkingSlots!)"
        print(parkingLotPath)
        
        if let email = Auth.auth().currentUser?.email{
            print(parkingLotPath)
            self.ref.child(parkingLotPath).setValue("free")
            
            if parkringHasRequested{
                parkringHasRequested = false
                
                advanceBooking.setTitle("Advance Booking", for: .normal)
                
                // query to delete the parking request for the current user signed in
                ref.child("parkingRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (snapshot) in
                    snapshot.ref.removeValue()
                    self.ref.child("parkingRequests").removeAllObservers()
                }
            }else{
                
                // sending the parking request with current user's information to the parking server
                let parkingRequestDictionary : [String : Any] = ["email":email, "lat":userLocation.latitude, "long": userLocation.longitude, "parkingLot": freeParkingSlots!]
                ref.child("parkingRequests").childByAutoId().setValue(parkingRequestDictionary)
                parkringHasRequested = true
                self.ref.child(parkingLotPath).setValue("reserved")
                print(parkingLotPath)
                advanceBooking.setTitle("Cancel Booking", for: .normal)
             
                
            }
        }
    }
    
//    @IBAction func advanceBookingPressed(_ sender: Any) {
//
//        let parkingLotPath = path! + "/\(freeParkingSlots!)"
//        print(parkingLotPath)
//
//        if let email = Auth.auth().currentUser?.email{
//            self.ref.child(parkingLotPath).setValue("free")
//
//            if parkringHasRequested{
//                parkringHasRequested = false
//
//                advanceBooking.setTitle("Advance Booking", for: .normal)
//
//                // query to delete the parking request for the current user signed in
//                ref.child("parkingRequests").queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (snapshot) in
//                    snapshot.ref.removeValue()
//                    self.ref.child("parkingRequests").removeAllObservers()
//                }
//            }else{
//
//                // sending the parking request with current user's information to the parking server
//                let parkingRequestDictionary : [String : Any] = ["email":email, "lat":userLocation.latitude, "long": userLocation.longitude, "parkingLot": freeParkingSlots!]
//                ref.child("parkingRequests").childByAutoId().setValue(parkingRequestDictionary)
//                parkringHasRequested = true
//                self.ref.child(parkingLotPath).setValue("reserved")
//                print(parkingLotPath)
//                advanceBooking.setTitle("Cancel Booking", for: .normal)
//
//            }
//        }
//    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        // hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        // create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil{
                print("error")
            }else{
                //remove annotations
                //                let annotations = self.map.annotations
                //                self.map.removeAnnotations(annotations)
                
                // getting data (lat and long)
                let lat = response?.boundingRegion.center.latitude
                let long = response?.boundingRegion.center.longitude
                
                // setting destination annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(lat!, long!)
                self.map.addAnnotation(annotation)
                
                //zooming in to annotation
                let coordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat!, long!)
                let span = MKCoordinateSpanMake(0.01, 0.01)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.map.setRegion(region, animated: true)
                
            }
        }
        
    }
    @IBAction func searchButton(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    @IBAction func signOut(_ sender: Any) {
        try! Auth.auth().signOut()
        //    navigationController?.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "welcome", sender: nil)
    }
}














//            for item in snapshot.children.enumerated(){
//                print(item)
//                guard let dic = item as? [String:Any] else {
//                    print("Not a dic vaue")
//                    return
//                }
//            }

//            for item in self.parkingStatus{
//
//                print(item)
//            }

/*
 data = JSON Dictonary
 
 // get one object from dictornary
 for () {
 if (free){
 free++
 }
 else if (reserved){
 res++
 }
 else if (occupied){
 occ ++
 }
 
 }
 
 */

/*
 func viewWillAppear(_ animated: Bool) {
 locationManager.startUpdatingLocation()
 }*/

