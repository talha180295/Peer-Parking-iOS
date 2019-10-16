//
//  FindParkingViewController.swift
//  PeerParking
//
//  Created by Munzareen Atique on 04/09/2019.
//  Copyright © 2019 Munzareen Atique. All rights reserved.
//

import UIKit
import SideMenuController
import UIKit.UIGestureRecognizerSubclass

// MARK: - State

private enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

class FindParkingViewController: UIViewController ,SideMenuControllerDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{

    @IBOutlet weak var parkingCollection: UICollectionView!
    @IBOutlet weak var parkingListView: UIView!
    private let popupOffset: CGFloat = 400
    @IBOutlet var detailView: UIView!
    @IBOutlet weak var mainSchedule: CardView!
    @IBOutlet weak var mainPicker: CardView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnSave: UIButton!
   
    @IBOutlet weak var placeView: UIView!
    
    
    
    private lazy var overlayView: UIView = {
          let view = UIView()
          view.backgroundColor = .black
          view.alpha = 0
          return view
      }()
      
      private lazy var popupView: UIView = {
          let view = UIView()
          //view.backgroundColor = .white
          view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
          view.layer.shadowColor = UIColor.black.cgColor
          view.layer.shadowOpacity = 0.1
          view.layer.shadowRadius = 10
          return view
      }()
    
    @IBOutlet weak var tblLocation: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
      
//        self.tabBarController!.navigationItem.title = "Find Parking"
        self.tabBarController?.tabBar.items?[0].image = UIImage(named: "tab_findParking")!.withRenderingMode(.alwaysOriginal);
        self.tabBarController?.tabBar.items?[1].image = UIImage(named: "tab_N")!.withRenderingMode(.alwaysOriginal);
        self.tabBarController?.tabBar.items?[2].image = UIImage(named: "tab_sellParking")!.withRenderingMode(.alwaysOriginal);
        
        
         tabBarItem.selectedImage = UIImage(named: "tab_selected_findParking")?.withRenderingMode(.alwaysOriginal);
        
        parkingListView.isHidden = true
//        mainSchedule.isHidden = true
        // tblLocation.isHidden = true
        placeView.isHidden = true
       // btnSave.addShadowView(color: btnSave.backgroundColor!)
        
//        btnConfirm.addShadowView(color: btnSave.backgroundColor!)
//        btnCancel.addShadowView(color: UIColor.lightGray)
   
       
      //  loadView()
        
        tblLocation.dataSource = self
        tblLocation.delegate = self
        
        tblLocation.register(UINib(nibName: "LoacationCell", bundle: nil), forCellReuseIdentifier: "locationCell")
        // Do any additional setup after loading the view.
        
        parkingCollection.delegate = self
        parkingCollection.dataSource = self
               
       let nibName = UINib(nibName: "homeParkingCell", bundle:nil)
       
       parkingCollection.register(nibName, forCellWithReuseIdentifier: "homeParkingCell")
        
    

        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController!.navigationItem.title = "Find Parking"
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func locationBtn(_ sender: Any) {
        
       // tblLocation.isHidden = false
        placeView.isHidden = false
       
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return transactionArr.count
        return 10;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblLocation.dequeueReusableCell(withIdentifier: "locationCell") as! LoacationCell
        
        
        cell.selectionStyle = .none
        return  cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        parkingListView.isHidden = false
        placeView.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
           
           //        [collectionView.collectionViewLayout invalidateLayout];
           return 1
       }
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           
           
           return 10;
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
           
           let cell = parkingCollection.dequeueReusableCell(withReuseIdentifier: "homeParkingCell", for: indexPath) as! homeParkingCell
           
           
           return  cell;
       }
       
       
       
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
                layout()
                detailView.addGestureRecognizer(panRecognizer)
           //here
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           
           
          
           // let yourHeight = yourWidth
           
           
           return CGSize(width: 300, height: 134)
           
       }
    
  
    
    
    @IBAction func CancelClick(_ sender: Any) {
        // tblLocation.isHidden = true
        placeView.isHidden = true
        
         mainPicker.isHidden = true
        mainSchedule.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func SaveClick(_ sender: Any) {
       // tblLocation.isHidden = true
        placeView.isHidden = true
        mainPicker.isHidden = true
        mainSchedule.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
    }
    @IBAction func btnSchedule(_ sender: Any) {
        // tblLocation.isHidden = true
        placeView.isHidden = true
        mainSchedule.isHidden = false
        mainPicker.isHidden = true;
        self.tabBarController?.tabBar.isHidden = true
//        self.menuButton.isHidden = true
    }
    
    @IBAction func btnClickDate(_ sender: Any) {
//         tblLocation.isHidden = true
        placeView.isHidden = true
        mainPicker.isHidden = false
        mainSchedule.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
       
        
    }
    
 
    @IBAction func btnPlaceBack(_ sender: Any) {
        placeView.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func btnConfirmClick(_ sender: Any) {
        //tblLocation.isHidden = false
        placeView.isHidden = false
        mainPicker.isHidden = true
        mainSchedule.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "parkDetailVC") as! ParkingDetailViewController
        vc.strVC = "find"
         self.navigationController?.pushViewController(vc, animated: true)
       
        
    }
      
        
        @IBAction func presentAction() {
            present(ViewController.fromStoryboard, animated: true, completion: nil)
        }
        
        var randomColor: UIColor {
            let colors = [UIColor(hue:0.65, saturation:0.33, brightness:0.82, alpha:1.00),
                          UIColor(hue:0.57, saturation:0.04, brightness:0.89, alpha:1.00),
                          UIColor(hue:0.55, saturation:0.35, brightness:1.00, alpha:1.00),
                          UIColor(hue:0.38, saturation:0.09, brightness:0.84, alpha:1.00)]
            
            let index = Int(arc4random_uniform(UInt32(colors.count)))
            return colors[index]
        }
        
        func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
            print(#function)
        }
        
        func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
            print(#function)
        }

//////////////animation
    
    
    @IBAction func btnBackDetail(_ sender: Any) {
  
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
         self.overlayView.alpha = 0
        detailView.removeFromSuperview()
     //   popupView.removeFromSuperview()
        
    
        
    }
    
    
 override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Layout
    
    private var bottomConstraint = NSLayoutConstraint()
    
    private func layout() {
        

        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        overlayView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        detailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailView)
        detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: popupOffset)
        bottomConstraint.isActive = true
        detailView.heightAnchor.constraint(equalToConstant: (self.view.frame.size.height - 30)).isActive = true
      //  popupView.addSubview(innerView)
//        detailView.translatesAutoresizingMaskIntoConstraints = false
//        popupView.addSubview(detailView)
//        detailView.leadingAnchor.constraint(equalTo: popupView.leadingAnchor,constant: 5).isActive = true
//        detailView.trailingAnchor.constraint(equalTo: popupView.trailingAnchor,constant: 5).isActive = true
//        detailView.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 10).isActive = true
        self.overlayView.alpha = 0.5
        
    }
    
    // MARK: - Animation
    
    /// The current state of the animation. This variable is changed only when an animation completes.
    private var currentState: State = .closed
    
    /// All of the currently running animators.
    private var runningAnimators = [UIViewPropertyAnimator]()
    
    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    private var animationProgress = [CGFloat]()
    
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(popupViewPanned(recognizer:)))
        return recognizer
    }()
    
    /// Animates the transition, if the animation is not already running.
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        
        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }
        
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
                self.popupView.layer.cornerRadius = 20
               // self.overlayView.alpha = 0.5
              
            case .closed:
                self.bottomConstraint.constant = self.popupOffset
                self.popupView.layer.cornerRadius = 0
               // self.overlayView.alpha = 0
               
            }
            self.view.layoutIfNeeded()
        })
        
        // the transition completion block
        transitionAnimator.addCompletion { position in
            
            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            
          
            // manually reset the constraint positions
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = self.popupOffset
            }
            
            // remove all running animators
            self.runningAnimators.removeAll()
            
        }
        
        let inTitleAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn, animations: {
                      switch state {
                      case .open:
                        
                        print("open")
                        //  self.openTitleLabel.alpha = 1
                      case .closed:
                        print("close")
                         // self.closedTitleLabel.alpha = 1
                      }
                  })
                  
        inTitleAnimator.scrubsLinearly = false
          transitionAnimator.startAnimation()
        // an animator for the title that is transitioning into view
        inTitleAnimator.startAnimation()
        
        runningAnimators.append(inTitleAnimator)
        // keep track of all running animators
        runningAnimators.append(transitionAnimator)
       
        
    }
    
    @objc private func popupViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            
            // start the animations
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1)
            
            // pause all animations, since the next event may be a pan changed
            runningAnimators.forEach { $0.pauseAnimation() }
            
            // keep track of each animator's progress
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            
            // variable setup
            let translation = recognizer.translation(in: popupView)
            var fraction = -translation.y / popupOffset
            
            // adjust the fraction for the current state and reversed state
            if currentState == .open { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            
            // variable setup
            let yVelocity = recognizer.velocity(in: popupView).y
            let shouldClose = yVelocity > 0
            
            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .open:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
            
        default:
            ()
        }
    }
    
}

// MARK: - InstantPanGestureRecognizer

/// A pan gesture that enters into the `began` state on touch down instead of waiting for a touches moved event.
class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
    
}

