//
//  GrenadeGameAppDelegate.m
//  GrenadeGame
//
//  Created by Robert Blackwood on 1/19/11.
//  Copyright Mobile Bros 2011. All rights reserved.
//

#import "cocos2d.h"

#import "GrenadeGameAppDelegate.h"
#import "GameConfig.h"
#import "MainMenuScene.h"
#import "RootViewController.h"
#import "InAppRageIAPHelper.h"


@implementation GrenadeGameAppDelegate

@synthesize window;
@synthesize viewController;

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	
	//	CC_ENABLE_DEFAULT_GL_STATES();
	//	CCDirector *director = [CCDirector sharedDirector];
	//	CGSize size = [director winSize];
	//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
	//	sprite.position = ccp(size.width/2, size.height/2);
	//	sprite.rotation = -90;
	//	[sprite visit];
	//	[[director openGLView] swapBuffers];
	//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}

- (void) applicationDidFinishLaunching:(UIApplication*)application
{            
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	    
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	
    EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
    
    NSString* pDeviceModel = [UIDevice currentDevice].model; 
    
    NSLog (@"Device model = %@", pDeviceModel);

    if ([pDeviceModel isEqualToString:@"iPhone Simulator"] || [pDeviceModel isEqualToString:@"iPhone"] || [pDeviceModel isEqualToString:@"iPod touch"]) {
        
        isIPhoneIPod = NO;
    }
    
    else {
        
        isIPhoneIPod = NO;
    }
    
    UIDeviceHardware *h=[[UIDeviceHardware alloc] init];
    NSLog (@"Device type = %@", [h platformString]);
    
    if ([[h platformString] isEqualToString:@"iPhone 1G"] || [[h platformString] isEqualToString:@"iPhone 3G"] || [[h platformString] isEqualToString:@"iPhone 3GS"] || [[h platformString] isEqualToString:@"iPhone 4"] || [[h platformString] isEqualToString:@"Verizon iPhone 4"] || [[h platformString] isEqualToString:@"iPod Touch 1G"] || [[h platformString] isEqualToString:@"iPod Touch 2G"] || [[h platformString] isEqualToString:@"iPod Touch 3G"] || [[h platformString] isEqualToString:@"iPod Touch 4G"] || [[h platformString] isEqualToString:@"iPad"] || [[h platformString] isEqualToString:@"iPad 2 (WiFi)"] || [[h platformString] isEqualToString:@"iPad 2 (GSM)"] || [[h platformString] isEqualToString:@"iPad 2 (CDMA)"]) {
        
        [director enableRetinaDisplay:NO];
        userIsOnFastDevice = NO;
    }
    
    else {
        
        [director enableRetinaDisplay:YES];
        userIsOnFastDevice = YES;
    }
    
    /*
    if (isIPhoneIPod == YES) {
    
        [director enableRetinaDisplay:NO];
    }
    
    else {
        
        [director enableRetinaDisplay:YES];
    }
	*/	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	//[window addSubview: viewController.view];
	[window setRootViewController: viewController];
	
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];

	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
    [[GCHelper sharedInstance] authenticateLocalUser];  
    
    firstTimeAtMenu = YES;
    firstTimeLoadingGameScene = YES;
        
	// Run the intro Scene
    
	[[CCDirector sharedDirector] runWithScene: [CCTransitionFade transitionWithDuration:0.5f scene: [Game scene]]]; 
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;        
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   // NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
	NSNumber *stageValue = [NSNumber numberWithInt:2];
    NSNumber *showAdsValue = [NSNumber numberWithBool:YES];
    NSNumber *computerExperiencePointsValue = [NSNumber numberWithInt:10];
    NSNumber *difficultyLevelValue = [NSNumber numberWithInt: 0];
    NSNumber *player1MarblesUnlockedValue = [NSNumber numberWithInt: 0];
    NSNumber *player1ExperiencePointsValue = [NSNumber numberWithInt:97];
    NSNumber *player1LevelValue = [NSNumber numberWithInt:100];
    NSNumber *showPointingFingerForGertyMainMenuLightBulbsValue = [NSNumber numberWithBool:NO];
    NSNumber *showPointingFingerForGertyMainMenuTamagachiValue = [NSNumber numberWithBool:YES];
    NSNumber *tamagachiColorValue = [NSNumber numberWithInt:TAMAGACHI_1_RED];


	NSDictionary *appDefaults = [[NSDictionary alloc] initWithObjectsAndKeys:
								 stageValue, @"stage", showAdsValue, @"showAds", computerExperiencePointsValue, @"computerExperiencePoints", difficultyLevelValue, @"difficultyLevel", player1MarblesUnlockedValue, @"player1MarblesUnlocked", player1ExperiencePointsValue, @"player1ExperiencePoints", player1LevelValue, @"player1Level", showPointingFingerForGertyMainMenuLightBulbsValue, @"showPointingFingerForGertyMainMenuLightBulbs", showPointingFingerForGertyMainMenuTamagachiValue, @"showPointingFingerForGertyMainMenuTamagachi",  tamagachiColorValue, @"tamagachi1Color", nil];
    
    
    [prefs registerDefaults:appDefaults];
    [appDefaults release];
    
    NSLog (@"stage = %i", stage);
    
    [MKiCloudSync start];
    
    // all your app’s startup code
    // Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeDefault];
	
	
	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	
    EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
								   pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
								   depthFormat:0						// GL_DEPTH_COMPONENT16_OES
						];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
	
    //	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	if( ! [director enableRetinaDisplay:YES] )
		CCLOG(@"Retina Display Not supported");
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/60];
	[director setDisplayFPS:NO];
    
    NSString* pDeviceModel = [UIDevice currentDevice].model; 
    
    NSLog (@"Device model = %@", pDeviceModel);
  /*  
    if ([pDeviceModel isEqualToString:@"iPhone Simulator"] || [pDeviceModel isEqualToString:@"iPhone"] || [pDeviceModel isEqualToString:@"iPod touch"]) {
        
        isIPhoneIPod = NO;
    }
    
    else {
        
        isIPhoneIPod = NO;
    }
   */ 
    UIDeviceHardware *h=[[UIDeviceHardware alloc] init];
    NSLog (@"Device type = %@", [h platformString]);
    /*
    if ([[h platformString] isEqualToString:@"iPhone 1G"] || [[h platformString] isEqualToString:@"iPhone 3G"] || [[h platformString] isEqualToString:@"iPhone 3GS"] || [[h platformString] isEqualToString:@"iPhone 4"] || [[h platformString] isEqualToString:@"Verizon iPhone 4"] || [[h platformString] isEqualToString:@"iPod Touch 1G"] || [[h platformString] isEqualToString:@"iPod Touch 2G"] || [[h platformString] isEqualToString:@"iPod Touch 3G"] || [[h platformString] isEqualToString:@"iPod Touch 4G"] || [[h platformString] isEqualToString:@"iPad"] || [[h platformString] isEqualToString:@"iPad 2 (WiFi)"] || [[h platformString] isEqualToString:@"iPad 2 (GSM)"] || [[h platformString] isEqualToString:@"iPad 2 (CDMA)"]) {
        
        isIPhoneIPod = YES;
    }
    
    else {
        
        isIPhoneIPod = NO;
    }
    
    
     if (isIPhoneIPod == YES) {
     
         [director enableRetinaDisplay:NO];
     }
     
     else {
     
         [director enableRetinaDisplay:YES];
     }
     	*/
    
    if ([[h platformString] isEqualToString:@"iPhone 1G"] || [[h platformString] isEqualToString:@"iPhone 3G"] || [[h platformString] isEqualToString:@"iPhone 3GS"] || [[h platformString] isEqualToString:@"iPhone 4"] || [[h platformString] isEqualToString:@"Verizon iPhone 4"] || [[h platformString] isEqualToString:@"iPod Touch 1G"] || [[h platformString] isEqualToString:@"iPod Touch 2G"] || [[h platformString] isEqualToString:@"iPod Touch 3G"] || [[h platformString] isEqualToString:@"iPod Touch 4G"] || [[h platformString] isEqualToString:@"iPad"] || [[h platformString] isEqualToString:@"iPad 2 (WiFi)"] || [[h platformString] isEqualToString:@"iPad 2 (GSM)"] || [[h platformString] isEqualToString:@"iPad 2 (CDMA)"]) {
        
        [director enableRetinaDisplay:NO];
        userIsOnFastDevice = NO;
        isIPhoneIPod = YES;
    }
    
    else {
        
        [director enableRetinaDisplay:YES];
        userIsOnFastDevice = YES;
        isIPhoneIPod = NO;
    }
    
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	//[window addSubview: viewController.view];
	[window setRootViewController: viewController];
    
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
    
	
	// Removes the startup flicker
	[self removeStartupFlicker];
	
    [[GCHelper sharedInstance] authenticateLocalUser];  
    
    firstTimeAtMenu = YES;
    firstTimeLoadingGameScene = YES;
    
	// Run the intro Scene
    
	[[CCDirector sharedDirector] runWithScene: [CCTransitionFade transitionWithDuration:0.5f scene: [Game scene]]]; 
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;  
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[InAppRageIAPHelper sharedHelper]];
    
    //DEBUG: Uncomment the following line to enable AdMob
    //[viewController initGADBanner];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {	
	
    if(gamePaused == NO) {
        
        [[CCDirector sharedDirector] pause];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	
    if (gamePaused == NO) {
        
        [[CCDirector sharedDirector] resume];
    }
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
    [[CCDirector sharedDirector] purgeCachedData];    
}

-(void) applicationDidEnterBackground:(UIApplication*)application {	
	
    [(Game*)[[[CCDirector sharedDirector] runningScene] getChildByTag:GAME_TAG] save];

	[[CCDirector sharedDirector] stopAnimation];
    
    NSLog (@"applicationDidEnterBackground");
    
    if (!isSinglePlayer) {
        
        if (isPlayer1) {
                        
           // playersCanTouchMarblesNow = NO;
            isPlayer1 = YES;
            player1Winner = NO;
            player2Winner = YES;
        }
        
        else if (!isPlayer1) {
            
           // playersCanTouchMarblesNow = NO;
            isPlayer1 = NO;
            player1Winner = YES;
            player2Winner = NO;
        }
    }
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}

@end
