//
//  Serialize.h
//  Example For Example
//
//  Created by Rob Blackwood on 5/30/10.
//

#import "SpaceManagerCocos2d.h"
#import "GameConfig.h"
#import "Bomb.h"
#import "Bomb2.h"
#import "Gerty.h"
#import "Gerty2.h"
#import "RootViewController.h"
#import "TriangleShape.h"
#import "RectangleShape.h"
#import "GCHelper.h"
#import "Lightning.h"
#import "CDAudioManager.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CDXPropertyModifierAction.h"
#import "UIDeviceHardware.h"
#import "MBProgressHUD.h"
#import "MainMenuScene.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GrenadeGameAppDelegate.h"
#import "RootViewController.h"
//#import "GADBannerView.h"


#define TAMAGACHI_1_RED                 1
#define TAMAGACHI_1_PINK                2
#define TAMAGACHI_1_GREEN               3
#define TAMAGACHI_1_YELLOW              4
#define TAMAGACHI_1_ORANGE              5
#define TAMAGACHI_1_LIGHTPURPLE         6
#define TAMAGACHI_1_PURPLE              7
#define TAMAGACHI_1_BLUE                8
#define TAMAGACHI_1_WHITE               9
#define TAMAGACHI_1_BLACK               10

#define TAMAGACHI_2_RED                 1
#define TAMAGACHI_2_PINK                2
#define TAMAGACHI_2_GREEN               3
#define TAMAGACHI_2_YELLOW              4
#define TAMAGACHI_2_ORANGE              5
#define TAMAGACHI_2_LIGHTPURPLE         6
#define TAMAGACHI_2_PURPLE              7
#define TAMAGACHI_2_BLUE                8
#define TAMAGACHI_2_WHITE               9
#define TAMAGACHI_2_BLACK               10

#define DAY_TIME_SUBURB                1
#define NIGHT_TIME_SUBURB              2
#define RANDOM_STAGE                   3



enum GameStatePP {
    kGameStatePlaying,
    kGameStatePaused
};


BOOL isPlayer1;
Bomb *_curBomb;
Bomb2 *_curBombPlayer2;

CDAudioManager *am;
CDSoundEngine  *soundEngine;
CCSprite *groundLevel;


int tamagachi1Color;
int tamagachi2Color;
int totalSoundSources;
int sourceIDNumber;
BOOL readyToReceiveBlocksPositionsFromPlayer1;
BOOL readyToReceiveBlockNumbersFromPlayer2;
int player1MarbleColor;
int player2MarbleColor;
BOOL colorReceivedFromPlayer1;
BOOL singlePlayer;
BOOL firstPlayer1MarbleSetToGreen;
BOOL firstPlayer2MarbleSetToGreen;
BOOL cameraTrackingMarblePlayer1;
BOOL cameraTrackingMarblePlayer2;
BOOL player1BombZapped;
BOOL player2BombZapped;
BOOL isSinglePlayer;
BOOL isIPad;
BOOL isRetinaDisplay;
int glColorRedPlayer1;
int glColorGreenPlayer1;
int glColorBluePlayer1;
int glColorAlphaPlayer1;
int glPointSizeValuePlayer1;
int glColorRedPlayer2;
int glColorGreenPlayer2;
int glColorBluePlayer2;
int glColorAlphaPlayer2;
int glPointSizeValuePlayer2;
int marbleBlocksInARow;
BOOL chargeMaxedOut;
int skillLevelBonus;
BOOL gamePaused;
int difficultyLevel;
CDXAudioNode *audioBlockOnFire;
NSMutableArray *loadRequests;
CDXAudioNode *audioBlockCrumblingFromFire;
CDXAudioNode *audioIceBlockBeingDestroyed;
int destroyedBlocksInARow1;
int destroyedBlocksInARow2;
ccColor3B computerGertyColor;
int difficultyLevel;
int computerExperiencePoints;
int player1MarblesUnlocked;
int player2MarblesUnlocked;
int player1MarblesUnlockedForLabel;
int player1MarblesUnlockedMultiplayerValue;
int player2MarblesUnlockedMultiplayerValue;
CCSprite *ledLight1;
CCSprite *ledLight2;
CCSprite *ledLight3;
CCSprite *ledLight4;
CCSprite *ledLight5;
CCSprite *ledBulb1;
CCSprite *ledBulb2;
CCSprite *ledBulb3;
CCSprite *ledBulb4;
CCSprite *ledBulb5;
CCSprite *ledLight1Player2;
CCSprite *ledLight2Player2;
CCSprite *ledLight3Player2;
CCSprite *ledLight4Player2;
CCSprite *ledLight5Player2;
CCSprite *ledBulb1Player2;
CCSprite *ledBulb2Player2;
CCSprite *ledBulb3Player2;
CCSprite *ledBulb4Player2;
CCSprite *ledBulb5Player2;
CCSprite *ledLight1MainMenu;
CCSprite *ledLight2MainMenu;
CCSprite *ledLight3MainMenu;
CCSprite *ledLight4MainMenu;
CCSprite *ledLight5MainMenu;
CCSprite *ledBulb1MainMenu;
CCSprite *ledBulb2MainMenu;
CCSprite *ledBulb3MainMenu;
CCSprite *ledBulb4MainMenu;
CCSprite *ledBulb5MainMenu;
int bonusPoints1;
int bonusPoints2;
BOOL player1GertyShouldBeDead;
BOOL player2GertyShouldBeDead;
BOOL playersCanTouchMarblesNow;
BOOL player1Winner;
BOOL player2Winner;
BOOL woodBlockTouched;
BOOL woodBlock2Touched;
BOOL woodBlock3Touched;
BOOL player1BombCreated;
BOOL player2BombCreated;
BOOL doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1;
BOOL doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2;
NSUserDefaults *prefs;
CCSprite *linedPaper;
BOOL dayTimeSuburbSelected;
BOOL nightTimeSuburbSelected;
int stage;
RectangleShape *rectangleShape;
BOOL deviceIsWidescreen;



typedef enum {
    kMessageTypeRandomNumber = 0,
    kMessageTypeGameBegin,
    kMessageTypeMove,
    kMessageTypeMove2,
    kMessageTypeLaunchProjectile,
    kMessageTypeLaunchProjectile2,
    kMessageTypeAppStartTime,
    kMessageTypeGameOver,
    kMessageTypeSendToken,
    kMessageTypePlayer1BlockPoint,
    kMessageTypePlayer1BlocksPositions,
    kMessageTypeBlockInfo,
    kMessageTypeBlockNumbersFromPlayer2,
    kMessageTypeProjectileBlocked,
    kMessageTypeProjectileBlocked2,
    kMessageTypeStretchingSling,
    kMessageTypeAudioProjectileLaunch,
    kMessageTypeAudioChargingShot,
    kMessageTypeAudioIncomingProjectile,
    kMessageTypeRequestBlockInfoFromPlayer1,
    kMessageTypeRequestBlockInfoFromPlayer2,
    kMessageTypePlayer1MarbleColor,
    kMessageTypePlayer2MarbleColor,
    kMessageTypeProjectileChargingPitch1,
    kMessageTypeProjectileChargingPitch2,
    kMessageTypeIncreaseSkillLevelBonus,
    kMessageTypePauseGame,
    kMessageTypePlayer1GertyShouldBeDead,
    kMessageTypePlayer2GertyShouldBeDead,
    kMessageTypeUnlockedMarbles1,
    kMessageTypeUnlockedMarbles2,
    kMessageTypeBonusPointsPlayer1,
    kMessageTypeBonusPointsPlayer2,
    kMessageTypePlayAgain,
    kMessageTypeOtherPlayerHasLeftMatchFromVersusScreen,
    kMessageTypePrelaunchTimeDelay,
    kMessageTypeOpposingPlayersTamagachiColor,
    kMessageTypeTeslaGlow,
    kMessageTypeTeslaGlowOff,
    kMessagePlayerReadyToStartInGameCountdown,
    kMessageTypePlayer1HandicapInteger,
    kMessageTypePlayer2HandicapInteger,
} MessageType;


typedef struct {
    MessageType messageType;
} Message;

typedef struct {
    Message message;
} MessagePlayerReadyToStartInGameCountdown;

typedef struct {
    Message message;
    int player1HandicapIntegerStruct;
    float handicapCoefficientPlayer1Struct;
} MessagePlayer1HandicapInteger;

typedef struct {
    Message message;
    int player2HandicapIntegerStruct;
    float handicapCoefficientPlayer2Struct;
} MessagePlayer2HandicapInteger;

typedef struct {
    Message message;
    uint32_t randomNumber;
} MessageRandomNumber;

typedef struct {
    Message message;
    int pillarConfigurationMessage;
} MessagePillarConfiguration;

typedef struct {
    Message message;
} MessageGameBegin;

typedef struct {
    Message message;
} MessagePlayAgain;

typedef struct {
    Message message;
} MessageOtherPlayHasLeftMatchFromVersusScreen;

typedef struct {
    Message message;
} MessageTeslaGlow;

typedef struct {
    Message message;
} MessageTeslaGlowOff;

typedef struct {
    Message message;
    CFTimeInterval player1CFAbsoluteTimeGetCurrent;
    CFTimeInterval player1AppAbsoluteStartTime;
} MessageAppStartTime;

typedef struct {
    Message message;
    int unlockedMarbles1;
    int player1LevelStruct;
    int player1ExperiencePointsStruct;
} MessageUnlockedMarbles1;

typedef struct {
    Message message;
    int unlockedMarbles2;
    int player2LevelStruct;
    int player2ExperiencePointsStruct;
} MessageUnlockedMarbles2;

typedef struct {
    Message message;
    double prelaunchTimeDelayStruct;
} MessageSendPrelaunchTimeDelay;

typedef struct {
    Message message;
    int opposingPlayersTamagachiColor;
    int pillarConfigurationStruct;
} MessageSendOpposingPlayersTamagachiColor;

typedef struct {
    Message message;
    int bonusPoints1Struct;
} MessageBonusPointsPlayer1;

typedef struct {
    Message message;
    int bonusPoints2Struct;
} MessageBonusPointsPlayer2;

typedef struct {
    Message message;
    int marbleColor1;
    BOOL doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1;
} MessagePlayer1MarbleColor;

typedef struct {
    Message message;
    int marbleColor2;
    BOOL doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2;
} MessagePlayer2MarbleColor;

typedef struct {
    Message message;
} MessagePlayer1GertyShouldBeDead;

typedef struct {
    Message message;
} MessagePlayer2GertyShouldBeDead;

typedef struct {
    Message message;
} MessagePauseGame;

typedef struct {
    Message message;
    int blockPointXValueOfMarble1;
} MessageProjectileBlocked;

typedef struct {
    Message message;
    int blockPointXValueOfMarble2;
} MessageProjectileBlocked2;

typedef struct {
    Message message;
    BOOL receivingChargingDataFromPlayer1;
    double chargedShotTimeStarted;
    int blockingChargeBonusPlayer1;
} MessageProjectileChargingPitch;

typedef struct {
    Message message;
    BOOL receivingChargingDataFromPlayer2;
    double chargedShotTimeStarted2;
    int blockingChargeBonusPlayer2;
} MessageProjectileChargingPitch2;

typedef struct {
    Message message;
} MessageAudioIncomingProjectile;

typedef struct {
    Message message;
} MessageIncreaseSkillLevelBonus;

typedef struct {
    Message message;
} MessageAudioChargingShot;

typedef struct {
    Message message;
} MessageStretchingSling;

typedef struct {
    Message message;
} MessageAudioProjectileLaunch;

typedef struct {
    Message message;
} MessageRequestBlockInfoFromPlayer1;

typedef struct {
    Message message;
} MessageRequestBlockInfoFromPlayer2;

typedef struct {
    Message message;
    int total_number_of_blocks;
    int block_id;
    float block_angle;
    CGPoint block_position;
    //CGPoint block_velocity;
} MessageBlockInfo;

typedef struct {
    Message message;
    int total_number_of_blocks;
    int block_id;
} MessageBlockNumberFromPlayer2;

typedef struct {
    Message message;
    CGPoint player1BlockPoint;
} MessagePlayer1BlockPoint;

typedef struct {
    Message message;
    CGPoint point;
} MessageMove;

typedef struct {
    Message message;
} MessageSendToken;

typedef struct {
    Message message;
    CGPoint launchPoint;
    int marbleRotationalVelocity;
    int projectileShotMultiplier;
    int projectileShotMultiplier2;
} MessageLaunchProjectile;

typedef struct {
    Message message;
    BOOL player1Won;
} MessageGameOver;

typedef enum {
    kEndReasonWin,
    kEndReasonLose,
    kEndReasonDisconnect
} EndReason;

typedef enum {
    kGameStateWaitingForMatch = 0,
    kGameStateWaitingForRandomNumber,
    kGameStateWaitingForStart,
    kGameStateActive,
    kGameStateDone
} GameState;


@interface Game : CCLayer<SpaceManagerSerializeDelegate, UIGestureRecognizerDelegate, GCHelperDelegate>
{
	SpaceManagerCocos2d *smgr;
	
	NSMutableArray	*_bombsPlayer1;
    NSMutableArray	*_bombsPlayer2;
    NSMutableArray	*_player2BombInPlay;
	Bomb			*_curBomb;
	Bomb2            *_curBombPlayer2;
    Bomb            *bombToBeLaunched;
	int _enemiesLeft;
    CCLabelBMFont *debugLabel;
    GameState gameState;
    
    uint32_t ourRandom;
    BOOL receivedRandom;
    NSString *otherPlayerID;
    
    CCLabelBMFont *player1Label;
    CCLabelBMFont *player2Label;
    
    CGPoint ZB_last_posn;
    
    CGPoint ptPlayer1;
    CGPoint normalVectorPlayer1;
    float lengthPlayer1;
    CGPoint bombPtPlayer1;
    CGPoint currentBombPostionPlayer1;
    CGPoint player1Vector;
    CGPoint ptPlayer2;
    CGPoint normalVectorPlayer2;
    float lengthPlayer2;
    CGPoint bombPtPlayer2;
    CGPoint currentBombPostionPlayer2;
    CGPoint player2Vector;
    
    MBProgressHUD *_hud;
    
    RootViewController *viewController;
    enum GameStatePP _state;
}


@property (readonly) SpaceManager* spaceManager;
//@property(readwrite,assign) int percentComplete;
@property(nonatomic, assign) BOOL bannerIsVisible;
@property (retain) MBProgressHUD *hud;
@property(nonatomic) enum GameStatePP state;

+(id) scene;
-(id) initWithSaved:(BOOL)loadIt;


-(BOOL) aboutToReadShape:(cpShape*)shape shapeId:(long)id;
-(void) syncShapesOnPlayer1;
-(void) syncShapesOnPlayer2;
-(void) save;
-(void) enemyKilled;
-(void) whitePoof: (CGPoint)position;
-(void) setupBombsPlayer2WithDelay;
-(void) stopAllActionsInParallaxNodePlayer1;
-(void) stopAllActionsInParallaxNodePlayer2;
-(void) delayShotTimeMethod;
-(void) sendPlayer2MarbleColor;
-(void) registerWithTouchDispatcher;
-(void) removePlayer1Bomb;
-(void) removePlayer2Bomb;
-(void) setupBombsPlayer1;
-(void) setupNextBombPlayer1;
-(void) setupBombsPlayer2;
-(void) setupNextBombPlayer2;
-(void) artificialIntelligenceLaunchMethod;
-(void) smokeyExplosionPlayer1;
-(void) smokeyExplosionPlayer2;
-(void) increaseSkillLevelBonus;
-(void) zoomIn;
-(void) zoomOut;
-(void) pauseGame;
-(void) sendPauseGame;
-(void) gertyVersusScreen;
-(void)setupStringsWithOtherPlayerId:(NSString *)playerID;
-(void) getReadyLabelVisible;
-(void) getReadyLabelNotVisible;
-(void) lightningStrikeFromSling1;
-(void) lightningStrikeFromSling2;
-(void) chargingRisingSmoke;
-(void) chargingRisingSmokePlayer2;
-(void) reduceValueOfBigSmokeCloudOpacity;
-(void) increaseValueOfBigSmokeCloudOpacity;
-(void) reduceBigSmokeCloudOpacity;
-(void) setMarblePlayer2IsReadyToSlingToNo;
-(void) setComputerWillLaunchWhenPlayerLaunchesToYes;
-(void) artificialIntelligenceLaunchMarbleMethod;
-(void) gertySinglePlayer;
-(void) playDestroyedBlockBonusSound1;
-(void) playDestroyedBlockBonusSound2;
-(void) bonusPointPopUp: (CGPoint) position;
-(void) loadGameSettings;
-(void) saveGameSettings;
-(void) startLevelWithCountDown;
-(void) player1IsTheWinnerScript;
-(void) player2IsTheWinnerScript;
-(void) dotPageIndicatorUpdate;
-(void) playMarbleRollingOnTable;
-(void) stopPlayingMarbleRollingOnTable;
-(void) makeVictoryOrLossScreenButtonsVisible;
-(void) singlePlayerVictoryScreenLevelUp;
-(void) gertyVersusScreenUpdateLightsForPlayer1;
-(void) gertyVersusScreenUpdateLightsForPlayer2;
-(void) sendBonusPointsPlayer1;
-(void) sendBonusPointsPlayer2;
-(void) increasePlayer2ExperiencePoints;
-(void) blowupGerty1AndRunPlayer2IsTheWinnerScript;
-(void) blowupGerty2AndRunPlayer1IsTheWinnerScript;
-(void) dropMarbleIfDoubleTapped: (CGPoint)touchLocation;
-(void) moveFingersAndCrossHairsToTargets;
-(void) backToMainMenu;
-(void) sendOtherPlayerHasLeftMatchFromVersusScreen;
-(void) gertyMainMenuUpdateLights;
-(void) updateLocksOverColorSwatchesAndMarbleList;
-(void) playCricketsBackgroundSounds;
-(void) isHeadsetPluggedIn;
-(void) timedOutMultiplayerMatch;
-(void) matchEnded;


@end

