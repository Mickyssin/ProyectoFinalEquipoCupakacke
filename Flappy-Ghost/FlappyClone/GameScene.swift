//
//  GameScene.swift
//  FlappyClone
//
//  Created by LEONARDO on 10/3/17.
//  Copyright (c) 2017 LEONARDO. All rights reserved.
//

import SpriteKit

// SpriteKit es una infraestructura que permite la renderización y animación de gráficos, puede servir para imágenes o formalmente conocidas como sprites

struct PhysicsCatagory {
    static let Ghost : UInt32 = 0x1 << 1
    static let Ground : UInt32 = 0x1 << 2
    static let Wall : UInt32 = 0x1 << 3
    static let Score : UInt32 = 0x1 << 4
}

// La función PhysicsCatagory, como su nombre lo indica se establecen las variables estáticas (let se utiliza para asignar un valor que no cambiará a las variables y así optimizar el uso de memoria en el juego).

class GameScene: SKScene, SKPhysicsContactDelegate {


    var Ground = SKSpriteNode()
    var Ghost = SKSpriteNode()

    var wallPair = SKNode()

    var moveAndRemove = SKAction()

    var gameStarted = Bool()

//La clase GameScene será la configuración base del juego, en ella se inicializan las variables y funciones que serán necesarias para el correcto funcionamiento del mismo.
//
// SKScene: Forma parte de SpriteKit, sirve para generar nodos que se al árbol de SpriteKit, estos proveen contenido que la escena renderiza y anima para que se vean en la aplicación.
//
// SKAction: Es una acción que es ejecutada por un nodo de la escena, frecuentemente se utilizan para cambiar la estructura y contenido de los nodos conectados.
//
// Bool: Representa un tipo de dato booleano.
//
// Las variables Ground, Ghost y wallPair se declaran como nodos de la escena la diferencia entre las primeras dos y wallPair es que este último nodo simple, mientras que los primeros son específicamente nodos Sprite.


    var score = Int()
    let scoreLbl = SKLabelNode()

    var died = Bool()
    var restartBTN = SKSpriteNode()

// scoreLbl es un nodo de la escena de tipo Label, esta mostrará en la pantalla el puntaje que el jugador lleva acumulador.
//
// Died es una variable booleana que indica si el fantasma o personaje ha “muerto”
//
// restartBTN es un nodo de tipo sprite, en él se mostrará un botón que permitirá el reinicio del juego.


    func restartScene(){

        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()

    }

    // La función restartScene remueve todos los nodos hijos que se crearon en el juego y todas las acciones, pone en falso las variables died y gameStarted, reinicia el contador y vuelve a crear la escena como si fuera la primera vez que se juega.

    func createScene(){

        self.physicsWorld.contactDelegate = self

        for i in 0..<2 {
            let background = SKSpriteNode(imageNamed: "Background")
            background.anchorPoint = CGPointZero
            background.position = CGPointMake(CGFloat(i) * self.frame.width, 0)
            background.name = "background"
            background.size = (self.view?.bounds.size)!
            self.addChild(background)

        }

        // El ciclo for repite el sprite del fondo para que cuando el juego comience, se obtenga un efecto similar a que el fantasma está avanzando.

        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.5)
        scoreLbl.text = "\(score)"
        scoreLbl.fontName = "04b_19"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 60
        self.addChild(scoreLbl)

        // Se establece la altura en la pantalla que tendrá el scoreLbl centrada horizontalmente y verticalmente un poco elevada del centro.
        //
        // Se le asigna el valor de la variable score, tipo de letra, posición en el eje z, este punto es muy importante ya que asi no colisionará o se sobrepondrá con las demás texturas, tamaño de letra y por último se agrega el nodo.


        Ground = SKSpriteNode(imageNamed: "Ground")
        Ground.setScale(0.5)
        Ground.position = CGPoint(x: self.frame.width / 2, y: 0 + Ground.frame.height / 2)

        Ground.physicsBody = SKPhysicsBody(rectangleOfSize: Ground.size)
        Ground.physicsBody?.categoryBitMask = PhysicsCatagory.Ground
        Ground.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        Ground.physicsBody?.contactTestBitMask  = PhysicsCatagory.Ghost
        Ground.physicsBody?.affectedByGravity = false
        Ground.physicsBody?.dynamic = false

        Ground.zPosition = 3

        self.addChild(Ground)

        // Se agregan las configuraciones del suelo, posiciones, con que objetos puede colisionar, en este caso solo puede con el fantasma

        Ghost = SKSpriteNode(imageNamed: "Ghost")
        Ghost.size = CGSize(width: 60, height: 70)
        Ghost.position = CGPoint(x: self.frame.width / 2 - Ghost.frame.width, y: self.frame.height / 2)

        Ghost.physicsBody = SKPhysicsBody(circleOfRadius: Ghost.frame.height / 2)
        Ghost.physicsBody?.categoryBitMask = PhysicsCatagory.Ghost
        Ghost.physicsBody?.collisionBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall
        Ghost.physicsBody?.contactTestBitMask = PhysicsCatagory.Ground | PhysicsCatagory.Wall | PhysicsCatagory.Score
        Ghost.physicsBody?.affectedByGravity = false
        Ghost.physicsBody?.dynamic = true

        Ghost.zPosition = 2


        self.addChild(Ghost)

        // Por ultimo en esta función, se agregan las configuraciones el fantasma, lo que se agrega son las propiedades physicsBosy, las cuales son para que agregarle físicas, como forma del cuerpo, con que elementos de juego colisionará (suelo y paredes) y con cuales podrá tener contacto (suelo, paredes y monedas).




    }

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        createScene()

    }

    func createBTN(){

        restartBTN = SKSpriteNode(imageNamed: "RestartBtn")
        restartBTN.size = CGSizeMake(200, 100)
        restartBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBTN.zPosition = 6
        restartBTN.setScale(0)
        self.addChild(restartBTN)
        restartBTN.runAction(SKAction.scaleTo(1.0, duration: 0.3))

    }

    // Después está la función createBTN esta crea el botón que aparecerá cuando el juego termine, se asigna al asset correspondiente, tamaño, posición en la pantalla, posición en z, se agrega al nodo, y su acción.

    func didBeginContact(contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB

        // De inicio se crean dos variables que serán igual a dos objetos del atributo contact, ya que en el juego el fantasma solo podrá tener contacto uno a uno con el resto de los objetos

        if firstBody.categoryBitMask == PhysicsCatagory.Score && secondBody.categoryBitMask == PhysicsCatagory.Ghost{

            score += 1
            scoreLbl.text = "\(score)"
            firstBody.node?.removeFromParent()

        }
        // Se hace una condicional, si el contacto de hace del fantasma a una moneda, simplemente se incrementará el puntaje, se actualizará el label correspondiente, y remueve el nodo de su padre, para que se pueda reutilizar para cualquier otro caso de contacto
        else if firstBody.categoryBitMask == PhysicsCatagory.Ghost && secondBody.categoryBitMask == PhysicsCatagory.Score {

            score += 1
            scoreLbl.text = "\(score)"
            secondBody.node?.removeFromParent()

        }

        else if firstBody.categoryBitMask == PhysicsCatagory.Ghost && secondBody.categoryBitMask == PhysicsCatagory.Wall || firstBody.categoryBitMask == PhysicsCatagory.Wall && secondBody.categoryBitMask == PhysicsCatagory.Ghost{

            enumerateChildNodesWithName("wallPair", usingBlock: ({
                (node, error) in

                node.speed = 0
                self.removeAllActions()

            }))
            if died == false{
                died = true
                createBTN()
            }
        }
        else if firstBody.categoryBitMask == PhysicsCatagory.Ghost && secondBody.categoryBitMask == PhysicsCatagory.Ground || firstBody.categoryBitMask == PhysicsCatagory.Ground && secondBody.categoryBitMask == PhysicsCatagory.Ghost{

            enumerateChildNodesWithName("wallPair", usingBlock: ({
                (node, error) in

                node.speed = 0
                self.removeAllActions()

            }))
            if died == false{
                died = true
                createBTN()
            }
        }

        // Estas funciones manejan la colisión entre el fantasma y cualquiera de las paredes, se marca como error, por lo tanto, se detiene el juego, se remueven acciones para que ya el fantasma no se mueva, se cambia la variable died a true y se muestra el botón de reinicio



    }


    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if gameStarted == false{

            gameStarted =  true

            Ghost.physicsBody?.affectedByGravity = true

            let spawn = SKAction.runBlock({
                () in

                self.createWalls()

            })

            // Al principio de inicia la condición si el juego no ha iniciado, entonces la variable cambia a true, de agrega la gravedad en el fantasma, y se empieza a generar el efecto de que el juego avanza además de llamar a la función para crear las paredes.
            let delay = SKAction.waitForDuration(1.5)
            let SpawnDelay = SKAction.sequence([spawn, delay])
            let spawnDelayForever = SKAction.repeatActionForever(SpawnDelay)
            self.runAction(spawnDelayForever)


            let distance = CGFloat(self.frame.width + wallPair.frame.width)
            let movePipes = SKAction.moveByX(-distance - 50, y: 0, duration: NSTimeInterval(0.008 * distance))
            let removePipes = SKAction.removeFromParent()
            moveAndRemove = SKAction.sequence([movePipes, removePipes])

            Ghost.physicsBody?.velocity = CGVectorMake(0, 0)
            Ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
        }
        else{

            if died == true{


            }
            else{
                Ghost.physicsBody?.velocity = CGVectorMake(0, 0)
                Ghost.physicsBody?.applyImpulse(CGVectorMake(0, 90))
            }

        }

//         Se crean todos los efectos de duración de las acciones, se generar un pequeño retardo para que haga un efecto más visual y cómodo para el usuario, que las acciones siempre se repitan de forma indefinida.
//
// Se crean la variable distance para que las paredes mantengan un espacio entre ellas con el fin de que el fantasma pueda pasar.
//
// La variable movepipes permite que las paredes se vayan moviendo de un extremo de la pantalla al otro en sentido contrario al fantasma, después removepipes simplemente la elimina cuando esta termina de pasar, moveAndRemove llama a estas dos últimas para que se genere de forma indefinida



        for touch in touches{
            let location = touch.locationInNode(self)

            if died == true{
                if restartBTN.containsPoint(location){
                    restartScene()

                }


            }

        }


// El ciclo touch guarda la posición en la que se genera el ultimo toque de la pantalla, para que cuando pierda el jugador, solo se pueda dar clic en el botón y el resto de la pantalla ya no generará alguna acción.



    }

    func createWalls(){

        let scoreNode = SKSpriteNode(imageNamed: "Coin")

        scoreNode.size = CGSize(width: 50, height: 50)
        scoreNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        scoreNode.physicsBody = SKPhysicsBody(rectangleOfSize: scoreNode.size)
        scoreNode.physicsBody?.affectedByGravity = false
        scoreNode.physicsBody?.dynamic = false
        scoreNode.physicsBody?.categoryBitMask = PhysicsCatagory.Score
        scoreNode.physicsBody?.collisionBitMask = 0
        scoreNode.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        scoreNode.color = SKColor.blueColor()

        // Al igual que con el fantasma se agregan características como altura y ancho, posición la cual será a la mitad de las dos paredes, tipo de física, no es afectada por la gravedad ni tampoco es dinámica, estará asignada a la física Score, solo podrá colisionar con el fantasma.

        wallPair = SKNode()
        wallPair.name = "wallPair"

        let topWall = SKSpriteNode(imageNamed: "Wall")
        let btmWall = SKSpriteNode(imageNamed: "Wall")


        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 370)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 370)

        topWall.setScale(0.5)
        btmWall.setScale(0.5)


        topWall.physicsBody = SKPhysicsBody(rectangleOfSize: topWall.size)
        topWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        topWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        topWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        topWall.physicsBody?.dynamic = false
        topWall.physicsBody?.affectedByGravity = false

        btmWall.physicsBody = SKPhysicsBody(rectangleOfSize: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = PhysicsCatagory.Wall
        btmWall.physicsBody?.collisionBitMask = PhysicsCatagory.Ghost
        btmWall.physicsBody?.contactTestBitMask = PhysicsCatagory.Ghost
        btmWall.physicsBody?.dynamic = false
        btmWall.physicsBody?.affectedByGravity = false

        topWall.zRotation = CGFloat(M_PI)

        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)

        wallPair.zPosition = 1

        let randomPosition = CGFloat.random(min: -200, max: 200)
         wallPair.position.y = wallPair.position.y +  randomPosition
        wallPair.addChild(scoreNode)

        wallPair.runAction(moveAndRemove)

        self.addChild(wallPair)

    }

    // Se crea el objeto wallPair que es un nodo, en este caso no se utiliza un nodo como el fantasma ya que este contendrá ambas paredes, por lo que su estructura es más compleja.
    //
    // Dentro de este nodo estarán SKSpriteNode para la pared superior como al inferior, a cada una se le asigna sus posiciones, dejando un espacio entre ellas.
    //
    // Se agregan todas las físicas propias de cada una de las paredes y ambos nodos se agregan a la escena.
    //
    // Ahora para asignar la posición en z de utiliza el nodo wallpair para que afecte a ambas paredes, por último, se usa una variable RandomPosition que irá entre -200 y 200, para que las paredes tengan ese margen y no “desaparezcan” de la pantalla, se les asigna esa posición a ambas paredes.


    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

        if gameStarted == true{
            if died == false{
                enumerateChildNodesWithName("background", usingBlock: ({
                    (node, error) in

                    let bg = node as! SKSpriteNode

                    bg.position = CGPoint(x: bg.position.x - 2, y: bg.position.y)

                    if bg.position.x <= -bg.size.width {
                        bg.position = CGPointMake(bg.position.x + bg.size.width * 2, bg.position.y)

                    }

                }))

            }


        }

        // Por último, la función de update que permitirá que el fondo de esté actualizando constantemente generando la impresión de que el fantasma está avanzando.



    }
}
