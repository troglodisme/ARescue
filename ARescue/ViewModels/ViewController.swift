//
//  CercaViewModel.swift
//  Cerca
//
//  Created by Adolfo Vera Blasco on 24/06/2020.
//  Modified by Giulio Ammendola on 11/12/2022.
//

import NearbyInteraction
import MultipeerConnectivity

import Combine
import Foundation

    
class ViewController: NSObject, ObservableObject {
    
    //Variable added to  add extra description in the nearby view
    @Published  private(set) var peerDescription = ""
    
    @Published  var invitationClosed = false
    @Published  private(set) var peerName = ""
    
    @Published  private(set) var distanceToPeer: Float?
    @Published  private(set) var isDirectionAvailable = false
    @Published  private(set) var directionAngle = 0.0
    @Published  private(set) var isConnectionLost = false
    
    @Published  private(set) var nearbyObjectsDebug = ""
    
    
    @Published var peersCount: Int?
    
    private var nearbySession: NISession?
    private let serviceIdentity: String
    private var multipeerSession: MCSession?
    private var peer: MCPeerID?
    private var peerToken: NIDiscoveryToken?
    private var multipeerAdvertiser: MCNearbyServiceAdvertiser?
    private var multipeerBrowser: MCNearbyServiceBrowser?
    private var maxPeersInSession = 3
    private var sharedTokenWithPeer = false
    
    internal static var nearbySessionAvailable: Bool {
        return NISession.isSupported  //deprecated 16.0?
    }
    

    /**
     We start the `NearbyInteraction` sessions and from `MultipeerConnectivity`
     */
    override internal init() {
        
        // Avoid any simulator instances from finding any actual devices.
        #if targetEnvironment(simulator)
                self.serviceIdentity = "io.gomma.ARescue./simulator_ni"
        #else
                self.serviceIdentity = "io.gomma.ARescue./device_ni"
        #endif
        
        super.init()
        
        self.startNearbySession()
        self.startMultipeerSession()
    }
    
    /**
     
     */
    deinit {
        self.stopMultipeerSession()
        
        self.multipeerSession?.disconnect()
    }
    
    /**
     Start the `NearbyInteraction` session.
     `MultipeerConnectivity` session is also started in case it is the first time the app is started.
     */
    
    internal func startNearbySession() -> Void {
        
        // Create the NISession.
        self.nearbySession = NISession()
        
        // Now the delegate.
        // Receive data about the session state
        self.nearbySession?.delegate = self
        
        // It's a new session so we'll have to
        // exchange our token.
        sharedTokenWithPeer = false
        
        // If the `peer` variable exists it is because it has been restarted
        // the session so we have to share the token again.
        if self.peer != nil && self.multipeerSession != nil {
            
            if !self.sharedTokenWithPeer {
                shareTokenWithAllPeers()
            }
        }
        
        else {
            self.startMultipeerSession()
        }
    }
    
    /**
     Start the `MultipeerConnectivity` session
     
     The main thing is the three objects that are created here
     
     * `MCSession`: The MultipeerConnectivity session
     * `MCNearbyServiceAdvertiser`: It is in charge of telling everyone that
     we are here.
     * `MCNearbyServiceBrowser`: Tells us if there are other devices
     out there.
     
     All these objects have their respective delegates
     **where we receive status updates** of everything related
     with `MultipeerConnectivity`
     */
    
    private func startMultipeerSession() -> Void {
        
        if self.multipeerSession == nil {
            
            let localPeer = MCPeerID(displayName: UIDevice.current.name)
            
            self.multipeerSession = MCSession(peer: localPeer,
                                              securityIdentity: nil,
                                              encryptionPreference: .required)
            
            self.multipeerAdvertiser = MCNearbyServiceAdvertiser(peer: localPeer,
                                                                 discoveryInfo: [ "identity" : serviceIdentity],
                                                                 serviceType: "ARescue")
            
            self.multipeerBrowser = MCNearbyServiceBrowser(peer: localPeer,
                                                           serviceType: "ARescue")
            
            self.multipeerSession?.delegate = self
            self.multipeerAdvertiser?.delegate = self
            self.multipeerBrowser?.delegate = self
        }
        
        self.stopMultipeerSession()
        
        self.multipeerAdvertiser?.startAdvertisingPeer()
        self.multipeerBrowser?.startBrowsingForPeers()
    }
    
    /**
     We stop the services of *advertising* and
     *browsing* the `MultipeerConnectivity`
     */
    private func stopMultipeerSession() -> Void {
        self.multipeerAdvertiser?.stopAdvertisingPeer()
        self.multipeerBrowser?.stopBrowsingForPeers()
    }
    
    /**
     From here we share our token of
     `NearbyInteraction` with the other devices.
     */
    private func  shareTokenWithAllPeers() -> Void {
        
        guard let token = nearbySession?.discoveryToken,
              let multipeerSession = self.multipeerSession,
              let encodedData = try?  NSKeyedArchiver.archivedData(withRootObject: token, requiringSecureCoding: true)
        
        else {
            fatalError("That token cannot be encoded. 😭")
        }
        
        do {
            try self.multipeerSession?.send(encodedData,
                                            toPeers: multipeerSession.connectedPeers,
                                            with: .reliable)
        }
        
        catch let error {
            print("Cannot send token to devices. \(error.localizedDescription)")
        }
        
        // We have already shared the token.
        self.sharedTokenWithPeer = true
    }
}

//
// MARK: - NISessionDelegate protocol implementation -
//

extension ViewController: NISessionDelegate {
    
    /// The session is invalid.
    /// We must start another one.
    func session(_ session: NISession, didInvalidateWith error: Error) -> Void {
        self.startNearbySession()
    }
    
    /// The connection to the other device has been lost
    /// The session is invalid, we have to create another one.
    func session(_ session: NISession, didRemove nearbyObjects: [NINearbyObject], reason: NINearbyObject.RemovalReason) -> Void {
        session.invalidate()
        self.startNearbySession()
        
    }
    

    
    /// New distance and direction data
    func session(_ session: NISession, didUpdate nearbyObjects: [NINearbyObject]) -> Void {
        
        print(nearbyObjects)
        nearbyObjectsDebug = (nearbyObjects.debugDescription)

        
        guard let nearbyObject = nearbyObjects.first else {
            return
        }
        
        self.distanceToPeer = nearbyObject.distance
        
        if let direction = nearbyObject.direction {
            
            self.isDirectionAvailable = true
            self.directionAngle = Double(direction.x)
//            print(directionAngle)
//            self.directionAngle = direction.x > 0.0 ? 90.0 : -90.0
            
        }
        
        else {
            self.isDirectionAvailable = false
        }
    }
    
    /// The app returns to the foreground
    func sessionSuspensionEnded(_ session: NISession) -> Void {
        
        guard let peerToken = self.peerToken else {
            return
        }
        
        // Create the configuration..
        let config = NINearbyPeerConfiguration(peerToken: peerToken)
        
        // we close the session again
        self.nearbySession?.run(config)
        
        self.shareTokenWithAllPeers()
    }
    
    /// App goes in bacjground
    func sessionWasSuspended(_ session: NISession) -> Void {
        print("\(#function). I will be back... 🙋‍♂️")
    }
}

//
// MARK: - MCSessionDelegate protocol implementation -
//

extension ViewController: MCSessionDelegate {
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("\(#function)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("\(#function)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("\(#function)")
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        DispatchQueue.main.async {
            
            switch state {
                
            case .connected:
                self.peerName = peerID.displayName
                
                //added to check what else is available
                self.peerDescription = peerID.debugDescription
                
                self.shareTokenWithAllPeers()
                
                self.isConnectionLost = false
                
            case .notConnected:
                self.isConnectionLost = true
                
            case .connecting:
                self.peerName = "Finding Emergency Equipment"
                
            @unknown default:
                fatalError("A new state of the enumeration has appeared. I have no idea what to do.")
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        guard peerID.displayName == self.peerName else {
            //Data arrives from a client that is not the one with whom we have started the session
            
            return
        }
        
        guard let discoveryToken = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NIDiscoveryToken.self, from: data) else {
            fatalError("Failed to read the token from the other device.")
        }
        
        // Create the configuration
        let config = NINearbyPeerConfiguration(peerToken: discoveryToken)
        
        // Start the nearby interaction
        self.nearbySession?.run(config)
        // ...and save the client token in case I have
        // than to resume my session.
        self.peerToken = discoveryToken
        
        DispatchQueue.main.async {
            self.isConnectionLost = false
        }
        
    }
    
}

//
// MARK: - MCNearbyServiceAdvertiserDelegate protocol implementation -
//

extension ViewController: MCNearbyServiceAdvertiserDelegate {
    ///
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        guard let multipeerSession = self.multipeerSession else {
            return
        }
        
        // Only accept the invitation if the number of peers is less than the maximum
        if multipeerSession.connectedPeers.count < self.maxPeersInSession {
            invitationHandler(true, multipeerSession)
        }
    }
}

//
// MARK: - MCNearbyServiceBrowserDelegate protocol implementation -
//

extension ViewController: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        if self.peerName == peerID.displayName {
            
            self.isConnectionLost = true
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) -> Void  {
        
        guard let info = info,
              let identity = info["identity"],
              let multipeerSession = self.multipeerSession,
              (identity == self.serviceIdentity && multipeerSession.connectedPeers.count < self.maxPeersInSession)
        else {
            return
        }
        
        peersCount = multipeerSession.connectedPeers.count
        browser.invitePeer(peerID, to: multipeerSession, withContext: nil, timeout: 10)
        
    }
}


