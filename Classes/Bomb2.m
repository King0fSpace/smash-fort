//
//  Bomb.m
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/20/11.
//  Copyright 2011 Mobile Bros. All rights reserved.
//

#import "Bomb2.h"
#import "Game.h"


BOOL player2BombInPlay;
BOOL player1BombInPlay;
int randomColorBomb;


@implementation Bomb2

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
    
    shape->layers = 2;  shape->u = 10.0;  shape->e = 0.0;  shape->body->m = 30;
}

-(void) setPlayer2HasBlackBallToYes
{
    player2HasBlackBall = YES;
    player2HasGreenBall = NO;
    player2HasRedBall = NO;
    player2HasYellowBall = NO;
    player2HasBlueBall = NO;
}

-(void) setPlayer2HasGreenBallToYes
{
    player2HasBlackBall = NO;
    player2HasGreenBall = YES;
    player2HasRedBall = NO;
    player2HasYellowBall = NO;
    player2HasBlueBall = NO;
}

-(void) setPlayer2HasRedBallToYes
{
    player2HasBlackBall = NO;
    player2HasGreenBall = NO;
    player2HasRedBall = YES;
    player2HasYellowBall = NO;
    player2HasBlueBall = NO;
}

-(void) setPlayer2HasYellowBallToYes
{
    player2HasBlackBall = NO;
    player2HasGreenBall = NO;
    player2HasRedBall = NO;
    player2HasYellowBall = YES;
    player2HasBlueBall = NO;
}

-(void) setPlayer2HasBlueBallToYes
{
    player2HasBlackBall = NO;
    player2HasGreenBall = NO;
    player2HasRedBall = NO;
    player2HasYellowBall = NO;
    player2HasBlueBall = YES;
}

-(id) initWithGame:(Game*)game shape:(cpShape*)shape;
{
    if (!isPlayer1 || isSinglePlayer) {
                        
        if (doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 == NO) {
            
            //randomNumber1 = arc4random()%101;
                        
            //Green marble should have an 80% chance of being chosen of tesla1 is not glowing
            if (randomNumber1 >= 0 && randomNumber1 <= 79) {
                
                player2MarbleColor = 0;
            }
            
            else if (randomNumber1 >= 80 && randomNumber1 <= 100) {
            
                //randomNumber = arc4random()%4;
                
                if (randomNumber == 0) {
                    
                    //player1 will get blue marble
                    randomColorBomb = 80;
                }
                
                else if (randomNumber == 1) {
                    
                    //player2 will get red marble
                    player2MarbleColor = 85;
                }     
                
                else if (randomNumber == 2) {
                    
                    //player2 will get black marble
                    player2MarbleColor = 90;
                }   
                
                else if (randomNumber == 3) {
                    
                    //player2 will get yellow marble
                    player2MarbleColor = 95;
                } 
            }
        }
        
        if (doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 == YES) {
            
            //randomNumber1 = arc4random()%101;
                        
            //Green marble should have an 20% chance of being chosen of tesla1 is not glowing
            if (randomNumber1 >= 0 && randomNumber1 <= 19) {
                
                player2MarbleColor = 0;
            }
            
            else if (randomNumber1 >= 20 && randomNumber1 <= 100) {
                    
                //randomNumber = arc4random()%4;
                
                if (randomNumber == 0) {
                    
                    //player1 will get blue marble
                    player2MarbleColor = 20;
                }
                
                else if (randomNumber == 1) {
                    
                    //player2 will get red marble
                    player2MarbleColor = 40;
                }     
                
                else if (randomNumber == 2) {
                    
                    //player2 will get black marble
                    player2MarbleColor = 60;
                }   
                
                else if (randomNumber == 3) {
                    
                    //player2 will get yellow marble
                    player2MarbleColor = 80;
                } 
            }
        }
    }

    NSLog (@"doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = %i", doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2);
    
    if (firstPlayer2MarbleSetToGreen == NO) {
        /*
        //Debug: Choose blue marble all the time
        if (doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 == NO) {
            player2MarbleColor = 80;
        }
        
        else {
            
            player2MarbleColor = 20;
        }
         */
        
        player2MarbleColor = 0;
    }
    
    //change this back to YES after debugging marble colos
    firstPlayer2MarbleSetToGreen = YES;
    
    NSLog (@"Bomb File doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = %i", doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2);
    NSLog (@"Bomb File randomNumber1 = %i", randomNumber1);
    NSLog (@"Bomb File randomNumber = %i", randomNumber);
    NSLog (@"Bomb File player2MarbleColor = %i", player2MarbleColor);
    
    if (doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 == NO) {
        
        if (player2MarbleColor >= 90 && player2MarbleColor <= 94) {

            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"blackmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Black Marble glow.png"];
                self.color = ccc3(220, 220, 220);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer2HasBlackBallToYes)], nil]];
            
            if (isSinglePlayer == YES) {
                
                if (difficultyLevel == 2 || difficultyLevel == 3) {
                    
                    //If computer level is 2 or 3, 
                }
            }
        }
        
        if (player2MarbleColor >= 80 && player2MarbleColor <= 84) {
            
            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"bluemarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Blue Marble glow.png"];    
                self.color = ccc3(135, 206, 250);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer2HasBlueBallToYes)], nil]];
        }
        
        if (player2MarbleColor >= 0 && player2MarbleColor <= 79) {
            
            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"greenmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Green Marble glow.png"];
                self.color = ccc3(152, 251, 152);
            }
            
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer2HasGreenBallToYes)], nil]];
        }
        
        if (player2MarbleColor >= 85 && player2MarbleColor <= 89) {
            
            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"redmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Red Marble glow.png"];
                self.color = ccc3(255, 192, 203);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer2HasRedBallToYes)], nil]];
        }
        
        if (player2MarbleColor >= 95 && player2MarbleColor <= 99) {
            
            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"yellowmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Yellow Marble glow.png"];
                self.color = ccc3(255, 255, 240);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer2HasYellowBallToYes)], nil]];
        }
    }
    
    else if (doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 == YES) {
        
        if (player2MarbleColor >= 60 && player2MarbleColor <= 79) {
            
            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"blackmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Black Marble glow.png"];
                self.color = ccc3(220, 220, 220);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer2HasBlackBallToYes)], nil]];
        }
        
        if (player2MarbleColor >= 20 && player2MarbleColor <= 39) {
            
            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"bluemarble.png"];    
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Blue Marble glow.png"];    
                self.color = ccc3(135, 206, 250);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer2HasBlueBallToYes)], nil]];
        }
        
        if (player2MarbleColor >= 0 && player2MarbleColor <= 19) {
            
            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"greenmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Green Marble glow.png"];
                self.color = ccc3(152, 251, 152);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer2HasGreenBallToYes)], nil]];
        }
        
        if (player2MarbleColor >= 40 && player2MarbleColor <= 59) {
            
            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"redmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Red Marble glow.png"];
                self.color = ccc3(255, 192, 203);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer2HasRedBallToYes)], nil]];
        }
        
        if (player2MarbleColor >= 80 && player2MarbleColor <= 99) {
            
            if (stage == DAY_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"yellowmarble.png"];
            }
            
            else if (stage == NIGHT_TIME_SUBURB) {
                
                [super initWithShape:shape file:@"Yellow Marble glow.png"];
                self.color = ccc3(255, 255, 240);
            }
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(setPlayer2HasYellowBallToYes)], nil]];
        }
    }
    
    
    shape->layers = 2;  shape->u = 5.0;  shape->e = 0.4;
    
	_game = game;
	_countDown = NO;
    //player2BombZapped = NO;
	
	//Free the shape when we are released
	self.spaceManager = game.spaceManager;
	self.autoFreeShape = YES;
	
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

-(void) player2BombInPlayToNo
{
    player2BombInPlay = NO;
    player2BombIsAirborne = NO;
} 

-(void) explosionForBlackMarble
{
    player2HasBlackBall = NO;
    player2HasGreenBall = NO;
    player2HasRedBall = NO;
    player2HasYellowBall = NO;
    player2HasBlueBall = NO;
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
     explosion.position = self.positi22on;
     explosion.duration = .5;
     explosion.speed = 40;
     explosion.autoRemoveOnFinish = YES;
     explosion.blendAdditive = NO;
     [_game addChild:explosion];*/

    player2BombExists = NO;
    player2BombCreated = NO;
    readyToReceiveBlocksPositionsFromPlayer1 = YES;
   
    if (!player2HasBlackBall) {

        [(Game*)_game stopAllActionsInParallaxNodePlayer2];
        [self setPosition: ccp(-1500,50)];
        [_game removeChild:self cleanup:YES];
        //[(Game*)_game removePlayer2Bomb];
        [self player2BombInPlayToNo];
    }
    
    else if (player2HasBlackBall) {
        
        [(Game*)_game stopAllActionsInParallaxNodePlayer2];
        [self.spaceManager applyLinearExplosionAt:self.position radius: 500 maxForce:1500];
        [_game removeChild:self cleanup:YES];
        //[(Game*)_game removePlayer2Bomb];
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(moveBombOffScreen)], [CCCallFunc actionWithTarget:self selector:@selector(player2BombInPlayToNo)], nil]];
    }
    
    player2HasBlackBall = NO;
    player2HasGreenBall = NO;
    player2HasRedBall = NO;
    player2HasYellowBall = NO;
    player2HasBlueBall = NO;
        
    if (!isPlayer1) {
        
        [(Game*)_game setupBombsPlayer2];
        [(Game*)_game setupNextBombPlayer2];
    }
    
    if (isSinglePlayer == YES && player2BombCreated == NO) {
        
        [(Game*)_game setupBombsPlayer2];
        [(Game*)_game setupNextBombPlayer2];
    }
}

-(void) player2BombZapped
{ 
    player2BombCreated = NO;
    player2BombZapped = YES;
    
    marbleBlocksInARow = marbleBlocksInARow + 1;
    
    [(Game*)_game stopAllActionsInParallaxNodePlayer2];
    
    if (isPlayer1 == NO) {
        
        [(Game*) _game lightningStrikeFromSling1];
    }
    
    player2HasBlackBall = NO;
    player2HasGreenBall = NO;
    player2HasRedBall = NO;
    player2HasYellowBall = NO;
    player2HasBlueBall = NO;
    
    player2BombExists = NO;
    readyToReceiveBlocksPositionsFromPlayer1 = YES;
    
    CDXAudioNode *audioElectricuteProjectile = [[self children] objectAtIndex:0];
    [audioElectricuteProjectile play];
    
    //[(Game*)_game removePlayer2Bomb];
    //[self player2BombInPlayToNo];
    
    [self setPosition: ccp(-1500,50)];
    [self runAction: [CCSequence actions: [CCCallFuncND actionWithTarget:self selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], [CCCallFunc actionWithTarget:self selector:@selector(player2BombInPlayToNo)], nil]];
    
    if (isPlayer1 == NO && player2BombCreated == NO) {
        
        [(Game*)_game setupBombsPlayer2];
        [(Game*)_game setupNextBombPlayer2];
    }

    if (isSinglePlayer == YES && player2BombCreated == NO) {
        
        [(Game*)_game setupBombsPlayer2];
        [(Game*)_game setupNextBombPlayer2];
    }    
}

@end
