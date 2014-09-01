//
//  GameScene.swift
//  BottomDemo
//
//  Created by Lanston Peng on 8/26/14.
//  Copyright (c) 2014 Vtm. All rights reserved.
//

import SpriteKit

extension Float
{
    static func range(min:CGFloat , max:CGFloat) -> CGFloat
    {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
}
class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        let sprite: SKSpriteNode = SKSpriteNode(imageNamed: "bottle.png")
            // Position the sprite in the middle of the screen
            sprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            var offsetX: CGFloat = sprite.frame.size.width * sprite.anchorPoint.x
            var offsetY: CGFloat = sprite.frame.size.height * sprite.anchorPoint.y
                
                
            //CGMutablePathRef path = CGPathCreateMutable();
                
            let path: CGMutablePathRef = CGPathCreateMutable()
                
            // Change all NULL values to nil
          MoveToPoint(path,    x: 29, y: 139, node: sprite)
    AddLineToPoint(path, x: 19, y: 139, node: sprite)
    AddLineToPoint(path, x: 19, y: 130, node: sprite)
    AddLineToPoint(path, x: 9,  y: 130, node: sprite)
    AddLineToPoint(path, x: 9,  y: 120, node: sprite)
    AddLineToPoint(path, x: 19, y: 120, node: sprite)
    AddLineToPoint(path, x: 19, y: 109, node: sprite)
    AddLineToPoint(path, x: 0,  y: 90,  node: sprite)
    AddLineToPoint(path, x: 0,  y: 20,  node: sprite)
    AddLineToPoint(path, x: 19, y: 0,   node: sprite)
    AddLineToPoint(path, x: 79, y: 0,   node: sprite)
    AddLineToPoint(path, x: 99, y: 20,  node: sprite)
    AddLineToPoint(path, x: 99, y: 90,  node: sprite)
    AddLineToPoint(path, x: 79, y: 110, node: sprite)
    AddLineToPoint(path, x: 80, y: 120, node: sprite)
    AddLineToPoint(path, x: 89, y: 120, node: sprite)
    AddLineToPoint(path, x: 89, y: 130, node: sprite)
    AddLineToPoint(path, x: 79, y: 131, node: sprite)
    AddLineToPoint(path, x: 79, y: 139, node: sprite)
    AddLineToPoint(path, x: 69, y: 139, node: sprite)
    AddLineToPoint(path, x: 69, y: 100, node: sprite)
    AddLineToPoint(path, x: 89, y: 79,  node: sprite)
    AddLineToPoint(path, x: 89, y: 30,  node: sprite)
    AddLineToPoint(path, x: 69, y: 10,  node: sprite)
    AddLineToPoint(path, x: 30, y: 10,  node: sprite)
    AddLineToPoint(path, x: 9,  y: 31,  node: sprite)
    AddLineToPoint(path, x: 9,  y: 76,  node: sprite)
    AddLineToPoint(path, x: 29, y: 100, node: sprite)
                
            CGPathCloseSubpath(path)
                
            //sprite.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
            sprite.physicsBody = SKPhysicsBody(polygonFromPath: path)
            // Set Dynamic to false
            sprite.physicsBody.dynamic = false
            // Add the sprite to the scene
            self.addChild(sprite)


self.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(0.05), SKAction.runBlock(self.generateFluid)])))
sprite.runAction(SKAction.repeatActionForever(SKAction.sequence([SKAction.waitForDuration(3), SKAction.rotateByAngle(6.28318531, duration: 5.0)])))
    }
    
    func generateFluid()
{
let sprite:SKSpriteNode = SKSpriteNode(imageNamed: "ball.png")
 sprite.position = CGPointMake(Float.range(CGRectGetMidX(self.frame) - 40, max: CGRectGetMidX(self.frame) + 40), CGRectGetMidY(self.frame) + 350)
    sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width/2)
    self.addChild(sprite)
sprite.runAction(SKAction.sequence([SKAction.waitForDuration(20), SKAction.removeFromParent()]))
}
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    

    func offset(node: SKSpriteNode, isX: Bool)->CGFloat {
        return isX ? node.frame.size.width * node.anchorPoint.x : node.frame.size.height * node.anchorPoint.y
    }
    
func AddLineToPoint(path: CGMutablePath!, x: CGFloat, y: CGFloat, node: SKSpriteNode) {
    CGPathAddLineToPoint(path, nil, (x * 2) - offset(node, isX: true), (y * 2) - offset(node, isX: false))
}
    
func MoveToPoint(path: CGMutablePath!, x: CGFloat, y: CGFloat, node: SKSpriteNode) {
    CGPathMoveToPoint(path, nil, (x * 2) - offset(node, isX: true), (y * 2) - offset(node, isX: false))
}
}
