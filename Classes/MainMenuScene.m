//
//  MainMenuScene.m
//  GrenadeGame
//
//  Created by Long Le on 12/29/11.
//  Copyright (c) 2011 Laguna Beach Unified School District. All rights reserved.
//

#import "MainMenuScene.h"

CCSprite *woodblock;
CCSprite *woodblock2;
CCSprite *happyGerty;
CCSprite *sadGerty;
CCSprite *uncertainGerty;
CCSprite *cryingGerty;
CCSprite *bigSmileGerty;
CCSprite *pensiveGerty;
CCLabelTTF *label;
CCSprite *stickFigureBoy;
CCSprite *stickFigureGirl;
CCSprite *stickGlobeWithArrows;
SimpleAudioEngine *mainMenuMusic;
CCSprite *batteryIndicator;


@implementation MainMenuScene


+(id) scene
{
	//Create MainMenuScene, then add layer to it
	CCScene *scene = [CCScene node];
	
	MainMenuScene *layer = [MainMenuScene node];
	
	[scene addChild: layer];

    return scene;
}

-(void) playThemeMusic
{
    if (musicIsPlaying == NO) {
        
        mainMenuMusic = [SimpleAudioEngine sharedEngine];//play background music
        
        if (mainMenuMusic != nil) {
            [mainMenuMusic preloadBackgroundMusic:@"YoungAtHeartMusic.mp3"];
            
            if (mainMenuMusic.willPlayBackgroundMusic) {
                mainMenuMusic.backgroundMusicVolume = 0.5f;
            }
        }
        
        [mainMenuMusic playBackgroundMusic:@"YoungAtHeartMusic.mp3" loop:YES];
        
        musicIsPlaying = YES;
    }
}

- (void) step: (ccTime) delta 
{
    [player1LevelLabelMainMenu setString: [NSString stringWithFormat:@"Z-%i", player1Level]];
    [player1ExperiencePointsLabelMainMenu setString: [NSString stringWithFormat:@"%i%%", player1ExperiencePoints]];    
    
    if (player1MarblesUnlocked == 0) {
        
        ledBulb1.color = ccGREEN;
        ledBulb2.color = ccc3(255, 192, 203);
        ledBulb3.color = ccc3(255, 192, 203);
        ledBulb4.color = ccc3(255, 192, 203);
        ledBulb5.color = ccc3(255, 192, 203);
        
        
        ledLight2.opacity = 0;
        ledLight3.opacity = 0;
        ledLight4.opacity = 0;
        ledLight5.opacity = 0;
    }
    
    else if (player1MarblesUnlocked == 1) {
        
        ledBulb1.color = ccGREEN;
        ledBulb2.color = ccc3(30, 144, 255);
        ledBulb3.color = ccc3(255, 192, 203);
        ledBulb4.color = ccc3(255, 192, 203);
        ledBulb5.color = ccc3(255, 192, 203);  
        
        ledLight2.opacity = 255;
        ledLight3.opacity = 0;
        ledLight4.opacity = 0;
        ledLight5.opacity = 0;
    }
    
    else if (player1MarblesUnlocked == 2) {
        
        ledBulb1.color = ccGREEN;
        ledBulb2.color = ccc3(30, 144, 255);
        ledBulb3.color = ccRED;
        ledBulb4.color = ccc3(255, 192, 203);
        ledBulb5.color = ccc3(255, 192, 203); 
        
        ledLight2.opacity = 255;
        ledLight3.opacity = 255;
        ledLight4.opacity = 0;
        ledLight5.opacity = 0;
    }
    
    else if (player1MarblesUnlocked == 3) {
        
        ledBulb1.color = ccGREEN;
        ledBulb2.color = ccc3(30, 144, 255);
        ledBulb3.color = ccRED;
        ledBulb4.color = ccGRAY;
        ledBulb5.color = ccc3(255, 192, 203); 
        
        ledLight2.opacity = 255;
        ledLight3.opacity = 255;
        ledLight4.opacity = 255;
        ledLight5.opacity = 0;        
    }
    
    else if (player1MarblesUnlocked >= 4) {
        
        ledBulb1.color = ccGREEN;
        ledBulb2.color = ccc3(30, 144, 255);
        ledBulb3.color = ccRED;
        ledBulb4.color = ccGRAY;
        ledBulb5.color = ccc3(250 , 250, 170); 
        
        ledLight2.opacity = 255;
        ledLight3.opacity = 255;
        ledLight4.opacity = 255;
        ledLight5.opacity = 255;      
    }
}

-(void) startiCloudSyncing
{
    [MKiCloudSync start];
}

-(void) syncLabels
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    player1MarblesUnlocked = [prefs integerForKey:@"player1MarblesUnlocked"];
    player1ExperiencePoints = [prefs integerForKey:@"player1ExperiencePoints"];
    player1Level = [prefs integerForKey:@"player1Level"];
}

-(void) loadUserDefaults
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if ([prefs integerForKey:@"player1ExperiencePoints"] == 0) {
        
        // First run, load NSUserDefaults
        [prefs setInteger:97 forKey:@"player1ExperiencePoints"];
        [prefs setInteger:1000 forKey:@"player1Level"];
        
        [prefs synchronize];
        
        player1MarblesUnlocked = [prefs integerForKey:@"player1MarblesUnlocked"];
        player1ExperiencePoints = [prefs integerForKey:@"player1ExperiencePoints"];
        player1Level = [prefs integerForKey:@"player1Level"];
        
        
        NSLog (@"first time loading player1ExperiencePoints = %i", player1ExperiencePoints);
    }
    
    else {
        
        // Second run, load NSUserDefaults
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        player1MarblesUnlocked = [prefs integerForKey:@"player1MarblesUnlocked"];
        player1ExperiencePoints = [prefs integerForKey:@"player1ExperiencePoints"];  
        player1Level = [prefs integerForKey:@"player1Level"];            
        
        NSLog (@"second time loading");
    }
}

-(id) init
{
	if( (self=[super init] )) {
		              
        NSLog (@"Device type = %@", [[UIDevice currentDevice] model]);
                
        [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(loadUserDefaults)],[CCCallFunc actionWithTarget:self selector:@selector(startiCloudSyncing)], [CCCallFunc actionWithTarget:self selector:@selector(syncLabels)], nil]];
        
        isSinglePlayer = YES;
        restartingLevel = NO;
        continuePlayingLevelFromVictoryScreen = NO;
        
        //player1Level = 1000;
        //player1ExperiencePoints = 97;
        
        carpet = [CCSprite spriteWithFile: @"Carpet.png"];
        [self addChild: carpet];
        carpet.anchorPoint = ccp(0,0);
        carpet.position = ccp(0,0);
        carpet.scale = 0.8;
        
        [self gerty];
        [self woodBlock];
        
        if (firstTimeAtMenu == NO) {
            
            carpet.scale = 0.5;
        }
        
        firstTimeAtMenu = NO;
                
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            isIPad = YES;
            NSLog (@"isIPad = %i", isIPad);
        }
        
        else {
            
            isIPad = NO;
            NSLog (@"isIPad = %i", isIPad);
        }
    }
    
    [self playThemeMusic];
    
    [carpet runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.3], [CCEaseIn actionWithAction: [CCScaleTo actionWithDuration: 1 scale: 0.5] rate: 2.0], nil]];
    
    [happyGerty runAction: [CCFadeIn actionWithDuration: 0.5]];

    
    [self schedule: @selector(step:)];
    
	return self;
}


#pragma mark -
#pragma mark ADBannerView

/*
-(void) orientationChanged:(NSNotification *)notification
{
    NSLog(@"orientationChanged");
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    //Transform Ad to adjust it to the current orientation
    //[self fixBannerToDeviceOrientation:orientation];
}
*/


- (void)onEnter
{        
    NSLog(@"onEnter called in MainMenuScene");
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
  /*  
    if (adView == nil) {
    
        adView = [[ADBannerView alloc]initWithFrame:CGRectZero];
        adView.delegate = self;
        adView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierLandscape, ADBannerContentSizeIdentifierLandscape,nil];
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
        [[[CCDirector sharedDirector] openGLView] addSubview:adView];
        
        //Transform bannerView
        [self fixBannerToDeviceOrientation:(UIDeviceOrientation)[[CCDirector sharedDirector] deviceOrientation]];
        
        CGSize windowSize = [[CCDirector sharedDirector] winSize];
        adView.center = CGPointMake(adView.frame.size.width/2,windowSize.height/2-145);
        adView.hidden = NO;
     
    }
  */  
    [super onEnter];
}

- (void)onExit
{
    NSLog (@"onExit called in MainMenuScene");
    
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
/*
    //Completely remove the bannerView
    [adView setDelegate:nil];
    [adView removeFromSuperview];
    [adView release];
    adView = nil;
 */
    [super onExit];
}

#pragma mark -
#pragma mark ADBannerViewDelegate

- (BOOL)allowActionToRun
{
    NSLog(@"allowActionToRun called");
    return TRUE;
}

- (void) stopActionsForAd
{
    /* remember to pause music too! */
    NSLog(@"stopActionsForAd called");
    //[[CCDirector sharedDirector] stopAnimation];
    [[CCDirector sharedDirector] pause];
}

- (void) startActionsForAd
{
    /* resume music, if paused */
    NSLog(@"startActionsForAd called");
    [[CCDirector sharedDirector] stopAnimation];
    [[CCDirector sharedDirector] resume];
    [[CCDirector sharedDirector] startAnimation];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
 
    NSLog (@"Dealloc called in MainMenu");
        
    // in case you have something to dealloc, do it in this method
    // in this particular example nothing needs to be released.
    // cocos2d will automatically release all the children (Label)
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // don't forget to call "super dealloc"
    [super dealloc];
}

-(void) woodBlock
{
    woodblock = [CCSprite spriteWithFile: @"WoodRectangleBlock1.png"];
    [carpet addChild: woodblock z: 5];
    woodblock.position = ccp(925, 575);
    
    woodblock2 = [CCSprite spriteWithFile: @"WoodRectangleBlock2.png"];
    [carpet addChild: woodblock2 z: 5];
    woodblock2.position = ccp(880, 365);
    
    if (showAds == YES) {
        
        woodblock.position = ccp(925, 478);
        woodblock2.position = ccp(880, 268);
    }
    
    stickFigureBoy = [CCSprite spriteWithFile: @"StickFigureBoy.png"];
    [woodblock addChild: stickFigureBoy z: 6];
    stickFigureBoy.scale = 1.2;
    stickFigureBoy.opacity = 215;
    stickFigureBoy.position = ccp(140,130);
    stickFigureBoy.rotation = -23;
    
    stickFigureBoy = [CCSprite spriteWithFile: @"StickFigureBoy.png"];
    [woodblock2 addChild: stickFigureBoy z: 6];
    stickFigureBoy.scale = 1.2;
    stickFigureBoy.opacity = 215;
    stickFigureBoy.position = ccp(85,105);
    stickFigureBoy.rotation = -23;
    
    stickFigureGirl = [CCSprite spriteWithFile: @"StickFigureGirl.png"];
    [woodblock2 addChild: stickFigureGirl z: 6];
    stickFigureGirl.scale = 1.2;
    stickFigureGirl.opacity = 215;
    stickFigureGirl.position = ccp(231,152);
    stickFigureGirl.rotation = -23;
    
    stickGlobeWithArrows = [CCSprite spriteWithFile: @"StickGlobeWithArrows.png"];
    [woodblock2 addChild: stickGlobeWithArrows z: 6];
    stickGlobeWithArrows.scale = 1.2;
    stickGlobeWithArrows.opacity = 215;
    stickGlobeWithArrows.position = ccp(155,135);
    stickGlobeWithArrows.rotation = -19;
}

-(void) labelIsVisible 
{
    label.visible = YES;
}

-(void) labelIsNotVisible 
{
    label.visible = NO;
}
/*
-(void) loadGameSettings
{    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    //If first run, make gertyGrid1 visible, 2-27 invisible
    if ([prefs integerForKey:@"player1ExperiencePoints"] == 0) {
        
        [prefs setInteger:0 forKey:@"player1MarblesUnlocked"];
        
        [prefs synchronize];
    }
    
    else {
        
        //If second run, set gertyGrid1VisibleBool to their NSUserDefaults
            
        player1MarblesUnlocked = [prefs integerForKey:@"player1MarblesUnlocked"];
        player1ExperiencePoints = [prefs integerForKey:@"player1ExperiencePoints"];  
        player1Level = [prefs integerForKey:@"player1Level"];            
        
        [prefs synchronize];

        NSLog (@"second time loading");
    }
}
*/
/*
-(void) gerty 
{
    tamagachi = [CCSprite spriteWithFile: @"Tamagachi.png"];
    happyGerty = [CCSprite spriteWithFile: @"happygerty.png"];
    sadGerty = [CCSprite spriteWithFile: @"sadgerty.png"];
    uncertainGerty = [CCSprite spriteWithFile: @"uncertaingerty.png"];
    cryingGerty = [CCSprite spriteWithFile: @"cryinggerty.png"];
    bigSmileGerty = [CCSprite spriteWithFile: @"bigsmilegerty.png"];
    pensiveGerty = [CCSprite spriteWithFile: @"pensivegerty.png"];
    batteryIndicator = [CCSprite spriteWithFile:@"Battery.png"];
    ledLight1 = [CCSprite spriteWithFile: @"led.png"];
    ledLight2 = [CCSprite spriteWithFile: @"led.png"];
    ledLight3 = [CCSprite spriteWithFile: @"led.png"];
    ledLight4 = [CCSprite spriteWithFile: @"led.png"];
    ledLight5 = [CCSprite spriteWithFile: @"led.png"];
    ledBulb1 = [CCSprite spriteWithFile: @"ledLightOff.png"];
    ledBulb2 = [CCSprite spriteWithFile: @"ledLightOff.png"];
    ledBulb3 = [CCSprite spriteWithFile: @"ledLightOff.png"];
    ledBulb4 = [CCSprite spriteWithFile: @"ledLightOff.png"];
    ledBulb5 = [CCSprite spriteWithFile: @"ledLightOff.png"];
    label = [CCLabelTTF labelWithString:@"Loading..." 
                                           fontName:@"Marker Felt" 
                                           fontSize:24];    
    
    playerLevelLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Z-%i", player1Level] fntFile:@"GertyLevel.fnt"];
    playerExperiencePointsLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i%%", player1ExperiencePoints] fntFile:@"BatteryLifeBlack2.fnt"];

    
    [happyGerty runAction: [CCFadeOut actionWithDuration: 0.0]];
    sadGerty.visible = NO;
    uncertainGerty.visible = NO;
    cryingGerty.visible = NO;
    bigSmileGerty.visible = NO;
    pensiveGerty.visible = NO;

    
    [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(labelIsVisible)], [CCDelayTime actionWithDuration: 0.7], [CCCallFunc actionWithTarget:self selector:@selector(labelIsNotVisible)], [CCDelayTime actionWithDuration: 0.4], nil]]];
  
 
    tamagachi.scale = 2.0;
    
    [carpet addChild: tamagachi];
    [tamagachi addChild: happyGerty];
    [tamagachi addChild: sadGerty];
    [tamagachi addChild: uncertainGerty];
    [tamagachi addChild: cryingGerty];
    [tamagachi addChild: bigSmileGerty];
    [tamagachi addChild: pensiveGerty];
    [tamagachi addChild:label z:100];
    [tamagachi addChild: playerLevelLabel];
    [tamagachi addChild: playerExperiencePointsLabel];
    [tamagachi addChild: ledLight1 z:5];
    [tamagachi addChild: ledLight2 z:5];
    [tamagachi addChild: ledLight3 z:5];
    [tamagachi addChild: ledLight4 z:5];
    [tamagachi addChild: ledLight5 z:5];
    [tamagachi addChild: ledBulb1];
    [tamagachi addChild: ledBulb2];
    [tamagachi addChild: ledBulb3];
    [tamagachi addChild: ledBulb4];
    [tamagachi addChild: ledBulb5];
    [tamagachi addChild: batteryIndicator];


    ledLight1.color = ccGREEN;
    ledLight1.scale = 0.5;
    ledLight1.opacity = 255;
    
    ledLight2.color = ccc3(30, 144, 255);
    ledLight2.scale = 0.5;
    
    ledLight3.color = ccRED;
    ledLight3.scale = 0.5;
    
    ledLight4.color = ccGRAY;
    ledLight4.scale = 0.5;
    
    ledLight5.color = ccc3(250 , 250, 170);
    ledLight5.scale = 0.5;
    
    ledBulb1.scale = 0.35;
    ledBulb1.color = ccGREEN;
    
    ledBulb2.scale = 0.35;
    ledBulb2.color = ccc3(255, 192, 203);
    
    ledBulb3.scale = 0.35;
    ledBulb3.color = ccc3(255, 192, 203);
    
    ledBulb4.scale = 0.35;
    ledBulb4.color = ccc3(255, 192, 203);
    
    ledBulb5.scale = 0.35;
    ledBulb5.color = ccc3(255, 192, 203);
    
    NSLog (@"player1MarblesUnlocked = %i", player1MarblesUnlocked);
    
    if (player1MarblesUnlocked == 0) {

        ledBulb1.color = ccGREEN;
        ledBulb2.color = ccc3(255, 192, 203);
        ledBulb3.color = ccc3(255, 192, 203);
        ledBulb4.color = ccc3(255, 192, 203);
        ledBulb5.color = ccc3(255, 192, 203);

        
        ledLight2.opacity = 0;
        ledLight3.opacity = 0;
        ledLight4.opacity = 0;
        ledLight5.opacity = 0;
    }
    
    else if (player1MarblesUnlocked == 1) {
        
        ledBulb1.color = ccGREEN;
        ledBulb2.color = ccc3(30, 144, 255);
        ledBulb3.color = ccc3(255, 192, 203);
        ledBulb4.color = ccc3(255, 192, 203);
        ledBulb5.color = ccc3(255, 192, 203);  
        
        ledLight2.opacity = 255;
        ledLight3.opacity = 0;
        ledLight4.opacity = 0;
        ledLight5.opacity = 0;
    }

    else if (player1MarblesUnlocked == 2) {
        
        ledBulb1.color = ccGREEN;
        ledBulb2.color = ccc3(30, 144, 255);
        ledBulb3.color = ccRED;
        ledBulb4.color = ccc3(255, 192, 203);
        ledBulb5.color = ccc3(255, 192, 203); 
        
        ledLight2.opacity = 255;
        ledLight3.opacity = 255;
        ledLight4.opacity = 0;
        ledLight5.opacity = 0;
    }

    else if (player1MarblesUnlocked == 3) {
        
        ledBulb1.color = ccGREEN;
        ledBulb2.color = ccc3(30, 144, 255);
        ledBulb3.color = ccRED;
        ledBulb4.color = ccGRAY;
        ledBulb5.color = ccc3(255, 192, 203); 
        
        ledLight2.opacity = 255;
        ledLight3.opacity = 255;
        ledLight4.opacity = 255;
        ledLight5.opacity = 0;        
    }

    else if (player1MarblesUnlocked == 4) {
        
        ledBulb1.color = ccGREEN;
        ledBulb2.color = ccc3(30, 144, 255);
        ledBulb3.color = ccRED;
        ledBulb4.color = ccGRAY;
        ledBulb5.color = ccc3(250 , 250, 170); 
        
        ledLight2.opacity = 255;
        ledLight3.opacity = 255;
        ledLight4.opacity = 255;
        ledLight5.opacity = 255;      
    }
    

    
    tamagachi.anchorPoint = ccp(0.5, 0.5);
    happyGerty.anchorPoint = ccp(0.5, 0.5);
    sadGerty.anchorPoint = ccp(0.5, 0.5);
    uncertainGerty.anchorPoint = ccp(0.5, 0.5);
    cryingGerty.anchorPoint = ccp(0.5, 0.5);
    bigSmileGerty.anchorPoint = ccp(0.5, 0.5);
    pensiveGerty.anchorPoint = ccp(0.5, 0.5);
    label.anchorPoint = ccp(0.5, 0.5);
    playerLevelLabel.anchorPoint = ccp(0.5, 0.5);
    playerExperiencePointsLabel.anchorPoint = ccp(0.5, 0.5);
    ledLight1.anchorPoint = ccp(0.5, 0.5);
    ledLight2.anchorPoint = ccp(0.5, 0.5);
    ledLight3.anchorPoint = ccp(0.5, 0.5);
    ledLight4.anchorPoint = ccp(0.5, 0.5);
    ledLight5.anchorPoint = ccp(0.5, 0.5);
    ledBulb1.anchorPoint = ccp(0.5, 0.5);
    ledBulb2.anchorPoint = ccp(0.5, 0.5);
    ledBulb3.anchorPoint = ccp(0.5, 0.5);
    ledBulb4.anchorPoint = ccp(0.5, 0.5);
    ledBulb5.anchorPoint = ccp(0.5, 0.5);
    batteryIndicator.anchorPoint = ccp(0.5, 0.5);

    
    tamagachi.position = ccp(295,200);
    happyGerty.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
    sadGerty.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
    uncertainGerty.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
    cryingGerty.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
    bigSmileGerty.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
    pensiveGerty.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
    label.position = ccp(-500, -500);
    playerLevelLabel.position = ccp(([tamagachi contentSize].width/2 - 27), ([tamagachi contentSize].height/2) + 42);
    playerExperiencePointsLabel.position = ccp(([tamagachi contentSize].width/2 + 37), ([tamagachi contentSize].height/2) + 31.5);
    ledLight1.position = ccp([tamagachi contentSize].width/2 - 30, [tamagachi contentSize].height/2 - 45);
    ledLight2.position = ccp([tamagachi contentSize].width/2 - 15, [tamagachi contentSize].height/2 - 45);
    ledLight3.position = ccp([tamagachi contentSize].width/2 + 0, [tamagachi contentSize].height/2 - 45);
    ledLight4.position = ccp([tamagachi contentSize].width/2 + 15, [tamagachi contentSize].height/2 - 45);
    ledLight5.position = ccp([tamagachi contentSize].width/2 + 30, [tamagachi contentSize].height/2 - 45);
    ledBulb1.position = ccp([tamagachi contentSize].width/2 - 30, [tamagachi contentSize].height/2 - 45);
    ledBulb2.position = ccp([tamagachi contentSize].width/2 - 15, [tamagachi contentSize].height/2 - 45);
    ledBulb3.position = ccp([tamagachi contentSize].width/2 + 0, [tamagachi contentSize].height/2 - 45);
    ledBulb4.position = ccp([tamagachi contentSize].width/2 + 15, [tamagachi contentSize].height/2 - 45);
    ledBulb5.position = ccp([tamagachi contentSize].width/2 + 30, [tamagachi contentSize].height/2 - 45);
    batteryIndicator.position = ccp(playerExperiencePointsLabel.position.x + - 1.5, playerExperiencePointsLabel.position.y);

    
    happyGerty.scaleX = 0.6;
    happyGerty.scaleY = 0.6;
    sadGerty.scaleX = 0.6;
    sadGerty.scaleY = 0.6;
    uncertainGerty.scaleX = 0.6;
    uncertainGerty.scaleY = 0.6;
    cryingGerty.scaleX = 0.6;
    cryingGerty.scaleY = 0.6;
    bigSmileGerty.scaleX = 0.6;
    bigSmileGerty.scaleY = 0.6;
    pensiveGerty.scaleX = 0.6;
    pensiveGerty.scaleY = 0.6;
    batteryIndicator.scale = 0.2;
        
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
        playerLevelLabel.scaleX = 0.5;
        playerLevelLabel.scaleY = 0.5;
        playerExperiencePointsLabel.scaleX = 0.38;
        playerExperiencePointsLabel.scaleY = 0.38;
    }
    
    else {
   
        playerLevelLabel.scaleX = 0.25;
        playerLevelLabel.scaleY = 0.25;
        playerExperiencePointsLabel.scaleX = 0.38/2;
        playerExperiencePointsLabel.scaleY = 0.38/2;
  //  }
}
*/
-(void) loadSinglePlayerScene
{
    isSinglePlayer = YES;
    musicIsPlaying = NO;

    [[CCDirector sharedDirector] replaceScene: [CCTransitionMoveInB transitionWithDuration:0.5f scene: [Game scene]]];  
    //[[CCDirector sharedDirector] replaceScene:[LoadingScene scene]];
    
    //[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

-(void) loadMultiplayerScene
{
    isSinglePlayer = NO;
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene: [Game scene]]]; 
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{    
    /*
    CGPoint touchLocation = [carpet convertTouchToNodeSpace:touch];
    
    NSLog (@"TouchBegan called in MainMenu");
        
    if (CGRectContainsPoint(woodblock.boundingBox, touchLocation)) {
        
        int woodBlockScript = arc4random()%2;
        
        if (woodBlockScript == 0) {
        
            [woodblock runAction: [CCEaseOut actionWithAction: [CCRotateBy actionWithDuration:0.1 angle:7] rate:1.5]];
        }
        
        else if (woodBlockScript == 1) {
            
            [woodblock runAction: [CCEaseOut actionWithAction: [CCRotateBy actionWithDuration:0.1 angle:2.5] rate:1.5]];
            [woodblock runAction: [CCEaseOut actionWithAction: [CCMoveBy actionWithDuration:0.1 position:ccp(0,2.5)] rate:1.5]];
        }
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"HardMarbleCollision.caf"];
        happyGerty.visible = NO;
        sadGerty.visible = NO;
        uncertainGerty.visible = NO;
        cryingGerty.visible = NO;
        bigSmileGerty.visible = NO;
        pensiveGerty.visible = NO;
        label.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);

        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.12], [CCCallFunc actionWithTarget:self selector:@selector(loadSinglePlayerScene)], nil]];
    }
    
    else if (CGRectContainsPoint(woodblock2.boundingBox, touchLocation)) {
        
        int woodBlockScript2 = arc4random()%2;

        if (woodBlockScript2 == 0) {
        
            [woodblock2 runAction: [CCEaseOut actionWithAction: [CCMoveBy actionWithDuration:0.1 position:ccp(0,2)] rate:1.5]];
            [woodblock2 runAction: [CCEaseOut actionWithAction: [CCRotateBy actionWithDuration:0.1 angle:3] rate:1.5]];
        }
        
        else if (woodBlockScript2 == 1) {
            
            [woodblock2 runAction: [CCEaseOut actionWithAction: [CCRotateBy actionWithDuration:0.1 angle:7] rate:1.5]];
        }
        
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"HardMarbleCollision.caf"];
        happyGerty.visible = NO;
        sadGerty.visible = NO;
        uncertainGerty.visible = NO;
        cryingGerty.visible = NO;
        bigSmileGerty.visible = NO;
        pensiveGerty.visible = NO;
        label.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.12], [CCCallFunc actionWithTarget:self selector:@selector(loadMultiplayerScene)], nil]];           
    }
    
     return TRUE; 
     */
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event 
{       
/*
    CGPoint touchPoint = [touch locationInView:[touch view]];
    
	CGPoint touchLocationMoved = [touch locationInView: [touch view]];	
	CGPoint prevLocationMoved = [touch previousLocationInView: [touch view]];	
 */
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{

}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{	
    /*
	CGPoint touchPoint = [touch locationInView:[touch view]];
	CGPoint touchLocation = [touch locationInView: [touch view]];    
	CGPoint prevLocation = [touch previousLocationInView: [touch view]];	
*/
   // [carpet runAction: [CCEaseOut actionWithAction: [CCScaleTo actionWithDuration: 1 scale: 1.0] rate: 2.0]];
}

@end
