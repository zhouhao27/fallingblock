//
//  GameScene.swift
//  FallingBlock
//
//  Created by Hao Zhou on 19/12/19.
//  Copyright © 2019 Hao Zhou. All rights reserved.
//

import SpriteKit
import GameplayKit

enum PianoKeyType {
  case black
  case white
}

struct Note: Equatable {
  var id: Int
  var type: PianoKeyType
  var length: Int
  var pitch: Int
  var time: TimeInterval
  var isLeft: Bool = true
  
  static func == (lhs: Note, rhs: Note) -> Bool {
    return lhs.id == rhs.id
  }
}

enum GameMode {
  case block
  case sheet
}

class GameScene: SKScene {
  
  private var rectNode : SKShapeNode?
  private var notes: [Note] = []
  private let margin: CGFloat = 20
  private let space: CGFloat = 20
  private let timeLineX: CGFloat = 160
  private let blockTravellingTime: TimeInterval = 2.0
  
  // the pointer index in notes array
  var currentNoteIndex = 0
  var playingNotes = [Note]()
  var currentStartTime: Date = Date()
  var isPlaying = false
  var mode: GameMode = .block
  
  override func didMove(to view: SKView) {
    loadNotes()
  }
  
  // Pitch is from 50 - 75
  private func loadNotes() {
    self.notes = [
      Note(id: 0, type: .white, length: 2, pitch: 60, time: 0),
      Note(id: 1, type: .white, length: 2, pitch: 62, time: 0),
      Note(id: 2, type: .black, length: 2, pitch: 64, time: 0),
      Note(id: 3, type: .white, length: 1, pitch: 60, time: 0.7, isLeft: false),
      Note(id: 4, type: .white, length: 1, pitch: 70, time: 1.0),
      Note(id: 5, type: .black, length: 0, pitch: 66, time: 1.6, isLeft: false),
      Note(id: 6, type: .white, length: 3, pitch: 58, time: 2.1),
      Note(id: 7, type: .white, length: 3, pitch: 54, time: 3.2),
      Note(id: 8, type: .white, length: 3, pitch: 56, time: 3.8, isLeft: false),
      Note(id: 9, type: .white, length: 3, pitch: 58, time: 3.8),
      Note(id: 10, type: .black, length: 2, pitch: 72, time: 4.4),
      Note(id: 11, type: .white, length: 0, pitch: 74, time: 5),
      Note(id: 12, type: .white, length: 1, pitch: 69, time: 5.8, isLeft: false),
      Note(id: 13, type: .white, length: 1, pitch: 63, time: 6.6),
      Note(id: 14, type: .black, length: 2, pitch: 65, time: 7.9),
      Note(id: 15, type: .white, length: 1, pitch: 61, time: 7.9),
      Note(id: 16, type: .white, length: 2, pitch: 67, time: 9.2),
      Note(id: 17, type: .black, length: 1, pitch: 67, time: 10.1, isLeft: false),
      Note(id: 18, type: .white, length: 3, pitch: 64, time: 12)
    ]
  }
  
  func playNote(_ note: Note) {
    print("playNote \(note.id)")
    if self.mode == .block {
      addBlock(note)
    } else if self.mode == .sheet {
      let line = note.pitch - 60
      var name = "note0"
      switch note.length {
        case 0:
          name = "note0"
        case 1:
          name = "note1"
        case 2:
          name = "note2"
        case 3:
          name = "note2"
        default:
        name = "note0"
      }
      // TODO: line should increase from bottom up
      addNote(line: line, name: name)
    }
  }
  
  private func addBlock(_ note: Note) {
    let color: UIColor = note.isLeft ? .orange : .cyan
    let w: CGFloat = note.type == .black ? 16 : 8
    var h: CGFloat = 8
    switch note.length {
      case 1:
        h = 16
      case 2:
        h = 32
      case 3:
        h = 48
      case 0:
        h = 8
      default:
        h = 8
    }
    // calculate x based on pitch (roughly)
    let x = CGFloat(note.pitch - 50) * 16
    
    let node = SKShapeNode(rectOf: CGSize(width: w, height: h),cornerRadius: w / 4.0)
    node.position = CGPoint(x: x, y: frame.size.height + h / 2)
    node.fillColor = color
    node.strokeColor = .clear
//    node.lineWidth = 3
//    node.strokeShader = createColorEmboss()
//    node.fillShader = createColorEmboss()
    
    self.addChild(node)
    
    let speed = Double(frame.size.height) / blockTravellingTime
    let t = (Double(frame.size.height) + Double(h)) / speed
    
    // TODO: delay
    let delayAction = SKAction.wait(forDuration: 0)
    let moveAction = SKAction.moveBy(x: 0, y: -(frame.height + CGFloat(h)), duration: t)
    
    let sequence = SKAction.sequence([
      delayAction,
      moveAction,
      SKAction.removeFromParent()
    ])
    node.run(sequence)
  }
  
  private func initSheet() {
    let firstLine: CGFloat = 160
    for i in 1...5 {
      let y = firstLine - CGFloat(i) * space
      drawLine(from: CGPoint(x: margin, y: y),
               to: CGPoint(x: frame.width - margin, y: y), color: .white)
    }
    
    // time line
    let x = timeLineX
    drawLine(from: CGPoint(x: x, y: 180),
             to: CGPoint(x: x, y: 180 - 5 * space - 60), color: .red)

    // clef
    let clef = SKSpriteNode(imageNamed: "clef")
    clef.color = .white
    clef.colorBlendFactor = 1
    clef.setScale(0.6)
    clef.position = CGPoint(x: margin + 30, y: 105)
    addChild(clef)
  }
  
  // line 0 - 9
  private func addNote(line: Int, name: String, delay: TimeInterval = 0) {
    
    let x1 = frame.width - margin
    let y = 140 - CGFloat(line) * space / 2
    
    let node = SKNode()
    node.position = CGPoint(x: x1, y: y)
    node.isHidden = true
    
    let spriteNode = SKSpriteNode(imageNamed: "\(name)")
    spriteNode.position = CGPoint(x: 0, y: 0)
    spriteNode.setScale(0.3)
    node.addChild(spriteNode)

    if line < 0 || line > 9 {
      // draw a line
      let w = spriteNode.size.width + 10
      let line = getLine(from: CGPoint(x:-w/2,y:0), to: CGPoint(x: w/2, y: 0), color: .white)
      node.addChild(line)
    }
    
    self.addChild(node)
    
    let travel_before_timeline = frame.width - margin - timeLineX
    let speed = travel_before_timeline / 5.0
    let total_travel_distance = travel_before_timeline + 60
    let t = TimeInterval(total_travel_distance / speed)
    
    let delayAction = SKAction.wait(forDuration: delay)
//    let moveAction = SKAction.moveBy(x: -total_travel_distance, y: 0, duration: t)
    let moveAction = SKAction.moveBy(x: -travel_before_timeline, y: 0, duration: 5)
    let moveAction2 = SKAction.moveBy(x: -60, y: 0, duration: t - 5)
    let alphaAction = SKAction.fadeAlpha(to: 0.2, duration: t - 5)
    
    let sequence = SKAction.sequence([
      delayAction,
      SKAction.unhide(),
      moveAction,
      SKAction.group([alphaAction,moveAction2]),
      SKAction.removeFromParent()
    ])
    node.run(sequence)
  }
    
  func drawLine(from: CGPoint, to: CGPoint, color: UIColor) {
    let line = getLine(from: from, to: to, color: color)
    addChild(line)
  }
  
  func getLine(from: CGPoint, to: CGPoint, color: UIColor) -> SKShapeNode {
    let line = SKShapeNode()
    let path = CGMutablePath()
    path.addLines(between: [from, to])
    line.path = path
    line.strokeColor = color
    line.lineWidth = 2
    return line
  }
  
  func start(_ mode: GameMode) {
    self.mode = mode
    
    self.removeAllActions()
    self.removeAllChildren()
    
    currentNoteIndex = 0
    playingNotes.removeAll()
    
    startTimer()
    
    isPlaying = true
    
    if mode == .sheet {
      initSheet()
    }
  }
  
  func createColorEmboss() -> SKShader {
    let source = "void main() {" +
        "vec4 current_color = SKDefaultShading();" +
        "if (current_color.a > 0.0) {" +
            "vec2 pixel_size = 1.0 / a_size;" +
            "vec4 new_color = current_color;" +
            "new_color += texture2D(u_texture, v_tex_coord + pixel_size) * u_strength;" +
            "new_color -= texture2D(u_texture, v_tex_coord - pixel_size) * u_strength;" +
            "gl_FragColor = vec4(new_color.rgb, 1) * current_color.a * v_color_mix.a;" +
        "} else {" +
            "gl_FragColor = current_color;" +
        "}" +
    "}"
    let shader = SKShader(source: source, uniforms: [SKUniform(name: "u_strength", float: 1)])
    shader.attributes = [SKAttribute(name: "a_size", type: .vectorFloat2)]
    return shader
  
//    let shader = SKShader(fileNamed: "emboss")
//    shader.attributes = [SKAttribute(name: "a_size", type: .vectorFloat2)]
//    shader.uniforms = [SKUniform(name: "u_strength", float: 1)]
//
//    return shader
  }

  private func startTimer() {
    currentStartTime = Date()
  }
  
  func touchDown(atPoint pos : CGPoint) {
  }
  
  func touchMoved(toPoint pos : CGPoint) {
  }
  
  func touchUp(atPoint pos : CGPoint) {
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchDown(atPoint: t.location(in: self)) }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    for t in touches { self.touchUp(atPoint: t.location(in: self)) }
  }
    
  override func update(_ currentTime: TimeInterval) {
    
    guard isPlaying else { return }

    if currentNoteIndex == notes.count - 1 && playingNotes.count == 0 {
      isPlaying = false
      return
    }
    
    let ts = Date().timeIntervalSince(currentStartTime)
    print("ts=\(ts)")
    
    let start = currentNoteIndex
    for i in start..<notes.count {
      let note = self.notes[i]
      if note.time < ts {
        print("note(\(note.id)) added with time = \(note.time)")
        playingNotes.append(note)
        currentNoteIndex = i + 1
      } else {
        break
      }
    }
    
    // create animation for playing notes
    for note in playingNotes {
      playingNotes.remove(object: note)
      playNote(note)
    }
  }
}
