//
//  ViewController.swift
//  Stonehenge
//
//  Created by Ryan Shelby on 10/5/14.
//  Copyright (c) 2014 Ryan Shelby. All rights reserved.
//

import SceneKit
import SpriteKit
import Foundation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let scene = SCNScene()
        let sceneView = SCNView()
        sceneView.frame = self.view.frame
        sceneView.autoresizingMask = UIViewAutoresizing.allZeros
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.blueColor()
        self.view = sceneView
        
        //Add camera to scene.
        let camera = self.makeCamera()
        scene.rootNode.addChildNode(camera)
        
        //Add some ambient light so it's not so dark.
        let lights = self.makeAmbientLight()
        scene.rootNode.addChildNode(lights)
        
        //Create and add the floor.
        let floor = self.makeFloor()
        scene.rootNode.addChildNode(floor)
        
        self.buildStonehenge(scene)
    }
    
    func makeCamera() -> SCNNode {
        let camera = SCNCamera()
        let cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(x: 0, y: 35, z: 120)
        camera.zFar = 1000
        return cameraNode
    }
    
    func makeAmbientLight() -> SCNNode{
        let lightNode = SCNNode()
        let light = SCNLight()
        light.type = SCNLightTypeAmbient
        light.color = SKColor(white: 0.1, alpha: 1)
        lightNode.light = light
        return lightNode
    }
    
    func makeFloor() -> SCNNode {
        let floor = SCNFloor()
        floor.reflectivity = 0
        let floorNode = SCNNode()
        floorNode.geometry = floor
        let floorMaterial = SCNMaterial()
        floorMaterial.litPerPixel = false
        floorMaterial.diffuse.contents = UIImage(named:"green2.png")
        floorMaterial.diffuse.wrapS = SCNWrapMode.Repeat
        floorMaterial.diffuse.wrapT = SCNWrapMode.Repeat
        floor.materials = [floorMaterial]
        return floorNode
    }
    
    func buildStonehenge(scene: SCNScene){
        
        let radius: Double = 30.0
        let numberOfStones = 30
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "rock.jpg")
        material.specular.contents = UIImage(named: "rock.jpg")
        
        //Create the base stones.
        let baseStone = SCNBox(width: 4.5, height: 8, length: 3.25, chamferRadius: 0.5)
        baseStone.materials = [material]
        let baseStones = self.buildCircleOfObjects(baseStone, numberOfItems: numberOfStones, radius: radius)
        baseStones.position = SCNVector3(x: 0, y: 4, z: 0)
        scene.rootNode.addChildNode(baseStones)
        
        //Create the top header stones.
        let topStone = SCNBox(width: 6, height: 1.75, length: 3.25, chamferRadius: 0.5)
        topStone.materials = [material]
        
        let rotateY: Float = Float(M_PI) / Float(30)
        let topStones = self.buildCircleOfObjects(topStone, numberOfItems: numberOfStones, radius: radius)
        topStones.position = SCNVector3(x: 0, y: 8.9, z:0)
        topStones.rotation = SCNVector4(x: 0, y: 1, z: 0, w: rotateY)
        scene.rootNode.addChildNode(topStones)
        
        //Create the inner circle of little stones.
        let littleStone = SCNBox(width: 2, height: 4, length: 2, chamferRadius: 0.5)
        littleStone.materials = [material]
        let littleStones = self.buildCircleOfObjects(littleStone, numberOfItems: numberOfStones, radius: 24.0)
        littleStones.position = SCNVector3(x: 0 , y:2, z:0)
        scene.rootNode.addChildNode(littleStones)
        
        
        //Create the 5 inner structures.
        var structure1 = centerStructure(SCNVector3(x: 0 , y:0, z: -12.5))
        scene.rootNode.addChildNode(structure1)
        
        let structure2 = centerStructure(SCNVector3(x: -12 , y:0, z: -5))
        structure2.rotation = SCNVector4(x: 0, y: 1, z: 0, w: 1.4)
        scene.rootNode.addChildNode(structure2)
        
        let structure3 = centerStructure(SCNVector3(x: 12 , y:0, z:-5))
        structure3.rotation = SCNVector4(x: 0, y: 1, z: 0, w: -1.4)
        scene.rootNode.addChildNode(structure3)
        
        let structure4 = centerStructure(SCNVector3(x: -13 , y:0, z:10))
        structure4.rotation = SCNVector4(x: 0, y: 1, z: 0, w: 1.8)
        scene.rootNode.addChildNode(structure4)
        
        let structure5 = centerStructure(SCNVector3(x: 13 , y:0, z:10))
        structure5.rotation = SCNVector4(x: 0, y: 1, z: 0, w: -1.8)
        scene.rootNode.addChildNode(structure5)
        
    }
    
    func buildCircleOfObjects(_geometry: SCNGeometry, numberOfItems: Int, radius: Double) -> SCNNode{
        
        var x: Double = 0.0
        var z: Double = radius
        let theta: Double = (M_PI) / Double(numberOfItems / 2)
        let incrementalY: Double = (M_PI) / Double(numberOfItems) * 2
        
        let nodeCollection = SCNNode()
        nodeCollection.position = SCNVector3(x: 0, y: 4, z: 0)
        
        for index in 1...numberOfItems {
            
            x = radius * sin(Double(index) * theta)
            z = radius * cos(Double(index) * theta)
            
            let node = SCNNode(geometry: _geometry)
            node.position = SCNVector3(x: Float(x), y: 0, z:Float(z))
            
            let rotation = Float(incrementalY) * Float(index)
            node.rotation = SCNVector4(x: 0, y: 1, z: 0, w: rotation)
            nodeCollection.addChildNode(node)
            
        }
        
        return nodeCollection
        
    }
    
    func centerStructure(vector3: SCNVector3) -> SCNNode{
        
        let parentNode = SCNNode()
        parentNode.position = vector3
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "rock.jpg")
        material.specular.contents = UIImage(named: "rock.jpg")
        
        let leftStone = SCNBox(width: 4.25, height: 12, length: 3.25, chamferRadius: 0.5)
        leftStone.materials = [material]
        let leftStoneNode = SCNNode(geometry: leftStone)
        leftStoneNode.position = SCNVector3(x: -3 , y:6, z:0)
        parentNode.addChildNode(leftStoneNode)
        
        let rightStone = SCNBox(width: 4.25, height: 12, length: 3.25, chamferRadius: 0.5)
        let rightStoneNode = SCNNode(geometry: rightStone)
        rightStoneNode.position = SCNVector3(x: 3 , y:6, z:0)
        rightStone.materials = [material]
        parentNode.addChildNode(rightStoneNode)
        
        let topStone = SCNBox(width: 11, height: 1.75, length: 4.25, chamferRadius: 0.5)
        let topStoneNode = SCNNode(geometry: topStone)
        topStoneNode.position = SCNVector3(x: 0, y:12, z: 0)
        topStone.materials = [material]
        parentNode.addChildNode(topStoneNode)
        
        return parentNode
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}