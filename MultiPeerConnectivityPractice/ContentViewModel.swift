//
//  ContentViewModel.swift
//  MultiPeerConnectivityPractice
//
//  Created by Kim Insub on 2022/09/26.
//

import SwiftUI
import MultipeerConnectivity
import AVFoundation

class ContentViewModel: NSObject, ObservableObject {

    @Published var number = 0
    @Published var numberLabel = "0"
    var audioPlayer: AVAudioPlayer?

    var peerId: MCPeerID
    var session: MCSession
    var nearbyServiceAdvertiser: MCNearbyServiceAdvertiser?

    override init() {
        peerId = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerId, securityIdentity: nil, encryptionPreference: .required)
        super.init()
        session.delegate = self
    }

    func startHosting() {
        nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(peer: peerId, discoveryInfo: nil, serviceType: "practice")
        nearbyServiceAdvertiser?.delegate = self
        nearbyServiceAdvertiser?.startAdvertisingPeer()
    }

    func joinSession() {
        let browser = MCBrowserViewController(serviceType: "practice", session: session)
        browser.delegate = self
        UIApplication.shared.windows.first?.rootViewController?.present(browser, animated: true)
    }

//    func sendData() {
//
//        self.number += 1
//        if session.connectedPeers.count > 0 {
//            if let textData = String(self.number).data(using: .utf8) {
//                do {
//                    try session.send(textData, toPeers: session.connectedPeers, with: .reliable)
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }

    func didTappedClickButton() {
        playClick()
        sendClickSign()
    }

    func playClick() {
        if let path =  Bundle.main.path(forResource: "click", ofType: ".wav") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func sendClickSign() {
        if session.connectedPeers.count > 0 {
            if let data = String("play").data(using: .utf8) {
                do {
                    try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension ContentViewModel: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("\(peerId) state: \(state)")
        switch state {
        case .notConnected:
            print("✅ not connected")
        case .connecting:
            print("✅ connecting")
        case .connected:
            print("✅ connected")
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let text = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                if text == "play" {
                    self.playClick()
                }
            }
        }
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }
}

extension ContentViewModel: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, session)
    }
}

extension ContentViewModel: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true)
    }
}
