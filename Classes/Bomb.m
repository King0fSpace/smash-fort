//
//  Bomb.m
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/20/11.
//  Copyright 2011 Mobile Bros. All rights reserved.
//

#import "Bomb.h"
#import "Game.h"


BOOL player2BombInPlay;
BOOL player1BombInPlay;
int randomColorBomb;


@implementation Bomb

+(id) bombWithGame:(Game*)game
{
	return [[[self alloc] initWithGame:game] autorelease];
}

+(id) bombWithGame:(Game*)game shape:(cpShape*)shape
{
	return [[[self alloc] initWithGame:game shape:shape] autorelease];	
}

-(id) initWithGame:(Game*)game
{
	cpShape *shape = [game.spaceManager addCircleAt:cpvzero mass:STATIC_MASS radius:10];
    
/*    cpShape *shape = [game.spaceManager addPolyAt:cpvzero mass:STATIC_MASS rotation:4 numPoints:20 points:cpv(8,0), cpv(7.608452,-2.472136), cpv(6.472136,-4.702282), cpv(4.702282,-6.472136), cpv(2.472136,-7.608452), cpv(0,-8), cpv(-2.472136,-7.608452), cpv(-4.702282,-6.472136), cpv(-6.472136,-4.702282), cpv(-7.608452,-2.472136), cpv(-8,0), cpv(-7.608452,2.472136), cpv(-6.472136,4.702282), cpv(-4.702282,6.472136), cpv(-2.472136,7.608452), cpv(0,8), cpv(2.472136,7.608452), cpv(4.702282,6.472136), cpv(6.472136,4.702282), cpv(7.608452,2.472136)];*/
    
	return [self initWithGame:game shape:shape];   
        
    shape->layers = 1;  shape->u = 10.0;  shape->e = 0.4;  shape->body->m = 30;
}

-(void) setPlayer1HasBlackBallToYes
{
    player1HasBlackBall = YES;
    player1HasGreenBall = NO;
    player1HasRedBall = NO;
    player1HasYellowBall = NO;
    player1HasBlueBall = NO;
}

-(void) setPlayer1HasGreenBallToYes
{
    player1HasBlackBall = NO;
    player1HasGreenBall = YES;
    player1HasRedBall = NO;
    player1HasYellowBall = NO;
    player1HasBlueBall = NO;
}

-(void) setPlayer1HasRedBallToYes
{
    player1HasBlackBall = NO;
    player1HasGreenBall = NO;
    player1HasRedBall = YES;
    player1HasYellowBall = NO;
    player1HasBlueBall = NO;
}

-(void) setPlayer1HasYellowBallToYes
{
    player1HasBlackBall = NO;
    player1HasGreenBall = NO;
    player1HasRedBall = NO;
    player1HasYellowBall = YES;
    player1HasBlueBall = NO;
}

-(void) setPlayer1HasBlueBallToYes
{
    player1HasBlackBall = NO;
    player1HasGreenBall = NO;
    player1HasRedBall = NO;
    player1HasYellowBall = NO;
    player1HasBlueBall = YES;
}


-(id) initWithGame:(Game*)game shape:(cpShape*)shape;
{            
    if (isPlayer1) {
    
        if (doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 == NO) {
                       
            //randomNumber1 = arc4random()%101;
            
            //Green marble should have an 80% chance of being chosen of tesla1 is not glowing
            if (randomNumber1 >= 0 && randomNumber1 <= 79) {
                
                player1MarbleColor = 0;
            }
            
            else if (randomNumber1 >= 80 && randomNumber1 <= 100) {
                
                if (player1MarblesUnlocked == 1) {
                    
                    //player1 will get blue marble
                    player1MarbleColor = 80;
                }
                
                else if (player1MarblesUnlocked == 2) {
                    
                    //BOOL randomNumber = arc4random()%2;
                    
                    if (randomNumber == 0) {
                    
                        //player1 will get blue marble
                        player1MarbleColor = 80;
                    }
                    
                    else if (randomNumber == 1) {
                    
                        //player2 will get red marble
                        player1MarbleColor = 85;
                    }
                }
                
                else if (player1MarblesUnlocked == 3) {
                    
                    //int randomNumber = arc4random()%3;
                    
                    if (randomNumber == 0) {
                        
                        //player1 will get blue marble
                        player1MarbleColor = 80;
                    }
                    
                    else if (randomNumber == 1) {
                        
                        //player2 will get red marble
                        player1MarbleColor = 85;
                    }     
                    
                    else if (randomNumber == 2) {
                        
                        //player2 will get black marble
                        player1MarbleColor = 90;
                    }   
                }
                
                else if (player1MarblesUnlocked >= 4) {
                    
                    //int randomNumber = arc4random()%4;
                    
                    if (randomNumber == 0) {
                        
                        //player1 will get blue marble
                        randomColorBomb = 80;
                    }
                    
                    else if (randomNumber == 1) {
                        
                        //player2 will get red marble
                        player1MarbleColor = 85;
                    }     
                    
                    else if (randomNumber == 2) {
                        
                        //player2 will get black marble
                        player1MarbleColor = 90;
                    }   
                    
                    else if (randomNumber == 3) {
                        
                        //player2 will get yellow marble
                        player1MarbleColor = 95;
                    } 
                }
            }
        }
        
        if (doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 == YES) {
            
            //randomNumber1 = arc4random()%101;
            
            //Green marble should have an 20% chance of being chosen of tesla1 is not glowing
            if (randomNumber1 >= 0 && randomNumber1 <= 19) {
                
                player1MarbleColor = 0;
            }
            
            else if (randomNumber1 >= 20 && randomNumber1 <= 100) {
                
                if (player1MarblesUnlocked == 1) {
                    
                    //player1 will get blue marble
                    player1MarbleColor = 20;
                }
                
                else if (player1MarblesUnlocked == 2) {
                    
                    //BOOL randomNumber = arc4random()%2;
                    
                    if (randomNumber == 0) {
                        
                        //player1 will get blue marble
                        player1MarbleColor = 20;
                    }
                    
                    else if (randomNumber == 1) {
                        
                        //player2 will get red marble
                        player1MarbleColor = 40;
                    }
                }
                
                else if (player1MarblesUnlocked == 3) {
                    
                    //int randomNumber = arc4random()%3;
                    
                    if (randomNumber == 0) {
                        
                        //player1 will get blue marble
                        player1MarbleColor = 20;
                    }
                    
                    else if (randomNumber == 1) {
                        
                        //player2 will get red marble
                        player1MarbleColor = 40;
                    }     
                    
                    else if (randomNumber == 2) {
                        
                        //player2 will get black marble
                        player1MarbleColor = 60;
                    }   
                }
                
                else if (player1MarblesUnlocked >= 4) {
                    
                    //int randomNumber = arc4random()%4;
                    
                    if (randomNumber == 0) {
                        
                        //player1 will get blue marble
                        player1MarbleColor = 20;
                    }
                    
                    else if (randomNumber == 1) {
                        
                        //player2 will get red marble
                        player1MarbleColor = 40;
                    }     
                    
                    else if (randomNumber == 2) {
                        
                        //player2 will get black marble
                        player1MarbleColor = 60;
                    }   
                    
                    else if (randomNumber == 3) {
                        
                        //player2 will get yellow marble
                        player1MarbleColor = 80;
                    } 
                }
            }
        }
        
       // player1MarbleColor = randomColorBomb;
       // NSLog (@"player1 player1MarbleColor = %i", player1MarbleColor);
    }
    
    if (firstPlayer1MarbleSetToGreen == NO) {
        
        player1MarbleColor = 1;
    }
    
    firstPlayer1MarbleSetToGreen = YES;
    
    NSLog (@"Bomb File doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = %i", doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1);
    NSLog (@"Bomb File randomNumber1 = %i", randomNumber1);
    NSLog (@"Bomb File randomNumber = %i", randomNumber);
    NSLog (@"Bomb File player1MarbleColor = %i", player1MarbleColor);
    
    if (doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 == NO) {
    
        if (player1MarbleColor >= 90 && player1MarbleColor <= 94) {
            
            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"blackmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Black Marble glow.png"];
                self.color = ccc3(220, 220, 220);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer1HasBlackBallToYes)], nil]];
            
            if (isSinglePlayer == YES) {
                
                if (difficultyLevel == 2 || difficultyLevel == 3) {
                    
                    //If computer level is 2 or 3, 
                }
            }
        }
                
        if (player1MarbleColor >= 80 && player1MarbleColor <= 84) {
                        
            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"bluemarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Blue Marble glow.png"];    
                self.color = ccc3(135, 206, 250);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer1HasBlueBallToYes)], nil]];
        }
            
        if (player1MarbleColor >= 0 && player1MarbleColor <= 79) {

            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"greenmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Green Marble glow.png"];
                self.color = ccc3(152, 251, 152);
            }
            
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer1HasGreenBallToYes)], nil]];
        }
            
        if (player1MarbleColor >= 85 && player1MarbleColor <= 89) {
            
            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"redmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Red Marble glow.png"];
                self.color = ccc3(255, 192, 203);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer1HasRedBallToYes)], nil]];
        }
            
        if (player1MarbleColor >= 95 && player1MarbleColor <= 99) {

            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"yellowmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Yellow Marble glow.png"];
                self.color = ccc3(255, 255, 240);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer1HasYellowBallToYes)], nil]];
        }
    }
    
    else if (doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 == YES) {
        
        if (player1MarbleColor >= 60 && player1MarbleColor <= 79) {

            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"blackmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Black Marble glow.png"];
                self.color = ccc3(220, 220, 220);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer1HasBlackBallToYes)], nil]];
        }
        
        if (player1MarbleColor >= 20 && player1MarbleColor <= 39) {

            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"bluemarble.png"];    
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Blue Marble glow.png"];    
                self.color = ccc3(135, 206, 250);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer1HasBlueBallToYes)], nil]];
        }
        
        if (player1MarbleColor >= 0 && player1MarbleColor <= 19) {
    
            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"greenmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Green Marble glow.png"];
                self.color = ccc3(152, 251, 152);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer1HasGreenBallToYes)], nil]];
        }
        
        if (player1MarbleColor >= 40 && player1MarbleColor <= 59) {

            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"redmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Red Marble glow.png"];
                self.color = ccc3(255, 192, 203);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer1HasRedBallToYes)], nil]];
        }
        
        if (player1MarbleColor >= 80 && player1MarbleColor <= 99) {

            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"yellowmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Yellow Marble glow.png"];
                self.color = ccc3(255, 255, 240);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer1HasYellowBallToYes)], nil]];
        }
    }
    

    
            
    shape->layers = 1;  shape->u = 5.0;  shape->e = 0.0;
            	
	_game = game;
	_countDown = NO;
	
	//Free the shape when we are released
	self.spaceManager = game.spaceManager;
	self.autoFreeShape = YES;
    //player2BombZapped = NO;
	
	//Handle collisions
	shape->collision_type = kBombCollisionType;
	
	return self;
}

-(void) startCountDown
{              
    //Only start it if we haven't yet
	if (!_countDown)
	{
		_countDown = YES;
		
		id f1 = [CCFadeTo actionWithDuration:.25 opacity:150];
		id f2 = [CCFadeTo actionWithDuration:.25 opacity:50];
		
		id d = [CCDelayTime actionWithDuration:1.5];
		id c = [CCCallFunc actionWithTarget:self selector:@selector(blowup)];
		
		[self runAction:[CCRepeatForever actionWithAction:[CCSequence actions:f1,f2,nil]]];
		[self runAction:[CCSequence actions:d,c,nil]];
	}
}

-(void) player1BombInPlayToNo
{
    player1BombInPlay = NO;  
    player1BombIsAirborne = NO;
} 

-(void) explosionForBlackMarble
{
    player1HasBlackBall = NO;
    player1HasGreenBall = NO;
    player1HasRedBall = NO;
    player1HasYellowBall = NO;
    player1HasBlueBall = NO;
}

-(void) moveBombOffScreen
{
    [self setPosition: ccp(-1500,50)];
}

-(void) blowup
{
	/*[self.spaceManager applyLinearExplosionAt:self.position radius:0 maxForce:0];
     
     CCParticleSun *explosion = [[[CCParticleSun alloc] initWithTotalParticles:10] autorelease];
     self.position = [self convertToWorldSpace: _game.position];
     explosion.position = self.position;
     explosion.duration = .5;
     explosion.speed = 40;
     explosion.autoRemoveOnFinish = YES;
     explosion.blendAdditive = NO;
     [_game addChild:explosion];*/
        
    player1BombExists = NO;
    player1BombCreated = NO;
    readyToReceiveBlocksPositionsFromPlayer1 = YES;
    
    if (!player1HasBlackBall) {
        
        [(Game*)_game stopAllActionsInParallaxNodePlayer1];
        [self setPosition: ccp(1500,50)];
        [_game removeChild:self cleanup:YES];
        //[(Game*)_game removePlayer1Bomb];
        [self player1BombInPlayToNo];
    }
    
    else if (player1HasBlackBall) {
        
        [(Game*)_game stopAllActionsInParallaxNodePlayer1];
        [self.spaceManager applyLinearExplosionAt:self.position radius: 500 maxForce:1500];
        [_game removeChild:self cleanup:YES];
        //[(Game*)_game removePlayer1Bomb];
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(moveBombOffScreen)], [CCCallFunc actionWithTarget:self selector:@selector(player1BombInPlayToNo)], nil]];
    }
    
    player1HasBlackBall = NO;
    player1HasGreenBall = NO;
    player1HasRedBall = NO;
    player1HasYellowBall = NO;
    player1HasBlueBall = NO;
        
    if (isPlayer1 == YES && player1BombCreated == NO) {
        
        [(Game*)_game setupBombsPlayer1];
        [(Game*)_game setupNextBombPlayer1];
    }
   
}

-(void) player1BombZapped 
{    
    player1BombCreated = NO;
    player1BombZapped = YES;
    
    marbleBlocksInARow = marbleBlocksInARow + 1;
    
    [(Game*)_game stopAllActionsInParallaxNodePlayer1];
    
    if (isPlayer1 == YES) {
        
        [(Game*) _game lightningStrikeFromSling2];
    }
    
    player1HasBlackBall = NO;
    player1HasGreenBall = NO;
    player1HasRedBall = NO;
    player1HasYellowBall = NO;
    player1HasBlueBall = NO;
    
    player1BombExists = NO;
    readyToReceiveBlockNumbersFromPlayer2 = NO;
    
    CDXAudioNode *audioElectricuteProjectile = [[self children] objectAtIndex:0];
    [audioElectricuteProjectile play];
    
 //   [(Game*)_game removePlayer1Bomb];
 //   [self player1BombInPlayToNo];
    
    [self setPosition: ccp(1500,50)];
    [self runAction: [CCSequence actions: [CCCallFuncND actionWithTarget:self selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], [CCCallFunc actionWithTarget:self selector:@selector(player1BombInPlayToNo)], nil]];
    
    
    if (isPlayer1 == YES && player1BombCreated == NO) {
        
        [(Game*)_game setupBombsPlayer1];
        [(Game*)_game setupNextBombPlayer1];
    }
     
}

@end
