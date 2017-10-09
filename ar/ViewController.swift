//
//  ViewController.swift
//  ar
//
//  Created by Said Murvatov on 13/09/2017.
//  Copyright © 2017 Said Murvatov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var addCube: UIButton!
    @IBOutlet weak var addCup: UIButton!
    @IBOutlet weak var addText: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    @IBAction func addCube(_ sender: Any) {
        //create node with geometry of SCNBox
        let cube: SCNNode = SCNNode(geometry: SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0))
        cube.position = SCNVector3(x: 0, y: 0, z: -1) //set position
        sceneView.scene.rootNode.addChildNode(cube) //add to main rootnode this node
        let cordinates = getCameraCoordinates(sceneView: sceneView)
        cube.position = SCNVector3(cordinates.x, cordinates.y, cordinates.z-1)
    }
    
    func initText() {
        let text: SCNNode = SCNNode(geometry: SCNText(string: "WELCOME TO AUGMENTED REALITY BITCH", extrusionDepth: CGFloat(0.1)))
        text.name = "text"
        let cordinates = getCameraCoordinates(sceneView: sceneView)
        text.position = SCNVector3(cordinates.x, cordinates.y, cordinates.z-1)
        //text.position = SCNVector3(x: 0, y: 0, z: 1)
        text.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        sceneView.scene.rootNode.addChildNode(text)
    }
    
    @IBAction func addText(_ sender: Any) {
        initText()
    }
    
    
    @IBAction func addCup(_ sender: Any) {
        let cup: SCNNode = SCNNode(geometry: SCNCylinder(radius: 0.2, height: 0.2))
        cup.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        let cordinates = getCameraCoordinates(sceneView: sceneView)
        cup.position = SCNVector3(cordinates.x, cordinates.y, cordinates.z-1)
        sceneView.scene.rootNode.addChildNode(cup)
        cup.physicsBody?.velocityFactor.x = 10
        cup.physicsBody?.velocityFactor.y = 0
        cup.physicsBody?.velocityFactor.z = 0
        //sceneView.scene.rootNode.childNode(withName: "text", recursively: false)?.removeFromParentNode()
    }
    
    
    struct myCameraCoordinates {
        var x = Float()
        var y = Float()
        var z = Float()
    }
    
    func getCameraCoordinates(sceneView: ARSCNView) -> myCameraCoordinates {
        let cameraTransform = sceneView.session.currentFrame?.camera.transform
        let cameraCoordinates = MDLTransform(matrix: cameraTransform!)
        
        var cc = myCameraCoordinates()
        cc.x = cameraCoordinates.translation.x
        cc.y = cameraCoordinates.translation.y
        cc.z = cameraCoordinates.translation.z
        
        return cc
    }
    func getCamera(node: SCNNode) {
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -2 // Translate 10 cm in front of the camera
        node.simdTransform = matrix_multiply((sceneView.session.currentFrame?.camera.transform)!, translation)
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
