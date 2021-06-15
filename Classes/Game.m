//
//  Serialize.m
//  Example For SpaceManager
//
//  Created by Rob Blackwood on 5/30/10.
//

#import "Game.h"
#import "Ninja.h"
#import "GrenadeGameAppDelegate.h"
#import "RootViewController.h"
#import "CDXAudioNode.h"
#import "CDXAudioNodeProjectileCharging.h"
#import "CDXAudioNodeProjectileCharging2.h"
#import "CDXAudioNodeSlingShot.h"
#import "CDXAudioNodeBlocks.h"
#import "InAppRageIAPHelper.h"
#import "Reachability.h"



#define SLING_POSITION			ccp(60 + 40,157)
#define SLING_BOMB_POSITION		ccpAdd(SLING_POSITION, ccp(0,9))
#define SLING_MAX_ANGLE			245
#define SLING_MIN_ANGLE			110
#define SLING_TOUCH_RADIUS		25
#define SLING_LAUNCH_RADIUS		25
#define SERIALIZED_FILE			@"GrenadeGameT1.xml"


#define SLING_POSITION_2			ccp(505 - 40,157)
#define SLING_BOMB_POSITION_2		ccpAdd(SLING_POSITION_2, ccp(0,9))
#define SLING_MAX_ANGLE_2               245
#define SLING_MIN_ANGLE_2               110
#define SLING_TOUCH_RADIUS_2            25
#define SLING_LAUNCH_RADIUS_2           25
#define YELLOW_BALL_SPEED_MULTIPLIER    1.4


#define CHARGING_COEFFICIENT_STEP_1     0.4
#define CHARGING_COEFFICIENT_STEP_2     0.8
#define CHARGING_COEFFICIENT_STEP_3     1.2
#define CHARGING_COEFFICIENT_STEP_4     1.6
#define CHARGING_COEFFICIENT_STEP_5     2.0

#define PLAYER_1_GIANT_SMOKE_CLOUD ccp(90, 135)
#define PLAYER_2_GIANT_SMOKE_CLOUD ccp(450, 135)


@interface Game (PrivateMethods)

//menu
- (void) restart:(id)sender;

//setup
- (void) setupShapes;
- (void) setupEnemies;
- (void) setupBackground;
- (void) setupBombsPlayer1;
- (void) setupBombsPlayer2;
- (void) setupBombsPlayer2WithDelay;
- (void) setupNextBombPlayer1;
- (void) setupNextBombPlayer2;
- (void) setupGertyPlayer1;
- (void) setupGertyPlayer2;
- (void) setupRestart;
- (void) convertNinjaToWorldCoordinates;

//creation
- (CCNode<cpCCNodeProtocol>*) createBlockAt:(cpVect)pt width:(int)w height:(int)h mass:(int)mass;
- (void) createTriPillarsAt:(cpVect)pos width:(int)w height:(int)h;
//- (void) createTeepeePillarsAt:(cpVect)pos width:(int)w height:(int)h;


//collisions
-(BOOL) handleNinjaCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
-(BOOL) handleGertyCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
-(BOOL) handleBombCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
-(BOOL) handleTriangleBlockCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space;
@end


BOOL chargingShot;
double chargedShotTimeStarted;
double chargedShotTimeEnded;
BOOL chargingShot2;
double chargedShotTimeTotal2;
double chargedShotTimeStarted2;
double chargedShotTimeEnded2;
float scaleCoefficient;
float rightPanningBound;
float leftPanningBound;
float topPanningBound;
float bottomPanningBound;
int projectileLaunchMultiplier;
int projectileLaunchMultiplier2;
CCLayerColor *zoombase;
CCLayerColor *gridLayer;
CCLayerColor *mainMenuLayer;
CCLayerColor *backgroundLayer;
CCLayerColor *hudLayer;
CCSprite *background;
CCSprite *sling1;
CCSprite *sling2;
CCSprite *sling1Player2;
CCSprite *sling2Player2;
CCSprite *curtains;
CCSprite *chairs;
CCSprite *table;
CCSprite *outside;
CCSprite *curtainsBlur;
CCSprite *chairsBlur;
CCSprite *outsideBlur;
CGPoint ZB_last_posn;
cpCCSprite *bomb;
cpCCSprite *bomb2;
Lightning *lightning;
Lightning *lightning2;
Lightning *tesla;
Lightning *tesla2;
Bomb *_curBomb;
Bomb2 *_curBombPlayer2;
float zoomScale;
CGPoint target_position;
BOOL touchingSlingShot;
BOOL holdingTouch;
CGPoint fieldHalfWayPoint;
CCSprite *restartSprite;
BOOL player1ProjectileHasBeenTouched;
BOOL player2ProjectileHasBeenTouched;
int bombsLeft;
Ninja *ninja;
BOOL topPanLimitReached;
BOOL bottomPanLimitReached;
BOOL rightPanLimitReached;
BOOL leftPanLimitReached;
int projectileImpulsePlayer1;
int projectileImpulsePlayer2;
cpBody *slingPinConstraintBody;
cpShape *slingPinConstraintShape;
cpConstraint *projectilePinJoint;
CFTimeInterval currentTimeDecimalValueOnly;
int currentTimeInteger;
BOOL player1HasTheToken = YES;
BOOL player2HasTheToken = NO;
CCSprite *groundLevel;
CFTimeInterval appAbsoluteStartTime;
CFTimeInterval appSessionStartTime;
CCLabelBMFont *timeLabel;
float currentLaunchTimePlayer1;
CGPoint player1BlockPoint;
cpShape* shape;
NSArray *shapes;
NSMutableArray *shapesArray;
NSMutableArray *shapesPositions;
NSMutableDictionary *shapeIDAndPositions;
NSMutableDictionary *shapesDictionary2;
NSMutableDictionary *shapesAngles;
NSMutableDictionary *shapesAnglesDictionaryFromPlayer2;
NSArray *allShapesTemporaryNSArray;
NSMutableArray *allShapesFromLocalDevice;
NSArray *shapesArrayPlayer2;
NSMutableArray *shapesArrayPlayer2ToSend;
NSMutableArray *shapesMutableArrayPlayer1;
NSMutableArray *shapesArrayFromPlayer2;
NSMutableArray *shapesArrayFromPlayer1;
NSMutableArray *shapesArrayInPlayer2;
NSMutableArray *shapesArrayInPlayer1;
CGPoint touchLocationMoved;
CGPoint prevLocationMoved;
CCParallaxNode *parallaxNode;
CGPoint touchLocationLightning;
CGPoint touchLocationLightning2;
BOOL player1LightningExists;
BOOL player2LightningExists;
BOOL fieldZoomedOut;
CCSprite *testball;
CDXAudioNode *audioNode;
CDXAudioNodeBlocks *audioBreakingSplintery;
CDXAudioNode *audioBlockTumbling;
CDXAudioNode *audioElectricuteProjectile;
CDXAudioNode *audioElectricuteProjectile2;
CDXAudioNodeSlingShot *audioStretchingSling;
CDXAudioNode *audioProjectileLaunch;
CDXAudioNode *audioIncomingProjectile1;
CDXAudioNode *audioIncomingProjectile2;
CDXAudioNodeProjectileCharging *audioChargingShot;
CDXAudioNodeProjectileCharging2 *audioChargingShot2;
int sourceIDNumber;
int projectileCollisionForce;
int player2BombSourceIDNumber;
int sling1SourceIDNumber;
BOOL stretchingSlingSoundReady = YES;
int sling2SourceIDNumber;
int sling2SourceIDNumber2;
int sling2SourceIDNumber3;
int sling2SourceIDNumber4;
BOOL stretchingSling2SoundReady = YES;
int sling1SourceIDNumber2;
int sling1SourceIDNumber3;
float guidePathDivisorPlayer1X;
float guidePathDivisorPlayer1Y;
float guidePathDivisorPlayer2X;
float guidePathDivisorPlayer2Y;
CGPoint collisionNormal;
CCSprite *redWarningArrow;
CCSprite *redWarningArrow2;
CCSprite *smokePlayer1;
CCSprite *smokePlayer2;
int smokePlayer1IDNumber;
int smokePlayer2IDNumber;
int gerty1IDNumber;
int gerty2IDNumber;
Gerty *gerty;
Gerty2 *gerty2;
CDXAudioNode *audioGerty1BeingDestroyed;
CDXAudioNode *audioGerty2BeingDestroyed;
CDXAudioNode *audioGertyFireworks;
CDXAudioNode *audioGerty2Fireworks;
CDXAudioNodeSlingShot *audioGertyHappy;
CDXAudioNodeSlingShot *audioGertySad;
CDXAudioNodeSlingShot *audioPensiveGerty;
CDXAudioNodeSlingShot *audioHappyGerty;
CCSprite *flamesForRedMarblePlayer1;
CCSprite *flamesForRedMarblePlayer2;
BOOL readyToReceiveBlocksPositionsFromPlayer1;
BOOL readyToReceiveBlockNumbersFromPlayer2;
BOOL timeAtBeginningOfTimeCycleSet = NO;
BOOL timeAtEndingOfTimeCycleSet = NO;
BOOL tokenHasAlreadyReachedPlayer2 = NO;
double timeAtBeginningOfTimeCycle;
double timeAtEndingOfTimeCycle;
int player1MarbleColor = 2;
int player2MarbleColor = 2;
id followPlayer1Marble;
id followPlayer2Marble;
CCSprite *bombExplosionPlayer1;
CCSprite *bombExplosionPlayer2;
BOOL readyForEnemyToFire;
BOOL readyForEnemyToBlock;
BOOL marblePlayer2IsReadyToSling;
int blockingChargeBonusPlayer1;
int blockingChargeBonusPlayer2;
BOOL isRetinaDisplay;
BOOL receivingChargingDataFromPlayer1;
BOOL receivingChargingDataFromPlayer2;
CGPoint touchLocation;
int blockPointXValueOfMarble1;
int blockPointXValueOfMarble2;
CCSprite *lightningBolt1;
CCSprite *lightningBolt2;
CCSprite *skillLevelUpLightningBolt1;
CCSprite *skillLevelUpLightningBolt2;
UIPanGestureRecognizer *panGestureRecognizer;
UIPinchGestureRecognizer *pinchGestureRecognizer;
UITapGestureRecognizer *doubleTap;
int skillLevelBonus;
float lineArcValue;
float lineArcValue2;
BOOL bombHasHitRectangleHenceNoBonus1;
BOOL bombHasHitRectangleHenceNoBonus2;
BOOL guideLineIsBlinking;
id guideLineBlinkingAction;
int currentLevel;
CCSprite *woodblock;
CCSprite *woodblock2;
CCSprite *woodblock3;
CCSprite *tamagachi;
CCSprite *tamagachiMainMenu;
CCSprite *pinkTamagachiMainMenu;
CCSprite *greenTamagachiMainMenu;
CCSprite *yellowTamagachiMainMenu;
CCSprite *orangeTamagachiMainMenu;
CCSprite *lightPurpleTamagachiMainMenu;
CCSprite *purpleTamagachiMainMenu;
CCSprite *blueTamagachiMainMenu;
CCSprite *whiteTamagachiMainMenu;
CCSprite *blackTamagachiMainMenu;
CCSprite *tamagachiShadow;
CCSprite *happyGerty;
CCSprite *sadGerty;
CCSprite *tamagachi2;
CCSprite *happyGerty2;
CCSprite *sadGerty2;
CCSprite *pensiveGerty;
CCLabelBMFont *player1Label;
CCLabelBMFont *player2Label;
BOOL waitingForStartup;
BOOL isGo;
CCSprite *threeLabel;
CCSprite *twoLabel;
CCSprite *oneLabel;
CCLabelBMFont *goLabel;
CCSprite *gCharacterInGoLabel;
CCSprite *oCharacterInGoLabel;
CCSprite *exclamationCharacterInGoLabel;
BOOL player1ProjectileIsZappable;
BOOL player2ProjectileIsZappable;
CCLabelTTF *getReadyLabel;
CCLabelTTF *winnerLabel;
CCLabelTTF *lostLabel;
Lightning *lightningFromSling1;
Lightning *lightningFromSling2;
CCSprite *gerty1BreakingSmoke;
CCSprite *gerty2BreakingSmoke;
CCSprite *player1GiantSmokeCloudFront;
CCSprite *player1GiantSmokeCloudBack;
CCSprite *player2GiantSmokeCloudFront;
CCSprite *player2GiantSmokeCloudBack;
id player1ChargingSmoke;
id player2ChargingSmoke;
BOOL player1SlingIsSmoking;
BOOL player2SlingIsSmoking;
int player1GiantSmokeCloudFrontOpacity;
int player1GiantSmokeCloudBackOpacity;
int player2GiantSmokeCloudFrontOpacity;
int player2GiantSmokeCloudBackOpacity;
BOOL player1GiantSmokeCloudFrontOpacityIsIncreasing;
BOOL player2GiantSmokeCloudFrontOpacityIsIncreasing;
id bigCloudExpand;
id increaseBigSmokeCloudOpacityAction;
id reduceBigSmokeCloudOpacityAction;
id increasePlayer2BigSmokeCloudOpacityAction;
id reducePlayer2BigSmokeCloudOpacityAction;
CCLabelBMFont *player1InGameLabel;
CCLabelBMFont *player2InGameLabel;
CCSprite *uncertainGerty;
CCSprite *cryingGerty;
CCSprite *uncertainGerty2;
CCSprite *cryingGerty2;
CCSprite *sling1Stem;
CCSprite *sling2Stem;
NSMutableArray *player1ShapeHashID;
CGPoint randomTarget;
int targetHashIDNumberInt;
BOOL computerWillBlockMarble;
BOOL computerWillBlockMarbleHighShot;
BOOL computerWillBlockMarbleForHighShot;
BOOL calculatingChanceOfComputerBlockForHighShot;
int chanceOfComputerBlock;
int chanceOfComputerBlockForHighShot;
BOOL computerWillLaunchWhenPlayerLaunches;
double angle1, angle2;
int fireHighOrLow;
cpVect direction;
float velocity;
int computerChargeTime;
id setNewVelocityAndMoveBomb2Action;
float computerLaunchVelocity;
float computerLaunchVelocityCoefficient;
BOOL computerSettingNewVelocityandMovingBomb;
int computerNumberOfChargingRounds;
int marble1RotationalVelocity;
int marble2RotationalVelocity;
int player1ExperiencePointsToAdd;
id increasePlayer1ExperiencePointsAction;
CCLabelBMFont *player1PointsLabel;
CCLabelBMFont *player2PointsLabel;
CCLabelBMFont *player1PointsLabelMultiplayer;
CCLabelBMFont *player2PointsLabelMultiplayer;
CCLabelBMFont *player1PointsLabelZero;
CCLabelBMFont *player2PointsLabelZero;
CCLabelBMFont *player1PointsLabelZeroMultiplayer;
CCLabelBMFont *player2PointsLabelZeroMultiplayer;
int player2ExperiencePointsToAdd;
id increasePlayer2ExperiencePointsAction;
int player2ExperiencePointsForLabel;
int player2LevelForLabel;
int player2MarblesUnlockedForLabel;
BOOL startingSequenceBegan;
SimpleAudioEngine *birdsBackgroundSounds;
CDSoundEngine *windChimesBackgroundSounds;
int chanceOfWindChimesSounds;
BOOL windChimesSoundsReadyToPlay;
int chanceOfKidsPlayingSounds;
CDSoundEngine *kidsPlayingBackgroundSounds;
BOOL kidsPlayingSoundsReadyToPlay;
CDXAudioNode *passingCarBackgroundSounds;
int chanceOfPassingCarSounds;
BOOL passingCarSoundsReadyToPlay;
int chanceOfDogBarkingSounds;
BOOL dogBarkingSoundsReadyToPlay;
CDXAudioNode *dogBarking1BackgroundSounds;
CDXAudioNode *dogBarking2BackgroundSounds;
CDXAudioNode *dogBarking3BackgroundSounds;
int chanceOfLightAircraftPassingBySounds;
BOOL lightAircraftPassingBySoundsReadyToPlay;
CDXAudioNode *lightAircraftPassingByBackgroundSounds;
NSArray *defs;
int sling1SourceIDNumber4;
int sling1SourceIDNumber5;
int sling1SourceIDNumber6;
int sling1SourceIDNumber7;
int sling1SourceIDNumber8;
int sling1SourceIDNumber9;
int sling1SourceIDNumber10;
int sling1SourceIDNumber11;
int sling1SourceIDNumber12;
int sling1SourceIDNumber13;
int sling1SourceIDNumber14;
int sling1SourceIDNumber15;
int sling1SourceIDNumber16;
int sling1SourceIDNumber17;
int sling1SourceIDNumber18;
int sling1SourceIDNumber19;
int sling1SourceIDNumber20;
int sling1SourceIDNumber21;
int sling1SourceIDNumber22;
int sling1SourceIDNumber23;
int sling1SourceIDNumber24;
int sling1SourceIDNumber25;
int sling1SourceIDNumber26;
int sling1SourceIDNumber27;
int sling1SourceIDNumber28;
int sling1SourceIDNumber29;
int sling1SourceIDNumber30;
CDXAudioNode *audioPreLaunchCharge;
CDXAudioNode *audioPreLaunchCharge2;
NSMutableArray *loadRequests;
CDXAudioNode *audioBombExplosionPlayer1;
CDXAudioNode *audioBombExplosionPlayer2;
CCSprite *couch;
CCSprite *couchBlurry;
CCSprite *orchid;
CCSprite *orchidBlurry;
CCSprite *faucet;
CCSprite *faucetBlurry;
CCSprite *wallAndCouch;
CCSprite *wallAndCouchBlurry;
CCSprite *kitchenOutside;
CCSprite *kitchenOutsideBlurry;
CCSprite *tvRoomTable;
CCSprite *tvRoomCouch;
CCSprite *tvRoomOutside;
CCSprite *tvRoomTableBlurry;
CCSprite *tvRoomCouchBlurry;
CCSprite *tvRoomOutsideBlurry;
CCSprite *fridgeBackground;
CCSprite *fridgeBackgroundBlurry;
CCSprite *sideBanister;
CCSprite *sideBanisterBlurry;
CCSprite *wallAndDoor;
CCSprite *wallAndDoorBlurry;
CCSprite *outsideBalcony;
CCSprite *outsideBalconyBlurry;
BOOL gamePaused;
CCSprite *backToMainMenu;
CCSprite *backToMainMenu2;
CCSprite *continuePlayingGame;
CCSprite *restartLevel;
CCSprite *pauseButton;
CCSprite *gertyGrid1;
CCSprite *gertyGrid2;
CCSprite *gertyGrid3;
CCSprite *gertyGrid4;
CCSprite *gertyGrid5;
CCSprite *gertyGrid6;
CCSprite *gertyGrid7;
CCSprite *gertyGrid8;
CCSprite *gertyGrid9;
CCSprite *gertyGrid10;
CCSprite *gertyGrid11;
CCSprite *gertyGrid12;
CCSprite *gertyGrid13;
CCSprite *gertyGrid14;
CCSprite *gertyGrid15;
CCSprite *gertyGrid16;
CCSprite *gertyGrid17;
CCSprite *gertyGrid18;
CCSprite *gertyGrid19;
CCSprite *gertyGrid20;
CCSprite *gertyGrid21;
CCSprite *gertyGrid22;
CCSprite *gertyGrid23;
CCSprite *gertyGrid24;
CCSprite *gertyGrid25;
CCSprite *gertyGrid26;
CCSprite *gertyGrid27;
int gridLayerPosition;
float increaseBigSmokeTimeInterval1;
float increaseBigSmokeTimeInterval2;
BOOL gertyGrid1VisibleBool;
BOOL gertyGrid2VisibleBool;
BOOL gertyGrid3VisibleBool;
BOOL gertyGrid4VisibleBool;
BOOL gertyGrid5VisibleBool;
BOOL gertyGrid6VisibleBool;
BOOL gertyGrid7VisibleBool;
BOOL gertyGrid8VisibleBool;
BOOL gertyGrid9VisibleBool;
BOOL gertyGrid10VisibleBool;
BOOL gertyGrid11VisibleBool;
BOOL gertyGrid12VisibleBool;
BOOL gertyGrid13VisibleBool;
BOOL gertyGrid14VisibleBool;
BOOL gertyGrid15VisibleBool;
BOOL gertyGrid16VisibleBool;
BOOL gertyGrid17VisibleBool;
BOOL gertyGrid18VisibleBool;
BOOL gertyGrid19VisibleBool;
BOOL gertyGrid20VisibleBool;
BOOL gertyGrid21VisibleBool;
BOOL gertyGrid22VisibleBool;
BOOL gertyGrid23VisibleBool;
BOOL gertyGrid24VisibleBool;
BOOL gertyGrid25VisibleBool;
BOOL gertyGrid26VisibleBool;
BOOL gertyGrid27VisibleBool;
CCSprite *gertyGrid1Lock;
CCSprite *gertyGrid2Lock;
CCSprite *gertyGrid3Lock;
CCSprite *gertyGrid4Lock;
CCSprite *gertyGrid5Lock;
CCSprite *gertyGrid6Lock;
CCSprite *gertyGrid7Lock;
CCSprite *gertyGrid8Lock;
CCSprite *gertyGrid9Lock;
CCSprite *gertyGrid10Lock;
CCSprite *gertyGrid11Lock;
CCSprite *gertyGrid12Lock;
CCSprite *gertyGrid13Lock;
CCSprite *gertyGrid14Lock;
CCSprite *gertyGrid15Lock;
CCSprite *gertyGrid16Lock;
CCSprite *gertyGrid17Lock;
CCSprite *gertyGrid18Lock;
CCSprite *gertyGrid19Lock;
CCSprite *gertyGrid20Lock;
CCSprite *gertyGrid21Lock;
CCSprite *gertyGrid22Lock;
CCSprite *gertyGrid23Lock;
CCSprite *gertyGrid24Lock;
CCSprite *gertyGrid25Lock;
CCSprite *gertyGrid26Lock;
CCSprite *gertyGrid27Lock;
BOOL player1IsTheWinnerScriptHasBeenPlayed;
BOOL player2IsTheWinnerScriptHasBeenPlayed;
BOOL player1ProjectileCanBeTouchedAgain;
BOOL player2ProjectileCanBeTouchedAgain;
CGPoint touchLocationHudLayer;
CCSprite *dotPageIndicator1;
CCSprite *dotPageIndicator2;
CCSprite *dotPageIndicator3;
int sourceIDNumber2;
int gertyGrid2BatteryLife;
CDXAudioNode *audioMarbleHittingTable;
CDXAudioNode *audioMarble2HittingTable;
int player2BombSourceIDNumber2;
CCLabelBMFont *player1LevelLabel;
CCLabelBMFont *player1ExperiencePointsLabel;
CCLabelBMFont *player2LevelLabel;
CCLabelBMFont *player2ExperiencePointsLabel;
CCLabelBMFont *computerLevelLabel;
int player2Level;
int player2ExperiencePoints;
int zoombaseHorizontalPosition1;
int zoombaseHorizontalPosition2;
CCLabelBMFont *computerLabel;
CCSprite *crosshairs1;
CCSprite *crosshairs2;
CCSprite *pointingFinger1;
CCSprite *pointingFinger2;
BOOL doNotShowMarblePointFinger1;
BOOL doNotShowMarblePointFinger2;
BOOL continuePlayingFromLossScreen;
int pillarConfiguration;
CCSprite *playButton;
CCSprite *carpet;
CCSprite *stickFigureBoy;
CCSprite *stickFigureGirl;
CCSprite *stickGlobeWithArrows;
CCSprite *drawnLock;
BOOL isAtMainMenu;
GKVoiceChat *teamChannel;
CCLabelBMFont *youLabel;
BOOL lightningStrikePlayer1Ready;
BOOL lightningStrikePlayer2Ready;
CCParticleFireworks *blockExplosion;
CCSprite *microphoneOn;
CCSprite *microphoneOff;
CCSprite *tamagachiMultiplayer;
CCSprite *tamagachi2Multiplayer;
CCLabelBMFont *opponentDisconnectedLabel;
CCLabelBMFont *loadingStore;
Reachability *reach;
NetworkStatus netStatus;
CCSprite *speechBubble;
CCSprite *speechBubbleColorSwatches;
CCSprite *buyButton1;
CCSprite *buyButton2;
CCSprite *buyButton3;
CCSprite *pinkColorSwatch;
CCSprite *redColorSwatch;
CCSprite *greenColorSwatch;
CCSprite *yellowColorSwatch;
CCSprite *orangeColorSwatch;
CCSprite *lightPurpleColorSwatch;
CCSprite *purpleColorSwatch;
CCSprite *blueColorSwatch;
CCSprite *whiteColorSwatch;
CCSprite *blackColorSwatch;
CCLabelBMFont *inAppPurchase1;
SKProduct *product;
CCLabelBMFont *buyButton1Label;
GKPlayer *player;
GKPlayer *player2;
BOOL otherPlayerWishesToPlayAgain;
double sentPingTime;
double receivedPingTime;
double pingTime;
double prelaunchDelayTime;
CCSprite *happyGertyTamagachiMultiplayer;
CCSprite *sadGertyTamagachiMultiplayer;
CCSprite *uncertainGertyTamagachiMultiplayer;
CCSprite *cryingGertyTamagachiMultiplayer;
CCSprite *pensiveGertyTamagachiMultiplayer;
CCSprite *happyGerty2TamagachiMultiplayer;
CCSprite *sadGerty2TamagachiMultiplayer;
CCSprite *uncertainGerty2TamagachiMultiplayer;
CCSprite *cryingGerty2TamagachiMultiplayer;
CCSprite *pensiveGerty2TamagachiMultiplayer;
CCSprite *blackLock1;
CCSprite *blackLock2;
CCSprite *blackLock3;
CCSprite *blackLock4;
CCSprite *blackLock5;
CCSprite *blackLock6;
CCSprite *blackLock7;
CCSprite *blackLock8;
CCSprite *blackLock9;
CCSprite *whiteLock1;
CCSprite *blackLockSpeechBubbleMarbleList1;
CCSprite *blackLockSpeechBubbleMarbleList2;
CCSprite *blackLockSpeechBubbleMarbleList3;
CCSprite *blackLockSpeechBubbleMarbleList4;
CCSprite *whiteLockSpeechBubbleMarbleList1;
CCSprite *speechBubbleMarbleList;
CCSprite *blueMarbleForSpeechBubble;
CCSprite *redMarbleForSpeechBubble;
CCSprite *yellowMarbleForSpeechBubble;
CCSprite *blackMarbleForSpeechBubble;
BOOL speechBubbleWillShow;
BOOL opponentDisconnected;
BOOL pingAnswered;
CCSprite *teslaGlow1;
CCSprite *teslaGlow2;
BOOL teslaGlowMessageSent;
CCSprite *pointingFingerForGertyMainMenuLightBulbs;
CCSprite *pointingFingerForGertyMainMenuTamagachi;
BOOL showPointingFingerForGertyMainMenuLightBulbs;
BOOL showPointingFingerForGertyMainMenuTamagachi;
SimpleAudioEngine *mainMenuMusic;
id timeOutTime;
NSString *player1InGameLabelStringForPlayer1;
NSString *player2InGameLabelStringForPlayer1;
NSString *player1InGameLabelStringForPlayer2;
NSString *player2InGameLabelStringForPlayer2;
id player1SlotMachineAnimation;
id player2SlotMachineAnimation;
ALuint audioSlotMachineSpinning;
ALuint audioSlotMachineSpinningPlayer2;
ALuint audioCricketsBackground;
CCSprite *indexCard;
CCSprite *indexCard2;
CCSprite *howToPlayFrame1;
CCSprite *howToPlayFrame2;
CCSprite *howToPlayFrame3;
CCSprite *howToPlayFrame4;
CCSprite *howToPlayFrame5;
CCSprite *howToPlayFrame6;
CCSprite *howToPlayFrame7;
CCSprite *howToPlayFrame8;
CCSprite *howToPlayFrame9;
CCSprite *howToDefendFrame1;
CCSprite *howToDefendFrame2;
CCSprite *howToDefendFrame3;
CCSprite *howToDefendFrame4;
CCSprite *speechBubbleStageSelect;
CCLabelBMFont *selectStage;
BOOL playbuttonPushed;
id howToPlayAnimation;
id howToDefendAnimation;
int indexCardTouchCount;
CCSprite *checkMark1;
CCSprite *checkMark2;
BOOL indexCard1ReadyToTouch;
BOOL indexCard2ReadyToTouch;
CCSprite *attackLabel;
CCSprite *defendLabel;
BOOL inGameTutorialHasAlreadyBeenPlayedOnce;
CCSpriteBatchNode *gameSpriteSheet;
CCSprite *dayTimeStageButton;
CCSprite *nightTimeStageButton;
CCSprite *randomStageSelectButton;
BOOL randomStageSelect;
BOOL playerCanZoomInAgain;
BOOL playerCanZoomOutAgain;
CCSprite *whiteTabStickerForSpeechBubbleStageSelect;
CCSprite *whiteTabStickerForSpeechBubbleColorSwatches;
CCSprite *whiteTabStickerForSpeechBubbleMarbleList;
BOOL speechBubbleColorSwatchIsTopLayer;
BOOL speechBubbleStageSelectIsTopLayer;
BOOL speechBubbleMarbleListIsTopLayer;
CCLabelBMFont *z200Label;
CCLabelBMFont *z500Label;
CCLabelBMFont *z1000Label;
CCLabelBMFont *z2000Label;
CCLabelBMFont *z200LabelForMarble;
CCLabelBMFont *z300LabelForMarble;
CCLabelBMFont *z400LabelForMarble;
CCLabelBMFont *z500LabelForMarble;
CCLabelBMFont *youLabelInGame;
CCLabelBMFont *enemyLabelInGame;
CCSprite *checkMarkSpeechBubbleStageSelect;
BOOL player1ReadyToStartInGameCountdown;
BOOL player2ReadyToStartInGameCountdown;
BOOL headsetIsPluggedIn;
UIDeviceHardware *h;
BOOL playerHasIPodTouch;
int computerZapLimit;
int tamagachiColorReceivedFromPlayer1;
int tamagachiColorReceivedFromPlayer2;
CCSprite *dot;
BOOL inGameCountdownStarted;
CCSprite *whiteProgressDot1;
CCSprite *whiteProgressDot2;
CCSprite *whiteProgressDot3;
CCSprite *whiteProgressDot4;
CCSprite *whiteProgressDot5;
BOOL checkMarkSpeechBubbleStageSelectIsOnRandomButton;
CCSprite *firstPlayerHandicapCheckMarkButton;
CCSprite *secondPlayerHandicapCheckMarkButton;
BOOL firstPlayerHandicapCheckMarkButtonTouched;
BOOL secondPlayerHandicapCheckMarkButtonTouched;
float handicapCoefficientPlayer1;
float handicapCoefficientPlayer2;
CCSprite *firstPlayerHandicapLeftBorder;
CCSprite *firstPlayerHandicapRightBorder;
CCSprite *firstPlayerHandicapGuideLine;
CCSprite *firstPlayerHandicapFirstLine;
CCSprite *firstPlayerHandicapSecondLine;
CCSprite *handicapLabel;
CCSprite *secondPlayerHandicapLeftBorder;
CCSprite *secondPlayerHandicapRightBorder;
CCSprite *secondPlayerHandicapGuideLine;
CCSprite *secondPlayerHandicapFirstLine;
CCSprite *secondPlayerHandicapSecondLine;
CCSprite *secondPlayerHandicapNumberZero;
CCSprite *secondPlayerHandicapNumberOne;
CCSprite *secondPlayerHandicapNumberTwo;
CCSprite *secondPlayerHandicapNumberThree;
CCSprite *secondPlayerHandicapNumberFour;
CCSprite *handicapLabel2;
int player1HandicapInteger;
int player2HandicapInteger;
int curBombPlayer2BlockingRadius;
int curBombBlockingRadius;
BOOL deviceIsRunningiOS6;
int handicapLinesSpacing;




static const float MIN_SCALE = 1.0;
static const float MAX_SCALE = 2.0;

static void
eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	CCSprite *sprite = shape->data;
	if( sprite ) {
		cpBody *body = shape->body;
		
		// TIP: cocos2d and chipmunk uses the same struct to store it's position
		// chipmunk uses: cpVect, and cocos2d uses CGPoint but in reality the are the same
		// since v0.7.1 you can mix them if you want.
        
		[sprite setPosition: body->p];
		
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
	}
}

@implementation Game


@synthesize spaceManager = smgr;
@synthesize hud = _hud;


+(id) scene
{
	CCScene *scene = [CCScene node];
	[scene addChild:[Game node] z:0 tag:GAME_TAG];
	return scene;
}

- (id) init
{
	return [self initWithSaved:NO];
}

- (void)setGameState:(GameState)state {
    
    gameState = state;
    if (gameState == kGameStateWaitingForMatch) {
        [debugLabel setString:@"Waiting for match"];
        NSLog (@"Waiting for match");
    } else if (gameState == kGameStateWaitingForRandomNumber) {
        [debugLabel setString:@"Waiting for rand #"];
        NSLog (@"Waiting for rand #");
    } else if (gameState == kGameStateWaitingForStart) {
        [debugLabel setString:@"Waiting for start"];
        NSLog (@"Waiting for start");
    } else if (gameState == kGameStateActive) {
        [debugLabel setString:@"Active"];
        NSLog (@"Active");
    } else if (gameState == kGameStateDone) {
        [debugLabel setString:@"Done"];
        NSLog (@"Done");
    }
}


// Add these new methods to the top of the file
- (void)sendData:(NSData *)data {
    NSError *error;
    BOOL success = [[GCHelper sharedInstance].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    //NSLog (@"sendData called!");
    if (!success) {
        //    CCLOG(@"Error sending init packet");
        //    NSLog(@"Error sending init packet");
        [self matchEnded];
    }
}

- (void)sendDataUnreliable:(NSData *)data {
    NSError *error;
    BOOL success = [[GCHelper sharedInstance].match sendDataToAllPlayers:data withDataMode:GKMatchSendDataUnreliable error:&error];
    //NSLog (@"sendData called!");
    if (!success) {
        //    CCLOG(@"Error sending init packet");
        //    NSLog(@"Error sending init packet");
        [self matchEnded];
    }
}

-(void) sendBlocksPositionsFromPlayer1 {
    
    int x = 0;
    
    NSArray *shapesArrayPlayer2Temp = [smgr getShapesAt:ccp(240, 160) radius:1000];
    
    for (NSValue *v in shapesArrayPlayer2Temp) {
        
        cpShape *shape = [v pointerValue];
        
        if (shape->collision_type == 3) {
            
            x = x + 1;
        }
    }
    
    MessageBlockInfo *oinf_arr = calloc(x, sizeof(MessageBlockInfo));
    
    oinf_arr->total_number_of_blocks = x;
    
    NSArray *shapesArrayPlayer2Temp2 = [smgr getShapesAt:ccp(240, 160) radius:1000];
    
    int i = 0;
    
    for (NSValue *v in shapesArrayPlayer2Temp2) {
        
        cpShape *shape2 = [v pointerValue];
        
        if (shape2->collision_type == 3) {
            
            oinf_arr[i].block_id = shape2->hashid;
            oinf_arr[i].block_position = shape2->body->p;
            oinf_arr[i].block_angle = shape2->body->a;
            //oinf_arr[i].block_velocity = shape2->body->v;
            i = i + 1;
        }
    }
    
    oinf_arr->message.messageType = kMessageTypeBlockInfo;
    NSData *data = [NSData dataWithBytes: oinf_arr length: oinf_arr->total_number_of_blocks*sizeof(MessageBlockInfo)];
    [self sendDataUnreliable: data];
    NSLog (@"Player1 sending MessageBlock Info with size of %i bytes", [data length]);
    
    /*
     for(int i=0; i < x; i++) {
     
     NSLog(@"Block Number = %i, at position (%f, %f)", oinf_arr[i].block_id, oinf_arr[i].block_position.x, oinf_arr[i].block_position.y);
     }
     */
}

-(void) sendBlockNumbersFromPlayer2 {
    
    int x = 0;
    
    NSArray *shapesArrayPlayer2Temp = [smgr getShapesAt:ccp(240, 160) radius:1000];
    
    for (NSValue *v in shapesArrayPlayer2Temp) {
        
        cpShape *shape = [v pointerValue];
        
        if (shape->collision_type == 3) {
            
            x = x + 1;
        }
    }
    
    MessageBlockNumberFromPlayer2 *oinf_arr_player2 = calloc(x, sizeof(MessageBlockNumberFromPlayer2));
    
    oinf_arr_player2->total_number_of_blocks = x;
    
    NSArray *shapesArrayPlayer2Temp2 = [smgr getShapesAt:ccp(240, 160) radius:1000];
    
    int i = 0;
    
    for (NSValue *v in shapesArrayPlayer2Temp2) {
        
        cpShape *shape2 = [v pointerValue];
        
        if (shape2->collision_type == 3) {
            
            oinf_arr_player2[i].block_id = shape2->hashid;
            i = i + 1;
        }
    }
    
    oinf_arr_player2->message.messageType = kMessageTypeBlockNumbersFromPlayer2;
    NSData *data = [NSData dataWithBytes: oinf_arr_player2 length: oinf_arr_player2->total_number_of_blocks*sizeof(MessageBlockNumberFromPlayer2)];
    
    NSLog (@"Player2 sending MessageBlock Info with size of %i bytes", [data length]);
    
    [self sendDataUnreliable: data];
}

- (void)sendPlayerReadyToStartInGameCountdown
{
    MessagePlayerReadyToStartInGameCountdown message;
    message.message.messageType = kMessagePlayerReadyToStartInGameCountdown;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessagePlayerReadyToStartInGameCountdown)];
    [self sendData:data];
}

- (void)sendPlayer1GertyShouldBeDead {
    
    MessagePlayer1GertyShouldBeDead message;
    message.message.messageType = kMessageTypePlayer1GertyShouldBeDead;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessagePlayer1GertyShouldBeDead)];
    [self sendData:data];
}

- (void)sendPlayer2GertyShouldBeDead {
    
    MessagePlayer2GertyShouldBeDead message;
    message.message.messageType = kMessageTypePlayer2GertyShouldBeDead;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessagePlayer2GertyShouldBeDead)];
    [self sendData:data];
}

- (void)sendRequestBlockInfoFromPlayer1 {
    
    MessageRequestBlockInfoFromPlayer1 message;
    message.message.messageType = kMessageTypeRequestBlockInfoFromPlayer1;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRequestBlockInfoFromPlayer1)];
    [self sendData:data];
}

- (void)sendRequestBlockInfoFromPlayer2 {
    
    MessageRequestBlockInfoFromPlayer2 message;
    message.message.messageType = kMessageTypeRequestBlockInfoFromPlayer2;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRequestBlockInfoFromPlayer2)];
    [self sendData:data];
}

- (void)sendUnlockedMarblesValue1 {
    
    MessageUnlockedMarbles1 message;
    message.message.messageType = kMessageTypeUnlockedMarbles1;
    message.unlockedMarbles1 = player1MarblesUnlockedMultiplayerValue;
    message.player1LevelStruct = player1LevelMultiplayerValue;
    message.player1ExperiencePointsStruct = player1ExperiencePointsMultiplayerValue;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageUnlockedMarbles1)];
    [self sendData:data];
}

- (void)sendUnlockedMarblesValue2 {
    
    MessageUnlockedMarbles2 message;
    message.message.messageType = kMessageTypeUnlockedMarbles2;
    message.unlockedMarbles2 = player2MarblesUnlockedMultiplayerValue;
    message.player2LevelStruct = player2LevelMultiplayerValue;
    message.player2ExperiencePointsStruct = player2ExperiencePointsMultiplayerValue;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageUnlockedMarbles2)];
    [self sendData:data];
}

- (void)sendBonusPointsPlayer1 {
    
    MessageBonusPointsPlayer1 message;
    message.message.messageType = kMessageTypeBonusPointsPlayer1;
    message.bonusPoints1Struct = bonusPoints1;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageBonusPointsPlayer1)];
    [self sendData:data];
}

- (void)sendBonusPointsPlayer2 {
    
    MessageBonusPointsPlayer2 message;
    message.message.messageType = kMessageTypeBonusPointsPlayer2;
    message.bonusPoints2Struct = bonusPoints2;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageBonusPointsPlayer2)];
    [self sendData:data];
}

- (void)sendPlayer1MarbleColor {
    
    MessagePlayer1MarbleColor message;
    message.message.messageType = kMessageTypePlayer1MarbleColor;
    message.marbleColor1 = player1MarbleColor;
    message.doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessagePlayer1MarbleColor)];
    [self sendData:data];
}

- (void)sendPlayer2MarbleColor {
    
    MessagePlayer2MarbleColor message;
    message.message.messageType = kMessageTypePlayer2MarbleColor;
    message.marbleColor2 = player2MarbleColor;
    message.doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessagePlayer2MarbleColor)];
    [self sendData:data];
}

-(void)sendPrelaunchTimeDelay
{
    MessageSendPrelaunchTimeDelay message;
    message.message.messageType = kMessageTypePrelaunchTimeDelay;
    message.prelaunchTimeDelayStruct = prelaunchDelayTime;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageSendPrelaunchTimeDelay)];
    [self sendData:data];
}

-(void)sendOpposingPlayersTamagachiColor
{
    MessageSendOpposingPlayersTamagachiColor message;
    message.message.messageType = kMessageTypeOpposingPlayersTamagachiColor;
    message.opposingPlayersTamagachiColor = tamagachi1Color;
    message.pillarConfigurationStruct = pillarConfiguration;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageSendOpposingPlayersTamagachiColor)];
    [self sendData:data];
}

-(void)sendPauseGame {
    
    MessagePauseGame message;
    message.message.messageType = kMessageTypePauseGame;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessagePauseGame)];
    [self sendData:data];
}

- (void)sendRandomNumber {
    
    MessageRandomNumber message;
    message.message.messageType = kMessageTypeRandomNumber;
    message.randomNumber = ourRandom;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageRandomNumber)];
    [self sendData:data];
}

-(void) sendPlayer1HandicapInteger {
    
    MessagePlayer1HandicapInteger message;
    message.message.messageType = kMessageTypePlayer1HandicapInteger;
    message.player1HandicapIntegerStruct = player1HandicapInteger;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessagePlayer1HandicapInteger)];
    [self sendData:data];
}

-(void) sendPlayer2HandicapInteger {
    
    MessagePlayer2HandicapInteger message;
    message.message.messageType = kMessageTypePlayer2HandicapInteger;
    message.player2HandicapIntegerStruct = player2HandicapInteger;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessagePlayer2HandicapInteger)];
    [self sendData:data];
}

-(void) sendAudioIncomingProjectile {
    
    MessageAudioIncomingProjectile message;
    message.message.messageType = kMessageTypeAudioIncomingProjectile;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageAudioIncomingProjectile)];
    [self sendData: data];
}

-(void) sendAudioChargingShot {
    
    MessageAudioChargingShot message;
    message.message.messageType = kMessageTypeAudioChargingShot;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageAudioChargingShot)];
    [self sendData: data];
}

-(void) sendAudioProjectileLaunch {
    
    MessageAudioProjectileLaunch message;
    message.message.messageType = kMessageTypeAudioProjectileLaunch;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageAudioProjectileLaunch)];
    [self sendData: data];
}

-(void) sendAudioStretchingSling {
    
    MessageStretchingSling message;
    message.message.messageType = kMessageTypeStretchingSling;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageStretchingSling)];
    [self sendData: data];
}

-(void) sendProjectileBlocked {
    
    MessageProjectileBlocked message;
    message.message.messageType = kMessageTypeProjectileBlocked;
    message.blockPointXValueOfMarble1 = blockPointXValueOfMarble1;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageProjectileBlocked)];
    [self sendData: data];
}

-(void) sendProjectileBlocked2 {
    
    MessageProjectileBlocked2 message;
    message.message.messageType = kMessageTypeProjectileBlocked2;
    message.blockPointXValueOfMarble2 = blockPointXValueOfMarble2;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageProjectileBlocked2)];
    [self sendData: data];
    
}

// Add right after sendRandomNumber
- (void)sendGameBegin {
    
    MessageGameBegin message;
    message.message.messageType = kMessageTypeGameBegin;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameBegin)];
    [self sendData:data];
}

- (void)sendPlayAgain {
    
    MessagePlayAgain message;
    message.message.messageType = kMessageTypePlayAgain;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessagePlayAgain)];
    [self sendData:data];
}

-(void)sendOtherPlayerHasLeftMatchFromVersusScreen {
    
    MessagePlayAgain message;
    message.message.messageType = kMessageTypeOtherPlayerHasLeftMatchFromVersusScreen;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageOtherPlayHasLeftMatchFromVersusScreen)];
    [self sendData:data];
}

-(void)sendTeslaGlow {
    
    MessageTeslaGlow message;
    message.message.messageType = kMessageTypeTeslaGlow;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageTeslaGlow)];
    [self sendData:data];
}

-(void)sendTeslaGlowOff {
    
    MessageTeslaGlow message;
    message.message.messageType = kMessageTypeTeslaGlowOff;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageTeslaGlowOff)];
    [self sendData:data];
}

- (void)sendIncreaseSkillLevelBonus {
    
    MessageIncreaseSkillLevelBonus message;
    message.message.messageType = kMessageTypeIncreaseSkillLevelBonus;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageIncreaseSkillLevelBonus)];
    [self sendData:data];
}

-(void) sendPlayer1BlockPoint {
    
    MessagePlayer1BlockPoint message;
    message.message.messageType = kMessageTypePlayer1BlockPoint;
    message.player1BlockPoint = player1BlockPoint;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessagePlayer1BlockPoint)];
    [self sendData:data];
}

-(void) sendShapesDictionary {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: shapeIDAndPositions];
    NSLog (@"ShapesDictionary Bytes Size = %i", [data length]);
    [self sendData:data];
}

-(void) sendShapesArray {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: shapesArrayPlayer2ToSend];
    //   NSLog (@"shapesArrayPlayer2ToSend Bytes Size = %i", [data length]);
    [self sendData:data];
}

-(void) sendShapesArray2 {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: shapesMutableArrayPlayer1];
    //  NSLog (@"shapesMutableArrayPlayer1 Bytes Size = %i", [data length]);
    [self sendData:data];
}

-(void) sendShapesAngles {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject: shapesAngles];
    //NSLog (@"shapesAngles Bytes Size = %i", [data length]);
    [self sendData:data];
}

- (void)sendMove {
    
    MessageMove message;
    message.message.messageType = kMessageTypeMove;
    message.point = _curBomb.position;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageMove)];
    [self sendDataUnreliable:data];
}

- (void)sendMove2 {
    
    MessageMove message;
    message.message.messageType = kMessageTypeMove2;
    message.point = _curBombPlayer2.position;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageMove)];
    [self sendDataUnreliable:data];
}

- (void) sendProjectileChargingPitchFromPlayer1 {
    
    MessageProjectileChargingPitch message;
    message.message.messageType = kMessageTypeProjectileChargingPitch1;
    message.chargedShotTimeStarted = chargedShotTimeStarted;
    message.blockingChargeBonusPlayer1 = blockingChargeBonusPlayer1;
    message.receivingChargingDataFromPlayer1 = receivingChargingDataFromPlayer1;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageProjectileChargingPitch)];
    [self sendData:data];
}

- (void) sendProjectileChargingPitchFromPlayer2 {
    
    MessageProjectileChargingPitch2 message;
    message.message.messageType = kMessageTypeProjectileChargingPitch2;
    message.chargedShotTimeStarted2 = chargedShotTimeStarted2;
    message.blockingChargeBonusPlayer2 = blockingChargeBonusPlayer2;
    message.receivingChargingDataFromPlayer2 = receivingChargingDataFromPlayer2;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageProjectileChargingPitch2)];
    [self sendData:data];
}

- (void)sendAppStartTime {
    
    MessageAppStartTime message;
    message.message.messageType = kMessageTypeAppStartTime;
    message.player1CFAbsoluteTimeGetCurrent = CFAbsoluteTimeGetCurrent();
    message.player1AppAbsoluteStartTime = appAbsoluteStartTime;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageAppStartTime)];
    [self sendData:data];
}

- (void) sendToken {
    
    MessageSendToken message;
    message.message.messageType = kMessageTypeSendToken;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageSendToken)];
    [self sendData:data];
}

- (void)sendLaunchProjectile {
    
    MessageLaunchProjectile message;
    message.message.messageType = kMessageTypeLaunchProjectile;
    message.launchPoint = player1Vector;
    message.marbleRotationalVelocity = marble1RotationalVelocity;
    message.projectileShotMultiplier = projectileLaunchMultiplier;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageLaunchProjectile)];
    [self sendData:data];
}

- (void)sendLaunchProjectile2 {
    
    MessageLaunchProjectile message;
    message.message.messageType = kMessageTypeLaunchProjectile2;
    message.launchPoint = player2Vector;
    message.marbleRotationalVelocity = marble2RotationalVelocity;
    message.projectileShotMultiplier2 = projectileLaunchMultiplier2;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageLaunchProjectile)];
    [self sendData:data];
}

- (void)sendGameOver:(BOOL)player1Won {
    
    MessageGameOver message;
    message.message.messageType = kMessageTypeGameOver;
    message.player1Won = player1Won;
    NSData *data = [NSData dataWithBytes:&message length:sizeof(MessageGameOver)];
    [self sendData:data];
}


-(void) addGroundLevel
{
    if (currentLevel == 1) {
        
        groundLevel = [CCSprite spriteWithSpriteFrameName: @"Layer 4 Table-hd.png"];
        groundLevel.position = ccp(0, 102);
        groundLevel.scaleX = 1.5;
        groundLevel.scaleY = 0.705;
        [zoombase addChild: groundLevel z:25];
    }
    /*
     else if (currentLevel == 2) {
     
     groundLevel = [CCSprite spriteWithFile: @"Layer 1 - Table.png"];
     groundLevel.position = ccp(0, 0);
     groundLevel.scaleX = 1.8*2;
     groundLevel.scaleY = 0.80*2;
     [zoombase addChild: groundLevel z:15];
     }
     
     else if (currentLevel == 3) {
     
     groundLevel = [CCSprite spriteWithFile: @"Layer 1 - Granite.png"];
     groundLevel.position = ccp(295, 0);
     groundLevel.scaleX = 0.9;
     groundLevel.scaleY = 0.26;
     [zoombase addChild: groundLevel z:15];
     }
     
     else if (currentLevel == 4) {
     
     groundLevel = [CCSprite spriteWithFile: @"Layer 1 - TV Room Table.png"];
     groundLevel.position = ccp(295, 0);
     groundLevel.scaleX = 0.9;
     groundLevel.scaleY = 0.26;
     [zoombase addChild: groundLevel z:15];
     }
     
     else if (currentLevel == 6) {
     
     groundLevel = [CCSprite spriteWithFile: @"Layer 1 - Granite.png"];
     groundLevel.position = ccp(295, 0);
     groundLevel.scaleX = 0.9;
     groundLevel.scaleY = 0.26;
     [zoombase addChild: groundLevel z:15];
     }
     
     else if (currentLevel == 7) {
     
     groundLevel = [CCSprite spriteWithFile: @"Layer 1 - Carpet.png"];
     groundLevel.position = ccp(295, 0);
     groundLevel.scaleX = 0.9;
     groundLevel.scaleY = 0.26;
     [zoombase addChild: groundLevel z:15];
     }
     */
    
    groundLevel.visible = YES;
	
	CGPoint groundLevelPolygon[] = {
		ccp(-750,-5),
		ccp(-750, 5),
		ccp( 750, 5),
		ccp( 750,-5),
	};
	
	cpBody *groundLevelBody = cpBodyNewStatic(INFINITY, INFINITY);
	
	groundLevelBody->p = ccp(25, 8);
	
	cpShape *groundLevelShape = cpPolyShapeNew(groundLevelBody, 4, groundLevelPolygon, CGPointZero);
    groundLevelShape->collision_type = kGroundCollisionType;
    groundLevelShape->u = 10.0;
	cpSpaceAddStaticShape(smgr.space, groundLevelShape);
}

- (void) timer
{
    //Timer Label
    timeLabel =[CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%f", appSessionStartTime] fntFile:@"Score.fnt"];
    [timeLabel setAnchorPoint:ccp(0.5, 0.5)];
    timeLabel.position = ccp(100, 20);
    timeLabel.scale = 1.3;
    timeLabel.visible = NO;
    [hudLayer addChild:timeLabel z:1000];
}

- (void) createTriPillarsAt:(cpVect)pos
					  width:(int)w
					 height:(int)h
{
	const int W2 = w/2;
	const int H2 = 9.9;
	const int W1 = 12;
	const int H1 = h-H2;
	const int M = 100;
    float widthCoefficient = 0.0059;
    float heightCoefficient = 0.0064;
    float groundWidthCoefficient = 0.0225;
    float groundHeightCoefficient = 0.0022;
    
    //rectangleShape.scaleX = W2*0.038;
    //rectangleShape.scaleY = H1*0.012;
    
    //pillars 1
    rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(0,H1/2)) width:W1 height:H1 mass:M];
    [zoombase addChild: rectangleShape z:18];
    /*
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     */
    rectangleShape.scaleX = W2*widthCoefficient;
    rectangleShape.scaleY = H1*heightCoefficient;
    audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioNode];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBreakingSplintery];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockTumbling];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockOnFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockCrumblingFromFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioIceBlockBeingDestroyed];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    
    rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(W2,H1/2)) width:W1 height:H1 mass:M];
    [zoombase addChild: rectangleShape z:18];
    /*
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     */
    rectangleShape.scaleX = W2*widthCoefficient;
    rectangleShape.scaleY = H1*heightCoefficient;
    audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioNode];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBreakingSplintery];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockTumbling];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockOnFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockCrumblingFromFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioIceBlockBeingDestroyed];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    
    
    rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(W2*2,H1/2)) width:W1 height:H1 mass:M];
    [zoombase addChild: rectangleShape z:18];
    /*
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     */
    rectangleShape.scaleX = W2*widthCoefficient;
    rectangleShape.scaleY = H1*heightCoefficient;
    audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioNode];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBreakingSplintery];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockTumbling];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockOnFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockCrumblingFromFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioIceBlockBeingDestroyed];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    
    
    //floor 1
    rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(W2/2-W1/4,H1+H2/2)) width:W2+W1/2 height:H2 mass:M];
    [zoombase addChild: rectangleShape z:18];
    /*
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     */
    rectangleShape.scaleX = W2*groundWidthCoefficient;
    rectangleShape.scaleY = H1*groundHeightCoefficient;
    audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioNode];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBreakingSplintery];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockTumbling];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockOnFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockCrumblingFromFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioIceBlockBeingDestroyed];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    
    
    rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(W2+W2/2+W1/4,H1+H2/2)) width:W2+W1/2 height:H2 mass:M];
    [zoombase addChild: rectangleShape z:18];
    /*
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     */
    rectangleShape.scaleX = W2*groundWidthCoefficient;
    rectangleShape.scaleY = H1*groundHeightCoefficient;
    audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioNode];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBreakingSplintery];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockTumbling];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockOnFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockCrumblingFromFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioIceBlockBeingDestroyed];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
}


- (void) createStackOfThree:(cpVect)pos
					  width:(int)w
					 height:(int)h
{
	const int W2 = w/2;
	const int H2 = 9.9;
	const int W1 = 12;
	const int H1 = h-H2;
	const int M = 100;
    float widthCoefficient = 0.0061;
    float heightCoefficient = 0.0064;
    float groundWidthCoefficient = 0.0225;
    float groundHeightCoefficient = 0.0024;
    
    //rectangleShape.scaleX = W2*0.038;
    //rectangleShape.scaleY = H1*0.012;
    
    
    
    //floor 1
    rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(0,H1+H2/2)) width:W2+W1/2 height:H2 mass:M];
    [zoombase addChild: rectangleShape z:18];
    /*
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     */
    rectangleShape.scaleX = W2*groundWidthCoefficient;
    rectangleShape.scaleY = H1*groundHeightCoefficient;
    audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioNode];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBreakingSplintery];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockTumbling];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockOnFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockCrumblingFromFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioIceBlockBeingDestroyed];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    
    
    rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(0,H1+H2/2)) width:W2+W1/2 height:H2 mass:M];
    [zoombase addChild: rectangleShape z:18];
    /*
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     */
    rectangleShape.scaleX = W2*groundWidthCoefficient;
    rectangleShape.scaleY = H1*groundHeightCoefficient;
    audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioNode];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBreakingSplintery];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockTumbling];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockOnFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockCrumblingFromFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioIceBlockBeingDestroyed];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    
    
    rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(0,H1+H2/2)) width:W2+W1/2 height:H2 mass:M];
    [zoombase addChild: rectangleShape z:18];
    /*
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     */
    rectangleShape.scaleX = W2*groundWidthCoefficient;
    rectangleShape.scaleY = H1*groundHeightCoefficient;
    audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioNode];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBreakingSplintery];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockTumbling];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockOnFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockCrumblingFromFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioIceBlockBeingDestroyed];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
}


- (void) createThreeSidedHouseAt:(cpVect)pos
                           width:(int)w
                          height:(int)h
{
	const int W2 = w/2;
	const int H2 = 9.9;
	const int W1 = 12;
	const int H1 = h-H2;
	const int M = 100;
    float widthCoefficient = 0.0050;
    float heightCoefficient = 0.0064;
    float groundWidthCoefficient = 0.0225;
    float groundHeightCoefficient = 0.0022;
    
    //rectangleShape.scaleX = W2*0.038;
    //rectangleShape.scaleY = H1*0.012;
    
    //Pillar 1
    rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(0,H1/2)) width:W1 height:H1 mass:M];
    [zoombase addChild: rectangleShape z:18];
    /*
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     */
    rectangleShape.scaleX = W2*widthCoefficient;
    rectangleShape.scaleY = H1*heightCoefficient;
    audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioNode];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBreakingSplintery];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockTumbling];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockOnFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockCrumblingFromFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioIceBlockBeingDestroyed];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    
    
    //Pillar2
    rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(W2,H1/2)) width:W1 height:H1 mass:M];
    [zoombase addChild: rectangleShape z:18];
    /*
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     */
    rectangleShape.scaleX = W2*widthCoefficient;
    rectangleShape.scaleY = H1*heightCoefficient;
    audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioNode];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBreakingSplintery];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockTumbling];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockOnFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockCrumblingFromFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioIceBlockBeingDestroyed];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    
    
    //floor 1
    rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(W2/2-W1/4,H1+H2/2)) width:W2+W1/2 height:H2 mass:M];
    [zoombase addChild: rectangleShape z:18];
    /*
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     */
    rectangleShape.scaleX = W2*groundWidthCoefficient;
    rectangleShape.scaleY = H1*groundHeightCoefficient;
    audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioNode];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBreakingSplintery];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockTumbling];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockOnFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockCrumblingFromFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioIceBlockBeingDestroyed];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
}


- (void) createTeePeePillarsAt:(cpVect)pos
                         width:(int)w
                        height:(int)h
{
	const int W2 = w/2;
	const int H2 = 20;
	const int W1 = 12;
	const int H1 = h-H2;
	const int M = 100;
    float widthCoefficient = 0.0053;
    float heightCoefficient = 0.0065;
    
    //rectangleShape.scaleX = W2*0.038;
    //rectangleShape.scaleY = H1*0.012;
    
    //Pillars 1
    rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(1,H1/2)) width:W1 height:H1 mass:M];
    [zoombase addChild: rectangleShape z:18];
    
    rectangleShape.shape->body->a = -M_PI/6;
    /*
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     */
    rectangleShape.scaleX = W2*widthCoefficient;
    rectangleShape.scaleY = H1*heightCoefficient;
    audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioNode];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBreakingSplintery];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockTumbling];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockOnFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockCrumblingFromFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioIceBlockBeingDestroyed];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    
    
    //Pillar 2
    rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(W2 - 8,H1/2)) width:W1 height:H1 mass:M];
    [zoombase addChild: rectangleShape z:18];
    
    rectangleShape.shape->body->a = M_PI/6;
    
    /*
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     */
    rectangleShape.scaleX = W2*widthCoefficient;
    rectangleShape.scaleY = H1*heightCoefficient;
    audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioNode];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBreakingSplintery];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockTumbling];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockOnFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioBlockCrumblingFromFire];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
    [rectangleShape addChild:audioIceBlockBeingDestroyed];
    sourceIDNumber = sourceIDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    
    /*
     rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(W2*2,H1/2)) width:W1 height:H1 mass:M];
     [zoombase addChild: rectangleShape z:18];
     
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     
     rectangleShape.scaleX = W2*widthCoefficient;
     rectangleShape.scaleY = H1*heightCoefficient;
     audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioNode];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioBreakingSplintery];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioBlockTumbling];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioBlockOnFire];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioBlockCrumblingFromFire];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioIceBlockBeingDestroyed];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     
     
     //floor 1
     rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(W2/2-W1/4,H1+H2/2)) width:W2+W1/2 height:H2 mass:M];
     [zoombase addChild: rectangleShape z:18];
     
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     
     rectangleShape.scaleX = W2*groundWidthCoefficient;
     rectangleShape.scaleY = H1*groundHeightCoefficient;
     audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioNode];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioBreakingSplintery];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioBlockTumbling];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioBlockOnFire];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioBlockCrumblingFromFire];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioIceBlockBeingDestroyed];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     
     
     rectangleShape = [RectangleShape rectangleShapeWithGame: self createBlockAt:cpvadd(pos, cpv(W2+W2/2+W1/4,H1+H2/2)) width:W2+W1/2 height:H2 mass:M];
     [zoombase addChild: rectangleShape z:18];
     
     if (rectangleShape.position.x > 250) {
     
     rectangleShape.shape->layers = 1;
     }
     
     if (rectangleShape.position.x < 250) {
     
     rectangleShape.shape->layers = 2;
     }
     
     rectangleShape.scaleX = W2*groundWidthCoefficient;
     rectangleShape.scaleY = H1*groundHeightCoefficient;
     audioNode = [CDXAudioNode audioNodeWithFile:@"HardMarbleCollision.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioNode];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioBreakingSplintery = [CDXAudioNodeBlocks audioNodeWithFile:@"BlockBreakingSplintery.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioBreakingSplintery];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioBlockTumbling = [CDXAudioNode audioNodeWithFile:@"BlockHittingFloorHard.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioBlockTumbling];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioBlockOnFire = [CDXAudioNode audioNodeWithFile:@"BlockOnFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioBlockOnFire];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioBlockCrumblingFromFire = [CDXAudioNode audioNodeWithFile:@"BlockCrumblingFromFire.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioBlockCrumblingFromFire];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioIceBlockBeingDestroyed = [CDXAudioNode audioNodeWithFile:@"glassbreak.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
     [rectangleShape addChild:audioIceBlockBeingDestroyed];
     sourceIDNumber = sourceIDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     */
}


- (void) setupShapes
{
    cpResetShapeIdCounter();
    /*
     AVAudioSession *audioSession = [AVAudioSession sharedInstance];
     [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
     [audioSession setActive: YES error: nil];
     */
    
    //
    
    if ([[h platformString] isEqualToString:@"iPod Touch 1G"] || [[h platformString] isEqualToString:@"iPod Touch 2G"] || [[h platformString] isEqualToString:@"iPod Touch 3G"] || [[h platformString] isEqualToString:@"iPod Touch 4G"]) {
        
        playerHasIPodTouch = YES;
        
        if (headsetIsPluggedIn) {
            
            [[CDAudioManager sharedManager] setMode:kAMM_PlayAndRecord];
        }
        
        else {
            
            [[CDAudioManager sharedManager] setMode:kAMM_FxPlusMusic];
        }
    }
    
    
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    
    if (!playerHasIPodTouch) {
        
        [CDAudioManager initAsynchronously:kAMM_PlayAndRecord];
    }
    
    else {
        
        [CDAudioManager initAsynchronously:kAMM_FxPlusMusic];
    }
    
    while ([CDAudioManager sharedManagerState] != kAMStateInitialised) {}
    
    am = [CDAudioManager sharedManager];
    
    if (!playerHasIPodTouch) {
        
        [[CDAudioManager sharedManager] setMode:kAMM_PlayAndRecord];
    }
    
    else {
        
        [[CDAudioManager sharedManager] setMode:kAMM_FxPlusMusic];
    }
    
    
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof (doChangeDefaultRoute), &doChangeDefaultRoute);
    
    soundEngine = [CDAudioManager sharedManager].soundEngine;
    
    
    defs = [NSArray arrayWithObjects: [NSNumber numberWithInt:550], nil];
    [soundEngine defineSourceGroups:defs];
    
    //
    
    //Choose a random block configuration if it's a single player game
    if (isSinglePlayer) {
        
        //pillarConfiguration = arc4random()%4;
        NSLog (@"pillarConfiguration = %i", pillarConfiguration);
        //Comment out the below line for release version
        pillarConfiguration = 3;
    }
    
    
    if (firstTimeLoadingGameScene == NO) {
        
        if (deviceIsWidescreen) {
            
            carpet.scale = 0.56;
        }
        
        if (!deviceIsWidescreen) {
            
            carpet.scale = 0.5;
        }
    }
    
    
    if (pillarConfiguration == 0) {
        
        //Pillars for Player1
        [self createThreeSidedHouseAt:cpv(70,13) width:92 height:40];
        [self createThreeSidedHouseAt:cpv(125,13) width:92 height:40];
        
        [self createThreeSidedHouseAt:cpv(122,53) width:92 height:40];
        
        [self createTeePeePillarsAt:cpv(122,93) width:92 height:55];
        
        
        //Pillars for Player2
        [self createThreeSidedHouseAt:cpv(382,13) width:92 height:40];
        [self createThreeSidedHouseAt:cpv(437,13) width:92 height:40];
        
        [self createThreeSidedHouseAt:cpv(382,53) width:92 height:40];
        
        [self createTeePeePillarsAt:cpv(382,93) width:92 height:55];
    }
    
    else if (pillarConfiguration == 1) {
        
        //Pillars for Player1
        [self createThreeSidedHouseAt:cpv(75 + 2,13) width:92 height:40];
        [self createThreeSidedHouseAt:cpv(125 + 20,13) width:92 height:40];
        
        [self createTeePeePillarsAt:cpv(77,55) width:92 height:55];
        [self createTeePeePillarsAt:cpv(145,55) width:92 height:55];
        
        
        //Pillars for Player2
        [self createThreeSidedHouseAt:cpv(382 - 6, 13) width:92 height:40];
        [self createThreeSidedHouseAt:cpv(445, 13) width:92 height:40];
        
        [self createTeePeePillarsAt:cpv(384 - 6, 55) width:92 height:55];
        [self createTeePeePillarsAt:cpv(445, 55) width:92 height:55];
    }
    
    else if (pillarConfiguration == 2) {
        
        //Pillars for Player1
        [self createThreeSidedHouseAt:cpv(77,13) width:92 height:40];
        [self createThreeSidedHouseAt:cpv(135,13) width:92 height:40];
        
        [self createThreeSidedHouseAt:cpv(74,53) width:92 height:40];
        [self createThreeSidedHouseAt:cpv(132,53) width:92 height:40];
        
        //Pillars for Player2
        [self createThreeSidedHouseAt:cpv(387,13) width:92 height:40];
        [self createThreeSidedHouseAt:cpv(445,13) width:92 height:40];
        
        [self createThreeSidedHouseAt:cpv(387,53) width:92 height:40];
        [self createThreeSidedHouseAt:cpv(445,53) width:92 height:40];
    }
    
    else if (pillarConfiguration == 3) {
        
        
        //Orignal TriPillar configuration
        //Pillars for Player1
        [self createTriPillarsAt:cpv(25,13) width:92 height:40];
        [self createTriPillarsAt:cpv(75,53) width:92 height:40];
        //[self createTriPillarsAt:cpv(85,73) width:92 height:40];
        
        
        [self createTriPillarsAt:cpv(125,13) width:92 height:40];
        //	[self createTriPillarsAt:cpv(128,53) width:82 height:20];
        //	[self createTriPillarsAt:cpv(131,73) width:72 height:20];
        
        
        //Pillars for Player2
        [self createTriPillarsAt:cpv(343,13) width:92 height:40];
        [self createTriPillarsAt:cpv(393,53) width:92 height:40];
        //[self createTriPillarsAt:cpv(395,73) width:92 height:40];
        
        
        [self createTriPillarsAt:cpv(443,13) width:92 height:40];
        //	[self createTriPillarsAt:cpv(438,53) width:82 height:20];
        //	[self createTriPillarsAt:cpv(441,73) width:72 height:20];
    }
    
    //Crosshairs over Gerty
    crosshairs1 = [CCSprite spriteWithSpriteFrameName: @"Crosshairs-hd.png"];
    crosshairs1.anchorPoint = ccp(0.5, 0.5);
    crosshairs1.position = ccp(-500,-500);
    [zoombase addChild: crosshairs1 z:30];
    
    //Crosshairs over Gerty2
    crosshairs2 = [CCSprite spriteWithSpriteFrameName: @"Crosshairs-hd.png"];
    crosshairs2.anchorPoint = ccp(0.5, 0.5);
    crosshairs2.position = ccp(-500,-500);
    [zoombase addChild: crosshairs2 z:30];
    
    //Pointing Finger Above Sling1
    pointingFinger1 = [CCSprite spriteWithSpriteFrameName: @"PointingFinger-hd.png"];
    pointingFinger1.anchorPoint = ccp(0.5, 0.5);
    pointingFinger1.position = ccp(-500, 500);
    [zoombase addChild: pointingFinger1 z:50];
    
    //Pointing Finger Above Opponent's Marble
    pointingFinger2 = [CCSprite spriteWithSpriteFrameName: @"PointingFinger-hd.png"];
    pointingFinger2.anchorPoint = ccp(0.5, 0.5);
    pointingFinger2.position = ccp(-500, 500);
    pointingFinger2.scale = 0.2;
    [zoombase addChild: pointingFinger2 z:1000];
    
    //Warning Arrow
    redWarningArrow = [CCSprite spriteWithSpriteFrameName: @"redarrow-hd.png"];
    [zoombase addChild: redWarningArrow z:15];
    redWarningArrow.opacity = 0;
    
    redWarningArrow2 = [CCSprite spriteWithSpriteFrameName: @"redarrow-hd.png"];
    [zoombase addChild: redWarningArrow2 z:15];
    redWarningArrow2.opacity = 0;
    
    lightningBolt1 = [CCSprite spriteWithSpriteFrameName: @"LightningBolt-hd.png"];
    [zoombase addChild: lightningBolt1 z:6];
    lightningBolt1.scale = 0.4;
    lightningBolt1.position = ccp(-300,-300);
    
    lightningBolt2 = [CCSprite spriteWithSpriteFrameName: @"LightningBolt-hd.png"];
    [zoombase addChild: lightningBolt2 z:6];
    lightningBolt2.scale = 0.4;
    lightningBolt2.position = ccp(-300,-300);
    
    skillLevelUpLightningBolt1 = [CCSprite spriteWithSpriteFrameName: @"LightningBolt-hd.png"];
    [zoombase addChild: skillLevelUpLightningBolt1 z:11];
    skillLevelUpLightningBolt1.scale = 1.0;
    skillLevelUpLightningBolt1.position = ccp(-300,-300);
    
    skillLevelUpLightningBolt2 = [CCSprite spriteWithSpriteFrameName: @"LightningBolt-hd.png"];
    [zoombase addChild: skillLevelUpLightningBolt2 z:11];
    skillLevelUpLightningBolt2.scale = 1.0;
    skillLevelUpLightningBolt2.position = ccp(-300,-300);
    
    teslaGlow1 = [CCSprite spriteWithFile: @"GlowInTheDarkAura.png"];
    [zoombase addChild: teslaGlow1 z:12];
    teslaGlow1.scale = 0.7;
    teslaGlow1.position = SLING_BOMB_POSITION;
    teslaGlow1.opacity = 150;
    teslaGlow1.scaleY = 1.6;
    teslaGlow1.scaleX = 2.1;
    [teslaGlow1 runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCScaleTo actionWithDuration:0.05 scale:1.7], [CCScaleTo actionWithDuration:0.05 scale:1.6], nil]]];
    
    
    teslaGlow2 = [CCSprite spriteWithFile: @"GlowInTheDarkAura.png"];
    [zoombase addChild: teslaGlow2 z:12];
    teslaGlow2.scale = 0.7;
    teslaGlow2.position = SLING_BOMB_POSITION_2;
    teslaGlow2.opacity = 150;
    teslaGlow2.scaleY = 1.6;
    teslaGlow2.scaleX = 2.1;
    [teslaGlow2 runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCScaleTo actionWithDuration:0.05 scale:1.7], [CCScaleTo actionWithDuration:0.05 scale:1.6], nil]]];
    
    
    //continue building out gerty1BreakingSmoke here
    //    gerty1BreakingSmoke = [CCSprite spriteWithFile: @"smoke.png"];
    
    player1GiantSmokeCloudFront = [CCSprite spriteWithSpriteFrameName: @"dustcloud-hd.png"];
    [zoombase addChild: player1GiantSmokeCloudFront z:20];
    player1GiantSmokeCloudFront.scaleX = 2.7;
    player1GiantSmokeCloudFront.scaleY = 1.5;
    [player1GiantSmokeCloudFront runAction: [CCFadeTo actionWithDuration:0.0 opacity: 0]];
    [player1GiantSmokeCloudFront runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCScaleBy actionWithDuration:1.0 scale:1.01], [CCScaleBy actionWithDuration:1.0 scale:0.99], nil]]];
    
    player1GiantSmokeCloudBack = [CCSprite spriteWithSpriteFrameName: @"dustcloud-hd.png"];
    [zoombase addChild: player1GiantSmokeCloudBack z:4];
    player1GiantSmokeCloudBack.scaleX = 2.7;
    player1GiantSmokeCloudBack.scaleY = 1.5;
    [player1GiantSmokeCloudBack runAction: [CCFadeTo actionWithDuration:0.0 opacity:0]];
    [player1GiantSmokeCloudBack runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCScaleBy actionWithDuration:1.0 scale:1.01], [CCScaleBy actionWithDuration:1.0 scale:0.99], nil]]];
    
    [player1GiantSmokeCloudFront runAction: [CCMoveTo actionWithDuration: 0.0 position: PLAYER_1_GIANT_SMOKE_CLOUD]];
    [player1GiantSmokeCloudBack runAction: [CCMoveTo actionWithDuration: 0.0 position: PLAYER_1_GIANT_SMOKE_CLOUD]];
    
    if (stage == NIGHT_TIME_SUBURB) {
        
        player1GiantSmokeCloudFront.color = ccc3(135, 206, 250);
    }
    
    player2GiantSmokeCloudFront = [CCSprite spriteWithSpriteFrameName: @"dustcloud-hd.png"];
    [zoombase addChild: player2GiantSmokeCloudFront z:20];
    player2GiantSmokeCloudFront.scaleX = 2.7;
    player2GiantSmokeCloudFront.scaleY = 1.5;
    [player2GiantSmokeCloudFront runAction: [CCFadeOut actionWithDuration: 0]];
    [player2GiantSmokeCloudFront runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCScaleBy actionWithDuration:1.0 scale:1.01], [CCScaleBy actionWithDuration:1.0 scale:0.99], nil]]];
    
    player2GiantSmokeCloudBack = [CCSprite spriteWithSpriteFrameName: @"dustcloud-hd.png"];
    [zoombase addChild: player2GiantSmokeCloudBack z:4];
    player2GiantSmokeCloudBack.scaleX = 2.7;
    player2GiantSmokeCloudBack.scaleY = 1.5;
    [player2GiantSmokeCloudBack runAction: [CCFadeOut actionWithDuration: 0]];
    [player2GiantSmokeCloudBack runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCScaleBy actionWithDuration:1.0 scale:1.01], [CCScaleBy actionWithDuration:1.0 scale:0.99], nil]]];
    
    [player2GiantSmokeCloudFront runAction: [CCMoveTo actionWithDuration: 0.0 position: PLAYER_2_GIANT_SMOKE_CLOUD]];
    [player2GiantSmokeCloudBack runAction: [CCMoveTo actionWithDuration: 0.0 position: PLAYER_2_GIANT_SMOKE_CLOUD]];
    
    if (stage == NIGHT_TIME_SUBURB) {
        
        player2GiantSmokeCloudFront.color = ccc3(135, 206, 250);
    }
    
    //Generate random number for low block
    [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(generateRandomNumberForLowShot)], [CCDelayTime actionWithDuration:0.3], [CCCallFunc actionWithTarget:self selector:@selector(generateRandomNumberForLowShot)], [CCDelayTime actionWithDuration: 0.3], nil]]];
    //Generate random number for high block
    [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(generateRandomNumberForHighShot)], [CCDelayTime actionWithDuration:0.3], [CCCallFunc actionWithTarget:self selector:@selector(generateRandomNumberForHighShot)], [CCDelayTime actionWithDuration: 0.3], nil]]];
    
    [self addGroundLevel];
}

- (void) addFlameToPlayer1Marble
{
    flamesForRedMarblePlayer1 = [CCSprite spriteWithSpriteFrameName: @"marbleflame-hd.png"];
    [zoombase addChild: flamesForRedMarblePlayer1 z: 5];
    flamesForRedMarblePlayer1.position = ccp(-300, -300);
    flamesForRedMarblePlayer1.opacity = 180;
    flamesForRedMarblePlayer1.anchorPoint = ccp(0.5, 0.3);
    flamesForRedMarblePlayer1.scaleY = 1.2;
    
    [flamesForRedMarblePlayer1 runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCFlipX actionWithFlipX: YES], [CCDelayTime actionWithDuration: 0.05], [CCFlipX actionWithFlipX: NO], [CCDelayTime actionWithDuration: 0.05], nil]]];
}

- (void) addFlameToPlayer2Marble
{
    flamesForRedMarblePlayer2 = [CCSprite spriteWithSpriteFrameName: @"marbleflame-hd.png"];
    [zoombase addChild: flamesForRedMarblePlayer2 z: 5];
    flamesForRedMarblePlayer2.position = ccp(-300, -300);
    flamesForRedMarblePlayer2.opacity = 180;
    flamesForRedMarblePlayer2.anchorPoint = ccp(0.5, 0.3);
    flamesForRedMarblePlayer2.scaleY = 1.2;
    
    
    [flamesForRedMarblePlayer2 runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCFlipX actionWithFlipX: YES], [CCDelayTime actionWithDuration: 0.05], [CCFlipX actionWithFlipX: NO], [CCDelayTime actionWithDuration: 0.05], nil]]];
}

-(void) decreaseBigSmokeTimeIntervalForBothPlayers
{
    
    if (increaseBigSmokeTimeInterval1 >= 0.07) {
        
        increaseBigSmokeTimeInterval1 = increaseBigSmokeTimeInterval1 - 0.01;
    }
    
    else {
        
        increaseBigSmokeTimeInterval1 = 0.07;
    }
    
    if (increaseBigSmokeTimeInterval2 >= 0.07) {
        
        increaseBigSmokeTimeInterval2 = increaseBigSmokeTimeInterval2 - 0.01;
    }
    
    else {
        
        increaseBigSmokeTimeInterval2 = 0.07;
    }
    
    NSLog (@"increaseBigSmokeTimeInterval1 = %f", increaseBigSmokeTimeInterval1);
}

-(void) increaseValueOfBigSmokeCloudOpacity
{
    if (player1GiantSmokeCloudFrontOpacity < 295) {
        
        if (player1HandicapInteger == 0) {
            
            player1GiantSmokeCloudFrontOpacity = player1GiantSmokeCloudFrontOpacity + 5;
            
        }
        
        else if (player1HandicapInteger == 1) {
            
            player1GiantSmokeCloudFrontOpacity = player1GiantSmokeCloudFrontOpacity + 3;
        }
        
        else if (player1HandicapInteger == 2) {
            
            player1GiantSmokeCloudFrontOpacity = player1GiantSmokeCloudFrontOpacity + 2;
        }
        
        else if (player1HandicapInteger == 3) {
            
            player1GiantSmokeCloudFrontOpacity = player1GiantSmokeCloudFrontOpacity + 1;
        }
        
        else if (player1HandicapInteger == 4) {
            
            player1GiantSmokeCloudFrontOpacity = player1GiantSmokeCloudFrontOpacity + 0;
        }
    }
}

-(void) increaseValueOfPlayer2BigSmokeCloudOpacity
{
    if (player2GiantSmokeCloudFrontOpacity < 295) {
        
        if (player2HandicapInteger == 0) {
            
            player2GiantSmokeCloudFrontOpacity = player2GiantSmokeCloudFrontOpacity + 5;
            
        }
        
        else if (player2HandicapInteger == 1) {
            
            player2GiantSmokeCloudFrontOpacity = player2GiantSmokeCloudFrontOpacity + 3;
        }
        
        else if (player2HandicapInteger == 2) {
            
            player2GiantSmokeCloudFrontOpacity = player2GiantSmokeCloudFrontOpacity + 2;
        }
        
        else if (player2HandicapInteger == 3) {
            
            player2GiantSmokeCloudFrontOpacity = player2GiantSmokeCloudFrontOpacity + 1;
        }
        
        else if (player2HandicapInteger == 4) {
            
            player2GiantSmokeCloudFrontOpacity = player2GiantSmokeCloudFrontOpacity + 0;
        }
    }
}

-(void) reduceValueOfBigSmokeCloudOpacity
{
    if (player1GiantSmokeCloudFrontOpacity >= 5) {
        
        player1GiantSmokeCloudFrontOpacity = player1GiantSmokeCloudFrontOpacity - 5;
    }
}

-(void) reduceValueOfPlayer2BigSmokeCloudOpacity
{
    if (player2GiantSmokeCloudFrontOpacity >= 5) {
        
        player2GiantSmokeCloudFrontOpacity = player2GiantSmokeCloudFrontOpacity - 5;
        //  NSLog (@"increasing!");
    }
}

-(void) increaseBigSmokeCloudOpacity
{
    if (player1GiantSmokeCloudFrontOpacityIsIncreasing == NO) {
        
        [self stopAction: reduceBigSmokeCloudOpacityAction];
    }
    
    player1GiantSmokeCloudFrontOpacityIsIncreasing = YES;
    
    increaseBigSmokeCloudOpacityAction = [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: increaseBigSmokeTimeInterval1], [CCCallFunc actionWithTarget:self selector:@selector(increaseValueOfBigSmokeCloudOpacity)], [CCDelayTime actionWithDuration: increaseBigSmokeTimeInterval1], [CCCallFunc actionWithTarget:self selector:@selector(increaseValueOfBigSmokeCloudOpacity)], nil]];
    
    [self runAction: increaseBigSmokeCloudOpacityAction];
}

-(void) increasePlayer2BigSmokeCloudOpacity
{
    if (player2GiantSmokeCloudFrontOpacityIsIncreasing == NO) {
        
        [self stopAction: reducePlayer2BigSmokeCloudOpacityAction];
    }
    
    if (isSinglePlayer == YES) {
        
        if (computerExperiencePoints == 10) {
            
            increaseBigSmokeTimeInterval2 = 0.16;
        }
        
        else if (computerExperiencePoints == 20) {
            
            increaseBigSmokeTimeInterval2 = 0.15;
        }
        
        else if (computerExperiencePoints == 30) {
            
            increaseBigSmokeTimeInterval2 = 0.14;
        }
        
        else if (computerExperiencePoints == 40) {
            
            increaseBigSmokeTimeInterval2 = 0.13;
        }
        
        else if (computerExperiencePoints == 50) {
            
            increaseBigSmokeTimeInterval2 = 0.12;
        }
        
        else if (computerExperiencePoints == 60) {
            
            increaseBigSmokeTimeInterval2 = 0.11;
        }
        
        else if (computerExperiencePoints == 70) {
            
            increaseBigSmokeTimeInterval2 = 0.10;
        }
        
        else if (computerExperiencePoints == 80) {
            
            increaseBigSmokeTimeInterval2 = 0.09;
        }
        
        else if (computerExperiencePoints == 90) {
            
            increaseBigSmokeTimeInterval2 = 0.08;
        }
    }
    
    player2GiantSmokeCloudFrontOpacityIsIncreasing = YES;
    
    increasePlayer2BigSmokeCloudOpacityAction = [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: increaseBigSmokeTimeInterval2], [CCCallFunc actionWithTarget:self selector:@selector(increaseValueOfPlayer2BigSmokeCloudOpacity)], [CCDelayTime actionWithDuration: increaseBigSmokeTimeInterval2], [CCCallFunc actionWithTarget:self selector:@selector(increaseValueOfPlayer2BigSmokeCloudOpacity)], nil]];
    
    [self runAction: increasePlayer2BigSmokeCloudOpacityAction];
}

-(void) reduceBigSmokeCloudOpacity
{
    
    if (player1GiantSmokeCloudFrontOpacityIsIncreasing == YES) {
        
        [self stopAction: increaseBigSmokeCloudOpacityAction];
    }
    
    player1GiantSmokeCloudFrontOpacityIsIncreasing = NO;
    
    reduceBigSmokeCloudOpacityAction = [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.05], [CCCallFunc actionWithTarget:self selector:@selector(reduceValueOfBigSmokeCloudOpacity)], [CCDelayTime actionWithDuration: 0.05], [CCCallFunc actionWithTarget:self selector:@selector(reduceValueOfBigSmokeCloudOpacity)], nil]];
    
    [self runAction: reduceBigSmokeCloudOpacityAction];
}

-(void) reducePlayer2BigSmokeCloudOpacity
{
    if (player2GiantSmokeCloudFrontOpacityIsIncreasing == YES) {
        
        [self stopAction: increasePlayer2BigSmokeCloudOpacityAction];
    }
    
    player2GiantSmokeCloudFrontOpacityIsIncreasing = NO;
    
    reducePlayer2BigSmokeCloudOpacityAction = [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.05], [CCCallFunc actionWithTarget:self selector:@selector(reduceValueOfPlayer2BigSmokeCloudOpacity)], [CCDelayTime actionWithDuration: 0.05], [CCCallFunc actionWithTarget:self selector:@selector(reduceValueOfPlayer2BigSmokeCloudOpacity)], nil]];
    
    [self runAction: reducePlayer2BigSmokeCloudOpacityAction];
}

-(void) generateRandomNumberForLowShot
{
    if (isSinglePlayer == YES) {
        
        if (difficultyLevel == 0) {
            
            if (player1GiantSmokeCloudFrontOpacity < 155) {
                
                chanceOfComputerBlock = arc4random()%4;
            }
            
            else if (player1GiantSmokeCloudFrontOpacity > 155) {
                
                chanceOfComputerBlock = arc4random()%4;
            }
        }
        
        else if (difficultyLevel == 1) {
            
            if (player1GiantSmokeCloudFrontOpacity < 155) {
                
                chanceOfComputerBlock = arc4random()%3;
            }
            
            else if (player1GiantSmokeCloudFrontOpacity > 155) {
                
                chanceOfComputerBlock = arc4random()%3;
            }
        }
        
        else if (difficultyLevel >= 2) {
            
            if (player1GiantSmokeCloudFrontOpacity < 155) {
                
                chanceOfComputerBlock = arc4random()%2;
            }
            
            else if (player1GiantSmokeCloudFrontOpacity > 155) {
                
                chanceOfComputerBlock = arc4random()%2;
            }
        }
    }
}

-(void) generateRandomNumberForHighShot
{
    if (isSinglePlayer == YES) {
        
        if (difficultyLevel == 0) {
            
            chanceOfComputerBlockForHighShot = arc4random()%3;
            // NSLog (@"chanceOfComputerBlockForHighShot = %i", chanceOfComputerBlockForHighShot);
        }
        
        else if (difficultyLevel == 1) {
            
            chanceOfComputerBlockForHighShot = arc4random()%2;
        }
        
        else if (difficultyLevel >= 2) {
            
            chanceOfComputerBlock = arc4random()%2;
        }
    }
}

-(void) loadGameSettings
{
    prefs = [NSUserDefaults standardUserDefaults];
    
    checkMarkSpeechBubbleStageSelectIsOnRandomButton = [prefs boolForKey:@"checkMarkSpeechBubbleStageSelectIsOnRandomButton"];
    stage = [prefs integerForKey: @"stage"];
    inGameTutorialHasAlreadyBeenPlayedOnce = [prefs boolForKey:@"inGameTutorialHasAlreadyBeenPlayedOnce"];
    tamagachi1Color = [prefs integerForKey:@"tamagachi1Color"];
    showAds = [prefs boolForKey:@"showAds"];
    player1MarblesUnlocked = [prefs integerForKey:@"player1MarblesUnlocked"];
    player1ExperiencePoints = [prefs integerForKey:@"player1ExperiencePoints"];
    player1Level = [prefs integerForKey:@"player1Level"];
    
    [prefs synchronize];
    computerExperiencePoints = [prefs integerForKey:@"computerExperiencePoints"];
    difficultyLevel = [prefs integerForKey:@"difficultyLevel"];
    player1MarblesUnlocked = [prefs integerForKey:@"player1MarblesUnlocked"];
    player1ExperiencePoints = [prefs integerForKey:@"player1ExperiencePoints"];
    player1Level = [prefs integerForKey:@"player1Level"];
    
    showPointingFingerForGertyMainMenuLightBulbs = [prefs integerForKey:@"showPointingFingerForGertyMainMenuLightBulbs"];
    showPointingFingerForGertyMainMenuTamagachi = [prefs integerForKey:@"showPointingFingerForGertyMainMenuTamagachi"];
    
    NSLog (@"second time loading");
    //    }
}

-(void) saveGameSettings
{
    prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool: checkMarkSpeechBubbleStageSelectIsOnRandomButton forKey: @"checkMarkSpeechBubbleStageSelectIsOnRandomButton"];
    [prefs setInteger: stage forKey: @"stage"];
    [prefs setBool: inGameTutorialHasAlreadyBeenPlayedOnce forKey:@"inGameTutorialHasAlreadyBeenPlayedOnce"];
    [prefs setBool:showAds forKey:@"showAds"];
    [prefs setInteger:tamagachi1Color forKey:@"tamagachi1Color"];
    [prefs setInteger:difficultyLevel forKey:@"difficultyLevel"];
    [prefs setInteger:computerExperiencePoints forKey:@"computerExperiencePoints"];
    [prefs setInteger:player1MarblesUnlocked forKey:@"player1MarblesUnlocked"];
    [prefs setInteger:player1ExperiencePoints forKey:@"player1ExperiencePoints"];
    [prefs setInteger:player1Level forKey:@"player1Level"];
    [prefs setBool:showPointingFingerForGertyMainMenuLightBulbs forKey:@"showPointingFingerForGertyMainMenuLightBulbs"];
    [prefs setBool:showPointingFingerForGertyMainMenuTamagachi forKey:@"showPointingFingerForGertyMainMenuTamagachi"];
    
    [prefs synchronize];
}
/*
 -(void) unlockNextGertyInGrid
 {
 if (difficultyLevel == 0) {
 
 if (computerExperiencePoints == 10) {
 
 gertyGrid1VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 20) {
 
 gertyGrid2VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 30) {
 
 gertyGrid3VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 40) {
 
 gertyGrid4VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 50) {
 
 gertyGrid5VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 60) {
 
 gertyGrid6VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 70) {
 
 gertyGrid7VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 80) {
 
 gertyGrid8VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 90) {
 
 gertyGrid9VisibleBool = YES;
 }
 }
 
 if (difficultyLevel == 1) {
 
 if (computerExperiencePoints == 10) {
 
 gertyGrid10VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 20) {
 
 gertyGrid11VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 30) {
 
 gertyGrid12VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 40) {
 
 gertyGrid13VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 50) {
 
 gertyGrid14VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 60) {
 
 gertyGrid15VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 70) {
 
 gertyGrid16VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 80) {
 
 gertyGrid17VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 90) {
 
 gertyGrid18VisibleBool = YES;
 }
 }
 
 if (difficultyLevel >= 2) {
 
 if (computerExperiencePoints == 10) {
 
 gertyGrid19VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 20) {
 
 gertyGrid20VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 30) {
 
 gertyGrid21VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 40) {
 
 gertyGrid22VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 50) {
 
 gertyGrid23VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 60) {
 
 gertyGrid24VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 70) {
 
 gertyGrid25VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 80) {
 
 gertyGrid26VisibleBool = YES;
 }
 
 if (computerExperiencePoints == 90) {
 
 gertyGrid27VisibleBool = YES;
 }
 }
 }
 
 -(void) updateGertyGrid
 {
 if (gertyGrid1VisibleBool == YES) {
 
 gertyGrid1Lock.visible = NO;
 }
 
 else {
 
 gertyGrid1Lock.visible = YES;
 }
 
 if (gertyGrid2VisibleBool == YES) {
 
 gertyGrid2Lock.visible = NO;
 }
 
 else {
 
 gertyGrid2Lock.visible = YES;
 }
 
 if (gertyGrid3VisibleBool == YES) {
 
 gertyGrid3Lock.visible = NO;
 }
 
 else {
 
 gertyGrid3Lock.visible = YES;
 }
 
 if (gertyGrid4VisibleBool == YES) {
 
 gertyGrid4Lock.visible = NO;
 }
 
 else {
 
 gertyGrid4Lock.visible = YES;
 }
 
 if (gertyGrid5VisibleBool == YES) {
 
 gertyGrid5Lock.visible = NO;
 }
 
 else {
 
 gertyGrid5Lock.visible = YES;
 }
 
 if (gertyGrid6VisibleBool == YES) {
 
 gertyGrid6Lock.visible = NO;
 }
 
 else {
 
 gertyGrid6Lock.visible = YES;
 }
 
 if (gertyGrid7VisibleBool == YES) {
 
 gertyGrid7Lock.visible = NO;
 }
 
 else {
 
 gertyGrid7Lock.visible = YES;
 }
 
 if (gertyGrid8VisibleBool == YES) {
 
 gertyGrid8Lock.visible = NO;
 }
 
 else {
 
 gertyGrid8Lock.visible = YES;
 }
 
 if (gertyGrid9VisibleBool == YES) {
 
 gertyGrid9Lock.visible = NO;
 }
 
 else {
 
 gertyGrid9Lock.visible = YES;
 }
 
 if (gertyGrid10VisibleBool == YES) {
 
 gertyGrid10Lock.visible = NO;
 }
 
 else {
 
 gertyGrid10Lock.visible = YES;
 }
 
 if (gertyGrid11VisibleBool == YES) {
 
 gertyGrid11Lock.visible = NO;
 }
 
 else {
 
 gertyGrid11Lock.visible = YES;
 }
 
 if (gertyGrid12VisibleBool == YES) {
 
 gertyGrid12Lock.visible = NO;
 }
 
 else {
 
 gertyGrid12Lock.visible = YES;
 }
 
 if (gertyGrid13VisibleBool == YES) {
 
 gertyGrid13Lock.visible = NO;
 }
 
 else {
 
 gertyGrid13Lock.visible = YES;
 }
 
 if (gertyGrid14VisibleBool == YES) {
 
 gertyGrid14Lock.visible = NO;
 }
 
 else {
 
 gertyGrid14Lock.visible = YES;
 }
 
 if (gertyGrid15VisibleBool == YES) {
 
 gertyGrid15Lock.visible = NO;
 }
 
 else {
 
 gertyGrid15Lock.visible = YES;
 }
 
 if (gertyGrid16VisibleBool == YES) {
 
 gertyGrid16Lock.visible = NO;
 }
 
 else {
 
 gertyGrid16Lock.visible = YES;
 }
 
 if (gertyGrid17VisibleBool == YES) {
 
 gertyGrid17Lock.visible = NO;
 }
 
 else {
 
 gertyGrid17Lock.visible = YES;
 }
 
 if (gertyGrid18VisibleBool == YES) {
 
 gertyGrid18Lock.visible = NO;
 }
 
 else {
 
 gertyGrid18Lock.visible = YES;
 }
 
 if (gertyGrid19VisibleBool == YES) {
 
 gertyGrid19Lock.visible = NO;
 }
 
 else {
 
 gertyGrid19Lock.visible = YES;
 }
 
 if (gertyGrid20VisibleBool == YES) {
 
 gertyGrid20Lock.visible = NO;
 }
 
 else {
 
 gertyGrid20Lock.visible = YES;
 }
 
 if (gertyGrid21VisibleBool == YES) {
 
 gertyGrid21Lock.visible = NO;
 }
 
 else {
 
 gertyGrid21Lock.visible = YES;
 }
 
 if (gertyGrid22VisibleBool == YES) {
 
 gertyGrid22Lock.visible = NO;
 }
 
 else {
 
 gertyGrid22Lock.visible = YES;
 }
 
 if (gertyGrid23VisibleBool == YES) {
 
 gertyGrid23Lock.visible = NO;
 }
 
 else {
 
 gertyGrid23Lock.visible = YES;
 }
 
 if (gertyGrid24VisibleBool == YES) {
 
 gertyGrid24Lock.visible = NO;
 }
 
 else {
 
 gertyGrid24Lock.visible = YES;
 }
 
 if (gertyGrid25VisibleBool == YES) {
 
 gertyGrid25Lock.visible = NO;
 }
 
 else {
 
 gertyGrid25Lock.visible = YES;
 }
 
 if (gertyGrid26VisibleBool == YES) {
 
 gertyGrid26Lock.visible = NO;
 }
 
 else {
 
 gertyGrid26Lock.visible = YES;
 }
 
 if (gertyGrid27VisibleBool == YES) {
 
 gertyGrid27Lock.visible = NO;
 }
 
 else {
 
 gertyGrid27Lock.visible = YES;
 }
 }
 */

-(void) woodBlock
{
    woodblock = [CCSprite spriteWithSpriteFrameName: @"WoodRectangleBlock1-hd.png"];
    [carpet addChild: woodblock z: 5];
    
    woodblock.position = ccp(925, 575);
    
    woodblock2 = [CCSprite spriteWithSpriteFrameName: @"WoodRectangleBlock2-hd.png"];
    [carpet addChild: woodblock2 z: 5];
    woodblock2.position = ccp(880, 398);
    
    woodblock3 = [CCSprite spriteWithFile: @"WoodRectangleBlock3.png"];
    [carpet addChild: woodblock3 z: 5];
    woodblock3.position = ccp(995, 130);
    //DEBUG: Make woodblock3 invisible in order to disable the store
    woodblock3.visible = NO;
    
    if (showAds == YES) {
        
        if (deviceIsWidescreen)
            woodblock.position = ccp(925, 435);
        
        if (!deviceIsWidescreen)
            woodblock.position = ccp(925, 475);
        
        if (deviceIsWidescreen)
            woodblock2.position = ccp(880, 258);
        
        if (!deviceIsWidescreen)
            woodblock2.position = ccp(880, 298);
    }
    
    stickFigureBoy = [CCSprite spriteWithSpriteFrameName: @"StickFigureBoy-hd.png"];
    [woodblock addChild: stickFigureBoy z: 6];
    stickFigureBoy.scale = 1.2;
    stickFigureBoy.opacity = 215;
    stickFigureBoy.position = ccp(140,130);
    stickFigureBoy.rotation = -23;
    
    stickFigureBoy = [CCSprite spriteWithSpriteFrameName: @"StickFigureBoy-hd.png"];
    [woodblock2 addChild: stickFigureBoy z: 6];
    stickFigureBoy.scale = 1.2;
    stickFigureBoy.opacity = 215;
    stickFigureBoy.position = ccp(85,105);
    stickFigureBoy.rotation = -23;
    
    stickFigureGirl = [CCSprite spriteWithSpriteFrameName: @"StickFigureGirl-hd.png"];
    [woodblock2 addChild: stickFigureGirl z: 6];
    stickFigureGirl.scale = 1.2;
    stickFigureGirl.opacity = 215;
    stickFigureGirl.position = ccp(231,152);
    stickFigureGirl.rotation = -23;
    
    stickGlobeWithArrows = [CCSprite spriteWithSpriteFrameName: @"StickGlobeWithArrows-hd.png"];
    [woodblock2 addChild: stickGlobeWithArrows z: 6];
    stickGlobeWithArrows.scale = 1.2;
    stickGlobeWithArrows.opacity = 215;
    stickGlobeWithArrows.position = ccp(155,135);
    stickGlobeWithArrows.rotation = -19;
    
    drawnLock = [CCSprite spriteWithFile: @"DrawnLock.png"];
    [woodblock3 addChild: drawnLock z: 6];
    drawnLock.scale = 1.2;
    drawnLock.opacity = 215;
    drawnLock.position = ccp(108,110);
    drawnLock.rotation = -19;
}

-(void) startiCloudSyncing
{
    [MKiCloudSync start];
}

-(void) syncLabels
{
    prefs = [NSUserDefaults standardUserDefaults];
    
    player1MarblesUnlocked = [prefs integerForKey:@"player1MarblesUnlocked"];
    player1ExperiencePoints = [prefs integerForKey:@"player1ExperiencePoints"];
    player1Level = [prefs integerForKey:@"player1Level"];
}

- (void)restartTapped {
    
    // This is what's run when a player accepts invite.  Needs code to tell it that the game is multiplayer
    NSLog (@"restarTapped method");
    //[[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.5f scene: [Game scene]]];
    
    //Added in an attempt to make invite games work
    isSinglePlayer = NO;
}

- (void)inviteReceived {
    [self restartTapped];
}

-(void) setupLightningStrikeReadyPlayer1ToYes
{
    lightningStrikePlayer1Ready = YES;
}

-(void) setupLightningStrikeReadyPlayer2ToYes
{
    lightningStrikePlayer2Ready = YES;
}

-(void) ping {
    
    if (isPlayer1) {
        
        [self sendToken];
        sentPingTime = [[NSDate date] timeIntervalSince1970];;
    }
}

-(void) setPingAnsweredToNo
{
    if (pingAnswered == NO) {
        
        [self matchEnded];
    }
    
    else if (pingAnswered == YES) {
        
        pingAnswered = NO;
    }
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
/*
 -(void) blockDestructionStageRumble
 {
 [zoombase runAction: [CCSequence actions: [CCMoveBy
 }
 */

-(void) player1ReadyToStartInGameCountdownMethod
{
    player1ReadyToStartInGameCountdown = YES;
    
    [self sendPlayerReadyToStartInGameCountdown];
    
    if (player2ReadyToStartInGameCountdown && !inGameCountdownStarted) {
        
        //add method which shows dots on versus screen counting down to the beginning of the match
        [self startInGameCountdown];
    }
}

-(void) player2ReadyToStartInGameCountdownMethod
{
    player2ReadyToStartInGameCountdown = YES;
    
    [self sendPlayerReadyToStartInGameCountdown];
    
    if (player1ReadyToStartInGameCountdown && !inGameCountdownStarted) {
        
        //add method which shows dots on versus screen counting down to the beginning of the match
        [self startInGameCountdown];
    }
}

- (void)isHeadsetPluggedIn {
    UInt32 routeSize = sizeof (CFStringRef);
    CFStringRef route;
    
    OSStatus error = AudioSessionGetProperty (kAudioSessionProperty_AudioRoute,
                                              &routeSize,
                                              &route);
    
    /* Known values of route:
     * "Headset"
     * "Headphone"
     * "Speaker"
     * "SpeakerAndMicrophone"
     * "HeadphonesAndMicrophone"
     * "HeadsetInOut"
     * "ReceiverAndMicrophone"
     * "Lineout"
     */
    
    
    
    if (!error && (route != NULL)) {
        
        NSString* routeStr = (NSString*)route;
        
        NSRange headphoneRange = [routeStr rangeOfString : @"Head"];
        
        if (headphoneRange.location != NSNotFound) {
            
            headsetIsPluggedIn = YES;
        }
    }
    
    else {
        
        headsetIsPluggedIn = NO;
    }
}

-(void) timedOutMultiplayerMatch
{
    NSLog (@"timedOutMultiplayerMatch executed");
    
    if (tamagachiColorReceivedFromPlayer1 == NO || tamagachiColorReceivedFromPlayer2 == NO) {
        
        [self matchEnded];
        [self backToMainMenu];
    }
}

-(void) slideUpGameCenterViewController
{
    GrenadeGameAppDelegate *delegate = (GrenadeGameAppDelegate *) [UIApplication sharedApplication].delegate;
    [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:delegate.viewController delegate:self];
}

-(void) setWhiteProgressDot1ToGray
{
    whiteProgressDot1.scale = 0.03;
    whiteProgressDot1.color = ccGRAY;
}

-(void) setWhiteProgressDot2ToGray
{
    whiteProgressDot2.scale = 0.03;
    whiteProgressDot2.color = ccGRAY;
}

-(void) setWhiteProgressDot3ToGray
{
    whiteProgressDot3.scale = 0.03;
    whiteProgressDot3.color = ccGRAY;
}

-(void) setWhiteProgressDot4ToGray
{
    whiteProgressDot4.scale = 0.03;
    whiteProgressDot4.color = ccGRAY;
}

-(void) setWhiteProgressDot5ToGray
{
    whiteProgressDot5.scale = 0.03;
    whiteProgressDot5.color = ccGRAY;
}

-(void) multiplayerInGameCountdownProgressDotsAnimation
{
    whiteProgressDot1.visible = YES;
    whiteProgressDot2.visible = YES;
    whiteProgressDot3.visible = YES;
    whiteProgressDot4.visible = YES;
    whiteProgressDot5.visible = YES;
    
    whiteProgressDot1.scale = 0.05;
    whiteProgressDot2.scale = 0.05;
    whiteProgressDot3.scale = 0.05;
    whiteProgressDot4.scale = 0.05;
    whiteProgressDot5.scale = 0.05;
    
    whiteProgressDot1.color = ccBLACK;
    whiteProgressDot2.color = ccBLACK;
    whiteProgressDot3.color = ccBLACK;
    whiteProgressDot4.color = ccBLACK;
    whiteProgressDot5.color = ccBLACK;
    
    
    if (isSinglePlayer) {
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.18], [CCCallFunc actionWithTarget:self selector:@selector(setWhiteProgressDot5ToGray)], [CCDelayTime actionWithDuration: 0.18], [CCCallFunc actionWithTarget:self selector:@selector(setWhiteProgressDot4ToGray)], [CCDelayTime actionWithDuration: 0.18], [CCCallFunc actionWithTarget:self selector:@selector(setWhiteProgressDot3ToGray)], [CCDelayTime actionWithDuration: 0.18], [CCCallFunc actionWithTarget:self selector:@selector(setWhiteProgressDot2ToGray)], [CCDelayTime actionWithDuration: 0.18], [CCCallFunc actionWithTarget:self selector:@selector(setWhiteProgressDot1ToGray)],nil]];
    }
    
    else if (!isSinglePlayer) {
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.0], [CCCallFunc actionWithTarget:self selector:@selector(setWhiteProgressDot5ToGray)], [CCDelayTime actionWithDuration: 1.0], [CCCallFunc actionWithTarget:self selector:@selector(setWhiteProgressDot4ToGray)], [CCDelayTime actionWithDuration: 1.0], [CCCallFunc actionWithTarget:self selector:@selector(setWhiteProgressDot3ToGray)], [CCDelayTime actionWithDuration: 1.0], [CCCallFunc actionWithTarget:self selector:@selector(setWhiteProgressDot2ToGray)], [CCDelayTime actionWithDuration: 1.0], [CCCallFunc actionWithTarget:self selector:@selector(setWhiteProgressDot1ToGray)],nil]];
    }
}

-(void) setFirstPlayerHandicapVisible
{
    firstPlayerHandicapLeftBorder.visible = YES;
    firstPlayerHandicapRightBorder.visible = YES;
    firstPlayerHandicapGuideLine.visible = YES;
    firstPlayerHandicapFirstLine.visible = YES;
    firstPlayerHandicapSecondLine.visible = YES;
    handicapLabel.visible = YES;
    firstPlayerHandicapCheckMarkButton.visible = YES;
}

-(void) setFirstPlayerHandicapInvisible
{
    firstPlayerHandicapLeftBorder.visible = NO;
    firstPlayerHandicapRightBorder.visible = NO;
    firstPlayerHandicapGuideLine.visible = NO;
    firstPlayerHandicapFirstLine.visible = NO;
    firstPlayerHandicapSecondLine.visible = NO;
    handicapLabel.visible = NO;
    firstPlayerHandicapCheckMarkButton.visible = NO;
}

-(void) firstPlayerHandicap
{    
    if (deviceIsWidescreen) {
        
        handicapLinesSpacing = 10;
    }
    
    if (!deviceIsWidescreen) {
        
        handicapLinesSpacing = 0;
    }
    
    firstPlayerHandicapLeftBorder = [CCLabelBMFont labelWithString:@"|" fntFile:@"Casual.fnt"];
    firstPlayerHandicapLeftBorder.position = ccp(18 + handicapLinesSpacing, 30 + 150);
    [linedPaper addChild: firstPlayerHandicapLeftBorder z: 300];
    
    firstPlayerHandicapRightBorder = [CCLabelBMFont labelWithString:@"|" fntFile:@"Casual.fnt"];
    firstPlayerHandicapRightBorder.position = ccp(148 + handicapLinesSpacing, 30 + 150);
    [linedPaper addChild: firstPlayerHandicapRightBorder z: 300];
    
    firstPlayerHandicapGuideLine = [CCLabelBMFont labelWithString:@"-" fntFile:@"Casual.fnt"];
    firstPlayerHandicapGuideLine.position = ccp(83 + handicapLinesSpacing, 30 + 150);
    firstPlayerHandicapGuideLine.scaleX = 12.0;
    [linedPaper addChild: firstPlayerHandicapGuideLine z: 300];
    
    
    firstPlayerHandicapFirstLine = [CCLabelBMFont labelWithString:@"|" fntFile:@"Casual.fnt"];
    firstPlayerHandicapFirstLine.position = ccp(62 + handicapLinesSpacing, 30 + 150);
    firstPlayerHandicapFirstLine.scale = 0.7;
    [linedPaper addChild: firstPlayerHandicapFirstLine z: 300];
    
    /*
     //Number zero under first player handicap left border
     firstPlayerHandicapNumberZero = [CCLabelBMFont labelWithString:@"|" fntFile:@"Casual.fnt"];
     firstPlayerHandicapNumberZero.position = ccp(firstPlayerHandicapLeftBorder.position.x, firstPlayerHandicapLeftBorder.position.y - 20);
     firstPlayerHandicapNumberZero.scale = 0.1;
     [linedPaper addChild: firstPlayerHandicapNumberZero z: 300];
     
     //Number one under first player handicap left border
     firstPlayerHandicapNumberOne = [CCLabelBMFont labelWithString:@"|" fntFile:@"Casual.fnt"];
     firstPlayerHandicapNumberOne.position = ccp(firstPlayerHandicapFirstLine.position.x, firstPlayerHandicapFirstLine.position.y - 20);
     firstPlayerHandicapNumberOne.scale = 0.1;
     [linedPaper addChild: firstPlayerHandicapNumberOne z: 300];
     */
    
    firstPlayerHandicapSecondLine = [CCLabelBMFont labelWithString:@"|" fntFile:@"Casual.fnt"];
    firstPlayerHandicapSecondLine.position = ccp(106 + handicapLinesSpacing, 30 + 150);
    firstPlayerHandicapSecondLine.scale = 0.7;
    [linedPaper addChild: firstPlayerHandicapSecondLine z: 300];
    
    handicapLabel = [CCLabelBMFont labelWithString:@"handicap" fntFile:@"Casual.fnt"];
    handicapLabel.position = ccp(83 + handicapLinesSpacing, 10 + 185);
    handicapLabel.scale = 0.4;
    handicapLabel.anchorPoint = ccp(0.5, 0.5);
    [linedPaper addChild: handicapLabel z: 300];
    
    firstPlayerHandicapCheckMarkButton = [CCSprite spriteWithFile: @"CheckMarkButton.png"];
    firstPlayerHandicapCheckMarkButton.scale = 0.25;
    firstPlayerHandicapCheckMarkButton.position = firstPlayerHandicapLeftBorder.position;
    [linedPaper addChild: firstPlayerHandicapCheckMarkButton z: 310];
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
        
        firstPlayerHandicapLeftBorder.scale = 1.0;
        firstPlayerHandicapRightBorder.scale = 1.0;
        firstPlayerHandicapGuideLine.scaleX = 12.0;
        firstPlayerHandicapGuideLine.scaleY = 1.0;
        firstPlayerHandicapFirstLine.scale = 0.7;
        firstPlayerHandicapSecondLine.scale = 0.7;
        handicapLabel.scale = 0.4;
    }
    
    else {
        
        firstPlayerHandicapLeftBorder.scale = 1.0/2;
        firstPlayerHandicapRightBorder.scale = 1.0/2;
        firstPlayerHandicapGuideLine.scaleX = 12.0/2;
        firstPlayerHandicapGuideLine.scaleY = 1.0/2;
        firstPlayerHandicapFirstLine.scale = 0.7/2;
        firstPlayerHandicapSecondLine.scale = 0.7/2;
        handicapLabel.scale = 0.4/2;
    }
    
    [self setFirstPlayerHandicapInvisible];
}


-(void) setSecondPlayerHandicapVisible
{
    secondPlayerHandicapLeftBorder.visible = YES;
    secondPlayerHandicapRightBorder.visible = YES;
    secondPlayerHandicapGuideLine.visible = YES;
    secondPlayerHandicapFirstLine.visible = YES;
    secondPlayerHandicapSecondLine.visible = YES;
    handicapLabel2.visible = YES;
    secondPlayerHandicapCheckMarkButton.visible = YES;
}

-(void) setSecondPlayerHandicapInvisible
{
    secondPlayerHandicapLeftBorder.visible = NO;
    secondPlayerHandicapRightBorder.visible = NO;
    secondPlayerHandicapGuideLine.visible = NO;
    secondPlayerHandicapFirstLine.visible = NO;
    secondPlayerHandicapSecondLine.visible = NO;
    handicapLabel2.visible = NO;
    secondPlayerHandicapCheckMarkButton.visible = NO;
}

-(void) secondPlayerHandicap
{
    int handicapLinesSpacing;
    
    if (deviceIsWidescreen) {
        
        handicapLinesSpacing = 40;
    }
    
    if (!deviceIsWidescreen) {
        
        handicapLinesSpacing = 0;
    }
    
    secondPlayerHandicapLeftBorder = [CCLabelBMFont labelWithString:@"|" fntFile:@"Casual.fnt"];
    secondPlayerHandicapLeftBorder.position = ccp(174 + handicapLinesSpacing, 30 + 150);
    [linedPaper addChild: secondPlayerHandicapLeftBorder z: 300];
    
    secondPlayerHandicapRightBorder = [CCLabelBMFont labelWithString:@"|" fntFile:@"Casual.fnt"];
    secondPlayerHandicapRightBorder.position = ccp(304 + handicapLinesSpacing, 30 + 150);
    [linedPaper addChild: secondPlayerHandicapRightBorder z: 300];
    
    secondPlayerHandicapGuideLine = [CCLabelBMFont labelWithString:@"-" fntFile:@"Casual.fnt"];
    secondPlayerHandicapGuideLine.position = ccp(239 + handicapLinesSpacing, 30 + 150);
    secondPlayerHandicapGuideLine.scaleX = 12.0;
    [linedPaper addChild: secondPlayerHandicapGuideLine z: 300];
    
    
    secondPlayerHandicapFirstLine = [CCLabelBMFont labelWithString:@"|" fntFile:@"Casual.fnt"];
    secondPlayerHandicapFirstLine.position = ccp(218 + handicapLinesSpacing, 30 + 150);
    secondPlayerHandicapFirstLine.scale = 0.7;
    [linedPaper addChild: secondPlayerHandicapFirstLine z: 300];
    
    secondPlayerHandicapSecondLine = [CCLabelBMFont labelWithString:@"|" fntFile:@"Casual.fnt"];
    secondPlayerHandicapSecondLine.position = ccp(262 + handicapLinesSpacing, 30 + 150);
    secondPlayerHandicapSecondLine.scale = 0.7;
    [linedPaper addChild: secondPlayerHandicapSecondLine z: 300];
    
    handicapLabel2 = [CCLabelBMFont labelWithString:@"handicap" fntFile:@"Casual.fnt"];
    handicapLabel2.position = ccp(239 + handicapLinesSpacing, 10 + 185);
    handicapLabel2.scale = 0.4;
    handicapLabel2.anchorPoint = ccp(0.5, 0.5);
    [linedPaper addChild: handicapLabel2 z: 300];
    
    secondPlayerHandicapCheckMarkButton = [CCSprite spriteWithFile: @"CheckMarkButton.png"];
    secondPlayerHandicapCheckMarkButton.scale = 0.25;
    secondPlayerHandicapCheckMarkButton.position = secondPlayerHandicapLeftBorder.position;
    [linedPaper addChild: secondPlayerHandicapCheckMarkButton z: 310];
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
        
        secondPlayerHandicapLeftBorder.scale = 1.0;
        secondPlayerHandicapRightBorder.scale = 1.0;
        secondPlayerHandicapGuideLine.scaleX = 12.0;
        secondPlayerHandicapGuideLine.scaleY = 1.0;
        secondPlayerHandicapFirstLine.scale = 0.7;
        secondPlayerHandicapSecondLine.scale = 0.7;
        handicapLabel2.scale = 0.4;
    }
    
    else {
        
        secondPlayerHandicapLeftBorder.scale = 1.0/2;
        secondPlayerHandicapRightBorder.scale = 1.0/2;
        secondPlayerHandicapGuideLine.scaleX = 12.0/2;
        secondPlayerHandicapGuideLine.scaleY = 1.0/2;
        secondPlayerHandicapFirstLine.scale = 0.7/2;
        secondPlayerHandicapSecondLine.scale = 0.7/2;
        handicapLabel2.scale = 0.4/2;
    }
    
    [self setSecondPlayerHandicapInvisible];
}



- (id) initWithSaved:(BOOL)loadIt
{
    
	if( (self=[super init] )) {
        
        if ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON ) {
            
            deviceIsWidescreen = YES;
        }
        
        else {
            
            deviceIsWidescreen = NO;
        }
        
        
        NSString *reqSysVer = @"6.0";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending) {
            
            NSLog (@"deviceIsRunningiOS6 = %i", deviceIsRunningiOS6);
            deviceIsRunningiOS6 = YES;
        }
        
        else {
            
            NSLog (@"deviceIsRunningiOS6 = %i", deviceIsRunningiOS6);
            deviceIsRunningiOS6 = NO;
        }
        
        dot = [CCSprite spriteWithFile: @"whiteCircle.png"];
        dot.scale = 0.2;
        [zoombase addChild: dot];
        
        bPAD = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
        
        gameSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"GameSpriteSheet.png"];
        [self addChild:gameSpriteSheet];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"GameSpriteSheet.plist"];
        
        CCSpriteBatchNode *tamagachiSprites;
        tamagachiSprites = [CCSpriteBatchNode batchNodeWithFile:@"TamagachiSpriteSheet.png"];
        [self addChild:tamagachiSprites];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"TamagachiSpriteSheet.plist"];
        
        CCSpriteBatchNode *mainMenuSprites;
        mainMenuSprites = [CCSpriteBatchNode batchNodeWithFile:@"MainMenuSpriteSheet.png"];
        [self addChild:mainMenuSprites];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"MainMenuSpriteSheet.plist"];
        
        //Setting this to true in order to transition MainMenuScene into Game scene
        isSinglePlayer = YES;
        
        self.bannerIsVisible = YES;
        
        if (!isPlayer1) {
            
            colorReceivedFromPlayer1 = NO;
        }
        
        //isSinglePlayer = NO;
        isPlayer1 = YES;
        
        //currentLevel refers to background not difficulty
        currentLevel = 1;
        
        chargedShotTimeTotal = chargedShotTimeEnded - chargedShotTimeStarted + blockingChargeBonusPlayer1 + skillLevelBonus*3;
        
        bonusPoints1 = 0;
        bonusPoints2 = 0;
        /*
         //DEBUG: set this to NO to play tutorial
         //inGameTutorialHasAlreadyBeenPlayedOnce = NO;
         */
        
        handicapCoefficientPlayer1 = 1.0;
        handicapCoefficientPlayer2 = 1.0;
        firstPlayerHandicapCheckMarkButtonTouched = NO;
        secondPlayerHandicapCheckMarkButtonTouched = NO;
        inGameCountdownStarted = NO;
        gertySlotAnimationIsRunning = NO;
        gerty2SlotAnimationIsRunning = NO;
        tamagachiColorReceivedFromPlayer1 = NO;
        tamagachiColorReceivedFromPlayer2 = NO;
        playerHasIPodTouch = NO;
        player1ReadyToStartInGameCountdown = NO;
        player2ReadyToStartInGameCountdown = NO;
        speechBubbleColorSwatchIsTopLayer = YES;
        playerCanZoomOutAgain = YES;
        playerCanZoomInAgain = YES;
        indexCard1ReadyToTouch = NO;
        indexCard2ReadyToTouch = NO;
        playbuttonPushed = NO;
        //stage = NIGHT_TIME_SUBURB;
        //stage = DAY_TIME_SUBURB;
        doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = YES;
        doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = YES;
        pingAnswered = NO;
        opponentDisconnected = NO;
        speechBubbleWillShow = NO;
        tamagachi1Color = TAMAGACHI_1_RED;
        tamagachi2Color = TAMAGACHI_2_RED;
        player2BombInPlay = YES;
        marblePlayer2IsReadyToSling = YES;
        prelaunchDelayTime = 0;
        sentPingTime = 0;
        receivedPingTime = 0;
        pingTime = 0;
        otherPlayerWishesToPlayAgain = NO;
        firstMatchWithThisPlayer = YES;
        woodBlockTouched = NO;
        woodBlock2Touched = NO;
        woodBlock3Touched = NO;
        lightningStrikePlayer1Ready = YES;
        lightningStrikePlayer2Ready = YES;
        isAtMainMenu = YES;
        doNotShowMarblePointFinger1 = NO;
        doNotShowMarblePointFinger2 = NO;
        player1ProjectileCanBeTouchedAgain = YES;
        player2ProjectileCanBeTouchedAgain = YES;
        player1IsTheWinnerScriptHasBeenPlayed = NO;
        player2IsTheWinnerScriptHasBeenPlayed = NO;
        player1LightningExists = NO;
        player2LightningExists = NO;
        totalSoundSources = 0;
        sourceIDNumber = 0;
        sling1SourceIDNumber = 0;
        sling1SourceIDNumber2 = 0;
        sling1SourceIDNumber3 = 0;
        sling1SourceIDNumber4 = 0;
        sling1SourceIDNumber5 = 0;
        sling1SourceIDNumber6 = 0;
        sling1SourceIDNumber7 = 0;
        sling1SourceIDNumber8 = 0;
        sling1SourceIDNumber9 = 0;
        sling1SourceIDNumber10 = 0;
        sling1SourceIDNumber11 = 0;
        sling1SourceIDNumber12 = 0;
        sling1SourceIDNumber13 = 0;
        sling1SourceIDNumber14 = 0;
        sling1SourceIDNumber15 = 0;
        sling1SourceIDNumber16 = 0;
        sling1SourceIDNumber17 = 0;
        sling1SourceIDNumber18 = 0;
        sling1SourceIDNumber19 = 0;
        sling1SourceIDNumber20 = 0;
        sling1SourceIDNumber21 = 0;
        sling1SourceIDNumber22 = 0;
        sling1SourceIDNumber23 = 0;
        sling1SourceIDNumber24 = 0;
        sling1SourceIDNumber25 = 0;
        sling1SourceIDNumber26 = 0;
        sling1SourceIDNumber27 = 0;
        sling1SourceIDNumber28 = 0;
        sling1SourceIDNumber29 = 0;
        sling1SourceIDNumber30 = 0;
        sling2SourceIDNumber = 0;
        sling2SourceIDNumber2 = 0;
        sling2SourceIDNumber3 = 0;
        sling2SourceIDNumber4 = 0;
        
        destroyedBlocksInARow1 = 0;
        destroyedBlocksInARow2 = 0;
        increaseBigSmokeTimeInterval1 = 0.16;
        increaseBigSmokeTimeInterval2 = 0.16;
        gridLayerPosition = 0;
        playersCanTouchMarblesNow = NO;
        lightAircraftPassingBySoundsReadyToPlay = YES;
        dogBarkingSoundsReadyToPlay = YES;
        passingCarSoundsReadyToPlay = YES;
        windChimesSoundsReadyToPlay = YES;
        startingSequenceBegan = NO;
        player1ExperiencePointsToAdd = 0;
        player1GertyShouldBeDead = NO;
        player2GertyShouldBeDead = NO;
        computerNumberOfChargingRounds = 0;
        player1SlingIsSmoking = NO;
        player2SlingIsSmoking = NO;
        computerSettingNewVelocityandMovingBomb = NO;
        player1GiantSmokeCloudFrontOpacityIsIncreasing = YES;
        player2GiantSmokeCloudFrontOpacityIsIncreasing = YES;
        player1GiantSmokeCloudFrontOpacity = 0;
        player1GiantSmokeCloudBackOpacity = 0;
        player2GiantSmokeCloudFrontOpacity = 0;
        player2GiantSmokeCloudBackOpacity = 0;
        player1ProjectileIsZappable = YES;
        player2ProjectileIsZappable = YES;
        isGo = NO;
        waitingForStartup = YES;
        gamePaused = NO;
        guideLineIsBlinking = NO;
        bombHasHitRectangleHenceNoBonus1 = NO;
        bombHasHitRectangleHenceNoBonus2 = NO;
        skillLevelBonus = 0;
        chargedShotTimeEnded = 0;
        chargedShotTimeStarted = 0;
        player1Winner = NO;
        player2Winner = NO;
        player1ProjectileHasBeenTouched = NO;
        player2ProjectileHasBeenTouched = NO;
        firstPlayer1MarbleSetToGreen = NO;
        firstPlayer2MarbleSetToGreen = NO;
        player1BombZapped = NO;
        player2BombZapped = NO;
        fieldZoomedOut = YES;
        player1BombIsAirborne = NO;
        player2BombIsAirborne = NO;
        readyToReceiveBlocksPositionsFromPlayer1 = NO;
        readyToReceiveBlockNumbersFromPlayer2 = NO;
        readyForEnemyToFire = NO;
        readyForEnemyToBlock = NO;
        blockingChargeBonusPlayer1 = 0;
        blockingChargeBonusPlayer2 = 0;
        projectileChargingPitchPlayer1 = 0;
        projectileChargingPitchPlayer2 = 0;
        receivingChargingDataFromPlayer1 = NO;
        receivingChargingDataFromPlayer2 = NO;
        
        
        player1HasGreenBall = NO;
        player1HasRedBall = NO;
        player1HasBlueBall = NO;
        player1HasYellowBall = NO;
        player1HasBlackBall = NO;
        player2HasGreenBall = NO;
        player2HasRedBall = NO;
        player2HasBlueBall = NO;
        player2HasYellowBall = NO;
        player2HasBlackBall = NO;
        
        [self loadGameSettings];
        
        //[self runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.4], [CCCallFunc actionWithTarget:self selector:@selector(startiCloudSyncing)], [CCCallFunc actionWithTarget:self selector:@selector(syncLabels)], nil]];
        
        self.position = ccp(0, 0);
        
        parallaxNode = [CCParallaxNode node];
        //parallaxNode.anchorPoint = ccp(0, 0);
        [self addChild: parallaxNode z:-10000];
        //[parallaxNode setPosition: ccp(0,0)];
        
        projectileCollisionForceMultiplier = 0.3;
        
        // Completely transparent base to attach things that do scroll or zoom
        zoombase = [CCLayerColor layerWithColor:ccc4(0,0,0,0)];
        
        mainMenuLayer = [CCLayerColor layerWithColor:ccc4(0,0,0,0)];
        [self addChild: mainMenuLayer z:5];
        
        hudLayer = [CCLayerColor layerWithColor:ccc4(0,0,0,0)];
        hudLayer.position = ccp(0, 0);
        [self addChild:hudLayer z: 10];
        [hudLayer runAction: [CCMoveTo actionWithDuration: 0.0 position: ccp(0, -460)]];
        
        threeLabel = [CCSprite spriteWithSpriteFrameName: @"GoldNumber3-hd.png"];
        [hudLayer addChild:threeLabel z:10000];
        threeLabel.position = ccp(-300 , -300);
        
        twoLabel = [CCSprite spriteWithSpriteFrameName: @"GoldNumber2-hd.png"];
        [hudLayer addChild:twoLabel z:10000];
        twoLabel.position = ccp(-300 , -300);
        
        oneLabel = [CCSprite spriteWithSpriteFrameName: @"GoldNumber1-hd.png"];
        [hudLayer addChild:oneLabel z:10000];
        oneLabel.position = ccp(-300 , -300);
        
        gCharacterInGoLabel = [CCSprite spriteWithSpriteFrameName: @"GoldLetterG-hd.png"];
        [hudLayer addChild:gCharacterInGoLabel z:10000];
        gCharacterInGoLabel.position = ccp(-300 , -300);
        
        oCharacterInGoLabel = [CCSprite spriteWithSpriteFrameName: @"GoldLetterO-hd.png"];
        [hudLayer addChild:oCharacterInGoLabel z:10000];
        oCharacterInGoLabel.position = ccp(-300 , -300);
        
        exclamationCharacterInGoLabel = [CCSprite spriteWithSpriteFrameName: @"GoldExclamationPoint-hd.png"];
        [hudLayer addChild:exclamationCharacterInGoLabel z:10000];
        exclamationCharacterInGoLabel.position = ccp(-300 , -300);
        
        microphoneOn = [CCSprite spriteWithFile: @"microphone on.png"];
        [hudLayer addChild: microphoneOn z:151];
        microphoneOn.position = ccp(18, 18);
        microphoneOn.scale = 0.122;
        microphoneOn.visible = NO;
        
        microphoneOff = [CCSprite spriteWithFile: @"microphone off.png"];
        [hudLayer addChild: microphoneOff z:151];
        microphoneOff.position = ccp(18, 18);
        microphoneOff.scale = 0.122;
        microphoneOff.visible = NO;
        
        //winnerLabel = [CCLabelTTF labelWithString:@"Winner!" fontName:@"Marker Felt" fontSize:48];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGPoint centerOfScreen = ccp(winSize.width/2, winSize.height/2);
        
        int labelPositionOffset;
        
        if (deviceIsWidescreen) {
            
            labelPositionOffset = 0;
        }
        
        if (!deviceIsWidescreen) {
            
            labelPositionOffset = 0;
        }
        
        winnerLabel = [CCLabelBMFont labelWithString:@"Winner!"  fntFile:@"CasualWhite.fnt"];
        winnerLabel.position = ccp(centerOfScreen.x + labelPositionOffset, centerOfScreen.y);
        [hudLayer addChild:winnerLabel z:10];
        winnerLabel.visible = NO;
        
        // lostLabel = [CCLabelTTF labelWithString:@"You Lost!" fontName:@"Marker Felt"fontSize:48];
        lostLabel = [CCLabelBMFont labelWithString:@"You Lost!"  fntFile:@"CasualWhite.fnt"];
        lostLabel.position = ccp(centerOfScreen.x + labelPositionOffset, centerOfScreen.y);
        [hudLayer addChild:lostLabel z:10];
        lostLabel.visible = NO;
        
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
            
            winnerLabel.scale = 2.0;
            lostLabel.scale = 2.0;
        }
        
        else {
            
            winnerLabel.scale = 2.0/2;
            lostLabel.scale = 2.0/2;
        }
        
        if (restartingLevel == NO && continuePlayingLevelFromVictoryScreen == NO) {
            
            linedPaper = [CCSprite spriteWithSpriteFrameName: @"linedPaper-hd.jpg"];
            [hudLayer addChild: linedPaper z:15];
            linedPaper.scale = 1.5;
            linedPaper.anchorPoint = ccp(0, 0);
            linedPaper.position = ccp(0,-460);
            [linedPaper runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(0,0)]];
        }
        
        else if (restartingLevel == YES && continuePlayingLevelFromVictoryScreen == NO) {
            
            linedPaper = [CCSprite spriteWithSpriteFrameName: @"linedPaper-hd.jpg"];
            [hudLayer addChild: linedPaper z:15];
            linedPaper.scale = 1.5;
            linedPaper.anchorPoint = ccp(0, 0);
            linedPaper.position = ccp(0,-200);
            [linedPaper runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(0,-550)]];
        }
        
        else if (continuePlayingLevelFromVictoryScreen == YES) {
            
            linedPaper = [CCSprite spriteWithSpriteFrameName: @"linedPaper-hd.jpg"];
            [hudLayer addChild: linedPaper z:15];
            linedPaper.scale = 1.5;
            linedPaper.anchorPoint = ccp(0, 0);
            linedPaper.position = ccp(0,0);
        }
        
        getReadyLabel = [CCLabelBMFont labelWithString:@"Get Ready!"  fntFile:@"Casual.fnt"];
        
        [linedPaper addChild: getReadyLabel];
        getReadyLabel.color = ccBLACK;
        
        if (deviceIsWidescreen) {
            
            getReadyLabel.position = ccp([linedPaper contentSize].width/2 - 12, [linedPaper contentSize].height/2 + 136);
        }
        
        if (!deviceIsWidescreen) {
            
            getReadyLabel.position = ccp([linedPaper contentSize].width/2 - 35, [linedPaper contentSize].height/2 + 136);
        }
        
        getReadyLabel.visible = NO;
        
        backToMainMenu = [CCSprite spriteWithSpriteFrameName: @"mainMenuButton-hd.png"];
        [linedPaper addChild: backToMainMenu z: 100];
        backToMainMenu.position = ccp([linedPaper contentSize].width/2 - 100, [linedPaper contentSize].height/2 + 116);
        backToMainMenu.scale = 0.31;
        backToMainMenu.visible = NO;
        
        backToMainMenu2 = [CCSprite spriteWithSpriteFrameName: @"mainMenuButton-hd.png"];
        [hudLayer addChild: backToMainMenu2 z: 15000];
        backToMainMenu2.position = ccp(23, 23);
        backToMainMenu2.scale = 0.31;
        backToMainMenu2.visible = NO;
        
        continuePlayingGame = [CCSprite spriteWithSpriteFrameName: @"playButton-hd.png"];
        [linedPaper addChild: continuePlayingGame];
        
        int continuePlayingGamePositionOffset;
        
        if (deviceIsWidescreen) {
            
            continuePlayingGamePositionOffset = 35;
        }
        
        if (!deviceIsWidescreen) {
            
            continuePlayingGamePositionOffset = 0;
        }
        
        continuePlayingGame.position = ccp(([linedPaper contentSize].width/2 - 35 + continuePlayingGamePositionOffset), [linedPaper contentSize].height/2 + 116);
        continuePlayingGame.scale = 0.41;
        continuePlayingGame.visible = NO;
        
        restartLevel = [CCSprite spriteWithSpriteFrameName: @"restartLevel-hd.png"];
        [linedPaper addChild: restartLevel];
        restartLevel.position = ccp([linedPaper contentSize].width/2 + 30, [linedPaper contentSize].height/2 + 116);
        parallaxNode.visible = NO;
        restartLevel.scale = 0.31;
        restartLevel.visible = NO;
        
        pauseButton = [CCSprite spriteWithSpriteFrameName: @"PauseButton-hd.png"];
        pauseButton.position = ccp(18, 18);
        pauseButton.opacity = 175;
        pauseButton.scale = 0.5;
        [hudLayer addChild: pauseButton z:100];
        pauseButton.visible = NO;
        
        scaleCoefficient = 0.9;
        rightPanningBound = 100;
        leftPanningBound = -220;
        topPanningBound = -110;
        bottomPanningBound = 75;
        
        carpet = [CCSprite spriteWithFile: @"Carpet.png"];
        carpet.anchorPoint = ccp(0,0);
        carpet.position = ccp(0,0);
        carpet.scale = 0.8;
        [mainMenuLayer addChild: carpet];
        
        if (deviceIsWidescreen) {
            
            [carpet runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.3], [CCEaseIn actionWithAction: [CCScaleTo actionWithDuration: 1 scale: 0.56] rate: 2.0], nil]];
        }
        
        else if (!deviceIsWidescreen) {
            
            [carpet runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.3], [CCEaseIn actionWithAction: [CCScaleTo actionWithDuration: 1 scale: 0.5] rate: 2.0], nil]];
        }
        
        if (currentLevel == 1) {
            /*
             [[CCTextureCache sharedTextureCache] addImage: @"Layer 3 Curtains.png"];
             [[CCTextureCache sharedTextureCache] addImage: @"Layer 3 Curtains blur.png"];
             [[CCTextureCache sharedTextureCache] addImage: @"Layer 2 Chairs.png"];
             [[CCTextureCache sharedTextureCache] addImage: @"Layer 2 Chairs blur.png"];
             [[CCTextureCache sharedTextureCache] addImage: @"Layer 1 Outside.png"];
             [[CCTextureCache sharedTextureCache] addImage: @"Layer 1 Outside blur.png"];
             */
            
            
            //Background Pictures
            curtains = [CCSprite spriteWithSpriteFrameName:@"Layer 3 Curtains-hd.png"];
            curtains.scale = 1.6;
            curtains.position = ccp(280,160);
            
            if (userIsOnFastDevice) {
                
                curtainsBlur = [CCSprite spriteWithSpriteFrameName:@"Layer 3 Curtains blur-hd.png"];
                curtainsBlur.scale = 1.6;
                curtainsBlur.position = ccp(280,160);
            }
            
            chairs = [CCSprite spriteWithSpriteFrameName:@"Layer 2 Chairs-hd.png"];
            chairs.scale = 1.9;
            chairs.position = ccp(280,220);
            
            if (userIsOnFastDevice) {
                
                chairsBlur = [CCSprite spriteWithSpriteFrameName:@"Layer 2 Chairs blur-hd.png"];
                chairsBlur.scale = 1.9;
                chairsBlur.position = ccp(280,220);
            }
            
            outside = [CCSprite spriteWithSpriteFrameName:@"Layer 1 Outside-hd.png"];
            outside.scale = 0.7;
            outside.position = ccp(280,160);
            
            if (userIsOnFastDevice) {
                
                outsideBlur = [CCSprite spriteWithSpriteFrameName:@"Layer 1 Outside blur-hd.png"];
                outsideBlur.scale = 0.7;
                outsideBlur.position = ccp(280,160);
            }
            
            if (!userIsOnFastDevice) {
                
                //Fade In Crisp Background Images
                [chairs runAction: [CCFadeIn actionWithDuration: 0.0]];
                [curtains runAction: [CCFadeIn actionWithDuration: 0.0]];
                [outside runAction: [CCFadeIn actionWithDuration: 0.0]];
            }
            
            if (userIsOnFastDevice) {
                
                //Fade Out Blurred Background Images
                [chairsBlur runAction: [CCFadeOut actionWithDuration: 0.0]];
                [curtainsBlur runAction: [CCFadeOut actionWithDuration: 0.0]];
                [outsideBlur runAction: [CCFadeOut actionWithDuration: 0.0]];
            }
            
            if (!bPAD) {
                
                if (deviceIsWidescreen) {
                    
                    [parallaxNode addChild: zoombase z:5 parallaxRatio:ccp(1,1) positionOffset:ccp(-28,-24)];
                    [parallaxNode addChild: chairs z:3 parallaxRatio:ccp(0.4,0.4) positionOffset:ccp(50 + 23,100)];
                    [parallaxNode addChild: curtains z:1 parallaxRatio:ccp(0.2,0.2) positionOffset:ccp(20 + 30,0)];
                    [parallaxNode addChild: outside z: 0 parallaxRatio:ccp(0.03,0.03) positionOffset:ccp(170 + 75,125)];
                }
                
                else if (!deviceIsWidescreen) {
                    
                    [parallaxNode addChild: zoombase z:5 parallaxRatio:ccp(1,1) positionOffset:ccp(-39,-24)];
                    [parallaxNode addChild: chairs z:3 parallaxRatio:ccp(0.4,0.4) positionOffset:ccp(50,132)];
                    [parallaxNode addChild: curtains z:1 parallaxRatio:ccp(0.2,0.2) positionOffset:ccp(20,0)];
                    [parallaxNode addChild: outside z: 0 parallaxRatio:ccp(0.03,0.03) positionOffset:ccp(170,125)];
                }
                
                if (userIsOnFastDevice && !deviceIsWidescreen) {
                    
                    [parallaxNode addChild: chairsBlur z:3 parallaxRatio:ccp(0.4,0.4) positionOffset:ccp(70,135)];
                    [parallaxNode addChild: curtainsBlur z:1 parallaxRatio:ccp(0.2,0.2) positionOffset:ccp(20,0)];
                    [parallaxNode addChild: outsideBlur z: 0 parallaxRatio:ccp(0.03,0.03) positionOffset:ccp(170,125)];
                }
                
                else if (deviceIsWidescreen) {
                    
                    [parallaxNode addChild: chairsBlur z:3 parallaxRatio:ccp(0.4,0.4) positionOffset:ccp(70,135)];
                    [parallaxNode addChild: curtainsBlur z:1 parallaxRatio:ccp(0.2,0.2) positionOffset:ccp(20,0)];
                    [parallaxNode addChild: outsideBlur z: 0 parallaxRatio:ccp(0.03,0.03) positionOffset:ccp(170 + 50,125)];
                }
            }
            // self.position = ccp(510,380);
            else {
                
                [parallaxNode addChild: zoombase z:5 parallaxRatio:ccp(1,1) positionOffset:ccp(-39 - 30,-24-30)];
                [parallaxNode addChild: chairs z:3 parallaxRatio:ccp(0.4,0.4) positionOffset:ccp(50 + 310,132 + 240)];
                [parallaxNode addChild: curtains z:1 parallaxRatio:ccp(0.2,0.2) positionOffset:ccp(20 + 510,0 + 380)];
                [parallaxNode addChild: outside z: 0 parallaxRatio:ccp(0.03,0.03) positionOffset:ccp(170 + 510,125 + 380)];
                
                if (userIsOnFastDevice) {
                    
                    [parallaxNode addChild: chairsBlur z:3 parallaxRatio:ccp(0.4,0.4) positionOffset:ccp(70 + 310,135 + 240)];
                    [parallaxNode addChild: curtainsBlur z:1 parallaxRatio:ccp(0.2,0.2) positionOffset:ccp(20 + 510,0 + 380)];
                    [parallaxNode addChild: outsideBlur z: 0 parallaxRatio:ccp(0.03,0.03) positionOffset:ccp(170 + 510,125)];
                }
            }
            
        }
        
        /*
         else if (currentLevel == 2) {
         
         [[CCTextureCache sharedTextureCache] addImage: @"Layer 3 - Couch.png"];
         [[CCTextureCache sharedTextureCache] addImage: @"Layer 3 - Couch blurry.png"];
         [[CCTextureCache sharedTextureCache] addImage: @"Layer 2 - Orchid.png"];
         [[CCTextureCache sharedTextureCache] addImage: @"Layer 2 - Orchid blurry.png"];
         [[CCTextureCache sharedTextureCache] addImage: @"Layer 1 - Table.png"];
         
         //Background Pictures
         orchid = [CCSprite spriteWithFile:@"Layer 2 - Orchid.png"];
         orchid.scale = 0.95;
         orchid.anchorPoint = ccp(0.5, 0);
         orchid.position = ccp(0,0);
         orchidBlurry = [CCSprite spriteWithFile:@"Layer 2 - Orchid blurry.png"];
         orchidBlurry.scale = 0.95;
         orchidBlurry.anchorPoint = ccp(0.5, 0);
         orchidBlurry.position = ccp(0,0);
         
         couch = [CCSprite spriteWithFile:@"Layer 3 - Couch.png"];
         couch.scale = 0.45;
         couch.anchorPoint = ccp(0.5, 0);
         couch.position = ccp(50,50);
         couchBlurry = [CCSprite spriteWithFile:@"Layer 3 - Couch blurry.png"];
         couchBlurry.scale = 0.45;
         couchBlurry.anchorPoint = ccp(0.5, 0);
         couchBlurry.position = ccp(0,0);
         
         //Fade Out Crisp Background Images
         [couchBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
         [orchidBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
         
         //Fade In Blurred Background Images
         [couch runAction: [CCFadeIn actionWithDuration: 0.0]];
         [orchid runAction: [CCFadeIn actionWithDuration: 0.0]];
         
         
         [parallaxNode addChild: zoombase z:5 parallaxRatio:ccp(1,1) positionOffset:ccp(-39,-24)];
         [parallaxNode addChild: couch z:0 parallaxRatio:ccp(0.4,0.4) positionOffset:ccp(280,0)];
         [parallaxNode addChild: couchBlurry z:0 parallaxRatio:ccp(0.4,0.4) positionOffset:ccp(280,-50)];
         [parallaxNode addChild: orchid z:1 parallaxRatio:ccp(0.7,0.2) positionOffset:ccp(200,10)];
         [parallaxNode addChild: orchidBlurry z:1 parallaxRatio:ccp(0.7,1) positionOffset:ccp(200,-120)];
         }
         
         else if (currentLevel == 3) {
         
         [[CCTextureCache sharedTextureCache] addImage: @"Layer 3 - Couch.png"];
         [[CCTextureCache sharedTextureCache] addImage: @"Layer 3 - Couch blurry.png"];
         [[CCTextureCache sharedTextureCache] addImage: @"Layer 2 - Orchid.png"];
         [[CCTextureCache sharedTextureCache] addImage: @"Layer 2 - Orchid blurry.png"];
         [[CCTextureCache sharedTextureCache] addImage: @"Layer 1 - Table.png"];
         
         //Background Pictures
         faucet = [CCSprite spriteWithFile:@"Layer 2 - Faucet.png"];
         faucet.scale = 0.95;
         faucet.anchorPoint = ccp(0.5, 0);
         faucet.position = ccp(0,0);
         faucetBlurry = [CCSprite spriteWithFile:@"Layer 2 - Faucet blurry.png"];
         faucetBlurry.scale = 0.95;
         faucetBlurry.anchorPoint = ccp(0.5, 0);
         faucetBlurry.position = ccp(0,0);
         
         wallAndCouch = [CCSprite spriteWithFile:@"Layer 3 - Wall and Couch.png"];
         wallAndCouch.scale = 0.45;
         wallAndCouch.anchorPoint = ccp(0.5, 0);
         wallAndCouch.position = ccp(50,50);
         wallAndCouchBlurry = [CCSprite spriteWithFile:@"Layer 3 - Wall and Couch blurry.png"];
         wallAndCouchBlurry.scale = 0.45;
         wallAndCouchBlurry.anchorPoint = ccp(0.5, 0);
         wallAndCouchBlurry.position = ccp(0,0);
         
         kitchenOutside = [CCSprite spriteWithFile:@"Layer 4 - Outside.png"];
         kitchenOutside.scale = 0.45;
         kitchenOutside.anchorPoint = ccp(0.5, 0);
         kitchenOutside.position = ccp(50,50);
         kitchenOutsideBlurry = [CCSprite spriteWithFile:@"Layer 4 - Outside blurry.png"];
         kitchenOutsideBlurry.scale = 0.45;
         kitchenOutsideBlurry.anchorPoint = ccp(0.5, 0);
         kitchenOutsideBlurry.position = ccp(0,0);
         
         //Fade Out Blurry Background Images
         [faucetBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
         [wallAndCouchBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
         [kitchenOutsideBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
         
         //Fade In Crisp Background Images
         [faucet runAction: [CCFadeIn actionWithDuration: 0.0]];
         [wallAndCouch runAction: [CCFadeIn actionWithDuration: 0.0]];
         [kitchenOutside runAction: [CCFadeIn actionWithDuration: 0.0]];
         
         [parallaxNode addChild: zoombase z:5 parallaxRatio:ccp(1,1) positionOffset:ccp(-39,-24)];
         [parallaxNode addChild: kitchenOutside z:0 parallaxRatio:ccp(0.02,0.02) positionOffset:ccp(280,0)];
         [parallaxNode addChild: kitchenOutsideBlurry z:0 parallaxRatio:ccp(0.02,0.02) positionOffset:ccp(280,-50)];
         [parallaxNode addChild: wallAndCouch z:1 parallaxRatio:ccp(0.05,0.05) positionOffset:ccp(280,-5)];
         [parallaxNode addChild: wallAndCouchBlurry z:1 parallaxRatio:ccp(0.05,0.05) positionOffset:ccp(280,-5)];
         [parallaxNode addChild: faucet z:3 parallaxRatio:ccp(0.7,0.2) positionOffset:ccp(225,10)];
         [parallaxNode addChild: faucetBlurry z:3 parallaxRatio:ccp(0.7,1) positionOffset:ccp(225,-120)];
         }
         
         else if (currentLevel == 4) {
         
         //Background Pictures
         tvRoomCouch = [CCSprite spriteWithFile:@"Layer 2 - TV Room Couch.png"];
         tvRoomCouch.scale = 1.6;
         tvRoomCouch.position = ccp(280,160);
         tvRoomCouchBlurry = [CCSprite spriteWithFile:@"Layer 2 - TV Room Couch blurry.png"];
         tvRoomCouchBlurry.scale = 1.6;
         tvRoomCouchBlurry.position = ccp(280,160);
         
         tvRoomOutside = [CCSprite spriteWithFile:@"Layer 3 - TV Room Outside.png"];
         tvRoomOutside.scale = 0.7;
         tvRoomOutside.position = ccp(280,160);
         tvRoomOutsideBlurry = [CCSprite spriteWithFile:@"Layer 3 - TV Room Outside blurry.png"];
         tvRoomOutsideBlurry.scale = 0.7;
         tvRoomOutsideBlurry.position = ccp(280,160);
         
         //Fade Out Blurry Background Images
         [tvRoomCouchBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
         [tvRoomOutsideBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
         
         //Fade In Crisp Background Images
         [tvRoomCouch runAction: [CCFadeIn actionWithDuration: 0.0]];
         [tvRoomOutside runAction: [CCFadeIn actionWithDuration: 0.0]];
         
         
         [parallaxNode addChild: zoombase z:5 parallaxRatio:ccp(1,1) positionOffset:ccp(-39,-24)];
         [parallaxNode addChild: tvRoomCouch z:1 parallaxRatio:ccp(0.2,0.2) positionOffset:ccp(255,160)];
         [parallaxNode addChild: tvRoomCouchBlurry z:1 parallaxRatio:ccp(0.2,0.2) positionOffset:ccp(255,160)];
         [parallaxNode addChild: tvRoomOutside z: 0 parallaxRatio:ccp(0.03,0.03) positionOffset:ccp(310,100)];
         [parallaxNode addChild: tvRoomOutsideBlurry z: 0 parallaxRatio:ccp(0.03,0.03) positionOffset:ccp(310,100)];
         }
         
         else if (currentLevel == 6) {
         
         fridgeBackground = [CCSprite spriteWithFile:@"Layer 2 - Fridge Background.png"];
         fridgeBackground.scale = 0.45;
         fridgeBackground.anchorPoint = ccp(0.5, 0);
         fridgeBackground.position = ccp(50,50);
         fridgeBackgroundBlurry = [CCSprite spriteWithFile:@"Layer 2 - Fridge Background blurry.png"];
         fridgeBackgroundBlurry.scale = 0.45;
         fridgeBackgroundBlurry.anchorPoint = ccp(0.5, 0);
         fridgeBackgroundBlurry.position = ccp(0,0);
         
         //Fade Out Blurred Background Images
         [fridgeBackgroundBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
         
         //Fade In Crisp Background Images
         [fridgeBackground runAction: [CCFadeIn actionWithDuration: 0.0]];
         
         [parallaxNode addChild: zoombase z:5 parallaxRatio:ccp(1,1) positionOffset:ccp(-39,-24)];
         [parallaxNode addChild: fridgeBackground z:0 parallaxRatio:ccp(0.05,0.05) positionOffset:ccp(280,-115)];
         [parallaxNode addChild: fridgeBackgroundBlurry z:0 parallaxRatio:ccp(0.05,0.05) positionOffset:ccp(280,-115)];
         }
         
         else if (currentLevel == 7) {
         
         //Background Pictures
         wallAndDoor = [CCSprite spriteWithFile:@"Layer 3 - Wall and Door.png"];
         wallAndDoor.scale = 1.6;
         wallAndDoor.position = ccp(280,160);
         wallAndDoorBlurry = [CCSprite spriteWithFile:@"Layer 3 - Wall and Door blurry.png"];
         wallAndDoorBlurry.scale = 1.6;
         wallAndDoorBlurry.position = ccp(280,160);
         
         sideBanister = [CCSprite spriteWithFile:@"Layer 2 - Banister.png"];
         sideBanister.scale = 1.9;
         sideBanister.position = ccp(280,220);
         sideBanisterBlurry = [CCSprite spriteWithFile:@"Layer 2 - Banister blurry.png"];
         sideBanisterBlurry.scale = 1.9;
         sideBanisterBlurry.position = ccp(280,220);
         
         outsideBalcony = [CCSprite spriteWithFile:@"Layer 4 - Outside Balcony.png"];
         outsideBalcony.scale = 0.7;
         outsideBalcony.position = ccp(280,160);
         outsideBalconyBlurry = [CCSprite spriteWithFile:@"Layer 4 - Outside Balcony blurry.png"];
         outsideBalconyBlurry.scale = 0.7;
         outsideBalconyBlurry.position = ccp(280,160);
         
         //Fade Out Crisp Background Images
         [sideBanister runAction: [CCFadeOut actionWithDuration: 0.0]];
         [wallAndDoor runAction: [CCFadeOut actionWithDuration: 0.0]];
         [outsideBalcony runAction: [CCFadeOut actionWithDuration: 0.0]];
         
         //Fade In Blurred Background Images
         [sideBanisterBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
         [wallAndDoorBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
         [outsideBalconyBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
         
         
         [parallaxNode addChild: zoombase z:5 parallaxRatio:ccp(1,1) positionOffset:ccp(-39,-24)];
         [parallaxNode addChild: sideBanister z:3 parallaxRatio:ccp(0.4,0.4) positionOffset:ccp(50,132)];
         [parallaxNode addChild: wallAndDoor z:1 parallaxRatio:ccp(0.2,0.2) positionOffset:ccp(20,0)];
         [parallaxNode addChild: outsideBalcony z: 0 parallaxRatio:ccp(0.03,0.03) positionOffset:ccp(170,125)];
         [parallaxNode addChild: sideBanisterBlurry z:3 parallaxRatio:ccp(0.4,0.4) positionOffset:ccp(70,135)];
         [parallaxNode addChild: wallAndDoorBlurry z:1 parallaxRatio:ccp(0.2,0.2) positionOffset:ccp(20,0)];
         [parallaxNode addChild: outsideBalconyBlurry z: 0 parallaxRatio:ccp(0.03,0.03) positionOffset:ccp(170,125)];
         }
         */
        
        shapes = [[NSArray alloc] init];
        shapesArrayPlayer2 = [[NSArray alloc] init];
        shapesArrayPlayer2ToSend = [[NSMutableArray alloc] init];
        shapesMutableArrayPlayer1 = [[NSMutableArray alloc] init];
        shapesArrayFromPlayer2 = [[NSMutableArray alloc] init];
        shapesArrayFromPlayer1 = [[NSMutableArray alloc] init];
        shapesPositions = [[NSMutableArray alloc] init];
        shapeIDAndPositions = [[NSMutableDictionary alloc] init];
        shapesDictionary2 = [[NSMutableDictionary alloc] init];
        shapesAngles = [[NSMutableDictionary alloc] init];
        shapesAnglesDictionaryFromPlayer2 = [[NSMutableDictionary alloc] init];
        allShapesTemporaryNSArray = [[NSArray alloc] init];
        allShapesFromLocalDevice = [[NSMutableArray alloc] init];
        shapesArrayInPlayer2 = [[NSMutableArray alloc] init];
        shapesArrayInPlayer1 = [[NSMutableArray alloc] init];
        player1ShapeHashID = [[NSMutableArray alloc] init];
        
        /*
         // Turn on UIGesture recognizers
         panGestureRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)] autorelease];
         panGestureRecognizer.delegate = self;
         
         */
        /* UILongPressGestureRecognizer *tapAndHold = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapAndHold:)] autorelease];
         tapAndHold.delegate = self;
         tapAndHold.minimumPressDuration = 0.6;
         */
        
        pinchGestureRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchFrom:)] autorelease];
        pinchGestureRecognizer.delegate = self;
        
        
        doubleTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(handleDoubleTapFrom:)] autorelease];
        doubleTap.delegate = self;
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.numberOfTouchesRequired = 1;
        
        //Add Tutorial 1 Index Card
        indexCard = [CCSprite spriteWithFile: @"notecard.png"];
        indexCard.scale = 0.75*2;
        indexCard.position = ccp(-1000, -1000);
        indexCard.anchorPoint = ccp(0, 1);
        [hudLayer addChild: indexCard z:5];
        
        //Add checkmark1 to indexCard
        checkMark1 = [CCSprite spriteWithFile: @"CheckMarkButton.png"];
        checkMark1.scale = 0.5;
        checkMark1.position = ccp (237, checkMark1.position.y + 10);
        [indexCard addChild: checkMark1 z: 10];
        checkMark1.visible = NO;
        
        
        //Add 'Attack' to index card
        attackLabel = [CCLabelBMFont labelWithString:@"Attack"  fntFile:@"Casual.fnt"];
        [indexCard addChild: attackLabel z:10];
        attackLabel.color = ccBLACK;
        attackLabel.position = ccp([indexCard contentSize].width/2, [indexCard contentSize].height/2 + 64);
        
        //Add first 'How to Play' index card frame1
        howToPlayFrame1 = [CCSprite spriteWithFile: @"Tutorial1A.png"];
        howToPlayFrame1.scale = 1.0;
        [indexCard addChild: howToPlayFrame1];
        howToPlayFrame1.position = ccp([indexCard contentSize].width/2, [indexCard contentSize].height/2);
        howToPlayFrame1.visible = NO;
        
        //Add first 'How to Play' index card frame2
        howToPlayFrame2 = [CCSprite spriteWithFile: @"Tutorial1B.png"];
        howToPlayFrame2.scale = 1.0;
        [indexCard addChild: howToPlayFrame2];
        howToPlayFrame2.position = ccp([indexCard contentSize].width/2, [indexCard contentSize].height/2);
        howToPlayFrame2.visible = NO;
        
        //Add first 'How to Play' index card frame3
        howToPlayFrame3 = [CCSprite spriteWithFile: @"Tutorial1C.png"];
        howToPlayFrame3.scale = 1.0;
        [indexCard addChild: howToPlayFrame3];
        howToPlayFrame3.position = ccp([indexCard contentSize].width/2, [indexCard contentSize].height/2);
        howToPlayFrame3.visible = NO;
        
        //Add first 'How to Play' index card frame4
        howToPlayFrame4 = [CCSprite spriteWithFile: @"Tutorial1D.png"];
        howToPlayFrame4.scale = 1.0;
        [indexCard addChild: howToPlayFrame4];
        howToPlayFrame4.position = ccp([indexCard contentSize].width/2, [indexCard contentSize].height/2);
        howToPlayFrame4.visible = NO;
        
        //Add first 'How to Play' index card frame5
        howToPlayFrame5 = [CCSprite spriteWithFile: @"Tutorial1E.png"];
        howToPlayFrame5.scale = 1.0;
        [indexCard addChild: howToPlayFrame5];
        howToPlayFrame5.position = ccp([indexCard contentSize].width/2, [indexCard contentSize].height/2);
        howToPlayFrame5.visible = NO;
        
        //Add first 'How to Play' index card frame6
        howToPlayFrame6 = [CCSprite spriteWithFile: @"Tutorial1F.png"];
        howToPlayFrame6.scale = 1.0;
        [indexCard addChild: howToPlayFrame6];
        howToPlayFrame6.position = ccp([indexCard contentSize].width/2, [indexCard contentSize].height/2);
        howToPlayFrame6.visible = NO;
        
        //Add first 'How to Play' index card frame7
        howToPlayFrame7 = [CCSprite spriteWithFile: @"Tutorial1G.png"];
        howToPlayFrame7.scale = 1.0;
        [indexCard addChild: howToPlayFrame7];
        howToPlayFrame7.position = ccp([indexCard contentSize].width/2, [indexCard contentSize].height/2);
        howToPlayFrame7.visible = NO;
        
        //Add first 'How to Play' index card frame8
        howToPlayFrame8 = [CCSprite spriteWithFile: @"Tutorial1H.png"];
        howToPlayFrame8.scale = 1.0;
        [indexCard addChild: howToPlayFrame8];
        howToPlayFrame8.position = ccp([indexCard contentSize].width/2, [indexCard contentSize].height/2);
        howToPlayFrame8.visible = NO;
        
        //Add first 'How to Play' index card frame9
        howToPlayFrame9 = [CCSprite spriteWithFile: @"Tutorial1I.png"];
        howToPlayFrame9.scale = 1.0;
        [indexCard addChild: howToPlayFrame9];
        howToPlayFrame9.position = ccp([indexCard contentSize].width/2, [indexCard contentSize].height/2);
        howToPlayFrame9.visible = NO;
        
        
        //Add Tutorial 2 index card
        indexCard2 = [CCSprite spriteWithFile: @"notecard.png"];
        indexCard2.scale = 0.75*2;
        indexCard2.position = ccp(-1000, -1000);
        indexCard2.anchorPoint = ccp(0, 1);
        [hudLayer addChild: indexCard2 z:1];
        
        //Add 'Attack' to index card
        defendLabel = [CCLabelBMFont labelWithString:@"Defend"  fntFile:@"Casual.fnt"];
        [indexCard2 addChild: defendLabel z:1];
        defendLabel.color = ccBLACK;
        defendLabel.position = ccp([indexCard2 contentSize].width/2, [indexCard2 contentSize].height/2 + 64);
        defendLabel.visible = NO;
        
        //Add checkmark2 to indexCard2
        checkMark2 = [CCSprite spriteWithFile: @"CheckMarkButton.png"];
        checkMark2.scale = 0.5;
        checkMark2.position = ccp (237, checkMark2.position.y + 10);
        [indexCard2 addChild: checkMark2 z: 10];
        checkMark2.visible = NO;
        
        //Add first 'How to Play' index card frame1
        howToDefendFrame1 = [CCSprite spriteWithFile: @"Tutorial2A.png"];
        howToDefendFrame1.scale = 1.0;
        [indexCard2 addChild: howToDefendFrame1];
        howToDefendFrame1.position = ccp([indexCard contentSize].width/2, [indexCard contentSize].height/2);
        howToDefendFrame1.visible = NO;
        
        //Add first 'How to Play' index card frame2
        howToDefendFrame2 = [CCSprite spriteWithFile: @"Tutorial2B.png"];
        howToDefendFrame2.scale = 1.0;
        [indexCard2 addChild: howToDefendFrame2];
        howToDefendFrame2.position = ccp([indexCard contentSize].width/2, [indexCard contentSize].height/2);
        howToDefendFrame2.visible = NO;
        
        //Add first 'How to Play' index card frame3
        howToDefendFrame3 = [CCSprite spriteWithFile: @"Tutorial2C.png"];
        howToDefendFrame3.scale = 1.0;
        [indexCard2 addChild: howToDefendFrame3];
        howToDefendFrame3.position = ccp([indexCard contentSize].width/2, [indexCard contentSize].height/2);
        howToDefendFrame3.visible = NO;
        
        //Add first 'How to Play' index card frame4
        howToDefendFrame4 = [CCSprite spriteWithFile: @"Tutorial2D.png"];
        howToDefendFrame4.scale = 1.0;
        [indexCard2 addChild: howToDefendFrame4];
        howToDefendFrame4.position = ccp([indexCard contentSize].width/2, [indexCard contentSize].height/2);
        howToDefendFrame4.visible = NO;
        
        int whiteProgressDotPositionOffset;
        
        if (deviceIsWidescreen) {
            
            whiteProgressDotPositionOffset = 20;
        }
        
        if (!deviceIsWidescreen) {
            
            whiteProgressDotPositionOffset = 0;
        }
        
        whiteProgressDot1 = [CCSprite spriteWithFile: @"whiteCircle.png"];
        whiteProgressDot1.position = ccp(([linedPaper contentSize].width/2 - 68 + whiteProgressDotPositionOffset), [linedPaper contentSize].height/2 - 120);
        whiteProgressDot1.color = ccBLACK;
        whiteProgressDot1.scale = 0.05;
        [linedPaper addChild: whiteProgressDot1];
        
        whiteProgressDot2 = [CCSprite spriteWithFile: @"whiteCircle.png"];
        whiteProgressDot2.position = ccp(([linedPaper contentSize].width/2 - 53 + whiteProgressDotPositionOffset), [linedPaper contentSize].height/2 - 120);
        whiteProgressDot2.color = ccBLACK;
        whiteProgressDot2.scale = 0.05;
        [linedPaper addChild: whiteProgressDot2];
        
        whiteProgressDot3 = [CCSprite spriteWithFile: @"whiteCircle.png"];
        whiteProgressDot3.position = ccp(([linedPaper contentSize].width/2 - 38 + whiteProgressDotPositionOffset), [linedPaper contentSize].height/2 - 120);
        whiteProgressDot3.color = ccBLACK;
        whiteProgressDot3.scale = 0.05;
        [linedPaper addChild: whiteProgressDot3];
        
        whiteProgressDot4 = [CCSprite spriteWithFile: @"whiteCircle.png"];
        whiteProgressDot4.position = ccp(([linedPaper contentSize].width/2 - 23 + whiteProgressDotPositionOffset), [linedPaper contentSize].height/2 - 120);
        whiteProgressDot4.color = ccBLACK;
        whiteProgressDot4.scale = 0.05;
        [linedPaper addChild: whiteProgressDot4];
        
        whiteProgressDot5 = [CCSprite spriteWithFile: @"whiteCircle.png"];
        whiteProgressDot5.position = ccp(([linedPaper contentSize].width/2 - 8 + whiteProgressDotPositionOffset), [linedPaper contentSize].height/2 - 120);
        whiteProgressDot5.color = ccBLACK;
        whiteProgressDot5.scale = 0.05;
        [linedPaper addChild: whiteProgressDot5];
        
        
        if (isSinglePlayer) {
            
            whiteProgressDot1.visible = NO;
            whiteProgressDot2.visible = NO;
            whiteProgressDot3.visible = NO;
            whiteProgressDot4.visible = NO;
            whiteProgressDot5.visible = NO;
        }
        
        //[singleTapGestureRecognizer requireGestureRecognizerToFail: doubleTap];
        
        // Add them to the director
        //[[[CCDirector sharedDirector] openGLView] addGestureRecognizer:tapAndHold];
        [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:pinchGestureRecognizer];
        //   [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:doubleTap];
        //   [[[CCDirector sharedDirector] openGLView] addGestureRecognizer:panGestureRecognizer];
        
        
        _bombsPlayer1 = [[NSMutableArray array] retain];
        
        _bombsPlayer2 = [[NSMutableArray array] retain];
        
        //allocate our space manager
        smgr = [[SpaceManagerCocos2d alloc] init];
        smgr.constantDt = 1.0/60.0;
        
        cpSpaceResizeStaticHash(smgr.space, 40.0f, 40);
        cpSpaceResizeActiveHash(smgr.space, 60.0f, 500);
        smgr.space->elasticIterations = NO;
        smgr.space->iterations = 1;
        smgr.rehashStaticEveryStep = NO;
        
        [smgr addCollisionCallbackBetweenType:kNinjaCollisionType
                                    otherType:kGroundCollisionType
                                       target:self
                                     selector:@selector(handleNinjaCollision:arbiter:space:)
                                      moments:COLLISION_POSTSOLVE,nil];
        [smgr addCollisionCallbackBetweenType:kNinjaCollisionType
                                    otherType:kBlockCollisionType
                                       target:self
                                     selector:@selector(handleNinjaCollision:arbiter:space:)
                                      moments:COLLISION_POSTSOLVE,nil];
        [smgr addCollisionCallbackBetweenType:kNinjaCollisionType
                                    otherType:kBombCollisionType
                                       target:self
                                     selector:@selector(handleNinjaCollision:arbiter:space:)
                                      moments:COLLISION_POSTSOLVE,nil];
        
        [smgr addCollisionCallbackBetweenType:kGertyCollisionType
                                    otherType:kBombCollisionType
                                       target:self
                                     selector:@selector(handleGertyCollision:arbiter:space:)
                                      moments:COLLISION_POSTSOLVE,nil];
        
        [smgr addCollisionCallbackBetweenType:kGerty2CollisionType
                                    otherType:kBombCollisionType
                                       target:self
                                     selector:@selector(handleGerty2Collision:arbiter:space:)
                                      moments:COLLISION_POSTSOLVE,nil];
        
        [smgr addCollisionCallbackBetweenType:kBombCollisionType
                                    otherType:kGroundCollisionType
                                       target:self
                                     selector:@selector(handleBombCollision:arbiter:space:)
                                      moments:COLLISION_POSTSOLVE,nil];
        
        [smgr addCollisionCallbackBetweenType:kBlockCollisionType
                                    otherType:kBombCollisionType
                                       target:self
                                     selector:@selector(handleBlockCollision:arbiter:space:)
                                      moments:COLLISION_BEGIN, COLLISION_POSTSOLVE, nil];
        
        [smgr addCollisionCallbackBetweenType:kTriangleBlockCollisionType
                                    otherType:kGroundCollisionType
                                       target:self
                                     selector:@selector(handleTriangleBlockCollision:arbiter:space:)
                                      moments:COLLISION_POSTSOLVE,nil];
        
        [smgr addCollisionCallbackBetweenType:kBlockCollisionType
                                    otherType:kBlockCollisionType
                                       target:self
                                     selector:@selector(handleBlockTumbleCollision:arbiter:space:)
                                      moments:COLLISION_BEGIN, COLLISION_POSTSOLVE,nil];
        
        [smgr addCollisionCallbackBetweenType:kTriangleBlockCollisionType
                                    otherType:kBlockCollisionType
                                       target:self
                                     selector:@selector(handleTriangleBlockCollision:arbiter:space:)
                                      moments:COLLISION_POSTSOLVE,nil];
        
        [smgr addCollisionCallbackBetweenType:kTriangleBlockCollisionType
                                    otherType:kBombCollisionType
                                       target:self
                                     selector:@selector(handleTriangleBlockCollision:arbiter:space:)
                                      moments:COLLISION_POSTSOLVE,nil];
        
        
        
        [self zoomOut];
        [self timer];
        
        if (isSinglePlayer) {
            
            [self gertyMainMenu];
            [self woodBlock];
            [self gertyMainMenuUpdateLights];
            
            //    [(Gerty2*)gerty2 chooseComputerGertyColor];
            //    [(Gerty2*)gerty2 setComputerGertyColor];
            //    tamagachi.visible = NO;
            
            //    [carpet addChild: tamagachi];
        }
        
        if (isSinglePlayer) {
            
            //[self gertyComputer];
            //[self gertySinglePlayer];
        }
        
        //[self addChild:[smgr createDebugLayer]];
        
        //start the manager!
        [smgr start];
        [self schedule: @selector(step:)];
        
        if (restartingLevel == YES) {
            
            playButton.visible = NO;
        }
        
        ourRandom = arc4random();
        [self setGameState:kGameStateWaitingForMatch];
        
        parallaxNode.position = ccp(-39,-24);
        
        if ([UIScreen instancesRespondToSelector:@selector(scale)])
        {
            CGFloat scale = [[UIScreen mainScreen] scale];
            
            if (scale > 1.0) {
                
                isRetinaDisplay = YES;
                //    winnerLabel.scale = 2.0;
                //    lostLabel.scale = 2.0;
            }
            
            else {
                isRetinaDisplay = NO;
            }
        }
    }
    
    /*
     else if (!isSinglePlayer) {
     
     // pillarConfiguration = 3;
     pillarConfiguration = 3;
     }
     */
    if (continuePlayingLevelFromVictoryScreen == YES) {
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.0], [CCCallFunc actionWithTarget:self selector:@selector(startLevelWithCountDown)], nil]];
    }
    
    player1ExperiencePointsForLabel = player1ExperiencePoints;
    player1LevelForLabel = player1Level;
    player1MarblesUnlockedForLabel = player1MarblesUnlocked;
    
    if (firstTimeLoadingGameScene == NO) {
        
        carpet.scale = 0.5;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    
    reach = [Reachability reachabilityForInternetConnection];
    netStatus = [reach currentReachabilityStatus];
    
    if (netStatus == NotReachable) {
        
        NSLog(@"No internet connection!");
    }
    
    
    /*
     SKProduct *product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex: 0];
     
     NSLog (@"product title objectAtIndex 0 = %@", product.localizedTitle);
     
     CCLabelBMFont *inAppPurchase1 = [CCLabelBMFont labelWithString:product.localizedTitle fntFile:@"Casual.fnt"];
     [woodblock2 addChild: inAppPurchase1 z: 10000];
     //loadingStore.position = ccp(240, 80);
     */
    
    [self updateLocksOverColorSwatchesAndMarbleList];
    
    h = [[UIDeviceHardware alloc] init];
    NSLog (@"Device type = %@", [h platformString]);
    
    if ([[h platformString] isEqualToString:@"iPod Touch 1G"] || [[h platformString] isEqualToString:@"iPod Touch 2G"] || [[h platformString] isEqualToString:@"iPod Touch 3G"] || [[h platformString] isEqualToString:@"iPod Touch 4G"]) {
        
        playerHasIPodTouch = YES;
        
        if (headsetIsPluggedIn) {
            
            [[CDAudioManager sharedManager] setMode:kAMM_PlayAndRecord];
        }
        
        else {
            
            [[CDAudioManager sharedManager] setMode:kAMM_FxPlusMusic];
        }
    }
    
    
    [CDSoundEngine setMixerSampleRate:CD_SAMPLE_RATE_MID];
    
    if (!playerHasIPodTouch) {
        
        [CDAudioManager initAsynchronously:kAMM_PlayAndRecord];
    }
    
    else {
        
        [CDAudioManager initAsynchronously:kAMM_FxPlusMusic];
    }
    
    while ([CDAudioManager sharedManagerState] != kAMStateInitialised) {}
    
    am = [CDAudioManager sharedManager];
    
    if (!playerHasIPodTouch) {
        
        [[CDAudioManager sharedManager] setMode:kAMM_PlayAndRecord];
    }
    
    else {
        
        [[CDAudioManager sharedManager] setMode:kAMM_FxPlusMusic];
    }
    
    
    UInt32 doChangeDefaultRoute = 1;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof (doChangeDefaultRoute), &doChangeDefaultRoute);
    
    soundEngine = [CDAudioManager sharedManager].soundEngine;
    
    
    defs = [NSArray arrayWithObjects:
            [NSNumber numberWithInt:550], nil];
    [soundEngine defineSourceGroups:defs];
    
    
    
    [self playThemeMusic];
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
        
        loadingStore.scale = 0.35;
        getReadyLabel.scale = 1.0;
        attackLabel.scale = 0.75;
        defendLabel.scale = 0.75;
    }
    
    else {
        
        loadingStore.scale = 0.35/2;
        getReadyLabel.scale = 1.0/2;
        attackLabel.scale = 0.75/2;
        defendLabel.scale = 0.75/2;
    }
    
    [self updateTamagachiMainMenuColor];
    [self gertyMainMenuUpdateLights];
    
    self.state = kGameStatePlaying;
    
    [self firstPlayerHandicap];
    [self secondPlayerHandicap];
    
    //DEBUG: Uncomment the following to allow handicap guidelines to show during single player
    //[linedPaper runAction: [CCSequence actions: [CCMoveTo actionWithDuration:0.0 position:ccp(0,0)], [CCCallFunc actionWithTarget:self selector:@selector(setFirstPlayerHandicapVisible)], [CCCallFunc actionWithTarget:self selector:@selector(setSecondPlayerHandicapVisible)], nil]];
    
	return self;
}

- (void)dismissHUD:(id)arg {
    
    //  loadingStore.visible = NO;
}

- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    loadingStore.visible = NO;
    
    int product_length = [[InAppRageIAPHelper sharedHelper].products count];
    
    for (int i = 0; i < product_length; i++) {
        
		product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:i];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[numberFormatter setLocale:product.priceLocale];
		NSString *formattedString = [numberFormatter stringFromNumber:product.price];
        
        NSLog (@"product title objectAtIndex 0 = %@", product.localizedTitle);
        
        inAppPurchase1 = [CCLabelBMFont labelWithString:product.localizedTitle fntFile:@"Casual.fnt"];
        [speechBubble addChild: inAppPurchase1 z: 10000];
        inAppPurchase1.position = ccp(93, 135 - 40*i);
        inAppPurchase1.scale = 0.65;
        [player1LevelLabelMainMenu setString: [NSString stringWithFormat:@"Rank: %i", player1Level/100]];
        
        buyButton1Label = [CCLabelBMFont labelWithString: [NSString stringWithFormat:@"%@", product.price] fntFile:@"Casual.fnt"];
        [speechBubble addChild: buyButton1Label];
        buyButton1Label.scale = 1.0;
        buyButton1Label.position = ccp(200, 135 - 40*i);
        buyButton1.visible = YES;
        buyButton2.visible = YES;
        buyButton3.visible = YES;
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
            
            inAppPurchase1.scale = 0.7/2;
            buyButton1Label.scale = 0.5;
        }
        
        else {
            
            inAppPurchase1.scale = 0.7/4;
            buyButton1Label.scale = 0.25;
        }
    }
    
    NSLog (@"productsLoaded method");
    
    NSLog (@"products count = %i", product_length);
}

- (void)timeout:(id)arg {
    
    CCLabelBMFont *timedOut = [CCLabelBMFont labelWithString:@"Timed Out" fntFile:@"Casual.fnt"];
    [hudLayer addChild: timedOut z: 10000];
    
    NSLog (@"Timed Out Loading Store");
    
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
}


-(void) isGo
{
    isGo = YES;
}

-(void) readyForEnemyToFireMethod
{
    
}


-(void) readyForEnemyToBlock
{
    
}

-(void) parallaxNodeVisibleToYes
{
    parallaxNode.visible = YES;
}

-(void) updateLightValueToBothPlayers
{
    if (isPlayer1) {
        
        [self sendUnlockedMarblesValue1];
    }
    
    else if (!isPlayer1) {
        
        [self sendUnlockedMarblesValue2];
    }
}

-(void) makePauseButtonVisible
{
    pauseButton.visible = YES;
}

-(void) startInGameCountdown
{
    inGameCountdownStarted = YES;
    
    [self multiplayerInGameCountdownProgressDotsAnimation];
    
    [linedPaper runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 6.0], [CCMoveTo actionWithDuration: 1.0 position: ccp(linedPaper.position.x, -400)], nil]];
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 6.0], [CCCallFunc actionWithTarget:self selector:@selector(getReadyLabelVisible)], nil]];
    
    [linedPaper runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 8.0], [CCMoveTo actionWithDuration: 0.2 position: ccp(linedPaper.position.x, -550)], nil]];
    
    
    //If device is not running iOS6, shift the y coordinate a bit.  Also, only zoom in and pan back and forth if device is running iOS6.  This particular section pans the camera to the 1st player's side
    if (deviceIsRunningiOS6 == YES && userIsOnFastDevice && !deviceIsWidescreen) {
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 8.0], [CCCallFunc actionWithTarget:self selector:@selector(zoomInForStartup)], nil]];
        
        [parallaxNode runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 8.0], [CCMoveTo actionWithDuration: 0.25 position: ccp(190,142)], nil]];
    }
    
    else if (deviceIsWidescreen) {
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 8.0], [CCCallFunc actionWithTarget:self selector:@selector(zoomInForStartup)], nil]];
        
        [parallaxNode runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 8.0], [CCMoveTo actionWithDuration: 0.25 position: ccp(325,142)], nil]];
    }
    
    
    //[self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 8.0], [CCCallFunc actionWithTarget:self selector:@selector(zoomInForStartup)], nil]];
    
    
    int parallaxNodePositionOffset;
    
    if (deviceIsWidescreen) {
        
        parallaxNodePositionOffset = 325;
    }
    
    if (!deviceIsWidescreen) {
        
        parallaxNodePositionOffset = 190;
    }
    
    if (userIsOnFastDevice || deviceIsWidescreen) {
        
        [parallaxNode runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 8.0], [CCMoveTo actionWithDuration: 0.25 position: ccp(parallaxNodePositionOffset, 142)], nil]];
        
        [parallaxNode runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 9.0], [CCMoveTo actionWithDuration: 0.25 position: ccp(-241,142)], nil]];
    }
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 10.0], [CCCallFunc actionWithTarget:self selector:@selector(zoomOut)], nil]];
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 10.2], [CCCallFunc actionWithTarget:self selector:@selector(isGo)], nil]];
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 10.2], [CCCallFunc actionWithTarget:self selector:@selector(getReadyLabelNotVisible)], nil]];
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CGPoint centerOfScreen = ccp(winSize.width/2, winSize.height/2);
    
    //three animation
    //three set size big, fade out fully
    [threeLabel runAction: [CCFadeOut actionWithDuration: 0.0]];
    [threeLabel runAction: [CCScaleTo actionWithDuration: 0.0 scale:2]];
    //three center into place
    [threeLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 8.0], [CCMoveTo actionWithDuration: 0.0 position: centerOfScreen], nil]];
    //three scale smaller, fade in fully
    [threeLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 8.0], [CCScaleTo actionWithDuration:0.3 scale:0.5], nil]];
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 8.3], [CCCallFunc actionWithTarget:self selector:@selector(playCountdownBlip)], nil]];
    [threeLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 8.0], [CCFadeIn actionWithDuration:0.3], nil]];
    //three move awawy
    [threeLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 9.0],[CCMoveTo actionWithDuration: 0.0 position: ccp(-300, -300)], nil]];
    
    //two animation
    [twoLabel runAction: [CCFadeOut actionWithDuration: 0.0]];
    [twoLabel runAction: [CCScaleTo actionWithDuration: 0.0 scale:2]];
    //two center into place
    [twoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 9.0], [CCMoveTo actionWithDuration: 0.0 position: centerOfScreen], nil]];
    //two scale smaller, fade in fully
    [twoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 9.0], [CCScaleTo actionWithDuration:0.3 scale:0.5], nil]];
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 9.3], [CCCallFunc actionWithTarget:self selector:@selector(playCountdownBlip)], nil]];
    [twoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 9.0], [CCFadeIn actionWithDuration:0.3], nil]];
    //two move awawy
    [twoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 10.0],[CCMoveTo actionWithDuration: 0.0 position: ccp(-300, -300)], nil]];
    
    //one animation
    [oneLabel runAction: [CCFadeOut actionWithDuration: 0.0]];
    [oneLabel runAction: [CCScaleTo actionWithDuration: 0.0 scale:2]];
    //one center into place
    [oneLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 10.0], [CCMoveTo actionWithDuration: 0.0 position: centerOfScreen], nil]];
    //one scale smaller, fade in fully
    [oneLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 10.0], [CCScaleTo actionWithDuration:0.3 scale:0.5], nil]];
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 10.3], [CCCallFunc actionWithTarget:self selector:@selector(playCountdownBlip)], nil]];
    [oneLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 10.0], [CCFadeIn actionWithDuration:0.3], nil]];
    //one move awawy
    [oneLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 11.0],[CCMoveTo actionWithDuration: 0.0 position: ccp(-300, -300)], nil]];
    
    if (isSinglePlayer) {
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 11.3], [CCCallFunc actionWithTarget:self selector:@selector(makePauseButtonVisible)], nil]];
    }
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 11.3], [CCCallFunc actionWithTarget:self selector:@selector(playCountdownBlip)], nil]];
    
    int characterPositionOffset;
    
    if (deviceIsWidescreen) {
        
        characterPositionOffset = 20;
    }
    
    if (!deviceIsWidescreen) {
        
        characterPositionOffset = 0;
    }
    
    [gCharacterInGoLabel runAction: [CCFadeOut actionWithDuration: 0.0]];
    [gCharacterInGoLabel runAction: [CCScaleTo actionWithDuration: 0.0 scale:2]];
    //one center into place
    [gCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 11.0], [CCMoveTo actionWithDuration: 0.0 position: ccp(165 + characterPositionOffset, 160)], nil]];
    //one scale smaller, fade in fully
    [gCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 11.0], [CCScaleTo actionWithDuration:0.3 scale:0.5], nil]];
    [gCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 11.0], [CCFadeIn actionWithDuration:0.3], nil]];
    //one move awawy
    [gCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 12.0],[CCMoveTo actionWithDuration: 0.0 position: ccp(-300, -300)], nil]];
    
    [oCharacterInGoLabel runAction: [CCFadeOut actionWithDuration: 0.0]];
    [oCharacterInGoLabel runAction: [CCScaleTo actionWithDuration: 0.0 scale:2]];
    //one center into place
    [oCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 11.0], [CCMoveTo actionWithDuration: 0.0 position: ccp(260 + characterPositionOffset, 160)], nil]];
    //one scale smaller, fade in fully
    [oCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 11.0], [CCScaleTo actionWithDuration:0.3 scale:0.5], nil]];
    [oCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 11.0], [CCFadeIn actionWithDuration:0.3], nil]];
    //one move awawy
    [oCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 12.0],[CCMoveTo actionWithDuration: 0.0 position: ccp(-300, -300)], nil]];
    
    [exclamationCharacterInGoLabel runAction: [CCFadeOut actionWithDuration: 0.0]];
    [exclamationCharacterInGoLabel runAction: [CCScaleTo actionWithDuration: 0.0 scale:2]];
    //one center into place
    [exclamationCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 11.0], [CCMoveTo actionWithDuration: 0.0 position: ccp(325 + characterPositionOffset, 160)], nil]];
    //one scale smaller, fade in fully
    [exclamationCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 11.0], [CCScaleTo actionWithDuration:0.3 scale:0.5], nil]];
    [exclamationCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 11.0], [CCFadeIn actionWithDuration:0.3], nil]];
    //one move awawy
    [exclamationCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 12.0],[CCMoveTo actionWithDuration: 0.0 position: ccp(-300, -300)], nil]];
}

- (void)setupStringsWithOtherPlayerId:(NSString *)playerID {
    
    //To keep multiplayer from crashing, set some required variables in case they're missing
    if (stage == 0) {
        
        stage = 2;
    }
    
    if (tamagachi1Color == 0) {
        
        tamagachi1Color = 1;
    }
    
    if (tamagachi2Color == 0) {
        
        tamagachi2Color = 1;
    }
    
    if (isPlayer1) {
        
        //Player1 is good to go
        tamagachiColorReceivedFromPlayer1 = YES;
    }
    
    else if (!isPlayer1) {
        
        //Player2 is good to go
        tamagachiColorReceivedFromPlayer2 = YES;
    }
    
    if (isPlayer1) {
        
        pillarConfiguration = arc4random()%4;
    }
    
    NSLog (@"setupStringsWithOtherPlayerId running");
    
    getReadyLabel = [CCLabelBMFont labelWithString:@"Get Ready!"  fntFile:@"Casual.fnt"];
    
    [linedPaper addChild: getReadyLabel];
    getReadyLabel.color = ccBLACK;
    
    if (deviceIsWidescreen) {
        
        getReadyLabel.position = ccp([linedPaper contentSize].width/2 - 12, [linedPaper contentSize].height/2 + 136);
    }
    
    if (!deviceIsWidescreen) {
        
        getReadyLabel.position = ccp([linedPaper contentSize].width/2 - 35, [linedPaper contentSize].height/2 + 136);
    }
    
    getReadyLabel.visible = NO;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
        
        getReadyLabel.scale = 1.0;
    }
    
    else {
        
        getReadyLabel.scale = 1.0/2;
    }
    
    [self stopAllActions];
    
    [mainMenuMusic stopBackgroundMusic];
    musicIsPlaying = NO;
    
    playButton = [CCSprite spriteWithSpriteFrameName: @"playButton-hd.png"];
    [linedPaper addChild: playButton];
    playButton.anchorPoint = ccp(0.5, 0.5);
    playButton.position = ccp([linedPaper contentSize].width/2 - 35, [linedPaper contentSize].height/2 -128);
    playButton.scale = 0.22;
    playButton.visible = NO;
    
    if (firstMatchWithThisPlayer == YES && !isSinglePlayer) {
        
        //If this is the first match with this player set handicaps to zero
        player1HandicapInteger = 0;
        player2HandicapInteger = 0;
        handicapCoefficientPlayer1 = 1;
        handicapCoefficientPlayer2 = 1;
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 7.0], [CCCallFunc actionWithTarget:self selector:@selector(timedOutMultiplayerMatch)], nil]];
        
        [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration:3.0], [CCCallFunc actionWithTarget:self selector:@selector(ping)], nil]]];
        //This will make sure the other player is still present during multiplayer
        [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration:15.0], [CCCallFunc actionWithTarget:self selector:@selector(setPingAnsweredToNo)], nil]]];
        
        microphoneOff.visible = YES;
        microphoneOn.visible = NO;
    }
    
    [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration:3.0], [CCCallFunc actionWithTarget:self selector:@selector(ping)], nil]]];
    //This will make sure the other player is still present during multiplayer
    [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration:15.0], [CCCallFunc actionWithTarget:self selector:@selector(setPingAnsweredToNo)], nil]]];
    
    pauseButton.visible = NO;
    
    dotPageIndicator1.visible = NO;
    dotPageIndicator2.visible = NO;
    dotPageIndicator3.visible = NO;
    
    opponentDisconnectedLabel.visible = NO;
    
    linedPaper.position = ccp(0,0);
    hudLayer.position = ccp(0,0);
    
    [linedPaper runAction: [CCSequence actions: [CCMoveTo actionWithDuration:0.0 position:ccp(0,0)], [CCCallFunc actionWithTarget:self selector:@selector(setFirstPlayerHandicapVisible)], [CCCallFunc actionWithTarget:self selector:@selector(setSecondPlayerHandicapVisible)], nil]];
    
    [hudLayer runAction: [CCSequence actions: [CCMoveTo actionWithDuration:0.0 position:ccp(0,0)], [CCCallFunc actionWithTarget:self selector:@selector(setIsAtMainMenuToNo)], [CCCallFunc actionWithTarget:self selector:@selector(moveMainMenuLayerDown)], nil]];
    
    if (isPlayer1) {
        
        player1MarblesUnlockedMultiplayerValue = player1MarblesUnlocked;
        player1LevelMultiplayerValue = player1Level;
        player1ExperiencePointsMultiplayerValue = player1ExperiencePoints;
        
        player1ExperiencePointsForLabel = player1ExperiencePoints;
        player1LevelForLabel = player1Level;
        player1MarblesUnlockedForLabel = player1MarblesUnlocked;
    }
    
    if (!isPlayer1) {
        
        player2ExperiencePointsForLabel = player1ExperiencePoints;
        player2LevelForLabel = player1Level;
        player2MarblesUnlockedForLabel = player1MarblesUnlocked;
        
        NSLog (@"I am player 2 and player2MarblesUnlockedForLabel = %i", player2MarblesUnlockedForLabel);
        
        player2MarblesUnlockedMultiplayerValue = player1MarblesUnlocked;
        player2LevelMultiplayerValue = player1Level;
        player2ExperiencePointsMultiplayerValue = player1ExperiencePoints;
    }
    
    NSLog (@"player1MarblesUnlockedMultiplayerValue = %i", player1MarblesUnlockedMultiplayerValue);
    NSLog (@"player2MarblesUnlockedMultiplayerValue = %i", player2MarblesUnlockedMultiplayerValue);
    
    if (isPlayer1) {
        
        if (firstMatchWithThisPlayer == YES) {
            
            player1Label = [CCLabelBMFont labelWithString:[GKLocalPlayer localPlayer].alias fntFile:@"Casual.fnt"];
            [linedPaper addChild:player1Label z:10000];
        }
        
        int playerLabelMultiplayerSpacing;
        
        if (deviceIsWidescreen) {
            
            playerLabelMultiplayerSpacing = 25;
        }
        
        if (!deviceIsWidescreen) {
            
            playerLabelMultiplayerSpacing = 0;
        }
        
        player1Label.position = ccp(([linedPaper contentSize].width/2 - 125 + playerLabelMultiplayerSpacing), [linedPaper contentSize].height/2 - 110);
        player1Label.color = ccBLACK;
        player1Label.scale = 0.4;
        player1Label.visible = YES;
        NSLog (@"I'm Player 1, [GKLocalPlayer localPlayer].alias = %@", [GKLocalPlayer localPlayer].alias);
        
        if (firstMatchWithThisPlayer == YES) {
            
            player = [[GCHelper sharedInstance].playersDict objectForKey:playerID];
            player2Label = [CCLabelBMFont labelWithString:player.alias fntFile:@"Casual.fnt"];
            [linedPaper addChild:player2Label z:10000];
        }
        
        player2Label.position = ccp(([linedPaper contentSize].width/2 + 45 + playerLabelMultiplayerSpacing), [linedPaper contentSize].height/2 - 110);
        player2Label.color = ccBLACK;
        player2Label.scale = 0.4;
        player2Label.visible = YES;
        //NSLog (@"I'm Player 1, player.alias = %@", player.alias);
        
        
        player1InGameLabelStringForPlayer1 = [NSString stringWithFormat:[GKLocalPlayer localPlayer].alias];
        player1InGameLabel = [CCLabelBMFont labelWithString:player1InGameLabelStringForPlayer1 fntFile:@"CasualWhite.fnt"];
        [zoombase addChild: player1InGameLabel z:1000];
        
        player1InGameLabel.position = ccp(125, 5);
        player1InGameLabel.color = ccWHITE;
        player1InGameLabel.scale = 0.5;
        player1InGameLabel.visible = YES;
        
        
        player2InGameLabelStringForPlayer1 = [NSString stringWithFormat:player.alias];
        player2InGameLabel = [CCLabelBMFont labelWithString:player2InGameLabelStringForPlayer1 fntFile:@"CasualWhite.fnt"];
        [zoombase addChild: player2InGameLabel z:1000];
        
        
        player2InGameLabel.position = ccp(440, 5);
        player2InGameLabel.color = ccWHITE;
        player2InGameLabel.scale = 0.5;
        player2InGameLabel.visible = YES;
        
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
            player1Label.scale = 0.8/2;
            player2Label.scale = 0.8/2;
            player1InGameLabel.scale = 1.2/2;
            player2InGameLabel.scale = 1.2/2;
        }
        
        else {
            
            player1Label.scale = 0.8/4;
            player2Label.scale = 0.8/4;
            player1InGameLabel.scale = 1.2/4;
            player2InGameLabel.scale = 1.2/4;
        }
        
        if (musicIsPlaying == YES) {
            
            [CDXPropertyModifierAction fadeBackgroundMusic:1.0f finalVolume:0.0f curveType:kIT_Linear shouldStop:NO];
            
            musicIsPlaying = NO;
        }
    }
    
    else {
        
        if (firstMatchWithThisPlayer == YES) {
            
            player2Label = [CCLabelBMFont labelWithString:[GKLocalPlayer localPlayer].alias fntFile:@"Casual.fnt"];
            [linedPaper addChild:player2Label z:10000];
        }
        
        int playerLabelMultiplayerSpacing;
        
        if (deviceIsWidescreen) {
            
            playerLabelMultiplayerSpacing = 25;
        }
        
        if (!deviceIsWidescreen) {
            
            playerLabelMultiplayerSpacing = 0;
        }
        
        player2Label.position = ccp(([linedPaper contentSize].width/2 + 45 + playerLabelMultiplayerSpacing), [linedPaper contentSize].height/2 - 110);
        player2Label.color = ccBLACK;
        player2Label.scale = 0.4;
        player2Label.visible = YES;
        NSLog (@"I'm Player2, [GKLocalPlayer localPlayer].alias = %@", [GKLocalPlayer localPlayer].alias);
        
        if (firstMatchWithThisPlayer == YES) {
            
            player2 = [[GCHelper sharedInstance].playersDict objectForKey:playerID];
            player1Label = [CCLabelBMFont labelWithString:player2.alias fntFile:@"Casual.fnt"];
            [linedPaper addChild:player1Label z:100];
        }
        
        player1Label.position = ccp(([linedPaper contentSize].width/2 - 125 + playerLabelMultiplayerSpacing), [linedPaper contentSize].height/2 - 110);
        player1Label.color = ccBLACK;
        player1Label.scale = 0.4;
        player2Label.visible = YES;
        NSLog (@"I'm Player 2, player2.alias = %@", player2.alias);
        
        
        player1InGameLabelStringForPlayer2 = [NSString stringWithFormat:player2.alias];
        player1InGameLabel = [CCLabelBMFont labelWithString:player1InGameLabelStringForPlayer2 fntFile:@"CasualWhite.fnt"];
        [zoombase addChild: player1InGameLabel z:100];
        
        
        player1InGameLabel.position = ccp(125, 5);
        player1InGameLabel.color = ccWHITE;
        player1InGameLabel.scale = 0.5;
        player1InGameLabel.visible = YES;
        
        
        player2InGameLabelStringForPlayer2 = [NSString stringWithFormat:[GKLocalPlayer localPlayer].alias];
        player2InGameLabel = [CCLabelBMFont labelWithString:player2InGameLabelStringForPlayer2 fntFile:@"CasualWhite.fnt"];
        [zoombase addChild: player2InGameLabel z:100];
        
        
        player2InGameLabel.position = ccp(440, 5);
        player2InGameLabel.color = ccWHITE;
        player2InGameLabel.scale = 0.5;
        player2InGameLabel.visible = YES;
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
            player1Label.scale = 0.8/2;
            player2Label.scale = 0.8/2;
            player1InGameLabel.scale = 1.2/2;
            player2InGameLabel.scale = 1.2/2;
        }
        
        else {
            
            player1Label.scale = 0.8/4;
            player2Label.scale = 0.8/4;
            player1InGameLabel.scale = 1.2/4;
            player2InGameLabel.scale = 1.2/4;
        }
        
        if (musicIsPlaying == YES) {
            
            //[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
            [CDXPropertyModifierAction fadeBackgroundMusic:1.0f finalVolume:0.0f curveType:kIT_Linear shouldStop:NO];
            
            musicIsPlaying = NO;
        }
    }
    
    [self parallaxNodeVisibleToYes];
    [self zoomOut];
    
    if (isPlayer1) {
        
        [self sendOpposingPlayersTamagachiColor];
    }
    
    if (stage == DAY_TIME_SUBURB) {
        
        //Set background colors to day time
        outside.color = ccc3(255, 255, 255);
        
        if (userIsOnFastDevice) {
            
            outsideBlur.color = ccc3(255, 255, 255);
        }
        
        curtains.color = ccc3(255, 255, 255);
        
        if (userIsOnFastDevice) {
            
            curtainsBlur.color = ccc3(255, 255, 255);
        }
        
        chairs.color = ccc3(255, 255, 255);
        
        if (userIsOnFastDevice) {
            
            chairsBlur.color = ccc3(255, 255, 255);
        }
        
        groundLevel.color = ccc3(255, 255, 255);
        sling1.color = ccc3(255, 255, 255);
        sling2.color = ccc3(255, 255, 255);
        sling1Stem.color = ccc3(255, 255, 255);
        sling1Player2.color = ccc3(255, 255, 255);
        sling2Player2.color = ccc3(255, 255, 255);
        sling2Stem.color = ccc3(255, 255, 255);
        
        //start playing sounds
        kidsPlayingSoundsReadyToPlay = YES;
        
        birdsBackgroundSounds = [SimpleAudioEngine sharedEngine];
        
        if (birdsBackgroundSounds != nil) {
            //[birdsBackgroundSounds preloadBackgroundMusic:@"SuburbanBirds.mp3"];
            if (birdsBackgroundSounds.willPlayBackgroundMusic) {
                birdsBackgroundSounds.backgroundMusicVolume = 0.02f;
            }
        }
        
        [birdsBackgroundSounds playBackgroundMusic:@"SuburbanBirds.mp3" loop:YES];
        
        //Subroutine that generates a random number to play windChimesBackgroundSounds
        [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfWindChimesSoundsRandomNumber)], [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfWindChimesSoundsRandomNumber)], nil]]];
        
        //Subroutine that generates a random number to play passingCarBackgroundSounds
        [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfPassingCarSoundsRandomNumber)], [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfPassingCarSoundsRandomNumber)], nil]]];
        
        //Subroutine that generates a random number to play DogBarkingBackgroundSounds
        [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfDogBarkingSoundsRandomNumber)], [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfDogBarkingSoundsRandomNumber)], nil]]];
        
        //Subroutine that generates a random number to play LightAircraftPassingByBackgroundSounds
        [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfLightAircraftPassingBySoundsRandomNumber)], [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfLightAircraftPassingBySoundsRandomNumber)], nil]]];
    }
    
    else if (stage == NIGHT_TIME_SUBURB) {
        
        //Set background colors to night time
        outside.color = ccc3(70, 130, 180);
        
        if (userIsOnFastDevice) {
            
            outsideBlur.color = ccc3(70, 130, 180);
        }
        
        curtains.color = ccc3(25, 25, 112);
        
        if (userIsOnFastDevice) {
            
            curtainsBlur.color = ccc3(25, 25, 112);
        }
        
        chairs.color = ccc3(25, 25, 112);
        
        if (userIsOnFastDevice) {
            
            chairsBlur.color = ccc3(25, 25, 112);
        }
        
        groundLevel.color = ccc3(25, 25, 112);
        sling1.color = ccc3(135, 206, 250);
        sling2.color = ccc3(135, 206, 250);
        sling1Stem.color = ccc3(135, 206, 250);
        sling1Player2.color = ccc3(135, 206, 250);
        sling2Player2.color = ccc3(135, 206, 250);
        sling2Stem.color = ccc3(135, 206, 250);
        
        SimpleAudioEngine *cricketsBackgroundSounds = [SimpleAudioEngine sharedEngine];
        
        if (cricketsBackgroundSounds != nil) {
            // [cricketsBackgroundSounds preloadBackgroundMusic:@"SuburbanBirds.mp3"];
            if (cricketsBackgroundSounds.willPlayBackgroundMusic) {
                cricketsBackgroundSounds.backgroundMusicVolume = 0.01f;
            }
        }
        
        [cricketsBackgroundSounds playBackgroundMusic:@"crickets.caf" loop:YES];
    }
    
    [player1InGameLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 12.0],[CCFadeTo actionWithDuration: 15.0 opacity: 50], nil]];
    [player2InGameLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 12.0],[CCFadeTo actionWithDuration: 15.0 opacity: 50], nil]];
    
    [microphoneOn runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 12.0],[CCFadeTo actionWithDuration: 15.0 opacity: 100], nil]];
    [microphoneOff runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 12.0],[CCFadeTo actionWithDuration: 15.0 opacity: 100], nil]];
    
    
    //Update light info between players for multiplayer
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(updateLightValueToBothPlayers)], nil]];
    
    
    if (firstMatchWithThisPlayer == YES) {
        
        //Voice chat code
        teamChannel = [[[GCHelper sharedInstance].match voiceChatWithName:@"redTeam"] retain];
        
        teamChannel.active = YES;
        teamChannel.volume = 1.3;
        
        [teamChannel setMute: YES forPlayer: otherPlayerID];
        
        [teamChannel start];
        
        teamChannel.playerStateUpdateHandler = ^(NSString *playerID, GKVoiceChatPlayerState state) {
            switch (state)
            {
                case GKVoiceChatPlayerSpeaking:
                    
                    // insert code to highlight the player's picture.
                    microphoneOn.color = ccYELLOW;
                    microphoneOff.color = ccYELLOW;
                    NSLog (@"Player is speaking!");
                    break;
                case GKVoiceChatPlayerSilent:
                    
                    // insert code to dim the player's picture.
                    microphoneOn.color = ccWHITE;
                    microphoneOff.color = ccWHITE;
                    break;
            }
        };
    }
    
    if ([GKVoiceChat isVoIPAllowed]==NO) {
        
        microphoneOn.visible = NO;
        microphoneOff.visible = NO;
    }
    
    //If ads are showing movie linedPaper down to make room for banner
    if (showAds) {
        
        NSLog (@"linedPaper should move down by 31");
        [linedPaper runAction: [CCMoveTo actionWithDuration:0.3 position:ccp(linedPaper.position.x, linedPaper.position.y - 32)]];
    }
}


-(void) zoomOutForSlingingPlayer1
{
    if (currentLevel == 1) {
        
        [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
        //multiply outside scale by 0.9
        [outside runAction: [CCScaleTo actionWithDuration:0.15 scale:4*0.63]];
        
        if (userIsOnFastDevice) {
            
            [outsideBlur runAction: [CCScaleTo actionWithDuration:0.15 scale:4*0.63]];
        }
        
        //multiply curtains scale by 0.7
        [curtains runAction: [CCScaleTo actionWithDuration:0.15 scale:1.12]];
        
        if (userIsOnFastDevice) {
            
            [curtainsBlur runAction: [CCScaleTo actionWithDuration:0.15 scale:1.12]];
        }
        //multiply chair scale by 0.6
        [chairs runAction: [CCScaleTo actionWithDuration:0.15 scale:2*1.14]];
        
        if (userIsOnFastDevice) {
            
            [chairsBlur runAction: [CCScaleTo actionWithDuration:0.15 scale:2*1.14]];
        }
        
        [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(39,0)]];
        
        if (fieldZoomedOut == NO) {
            
            if (userIsOnFastDevice) {
                
                //Fade In Crisp Background Images
                [chairsBlur runAction: [CCFadeOut actionWithDuration: 0.0]];
                [curtainsBlur runAction: [CCFadeOut actionWithDuration: 0.0]];
                [outsideBlur runAction: [CCFadeOut actionWithDuration: 0.0]];
                
                //Fade Out Blurred Background Images
                [chairs runAction: [CCFadeIn actionWithDuration: 0.0]];
                [curtains runAction: [CCFadeIn actionWithDuration: 0.0]];
                [outside runAction: [CCFadeIn actionWithDuration: 0.0]];
            }
        }
    }
    /*
     else if (currentLevel == 2) {
     
     [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
     //multiply outside scale by 0.9
     [couch runAction: [CCScaleTo actionWithDuration:0.15 scale:0.33*2]];
     [couchBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.33*2]];
     //multiply curtains scale by 0.7
     [orchid runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8*2]];
     [orchidBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8*2]];
     //move orchid to match table height
     
     [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(39,0)]];
     
     if (fieldZoomedOut == NO) {
     
     //Fade Out Blurred Background Images
     [couchBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
     [orchidBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
     
     //Fade In Crisp Background Images
     [couch runAction: [CCFadeIn actionWithDuration: 0.0]];
     [orchid runAction: [CCFadeIn actionWithDuration: 0.0]];
     }
     }
     
     else if (currentLevel == 3) {
     
     [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
     [kitchenOutside runAction: [CCScaleTo actionWithDuration:0.15 scale:0.55]];
     [kitchenOutsideBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.55]];
     [wallAndCouch runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
     [wallAndCouchBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
     [faucet runAction: [CCScaleTo actionWithDuration:0.15 scale:0.6]];
     [faucetBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.6]];
     
     [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(39,0)]];
     
     if (fieldZoomedOut == NO) {
     
     //Fade Out Blurred Background Images
     [kitchenOutsideBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
     [wallAndCouchBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
     [faucetBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
     
     //Fade In Crisp Background Images
     [kitchenOutside runAction: [CCFadeIn actionWithDuration: 0.0]];
     [wallAndCouch runAction: [CCFadeIn actionWithDuration: 0.0]];
     [faucet runAction: [CCFadeIn actionWithDuration: 0.0]];
     }
     }
     
     if (currentLevel == 4) {
     
     [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
     [tvRoomOutside runAction: [CCScaleTo actionWithDuration:0.15 scale:0.63]];
     [tvRoomOutsideBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.63]];
     [tvRoomCouch runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8]];
     [tvRoomCouchBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8]];
     
     
     [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(39,0)]];
     
     if (fieldZoomedOut == NO) {
     
     //Fade Out Blurred Background Images
     [tvRoomCouchBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
     [tvRoomOutsideBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
     
     //Fade  Crisp Background Images
     [tvRoomCouch runAction: [CCFadeIn actionWithDuration: 0.0]];
     [tvRoomOutside runAction: [CCFadeIn actionWithDuration: 0.0]];
     }
     }
     
     if (currentLevel == 6) {
     
     [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
     [fridgeBackground runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
     [fridgeBackgroundBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
     
     [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(39,0)]];
     
     if (fieldZoomedOut == NO) {
     
     //Fade Out Blurred Background Images
     [fridgeBackgroundBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
     
     //Fade In Crisp Background Images
     [fridgeBackground runAction: [CCFadeIn actionWithDuration: 0.0]];
     }
     }
     */
    
    fieldZoomedOut = YES;
    [self sendRequestBlockInfoFromPlayer2];
}

-(void) zoomOutForSlingingPlayer2
{
    if (currentLevel == 1) {
        
        [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
        //multiply outside scale by 0.9
        [couch runAction: [CCScaleTo actionWithDuration:0.15 scale:0.33*2]];
        [couchBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.33*2]];
        //multiply curtains scale by 0.7
        [orchid runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8*2]];
        [orchidBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8*2]];
        //move orchid to match table height
        
        [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(-30,0)]];
        
        if (fieldZoomedOut == NO) {
            
            //Fade Out Blurred Background Images
            [couchBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
            [orchidBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
            
            //Fade In Crisp Background Images
            [couch runAction: [CCFadeIn actionWithDuration: 0.0]];
            [orchid runAction: [CCFadeIn actionWithDuration: 0.0]];
        }
    }
    
    else if (currentLevel == 2) {
        
        [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
        //multiply outside scale by 0.9
        [couch runAction: [CCScaleTo actionWithDuration:0.15 scale:0.33*2]];
        [couchBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.33*2]];
        //multiply curtains scale by 0.7
        [orchid runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8*2]];
        [orchidBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8*2]];
        //move orchid to match table height
        
        [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(-30,0)]];
        
        if (fieldZoomedOut == NO) {
            
            //Fade Out Blurred Background Images
            [couchBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
            [orchidBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
            
            //Fade In Crisp Background Images
            [couch runAction: [CCFadeIn actionWithDuration: 0.0]];
            [orchid runAction: [CCFadeIn actionWithDuration: 0.0]];
        }
    }
    
    else if (currentLevel == 3) {
        
        [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
        [kitchenOutside runAction: [CCScaleTo actionWithDuration:0.15 scale:0.55]];
        [kitchenOutsideBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.55]];
        [wallAndCouch runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
        [wallAndCouchBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
        [faucet runAction: [CCScaleTo actionWithDuration:0.15 scale:0.6]];
        [faucetBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.6]];
        
        [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(-30,0)]];
        
        if (fieldZoomedOut == NO) {
            
            //Fade Out Blurred Background Images
            [kitchenOutsideBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
            [wallAndCouchBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
            [faucetBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
            
            //Fade In Crisp Background Images
            [kitchenOutside runAction: [CCFadeIn actionWithDuration: 0.0]];
            [wallAndCouch runAction: [CCFadeIn actionWithDuration: 0.0]];
            [faucet runAction: [CCFadeIn actionWithDuration: 0.0]];
        }
    }
    
    if (currentLevel == 4) {
        
        [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
        [tvRoomOutside runAction: [CCScaleTo actionWithDuration:0.15 scale:0.63]];
        [tvRoomOutsideBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.63]];
        [tvRoomCouch runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8]];
        [tvRoomCouchBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8]];
        
        
        [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(-30,0)]];
        
        if (fieldZoomedOut == NO) {
            
            //Fade Out Blurred Background Images
            [tvRoomCouchBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
            [tvRoomOutsideBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
            
            //Fade  Crisp Background Images
            [tvRoomCouch runAction: [CCFadeIn actionWithDuration: 0.0]];
            [tvRoomOutside runAction: [CCFadeIn actionWithDuration: 0.0]];
        }
    }
    
    if (currentLevel == 6) {
        
        [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
        [fridgeBackground runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
        [fridgeBackgroundBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
        
        [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(-30,0)]];
        
        if (fieldZoomedOut == NO) {
            
            //Fade Out Blurred Background Images
            [fridgeBackgroundBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
            
            //Fade In Crisp Background Images
            [fridgeBackground runAction: [CCFadeIn actionWithDuration: 0.0]];
        }
    }
    
    fieldZoomedOut = YES;
    [self sendRequestBlockInfoFromPlayer1];
}

-(void) setCrispBackgroundToNotVisible
{
    outside.visible = NO;
    curtains.visible = NO;
    chairs.visible = NO;
}

-(void) setBlurredBackgroundToNotVisible
{
    if (userIsOnFastDevice) {
        
        outsideBlur.visible = NO;
        curtainsBlur.visible = NO;
        chairsBlur.visible = NO;
    }
}

-(void) playerCanZoomInAgainMethod
{
    playerCanZoomInAgain = YES;
}

-(void) playerCanZoomOutAgainMethod
{
    playerCanZoomOutAgain = YES;
}

-(void) zoomOut
{
    playerCanZoomInAgain = NO;
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.2], [CCCallFunc actionWithTarget:self selector:@selector(playerCanZoomInAgainMethod)], nil]];
    
    if (playerCanZoomOutAgain == YES) {
        
        if (currentLevel == 1) {
            
            if (deviceIsWidescreen) {
                
                //Make zoombase appear slightly bigger when zoomed out
                [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.93]];
                //multiply outside scale by 0.9
                [outside runAction: [CCScaleTo actionWithDuration:0.15 scale:4*0.63]];
            }
            
            else if (!deviceIsWidescreen) {
                
                [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
                //multiply outside scale by 0.9
                [outside runAction: [CCScaleTo actionWithDuration:0.15 scale:4*0.63]];
            }
            
            if (userIsOnFastDevice) {
                
                [outsideBlur runAction: [CCScaleTo actionWithDuration:0.15 scale:4*0.63]];
            }
            //multiply curtains scale by 0.7
            [curtains runAction: [CCScaleTo actionWithDuration:0.15 scale:4*1.12]];
            
            if (userIsOnFastDevice) {
                
                [curtainsBlur runAction: [CCScaleTo actionWithDuration:0.15 scale:4*1.12]];
            }
            
            //multiply chair scale by 0.6
            [chairs runAction: [CCScaleTo actionWithDuration:0.15 scale:2*1.14]];
            
            if (userIsOnFastDevice) {
                
                [chairsBlur runAction: [CCScaleTo actionWithDuration:0.15 scale:2*1.14]];
            }
            
            //If device is not running iOS6, shift the parallax node a bit to compensate
            if (deviceIsRunningiOS6 == YES) {
                
                [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(0, 0)]];
                
                if (!userIsOnFastDevice) {
                    
                    [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(5, 0)]];
                }
                
                if (deviceIsWidescreen) {
                    
                    [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(27, 17)]];
                }
            }
            
            else if (!deviceIsRunningiOS6) {
                
                [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(19, -15)]];
            }
            
            
            if (fieldZoomedOut == NO) {
                
                if (userIsOnFastDevice) {
                    
                    //Fade In Crisp Background Images
                    [chairsBlur runAction: [CCFadeOut actionWithDuration: 0.0]];
                    [curtainsBlur runAction: [CCFadeOut actionWithDuration: 0.0]];
                    [outsideBlur runAction: [CCFadeOut actionWithDuration: 0.0]];
                    
                    //Fade Out Blurred Background Images
                    [chairs runAction: [CCFadeIn actionWithDuration: 0.0]];
                    [curtains runAction: [CCFadeIn actionWithDuration: 0.0]];
                    [outside runAction: [CCFadeIn actionWithDuration: 0.0]];
                }
            }
        }
        
        /*Zoom In Size
         [zoombase runAction: [CCScaleTo actionWithDuration:0.1 scale: 1.7]];
         
         [couch runAction: [CCScaleTo actionWithDuration:0.1 scale:0.63]];
         [couchBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:0.63]];
         [orchid runAction: [CCScaleTo actionWithDuration:0.1 scale:1.12]];
         [orchidBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:1.12]];
         */
        
        else if (currentLevel == 2) {
            
            [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
            //multiply outside scale by 0.9
            [couch runAction: [CCScaleTo actionWithDuration:0.15 scale:0.33*2]];
            [couchBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.33*2]];
            //multiply curtains scale by 0.7
            [orchid runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8*2]];
            [orchidBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8*2]];
            //move orchid to match table height
            
            [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(0,0)]];
            
            if (fieldZoomedOut == NO) {
                
                //Fade Out Blurred Background Images
                [couchBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
                [orchidBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
                
                //Fade In Crisp Background Images
                [couch runAction: [CCFadeIn actionWithDuration: 0.0]];
                [orchid runAction: [CCFadeIn actionWithDuration: 0.0]];
            }
        }
        
        else if (currentLevel == 3) {
            
            [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
            [kitchenOutside runAction: [CCScaleTo actionWithDuration:0.15 scale:0.55]];
            [kitchenOutsideBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.55]];
            [wallAndCouch runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
            [wallAndCouchBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
            [faucet runAction: [CCScaleTo actionWithDuration:0.15 scale:0.6]];
            [faucetBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.6]];
            
            [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(0,0)]];
            
            if (fieldZoomedOut == NO) {
                
                //Fade Out Blurred Background Images
                [kitchenOutsideBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
                [wallAndCouchBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
                [faucetBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
                
                //Fade In Crisp Background Images
                [kitchenOutside runAction: [CCFadeIn actionWithDuration: 0.0]];
                [wallAndCouch runAction: [CCFadeIn actionWithDuration: 0.0]];
                [faucet runAction: [CCFadeIn actionWithDuration: 0.0]];
            }
        }
        /*
         [parallaxNode addChild: zoombase z:5 parallaxRatio:ccp(1,1) positionOffset:ccp(-39,-24)];
         [parallaxNode addChild: tvRoomCouch z:1 parallaxRatio:ccp(0.2,0.2) positionOffset:ccp(20,0)];
         [parallaxNode addChild: tvRoomOutside z: 0 parallaxRatio:ccp(0.03,0.03) positionOffset:ccp(170,125)];
         [parallaxNode addChild: tvRoomCouchBlurry z:1 parallaxRatio:ccp(0.2,0.2) positionOffset:ccp(20,0)];
         [parallaxNode addChild: tvRoomOutsideBlurry z: 0 parallaxRatio:ccp(0.03,0.03) positionOffset:ccp(170,125)];
         */
        
        if (currentLevel == 4) {
            
            [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
            [tvRoomOutside runAction: [CCScaleTo actionWithDuration:0.15 scale:0.63]];
            [tvRoomOutsideBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.63]];
            [tvRoomCouch runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8]];
            [tvRoomCouchBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8]];
            
            
            [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(0,0)]];
            
            if (fieldZoomedOut == NO) {
                
                //Fade Out Blurred Background Images
                [tvRoomCouchBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
                [tvRoomOutsideBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
                
                //Fade  Crisp Background Images
                [tvRoomCouch runAction: [CCFadeIn actionWithDuration: 0.0]];
                [tvRoomOutside runAction: [CCFadeIn actionWithDuration: 0.0]];
            }
        }
        
        if (currentLevel == 6) {
            
            [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
            [fridgeBackground runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
            [fridgeBackgroundBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
            
            [parallaxNode runAction: [CCMoveTo actionWithDuration:0.15 position:ccp(0,0)]];
            
            if (fieldZoomedOut == NO) {
                
                //Fade Out Blurred Background Images
                [fridgeBackgroundBlurry runAction: [CCFadeOut actionWithDuration: 0.0]];
                
                //Fade In Crisp Background Images
                [fridgeBackground runAction: [CCFadeIn actionWithDuration: 0.0]];
            }
        }
        
        fieldZoomedOut = YES;
    }
}

-(void) zoomIn
{
    playerCanZoomOutAgain = NO;
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.2], [CCCallFunc actionWithTarget:self selector:@selector(playerCanZoomOutAgainMethod)], nil]];
    
    if (playerCanZoomInAgain == YES) {
        
        if (currentLevel == 1) {
            
            [zoombase runAction: [CCScaleTo actionWithDuration:0.1 scale: 1.7]];
            [outside runAction: [CCScaleTo actionWithDuration:0.1 scale:4*0.7]];
            
            if (userIsOnFastDevice) {
                
                [outsideBlur runAction: [CCScaleTo actionWithDuration:0.1 scale:4*0.7]];
            }
            
            [curtains runAction: [CCScaleTo actionWithDuration:0.1 scale:4*1.6]];
            
            if (userIsOnFastDevice) {
                
                [curtainsBlur runAction: [CCScaleTo actionWithDuration:0.1 scale:4*1.6]];
            }
            [chairs runAction: [CCScaleTo actionWithDuration:0.1 scale:2*1.9]];
            
            if (userIsOnFastDevice) {
                
                [chairsBlur runAction: [CCScaleTo actionWithDuration:0.1 scale:2*1.9]];
            }
            
            if (userIsOnFastDevice) {
                
                //Fade Out Crisp Background Images
                [chairs runAction: [CCFadeOut actionWithDuration: 0.0]];
                [curtains runAction: [CCFadeOut actionWithDuration: 0.0]];
                [outside runAction: [CCFadeOut actionWithDuration: 0.0]];
                
                //Fade In Blurred Background Images
                [chairsBlur runAction: [CCFadeIn actionWithDuration: 0.0]];
                [curtainsBlur runAction: [CCFadeIn actionWithDuration: 0.0]];
                [outsideBlur runAction: [CCFadeIn actionWithDuration: 0.0]];
            }
            
            /*
             //Set all blurred background sprites to not visible after 0.20 seconds
             [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.2], [CCCallFunc actionWithTarget:self selector:@selector(setCrispBackgroundToNotVisible)], nil]];
             */
        }
        
        else if (currentLevel == 2) {
            
            [zoombase runAction: [CCScaleTo actionWithDuration:0.1 scale: 1.7]];
            
            [couch runAction: [CCScaleTo actionWithDuration:0.1 scale:0.63*2]];
            [couchBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:0.63*2]];
            [orchid runAction: [CCScaleTo actionWithDuration:0.1 scale:1.7*2]];
            [orchidBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:1.7*2]];
            
            //Fade Out Crisp Background Images
            [couch runAction: [CCFadeOut actionWithDuration: 0.0]];
            [orchid runAction: [CCFadeOut actionWithDuration: 0.0]];
            
            //Fade In Blurred Background Images
            [couchBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
            [orchidBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
        }
        
        else if (currentLevel == 3) {
            /*ZoomOut Size
             [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
             [kitchenOutside runAction: [CCScaleTo actionWithDuration:0.15 scale:0.55]];
             [kitchenOutsideBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.55]];
             [wallAndCouch runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
             [wallAndCouchBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
             [faucet runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8]];
             [faucetBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8]];
             */
            [zoombase runAction: [CCScaleTo actionWithDuration:0.1 scale: 1.7]];
            [kitchenOutside runAction: [CCScaleTo actionWithDuration:0.1 scale:0.63]];
            [kitchenOutsideBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:0.63]];
            [wallAndCouch runAction: [CCScaleTo actionWithDuration:0.1 scale:1.05]];
            [wallAndCouchBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:1.05]];
            [faucet runAction: [CCScaleTo actionWithDuration:0.1 scale:1.3]];
            [faucetBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:1.3]];
            
            //Fade Out Crisp Background Images
            [kitchenOutside runAction: [CCFadeOut actionWithDuration: 0.0]];
            [wallAndCouch runAction: [CCFadeOut actionWithDuration: 0.0]];
            [faucet runAction: [CCFadeOut actionWithDuration: 0.0]];
            
            //Fade In Blurred Background Images
            [kitchenOutsideBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
            [wallAndCouchBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
            [faucetBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
        }
        
        else if (currentLevel == 4) {
            /*ZoomOut Level
             [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
             [tvRoomOutside runAction: [CCScaleTo actionWithDuration:0.15 scale:0.63]];
             [tvRoomOutsideBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.63]];
             [tvRoomCouch runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8]];
             [tvRoomCouchBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8]];
             */
            [zoombase runAction: [CCScaleTo actionWithDuration:0.1 scale: 1.7]];
            [tvRoomOutside runAction: [CCScaleTo actionWithDuration:0.1 scale:0.7]];
            [tvRoomOutsideBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:0.7]];
            [tvRoomCouch runAction: [CCScaleTo actionWithDuration:0.1 scale:1.6]];
            [tvRoomCouchBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:1.6]];
            
            
            //Fade Out Crisp Background Images
            [tvRoomOutside runAction: [CCFadeOut actionWithDuration: 0.0]];
            [tvRoomCouch runAction: [CCFadeOut actionWithDuration: 0.0]];
            
            //Fade In Blurred Background Images
            [tvRoomOutsideBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
            [tvRoomCouchBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
        }
        
        else if (currentLevel == 6) {
            
            [zoombase runAction: [CCScaleTo actionWithDuration:0.1 scale: 1.7]];
            [fridgeBackground runAction: [CCScaleTo actionWithDuration:0.1 scale:1.05]];
            [fridgeBackgroundBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:1.05]];
            
            //Fade Out Crisp Background Images
            [fridgeBackground runAction: [CCFadeOut actionWithDuration: 0.0]];
            
            //Fade In Blurred Background Images
            [fridgeBackgroundBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
        }
        
        fieldZoomedOut = NO;
    }
}

-(void) zoomInForStartup
{
    
    if (currentLevel == 1) {
        
        [zoombase runAction: [CCScaleTo actionWithDuration:0.25 scale: 1.7]];
        [outside runAction: [CCScaleTo actionWithDuration:0.25 scale:4*0.7]];
        
        if (userIsOnFastDevice) {
            
            [outsideBlur runAction: [CCScaleTo actionWithDuration:0.25 scale:4*0.7]];
        }
        
        [curtains runAction: [CCScaleTo actionWithDuration:0.25 scale:4*1.6]];
        
        if (userIsOnFastDevice) {
            
            [curtainsBlur runAction: [CCScaleTo actionWithDuration:0.25 scale:4*1.6]];
        }
        
        [chairs runAction: [CCScaleTo actionWithDuration:0.25 scale:2*1.9]];
        
        if (userIsOnFastDevice) {
            
            [chairsBlur runAction: [CCScaleTo actionWithDuration:0.25 scale:2*1.9]];
        }
        
        if (userIsOnFastDevice) {
            
            //Fade Out Crisp Background Images
            [chairs runAction: [CCFadeOut actionWithDuration: 0.0]];
            [curtains runAction: [CCFadeOut actionWithDuration: 0.0]];
            [outside runAction: [CCFadeOut actionWithDuration: 0.0]];
        }
        
        if (userIsOnFastDevice) {
            
            //Fade In Blurred Background Images
            [chairsBlur runAction: [CCFadeIn actionWithDuration: 0.0]];
            [curtainsBlur runAction: [CCFadeIn actionWithDuration: 0.0]];
            [outsideBlur runAction: [CCFadeIn actionWithDuration: 0.0]];
        }
        
        /*
         //Set all crisp background sprites to not visible after 0.20 seconds
         [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.2], [CCCallFunc actionWithTarget:self selector:@selector(setCrispBackgroundToNotVisible)], nil]];
         */
    }
    
    else if (currentLevel == 2) {
        
        [zoombase runAction: [CCScaleTo actionWithDuration:0.25 scale: 1.7]];
        
        [couch runAction: [CCScaleTo actionWithDuration:0.1 scale:0.63*2]];
        [couchBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:0.63*2]];
        [orchid runAction: [CCScaleTo actionWithDuration:0.1 scale:1.7*2]];
        [orchidBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:1.7*2]];
        
        //Fade Out Crisp Background Images
        [couch runAction: [CCFadeOut actionWithDuration: 0.0]];
        [orchid runAction: [CCFadeOut actionWithDuration: 0.0]];
        
        //Fade In Blurred Background Images
        [couchBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
        [orchidBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
    }
    
    else if (currentLevel == 3) {
        /*ZoomOut Size
         [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
         [kitchenOutside runAction: [CCScaleTo actionWithDuration:0.15 scale:0.55]];
         [kitchenOutsideBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.55]];
         [wallAndCouch runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
         [wallAndCouchBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.75]];
         [faucet runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8]];
         [faucetBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8]];
         */
        [zoombase runAction: [CCScaleTo actionWithDuration:0.1 scale: 1.7]];
        [kitchenOutside runAction: [CCScaleTo actionWithDuration:0.1 scale:0.63]];
        [kitchenOutsideBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:0.63]];
        [wallAndCouch runAction: [CCScaleTo actionWithDuration:0.1 scale:1.05]];
        [wallAndCouchBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:1.05]];
        [faucet runAction: [CCScaleTo actionWithDuration:0.1 scale:1.5]];
        [faucetBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:1.5]];
        
        //Fade Out Crisp Background Images
        [kitchenOutside runAction: [CCFadeOut actionWithDuration: 0.0]];
        [wallAndCouch runAction: [CCFadeOut actionWithDuration: 0.0]];
        [faucet runAction: [CCFadeOut actionWithDuration: 0.0]];
        
        //Fade In Blurred Background Images
        [kitchenOutsideBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
        [wallAndCouchBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
        [faucetBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
    }
    
    else if (currentLevel == 4) {
        /*ZoomOut Level
         [zoombase runAction: [CCScaleTo actionWithDuration:0.15 scale: 0.9*0.9]];
         [tvRoomOutside runAction: [CCScaleTo actionWithDuration:0.15 scale:0.63]];
         [tvRoomOutsideBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.63]];
         [tvRoomCouch runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8]];
         [tvRoomCouchBlurry runAction: [CCScaleTo actionWithDuration:0.15 scale:0.8]];
         */
        [zoombase runAction: [CCScaleTo actionWithDuration:0.1 scale: 1.7]];
        [tvRoomOutside runAction: [CCScaleTo actionWithDuration:0.1 scale:0.7]];
        [tvRoomOutsideBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:0.7]];
        [tvRoomCouch runAction: [CCScaleTo actionWithDuration:0.1 scale:1.6]];
        [tvRoomCouchBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:1.6]];
        
        
        //Fade Out Crisp Background Images
        [tvRoomOutside runAction: [CCFadeOut actionWithDuration: 0.0]];
        [tvRoomCouch runAction: [CCFadeOut actionWithDuration: 0.0]];
        
        //Fade In Blurred Background Images
        [tvRoomOutsideBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
        [tvRoomCouchBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
    }
    
    else if (currentLevel == 6) {
        
        [zoombase runAction: [CCScaleTo actionWithDuration:0.1 scale: 1.7]];
        [fridgeBackground runAction: [CCScaleTo actionWithDuration:0.1 scale:1.05]];
        [fridgeBackgroundBlurry runAction: [CCScaleTo actionWithDuration:0.1 scale:1.05]];
        
        //Fade Out Crisp Background Images
        [fridgeBackground runAction: [CCFadeOut actionWithDuration: 0.0]];
        
        //Fade In Blurred Background Images
        [fridgeBackgroundBlurry runAction: [CCFadeIn actionWithDuration: 0.0]];
    }
    
    fieldZoomedOut = NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    return YES;
}


- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}
/*
 - (void)tapAndHold:(UILongPressGestureRecognizer *)recognizer {
 
 
 if (recognizer.state == UIGestureRecognizerStateBegan) {
 
 [self zoomOut];
 }
 
 if (recognizer.state == UIGestureRecognizerStateChanged) {
 
 return;
 }
 
 if (recognizer.state == UIGestureRecognizerStateEnded) {
 
 if (isPlayer1 && player1LightningExists == YES) {
 
 [lightning removeFromParentAndCleanup: YES];
 player1LightningExists = NO;
 }
 
 if (!isPlayer1 && player2LightningExists == YES) {
 
 [lightning2 removeFromParentAndCleanup: YES];
 player2LightningExists = NO;
 }
 }
 }
 */

// Zoom board
- (void)zoomLayer:(float)zoomScale {
	// Debugging purposes
	//  NSLog(@"zoombase scale: %f and scale from the gesture: %f\n",zoombase.scale, zoomScale);
    
	if ((zoombase.scale*zoomScale) <= MIN_SCALE) {
		zoomScale = MIN_SCALE/zoombase.scale;
	}
	if ((zoombase.scale*zoomScale) >= MAX_SCALE) {
		zoomScale =	MAX_SCALE/zoombase.scale;
	}
	zoombase.scale = zoombase.scale*zoomScale;
    
}


// UIGesture recognizer routines
- (void)handleSingleTapFrom:(UITapGestureRecognizer *)recognizer {
    
}

- (void)handleDoubleTapFrom:(UITapGestureRecognizer *)recognizer {
    
    //   [self dropMarbleIfDoubleTapped:touchLocation];
    
    
    if (isPlayer1 && player1LightningExists == YES) {
        
        [lightning removeFromParentAndCleanup: YES];
        player1LightningExists = NO;
    }
    
    if (!isPlayer1 && player2LightningExists == YES) {
        
        [lightning2 removeFromParentAndCleanup: YES];
        player2LightningExists = NO;
    }
    
    if (fieldZoomedOut == YES) {
        
        if ((isPlayer1 && player1ProjectileHasBeenTouched == NO) || (!isPlayer1 && player2ProjectileHasBeenTouched == NO)) {
            /*
             [self zoomIn];
             
             // scaleCenter is the point to zoom to..
             // If you are doing a pinch zoom, this should be the center of your pinch.
             
             float x = [[CCDirector sharedDirector] winSize].width;
             float y = [[CCDirector sharedDirector] winSize].height;
             
             // Get the original center point.
             CGPoint oldCenterPoint = ccp((x/2), (y/2));
             // Set the scale.
             // [self zoomIn];
             
             // Get the new center point.
             CGPoint newCenterPoint = ccp(touchLocation.x, touchLocation.y);
             
             // Then calculate the delta.
             CGPoint centerPointDelta  = ccpSub(oldCenterPoint, newCenterPoint);
             
             // Now adjust your layer by the delta.
             [parallaxNode runAction: [CCMoveTo actionWithDuration: 0.1 position:ccpAdd(parallaxNode.position, centerPointDelta)]];
             */
        }
    }
}

- (void)handlePinchFrom:(UIPinchGestureRecognizer *)recognizer {
    
    if (((isPlayer1) || (!isPlayer1)) && playersCanTouchMarblesNow) {
        
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            
            float zoomScale = [recognizer scale];
            NSLog (@"Recognizer scale = %f", zoomScale);
        }
        
        else if (recognizer.state == UIGestureRecognizerStateChanged) {
            
            if ([recognizer scale] <= 1 && fieldZoomedOut == NO) {
                
                [self zoomOut];
                
                if (!isPlayer1) {
                    
                    [self sendRequestBlockInfoFromPlayer1];
                }
            }
            
            if ([recognizer scale] > 1 && fieldZoomedOut == YES) {
                
                [self zoomIn];
                
                // scaleCenter is the point to zoom to..
                // If you are doing a pinch zoom, this should be the center of your pinch.
                
                float x = [[CCDirector sharedDirector] winSize].width;
                float y = [[CCDirector sharedDirector] winSize].height;
                
                // Get the original center point.
                CGPoint oldCenterPoint = ccp((x/2), (y/2));
                // Set the scale.
                // [self zoomIn];
                
                // Get the new center point.
                CGPoint newCenterPoint = ccp(touchLocation.x, touchLocation.y);
                
                // Then calculate the delta.
                CGPoint centerPointDelta  = ccpSub(oldCenterPoint, newCenterPoint);
                
                // Now adjust your layer by the delta.
                [parallaxNode runAction: [CCMoveTo actionWithDuration: 0.1 position:ccpAdd(parallaxNode.position, centerPointDelta)]];
                
                if (!isPlayer1) {
                    
                    [self sendRequestBlockInfoFromPlayer1];
                }
            }
        }
        
        else if (recognizer.state == UIGestureRecognizerStateEnded) {
            
            if (isPlayer1 && player1LightningExists == YES) {
                
                [lightning removeFromParentAndCleanup: YES];
                player1LightningExists = NO;
            }
            
            if (!isPlayer1 && player2LightningExists == YES) {
                
                [lightning2 removeFromParentAndCleanup: YES];
                player2LightningExists = NO;
            }
        }
    }
}

// Point conversion routines
- (CGPoint)convertPoint:(CGPoint)point fromNode:(CCNode *)node {
    return [self convertToNodeSpace:[node convertToWorldSpace:point]];
}
- (CGPoint)convertPoint:(CGPoint)touchLocation toNode:(CCNode *)node {
	// do the inverse of the routine above
	// Where touchLocation is the result of what is called from the UIGestureRecognizer
	CGPoint newPos = [[CCDirector sharedDirector] convertToGL: touchLocation];
	newPos = [node convertToNodeSpace:newPos];
	return newPos;
}

-(void) pauseGameForSinglePlayer
{
    [[CCDirector sharedDirector] pause];
}

-(void) unPauseGameForSinglePlayer
{
    [[CCDirector sharedDirector] resume];
}

//play swish sound

-(void) pauseGame
{
    NSLog(@"pauseGame called!");
    
    if (isSinglePlayer == YES) {
        
        getReadyLabel.visible = NO;
        
        if (gamePaused == NO) {
            
            //add swish sound
            gamePaused = YES;
            [linedPaper runAction: [CCSequence actions: [CCMoveTo actionWithDuration: 0.2 position: ccp(linedPaper.position.x, -330)], [CCCallFunc actionWithTarget:self selector:@selector(pauseGameForSinglePlayer)], nil]];
            NSLog (@"gamePaused == %i", gamePaused);
        }
        
        else if (gamePaused == YES) {
            
            //add swish sound
            gamePaused = NO;
            [self unPauseGameForSinglePlayer];
            [linedPaper runAction: [CCMoveTo actionWithDuration: 0.2 position: ccp(linedPaper.position.x, -500)]];
            NSLog (@"gamePaused == %i", gamePaused);
        }
    }
    
    
    else if (isSinglePlayer == NO) {
        
        if (gamePaused == NO) {
            
            [[CCDirector sharedDirector] pause];
            gamePaused= YES;
            NSLog (@"Game Paused");
            
            if (isSinglePlayer == NO) {
                
                [self sendPauseGame];
            }
        }
        
        else if (gamePaused == YES) {
            
            [[CCDirector sharedDirector] resume];
            gamePaused = NO;
            NSLog (@"Game UNpaused");
            
            if (isSinglePlayer == NO) {
                
                [self sendPauseGame];
            }
        }
    }
}
/*
 - (void) restart:(id)sender
 {
 //    CCScene *scene = [CCScene node];
 //	[scene addChild:[[[Game alloc] initWithSaved:NO] autorelease] z:0 tag:GAME_TAG];
 
 [[CCTextureCache sharedTextureCache] removeUnusedTextures];
 
 
 //	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:.7
 scene:[MainMenuScene scene]
 withColor:ccBLACK]];
 
 
 //  [[CCDirector sharedDirector] replaceScene:
 //  [CCTransitionFlipX transitionWithDuration:0.6f scene:[MainMenuScene scene]]];
 
 // [self matchEnded];
 
 //action should bring up paper then run pauseGame
 
 [self pauseGame];
 }
 */
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
    NSLog (@"onEnter Called in Game");
    
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
//    //iAd Banner Here
//    if (firstTimeLoadingGameScene == YES && showAds == YES) {
//        
//        firstTimeLoadingGameScene = NO;
//        
//        adView = [[ADBannerView alloc]initWithFrame:CGRectZero];
//        adView.delegate = self;
//        adView.requiredContentSizeIdentifiers = [NSSet setWithObjects: ADBannerContentSizeIdentifierLandscape, ADBannerContentSizeIdentifierLandscape,nil];
//        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
//        [[[CCDirector sharedDirector] openGLView] addSubview:adView];
//        
//        //Transform bannerView
//        [self fixBannerToDeviceOrientation:(UIDeviceOrientation)[[CCDirector sharedDirector] deviceOrientation]];
//        
//        CGSize windowSize = [[CCDirector sharedDirector] winSize];
//        adView.center = CGPointMake(adView.frame.size.width/2,windowSize.height/2-145);
//    }
    
    [super onEnter];
}

- (void) onExit
{
    if (restartLevel == NO) {
        
        [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
        [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:pinchGestureRecognizer];
        [[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:doubleTap];
    }
    //    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    
    
    NSLog (@"onExit called in Game");
    
    //[[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:pinchGestureRecognizer];
    //[[[CCDirector sharedDirector] openGLView] removeGestureRecognizer:doubleTap];
    
	[super onExit];
    
    [soundEngine stopAllSounds];
    
    [self stopAllActions];
    
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
    if (isSinglePlayer) {
        
        // remember to pause music too!
        NSLog(@"stopActionsForAd called");
        //[[CCDirector sharedDirector] stopAnimation];
        
        [[CCDirector sharedDirector] pause];
    }
}

-(void)save
{
	[smgr saveSpaceToUserDocs:SERIALIZED_FILE delegate:self];
}

- (void) dealloc
{
    NSLog (@"Dealloc Called in Game");
    
    
	//do this before [smgr release] so autoFreeShape works
	[self removeAllChildrenWithCleanup:YES];
    /*
     [zoombase release];
     [hudLayer release];
     [backgroundLayer release];
     [lightning release];
     [bomb release];
     [bomb2 release];
     [_bombsPlayer1 release];
     [_bombsPlayer2 release];
     */
        
	[smgr release];
    [otherPlayerID release];
    otherPlayerID = nil;
	[super dealloc];
}

-(void) stretchingSlingSoundReady
{
    stretchingSlingSoundReady = YES;
}

-(void) resetStretchingSlingSoundReady
{
    if (stretchingSlingSoundReady == NO) {
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration:2.5],[CCCallFunc actionWithTarget:self selector:@selector(stretchingSlingSoundReady)], nil]];
    }
}

-(void) stretchingSling2SoundReady
{
    stretchingSling2SoundReady = YES;
}

-(void) resetStretchingSling2SoundReady
{
    if (stretchingSling2SoundReady == NO) {
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration:2.5],[CCCallFunc actionWithTarget:self selector:@selector(stretchingSling2SoundReady)], nil]];
    }
}

-(void) setChargeMaxedOutToNo
{
    chargeMaxedOut = NO;
}

-(void) setChargeMaxedOutToYes
{
    chargeMaxedOut = YES;
}

-(void) chargeMaxedOutBlinkGuideLine
{
    guideLineIsBlinking = YES;
    
    guideLineBlinkingAction = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(setChargeMaxedOutToYes)], [CCDelayTime actionWithDuration:0.25], [CCCallFunc actionWithTarget:self selector:@selector(setChargeMaxedOutToNo)], [CCDelayTime actionWithDuration:0.25], nil]]];
}

-(void) player1SlingIsSmoking
{
    player1SlingIsSmoking = YES;
    
    //increaseBigSmokeTimeInterval1 is equal to 0.16 through 0.07
    float chargingSmokePuffingFrequency = 0.4 + 2*increaseBigSmokeTimeInterval1;
    
    player1ChargingSmoke = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: chargingSmokePuffingFrequency], [CCCallFunc actionWithTarget:self selector:@selector(chargingRisingSmoke)], nil]]];
}

-(void) player2SlingIsSmoking
{
    player2SlingIsSmoking = YES;
    
    float chargingSmoke2PuffingFrequency = 0.4 + 2*increaseBigSmokeTimeInterval2;
    
    //increaseBigSmokeTimeInterval2 is equal to 0.16 through 0.07
    player2ChargingSmoke = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: chargingSmoke2PuffingFrequency], [CCCallFunc actionWithTarget:self selector:@selector(chargingRisingSmokePlayer2)], nil]]];
}

-(void) setChanceOfWindChimesSoundsToYes
{
    windChimesSoundsReadyToPlay = YES;
}

-(void) setChanceOfKidsPlayingSoundsToYes
{
    kidsPlayingSoundsReadyToPlay = YES;
}

-(void) setChanceOfPassingCarSoundsToYes
{
    passingCarSoundsReadyToPlay = YES;
}

-(void) setChanceOfDogBarkingSoundsToYes
{
    dogBarkingSoundsReadyToPlay = YES;
}

-(void) setChanceOfLightAircraftPassingBySoundsToYes
{
    lightAircraftPassingBySoundsReadyToPlay = YES;
}

- (void) step: (ccTime) delta
{
    if (invitationalGame == YES) {
        
        invitationalGame = NO;
        
        NSLog (@"multiplayer should be initiated");
        GrenadeGameAppDelegate *delegate = (GrenadeGameAppDelegate *) [UIApplication sharedApplication].delegate;
        [[GCHelper sharedInstance] findMatchWithMinPlayers:2 maxPlayers:2 viewController:delegate.viewController delegate:self];
    }
    
    //   NSLog (@"parallaxNode.position = (%f, %f)", parallaxNode.position.x, parallaxNode.position.y);
    //   NSLog (@"self.position = (%f, %f)", self.position.x, self.position.y);
    
    // chargedShotTimeTotal = chargedShotTimeEnded - chargedShotTimeStarted + blockingChargeBonusPlayer1 + skillLevelBonus*3;
    
    //   NSLog (@"projectileImpulsePlayer1 = %i", projectileImpulsePlayer1);
    //   NSLog (@"projectileImpulsePlayer2 = %i", projectileImpulsePlayer2);
    
    /*
     
     NSLog (@"chargedShotTimeTotal = %f", chargedShotTimeTotal);
     NSLog (@"chargedShotTimeEnded = %f", chargedShotTimeEnded);
     NSLog (@"chargedShotTimeStarted = %f", chargedShotTimeStarted);
     NSLog (@"blockingChargeBonusPlayer1 = %i", blockingChargeBonusPlayer1);
     NSLog (@"skillLevelBonus = %i", skillLevelBonus);
     
     NSLog (@"chargedShotTimeTotal2 = %f", chargedShotTimeTotal2);
     NSLog (@"chargedShotTimeEnded2 = %f", chargedShotTimeEnded2);
     NSLog (@"chargedShotTimeStarted2 = %f", chargedShotTimeStarted2);
     NSLog (@"blockingChargeBonusPlayer1 = %i", blockingChargeBonusPlayer2);
     */
    // NSLog (@"bomb position = (%f, %f)", _curBomb.position.x, _curBomb.position.y);
    
    //NSLog (@"computerWillLaunchWhenPlayerLaunches = %i", computerWillLaunchWhenPlayerLaunches);
    //NSLog (@"player2BombInPlay = %i", player2BombInPlay);
    
    //Move pointing finger up and down above opponent's marble
    [player1LevelLabelMainMenu setString: [NSString stringWithFormat:@"Rank: %i", player1Level/100]];
    [player1ExperiencePointsLabelMainMenu setString: [NSString stringWithFormat:@"%i%%", player1ExperiencePoints]];
    
    if (!isSinglePlayer) {
        
        pauseButton.visible = NO;
    }
    
    if (player1BombExists && player2BombExists) {
        
        teslaGlow1.color = ccc3(glColorRedPlayer1, glColorGreenPlayer1, glColorBluePlayer1);
        teslaGlow2.color = ccc3(glColorRedPlayer2, glColorGreenPlayer2, glColorBluePlayer2);
    }
    
    if (isSinglePlayer || (!isSinglePlayer && isPlayer1 && player2BombExists == YES && isGo == YES)) {
        
        pointingFinger2.position = ccp(bomb2.position.x, bomb2.position.y + 25);
        
        if (bomb2.position.x < SLING_POSITION_2.x - 25 && player2ProjectileIsZappable == YES && doNotShowMarblePointFinger2 == NO) {
            
            pointingFinger2.visible = YES;
        }
        
        else {
            
            pointingFinger2.visible = NO;
        }
    }
    
    else if (!isPlayer1 && !isSinglePlayer && player1BombExists == YES && isGo == YES) {
        
        pointingFinger2.position = ccp(bomb.position.x, bomb.position.y + 25);
        
        if (bomb.position.x > SLING_POSITION.x + 25 && player1ProjectileIsZappable == YES && doNotShowMarblePointFinger2 == NO) {
            
            pointingFinger2.visible = YES;
        }
        
        else {
            
            pointingFinger2.visible = NO;
        }
    }
    
    
    if (isPlayer1) {
        
        //Move zoombase for player1 based on how far _curBomb has been pulled back
        zoombaseHorizontalPosition1 = SLING_BOMB_POSITION.x - _curBomb.position.x;
    }
    
    if (isPlayer1 && player1ProjectileHasBeenTouched == YES && zoombaseHorizontalPosition1 > 0) {
        
        zoombase.position = ccp((-39 + zoombaseHorizontalPosition1), zoombase.position.y);
    }
    
    if (!isPlayer1) {
        
        //Move zoombase for player2 based on how far _curBomb has been pulled back
        zoombaseHorizontalPosition2 = _curBombPlayer2.position.x - SLING_BOMB_POSITION_2.x;
    }
    
    if (!isPlayer1 && player2ProjectileHasBeenTouched == YES && zoombaseHorizontalPosition2 > 0) {
        
        zoombase.position = ccp((-39 - zoombaseHorizontalPosition2), zoombase.position.y);
    }
    
    if (!isSinglePlayer) {
        
        gridLayer.visible = NO;
    }
    
    //  NSLog (@"doubleTap.enabled = %i", doubleTap.enabled);
    
    if (isPlayer1 && player1ProjectileHasBeenTouched == YES) {
        
        pinchGestureRecognizer.enabled = NO;
        //    doubleTap.enabled = NO;
    }
    
    else if (isPlayer1 && playersCanTouchMarblesNow == YES && player1ProjectileHasBeenTouched == NO) {
        
        pinchGestureRecognizer.enabled = YES;
        //    doubleTap.enabled = YES;
    }
    
    
    if (!isPlayer1 && player2ProjectileHasBeenTouched == YES) {
        
        pinchGestureRecognizer.enabled = NO;
        //    doubleTap.enabled = NO;
    }
    
    else if (!isPlayer1 && playersCanTouchMarblesNow == YES && player2ProjectileHasBeenTouched == NO) {
        
        pinchGestureRecognizer.enabled = YES;
        //    doubleTap.enabled = YES;
    }
    
    if (stage == DAY_TIME_SUBURB) {
        
        if (kidsPlayingSoundsReadyToPlay == YES) {
            
            //Mark BOOLEAN OFF
            kidsPlayingSoundsReadyToPlay = NO;
            //Play Sound
            //    [kidsPlayingBackgroundSounds playEffect:@"KidsPlayingInTheDistance.caf" pitch:1.0 pan:0.5 gain:0.07];
            
            [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber8 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.07 loop:NO];
            
            //Run action which turns ON boolean after sound bite time has elapsed, 8 seconds in this case
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 21.0], [CCCallFunc actionWithTarget:self selector:@selector(setChanceOfKidsPlayingSoundsToYes)], nil]];
        }
        
        if (chanceOfWindChimesSounds == 1 && windChimesSoundsReadyToPlay == YES) {
            
            //Mark BOOLEAN OFF
            windChimesSoundsReadyToPlay = NO;
            //Play Sound
            //   [windChimesBackgroundSounds playEffect:@"WindChimes.caf" pitch:1.0 pan:0.5 gain:0.05];
            
            [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber7 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.05 loop:NO];
            
            //Run action which turns ON boolean after sound bite time has elapsed, 8 seconds in this case
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 8.0], [CCCallFunc actionWithTarget:self selector:@selector(setChanceOfWindChimesSoundsToYes)], nil]];
        }
        
        if (chanceOfPassingCarSounds == 1 && passingCarSoundsReadyToPlay == YES) {
            
            //Mark BOOLEAN OFF
            passingCarSoundsReadyToPlay = NO;
            //Play Sound
            //   [passingCarBackgroundSounds playEffect:@"PassingCar.caf" pitch:1.0 pan:0.5 gain:0.55];
            
            [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber9 sourceGroupId:0 pitch:0.6f pan:0.5 gain:0.17 loop:NO];
            
            //Run action which turns ON boolean after sound bite time has elapsed, 16 seconds in this case
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 16], [CCCallFunc actionWithTarget:self selector:@selector(setChanceOfPassingCarSoundsToYes)], nil]];
        }
        
        if (chanceOfLightAircraftPassingBySounds == 1 && lightAircraftPassingBySoundsReadyToPlay == YES) {
            
            //Mark BOOLEAN OFF
            chanceOfLightAircraftPassingBySounds = NO;
            //Play Sound
            //  [lightAircraftPassingByBackgroundSounds playEffect:@"LightAircraftPassingBy.caf" pitch:1.0 pan:0.5 gain:1.0];
            
            [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber13 sourceGroupId:0 pitch:1.0f pan:0.5 gain:1.0 loop:NO];
            
            //Run action which turns ON boolean after sound bite time has elapsed, 16 seconds in this case
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 16.0], [CCCallFunc actionWithTarget:self selector:@selector(setChanceOfLightAircraftPassingBySoundsToYes)], nil]];
        }
        
        if (chanceOfDogBarkingSounds == 1 && dogBarkingSoundsReadyToPlay == YES) {
            
            //Mark BOOLEAN OFF
            dogBarkingSoundsReadyToPlay = NO;
            
            int dogBarkingSoundChoice = arc4random()%3;
            
            if (dogBarkingSoundChoice == 0) {
                
                //Play Sound
                //    [dogBarking1BackgroundSounds playEffect:@"DogBarking1.caf" pitch:1.0 pan:0.5 gain:0.7];
                
                [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber10 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.7 loop:NO];
                
                //Run action which turns ON boolean after sound bite time has elapsed, 4 seconds in this case
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 4.0], [CCCallFunc actionWithTarget:self selector:@selector(setChanceOfDogBarkingSoundsToYes)], nil]];
            }
            
            else if (dogBarkingSoundChoice == 1) {
                
                //Play Sound
                //    [dogBarking2BackgroundSounds playEffect:@"DogBarking2.caf" pitch:1.0 pan:0.4 gain:0.7];
                
                [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber11 sourceGroupId:0 pitch:1.0f pan:0.4 gain:0.7 loop:NO];
                
                //Run action which turns ON boolean after sound bite time has elapsed, 3 seconds in this case
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3.0], [CCCallFunc actionWithTarget:self selector:@selector(setChanceOfDogBarkingSoundsToYes)], nil]];
            }
            
            else if (dogBarkingSoundChoice == 2) {
                
                //Play Sound
                //   [dogBarking3BackgroundSounds playEffect:@"DogBarking3.caf" pitch:1.0 pan:0.65 gain:0.5];
                
                [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber12 sourceGroupId:0 pitch:1.0f pan:0.65 gain:0.5 loop:NO];
                
                //Run action which turns ON boolean after sound bite time has elapsed, 6 seconds in this case
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 6.0], [CCCallFunc actionWithTarget:self selector:@selector(setChanceOfDogBarkingSoundsToYes)], nil]];
            }
        }
    }
    
    if (skillLevelBonus >= 2) {
        
        skillLevelBonus = 2;
    }
    
    //Kill Gerty1 if he should be dead, is not aleady dead, and local marble has already hit rectangle
    if (!isSinglePlayer && gertyPlayer1Alive == YES && player1GertyShouldBeDead == YES && player2IsTheWinnerScriptHasBeenPlayed == NO) {
        
        //I am player 2 and if Gerty is not already dead, then kill him once bomb2 disappears
        
        gertyPlayer1Alive = NO;
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: prelaunchDelayTime], [CCCallFunc actionWithTarget:self selector:@selector(blowupGerty1AndRunPlayer2IsTheWinnerScript)], nil]];
    }
    
    //Kill Gerty2 if he should be dead, is not aleady dead, and local marble has already hit rectangle
    if (gertyPlayer2Alive == YES && player2GertyShouldBeDead == YES && player1IsTheWinnerScriptHasBeenPlayed == NO) {
        
        //I am player 1 and if Gerty2 is not already dead, then kill him once bomb disappears
        
        gertyPlayer2Alive = NO;
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: prelaunchDelayTime], [CCCallFunc actionWithTarget:self selector:@selector(blowupGerty2AndRunPlayer1IsTheWinnerScript)], nil]];
    }
    
    if (isSinglePlayer == YES) {
        
        if (player1BombExists == YES && ((_curBomb.position.x > SLING_BOMB_POSITION.x + 26) || (_curBomb.position.y >= 385)) && computerWillBlockMarble == NO && bombHasHitRectangleHenceNoBonus1 == NO && calculatingChanceOfComputerBlockForHighShot == NO && ((_curBombPlayer2.position.x < SLING_BOMB_POSITION_2.x) || _curBombPlayer2.position.x == SLING_BOMB_POSITION_2.x)) {
            
            if (_curBomb.position.y < 370 && chanceOfComputerBlock == 1) {
                
                computerWillBlockMarble = YES;
            }
            
            else if (_curBomb.position.y >= 370 && computerWillBlockMarble == NO && chanceOfComputerBlock == 1) {
                
                calculatingChanceOfComputerBlockForHighShot = YES;
            }
            
            if (bombHasHitRectangleHenceNoBonus1 == YES) {
                
                calculatingChanceOfComputerBlockForHighShot = NO;
                computerWillBlockMarbleForHighShot = NO;
                computerWillBlockMarble = NO;
            }
        }
        
        //Set range at which AI can zap the player's marble
        if (difficultyLevel == 0) {
            
            if (player1GiantSmokeCloudFrontOpacity < 155) {
                
                int computerZapLimitRandomNumber = arc4random()%360;
                
                if (computerZapLimitRandomNumber > 260 && computerZapLimitRandomNumber < 361) {
                    
                    computerZapLimit = computerZapLimitRandomNumber;
                }
                
                else {
                    
                    computerZapLimit = 260;
                }
            }
            
            else if (player1GiantSmokeCloudFrontOpacity > 155) {
                
                computerZapLimit = 360;
            }
        }
        
        else if (difficultyLevel == 1) {
            
            if (player1GiantSmokeCloudFrontOpacity < 155) {
                
                int computerZapLimitRandomNumber = arc4random()%330;
                
                if (computerZapLimitRandomNumber > 260 && computerZapLimitRandomNumber < 331) {
                    
                    computerZapLimit = computerZapLimitRandomNumber;
                }
                
                else {
                    
                    computerZapLimit = 250;
                }
            }
            
            else if (player1GiantSmokeCloudFrontOpacity > 155) {
                
                computerZapLimit = 330;
            }
        }
        
        else if (difficultyLevel >= 2) {
            
            if (player1GiantSmokeCloudFrontOpacity < 155) {
                
                int computerZapLimitRandomNumber = arc4random()%320;
                
                if (computerZapLimitRandomNumber > 260 && computerZapLimitRandomNumber < 321) {
                    
                    computerZapLimit = computerZapLimitRandomNumber;
                }
                
                else {
                    
                    computerZapLimit = 240;
                }
            }
            
            else if (player1GiantSmokeCloudFrontOpacity > 155) {
                
                computerZapLimit = 320;
            }
        }
        
        if (player1BombExists == YES && computerWillBlockMarble == YES && (_curBomb.position.x > computerZapLimit && _curBomb.position.y <= 370) && ((_curBombPlayer2.position.x < SLING_BOMB_POSITION_2.x) || _curBombPlayer2.position.x == SLING_BOMB_POSITION_2.x) && bombHasHitRectangleHenceNoBonus1 == NO) {
            
            //385 is zoombase view border in zoomedOut mode, choose 370 for 'realism sake'
            if (calculatingChanceOfComputerBlockForHighShot == NO) {
                
                computerWillBlockMarble = NO;
                calculatingChanceOfComputerBlockForHighShot = NO;
                [self smokeyExplosionPlayer1];
                [(Bomb *)_curBomb.shape->data player1BombZapped];
                NSLog (@"bomb zapped low");
            }
        }
        
        else if (player1BombExists == YES && calculatingChanceOfComputerBlockForHighShot == YES && computerWillBlockMarbleHighShot == NO && _curBomb.position.y < 370 && ((_curBombPlayer2.position.x < SLING_BOMB_POSITION_2.x) || _curBombPlayer2.position.x == SLING_BOMB_POSITION_2.x)) {
            
            calculatingChanceOfComputerBlockForHighShot = YES;
            
            if (chanceOfComputerBlockForHighShot == 1) {
                
                computerWillBlockMarbleForHighShot = YES;
            }
            
            if (bombHasHitRectangleHenceNoBonus1 == YES) {
                
                calculatingChanceOfComputerBlockForHighShot = NO;
                computerWillBlockMarbleForHighShot = NO;
                computerWillBlockMarble = NO;
            }
            
            if (computerWillBlockMarbleForHighShot == YES && bombHasHitRectangleHenceNoBonus1 == NO) {
                
                computerWillBlockMarbleForHighShot = NO;
                computerWillBlockMarble = NO;
                [self smokeyExplosionPlayer1];
                [(Bomb *)_curBomb.shape->data player1BombZapped];
                calculatingChanceOfComputerBlockForHighShot = NO;
                NSLog (@"bomb zapped high");
            }
        }
    }
    
    int player1GiantSmokeCloudFrontOpacityValue;
    int player2GiantSmokeCloudFrontOpacityValue;
    
    if (player1GiantSmokeCloudFrontOpacity <= 255) {
        
        player1GiantSmokeCloudFrontOpacityValue = player1GiantSmokeCloudFrontOpacity;
    }
    
    else if (player1GiantSmokeCloudFrontOpacity > 255) {
        
        player1GiantSmokeCloudFrontOpacityValue = 255;
    }
    
    if (player2GiantSmokeCloudFrontOpacity <= 255) {
        
        player2GiantSmokeCloudFrontOpacityValue = player2GiantSmokeCloudFrontOpacity;
    }
    
    else if (player2GiantSmokeCloudFrontOpacity > 255) {
        
        player2GiantSmokeCloudFrontOpacityValue = 255;
    }
    
    player1GiantSmokeCloudFront.opacity = player1GiantSmokeCloudFrontOpacityValue;
    // player1GiantSmokeCloudBack.opacity = player1GiantSmokeCloudBackOpacityValue;
    
    player2GiantSmokeCloudFront.opacity = player2GiantSmokeCloudFrontOpacityValue;
    //player2GiantSmokeCloudBack.opacity = player2GiantSmokeCloudBackOpacityValue;
    
    
    if (player1BombExists == YES) {
        
        if (_curBomb.position.x != SLING_BOMB_POSITION.x && _curBomb.position.y != SLING_BOMB_POSITION.y) {
            
            if (((_curBomb.position.x <= SLING_BOMB_POSITION.x + 25) && (_curBomb.position.x >= SLING_BOMB_POSITION.x - 25)) && ((_curBomb.position.y <= SLING_BOMB_POSITION.y + 25) && (_curBomb.position.y >= SLING_BOMB_POSITION.y - 25))) {
                
                tesla.position = _curBomb.position;
            }
            
            else {
                
                tesla.position = ccp(sling1.position.x - 5, sling1.position.y + 7);
            }
        }
    }
    
    if (player2BombExists == YES) {
        
        if (_curBombPlayer2.position.x != SLING_BOMB_POSITION_2.x && _curBombPlayer2.position.y != SLING_BOMB_POSITION_2.y) {
            
            if (((_curBombPlayer2.position.x >= SLING_BOMB_POSITION_2.x - 25) && (_curBombPlayer2.position.x <= SLING_BOMB_POSITION_2.x + 25)) && ((_curBombPlayer2.position.y >= SLING_BOMB_POSITION_2.y - 25) && (_curBombPlayer2.position.y <= SLING_BOMB_POSITION_2.y + 25))) {
                
                tesla2.position = _curBombPlayer2.position;
            }
            
            else {
                
                tesla2.position = ccp(sling1Player2.position.x + 5, sling1Player2.position.y + 7);
            }
        }
    }
    
    if (isGo == YES) {
        
        //If Difficultylevel == 0 or 1
        if (isSinglePlayer == YES && marblePlayer2IsReadyToSling == YES && _curBombPlayer2.position.x == SLING_BOMB_POSITION_2.x && _curBombPlayer2.position.y == SLING_BOMB_POSITION_2.y && playersCanTouchMarblesNow == YES) {
            
            [self artificialIntelligenceLaunchMethod];
        }
        
        //If DifficultyLevel >= 2
        else if (isSinglePlayer == YES && difficultyLevel >= 2 && player2BombInPlay == YES && (_curBombPlayer2.position.x > SLING_BOMB_POSITION_2.x || (_curBombPlayer2.position.y < SLING_BOMB_POSITION_2.y + 25))) {
            
            if (computerNumberOfChargingRounds >= 4) {
                
                [self artificialIntelligenceLaunchMarbleMethod];
            }
            
            else if (_curBomb.position.x > SLING_BOMB_POSITION.x + 35 && bombHasHitRectangleHenceNoBonus1 == NO) {
                
                [self artificialIntelligenceLaunchMarbleMethod];
            }
            
            else if (player2GiantSmokeCloudFrontOpacity >= 255) {
                
                [self artificialIntelligenceLaunchMarbleMethod];
            }
        }
    }
    
    
    
    currentTimeInteger = CFAbsoluteTimeGetCurrent();
    
    currentTimeDecimalValueOnly = CFAbsoluteTimeGetCurrent() - currentTimeInteger;
    
    appSessionStartTime = CFAbsoluteTimeGetCurrent() - appAbsoluteStartTime;
    
    [timeLabel setString:[NSString stringWithFormat:@"%f", appSessionStartTime]];
    
    
    if (isPlayer1) {
        
        if (marbleBlocksInARow == 4) {
            
            [self increaseSkillLevelBonus];
        }
    }
    
    
    //Handle the case where the bombs go out of bounds
    
    if (player2BombExists) {
        
        if ((_curBombPlayer2.position.x > SLING_POSITION_2.x + 300) || (_curBombPlayer2.position.x < SLING_POSITION.x - 300)) {
            
            [(Bomb2 *)_curBombPlayer2.shape->data startCountDown];
        }
    }
    
    if (player1BombExists) {
        
        if ((_curBomb.position.x > SLING_POSITION_2.x + 300) || (_curBomb.position.x < SLING_POSITION.x - 300)) {
            
            [(Bomb2 *)_curBomb.shape->data startCountDown];
        }
    }
    
    
    //Handle bomb zapping in multiplayer
    if (isPlayer1) {
        
        if (player1BombZapped == YES) {
            
            if (_curBomb.position.x > blockPointXValueOfMarble1) {
                
                [self smokeyExplosionPlayer1];
                [(Bomb *)_curBomb.shape->data player1BombZapped];
            }
        }
    }
    
    if (!isPlayer1) {
        
        if (player2BombZapped == YES) {
            
            if (_curBombPlayer2.position.x < blockPointXValueOfMarble2) {
                
                [self smokeyExplosionPlayer2];
                [(Bomb2 *)_curBombPlayer2.shape->data player2BombZapped];
            }
        }
    }
    
    //   NSLog (@"player2BombZapped = %i", player2BombZapped);
    //   NSLog (@"blockPointXValueOfMarble2 = %d", blockPointXValueOfMarble2);
    
    
    if (player1HasRedBall) {
        
        flamesForRedMarblePlayer1.position = ccp(bomb.position.x, bomb.position.y);
        
        if (bomb.shape->body->v.x != 0 || bomb.shape->body->v.y != 0) {
            
            float angleRadians = atanf(bomb.shape->body->v.x/bomb.shape->body->v.y);
            float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
            float cocosAngle = angleDegrees;
            
            if (bomb.shape->body->v.y > 0) {
                
                cocosAngle = cocosAngle - 180;
            }
            
            flamesForRedMarblePlayer1.rotation = cocosAngle;
        }
    }
    
    if (!player1HasRedBall) {
        
        flamesForRedMarblePlayer1.position = ccp(-300, -300);
        flamesForRedMarblePlayer1.rotation = 0;
    }
    
    if (player2HasRedBall) {
        
        flamesForRedMarblePlayer2.position = ccp(bomb2.position.x, bomb2.position.y);
        
        if (bomb2.shape->body->v.x != 0 || bomb2.shape->body->v.y != 0) {
            
            float angleRadians = atanf(bomb2.shape->body->v.x/bomb2.shape->body->v.y);
            float angleDegrees = CC_RADIANS_TO_DEGREES(angleRadians);
            float cocosAngle = angleDegrees;
            
            if (bomb2.shape->body->v.y > 0) {
                
                cocosAngle = cocosAngle - 180;
            }
            
            flamesForRedMarblePlayer2.rotation = cocosAngle;
        }
    }
    
    if (!player2HasRedBall) {
        
        flamesForRedMarblePlayer2.position = ccp(-300, -300);
        flamesForRedMarblePlayer2.rotation = 0;
    }
    
    if (player1BombExists == YES && isPlayer1 == NO) {
        
        redWarningArrow.opacity = 0;
        
        //Warning arrow pointing Left
        if ((bomb.position.x < -parallaxNode.position.x*0.591+127) && (bomb.position.y < -parallaxNode.position.y*0.591+260 && (bomb.position.x > SLING_POSITION.x + 30)) && fieldZoomedOut == NO) {
            
            redWarningArrow.position = ccp(-parallaxNode.position.x*0.591+127, bomb.position.y);
            redWarningArrow.rotation = 0;
            redWarningArrow.opacity = 255;
            // NSLog (@"Arrow following bomb's X value!");
        }
        
        //Warning arrow pointing diagonal up and left
        else if ((bomb.position.x < -parallaxNode.position.x*0.591+127) && (bomb.position.y > -parallaxNode.position.y*0.591+260) && (bomb.position.x > SLING_POSITION.x + 30) && fieldZoomedOut == NO) {
            
            if (deviceIsWidescreen) {
                
                redWarningArrow.position = ccp(-parallaxNode.position.x*0.591+127, -parallaxNode.position.y*0.591+210);
                redWarningArrow.rotation = 45;
                redWarningArrow.opacity = 255;
            }
            
            if (!deviceIsWidescreen) {
                
                redWarningArrow.position = ccp(-parallaxNode.position.x*0.591+127, -parallaxNode.position.y*0.591+240);
                redWarningArrow.rotation = 45;
                redWarningArrow.opacity = 255;
            }
        }
        
        //Warning arrow pointing up for field zoomed in
        else if ((bomb.position.y > -parallaxNode.position.y*0.591+260) && (bomb.position.x > -parallaxNode.position.x*0.591+127) && (bomb.position.x > SLING_POSITION.x + 30) && fieldZoomedOut == NO) {
            
            if (deviceIsWidescreen) {
                
                redWarningArrow.position = ccp(bomb.position.x, -parallaxNode.position.y*0.591+210);
                redWarningArrow.rotation = 90;
                redWarningArrow.opacity = 255;
                // NSLog (@"Arrow following bomb's Y value!");
            }
            
            if (!deviceIsWidescreen) {
                
                redWarningArrow.position = ccp(bomb.position.x, -parallaxNode.position.y*0.591+240);
                redWarningArrow.rotation = 90;
                redWarningArrow.opacity = 255;
                // NSLog (@"Arrow following bomb's Y value!");
            }
        }
        
        //Warning arrow pointing up for field zoomed out
        else if ((bomb.position.y > 345) && fieldZoomedOut == YES) {
            
            if (deviceIsWidescreen) {
                
                redWarningArrow.position = ccp(bomb.position.x, 275);
                redWarningArrow.rotation = 90;
                redWarningArrow.opacity = 255;
                // NSLog (@"Arrow following bomb's Y value!");
            }
            
            if (!deviceIsWidescreen) {
                
                redWarningArrow.position = ccp(bomb.position.x, 330);
                redWarningArrow.rotation = 90;
                redWarningArrow.opacity = 255;
                // NSLog (@"Arrow following bomb's Y value!");
            }
        }
        
        else {
            
            redWarningArrow.opacity =  0;
        }
    }
    
    
    
    if (player2BombExists == YES && isPlayer1 == YES) {
        
        redWarningArrow2.opacity = 0;
        redWarningArrow2.flipX = YES;
        
        //Red warning arrow pointing right
        if ((bomb2.position.x > -parallaxNode.position.x*0.591+357) && (bomb2.position.y < -parallaxNode.position.y*0.591+260) && (bomb2.position.x < SLING_POSITION_2.x - 30) && fieldZoomedOut == NO) {
            
            redWarningArrow2.position = ccp(-parallaxNode.position.x*0.591+357, bomb2.position.y);
            redWarningArrow2.rotation = 0;
            redWarningArrow2.opacity = 255;
            // NSLog (@"Arrow following bomb's X value!");
        }
        
        //Warning arrow pointing diagonal up and right
        else if ((bomb2.position.x > -parallaxNode.position.x*0.591+357) && (bomb2.position.y > -parallaxNode.position.y*0.591+260) && (bomb2.position.x < SLING_POSITION_2.x - 30) && fieldZoomedOut == NO) {
            
            if (deviceIsWidescreen) {
                
                redWarningArrow2.position = ccp(-parallaxNode.position.x*0.591+357, -parallaxNode.position.y*0.591+210);
                redWarningArrow2.rotation = 310;
                redWarningArrow2.opacity = 255;
            }
            
            if (!deviceIsWidescreen) {
                
                redWarningArrow2.position = ccp(-parallaxNode.position.x*0.591+357, -parallaxNode.position.y*0.591+240);
                redWarningArrow2.rotation = 310;
                redWarningArrow2.opacity = 255;
            }
        }
        
        //Warning arrow pointing up for field zoomed in
        else if ((bomb2.position.y > -parallaxNode.position.y*0.591+260) && (bomb2.position.x < -parallaxNode.position.x*0.591+357) && (bomb2.position.x < SLING_POSITION_2.x - 30) && fieldZoomedOut == NO) {
            
            if (deviceIsWidescreen) {
                
                redWarningArrow2.position = ccp(bomb2.position.x, -parallaxNode.position.y*0.591+210);
                redWarningArrow2.rotation = 270;
                redWarningArrow2.opacity = 255;
                // NSLog (@"Arrow following bomb's Y value!");
            }
            
            if (!deviceIsWidescreen) {
                
                redWarningArrow2.position = ccp(bomb2.position.x, -parallaxNode.position.y*0.591+240);
                redWarningArrow2.rotation = 270;
                redWarningArrow2.opacity = 255;
                // NSLog (@"Arrow following bomb's Y value!");
            }
        }
        
        //Warning arrow pointing up for field zoomed out
        else if ((bomb2.position.y > 345) && fieldZoomedOut == YES) {
            
            if (deviceIsWidescreen) {
                
                redWarningArrow2.position = ccp(bomb2.position.x, 275);
                redWarningArrow2.rotation = 270;
                redWarningArrow2.opacity = 255;
                // NSLog (@"Arrow following bomb's Y value!");
            }
            
            if (!deviceIsWidescreen) {
                
                redWarningArrow2.position = ccp(bomb2.position.x, 330);
                redWarningArrow2.rotation = 270;
                redWarningArrow2.opacity = 255;
                // NSLog (@"Arrow following bomb's Y value!");
            }
        }
        
        else {
            
            redWarningArrow2.opacity =  0;
        }
    }
    
    
    //This will determine if player1's tesla should glow
    int teslaGlowChargingTime = appSessionStartTime - chargedShotTimeStarted;
    
    if (player1ProjectileHasBeenTouched == YES && teslaGlowChargingTime >= 3) {
        
        doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = YES;
        teslaGlow1.opacity = 150;
        
        if (teslaGlowMessageSent == NO) {
            
            teslaGlowMessageSent = YES;
            [self sendTeslaGlow];
        }
    }
    
    if (player1ProjectileHasBeenTouched == YES || receivingChargingDataFromPlayer1 == YES) {
        
        projectileChargingPitchPlayer1 = appSessionStartTime - chargedShotTimeStarted + blockingChargeBonusPlayer1 + skillLevelBonus*3;
        /*
         NSLog (@"projectileChargingPitchPlayer1 = %d", projectileChargingPitchPlayer1);
         NSLog (@"appSessionStartTime = %f", appSessionStartTime);
         NSLog (@"chargedShotTimeStarted = %f", chargedShotTimeStarted);
         NSLog (@"blockingChargeBonusPlayer1 = %d", blockingChargeBonusPlayer1);
         NSLog (@"skillLevelBonus = %d", skillLevelBonus);
         */
    }
    
    else {
        
        projectileChargingPitchPlayer1 = 0 + blockingChargeBonusPlayer1 + skillLevelBonus*3;
    }
    
    
    if (projectileChargingPitchPlayer1 >= 0.0 && projectileChargingPitchPlayer1 < 2.999999) {
        
        if (player1HasYellowBall == NO) {
            
            lineArcValue = handicapCoefficientPlayer1*240;
        }
        
        
        if (player1HasYellowBall == YES) {
            
            lineArcValue = handicapCoefficientPlayer1*(240*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        
        glPointSizeValuePlayer1 = 2;
        glColorRedPlayer1 = 0;
        glColorGreenPlayer1 = 255;
        glColorBluePlayer1 = 0;
        glColorAlphaPlayer1 = 255;
    }
    
    else if (projectileChargingPitchPlayer1 >= 3.0 && projectileChargingPitchPlayer1 < 5.999999) {
        
        if (player1HasYellowBall == NO) {
            
            lineArcValue = handicapCoefficientPlayer1*(CHARGING_COEFFICIENT_STEP_1*240 + 240);
        }
        
        if (player1HasYellowBall == YES) {
            
            lineArcValue = handicapCoefficientPlayer1*((CHARGING_COEFFICIENT_STEP_1*240 + 240)*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        
        glPointSizeValuePlayer1 = 4;
        glColorRedPlayer1 = 255;
        glColorGreenPlayer1 = 255;
        glColorBluePlayer1 = 0;
        glColorAlphaPlayer1 = 255;
        
        /*  if (skillLevelBonus == 0 && player1ProjectileHasBeenTouched == YES) {
         
         doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = YES;
         teslaGlow1.opacity = 150;
         }
         */
    }
    
    else if (projectileChargingPitchPlayer1 >= 6.0 && projectileChargingPitchPlayer1 < 8.999999)  {
        
        if (player1HasYellowBall == NO) {
            
            lineArcValue = handicapCoefficientPlayer1*(CHARGING_COEFFICIENT_STEP_2*240 + 240);
        }
        
        if (player1HasYellowBall == YES) {
            
            lineArcValue = handicapCoefficientPlayer1*((CHARGING_COEFFICIENT_STEP_2*240 + 240)*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        
        glPointSizeValuePlayer1 = 4;
        glColorRedPlayer1 = 255;
        glColorGreenPlayer1 = 128;
        glColorBluePlayer1 = 0;
        glColorAlphaPlayer1 = 255;
        
        /*     if (skillLevelBonus == 1 && player1ProjectileHasBeenTouched == YES) {
         
         doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = YES;
         teslaGlow1.opacity = 150;
         }
         */
    }
    
    else if (skillLevelBonus == 0 && projectileChargingPitchPlayer1 >= 9.0) {
        
        if (player1HasYellowBall == NO) {
            
            lineArcValue = handicapCoefficientPlayer1*(CHARGING_COEFFICIENT_STEP_3*240 + 240);
        }
        
        if (player1HasYellowBall == YES) {
            
            lineArcValue = handicapCoefficientPlayer1*((CHARGING_COEFFICIENT_STEP_3*240 + 240)*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        
        if (guideLineIsBlinking == NO) {
            
            [self chargeMaxedOutBlinkGuideLine];
        }
        
        if (chargeMaxedOut == NO) {
            glPointSizeValuePlayer1 = 6;
            glColorRedPlayer1 = 255;
            glColorGreenPlayer1 = 0;
            glColorBluePlayer1 = 0;
            glColorAlphaPlayer1 = 255;
        }
        
        else if (chargeMaxedOut == YES) {
            
            glPointSizeValuePlayer1 = 6;
            glColorRedPlayer1 = 255;
            glColorGreenPlayer1 = 250;
            glColorBluePlayer1 = 250;
            glColorAlphaPlayer1 = 255;
        }
    }
    
    else if (projectileChargingPitchPlayer1 >= 9.0 && projectileChargingPitchPlayer1 < 11.999999 && (skillLevelBonus == 1 || skillLevelBonus >= 2)) {
        
        if (player1HasYellowBall == NO) {
            
            lineArcValue = handicapCoefficientPlayer1*(CHARGING_COEFFICIENT_STEP_3*240 + 240);
        }
        
        if (player1HasYellowBall == YES) {
            
            lineArcValue = handicapCoefficientPlayer1*((CHARGING_COEFFICIENT_STEP_3*240 + 240)*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        /*
         if (skillLevelBonus == 2 && player1ProjectileHasBeenTouched == YES) {
         
         doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = YES;
         teslaGlow1.opacity = 150;
         }
         */
        glPointSizeValuePlayer1 = 6;
        glColorRedPlayer1 = 255;
        glColorGreenPlayer1 = 0;
        glColorBluePlayer1 = 0;
        glColorAlphaPlayer1 = 255;
    }
    
    else if (skillLevelBonus == 1 && projectileChargingPitchPlayer1 >= 12.0) {
        
        if (player1HasYellowBall == NO) {
            
            lineArcValue = handicapCoefficientPlayer1*(CHARGING_COEFFICIENT_STEP_4*240 + 240);
        }
        
        if (player1HasYellowBall == YES) {
            
            lineArcValue = handicapCoefficientPlayer1*((CHARGING_COEFFICIENT_STEP_4*240 + 240)*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        
        if (guideLineIsBlinking == NO) {
            
            [self chargeMaxedOutBlinkGuideLine];
        }
        
        if (chargeMaxedOut == NO) {
            glPointSizeValuePlayer1 = 6;
            glColorRedPlayer1 = 72;
            glColorGreenPlayer1 = 61;
            glColorBluePlayer1 = 139;
            glColorAlphaPlayer1 = 255;
        }
        
        else if (chargeMaxedOut == YES) {
            
            glPointSizeValuePlayer1 = 6;
            glColorRedPlayer1 = 255;
            glColorGreenPlayer1 = 250;
            glColorBluePlayer1 = 250;
            glColorAlphaPlayer1 = 255;
        }
    }
    
    
    else if (projectileChargingPitchPlayer1 >= 12.0 && projectileChargingPitchPlayer1 < 14.999999 && skillLevelBonus >= 2) {
        
        if (player1HasYellowBall == NO) {
            
            lineArcValue = handicapCoefficientPlayer1*(CHARGING_COEFFICIENT_STEP_4*240 + 240);
        }
        
        if (player1HasYellowBall == YES) {
            
            lineArcValue = handicapCoefficientPlayer1*((CHARGING_COEFFICIENT_STEP_4*240 + 240)*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        
        glPointSizeValuePlayer1 = 6;
        glColorRedPlayer1 = 72;
        glColorGreenPlayer1 = 61;
        glColorBluePlayer1 = 139;
        glColorAlphaPlayer1 = 255;
    }
    
    else if (projectileChargingPitchPlayer1 >= 15.0 && skillLevelBonus >= 2) {
        
        if (player1HasYellowBall == NO) {
            
            lineArcValue = handicapCoefficientPlayer1*(CHARGING_COEFFICIENT_STEP_5*240 + 240);
        }
        
        if (player1HasYellowBall == YES) {
            
            lineArcValue = handicapCoefficientPlayer1*((CHARGING_COEFFICIENT_STEP_5*240 + 240)*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        
        if (guideLineIsBlinking == NO) {
            
            [self chargeMaxedOutBlinkGuideLine];
        }
        
        if (chargeMaxedOut == NO) {
            glPointSizeValuePlayer1 = 6;
            glColorRedPlayer1 = 25;
            glColorGreenPlayer1 = 25;
            glColorBluePlayer1 = 112;
            glColorAlphaPlayer1 = 255;
        }
        
        else if (chargeMaxedOut == YES) {
            
            glPointSizeValuePlayer1 = 6;
            glColorRedPlayer1 = 255;
            glColorGreenPlayer1 = 250;
            glColorBluePlayer1 = 250;
            glColorAlphaPlayer1 = 255;
        }
    }
    
    tesla.color = ccc3(glColorRedPlayer1, glColorGreenPlayer1, glColorBluePlayer1);
    
    
    //This will determine if player2's tesla should glow
    int teslaGlowChargingTime2 = appSessionStartTime - chargedShotTimeStarted2;
    
    if (player2ProjectileHasBeenTouched == YES && teslaGlowChargingTime2 >= 3) {
        
        doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = YES;
        teslaGlow2.opacity = 150;
        
        if (teslaGlowMessageSent == NO) {
            
            teslaGlowMessageSent = YES;
            [self sendTeslaGlow];
        }
    }
    
    if (player2ProjectileHasBeenTouched == YES || receivingChargingDataFromPlayer2 == YES) {
        
        projectileChargingPitchPlayer2 = appSessionStartTime - chargedShotTimeStarted2 + blockingChargeBonusPlayer2 + skillLevelBonus*3;
    }
    
    else {
        
        projectileChargingPitchPlayer2 = 0 + blockingChargeBonusPlayer2 + skillLevelBonus*3;
    }
    
    if (projectileChargingPitchPlayer2 >= 0.0 && projectileChargingPitchPlayer2 < 2.999999) {
        
        if (player2HasYellowBall == NO) {
            
            lineArcValue2 = handicapCoefficientPlayer2*240;
        }
        
        if (player2HasYellowBall == YES) {
            
            lineArcValue2 = handicapCoefficientPlayer2*(240*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        
        glPointSizeValuePlayer2 = 2;
        glColorRedPlayer2 = 0;
        glColorGreenPlayer2 = 255;
        glColorBluePlayer2 = 0;
        glColorAlphaPlayer2 = 255;
    }
    
    else if (projectileChargingPitchPlayer2 >= 3.0 && projectileChargingPitchPlayer2 < 5.999999) {
        
        if (player2HasYellowBall == NO) {
            
            lineArcValue2 = handicapCoefficientPlayer2*(CHARGING_COEFFICIENT_STEP_1*240 + 240);
        }
        
        if (player2HasYellowBall == YES) {
            
            lineArcValue2 = handicapCoefficientPlayer2*((CHARGING_COEFFICIENT_STEP_1*240 + 240)*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        
        glPointSizeValuePlayer2 = 4;
        glColorRedPlayer2 = 255;
        glColorGreenPlayer2 = 255;
        glColorBluePlayer2 = 0;
        glColorAlphaPlayer2 = 255;
        /*
         if (skillLevelBonus == 0 && player2ProjectileHasBeenTouched == YES) {
         
         doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = YES;
         teslaGlow2.opacity = 150;
         }
         */
    }
    
    else if (projectileChargingPitchPlayer2 >= 6.0 && projectileChargingPitchPlayer2 < 8.999999) {
        
        if (player2HasYellowBall == NO) {
            
            lineArcValue2 = handicapCoefficientPlayer2*(CHARGING_COEFFICIENT_STEP_2*240 + 240);
        }
        
        if (player2HasYellowBall == YES) {
            
            lineArcValue2 = handicapCoefficientPlayer2*((CHARGING_COEFFICIENT_STEP_2*240 + 240)*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        
        glPointSizeValuePlayer2 = 4;
        glColorRedPlayer2 = 255;
        glColorGreenPlayer2 = 128;
        glColorBluePlayer2 = 0;
        glColorAlphaPlayer2 = 255;
        
        /*
         if (skillLevelBonus == 1 && player2ProjectileHasBeenTouched == YES) {
         
         doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = YES;
         teslaGlow2.opacity = 150;
         }
         */
    }
    
    else if (skillLevelBonus == 0 && projectileChargingPitchPlayer2 >= 9.0) {
        
        if (player2HasYellowBall == NO) {
            
            lineArcValue2 = handicapCoefficientPlayer2*(CHARGING_COEFFICIENT_STEP_3*240 + 240);
        }
        
        if (player2HasYellowBall == YES) {
            
            lineArcValue2 = handicapCoefficientPlayer2*((CHARGING_COEFFICIENT_STEP_3*240 + 240)*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        
        if (guideLineIsBlinking == NO) {
            
            [self chargeMaxedOutBlinkGuideLine];
        }
        
        if (chargeMaxedOut == NO) {
            glPointSizeValuePlayer2 = 6;
            glColorRedPlayer2 = 255;
            glColorGreenPlayer2 = 0;
            glColorBluePlayer2 = 0;
            glColorAlphaPlayer2 = 255;
        }
        
        else if (chargeMaxedOut == YES) {
            
            glPointSizeValuePlayer2 = 6;
            glColorRedPlayer2 = 255;
            glColorGreenPlayer2 = 250;
            glColorBluePlayer2 = 250;
            glColorAlphaPlayer2 = 255;
        }
    }
    
    else if (projectileChargingPitchPlayer2 >= 9.0 && projectileChargingPitchPlayer2 < 11.999999 && (skillLevelBonus == 1 || skillLevelBonus >= 2)) {
        
        if (player2HasYellowBall == NO) {
            
            lineArcValue2 = handicapCoefficientPlayer2*(CHARGING_COEFFICIENT_STEP_3*240 + 240);
        }
        
        if (player2HasYellowBall == YES) {
            
            lineArcValue2 = handicapCoefficientPlayer2*((CHARGING_COEFFICIENT_STEP_3*240 + 240)*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        /*
         if (skillLevelBonus == 2 && player2ProjectileHasBeenTouched == YES) {
         
         doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = YES;
         teslaGlow2.opacity = 150;
         }
         */
        glPointSizeValuePlayer2 = 6;
        glColorRedPlayer2 = 255;
        glColorGreenPlayer2 = 0;
        glColorBluePlayer2 = 0;
        glColorAlphaPlayer2 = 255;
    }
    
    else if (skillLevelBonus == 1 && projectileChargingPitchPlayer2 >= 12.0) {
        
        if (player2HasYellowBall == NO) {
            
            lineArcValue2 = handicapCoefficientPlayer2*(CHARGING_COEFFICIENT_STEP_4*240 + 240);
        }
        
        if (player2HasYellowBall == YES) {
            
            lineArcValue2 = handicapCoefficientPlayer2*((CHARGING_COEFFICIENT_STEP_4*240 + 240)*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        
        if (guideLineIsBlinking == NO) {
            
            [self chargeMaxedOutBlinkGuideLine];
        }
        
        if (chargeMaxedOut == NO) {
            glPointSizeValuePlayer2 = 6;
            glColorRedPlayer2 = 72;
            glColorGreenPlayer2 = 61;
            glColorBluePlayer2 = 139;
            glColorAlphaPlayer2 = 255;
        }
        
        else if (chargeMaxedOut == YES) {
            
            glPointSizeValuePlayer2 = 6;
            glColorRedPlayer2 = 255;
            glColorGreenPlayer2 = 250;
            glColorBluePlayer2 = 250;
            glColorAlphaPlayer2 = 255;
        }
    }
    
    
    else if (projectileChargingPitchPlayer2 >= 12.0 && projectileChargingPitchPlayer2 < 14.999999 && skillLevelBonus >= 2) {
        
        if (player2HasYellowBall == NO) {
            
            lineArcValue2 = handicapCoefficientPlayer2*(CHARGING_COEFFICIENT_STEP_4*240 + 240);
        }
        
        if (player2HasYellowBall == YES) {
            
            lineArcValue2 = handicapCoefficientPlayer2*((CHARGING_COEFFICIENT_STEP_4*240 + 240)*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        
        glPointSizeValuePlayer2 = 6;
        glColorRedPlayer2 = 72;
        glColorGreenPlayer2 = 61;
        glColorBluePlayer2 = 139;
        glColorAlphaPlayer2 = 255;
    }
    
    else if (projectileChargingPitchPlayer2 >= 15.0 && skillLevelBonus >= 2) {
        
        if (player2HasYellowBall == NO) {
            
            lineArcValue2 = handicapCoefficientPlayer2*(CHARGING_COEFFICIENT_STEP_5*240 + 240);
        }
        
        if (player2HasYellowBall == YES) {
            
            lineArcValue2 = handicapCoefficientPlayer2*((CHARGING_COEFFICIENT_STEP_5*240 + 240)*YELLOW_BALL_SPEED_MULTIPLIER);
        }
        
        if (guideLineIsBlinking == NO) {
            
            [self chargeMaxedOutBlinkGuideLine];
        }
        
        if (chargeMaxedOut == NO) {
            
            glPointSizeValuePlayer2 = 6;
            glColorRedPlayer2 = 25;
            glColorGreenPlayer2 = 25;
            glColorBluePlayer2 = 112;
            glColorAlphaPlayer2 = 255;
        }
        
        else if (chargeMaxedOut == YES) {
            
            glPointSizeValuePlayer2 = 6;
            glColorRedPlayer2 = 255;
            glColorGreenPlayer2 = 250;
            glColorBluePlayer2 = 250;
            glColorAlphaPlayer2 = 255;
        }
    }
    
    //CPU Tesla Colors according to computerNumberOfChargingRounds and skillLevelBonus
    if (isSinglePlayer) {
        
        if (skillLevelBonus == 0) {
            
            if (computerNumberOfChargingRounds == 0) {
                
                glPointSizeValuePlayer2 = 2;
                glColorRedPlayer2 = 0;
                glColorGreenPlayer2 = 255;
                glColorBluePlayer2 = 0;
                glColorAlphaPlayer2 = 255;
            }
            
            else if (computerNumberOfChargingRounds == 1) {
                
                glPointSizeValuePlayer2 = 4;
                glColorRedPlayer2 = 255;
                glColorGreenPlayer2 = 255;
                glColorBluePlayer2 = 0;
                glColorAlphaPlayer2 = 255;
            }
            
            else if (computerNumberOfChargingRounds == 2) {
                
                glPointSizeValuePlayer2 = 6;
                glColorRedPlayer2 = 255;
                glColorGreenPlayer2 = 128;
                glColorBluePlayer2 = 0;
                glColorAlphaPlayer2 = 255;
            }
            
            else if (computerNumberOfChargingRounds == 3) {
                
                glPointSizeValuePlayer2 = 6;
                glColorRedPlayer2 = 255;
                glColorGreenPlayer2 = 0;
                glColorBluePlayer2 = 0;
                glColorAlphaPlayer2 = 255;
            }
        }
        
        if (skillLevelBonus == 1) {
            
            if (computerNumberOfChargingRounds == 0) {
                
                glPointSizeValuePlayer2 = 4;
                glColorRedPlayer2 = 255;
                glColorGreenPlayer2 = 255;
                glColorBluePlayer2 = 0;
                glColorAlphaPlayer2 = 255;
            }
            
            else if (computerNumberOfChargingRounds == 1) {
                
                glPointSizeValuePlayer2 = 6;
                glColorRedPlayer2 = 255;
                glColorGreenPlayer2 = 128;
                glColorBluePlayer2 = 0;
                glColorAlphaPlayer2 = 255;
            }
            
            else if (computerNumberOfChargingRounds == 2) {
                
                glPointSizeValuePlayer2 = 6;
                glColorRedPlayer2 = 255;
                glColorGreenPlayer2 = 0;
                glColorBluePlayer2 = 0;
                glColorAlphaPlayer2 = 255;
            }
            
            else if (computerNumberOfChargingRounds == 3) {
                
                glPointSizeValuePlayer2 = 6;
                glColorRedPlayer2 = 72;
                glColorGreenPlayer2 = 61;
                glColorBluePlayer2 = 139;
                glColorAlphaPlayer2 = 255;
            }
        }
        
        if (skillLevelBonus == 2) {
            
            if (computerNumberOfChargingRounds == 0) {
                
                glPointSizeValuePlayer2 = 6;
                glColorRedPlayer2 = 255;
                glColorGreenPlayer2 = 128;
                glColorBluePlayer2 = 0;
                glColorAlphaPlayer2 = 255;
            }
            
            else if (computerNumberOfChargingRounds == 1) {
                
                glPointSizeValuePlayer2 = 6;
                glColorRedPlayer2 = 255;
                glColorGreenPlayer2 = 0;
                glColorBluePlayer2 = 0;
                glColorAlphaPlayer2 = 255;
            }
            
            else if (computerNumberOfChargingRounds == 2) {
                
                glPointSizeValuePlayer2 = 6;
                glColorRedPlayer2 = 72;
                glColorGreenPlayer2 = 61;
                glColorBluePlayer2 = 139;
                glColorAlphaPlayer2 = 255;
            }
            
            else if (computerNumberOfChargingRounds == 3) {
                
                glPointSizeValuePlayer2 = 6;
                glColorRedPlayer2 = 25;
                glColorGreenPlayer2 = 25;
                glColorBluePlayer2 = 112;
                glColorAlphaPlayer2 = 255;
            }
        }
    }
    
    tesla2.color = ccc3(glColorRedPlayer2, glColorGreenPlayer2, glColorBluePlayer2);
    
    
    if (player1BombInPlay == NO && firstPlayer1MarbleSetToGreen == YES) {
        
        if (isPlayer1) {
            
            //   [self setupBombsPlayer1];
            
            //   [self setupNextBombPlayer1];
        }
    }
    
    if (player2BombInPlay == NO && firstPlayer2MarbleSetToGreen == YES) {
        
        if (!isPlayer1) {
            
            //   [self setupBombsPlayer2];
            
            //   [self setupNextBombPlayer2];
        }
    }

    
    
    if (currentTimeDecimalValueOnly < 0.05) {
        
        if (isPlayer1) {
            
            [self sendProjectileChargingPitchFromPlayer1];
        }
        
        if (!isPlayer1) {
            
            [self sendProjectileChargingPitchFromPlayer2];
        }
    }
}


/*
 -(void) elapsedTime: (ccTime) delta
 {
 [self currentElapsedTime];
 
 if (currentElapsedTime % 2 == 0) {
 [self sendTime];
 }
 }
 */

-(void) blowupGerty1AndRunPlayer2IsTheWinnerScript
{
    gertyPlayer1Alive = NO;
    [(Gerty*)gerty blowup];
    
    [self player2IsTheWinnerScript];
}

-(void) blowupGerty2AndRunPlayer1IsTheWinnerScript
{
    gertyPlayer2Alive = NO;
    [(Gerty2*)gerty2 blowup];
    
    [self player1IsTheWinnerScript];
}

-(void) playerSteelStrikingSound
{
    [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber18 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
}

-(void) increaseSkillLevelBonusGraphic
{
    marbleBlocksInARow = 0;
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.0], [CCCallFunc actionWithTarget:self selector:@selector(playerSteelStrikingSound)], nil]];
    
    if (skillLevelBonus == 1) {
        
        skillLevelUpLightningBolt1.color = ccYELLOW;
        skillLevelUpLightningBolt2.color = ccYELLOW;
    }
    
    else if (skillLevelBonus == 2) {
        
        skillLevelUpLightningBolt1.color = ccc3(255, 128, 0);
        skillLevelUpLightningBolt2.color = ccc3(255, 128, 0);
    }
    
    skillLevelUpLightningBolt1.position = sling1.position;
    skillLevelUpLightningBolt1.scale = 1.0;
    skillLevelUpLightningBolt1.opacity = 150;
    
    [skillLevelUpLightningBolt1 runAction: [CCEaseIn actionWithAction: [CCScaleTo actionWithDuration:1.0 scale: 0.5] rate:5.0]];
    [skillLevelUpLightningBolt1 runAction: [CCFadeIn actionWithDuration: 1.0]];
    
    [skillLevelUpLightningBolt1 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 2.5], [CCFadeOut actionWithDuration: 0.7], [CCMoveTo actionWithDuration: 0 position: ccp(-300, -300)], [CCFadeIn actionWithDuration: 0.0], nil]];
    
    skillLevelUpLightningBolt2.position = sling1Player2.position;
    skillLevelUpLightningBolt2.scale = 1.0;
    skillLevelUpLightningBolt2.opacity = 150;
    
    [skillLevelUpLightningBolt2 runAction: [CCEaseIn actionWithAction: [CCScaleTo actionWithDuration:1.0 scale: 0.5] rate:5.0]];
    [skillLevelUpLightningBolt2 runAction: [CCFadeIn actionWithDuration: 1.0]];
    
    [skillLevelUpLightningBolt2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 2.5], [CCFadeOut actionWithDuration: 0.7], [CCMoveTo actionWithDuration: 0 position: ccp(-300, -300)], nil]];
}

-(void) increaseSkillLevelBonus
{
    skillLevelBonus = skillLevelBonus + 1;
    
    if (isPlayer1) {
        
        [self sendIncreaseSkillLevelBonus];
    }
    
    [self increaseSkillLevelBonusGraphic];
    [self decreaseBigSmokeTimeIntervalForBothPlayers];
}

-(BOOL) aboutToReadShape:(cpShape*)shape shapeId:(long)id
{
	if (shape->collision_type == kBombCollisionType)
	{
		Bomb *bomb = [Bomb bombWithGame:self shape:shape];
		[self addChild:bomb z:5];
		
		if (cpBodyGetMass(shape->body) == STATIC_MASS)
			[_bombsPlayer1 addObject:bomb];
	}
	else if (shape->collision_type == kNinjaCollisionType)
	{
		Ninja *ninja = [Ninja ninjaWithGame:self shape:shape];
		[self addChild:ninja z:5];
	}
	else if (shape->collision_type == kBlockCollisionType)
	{
		cpShapeNode *node = [cpShapeNode nodeWithShape:shape];
		node.color = ccc3(56+rand()%200, 56+rand()%200, 56+rand()%200);
		[self addChild:node z:5];
	}
	
	//This just means accept the reading of this shape
	return YES;
}
/*
 // Pan board
 - (void)moveBoard:(CGPoint)translation from:(CGPoint)lastLocation {
 target_position = ccpAdd(translation, lastLocation);
 
 CGSize winSize = [[CCDirector sharedDirector] winSize];
 
 // Insert routine here to check that target position is not out of bounds for your background
 // Remember that ZB_last_posn is a variable that holds the current position of zoombase
 
 if (background) {
 
 if ((target_position.x > -1.5*background.contentSize.width+(winSize.width) - ((1.5*background.contentSize.width)*(zoombase.scale-1))) && (target_position.x < 0) && (target_position.y < 0) && ((target_position.y > -1.5*background.contentSize.height+(winSize.height) - ((1.5*background.contentSize.height)*(zoombase.scale-1))))) {
 //allow zoombase.position to move freely
 zoombase.position = ccp(target_position.x, target_position.y);
 }
 
 if ((target_position.x <= -1.5*background.contentSize.width+(winSize.width) - ((1.5*background.contentSize.width)*(zoombase.scale-1)))) {
 //set zoombase.position.x to -480(or the negative width of the background) and allow target_position.y to move freely.
 zoombase.position = ccp((-1.5*background.contentSize.width+(winSize.width) - ((1.5*background.contentSize.width)*(zoombase.scale-1))), target_position.y);
 }
 
 if (target_position.x >= 0) {
 //set zoombase.position.x to 0 and allow target_position.y to move freely
 zoombase.position = ccp(0, target_position.y);
 }
 
 if (target_position.y >= 0) {
 //set zoombase.position.y to 0 and allow target_position.x to move freely.
 zoombase.position = ccp(target_position.x, 0);
 }
 
 if (target_position.y <= ((-1.5*background.contentSize.height+(winSize.height) - ((1.5*background.contentSize.height)*(zoombase.scale-1))))) {
 //set zoombase.position.y to -320(or the negative height of the background) and allow target_position.x to move freely.
 zoombase.position = ccp(target_position.x, ((-1.5*background.contentSize.height+(winSize.height) - ((1.5*background.contentSize.height)*(zoombase.scale-1)))));
 }
 
 if (target_position.x >= 0 && target_position.y >= 0) {
 zoombase.position = ccp(0,0);
 }
 
 if ((target_position.x <= ((-1.5*background.contentSize.width+(winSize.width) - ((1.5*background.contentSize.width)*(zoombase.scale-1))))) && target_position.y >= 0) {
 zoombase.position = ccp((-1.5*background.contentSize.width+(winSize.width) - ((1.5*background.contentSize.width)*(zoombase.scale-1))),0);
 }
 
 if ((target_position.x < -1.5*background.contentSize.width+(winSize.width) - ((1.5*background.contentSize.width)*(zoombase.scale-1))) && (target_position.y < -1.5*background.contentSize.height+(winSize.height) - ((1.5*background.contentSize.height)*(zoombase.scale-1)))) {
 zoombase.position = ccp((-1.5*background.contentSize.width+(winSize.width) - ((1.5*background.contentSize.width)*(zoombase.scale-1))),(-1.5*background.contentSize.height+(winSize.height) - ((1.5*background.contentSize.height)*(zoombase.scale-1))));
 }
 
 if (target_position.x >= 0 && ((target_position.y <= ((-1.5*background.contentSize.height+(winSize.height) - ((1.5*background.contentSize.height)*(zoombase.scale-1))))))) {
 zoombase.position = ccp(0, ((-1.5*background.contentSize.height+(winSize.height) - ((1.5*background.contentSize.height)*(zoombase.scale-1)))));
 }
 }
 }
 */

- (void) syncShapesOnPlayer1
{
    if (!isPlayer1) {
        
        //NSLog (@"I am player2");
        [shapeIDAndPositions removeAllObjects];
        [shapesArrayPlayer2ToSend removeAllObjects];
        [shapesArrayInPlayer2 removeAllObjects];
        
        NSArray *shapesArray = [smgr getShapesAt:ccp(240, 160) radius:1000];
        
        for (NSValue *v in shapesArray) {
            
            cpShape *shape = [v pointerValue];
            
            if (shape->collision_type == 3) {
                
                NSNumber *shapeHashID = [NSNumber numberWithInt: shape->hashid];
                NSValue *points = [NSValue valueWithCGPoint: shape->body->p];
                NSNumber *angle = [NSNumber numberWithInt: shape->body->a];
                
                [shapeIDAndPositions setObject: shapeHashID forKey: points];
                [shapesAngles setObject: shapeHashID forKey: angle];
            }
        }
        
        NSArray *shapesArrayPlayer2Temp = [smgr getShapesAt:ccp(240, 160) radius:1000];
        
        for (NSValue *v in shapesArrayPlayer2Temp) {
            
            cpShape *shape = [v pointerValue];
            
            if (shape->collision_type == 3) {
                
                NSNumber *shapeHashID = [NSNumber numberWithInt: shape->hashid];
                
                [shapesArrayPlayer2ToSend addObject: shapeHashID];
            }
        }
        
        NSArray *shapesArrayPlayer2Temp2 = [smgr getShapesAt:ccp(240, 160) radius:1000];
        
        for (NSValue *v in shapesArrayPlayer2Temp2) {
            
            cpShape *shape = [v pointerValue];
            
            if (shape->collision_type == 3) {
                
                NSNumber *shapeHashID = [NSNumber numberWithInt: shape->hashid];
                
                [shapesArrayInPlayer2 addObject: shapeHashID];
            }
        }
        
        //[self sendBlocksPositionsFromPlayer1];
    }
}

- (void) syncShapesOnPlayer2
{
    if (isPlayer1) {
        
        //NSLog (@"I am player1");
        [shapeIDAndPositions removeAllObjects];
        [shapesMutableArrayPlayer1 removeAllObjects];
        
        NSArray *shapesArrayPlayer1 = [smgr getShapesAt:ccp(240, 160) radius:1000];
        
        for (NSValue *v in shapesArrayPlayer1) {
            
            cpShape *shape = [v pointerValue];
            
            if (shape->collision_type == 3) {
                
                NSNumber *shapeHashID = [NSNumber numberWithInt: shape->hashid];
                
                [shapesMutableArrayPlayer1 addObject: shapeHashID];
            }
        }
        
        NSArray *shapesArrayPlayer1Temp1 = [smgr getShapesAt:ccp(240, 160) radius:1000];
        
        for (NSValue *v in shapesArrayPlayer1Temp1) {
            
            cpShape *shape = [v pointerValue];
            
            if (shape->collision_type == 3) {
                
                NSNumber *shapeHashID = [NSNumber numberWithInt: shape->hashid];
                
                [shapesArrayInPlayer1 addObject: shapeHashID];
            }
        }
        
        //      [self sendShapesArray2];
    }
}

-(void) chargedShotTimeMethod
{
    chargedShotTimeStarted = appSessionStartTime;
}
/*
 -(void) delayShotTimeMethod
 {
 if (isPlayer1 && player1HasTheToken && tokenHasAlreadyReachedPlayer2 == NO) {
 
 timeAtBeginningOfTimeCycle = CFAbsoluteTimeGetCurrent();
 timeAtBeginningOfTimeCycleSet = YES;
 NSLog (@"timeAtBeginningOfTimeCycle = %f", timeAtBeginningOfTimeCycle);
 }
 
 else if (isPlayer1 && !player1HasTheToken && tokenHasAlreadyReachedPlayer2 == NO) {
 
 tokenHasAlreadyReachedPlayer2 = YES;
 }
 
 else if (isPlayer1 && player1HasTheToken && tokenHasAlreadyReachedPlayer2 == YES) {
 
 timeAtEndingOfTimeCycle = CFAbsoluteTimeGetCurrent();
 tokenHasAlreadyReachedPlayer2 = NO;
 NSLog (@"timeAtEndingOfTimeCycle = %f", timeAtEndingOfTimeCycle);
 }
 
 if (isPlayer1) {
 
 double delayShotTime = timeAtEndingOfTimeCycle - timeAtBeginningOfTimeCycle;
 NSLog (@"DelayShotTime = %f", delayShotTime);
 NSLog (@"CFAbsoluteTimeGetCurrent = %f", CFAbsoluteTimeGetCurrent());
 }
 }
 */

-(void) lightningBoltBlockPlayer1
{
    lightningBolt1.position = bomb.position;
    
    [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber16 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
    
    [lightningBolt1 runAction: [CCSequence actions: [CCMoveBy actionWithDuration:1.0 position: ccp(0, 60)], [CCMoveTo actionWithDuration:1.0 position: SLING_POSITION_2], [CCFadeOut actionWithDuration:1.0], [CCMoveTo actionWithDuration:0 position: ccp(-300,-300)], [CCFadeIn actionWithDuration:0], nil]];
}

-(void) lightningBoltBlockPlayer2
{
    lightningBolt2.position = bomb2.position;
    
    [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber16 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
    
    [lightningBolt2 runAction: [CCSequence actions: [CCMoveBy actionWithDuration:1.0 position: ccp(0, 60)], [CCMoveTo actionWithDuration:1.0 position: SLING_POSITION], [CCFadeOut actionWithDuration:1.0], [CCMoveTo actionWithDuration:0 position: ccp(-300,-300)], [CCFadeIn actionWithDuration:0], nil]];
}

-(void) chargingRisingSmoke
{
    CCSprite *chargingRisingSmoke = [CCSprite spriteWithSpriteFrameName: @"dustcloud-hd.png"];
    [zoombase addChild: chargingRisingSmoke z:5];
    chargingRisingSmoke.position = SLING_BOMB_POSITION;
    chargingRisingSmoke.scale = 0.15;
    
    [chargingRisingSmoke runAction: [CCScaleBy actionWithDuration:1.0 scale:2.0]];
    [chargingRisingSmoke runAction: [CCFadeOut actionWithDuration:1.0]];
    [chargingRisingSmoke runAction: [CCSequence actions: [CCMoveBy actionWithDuration:1.0 position:ccp(0, 20)], [CCCallFuncND actionWithTarget:chargingRisingSmoke selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], nil]];
}

-(void) chargingRisingSmokePlayer2
{
    CCSprite *chargingRisingSmokePlayer2 = [CCSprite spriteWithSpriteFrameName: @"dustcloud-hd.png"];
    [zoombase addChild: chargingRisingSmokePlayer2 z:5];
    chargingRisingSmokePlayer2.position = SLING_BOMB_POSITION_2;
    chargingRisingSmokePlayer2.scale = 0.15;
    
    [chargingRisingSmokePlayer2 runAction: [CCScaleBy actionWithDuration:1.0 scale:2.0]];
    [chargingRisingSmokePlayer2 runAction: [CCFadeOut actionWithDuration:1.0]];
    [chargingRisingSmokePlayer2 runAction: [CCSequence actions: [CCMoveBy actionWithDuration:1.0 position:ccp(0, 20)], [CCCallFuncND actionWithTarget:chargingRisingSmokePlayer2 selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], nil]];
}

-(void) smokeyExplosionPlayer1
{
    smokePlayer1.position = bomb.position;
    [smokePlayer1 runAction: [CCMoveBy actionWithDuration:1.5 position: ccp(0, 35)]];
    [smokePlayer1 runAction: [CCScaleBy actionWithDuration:1.5 scale:1.5]];
    [smokePlayer1 runAction: [CCFadeOut actionWithDuration:1.5]];
    
    CDXAudioNode *audioElectricuteProjectile = [[smokePlayer1 children] objectAtIndex:0];
    [audioElectricuteProjectile play];
    
    [smokePlayer1 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.5], [CCMoveTo actionWithDuration:0 position: ccp(-300,-300)], [CCScaleTo actionWithDuration:0 scale:1], [CCFadeIn actionWithDuration:0], nil]];
}

-(void) smokeyExplosionPlayer2
{
    smokePlayer2.position = bomb2.position;
    [smokePlayer2 runAction: [CCMoveBy actionWithDuration:1.5 position: ccp(0, 35)]];
    [smokePlayer2 runAction: [CCScaleBy actionWithDuration:1.5 scale:1.5]];
    [smokePlayer2 runAction: [CCFadeOut actionWithDuration:1.5]];
    
    CDXAudioNode *audioElectricuteProjectile2 = [[smokePlayer2 children] objectAtIndex:0];
    [audioElectricuteProjectile2 play];
    
    [smokePlayer2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.5], [CCMoveTo actionWithDuration:0 position: ccp(-300,-300)], [CCScaleTo actionWithDuration:0 scale:1], [CCFadeIn actionWithDuration:0], nil]];
}

-(void) smokeyExplosionGertyPlayer1
{
    smokePlayer1.position = gerty.position;
    [smokePlayer1 runAction: [CCMoveBy actionWithDuration:4.5 position: ccp(0, 35)]];
    [smokePlayer1 runAction: [CCScaleBy actionWithDuration:4.5 scale:1.5]];
    [smokePlayer1 runAction: [CCFadeOut actionWithDuration:4.5]];
    /*
     CDXAudioNode *audioElectricuteProjectile = [[smokePlayer1 children] objectAtIndex:0];
     [audioElectricuteProjectile play];
     */
    [smokePlayer1 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.5], [CCMoveTo actionWithDuration:0 position: ccp(-300,-300)], [CCScaleTo actionWithDuration:0 scale:1], [CCFadeIn actionWithDuration:0], nil]];
}

-(void) smokeyExplosionGertyPlayer2
{
    smokePlayer2.position = gerty2.position;
    [smokePlayer2 runAction: [CCMoveBy actionWithDuration:4.5 position: ccp(0, 35)]];
    [smokePlayer2 runAction: [CCScaleBy actionWithDuration:4.5 scale:1.5]];
    [smokePlayer2 runAction: [CCFadeOut actionWithDuration:4.5]];
    /*
     CDXAudioNode *audioElectricuteProjectile2 = [[smokePlayer2 children] objectAtIndex:0];
     [audioElectricuteProjectile2 play];
     */
    [smokePlayer2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.5], [CCMoveTo actionWithDuration:0 position: ccp(-300,-300)], [CCScaleTo actionWithDuration:0 scale:1], [CCFadeIn actionWithDuration:0], nil]];
}

- (void) launchMarbleInTouchEnded
{
    if (isPlayer1) {
        
        [audioPreLaunchCharge stop];
        
        //_curBomb.shape->layers = 1;
        
        [smgr morphShapeToActive:_curBomb.shape mass:30];
        tesla.position = ccp(sling1.position.x - 5, sling1.position.y + 7);
        tesla.displacement = 11;
        
        if (!player1HasYellowBall) {
            
            [_curBomb applyImpulse:cpvmult(player1Vector, projectileImpulsePlayer1)];
        }
        
        if (player1HasYellowBall) {
            
            float projectileImpulsePlayer1YellowBall = projectileImpulsePlayer1*YELLOW_BALL_SPEED_MULTIPLIER;
            [_curBomb applyImpulse:cpvmult(player1Vector, projectileImpulsePlayer1YellowBall)];
            
            NSLog (@"projectileImpulsePlayer1YellowBall = %f", projectileImpulsePlayer1YellowBall);
        }
        
        _curBomb.shape->body->w = marble1RotationalVelocity;
        
        CDXAudioNode *audioProjectileLaunch = [[sling1 children] objectAtIndex:1];
        [audioProjectileLaunch play];
        
        CDXAudioNode *audioIncomingProjectile = [[bomb children] objectAtIndex:0];
        [audioIncomingProjectile play];
        
        projectileLaunchMultiplier = 0;
    }
    
    if (!isPlayer1) {
        
        [self zoomOut];
        
        [audioPreLaunchCharge2 stop];
        
        //_curBombPlayer2.shape->layers = 2;
        
        [smgr morphShapeToActive:_curBombPlayer2.shape mass:30];
        tesla2.displacement = 11;
        
        if (!player2HasYellowBall) {
            
            [_curBombPlayer2 applyImpulse:cpvmult(player2Vector, projectileImpulsePlayer2)];
            NSLog (@"impulse = %f, %f", cpvmult(player2Vector, projectileImpulsePlayer2).x, cpvmult(player2Vector, projectileImpulsePlayer2).y);
        }
        
        if (player2HasYellowBall) {
            
            float projectileImpulsePlayer2YellowBall = projectileImpulsePlayer2*YELLOW_BALL_SPEED_MULTIPLIER;
            [_curBombPlayer2 applyImpulse:cpvmult(player2Vector, projectileImpulsePlayer2YellowBall)];
            
            NSLog (@"projectileImpulsePlayer2YellowBall = %f", projectileImpulsePlayer2YellowBall);
        }
        
        _curBombPlayer2.shape->body->w = -(marble2RotationalVelocity);
        
        CDXAudioNode *audioProjectileLaunch = [[sling1Player2 children] objectAtIndex:1];
        [audioProjectileLaunch play];
        
        CDXAudioNode *audioIncomingProjectile2 = [[bomb2 children] objectAtIndex:0];
        [audioIncomingProjectile2 play];
        
        projectileLaunchMultiplier2 = 0;
    }
}

-(void) playCountdownBlip
{
    [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber17 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
}

-(void) getReadyLabelVisible
{
    getReadyLabel.visible = YES;
    backToMainMenu.visible = NO;
    continuePlayingGame.visible = NO;
    restartLevel.visible = NO;
    pauseButton.visible = NO;
    playButton.visible = NO;
}

-(void) getReadyLabelNotVisible
{
    getReadyLabel.visible = NO;
    backToMainMenu.visible = YES;
    continuePlayingGame.visible = YES;
    restartLevel.visible = NO;
    playersCanTouchMarblesNow = YES;
    
    if ((showAds == YES && userIsOnFastDevice == NO) || !isSinglePlayer) {
        
        NSLog(@"Device will now ignore new ad request");
        //[adWhirlView ignoreNewAdRequests];
        
        
    }
    
    // playButton.visible = NO;
    
    if (isSinglePlayer) {
        
        pauseButton.visible = YES;
    }
}

-(void) cleanUpLightningStrikeFromSling1
{
    [lightningFromSling1 removeFromParentAndCleanup: YES];
}

-(void) cleanUpLightningStrikeFromSling2
{
    [lightningFromSling2 removeFromParentAndCleanup: YES];
}

-(void) lightningStrikeFromSling1
{
    lightningFromSling1 = [Lightning lightningWithStrikePoint: ccp(_curBombPlayer2.position.x - 60, _curBombPlayer2.position.y - 166)];
    lightningFromSling1.position = SLING_POSITION;
    [zoombase addChild:lightningFromSling1 z:6];
    
    [lightningFromSling1 strike];
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.5], [CCCallFunc actionWithTarget:self selector:@selector(cleanUpLightningStrikeFromSling1)], nil]];
}

-(void) lightningStrikeFromSling2
{
    lightningFromSling2 = [Lightning lightningWithStrikePoint: ccp(_curBomb.position.x - 470, _curBomb.position.y - 166)];
    lightningFromSling2.position = SLING_POSITION_2;
    [zoombase addChild:lightningFromSling2 z:6];
    
    [lightningFromSling2 strike];
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.5], [CCCallFunc actionWithTarget:self selector:@selector(cleanUpLightningStrikeFromSling2)], nil]];
}

-(void) increasePlayer1ExperiencePoints
{
    NSLog(@"increasePlayer1ExperiencePoints called!");
    
    //It's SinglePlayer
    if (isSinglePlayer) {
        
        if (player1ExperiencePointsToAdd != 0) {
            
            player1ExperiencePointsToAdd = player1ExperiencePointsToAdd - 1;
            
            if (player1ExperiencePointsForLabel == 99) {
                
                player1ExperiencePointsToAdd = player1ExperiencePointsToAdd - 2;
                
                [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber20 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
                player1ExperiencePointsForLabel = 1;
                player1LevelForLabel = player1LevelForLabel + 100;
                player1MarblesUnlockedForLabel = player1MarblesUnlockedForLabel + 1;
                [self singlePlayerVictoryScreenLevelUp];
            }
            
            [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber19 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
            player1ExperiencePointsForLabel = player1ExperiencePointsForLabel + 1;
            [player1ExperiencePointsLabel setString:[NSString stringWithFormat:@"%i%%", player1ExperiencePointsForLabel]];
            [player1LevelLabel setString:[NSString stringWithFormat:@"Rank: %i", player1LevelForLabel/100]];
        }
        
        else if (player1ExperiencePointsToAdd <= 0) {
            
            player1Winner = NO;
            player2Winner = NO;
            player1BombExists = NO;
            player2BombExists = NO;
            
            [self stopAction: increasePlayer1ExperiencePointsAction];
            [self saveGameSettings];
            
            [self runAction: [CCSequence actions:[CCDelayTime actionWithDuration:1.0], [CCCallFunc actionWithTarget:self selector:@selector(clearAndRestartLevelFromSinglePlayerVersusScreen)],[CCCallFunc actionWithTarget:self selector:@selector(makeVictoryOrLossScreenButtonsVisible)], nil]];
        }
    }
    
    //Is Player1
    else if (isPlayer1 && !isSinglePlayer) {
        
        if (player1ExperiencePointsToAdd != 0) {
            
            player1ExperiencePointsToAdd = player1ExperiencePointsToAdd - 1;
            
            if (player1ExperiencePointsForLabel == 99) {
                
                player1ExperiencePointsToAdd = player1ExperiencePointsToAdd - 2;
                
                [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber20 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
                player1ExperiencePointsForLabel = 1;
                player1LevelForLabel = player1LevelForLabel + 100;
                
                NSLog (@"BEFORE i am player 1 within increasePlayer2ExperiencePoints method player1MarblesUnlockedForLabel = %i", player1MarblesUnlockedForLabel);
                
                player1MarblesUnlockedForLabel = player1MarblesUnlockedForLabel + 1;
                
                NSLog (@"AFTER i am player 2 within increasePlayer2ExperiencePoints method player1MarblesUnlockedForLabel = %i", player1MarblesUnlockedForLabel);
                
                [self multiPlayerVictoryScreenLevelUp];
            }
            
            [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber19 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
            player1ExperiencePointsForLabel = player1ExperiencePointsForLabel + 1;
            [player1ExperiencePointsLabel setString:[NSString stringWithFormat:@"%i%%", player1ExperiencePointsForLabel]];
            [player1LevelLabel setString:[NSString stringWithFormat:@"Rank: %i", player1LevelForLabel/100]];
        }
        
        else if (player1ExperiencePointsToAdd <= 0) {
            
            player1Winner = NO;
            player2Winner = NO;
            player1BombExists = NO;
            player2BombExists = NO;
            
            [self stopAction: increasePlayer1ExperiencePointsAction];
            [self saveGameSettings];
            
            [self runAction: [CCSequence actions:[CCDelayTime actionWithDuration:1.0], [CCCallFunc actionWithTarget:self selector:@selector(clearAndRestartMultiplayerMatch)],[CCCallFunc actionWithTarget:self selector:@selector(makeVictoryOrLossScreenButtonsVisible)], nil]];
        }
    }
    
    //Is Player2
    else if (!isPlayer1 && !isSinglePlayer) {
        
        if (player1ExperiencePointsToAdd != 0) {
            
            player1ExperiencePointsToAdd = player1ExperiencePointsToAdd - 1;
            
            if (player1ExperiencePointsMultiplayerValue == 99) {
                
                player1ExperiencePointsToAdd = player1ExperiencePointsToAdd - 2;
                
                player1ExperiencePointsMultiplayerValue = 1;
                player1LevelMultiplayerValue = player1LevelMultiplayerValue + 100;
                player1MarblesUnlockedMultiplayerValue = player1MarblesUnlockedMultiplayerValue + 1;
                [self multiPlayerVictoryScreenLevelUp];
            }
            
            player1ExperiencePointsMultiplayerValue = player1ExperiencePointsMultiplayerValue + 1;
            [player1ExperiencePointsLabel setString:[NSString stringWithFormat:@"%i%%", player1ExperiencePointsMultiplayerValue]];
            [player1LevelLabel setString:[NSString stringWithFormat:@"Rank: %i", player1LevelMultiplayerValue/100]];
        }
        
        else if (player1ExperiencePointsToAdd <= 0) {
            
            player1Winner = NO;
            player2Winner = NO;
            player1BombExists = NO;
            player2BombExists = NO;
            
            [self stopAction: increasePlayer1ExperiencePointsAction];
            [self saveGameSettings];
            
            [self runAction: [CCSequence actions:[CCDelayTime actionWithDuration:1.0], [CCCallFunc actionWithTarget:self selector:@selector(clearAndRestartMultiplayerMatch)],[CCCallFunc actionWithTarget:self selector:@selector(makeVictoryOrLossScreenButtonsVisible)], nil]];
        }
    }
}

-(void) increasePlayer2ExperiencePoints
{
    //Is Player2
    if (!isPlayer1 && !isSinglePlayer) {
        
        if (player2ExperiencePointsToAdd != 0) {
            
            player2ExperiencePointsToAdd = player2ExperiencePointsToAdd - 1;
            
            if (player2ExperiencePointsForLabel == 99) {
                
                player2ExperiencePointsToAdd = player2ExperiencePointsToAdd - 2;
                
                [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber20 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
                player2ExperiencePointsForLabel = 1;
                player2LevelForLabel = player2LevelForLabel + 100;
                player2MarblesUnlockedForLabel = player2MarblesUnlockedForLabel + 1;
                [self singlePlayerVictoryScreenLevelUp];
            }
            
            [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber19 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
            player2ExperiencePointsForLabel = player2ExperiencePointsForLabel + 1;
            [player2ExperiencePointsLabel setString:[NSString stringWithFormat:@"%i%%", player2ExperiencePointsForLabel]];
            [player2LevelLabel setString:[NSString stringWithFormat:@"Rank: %i", player2LevelForLabel/100]];
        }
        
        else if (player2ExperiencePointsToAdd <= 0) {
            
            player1Winner = NO;
            player2Winner = NO;
            player1BombExists = NO;
            player2BombExists = NO;
            
            [self stopAction: increasePlayer2ExperiencePointsAction];
            [self saveGameSettings];
            
            [self runAction: [CCSequence actions:[CCDelayTime actionWithDuration:1.0], [CCCallFunc actionWithTarget:self selector:@selector(clearAndRestartMultiplayerMatch)],[CCCallFunc actionWithTarget:self selector:@selector(makeVictoryOrLossScreenButtonsVisible)], nil]];
            
        }
    }
    
    //Is Player1
    else if (isPlayer1 && !isSinglePlayer) {
        
        if (player2ExperiencePointsToAdd != 0) {
            
            player2ExperiencePointsToAdd = player2ExperiencePointsToAdd - 1;
            
            if (player2ExperiencePointsMultiplayerValue == 99) {
                
                player2ExperiencePointsToAdd = player2ExperiencePointsToAdd - 2;
                
                player2ExperiencePointsMultiplayerValue = 1;
                player2LevelMultiplayerValue = player2LevelMultiplayerValue + 100;
                player2MarblesUnlockedMultiplayerValue = player2MarblesUnlockedMultiplayerValue + 1;
                [self multiPlayerVictoryScreenLevelUp];
            }
            
            player2ExperiencePointsMultiplayerValue = player2ExperiencePointsMultiplayerValue + 1;
            [player2ExperiencePointsLabel setString:[NSString stringWithFormat:@"%i%%", player2ExperiencePointsMultiplayerValue]];
            [player2LevelLabel setString:[NSString stringWithFormat:@"Rank: %i", player2LevelMultiplayerValue/100]];
        }
        
        else if (player2ExperiencePointsToAdd <= 0) {
            
            player1Winner = NO;
            player2Winner = NO;
            player1BombExists = NO;
            player2BombExists = NO;
            
            [self stopAction: increasePlayer2ExperiencePointsAction];
            [self saveGameSettings];
            
            [self runAction: [CCSequence actions:[CCDelayTime actionWithDuration:1.0], [CCCallFunc actionWithTarget:self selector:@selector(clearAndRestartMultiplayerMatch)],[CCCallFunc actionWithTarget:self selector:@selector(makeVictoryOrLossScreenButtonsVisible)], nil]];
        }
    }
}

-(void) turnLight2AndBulb2On
{
    if (player1Winner || isSinglePlayer) {
        
        ledBulb2.color = ccc3(30, 144, 255);
        ledLight2.opacity = 255;
    }
    
    else {
        
        ledBulb2Player2.color = ccc3(30, 144, 255);
        ledLight2Player2.opacity = 255;
    }
}

-(void) turnLight2AndBulb2Off
{
    if (player1Winner || isSinglePlayer) {
        
        ledBulb2.color = ccc3(255, 192, 203);
        ledLight2.opacity = 0;
    }
    
    else {
        
        ledBulb2Player2.color = ccc3(255, 192, 203);
        ledLight2Player2.opacity = 0;
    }
}

-(void) turnLight3AndBulb3On
{
    if (player1Winner || isSinglePlayer) {
        
        ledBulb3.color = ccRED;
        ledLight3.opacity = 255;
    }
    
    if (player2Winner) {
        
        ledBulb3Player2.color = ccRED;
        ledLight3Player2.opacity = 255;
    }
}

-(void) turnLight3AndBulb3Off
{
    if (player1Winner || isSinglePlayer) {
        
        ledBulb3.color = ccc3(255, 192, 203);
        ledLight3.opacity = 0;
    }
    
    if (player2Winner) {
        
        ledBulb3Player2.color = ccc3(255, 192, 203);
        ledLight3Player2.opacity = 0;
    }
}

-(void) turnLight4AndBulb4On
{
    if (player1Winner || isSinglePlayer) {
        
        ledBulb4.color = ccGRAY;
        ledLight4.opacity = 255;
    }
    
    if (player2Winner) {
        
        ledBulb4Player2.color = ccGRAY;
        ledLight4Player2.opacity = 255;
    }
}

-(void) turnLight4AndBulb4Off
{
    if (player1Winner || isSinglePlayer) {
        
        ledBulb4.color = ccc3(255, 192, 203);
        ledLight4.opacity = 0;
    }
    
    if (player2Winner) {
        
        ledBulb4Player2.color = ccc3(255, 192, 203);
        ledLight4Player2.opacity = 0;
    }
}

-(void) turnLight5AndBulb5On
{
    if (player1Winner || isSinglePlayer) {
        
        ledBulb5.color = ccc3(250 , 250, 170);
        ledLight5.opacity = 255;
    }
    
    if (player2Winner) {
        
        ledBulb5Player2.color = ccc3(250 , 250, 170);
        ledLight5Player2.opacity = 255;
    }
}

-(void) turnLight5AndBulb5Off
{
    if (player1Winner || isSinglePlayer) {
        
        ledBulb5.color = ccc3(255, 192, 203);
        ledLight5.opacity = 0;
    }
    
    if (player2Winner) {
        
        ledBulb5Player2.color = ccc3(255, 192, 203);
        ledLight5Player2.opacity = 0;
    }
}

-(void) singlePlayerVictoryScreenLevelUp
{
    //This method runs once player1ExperiencePoints ticks from 99 to 1
    
    //The next LED light blinks on and off 5 times
    //Contingency check in order: (1) if it's single player and player1's marblesUnlocked ==1     (2)If it's multiplayer and you're player1 and your marblesUnlocked ==1 and player1 is the winner    (3) If it's multiplayer and you're player2 and your marblesunlocked ==1 and player2 is the winner    (4) If it's multiplayer and you're player2 and player1's unlockedMables==1 and player1 is the winner  (5) If it's multiplayer and you're player1 and player2's unlockedMarbles==1 and player2 is the winner
    
    if (isPlayer1) {
        
        NSLog (@"I am player 1, player1MarblesUnlockedForLabel = %i", player1MarblesUnlockedForLabel);
    }
    
    if (!isPlayer1) {
        
        NSLog (@"I am player 2, player2MarblesUnlockedForLabel = %i", player2MarblesUnlockedForLabel);
    }
    
    if ((isSinglePlayer && player1MarblesUnlockedForLabel == 1) || (!isSinglePlayer && player1MarblesUnlockedForLabel == 1) || (!isSinglePlayer && player2MarblesUnlockedForLabel == 1 && player2Winner) || (!isSinglePlayer && isPlayer1 && player2MarblesUnlockedMultiplayerValue == 1) || (!isSinglePlayer && !isPlayer1 && player1MarblesUnlockedMultiplayerValue == 1)) {
        
        if (isPlayer1) {
            
            NSLog (@"I'm player 1 and blueMarble should be showing");
        }
        
        if (!isPlayer1) {
            
            NSLog (@"I'm player 2 and blueMarble should be showing");
        }
        
        [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2On)], nil]];
        
        CCSprite *blueMarble = [CCSprite spriteWithSpriteFrameName: @"bluemarble-hd.png"];
        
        if (player1Winner) {
            
            NSLog (@"I am player 1, player1MarblesUnlockedForLabel = %i", player1MarblesUnlockedForLabel);
            
            blueMarble.scale = 0.975;
            
            [tamagachi addChild: blueMarble z:10];
            blueMarble.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
        }
        
        else if (player2Winner) {
            
            NSLog (@"I am player 2, player2MarblesUnlockedMultiplayerValue = %i", player1MarblesUnlockedMultiplayerValue);
            
            blueMarble.scale = 0.975;
            
            [tamagachi2 addChild: blueMarble z:10];
            blueMarble.position = ccp([tamagachi2 contentSize].width/2, [tamagachi2 contentSize].height/2);
        }
        
        [blueMarble runAction: [CCSequence actions:[CCDelayTime actionWithDuration: 4.0], [CCFadeOut actionWithDuration: 2.5], nil]];
    }
    
    else if ((isSinglePlayer && player1MarblesUnlockedForLabel == 2) || (!isSinglePlayer && player1MarblesUnlockedForLabel == 2 && player1Winner == YES) || (!isSinglePlayer && player2MarblesUnlockedForLabel == 2 && player2Winner == YES) || (!isSinglePlayer && isPlayer1 && player2MarblesUnlockedMultiplayerValue == 2 && player2Winner == YES) || (!isSinglePlayer && !isPlayer1 && player1MarblesUnlockedMultiplayerValue == 2 && player1Winner == YES)) {
        
        if (isPlayer1) {
            
            NSLog (@"I'm player 1 and redMarble should be showing");
        }
        
        if (!isPlayer1) {
            
            NSLog (@"I'm player 2 and redMarble should be showing");
        }
        
        [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3On)], nil]];
        
        CCSprite *redMarble = [CCSprite spriteWithSpriteFrameName: @"redmarble-hd.png"];
        
        if (player1Winner) {
            
            redMarble.scale = 0.975;
            
            [tamagachi addChild: redMarble z:10];
            redMarble.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
        }
        
        else if (player2Winner) {
            
            redMarble.scale = 0.975;
            
            [tamagachi2 addChild: redMarble z:10];
            redMarble.position = ccp([tamagachi2 contentSize].width/2, [tamagachi2 contentSize].height/2);
        }
        
        [redMarble runAction: [CCSequence actions:[CCDelayTime actionWithDuration: 4.0], [CCFadeOut actionWithDuration: 2.5], nil]];
    }
    
    else if ((isSinglePlayer && player1MarblesUnlockedForLabel == 3) || (!isSinglePlayer && player1MarblesUnlockedForLabel == 3 && player1Winner == YES) || (!isSinglePlayer && player2MarblesUnlockedForLabel == 3 && player2Winner == YES) || (!isSinglePlayer && isPlayer1 && player2MarblesUnlockedMultiplayerValue == 3 && player2Winner == YES) || (!isSinglePlayer && !isPlayer1 && player1MarblesUnlockedMultiplayerValue == 3 && player1Winner == YES)) {
        
        if (isPlayer1) {
            
            NSLog (@"I'm player 1 and blackMarble should be showing");
        }
        
        if (!isPlayer1) {
            
            NSLog (@"I'm player 2 and blackMarble should be showing");
        }
        
        [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4On)], nil]];
        
        CCSprite *blackMarble = [CCSprite spriteWithSpriteFrameName: @"blackmarble-hd.png"];
        
        if (player1Winner) {
            
            blackMarble.scale = 0.975;
            
            [tamagachi addChild: blackMarble z:10];
            blackMarble.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
        }
        
        else if (player2Winner) {
            
            blackMarble.scale = 0.975;
            
            [tamagachi2 addChild: blackMarble z:10];
            blackMarble.position = ccp([tamagachi2 contentSize].width/2, [tamagachi2 contentSize].height/2);
        }
        
        [blackMarble runAction: [CCSequence actions:[CCDelayTime actionWithDuration: 4.0], [CCFadeOut actionWithDuration: 2.5], nil]];
    }
    
    else if ((isSinglePlayer && player1MarblesUnlockedForLabel == 4) || (!isSinglePlayer && player1MarblesUnlockedForLabel == 4 && player1Winner == YES) || (!isSinglePlayer && player2MarblesUnlockedForLabel == 4 && player2Winner == YES) || (!isSinglePlayer && isPlayer1 && player2MarblesUnlockedMultiplayerValue == 4 && player2Winner == YES) || (!isSinglePlayer && !isPlayer1 && player1MarblesUnlockedMultiplayerValue == 4 && player1Winner == YES)) {
        
        if (isPlayer1) {
            
            NSLog (@"I'm player 1 and yellowMarble should be showing");
        }
        
        if (!isPlayer1) {
            
            NSLog (@"I'm player 2 and yellowMarble should be showing");
        }
        
        [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5On)], nil]];
        
        CCSprite *yellowMarble = [CCSprite spriteWithSpriteFrameName: @"yellowmarble-hd.png"];
        
        if (player1Winner) {
            
            yellowMarble.scale = 0.975;
            
            [tamagachi addChild: yellowMarble z:10];
            yellowMarble.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
        }
        
        else if (player2Winner) {
            
            yellowMarble.scale = 0.975;
            
            [tamagachi2 addChild: yellowMarble z:10];
            yellowMarble.position = ccp([tamagachi2 contentSize].width/2, [tamagachi2 contentSize].height/2);
        }
        
        [yellowMarble runAction: [CCSequence actions:[CCDelayTime actionWithDuration: 4.0], [CCFadeOut actionWithDuration: 2.5], nil]];
    }
    
    //Angelic chorus sound plays
}

-(void) multiPlayerVictoryScreenLevelUp
{
    //This method runs once player1ExperiencePoints ticks from 99 to 1
    
    //The next LED light blinks on and off 5 times
    //Contingency check in order: (1) if it's single player and player1's marblesUnlocked ==1     (2)If it's multiplayer and you're player1 and your marblesUnlocked ==1 and player1 is the winner    (3) If it's multiplayer and you're player2 and your marblesunlocked ==1 and player2 is the winner    (4) If it's multiplayer and you're player2 and player1's unlockedMables==1 and player1 is the winner  (5) If it's multiplayer and you're player1 and player2's unlockedMarbles==1 and player2 is the winner
    
    if (isPlayer1) {
        
        NSLog (@"I am player 1, player1MarblesUnlockedForLabel = %i", player1MarblesUnlockedForLabel);
    }
    
    if (!isPlayer1) {
        
        NSLog (@"I am player 2, player2MarblesUnlockedForLabel = %i", player2MarblesUnlockedForLabel);
    }
    
    if ((isSinglePlayer && player1MarblesUnlocked == 1) || (!isSinglePlayer && player1MarblesUnlockedForLabel == 1 && player1Winner == YES) || (!isSinglePlayer && player2MarblesUnlockedForLabel == 1 && player2Winner) || (!isSinglePlayer && isPlayer1 && player2MarblesUnlockedMultiplayerValue == 1 && player2Winner == YES) || (!isSinglePlayer && !isPlayer1 && player1MarblesUnlockedMultiplayerValue == 1 && player1Winner == YES)) {
        
        if (isPlayer1) {
            
            NSLog (@"I'm player 1 and blueMarble should be showing");
        }
        
        if (!isPlayer1) {
            
            NSLog (@"I'm player 2 and blueMarble should be showing");
        }
        
        [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight2AndBulb2On)], nil]];
        
        CCSprite *blueMarble = [CCSprite spriteWithSpriteFrameName: @"bluemarble-hd.png"];
        
        if (player1Winner) {
            
            NSLog (@"I am player 1, player1MarblesUnlockedForLabel = %i", player1MarblesUnlockedForLabel);
            
            blueMarble.scale = 0.975;
            
            [tamagachiMultiplayer addChild: blueMarble z:10];
            blueMarble.position = ccp([tamagachiMultiplayer contentSize].width/2, [tamagachiMultiplayer contentSize].height/2);
        }
        
        else if (player2Winner) {
            
            NSLog (@"I am player 2, player2MarblesUnlockedMultiplayerValue = %i", player1MarblesUnlockedMultiplayerValue);
            
            blueMarble.scale = 0.975;
            
            [tamagachi2Multiplayer addChild: blueMarble z:10];
            blueMarble.position = ccp([tamagachi2Multiplayer contentSize].width/2, [tamagachi2Multiplayer contentSize].height/2);
        }
        
        [blueMarble runAction: [CCSequence actions:[CCDelayTime actionWithDuration: 4.0], [CCFadeOut actionWithDuration: 2.5], nil]];
    }
    
    else if ((isSinglePlayer && player1MarblesUnlocked == 2) || (!isSinglePlayer && player1MarblesUnlockedForLabel == 2 && player1Winner == YES) || (!isSinglePlayer && player2MarblesUnlockedForLabel == 2 && player2Winner == YES) || (!isSinglePlayer && isPlayer1 && player2MarblesUnlockedMultiplayerValue == 2 && player2Winner == YES) || (!isSinglePlayer && !isPlayer1 && player1MarblesUnlockedMultiplayerValue == 2 && player1Winner == YES)) {
        
        if (isPlayer1) {
            
            NSLog (@"I'm player 1 and redMarble should be showing");
        }
        
        if (!isPlayer1) {
            
            NSLog (@"I'm player 2 and redMarble should be showing");
        }
        
        [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight3AndBulb3On)], nil]];
        
        CCSprite *redMarble = [CCSprite spriteWithSpriteFrameName: @"redmarble-hd.png"];
        
        if (player1Winner) {
            
            redMarble.scale = 0.975;
            
            [tamagachiMultiplayer addChild: redMarble z:10];
            redMarble.position = ccp([tamagachiMultiplayer contentSize].width/2, [tamagachiMultiplayer contentSize].height/2);
        }
        
        else if (player2Winner) {
            
            redMarble.scale = 0.975;
            
            [tamagachi2Multiplayer addChild: redMarble z:10];
            redMarble.position = ccp([tamagachi2Multiplayer contentSize].width/2, [tamagachi2Multiplayer contentSize].height/2);
        }
        
        [redMarble runAction: [CCSequence actions:[CCDelayTime actionWithDuration: 4.0], [CCFadeOut actionWithDuration: 2.5], nil]];
    }
    
    else if ((isSinglePlayer && player1MarblesUnlocked == 3) || (!isSinglePlayer && player1MarblesUnlockedForLabel == 3 && player1Winner == YES) || (!isSinglePlayer && player2MarblesUnlockedForLabel == 3 && player2Winner == YES) || (!isSinglePlayer && isPlayer1 && player2MarblesUnlockedMultiplayerValue == 3 && player2Winner == YES) || (!isSinglePlayer && !isPlayer1 && player1MarblesUnlockedMultiplayerValue == 3 && player1Winner == YES)) {
        
        if (isPlayer1) {
            
            NSLog (@"I'm player 1 and blackMarble should be showing");
        }
        
        if (!isPlayer1) {
            
            NSLog (@"I'm player 2 and blackMarble should be showing");
        }
        
        [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight4AndBulb4On)], nil]];
        
        CCSprite *blackMarble = [CCSprite spriteWithSpriteFrameName: @"blackmarble-hd.png"];
        
        if (player1Winner) {
            
            blackMarble.scale = 0.975;
            
            [tamagachiMultiplayer addChild: blackMarble z:10];
            blackMarble.position = ccp([tamagachiMultiplayer contentSize].width/2, [tamagachiMultiplayer contentSize].height/2);
        }
        
        else if (player2Winner) {
            
            blackMarble.scale = 0.975;
            
            [tamagachi2Multiplayer addChild: blackMarble z:10];
            blackMarble.position = ccp([tamagachi2Multiplayer contentSize].width/2, [tamagachi2Multiplayer contentSize].height/2);
        }
        
        [blackMarble runAction: [CCSequence actions:[CCDelayTime actionWithDuration: 4.0], [CCFadeOut actionWithDuration: 2.5], nil]];
    }
    
    else if ((isSinglePlayer && player1MarblesUnlocked >= 4) || (!isSinglePlayer && player1MarblesUnlockedForLabel == 4 && player1Winner == YES) || (!isSinglePlayer && player2MarblesUnlockedForLabel == 4 && player2Winner == YES) || (!isSinglePlayer && isPlayer1 && player2MarblesUnlockedMultiplayerValue == 4 && player2Winner == YES) || (!isSinglePlayer && !isPlayer1 && player1MarblesUnlockedMultiplayerValue == 4 && player1Winner == YES)) {
        
        if (isPlayer1) {
            
            NSLog (@"I'm player 1 and yellowMarble should be showing");
        }
        
        if (!isPlayer1) {
            
            NSLog (@"I'm player 2 and yellowMarble should be showing");
        }
        
        [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5On)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5Off)], [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(turnLight5AndBulb5On)], nil]];
        
        CCSprite *yellowMarble = [CCSprite spriteWithSpriteFrameName: @"yellowmarble-hd.png"];
        
        if (player1Winner) {
            
            yellowMarble.scale = 0.975;
            
            [tamagachiMultiplayer addChild: yellowMarble z:10];
            yellowMarble.position = ccp([tamagachiMultiplayer contentSize].width/2, [tamagachiMultiplayer contentSize].height/2);
        }
        
        else if (player2Winner) {
            
            yellowMarble.scale = 0.975;
            
            [tamagachi2Multiplayer addChild: yellowMarble z:10];
            yellowMarble.position = ccp([tamagachi2Multiplayer contentSize].width/2, [tamagachi2Multiplayer contentSize].height/2);
        }
        
        [yellowMarble runAction: [CCSequence actions:[CCDelayTime actionWithDuration: 4.0], [CCFadeOut actionWithDuration: 2.5], nil]];
    }
    
    //Angelic chorus sound plays
}

-(void) increasePlayer1ExperiencePointsMethod
{
    NSLog (@"increasePlayer1ExperiencePointsMethod called!");
    
    //wait 0.7 + 0.9 + 0.7 seconds, and then run a script which ticks up player1ExperiencePoints
    increasePlayer1ExperiencePointsAction = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(increasePlayer1ExperiencePoints)], [CCDelayTime actionWithDuration: 0.1], nil]]];
}

-(void) increasePlayer2ExperiencePointsMethod
{
    //wait 0.7 + 0.9 + 0.7 seconds, and then run a script which ticks up player2ExperiencePoints
    increasePlayer2ExperiencePointsAction = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(increasePlayer2ExperiencePoints)], [CCDelayTime actionWithDuration: 0.1], nil]]];
}

-(void) updateLocksOverColorSwatchesAndMarbleList
{
    if (player1Level == 100) {
        
        blackLock1.visible = NO;
        blackLock2.visible = YES;
        blackLock3.visible = YES;
        blackLock4.visible = YES;
        blackLock5.visible = YES;
        blackLock6.visible = YES;
        blackLock7.visible = YES;
        blackLock8.visible = YES;
        blackLock9.visible = YES;
        whiteLock1.visible = YES;
        
        blackLockSpeechBubbleMarbleList1.visible = YES;
        blackLockSpeechBubbleMarbleList2.visible = YES;
        whiteLockSpeechBubbleMarbleList1.visible = YES;
        blackLockSpeechBubbleMarbleList3.visible = YES;
    }
    
    if (player1Level >= 200) {
        
        blackLock1.visible = NO;
        blackLock2.visible = NO;
        blackLock3.visible = YES;
        blackLock4.visible = YES;
        blackLock5.visible = YES;
        blackLock6.visible = YES;
        blackLock7.visible = YES;
        blackLock8.visible = YES;
        blackLock9.visible = YES;
        whiteLock1.visible = YES;
    }
    
    if (player1Level >= 500) {
        
        blackLock1.visible = NO;
        blackLock2.visible = NO;
        blackLock3.visible = NO;
        blackLock4.visible = NO;
        blackLock5.visible = NO;
        blackLock6.visible = YES;
        blackLock7.visible = YES;
        blackLock8.visible = YES;
        blackLock9.visible = YES;
        whiteLock1.visible = YES;
    }
    
    if (player1Level >= 1000) {
        
        blackLock1.visible = NO;
        blackLock2.visible = NO;
        blackLock3.visible = NO;
        blackLock4.visible = NO;
        blackLock5.visible = NO;
        blackLock6.visible = NO;
        blackLock7.visible = NO;
        blackLock8.visible = NO;
        blackLock9.visible = YES;
        whiteLock1.visible = YES;
    }
    
    if (player1Level >= 2000) {
        
        blackLock1.visible = NO;
        blackLock2.visible = NO;
        blackLock3.visible = NO;
        blackLock4.visible = NO;
        blackLock5.visible = NO;
        blackLock6.visible = NO;
        blackLock7.visible = NO;
        blackLock8.visible = NO;
        blackLock9.visible = NO;
        whiteLock1.visible = NO;
    }
    
    
    if (player1Level > 100 && player1Level <= 200) {
        
        blackLockSpeechBubbleMarbleList1.visible = NO;
        blackLockSpeechBubbleMarbleList2.visible = YES;
        whiteLockSpeechBubbleMarbleList1.visible = YES;
        blackLockSpeechBubbleMarbleList3.visible = YES;
    }
    
    else if (player1Level > 200 && player1Level <= 300) {
        
        blackLockSpeechBubbleMarbleList1.visible = NO;
        blackLockSpeechBubbleMarbleList2.visible = NO;
        whiteLockSpeechBubbleMarbleList1.visible = YES;
        blackLockSpeechBubbleMarbleList3.visible = YES;
    }
    
    else if (player1Level > 300 && player1Level <= 400) {
        
        blackLockSpeechBubbleMarbleList1.visible = NO;
        blackLockSpeechBubbleMarbleList2.visible = NO;
        whiteLockSpeechBubbleMarbleList1.visible = NO;
        blackLockSpeechBubbleMarbleList3.visible = YES;
    }
    
    else if (player1Level >= 500) {
        
        blackLockSpeechBubbleMarbleList1.visible = NO;
        blackLockSpeechBubbleMarbleList2.visible = NO;
        whiteLockSpeechBubbleMarbleList1.visible = NO;
        blackLockSpeechBubbleMarbleList3.visible = NO;
    }
}

-(void) addPointsToTamagachiToPlayer1
{
    if (isSinglePlayer) {
        
        player1PointsLabel = [CCLabelBMFont labelWithString:@"+6" fntFile:@"GertyLevel.fnt"];
        player1PointsLabel.position = ccp((tamagachi.position.x), (tamagachi.position.y + 25));
        
        player1PointsLabel.color = ccRED;
        player1PointsLabel.anchorPoint = ccp(0.5, 0.5);
        player1PointsLabel.scale = 0.8;
        
        [tamagachi addChild: player1PointsLabel z:10];
    }
    
    else if (!isSinglePlayer) {
        
        player1PointsLabelMultiplayer = [CCLabelBMFont labelWithString:@"+10" fntFile:@"GertyLevel.fnt"];
        player1PointsLabelMultiplayer.position = ccp((tamagachiMultiplayer.position.x - 25), (tamagachiMultiplayer.position.y + 25));
        
        player1PointsLabelMultiplayer.color = ccRED;
        player1PointsLabelMultiplayer.anchorPoint = ccp(0.5, 0.5);
        player1PointsLabelMultiplayer.scale = 0.8;
        
        [player1PointsLabelMultiplayer runAction: [CCFadeOut actionWithDuration:0.0]];
        
        [tamagachiMultiplayer addChild: player1PointsLabelMultiplayer z:10];
    }
    
    
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
        
        if (isSinglePlayer) {
            player1PointsLabel.scaleX = 0.75;
            player1PointsLabel.scaleY = 0.75;
        }
        
        else if (!isSinglePlayer) {
            
            player1PointsLabelMultiplayer.scaleX = 0.75;
            player1PointsLabelMultiplayer.scaleY = 0.75;
        }
    }
    
    else {
        
        if (isSinglePlayer) {
            player1PointsLabel.scaleX = 0.75/2;
            player1PointsLabel.scaleY = 0.75/2;
        }
        
        else if (!isSinglePlayer) {
            
            player1PointsLabelMultiplayer.scaleX = 0.75/2;
            player1PointsLabelMultiplayer.scaleY = 0.75/2;
        }
    }
    
    if (isSinglePlayer) {
        
        [player1PointsLabel runAction: [CCSequence actions: [CCFadeIn actionWithDuration: 0.7], [CCMoveTo actionWithDuration:0.9 position: player1ExperiencePointsLabel.position], [CCFadeOut actionWithDuration: 0.7], nil]];
        [player1PointsLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCScaleTo actionWithDuration: 0.9 scale: 0.12], nil]];
    }
    
    else if (!isSinglePlayer) {
        
        [player1PointsLabelMultiplayer runAction: [CCSequence actions: [CCFadeIn actionWithDuration: 0.7], [CCMoveTo actionWithDuration:0.9 position: player1ExperiencePointsLabel.position], [CCFadeOut actionWithDuration: 0.7], nil]];
        [player1PointsLabelMultiplayer runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCScaleTo actionWithDuration: 0.9 scale: 0.12], nil]];
    }
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.5],[CCCallFunc actionWithTarget:self selector:@selector(increasePlayer1ExperiencePointsMethod)], nil]];
    
    if (bonusPoints1 > 0 && player1Winner) {
        
        if (isSinglePlayer) {
            
            CCSprite *player1BonusPointsLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"+%i", bonusPoints1] fntFile:@"GertyLevel.fnt"];
            
            //move player1PointsLabel to the left by 35, from -105 to -140
            player1PointsLabel.position = ccp((tamagachi.position.x - 35), (tamagachi.position.y + 15));
            
            //move player1BonusPointsLabel to the right by 35, from -105 to -70
            player1BonusPointsLabel.color = ccYELLOW;
            player1BonusPointsLabel.position = ccp((tamagachi.position.x + 35), (tamagachi.position.y + 15));
            player1BonusPointsLabel.anchorPoint = ccp(0.5, 0.5);
            player1BonusPointsLabel.scale = 0.8;
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
                player1BonusPointsLabel.scaleX = 0.75;
                player1BonusPointsLabel.scaleY = 0.75;
            }
            
            else {
                
                player1BonusPointsLabel.scaleX = 0.75/2;
                player1BonusPointsLabel.scaleY = 0.75/2;
            }
            
            [player1BonusPointsLabel runAction: [CCFadeOut actionWithDuration:0.0]];
            
            [tamagachi addChild: player1BonusPointsLabel z:10];
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
                player1BonusPointsLabel.scaleX = 0.75;
                player1BonusPointsLabel.scaleY = 0.75;
            }
            
            else {
                
                player1BonusPointsLabel.scaleX = 0.75/2;
                player1BonusPointsLabel.scaleY = 0.75/2;
            }
            
            [player1BonusPointsLabel runAction: [CCSequence actions: [CCFadeIn actionWithDuration: 0.7], [CCMoveTo actionWithDuration:0.9 position: player1ExperiencePointsLabel.position], [CCFadeOut actionWithDuration: 0.7], nil]];
            [player1BonusPointsLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCScaleTo actionWithDuration: 0.9 scale: 0.12], nil]];
        }
        
        else if (!isSinglePlayer) {
            
            CCSprite *player1BonusPointsLabelMultiplayer = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"+%i", bonusPoints1] fntFile:@"GertyLevel.fnt"];
            
            player1BonusPointsLabelMultiplayer.color = ccYELLOW;
            player1BonusPointsLabelMultiplayer.position = ccp((tamagachiMultiplayer.position.x + 25), (tamagachiMultiplayer.position.y + 25));
            player1BonusPointsLabelMultiplayer.anchorPoint = ccp(0.5, 0.5);
            player1BonusPointsLabelMultiplayer.scale = 0.8;
            
            [player1BonusPointsLabelMultiplayer runAction: [CCFadeOut actionWithDuration:0.0]];
            
            [tamagachiMultiplayer addChild: player1BonusPointsLabelMultiplayer z:10];
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
                player1BonusPointsLabelMultiplayer.scaleX = 0.75;
                player1BonusPointsLabelMultiplayer.scaleY = 0.75;
            }
            
            else {
                
                player1BonusPointsLabelMultiplayer.scaleX = 0.75/2;
                player1BonusPointsLabelMultiplayer.scaleY = 0.75/2;
            }
            
            [player1BonusPointsLabelMultiplayer runAction: [CCSequence actions: [CCFadeIn actionWithDuration: 0.7], [CCMoveTo actionWithDuration:0.9 position: player1ExperiencePointsLabel.position], [CCFadeOut actionWithDuration: 0.7], nil]];
            [player1BonusPointsLabelMultiplayer runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCScaleTo actionWithDuration: 0.9 scale: 0.12], nil]];
        }
    }
}

-(void) addPointsToTamagachiToPlayer2
{
    if (!isSinglePlayer) {
        
        player2PointsLabelMultiplayer = [CCLabelBMFont labelWithString:@"+10" fntFile:@"GertyLevel.fnt"];
        player2PointsLabelMultiplayer.position = ccp((tamagachi2Multiplayer.position.x - 155), (tamagachi2Multiplayer.position.y + 25));
        
        player2PointsLabelMultiplayer.color = ccRED;
        player2PointsLabelMultiplayer.anchorPoint = ccp(0.5, 0.5);
        player2PointsLabelMultiplayer.scale = 0.8;
        
        [player2PointsLabelMultiplayer runAction: [CCFadeOut actionWithDuration:0.0]];
        
        [tamagachi2Multiplayer addChild: player2PointsLabelMultiplayer z:10];
    }
    
    
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
        
        player2PointsLabelMultiplayer.scaleX = 0.75;
        player2PointsLabelMultiplayer.scaleY = 0.75;
    }
    
    else {
        
        player2PointsLabelMultiplayer.scaleX = 0.75/2;
        player2PointsLabelMultiplayer.scaleY = 0.75/2;
    }
    
    
    [player2PointsLabelMultiplayer runAction: [CCSequence actions: [CCFadeIn actionWithDuration: 0.7], [CCMoveTo actionWithDuration:0.9 position: player2ExperiencePointsLabel.position], [CCFadeOut actionWithDuration: 0.7], nil]];
    [player2PointsLabelMultiplayer runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCScaleTo actionWithDuration: 0.9 scale: 0.12], nil]];
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.5],[CCCallFunc actionWithTarget:self selector:@selector(increasePlayer2ExperiencePointsMethod)], [CCDelayTime actionWithDuration: 1.5], nil]];
    
    
    if (bonusPoints2 > 0 && player2Winner) {
        
        if (!isSinglePlayer) {
            
            CCSprite *player2BonusPointsLabelMultiplayer = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"+%i", bonusPoints2] fntFile:@"GertyLevel.fnt"];
            
            player2BonusPointsLabelMultiplayer.position = ccp((tamagachi2Multiplayer.position.x - 155), (tamagachi2Multiplayer.position.y + 25));
            
            player2BonusPointsLabelMultiplayer.color = ccYELLOW;
            player2BonusPointsLabelMultiplayer.position = ccp((tamagachi2Multiplayer.position.x - 77), (tamagachi2Multiplayer.position.y + 25));
            player2BonusPointsLabelMultiplayer.anchorPoint = ccp(0.5, 0.5);
            player2BonusPointsLabelMultiplayer.scale = 0.8;
            
            [player2BonusPointsLabelMultiplayer runAction: [CCFadeOut actionWithDuration:0.0]];
            
            [tamagachi2Multiplayer addChild: player2BonusPointsLabelMultiplayer z:10];
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
                player2BonusPointsLabelMultiplayer.scaleX = 0.75;
                player2BonusPointsLabelMultiplayer.scaleY = 0.75;
            }
            
            else {
                
                player2BonusPointsLabelMultiplayer.scaleX = 0.75/2;
                player2BonusPointsLabelMultiplayer.scaleY = 0.75/2;
            }
            
            [player2BonusPointsLabelMultiplayer runAction: [CCSequence actions: [CCFadeIn actionWithDuration: 0.7], [CCMoveTo actionWithDuration:0.9 position: player2ExperiencePointsLabel.position], [CCFadeOut actionWithDuration: 0.7], nil]];
            [player2BonusPointsLabelMultiplayer runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCScaleTo actionWithDuration: 0.9 scale: 0.12], nil]];
        }
    }
    
    /*
     if (isSinglePlayer) {
     
     player2PointsLabel = [CCLabelBMFont labelWithString:@"+6" fntFile:@"GertyLevel.fnt"];
     }
     
     else if (!isSinglePlayer) {
     
     player2PointsLabel = [CCLabelBMFont labelWithString:@"+10" fntFile:@"GertyLevel.fnt"];
     }
     
     player2PointsLabel.color = ccRED;
     player2PointsLabel.position = ccp((tamagachi2Multiplayer.position.x - 155), (tamagachi2Multiplayer.position.y + 25));
     player2PointsLabel.anchorPoint = ccp(0.5, 0.5);
     player2PointsLabel.scale = 0.8;
     
     [player2PointsLabel runAction: [CCFadeOut actionWithDuration:0.0]];
     
     [tamagachi2Multiplayer addChild: player2PointsLabel z:10];
     
     if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
     ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
     player1PointsLabel.scaleX = 0.75;
     player1PointsLabel.scaleY = 0.75;
     }
     
     else {
     
     player1PointsLabel.scaleX = 0.75/2;
     player1PointsLabel.scaleY = 0.75/2;
     }
     
     [player2PointsLabel runAction: [CCSequence actions: [CCFadeIn actionWithDuration: 0.7], [CCMoveTo actionWithDuration:0.9 position: player2ExperiencePointsLabel.position], [CCFadeOut actionWithDuration: 0.7], nil]];
     [player2PointsLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCScaleTo actionWithDuration: 0.9 scale: 0.12], nil]];
     
     [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.5],[CCCallFunc actionWithTarget:self selector:@selector(increasePlayer2ExperiencePointsMethod)], [CCDelayTime actionWithDuration: 1.5], [CCCallFunc actionWithTarget:self selector:@selector(makeVictoryOrLossScreenButtonsVisible)], nil]];
     
     if (bonusPoints1 > 0 && player2Winner) {
     
     CCSprite *player2BonusPointsLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"+%i", bonusPoints1] fntFile:@"GertyLevel.fnt"];
     
     if (isSinglePlayer) {
     
     //move player2PointsLabel to the left by 35, from -105 to -140
     //player2PointsLabel.position = ccp((tamagachi2.position.x - 140), (tamagachi2.position.y + 25));
     
     //move player2BonusPointsLabel to the right by 35, from -105 to -70
     // player2BonusPointsLabel.color = ccYELLOW;
     // player2BonusPointsLabel.position = ccp((tamagachi2.position.x - 70), (tamagachi2.position.y + 25));
     // player2BonusPointsLabel.anchorPoint = ccp(0.5, 0.5);
     // player2BonusPointsLabel.scale = 0.8;
     
     if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
     ([UIScreen mainScreen].scale == 2.0)) {
     player2BonusPointsLabel.scaleX = 0.75;
     player2BonusPointsLabel.scaleY = 0.75;
     }
     
     else {
     
     player2BonusPointsLabel.scaleX = 0.75/2;
     player2BonusPointsLabel.scaleY = 0.75/2;
     }
     }
     
     if (!isSinglePlayer) {
     
     player2PointsLabel.position = ccp((tamagachi2Multiplayer.position.x - 155), (tamagachi2Multiplayer.position.y + 25));
     
     player2BonusPointsLabel.color = ccYELLOW;
     player2BonusPointsLabel.position = ccp((tamagachi2Multiplayer.position.x - 77), (tamagachi2Multiplayer.position.y + 25));
     player2BonusPointsLabel.anchorPoint = ccp(0.5, 0.5);
     player2BonusPointsLabel.scale = 0.8;
     
     if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
     ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
     player2BonusPointsLabel.scaleX = 0.75;
     player2BonusPointsLabel.scaleY = 0.75;
     }
     
     else {
     
     player2BonusPointsLabel.scaleX = 0.75/2;
     player2BonusPointsLabel.scaleY = 0.75/2;
     }
     }
     
     [player2BonusPointsLabel runAction: [CCFadeOut actionWithDuration:0.0]];
     
     [tamagachi2Multiplayer addChild: player2BonusPointsLabel z:10];
     
     if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
     ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
     player2BonusPointsLabel.scaleX = 0.75;
     player2BonusPointsLabel.scaleY = 0.75;
     }
     
     else {
     
     player2BonusPointsLabel.scaleX = 0.75/2;
     player2BonusPointsLabel.scaleY = 0.75/2;
     }
     
     [player2BonusPointsLabel runAction: [CCSequence actions: [CCFadeIn actionWithDuration: 0.7], [CCMoveTo actionWithDuration:0.9 position: player2ExperiencePointsLabel.position], [CCFadeOut actionWithDuration: 0.7], nil]];
     [player2BonusPointsLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCScaleTo actionWithDuration: 0.9 scale: 0.12], nil]];
     }
     */
}


-(void) chanceOfWindChimesSoundsRandomNumber
{
    chanceOfWindChimesSounds = arc4random()%226;
    //NSLog (@"chanceOfWindChimesSounds = %i", chanceOfWindChimesSounds);
}

-(void) chanceOfPassingCarSoundsRandomNumber
{
    chanceOfPassingCarSounds = arc4random()%301;
    //NSLog (@"chanceOfPassingCarSounds = %i", chanceOfPassingCarSounds);
}

-(void) chanceOfLightAircraftPassingBySoundsRandomNumber
{
    chanceOfLightAircraftPassingBySounds = arc4random()%500;
    //NSLog (@"chanceOfLightAircraftPassingBySounds = %i", chanceOfLightAircraftPassingBySounds);
}

-(void) chanceOfDogBarkingSoundsRandomNumber
{
    chanceOfDogBarkingSounds = arc4random()%251;
    //NSLog (@"chanceOfDogBarkingSounds = %i", chanceOfDogBarkingSounds);
}

-(void) fadeInHowToPlayTutorialFrame1
{
    howToPlayFrame1.visible = YES;
    howToPlayFrame2.visible = NO;
    howToPlayFrame3.visible = NO;
    howToPlayFrame4.visible = NO;
    howToPlayFrame5.visible = NO;
    howToPlayFrame6.visible = NO;
    howToPlayFrame7.visible = NO;
    howToPlayFrame8.visible = NO;
    howToPlayFrame9.visible = NO;
}

-(void) fadeInHowToPlayTutorialFrame2
{
    howToPlayFrame1.visible = NO;
    howToPlayFrame2.visible = YES;
    howToPlayFrame3.visible = NO;
    howToPlayFrame4.visible = NO;
    howToPlayFrame5.visible = NO;
    howToPlayFrame6.visible = NO;
    howToPlayFrame7.visible = NO;
    howToPlayFrame8.visible = NO;
    howToPlayFrame9.visible = NO;
}

-(void) fadeInHowToPlayTutorialFrame3
{
    howToPlayFrame1.visible = NO;
    howToPlayFrame2.visible = NO;
    howToPlayFrame3.visible = YES;
    howToPlayFrame4.visible = NO;
    howToPlayFrame5.visible = NO;
    howToPlayFrame6.visible = NO;
    howToPlayFrame7.visible = NO;
    howToPlayFrame8.visible = NO;
    howToPlayFrame9.visible = NO;
}

-(void) fadeInHowToPlayTutorialFrame4
{
    howToPlayFrame1.visible = NO;
    howToPlayFrame2.visible = NO;
    howToPlayFrame3.visible = NO;
    howToPlayFrame4.visible = YES;
    howToPlayFrame5.visible = NO;
    howToPlayFrame6.visible = NO;
    howToPlayFrame7.visible = NO;
    howToPlayFrame8.visible = NO;
    howToPlayFrame9.visible = NO;
}

-(void) fadeInHowToPlayTutorialFrame5
{
    howToPlayFrame1.visible = NO;
    howToPlayFrame2.visible = NO;
    howToPlayFrame3.visible = NO;
    howToPlayFrame4.visible = NO;
    howToPlayFrame5.visible = YES;
    howToPlayFrame6.visible = NO;
    howToPlayFrame7.visible = NO;
    howToPlayFrame8.visible = NO;
    howToPlayFrame9.visible = NO;
}

-(void) fadeInHowToPlayTutorialFrame6
{
    howToPlayFrame1.visible = NO;
    howToPlayFrame2.visible = NO;
    howToPlayFrame3.visible = NO;
    howToPlayFrame4.visible = NO;
    howToPlayFrame5.visible = NO;
    howToPlayFrame6.visible = YES;
    howToPlayFrame7.visible = NO;
    howToPlayFrame8.visible = NO;
    howToPlayFrame9.visible = NO;
}

-(void) fadeInHowToPlayTutorialFrame7
{
    howToPlayFrame1.visible = NO;
    howToPlayFrame2.visible = NO;
    howToPlayFrame3.visible = NO;
    howToPlayFrame4.visible = NO;
    howToPlayFrame5.visible = NO;
    howToPlayFrame6.visible = NO;
    howToPlayFrame7.visible = YES;
    howToPlayFrame8.visible = NO;
    howToPlayFrame9.visible = NO;
}

-(void) fadeInHowToPlayTutorialFrame8
{
    howToPlayFrame1.visible = NO;
    howToPlayFrame2.visible = NO;
    howToPlayFrame3.visible = NO;
    howToPlayFrame4.visible = NO;
    howToPlayFrame5.visible = NO;
    howToPlayFrame6.visible = NO;
    howToPlayFrame7.visible = NO;
    howToPlayFrame8.visible = YES;
    howToPlayFrame9.visible = NO;
}

-(void) fadeInHowToPlayTutorialFrame9
{
    howToPlayFrame1.visible = NO;
    howToPlayFrame2.visible = NO;
    howToPlayFrame3.visible = NO;
    howToPlayFrame4.visible = NO;
    howToPlayFrame5.visible = NO;
    howToPlayFrame6.visible = NO;
    howToPlayFrame7.visible = NO;
    howToPlayFrame8.visible = NO;
    howToPlayFrame9.visible = YES;
    checkMark1.visible = YES;
    indexCard1ReadyToTouch = YES;
}

-(void) fadeOutAllHowToPlayTutorialFrames
{
    howToPlayFrame1.visible = NO;
    howToPlayFrame2.visible = NO;
    howToPlayFrame3.visible = NO;
    howToPlayFrame4.visible = NO;
    howToPlayFrame5.visible = NO;
    howToPlayFrame6.visible = NO;
    howToPlayFrame7.visible = NO;
    howToPlayFrame8.visible = NO;
    howToPlayFrame9.visible = NO;
}

-(void) fadeInHowToDefendTutorialFrame1
{
    howToDefendFrame1.visible = YES;
    howToDefendFrame2.visible = NO;
    howToDefendFrame3.visible = NO;
    howToDefendFrame4.visible = NO;
}

-(void) fadeInHowToDefendTutorialFrame2
{
    howToDefendFrame1.visible = NO;
    howToDefendFrame2.visible = YES;
    howToDefendFrame3.visible = NO;
    howToDefendFrame4.visible = NO;
}

-(void) fadeInHowToDefendTutorialFrame3
{
    howToDefendFrame1.visible = NO;
    howToDefendFrame2.visible = NO;
    howToDefendFrame3.visible = YES;
    howToDefendFrame4.visible = NO;
}

-(void) fadeInHowToDefendTutorialFrame4
{
    howToDefendFrame1.visible = NO;
    howToDefendFrame2.visible = NO;
    howToDefendFrame3.visible = NO;
    howToDefendFrame4.visible = YES;
    checkMark2.visible = YES;
    indexCard2ReadyToTouch = YES;
}

-(void) fadeOutAllHowToDefendTutorialFrame
{
    howToDefendFrame1.visible = NO;
    howToDefendFrame2.visible = NO;
    howToDefendFrame3.visible = NO;
    howToDefendFrame4.visible = NO;
}

-(void) setIndexCardBehindIndexCard2
{
    [hudLayer reorderChild:indexCard z: 0];
    [indexCard reorderChild:checkMark1 z: 0];
    [indexCard reorderChild:attackLabel z: 0];
}

-(void) howToPlayTutorial
{
    inGameTutorialHasAlreadyBeenPlayedOnce = YES;
    
    //Display the first frame of indexCard2
    howToDefendFrame1.visible = YES;
    
    //This method will display indexCard1
    
    //Play swoosh sound when index card comes in
    [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber21 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
    
    //Place indexCard1 in front
    [indexCard runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(50, -400)]];
    
    //Place indexCard2 behind indexCard1 but slightly off to the top left of it
    [indexCard2 runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(50 + 3, -400)]];
    
    int indexCardsPositionOffset;
    
    if (deviceIsWidescreen) {
        
        indexCardsPositionOffset = 35;
    }
    
    if (!deviceIsWidescreen) {
        
        indexCardsPositionOffset = 0;
    }
    
    [indexCard runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.0], [CCMoveTo actionWithDuration:0.3 position:ccp(50 + indexCardsPositionOffset, 259)], nil]];
    [indexCard2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.0], [CCMoveTo actionWithDuration:0.3 position:ccp(53 + indexCardsPositionOffset, 263)], nil]];
    
    howToPlayAnimation = [self runAction:[CCRepeatForever actionWithAction:[CCSequence actions: [CCDelayTime actionWithDuration:0.3], [CCCallFunc actionWithTarget:self selector:@selector(fadeInHowToPlayTutorialFrame1)], [CCDelayTime actionWithDuration:0.7], [CCCallFunc actionWithTarget:self selector:@selector(fadeInHowToPlayTutorialFrame2)], [CCDelayTime actionWithDuration:0.7], [CCCallFunc actionWithTarget:self selector:@selector(fadeInHowToPlayTutorialFrame3)], [CCDelayTime actionWithDuration:0.7], [CCCallFunc actionWithTarget:self selector:@selector(fadeInHowToPlayTutorialFrame4)], [CCDelayTime actionWithDuration:0.7], [CCCallFunc actionWithTarget:self selector:@selector(fadeInHowToPlayTutorialFrame5)], [CCDelayTime actionWithDuration:0.7], [CCCallFunc actionWithTarget:self selector:@selector(fadeInHowToPlayTutorialFrame6)], [CCDelayTime actionWithDuration:0.7], [CCCallFunc actionWithTarget:self selector:@selector(fadeInHowToPlayTutorialFrame7)], [CCDelayTime actionWithDuration:0.7], [CCCallFunc actionWithTarget:self selector:@selector(fadeInHowToPlayTutorialFrame8)], [CCDelayTime actionWithDuration:0.7], [CCCallFunc actionWithTarget:self selector:@selector(fadeInHowToPlayTutorialFrame9)], [CCDelayTime actionWithDuration:2.1], nil]]];
    
    //
}

-(void) howToDefendTutorial
{
    //This method will place indexCard1 behind indexCard2 and then play the 'How to Defend' tutorial animation
    
    [indexCard runAction: [CCSequence actions: [CCRotateTo actionWithDuration:0.3 angle: -140], [CCCallFunc actionWithTarget:self selector:@selector(setIndexCardBehindIndexCard2)], [CCRotateTo actionWithDuration:0.3 angle:0], nil]];
    
    howToDefendAnimation = [self runAction:[CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.5], [CCCallFunc actionWithTarget:self selector:@selector(fadeInHowToDefendTutorialFrame1)], [CCDelayTime actionWithDuration:0.7], [CCCallFunc actionWithTarget:self selector:@selector(fadeInHowToDefendTutorialFrame2)], [CCDelayTime actionWithDuration:0.7], [CCCallFunc actionWithTarget:self selector:@selector(fadeInHowToDefendTutorialFrame3)], [CCDelayTime actionWithDuration:0.7], [CCCallFunc actionWithTarget:self selector:@selector(fadeInHowToDefendTutorialFrame4)], [CCDelayTime actionWithDuration:1.0], nil]]];
}

-(void) startLevelWithCountDown
{
    [linedPaper runAction: [CCMoveTo actionWithDuration: 1.0 position: ccp(linedPaper.position.x, -410)]];
    [gridLayer runAction: [CCMoveTo actionWithDuration:1.0 position:ccp(gridLayer.position.x, -410)]];
    getReadyLabel.visible = YES;
    
    [linedPaper runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 2.0], [CCMoveTo actionWithDuration: 0.2 position: ccp(linedPaper.position.x, -550)], nil]];
    
    kidsPlayingSoundsReadyToPlay = YES;
    
    if (stage == DAY_TIME_SUBURB) {
        
        //Set background colors to day time
        outside.color = ccc3(255, 255, 255);
        
        if (userIsOnFastDevice) {
            
            outsideBlur.color = ccc3(255, 255, 255);
        }
        
        curtains.color = ccc3(255, 255, 255);
        
        if (userIsOnFastDevice) {
            
            curtainsBlur.color = ccc3(255, 255, 255);
        }
        
        chairs.color = ccc3(255, 255, 255);
        
        if (userIsOnFastDevice) {
            
            chairsBlur.color = ccc3(255, 255, 255);
        }
        
        groundLevel.color = ccc3(255, 255, 255);
        sling1.color = ccc3(255, 255, 255);
        sling2.color = ccc3(255, 255, 255);
        sling1Stem.color = ccc3(255, 255, 255);
        sling1Player2.color = ccc3(255, 255, 255);
        sling2Player2.color = ccc3(255, 255, 255);
        sling2Stem.color = ccc3(255, 255, 255);
        
        birdsBackgroundSounds = [SimpleAudioEngine sharedEngine];
        
        if (birdsBackgroundSounds != nil) {
            // [birdsBackgroundSounds preloadBackgroundMusic:@"SuburbanBirds.mp3"];
            if (birdsBackgroundSounds.willPlayBackgroundMusic) {
                birdsBackgroundSounds.backgroundMusicVolume = 0.02f;
            }
        }
        
        [birdsBackgroundSounds playBackgroundMusic:@"SuburbanBirds.mp3" loop:YES];
        
        //Subroutine that generates a random number to play windChimesBackgroundSounds
        [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfWindChimesSoundsRandomNumber)], [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfWindChimesSoundsRandomNumber)], nil]]];
        
        //Subroutine that generates a random number to play passingCarBackgroundSounds
        [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfPassingCarSoundsRandomNumber)], [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfPassingCarSoundsRandomNumber)], nil]]];
        
        //Subroutine that generates a random number to play DogBarkingBackgroundSounds
        [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfDogBarkingSoundsRandomNumber)], [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfDogBarkingSoundsRandomNumber)], nil]]];
        
        //Subroutine that generates a random number to play LightAircraftPassingByBackgroundSounds
        [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfLightAircraftPassingBySoundsRandomNumber)], [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(chanceOfLightAircraftPassingBySoundsRandomNumber)], nil]]];
    }
    
    else if (stage == NIGHT_TIME_SUBURB) {
        
        //Set background colors to night time
        outside.color = ccc3(70, 130, 180);
        
        if (userIsOnFastDevice) {
            
            outsideBlur.color = ccc3(70, 130, 180);
        }
        
        curtains.color = ccc3(25, 25, 112);
        
        if (userIsOnFastDevice) {
            
            curtainsBlur.color = ccc3(25, 25, 112);
        }
        
        chairs.color = ccc3(25, 25, 112);
        
        if (userIsOnFastDevice) {
            
            chairsBlur.color = ccc3(25, 25, 112);
        }
        
        groundLevel.color = ccc3(25, 25, 112);
        sling1.color = ccc3(135, 206, 250);
        sling2.color = ccc3(135, 206, 250);
        sling1Stem.color = ccc3(135, 206, 250);
        sling1Player2.color = ccc3(135, 206, 250);
        sling2Player2.color = ccc3(135, 206, 250);
        sling2Stem.color = ccc3(135, 206, 250);
        
        SimpleAudioEngine *cricketsBackgroundSounds = [SimpleAudioEngine sharedEngine];
        
        if (cricketsBackgroundSounds != nil) {
            // [cricketsBackgroundSounds preloadBackgroundMusic:@"SuburbanBirds.mp3"];
            if (cricketsBackgroundSounds.willPlayBackgroundMusic) {
                cricketsBackgroundSounds.backgroundMusicVolume = 0.01f;
            }
        }
        
        [cricketsBackgroundSounds playBackgroundMusic:@"crickets.caf" loop:YES];
    }
    
    //Make CLICKING SOUND HERE
    
    if ((player1Winner == NO && player2Winner == NO) && isSinglePlayer == YES && startingSequenceBegan == NO) {
        
        startingSequenceBegan = YES;
        parallaxNode.visible = YES;
        isGo = YES;
        
        //run crosshairs animation on gerty2
        [crosshairs2 runAction: [CCFadeOut actionWithDuration: 0.0]];
        [crosshairs2 runAction: [CCScaleTo actionWithDuration:0.0 scale:0.5]];
        
        [crosshairs2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.5], [CCFadeIn actionWithDuration:0.5], nil]];
        [crosshairs2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration:2.0], [CCMoveTo actionWithDuration:0.0 position:ccp(gerty2.position.x + 0, gerty2.position.y + 0)], nil]];
        
        [crosshairs2 runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCScaleTo actionWithDuration:0.3 scale:0.45], [CCScaleTo actionWithDuration:0.3 scale: 0.3],  nil]]];
        [crosshairs2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 6.3], [CCFadeOut actionWithDuration:0.4], nil]];
        //In single player, fade out 'You' and 'Enemy' labels
        [youLabelInGame runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCFadeOut actionWithDuration:0.4], nil]];
        [enemyLabelInGame runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCFadeOut actionWithDuration:0.4], nil]];
        
        
        //run PointingFinger animation over Sling1
        [pointingFinger1 runAction: [CCFadeOut actionWithDuration: 0.0]];
        [pointingFinger1 runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(sling1.position.x, sling1.position.y + 30)]];
        [pointingFinger1 runAction: [CCScaleBy actionWithDuration:0.0 scale:0.2]];
        
        [pointingFinger1 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 6.0], [CCFadeIn actionWithDuration:0.0], nil]];
        [pointingFinger1 runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCMoveTo actionWithDuration:0.3 position:ccp(sling1.position.x, sling1.position.y + 35)], [CCMoveTo actionWithDuration:0.3 position:ccp(sling1.position.x, sling1.position.y + 30)],  nil]]];
        
        
        //If device is not running iOS6, shift the y coordinate a bit.  Also, only zoom in and pan back and forth if device is running iOS6.  This particular section pans the camera to the 1st player's side
        if (deviceIsRunningiOS6 == YES && userIsOnFastDevice && !deviceIsWidescreen) {
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 2.0], [CCCallFunc actionWithTarget:self selector:@selector(zoomInForStartup)], nil]];
            
            [parallaxNode runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 2.0], [CCMoveTo actionWithDuration: 0.25 position: ccp(190,142)], nil]];
        }
        
        else if (deviceIsWidescreen) {
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 2.0], [CCCallFunc actionWithTarget:self selector:@selector(zoomInForStartup)], nil]];
            
            [parallaxNode runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 2.0], [CCMoveTo actionWithDuration: 0.25 position: ccp(325,142)], nil]];
        }
        
        
        //If device is not running iOS6, shift the y coordinate a bit.  The following pans the camera to the second player side
        if (deviceIsRunningiOS6 == YES && userIsOnFastDevice) {
            
            [parallaxNode runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3.0], [CCMoveTo actionWithDuration: 0.25 position: ccp(-241,142)], nil]];
        }
        /*
         else {
         
         [parallaxNode runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3.0], [CCMoveTo actionWithDuration: 0.25 position: ccp(-271,227)], nil]];
         }
         */
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 4.0], [CCCallFunc actionWithTarget:self selector:@selector(zoomOut)], nil]];
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CGPoint centerOfScreen = ccp(winSize.width/2, winSize.height/2);
        
        //three animation
        //three set size big, fade out fully
        [threeLabel runAction: [CCFadeOut actionWithDuration: 0.0]];
        [threeLabel runAction: [CCScaleTo actionWithDuration: 0.0 scale:2]];
        //three center into place
        [threeLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 2.0], [CCMoveTo actionWithDuration: 0.0 position: centerOfScreen], nil]];
        //three scale smaller, fade in fully
        [threeLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 2.0], [CCScaleTo actionWithDuration:0.3 scale:0.5], nil]];
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 2.3], [CCCallFunc actionWithTarget:self selector:@selector(playCountdownBlip)], nil]];
        [threeLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 2.0], [CCFadeIn actionWithDuration:0.3], nil]];
        //three move awawy
        [threeLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3.0],[CCMoveTo actionWithDuration: 0.0 position: ccp(-300, -300)], nil]];
        
        //two animation
        [twoLabel runAction: [CCFadeOut actionWithDuration: 0.0]];
        [twoLabel runAction: [CCScaleTo actionWithDuration: 0.0 scale:2]];
        //two center into place
        [twoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3.0], [CCMoveTo actionWithDuration: 0.0 position: centerOfScreen], nil]];
        //two scale smaller, fade in fully
        [twoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3.0], [CCScaleTo actionWithDuration:0.3 scale:0.5], nil]];
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3.3], [CCCallFunc actionWithTarget:self selector:@selector(playCountdownBlip)], nil]];
        [twoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3.0], [CCFadeIn actionWithDuration:0.3], nil]];
        //two move awawy
        [twoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 4.0],[CCMoveTo actionWithDuration: 0.0 position: ccp(-300, -300)], nil]];
        
        //one animation
        [oneLabel runAction: [CCFadeOut actionWithDuration: 0.0]];
        [oneLabel runAction: [CCScaleTo actionWithDuration: 0.0 scale:2]];
        //one center into place
        [oneLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 4.0], [CCMoveTo actionWithDuration: 0.0 position: centerOfScreen], nil]];
        //one scale smaller, fade in fully
        [oneLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 4.0], [CCScaleTo actionWithDuration:0.3 scale:0.5], nil]];
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 4.3], [CCCallFunc actionWithTarget:self selector:@selector(playCountdownBlip)], nil]];
        [oneLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 4.0], [CCFadeIn actionWithDuration:0.3], nil]];
        //one move awawy
        [oneLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0],[CCMoveTo actionWithDuration: 0.0 position: ccp(-300, -300)], nil]];
        
        if (isSinglePlayer) {
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.3], [CCCallFunc actionWithTarget:self selector:@selector(makePauseButtonVisible)], nil]];
        }
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.3], [CCCallFunc actionWithTarget:self selector:@selector(playCountdownBlip)], nil]];
        
        int characterPositionOffset;
        
        if (deviceIsWidescreen) {
            
            characterPositionOffset = 50;
        }
        
        if (!deviceIsWidescreen) {
            
            characterPositionOffset = 0;
        }
        
        [gCharacterInGoLabel runAction: [CCFadeOut actionWithDuration: 0.0]];
        [gCharacterInGoLabel runAction: [CCScaleTo actionWithDuration: 0.0 scale:2]];
        //one center into place
        [gCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCMoveTo actionWithDuration: 0.0 position: ccp((165 + characterPositionOffset), 160)], nil]];
        //one scale smaller, fade in fully
        [gCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCScaleTo actionWithDuration:0.3 scale:0.5], nil]];
        [gCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCFadeIn actionWithDuration:0.3], nil]];
        //one move awawy
        [gCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 6.0],[CCMoveTo actionWithDuration: 0.0 position: ccp(-300, -300)], nil]];
        
        [oCharacterInGoLabel runAction: [CCFadeOut actionWithDuration: 0.0]];
        [oCharacterInGoLabel runAction: [CCScaleTo actionWithDuration: 0.0 scale:2]];
        //one center into place
        [oCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCMoveTo actionWithDuration: 0.0 position: ccp((260 + characterPositionOffset), 160)], nil]];
        //one scale smaller, fade in fully
        [oCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCScaleTo actionWithDuration:0.3 scale:0.5], nil]];
        [oCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCFadeIn actionWithDuration:0.3], nil]];
        //one move awawy
        [oCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 6.0],[CCMoveTo actionWithDuration: 0.0 position: ccp(-300, -300)], nil]];
        
        [exclamationCharacterInGoLabel runAction: [CCFadeOut actionWithDuration: 0.0]];
        [exclamationCharacterInGoLabel runAction: [CCScaleTo actionWithDuration: 0.0 scale:2]];
        //one center into place
        [exclamationCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCMoveTo actionWithDuration: 0.0 position: ccp((325 + characterPositionOffset), 160)], nil]];
        //one scale smaller, fade in fully
        [exclamationCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCScaleTo actionWithDuration:0.3 scale:0.5], nil]];
        [exclamationCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCFadeIn actionWithDuration:0.3], nil]];
        //one move awawy
        [exclamationCharacterInGoLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 6.0],[CCMoveTo actionWithDuration: 0.0 position: ccp(-300, -300)], nil]];
        
        if (inGameTutorialHasAlreadyBeenPlayedOnce == NO) {
            
            //Show Tutorial Here.  Once player taps away tutorial 'getReadyLabelNotVisible' will be called and the game can start
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 6.0], [CCCallFunc actionWithTarget:self selector:@selector(howToPlayTutorial)], nil]];
        }
        
        else {
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 6.0], [CCCallFunc actionWithTarget:self selector:@selector(getReadyLabelNotVisible)], nil]];
        }
    }
}

-(void) restartGameSceneWithNoTransition
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:0.0 scene:[Game scene]]];
}

-(void) startSpaceManagerAndTimeStep
{
    [smgr start];
    [self schedule: @selector(step:)];
}

-(void) resetAllVariables
{
    bonusPoints1 = 0;
    bonusPoints2 = 0;
    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = YES;
    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = YES;
    opponentDisconnected = NO;
    player2BombInPlay = YES;
    marblePlayer2IsReadyToSling = YES;
    firstMatchWithThisPlayer = YES;
    prelaunchDelayTime = 0;
    sentPingTime = 0;
    receivedPingTime = 0;
    pingTime = 0;
    woodBlockTouched = NO;
    woodBlock2Touched = NO;
    woodBlock3Touched = NO;
    lightningStrikePlayer1Ready = YES;
    lightningStrikePlayer2Ready = YES;
    isAtMainMenu = YES;
    doNotShowMarblePointFinger1 = NO;
    doNotShowMarblePointFinger2 = NO;
    player1ProjectileCanBeTouchedAgain = YES;
    player2ProjectileCanBeTouchedAgain = YES;
    player1IsTheWinnerScriptHasBeenPlayed = NO;
    player2IsTheWinnerScriptHasBeenPlayed = NO;
    player1LightningExists = NO;
    player2LightningExists = NO;
    destroyedBlocksInARow1 = 0;
    destroyedBlocksInARow2 = 0;
    increaseBigSmokeTimeInterval1 = 0.16;
    increaseBigSmokeTimeInterval2 = 0.16;
    gridLayerPosition = 0;
    playersCanTouchMarblesNow = NO;
    lightAircraftPassingBySoundsReadyToPlay = YES;
    dogBarkingSoundsReadyToPlay = YES;
    passingCarSoundsReadyToPlay = YES;
    windChimesSoundsReadyToPlay = YES;
    startingSequenceBegan = NO;
    //player1ExperiencePointsToAdd = 0;
    player1GertyShouldBeDead = NO;
    player2GertyShouldBeDead = NO;
    computerNumberOfChargingRounds = 0;
    player1SlingIsSmoking = NO;
    player2SlingIsSmoking = NO;
    computerSettingNewVelocityandMovingBomb = NO;
    player1GiantSmokeCloudFrontOpacityIsIncreasing = YES;
    player2GiantSmokeCloudFrontOpacityIsIncreasing = YES;
    player1GiantSmokeCloudFrontOpacity = 0;
    player1GiantSmokeCloudBackOpacity = 0;
    player2GiantSmokeCloudFrontOpacity = 0;
    player2GiantSmokeCloudBackOpacity = 0;
    player1ProjectileIsZappable = YES;
    player2ProjectileIsZappable = YES;
    isGo = NO;
    waitingForStartup = YES;
    gamePaused = NO;
    guideLineIsBlinking = NO;
    bombHasHitRectangleHenceNoBonus1 = NO;
    bombHasHitRectangleHenceNoBonus2 = NO;
    skillLevelBonus = 0;
    chargedShotTimeEnded = 0;
    chargedShotTimeStarted = 0;
    player1Winner = NO;
    player2Winner = NO;
    player1ProjectileHasBeenTouched = NO;
    player2ProjectileHasBeenTouched = NO;
    firstPlayer1MarbleSetToGreen = NO;
    firstPlayer2MarbleSetToGreen = NO;
    player1BombZapped = NO;
    player2BombZapped = NO;
    fieldZoomedOut = YES;
    player1BombIsAirborne = NO;
    player2BombIsAirborne = NO;
    readyToReceiveBlocksPositionsFromPlayer1 = NO;
    readyToReceiveBlockNumbersFromPlayer2 = NO;
    readyForEnemyToFire = NO;
    readyForEnemyToBlock = NO;
    blockingChargeBonusPlayer1 = 0;
    blockingChargeBonusPlayer2 = 0;
    projectileChargingPitchPlayer1 = 0;
    projectileChargingPitchPlayer2 = 0;
    receivingChargingDataFromPlayer1 = NO;
    receivingChargingDataFromPlayer2 = NO;
    
    player1HasGreenBall = NO;
    player1HasRedBall = NO;
    player1HasBlueBall = NO;
    player1HasYellowBall = NO;
    player1HasBlackBall = NO;
    player2HasGreenBall = NO;
    player2HasRedBall = NO;
    player2HasBlueBall = NO;
    player2HasYellowBall = NO;
    player2HasBlackBall = NO;
}

-(void) clearLevel
{
    [smgr stop];
    [self unschedule: @selector(step:)];
    [self stopAllActions];
    
    bonusPoints1 = 0;
    bonusPoints2 = 0;
    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = YES;
    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = YES;
    opponentDisconnected = NO;
    player2BombInPlay = YES;
    marblePlayer2IsReadyToSling = YES;
    firstMatchWithThisPlayer = YES;
    prelaunchDelayTime = 0;
    sentPingTime = 0;
    receivedPingTime = 0;
    pingTime = 0;
    woodBlockTouched = NO;
    woodBlock2Touched = NO;
    woodBlock3Touched = NO;
    lightningStrikePlayer1Ready = YES;
    lightningStrikePlayer2Ready = YES;
    isAtMainMenu = YES;
    doNotShowMarblePointFinger1 = NO;
    doNotShowMarblePointFinger2 = NO;
    player1ProjectileCanBeTouchedAgain = YES;
    player2ProjectileCanBeTouchedAgain = YES;
    player1IsTheWinnerScriptHasBeenPlayed = NO;
    player2IsTheWinnerScriptHasBeenPlayed = NO;
    player1LightningExists = NO;
    player2LightningExists = NO;
    totalSoundSources = 0;
    sourceIDNumber = 0;
    sling1SourceIDNumber = 0;
    sling1SourceIDNumber2 = 0;
    sling1SourceIDNumber3 = 0;
    sling1SourceIDNumber4 = 0;
    sling1SourceIDNumber5 = 0;
    sling1SourceIDNumber6 = 0;
    sling1SourceIDNumber7 = 0;
    sling1SourceIDNumber8 = 0;
    sling1SourceIDNumber9 = 0;
    sling1SourceIDNumber10 = 0;
    sling1SourceIDNumber11 = 0;
    sling1SourceIDNumber12 = 0;
    sling1SourceIDNumber13 = 0;
    sling1SourceIDNumber14 = 0;
    sling1SourceIDNumber15 = 0;
    sling1SourceIDNumber16 = 0;
    sling1SourceIDNumber17 = 0;
    sling1SourceIDNumber18 = 0;
    sling1SourceIDNumber19 = 0;
    sling1SourceIDNumber20 = 0;
    sling1SourceIDNumber21 = 0;
    sling1SourceIDNumber22 = 0;
    sling1SourceIDNumber23 = 0;
    sling1SourceIDNumber24 = 0;
    sling1SourceIDNumber25 = 0;
    sling1SourceIDNumber26 = 0;
    sling1SourceIDNumber27 = 0;
    sling1SourceIDNumber28 = 0;
    sling1SourceIDNumber29 = 0;
    sling1SourceIDNumber30 = 0;
    sling2SourceIDNumber = 0;
    sling2SourceIDNumber2 = 0;
    sling2SourceIDNumber3 = 0;
    destroyedBlocksInARow1 = 0;
    destroyedBlocksInARow2 = 0;
    increaseBigSmokeTimeInterval1 = 0.16;
    increaseBigSmokeTimeInterval2 = 0.16;
    gridLayerPosition = 0;
    playersCanTouchMarblesNow = NO;
    lightAircraftPassingBySoundsReadyToPlay = YES;
    dogBarkingSoundsReadyToPlay = YES;
    passingCarSoundsReadyToPlay = YES;
    windChimesSoundsReadyToPlay = YES;
    startingSequenceBegan = NO;
    //  player1ExperiencePointsToAdd = 0;
    player1GertyShouldBeDead = NO;
    player2GertyShouldBeDead = NO;
    computerNumberOfChargingRounds = 0;
    player1SlingIsSmoking = NO;
    player2SlingIsSmoking = NO;
    computerSettingNewVelocityandMovingBomb = NO;
    player1GiantSmokeCloudFrontOpacityIsIncreasing = YES;
    player2GiantSmokeCloudFrontOpacityIsIncreasing = YES;
    player1GiantSmokeCloudFrontOpacity = 0;
    player1GiantSmokeCloudBackOpacity = 0;
    player2GiantSmokeCloudFrontOpacity = 0;
    player2GiantSmokeCloudBackOpacity = 0;
    player1ProjectileIsZappable = YES;
    player2ProjectileIsZappable = YES;
    isGo = NO;
    waitingForStartup = YES;
    gamePaused = NO;
    guideLineIsBlinking = NO;
    bombHasHitRectangleHenceNoBonus1 = NO;
    bombHasHitRectangleHenceNoBonus2 = NO;
    skillLevelBonus = 0;
    chargedShotTimeEnded = 0;
    chargedShotTimeStarted = 0;
    player1Winner = NO;
    player2Winner = NO;
    player1ProjectileHasBeenTouched = NO;
    player2ProjectileHasBeenTouched = NO;
    firstPlayer1MarbleSetToGreen = NO;
    firstPlayer2MarbleSetToGreen = NO;
    player1BombZapped = NO;
    player2BombZapped = NO;
    fieldZoomedOut = YES;
    player1BombIsAirborne = NO;
    player2BombIsAirborne = NO;
    readyToReceiveBlocksPositionsFromPlayer1 = NO;
    readyToReceiveBlockNumbersFromPlayer2 = NO;
    readyForEnemyToFire = NO;
    readyForEnemyToBlock = NO;
    blockingChargeBonusPlayer1 = 0;
    blockingChargeBonusPlayer2 = 0;
    projectileChargingPitchPlayer1 = 0;
    projectileChargingPitchPlayer2 = 0;
    receivingChargingDataFromPlayer1 = NO;
    receivingChargingDataFromPlayer2 = NO;
    
    player1HasGreenBall = NO;
    player1HasRedBall = NO;
    player1HasBlueBall = NO;
    player1HasYellowBall = NO;
    player1HasBlackBall = NO;
    player2HasGreenBall = NO;
    player2HasRedBall = NO;
    player2HasBlueBall = NO;
    player2HasYellowBall = NO;
    player2HasBlackBall = NO;
    
    [zoombase removeAllChildrenWithCleanup: YES];
}

-(void) clearAndRestartLevelFromVictoryOrLossScreen
{
    [smgr stop];
    [self unschedule: @selector(step:)];
    [self stopAllActions];
    /*
     if (player1ProjectileHasBeenTouched) {
     
     NSLog (@"player1SlotMachineAnimation should stop now!");
     gertySlotAnimationIsRunning = NO;
     [self stopAction: player1SlotMachineAnimation];
     }
     
     if (player2ProjectileHasBeenTouched) {
     
     NSLog (@"player2SlotMachineAnimation should stop now!");
     gerty2SlotAnimationIsRunning = NO;
     [self stopAction: player2SlotMachineAnimation];
     }
     */
    player1GiantSmokeCloudFrontOpacity = 10;
    player1GiantSmokeCloudFrontOpacity = 10;
    
    bonusPoints1 = 0;
    bonusPoints2 = 0;
    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = YES;
    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = YES;
    opponentDisconnected = NO;
    player2BombInPlay = YES;
    marblePlayer2IsReadyToSling = YES;
    prelaunchDelayTime = 0;
    sentPingTime = 0;
    receivedPingTime = 0;
    pingTime = 0;
    woodBlockTouched = NO;
    woodBlock2Touched = NO;
    woodBlock3Touched = NO;
    lightningStrikePlayer1Ready = YES;
    lightningStrikePlayer2Ready = YES;
    isAtMainMenu = NO;
    doNotShowMarblePointFinger1 = NO;
    doNotShowMarblePointFinger2 = NO;
    player1ProjectileCanBeTouchedAgain = YES;
    player2ProjectileCanBeTouchedAgain = YES;
    player1IsTheWinnerScriptHasBeenPlayed = NO;
    player2IsTheWinnerScriptHasBeenPlayed = NO;
    player1LightningExists = NO;
    player2LightningExists = NO;
    totalSoundSources = 0;
    sourceIDNumber = 0;
    sling1SourceIDNumber = 0;
    sling1SourceIDNumber2 = 0;
    sling1SourceIDNumber3 = 0;
    sling1SourceIDNumber4 = 0;
    sling1SourceIDNumber5 = 0;
    sling1SourceIDNumber6 = 0;
    sling1SourceIDNumber7 = 0;
    sling1SourceIDNumber8 = 0;
    sling1SourceIDNumber9 = 0;
    sling1SourceIDNumber10 = 0;
    sling1SourceIDNumber11 = 0;
    sling1SourceIDNumber12 = 0;
    sling1SourceIDNumber13 = 0;
    sling1SourceIDNumber14 = 0;
    sling1SourceIDNumber15 = 0;
    sling1SourceIDNumber16 = 0;
    sling1SourceIDNumber17 = 0;
    sling1SourceIDNumber18 = 0;
    sling1SourceIDNumber19 = 0;
    sling1SourceIDNumber20 = 0;
    sling1SourceIDNumber21 = 0;
    sling1SourceIDNumber22 = 0;
    sling1SourceIDNumber23 = 0;
    sling1SourceIDNumber24 = 0;
    sling1SourceIDNumber25 = 0;
    sling1SourceIDNumber26 = 0;
    sling1SourceIDNumber27 = 0;
    sling1SourceIDNumber28 = 0;
    sling1SourceIDNumber29 = 0;
    sling1SourceIDNumber30 = 0;
    sling2SourceIDNumber = 0;
    sling2SourceIDNumber2 = 0;
    sling2SourceIDNumber3 = 0;
    destroyedBlocksInARow1 = 0;
    destroyedBlocksInARow2 = 0;
    increaseBigSmokeTimeInterval1 = 0.16;
    increaseBigSmokeTimeInterval2 = 0.16;
    gridLayerPosition = 0;
    playersCanTouchMarblesNow = NO;
    lightAircraftPassingBySoundsReadyToPlay = YES;
    dogBarkingSoundsReadyToPlay = YES;
    passingCarSoundsReadyToPlay = YES;
    windChimesSoundsReadyToPlay = YES;
    startingSequenceBegan = NO;
    //  player1ExperiencePointsToAdd = 0;
    player1GertyShouldBeDead = NO;
    player2GertyShouldBeDead = NO;
    computerNumberOfChargingRounds = 0;
    player1SlingIsSmoking = NO;
    player2SlingIsSmoking = NO;
    computerSettingNewVelocityandMovingBomb = NO;
    player1GiantSmokeCloudFrontOpacityIsIncreasing = YES;
    player2GiantSmokeCloudFrontOpacityIsIncreasing = YES;
    player1GiantSmokeCloudFrontOpacity = 0;
    player1GiantSmokeCloudBackOpacity = 0;
    player2GiantSmokeCloudFrontOpacity = 0;
    player2GiantSmokeCloudBackOpacity = 0;
    player1ProjectileIsZappable = YES;
    player2ProjectileIsZappable = YES;
    isGo = NO;
    waitingForStartup = YES;
    gamePaused = NO;
    guideLineIsBlinking = NO;
    bombHasHitRectangleHenceNoBonus1 = NO;
    bombHasHitRectangleHenceNoBonus2 = NO;
    skillLevelBonus = 0;
    chargedShotTimeEnded = 0;
    chargedShotTimeStarted = 0;
    player1Winner = NO;
    player2Winner = NO;
    player1ProjectileHasBeenTouched = NO;
    player2ProjectileHasBeenTouched = NO;
    firstPlayer1MarbleSetToGreen = NO;
    firstPlayer2MarbleSetToGreen = NO;
    player1BombZapped = NO;
    player2BombZapped = NO;
    fieldZoomedOut = YES;
    player1BombIsAirborne = NO;
    player2BombIsAirborne = NO;
    readyToReceiveBlocksPositionsFromPlayer1 = NO;
    readyToReceiveBlockNumbersFromPlayer2 = NO;
    readyForEnemyToFire = NO;
    readyForEnemyToBlock = NO;
    blockingChargeBonusPlayer1 = 0;
    blockingChargeBonusPlayer2 = 0;
    projectileChargingPitchPlayer1 = 0;
    projectileChargingPitchPlayer2 = 0;
    receivingChargingDataFromPlayer1 = NO;
    receivingChargingDataFromPlayer2 = NO;
    
    player1HasGreenBall = NO;
    player1HasRedBall = NO;
    player1HasBlueBall = NO;
    player1HasYellowBall = NO;
    player1HasBlackBall = NO;
    player2HasGreenBall = NO;
    player2HasRedBall = NO;
    player2HasBlueBall = NO;
    player2HasYellowBall = NO;
    player2HasBlackBall = NO;
    
    winnerLabel.visible = NO;
    lostLabel.visible = NO;
    
    [zoombase removeAllChildrenWithCleanup: YES];
    
    //Choose a random stage if 'Random Stage Select is YES' or if stage == 0 for some technical reason
    if (checkMarkSpeechBubbleStageSelectIsOnRandomButton || stage == 0) {
        
        checkMarkSpeechBubbleStageSelectIsOnRandomButton = YES;
        int randomLevelRoll = arc4random()%2;
        
        if (randomLevelRoll == 0) {
            
            stage = DAY_TIME_SUBURB;
        }
        
        else if (randomLevelRoll == 1) {
            
            stage = NIGHT_TIME_SUBURB;
        }
    }
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(setupMarblesAndBlocks)], nil]];
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.0], [CCCallFunc actionWithTarget:self selector:@selector(startSpaceManagerAndTimeStep)], nil]];
    
}

-(void) clearAndRestartMultiplayerMatch
{
    [smgr stop];
    [self unschedule: @selector(step:)];
    [self stopAllActions];

    
    [zoombase removeAllChildrenWithCleanup: YES];
    
    winnerLabel.visible = NO;
    lostLabel.visible = NO;
    
    player1GiantSmokeCloudFrontOpacity = 10;
    player1GiantSmokeCloudFrontOpacity = 10;
    
    bonusPoints1 = 0;
    bonusPoints2 = 0;
    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = YES;
    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = YES;
    player2BombInPlay = YES;
    marblePlayer2IsReadyToSling = YES;
    prelaunchDelayTime = 0;
    sentPingTime = 0;
    receivedPingTime = 0;
    pingTime = 0;
    otherPlayerWishesToPlayAgain = NO;
    woodBlockTouched = NO;
    woodBlock2Touched = NO;
    woodBlock3Touched = NO;
    lightningStrikePlayer1Ready = YES;
    lightningStrikePlayer2Ready = YES;
    isAtMainMenu = NO;
    doNotShowMarblePointFinger1 = NO;
    doNotShowMarblePointFinger2 = NO;
    player1ProjectileCanBeTouchedAgain = YES;
    player2ProjectileCanBeTouchedAgain = YES;
    player1IsTheWinnerScriptHasBeenPlayed = NO;
    player2IsTheWinnerScriptHasBeenPlayed = NO;
    player1LightningExists = NO;
    player2LightningExists = NO;
    totalSoundSources = 0;
    sourceIDNumber = 0;
    sling1SourceIDNumber = 0;
    sling1SourceIDNumber2 = 0;
    sling1SourceIDNumber3 = 0;
    sling1SourceIDNumber4 = 0;
    sling1SourceIDNumber5 = 0;
    sling1SourceIDNumber6 = 0;
    sling1SourceIDNumber7 = 0;
    sling1SourceIDNumber8 = 0;
    sling1SourceIDNumber9 = 0;
    sling1SourceIDNumber10 = 0;
    sling1SourceIDNumber11 = 0;
    sling1SourceIDNumber12 = 0;
    sling1SourceIDNumber13 = 0;
    sling1SourceIDNumber14 = 0;
    sling1SourceIDNumber15 = 0;
    sling1SourceIDNumber16 = 0;
    sling1SourceIDNumber17 = 0;
    sling1SourceIDNumber18 = 0;
    sling1SourceIDNumber19 = 0;
    sling1SourceIDNumber20 = 0;
    sling1SourceIDNumber21 = 0;
    sling1SourceIDNumber22 = 0;
    sling1SourceIDNumber23 = 0;
    sling1SourceIDNumber24 = 0;
    sling1SourceIDNumber25 = 0;
    sling1SourceIDNumber26 = 0;
    sling1SourceIDNumber27 = 0;
    sling1SourceIDNumber28 = 0;
    sling1SourceIDNumber29 = 0;
    sling1SourceIDNumber30 = 0;
    sling2SourceIDNumber = 0;
    sling2SourceIDNumber2 = 0;
    sling2SourceIDNumber3 = 0;
    destroyedBlocksInARow1 = 0;
    destroyedBlocksInARow2 = 0;
    increaseBigSmokeTimeInterval1 = 0.16;
    increaseBigSmokeTimeInterval2 = 0.16;
    gridLayerPosition = 0;
    playersCanTouchMarblesNow = NO;
    lightAircraftPassingBySoundsReadyToPlay = YES;
    dogBarkingSoundsReadyToPlay = YES;
    passingCarSoundsReadyToPlay = YES;
    windChimesSoundsReadyToPlay = YES;
    startingSequenceBegan = NO;
    //   player1ExperiencePointsToAdd = 0;
    player1GertyShouldBeDead = NO;
    player2GertyShouldBeDead = NO;
    computerNumberOfChargingRounds = 0;
    player1SlingIsSmoking = NO;
    player2SlingIsSmoking = NO;
    computerSettingNewVelocityandMovingBomb = NO;
    player1GiantSmokeCloudFrontOpacityIsIncreasing = YES;
    player2GiantSmokeCloudFrontOpacityIsIncreasing = YES;
    player1GiantSmokeCloudFrontOpacity = 0;
    player1GiantSmokeCloudBackOpacity = 0;
    player2GiantSmokeCloudFrontOpacity = 0;
    player2GiantSmokeCloudBackOpacity = 0;
    player1ProjectileIsZappable = YES;
    player2ProjectileIsZappable = YES;
    isGo = NO;
    waitingForStartup = YES;
    gamePaused = NO;
    guideLineIsBlinking = NO;
    bombHasHitRectangleHenceNoBonus1 = NO;
    bombHasHitRectangleHenceNoBonus2 = NO;
    skillLevelBonus = 0;
    chargedShotTimeEnded = 0;
    chargedShotTimeStarted = 0;
    player1Winner = NO;
    player2Winner = NO;
    player1ProjectileHasBeenTouched = NO;
    player2ProjectileHasBeenTouched = NO;
    firstPlayer1MarbleSetToGreen = NO;
    firstPlayer2MarbleSetToGreen = NO;
    player1BombZapped = NO;
    player2BombZapped = NO;
    fieldZoomedOut = YES;
    player1BombIsAirborne = NO;
    player2BombIsAirborne = NO;
    readyToReceiveBlocksPositionsFromPlayer1 = NO;
    readyToReceiveBlockNumbersFromPlayer2 = NO;
    readyForEnemyToFire = NO;
    readyForEnemyToBlock = NO;
    blockingChargeBonusPlayer1 = 0;
    blockingChargeBonusPlayer2 = 0;
    projectileChargingPitchPlayer1 = 0;
    projectileChargingPitchPlayer2 = 0;
    receivingChargingDataFromPlayer1 = NO;
    receivingChargingDataFromPlayer2 = NO;
    
    player1HasGreenBall = NO;
    player1HasRedBall = NO;
    player1HasBlueBall = NO;
    player1HasYellowBall = NO;
    player1HasBlackBall = NO;
    player2HasGreenBall = NO;
    player2HasRedBall = NO;
    player2HasBlueBall = NO;
    player2HasYellowBall = NO;
    player2HasBlackBall = NO;
    
    //playerLabel.visible = NO;
    
    //Choose a random stage if 'Random Stage Select is YES' or if stage == 0 for some technical reason
    if (checkMarkSpeechBubbleStageSelectIsOnRandomButton || stage == 0) {
        
        checkMarkSpeechBubbleStageSelectIsOnRandomButton = YES;
        int randomLevelRoll = arc4random()%2;
        
        if (randomLevelRoll == 0) {
            
            stage = DAY_TIME_SUBURB;
        }
        
        else if (randomLevelRoll == 1) {
            
            stage = NIGHT_TIME_SUBURB;
        }
    }
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.5], [CCCallFunc actionWithTarget:self selector:@selector(setupMarblesAndBlocks)], nil]];
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.0], [CCCallFunc actionWithTarget:self selector:@selector(startSpaceManagerAndTimeStep)], nil]];
}

-(void) clearAndRestartLevelFromSinglePlayerVersusScreen
{
    [smgr stop];
    [self unschedule: @selector(step:)];
    //  [self stopAllActions];
    /*
     if (player1ProjectileHasBeenTouched) {
     
     NSLog (@"player1SlotMachineAnimation should stop now!");
     gertySlotAnimationIsRunning = NO;
     [self stopAction: player1SlotMachineAnimation];
     }
     
     if (player2ProjectileHasBeenTouched) {
     
     NSLog (@"player2SlotMachineAnimation should stop now!");
     gerty2SlotAnimationIsRunning = NO;
     [self stopAction: player2SlotMachineAnimation];
     }
     */
    player1GiantSmokeCloudFrontOpacity = 10;
    player1GiantSmokeCloudFrontOpacity = 10;
    
    bonusPoints1 = 0;
    bonusPoints2 = 0;
    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = YES;
    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = YES;
    opponentDisconnected = NO;
    isSinglePlayer = YES;
    player2BombInPlay = YES;
    marblePlayer2IsReadyToSling = YES;
    firstMatchWithThisPlayer = YES;
    prelaunchDelayTime = 0;
    sentPingTime = 0;
    receivedPingTime = 0;
    pingTime = 0;
    woodBlockTouched = NO;
    woodBlock2Touched = NO;
    woodBlock3Touched = NO;
    lightningStrikePlayer1Ready = YES;
    lightningStrikePlayer2Ready = YES;
    isAtMainMenu = YES;
    doNotShowMarblePointFinger1 = NO;
    doNotShowMarblePointFinger2 = NO;
    player1ProjectileCanBeTouchedAgain = YES;
    player2ProjectileCanBeTouchedAgain = YES;
    player1IsTheWinnerScriptHasBeenPlayed = NO;
    player2IsTheWinnerScriptHasBeenPlayed = NO;
    player1LightningExists = NO;
    player2LightningExists = NO;
    totalSoundSources = 0;
    sourceIDNumber = 0;
    sling1SourceIDNumber = 0;
    sling1SourceIDNumber2 = 0;
    sling1SourceIDNumber3 = 0;
    sling1SourceIDNumber4 = 0;
    sling1SourceIDNumber5 = 0;
    sling1SourceIDNumber6 = 0;
    sling1SourceIDNumber7 = 0;
    sling1SourceIDNumber8 = 0;
    sling1SourceIDNumber9 = 0;
    sling1SourceIDNumber10 = 0;
    sling1SourceIDNumber11 = 0;
    sling1SourceIDNumber12 = 0;
    sling1SourceIDNumber13 = 0;
    sling1SourceIDNumber14 = 0;
    sling1SourceIDNumber15 = 0;
    sling1SourceIDNumber16 = 0;
    sling1SourceIDNumber17 = 0;
    sling1SourceIDNumber18 = 0;
    sling1SourceIDNumber19 = 0;
    sling1SourceIDNumber20 = 0;
    sling1SourceIDNumber21 = 0;
    sling1SourceIDNumber22 = 0;
    sling1SourceIDNumber23 = 0;
    sling1SourceIDNumber24 = 0;
    sling1SourceIDNumber25 = 0;
    sling1SourceIDNumber26 = 0;
    sling1SourceIDNumber27 = 0;
    sling1SourceIDNumber28 = 0;
    sling1SourceIDNumber29 = 0;
    sling1SourceIDNumber30 = 0;
    sling2SourceIDNumber = 0;
    sling2SourceIDNumber2 = 0;
    sling2SourceIDNumber3 = 0;
    destroyedBlocksInARow1 = 0;
    destroyedBlocksInARow2 = 0;
    increaseBigSmokeTimeInterval1 = 0.16;
    increaseBigSmokeTimeInterval2 = 0.16;
    gridLayerPosition = 0;
    playersCanTouchMarblesNow = NO;
    lightAircraftPassingBySoundsReadyToPlay = YES;
    dogBarkingSoundsReadyToPlay = YES;
    passingCarSoundsReadyToPlay = YES;
    windChimesSoundsReadyToPlay = YES;
    startingSequenceBegan = NO;
    //player1ExperiencePointsToAdd = 0;
    player1GertyShouldBeDead = NO;
    player2GertyShouldBeDead = NO;
    computerNumberOfChargingRounds = 0;
    player1SlingIsSmoking = NO;
    player2SlingIsSmoking = NO;
    computerSettingNewVelocityandMovingBomb = NO;
    player1GiantSmokeCloudFrontOpacityIsIncreasing = YES;
    player2GiantSmokeCloudFrontOpacityIsIncreasing = YES;
    player1GiantSmokeCloudFrontOpacity = 0;
    player1GiantSmokeCloudBackOpacity = 0;
    player2GiantSmokeCloudFrontOpacity = 0;
    player2GiantSmokeCloudBackOpacity = 0;
    player1ProjectileIsZappable = YES;
    player2ProjectileIsZappable = YES;
    isGo = NO;
    waitingForStartup = YES;
    gamePaused = NO;
    guideLineIsBlinking = NO;
    bombHasHitRectangleHenceNoBonus1 = NO;
    bombHasHitRectangleHenceNoBonus2 = NO;
    skillLevelBonus = 0;
    chargedShotTimeEnded = 0;
    chargedShotTimeStarted = 0;
    player1Winner = NO;
    player2Winner = NO;
    player1BombExists = NO;
    player2BombExists = NO;
    player1ProjectileHasBeenTouched = NO;
    player2ProjectileHasBeenTouched = NO;
    firstPlayer1MarbleSetToGreen = NO;
    firstPlayer2MarbleSetToGreen = NO;
    player1BombZapped = NO;
    player2BombZapped = NO;
    fieldZoomedOut = YES;
    player1BombIsAirborne = NO;
    player2BombIsAirborne = NO;
    readyToReceiveBlocksPositionsFromPlayer1 = NO;
    readyToReceiveBlockNumbersFromPlayer2 = NO;
    readyForEnemyToFire = NO;
    readyForEnemyToBlock = NO;
    blockingChargeBonusPlayer1 = 0;
    blockingChargeBonusPlayer2 = 0;
    projectileChargingPitchPlayer1 = 0;
    projectileChargingPitchPlayer2 = 0;
    receivingChargingDataFromPlayer1 = NO;
    receivingChargingDataFromPlayer2 = NO;
    
    player1HasGreenBall = NO;
    player1HasRedBall = NO;
    player1HasBlueBall = NO;
    player1HasYellowBall = NO;
    player1HasBlackBall = NO;
    player2HasGreenBall = NO;
    player2HasRedBall = NO;
    player2HasBlueBall = NO;
    player2HasYellowBall = NO;
    player2HasBlackBall = NO;
    
    winnerLabel.visible = NO;
    lostLabel.visible = NO;
    
    [zoombase removeAllChildrenWithCleanup: YES];
    
    // [self setupGertyPlayer1];
    // [self setupGertyPlayer2];
    
    //Choose a random stage if 'Random Stage Select is YES' or if stage == 0 for some technical reason
    if (checkMarkSpeechBubbleStageSelectIsOnRandomButton || stage == 0) {
        
        checkMarkSpeechBubbleStageSelectIsOnRandomButton = YES;
        int randomLevelRoll = arc4random()%2;
        
        if (randomLevelRoll == 0) {
            
            stage = DAY_TIME_SUBURB;
        }
        
        else if (randomLevelRoll == 1) {
            
            stage = NIGHT_TIME_SUBURB;
        }
    }
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(setupMarblesAndBlocks)], nil]];
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.0], [CCCallFunc actionWithTarget:self selector:@selector(startSpaceManagerAndTimeStep)], nil]];
}

-(void) clearAndRestartLevel
{
    [smgr stop];
    [self unschedule: @selector(step:)];
    [self stopAllActions];
    /*
     if (player1ProjectileHasBeenTouched) {
     
     NSLog (@"player1SlotMachineAnimation should stop now!");
     gertySlotAnimationIsRunning = NO;
     [self stopAction: player1SlotMachineAnimation];
     }
     
     if (player2ProjectileHasBeenTouched) {
     
     NSLog (@"player2SlotMachineAnimation should stop now!");
     gerty2SlotAnimationIsRunning = NO;
     [self stopAction: player2SlotMachineAnimation];
     }
     */
    player1GiantSmokeCloudFrontOpacity = 10;
    player1GiantSmokeCloudFrontOpacity = 10;
    
    bonusPoints1 = 0;
    bonusPoints2 = 0;
    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = YES;
    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = YES;
    opponentDisconnected = NO;
    isSinglePlayer = YES;
    player2BombInPlay = YES;
    marblePlayer2IsReadyToSling = YES;
    firstMatchWithThisPlayer = YES;
    prelaunchDelayTime = 0;
    sentPingTime = 0;
    receivedPingTime = 0;
    pingTime = 0;
    woodBlockTouched = NO;
    woodBlock2Touched = NO;
    woodBlock3Touched = NO;
    lightningStrikePlayer1Ready = YES;
    lightningStrikePlayer2Ready = YES;
    isAtMainMenu = YES;
    doNotShowMarblePointFinger1 = NO;
    doNotShowMarblePointFinger2 = NO;
    player1ProjectileCanBeTouchedAgain = YES;
    player2ProjectileCanBeTouchedAgain = YES;
    player1IsTheWinnerScriptHasBeenPlayed = NO;
    player2IsTheWinnerScriptHasBeenPlayed = NO;
    player1LightningExists = NO;
    player2LightningExists = NO;
    totalSoundSources = 0;
    sourceIDNumber = 0;
    sling1SourceIDNumber = 0;
    sling1SourceIDNumber2 = 0;
    sling1SourceIDNumber3 = 0;
    sling1SourceIDNumber4 = 0;
    sling1SourceIDNumber5 = 0;
    sling1SourceIDNumber6 = 0;
    sling1SourceIDNumber7 = 0;
    sling1SourceIDNumber8 = 0;
    sling1SourceIDNumber9 = 0;
    sling1SourceIDNumber10 = 0;
    sling1SourceIDNumber11 = 0;
    sling1SourceIDNumber12 = 0;
    sling1SourceIDNumber13 = 0;
    sling1SourceIDNumber14 = 0;
    sling1SourceIDNumber15 = 0;
    sling1SourceIDNumber16 = 0;
    sling1SourceIDNumber17 = 0;
    sling1SourceIDNumber18 = 0;
    sling1SourceIDNumber19 = 0;
    sling1SourceIDNumber20 = 0;
    sling1SourceIDNumber21 = 0;
    sling1SourceIDNumber22 = 0;
    sling1SourceIDNumber23 = 0;
    sling1SourceIDNumber24 = 0;
    sling1SourceIDNumber25 = 0;
    sling1SourceIDNumber26 = 0;
    sling1SourceIDNumber27 = 0;
    sling1SourceIDNumber28 = 0;
    sling1SourceIDNumber29 = 0;
    sling1SourceIDNumber30 = 0;
    sling2SourceIDNumber = 0;
    sling2SourceIDNumber2 = 0;
    sling2SourceIDNumber3 = 0;
    destroyedBlocksInARow1 = 0;
    destroyedBlocksInARow2 = 0;
    increaseBigSmokeTimeInterval1 = 0.16;
    increaseBigSmokeTimeInterval2 = 0.16;
    gridLayerPosition = 0;
    playersCanTouchMarblesNow = NO;
    lightAircraftPassingBySoundsReadyToPlay = YES;
    dogBarkingSoundsReadyToPlay = YES;
    passingCarSoundsReadyToPlay = YES;
    windChimesSoundsReadyToPlay = YES;
    startingSequenceBegan = NO;
    //  player1ExperiencePointsToAdd = 0;
    player1GertyShouldBeDead = NO;
    player2GertyShouldBeDead = NO;
    computerNumberOfChargingRounds = 0;
    player1SlingIsSmoking = NO;
    player2SlingIsSmoking = NO;
    computerSettingNewVelocityandMovingBomb = NO;
    player1GiantSmokeCloudFrontOpacityIsIncreasing = YES;
    player2GiantSmokeCloudFrontOpacityIsIncreasing = YES;
    player1GiantSmokeCloudFrontOpacity = 0;
    player1GiantSmokeCloudBackOpacity = 0;
    player2GiantSmokeCloudFrontOpacity = 0;
    player2GiantSmokeCloudBackOpacity = 0;
    player1ProjectileIsZappable = YES;
    player2ProjectileIsZappable = YES;
    isGo = NO;
    waitingForStartup = YES;
    gamePaused = NO;
    guideLineIsBlinking = NO;
    bombHasHitRectangleHenceNoBonus1 = NO;
    bombHasHitRectangleHenceNoBonus2 = NO;
    skillLevelBonus = 0;
    chargedShotTimeEnded = 0;
    chargedShotTimeStarted = 0;
    player1Winner = NO;
    player2Winner = NO;
    player1ProjectileHasBeenTouched = NO;
    player2ProjectileHasBeenTouched = NO;
    firstPlayer1MarbleSetToGreen = NO;
    firstPlayer2MarbleSetToGreen = NO;
    player1BombZapped = NO;
    player2BombZapped = NO;
    fieldZoomedOut = YES;
    player1BombIsAirborne = NO;
    player2BombIsAirborne = NO;
    readyToReceiveBlocksPositionsFromPlayer1 = NO;
    readyToReceiveBlockNumbersFromPlayer2 = NO;
    readyForEnemyToFire = NO;
    readyForEnemyToBlock = NO;
    blockingChargeBonusPlayer1 = 0;
    blockingChargeBonusPlayer2 = 0;
    projectileChargingPitchPlayer1 = 0;
    projectileChargingPitchPlayer2 = 0;
    receivingChargingDataFromPlayer1 = NO;
    receivingChargingDataFromPlayer2 = NO;
    
    player1HasGreenBall = NO;
    player1HasRedBall = NO;
    player1HasBlueBall = NO;
    player1HasYellowBall = NO;
    player1HasBlackBall = NO;
    player2HasGreenBall = NO;
    player2HasRedBall = NO;
    player2HasBlueBall = NO;
    player2HasYellowBall = NO;
    player2HasBlackBall = NO;
    
    winnerLabel.visible = NO;
    lostLabel.visible = NO;
    
    [zoombase removeAllChildrenWithCleanup: YES];
    
    //Choose a random stage if 'Random Stage Select is YES' or if stage == 0 for some technical reason
    if (checkMarkSpeechBubbleStageSelectIsOnRandomButton || stage == 0) {
        
        checkMarkSpeechBubbleStageSelectIsOnRandomButton = YES;
        int randomLevelRoll = arc4random()%2;
        
        if (randomLevelRoll == 0) {
            
            stage = DAY_TIME_SUBURB;
        }
        
        else if (randomLevelRoll == 1) {
            
            stage = NIGHT_TIME_SUBURB;
        }
    }
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.1], [CCCallFunc actionWithTarget:self selector:@selector(setupMarblesAndBlocks)], nil]];
    
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.0], [CCCallFunc actionWithTarget:self selector:@selector(startSpaceManagerAndTimeStep)], nil]];
}

-(void) setIsAtMainMenuToNo
{
    isAtMainMenu = NO;
}

-(void) moveMainMenuLayerDown
{
    [mainMenuLayer runAction: [CCMoveTo actionWithDuration: 0.0 position:ccp(0, -525)]];
    carpet.visible = NO;
}

-(void) makeNavigationButtonsInvisible
{
    backToMainMenu.visible = NO;
    backToMainMenu2.visible = NO;
    continuePlayingGame.visible = NO;
    restartLevel.visible = NO;
    playButton.visible = NO;
    
    firstMatchWithThisPlayer = NO;
}

-(void) setSpeechBubbleVisibleToYes
{
    speechBubble.visible = YES;
}

-(void) setSpeechBubbleColorSwatchesVisibleToYes
{
    speechBubbleColorSwatches.visible = YES;
}

-(void) setSpeechBubbleMarbleListVisibleToYes
{
    speechBubbleMarbleList.visible = YES;
}

-(void) setSpeechBubbleStageSelectVisibleToYes
{
    speechBubbleStageSelect.visible = YES;
}

-(void) setSpeechBubbleVisibleToNo
{
    speechBubble.visible = NO;
}

-(void) setSpeechBubbleColorSwatchesVisibleToNo
{
    speechBubbleColorSwatches.visible = NO;
}

-(void) setSpeechBubbleMarbleListVisibleToNo
{
    speechBubbleMarbleList.visible = NO;
}

-(void) setSpeechBubbleStageSelectVisibleToNo
{
    speechBubbleStageSelect.visible = NO;
}

-(void) cleanupMultiplayerVersusScreenSprites
{
    [tamagachiMultiplayer removeFromParentAndCleanup: YES];
    [tamagachi2Multiplayer removeFromParentAndCleanup: YES];
}

-(void) stopTimeOutTime
{
    [self stopAction: timeOutTime];
}

-(void) backToMainMenu
{
    //When backToMainMenu is called set handicapCheckMarkButtons back to zero and set the corresponding handicap values to zero
    [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.0 position:firstPlayerHandicapLeftBorder.position]];
    [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.0 position:secondPlayerHandicapLeftBorder.position]];
    handicapCoefficientPlayer1 = 1.0;
    handicapCoefficientPlayer2 = 1.0;
    
    if (showAds == YES) {
        
        //[adWhirlView doNotIgnoreNewAdRequests];
        //[adWhirlView requestFreshAd];
    }
    
    whiteProgressDot1.visible = NO;
    whiteProgressDot2.visible = NO;
    whiteProgressDot3.visible = NO;
    whiteProgressDot4.visible = NO;
    whiteProgressDot5.visible = NO;
    
    inGameCountdownStarted = NO;
    
    tamagachiColorReceivedFromPlayer1 = NO;
    tamagachiColorReceivedFromPlayer1 = NO;
    
    carpet.visible = YES;
    
    playbuttonPushed = NO;
    
    player1ReadyToStartInGameCountdown = NO;
    player2ReadyToStartInGameCountdown = NO;
    
    firstMatchWithThisPlayer = YES;
    opponentDisconnectedLabel.visible = NO;
    
    lostLabel.visible = NO;
    
    [tamagachiMainMenu removeFromParentAndCleanup: YES];
    [self gertyMainMenu];
    
    [self updateLocksOverColorSwatchesAndMarbleList];
    [self stopAllActions];
    
    isAtMainMenu = YES;
    
    woodBlockTouched = NO;
    woodBlock2Touched = NO;
    woodBlock3Touched = NO;
    
    if (playersCanTouchMarblesNow == YES) {
        
        [self pauseGame];
    }
    
    [birdsBackgroundSounds stopBackgroundMusic];
    
    [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber22 sourceGroupId:0 pitch:1.0f pan:0.5 gain:1.9 loop:NO];
    
    //Move linedPaper all the way up then all the way down revealing mainMenu layer.  Destroy children of zoombase
    
    mainMenuMusic.backgroundMusicVolume = 0.5f;
    
    [mainMenuMusic playBackgroundMusic:@"YoungAtHeartMusic.mp3" loop:YES];
    
    if (isSinglePlayer == YES) {
        
        //Make playButton invisible
        //tamagachi2.visible = NO;
        //computerLabel.visible = NO;
        playButton.visible = NO;
        
        [youLabel removeFromParentAndCleanup: YES];
        [tamagachi removeFromParentAndCleanup: YES];
        
        [computerLabel removeFromParentAndCleanup: YES];
        [tamagachi2 removeFromParentAndCleanup: YES];
        
        //Clear zoombase of all children
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.4],  [CCCallFunc actionWithTarget:self selector:@selector(makeNavigationButtonsInvisible)],[CCCallFunc actionWithTarget:self selector:@selector(resetAllVariables)], nil]];
    }
    
    //Move linedPaper all the way up
    [linedPaper runAction: [CCMoveTo actionWithDuration:0.4 position:ccp(0,0)]];
    
    //Move hudLayer down ove 0.6 seconds
    [hudLayer runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.0], [CCMoveTo actionWithDuration:0.6 position:ccp(0, -460)], nil]];
    
    //Move mainMenuLayer up
    [mainMenuLayer runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.4], [CCMoveTo actionWithDuration:0.0 position:ccp(0,0)], nil]];
    
    NSLog (@"backToMainMenu pushed");
    
    if (!isSinglePlayer) {
        
        [self sendOtherPlayerHasLeftMatchFromVersusScreen];
        
        [player1Label removeFromParentAndCleanup: YES];
        [player2Label removeFromParentAndCleanup: YES];
        [self cleanupMultiplayerVersusScreenSprites];
        
        backToMainMenu.visible = NO;
        playButton.visible = NO;
        
        //  [linedPaper removeAllChildrenWithCleanup: YES];
        
        [self matchEnded];
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.0], [CCCallFunc actionWithTarget:self selector:@selector(resetAllVariables)], nil]];
        
        NSLog(@"backtoMainMenu cleanup stuff");
        
        pauseButton.visible = NO;
        //      tamagachiMultiplayer.visible = NO;
        //      tamagachi2Multiplayer.visible = NO;
        //      computerLabel.visible = NO;
        //      youLabel.visible = NO;
        backToMainMenu.visible = NO;
        //      player1Label.visible = NO;
        //      player2Label.visible = NO;
    }
    
    isSinglePlayer = YES;
    
    microphoneOn.visible = NO;
    microphoneOff.visible = NO;
}

- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    NSString *productIdentifier = (NSString *) notification.object;
    NSLog(@"Purchased: %@", productIdentifier);
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
    if (transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Error!"
                                                         message:transaction.error.localizedDescription
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] autorelease];
        
        [alert show];
    }
}

-(void) setTeslaPositionsToSlingBombPositions
{
    tesla.position = SLING_BOMB_POSITION;
    tesla2.position = SLING_BOMB_POSITION_2;
}

-(void) buyButton1Dark
{
    buyButton1.color = ccBLACK;
}

-(void) buyButton1Normal
{
    buyButton1.color = ccWHITE;
}

-(void) buyButton2Dark
{
    buyButton2.color = ccBLACK;
}

-(void) buyButton2Normal
{
    buyButton2.color = ccWHITE;
}

-(void) buyButton3Dark
{
    buyButton3.color = ccBLACK;
}

-(void) buyButton3Normal
{
    buyButton3.color = ccWHITE;
}

-(void) buyButton1ClickedAnimation
{
    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(buyButton1Dark)], [CCDelayTime actionWithDuration:0.2], [CCCallFunc actionWithTarget:self selector:@selector(buyButton1Normal)], nil]];
}

-(void) buyButton2ClickedAnimation
{
    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(buyButton2Dark)], [CCDelayTime actionWithDuration:0.2], [CCCallFunc actionWithTarget:self selector:@selector(buyButton2Normal)], nil]];
}

-(void) buyButton3ClickedAnimation
{
    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(buyButton3Dark)], [CCDelayTime actionWithDuration:0.2], [CCCallFunc actionWithTarget:self selector:@selector(buyButton3Normal)], nil]];
}


-(void) stageDayTimeButtonDark
{
    dayTimeStageButton.color = ccBLACK;
}

-(void) stageDayTimeButtonNormal
{
    dayTimeStageButton.color = ccWHITE;
}

-(void) stageNightTimeButtonDark
{
    nightTimeStageButton.color = ccBLACK;
}

-(void) stageNightTimeButtonNormal
{
    nightTimeStageButton.color = ccWHITE;
}

-(void) stageRandomButtonDark
{
    randomStageSelectButton.color = ccBLACK;
}

-(void) stageRandomButtonNormal
{
    randomStageSelectButton.color = ccWHITE;
}

-(void) stageDayTimeButtonClickedAnimation
{
    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(stageDayTimeButtonDark)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(stageDayTimeButtonNormal)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(stageDayTimeButtonDark)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(stageDayTimeButtonNormal)], nil]];
}

-(void) stageNightTimeButtonClickedAnimation
{
    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(stageNightTimeButtonDark)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(stageNightTimeButtonNormal)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(stageNightTimeButtonDark)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(stageNightTimeButtonNormal)], nil]];
}

-(void) stageRandomButtonClickedAnimation
{
    [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(stageRandomButtonDark)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(stageRandomButtonNormal)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(stageRandomButtonDark)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(stageRandomButtonNormal)], nil]];
}

-(void) playSlotDoneAudio
{
    [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber27 sourceGroupId:0 pitch:1.0f pan:0.2 gain:0.05 loop:NO];
}

-(void) playSlotDoneAudioPlayer2
{
    [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber29 sourceGroupId:0 pitch:1.0f pan:0.8 gain:0.05 loop:NO];
}

-(void) mainMenuTamagachiLightsAllTurnOff
{
    ledLight1MainMenu.color = ccGREEN;
    ledLight2MainMenu.color = ccc3(30, 144, 255);
    ledLight3MainMenu.color = ccRED;
    ledLight4MainMenu.color = ccGRAY;
    ledLight5MainMenu.color = ccc3(250 , 250, 170);
    
    ledLight1MainMenu.opacity = 0;
    ledLight2MainMenu.opacity = 0;
    ledLight3MainMenu.opacity = 0;
    ledLight4MainMenu.opacity = 0;
    ledLight5MainMenu.opacity = 0;
}

-(void) mainMenuTamagachiLightsAllTurnOn
{
    ledLight1MainMenu.color = ccGREEN;
    ledLight2MainMenu.color = ccc3(30, 144, 255);
    ledLight3MainMenu.color = ccRED;
    ledLight4MainMenu.color = ccGRAY;
    ledLight5MainMenu.color = ccc3(250 , 250, 170);
    
    ledLight1MainMenu.opacity = 255;
    ledLight2MainMenu.opacity = 255;
    ledLight3MainMenu.opacity = 255;
    ledLight4MainMenu.opacity = 255;
    ledLight5MainMenu.opacity = 255;
}

-(void) mainMenuTamagachiLightsTurnOnOnlyUnlockedMarbleLights
{
    if (player1MarblesUnlocked == 0) {
        
        ledBulb1MainMenu.color = ccGREEN;
        ledBulb2MainMenu.color = ccc3(255, 192, 203);
        ledBulb3MainMenu.color = ccc3(255, 192, 203);
        ledBulb4MainMenu.color = ccc3(255, 192, 203);
        ledBulb5MainMenu.color = ccc3(255, 192, 203);
        
        
        ledLight2MainMenu.opacity = 0;
        ledLight3MainMenu.opacity = 0;
        ledLight4MainMenu.opacity = 0;
        ledLight5MainMenu.opacity = 0;
    }
    
    else if (player1MarblesUnlocked == 1) {
        
        ledBulb1MainMenu.color = ccGREEN;
        ledBulb2MainMenu.color = ccc3(30, 144, 255);
        ledBulb3MainMenu.color = ccc3(255, 192, 203);
        ledBulb4MainMenu.color = ccc3(255, 192, 203);
        ledBulb5MainMenu.color = ccc3(255, 192, 203);
        
        ledLight2MainMenu.opacity = 255;
        ledLight3MainMenu.opacity = 0;
        ledLight4MainMenu.opacity = 0;
        ledLight5MainMenu.opacity = 0;
    }
    
    else if (player1MarblesUnlocked == 2) {
        
        ledBulb1MainMenu.color = ccGREEN;
        ledBulb2MainMenu.color = ccc3(30, 144, 255);
        ledBulb3MainMenu.color = ccRED;
        ledBulb4MainMenu.color = ccc3(255, 192, 203);
        ledBulb5MainMenu.color = ccc3(255, 192, 203);
        
        ledLight2MainMenu.opacity = 255;
        ledLight3MainMenu.opacity = 255;
        ledLight4MainMenu.opacity = 0;
        ledLight5MainMenu.opacity = 0;
    }
    
    else if (player1MarblesUnlocked == 3) {
        
        ledBulb1MainMenu.color = ccGREEN;
        ledBulb2MainMenu.color = ccc3(30, 144, 255);
        ledBulb3MainMenu.color = ccRED;
        ledBulb4MainMenu.color = ccGRAY;
        ledBulb5MainMenu.color = ccc3(255, 192, 203);
        
        ledLight2MainMenu.opacity = 255;
        ledLight3MainMenu.opacity = 255;
        ledLight4MainMenu.opacity = 255;
        ledLight5MainMenu.opacity = 0;
    }
    
    else if (player1MarblesUnlocked >= 4) {
        
        ledBulb1MainMenu.color = ccGREEN;
        ledBulb2MainMenu.color = ccc3(30, 144, 255);
        ledBulb3MainMenu.color = ccRED;
        ledBulb4MainMenu.color = ccGRAY;
        ledBulb5MainMenu.color = ccc3(250 , 250, 170);
        
        ledLight2MainMenu.opacity = 255;
        ledLight3MainMenu.opacity = 255;
        ledLight4MainMenu.opacity = 255;
        ledLight5MainMenu.opacity = 255;
    }
}

-(void) mainMenuTamagachiGertyNotVisible
{
    happyGerty.visible = NO;
    sadGerty.visible = NO;
    uncertainGerty.visible = NO;
    cryingGerty.visible = NO;
}

-(void) mainMenuTamagachiGertyVisible
{
    happyGerty.visible = YES;
    sadGerty.visible = NO;
    uncertainGerty.visible = NO;
    cryingGerty.visible = NO;
}

-(void) setAllSpeechBubblesChildSpritesToNotVisible
{
    checkMarkSpeechBubbleStageSelect.visible = NO;
    dayTimeStageButton.visible = NO;
    nightTimeStageButton.visible = NO;
    randomStageSelectButton.visible = NO;
    redColorSwatch.visible = NO;
    pinkColorSwatch.visible = NO;
    greenColorSwatch.visible = NO;
    yellowColorSwatch.visible = NO;
    orangeColorSwatch.visible = NO;
    purpleColorSwatch.visible = NO;
    lightPurpleColorSwatch.visible = NO;
    blueColorSwatch.visible = NO;
    whiteColorSwatch.visible = NO;
    blackColorSwatch.visible = NO;
    blueMarbleForSpeechBubble.visible = NO;
    redMarbleForSpeechBubble.visible = NO;
    blackMarbleForSpeechBubble.visible = NO;
    yellowMarbleForSpeechBubble.visible = NO;
    z200Label.visible = NO;
    z500Label.visible = NO;
    z1000Label.visible = NO;
    z2000Label.visible = NO;
    z200LabelForMarble.visible = NO;
    z300LabelForMarble.visible = NO;
    z400LabelForMarble.visible = NO;
    z500LabelForMarble.visible = NO;
}

-(void) setAllSpeechBubblesChildSpritesToVisible
{
    checkMarkSpeechBubbleStageSelect.visible = YES;
    dayTimeStageButton.visible = YES;
    nightTimeStageButton.visible = YES;
    randomStageSelectButton.visible = YES;
    redColorSwatch.visible = YES;
    pinkColorSwatch.visible = YES;
    greenColorSwatch.visible = YES;
    yellowColorSwatch.visible = YES;
    orangeColorSwatch.visible = YES;
    purpleColorSwatch.visible = YES;
    lightPurpleColorSwatch.visible = YES;
    blueColorSwatch.visible = YES;
    whiteColorSwatch.visible = YES;
    blackColorSwatch.visible = YES;
    blueMarbleForSpeechBubble.visible = YES;
    redMarbleForSpeechBubble.visible = YES;
    blackMarbleForSpeechBubble.visible = YES;
    yellowMarbleForSpeechBubble.visible = YES;
    z200Label.visible = YES;
    z500Label.visible = YES;
    z1000Label.visible = YES;
    z2000Label.visible = YES;
    z200LabelForMarble.visible = YES;
    z300LabelForMarble.visible = YES;
    z400LabelForMarble.visible = YES;
    z500LabelForMarble.visible = YES;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    touchLocation = [zoombase convertTouchToNodeSpace:touch];
    touchLocationHudLayer = [hudLayer convertTouchToNodeSpace:touch];
    CGPoint linedPaperTouchLocation = [linedPaper convertTouchToNodeSpace:touch];
    CGPoint touchLocationCarpet = [carpet convertTouchToNodeSpace:touch];
    CGPoint touchLocationTamagachi = [tamagachiMainMenu convertTouchToNodeSpace:touch];
    CGPoint speechBubbleTouchLocation = [speechBubble convertTouchToNodeSpace:touch];
    CGPoint speechBubbleColorSwatchesTouchLocation = [speechBubbleColorSwatches convertTouchToNodeSpace:touch];
    CGPoint speechBubbleMarbleListTouchLocation = [speechBubbleMarbleList convertTouchToNodeSpace:touch];
    CGPoint speechBubbleStageSelectTouchLocation = [speechBubbleStageSelect convertTouchToNodeSpace:touch];
    CGPoint mainMenuTouchLocation = [mainMenuLayer convertTouchToNodeSpace:touch];
    
    
    //Move first player handicap
    if (isPlayer1 && CGRectContainsPoint(firstPlayerHandicapCheckMarkButton.boundingBox, linedPaperTouchLocation) && firstPlayerHandicapCheckMarkButton.visible) {
        
        firstPlayerHandicapCheckMarkButtonTouched = YES;
        [firstPlayerHandicapCheckMarkButton runAction: [CCScaleTo actionWithDuration:0.35 scale:0.5]];
    }
    
    //If player1 touches any part of the firstPlayerHandicapGuideline then have checkmark jump to that point
    if (isPlayer1 && CGRectContainsPoint(firstPlayerHandicapGuideLine.boundingBox, linedPaperTouchLocation)) {
        
        if ((linedPaperTouchLocation.x >= firstPlayerHandicapLeftBorder.position.x + handicapLinesSpacing) && (linedPaperTouchLocation.x <= firstPlayerHandicapRightBorder.position.x + handicapLinesSpacing)) {
            
            firstPlayerHandicapCheckMarkButtonTouched = YES;
            [firstPlayerHandicapCheckMarkButton runAction: [CCScaleTo actionWithDuration:0.0 scale:0.5]];
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(linedPaperTouchLocation.x, firstPlayerHandicapGuideLine.position.y)]];
        }
    }
    
    //If player2 touches any part of the secondPlayerHandicapGuideline then have checkmark jump to that point
    if (!isPlayer1 && CGRectContainsPoint(secondPlayerHandicapGuideLine.boundingBox, linedPaperTouchLocation)) {
        
        if ((linedPaperTouchLocation.x >= secondPlayerHandicapLeftBorder.position.x + handicapLinesSpacing) && (linedPaperTouchLocation.x <= secondPlayerHandicapRightBorder.position.x + handicapLinesSpacing)) {
            
            secondPlayerHandicapCheckMarkButtonTouched = YES;
            [secondPlayerHandicapCheckMarkButton runAction: [CCScaleTo actionWithDuration:0.0 scale:0.5]];
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(linedPaperTouchLocation.x, secondPlayerHandicapCheckMarkButton.position.y)]];
        }
    }
    
    //Move second player handicap
    if (!isPlayer1 && CGRectContainsPoint(secondPlayerHandicapCheckMarkButton.boundingBox, linedPaperTouchLocation) && secondPlayerHandicapCheckMarkButton.visible) {
        
        secondPlayerHandicapCheckMarkButtonTouched = YES;
        [secondPlayerHandicapCheckMarkButton runAction: [CCScaleTo actionWithDuration:0.35 scale:0.5]];
    }
    
    //Test object children sounds here
    if (isGo == YES) {
        //CCSprite *sprite = (RectangleShape*)rectangleShape.shape->data;
        
        //CDXAudioNode *audioIceBlockBeingDestroyed = [[sprite children] objectAtIndex:0];
        //[audioIceBlockBeingDestroyed plflameay];
        
        //[(RectangleShape*)rectangleShape.shape->data icyBlock];
    }
    
    if (isGo == NO) {
        
        [self updateTamagachiMainMenuColor];
        
        [self updateLocksOverColorSwatchesAndMarbleList];
        
        if (showAds == YES) {
            
            //    adWhirlView.hidden = NO;
        }
        
        else if (showAds == NO) {
            
            //    adWhirlView.hidden = YES;
        }
    }
    
    if (CGRectContainsPoint(microphoneOn.boundingBox, touchLocationHudLayer) && !isSinglePlayer) {
        
        if (microphoneOn.visible == YES) {
            
            microphoneOff.visible = YES;
            microphoneOn.visible = NO;
            
            [teamChannel setMute: YES forPlayer: otherPlayerID];
        }
        
        else if (microphoneOn.visible == NO) {
            
            microphoneOn.visible = YES;
            microphoneOff.visible = NO;
            
            [teamChannel setMute: NO forPlayer: otherPlayerID];
        }
    }
    
    if (isAtMainMenu == YES) {
        
        if (CGRectContainsPoint(whiteTabStickerForSpeechBubbleColorSwatches.boundingBox, speechBubbleColorSwatchesTouchLocation)) {
            
            //Detect if touch is on white tab for Color Swatch Speech Bubble
            [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setColorsSpeechBubbleToFront)]];
        }
        
        else if (CGRectContainsPoint(whiteTabStickerForSpeechBubbleMarbleList.boundingBox, speechBubbleMarbleListTouchLocation)) {
            
            
            //Detect if touch is on white tab for Marble List Speech Bubble
            [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setMarblesSpeechBubbleToFront)]];
        }
        
        else if (CGRectContainsPoint(whiteTabStickerForSpeechBubbleStageSelect.boundingBox, speechBubbleStageSelectTouchLocation)) {
            
            //Detect if touch is on white tab for Stage Select Speech Bubble
            [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setStagesSpeechBubbleToFront)]];
        }
        
        else if (speechBubbleStageSelect.visible == YES && speechBubbleStageSelectIsTopLayer) {
            
            if (CGRectContainsPoint(dayTimeStageButton.boundingBox, speechBubbleStageSelectTouchLocation) && speechBubbleWillShow == YES) {
                
                [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber22 sourceGroupId:0 pitch:1.0f pan:0.5 gain:1.9 loop:NO];
                
                [self stageDayTimeButtonClickedAnimation];
                
                checkMarkSpeechBubbleStageSelectIsOnRandomButton = NO;
                stage = DAY_TIME_SUBURB;
                
                checkMarkSpeechBubbleStageSelect.position = dayTimeStageButton.position;
                
                speechBubbleWillShow = NO;
                
                //Fade out all child sprites of the stageSelect Speech Bubble
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)], nil]];
                
                //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                [speechBubbleStageSelect runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.7], [CCFadeOut actionWithDuration: 0.3], nil]];
                [speechBubbleColorSwatches runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.7], [CCFadeOut actionWithDuration: 0.3], nil]];
                [speechBubbleMarbleList runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.7], [CCFadeOut actionWithDuration: 0.3], nil]];
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                
                [carpet runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.7], [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)], nil]];
                
                [self saveGameSettings];
            }
            
            else if (CGRectContainsPoint(nightTimeStageButton.boundingBox, speechBubbleStageSelectTouchLocation) && speechBubbleWillShow == YES) {
                
                [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber22 sourceGroupId:0 pitch:1.0f pan:0.5 gain:1.9 loop:NO];
                
                [self stageNightTimeButtonClickedAnimation];
                
                checkMarkSpeechBubbleStageSelectIsOnRandomButton = NO;
                stage = NIGHT_TIME_SUBURB;
                
                checkMarkSpeechBubbleStageSelect.position = nightTimeStageButton.position;
                
                speechBubbleWillShow = NO;
                
                //Fade out all child sprites of the stageSelect Speech Bubble
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)], nil]];
                
                //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                [speechBubbleStageSelect runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.7], [CCFadeOut actionWithDuration: 0.3], nil]];
                [speechBubbleColorSwatches runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.7], [CCFadeOut actionWithDuration: 0.3], nil]];
                [speechBubbleMarbleList runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.7], [CCFadeOut actionWithDuration: 0.3], nil]];
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                
                [carpet runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.7], [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)], nil]];
                
                [self saveGameSettings];
            }
            
            else if (CGRectContainsPoint(randomStageSelectButton.boundingBox, speechBubbleStageSelectTouchLocation) && speechBubbleWillShow == YES) {
                
                [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber22 sourceGroupId:0 pitch:1.0f pan:0.5 gain:1.9 loop:NO];
                
                [self stageRandomButtonClickedAnimation];
                
                checkMarkSpeechBubbleStageSelectIsOnRandomButton = YES;
                stage = RANDOM_STAGE;
                
                checkMarkSpeechBubbleStageSelect.position = randomStageSelectButton.position;
                
                speechBubbleWillShow = NO;
                
                //Fade out all child sprites of the stageSelect Speech Bubble
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)], nil]];
                
                //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                [speechBubbleStageSelect runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.7], [CCFadeOut actionWithDuration: 0.3], nil]];
                [speechBubbleColorSwatches runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.7], [CCFadeOut actionWithDuration: 0.3], nil]];
                [speechBubbleMarbleList runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.7], [CCFadeOut actionWithDuration: 0.3], nil]];
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                
                [carpet runAction: [CCSequence actions: [CCDelayTime actionWithDuration:0.7], [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)], nil]];
                
                [self saveGameSettings];
            }
            
            else if (speechBubbleStageSelect.visible == YES && speechBubbleStageSelectIsTopLayer && !(CGRectContainsPoint(whiteTabStickerForSpeechBubbleStageSelect.boundingBox, speechBubbleStageSelectTouchLocation)) && CGRectContainsPoint(speechBubbleStageSelect.boundingBox, touchLocationTamagachi) && !(CGRectContainsPoint(dayTimeStageButton.boundingBox, speechBubbleStageSelectTouchLocation)) && !(CGRectContainsPoint(nightTimeStageButton.boundingBox, speechBubbleStageSelectTouchLocation)) && !(CGRectContainsPoint(randomStageSelectButton.boundingBox, speechBubbleStageSelectTouchLocation)) && speechBubbleWillShow == YES) {
                
                NSLog (@"SpeechBubbleStageSelect touched!");
                
                speechBubbleWillShow = NO;
                
                //Fade out all child sprites of the stageSelect Speech Bubble
                [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)]];
                
                
                //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                [speechBubbleStageSelect runAction: [CCFadeOut actionWithDuration: 0.3]];
                [speechBubbleColorSwatches runAction: [CCFadeOut actionWithDuration: 0.3]];
                [speechBubbleMarbleList runAction: [CCFadeOut actionWithDuration: 0.3]];
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                
                
                [carpet runAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)]];
            }
        }
        
        else if (speechBubble.visible == YES) {
            
            if (CGRectContainsPoint(buyButton1.boundingBox, speechBubbleTouchLocation) && buyButton1.visible == YES) {
                
                [self buyButton1ClickedAnimation];
                
                [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber22 sourceGroupId:0 pitch:1.0f pan:0.5 gain:1.9 loop:NO];
                
                //[[SimpleAudioEngine sharedEngine] playEffect:@"MouseClick.wav"];
                
                SKProduct *product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:0];
                
                NSLog(@"Buying %@...", product.productIdentifier);
                [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
                
                [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
                NSLog (@"buyButton1 pushed!");
            }
            
            else if (CGRectContainsPoint(buyButton2.boundingBox, speechBubbleTouchLocation) && buyButton2.visible == YES) {
                
                [self buyButton2ClickedAnimation];
                
                [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber22 sourceGroupId:0 pitch:1.0f pan:0.5 gain:1.9 loop:NO];
                
                //  [[SimpleAudioEngine sharedEngine] playEffect:@"MouseClick.wav"];
                
                SKProduct *product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:1];
                
                NSLog(@"Buying %@...", product.productIdentifier);
                [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
                
                [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
                NSLog (@"buyButton2 pushed!");
            }
            
            else if (CGRectContainsPoint(buyButton3.boundingBox, speechBubbleTouchLocation) && buyButton3.visible == YES) {
                
                [self buyButton3ClickedAnimation];
                
                [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber22 sourceGroupId:0 pitch:1.0f pan:0.5 gain:1.9 loop:NO];
                
                // [[SimpleAudioEngine sharedEngine] playEffect:@"MouseClick.wav"];
                
                SKProduct *product = [[InAppRageIAPHelper sharedHelper].products objectAtIndex:2];
                
                NSLog(@"Buying %@...", product.productIdentifier);
                [[InAppRageIAPHelper sharedHelper] buyProductIdentifier:product.productIdentifier];
                
                [self performSelector:@selector(timeout:) withObject:nil afterDelay:60*5];
                NSLog (@"buyButton2 pushed!");
            }
            
            else if (CGRectContainsPoint(speechBubble.boundingBox, touchLocationTamagachi) && speechBubble.visible && speechBubbleWillShow == YES) {
                
                if (showAds == NO) {
                    
                    //adWhirlView.hidden = YES;
                    //[adWhirlView ignoreNewAdRequests];
                }
                
                speechBubbleWillShow = NO;
                
                [speechBubble runAction: [CCFadeOut actionWithDuration: 0.3]];
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleVisibleToNo)], nil]];
                
                [carpet runAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)]];
                
                NSLog (@"Speech bubble touched");
            }
        }
        
        else if (speechBubbleColorSwatches.visible == YES && speechBubbleColorSwatchIsTopLayer && !(CGRectContainsPoint(whiteTabStickerForSpeechBubbleColorSwatches.boundingBox, speechBubbleColorSwatchesTouchLocation) && speechBubbleWillShow == YES)) {
            
            if (CGRectContainsPoint(redColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation) && speechBubbleWillShow == YES) {
                
                NSLog (@"Red button touched!");
                
                speechBubbleWillShow = NO;
                
                tamagachi1Color = TAMAGACHI_1_RED;
                
                // [self saveGameSettings];
                
                tamagachiMainMenu.opacity = 255;
                pinkTamagachiMainMenu.opacity = 0;
                greenTamagachiMainMenu.opacity = 0.0;
                yellowTamagachiMainMenu.opacity = 0.0;
                orangeTamagachiMainMenu.opacity = 0.0;
                lightPurpleTamagachiMainMenu.opacity = 0.0;
                purpleTamagachiMainMenu.opacity = 0.0;
                blueTamagachiMainMenu.opacity = 0.0;
                whiteTamagachiMainMenu.opacity = 0.0;
                blackTamagachiMainMenu.opacity = 0.0;
                
                //Fade out all child sprites of the stageSelect Speech Bubble
                [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)]];
                
                //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                [speechBubbleStageSelect runAction: [CCFadeOut actionWithDuration: 0.3]];
                [speechBubbleColorSwatches runAction: [CCFadeOut actionWithDuration: 0.3]];
                [speechBubbleMarbleList runAction: [CCFadeOut actionWithDuration: 0.3]];
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                
                [carpet runAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)]];
            }
            
            else if (CGRectContainsPoint(pinkColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation) && speechBubbleWillShow == YES) {
                
                NSLog (@"Pink button touched!");
                
                if (player1Level >= 200) {
                    
                    speechBubbleWillShow = NO;
                    
                    tamagachi1Color = TAMAGACHI_1_PINK;
                    
                    //  [self saveGameSettings];
                    
                    tamagachiMainMenu.opacity = 0;
                    pinkTamagachiMainMenu.opacity = 255;
                    greenTamagachiMainMenu.opacity = 0.0;
                    yellowTamagachiMainMenu.opacity = 0.0;
                    orangeTamagachiMainMenu.opacity = 0.0;
                    lightPurpleTamagachiMainMenu.opacity = 0.0;
                    purpleTamagachiMainMenu.opacity = 0.0;
                    blueTamagachiMainMenu.opacity = 0.0;
                    whiteTamagachiMainMenu.opacity = 0.0;
                    blackTamagachiMainMenu.opacity = 0.0;
                    
                    //Fade out all child sprites of the stageSelect Speech Bubble
                    [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)]];
                    
                    //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                    [speechBubbleStageSelect runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleColorSwatches runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleMarbleList runAction: [CCFadeOut actionWithDuration: 0.3]];
                    
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                    
                    [carpet runAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)]];
                }
                
                else {
                    
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Buzzer.wav"];
                }
            }
            
            else if (CGRectContainsPoint(greenColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation) && speechBubbleWillShow == YES) {
                
                if (player1Level >= 500) {
                    
                    speechBubbleWillShow = NO;
                    
                    tamagachi1Color = TAMAGACHI_1_GREEN;
                    
                    // [self saveGameSettings];
                    
                    tamagachiMainMenu.opacity = 0;
                    pinkTamagachiMainMenu.opacity = 0;
                    greenTamagachiMainMenu.opacity = 255;
                    yellowTamagachiMainMenu.opacity = 0.0;
                    orangeTamagachiMainMenu.opacity = 0.0;
                    lightPurpleTamagachiMainMenu.opacity = 0.0;
                    purpleTamagachiMainMenu.opacity = 0.0;
                    blueTamagachiMainMenu.opacity = 0.0;
                    whiteTamagachiMainMenu.opacity = 0.0;
                    blackTamagachiMainMenu.opacity = 0.0;
                    
                    //Fade out all child sprites of the stageSelect Speech Bubble
                    [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)]];
                    
                    //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                    [speechBubbleStageSelect runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleColorSwatches runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleMarbleList runAction: [CCFadeOut actionWithDuration: 0.3]];
                    
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                    
                    [carpet runAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)]];
                }
                
                else {
                    
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Buzzer.wav"];
                }
                
                
            }
            
            else if (CGRectContainsPoint(yellowColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation) && speechBubbleWillShow == YES) {
                
                if (player1Level >= 500) {
                    
                    speechBubbleWillShow = NO;
                    
                    tamagachi1Color = TAMAGACHI_1_YELLOW;
                    
                    //  [self saveGameSettings];
                    
                    tamagachiMainMenu.opacity = 0;
                    pinkTamagachiMainMenu.opacity = 0;
                    greenTamagachiMainMenu.opacity = 0;
                    yellowTamagachiMainMenu.opacity = 255;
                    orangeTamagachiMainMenu.opacity = 0.0;
                    lightPurpleTamagachiMainMenu.opacity = 0.0;
                    purpleTamagachiMainMenu.opacity = 0.0;
                    blueTamagachiMainMenu.opacity = 0.0;
                    whiteTamagachiMainMenu.opacity = 0.0;
                    blackTamagachiMainMenu.opacity = 0.0;
                    
                    //Fade out all child sprites of the stageSelect Speech Bubble
                    [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)]];
                    
                    //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                    [speechBubbleStageSelect runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleColorSwatches runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleMarbleList runAction: [CCFadeOut actionWithDuration: 0.3]];
                    
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                    
                    [carpet runAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)]];
                }
                
                else {
                    
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Buzzer.wav"];
                }
            }
            
            else if (CGRectContainsPoint(orangeColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation) && speechBubbleWillShow == YES) {
                
                if (player1Level >= 500) {
                    
                    speechBubbleWillShow = NO;
                    
                    tamagachi1Color = TAMAGACHI_1_ORANGE;
                    
                    //[self saveGameSettings];
                    
                    tamagachiMainMenu.opacity = 0;
                    pinkTamagachiMainMenu.opacity = 0;
                    greenTamagachiMainMenu.opacity = 0;
                    yellowTamagachiMainMenu.opacity = 0;
                    orangeTamagachiMainMenu.opacity = 255;
                    lightPurpleTamagachiMainMenu.opacity = 0.0;
                    purpleTamagachiMainMenu.opacity = 0.0;
                    blueTamagachiMainMenu.opacity = 0.0;
                    whiteTamagachiMainMenu.opacity = 0.0;
                    blackTamagachiMainMenu.opacity = 0.0;
                    
                    //Fade out all child sprites of the stageSelect Speech Bubble
                    [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)]];
                    
                    //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                    [speechBubbleStageSelect runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleColorSwatches runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleMarbleList runAction: [CCFadeOut actionWithDuration: 0.3]];
                    
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                    
                    [carpet runAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)]];
                }
                
                else {
                    
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Buzzer.wav"];
                }
            }
            
            else if (CGRectContainsPoint(lightPurpleColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation) && speechBubbleWillShow == YES) {
                
                if (player1Level >= 1000) {
                    
                    speechBubbleWillShow = NO;
                    
                    tamagachi1Color = TAMAGACHI_1_LIGHTPURPLE;
                    
                    //[self saveGameSettings];
                    
                    tamagachiMainMenu.opacity = 0;
                    pinkTamagachiMainMenu.opacity = 0;
                    greenTamagachiMainMenu.opacity = 0;
                    yellowTamagachiMainMenu.opacity = 0;
                    orangeTamagachiMainMenu.opacity = 0;
                    lightPurpleTamagachiMainMenu.opacity = 255;
                    purpleTamagachiMainMenu.opacity = 0.0;
                    blueTamagachiMainMenu.opacity = 0.0;
                    whiteTamagachiMainMenu.opacity = 0.0;
                    blackTamagachiMainMenu.opacity = 0.0;
                    
                    //Fade out all child sprites of the stageSelect Speech Bubble
                    [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)]];
                    
                    //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                    [speechBubbleStageSelect runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleColorSwatches runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleMarbleList runAction: [CCFadeOut actionWithDuration: 0.3]];
                    
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                    
                    [carpet runAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)]];
                }
                
                else {
                    
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Buzzer.wav"];
                }
            }
            
            else if (CGRectContainsPoint(purpleColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation) && speechBubbleWillShow == YES) {
                
                if (player1Level >= 1000) {
                    
                    speechBubbleWillShow = NO;
                    
                    tamagachi1Color = TAMAGACHI_1_PURPLE;
                    
                    //[self saveGameSettings];
                    
                    tamagachiMainMenu.opacity = 0;
                    pinkTamagachiMainMenu.opacity = 0;
                    greenTamagachiMainMenu.opacity = 0;
                    yellowTamagachiMainMenu.opacity = 0;
                    orangeTamagachiMainMenu.opacity = 0;
                    lightPurpleTamagachiMainMenu.opacity = 0;
                    purpleTamagachiMainMenu.opacity = 255;
                    blueTamagachiMainMenu.opacity = 0.0;
                    whiteTamagachiMainMenu.opacity = 0.0;
                    blackTamagachiMainMenu.opacity = 0.0;
                    
                    //Fade out all child sprites of the stageSelect Speech Bubble
                    [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)]];
                    
                    //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                    [speechBubbleStageSelect runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleColorSwatches runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleMarbleList runAction: [CCFadeOut actionWithDuration: 0.3]];
                    
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                    
                    [carpet runAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)]];
                }
                
                else {
                    
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Buzzer.wav"];
                }
            }
            
            else if (CGRectContainsPoint(blueColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation) && speechBubbleWillShow == YES) {
                
                if (player1Level >= 1000) {
                    
                    speechBubbleWillShow = NO;
                    
                    tamagachi1Color = TAMAGACHI_1_BLUE;
                    
                    // [self saveGameSettings];
                    
                    tamagachiMainMenu.opacity = 0;
                    pinkTamagachiMainMenu.opacity = 0;
                    greenTamagachiMainMenu.opacity = 0;
                    yellowTamagachiMainMenu.opacity = 0;
                    orangeTamagachiMainMenu.opacity = 0;
                    lightPurpleTamagachiMainMenu.opacity = 0;
                    purpleTamagachiMainMenu.opacity = 0;
                    blueTamagachiMainMenu.opacity = 255;
                    whiteTamagachiMainMenu.opacity = 0.0;
                    blackTamagachiMainMenu.opacity = 0.0;
                    
                    //Fade out all child sprites of the stageSelect Speech Bubble
                    [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)]];
                    
                    //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                    [speechBubbleStageSelect runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleColorSwatches runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleMarbleList runAction: [CCFadeOut actionWithDuration: 0.3]];
                    
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                    
                    [carpet runAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)]];
                }
                
                else {
                    
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Buzzer.wav"];
                }
            }
            
            else if (CGRectContainsPoint(whiteColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation) && speechBubbleWillShow == YES) {
                
                if (player1Level >= 2000) {
                    
                    speechBubbleWillShow = NO;
                    
                    tamagachi1Color = TAMAGACHI_1_WHITE;
                    
                    //[self saveGameSettings];
                    
                    tamagachiMainMenu.opacity = 0;
                    pinkTamagachiMainMenu.opacity = 0;
                    greenTamagachiMainMenu.opacity = 0;
                    yellowTamagachiMainMenu.opacity = 0;
                    orangeTamagachiMainMenu.opacity = 0;
                    lightPurpleTamagachiMainMenu.opacity = 0;
                    purpleTamagachiMainMenu.opacity = 0;
                    blueTamagachiMainMenu.opacity = 0;
                    whiteTamagachiMainMenu.opacity = 255;
                    blackTamagachiMainMenu.opacity = 0.0;
                    
                    //Fade out all child sprites of the stageSelect Speech Bubble
                    [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)]];
                    
                    //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                    [speechBubbleStageSelect runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleColorSwatches runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleMarbleList runAction: [CCFadeOut actionWithDuration: 0.3]];
                    
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                    
                    [carpet runAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)]];
                }
                
                else {
                    
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Buzzer.wav"];
                }
            }
            
            else if (CGRectContainsPoint(blackColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation) && speechBubbleWillShow == YES) {
                
                if (player1Level >= 2000) {
                    
                    speechBubbleWillShow = NO;
                    
                    tamagachi1Color = TAMAGACHI_1_BLACK;
                    
                    // [self saveGameSettings];
                    
                    tamagachiMainMenu.opacity = 0;
                    pinkTamagachiMainMenu.opacity = 0;
                    greenTamagachiMainMenu.opacity = 0;
                    yellowTamagachiMainMenu.opacity = 0;
                    orangeTamagachiMainMenu.opacity = 0;
                    lightPurpleTamagachiMainMenu.opacity = 0;
                    purpleTamagachiMainMenu.opacity = 0;
                    blueTamagachiMainMenu.opacity = 0;
                    whiteTamagachiMainMenu.opacity = 0;
                    blackTamagachiMainMenu.opacity = 255;
                    
                    //Fade out all child sprites of the stageSelect Speech Bubble
                    [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)]];
                    
                    //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                    [speechBubbleStageSelect runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleColorSwatches runAction: [CCFadeOut actionWithDuration: 0.3]];
                    [speechBubbleMarbleList runAction: [CCFadeOut actionWithDuration: 0.3]];
                    
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                    
                    [carpet runAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)]];
                }
                
                else {
                    
                    [[SimpleAudioEngine sharedEngine] playEffect:@"Buzzer.wav"];
                }
            }
            
            else if (CGRectContainsPoint(speechBubbleColorSwatches.boundingBox, touchLocationTamagachi) && speechBubbleColorSwatches.visible && speechBubbleWillShow == YES && speechBubbleColorSwatchIsTopLayer == YES && !(CGRectContainsPoint(redColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation)) && !(CGRectContainsPoint(pinkColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation)) && !(CGRectContainsPoint(greenColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation)) && !(CGRectContainsPoint(yellowColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation)) && !(CGRectContainsPoint(orangeColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation)) && !(CGRectContainsPoint(lightPurpleColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation)) && !(CGRectContainsPoint(purpleColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation)) && !(CGRectContainsPoint(blueColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation)) && !(CGRectContainsPoint(whiteColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation)) && !(CGRectContainsPoint(blackColorSwatch.boundingBox, speechBubbleColorSwatchesTouchLocation))) {
                
                speechBubbleWillShow = NO;
                
                //Fade out all child sprites of the stageSelect Speech Bubble
                [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)]];
                
                //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                [speechBubbleStageSelect runAction: [CCFadeOut actionWithDuration: 0.3]];
                [speechBubbleColorSwatches runAction: [CCFadeOut actionWithDuration: 0.3]];
                [speechBubbleMarbleList runAction: [CCFadeOut actionWithDuration: 0.3]];
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                
                [carpet runAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)]];
            }
            
            [self saveGameSettings];
        }
        
        else if (speechBubbleMarbleList.visible == YES && speechBubbleMarbleListIsTopLayer && !(CGRectContainsPoint(whiteTabStickerForSpeechBubbleMarbleList.boundingBox, speechBubbleMarbleListTouchLocation))) {
            
            if (CGRectContainsPoint(speechBubbleMarbleList.boundingBox, touchLocationTamagachi) && speechBubbleMarbleList.visible && speechBubbleWillShow == YES) {
                
                speechBubbleWillShow = NO;
                
                //Fade out all child sprites of the stageSelect Speech Bubble
                [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToNotVisible)]];
                
                //Set stage select, color swatches, and marble list speech bubbles to fade out and not be visible
                [speechBubbleStageSelect runAction: [CCFadeOut actionWithDuration: 0.3]];
                [speechBubbleColorSwatches runAction: [CCFadeOut actionWithDuration: 0.3]];
                [speechBubbleMarbleList runAction: [CCFadeOut actionWithDuration: 0.3]];
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToNo)], nil]];
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToNo)], nil]];
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToNo)], nil]];
                
                [carpet runAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, 147)]];
                
                NSLog (@"Speech bubble touched");
            }
        }
        
        else if (CGRectContainsPoint(woodblock.boundingBox, touchLocationCarpet) && woodBlockTouched == NO && speechBubble.visible == NO && speechBubbleColorSwatches.visible == NO && speechBubbleWillShow == NO) {
            
            //DEBUG: Uncomment the below, in the game tap woodblock, go back to mainMenu, and then make a pref change by tapping gertyMainMenu to save iCloud chaanges once you uncomment the appropriate lines in MKiCloud
            //difficultyLevel = 1;
            //computerExperiencePoints = 50;
            //player1Level = 100;
            //player1ExperiencePoints = 97;
            //showAds = YES;
            
            //Choose a random stage if 'Random Stage Select is YES' or if stage == 0 for some technical reason
            if (checkMarkSpeechBubbleStageSelectIsOnRandomButton || stage == 0) {
                
                checkMarkSpeechBubbleStageSelectIsOnRandomButton = YES;
                int randomLevelRoll = arc4random()%2;
                
                if (randomLevelRoll == 0) {
                    
                    stage = DAY_TIME_SUBURB;
                }
                
                else if (randomLevelRoll == 1) {
                    
                    stage = NIGHT_TIME_SUBURB;
                }
            }
            
            //TURN THIS OFF FOR FINAL VERSION
            //player1MarblesUnlocked = 2;
            
            musicIsPlaying = NO;
            [mainMenuMusic stopBackgroundMusic];
            
            isPlayer1 = YES;
            opponentDisconnectedLabel.visible = NO;
            playButton.scale = 0.3;
            playButton.position = ccp([linedPaper contentSize].width/2, [linedPaper contentSize].height/2 -128);
            woodBlockTouched = YES;
            woodBlock2Touched = YES;
            woodBlock3Touched = YES;
            isSinglePlayer = YES;
            //tamagachi.visible = YES;
            //tamagachi2.visible = YES;
            //youLabel.visible = YES;
            backToMainMenu.visible = NO;
            backToMainMenu2.visible = YES;
            
            [self gertyComputer];
            [self gertySinglePlayer];
            
            microphoneOn.visible = NO;
            microphoneOff.visible = NO;
            
            //Sets tamagachi1 and tamagachi2 postions as you press woodBlock
            if (deviceIsWidescreen) {
                
                tamagachi.position = ccp([linedPaper contentSize].width/2 - 90, [linedPaper contentSize].height/2 - 50);
                tamagachi2.position = ccp([linedPaper contentSize].width/2 + 65, [linedPaper contentSize].height/2 - 50);
            }
            
            if (!deviceIsWidescreen) {
                
                tamagachi.position = ccp([linedPaper contentSize].width/2 - 115, [linedPaper contentSize].height/2 - 50);
                tamagachi2.position = ccp([linedPaper contentSize].width/2 + 40, [linedPaper contentSize].height/2 - 50);
            }
            
            int woodBlockScript = arc4random()%2;
            
            if (woodBlockScript == 0) {
                
                [woodblock runAction: [CCEaseOut actionWithAction: [CCRotateBy actionWithDuration:0.1 angle:7] rate:1.5]];
                [woodblock runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.2],[CCEaseOut actionWithAction: [CCRotateBy actionWithDuration:0.1 angle:-7] rate:1.5], nil]];
                
                tamagachi2.visible = YES;
                computerLabel.visible = YES;
                playButton.visible = YES;
                
                [linedPaper runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(0,0)]];
                
                [hudLayer runAction: [CCSequence actions: [CCMoveTo actionWithDuration:0.0 position:ccp(0, -460)],[CCDelayTime actionWithDuration: 0.4], [CCMoveTo actionWithDuration: 0.5 position: ccp(0, 0)], nil]];
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.0], [CCCallFunc actionWithTarget:self selector:@selector(setIsAtMainMenuToNo)], [CCCallFunc actionWithTarget:self selector:@selector(moveMainMenuLayerDown)], nil]];
            }
            
            else if (woodBlockScript == 1) {
                
                [woodblock runAction: [CCEaseOut actionWithAction: [CCRotateBy actionWithDuration:0.1 angle:2.5] rate:1.5]];
                [woodblock runAction: [CCEaseOut actionWithAction: [CCMoveBy actionWithDuration:0.1 position:ccp(0,2.5)] rate:1.5]];
                
                [woodblock runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.2],[CCEaseOut actionWithAction: [CCRotateBy actionWithDuration:0.1 angle:-2.5] rate:1.5], nil]];
                [woodblock runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.2],[CCEaseOut actionWithAction: [CCMoveBy actionWithDuration:0.1 position:ccp(0,-2.5)] rate:1.5], nil]];
                
                tamagachi2.visible = YES;
                computerLabel.visible = YES;
                playButton.visible = YES;
                
                [linedPaper runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(0,0)]];
                
                [hudLayer runAction: [CCSequence actions: [CCMoveTo actionWithDuration:0.0 position:ccp(0, -460)],[CCDelayTime actionWithDuration: 0.4], [CCMoveTo actionWithDuration: 0.5 position: ccp(0, 0)], nil]];
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.0], [CCCallFunc actionWithTarget:self selector:@selector(setIsAtMainMenuToNo)], [CCCallFunc actionWithTarget:self selector:@selector(moveMainMenuLayerDown)], nil]];
            }
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"HardMarbleCollision.caf"];
            happyGerty.visible = NO;
            sadGerty.visible = NO;
            uncertainGerty.visible = YES;
            cryingGerty.visible = NO;
            
            happyGerty2.visible = YES;
            sadGerty2.visible = NO;
            uncertainGerty2.visible = YES;
            cryingGerty2.visible = NO;
        }
        
        else if (CGRectContainsPoint(woodblock2.boundingBox, touchLocationCarpet) && woodBlock2Touched == NO && speechBubble.visible == NO && speechBubbleColorSwatches.visible == NO && speechBubbleWillShow == NO) {
            
            //Choose a random stage if 'Random Stage Select is YES' or if stage == 0 for some technical reason
            if (checkMarkSpeechBubbleStageSelectIsOnRandomButton || stage == 0) {
                
                checkMarkSpeechBubbleStageSelectIsOnRandomButton = YES;
                int randomLevelRoll = arc4random()%2;
                
                if (randomLevelRoll == 0) {
                    
                    stage = DAY_TIME_SUBURB;
                }
                
                else if (randomLevelRoll == 1) {
                    
                    stage = NIGHT_TIME_SUBURB;
                }
            }
            
            opponentDisconnected = NO;
            
            woodBlockTouched = YES;
            woodBlock2Touched = YES;
            woodBlock3Touched = YES;
            
            int woodBlockScript2 = arc4random()%2;
            isSinglePlayer = NO;
            
            if (woodBlockScript2 == 0) {
                
                [woodblock2 runAction: [CCEaseOut actionWithAction: [CCMoveBy actionWithDuration:0.1 position:ccp(0,2)] rate:1.5]];
                [woodblock2 runAction: [CCEaseOut actionWithAction: [CCRotateBy actionWithDuration:0.1 angle:3] rate:1.5]];
                
                //Move block back to the way it was before
                [woodblock2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.0],[CCEaseOut actionWithAction: [CCMoveBy actionWithDuration:0.1 position:ccp(0,-2.0)] rate:1.5], nil]];
                
                [woodblock2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.0],[CCEaseOut actionWithAction: [CCRotateBy actionWithDuration:0.1 angle:-3] rate:1.5], nil]];
                
                
                [linedPaper runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(0,-460)]];
                
                [hudLayer runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(0,0)]];
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.12], [CCCallFunc actionWithTarget:self selector:@selector(slideUpGameCenterViewController)], nil]];
            }
            
            else if (woodBlockScript2 == 1) {
                
                [woodblock2 runAction: [CCEaseOut actionWithAction: [CCRotateBy actionWithDuration:0.1 angle:7] rate:1.5]];
                
                //Move block back to the way it was before
                [woodblock2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.0],[CCEaseOut actionWithAction: [CCRotateBy actionWithDuration:0.1 angle:-7] rate:1.5], nil]];
                
                [linedPaper runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(0,-460)]];
                
                [hudLayer runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(0,0)]];
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.12], [CCCallFunc actionWithTarget:self selector:@selector(slideUpGameCenterViewController)], nil]];
            }
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"HardMarbleCollision.caf"];
            //         happyGerty.visible = YES;
            //         sadGerty.visible = NO;
            //         uncertainGerty.visible = NO;
            //         cryingGerty.visible = NO;
        }
        
        /*else if (CGRectContainsPoint(woodblock3.boundingBox, touchLocationCarpet) && speechBubbleWillShow == NO) {
                  
         [[SimpleAudioEngine sharedEngine] playEffect:@"HardMarbleCollision.caf"];
         
         speechBubbleWillShow = YES;
         
         if ([InAppRageIAPHelper sharedHelper].products == nil) {
         
         [[InAppRageIAPHelper sharedHelper] requestProducts];
         [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
         
         NSLog (@"Loading Store");
         }
         
         [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleVisibleToYes)], nil]];
         
         [speechBubble runAction: [CCFadeIn actionWithDuration: 0.3]];
         
         [carpet runAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, -147)]];
         }
         */
        
        /*
         //check for touches over the five ledBulbs on tamagachiMainMenu in the main menu
         else if ((touchLocationTamagachi.x < ledBulb1MainMenu.position.x + 90) && (touchLocationTamagachi.x > ledBulb1MainMenu.position.x - 50) && (touchLocationTamagachi.y < ledBulb1MainMenu.position.y + 25) && (touchLocationTamagachi.y > ledBulb1MainMenu.position.y - 50) && speechBubbleWillShow == NO) {
         
         showPointingFingerForGertyMainMenuLightBulbs = NO;
         
         pointingFingerForGertyMainMenuLightBulbs.visible = NO;
         
         speechBubbleWillShow = YES;
         
         [speechBubbleMarbleList runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.0], [CCFadeIn actionWithDuration: 0.3], nil]];
         
         [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.0], [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToYes)], nil]];
         
         [carpet runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.0],[CCMoveBy actionWithDuration:0.3 position:ccp(0, -147)], nil]];
         
         //All LED lights should flash several times indicating that was what was clicked on
         [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiLightsAllTurnOff)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiLightsAllTurnOn)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiLightsAllTurnOff)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiLightsAllTurnOn)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiLightsAllTurnOff)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiLightsAllTurnOn)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiLightsTurnOnOnlyUnlockedMarbleLights)], nil]];
         
         [self saveGameSettings];
         }
         */
        else if (CGRectContainsPoint(tamagachiMainMenu.boundingBox, touchLocationCarpet) && speechBubbleWillShow == NO && woodBlockTouched == NO && woodBlock2Touched == NO && woodBlock3Touched == NO) {
            
            [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(setAllSpeechBubblesChildSpritesToVisible)]];
            
            [carpet runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.0], [CCMoveBy actionWithDuration:0.3 position:ccp(0, -147)], nil]];
            
            [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber22 sourceGroupId:0 pitch:1.0f pan:0.5 gain:1.9 loop:NO];
            
            showPointingFingerForGertyMainMenuTamagachi = NO;
            
            pointingFingerForGertyMainMenuTamagachi.visible = NO;
            
            speechBubbleWillShow = YES;
            
            [speechBubbleColorSwatches runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.0], [CCFadeIn actionWithDuration: 0.3], nil]];
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.0], [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleColorSwatchesVisibleToYes)], nil]];
            
            //Gerty's face should flash several times indicating that was what was clicked on
            [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiGertyNotVisible)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiGertyVisible)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiGertyNotVisible)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiGertyVisible)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiGertyNotVisible)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiGertyVisible)], [CCDelayTime actionWithDuration:0.1], nil]];
            
            
            
            //Stage Select Speech Bubble Code
            NSLog (@"carpet tapped");
            
            [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber22 sourceGroupId:0 pitch:1.0f pan:0.5 gain:1.9 loop:NO];
            
            [speechBubbleStageSelect runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.0], [CCFadeIn actionWithDuration: 0.3], nil]];
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.0], [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleStageSelectVisibleToYes)], nil]];
            
            
            
            
            //Marble List Speech Bubble Code
            showPointingFingerForGertyMainMenuLightBulbs = NO;
            
            pointingFingerForGertyMainMenuLightBulbs.visible = NO;
            
            speechBubbleWillShow = YES;
            
            [speechBubbleMarbleList runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.0], [CCFadeIn actionWithDuration: 0.3], nil]];
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.0], [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(setSpeechBubbleMarbleListVisibleToYes)], nil]];
            
            //All LED lights should flash several times indicating that was what was clicked on
            [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiLightsAllTurnOff)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiLightsAllTurnOn)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiLightsAllTurnOff)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiLightsAllTurnOn)], [CCDelayTime actionWithDuration:0.1],[CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiLightsAllTurnOff)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiLightsAllTurnOn)], [CCDelayTime actionWithDuration:0.1], [CCCallFunc actionWithTarget:self selector:@selector(mainMenuTamagachiLightsTurnOnOnlyUnlockedMarbleLights)], nil]];
            
            
            [self saveGameSettings];
        }
    }
    
    
    else if (CGRectContainsPoint(indexCard.boundingBox, touchLocationHudLayer)) {
        
        if (indexCardTouchCount == 0 && indexCard1ReadyToTouch) {
            
            checkMark1.visible = NO;
            attackLabel.visible = NO;
            defendLabel.visible = YES;
            
            indexCardTouchCount = 1;
            
            //Play swoosh sound when dismissing away the index card
            [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber21 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
            
            [self howToDefendTutorial];
            [self stopAction: howToPlayAnimation];
            [self fadeOutAllHowToPlayTutorialFrames];
        }
        
        else if (indexCardTouchCount >= 1) {
            
            if (indexCard2ReadyToTouch) {
            
                indexCard2ReadyToTouch = NO;
            
                [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber21 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
                
                [self stopAction: howToDefendAnimation];
                [self fadeOutAllHowToDefendTutorialFrame];
                
                [self runAction: [CCCallFunc actionWithTarget:self selector:@selector(getReadyLabelNotVisible)]];
                
                [indexCard runAction: [CCMoveTo actionWithDuration:0.3 position:ccp(50, -400)]];
                [indexCard2 runAction: [CCMoveTo actionWithDuration:0.3 position:ccp(53, -400)]];
                
                inGameTutorialHasAlreadyBeenPlayedOnce = YES;
                
                [self saveGameSettings];
            }
        }
    }
    
    //DEBUG: This will disable the ability to begin the single player match from versus screen or push backToMainMenu2
    
    else if (((CGRectContainsPoint(playButton.boundingBox, linedPaperTouchLocation)  && playButton.visible == YES && isGo == NO && playersCanTouchMarblesNow == NO && isAtMainMenu == NO) || (CGRectContainsPoint(linedPaper.boundingBox, linedPaperTouchLocation)  && playButton.visible == YES && isGo == NO && playersCanTouchMarblesNow == NO && isAtMainMenu == NO)) && !(CGRectContainsPoint(backToMainMenu.boundingBox, linedPaperTouchLocation)) && !(CGRectContainsPoint(backToMainMenu2.boundingBox, linedPaperTouchLocation))) {
        
        NSLog (@"play button pushed!");
        
        whiteProgressDot1.visible = YES;
        whiteProgressDot2.visible = YES;
        whiteProgressDot3.visible = YES;
        whiteProgressDot4.visible = YES;
        whiteProgressDot5.visible = YES;
        
        whiteProgressDot1.color = ccBLACK;
        whiteProgressDot1.scale = 0.05;
        whiteProgressDot2.color = ccBLACK;
        whiteProgressDot2.scale = 0.05;
        whiteProgressDot3.color = ccBLACK;
        whiteProgressDot3.scale = 0.05;
        whiteProgressDot4.color = ccBLACK;
        whiteProgressDot4.scale = 0.05;
        whiteProgressDot5.color = ccBLACK;
        whiteProgressDot5.scale = 0.05;
        
        playButton.visible = NO;
        backToMainMenu.visible = NO;
        backToMainMenu2.visible = NO;
        
        [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber22 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
        
        if (isSinglePlayer && playbuttonPushed == NO) {
            
            [self multiplayerInGameCountdownProgressDotsAnimation];
            
            playbuttonPushed = YES;
            
            startingSequenceBegan = NO;
            player1Winner = NO;
            player2Winner = NO;
            //isSinglePlayer = YES;
            
            backToMainMenu2.visible = NO;
            
            //[self startLevelWithCountDown];
            
            //Move player tamagachi away first
            [tamagachi runAction: [CCSequence actions: [CCEaseOut actionWithAction: [CCMoveTo actionWithDuration: 0.9 position: ccp(tamagachi.position.x - 400, tamagachi.position.y)] rate: 3.0], nil]];
            
            if (deviceIsWidescreen) {
                
                //Move computer tamagachi in
                [tamagachi2 runAction: [CCSequence actions: [CCEaseOut actionWithAction: [CCMoveTo actionWithDuration: 0.7 position:ccp([linedPaper contentSize].width/2 - 15, [linedPaper contentSize].height/2 - 50)] rate: 3.0], [CCCallFunc actionWithTarget:self selector:@selector(clearAndRestartLevelFromSinglePlayerVersusScreen)], [CCDelayTime actionWithDuration:0.5], [CCCallFunc actionWithTarget:self selector:@selector(setIsAtMainMenuToNo)], [CCCallFunc actionWithTarget:self selector:@selector(moveMainMenuLayerDown)], [CCCallFunc actionWithTarget:self selector:@selector(setTeslaPositionsToSlingBombPositions)], nil]];
            }
            
            if (!deviceIsWidescreen) {
                
                //Move computer tamagachi in
                [tamagachi2 runAction: [CCSequence actions: [CCEaseOut actionWithAction: [CCMoveTo actionWithDuration: 0.7 position:ccp([linedPaper contentSize].width/2 - 40, [linedPaper contentSize].height/2 - 50)] rate: 3.0], [CCCallFunc actionWithTarget:self selector:@selector(clearAndRestartLevelFromSinglePlayerVersusScreen)], [CCDelayTime actionWithDuration:0.5], [CCCallFunc actionWithTarget:self selector:@selector(setIsAtMainMenuToNo)], [CCCallFunc actionWithTarget:self selector:@selector(moveMainMenuLayerDown)], [CCCallFunc actionWithTarget:self selector:@selector(setTeslaPositionsToSlingBombPositions)], nil]];
            }
            
            happyGerty2.visible = NO;
            uncertainGerty2.visible = YES;
            cryingGerty2.visible = NO;
            
            [linedPaper runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(0,0)]];
            
            [hudLayer runAction: [CCSequence actions: [CCMoveTo actionWithDuration:0.0 position:ccp(0, 0)],[CCDelayTime actionWithDuration: 0.4], [CCMoveTo actionWithDuration: 0.0 position: ccp(0, 0)], nil]];
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.2], [CCCallFunc actionWithTarget:self selector:@selector(startLevelWithCountDown)], nil]];
            
            //Update computerLevelLabel upon pushing play button
            [computerLevelLabel setString:[NSString stringWithFormat: @"Rank: %i", (difficultyLevel + 1)]];
            
            //Update computerExperiencePointsLabel upon pushing play button
            [player2ExperiencePointsLabel setString:[NSString stringWithFormat:@"%i%%", computerExperiencePoints]];
            
            [player2ExperiencePointsLabel runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCFadeOut actionWithDuration: 0.0], [CCDelayTime actionWithDuration: 0.1], [CCFadeIn actionWithDuration: 0.0], [CCDelayTime actionWithDuration: 0.1],[CCFadeOut actionWithDuration: 0.0], [CCDelayTime actionWithDuration: 0.1], [CCFadeIn actionWithDuration: 0.0], [CCDelayTime actionWithDuration: 0.1], [CCFadeOut actionWithDuration: 0.0], [CCDelayTime actionWithDuration: 0.1], [CCFadeIn actionWithDuration: 0.0], nil]];
        }
        
        else if (!isSinglePlayer && playbuttonPushed == NO) {
            
            playbuttonPushed = YES;
            
            backToMainMenu.visible = NO;
            playButton.visible = NO;
            
            [self sendPlayAgain];
            
            //timeOutTime = [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCCallFunc actionWithTarget:self selector:@selector(backToMainMenu)], nil];
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCCallFunc actionWithTarget:self selector:@selector(backToMainMenu)], nil]];
            
            //[self runAction: timeOutTime];
            
            NSLog (@"sendPlayAgain sending");
            
            if (otherPlayerWishesToPlayAgain == YES) {
                
                //  [self sendGameBegin];
                
                [self stopAction: timeOutTime];
     
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFunc actionWithTarget:self selector:@selector(sendGameBegin)], nil]];
                
                
                NSLog (@"sendGameBegin sending");
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCCallFuncND actionWithTarget:self selector:@selector(setupStringsWithOtherPlayerId:) data:(void*)otherPlayerID], nil]];
                
            }
        }
    }
    
    
    
    else if (CGRectContainsPoint(backToMainMenu2.boundingBox, linedPaperTouchLocation) && backToMainMenu2.visible == YES) {
        
        [self backToMainMenu];
        
        //Move linedPaper all the way up
        [linedPaper runAction: [CCSequence actions:[CCMoveTo actionWithDuration:0.0 position:ccp(0,0)], [CCCallFunc actionWithTarget:self selector:@selector(makeNavigationButtonsInvisible)], nil]];
        
    }
    
    
    else if (CGRectContainsPoint(pauseButton.boundingBox, touchLocationHudLayer) && playersCanTouchMarblesNow == YES && pauseButton.visible == YES && isSinglePlayer) {
        
        pauseButton.visible = NO;
        
        int backToMainMenuPositionOffset;
        
        if (deviceIsWidescreen) {
            
            backToMainMenuPositionOffset = 35;
        }
        
        if (!deviceIsWidescreen) {
            
            backToMainMenuPositionOffset = 0;
        }
        
        backToMainMenu.position = ccp((98.75 + backToMainMenuPositionOffset), 267.5);
        [backToMainMenu runAction: [CCScaleTo actionWithDuration:0.0 scale:0.31]];
        backToMainMenu.visible = YES;
        
        if (isGo == YES) {
            
            [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber21 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
            [self pauseGame];
        }
        
        else if (isGo == NO) {
            
            [linedPaper runAction: [CCMoveTo actionWithDuration:1.0 position:ccp(linedPaper.position.x, -200)]];
        }
    }
    
    
    else if (CGRectContainsPoint(backToMainMenu.boundingBox, linedPaperTouchLocation) && backToMainMenu.visible == YES) {
                
        //[self sendOtherPlayerHasLeftMatchFromVersusScreen];
        [self backToMainMenu];
    }
    
    else if (CGRectContainsPoint(continuePlayingGame.boundingBox, linedPaperTouchLocation) && continuePlayingGame.visible == YES && isGo) {
        
        [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber22 sourceGroupId:0 pitch:1.0f pan:0.5 gain:1.9 loop:NO];
        
        if (playersCanTouchMarblesNow == YES) {
            
            [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber21 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
            [self pauseGame];
        }
        
        pauseButton.visible = YES;
        NSLog (@"continuePlayingGame pushed");
    }
    
    else if (isPlayer1 == YES && isGo == YES && playersCanTouchMarblesNow == YES && lightningStrikePlayer1Ready == YES) {
        
        if (player1HandicapInteger == 0) {
            
            curBombPlayer2BlockingRadius = 25;
        }
        
        else if (player1HandicapInteger == 1) {
            
            curBombPlayer2BlockingRadius = 23;
        }
        
        else if (player1HandicapInteger == 2) {
            
            curBombPlayer2BlockingRadius = 21;
        }
        
        else if (player1HandicapInteger == 3) {
            
            curBombPlayer2BlockingRadius = 19;
        }
        
        else if (player1HandicapInteger == 4) {
            
            curBombPlayer2BlockingRadius = 17;
        }
        
        touchLocationLightning = [sling1 convertTouchToNodeSpace: touch];
        
        if (isPlayer1) {
            
            //DEBUG: Allows player1 to win upon first touch
            //[self player1IsTheWinnerScript];
        }
        
        if (lightningStrikePlayer1Ready == YES && player1ProjectileHasBeenTouched == NO && gamePaused == NO && ((CGRectContainsPoint(microphoneOn.boundingBox, touchLocationHudLayer) == NO)) && (CGRectContainsPoint(pauseButton.boundingBox, touchLocationHudLayer) == NO) && (CGRectContainsPoint(continuePlayingGame.boundingBox, linedPaperTouchLocation) == NO) && (CGRectContainsPoint(backToMainMenu.boundingBox, linedPaperTouchLocation) == NO)) {
            
            lightningStrikePlayer1Ready = NO;
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(removeAndResetLightningPlayer1)], [CCCallFunc actionWithTarget:self selector:@selector(setupLightningStrikeReadyPlayer1ToYes)], nil]];
            
            lightning = [Lightning lightningWithStrikePoint: ccp(touchLocationLightning.x - 26, touchLocationLightning.y - 46)];
            lightning.position = SLING_POSITION;
            [zoombase addChild:lightning z:6];
            
            [lightning strike];
            player1LightningExists = YES;
        }
        
        NSLog (@"Player1 lightning strike!");
        
        touchLocation = [zoombase convertTouchToNodeSpace:touch];
        
        
        if (player2BombExists == YES) {
            
            if (cpShapePointQuery(_curBombPlayer2.shape, touchLocation) && (_curBombPlayer2.position.x < SLING_POSITION_2.x - 30) && player2ProjectileIsZappable == YES) {
                
                if (bombHasHitRectangleHenceNoBonus2 == NO) {
                    
                    if (isSinglePlayer == NO) {
                        
                        if (projectileLaunchMultiplier2 == 0 && blockingChargeBonusPlayer1 == 0) {
                            
                            blockingChargeBonusPlayer1 = 3;
                            [lightningBolt2 setColor: ccc3(255, 255, 0)];
                        }
                        
                        if (projectileLaunchMultiplier2 == 1 && blockingChargeBonusPlayer1 <= 3) {
                            
                            blockingChargeBonusPlayer1 = 6;
                            [lightningBolt2 setColor: ccORANGE];
                        }
                        
                        if (projectileLaunchMultiplier2 >= 2 && blockingChargeBonusPlayer1 <= 6) {
                            
                            blockingChargeBonusPlayer1 = 9;
                            [lightningBolt2 setColor: ccc3(255, 0, 0)];
                        }
                        
                        if (projectileLaunchMultiplier2 >= 3 && blockingChargeBonusPlayer1 <= 9) {
                            
                            blockingChargeBonusPlayer1 = 12;
                            [lightningBolt2 setColor: ccc3(72, 61, 139)];
                        }
                        
                        if (projectileLaunchMultiplier2 >= 4 && blockingChargeBonusPlayer1 <= 12) {
                            
                            blockingChargeBonusPlayer1 = 15;
                            [lightningBolt2 setColor: ccc3(25, 25, 112)];
                        }
                    }
                    
                    else if (isSinglePlayer == YES) {
                        
                        if (skillLevelBonus == 0) {
                            
                            if (computerNumberOfChargingRounds == 0) {
                                
                                blockingChargeBonusPlayer1 = 3;
                                [lightningBolt2 setColor: ccc3(255, 255, 0)];
                            }
                            
                            else if (computerNumberOfChargingRounds == 1) {
                                
                                blockingChargeBonusPlayer1 = 6;
                                [lightningBolt2 setColor: ccORANGE];
                            }
                            
                            else if (computerNumberOfChargingRounds == 2) {
                                
                                blockingChargeBonusPlayer1 = 9;
                                [lightningBolt2 setColor: ccc3(255, 0, 0)];
                            }
                        }
                        
                        else if (skillLevelBonus == 1) {
                            
                            if (computerNumberOfChargingRounds == 0) {
                                
                                blockingChargeBonusPlayer1 = 6;
                                [lightningBolt2 setColor: ccORANGE];
                            }
                            
                            else if (computerNumberOfChargingRounds == 1) {
                                
                                blockingChargeBonusPlayer1 = 9;
                                [lightningBolt2 setColor: ccc3(255, 0, 0)];
                            }
                            
                            else if (computerNumberOfChargingRounds == 2) {
                                
                                blockingChargeBonusPlayer1 = 12;
                                [lightningBolt2 setColor: ccc3(72, 61, 139)];
                            }
                        }
                        
                        else if (skillLevelBonus == 2) {
                            
                            if (computerNumberOfChargingRounds == 0) {
                                
                                blockingChargeBonusPlayer1 = 9;
                                [lightningBolt2 setColor: ccc3(255, 0, 0)];
                            }
                            
                            else if (computerNumberOfChargingRounds == 1) {
                                
                                blockingChargeBonusPlayer1 = 12;
                                [lightningBolt2 setColor: ccc3(72, 61, 139)];
                            }
                            
                            else if (computerNumberOfChargingRounds == 2) {
                                
                                blockingChargeBonusPlayer1 = 15;
                                [lightningBolt2 setColor: ccc3(25, 25, 112)];
                            }
                        }
                    }
                    
                    [self lightningBoltBlockPlayer2];
                }
                
                doNotShowMarblePointFinger2 = YES;
                
                blockPointXValueOfMarble2 = _curBombPlayer2.position.x;
                
                [self smokeyExplosionPlayer2];
                [self sendProjectileBlocked2];
                [(Bomb2 *)_curBombPlayer2.shape->data player2BombZapped];
                
                if (gertyPlayer1Alive) {
                    [(Gerty*)gerty.shape->data happyGertyFace];
                }
            }
            
            //If enemy marble and friendly sling shot and touch overlap, then marble should die
            else if (((touchLocation.x < SLING_BOMB_POSITION.x + 50 && touchLocation.x > SLING_BOMB_POSITION.x - 50) && (touchLocation.y < SLING_BOMB_POSITION.y + 50 && touchLocation.y > SLING_BOMB_POSITION.y - 50) && (_curBombPlayer2.position.x < SLING_POSITION_2.x - 30) && player2BombExists == YES && player2ProjectileIsZappable == YES) && ((_curBombPlayer2.position.x < SLING_BOMB_POSITION.x + 50 && _curBombPlayer2.position.x > SLING_BOMB_POSITION.x - 50) && (_curBombPlayer2.position.y < SLING_BOMB_POSITION.y + 50 && _curBombPlayer2.position.y > SLING_BOMB_POSITION.y - 50) && (_curBomb.position.x == SLING_BOMB_POSITION.x) && _curBomb.shape->body->v.x == 0)) {
                
                
                doNotShowMarblePointFinger2 = YES;
                
                blockPointXValueOfMarble2 = _curBombPlayer2.position.x;
                [self smokeyExplosionPlayer2];
                [self sendProjectileBlocked2];
                [(Bomb2 *)_curBombPlayer2.shape->data player2BombZapped];
                
                
                if (gertyPlayer1Alive) {
                    [(Gerty*)gerty.shape->data happyGertyFace];
                }
            }
            
            else if ((touchLocation.x < _curBombPlayer2.position.x + curBombPlayer2BlockingRadius && touchLocation.x > _curBombPlayer2.position.x - curBombPlayer2BlockingRadius) && (touchLocation.y < _curBombPlayer2.position.y + curBombPlayer2BlockingRadius && touchLocation.y > _curBombPlayer2.position.y - curBombPlayer2BlockingRadius) && (_curBombPlayer2.position.x < SLING_POSITION_2.x - 30) && player2BombExists == YES && player2ProjectileIsZappable == YES) {
                
                doNotShowMarblePointFinger2 = YES;
                
                blockPointXValueOfMarble2 = _curBombPlayer2.position.x;
                [self smokeyExplosionPlayer2];
                [self sendProjectileBlocked2];
                [(Bomb2 *)_curBombPlayer2.shape->data player2BombZapped];
                
                if (gertyPlayer1Alive) {
                    [(Gerty*)gerty.shape->data happyGertyFace];
                }
            }
            
            else if ((cpShapePointQuery(_curBombPlayer2.shape, touchLocation) && (_curBombPlayer2.position.x < SLING_POSITION_2.x + 30) && player2ProjectileIsZappable == NO) || ((touchLocation.x < _curBombPlayer2.position.x + 25 && touchLocation.x > _curBombPlayer2.position.x - 25) && (touchLocation.y < _curBombPlayer2.position.y + 25 && touchLocation.y > _curBombPlayer2.position.y - 25) && (_curBombPlayer2.position.x < SLING_POSITION_2.x - 30) && player2BombExists == YES)) {
                
                NSLog (@"Buzzer should be playing");
                
                [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber24 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
            }
            
            else if ((touchLocation.x < SLING_BOMB_POSITION.x + 25 && touchLocation.x > SLING_BOMB_POSITION.x - 25) && (touchLocation.y < SLING_BOMB_POSITION.y + 25 && touchLocation.y > SLING_BOMB_POSITION.y - 25) && (_curBomb.position.x == SLING_BOMB_POSITION.x) && _curBomb.shape->body->v.x == 0 && player1ProjectileCanBeTouchedAgain == YES) {
                
                player1ProjectileCanBeTouchedAgain = NO;
                player1ProjectileHasBeenTouched = YES;
                
                player1SlotMachineAnimation = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.2], [CCCallFunc actionWithTarget:self selector:@selector(startMarbleSlotMachineGameMethodForPlayer1)], nil]]];
                
                audioSlotMachineSpinning = [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber26 sourceGroupId:0 pitch:1.0f pan:0.2 gain:0.03 loop:YES];
                
                
                pointingFinger1.visible = NO;
                
                [self player1SlingIsSmoking];
                
                //    if (player1GiantSmokeCloudFrontOpacityIsIncreasing == NO) {
                
                [self increaseBigSmokeCloudOpacity];
                //  [self stopAction: reduceBigSmokeCloudOpacityAction];
                //     }
                
                //[self zoomOutForSlingingPlayer1];
                [self zoomOut];
                [self sendAudioStretchingSling];
                [self sendRequestBlockInfoFromPlayer2];
                receivingChargingDataFromPlayer1 = YES;
                
                
                ptPlayer1 = [zoombase convertTouchToNodeSpace:touch];
                bombPtPlayer1 = ccp(60,166);
                CGPoint ptPlayer1Vector = ccpSub(ptPlayer1, bombPtPlayer1);
                normalVectorPlayer1 = ccpNormalize(ptPlayer1Vector);
                lengthPlayer1 = ccpLength(ptPlayer1Vector);
                
                if (lengthPlayer1 > 25)
                    lengthPlayer1 = 25;
                
                currentBombPostionPlayer1 = ccpAdd(bombPtPlayer1, ccpMult(normalVectorPlayer1, lengthPlayer1));
                _curBomb.position = currentBombPostionPlayer1;
                
                CDXAudioNodeSlingShot *audioStretchingSling = [[sling1 children] objectAtIndex:0];
                [audioStretchingSling play];
                
                audioChargingShot = [[sling1 children] objectAtIndex:2];
                audioChargingShot.playMode = kAudioNodeLoopProjectileCharging;
                [audioChargingShot play];
                
                chargedShotTimeStarted = appSessionStartTime;
            }
            
            else if (cpShapePointQuery(_curBomb.shape, touchLocation) && _curBomb.shape->body->v.x == 0 && player1BombIsAirborne == NO && player1ProjectileCanBeTouchedAgain == YES) {
                
                player1SlotMachineAnimation = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.2], [CCCallFunc actionWithTarget:self selector:@selector(startMarbleSlotMachineGameMethodForPlayer1)], nil]]];
                
                audioSlotMachineSpinning = [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber26 sourceGroupId:0 pitch:1.0f pan:0.2 gain:0.03 loop:NO];
                
                pointingFinger1.visible = NO;
                
                //   if (player1GiantSmokeCloudFrontOpacityIsIncreasing == NO) {
                
                [self increaseBigSmokeCloudOpacity];
                //  [self stopAction: reduceBigSmokeCloudOpacityAction];
                //   }
                
                //[self zoomOutForSlingingPlayer1];
                [self zoomOut];
                [self sendAudioStretchingSling];
                [self sendRequestBlockInfoFromPlayer2];
                receivingChargingDataFromPlayer1 = YES;
                
                ptPlayer1 = [zoombase convertTouchToNodeSpace:touch];
                bombPtPlayer1 = ccp(60,166);
                player1Vector = ccpSub(ptPlayer1, bombPtPlayer1);
                normalVectorPlayer1 = ccpNormalize(player1Vector);
                lengthPlayer1 = ccpLength(player1Vector);
                
                if (lengthPlayer1 > 25)
                    lengthPlayer1 = 25;
                
                currentBombPostionPlayer1 = ccpAdd(bombPtPlayer1, ccpMult(normalVectorPlayer1, lengthPlayer1));
                _curBomb.position = currentBombPostionPlayer1;
                
                touchLocation = [zoombase convertTouchToNodeSpace:touch];
                
                player1ProjectileCanBeTouchedAgain = NO;
                player1ProjectileHasBeenTouched = YES;
                
                CDXAudioNodeSlingShot *audioStretchingSling = [[sling1 children] objectAtIndex:0];
                [audioStretchingSling play];
                
                audioChargingShot = [[sling1 children] objectAtIndex:2];
                
                
                chargedShotTimeStarted = appSessionStartTime;
                // NSLog (@"chargedShotTimeStarted in TouchBegan = %f", chargedShotTimeStarted);
            }
        }
    }
    
    
    if (isPlayer1 == NO && isGo == YES && playersCanTouchMarblesNow == YES && lightningStrikePlayer2Ready == YES && gamePaused == NO) {
        
        if (player2HandicapInteger == 0) {
            
            curBombBlockingRadius = 25;
        }
        
        else if (player2HandicapInteger == 1) {
            
            curBombBlockingRadius = 23;
        }
        
        else if (player2HandicapInteger == 2) {
            
            curBombBlockingRadius = 21;
        }
        
        else if (player2HandicapInteger == 3) {
            
            curBombBlockingRadius = 19;
        }
        
        else if (player2HandicapInteger == 4) {
            
            curBombBlockingRadius = 17;
        }
        
        touchLocationLightning2 = [sling1Player2 convertTouchToNodeSpace: touch];
        
        //DEBUG: Uncomment the bottom to have player2 win at first touch
        //[self player2IsTheWinnerScript];
        
        if (lightningStrikePlayer2Ready == YES && player2ProjectileHasBeenTouched == NO && ((CGRectContainsPoint(microphoneOn.boundingBox, touchLocationHudLayer) == NO)) && (CGRectContainsPoint(pauseButton.boundingBox, touchLocationHudLayer) == NO) && (CGRectContainsPoint(continuePlayingGame.boundingBox, linedPaperTouchLocation) == NO) && (CGRectContainsPoint(backToMainMenu.boundingBox, linedPaperTouchLocation) == NO)) {
            
            lightningStrikePlayer2Ready = NO;
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.4], [CCCallFunc actionWithTarget:self selector:@selector(removeAndResetLightningPlayer2)], [CCCallFunc actionWithTarget:self selector:@selector(setupLightningStrikeReadyPlayer2ToYes)], nil]];
            
            lightning2 = [Lightning lightningWithStrikePoint: ccp(touchLocationLightning2.x - 26, touchLocationLightning2.y - 46)];
            lightning2.position = SLING_POSITION_2;
            [zoombase addChild:lightning2 z:6];
            
            [lightning2 strike];
            player2LightningExists = YES;
        }
        
        
        touchLocation = [zoombase convertTouchToNodeSpace:touch];
        
        if (player1BombExists == YES) {
            
            if (cpShapePointQuery(_curBomb.shape, touchLocation) && (_curBomb.position.x > SLING_POSITION.x + 30) && player1ProjectileIsZappable == YES) {
                
                if (bombHasHitRectangleHenceNoBonus1 == NO) {
                    
                    if (projectileLaunchMultiplier == 0 && blockingChargeBonusPlayer2 == 0) {
                        
                        blockingChargeBonusPlayer2 = 3;
                        [lightningBolt1 setColor: ccc3(255, 255, 0)];
                    }
                    
                    if (projectileLaunchMultiplier == 1 && blockingChargeBonusPlayer2 <= 3) {
                        
                        blockingChargeBonusPlayer2 = 6;
                        [lightningBolt1 setColor: ccc3(255, 128, 0)];
                    }
                    
                    if (projectileLaunchMultiplier >= 2 && blockingChargeBonusPlayer2 <= 6) {
                        
                        blockingChargeBonusPlayer2 = 9;
                        [lightningBolt1 setColor: ccc3(255, 0, 0)];
                    }
                    
                    if (projectileLaunchMultiplier >= 3 && blockingChargeBonusPlayer2 <= 9) {
                        
                        blockingChargeBonusPlayer2 = 12;
                        [lightningBolt1 setColor: ccc3(72, 61, 139)];
                        
                    }
                    
                    if (projectileLaunchMultiplier >= 4 && blockingChargeBonusPlayer2 <= 12) {
                        
                        blockingChargeBonusPlayer2 = 15;
                        [lightningBolt1 setColor: ccc3(25, 25, 112)];
                    }
                    
                    [self lightningBoltBlockPlayer1];
                }
                
                doNotShowMarblePointFinger2 = YES;
                
                blockPointXValueOfMarble1 = _curBomb.position.x;
                [self smokeyExplosionPlayer1];
                [self sendProjectileBlocked];
                [(Bomb *)_curBomb.shape->data player1BombZapped];
                
                if (gertyPlayer1Alive) {
                    [(Gerty2*)gerty2.shape->data happyGertyFace];
                }
            }
            
            //If enemy marble and friendly sling shot and touch overlap, then marble should die
            else if (((touchLocation.x < SLING_BOMB_POSITION_2.x + 50 && touchLocation.x > SLING_BOMB_POSITION_2.x - 50) && (touchLocation.y < SLING_BOMB_POSITION_2.y + 50 && touchLocation.y > SLING_BOMB_POSITION_2.y - 50) && (_curBomb.position.x > SLING_POSITION.x + 30) && player1BombExists == YES && player1ProjectileIsZappable == YES) && ((_curBomb.position.x < SLING_BOMB_POSITION_2.x + 50 && _curBomb.position.x > SLING_BOMB_POSITION_2.x - 50) && (_curBomb.position.y < SLING_BOMB_POSITION_2.y + 50 && _curBomb.position.y > SLING_BOMB_POSITION_2.y - 50) && (_curBombPlayer2.position.x == SLING_BOMB_POSITION_2.x) && _curBombPlayer2.shape->body->v.x == 0)) {
                
                doNotShowMarblePointFinger2 = YES;
                
                blockPointXValueOfMarble1 = _curBomb.position.x;
                [self smokeyExplosionPlayer1];
                [self sendProjectileBlocked];
                [(Bomb *)_curBomb.shape->data player1BombZapped];
                
                if (gertyPlayer1Alive) {
                    [(Gerty2*)gerty2.shape->data happyGertyFace];
                }
            }
            
            else if ((touchLocation.x < _curBomb.position.x + 25 && touchLocation.x > _curBomb.position.x - 25) && (touchLocation.y < _curBomb.position.y + 25 && touchLocation.y > _curBomb.position.y - 25) && (_curBomb.position.x > SLING_POSITION.x + 30) && player1BombExists == YES && player1ProjectileIsZappable == YES) {
                
                doNotShowMarblePointFinger2 = YES;
                
                blockPointXValueOfMarble1 = _curBomb.position.x;
                [self smokeyExplosionPlayer1];
                [self sendProjectileBlocked];
                [(Bomb *)_curBomb.shape->data player1BombZapped];
                
                redWarningArrow.opacity = 0;
                
                if (gertyPlayer2Alive) {
                    [(Gerty2*)gerty2.shape->data happyGertyFace];
                }
            }
            
            else if ((cpShapePointQuery(_curBomb.shape, touchLocation) && (_curBomb.position.x > SLING_POSITION.x + 30) && player1ProjectileIsZappable == NO) || ((touchLocation.x < _curBomb.position.x + 25 && touchLocation.x > _curBomb.position.x - 25) && (touchLocation.y < _curBomb.position.y + 25 && touchLocation.y > _curBomb.position.y - 25) && (_curBomb.position.x > SLING_POSITION.x + 30) && player1BombExists == YES)) {
                
                NSLog (@"Buzzer should be playing");
                
                [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber24 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
            }
            
            
            else if ((touchLocation.x < SLING_BOMB_POSITION_2.x + 25 && touchLocation.x > SLING_BOMB_POSITION_2.x - 25) && (touchLocation.y < SLING_BOMB_POSITION_2.y + 25 && touchLocation.y > SLING_BOMB_POSITION_2.y - 25) && (_curBombPlayer2.position.x == SLING_BOMB_POSITION_2.x) && _curBombPlayer2.shape->body->v.x == 0 && player2ProjectileCanBeTouchedAgain == YES) {
                
                player2ProjectileCanBeTouchedAgain = NO;
                player2ProjectileHasBeenTouched = YES;
                
                player2SlotMachineAnimation = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.2], [CCCallFunc actionWithTarget:self selector:@selector(startMarbleSlotMachineGameMethodForPlayer2)], nil]]];
                
                audioSlotMachineSpinningPlayer2 = [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber28 sourceGroupId:0 pitch:1.0f pan:0.8 gain:0.03 loop:YES];
                
                pointingFinger1.visible = NO;
                
                [self player2SlingIsSmoking];
                [self increasePlayer2BigSmokeCloudOpacity];
                
                //[self zoomOutForSlingingPlayer2];
                [self zoomOut];
                [self sendAudioStretchingSling];
                [self sendRequestBlockInfoFromPlayer1];
                receivingChargingDataFromPlayer2 = YES;
                
                readyToReceiveBlocksPositionsFromPlayer1 = NO;
                
                ptPlayer2 = [zoombase convertTouchToNodeSpace:touch];
                bombPtPlayer2 = ccp(525,166);
                player2Vector = ccpSub(ptPlayer2, bombPtPlayer2);
                normalVectorPlayer2 = ccpNormalize(player2Vector);
                lengthPlayer2 = ccpLength(player2Vector);
                
                if (lengthPlayer2 > 25)
                    lengthPlayer2 = 25;
                
                currentBombPostionPlayer2 = ccpAdd(bombPtPlayer2, ccpMult(normalVectorPlayer2, lengthPlayer2));
                _curBombPlayer2.position = currentBombPostionPlayer2;
                
                touchLocation = [zoombase convertTouchToNodeSpace:touch];
                
                CDXAudioNodeSlingShot *audioStretchingSling = [[sling1Player2 children] objectAtIndex:0];
                [audioStretchingSling play];
                
                CDXAudioNodeProjectileCharging2 *audioChargingShot2 = [[sling1Player2 children] objectAtIndex:2];
                audioChargingShot2.playMode = kAudioNodeLoopProjectileCharging2;
                [audioChargingShot2 play];
                
                chargedShotTimeStarted2 = appSessionStartTime;
            }
            
            else if (cpShapePointQuery(_curBombPlayer2.shape, touchLocation) && _curBombPlayer2.shape->body->v.x == 0 && fieldZoomedOut == NO && player2BombIsAirborne == NO && player2ProjectileCanBeTouchedAgain == YES) {
                
                player2SlotMachineAnimation = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.2], [CCCallFunc actionWithTarget:self selector:@selector(startMarbleSlotMachineGameMethodForPlayer2)], nil]]];
                
                audioSlotMachineSpinningPlayer2 = [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber28 sourceGroupId:0 pitch:1.0f pan:0.8 gain:0.03 loop:YES];
                
                pointingFinger1.visible = NO;
                
                [self player2SlingIsSmoking];
                
                //      if (player2GiantSmokeCloudFrontOpacityIsIncreasing == NO) {
                
                [self increasePlayer2BigSmokeCloudOpacity];
                //    [self stopAction: reducePlayer2BigSmokeCloudOpacityAction];
                //       }
                
                //[self zoomOutForSlingingPlayer2];
                [self zoomOut];
                [self sendAudioStretchingSling];
                [self sendRequestBlockInfoFromPlayer1];
                receivingChargingDataFromPlayer2 = YES;
                
                
                readyToReceiveBlocksPositionsFromPlayer1 = NO;
                
                ptPlayer2 = [zoombase convertTouchToNodeSpace:touch];
                bombPtPlayer2 = ccp(525,166);
                player2Vector = ccpSub(ptPlayer2, bombPtPlayer2);
                normalVectorPlayer2 = ccpNormalize(player2Vector);
                lengthPlayer2 = ccpLength(player2Vector);
                
                if (lengthPlayer2 > 25)
                    lengthPlayer2 = 25;
                
                currentBombPostionPlayer2 = ccpAdd(bombPtPlayer2, ccpMult(normalVectorPlayer2, lengthPlayer2));
                _curBombPlayer2.position = currentBombPostionPlayer2;
                
                touchLocation = [zoombase convertTouchToNodeSpace:touch];
                
                player2ProjectileCanBeTouchedAgain = NO;
                player2ProjectileHasBeenTouched = YES;
                
                CDXAudioNodeSlingShot *audioStretchingSling = [[sling1Player2 children] objectAtIndex:0];
                [audioStretchingSling play];
                
                CDXAudioNodeProjectileCharging2 *audioChargingShot2 = [[sling1Player2 children] objectAtIndex:2];
                audioChargingShot2.playMode = kAudioNodeLoopProjectileCharging2;
                [audioChargingShot2 play];
                
                chargedShotTimeStarted2 = appSessionStartTime;
                NSLog (@"chargedShotTimeStarted2 in TouchBegan = %f", chargedShotTimeStarted2);
            }
        }
    }
    
    return TRUE;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
	touchLocationMoved = [touch locationInView: [touch view]];
	prevLocationMoved = [touch previousLocationInView: [touch view]];
    
	touchLocationMoved = [[CCDirector sharedDirector] convertToGL: touchLocationMoved];
	prevLocationMoved = [[CCDirector sharedDirector] convertToGL: prevLocationMoved];
    
    CGPoint diff = ccpSub(touchLocationMoved,prevLocationMoved);
    CGPoint currentPos = [parallaxNode position];
    
    CGPoint linedPaperTouchLocation = [linedPaper convertTouchToNodeSpace:touch];
    
    scaleCoefficient = 0.9;
    rightPanningBound = 150;
    leftPanningBound = -220;
    topPanningBound = -110;
    
    //If device is not running iOS6, shift the bottomPanningBound down a bit
    if (deviceIsRunningiOS6 == YES && userIsOnFastDevice) {
        
        bottomPanningBound = 75;
    }
    
    else {
        
        bottomPanningBound = 105;
    }
    
    if (deviceIsWidescreen) {
        
        rightPanningBound = 200;
    }
    
    
    
    if (isPlayer1 && firstPlayerHandicapCheckMarkButtonTouched) {
        
        if (linedPaperTouchLocation.x >= firstPlayerHandicapRightBorder.position.x) {
            
            firstPlayerHandicapCheckMarkButton.position = ccp(firstPlayerHandicapRightBorder.position.x, 30 + 150);
        }
        
        else if (linedPaperTouchLocation.x <= firstPlayerHandicapLeftBorder.position.x) {
            
            firstPlayerHandicapCheckMarkButton.position = ccp(firstPlayerHandicapLeftBorder.position.x, 30 + 150);
        }
        
        else {
            
            firstPlayerHandicapCheckMarkButton.position = ccp(linedPaperTouchLocation.x, 30 + 150);
        }
    }
    
    
    if (!isPlayer1 && secondPlayerHandicapCheckMarkButtonTouched) {
        
        if (linedPaperTouchLocation.x >= secondPlayerHandicapRightBorder.position.x) {
            
            secondPlayerHandicapCheckMarkButton.position = ccp(secondPlayerHandicapRightBorder.position.x, 30 + 150);
        }
        
        else if (linedPaperTouchLocation.x <= secondPlayerHandicapLeftBorder.position.x) {
            
            secondPlayerHandicapCheckMarkButton.position = ccp(secondPlayerHandicapLeftBorder.position.x, 30 + 150);
        }
        
        else {
            
            secondPlayerHandicapCheckMarkButton.position = ccp(linedPaperTouchLocation.x, 30 + 150);
        }
    }
    
    
    if (player1ProjectileHasBeenTouched == NO && player2ProjectileHasBeenTouched == NO && fieldZoomedOut == NO && isGo == YES && playersCanTouchMarblesNow == YES) {
        
        [parallaxNode setPosition: ccpAdd(currentPos, ccp(diff.x*1.2, diff.y*1.2))];
        
        //  [backgroundLayer setPosition: ccpAdd([backgroundLayer position], ccp(diff.x/2, diff.y/2))];
        
        if (parallaxNode.position.x <= (leftPanningBound*scaleCoefficient + leftPanningBound)) {
            [parallaxNode setPosition: ccp((leftPanningBound*scaleCoefficient + leftPanningBound), parallaxNode.position.y)];
            // [backgroundLayer setPosition: ccpAdd([backgroundLayer position], ccp(diff.x/2, diff.y/2))];
            // [backgroundLayer setPosition: ccp(-245/2,[backgroundLayer position].y)];
            leftPanLimitReached = YES;
        }
        
        if (parallaxNode.position.x >= (rightPanningBound*scaleCoefficient + rightPanningBound)) {
            [parallaxNode setPosition: ccp((rightPanningBound*scaleCoefficient + rightPanningBound), parallaxNode.position.y)];
            // [backgroundLayer setPosition: ccp(100/2,[backgroundLayer position].y)];
            // rightPanLimitReached = YES;
        }
        
        if (parallaxNode.position.y <= (topPanningBound*scaleCoefficient + topPanningBound)) {
            [parallaxNode setPosition: ccp(parallaxNode.position.x, (topPanningBound*scaleCoefficient + topPanningBound))];
            // [backgroundLayer setPosition: ccp([backgroundLayer position].x, -110/2)];
            // topPanLimitReached = YES;
        }
        
        if (parallaxNode.position.y >=(bottomPanningBound*scaleCoefficient + bottomPanningBound)) {
            [parallaxNode setPosition: ccp(parallaxNode.position.x, (bottomPanningBound*scaleCoefficient + bottomPanningBound))];
            // [backgroundLayer setPosition: ccp([backgroundLayer position].x, 60/2)];
            // bottomPanLimitReached = YES;
        }
    }
    
    
    if (player1ProjectileHasBeenTouched == YES) {
        
        ptPlayer1 = [zoombase convertTouchToNodeSpace:touch];
        bombPtPlayer1 = SLING_BOMB_POSITION;
        
        //Get the vector, angle, length, and normal vector of the touch
        CGPoint ptPlayer1Vector = ccpSub(ptPlayer1, bombPtPlayer1);
        normalVectorPlayer1 = ccpNormalize(ptPlayer1Vector);
        lengthPlayer1 = ccpLength(ptPlayer1Vector);
        // NSLog (@"ptPlayer1 = (%f, %f)", player1Vector.x, player1Vector.y);
        // NSLog (@"lengthPlayer1 = %f", lengthPlayer1);
        // NSLog (@"stretchingSlingSoundReady = %i", stretchingSlingSoundReady);
        
        /*     //Correct the Angle; we want a positive one
         while (angleDegs < 0)
         angleDegs += 360;
         */
        //Limit the length
        if (lengthPlayer1 > 25)
            lengthPlayer1 = 25;
        
        /*   //Limit the angle
         if (angleDegs > 245)
         normalVectorPlayer1 = ccpForAngle(CC_DEGREES_TO_RADIANS(245));
         else if (angleDegs < 110)
         normalVectorPlayer1 = ccpForAngle(CC_DEGREES_TO_RADIANS(110));
         */
        
        //  NSLog (@"player1Vector = (%f, %f)", player1Vector.x, player1Vector.y);
        
        //Set the position
        currentBombPostionPlayer1 = ccpAdd(bombPtPlayer1, ccpMult(normalVectorPlayer1, lengthPlayer1));
        _curBomb.position = currentBombPostionPlayer1;
        player1Vector = ccpSub(bombPtPlayer1, _curBomb.position);
        
        
        if (stretchingSlingSoundReady == YES && (lengthPlayer1 < 12)) {
            
            CDXAudioNodeSlingShot *audioStretchingSling = [[sling1 children] objectAtIndex:0];
            [audioStretchingSling play];
            //  NSLog (@"Stretching sling sound should be playing");
            
            stretchingSlingSoundReady = NO;
            [self resetStretchingSlingSoundReady];
        }
        
        [self sendMove];
    }
    
    
    if (player2ProjectileHasBeenTouched == YES) {
        
        ptPlayer2 = [zoombase convertTouchToNodeSpace:touch];
        bombPtPlayer2 = SLING_BOMB_POSITION_2;
        
        //Get the vector, angle, length, and normal vector of the touch
        CGPoint ptPlayer2Vector = ccpSub(ptPlayer2, bombPtPlayer2);
        normalVectorPlayer2 = ccpNormalize(ptPlayer2Vector);
        //float angleRads2 = ccpToAngle(normalVectorPlayer2);
        // int angleDegs = (int)CC_RADIANS_TO_DEGREES(angleRads2) % 360;
        lengthPlayer2 = ccpLength(ptPlayer2Vector);
        
        //Correct the Angle; we want a positive one
        //      while (angleDegs < 0)
        //        angleDegs += 360;
        
        //Limit the length
        if (lengthPlayer2 > 25)
            lengthPlayer2 = 25;
        
        //Limit the angle
        /*     if (angleDegs > 295)
         normalVector = ccpForAngle(CC_DEGREES_TO_RADIANS(295));
         else if (angleDegs < 70)
         normalVector = ccpForAngle(CC_DEGREES_TO_RADIANS(70));
         */
        //Set the position
        currentBombPostionPlayer2 = ccpAdd(bombPtPlayer2, ccpMult(normalVectorPlayer2, lengthPlayer2));
        _curBombPlayer2.position = currentBombPostionPlayer2;
        player2Vector = ccpSub(bombPtPlayer2, _curBombPlayer2.position);
        
        if (stretchingSling2SoundReady == YES && (lengthPlayer2 < 12)) {
            
            CDXAudioNodeSlingShot *audioStretchingSling = [[sling1Player2 children] objectAtIndex:0];
            [audioStretchingSling play];
            
            stretchingSling2SoundReady = NO;
            [self resetStretchingSling2SoundReady];
        }
        
        [self sendMove2];
    }
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (firstPlayerHandicapCheckMarkButtonTouched) {
        
        if (firstPlayerHandicapCheckMarkButton.position.x <= 40 + handicapLinesSpacing) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapLeftBorder.position.x, 30 + 150)]];
            handicapCoefficientPlayer1 = 1.0;
            player1HandicapInteger = 1;
        }
        
        else if (firstPlayerHandicapCheckMarkButton.position.x >= 40 + handicapLinesSpacing && firstPlayerHandicapCheckMarkButton.position.x < 62 + handicapLinesSpacing) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapFirstLine.position.x,  30 + 150)]];
            handicapCoefficientPlayer1 = 0.83;
            player1HandicapInteger = 2;
        }
        
        else if (firstPlayerHandicapCheckMarkButton.position.x >= 62 + handicapLinesSpacing && firstPlayerHandicapCheckMarkButton.position.x < 84 + handicapLinesSpacing) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapFirstLine.position.x, 30 + 150)]];
            handicapCoefficientPlayer1 = 0.83;
            player1HandicapInteger = 2;
        }
        
        else if (firstPlayerHandicapCheckMarkButton.position.x >= 84 + handicapLinesSpacing && firstPlayerHandicapCheckMarkButton.position.x < 106 + handicapLinesSpacing) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapSecondLine.position.x, 30 + 150)]];
            handicapCoefficientPlayer1 = 0.67;
            player1HandicapInteger = 3;
        }
        
        else if (firstPlayerHandicapCheckMarkButton.position.x >= 106 + handicapLinesSpacing && firstPlayerHandicapCheckMarkButton.position.x < 128 + handicapLinesSpacing) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapSecondLine.position.x, 30 + 150)]];
            handicapCoefficientPlayer1 = 0.67;
            player1HandicapInteger = 3;
        }
        
        else if (firstPlayerHandicapCheckMarkButton.position.x >= 128 + handicapLinesSpacing && firstPlayerHandicapCheckMarkButton.position.x <= 148 + handicapLinesSpacing) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapRightBorder.position.x, 30 + 150)]];
            handicapCoefficientPlayer1 = 0.5;
            player1HandicapInteger = 4;
        }
        
        firstPlayerHandicapCheckMarkButtonTouched = NO;
        [firstPlayerHandicapCheckMarkButton runAction: [CCScaleTo actionWithDuration:0.35 scale: 0.25]];
        [self sendPlayer1HandicapInteger];
    }
    

    if (!isPlayer1 && secondPlayerHandicapCheckMarkButtonTouched) {
        
        if (secondPlayerHandicapCheckMarkButton.position.x <= secondPlayerHandicapLeftBorder.position.x + 22 + handicapLinesSpacing) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapLeftBorder.position.x, 30 + 150)]];
            handicapCoefficientPlayer2 = 1.0;
            player2HandicapInteger = 1;
        }
        
        else if (secondPlayerHandicapCheckMarkButton.position.x >= secondPlayerHandicapLeftBorder.position.x + 22 + handicapLinesSpacing && secondPlayerHandicapCheckMarkButton.position.x < secondPlayerHandicapFirstLine.position.x + handicapLinesSpacing) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapFirstLine.position.x,  30 + 150)]];
            handicapCoefficientPlayer2 = 0.83;
            player2HandicapInteger = 2;
        }
        
        else if (secondPlayerHandicapCheckMarkButton.position.x >= secondPlayerHandicapFirstLine.position.x + handicapLinesSpacing && secondPlayerHandicapCheckMarkButton.position.x < secondPlayerHandicapFirstLine.position.x + 22 + handicapLinesSpacing) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapFirstLine.position.x, 30 + 150)]];
            handicapCoefficientPlayer2 = 0.83;
            player2HandicapInteger = 2;
        }
        
        else if (secondPlayerHandicapCheckMarkButton.position.x >= secondPlayerHandicapFirstLine.position.x + 22 + handicapLinesSpacing && secondPlayerHandicapCheckMarkButton.position.x < secondPlayerHandicapSecondLine.position.x + handicapLinesSpacing) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapSecondLine.position.x, 30 + 150)]];
            handicapCoefficientPlayer2 = 0.67;
            player2HandicapInteger = 3;
        }
        
        else if (secondPlayerHandicapCheckMarkButton.position.x >= secondPlayerHandicapSecondLine.position.x + handicapLinesSpacing && secondPlayerHandicapCheckMarkButton.position.x < secondPlayerHandicapSecondLine.position.x + 22 + handicapLinesSpacing) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapSecondLine.position.x, 30 + 150)]];
            handicapCoefficientPlayer2 = 0.67;
            player2HandicapInteger = 3;
        }
        
        else if (secondPlayerHandicapCheckMarkButton.position.x >= secondPlayerHandicapSecondLine.position.x + 22 + handicapLinesSpacing && secondPlayerHandicapCheckMarkButton.position.x <= 304 + handicapLinesSpacing) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapRightBorder.position.x, 30 + 150)]];
            handicapCoefficientPlayer2 = 0.5;
            player2HandicapInteger = 4;
        }
        
        secondPlayerHandicapCheckMarkButtonTouched = NO;
        [secondPlayerHandicapCheckMarkButton runAction: [CCScaleTo actionWithDuration:0.35 scale: 0.25]];
        [self sendPlayer2HandicapInteger];
    }
}

-(void) removeAndResetLightningPlayer1
{
    if (player1LightningExists) {
        
        player1LightningExists = NO;
        [lightning removeFromParentAndCleanup: YES];
    }
}

-(void) removeAndResetLightningPlayer2
{
    if (player2LightningExists) {
        
        player2LightningExists = NO;
        [lightning2 removeFromParentAndCleanup: YES];
    }
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (firstPlayerHandicapCheckMarkButtonTouched) {
        
        if (firstPlayerHandicapCheckMarkButton.position.x < 40 + handicapLinesSpacing) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapLeftBorder.position.x, 30 + 150)]];
            handicapCoefficientPlayer1 = 1.0;
            player1HandicapInteger = 1;
        }
        
        else if (firstPlayerHandicapCheckMarkButton.position.x >= 40 + handicapLinesSpacing && firstPlayerHandicapCheckMarkButton.position.x < 62 + handicapLinesSpacing) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapFirstLine.position.x,  30 + 150)]];
            handicapCoefficientPlayer1 = 0.83;
            player1HandicapInteger = 2;
        }
        
        else if (firstPlayerHandicapCheckMarkButton.position.x >= 62 + handicapLinesSpacing && firstPlayerHandicapCheckMarkButton.position.x < 84 + handicapLinesSpacing) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapFirstLine.position.x, 30 + 150)]];
            handicapCoefficientPlayer1 = 0.83;
            player1HandicapInteger = 2;
        }
        
        else if (firstPlayerHandicapCheckMarkButton.position.x >= 84 + handicapLinesSpacing && firstPlayerHandicapCheckMarkButton.position.x < 106 + handicapLinesSpacing) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapSecondLine.position.x, 30 + 150)]];
            handicapCoefficientPlayer1 = 0.67;
            player1HandicapInteger = 3;
        }
        
        else if (firstPlayerHandicapCheckMarkButton.position.x >= 106 + handicapLinesSpacing && firstPlayerHandicapCheckMarkButton.position.x < 128 + handicapLinesSpacing) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapSecondLine.position.x, 30 + 150)]];
            handicapCoefficientPlayer1 = 0.67;
            player1HandicapInteger = 3;
        }
        
        else if (firstPlayerHandicapCheckMarkButton.position.x >= 128 + handicapLinesSpacing) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapRightBorder.position.x, 30 + 150)]];
            handicapCoefficientPlayer1 = 0.5;
            player1HandicapInteger = 4;
        }
        
        firstPlayerHandicapCheckMarkButtonTouched = NO;
        [firstPlayerHandicapCheckMarkButton runAction: [CCScaleTo actionWithDuration:0.35 scale: 0.25]];
        [self sendPlayer1HandicapInteger];
    }
    
    
    if (!isPlayer1 && secondPlayerHandicapCheckMarkButtonTouched) {
        
        if (secondPlayerHandicapCheckMarkButton.position.x <= secondPlayerHandicapLeftBorder.position.x + 22 + handicapLinesSpacing) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapLeftBorder.position.x, 30 + 150)]];
            handicapCoefficientPlayer2 = 1.0;
            player2HandicapInteger = 1;
        }
        
        else if (secondPlayerHandicapCheckMarkButton.position.x >= secondPlayerHandicapLeftBorder.position.x + 22 + handicapLinesSpacing && secondPlayerHandicapCheckMarkButton.position.x < secondPlayerHandicapFirstLine.position.x + handicapLinesSpacing) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapFirstLine.position.x,  30 + 150)]];
            handicapCoefficientPlayer2 = 0.83;
            player2HandicapInteger = 2;
        }
        
        else if (secondPlayerHandicapCheckMarkButton.position.x >= secondPlayerHandicapFirstLine.position.x + handicapLinesSpacing && secondPlayerHandicapCheckMarkButton.position.x < secondPlayerHandicapFirstLine.position.x + 22 + handicapLinesSpacing) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapFirstLine.position.x, 30 + 150)]];
            handicapCoefficientPlayer2 = 0.83;
            player2HandicapInteger = 2;
        }
        
        else if (secondPlayerHandicapCheckMarkButton.position.x >= secondPlayerHandicapFirstLine.position.x + 22 + handicapLinesSpacing && secondPlayerHandicapCheckMarkButton.position.x < secondPlayerHandicapSecondLine.position.x + handicapLinesSpacing) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapSecondLine.position.x, 30 + 150)]];
            handicapCoefficientPlayer2 = 0.67;
            player2HandicapInteger = 3;
        }
        
        else if (secondPlayerHandicapCheckMarkButton.position.x >= secondPlayerHandicapSecondLine.position.x + handicapLinesSpacing && secondPlayerHandicapCheckMarkButton.position.x < secondPlayerHandicapSecondLine.position.x + 22 + handicapLinesSpacing) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapSecondLine.position.x, 30 + 150)]];
            handicapCoefficientPlayer2 = 0.67;
            player2HandicapInteger = 3;
        }
        
        else if (secondPlayerHandicapCheckMarkButton.position.x >= secondPlayerHandicapSecondLine.position.x + 22 + handicapLinesSpacing) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapRightBorder.position.x, 30 + 150)]];
            handicapCoefficientPlayer2 = 0.5;
            player2HandicapInteger = 4;
        }
        
        secondPlayerHandicapCheckMarkButtonTouched = NO;
        [secondPlayerHandicapCheckMarkButton runAction: [CCScaleTo actionWithDuration:0.35 scale: 0.25]];
        [self sendPlayer2HandicapInteger];
    }
    
    
    
    if (isPlayer1 && isGo == YES && player1ProjectileHasBeenTouched == YES) {
        
        if (player1SlingIsSmoking == YES) {
            
            player1SlingIsSmoking = NO;
            [self stopAction: player1ChargingSmoke];
            tesla.displacement = 35;
        }
        
        if (player1GiantSmokeCloudFrontOpacityIsIncreasing == YES) {
            
            //      [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.2], [CCCallFunc actionWithTarget:self selector:@selector(reduceBigSmokeCloudOpacity)], nil]];
            
            [self reduceBigSmokeCloudOpacity];
        }
    }
    
    if (!isPlayer1 && isGo == YES && player2ProjectileHasBeenTouched == YES) {
        
        if (player2SlingIsSmoking == YES) {
            
            player2SlingIsSmoking = NO;
            [self stopAction: player2ChargingSmoke];
            tesla2.displacement = 35;
        }
        
        
        if (player2GiantSmokeCloudFrontOpacityIsIncreasing == YES) {
            
            //    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.2], [CCCallFunc actionWithTarget:self selector:@selector(reducePlayer2BigSmokeCloudOpacity)], nil]];
            
            [self reducePlayer2BigSmokeCloudOpacity];
        }
    }
    
    
    /*
     NSLog (@"chargedShotTimeTotal = %f", chargedShotTimeTotal);
     NSLog (@"chargedShotTimeEnded = %f", chargedShotTimeEnded);
     NSLog (@"chargedShotTimeStarted = %f", chargedShotTimeStarted);
     NSLog (@"blockingChargeBonusPlayer1 = %i", blockingChargeBonusPlayer1);
     NSLog (@"skillLevelBonus = %i", skillLevelBonus);
     NSLog (@"projectileChargingPitchPlayer1 = %i", projectileChargingPitchPlayer1);
     NSLog (@"lineArcValue = %f", lineArcValue);
     
     NSLog (@"chargedShotTimeTotal2 = %f", chargedShotTimeTotal2);
     NSLog (@"chargedShotTimeEnded2 = %f", chargedShotTimeEnded2);
     NSLog (@"chargedShotTimeStarted2 = %f", chargedShotTimeStarted2);
     NSLog (@"blockingChargeBonusPlayer2 = %i", blockingChargeBonusPlayer2);
     NSLog (@"projectileChargingPitchPlayer2 = %i", projectileChargingPitchPlayer2);
     NSLog (@"lineArcValue = %f", lineArcValue2);
     */
    /*
     if (isPlayer1 && player1LightningExists == YES && playersCanTouchMarblesNow == YES) {
     
     player1LightningExists = NO;
     [lightning removeFromParentAndCleanup: YES];
     }
     
     if (!isPlayer1 && player2LightningExists == YES && playersCanTouchMarblesNow == YES) {
     
     player2LightningExists = NO;
     [lightning2 removeFromParentAndCleanup: YES];
     }
     */
    /*
     if (isPlayer1) {
     
     [self sendBlocksPositionsFromPlayer1];
     }
     
     if (!isPlayer1) {
     
     [self sendBlockNumbersFromPlayer2];
     }
     */
    
    if (player1ProjectileHasBeenTouched == YES && isGo == YES) {
        
        gertySlotAnimationIsRunning = NO;
        [self stopAction: player1SlotMachineAnimation];
        
        //  [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber25 sourceGroupId:0 pitch:1.0f pan:0.2 gain:0.25 loop:YES];
        
        [[CDAudioManager sharedManager].soundEngine stopSound:audioSlotMachineSpinning];
        
        //Play the slotdone.caf sound 3 times to coincide with the blinking marble on Gerty's screen
        [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(playSlotDoneAudio)],[CCDelayTime actionWithDuration:0.15], [CCCallFunc actionWithTarget:self selector:@selector(playSlotDoneAudio)],[CCDelayTime actionWithDuration:0.15],[CCCallFunc actionWithTarget:self selector:@selector(playSlotDoneAudio)], nil]];
        
        
        //This is a poll that will tell the computer to launch when player launches if a BOOL is true
        if (isSinglePlayer == YES && computerWillLaunchWhenPlayerLaunches == YES && player2BombInPlay == YES) {
            
            if (difficultyLevel == 0 || difficultyLevel == 1) {
                
                int randomTime = arc4random()%61;
                
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: (randomTime/100 + 1)], [CCCallFunc actionWithTarget:self selector:@selector(artificialIntelligenceLaunchMarbleMethod)], nil]];
                
                computerWillLaunchWhenPlayerLaunches = NO;
            }
            
            if (difficultyLevel >= 2) {
                
                if (player1HasYellowBall == YES) {
                    
                    int randomTime = arc4random()%21;
                    
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: (randomTime/100 + 0.4)], [CCCallFunc actionWithTarget:self selector:@selector(artificialIntelligenceLaunchMarbleMethod)], nil]];
                    
                    computerWillLaunchWhenPlayerLaunches = NO;
                }
                
                else if (player1HasYellowBall == NO) {
                    
                    int randomTime = arc4random()%61;
                    
                    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: (randomTime/100 + 1)], [CCCallFunc actionWithTarget:self selector:@selector(artificialIntelligenceLaunchMarbleMethod)], nil]];
                    
                    computerWillLaunchWhenPlayerLaunches = NO;
                }
            }
        }
        
        [self zoomOut];
        
        player1ProjectileHasBeenTouched = NO;
        
        // followPlayer1Marble = [[CCFollow actionWithTarget:bomb worldBoundary:CGRectMake(-60,-115,2000,1000)]retain];
        // [parallaxNode runAction: followPlayer1Marble];
        
        receivingChargingDataFromPlayer1 = NO;
        
        player1Vector = ccpSub(SLING_BOMB_POSITION, _curBomb.position);
        
        if (_curBomb) {
            
            [zoombase runAction: [CCMoveTo actionWithDuration:0.15 position: ccp(-39,-24)]];
            
            if (!isSinglePlayer) {
                
                audioPreLaunchCharge = [[sling1 children] objectAtIndex:3];
                [audioPreLaunchCharge play];
            }
            
            chargedShotTimeEnded = appSessionStartTime;
            
            chargedShotTimeTotal = chargedShotTimeEnded - chargedShotTimeStarted + blockingChargeBonusPlayer1 + skillLevelBonus*3;
            
            
            if (chargedShotTimeTotal >= 0.0 && chargedShotTimeTotal < 2.999999) {
                
                projectileImpulsePlayer1 = handicapCoefficientPlayer1*(240);
                
                if (skillLevelBonus == 0) {
                    
                    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = NO;
                    teslaGlow1.opacity = 0;
                    [self sendTeslaGlowOff];
                }
            }
            
            if (chargedShotTimeTotal >= 3.0 && chargedShotTimeTotal < 5.999999) {
                
                projectileImpulsePlayer1 = handicapCoefficientPlayer1*(CHARGING_COEFFICIENT_STEP_1*240 + 240);
                projectileLaunchMultiplier = 1;
                
                if (skillLevelBonus == 1) {
                    
                    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = NO;
                    teslaGlow1.opacity = 0;
                    [self sendTeslaGlowOff];
                }
            }
            
            if (chargedShotTimeTotal >= 6.0 && chargedShotTimeTotal < 8.999999) {
                
                projectileImpulsePlayer1 = handicapCoefficientPlayer1*(CHARGING_COEFFICIENT_STEP_2*240 + 240);
                projectileLaunchMultiplier = 2;
                
                if (skillLevelBonus == 2) {
                    
                    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = NO;
                    teslaGlow1.opacity = 0;
                    [self sendTeslaGlowOff];
                }
            }
            
            if (chargedShotTimeTotal >= 9.0 && skillLevelBonus == 0) {
                
                projectileImpulsePlayer1 = handicapCoefficientPlayer1*(CHARGING_COEFFICIENT_STEP_3*240 + 240);
                projectileLaunchMultiplier = 3;
            }
            
            if ((chargedShotTimeTotal >= 9.0 && chargedShotTimeTotal < 11.999999) && (skillLevelBonus == 1 || skillLevelBonus == 2)) {
                
                projectileImpulsePlayer1 = handicapCoefficientPlayer1*(CHARGING_COEFFICIENT_STEP_3*240 + 240);
                projectileLaunchMultiplier = 3;
            }
            
            if (chargedShotTimeTotal >= 12.0 && skillLevelBonus == 1) {
                
                projectileImpulsePlayer1 = handicapCoefficientPlayer1*(CHARGING_COEFFICIENT_STEP_4*240 + 240);
                projectileLaunchMultiplier = 4;
            }
            
            if ((chargedShotTimeTotal >= 12.0 && chargedShotTimeTotal < 14.999999) && (skillLevelBonus == 2)) {
                
                projectileImpulsePlayer1 = handicapCoefficientPlayer1*(CHARGING_COEFFICIENT_STEP_4*240 + 240);
                projectileLaunchMultiplier = 4;
            }
            
            if (chargedShotTimeTotal >= 15.0 && skillLevelBonus == 2) {
                
                projectileImpulsePlayer1 = handicapCoefficientPlayer1*(CHARGING_COEFFICIENT_STEP_5*240 + 240);
                projectileLaunchMultiplier = 5;
            }
            
            //delay time for 1.5s then launch marble here
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: prelaunchDelayTime], [CCCallFunc actionWithTarget:self selector:@selector(launchMarbleInTouchEnded)], nil]];
            
            marble1RotationalVelocity = arc4random()%5;
            
            [audioChargingShot stop];
            
            if (isGo == YES) {
                
                [self sendLaunchProjectile];
                [self sendAudioProjectileLaunch];
                [self sendAudioIncomingProjectile];
            }
            
            guideLineIsBlinking = NO;
            
            if (guideLineIsBlinking == YES) {
                
                [self stopAction: guideLineBlinkingAction];
            }
            
            if (blockingChargeBonusPlayer1 > 0) {
                
                blockingChargeBonusPlayer1 = 0;
            }
        }
        
        [self displaySelectedSlotMachineBombOnGertyGameMethod];
    }
    
    if (player2ProjectileHasBeenTouched == YES && isGo == YES) {
        
        gerty2SlotAnimationIsRunning = NO;
        [self stopAction: player2SlotMachineAnimation];
        
        [[CDAudioManager sharedManager].soundEngine stopSound:audioSlotMachineSpinningPlayer2];
        
        //Play the slotdone.caf sound 3 times to coincide with the blinking marble on Gerty's screen
        [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(playSlotDoneAudioPlayer2)],[CCDelayTime actionWithDuration:0.15], [CCCallFunc actionWithTarget:self selector:@selector(playSlotDoneAudioPlayer2)],[CCDelayTime actionWithDuration:0.15],[CCCallFunc actionWithTarget:self selector:@selector(playSlotDoneAudioPlayer2)], nil]];
        
        [self zoomOut];
        
        if (!isSinglePlayer) {
            
            audioPreLaunchCharge2 = [[sling1Player2 children] objectAtIndex:3];
            [audioPreLaunchCharge2 play];
        }
        
        receivingChargingDataFromPlayer2 = NO;
        
        player2Vector = ccpSub(SLING_BOMB_POSITION_2, _curBombPlayer2.position);
        
        if (_curBombPlayer2) {
            
            [zoombase runAction: [CCMoveTo actionWithDuration:0.15 position: ccp(-39,-24)]];
            
            chargedShotTimeEnded2 = appSessionStartTime;
            
            chargedShotTimeTotal2 = chargedShotTimeEnded2 - chargedShotTimeStarted2 + blockingChargeBonusPlayer2 + skillLevelBonus*3;
            
            if (chargedShotTimeTotal2 >= 0.0 && chargedShotTimeTotal2 < 2.999999) {
                
                projectileImpulsePlayer2 = handicapCoefficientPlayer2*240;
                projectileLaunchMultiplier2 = 0;
                
                if (skillLevelBonus == 0) {
                    
                    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = NO;
                    teslaGlow2.opacity = 0;
                    [self sendTeslaGlowOff];
                }
            }
            
            if (chargedShotTimeTotal2 >= 3.0 && chargedShotTimeTotal2 < 5.999999) {
                
                projectileImpulsePlayer2 = handicapCoefficientPlayer2*(CHARGING_COEFFICIENT_STEP_1*240 + 240);
                projectileLaunchMultiplier2 = 1;
                
                if (skillLevelBonus == 1) {
                    
                    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = NO;
                    teslaGlow2.opacity = 0;
                    [self sendTeslaGlowOff];
                }
            }
            
            if (chargedShotTimeTotal2 >= 6.0 && chargedShotTimeTotal2 < 8.999999) {
                
                projectileImpulsePlayer2 = handicapCoefficientPlayer2*(CHARGING_COEFFICIENT_STEP_2*240 + 240);
                projectileLaunchMultiplier2 = 2;
                
                if (skillLevelBonus == 2) {
                    
                    doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = NO;
                    teslaGlow2.opacity = 0;
                    [self sendTeslaGlowOff];
                }
            }
            
            if (chargedShotTimeTotal2 >= 9.0 && skillLevelBonus == 0) {
                
                projectileImpulsePlayer2 = handicapCoefficientPlayer2*(CHARGING_COEFFICIENT_STEP_3*240 + 240);
                projectileLaunchMultiplier2 = 3;
            }
            
            if ((chargedShotTimeTotal2 >= 9.0 && chargedShotTimeTotal2 < 11.999999) && (skillLevelBonus == 1 || skillLevelBonus == 2)) {
                
                projectileImpulsePlayer2 = handicapCoefficientPlayer2*(CHARGING_COEFFICIENT_STEP_3*240 + 240);
                projectileLaunchMultiplier2 = 3;
            }
            
            if (chargedShotTimeTotal2 >= 12.0 && skillLevelBonus == 1) {
                
                projectileImpulsePlayer2 = handicapCoefficientPlayer2*(CHARGING_COEFFICIENT_STEP_4*240 + 240);
                projectileLaunchMultiplier2 = 4;
            }
            
            if ((chargedShotTimeTotal2 >= 12.0 && chargedShotTimeTotal2 < 14.999999) && (skillLevelBonus == 2)) {
                
                projectileImpulsePlayer2 = handicapCoefficientPlayer2*(CHARGING_COEFFICIENT_STEP_4*240 + 240);
                projectileLaunchMultiplier2 = 4;
            }
            
            if (chargedShotTimeTotal2 >= 15.0 && skillLevelBonus == 2) {
                
                projectileImpulsePlayer2 = handicapCoefficientPlayer2*(CHARGING_COEFFICIENT_STEP_5*240 + 240);
                projectileLaunchMultiplier2 = 5;
            }
            
            
            //delay time for 1.5s then launch marble here
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: prelaunchDelayTime], [CCCallFunc actionWithTarget:self selector:@selector(launchMarbleInTouchEnded)], nil]];
            
            marble2RotationalVelocity = arc4random()%5;
            
            [audioChargingShot2 stop];
            
            player2ProjectileHasBeenTouched = NO;
            
            if (isGo == YES) {
                
                [self sendLaunchProjectile2];
                [self sendAudioProjectileLaunch];
                [self sendAudioIncomingProjectile];
            }
            
            guideLineIsBlinking = NO;
            
            if (guideLineIsBlinking == YES) {
                
                [self stopAction: guideLineBlinkingAction];
            }
            
            if (blockingChargeBonusPlayer2 > 0) {
                
                blockingChargeBonusPlayer2 = 0;
            }
            
            //projectileLaunchMultiplier2 = 0;
        }
        
        [self displaySelectedSlotMachineBombOnGerty2GameMethod];
    }
    
    NSLog (@"projectileImpulsePlayer1 = %i", projectileImpulsePlayer1);
    NSLog (@"projectileImpulsePlayer2 = %i", projectileImpulsePlayer2);
}



- (void)draw {
	
    [super draw];
    
    if (player1ProjectileHasBeenTouched == YES) {
        
        //CGPoint vector = ccpSub(ccp(60,166), _curBomb.position);
        
        for (float i = 1.0/20.0; i < 10; i = i + 1.0/20.0) {
            
            //float x = vector.x*8*i*guidePathDivisorPlayer1X;
            //float y = (vector.y*8*i - (-smgr.space->gravity.y)*(i*i)/guidePathDivisorPlayer1Y);
            
            float x;
            float y;
            
            if (deviceIsWidescreen) {
            
                x = (0.87)*player1Vector.x*((lineArcValue)/30)*i;
                y = (0.8)*(player1Vector.y*((lineArcValue)/30)*i - ((-smgr.space->gravity.y)*(i*i))/2);
            }
            
            else if (!deviceIsWidescreen) {
                
                x = (0.8)*player1Vector.x*((lineArcValue)/30)*i;
                y = (0.8)*(player1Vector.y*((lineArcValue)/30)*i - ((-smgr.space->gravity.y)*(i*i))/2);
            }
            
            glPointSize(glPointSizeValuePlayer1);
            glColor4ub(glColorRedPlayer1, glColorGreenPlayer1, glColorBluePlayer1, glColorAlphaPlayer1);
            
            CGPoint currentBombPositionConverted = [zoombase convertToWorldSpace:_curBomb.position];
            
            if (y > -150)
                ccDrawCircle((ccp(currentBombPositionConverted.x + x, currentBombPositionConverted.y + y)), glPointSizeValuePlayer1/2.7, 0, 10, NO);
        }
    }
    
    if (player2ProjectileHasBeenTouched == YES) {
        
        //CGPoint vector = ccpSub(ccp(525,166), _curBombPlayer2.position);
        
        for (float i = 1.0/20.0; i < 10; i = i + 1.0/20.0) {
            
            float x;
            float y;
            
            if (deviceIsWidescreen) {
            
                x = (0.87)*player2Vector.x*((lineArcValue2)/30)*i;
                y = (0.8)*(player2Vector.y*((lineArcValue2)/30)*i - ((-smgr.space->gravity.y)*(i*i))/2);
            }
            
            else if (!deviceIsWidescreen) {
                
                x = (0.8)*player2Vector.x*((lineArcValue2)/30)*i;
                y = (0.8)*(player2Vector.y*((lineArcValue2)/30)*i - ((-smgr.space->gravity.y)*(i*i))/2);
            }
            
            glPointSize(glPointSizeValuePlayer2);
            glColor4ub(glColorRedPlayer2,glColorGreenPlayer2,glColorBluePlayer2,glColorAlphaPlayer2);
            // tesla2.color = ccc3(glColorRedPlayer1, glColorGreenPlayer1, glColorBluePlayer1);
            
            CGPoint currentBombPositionConverted = [zoombase convertToWorldSpace:_curBombPlayer2.position];
            
            if (y > -150)
                ccDrawCircle((ccp(currentBombPositionConverted.x + x, currentBombPositionConverted.y + y)), glPointSizeValuePlayer2/2.7, 0, 10, NO);
        }
    }
}


-(void) bonusPointPopUp: (CGPoint) position
{
    if ((isPlayer1 && destroyedBlocksInARow1 == 2) || (!isPlayer1 && destroyedBlocksInARow2 == 2)) {
        
        CCSprite *bonusOnePoint = [CCLabelBMFont labelWithString:@"+1" fntFile:@"GertyLevel.fnt"];
        CCSprite *bonusOnePointShadow = [CCLabelBMFont labelWithString:@"+1" fntFile:@"GertyLevel.fnt"];
        
        bonusOnePoint.color = ccYELLOW;
        bonusOnePoint.position = position;
        bonusOnePoint.anchorPoint = ccp(0.5, 0.5);
        bonusOnePoint.scale = 0.9;
        [bonusOnePoint setOpacity: 185];
        
        bonusOnePointShadow.color = ccYELLOW;
        bonusOnePointShadow.position = position;
        bonusOnePointShadow.anchorPoint = ccp(0.5, 0.5);
        bonusOnePointShadow.scale = 0.9;
        [bonusOnePointShadow setOpacity: 185];
        
        [zoombase addChild: bonusOnePoint z:100];
        [zoombase addChild: bonusOnePointShadow z:100];
        
        [bonusOnePointShadow runAction: [CCScaleBy actionWithDuration:0.7 scale:2.5]];
        [bonusOnePointShadow runAction: [CCSequence actions: [CCFadeOut actionWithDuration:0.7], [CCCallFuncND actionWithTarget:bonusOnePointShadow selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], nil]];
        
        [bonusOnePoint runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.5], [CCFadeOut actionWithDuration: 1.0], nil]];
        [bonusOnePoint runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.1], [CCScaleBy actionWithDuration: 1.0 scale: 0.5], nil]];
    }
    
    else if ((isPlayer1 && destroyedBlocksInARow1 >= 3) || (!isPlayer1 && destroyedBlocksInARow2 >= 3)) {
        
        CCSprite *bonusTwoPoints = [CCLabelBMFont labelWithString:@"+2" fntFile:@"GertyLevel.fnt"];
        CCSprite *bonusTwoPointsShadow = [CCLabelBMFont labelWithString:@"+2" fntFile:@"GertyLevel.fnt"];
        
        bonusTwoPoints.color = ccYELLOW;
        bonusTwoPoints.position = position;
        bonusTwoPoints.anchorPoint = ccp(0.5, 0.5);
        bonusTwoPoints.scale = 0.9;
        [bonusTwoPoints setOpacity: 185];
        
        bonusTwoPointsShadow.color = ccYELLOW;
        bonusTwoPointsShadow.position = position;
        bonusTwoPointsShadow.anchorPoint = ccp(0.5, 0.5);
        bonusTwoPointsShadow.scale = 0.9;
        [bonusTwoPointsShadow setOpacity: 185];
        
        [zoombase addChild: bonusTwoPoints z:100];
        [zoombase addChild: bonusTwoPointsShadow z:100];
        
        [bonusTwoPointsShadow runAction: [CCScaleBy actionWithDuration:0.7 scale:2.5]];
        [bonusTwoPointsShadow runAction: [CCSequence actions: [CCFadeOut actionWithDuration:0.7], [CCCallFuncND actionWithTarget:bonusTwoPointsShadow selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], nil]];
        
        [bonusTwoPoints runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.5], [CCFadeOut actionWithDuration: 1.0], nil]];
        [bonusTwoPoints runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.1], [CCScaleBy actionWithDuration: 1.0 scale: 0.5], nil]];
    }
}

-(void) playDestroyedBlockBonusSound1
{
    [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber14 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
}

-(void) playDestroyedBlockBonusSound2
{
    [[CDAudioManager sharedManager].soundEngine playSound:sling1SourceIDNumber15 sourceGroupId:0 pitch:1.0f pan:0.5 gain:0.5 loop:NO];
}

-(void) setupMarblesAndBlocks
{
    if (isSinglePlayer) {
        
        NSLog (@"setupMarblesAndBlocks method called and it's SinglePlayer");
        
        [self setupShapes];
        
        [self addFlameToPlayer1Marble];
        [self addFlameToPlayer2Marble];
        
        [self setupBombsPlayer1];
        [self setupNextBombPlayer1];
        
        [self setupBombsPlayer2];
        [self setupNextBombPlayer2];
        
        [self setupGertyPlayer1];
        [self setupGertyPlayer2];
        
        [self setupBackground];
    }
    
    else if (!isSinglePlayer) {
        
        [self setupShapes];
        
        [self addFlameToPlayer1Marble];
        [self addFlameToPlayer2Marble];
        
        [self setupBombsPlayer1];
        [self setupNextBombPlayer1];
        
        [self setupBombsPlayer2];
        [self setupNextBombPlayer2];
        
        [self setupBackground];
    }
}

- (void) setupBackground
{
    //Sling for Player 1
	sling1 = [CCSprite spriteWithSpriteFrameName:@"sling1-hd.png"];
	sling2 = [CCSprite spriteWithSpriteFrameName:@"sling2-hd.png"];
    sling1Stem = [CCSprite spriteWithSpriteFrameName:@"slingStem-hd.png"];
	
    sling1.position = SLING_POSITION;
	sling2.position = ccp(SLING_POSITION.x + 5, SLING_POSITION.y + 10);
    sling1Stem.position = ccp(SLING_POSITION.x + 4.2, SLING_POSITION.y - 201.1);
    sling1SourceIDNumber = player2BombSourceIDNumber + 2;
    sling1SourceIDNumber2 = player2BombSourceIDNumber + 3;
    sling1SourceIDNumber3 = player2BombSourceIDNumber + 4;
    sling1SourceIDNumber4 = player2BombSourceIDNumber + 5;
    sling1SourceIDNumber5 = player2BombSourceIDNumber + 6;
    sling1SourceIDNumber6 = player2BombSourceIDNumber + 7;
    sling1SourceIDNumber7 = player2BombSourceIDNumber + 8;
    sling1SourceIDNumber8 = player2BombSourceIDNumber + 9;
    sling1SourceIDNumber9 = player2BombSourceIDNumber + 10;
    sling1SourceIDNumber10 = player2BombSourceIDNumber + 11;
    sling1SourceIDNumber11 = player2BombSourceIDNumber + 12;
    sling1SourceIDNumber12 = player2BombSourceIDNumber + 13;
    sling1SourceIDNumber13 = player2BombSourceIDNumber + 14;
    sling1SourceIDNumber14 = player2BombSourceIDNumber + 15;
    sling1SourceIDNumber15 = player2BombSourceIDNumber + 16;
    sling1SourceIDNumber16 = player2BombSourceIDNumber + 17;
    sling1SourceIDNumber17 = player2BombSourceIDNumber + 18;
    sling1SourceIDNumber18 = player2BombSourceIDNumber + 19;
    sling1SourceIDNumber19 = player2BombSourceIDNumber + 20;
    sling1SourceIDNumber20 = player2BombSourceIDNumber + 21;
    sling1SourceIDNumber21 = player2BombSourceIDNumber + 22;
    sling1SourceIDNumber22 = player2BombSourceIDNumber + 23;
    sling1SourceIDNumber23 = player2BombSourceIDNumber + 24;
    sling1SourceIDNumber24 = player2BombSourceIDNumber + 25;
    sling1SourceIDNumber25 = player2BombSourceIDNumber + 26;
    sling1SourceIDNumber26 = player2BombSourceIDNumber + 27;
    sling1SourceIDNumber27 = player2BombSourceIDNumber + 28;
    sling1SourceIDNumber28 = player2BombSourceIDNumber + 29;
    sling1SourceIDNumber29 = player2BombSourceIDNumber + 30;
    sling1SourceIDNumber30 = player2BombSourceIDNumber + 31;
    
    
    
    sling2SourceIDNumber = player2BombSourceIDNumber + 32;
    sling2SourceIDNumber2 = player2BombSourceIDNumber + 33;
    sling2SourceIDNumber3 = player2BombSourceIDNumber + 34;
    sling2SourceIDNumber4 = player2BombSourceIDNumber + 35;
    
    
    tesla = [Tesla teslaWithNode: sling2];
    tesla.position = ccp(sling1.position.x - 5, sling1.position.y + 7);
    
    [zoombase addChild:sling1 z:16];
    [zoombase addChild:sling2 z:1];
    [zoombase addChild: sling1Stem z:16];
    [zoombase addChild:tesla z:6];
    
    
    //Load sound buffers asynchrounously
    loadRequests = [[[NSMutableArray alloc] init] autorelease];
    
    /**
     Here we set up an array of sounds to load
     Each CDBufferLoadRequest takes an integer as an identifier (to call later)
     and the file path.  Pretty straightforward here.
     */
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber7 filePath:@"WindChimes.caf"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber8 filePath:@"KidsPlayingInTheDistance.caf"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber9 filePath:@"PassingCar.caf"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber10 filePath:@"DogBarking1.caf"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber11 filePath:@"DogBarking2.caf"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber12 filePath:@"DogBarking3.caf"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber13 filePath:@"LightAircraftPassingBy.caf"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber14 filePath:@"BonusDestroyedBlock1.caf"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber15 filePath:@"BonusDestroyedBlock2.caf"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber16 filePath:@"BonusBlock.caf"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber17 filePath:@"CountDownBlip.caf"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber18 filePath:@"StrikingSteel.caf"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber19 filePath:@"ExperiencePointDing.wav"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber20 filePath:@"LevelUpAngelsSound.wav"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber21 filePath:@"Swoosh.wav"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber22 filePath:@"MouseClick.wav"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber23 filePath:@"GertyGridSlide.wav"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber24 filePath:@"Buzzer.wav"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber26 filePath:@"slotrunning.wav"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber27 filePath:@"slotdone.wav"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber28 filePath:@"slotrunning.wav"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber29 filePath:@"slotdone.wav"] autorelease]];
    [loadRequests addObject:[[[CDBufferLoadRequest alloc] init:sling1SourceIDNumber30 filePath:@"crickets.wav"] autorelease]];
    
    [soundEngine loadBuffersAsynchronously:loadRequests];
    
    
    
    audioStretchingSling = [CDXAudioNodeSlingShot audioNodeWithFile:@"StretchingSling.caf" soundEngine:soundEngine sourceId:sling1SourceIDNumber];
    [sling1 addChild:audioStretchingSling];
    audioProjectileLaunch = [CDXAudioNode audioNodeWithFile:@"ProjectileLaunch.caf" soundEngine:soundEngine sourceId:sling1SourceIDNumber2];
    [sling1 addChild:audioProjectileLaunch];
    audioChargingShot = [CDXAudioNodeProjectileCharging audioNodeWithFile:@"ChargingShot.caf" soundEngine:soundEngine sourceId:sling1SourceIDNumber3];
    [sling1 addChild:audioChargingShot];
    audioPreLaunchCharge = [CDXAudioNode audioNodeWithFile:@"PreLaunchCharge.caf" soundEngine:soundEngine sourceId:sling1SourceIDNumber25];
    [sling1 addChild:audioPreLaunchCharge];
    
    bombExplosionPlayer1 = [CCSprite spriteWithSpriteFrameName: @"bombexplosion-hd.png"];
    [zoombase addChild: bombExplosionPlayer1 z:6];
    bombExplosionPlayer1.position = ccp(-300,-300);
    [bombExplosionPlayer1 runAction: [CCFadeOut actionWithDuration: 0.0]];
    audioBombExplosionPlayer1 = [CDXAudioNode audioNodeWithFile:@"BlackBombExploding.caf" soundEngine:soundEngine sourceId:sling1SourceIDNumber5];
    [bombExplosionPlayer1 addChild:audioBombExplosionPlayer1];
    
    
    bombExplosionPlayer2 = [CCSprite spriteWithSpriteFrameName: @"bombexplosion-hd.png"];
    [zoombase addChild: bombExplosionPlayer2 z:6];
    bombExplosionPlayer2.position = ccp(-300,-300);
    [bombExplosionPlayer2 runAction: [CCFadeOut actionWithDuration: 0.0]];
    [bombExplosionPlayer1 runAction: [CCFadeOut actionWithDuration: 0.0]];
    audioBombExplosionPlayer2 = [CDXAudioNode audioNodeWithFile:@"BlackBombExploding.caf" soundEngine:soundEngine sourceId:sling1SourceIDNumber6];
    [bombExplosionPlayer2 addChild:audioBombExplosionPlayer2];
    
    
    
    //Sling for Player 2
	sling1Player2 = [CCSprite spriteWithSpriteFrameName:@"sling1-hd.png"];
	sling2Player2 = [CCSprite spriteWithSpriteFrameName:@"sling2-hd.png"];
    sling2Stem = [CCSprite spriteWithSpriteFrameName:@"slingStem-hd.png"];
    sling1Player2.flipX = YES;
    sling2Player2.flipX = YES;
    sling2Stem.flipX = YES;
    sling1Player2.scaleY = 1.0;
    sling2Player2.scaleY = 1.0;
	
    sling1Player2.position = SLING_POSITION_2;
	sling2Player2.position = ccp(SLING_POSITION_2.x - 5, SLING_POSITION_2.y + 10);
    //    sling1Stem.position = ccp(SLING_POSITION.x + 4.2, SLING_POSITION.y - 201.1);
    
    sling2Stem.position = ccp(SLING_POSITION_2.x - 4.2, SLING_POSITION_2.y - 201.1);
    
    NSLog (@"sling2SourceIDNumber = %i", sling2SourceIDNumber);
    NSLog (@"sling2SourceIDNumber2 = %i", sling2SourceIDNumber2);
    
    tesla2 = [Tesla teslaWithNode: sling2Player2];
    tesla2.position = ccp(sling1Player2.position.x + 5, sling1Player2.position.y + 7);
    
    [zoombase addChild:sling1Player2 z:16];
    [zoombase addChild:sling2Player2 z:1];
    [zoombase addChild:sling2Stem z:16];
    [zoombase addChild: tesla2 z:6];
    
    
    audioStretchingSling = [CDXAudioNodeSlingShot audioNodeWithFile:@"StretchingSling.caf" soundEngine:soundEngine sourceId:sling2SourceIDNumber];
    [sling1Player2 addChild:audioStretchingSling];
    audioProjectileLaunch = [CDXAudioNode audioNodeWithFile:@"ProjectileLaunch.caf" soundEngine:soundEngine sourceId:sling2SourceIDNumber2];
    [sling1Player2 addChild:audioProjectileLaunch];
    audioChargingShot2 = [CDXAudioNodeProjectileCharging2 audioNodeWithFile:@"ChargingShot.caf" soundEngine:soundEngine sourceId:sling2SourceIDNumber3];
    //audioChargingShot.playMode = kAudioNodeLoop;
    [sling1Player2 addChild:audioChargingShot2];
    audioPreLaunchCharge2 = [CDXAudioNode audioNodeWithFile:@"PreLaunchCharge.caf" soundEngine:soundEngine sourceId:sling1SourceIDNumber4];
    [sling1Player2 addChild:audioPreLaunchCharge2];
    
    
    NSLog (@"sourceIDNumber = %i", sourceIDNumber);
    NSLog (@"player2BombSourceIDNumber = %i", player2BombSourceIDNumber);
    NSLog (@"sling1SourceIDNumber = %i", sling1SourceIDNumber);
    NSLog (@"sling2SourceIDNumber = %i", sling2SourceIDNumber);
    NSLog (@"sling1SourceIDNumber2 = %i", sling1SourceIDNumber2);
    NSLog (@"sling2SourceIDNumber2 = %i", sling2SourceIDNumber2);
    NSLog (@"sling1SourceIDNumber3 = %i", sling1SourceIDNumber3);
}

-(void) gertyMainMenuUpdateLights
{
    [player1LevelLabelMainMenu setString:[NSString stringWithFormat:@"Rank: %i", player1Level/100]];
    [player1ExperiencePointsLabelMainMenu setString:[NSString stringWithFormat:@"%i%%", player1ExperiencePoints]];
    
    NSLog(@"Running gertyMainMenuUpdateLights");
    
    if (player1MarblesUnlocked == 0) {
        
        ledBulb1MainMenu.color = ccGREEN;
        ledBulb2MainMenu.color = ccc3(255, 192, 203);
        ledBulb3MainMenu.color = ccc3(255, 192, 203);
        ledBulb4MainMenu.color = ccc3(255, 192, 203);
        ledBulb5MainMenu.color = ccc3(255, 192, 203);
        
        
        ledLight2MainMenu.opacity = 0;
        ledLight3MainMenu.opacity = 0;
        ledLight4MainMenu.opacity = 0;
        ledLight5MainMenu.opacity = 0;
        NSLog (@"only green LED should show");
    }
    
    else if (player1MarblesUnlocked == 1) {
        
        ledBulb1MainMenu.color = ccGREEN;
        ledBulb2MainMenu.color = ccc3(30, 144, 255);
        ledBulb3MainMenu.color = ccc3(255, 192, 203);
        ledBulb4MainMenu.color = ccc3(255, 192, 203);
        ledBulb5MainMenu.color = ccc3(255, 192, 203);
        
        ledLight2MainMenu.opacity = 255;
        ledLight3MainMenu.opacity = 0;
        ledLight4MainMenu.opacity = 0;
        ledLight5MainMenu.opacity = 0;
    }
    
    else if (player1MarblesUnlocked == 2) {
        
        ledBulb1MainMenu.color = ccGREEN;
        ledBulb2MainMenu.color = ccc3(30, 144, 255);
        ledBulb3MainMenu.color = ccRED;
        ledBulb4MainMenu.color = ccc3(255, 192, 203);
        ledBulb5MainMenu.color = ccc3(255, 192, 203);
        
        ledLight2MainMenu.opacity = 255;
        ledLight3MainMenu.opacity = 255;
        ledLight4MainMenu.opacity = 0;
        ledLight5MainMenu.opacity = 0;
    }
    
    else if (player1MarblesUnlocked == 3) {
        
        ledBulb1MainMenu.color = ccGREEN;
        ledBulb2MainMenu.color = ccc3(30, 144, 255);
        ledBulb3MainMenu.color = ccRED;
        ledBulb4MainMenu.color = ccGRAY;
        ledBulb5MainMenu.color = ccc3(255, 192, 203);
        
        ledLight2MainMenu.opacity = 255;
        ledLight3MainMenu.opacity = 255;
        ledLight4MainMenu.opacity = 255;
        ledLight5MainMenu.opacity = 0;
    }
    
    else if (player1MarblesUnlocked >= 4) {
        
        ledBulb1MainMenu.color = ccGREEN;
        ledBulb2MainMenu.color = ccc3(30, 144, 255);
        ledBulb3MainMenu.color = ccRED;
        ledBulb4MainMenu.color = ccGRAY;
        ledBulb5MainMenu.color = ccc3(250 , 250, 170);
        
        ledLight2MainMenu.opacity = 255;
        ledLight3MainMenu.opacity = 255;
        ledLight4MainMenu.opacity = 255;
        ledLight5MainMenu.opacity = 255;
    }
}


-(void) gertyVersusScreenUpdateLightsForPlayer1
{
    [player1LevelLabel setString:[NSString stringWithFormat:@"Rank: %i", player1LevelMultiplayerValue/100]];
    [player1ExperiencePointsLabel setString:[NSString stringWithFormat:@"%i%%", player1ExperiencePointsMultiplayerValue]];
    
    
    if (player1MarblesUnlockedMultiplayerValue == 0) {
        
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
    
    else if (player1MarblesUnlockedMultiplayerValue == 1) {
        
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
    
    else if (player1MarblesUnlockedMultiplayerValue == 2) {
        
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
    
    else if (player1MarblesUnlockedMultiplayerValue == 3) {
        
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
    
    else if (player1MarblesUnlockedMultiplayerValue >= 4) {
        
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

-(void) gertyVersusScreenUpdateLightsForPlayer2
{
    [player2LevelLabel setString:[NSString stringWithFormat:@"Rank: %i", player2LevelMultiplayerValue/100]];
    [player2ExperiencePointsLabel setString:[NSString stringWithFormat:@"%i%%", player2ExperiencePointsMultiplayerValue]];
    
    if (player2MarblesUnlockedMultiplayerValue == 0) {
        
        ledBulb1Player2.color = ccGREEN;
        ledBulb2Player2.color = ccc3(255, 192, 203);
        ledBulb3Player2.color = ccc3(255, 192, 203);
        ledBulb4Player2.color = ccc3(255, 192, 203);
        ledBulb5Player2.color = ccc3(255, 192, 203);
        
        
        ledLight2Player2.opacity = 0;
        ledLight3Player2.opacity = 0;
        ledLight4Player2.opacity = 0;
        ledLight5Player2.opacity = 0;
    }
    
    else if (player2MarblesUnlockedMultiplayerValue == 1) {
        
        ledBulb1Player2.color = ccGREEN;
        ledBulb2Player2.color = ccc3(30, 144, 255);
        ledBulb3Player2.color = ccc3(255, 192, 203);
        ledBulb4Player2.color = ccc3(255, 192, 203);
        ledBulb5Player2.color = ccc3(255, 192, 203);
        
        ledLight2Player2.opacity = 255;
        ledLight3Player2.opacity = 0;
        ledLight4Player2.opacity = 0;
        ledLight5Player2.opacity = 0;
    }
    
    else if (player2MarblesUnlockedMultiplayerValue == 2) {
        
        ledBulb1Player2.color = ccGREEN;
        ledBulb2Player2.color = ccc3(30, 144, 255);
        ledBulb3Player2.color = ccRED;
        ledBulb4Player2.color = ccc3(255, 192, 203);
        ledBulb5Player2.color = ccc3(255, 192, 203);
        
        ledLight2Player2.opacity = 255;
        ledLight3Player2.opacity = 255;
        ledLight4Player2.opacity = 0;
        ledLight5Player2.opacity = 0;
    }
    
    else if (player2MarblesUnlockedMultiplayerValue == 3) {
        
        ledBulb1Player2.color = ccGREEN;
        ledBulb2Player2.color = ccc3(30, 144, 255);
        ledBulb3Player2.color = ccRED;
        ledBulb4Player2.color = ccGRAY;
        ledBulb5Player2.color = ccc3(255, 192, 203);
        
        ledLight2Player2.opacity = 255;
        ledLight3Player2.opacity = 255;
        ledLight4Player2.opacity = 255;
        ledLight5Player2.opacity = 0;
    }
    
    else if (player2MarblesUnlockedMultiplayerValue >= 4) {
        
        ledBulb1Player2.color = ccGREEN;
        ledBulb2Player2.color = ccc3(30, 144, 255);
        ledBulb3Player2.color = ccRED;
        ledBulb4Player2.color = ccGRAY;
        ledBulb5Player2.color = ccc3(250 , 250, 170);
        
        ledLight2Player2.opacity = 255;
        ledLight3Player2.opacity = 255;
        ledLight4Player2.opacity = 255;
        ledLight5Player2.opacity = 255;
    }
}

-(void) gertyComputer
{
    //Second Player Gerty
    tamagachi2 = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-2000 black.png"];
    happyGerty2 = [CCSprite spriteWithSpriteFrameName: @"happygerty-hd.png"];
    sadGerty2 = [CCSprite spriteWithSpriteFrameName: @"sadgerty-hd.png"];
    uncertainGerty2 = [CCSprite spriteWithSpriteFrameName: @"gerty-hd.png"];
    cryingGerty2 = [CCSprite spriteWithSpriteFrameName: @"cryinggerty-hd.png"];
    ledLight1Player2 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight2Player2 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight3Player2 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight4Player2 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight5Player2 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledBulb1Player2 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb2Player2 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb3Player2 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb4Player2 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb5Player2 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    computerLevelLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Rank: %i", (difficultyLevel + 1)] fntFile:@"AerialBlack.fnt"];
    player2ExperiencePointsLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i%%", computerExperiencePoints] fntFile:@"BatteryLifeBlack2.fnt"];
    computerLabel = [CCLabelBMFont labelWithString:@"Computer" fntFile:@"Casual.fnt"];
    CCSprite *batteryIndicator1 = [CCSprite spriteWithSpriteFrameName: @"Battery-hd.png"];
    playButton = [CCSprite spriteWithSpriteFrameName: @"playButton-hd.png"];
    computerLevelLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Rank: %i", (difficultyLevel + 1)] fntFile:@"AerialBlack.fnt"];
    
    happyGerty2.visible = NO;
    sadGerty2.visible = NO;
    uncertainGerty2.visible = YES;
    cryingGerty2.visible = NO;
    
    if (restartingLevel == NO) {
        
        playButton.visible = YES;
    }
    
    else if (restartingLevel == YES) {
        
        playButton.visible = NO;
    }
    
    tamagachi2.scale = 1.0;
    
    [linedPaper addChild: tamagachi2];
    [tamagachi2 addChild: happyGerty2];
    [tamagachi2 addChild: sadGerty2];
    [tamagachi2 addChild: uncertainGerty2];
    [tamagachi2 addChild: cryingGerty2];
    [tamagachi2 addChild: computerLevelLabel];
    [tamagachi2 addChild: player2ExperiencePointsLabel];
    [tamagachi2 addChild: computerLabel];
    [tamagachi2 addChild: ledLight1Player2 z:5];
    [tamagachi2 addChild: ledLight2Player2 z:5];
    [tamagachi2 addChild: ledLight3Player2 z:5];
    [tamagachi2 addChild: ledLight4Player2 z:5];
    [tamagachi2 addChild: ledLight5Player2 z:5];
    [tamagachi2 addChild: ledBulb1Player2];
    [tamagachi2 addChild: ledBulb2Player2];
    [tamagachi2 addChild: ledBulb3Player2];
    [tamagachi2 addChild: ledBulb4Player2];
    [tamagachi2 addChild: ledBulb5Player2];
    [tamagachi2 addChild: batteryIndicator1];
    [linedPaper addChild: playButton];
    
    ledLight1Player2.color = ccGREEN;
    ledLight1Player2.scale = 0.5;
    ledLight1Player2.opacity = 255;
    
    ledLight2Player2.color = ccc3(30, 144, 255);
    ledLight2Player2.scale = 0.5;
    
    ledLight3Player2.color = ccRED;
    ledLight3Player2.scale = 0.5;
    
    ledLight4Player2.color = ccGRAY;
    ledLight4Player2.scale = 0.5;
    
    ledLight5Player2.color = ccc3(250 , 250, 170);
    ledLight5Player2.scale = 0.5;
    
    ledBulb1Player2.scale = 0.35;
    ledBulb1Player2.color = ccGREEN;
    
    ledBulb2Player2.scale = 0.35;
    ledBulb2Player2.color = ccc3(255, 192, 203);
    
    ledBulb3Player2.scale = 0.35;
    ledBulb3Player2.color = ccc3(255, 192, 203);
    
    ledBulb4Player2.scale = 0.35;
    ledBulb4Player2.color = ccc3(255, 192, 203);
    
    ledBulb5Player2.scale = 0.35;
    ledBulb5Player2.color = ccc3(255, 192, 203);
    
    
    ledBulb1Player2.color = ccGREEN;
    ledBulb2Player2.color = ccc3(30, 144, 255);
    ledBulb3Player2.color = ccRED;
    ledBulb4Player2.color = ccGRAY;
    ledBulb5Player2.color = ccc3(250 , 250, 170);
    
    ledLight2Player2.opacity = 255;
    ledLight3Player2.opacity = 255;
    ledLight4Player2.opacity = 255;
    ledLight5Player2.opacity = 255;
    
    
    tamagachi2.anchorPoint = ccp(0.5, 0.5);
    happyGerty2.anchorPoint = ccp(0.5, 0.5);
    sadGerty2.anchorPoint = ccp(0.5, 0.5);
    uncertainGerty2.anchorPoint = ccp(0.5, 0.5);
    cryingGerty2.anchorPoint = ccp(0.5, 0.5);
    computerLevelLabel.anchorPoint = ccp(0.5, 0.5);
    player2ExperiencePointsLabel.anchorPoint = ccp(0.5, 0.5);
    computerLabel.anchorPoint = ccp(0.5, 0.5);
    ledLight1Player2.anchorPoint = ccp(0.5, 0.5);
    ledLight2Player2.anchorPoint = ccp(0.5, 0.5);
    ledLight3Player2.anchorPoint = ccp(0.5, 0.5);
    ledLight4Player2.anchorPoint = ccp(0.5, 0.5);
    ledLight5Player2.anchorPoint = ccp(0.5, 0.5);
    ledBulb1Player2.anchorPoint = ccp(0.5, 0.5);
    ledBulb2Player2.anchorPoint = ccp(0.5, 0.5);
    ledBulb3Player2.anchorPoint = ccp(0.5, 0.5);
    ledBulb4Player2.anchorPoint = ccp(0.5, 0.5);
    ledBulb5Player2.anchorPoint = ccp(0.5, 0.5);
    batteryIndicator1.anchorPoint = ccp(0.5, 0.5);
    playButton.anchorPoint = ccp(0.5, 0.5);
    
    happyGerty2.position = ccp([tamagachi2 contentSize].width/2, [tamagachi2 contentSize].height/2);
    sadGerty2.position = ccp([tamagachi2 contentSize].width/2, [tamagachi2 contentSize].height/2);
    uncertainGerty2.position = ccp([tamagachi2 contentSize].width/2, [tamagachi2 contentSize].height/2);
    cryingGerty2.position = ccp([tamagachi2 contentSize].width/2, [tamagachi2 contentSize].height/2);
    computerLevelLabel.position = ccp(([tamagachi2 contentSize].width/2 - 30), ([tamagachi2 contentSize].height/2) + 42);
    player2ExperiencePointsLabel.position = ccp(([tamagachi2 contentSize].width/2 + 37), ([tamagachi2 contentSize].height/2) + 31.5);
    computerLabel.position = ccp(([tamagachi2 contentSize].width/2), ([tamagachi2 contentSize].height/2) + 65);
    ledLight1Player2.position = ccp([tamagachi2 contentSize].width/2 - 30, [tamagachi2 contentSize].height/2 - 45);
    ledLight2Player2.position = ccp([tamagachi2 contentSize].width/2 - 15, [tamagachi2 contentSize].height/2 - 45);
    ledLight3Player2.position = ccp([tamagachi2 contentSize].width/2 + 0, [tamagachi2 contentSize].height/2 - 45);
    ledLight4Player2.position = ccp([tamagachi2 contentSize].width/2 + 15, [tamagachi2 contentSize].height/2 - 45);
    ledLight5Player2.position = ccp([tamagachi2 contentSize].width/2 + 30, [tamagachi2 contentSize].height/2 - 45);
    ledBulb1Player2.position = ccp([tamagachi2 contentSize].width/2 - 30, [tamagachi2 contentSize].height/2 - 45);
    ledBulb2Player2.position = ccp([tamagachi2 contentSize].width/2 - 15, [tamagachi2 contentSize].height/2 - 45);
    ledBulb3Player2.position = ccp([tamagachi2 contentSize].width/2 + 0, [tamagachi2 contentSize].height/2 - 45);
    ledBulb4Player2.position = ccp([tamagachi2 contentSize].width/2 + 15, [tamagachi2 contentSize].height/2 - 45);
    ledBulb5Player2.position = ccp([tamagachi2 contentSize].width/2 + 30, [tamagachi2 contentSize].height/2 - 45);
    batteryIndicator1.position = ccp(player2ExperiencePointsLabel.position.x + - 1.5, player2ExperiencePointsLabel.position.y);
    
    //The following places the 'playButton' at the middle bototm of linedPaper
    
    if (deviceIsWidescreen) {
        
        playButton.position = ccp([linedPaper contentSize].width/2 - 17, [linedPaper contentSize].height/2 -128);
    }
    
    if (!deviceIsWidescreen) {
        
        playButton.position = ccp([linedPaper contentSize].width/2 - 35, [linedPaper contentSize].height/2 -128);
    }
    
    
    
    happyGerty2.scaleX = 0.6;
    happyGerty2.scaleY = 0.6;
    sadGerty2.scaleX = 0.6;
    sadGerty2.scaleY = 0.6;
    uncertainGerty2.scaleX = 0.6;
    uncertainGerty2.scaleY = 0.6;
    cryingGerty2.scaleX = 0.6;
    cryingGerty2.scaleY = 0.6;
    batteryIndicator1.scale = 0.2;
    playButton.scale = 0.3;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
        computerLevelLabel.scaleX = 0.75;
        computerLevelLabel.scaleY = 0.75;
        player2ExperiencePointsLabel.scaleX = 0.38;
        player2ExperiencePointsLabel.scaleY = 0.38;
        computerLabel.scale = 1.0/2;
    }
    
    else {
        
        computerLevelLabel.scaleX = 0.75/2;
        computerLevelLabel.scaleY = 0.75/2;
        player2ExperiencePointsLabel.scaleX = 0.38/2;
        player2ExperiencePointsLabel.scaleY = 0.38/2;
        computerLabel.scale = 1.0/4;
    }
    
    tamagachi2.position = ccp([linedPaper contentSize].width/2 + 40, [linedPaper contentSize].height/2 - 50);
}

-(void) gertyVersusScreen
{
    //First Player Gerty
    if (tamagachi1Color == TAMAGACHI_1_RED) {
        
        tamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-200 red.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_PINK) {
        
        tamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-200 pink.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_GREEN) {
        
        tamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-500 green.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_YELLOW) {
        
        tamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-500 yellow.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_ORANGE) {
        
        tamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-500 orange.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_LIGHTPURPLE) {
        
        tamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-1000 purple.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_PURPLE) {
        
        tamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-1000 maroon.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_BLUE) {
        
        tamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-1000 blue.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_WHITE) {
        
        tamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-2000 white.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_BLACK){
        
        tamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-2000 black.png"];
    }
    
    else if (tamagachi1Color == 0) {
        
        tamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-200 red.png"];
    }
    
    happyGertyTamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"happygerty-hd.png"];
    sadGertyTamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"sadgerty-hd.png"];
    uncertainGertyTamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"gerty-hd.png"];
    cryingGertyTamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"cryinggerty-hd.png"];
    pensiveGertyTamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"pensivegerty-hd.png"];
    ledLight1 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight2 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight3 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight4 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight5 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledBulb1 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb2 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb3 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb4 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb5 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    player1LevelLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Rank: %i", player1Level/100] fntFile:@"AerialBlack.fnt"];
    player1ExperiencePointsLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i%%", player1ExperiencePoints] fntFile:@"BatteryLifeBlack2.fnt"];
    CCSprite *batteryIndicator2 = [CCSprite spriteWithSpriteFrameName: @"Battery-hd.png"];
    
    happyGertyTamagachiMultiplayer.visible = NO;
    sadGertyTamagachiMultiplayer.visible = NO;
    uncertainGertyTamagachiMultiplayer.visible = YES;
    cryingGertyTamagachiMultiplayer.visible = NO;
    pensiveGertyTamagachiMultiplayer.visible = NO;
    
    tamagachiMultiplayer.scale = 1.0;
    
    [linedPaper addChild: tamagachiMultiplayer];
    [tamagachiMultiplayer addChild: happyGertyTamagachiMultiplayer];
    [tamagachiMultiplayer addChild: sadGertyTamagachiMultiplayer];
    [tamagachiMultiplayer addChild: uncertainGertyTamagachiMultiplayer];
    [tamagachiMultiplayer addChild: cryingGertyTamagachiMultiplayer];
    [tamagachiMultiplayer addChild: pensiveGertyTamagachiMultiplayer];
    [tamagachiMultiplayer addChild: player1LevelLabel];
    [tamagachiMultiplayer addChild: player1ExperiencePointsLabel];
    [tamagachiMultiplayer addChild: ledLight1 z:5];
    [tamagachiMultiplayer addChild: ledLight2 z:5];
    [tamagachiMultiplayer addChild: ledLight3 z:5];
    [tamagachiMultiplayer addChild: ledLight4 z:5];
    [tamagachiMultiplayer addChild: ledLight5 z:5];
    [tamagachiMultiplayer addChild: ledBulb1];
    [tamagachiMultiplayer addChild: ledBulb2];
    [tamagachiMultiplayer addChild: ledBulb3];
    [tamagachiMultiplayer addChild: ledBulb4];
    [tamagachiMultiplayer addChild: ledBulb5];
    [tamagachiMultiplayer addChild: batteryIndicator2];
    
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
    
    tamagachiMultiplayer.anchorPoint = ccp(0.5, 0.5);
    happyGertyTamagachiMultiplayer.anchorPoint = ccp(0.5, 0.5);
    sadGertyTamagachiMultiplayer.anchorPoint = ccp(0.5, 0.5);
    uncertainGertyTamagachiMultiplayer.anchorPoint = ccp(0.5, 0.5);
    cryingGertyTamagachiMultiplayer.anchorPoint = ccp(0.5, 0.5);
    pensiveGertyTamagachiMultiplayer.anchorPoint = ccp(0.5, 0.5);
    player1LevelLabel.anchorPoint = ccp(0.5, 0.5);
    player1ExperiencePointsLabel.anchorPoint = ccp(0.5, 0.5);
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
    batteryIndicator2.anchorPoint = ccp(0.5, 0.5);
    
    happyGertyTamagachiMultiplayer.position = ccp([tamagachiMultiplayer contentSize].width/2, [tamagachiMultiplayer contentSize].height/2);
    sadGertyTamagachiMultiplayer.position = ccp([tamagachiMultiplayer contentSize].width/2, [tamagachiMultiplayer contentSize].height/2);
    uncertainGertyTamagachiMultiplayer.position = ccp([tamagachiMultiplayer contentSize].width/2, [tamagachiMultiplayer contentSize].height/2);
    cryingGertyTamagachiMultiplayer.position = ccp([tamagachiMultiplayer contentSize].width/2, [tamagachiMultiplayer contentSize].height/2);
    pensiveGertyTamagachiMultiplayer.position = ccp([tamagachiMultiplayer contentSize].width/2, [tamagachiMultiplayer contentSize].height/2);
    player1LevelLabel.position = ccp(([tamagachiMultiplayer contentSize].width/2 - 30), ([tamagachiMultiplayer contentSize].height/2) + 42);
    player1ExperiencePointsLabel.position = ccp(([tamagachiMultiplayer contentSize].width/2 + 37), ([tamagachiMultiplayer contentSize].height/2) + 31.5);
    
    ledLight1.position = ccp([tamagachiMultiplayer contentSize].width/2 - 30, [tamagachiMultiplayer contentSize].height/2 - 45);
    ledLight2.position = ccp([tamagachiMultiplayer contentSize].width/2 - 15, [tamagachiMultiplayer contentSize].height/2 - 45);
    ledLight3.position = ccp([tamagachiMultiplayer contentSize].width/2 + 0, [tamagachiMultiplayer contentSize].height/2 - 45);
    ledLight4.position = ccp([tamagachiMultiplayer contentSize].width/2 + 15, [tamagachiMultiplayer contentSize].height/2 - 45);
    ledLight5.position = ccp([tamagachiMultiplayer contentSize].width/2 + 30, [tamagachiMultiplayer contentSize].height/2 - 45);
    ledBulb1.position = ccp([tamagachiMultiplayer contentSize].width/2 - 30, [tamagachiMultiplayer contentSize].height/2 - 45);
    ledBulb2.position = ccp([tamagachiMultiplayer contentSize].width/2 - 15, [tamagachiMultiplayer contentSize].height/2 - 45);
    ledBulb3.position = ccp([tamagachiMultiplayer contentSize].width/2 + 0, [tamagachiMultiplayer contentSize].height/2 - 45);
    ledBulb4.position = ccp([tamagachiMultiplayer contentSize].width/2 + 15, [tamagachiMultiplayer contentSize].height/2 - 45);
    ledBulb5.position = ccp([tamagachiMultiplayer contentSize].width/2 + 30, [tamagachiMultiplayer contentSize].height/2 - 45);
    batteryIndicator2.position = ccp(player1ExperiencePointsLabel.position.x + - 1.5, player1ExperiencePointsLabel.position.y);
    
    happyGertyTamagachiMultiplayer.scaleX = 0.6;
    happyGertyTamagachiMultiplayer.scaleY = 0.6;
    sadGertyTamagachiMultiplayer.scaleX = 0.6;
    sadGertyTamagachiMultiplayer.scaleY = 0.6;
    uncertainGertyTamagachiMultiplayer.scaleX = 0.6;
    uncertainGertyTamagachiMultiplayer.scaleY = 0.6;
    cryingGertyTamagachiMultiplayer.scaleX = 0.6;
    cryingGertyTamagachiMultiplayer.scaleY = 0.6;
    pensiveGertyTamagachiMultiplayer.scaleX = 0.6;
    pensiveGertyTamagachiMultiplayer.scaleY = 0.6;
    
    batteryIndicator2.scale = 0.2;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
        player1LevelLabel.scaleX = 0.75;
        player1LevelLabel.scaleY = 0.75;
        player1ExperiencePointsLabel.scaleX = 0.38;
        player1ExperiencePointsLabel.scaleY = 0.38;
    }
    
    else {
        
        player1LevelLabel.scaleX = 0.75/2;
        player1LevelLabel.scaleY = 0.75/2;
        player1ExperiencePointsLabel.scaleX = 0.38/2;
        player1ExperiencePointsLabel.scaleY = 0.38/2;
    }
    
    //Second Player Gerty
    //tamagachi2Multiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi-hd.png"];
    
    if (tamagachi2Color == TAMAGACHI_2_RED) {
        
        tamagachi2Multiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-200 red.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_PINK) {
        
        tamagachi2Multiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-200 pink.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_GREEN) {
        
        tamagachi2Multiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-500 green.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_YELLOW) {
        
        tamagachi2Multiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-500 yellow.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_ORANGE) {
        
        tamagachi2Multiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-500 orange.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_LIGHTPURPLE) {
        
        tamagachi2Multiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-1000 purple.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_PURPLE) {
        
        tamagachi2Multiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-1000 maroon.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_BLUE) {
        
        tamagachi2Multiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-1000 blue.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_WHITE) {
        
        tamagachi2Multiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-2000 white.png"];
    }
    
    else if (tamagachi2Color == TAMAGACHI_2_BLACK){
        
        tamagachi2Multiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-2000 black.png"];
    }
    
    else if (tamagachiMultiplayer == 0) {
        
        tamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-200 red.png"];
    }
    
    happyGerty2TamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"happygerty-hd.png"];
    sadGerty2TamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"sadgerty-hd.png"];
    uncertainGerty2TamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"gerty-hd.png"];
    cryingGerty2TamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"cryinggerty-hd.png"];
    pensiveGerty2TamagachiMultiplayer = [CCSprite spriteWithSpriteFrameName: @"pensivegerty-hd.png"];
    ledLight1Player2 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight2Player2 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight3Player2 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight4Player2 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight5Player2 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledBulb1Player2 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb2Player2 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb3Player2 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb4Player2 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb5Player2 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    player2LevelLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Rank: %i", player2Level/100] fntFile:@"AerialBlack.fnt"];
    player2ExperiencePointsLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i%%", player2ExperiencePoints] fntFile:@"BatteryLifeBlack2.fnt"];
    CCSprite *batteryIndicator3 = [CCSprite spriteWithSpriteFrameName: @"Battery-hd.png"];
    
    
    happyGerty2TamagachiMultiplayer.visible = NO;
    sadGerty2TamagachiMultiplayer.visible = NO;
    uncertainGerty2TamagachiMultiplayer.visible = YES;
    cryingGerty2TamagachiMultiplayer.visible = NO;
    pensiveGerty2TamagachiMultiplayer.visible = NO;
    
    tamagachi2Multiplayer.scale = 1.0;
    
    [linedPaper addChild: tamagachi2Multiplayer];
    [tamagachi2Multiplayer addChild: happyGerty2TamagachiMultiplayer];
    [tamagachi2Multiplayer addChild: sadGerty2TamagachiMultiplayer];
    [tamagachi2Multiplayer addChild: uncertainGerty2TamagachiMultiplayer];
    [tamagachi2Multiplayer addChild: cryingGerty2TamagachiMultiplayer];
    [tamagachi2Multiplayer addChild: pensiveGerty2TamagachiMultiplayer];
    [tamagachi2Multiplayer addChild: player2LevelLabel];
    [tamagachi2Multiplayer addChild: player2ExperiencePointsLabel];
    [tamagachi2Multiplayer addChild: ledLight1Player2 z:5];
    [tamagachi2Multiplayer addChild: ledLight2Player2 z:5];
    [tamagachi2Multiplayer addChild: ledLight3Player2 z:5];
    [tamagachi2Multiplayer addChild: ledLight4Player2 z:5];
    [tamagachi2Multiplayer addChild: ledLight5Player2 z:5];
    [tamagachi2Multiplayer addChild: ledBulb1Player2];
    [tamagachi2Multiplayer addChild: ledBulb2Player2];
    [tamagachi2Multiplayer addChild: ledBulb3Player2];
    [tamagachi2Multiplayer addChild: ledBulb4Player2];
    [tamagachi2Multiplayer addChild: ledBulb5Player2];
    [tamagachi2Multiplayer addChild: batteryIndicator3];
    
    
    ledLight1Player2.color = ccGREEN;
    ledLight1Player2.scale = 0.5;
    ledLight1Player2.opacity = 255;
    
    ledLight2Player2.color = ccc3(30, 144, 255);
    ledLight2Player2.scale = 0.5;
    
    ledLight3Player2.color = ccRED;
    ledLight3Player2.scale = 0.5;
    
    ledLight4Player2.color = ccGRAY;
    ledLight4Player2.scale = 0.5;
    
    ledLight5Player2.color = ccc3(250 , 250, 170);
    ledLight5Player2.scale = 0.5;
    
    ledBulb1Player2.scale = 0.35;
    ledBulb1Player2.color = ccGREEN;
    
    ledBulb2Player2.scale = 0.35;
    ledBulb2Player2.color = ccc3(255, 192, 203);
    
    ledBulb3Player2.scale = 0.35;
    ledBulb3Player2.color = ccc3(255, 192, 203);
    
    ledBulb4Player2.scale = 0.35;
    ledBulb4Player2.color = ccc3(255, 192, 203);
    
    ledBulb5Player2.scale = 0.35;
    ledBulb5Player2.color = ccc3(255, 192, 203);
    
    
    if (player2MarblesUnlocked == 0) {
        
        ledBulb1Player2.color = ccGREEN;
        ledBulb2Player2.color = ccc3(255, 192, 203);
        ledBulb3Player2.color = ccc3(255, 192, 203);
        ledBulb4Player2.color = ccc3(255, 192, 203);
        ledBulb5Player2.color = ccc3(255, 192, 203);
        
        
        ledLight2Player2.opacity = 0;
        ledLight3Player2.opacity = 0;
        ledLight4Player2.opacity = 0;
        ledLight5Player2.opacity = 0;
    }
    
    else if (player2MarblesUnlocked == 1) {
        
        ledBulb1Player2.color = ccGREEN;
        ledBulb2Player2.color = ccc3(30, 144, 255);
        ledBulb3Player2.color = ccc3(255, 192, 203);
        ledBulb4Player2.color = ccc3(255, 192, 203);
        ledBulb5Player2.color = ccc3(255, 192, 203);
        
        ledLight2Player2.opacity = 255;
        ledLight3Player2.opacity = 0;
        ledLight4Player2.opacity = 0;
        ledLight5Player2.opacity = 0;
    }
    
    else if (player2MarblesUnlocked == 2) {
        
        ledBulb1Player2.color = ccGREEN;
        ledBulb2Player2.color = ccc3(30, 144, 255);
        ledBulb3Player2.color = ccRED;
        ledBulb4Player2.color = ccc3(255, 192, 203);
        ledBulb5Player2.color = ccc3(255, 192, 203);
        
        ledLight2Player2.opacity = 255;
        ledLight3Player2.opacity = 255;
        ledLight4Player2.opacity = 0;
        ledLight5Player2.opacity = 0;
    }
    
    else if (player2MarblesUnlocked == 3) {
        
        ledBulb1Player2.color = ccGREEN;
        ledBulb2Player2.color = ccc3(30, 144, 255);
        ledBulb3Player2.color = ccRED;
        ledBulb4Player2.color = ccGRAY;
        ledBulb5Player2.color = ccc3(255, 192, 203);
        
        ledLight2Player2.opacity = 255;
        ledLight3Player2.opacity = 255;
        ledLight4Player2.opacity = 255;
        ledLight5Player2.opacity = 0;
    }
    
    else if (player2MarblesUnlocked == 4) {
        
        ledBulb1Player2.color = ccGREEN;
        ledBulb2Player2.color = ccc3(30, 144, 255);
        ledBulb3Player2.color = ccRED;
        ledBulb4Player2.color = ccGRAY;
        ledBulb5Player2.color = ccc3(250 , 250, 170);
        
        ledLight2Player2.opacity = 255;
        ledLight3Player2.opacity = 255;
        ledLight4Player2.opacity = 255;
        ledLight5Player2.opacity = 255;
    }
    
    tamagachi2Multiplayer.anchorPoint = ccp(0.5, 0.5);
    happyGerty2TamagachiMultiplayer.anchorPoint = ccp(0.5, 0.5);
    sadGerty2TamagachiMultiplayer.anchorPoint = ccp(0.5, 0.5);
    uncertainGerty2TamagachiMultiplayer.anchorPoint = ccp(0.5, 0.5);
    cryingGerty2TamagachiMultiplayer.anchorPoint = ccp(0.5, 0.5);
    pensiveGerty2TamagachiMultiplayer.anchorPoint = ccp(0.5, 0.5);
    player2LevelLabel.anchorPoint = ccp(0.5, 0.5);
    player2ExperiencePointsLabel.anchorPoint = ccp(0.5, 0.5);
    ledLight1Player2.anchorPoint = ccp(0.5, 0.5);
    ledLight2Player2.anchorPoint = ccp(0.5, 0.5);
    ledLight3Player2.anchorPoint = ccp(0.5, 0.5);
    ledLight4Player2.anchorPoint = ccp(0.5, 0.5);
    ledLight5Player2.anchorPoint = ccp(0.5, 0.5);
    ledBulb1Player2.anchorPoint = ccp(0.5, 0.5);
    ledBulb2Player2.anchorPoint = ccp(0.5, 0.5);
    ledBulb3Player2.anchorPoint = ccp(0.5, 0.5);
    ledBulb4Player2.anchorPoint = ccp(0.5, 0.5);
    ledBulb5Player2.anchorPoint = ccp(0.5, 0.5);
    batteryIndicator3.anchorPoint = ccp(0.5, 0.5);
    
    
    happyGerty2TamagachiMultiplayer.position = ccp([tamagachi2Multiplayer contentSize].width/2, [tamagachi2Multiplayer contentSize].height/2);
    sadGerty2TamagachiMultiplayer.position = ccp([tamagachi2Multiplayer contentSize].width/2, [tamagachi2Multiplayer contentSize].height/2);
    uncertainGerty2TamagachiMultiplayer.position = ccp([tamagachi2Multiplayer contentSize].width/2, [tamagachi2Multiplayer contentSize].height/2);
    cryingGerty2TamagachiMultiplayer.position = ccp([tamagachi2Multiplayer contentSize].width/2, [tamagachi2Multiplayer contentSize].height/2);
    pensiveGerty2TamagachiMultiplayer.position = ccp([tamagachi2Multiplayer contentSize].width/2, [tamagachi2Multiplayer contentSize].height/2);
    player2LevelLabel.position = ccp(([tamagachi2Multiplayer contentSize].width/2 - 30), ([tamagachi2Multiplayer contentSize].height/2) + 42);
    player2ExperiencePointsLabel.position = ccp(([tamagachi2Multiplayer contentSize].width/2 + 37), ([tamagachi2Multiplayer contentSize].height/2) + 31.5);
    
    ledLight1Player2.position = ccp([tamagachi2Multiplayer contentSize].width/2 - 30, [tamagachi2Multiplayer contentSize].height/2 - 45);
    ledLight2Player2.position = ccp([tamagachi2Multiplayer contentSize].width/2 - 15, [tamagachi2Multiplayer contentSize].height/2 - 45);
    ledLight3Player2.position = ccp([tamagachi2Multiplayer contentSize].width/2 + 0, [tamagachi2Multiplayer contentSize].height/2 - 45);
    ledLight4Player2.position = ccp([tamagachi2Multiplayer contentSize].width/2 + 15, [tamagachi2Multiplayer contentSize].height/2 - 45);
    ledLight5Player2.position = ccp([tamagachi2Multiplayer contentSize].width/2 + 30, [tamagachi2Multiplayer contentSize].height/2 - 45);
    ledBulb1Player2.position = ccp([tamagachi2Multiplayer contentSize].width/2 - 30, [tamagachi2Multiplayer contentSize].height/2 - 45);
    ledBulb2Player2.position = ccp([tamagachi2Multiplayer contentSize].width/2 - 15, [tamagachi2Multiplayer contentSize].height/2 - 45);
    ledBulb3Player2.position = ccp([tamagachi2Multiplayer contentSize].width/2 + 0, [tamagachi2Multiplayer contentSize].height/2 - 45);
    ledBulb4Player2.position = ccp([tamagachi2Multiplayer contentSize].width/2 + 15, [tamagachi2Multiplayer contentSize].height/2 - 45);
    ledBulb5Player2.position = ccp([tamagachi2Multiplayer contentSize].width/2 + 30, [tamagachi2Multiplayer contentSize].height/2 - 45);
    batteryIndicator3.position = ccp(player2ExperiencePointsLabel.position.x + - 1.5, player2ExperiencePointsLabel.position.y);
    
    
    happyGerty2TamagachiMultiplayer.scaleX = 0.6;
    happyGerty2TamagachiMultiplayer.scaleY = 0.6;
    sadGerty2TamagachiMultiplayer.scaleX = 0.6;
    sadGerty2TamagachiMultiplayer.scaleY = 0.6;
    uncertainGerty2TamagachiMultiplayer.scaleX = 0.6;
    uncertainGerty2TamagachiMultiplayer.scaleY = 0.6;
    cryingGerty2TamagachiMultiplayer.scaleX = 0.6;
    cryingGerty2TamagachiMultiplayer.scaleY = 0.6;
    pensiveGerty2TamagachiMultiplayer.scaleX = 0.6;
    pensiveGerty2TamagachiMultiplayer.scaleY = 0.6;
    batteryIndicator3.scale = 0.2;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
        player2LevelLabel.scaleX = 0.75;
        player2LevelLabel.scaleY = 0.75;
        player2ExperiencePointsLabel.scaleX = 0.38;
        player2ExperiencePointsLabel.scaleY = 0.38;
    }
    
    else {
        
        player2LevelLabel.scaleX = 0.75/2;
        player2LevelLabel.scaleY = 0.75/2;
        player2ExperiencePointsLabel.scaleX = 0.38/2;
        player2ExperiencePointsLabel.scaleY = 0.38/2;
    }
    
    //Start tamagachi positions
    tamagachiMultiplayer.position = ccp([linedPaper contentSize].width/2 - 325, [linedPaper contentSize].height/2 - 50);
    tamagachi2Multiplayer.position = ccp([linedPaper contentSize].width/2 + 245, [linedPaper contentSize].height/2 - 50);
}

-(void) startMarbleSlotMachineGameMethodForPlayer1
{
    [(Gerty*)gerty startMarbleSlotMachine];
}

-(void) startMarbleSlotMachineGameMethodForPlayer2
{
    [(Gerty2*)gerty2 startMarbleSlotMachine];
}

-(void) displaySelectedSlotMachineBombOnGertyGameMethod
{
    [(Gerty*)gerty displaySelectedSlotMachineBombOnGerty];
}

-(void) displaySelectedSlotMachineBombOnGerty2GameMethod
{
    [(Gerty2*)gerty2 displaySelectedSlotMachineBombOnGerty];
}

-(void) gertySinglePlayer
{
    //First Player Gerty
    
    if (tamagachi1Color == TAMAGACHI_1_RED) {
        
        tamagachi = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-200 red.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_PINK) {
        
        tamagachi = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-200 pink.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_GREEN) {
        
        tamagachi = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-500 green.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_YELLOW) {
        
        tamagachi = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-500 yellow.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_ORANGE) {
        
        tamagachi = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-500 orange.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_LIGHTPURPLE) {
        
        tamagachi = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-1000 purple.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_PURPLE) {
        
        tamagachi = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-1000 maroon.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_BLUE) {
        
        tamagachi = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-1000 blue.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_WHITE) {
        
        tamagachi = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-2000 white.png"];
    }
    
    else if (tamagachi1Color == TAMAGACHI_1_BLACK){
        
        tamagachi = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-2000 black.png"];
    }
    
    else if (tamagachi == 0) {
        
        //Else pick Red Anyway
        tamagachi = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-200 red.png"];
    }
    
    
    
    happyGerty = [CCSprite spriteWithSpriteFrameName: @"happygerty-hd.png"];
    sadGerty = [CCSprite spriteWithSpriteFrameName: @"sadgerty-hd.png"];
    uncertainGerty = [CCSprite spriteWithSpriteFrameName: @"gerty-hd.png"];
    cryingGerty = [CCSprite spriteWithSpriteFrameName: @"cryinggerty-hd.png"];
    pensiveGerty = [CCSprite spriteWithSpriteFrameName: @"pensivegerty-hd.png"];
    ledLight1 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight2 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight3 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight4 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight5 = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledBulb1 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb2 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb3 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb4 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb5 = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    player1LevelLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Rank: %i", player1Level/100] fntFile:@"AerialBlack.fnt"];
    player1ExperiencePointsLabel = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i%%", player1ExperiencePoints] fntFile:@"BatteryLifeBlack2.fnt"];
    CCSprite *batteryIndicator2 = [CCSprite spriteWithSpriteFrameName: @"Battery-hd.png"];
    youLabel = [CCLabelBMFont labelWithString:@"You" fntFile:@"Casual.fnt"];
    
    
    happyGerty.visible = YES;
    sadGerty.visible = NO;
    uncertainGerty.visible = NO;
    cryingGerty.visible = NO;
    pensiveGerty.visible = NO;
    
    tamagachi.scale = 1.0;
    
    [linedPaper addChild: tamagachi];
    [tamagachi addChild: happyGerty];
    [tamagachi addChild: sadGerty];
    [tamagachi addChild: uncertainGerty];
    [tamagachi addChild: cryingGerty];
    [tamagachi addChild: pensiveGerty];
    [tamagachi addChild: player1LevelLabel];
    [tamagachi addChild: player1ExperiencePointsLabel];
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
    [tamagachi addChild: batteryIndicator2];
    [tamagachi addChild: youLabel];
    
    
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
    
    
    tamagachi.anchorPoint = ccp(0.5, 0.5);
    happyGerty.anchorPoint = ccp(0.5, 0.5);
    sadGerty.anchorPoint = ccp(0.5, 0.5);
    uncertainGerty.anchorPoint = ccp(0.5, 0.5);
    cryingGerty.anchorPoint = ccp(0.5, 0.5);
    pensiveGerty.anchorPoint = ccp(0.5, 0.5);
    player1LevelLabel.anchorPoint = ccp(0.5, 0.5);
    player1ExperiencePointsLabel.anchorPoint = ccp(0.5, 0.5);
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
    batteryIndicator2.anchorPoint = ccp(0.5, 0.5);
    youLabel.anchorPoint = ccp(0.5, 0.5);
    
    happyGerty.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
    sadGerty.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
    uncertainGerty.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
    cryingGerty.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
    pensiveGerty.position = ccp([tamagachi contentSize].width/2, [tamagachi contentSize].height/2);
    player1LevelLabel.position = ccp(([tamagachi contentSize].width/2 - 30), ([tamagachi contentSize].height/2) + 42);
    player1ExperiencePointsLabel.position = ccp(([tamagachi contentSize].width/2 + 37), ([tamagachi contentSize].height/2) + 31.5);
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
    batteryIndicator2.position = ccp(player1ExperiencePointsLabel.position.x + - 1.5, player1ExperiencePointsLabel.position.y);
    youLabel.position = ccp(([tamagachi contentSize].width/2), ([tamagachi contentSize].height/2) + 63);
    
    
    happyGerty.scaleX = 0.6;
    happyGerty.scaleY = 0.6;
    sadGerty.scaleX = 0.6;
    sadGerty.scaleY = 0.6;
    uncertainGerty.scaleX = 0.6;
    uncertainGerty.scaleY = 0.6;
    cryingGerty.scaleX = 0.6;
    cryingGerty.scaleY = 0.6;
    pensiveGerty.scaleX = 0.6;
    pensiveGerty.scaleY = 0.6;
    batteryIndicator2.scale = 0.2;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
        player1LevelLabel.scaleX = 0.75;
        player1LevelLabel.scaleY = 0.75;
        player1ExperiencePointsLabel.scaleX = 0.38;
        player1ExperiencePointsLabel.scaleY = 0.38;
        
        youLabel.scaleX = 0.75/2;
        youLabel.scaleY = 0.75/2;
        youLabel.scale = 1.0/2;
        
        getReadyLabel.scale = 1.0;
    }
    
    else {
        
        player1LevelLabel.scaleX = 0.75/2;
        player1LevelLabel.scaleY = 0.75/2;
        player1ExperiencePointsLabel.scaleX = 0.38/2;
        player1ExperiencePointsLabel.scaleY = 0.38/2;
        
        youLabel.scaleX = 0.75/4;
        youLabel.scaleY = 0.75/4;
        youLabel.scale = 1.0/4;
        
        getReadyLabel.scale = 1.0/2;
    }
}

-(void) updateTamagachiMainMenuColor
{
    NSLog (@"tamagachi1Color = %i", tamagachi1Color);
    NSLog (@"Updating Tamagachi MainMenu Color!");
    
    if (tamagachi1Color == 1) {
        
        tamagachiMainMenu.opacity = 255;
        pinkTamagachiMainMenu.opacity = 0;
        greenTamagachiMainMenu.opacity = 0.0;
        yellowTamagachiMainMenu.opacity = 0.0;
        orangeTamagachiMainMenu.opacity = 0.0;
        lightPurpleTamagachiMainMenu.opacity = 0.0;
        purpleTamagachiMainMenu.opacity = 0.0;
        blueTamagachiMainMenu.opacity = 0.0;
        whiteTamagachiMainMenu.opacity = 0.0;
        blackTamagachiMainMenu.opacity = 0.0;
    }
    
    else if (tamagachi1Color == 2) {
        
        tamagachiMainMenu.opacity = 0;
        pinkTamagachiMainMenu.opacity = 255;
        greenTamagachiMainMenu.opacity = 0.0;
        yellowTamagachiMainMenu.opacity = 0.0;
        orangeTamagachiMainMenu.opacity = 0.0;
        lightPurpleTamagachiMainMenu.opacity = 0.0;
        purpleTamagachiMainMenu.opacity = 0.0;
        blueTamagachiMainMenu.opacity = 0.0;
        whiteTamagachiMainMenu.opacity = 0.0;
        blackTamagachiMainMenu.opacity = 0.0;
    }
    
    else if (tamagachi1Color == 3) {
        
        tamagachiMainMenu.opacity = 0;
        pinkTamagachiMainMenu.opacity = 0;
        greenTamagachiMainMenu.opacity = 255;
        yellowTamagachiMainMenu.opacity = 0.0;
        orangeTamagachiMainMenu.opacity = 0.0;
        lightPurpleTamagachiMainMenu.opacity = 0.0;
        purpleTamagachiMainMenu.opacity = 0.0;
        blueTamagachiMainMenu.opacity = 0.0;
        whiteTamagachiMainMenu.opacity = 0.0;
        blackTamagachiMainMenu.opacity = 0.0;
    }
    
    else if (tamagachi1Color == 4) {
        
        tamagachiMainMenu.opacity = 0;
        pinkTamagachiMainMenu.opacity = 0;
        greenTamagachiMainMenu.opacity = 0.0;
        yellowTamagachiMainMenu.opacity = 255;
        orangeTamagachiMainMenu.opacity = 0.0;
        lightPurpleTamagachiMainMenu.opacity = 0.0;
        purpleTamagachiMainMenu.opacity = 0.0;
        blueTamagachiMainMenu.opacity = 0.0;
        whiteTamagachiMainMenu.opacity = 0.0;
        blackTamagachiMainMenu.opacity = 0.0;
    }
    
    else if (tamagachi1Color == 5) {
        
        tamagachiMainMenu.opacity = 0;
        pinkTamagachiMainMenu.opacity = 0;
        greenTamagachiMainMenu.opacity = 0.0;
        yellowTamagachiMainMenu.opacity = 0.0;
        orangeTamagachiMainMenu.opacity = 255;
        lightPurpleTamagachiMainMenu.opacity = 0.0;
        purpleTamagachiMainMenu.opacity = 0.0;
        blueTamagachiMainMenu.opacity = 0.0;
        whiteTamagachiMainMenu.opacity = 0.0;
        blackTamagachiMainMenu.opacity = 0.0;
    }
    
    else if (tamagachi1Color == 6) {
        
        tamagachiMainMenu.opacity = 0;
        pinkTamagachiMainMenu.opacity = 0;
        greenTamagachiMainMenu.opacity = 0.0;
        yellowTamagachiMainMenu.opacity = 0.0;
        orangeTamagachiMainMenu.opacity = 0.0;
        lightPurpleTamagachiMainMenu.opacity = 255;
        purpleTamagachiMainMenu.opacity = 0.0;
        blueTamagachiMainMenu.opacity = 0.0;
        whiteTamagachiMainMenu.opacity = 0.0;
        blackTamagachiMainMenu.opacity = 0.0;
    }
    
    else if (tamagachi1Color == 7) {
        
        tamagachiMainMenu.opacity = 0;
        pinkTamagachiMainMenu.opacity = 0;
        greenTamagachiMainMenu.opacity = 0.0;
        yellowTamagachiMainMenu.opacity = 0.0;
        orangeTamagachiMainMenu.opacity = 0.0;
        lightPurpleTamagachiMainMenu.opacity = 0.0;
        purpleTamagachiMainMenu.opacity = 255;
        blueTamagachiMainMenu.opacity = 0.0;
        whiteTamagachiMainMenu.opacity = 0.0;
        blackTamagachiMainMenu.opacity = 0.0;
    }
    
    else if (tamagachi1Color == 8) {
        
        tamagachiMainMenu.opacity = 0;
        pinkTamagachiMainMenu.opacity = 0;
        greenTamagachiMainMenu.opacity = 0.0;
        yellowTamagachiMainMenu.opacity = 0.0;
        orangeTamagachiMainMenu.opacity = 0.0;
        lightPurpleTamagachiMainMenu.opacity = 0.0;
        purpleTamagachiMainMenu.opacity = 0.0;
        blueTamagachiMainMenu.opacity = 255;
        whiteTamagachiMainMenu.opacity = 0.0;
        blackTamagachiMainMenu.opacity = 0.0;
    }
    
    else if (tamagachi1Color == 9) {
        
        tamagachiMainMenu.opacity = 0;
        pinkTamagachiMainMenu.opacity = 0;
        greenTamagachiMainMenu.opacity = 0.0;
        yellowTamagachiMainMenu.opacity = 0.0;
        orangeTamagachiMainMenu.opacity = 0.0;
        lightPurpleTamagachiMainMenu.opacity = 0.0;
        purpleTamagachiMainMenu.opacity = 0.0;
        blueTamagachiMainMenu.opacity = 0.0;
        whiteTamagachiMainMenu.opacity = 255;
        blackTamagachiMainMenu.opacity = 0.0;
    }
    
    else if (tamagachi1Color == 10) {
        
        tamagachiMainMenu.opacity = 0;
        pinkTamagachiMainMenu.opacity = 0;
        greenTamagachiMainMenu.opacity = 0.0;
        yellowTamagachiMainMenu.opacity = 0.0;
        orangeTamagachiMainMenu.opacity = 0.0;
        lightPurpleTamagachiMainMenu.opacity = 0.0;
        purpleTamagachiMainMenu.opacity = 0.0;
        blueTamagachiMainMenu.opacity = 0.0;
        whiteTamagachiMainMenu.opacity = 0.0;
        blackTamagachiMainMenu.opacity = 255;
    }
}

-(void) setColorsSpeechBubbleToFront
{
    speechBubbleColorSwatchIsTopLayer = YES;
    speechBubbleMarbleListIsTopLayer = NO;
    speechBubbleStageSelectIsTopLayer = NO;
    
    [tamagachiMainMenu reorderChild:speechBubbleColorSwatches z: 101];
    [tamagachiMainMenu reorderChild:speechBubbleMarbleList z: 100];
    [tamagachiMainMenu reorderChild:speechBubbleStageSelect z: 100];
}

-(void) setMarblesSpeechBubbleToFront
{
    speechBubbleColorSwatchIsTopLayer = NO;
    speechBubbleMarbleListIsTopLayer = YES;
    speechBubbleStageSelectIsTopLayer = NO;
    
    [tamagachiMainMenu reorderChild:speechBubbleColorSwatches z: 100];
    [tamagachiMainMenu reorderChild:speechBubbleMarbleList z: 101];
    [tamagachiMainMenu reorderChild:speechBubbleStageSelect z: 100];
}

-(void) setStagesSpeechBubbleToFront
{
    speechBubbleColorSwatchIsTopLayer = NO;
    speechBubbleMarbleListIsTopLayer = NO;
    speechBubbleStageSelectIsTopLayer = YES;
    
    [tamagachiMainMenu reorderChild:speechBubbleColorSwatches z: 100];
    [tamagachiMainMenu reorderChild:speechBubbleMarbleList z: 100];
    [tamagachiMainMenu reorderChild:speechBubbleStageSelect z: 101];
}

-(void) gertyMainMenu
{
    //First Player Gerty
    tamagachiShadow = [CCSprite spriteWithFile: @"TamagachiShadow.png"];
    tamagachiMainMenu = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-200 red.png"];
    pinkTamagachiMainMenu = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-200 pink.png"];
    greenTamagachiMainMenu = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-500 green.png"];
    yellowTamagachiMainMenu = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-500 yellow.png"];
    orangeTamagachiMainMenu = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-500 orange.png"];
    lightPurpleTamagachiMainMenu = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-1000 purple.png"];
    purpleTamagachiMainMenu = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-1000 maroon.png"];
    blueTamagachiMainMenu = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-1000 blue.png"];
    whiteTamagachiMainMenu = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-2000 white.png"];
    blackTamagachiMainMenu = [CCSprite spriteWithSpriteFrameName: @"Tamagachi Z-2000 black.png"];
    happyGerty = [CCSprite spriteWithSpriteFrameName: @"happygerty-hd.png"];
    sadGerty = [CCSprite spriteWithSpriteFrameName: @"sadgerty-hd.png"];
    uncertainGerty = [CCSprite spriteWithSpriteFrameName: @"gerty-hd.png"];
    cryingGerty = [CCSprite spriteWithSpriteFrameName: @"cryinggerty-hd.png"];
    ledLight1MainMenu = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight2MainMenu = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight3MainMenu = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight4MainMenu = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledLight5MainMenu = [CCSprite spriteWithSpriteFrameName: @"led-hd.png"];
    ledBulb1MainMenu = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb2MainMenu = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb3MainMenu = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb4MainMenu = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    ledBulb5MainMenu = [CCSprite spriteWithSpriteFrameName: @"ledLightOff-hd.png"];
    player1LevelLabelMainMenu = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"Rank: %i", player1Level/100] fntFile:@"AerialBlack.fnt"];
    player1ExperiencePointsLabelMainMenu = [CCLabelBMFont labelWithString:[NSString stringWithFormat:@"%i%%", player1ExperiencePoints] fntFile:@"BatteryLifeBlack2.fnt"];
    CCSprite *batteryIndicator2 = [CCSprite spriteWithSpriteFrameName: @"Battery-hd.png"];
    pointingFingerForGertyMainMenuLightBulbs = [CCSprite spriteWithSpriteFrameName: @"PointingFinger-hd.png"];
    pointingFingerForGertyMainMenuTamagachi = [CCSprite spriteWithSpriteFrameName: @"PointingFinger-hd.png"];
    
    //In-app purchases bubble
    speechBubble = [CCSprite spriteWithFile: @"SpeechBubble.png"];
    
    //Stage select speech bubble
    speechBubbleStageSelect = [CCSprite spriteWithFile: @"SpeechBubbleRightTab.png"];
    
    //Daytime stage select button
    dayTimeStageButton = [CCSprite spriteWithFile: @"DayButton.png"];
    dayTimeStageButton.scale = 0.6;
    [speechBubbleStageSelect addChild: dayTimeStageButton];
    dayTimeStageButton.position = ccp([speechBubbleStageSelect contentSize].width/2 - 50, [speechBubbleStageSelect contentSize].width/2);
    CCLabelBMFont *dayLabel = [CCLabelBMFont labelWithString:@"DAY" fntFile:@"CasualWhite.fnt"];
    dayLabel.anchorPoint = ccp(0.5, 0.5);
    [dayTimeStageButton addChild: dayLabel];
    dayLabel.position = ccp([dayTimeStageButton contentSize].width/2, [dayTimeStageButton contentSize].height/2);
    
    //Nightime stage select button
    nightTimeStageButton = [CCSprite spriteWithFile: @"NightTimeSuburb.png"];
    nightTimeStageButton.scale = 0.6;
    [speechBubbleStageSelect addChild: nightTimeStageButton];
    nightTimeStageButton.position = ccp([speechBubbleStageSelect contentSize].width/2 + 50, [speechBubbleStageSelect contentSize].width/2);
    CCLabelBMFont *nightLabel = [CCLabelBMFont labelWithString:@"NIGHT" fntFile:@"CasualWhite.fnt"];
    nightLabel.anchorPoint = ccp(0.5, 0.5);
    [nightTimeStageButton addChild: nightLabel];
    nightLabel.position = ccp([nightTimeStageButton contentSize].width/2, [nightTimeStageButton contentSize].height/2);
    
    
    //speechBubbleStageSelect white sticker tab icon
    whiteTabStickerForSpeechBubbleStageSelect = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    whiteTabStickerForSpeechBubbleStageSelect.scaleX = 0.55;
    whiteTabStickerForSpeechBubbleStageSelect.scaleY = 0.27;
    [speechBubbleStageSelect addChild: whiteTabStickerForSpeechBubbleStageSelect];
    whiteTabStickerForSpeechBubbleStageSelect.position = ccp([speechBubbleStageSelect contentSize].width/2 + 69, 160);
    //'Level' label for whiteTabStickerForSpeechBubbleStageSelect
    CCLabelBMFont *levelLabelForTab = [CCLabelBMFont labelWithString:@"Stage" fntFile:@"Casual.fnt"];
    [whiteTabStickerForSpeechBubbleStageSelect addChild: levelLabelForTab];
    levelLabelForTab.position = ccp([whiteTabStickerForSpeechBubbleStageSelect contentSize].width/2, [whiteTabStickerForSpeechBubbleStageSelect contentSize].height/2);
    
    //Random stage select button
    randomStageSelectButton = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    randomStageSelectButton.scale = 0.6;
    [speechBubbleStageSelect addChild: randomStageSelectButton];
    //'Random' label for randomStageSelectButton
    randomStageSelectButton.position = ccp([speechBubbleStageSelect contentSize].width/2, [speechBubbleStageSelect contentSize].width/2 - 56);
    CCLabelBMFont *randomLabel = [CCLabelBMFont labelWithString:@"RANDOM" fntFile:@"Casual.fnt"];
    randomLabel.anchorPoint = ccp(0.5, 0.5);
    [randomStageSelectButton addChild: randomLabel];
    randomLabel.position = ccp([randomStageSelectButton contentSize].width/2, [randomStageSelectButton contentSize].height/2);
    
    
    //Create and add 'Loading Store...' text
    loadingStore = [CCLabelBMFont labelWithString:@"Loading Store..." fntFile:@"Casual.fnt"];
    [speechBubble addChild: loadingStore z: 10000];
    loadingStore.scale = 0.35;
    loadingStore.position = ccp(([speechBubble contentSize].width/2), ([speechBubble contentSize].height/2 + 15));
    
    //Add the three buy buttons
    buyButton1 = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    [speechBubble addChild: buyButton1];
    buyButton1.position = ccp(200, 135);
    buyButton1.visible = NO;
    buyButton1.scale = 0.3;
    
    buyButton2 = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    [speechBubble addChild: buyButton2];
    buyButton2.position = ccp(200, 95);
    buyButton2.visible = NO;
    buyButton2.scale = 0.3;
    
    buyButton3 = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    [speechBubble addChild: buyButton3];
    buyButton3.position = ccp(200, 55);
    buyButton3.visible = NO;
    buyButton3.scale = 0.3;
    
    
    
    //Color swatch speech bubble
    speechBubbleColorSwatches = [CCSprite spriteWithFile: @"SpeechBubbleLeftTab.png"];
    
    //speechBubbleColorSwatches white sticker tab icon
    whiteTabStickerForSpeechBubbleColorSwatches = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    whiteTabStickerForSpeechBubbleColorSwatches.scaleX = 0.55;
    whiteTabStickerForSpeechBubbleColorSwatches.scaleY = 0.27;
    [speechBubbleColorSwatches addChild: whiteTabStickerForSpeechBubbleColorSwatches];
    whiteTabStickerForSpeechBubbleColorSwatches.position = ccp([speechBubbleColorSwatches contentSize].width/2 - 72.5, [speechBubbleColorSwatches contentSize].height/2 + 71);
    
    //'Level' label for whiteTabStickerForSpeechBubbleColorSwatches
    CCLabelBMFont *colorsLabelForTab = [CCLabelBMFont labelWithString:@"Colors" fntFile:@"Casual.fnt"];
    [whiteTabStickerForSpeechBubbleColorSwatches addChild: colorsLabelForTab];
    colorsLabelForTab.position = ccp([whiteTabStickerForSpeechBubbleColorSwatches contentSize].width/2, [whiteTabStickerForSpeechBubbleColorSwatches contentSize].height/2);
    
    
    redColorSwatch = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    [speechBubbleColorSwatches addChild: redColorSwatch];
    redColorSwatch.position = ccp([speechBubbleColorSwatches contentSize].width/2 - 20, 40);
    redColorSwatch.visible = YES;
    redColorSwatch.scale = 0.3;
    redColorSwatch.color = ccRED;
    blackLock1 = [CCSprite spriteWithFile: @"whiteLock.png"];
    blackLock1.color = ccBLACK;
    [redColorSwatch addChild: blackLock1];
    blackLock1.position = ccp([redColorSwatch contentSize].width/2, [redColorSwatch contentSize].width/2 - 16);
    
    pinkColorSwatch = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    [speechBubbleColorSwatches addChild: pinkColorSwatch];
    pinkColorSwatch.position = ccp([speechBubbleColorSwatches contentSize].width/2 + 20, 40);
    pinkColorSwatch.visible = YES;
    pinkColorSwatch.scale = 0.3;
    pinkColorSwatch.color = ccc3(255, 105, 180);
    blackLock2 = [CCSprite spriteWithFile: @"whiteLock.png"];
    blackLock2.color = ccBLACK;
    [pinkColorSwatch addChild: blackLock2];
    blackLock2.position = ccp([pinkColorSwatch contentSize].width/2, [pinkColorSwatch contentSize].width/2 - 16);
    
    CCLabelBMFont *dividerLine = [CCLabelBMFont labelWithString:@"-" fntFile:@"Casual.fnt"];
    [speechBubbleColorSwatches addChild: dividerLine];
    dividerLine.position = ccp([speechBubbleColorSwatches contentSize].width/2, 55);
    dividerLine.scaleY = 0.13;
    dividerLine.scaleX = 9;
    
    
    greenColorSwatch = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    [speechBubbleColorSwatches addChild: greenColorSwatch];
    greenColorSwatch.position = ccp([speechBubbleColorSwatches contentSize].width/2 - 40, 70);
    greenColorSwatch.visible = YES;
    greenColorSwatch.scale = 0.3;
    greenColorSwatch.color = ccGREEN;
    blackLock3 = [CCSprite spriteWithFile: @"whiteLock.png"];
    blackLock3.color = ccBLACK;
    [greenColorSwatch addChild: blackLock3];
    blackLock3.position = ccp([greenColorSwatch contentSize].width/2, [greenColorSwatch contentSize].width/2 - 16);
    
    yellowColorSwatch = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    [speechBubbleColorSwatches addChild: yellowColorSwatch];
    yellowColorSwatch.position = ccp([speechBubbleColorSwatches contentSize].width/2, 70);
    yellowColorSwatch.visible = YES;
    yellowColorSwatch.scale = 0.3;
    yellowColorSwatch.color = ccYELLOW;
    blackLock4 = [CCSprite spriteWithFile: @"whiteLock.png"];
    blackLock4.color = ccBLACK;
    [yellowColorSwatch addChild: blackLock4];
    blackLock4.position = ccp([yellowColorSwatch contentSize].width/2, [yellowColorSwatch contentSize].width/2 - 16);
    
    orangeColorSwatch = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    [speechBubbleColorSwatches addChild: orangeColorSwatch];
    orangeColorSwatch.position = ccp([speechBubbleColorSwatches contentSize].width/2 + 40, 70);
    orangeColorSwatch.visible = YES;
    orangeColorSwatch.scale = 0.3;
    orangeColorSwatch.color = ccORANGE;
    blackLock5 = [CCSprite spriteWithFile: @"whiteLock.png"];
    blackLock5.color = ccBLACK;
    [orangeColorSwatch addChild: blackLock5];
    blackLock5.position = ccp([orangeColorSwatch contentSize].width/2, [orangeColorSwatch contentSize].width/2 - 16);
    
    CCLabelBMFont *dividerLine2 = [CCLabelBMFont labelWithString:@"-" fntFile:@"Casual.fnt"];
    [speechBubbleColorSwatches addChild: dividerLine2];
    dividerLine2.position = ccp([speechBubbleColorSwatches contentSize].width/2, 85);
    dividerLine2.scaleY = 0.13;
    dividerLine2.scaleX = 9.0;
    
    //button is more medium slate blue
    lightPurpleColorSwatch = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    [speechBubbleColorSwatches addChild: lightPurpleColorSwatch];
    lightPurpleColorSwatch.position = ccp([speechBubbleColorSwatches contentSize].width/2 - 40, 100);
    lightPurpleColorSwatch.visible = YES;
    lightPurpleColorSwatch.scale = 0.3;
    lightPurpleColorSwatch.color = ccc3(123, 104, 238);
    blackLock6 = [CCSprite spriteWithFile: @"whiteLock.png"];
    blackLock6.color = ccBLACK;
    [lightPurpleColorSwatch addChild: blackLock6];
    blackLock6.position = ccp([lightPurpleColorSwatch contentSize].width/2, [lightPurpleColorSwatch contentSize].width/2 - 16);
    
    //button is more maroon colored actually
    purpleColorSwatch = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    [speechBubbleColorSwatches addChild: purpleColorSwatch];
    purpleColorSwatch.position = ccp([speechBubbleColorSwatches contentSize].width/2, 100);
    purpleColorSwatch.visible = YES;
    purpleColorSwatch.scale = 0.3;
    purpleColorSwatch.color = ccc3(176, 48, 96);
    blackLock7 = [CCSprite spriteWithFile: @"whiteLock.png"];
    blackLock7.color = ccBLACK;
    [purpleColorSwatch addChild: blackLock7];
    blackLock7.position = ccp([purpleColorSwatch contentSize].width/2, [purpleColorSwatch contentSize].width/2 - 16);
    
    blueColorSwatch = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    [speechBubbleColorSwatches addChild: blueColorSwatch];
    blueColorSwatch.position = ccp([speechBubbleColorSwatches contentSize].width/2 + 40, 100);
    blueColorSwatch.visible = YES;
    blueColorSwatch.scale = 0.3;
    blueColorSwatch.color = ccBLUE;
    blackLock8 = [CCSprite spriteWithFile: @"whiteLock.png"];
    blackLock8.color = ccBLACK;
    [blueColorSwatch addChild: blackLock8];
    blackLock8.position = ccp([blueColorSwatch contentSize].width/2, [blueColorSwatch contentSize].width/2 - 16);
    
    CCLabelBMFont *dividerLine3 = [CCLabelBMFont labelWithString:@"-" fntFile:@"Casual.fnt"];
    [speechBubbleColorSwatches addChild: dividerLine3];
    dividerLine3.position = ccp([speechBubbleColorSwatches contentSize].width/2, 115);
    dividerLine3.scaleY = 0.13;
    dividerLine3.scaleX = 9.0;
    
    whiteColorSwatch = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    [speechBubbleColorSwatches addChild: whiteColorSwatch];
    whiteColorSwatch.position = ccp([speechBubbleColorSwatches contentSize].width/2 - 20, 130);
    whiteColorSwatch.visible = YES;
    whiteColorSwatch.scale = 0.3;
    whiteColorSwatch.color = ccWHITE;
    blackLock9 = [CCSprite spriteWithFile: @"whiteLock.png"];
    blackLock9.color = ccBLACK;
    [whiteColorSwatch addChild: blackLock9];
    blackLock9.position = ccp([whiteColorSwatch contentSize].width/2, [whiteColorSwatch contentSize].width/2 - 16);
    
    blackColorSwatch = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    [speechBubbleColorSwatches addChild: blackColorSwatch];
    blackColorSwatch.position = ccp([speechBubbleColorSwatches contentSize].width/2 + 20, 130);
    blackColorSwatch.visible = YES;
    blackColorSwatch.scale = 0.3;
    blackColorSwatch.color = ccBLACK;
    whiteLock1 = [CCSprite spriteWithFile: @"whiteLock.png"];
    whiteLock1.color = ccWHITE;
    [blackColorSwatch addChild: whiteLock1];
    whiteLock1.position = ccp([blackColorSwatch contentSize].width/2, [blackColorSwatch contentSize].width/2 - 16);
    /*
     CCLabelBMFont *dividerLine4 = [CCLabelBMFont labelWithString:@"-" fntFile:@"Casual.fnt"];
     [speechBubbleColorSwatches addChild: dividerLine4];
     dividerLine4.position = ccp([speechBubbleColorSwatches contentSize].width/2, 154);
     dividerLine4.scaleY = 0.13;
     dividerLine4.scaleX = 5;
     */
    z200Label = [CCLabelBMFont labelWithString:@"Rank: 2" fntFile:@"Casual.fnt"];
    [speechBubbleColorSwatches addChild: z200Label];
    z200Label.position = ccp([speechBubbleColorSwatches contentSize].width/2 + 80, 40);
    
    z500Label = [CCLabelBMFont labelWithString:@"Rank: 5" fntFile:@"Casual.fnt"];
    [speechBubbleColorSwatches addChild: z500Label];
    z500Label.position = ccp([speechBubbleColorSwatches contentSize].width/2 + 80, 70);
    
    z1000Label = [CCLabelBMFont labelWithString:@"Rank: 10" fntFile:@"Casual.fnt"];
    [speechBubbleColorSwatches addChild: z1000Label];
    z1000Label.position = ccp([speechBubbleColorSwatches contentSize].width/2 + 80, 100);
    
    z2000Label = [CCLabelBMFont labelWithString:@"Rank: 20" fntFile:@"Casual.fnt"];
    [speechBubbleColorSwatches addChild: z2000Label];
    z2000Label.position = ccp([speechBubbleColorSwatches contentSize].width/2 + 80, 130);
    /*
     CCLabelBMFont *chooseYourColorLabel = [CCLabelBMFont labelWithString:@"Choose Color" fntFile:@"Casual.fnt"];
     [speechBubbleColorSwatches addChild: chooseYourColorLabel];
     chooseYourColorLabel.position = ccp([speechBubbleColorSwatches contentSize].width/2, 160);
     */
    speechBubbleMarbleList = [CCSprite spriteWithFile: @"SpeechBubbleMiddleTab.png"];
    
    //speechBubbleMarbleList white sticker tab icon
    whiteTabStickerForSpeechBubbleMarbleList = [CCSprite spriteWithFile: @"RoundedRectangle.png"];
    whiteTabStickerForSpeechBubbleMarbleList.scaleX = 0.55;
    whiteTabStickerForSpeechBubbleMarbleList.scaleY = 0.27;
    [speechBubbleMarbleList addChild: whiteTabStickerForSpeechBubbleMarbleList];
    whiteTabStickerForSpeechBubbleMarbleList.position = ccp([speechBubbleMarbleList contentSize].width/2 - 1.5, [speechBubbleMarbleList contentSize].height/2 + 71.8);
    
    //'Level' label for whiteTabStickerForSpeechBubbleMarbleList
    CCLabelBMFont *marblesLabelForTab = [CCLabelBMFont labelWithString:@"Marbles" fntFile:@"Casual.fnt"];
    [whiteTabStickerForSpeechBubbleMarbleList addChild: marblesLabelForTab];
    marblesLabelForTab.position = ccp([whiteTabStickerForSpeechBubbleMarbleList contentSize].width/2, [whiteTabStickerForSpeechBubbleMarbleList contentSize].height/2);
    
    //add blue marble sprite and corresponding level requirement
    blueMarbleForSpeechBubble = [CCSprite spriteWithSpriteFrameName: @"bluemarble-hd.png"];
    [speechBubbleMarbleList addChild: blueMarbleForSpeechBubble];
    blueMarbleForSpeechBubble.scaleX = 0.34;
    blueMarbleForSpeechBubble.scaleY = 0.4;
    blueMarbleForSpeechBubble.position = ccp([speechBubbleColorSwatches contentSize].width/2, 40);
    blackLockSpeechBubbleMarbleList1 = [CCSprite spriteWithFile: @"whiteLock.png"];
    blackLockSpeechBubbleMarbleList1.color = ccBLACK;
    [blueMarbleForSpeechBubble addChild: blackLockSpeechBubbleMarbleList1];
    blackLockSpeechBubbleMarbleList1.position = ccp([blueMarbleForSpeechBubble contentSize].width/2, [blueMarbleForSpeechBubble contentSize].width/2);
    blackLockSpeechBubbleMarbleList1.scale = 0.8;
    
    //add red marble sprite and corresponding level requirement
    redMarbleForSpeechBubble = [CCSprite spriteWithSpriteFrameName: @"redmarble-hd.png"];
    [speechBubbleMarbleList addChild: redMarbleForSpeechBubble];
    redMarbleForSpeechBubble.scaleX = 0.34;
    redMarbleForSpeechBubble.scaleY = 0.4;
    redMarbleForSpeechBubble.position = ccp([speechBubbleColorSwatches contentSize].width/2, 70);
    blackLockSpeechBubbleMarbleList2 = [CCSprite spriteWithFile: @"whiteLock.png"];
    blackLockSpeechBubbleMarbleList2.color = ccBLACK;
    [redMarbleForSpeechBubble addChild: blackLockSpeechBubbleMarbleList2];
    blackLockSpeechBubbleMarbleList2.position = ccp([redMarbleForSpeechBubble contentSize].width/2, [redMarbleForSpeechBubble contentSize].width/2);
    blackLockSpeechBubbleMarbleList2.scale = 0.8;
    
    //add black marble sprite and corresponding level requirement
    blackMarbleForSpeechBubble = [CCSprite spriteWithSpriteFrameName: @"blackmarble-hd.png"];
    [speechBubbleMarbleList addChild: blackMarbleForSpeechBubble];
    blackMarbleForSpeechBubble.scaleX = 0.34;
    blackMarbleForSpeechBubble.scaleY = 0.4;
    blackMarbleForSpeechBubble.position = ccp([speechBubbleColorSwatches contentSize].width/2, 100);
    whiteLockSpeechBubbleMarbleList1 = [CCSprite spriteWithFile: @"whiteLock.png"];
    [blackMarbleForSpeechBubble addChild: whiteLockSpeechBubbleMarbleList1];
    whiteLockSpeechBubbleMarbleList1.position = ccp([blackMarbleForSpeechBubble contentSize].width/2, [blackMarbleForSpeechBubble contentSize].width/2);
    whiteLockSpeechBubbleMarbleList1.scale = 0.8;
    
    //add yellow marble sprite and corresponding level requirement
    yellowMarbleForSpeechBubble = [CCSprite spriteWithSpriteFrameName: @"yellowmarble-hd.png"];
    [speechBubbleMarbleList addChild: yellowMarbleForSpeechBubble];
    yellowMarbleForSpeechBubble.scaleX = 0.34;
    yellowMarbleForSpeechBubble.scaleY = 0.4;
    yellowMarbleForSpeechBubble.position = ccp([speechBubbleColorSwatches contentSize].width/2, 130);
    blackLockSpeechBubbleMarbleList3 = [CCSprite spriteWithFile: @"whiteLock.png"];
    blackLockSpeechBubbleMarbleList3.color = ccBLACK;
    [yellowMarbleForSpeechBubble addChild: blackLockSpeechBubbleMarbleList3];
    blackLockSpeechBubbleMarbleList3.position = ccp([yellowMarbleForSpeechBubble contentSize].width/2, [yellowMarbleForSpeechBubble contentSize].width/2);
    blackLockSpeechBubbleMarbleList3.scale = 0.8;
    
    
    z200LabelForMarble = [CCLabelBMFont labelWithString:@"Rank: 2" fntFile:@"Casual.fnt"];
    [speechBubbleMarbleList addChild: z200LabelForMarble];
    z200LabelForMarble.position = ccp([speechBubbleMarbleList contentSize].width/2 + 40, 40);
    
    z300LabelForMarble = [CCLabelBMFont labelWithString:@"Rank: 3" fntFile:@"Casual.fnt"];
    [speechBubbleMarbleList addChild: z300LabelForMarble];
    z300LabelForMarble.position = ccp([speechBubbleMarbleList contentSize].width/2 + 40, 70);
    
    z400LabelForMarble = [CCLabelBMFont labelWithString:@"Rank: 4" fntFile:@"Casual.fnt"];
    [speechBubbleMarbleList addChild: z400LabelForMarble];
    z400LabelForMarble.position = ccp([speechBubbleMarbleList contentSize].width/2 + 40, 100);
    
    z500LabelForMarble = [CCLabelBMFont labelWithString:@"Rank: 5" fntFile:@"Casual.fnt"];
    [speechBubbleMarbleList addChild: z500LabelForMarble];
    z500LabelForMarble.position = ccp([speechBubbleMarbleList contentSize].width/2 + 40, 130);
    
    /*
     CCLabelBMFont *marblesColorLabel = [CCLabelBMFont labelWithString:@"Marbles" fntFile:@"Casual.fnt"];
     [speechBubbleMarbleList addChild: marblesColorLabel];
     marblesColorLabel.position = ccp([speechBubbleMarbleList contentSize].width/2, 160);
     */
    
    //Divider lines for marble speech bubble
    CCLabelBMFont *dividerLineMarbleSpeechBubble1 = [CCLabelBMFont labelWithString:@"-" fntFile:@"Casual.fnt"];
    [speechBubbleMarbleList addChild: dividerLineMarbleSpeechBubble1];
    dividerLineMarbleSpeechBubble1.position = ccp([speechBubbleMarbleList contentSize].width/2 + 20, 55);
    dividerLineMarbleSpeechBubble1.scaleY = 0.13;
    dividerLineMarbleSpeechBubble1.scaleX = 5;
    
    CCLabelBMFont *dividerLineMarbleSpeechBubble2 = [CCLabelBMFont labelWithString:@"-" fntFile:@"Casual.fnt"];
    [speechBubbleMarbleList addChild: dividerLineMarbleSpeechBubble2];
    dividerLineMarbleSpeechBubble2.position = ccp([speechBubbleMarbleList contentSize].width/2 + 20, 85);
    dividerLineMarbleSpeechBubble2.scaleY = 0.13;
    dividerLineMarbleSpeechBubble2.scaleX = 5;
    
    CCLabelBMFont *dividerLineMarbleSpeechBubble3 = [CCLabelBMFont labelWithString:@"-" fntFile:@"Casual.fnt"];
    [speechBubbleMarbleList addChild: dividerLineMarbleSpeechBubble3];
    dividerLineMarbleSpeechBubble3.position = ccp([speechBubbleMarbleList contentSize].width/2 + 20, 115);
    dividerLineMarbleSpeechBubble3.scaleY = 0.13;
    dividerLineMarbleSpeechBubble3.scaleX = 5;
    /*
     CCLabelBMFont *dividerLineMarbleSpeechBubble4 = [CCLabelBMFont labelWithString:@"-" fntFile:@"Casual.fnt"];
     [speechBubbleMarbleList addChild: dividerLineMarbleSpeechBubble4];
     dividerLineMarbleSpeechBubble4.position = ccp([speechBubbleMarbleList contentSize].width/2, 153);
     dividerLineMarbleSpeechBubble4.scaleY = 0.13;
     dividerLineMarbleSpeechBubble4.scaleX = 3.8;
     */
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
        
        z200Label.scale = 0.7/2;
        z500Label.scale = 0.7/2;
        z1000Label.scale = 0.7/2;
        z2000Label.scale = 0.7/2;
        
        z200LabelForMarble.scale = 0.7/2;
        z300LabelForMarble.scale = 0.7/2;
        z400LabelForMarble.scale = 0.7/2;
        z500LabelForMarble.scale = 0.7/2;
        
        levelLabelForTab.scaleX = 0.9;
        levelLabelForTab.scaleY = 2.0;
        colorsLabelForTab.scaleX = 0.88;
        colorsLabelForTab.scaleY = 2.0;
        marblesLabelForTab.scaleX = 0.88;
        marblesLabelForTab.scaleY = 2.0;
        
        dayLabel.scale = 0.8;
        nightLabel.scale = 0.8;
        randomLabel.scale = 0.8;
        
        //chooseYourColorLabel.scale = 0.9/2;
        //marblesColorLabel.scale = 0.9/2;
    }
    
    else {
        
        z200Label.scale = 0.7/4;
        z500Label.scale = 0.7/4;
        z1000Label.scale = 0.7/4;
        z2000Label.scale = 0.7/4;
        
        z200LabelForMarble.scale = 0.7/4;
        z300LabelForMarble.scale = 0.7/4;
        z400LabelForMarble.scale = 0.7/4;
        z500LabelForMarble.scale = 0.7/4;
        
        levelLabelForTab.scaleX = 0.9/2;
        levelLabelForTab.scaleY = 2.0/2;
        colorsLabelForTab.scaleX = 0.88/2;
        colorsLabelForTab.scaleY = 2.0/2;
        marblesLabelForTab.scaleX = 0.88/2;
        marblesLabelForTab.scaleY = 2.0/2;
        
        dayLabel.scale = 0.8/2;
        nightLabel.scale = 0.8/2;
        randomLabel.scale = 0.8/2;
        
        //chooseYourColorLabel.scale = 0.9/4;
        //marblesColorLabel.scale = 0.9/4;
    }
    
    happyGerty.visible = YES;
    sadGerty.visible = NO;
    uncertainGerty.visible = NO;
    cryingGerty.visible = NO;
    speechBubble.visible = NO;
    speechBubbleColorSwatches.visible = NO;
    speechBubbleMarbleList.visible = NO;
    speechBubbleStageSelect.visible = NO;
    
    if (showPointingFingerForGertyMainMenuTamagachi == YES) {
        
        // pointingFingerForGertyMainMenuTamagachi.visible = YES;
        
        [pointingFingerForGertyMainMenuTamagachi runAction: [CCFadeOut actionWithDuration:0.0]];
        
        [pointingFingerForGertyMainMenuTamagachi runAction: [CCSequence actions: [CCDelayTime actionWithDuration:3.0], [CCFadeIn actionWithDuration:0.0], nil]];
    }
    
    else {
        
        pointingFingerForGertyMainMenuTamagachi.visible = NO;
    }
    
    if (showPointingFingerForGertyMainMenuLightBulbs == YES && pointingFingerForGertyMainMenuTamagachi.visible == NO) {
        
        // pointingFingerForGertyMainMenuLightBulbs.visible = YES;
        
        [pointingFingerForGertyMainMenuLightBulbs runAction: [CCFadeOut actionWithDuration:0.0]];
        
        [pointingFingerForGertyMainMenuLightBulbs runAction: [CCSequence actions: [CCDelayTime actionWithDuration:3.0], [CCFadeIn actionWithDuration:0.0], nil]];
    }
    
    else {
        
        pointingFingerForGertyMainMenuLightBulbs.visible = NO;
    }
    
    tamagachiShadow.scale = 1.9;
    tamagachiMainMenu.scale = 2.0;
    pinkTamagachiMainMenu.scale = 2.0;
    greenTamagachiMainMenu.scale = 2.0;
    yellowTamagachiMainMenu.scale = 2.0;
    orangeTamagachiMainMenu.scale = 2.0;
    lightPurpleTamagachiMainMenu.scale = 2.0;
    purpleTamagachiMainMenu.scale = 2.0;
    blueTamagachiMainMenu.scale = 2.0;
    whiteTamagachiMainMenu.scale = 2.0;
    blackTamagachiMainMenu.scale = 2.0;
    
    pinkTamagachiMainMenu.opacity = 0.0;
    greenTamagachiMainMenu.opacity = 0.0;
    yellowTamagachiMainMenu.opacity = 0.0;
    orangeTamagachiMainMenu.opacity = 0.0;
    lightPurpleTamagachiMainMenu.opacity = 0.0;
    purpleTamagachiMainMenu.opacity = 0.0;
    blueTamagachiMainMenu.opacity = 0.0;
    whiteTamagachiMainMenu.opacity = 0.0;
    blackTamagachiMainMenu.opacity = 0.0;
    
    [carpet addChild: tamagachiShadow z: 0];
    [carpet addChild: tamagachiMainMenu z: 20];
    [carpet addChild: pinkTamagachiMainMenu z: 10];
    [carpet addChild: greenTamagachiMainMenu z: 10];
    [carpet addChild: yellowTamagachiMainMenu z: 10];
    [carpet addChild: orangeTamagachiMainMenu z: 10];
    [carpet addChild: lightPurpleTamagachiMainMenu z: 10];
    [carpet addChild: purpleTamagachiMainMenu z: 10];
    [carpet addChild: blueTamagachiMainMenu z: 10];
    [carpet addChild: whiteTamagachiMainMenu z: 10];
    [carpet addChild: blackTamagachiMainMenu z: 10];
    
    [tamagachiMainMenu addChild: happyGerty];
    [tamagachiMainMenu addChild: sadGerty];
    [tamagachiMainMenu addChild: uncertainGerty];
    [tamagachiMainMenu addChild: cryingGerty];
    [tamagachiMainMenu addChild: player1LevelLabelMainMenu];
    [tamagachiMainMenu addChild: player1ExperiencePointsLabelMainMenu];
    [tamagachiMainMenu addChild: ledLight1MainMenu z:5];
    [tamagachiMainMenu addChild: ledLight2MainMenu z:5];
    [tamagachiMainMenu addChild: ledLight3MainMenu z:5];
    [tamagachiMainMenu addChild: ledLight4MainMenu z:5];
    [tamagachiMainMenu addChild: ledLight5MainMenu z:5];
    [tamagachiMainMenu addChild: ledBulb1MainMenu];
    [tamagachiMainMenu addChild: ledBulb2MainMenu];
    [tamagachiMainMenu addChild: ledBulb3MainMenu];
    [tamagachiMainMenu addChild: ledBulb4MainMenu];
    [tamagachiMainMenu addChild: ledBulb5MainMenu];
    [tamagachiMainMenu addChild: batteryIndicator2];
    [tamagachiMainMenu addChild: speechBubble z: 100];
    [tamagachiMainMenu addChild: speechBubbleColorSwatches z: 101];
    [tamagachiMainMenu addChild: speechBubbleMarbleList z: 100];
    [tamagachiMainMenu addChild: speechBubbleStageSelect z: 100];
    [tamagachiMainMenu addChild: pointingFingerForGertyMainMenuLightBulbs z: 100];
    [tamagachiMainMenu addChild: pointingFingerForGertyMainMenuTamagachi z: 100];
    
    
    ledLight1MainMenu.color = ccGREEN;
    ledLight1MainMenu.scale = 0.5;
    ledLight1MainMenu.opacity = 255;
    
    ledLight2MainMenu.color = ccc3(30, 144, 255);
    ledLight2MainMenu.scale = 0.5;
    
    ledLight3MainMenu.color = ccRED;
    ledLight3MainMenu.scale = 0.5;
    
    ledLight4MainMenu.color = ccGRAY;
    ledLight4MainMenu.scale = 0.5;
    
    ledLight5MainMenu.color = ccc3(250 , 250, 170);
    ledLight5MainMenu.scale = 0.5;
    
    ledBulb1MainMenu.scale = 0.35;
    ledBulb1MainMenu.color = ccGREEN;
    
    ledBulb2MainMenu.scale = 0.35;
    ledBulb2MainMenu.color = ccc3(255, 192, 203);
    
    ledBulb3MainMenu.scale = 0.35;
    ledBulb3MainMenu.color = ccc3(255, 192, 203);
    
    ledBulb4MainMenu.scale = 0.35;
    ledBulb4MainMenu.color = ccc3(255, 192, 203);
    
    ledBulb5MainMenu.scale = 0.35;
    ledBulb5MainMenu.color = ccc3(255, 192, 203);
    
    
    if (player1MarblesUnlocked == 0) {
        
        ledBulb1MainMenu.color = ccGREEN;
        ledBulb2MainMenu.color = ccc3(255, 192, 203);
        ledBulb3MainMenu.color = ccc3(255, 192, 203);
        ledBulb4MainMenu.color = ccc3(255, 192, 203);
        ledBulb5MainMenu.color = ccc3(255, 192, 203);
        
        
        ledLight2MainMenu.opacity = 0;
        ledLight3MainMenu.opacity = 0;
        ledLight4MainMenu.opacity = 0;
        ledLight5MainMenu.opacity = 0;
    }
    
    else if (player1MarblesUnlocked == 1) {
        
        ledBulb1MainMenu.color = ccGREEN;
        ledBulb2MainMenu.color = ccc3(30, 144, 255);
        ledBulb3MainMenu.color = ccc3(255, 192, 203);
        ledBulb4MainMenu.color = ccc3(255, 192, 203);
        ledBulb5MainMenu.color = ccc3(255, 192, 203);
        
        ledLight2MainMenu.opacity = 255;
        ledLight3MainMenu.opacity = 0;
        ledLight4MainMenu.opacity = 0;
        ledLight5MainMenu.opacity = 0;
    }
    
    else if (player1MarblesUnlocked == 2) {
        
        ledBulb1MainMenu.color = ccGREEN;
        ledBulb2MainMenu.color = ccc3(30, 144, 255);
        ledBulb3MainMenu.color = ccRED;
        ledBulb4MainMenu.color = ccc3(255, 192, 203);
        ledBulb5MainMenu.color = ccc3(255, 192, 203);
        
        ledLight2MainMenu.opacity = 255;
        ledLight3MainMenu.opacity = 255;
        ledLight4MainMenu.opacity = 0;
        ledLight5MainMenu.opacity = 0;
    }
    
    else if (player1MarblesUnlocked == 3) {
        
        ledBulb1MainMenu.color = ccGREEN;
        ledBulb2MainMenu.color = ccc3(30, 144, 255);
        ledBulb3MainMenu.color = ccRED;
        ledBulb4MainMenu.color = ccGRAY;
        ledBulb5MainMenu.color = ccc3(255, 192, 203);
        
        ledLight2MainMenu.opacity = 255;
        ledLight3MainMenu.opacity = 255;
        ledLight4MainMenu.opacity = 255;
        ledLight5MainMenu.opacity = 0;
    }
    
    else if (player1MarblesUnlocked >= 4) {
        
        ledBulb1MainMenu.color = ccGREEN;
        ledBulb2MainMenu.color = ccc3(30, 144, 255);
        ledBulb3MainMenu.color = ccRED;
        ledBulb4MainMenu.color = ccGRAY;
        ledBulb5MainMenu.color = ccc3(250 , 250, 170);
        
        ledLight2MainMenu.opacity = 255;
        ledLight3MainMenu.opacity = 255;
        ledLight4MainMenu.opacity = 255;
        ledLight5MainMenu.opacity = 255;
    }
    
    tamagachiShadow.anchorPoint = ccp(0.5, 0.5);
    tamagachiMainMenu.anchorPoint = ccp(0.5, 0.5);
    pinkTamagachiMainMenu.anchorPoint = ccp(0.5, 0.5);
    greenTamagachiMainMenu.anchorPoint = ccp(0.5, 0.5);
    yellowTamagachiMainMenu.anchorPoint = ccp(0.5, 0.5);
    orangeTamagachiMainMenu.anchorPoint = ccp(0.5, 0.5);
    lightPurpleTamagachiMainMenu.anchorPoint = ccp(0.5, 0.5);
    purpleTamagachiMainMenu.anchorPoint = ccp(0.5, 0.5);
    whiteTamagachiMainMenu.anchorPoint = ccp(0.5, 0.5);
    blackTamagachiMainMenu.anchorPoint = ccp(0.5, 0.5);
    
    
    happyGerty.anchorPoint = ccp(0.5, 0.5);
    sadGerty.anchorPoint = ccp(0.5, 0.5);
    uncertainGerty.anchorPoint = ccp(0.5, 0.5);
    cryingGerty.anchorPoint = ccp(0.5, 0.5);
    player1LevelLabelMainMenu.anchorPoint = ccp(0.5, 0.5);
    player1ExperiencePointsLabelMainMenu.anchorPoint = ccp(0.5, 0.5);
    ledLight1MainMenu.anchorPoint = ccp(0.5, 0.5);
    ledLight2MainMenu.anchorPoint = ccp(0.5, 0.5);
    ledLight3MainMenu.anchorPoint = ccp(0.5, 0.5);
    ledLight4MainMenu.anchorPoint = ccp(0.5, 0.5);
    ledLight5MainMenu.anchorPoint = ccp(0.5, 0.5);
    ledBulb1MainMenu.anchorPoint = ccp(0.5, 0.5);
    ledBulb2MainMenu.anchorPoint = ccp(0.5, 0.5);
    ledBulb3MainMenu.anchorPoint = ccp(0.5, 0.5);
    ledBulb4MainMenu.anchorPoint = ccp(0.5, 0.5);
    ledBulb5MainMenu.anchorPoint = ccp(0.5, 0.5);
    batteryIndicator2.anchorPoint = ccp(0.5, 0.5);
    speechBubble.anchorPoint = ccp(0.5, 0.5);
    speechBubbleColorSwatches.anchorPoint = ccp(0.5, 0.5);
    speechBubbleMarbleList.anchorPoint = ccp(0.5, 0.5);
    tamagachiMainMenu.anchorPoint = ccp(0.5, 0.5);
    speechBubbleStageSelect.anchorPoint = ccp(0.5, 0.5);
    
    
    tamagachiShadow.position = ccp(290,140);
    tamagachiMainMenu.position = ccp(295,150);
    pinkTamagachiMainMenu.position = ccp(295,150);
    greenTamagachiMainMenu.position = ccp(295,150);
    yellowTamagachiMainMenu.position = ccp(295,150);
    orangeTamagachiMainMenu.position = ccp(295,150);
    lightPurpleTamagachiMainMenu.position = ccp(295,150);
    purpleTamagachiMainMenu.position = ccp(295,150);
    blueTamagachiMainMenu.position = ccp(295,150);
    whiteTamagachiMainMenu.position = ccp(295,150);
    blackTamagachiMainMenu.position = ccp(295,150);
    
    happyGerty.position = ccp([tamagachiMainMenu contentSize].width/2, [tamagachiMainMenu contentSize].height/2);
    sadGerty.position = ccp([tamagachiMainMenu contentSize].width/2, [tamagachiMainMenu contentSize].height/2);
    uncertainGerty.position = ccp([tamagachiMainMenu contentSize].width/2, [tamagachiMainMenu contentSize].height/2);
    cryingGerty.position = ccp([tamagachiMainMenu contentSize].width/2, [tamagachiMainMenu contentSize].height/2);
    player1LevelLabelMainMenu.position = ccp(([tamagachiMainMenu contentSize].width/2 - 30), ([tamagachiMainMenu contentSize].height/2) + 42);
    player1ExperiencePointsLabelMainMenu.position = ccp(([tamagachiMainMenu contentSize].width/2 + 37), ([tamagachiMainMenu contentSize].height/2) + 31.5);
    ledLight1MainMenu.position = ccp([tamagachiMainMenu contentSize].width/2 - 30, [tamagachiMainMenu contentSize].height/2 - 45);
    ledLight2MainMenu.position = ccp([tamagachiMainMenu contentSize].width/2 - 15, [tamagachiMainMenu contentSize].height/2 - 45);
    ledLight3MainMenu.position = ccp([tamagachiMainMenu contentSize].width/2 + 0, [tamagachiMainMenu contentSize].height/2 - 45);
    ledLight4MainMenu.position = ccp([tamagachiMainMenu contentSize].width/2 + 15, [tamagachiMainMenu contentSize].height/2 - 45);
    ledLight5MainMenu.position = ccp([tamagachiMainMenu contentSize].width/2 + 30, [tamagachiMainMenu contentSize].height/2 - 45);
    ledBulb1MainMenu.position = ccp([tamagachiMainMenu contentSize].width/2 - 30, [tamagachiMainMenu contentSize].height/2 - 45);
    ledBulb2MainMenu.position = ccp([tamagachiMainMenu contentSize].width/2 - 15, [tamagachiMainMenu contentSize].height/2 - 45);
    ledBulb3MainMenu.position = ccp([tamagachiMainMenu contentSize].width/2 + 0, [tamagachiMainMenu contentSize].height/2 - 45);
    ledBulb4MainMenu.position = ccp([tamagachiMainMenu contentSize].width/2 + 15, [tamagachiMainMenu contentSize].height/2 - 45);
    ledBulb5MainMenu.position = ccp([tamagachiMainMenu contentSize].width/2 + 30, [tamagachiMainMenu contentSize].height/2 - 45);
    batteryIndicator2.position = ccp(player1ExperiencePointsLabelMainMenu.position.x + - 1.5, player1ExperiencePointsLabelMainMenu.position.y);
    
    //The following moves the speechBubble (or Store window) down a bit
    if (deviceIsWidescreen) {
        speechBubble.position = ccp(147.5, 230);
    }
    
    if (!deviceIsWidescreen) {
        speechBubble.position = ccp(147.5, 250);
    }
    
    if (deviceIsWidescreen) {
        
        speechBubbleColorSwatches.position = ccp(147.5, 224);
        speechBubbleMarbleList.position = ccp(147.5, 224);
        speechBubbleStageSelect.position = ccp(147.5, 224);
    }
    
    if (!deviceIsWidescreen) {
        
        speechBubbleColorSwatches.position = ccp(147.5, 250);
        speechBubbleMarbleList.position = ccp(147.5, 250);
        speechBubbleStageSelect.position = ccp(147.5, 250);
    }
    
    pointingFingerForGertyMainMenuLightBulbs.position = ccp(ledBulb3MainMenu.position.x, ledBulb3MainMenu.position.y);
    pointingFingerForGertyMainMenuTamagachi.position = ccp(tamagachiMainMenu.position.x, tamagachiMainMenu.position.y);
    
    
    [pointingFingerForGertyMainMenuLightBulbs runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCMoveTo actionWithDuration:0.3 position:ccp(ledBulb3MainMenu.position.x + 2, ledBulb3MainMenu.position.y + 22)], [CCMoveTo actionWithDuration:0.3 position:ccp(ledBulb3MainMenu.position.x + 2, ledBulb3MainMenu.position.y + 17)],  nil]]];
    
    [pointingFingerForGertyMainMenuTamagachi runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCMoveTo actionWithDuration:0.3 position:ccp(happyGerty.position.x + 2, happyGerty.position.y + 55)], [CCMoveTo actionWithDuration:0.3 position:ccp(happyGerty.position.x + 2, happyGerty.position.y + 65)],  nil]]];
    
    
    happyGerty.scaleX = 0.6;
    happyGerty.scaleY = 0.6;
    sadGerty.scaleX = 0.6;
    sadGerty.scaleY = 0.6;
    uncertainGerty.scaleX = 0.6;
    uncertainGerty.scaleY = 0.6;
    cryingGerty.scaleX = 0.6;
    cryingGerty.scaleY = 0.6;
    batteryIndicator2.scale = 0.2;
    speechBubble.scaleX = 2.0;
    speechBubble.scaleY = 1.8;
    speechBubbleColorSwatches.scaleX = 2.0;
    speechBubbleColorSwatches.scaleY = 1.65;
    speechBubbleStageSelect.scaleX = 2.0;
    speechBubbleStageSelect.scaleY = 1.65;
    speechBubbleMarbleList.scaleX = 2.0;
    speechBubbleMarbleList.scaleY = 1.65;
    pointingFingerForGertyMainMenuLightBulbs.scale = 0.2;
    pointingFingerForGertyMainMenuTamagachi.scale = 0.2;
    
    speechBubble.visible = NO;
    
    //Add checkmark1 to SpeechBubbleStageSelect
    checkMarkSpeechBubbleStageSelect = [CCSprite spriteWithFile: @"CheckMarkButton.png"];
    checkMarkSpeechBubbleStageSelect.scaleX = 0.4;
    checkMarkSpeechBubbleStageSelect.scaleY = 0.5;
    checkMarkSpeechBubbleStageSelect.anchorPoint = ccp(0.5, 0.5);
    [speechBubbleStageSelect addChild: checkMarkSpeechBubbleStageSelect z: 10];
    
    if (checkMarkSpeechBubbleStageSelectIsOnRandomButton) {
        
        checkMarkSpeechBubbleStageSelectIsOnRandomButton = YES;
        checkMarkSpeechBubbleStageSelect.position = randomStageSelectButton.position;
    }
    
    else if (stage == DAY_TIME_SUBURB) {
        
        checkMarkSpeechBubbleStageSelectIsOnRandomButton = NO;
        checkMarkSpeechBubbleStageSelect.position = dayTimeStageButton.position;
    }
    
    else {
        
        checkMarkSpeechBubbleStageSelectIsOnRandomButton = NO;
        checkMarkSpeechBubbleStageSelect.position = nightTimeStageButton.position;
    }
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
        
        player1LevelLabelMainMenu.scaleX = 0.75;
        player1LevelLabelMainMenu.scaleY = 0.75;
        player1ExperiencePointsLabelMainMenu.scaleX = 0.38;
        player1ExperiencePointsLabelMainMenu.scaleY = 0.38;
    }
    
    else {
        
        player1LevelLabelMainMenu.scaleX = 0.75/2;
        player1LevelLabelMainMenu.scaleY = 0.75/2;
        player1ExperiencePointsLabelMainMenu.scaleX = 0.38/2;
        player1ExperiencePointsLabelMainMenu.scaleY = 0.38/2;
    }
    
    [self updateTamagachiMainMenuColor];
}


-(void) setupGertyPlayer1
{
    NSLog (@"setupGertyPlayer1 called!");
    
    gerty = [Gerty gertyWithGame:self];
    gerty.scaleX = 0.22;
    gerty.scaleY = 0.26;
    [zoombase addChild: gerty z:18];
    gerty.position = ccp(101,28);
    
    if (pillarConfiguration == 0) {
        
        gerty.position = ccp(94, 28);
    }
    
    else if (pillarConfiguration == 3) {
        
        gerty.position = ccp(92.5, 28);
    }
    
    gerty1IDNumber = sling2SourceIDNumber3 + 1;
    totalSoundSources = totalSoundSources + 1;
    audioGerty1BeingDestroyed = [CDXAudioNode audioNodeWithFile:@"GertyDestroyedWav.wav" soundEngine:soundEngine sourceId:gerty1IDNumber];
    [gerty addChild: audioGerty1BeingDestroyed];
    
    gerty1IDNumber = sling2SourceIDNumber3 + 2;
    totalSoundSources = totalSoundSources + 1;
    audioGertyFireworks = [CDXAudioNode audioNodeWithFile:@"FireworksVictory.wav" soundEngine:soundEngine sourceId:gerty1IDNumber];
    [gerty addChild: audioGertyFireworks];
    
    if (isSinglePlayer) {
        
        youLabelInGame = [CCLabelBMFont labelWithString:@"YOU" fntFile:@"CasualWhite.fnt"];
        [zoombase addChild: youLabelInGame z:100];
        youLabelInGame.position = gerty.position;
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
            
            youLabelInGame.scale = 1.5;
        }
        
        else {
            
            youLabelInGame.scale = 1.5/2;
        }
    }
}

-(void) setupGertyPlayer2
{
    gerty2 = [Gerty2 gerty2WithGame:self];
    gerty2.position = ccp(467, 28);
    gerty2.scaleX = 0.22;
    gerty2.scaleY = 0.26;
    [zoombase addChild:gerty2 z:18];
    
    if (pillarConfiguration == 0) {
        
        gerty2.position = ccp(460 , 28);
    }
    
    gerty2IDNumber = gerty1IDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioGerty2BeingDestroyed = [CDXAudioNode audioNodeWithFile:@"GertyDestroyedWav.wav" soundEngine:soundEngine sourceId:gerty2IDNumber];
    [gerty2 addChild: audioGerty2BeingDestroyed];
    
    gerty2IDNumber = gerty1IDNumber + 2;
    totalSoundSources = totalSoundSources + 1;
    audioGerty2Fireworks = [CDXAudioNode audioNodeWithFile:@"FireworksVictory.wav" soundEngine:soundEngine sourceId:gerty2IDNumber];
    [gerty2 addChild: audioGerty2Fireworks];
    /*
     gerty2IDNumber = gerty1IDNumber + 1;
     totalSoundSources = totalSoundSources + 1;
     audioGertySad = [CDXAudioNodeSlingShot audioNodeWithFile:@"AudioSadGerty.caf" soundEngine:soundEngine sourceId:gerty2IDNumber];
     [gerty2 addChild: audioGertySad];
     
     gerty2IDNumber = gerty1IDNumber + 2;
     totalSoundSources = totalSoundSources + 1;
     audioPensiveGerty = [CDXAudioNodeSlingShot audioNodeWithFile:@"AudioPensiveGerty.caf" soundEngine:soundEngine sourceId:gerty2IDNumber];
     [gerty2 addChild: audioPensiveGerty];
     
     gerty2IDNumber = gerty1IDNumber + 3;
     totalSoundSources = totalSoundSources + 1;
     audioHappyGerty = [CDXAudioNodeSlingShot audioNodeWithFile:@"AudioHappyGerty.caf" soundEngine:soundEngine sourceId:gerty2IDNumber];
     [gerty2 addChild: audioHappyGerty];
     */
    
    if (isSinglePlayer) {
        
        enemyLabelInGame = [CCLabelBMFont labelWithString:@"ENEMY" fntFile:@"CasualWhite.fnt"];
        [zoombase addChild: enemyLabelInGame z:100];
        enemyLabelInGame.position = gerty2.position;
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
            
            enemyLabelInGame.scale = 1.5;
        }
        
        else {
            
            enemyLabelInGame.scale = 1.5/2;
        }
    }
    
    smokePlayer1 = [CCSprite spriteWithSpriteFrameName: @"smoke-hd.png"];
    [zoombase addChild: smokePlayer1 z:6];
    smokePlayer1IDNumber = gerty2IDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioElectricuteProjectile = [CDXAudioNode audioNodeWithFile:@"ElectrifyProjectile.caf" soundEngine:soundEngine sourceId:smokePlayer1IDNumber];
    [smokePlayer1 addChild: audioElectricuteProjectile];
    smokePlayer1.position = ccp(-300,-300);
    
    smokePlayer2 = [CCSprite spriteWithSpriteFrameName: @"smoke-hd.png"];
    [zoombase addChild: smokePlayer2 z: 6];
    smokePlayer2IDNumber = smokePlayer1IDNumber + 1;
    totalSoundSources = totalSoundSources + 1;
    audioElectricuteProjectile2 = [CDXAudioNode audioNodeWithFile:@"ElectrifyProjectile.caf" soundEngine:soundEngine sourceId:smokePlayer2IDNumber];
    [smokePlayer2 addChild: audioElectricuteProjectile2];
    smokePlayer2.position = ccp(-300,-300);
    
    /*
     blockExplosion = [[[CCParticleFireworks alloc] initWithTotalParticles:1000] autorelease];
     blockExplosion.position = gerty.position;
     blockExplosion.scale = 1.0;
     blockExplosion.duration = 2.0;
     blockExplosion.life = 2.0;
     blockExplosion.speed = 1000;
     //blockExplosion.gravity = ccp(-blockExplosionDirection.x*500, -680);
     blockExplosion.blendAdditive = NO;
     [zoombase addChild:blockExplosion];
     */
}

-(void) setDestroyedBlocksInARow1ToZero
{
    destroyedBlocksInARow1 = 0;
}

-(void) setDestroyedBlocksInARow2ToZero
{
    destroyedBlocksInARow2 = 0;
}

-(void) setupBombHasHitRectangleHenceNoBonus1ToNo
{
    bombHasHitRectangleHenceNoBonus1 = NO;
}

-(void) setupBombHasHitRectangleHenceNoBonus2ToNo
{
    bombHasHitRectangleHenceNoBonus2 = NO;
}

-(void) resetBomb1Variables
{
    //   player1BombInPlay = YES;
    //   player1BombExists = YES;
    player1BombZapped = NO;
    player1ProjectileIsZappable = YES;
    blockPointXValueOfMarble1 = 1000;
    bombHasHitRectangleHenceNoBonus1 = NO;
}

-(void) resetBomb2Variables
{
    //  player2BombInPlay = YES;
    //  player2BombExists = YES;
    player2BombZapped = NO;
    player2ProjectileIsZappable = YES;
    blockPointXValueOfMarble2 = -1000;
    bombHasHitRectangleHenceNoBonus2 = NO;
}

- (void) setupBombsPlayer1
{
    if ((player1BombExists == NO && player1Winner == NO && player2Winner == NO) || isGo == NO) {
        
        if (isGo) {
            
            [(Gerty*)gerty displayNoMarbles];
        }
        
        bomb = [Bomb bombWithGame:self];
        //bomb.position = ccp(-20, 150);
        
        if (playersCanTouchMarblesNow || player1IsTheWinnerScriptHasBeenPlayed || player2IsTheWinnerScriptHasBeenPlayed) {
            
            bomb.position = gerty.position;
        }
        
        else {
            
            bomb.position = SLING_BOMB_POSITION;
        }
        
        bomb.scale = 0.25;
        [zoombase addChild:bomb z:15];
        [_bombsPlayer1 addObject: bomb];
        player1BombCreated = YES;
        
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.0], [CCCallFunc actionWithTarget:self selector:@selector(setDestroyedBlocksInARow1ToZero)], nil]];
        
        audioIncomingProjectile1 = [CDXAudioNode audioNodeWithFile:@"IncomingProjectile.caf" soundEngine:soundEngine sourceId:sourceIDNumber];
        [bomb addChild:audioIncomingProjectile1];
        
        sourceIDNumber2 = sourceIDNumber + 1;
        audioMarbleHittingTable = [CDXAudioNode audioNodeWithFile:@"MarbleHittingTable.wav" soundEngine:soundEngine sourceId:sourceIDNumber2];
        [bomb addChild:audioMarbleHittingTable];
        
        if (isPlayer1) {
            
            [self sendPlayer1MarbleColor];
        }
    }
}

- (void) setupBombsPlayer2
{
    if ((player2BombExists == NO && player1Winner == NO && player2Winner == NO) || isGo == NO) {
        
        if (isGo) {
            
            [(Gerty2*)gerty2 displayNoMarbles];
        }
        
        bomb2 = [Bomb2 bombWithGame:self];
        //bomb.position = ccp(-20, 150);
        
        if (playersCanTouchMarblesNow || player1IsTheWinnerScriptHasBeenPlayed || player2IsTheWinnerScriptHasBeenPlayed) {
            
            bomb2.position = gerty2.position;
        }
        
        else {
            
            bomb2.position = SLING_BOMB_POSITION_2;
        }
        
        bomb2.scale = 0.25;
        [zoombase addChild:bomb2 z:15];
        [_bombsPlayer2 addObject:bomb2];
        player2BombCreated = YES;
        
        if (isSinglePlayer == YES) {
            
            computerNumberOfChargingRounds = 0;
        }
        
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.0], [CCCallFunc actionWithTarget:self selector:@selector(setDestroyedBlocksInARow2ToZero)], nil]];
        
        player2BombSourceIDNumber = sourceIDNumber2 + 1;
        audioIncomingProjectile2 = [CDXAudioNode audioNodeWithFile:@"IncomingProjectile.caf" soundEngine:soundEngine sourceId:player2BombSourceIDNumber];
        [bomb2 addChild:audioIncomingProjectile2];
        
        player2BombSourceIDNumber2 = player2BombSourceIDNumber + 1;
        audioMarble2HittingTable = [CDXAudioNode audioNodeWithFile:@"MarbleHittingTable.wav" soundEngine:soundEngine sourceId:player2BombSourceIDNumber2];
        [bomb2 addChild:audioMarble2HittingTable];
        
        if (!isPlayer1) {
            
            [self sendPlayer2MarbleColor];
        }
    }
}
/*
 -(void) removePlayer1Bomb
 {
 //    [bomb removeFromParentAndCleanup:YES];
 }
 */
-(void) removePlayer2Bomb
{
    //    [bomb2 removeFromParentAndCleanup:YES];
}

-(void) setMarblePlayer2IsReadyToSlingToNo
{
    marblePlayer2IsReadyToSling = NO;
}

-(void) marblePlayer2IsReadyToSlingMethod
{
    marblePlayer2IsReadyToSling = YES;
    player2BombInPlay = YES;
}
/*
 ptPlayer2 = [zoombase convertTouchToNodeSpace:touch];
 bombPtPlayer2 = ccp(525,166);
 player2Vector = ccpSub(ptPlayer2, bombPtPlayer2);
 normalVectorPlayer2 = ccpNormalize(player2Vector);
 lengthPlayer2 = ccpLength(player2Vector);
 
 currentBombPostionPlayer2 = ccpAdd(bombPtPlayer2, ccpMult(normalVectorPlayer2, lengthPlayer2));
 _curBombPlayer2.position = currentBombPostionPlayer2;
 */

- (void) calculateShotForTarget
{
    if (fireHighOrLow == 0) {
        
        //Fire High
        cpVect direction = cpvforangle(angle2);
        CGPoint force = cpvmult(ccp(direction.x, direction.y), computerLaunchVelocity);
        
        _curBombPlayer2.shape->body->v = force;
        
        int randomRotation = arc4random()%5;
        _curBombPlayer2.shape->body->w = -randomRotation;
    }
    
    else if (fireHighOrLow >= 1) {
        
        //Fire Low
        cpVect direction = cpvforangle(angle1);
        CGPoint force = cpvmult(ccp(direction.x, direction.y), computerLaunchVelocity);
        
        _curBombPlayer2.shape->body->v = force;
        
        int randomRotation = arc4random()%5;
        _curBombPlayer2.shape->body->w = -randomRotation;
    }
}

-(void) artificialIntelligenceLaunchMarbleMethod
{
    
    if (isSinglePlayer == YES && player2BombInPlay == YES && playersCanTouchMarblesNow == YES) {
        
        if (player2SlingIsSmoking == YES) {
            
            player2SlingIsSmoking = NO;
            [self stopAction: player2ChargingSmoke];
        }
        
        if (computerSettingNewVelocityandMovingBomb == YES) {
            
            [self stopAction: setNewVelocityAndMoveBomb2Action];
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.7], [CCCallFunc actionWithTarget:self selector:@selector(reducePlayer2BigSmokeCloudOpacity)], nil]];
        }
        
        CDXAudioNode *audioProjectileLaunch = [[sling1Player2 children] objectAtIndex:1];
        [audioProjectileLaunch play];
        
        [smgr morphShapeToActive:_curBombPlayer2.shape mass:30];
        [self calculateShotForTarget];
        computerWillLaunchWhenPlayerLaunches = NO;
        player2BombInPlay = NO;
        computerSettingNewVelocityandMovingBomb = NO;
        computerLaunchVelocityCoefficient = 0;
        
        if (computerNumberOfChargingRounds == 0) {
            
            doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = NO;
            teslaGlow2.opacity = 0;
            [self sendTeslaGlowOff];
        }
        /*
         else if (skillLevelBonus == 1 && computerNumberOfChargingRounds <= 1) {
         
         doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = NO;
         teslaGlow2.opacity = 0;
         [self sendTeslaGlowOff];
         }
         
         else if (skillLevelBonus == 2 && computerNumberOfChargingRounds <= 2) {
         
         doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = NO;
         teslaGlow2.opacity = 0;
         [self sendTeslaGlowOff];
         }
         */
    }
}

-(void) setNewVelocityAndMoveBomb2
{
    if (computerSettingNewVelocityandMovingBomb == YES && computerNumberOfChargingRounds < 4) {
        
        computerNumberOfChargingRounds = computerNumberOfChargingRounds + 1;
        NSLog (@"computerNumberOfChargingRounds = %i", computerNumberOfChargingRounds);
        
        if (computerNumberOfChargingRounds >= 1) {
            
            doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = YES;
            teslaGlow2.opacity = 150;
        }
        /*
         else if (skillLevelBonus == 1 && computerNumberOfChargingRounds >= 1) {
         
         doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = YES;
         teslaGlow2.opacity = 150;
         }
         
         else if (skillLevelBonus == 2 && computerNumberOfChargingRounds >= 1) {
         
         doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = YES;
         teslaGlow2.opacity = 150;
         }
         */
    }
    
    computerSettingNewVelocityandMovingBomb = YES;
    
    if (player2HasYellowBall == YES) {
        
        computerLaunchVelocity = 240*YELLOW_BALL_SPEED_MULTIPLIER + (computerLaunchVelocityCoefficient + skillLevelBonus*CHARGING_COEFFICIENT_STEP_1)*240*YELLOW_BALL_SPEED_MULTIPLIER;
        
        if (computerLaunchVelocityCoefficient < 0.6) {
            
            computerLaunchVelocityCoefficient = CHARGING_COEFFICIENT_STEP_1*computerNumberOfChargingRounds;
        }
        
        else {
            
            computerLaunchVelocityCoefficient = CHARGING_COEFFICIENT_STEP_3;
        }
    }
    
    else if (computerSettingNewVelocityandMovingBomb == YES && !player2HasYellowBall) {
        
        computerLaunchVelocity = 240 + (computerLaunchVelocityCoefficient + skillLevelBonus*CHARGING_COEFFICIENT_STEP_1)*240;
        
        if (computerLaunchVelocityCoefficient < 0.6) {
            
            computerLaunchVelocityCoefficient = CHARGING_COEFFICIENT_STEP_1*computerNumberOfChargingRounds;
        }
        
        else {
            
            computerLaunchVelocityCoefficient = 0.6;
        }
    }
    
    
    float x = randomTarget.x - _curBombPlayer2.position.x;
    float y = randomTarget.y - _curBombPlayer2.position.y;
    float g = -smgr.space->gravity.y;
    
    
    float tmp = pow(computerLaunchVelocity, 4) - g * (g * pow(x, 2) + 2 * y * pow(computerLaunchVelocity, 2));
    // NSLog (@"tmp = %f", tmp);
    
    if(tmp < 0){
        NSLog(@"No Firing Solution");
    }else{
        angle1 = atan2(pow(computerLaunchVelocity, 2) - sqrt(tmp), g * x);
        angle2 = atan2(pow(computerLaunchVelocity, 2) + sqrt(tmp), g * x);
    }
    
    //Move bomb2 to location SLING_BOMB_POSITION_2 + 25 towards angle1 or angle2
    
    if (fireHighOrLow == 0) {
        
        direction = cpvforangle(angle2);
    }
    
    else if (fireHighOrLow >= 1) {
        
        direction = cpvforangle(angle1);
    }
    
    //method sets new velocity, defines new moveToPoint, and moves bomb2 to moveToPoint
    CGPoint moveToPoint = ccpAdd(SLING_BOMB_POSITION_2, ccpMult(direction, -25));
    [_curBombPlayer2 runAction: [CCMoveTo actionWithDuration:0.1 position:moveToPoint]];
    //NSLog(@"direction = (%f, %f)", direction.x, direction.y);
    
    NSLog (@"CPU moveToPoint - (%f, %f)", moveToPoint.x, moveToPoint.y);
    
    //Chance of computer lauching this round of method call
    if (difficultyLevel == 0 && computerLaunchVelocityCoefficient > 0) {
        
        int chanceOfLaunchThisMethodCall = arc4random()%11;
        //  NSLog (@"chanceOfLaunchThisMethodCall = %i", chanceOfLaunchThisMethodCall);
        //  NSLog (@"computerNumberOfChargingRounds = %i", computerNumberOfChargingRounds);
        
        if (chanceOfLaunchThisMethodCall <= 5 || computerNumberOfChargingRounds >= 4) {
            
            [self artificialIntelligenceLaunchMarbleMethod];
        }
    }
    
    
    else if (difficultyLevel == 1) {
        
        if (!player1HasGreenBall) {
            
            computerWillLaunchWhenPlayerLaunches = YES;
        }
        
        int chanceOfLaunchThisMethodCall = arc4random()%11;
        
        if ((chanceOfLaunchThisMethodCall <= 3 || computerNumberOfChargingRounds >= 4)) {
            
            [self artificialIntelligenceLaunchMarbleMethod];
        }
    }
    
    /*    else if (difficultyLevel >= 2 && player2BombInPlay == YES) {
     
     if (!player1HasGreenBall) {
     
     computerWillLaunchWhenPlayerLaunches = YES;
     }
     
     int chanceOfLaunchThisMethodCall = arc4random()%11;
     
     if ((chanceOfLaunchThisMethodCall <= 9 || computerNumberOfChargingRounds >= 4)) {
     
     [self artificialIntelligenceLaunchMarbleMethod];
     }
     
     if (player2GiantSmokeCloudBackOpacity >= 255) {
     
     [self artificialIntelligenceLaunchMarbleMethod];
     }
     }
     */
}

-(void) artificialIntelligenceLaunchMethod
{
    /*   if (isSinglePlayer == YES && waitingForStartup == YES) {
     
     marblePlayer2IsReadyToSling = NO;
     
     fireHighOrLow = arc4random()%5;
     
     //Choose first target for computer
     //Choose a Block for Computer to Fire At
     NSArray *shapesArrayPlayer1Temp = [smgr getShapesAt:ccp(240, 160) radius:1000];
     
     for (NSValue *v in shapesArrayPlayer1Temp) {
     
     cpShape *shape = [v pointerValue];
     
     if (shape->collision_type == 3 && shape->body->p.x < 300) {
     
     NSNumber *shapeHashID = [NSNumber numberWithInt: shape->hashid];
     
     [player1ShapeHashID addObject: shapeHashID];
     }
     }
     
     int player1ShapeHashIDSize = [player1ShapeHashID count];
     //Gives me random object within the player1ShapeHashID MutableArray<---verify this
     int randomTargetHashIDNumber = arc4random()%player1ShapeHashIDSize;
     
     //Gives me the hashID number of the target wrapped in an NSNumber
     NSNumber *targetHashIDNumber = [player1ShapeHashID objectAtIndex: randomTargetHashIDNumber];
     
     //Gives me the hashID number in int form
     targetHashIDNumberInt = [targetHashIDNumber intValue];
     
     NSLog (@"[targetHashIDNumber intValue] = %i", [targetHashIDNumber intValue]);
     
     NSArray *shapesArrayPlayer1Temp2 = [smgr getShapesAt:ccp(240, 160) radius:1000];
     
     for (NSValue *v in shapesArrayPlayer1Temp2) {
     
     cpShape *shape2 = [v pointerValue];
     
     if (shape2->hashid == targetHashIDNumberInt) {
     
     randomTarget = shape2->body->p;
     }
     }
     
     
     //  NSLog (@"player1ShapeHashID Count = %i", [player1ShapeHashID count]);
     
     
     float x = randomTarget.x - SLING_BOMB_POSITION_2.x;
     float y = randomTarget.y - SLING_BOMB_POSITION_2.y;
     float g = -smgr.space->gravity.y;
     computerLaunchVelocity = 250;
     
     
     float tmp = pow(computerLaunchVelocity, 4) - g * (g * pow(x, 2) + 2 * y * pow(computerLaunchVelocity, 2));
     NSLog (@"tmp = %f", tmp);
     
     if(tmp < 0){
     NSLog(@"No Firing Solution");
     }else{
     angle1 = atan2(pow(computerLaunchVelocity, 2) - sqrt(tmp), g * x);
     angle2 = atan2(pow(computerLaunchVelocity, 2) + sqrt(tmp), g * x);
     }
     
     computerWillLaunchWhenPlayerLaunches = NO;
     computerChargeTime = arc4random()%13;
     NSLog (@"computerChargeTime = %i", computerChargeTime);
     
     if (computerChargeTime <= 12) {
     
     if (fireHighOrLow == 0) {
     
     //Move bomb2 to location SLING_BOMB_POSITION_2 + 25 towards angle2
     direction = cpvforangle(angle2);
     CGPoint force = cpvmult(ccp(direction.x, direction.y), computerLaunchVelocity);
     NSLog(@"direction = (%f, %f)", direction.x, direction.y);
     
     _curBombPlayer2.shape->body->v = force;
     }
     
     else if (fireHighOrLow >= 1) {
     
     //Move bomb2 to location SLING_BOMB_POSITION_2 + 25 towards angle1
     direction = cpvforangle(angle1);
     CGPoint force = cpvmult(ccp(direction.x, direction.y), computerLaunchVelocity);
     NSLog(@"direction = (%f, %f)", direction.x, direction.y);
     
     _curBombPlayer2.shape->body->v = force;
     }
     }
     
     int computerLaunchDelayTime;
     
     if (restartingLevel == NO) {
     
     computerLaunchDelayTime = 6.0;
     }
     
     else if (restartingLevel == YES) {
     
     computerLaunchDelayTime = 1.1;
     }
     
     [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: computerLaunchDelayTime], [CCCallFunc actionWithTarget:self selector:@selector(artificialIntelligenceLaunchMarbleMethod)], nil]];
     
     waitingForStartup = NO;
     }
     
     else {
     */
    
    marblePlayer2IsReadyToSling = NO;
    
    //Choose a Block for Computer to Fire At
    NSArray *shapesArrayPlayer1Temp = [smgr getShapesAt:ccp(240, 160) radius:1000];
    
    for (NSValue *v in shapesArrayPlayer1Temp) {
        
        cpShape *shape = [v pointerValue];
        
        if (shape->collision_type == 3 && shape->body->p.x < 300) {
            
            NSNumber *shapeHashID = [NSNumber numberWithInt: shape->hashid];
            
            [player1ShapeHashID addObject: shapeHashID];
        }
    }
    
    int player1ShapeHashIDSize = [player1ShapeHashID count];
    //Gives me random object within the player1ShapeHashID MutableArray<---verify this
    int randomTargetHashIDNumber = arc4random()%player1ShapeHashIDSize;
    
    //Gives me the hashID number of the target wrapped in an NSNumber
    NSNumber *targetHashIDNumber = [player1ShapeHashID objectAtIndex: randomTargetHashIDNumber];
    
    //Gives me the hashID number in int form
    targetHashIDNumberInt = [targetHashIDNumber intValue];
    
    NSLog (@"[targetHashIDNumber intValue] = %i", [targetHashIDNumber intValue]);
    
    NSArray *shapesArrayPlayer1Temp2 = [smgr getShapesAt:ccp(240, 160) radius:1000];
    
    for (NSValue *v in shapesArrayPlayer1Temp2) {
        
        cpShape *shape2 = [v pointerValue];
        
        if (shape2->hashid == targetHashIDNumberInt) {
            
            randomTarget = shape2->body->p;
        }
    }
    
    //What computer does to the target if computer is Novice
    if (difficultyLevel == 0) {
        
        computerWillLaunchWhenPlayerLaunches = NO;
        computerChargeTime = arc4random()%51;
        fireHighOrLow = arc4random()%5;
        //computerChargeTime = 11;
        NSLog (@"computerChargeTime = %i", computerChargeTime);
        
        if (computerChargeTime <= 12) {
            
            if (fireHighOrLow == 0) {
                
                CDXAudioNodeSlingShot *audioStretchingSling = [[sling1Player2 children] objectAtIndex:0];
                [audioStretchingSling play];
                
                //run action which calls setNewVelocityAndMoveBomb2 over and over every 3 seconds.
                setNewVelocityAndMoveBomb2Action = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(setNewVelocityAndMoveBomb2)], [CCDelayTime actionWithDuration: 3.0], [CCCallFunc actionWithTarget:self selector:@selector(setNewVelocityAndMoveBomb2)], [CCDelayTime actionWithDuration: 3.0], nil]]];
                
                [self increasePlayer2BigSmokeCloudOpacity];
                [self player2SlingIsSmoking];
                //  [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: computerChargeTime], [CCCallFunc actionWithTarget:self selector:@selector(artificialIntelligenceLaunchMarbleMethod)], nil]];
            }
            
            else if (fireHighOrLow >= 1) {
                
                CDXAudioNodeSlingShot *audioStretchingSling = [[sling1Player2 children] objectAtIndex:0];
                [audioStretchingSling play];
                
                //run action which calls setNewVelocityAndMoveBomb2 over and over every 3 seconds.
                setNewVelocityAndMoveBomb2Action = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(setNewVelocityAndMoveBomb2)], [CCDelayTime actionWithDuration: 3.0], [CCCallFunc actionWithTarget:self selector:@selector(setNewVelocityAndMoveBomb2)], [CCDelayTime actionWithDuration: 3.0], nil]]];
                
                [self increasePlayer2BigSmokeCloudOpacity];
                [self player2SlingIsSmoking];
                //  [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: (computerChargeTime + 1)], [CCCallFunc actionWithTarget:self selector:@selector(artificialIntelligenceLaunchMarbleMethod)], nil]];
            }
        }
        
        else if (computerChargeTime >= 13 && computerChargeTime <= 30) {
            
            //add short delay before CPU launches their ball in response to player launching theirs
            //int delayTime = arc4random()%15;
            
            //This BOOL (computerWillLaunchWhenPlayerLaunches) is polled in the TouchEnded method when player launches ball.  It is turned off again right above.
            //  [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: (delayTime)/10], [CCCallFunc actionWithTarget:self selector:@selector(setComputerWillLaunchWhenPlayerLaunchesToYes)], nil]];
            
            CDXAudioNodeSlingShot *audioStretchingSling = [[sling1Player2 children] objectAtIndex:0];
            [audioStretchingSling play];
            
            setNewVelocityAndMoveBomb2Action = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(setNewVelocityAndMoveBomb2)], [CCDelayTime actionWithDuration: 3.0], [CCCallFunc actionWithTarget:self selector:@selector(setNewVelocityAndMoveBomb2)], [CCDelayTime actionWithDuration: 3.0], nil]]];
            
            [self runAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(setComputerWillLaunchWhenPlayerLaunchesToYes)], nil]];
            
            //Move bomb2 to location SLING_BOMB_POSITION_2 + 25 towards angle1
            direction = cpvforangle(angle1);
            CGPoint moveToPoint = ccpAdd(SLING_BOMB_POSITION_2, ccpMult(direction, -25));
            [_curBombPlayer2 runAction: [CCMoveTo actionWithDuration:0.1 position:moveToPoint]];                        NSLog(@"direction = (%f, %f)", direction.x, direction.y);
            
            [self increasePlayer2BigSmokeCloudOpacity];
            [self player2SlingIsSmoking];
        }
        
        else if (computerChargeTime >= 31 && computerChargeTime <= 50) {
            
            //Wait and See What Player Does for 0-4 Seconds
            int waitAndSeeTime = arc4random()%5;
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: waitAndSeeTime],[CCCallFunc actionWithTarget:self selector:@selector(setMarblePlayer2IsReadyToSlingToNo)], [CCCallFunc actionWithTarget:self selector:@selector(marblePlayer2IsReadyToSlingMethod)], nil]];
        }
    }
    
    //If CPU is Level1
    else if (difficultyLevel == 1) {
        
        computerWillLaunchWhenPlayerLaunches = NO;
        computerChargeTime = arc4random()%13;
        fireHighOrLow = arc4random()%5;
        //computerChargeTime = 11;
        NSLog (@"computerChargeTime = %i", computerChargeTime);
        
        if (computerChargeTime <= 12) {
            
            if (fireHighOrLow == 0) {
                
                CDXAudioNodeSlingShot *audioStretchingSling = [[sling1Player2 children] objectAtIndex:0];
                [audioStretchingSling play];
                
                //run action which calls setNewVelocityAndMoveBomb2 over and over every 3 seconds.
                setNewVelocityAndMoveBomb2Action = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(setNewVelocityAndMoveBomb2)], [CCDelayTime actionWithDuration: 3.0], [CCCallFunc actionWithTarget:self selector:@selector(setNewVelocityAndMoveBomb2)], [CCDelayTime actionWithDuration: 3.0], nil]]];
                
                [self increasePlayer2BigSmokeCloudOpacity];
                [self player2SlingIsSmoking];
                //  [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: computerChargeTime], [CCCallFunc actionWithTarget:self selector:@selector(artificialIntelligenceLaunchMarbleMethod)], nil]];
            }
            
            else if (fireHighOrLow >= 1) {
                
                CDXAudioNodeSlingShot *audioStretchingSling = [[sling1Player2 children] objectAtIndex:0];
                [audioStretchingSling play];
                
                //run action which calls setNewVelocityAndMoveBomb2 over and over every 3 seconds.
                setNewVelocityAndMoveBomb2Action = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(setNewVelocityAndMoveBomb2)], [CCDelayTime actionWithDuration: 3.0], [CCCallFunc actionWithTarget:self selector:@selector(setNewVelocityAndMoveBomb2)], [CCDelayTime actionWithDuration: 3.0], nil]]];
                
                [self increasePlayer2BigSmokeCloudOpacity];
                [self player2SlingIsSmoking];
                //  [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: (computerChargeTime + 1)], [CCCallFunc actionWithTarget:self selector:@selector(artificialIntelligenceLaunchMarbleMethod)], nil]];
            }
        }
    }
    
    
    //If CPU is Level 3
    else if (difficultyLevel >= 2) {
        
        computerWillLaunchWhenPlayerLaunches = NO;
        computerChargeTime = arc4random()%13;
        fireHighOrLow = arc4random()%5;
        //computerChargeTime = 11;
        NSLog (@"computerChargeTime = %i", computerChargeTime);
        
        if (computerChargeTime <= 12) {
            
            if (fireHighOrLow == 0) {
                
                CDXAudioNodeSlingShot *audioStretchingSling = [[sling1Player2 children] objectAtIndex:0];
                [audioStretchingSling play];
                
                //run action which calls setNewVelocityAndMoveBomb2 over and over every 3 seconds.
                setNewVelocityAndMoveBomb2Action = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(setNewVelocityAndMoveBomb2)], [CCDelayTime actionWithDuration: 3.0], [CCCallFunc actionWithTarget:self selector:@selector(setNewVelocityAndMoveBomb2)], [CCDelayTime actionWithDuration: 3.0], nil]]];
                
                [self increasePlayer2BigSmokeCloudOpacity];
                [self player2SlingIsSmoking];
                //  [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: computerChargeTime], [CCCallFunc actionWithTarget:self selector:@selector(artificialIntelligenceLaunchMarbleMethod)], nil]];
            }
            
            else if (fireHighOrLow >= 1) {
                
                CDXAudioNodeSlingShot *audioStretchingSling = [[sling1Player2 children] objectAtIndex:0];
                [audioStretchingSling play];
                
                //run action which calls setNewVelocityAndMoveBomb2 over and over every 3 seconds.
                setNewVelocityAndMoveBomb2Action = [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCCallFunc actionWithTarget:self selector:@selector(setNewVelocityAndMoveBomb2)], [CCDelayTime actionWithDuration: 3.0], [CCCallFunc actionWithTarget:self selector:@selector(setNewVelocityAndMoveBomb2)], [CCDelayTime actionWithDuration: 3.0], nil]]];
                
                [self increasePlayer2BigSmokeCloudOpacity];
                [self player2SlingIsSmoking];
                //  [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: (computerChargeTime + 1)], [CCCallFunc actionWithTarget:self selector:@selector(artificialIntelligenceLaunchMarbleMethod)], nil]];
            }
        }
    }
}



-(void) setComputerWillLaunchWhenPlayerLaunchesToYes
{
    computerWillLaunchWhenPlayerLaunches = YES;
}

- (void) setupNextBombPlayer1
{
    if ([_bombsPlayer1 count]) {
        
        _curBomb = [_bombsPlayer1 lastObject];
        
        player1BombExists = YES;
        
        //move it into position
        //[_curBomb runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.6], [CCMoveTo actionWithDuration:0.6 position:SLING_BOMB_POSITION], [CCCallFunc actionWithTarget:self selector:@selector(resetBomb1Variables)],  nil]];
        
        if (player1Winner == NO && player2Winner == NO) {
            
            [_curBomb runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCMoveTo actionWithDuration:0.3 position:ccp(SLING_BOMB_POSITION.x - 30, SLING_BOMB_POSITION.y/2 + 30)], [CCMoveTo actionWithDuration:0.3 position:ccp(SLING_BOMB_POSITION.x, SLING_BOMB_POSITION.y)], [CCCallFunc actionWithTarget:self selector:@selector(resetBomb1Variables)],  nil]];
        }
        
        
        [_bombsPlayer1 removeLastObject];
        
        player1ProjectileCanBeTouchedAgain = YES;
    }
}

- (void) setupNextBombPlayer2
{
    if ([_bombsPlayer2 count]) {
        
        _curBombPlayer2 = [_bombsPlayer2 lastObject];
        
        player2BombExists = YES;
        
        //move it into position
        //[_curBombPlayer2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.6], [CCMoveTo actionWithDuration:0.6 position:SLING_BOMB_POSITION_2], [CCCallFunc actionWithTarget:self selector:@selector(resetBomb2Variables)], nil]];
        
        if (player1Winner == NO && player2Winner == NO) {
            
            [_curBombPlayer2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.3], [CCMoveTo actionWithDuration:0.3 position:ccp(SLING_BOMB_POSITION_2.x + 30, SLING_BOMB_POSITION_2.y/2 + 30)], [CCMoveTo actionWithDuration:0.3 position:ccp(SLING_BOMB_POSITION_2.x, SLING_BOMB_POSITION_2.y)], [CCCallFunc actionWithTarget:self selector:@selector(resetBomb2Variables)],  nil]];
        }
        
        [_bombsPlayer2 removeLastObject];
        
        player2ProjectileCanBeTouchedAgain = YES;
    }
    
    if (isSinglePlayer == YES) {
        [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.3], [CCCallFunc actionWithTarget:self selector:@selector(marblePlayer2IsReadyToSlingMethod)], nil]];
    }
}

- (void) setupRestart
{
	CCMenuItem *restart = [CCMenuItemImage itemFromNormalImage:@"restart.png"
												 selectedImage:@"restartsel.png"
														target:self
													  selector:@selector(restart:)];
	restart.position = ccp(-220,-140);
	[hudLayer addChild:[CCMenu menuWithItems:restart,nil] z:100];
}
/*
 - (CCNode<cpCCNodeProtocol>*) createBlockAt:(cpVect)pt
 width:(int)w
 height:(int)h
 mass:(int)mass
 {
 cpShape *shape = [smgr addRectAt:pt mass:mass width:w height:h rotation:0];
 shape->collision_type = kBlockCollisionType;
 
 cpShapeNode *node = [cpShapeNode nodeWithShape:shape];
 node.color = ccc3(56+rand()%200, 56+rand()%200, 56+rand()%200);
 
 shape->u = 5.0;  shape->e = 0.0;
 
 [self addChild:node z:5];
 
 return node;
 }
 */
/*
 - (CCNode<cpCCNodeProtocol>*) createTriangleAt:(cpVect)pt
 size:(int)size
 mass:(int)mass
 {
 CGPoint d1 = ccpForAngle(CC_DEGREES_TO_RADIANS(330));
 CGPoint d2 = ccpForAngle(CC_DEGREES_TO_RADIANS(210));
 CGPoint d3 = ccpForAngle(CC_DEGREES_TO_RADIANS(90));
 
 d1 = ccpMult(d1, size);
 d2 = ccpMult(d2, size);
 d3 = ccpMult(d3, size);
 
 cpShape *shape = [smgr addPolyAt:pt mass:mass rotation:0 numPoints:3 points:d1,d2,d3,nil];
 shape->collision_type = kBlockCollisionType;
 
 cpShapeNode *node = [cpShapeNode nodeWithShape:shape];
 node.color = ccc3(100, 20, 40);
 
 [self addChild:node];
 
 return node;
 }
 */

-(void) playPlayer1ExplodingBombSound
{
    audioBombExplosionPlayer1 = [[bombExplosionPlayer1 children] objectAtIndex:0];
    [audioBombExplosionPlayer1 play];
}

-(void) stopAllActionsInParallaxNodePlayer1
{
    if (isPlayer1) {
        
        [parallaxNode stopAction: followPlayer1Marble];
    }
    
    if (player1HasBlackBall == YES && player1BombZapped == NO) {
        
        bombExplosionPlayer1.position = bomb.position;
        [bombExplosionPlayer1 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.0], [CCFadeIn actionWithDuration: 0.05], [CCCallFunc actionWithTarget:self selector:@selector(playPlayer1ExplodingBombSound)], [CCFadeOut actionWithDuration: 0.05], [CCDelayTime actionWithDuration:4.0], [CCMoveTo actionWithDuration:0.0 position:ccp(-300, 300)], nil]];
        
        NSLog (@"bombExplosionPlayer1 should be going off");
        
        if (_curBomb) {
            
            NSArray *shapesArrayPlayer1Temp = [smgr getShapesAt:_curBomb.position radius:45];
            
            for (NSValue *v in shapesArrayPlayer1Temp) {
                
                cpShape *shape = [v pointerValue];
                
                if (shape->collision_type == 3 && shape->layers == bomb.shape->layers) {
                    
                    [(RectangleShape*)shape->data addDamage:100];
                }
            }
            
            NSArray *shapesArrayPlayer1Temp2 = [smgr getShapesAt:_curBomb.position radius:70];
            
            for (NSValue *v in shapesArrayPlayer1Temp2) {
                
                cpShape *shape = [v pointerValue];
                
                if (shape->collision_type == 3 && shape->layers == bomb.shape->layers) {
                    
                    [(RectangleShape*)shape->data addDamage:35];
                }
            }
        }
    }
}

-(void) playPlayer2ExplodingBombSound
{
    audioBombExplosionPlayer2 = [[bombExplosionPlayer2 children] objectAtIndex:0];
    [audioBombExplosionPlayer2 play];
}

-(void) stopAllActionsInParallaxNodePlayer2
{
    if (!isPlayer1) {
        
        [parallaxNode stopAction: followPlayer2Marble];
    }
    
    if (player2HasBlackBall == YES && player2BombZapped == NO) {
        
        bombExplosionPlayer2.position = bomb2.position;
        [bombExplosionPlayer2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.0], [CCFadeIn actionWithDuration: 0.05], [CCCallFunc actionWithTarget:self selector:@selector(playPlayer2ExplodingBombSound)], [CCFadeOut actionWithDuration: 0.05], [CCDelayTime actionWithDuration:4.0], [CCMoveTo actionWithDuration:0.0 position:ccp(-300, 300)], nil]];
        
        NSLog (@"bombExplosionPlayer2 should be going off");
        
        if (_curBombPlayer2) {
            
            NSArray *shapesArrayPlayer2Temp = [smgr getShapesAt:_curBombPlayer2.position radius:45];
            
            for (NSValue *v in shapesArrayPlayer2Temp) {
                
                cpShape *shape = [v pointerValue];
                
                if (shape->collision_type == 3 && shape->layers == bomb2.shape->layers) {
                    
                    [(RectangleShape*)shape->data addDamage:100];
                }
            }
            
            NSArray *shapesArrayPlayer2Temp2 = [smgr getShapesAt:_curBombPlayer2.position radius:70];
            
            for (NSValue *v in shapesArrayPlayer2Temp2) {
                
                cpShape *shape = [v pointerValue];
                
                if (shape->collision_type == 3 && shape->layers == bomb2.shape->layers) {
                    
                    [(RectangleShape*)shape->data addDamage:35];
                }
            }
        }
    }
}

-(void) whitePoof: (CGPoint) position
{
    CCSprite *poof = [CCSprite spriteWithSpriteFrameName:@"dustcloud-hd.png"];
    [zoombase addChild:poof z:6];
    poof.scale = 0.2;
    poof.position = position;
    
    [poof runAction: [CCScaleBy actionWithDuration:2.0 scale:2.0]];
    [poof runAction: [CCFadeOut actionWithDuration:2.0]];
    
    [poof runAction: [CCSequence actions: [CCDelayTime actionWithDuration:2.0], [CCCallFuncND actionWithTarget:poof selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], nil]];
}

-(void) syncShapesOntoPlayer1ThreeTimes
{
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3.5], [CCCallFunc actionWithTarget:self selector:@selector(sendRequestBlockInfoFromPlayer2)], nil]];
}

-(void) syncShapesOntoPlayer2ThreeTimes
{
    [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3.5], [CCCallFunc actionWithTarget:self selector:@selector(sendRequestBlockInfoFromPlayer1)], nil]];
}

-(void) makeVictoryOrLossScreenButtonsVisible
{
    continuePlayingGame.visible = NO;
    
    if (isSinglePlayer) {
        
        [self clearAndRestartLevelFromVictoryOrLossScreen];
        
        isGo = NO;
        playersCanTouchMarblesNow = NO;
        isAtMainMenu = NO;
        
        //     if (player1Winner == YES) {
        
        if (deviceIsWidescreen) {
            
            backToMainMenu.position = ccp(tamagachi.position.x + 60, tamagachi.position.y - 85);
            backToMainMenu.visible = YES;
            backToMainMenu.scale = 0.22;
            
            playButton.position = ccp([linedPaper contentSize].width/2 + 10, [linedPaper contentSize].height/2 -133);
            
            playButton.visible = YES;
            playButton.scale = 0.22;
        }
        
        if (!deviceIsWidescreen) {
            
            backToMainMenu.position = ccp(tamagachi.position.x + 70, tamagachi.position.y - 85);
            backToMainMenu.visible = YES;
            backToMainMenu.scale = 0.22;
            
            playButton.position = ccp([linedPaper contentSize].width/2 - 8, [linedPaper contentSize].height/2 -133);
            
            playButton.visible = YES;
            playButton.scale = 0.22;
        }
        
        //     }
        /*
         else if (player1Winner == NO) {
         
         //backToMainMenu.position = ccp(backToMainMenu.position.x + 40, backToMainMenu.position.y - 250);
         backToMainMenu.position = ccp(tamagachi.position.x + 70, tamagachi.position.y - 85);
         backToMainMenu.visible = YES;
         backToMainMenu.scale = 0.22;
         
         restartLevel.position = ccp(restartLevel.position.x - 40, restartLevel.position.y - 250);
         restartLevel.visible = YES;
         restartLevel.scale = 0.22;
         }
         */
    }
    
    else if (!isSinglePlayer) {
        
        NSLog (@"backToMainMenu button should be visible now!");
        
        [self clearAndRestartMultiplayerMatch];
        
        //backToMainMenu.position = ccp(backToMainMenu.position.x + 40, backToMainMenu.position.y - 250);
        backToMainMenu.position = ccp([linedPaper contentSize].width/2 - 50, [linedPaper contentSize].height/2 -133);
        backToMainMenu.visible = YES;
        backToMainMenu.scale = 0.22;
        
        playButton.position = ccp([linedPaper contentSize].width/2 - 8, [linedPaper contentSize].height/2 -133);
        
        if (opponentDisconnected == NO) {
            
            playButton.visible = YES;
        }
        
        playButton.scale = 0.22;
    }
}

-(void) player1IsTheWinnerScript
{
    [self setFirstPlayerHandicapInvisible];
    [self setSecondPlayerHandicapInvisible];
    
    if (showAds == YES) {
        
        //[adWhirlView doNotIgnoreNewAdRequests];
        //[adWhirlView requestFreshAd];
    }
    
    if (!isSinglePlayer) {
        
        int tamagachiMultiplayerSpacing;
        
        if (deviceIsWidescreen) {
            
            tamagachiMultiplayerSpacing = 25;
        }
        
        if (!deviceIsWidescreen) {
            
            tamagachiMultiplayerSpacing = 0;
        }
        
        //Tamgachi Move To Positions
        [tamagachiMultiplayer runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.6], [CCEaseOut actionWithAction: [CCMoveTo actionWithDuration: 0.6  position: ccp(([linedPaper contentSize].width/2 - 122 + tamagachiMultiplayerSpacing), [linedPaper contentSize].height/2 - 50)] rate: 3.0], nil]];
        [tamagachi2Multiplayer runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.6], [CCEaseOut actionWithAction: [CCMoveTo actionWithDuration: 0.6  position: ccp(([linedPaper contentSize].width/2 + 45 + tamagachiMultiplayerSpacing), [linedPaper contentSize].height/2 - 50)] rate: 3.0], nil]];
    }
    
    
    if (isPlayer1) {
        
        [(Gerty*)gerty setAllSlotMarblesToNotVisible];
    }
    
    else if (!isPlayer1) {
        
        [(Gerty2*)gerty2 setAllSlotMarblesToNotVisible];
    }
    
    //If gerty2 is destroyed, make sure all slot marbles for Gerty2 are invisble
    [(Gerty2*)gerty2 makeAllSlotMarblesNotVisibleAndGertyFaces];
    
    whiteProgressDot1.visible = NO;
    whiteProgressDot2.visible = NO;
    whiteProgressDot3.visible = NO;
    whiteProgressDot4.visible = NO;
    whiteProgressDot5.visible = NO;
    
    inGameCountdownStarted = NO;
    
    playbuttonPushed = NO;
    pauseButton.visible = NO;
    playButton.visible = NO;
    
    player1IsTheWinnerScriptHasBeenPlayed = YES;
    isGo = NO;
    
    playersCanTouchMarblesNow = NO;
    
    player2GertyShouldBeDead = YES;
    
    player1Winner = YES;
    player2Winner = NO;
    
    restartLevel.visible = NO;
    continuePlayingGame.visible = NO;
    backToMainMenu.visible = NO;
    
    if (isSinglePlayer) {
        
        happyGerty.visible = YES;
        sadGerty.visible = NO;
        uncertainGerty.visible = NO;
        cryingGerty.visible = NO;
        
        happyGerty2.visible = NO;
        sadGerty2.visible = NO;
        uncertainGerty2.visible = NO;
        cryingGerty2.visible = YES;
    }
    
    else if (!isSinglePlayer) {
        
        happyGertyTamagachiMultiplayer.visible = YES;
        sadGertyTamagachiMultiplayer.visible = NO;
        uncertainGertyTamagachiMultiplayer.visible = NO;
        cryingGertyTamagachiMultiplayer.visible = NO;
        pensiveGertyTamagachiMultiplayer.visible = NO;
        
        happyGerty2TamagachiMultiplayer.visible = NO;
        sadGerty2TamagachiMultiplayer.visible = NO;
        uncertainGerty2TamagachiMultiplayer.visible = NO;
        cryingGerty2TamagachiMultiplayer.visible = YES;
        pensiveGerty2TamagachiMultiplayer.visible = NO;
    }
    
    blockExplosion = [[[CCParticleFireworks alloc] initWithTotalParticles:300] autorelease];
    blockExplosion.position = gerty.position;
    blockExplosion.scale = 1.0;
    blockExplosion.duration = 7.0;
    blockExplosion.life = 7.0;
    blockExplosion.speed = 225;
    //blockExplosion.gravity = ccp(-blockExplosionDirection.x*500, -680);
    blockExplosion.autoRemoveOnFinish = YES;
    blockExplosion.blendAdditive = NO;
    [zoombase addChild:blockExplosion];
    
    audioGerty2Fireworks = [[gerty2 children] objectAtIndex:13];
    [audioGerty2Fireworks play];
    
    [self sendPlayer2GertyShouldBeDead];
    
    if (isSinglePlayer) {
        
        //Sets tamagachi1 and tamagachi2 postions as you press woodBlock
        if (deviceIsWidescreen) {
            
            tamagachi.position = ccp([linedPaper contentSize].width/2 - 90, [linedPaper contentSize].height/2 - 50);
            tamagachi2.position = ccp([linedPaper contentSize].width/2 + 65, [linedPaper contentSize].height/2 - 50);
        }
        
        if (!deviceIsWidescreen) {
            
            tamagachi.position = ccp([linedPaper contentSize].width/2 - 115, [linedPaper contentSize].height/2 - 50);
            tamagachi2.position = ccp([linedPaper contentSize].width/2 + 40, [linedPaper contentSize].height/2 - 50);
        }
        
        player1ExperiencePointsToAdd = 6 + bonusPoints1;
        
        if (player1ExperiencePoints + 6 + bonusPoints1 >= 100) {
            
            player1ExperiencePoints = (player1ExperiencePoints + 6 + bonusPoints1) - 100;
            player1Level = player1Level + 100;
            player1MarblesUnlocked = player1MarblesUnlocked + 1;
        }
        
        else {
            
            player1ExperiencePoints = player1ExperiencePoints + 6 + bonusPoints1;
        }
        
        
        if (computerExperiencePoints != 90) {
            
            computerExperiencePoints = computerExperiencePoints + 10;
        }
        
        else if (computerExperiencePoints == 90) {
            
            difficultyLevel = difficultyLevel + 1;
            computerExperiencePoints = 10;
        }
        
        //[self unlockNextGertyInGrid];
        [self saveGameSettings];
        
        [(Gerty2*)gerty2 blowup];
        
        winnerLabel.visible = YES;
        //[self sendGameOver: true];
        
        CCSprite *winnerLabelShadow = [CCLabelBMFont labelWithString:@"Winner!"  fntFile:@"CasualWhite.fnt"];
        winnerLabelShadow.position = ccp(240,180);
        [hudLayer addChild:winnerLabelShadow z:10];
        
        winnerLabelShadow.position = winnerLabel.position;
        winnerLabelShadow.anchorPoint = ccp(0.5, 0.5);
        [winnerLabelShadow setOpacity: 185];
        
        [winnerLabelShadow runAction: [CCScaleBy actionWithDuration:0.35 scale:1.5]];
        [winnerLabelShadow runAction: [CCSequence actions: [CCFadeOut actionWithDuration:0.35], [CCCallFuncND actionWithTarget:winnerLabelShadow selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], nil]];
        
        getReadyLabel.visible = NO;
        
        //make player's gerty happy
        tamagachi.visible = YES;
        happyGerty2.visible = YES;
        sadGerty2.visible = NO;
        uncertainGerty2.visible = NO;
        cryingGerty2.visible = NO;
        
        //make computer gerty sad
        happyGerty2.visible = NO;
        sadGerty2.visible = NO;
        uncertainGerty2.visible = NO;
        cryingGerty2.visible = YES;
        
        // [tamagachi2 runAction: [CCMoveBy actionWithDuration:0.0 position:ccp(300, 0)]];
        
        [linedPaper runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3], [CCMoveTo actionWithDuration: 1.0 position: ccp(0,0)],[CCDelayTime actionWithDuration: 2.0], [CCCallFunc actionWithTarget:self selector:@selector(addPointsToTamagachiToPlayer1)], nil]];
    }
    
    else if (isPlayer1 && !isSinglePlayer) {
        
        //    tamagachi.visible = NO;
        
        player1ExperiencePointsToAdd = 10 + bonusPoints1;
        
        if (player1ExperiencePoints + 10 + bonusPoints1 >= 100) {
            
            player1ExperiencePoints = (player1ExperiencePoints + 10 + bonusPoints1) - 100;
            player1Level = player1Level + 100;
            player1MarblesUnlocked = player1MarblesUnlocked + 1;
        }
        
        else {
            
            player1ExperiencePoints = player1ExperiencePoints + 10 + bonusPoints1;
        }
        
        winnerLabel.visible = YES;
        //  [self sendGameOver: true];
        
        CCSprite *winnerLabelShadow = [CCLabelBMFont labelWithString:@"Winner!"  fntFile:@"CasualWhite.fnt"];
        winnerLabelShadow.position = ccp(240,180);
        [hudLayer addChild:winnerLabelShadow z:10];
        
        winnerLabelShadow.position = winnerLabel.position;
        winnerLabelShadow.anchorPoint = ccp(0.5, 0.5);
        [winnerLabelShadow setOpacity: 185];
        
        [winnerLabelShadow runAction: [CCScaleBy actionWithDuration:0.35 scale:1.5]];
        [winnerLabelShadow runAction: [CCSequence actions: [CCFadeOut actionWithDuration:0.35], [CCCallFuncND actionWithTarget:winnerLabelShadow selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], nil]];
        
        getReadyLabel.visible = NO;
        
        //put a graphic that portrays player 1 getting +0 point for losing
        player2PointsLabelZero = [CCLabelBMFont labelWithString:@"+0" fntFile:@"GertyLevel.fnt"];
        
        player2PointsLabelZero.color = ccBLUE;
        player2PointsLabelZero.position = ccp((tamagachi2Multiplayer.position.x - 175), (tamagachi2Multiplayer.position.y + 25));
        player2PointsLabelZero.anchorPoint = ccp(0.5, 0.5);
        player2PointsLabelZero.scale = 0.8;
        
        [player2PointsLabelZero runAction: [CCFadeOut actionWithDuration:0.0]];
        
        [player2PointsLabelZero runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCFadeIn actionWithDuration: 0.7], [CCDelayTime actionWithDuration: 1.6], [CCFadeOut actionWithDuration:0.8], nil]];
        
        [player2PointsLabelZero runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 7.3], [CCEaseIn actionWithAction: [CCMoveBy actionWithDuration:1.0 position:ccp(0, -15)] rate: 2.0], nil]];
        
        [tamagachi2Multiplayer addChild: player2PointsLabelZero z:1000];
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
            
            player2PointsLabelZero.scaleX = 0.75;
            player2PointsLabelZero.scaleY = 0.75;
        }
        
        else {
            
            player2PointsLabelZero.scaleX = 0.75/2;
            player2PointsLabelZero.scaleY = 0.75/2;
        }
        
        [(Gerty2*)gerty2 blowup];
        
        [linedPaper runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3], [CCMoveTo actionWithDuration: 1.0 position: ccp(0,0)],[CCDelayTime actionWithDuration: 2.0], [CCCallFunc actionWithTarget:self selector:@selector(addPointsToTamagachiToPlayer1)], nil]];
    }
    
    else if (!isPlayer1 && !isSinglePlayer) {
        
        //      tamagachi.visible = NO;
        
        player1ExperiencePointsToAdd = 10 + bonusPoints1;
        
        lostLabel.visible = YES;
        
        getReadyLabel.visible = NO;
        
        player2PointsLabelZero = [CCLabelBMFont labelWithString:@"+0" fntFile:@"GertyLevel.fnt"];
        
        player2PointsLabelZero.color = ccBLUE;
        player2PointsLabelZero.position = ccp((tamagachi2Multiplayer.position.x - 175), (tamagachi2Multiplayer.position.y + 25));
        player2PointsLabelZero.anchorPoint = ccp(0.5, 0.5);
        player2PointsLabelZero.scale = 0.8;
        
        [player2PointsLabelZero runAction: [CCFadeOut actionWithDuration:0.0]];
        
        [player2PointsLabelZero runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCFadeIn actionWithDuration: 0.7], [CCDelayTime actionWithDuration: 1.6], [CCFadeOut actionWithDuration:0.8], [CCDelayTime actionWithDuration: 1.5], nil]];
        
        [player2PointsLabelZero runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 7.3], [CCEaseIn actionWithAction: [CCMoveBy actionWithDuration:1.0 position:ccp(0, -15)] rate: 2.0], nil]];
        
        [tamagachi2Multiplayer addChild: player2PointsLabelZero z:1000];
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
            
            player2PointsLabelZero.scaleX = 0.75;
            player2PointsLabelZero.scaleY = 0.75;
        }
        
        else {
            
            player2PointsLabelZero.scaleX = 0.75/2;
            player2PointsLabelZero.scaleY = 0.75/2;
        }
        
        [linedPaper runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3], [CCMoveTo actionWithDuration: 1.0 position: ccp(0,0)],[CCDelayTime actionWithDuration: 2.0], [CCCallFunc actionWithTarget:self selector:@selector(addPointsToTamagachiToPlayer1)], nil]];
    }
    
    [linedPaper runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 4.5], [CCCallFunc actionWithTarget:self selector:@selector(saveGameSettings)], nil]];
}

-(void) player2IsTheWinnerScript
{
    [self setFirstPlayerHandicapInvisible];
    [self setSecondPlayerHandicapInvisible];
    
    if (showAds == YES) {
        
        //[adWhirlView doNotIgnoreNewAdRequests];
        //[adWhirlView requestFreshAd];
    }
    
    if (!isSinglePlayer) {
        
        int tamagachiMultiplayerSpacing;
        
        if (deviceIsWidescreen) {
            
            tamagachiMultiplayerSpacing = 25;
        }
        
        if (!deviceIsWidescreen) {
            
            tamagachiMultiplayerSpacing = 0;
        }
        
        //Tamgachi Move To Positions
        [tamagachiMultiplayer runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.6], [CCEaseOut actionWithAction: [CCMoveTo actionWithDuration: 0.6  position: ccp(([linedPaper contentSize].width/2 - 122 + tamagachiMultiplayerSpacing), [linedPaper contentSize].height/2 - 50)] rate: 3.0], nil]];
        [tamagachi2Multiplayer runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 0.6], [CCEaseOut actionWithAction: [CCMoveTo actionWithDuration: 0.6  position: ccp(([linedPaper contentSize].width/2 + 45 + tamagachiMultiplayerSpacing), [linedPaper contentSize].height/2 - 50)] rate: 3.0], nil]];
    }
    
    /*
     //Stop the increaseBigSmokeCloudOpacityAction if player1 or player2's marble has been touched
     if (player2ProjectileHasBeenTouched || stretchingSling2SoundReady == NO) {
     
     [self stopAction: increasePlayer2BigSmokeCloudOpacityAction];
     }
     
     if (player1ProjectileHasBeenTouched || stretchingSling2SoundReady == NO) {
     
     [self stopAction: increaseBigSmokeCloudOpacityAction];
     }
     */
    
    if (isPlayer1) {
        
        [(Gerty*)gerty setAllSlotMarblesToNotVisible];
    }
    
    else if (!isPlayer1) {
        
        [(Gerty2*)gerty2 setAllSlotMarblesToNotVisible];
    }
    
    //If gerty is destroyed, make sure all slot marbles for Gerty are invisble
    [(Gerty*)gerty makeAllSlotMarblesNotVisibleAndGertyFaces];
    
    whiteProgressDot1.visible = NO;
    whiteProgressDot2.visible = NO;
    whiteProgressDot3.visible = NO;
    whiteProgressDot4.visible = NO;
    whiteProgressDot5.visible = NO;
    
    inGameCountdownStarted = NO;
    
    playbuttonPushed = NO;
    
    pauseButton.visible = NO;
    playButton.visible = NO;
    
    player2IsTheWinnerScriptHasBeenPlayed = YES;
    isGo = NO;
    
    playersCanTouchMarblesNow = NO;
    
    player1GertyShouldBeDead = YES;
    
    player1Winner = NO;
    player2Winner = YES;
    
    restartLevel.visible = NO;
    continuePlayingGame.visible = NO;
    backToMainMenu.visible = NO;
    
    if (isSinglePlayer) {
        
        happyGerty.visible = YES;
        sadGerty.visible = NO;
        uncertainGerty.visible = NO;
        cryingGerty.visible = NO;
        
        happyGerty2.visible = NO;
        sadGerty2.visible = NO;
        uncertainGerty2.visible = NO;
        cryingGerty2.visible = YES;
    }
    
    else if (!isSinglePlayer) {
        
        happyGertyTamagachiMultiplayer.visible = NO;
        sadGertyTamagachiMultiplayer.visible = NO;
        uncertainGertyTamagachiMultiplayer.visible = NO;
        cryingGertyTamagachiMultiplayer.visible = YES;
        pensiveGertyTamagachiMultiplayer.visible = NO;
        
        happyGerty2TamagachiMultiplayer.visible = YES;
        sadGerty2TamagachiMultiplayer.visible = NO;
        uncertainGerty2TamagachiMultiplayer.visible = NO;
        cryingGerty2TamagachiMultiplayer.visible = NO;
        pensiveGerty2TamagachiMultiplayer.visible = NO;
    }
    
    blockExplosion = [[[CCParticleFireworks alloc] initWithTotalParticles:300] autorelease];
    blockExplosion.position = gerty2.position;
    blockExplosion.scale = 1.0;
    blockExplosion.duration = 7.0;
    blockExplosion.life = 7.0;
    blockExplosion.speed = 225;
    //blockExplosion.gravity = ccp(-blockExplosionDirection.x*500, -680);
    blockExplosion.autoRemoveOnFinish = YES;
    blockExplosion.blendAdditive = NO;
    [zoombase addChild:blockExplosion];
    
    audioGertyFireworks = [[gerty children] objectAtIndex:13];
    [audioGertyFireworks play];
    
    [self sendPlayer1GertyShouldBeDead];
    
    if (isSinglePlayer == YES) {
        
        //Sets tamagachi1 and tamagachi2 postions as you press woodBlock
        if (deviceIsWidescreen) {
            
            tamagachi.position = ccp([linedPaper contentSize].width/2 - 90, [linedPaper contentSize].height/2 - 50);
            tamagachi2.position = ccp([linedPaper contentSize].width/2 + 65, [linedPaper contentSize].height/2 - 50);
        }
        
        if (!deviceIsWidescreen) {
            
            tamagachi.position = ccp([linedPaper contentSize].width/2 - 115, [linedPaper contentSize].height/2 - 50);
            tamagachi2.position = ccp([linedPaper contentSize].width/2 + 40, [linedPaper contentSize].height/2 - 50);
        }
        
        lostLabel.visible = YES;
        
        bombHasHitRectangleHenceNoBonus1 = YES;
        
        getReadyLabel.visible = NO;
        
        tamagachi.visible = YES;
        //put a graphic that portrays player 1 getting +0 point for losing
        player1PointsLabelZero = [CCLabelBMFont labelWithString:@"+0" fntFile:@"GertyLevel.fnt"];
        
        //make computer's gerty happy
        tamagachi.visible = YES;
        happyGerty2.visible = YES;
        sadGerty2.visible = NO;
        uncertainGerty2.visible = NO;
        cryingGerty2.visible = NO;
        
        //make player's gerty crying
        happyGerty.visible = NO;
        sadGerty.visible = NO;
        uncertainGerty.visible = NO;
        cryingGerty.visible = YES;
        
        player1PointsLabelZero.color = ccBLUE;
        player1PointsLabelZero.position = ccp((tamagachi.position.x - 15), (tamagachi.position.y + 15));
        player1PointsLabelZero.anchorPoint = ccp(0.5, 0.5);
        player1PointsLabelZero.scale = 0.8;
        
        [player1PointsLabelZero runAction: [CCFadeOut actionWithDuration:0.0]];
        
        [player1PointsLabelZero runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCFadeIn actionWithDuration: 0.7], [CCDelayTime actionWithDuration: 1.6], [CCFadeOut actionWithDuration:0.8], [CCDelayTime actionWithDuration: 1.5], [CCCallFunc actionWithTarget:self selector:@selector(makeVictoryOrLossScreenButtonsVisible)], nil]];
        
        [player1PointsLabelZero runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 7.3], [CCEaseIn actionWithAction: [CCMoveBy actionWithDuration:1.0 position:ccp(0, -15)] rate: 2.0], nil]];
        
        [tamagachi addChild: player1PointsLabelZero z:10];
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
            
            player1PointsLabelZero.scaleX = 0.75;
            player1PointsLabelZero.scaleY = 0.75;
        }
        
        else {
            
            player1PointsLabelZero.scaleX = 0.75/2;
            player1PointsLabelZero.scaleY = 0.75/2;
        }
        
        [linedPaper runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3], [CCMoveTo actionWithDuration: 1.0 position: ccp(0,0)], nil]];
        
        //Move computer tamagachi2 to the right
        //   [tamagachi2 runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(600, [linedPaper contentSize].height/2 - 50)]];
    }
    
    else if (isPlayer1 && !isSinglePlayer) {
        
        //      tamagachi.visible = NO;
        
        player2ExperiencePointsToAdd = 10 + bonusPoints1;
        
        lostLabel.visible = YES;
        //  [self sendGameOver: false];
        bombHasHitRectangleHenceNoBonus1 = YES;
        
        getReadyLabel.visible = NO;
        
        //put a graphic that portrays player 1 getting +0 point for losing
        player1PointsLabelZero = [CCLabelBMFont labelWithString:@"+0" fntFile:@"GertyLevel.fnt"];
        
        player1PointsLabelZero.color = ccBLUE;
        player1PointsLabelZero.position = ccp((tamagachiMultiplayer.position.x - 15), (tamagachiMultiplayer.position.y + 15));
        player1PointsLabelZero.anchorPoint = ccp(0.5, 0.5);
        player1PointsLabelZero.scale = 0.8;
        
        [player1PointsLabelZero runAction: [CCFadeOut actionWithDuration:0.0]];
        
        [player1PointsLabelZero runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCFadeIn actionWithDuration: 0.7], [CCDelayTime actionWithDuration: 1.6], [CCFadeOut actionWithDuration:0.8], [CCDelayTime actionWithDuration: 1.5], nil]];
        
        [player1PointsLabelZero runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 7.3], [CCEaseIn actionWithAction: [CCMoveBy actionWithDuration:1.0 position:ccp(0, -15)] rate: 2.0], nil]];
        
        [tamagachiMultiplayer addChild: player1PointsLabelZero z:10];
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
            
            player1PointsLabelZero.scaleX = 0.75;
            player1PointsLabelZero.scaleY = 0.75;
        }
        
        else {
            
            player1PointsLabelZero.scaleX = 0.75/2;
            player1PointsLabelZero.scaleY = 0.75/2;
        }
        
        [linedPaper runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3], [CCMoveTo actionWithDuration: 1.0 position: ccp(0,0)],[CCDelayTime actionWithDuration: 2.0], [CCCallFunc actionWithTarget:self selector:@selector(addPointsToTamagachiToPlayer2)], nil]];
        
        [self sendBonusPointsPlayer2];
    }
    
    else if (!isPlayer1 && !isSinglePlayer) {
        
        //     tamagachi.visible = NO;
        
        [(Gerty*)gerty blowup];
        
        player2ExperiencePointsToAdd = 10 + bonusPoints1;
        
        //add points directly to player2's local device
        if (player1ExperiencePoints + 10 + bonusPoints1 >= 100) {
            
            player1ExperiencePoints = (player1ExperiencePoints + 10 + bonusPoints1) - 100;
            player1Level = player1Level + 100;
            player1MarblesUnlocked = player1MarblesUnlocked + 1;
        }
        
        else {
            
            player1ExperiencePoints = player1ExperiencePoints + 10 + bonusPoints1;
        }
        
        winnerLabel.visible = YES;
        //  [self sendGameOver: false];
        
        CCSprite *winnerLabelShadow = [CCLabelBMFont labelWithString:@"Winner!"  fntFile:@"CasualWhite.fnt"];
        winnerLabelShadow.position = ccp(240,180);
        [hudLayer addChild:winnerLabelShadow z:10];
        
        winnerLabelShadow.position = winnerLabel.position;
        winnerLabelShadow.anchorPoint = ccp(0.5, 0.5);
        [winnerLabelShadow setOpacity: 185];
        
        [winnerLabelShadow runAction: [CCScaleBy actionWithDuration:0.35 scale:1.5]];
        [winnerLabelShadow runAction: [CCSequence actions: [CCFadeOut actionWithDuration:0.35], [CCCallFuncND actionWithTarget:winnerLabelShadow selector:@selector(removeFromParentAndCleanup:) data:(void*)YES], nil]];
        
        bombHasHitRectangleHenceNoBonus2 = YES;
        
        getReadyLabel.visible = NO;
        
        //put a graphic that portrays player 1 getting +0 point for losing
        player1PointsLabelZero = [CCLabelBMFont labelWithString:@"+0" fntFile:@"GertyLevel.fnt"];
        
        player1PointsLabelZero.color = ccBLUE;
        player1PointsLabelZero.position = ccp((tamagachiMultiplayer.position.x - 15), (tamagachiMultiplayer.position.y + 15));
        player1PointsLabelZero.anchorPoint = ccp(0.5, 0.5);
        player1PointsLabelZero.scale = 0.8;
        
        [player1PointsLabelZero runAction: [CCFadeOut actionWithDuration:0.0]];
        
        [player1PointsLabelZero runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 5.0], [CCFadeIn actionWithDuration: 0.7], [CCDelayTime actionWithDuration: 1.6], [CCFadeOut actionWithDuration:0.8], nil]];
        
        [player1PointsLabelZero runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 7.3], [CCEaseIn actionWithAction: [CCMoveBy actionWithDuration:1.0 position:ccp(0, -15)] rate: 2.0], nil]];
        
        [tamagachiMultiplayer addChild: player1PointsLabelZero z:10];
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
            
            player1PointsLabelZero.scaleX = 0.75;
            player1PointsLabelZero.scaleY = 0.75;
        }
        
        else {
            
            player1PointsLabelZero.scaleX = 0.75/2;
            player1PointsLabelZero.scaleY = 0.75/2;
        }
        
        [linedPaper runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 3], [CCMoveTo actionWithDuration: 1.0 position: ccp(0,0)],[CCDelayTime actionWithDuration: 2.0], [CCCallFunc actionWithTarget:self selector:@selector(addPointsToTamagachiToPlayer2)], nil]];
    }
    
    [linedPaper runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 4.5], [CCCallFunc actionWithTarget:self selector:@selector(saveGameSettings)], nil]];
}

-(BOOL) handleGertyCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	CP_ARBITER_GET_SHAPES(arb, gertyShape, bombShape);
	
    playButton.visible = NO;
    
	//Get a value for "force" generated by collision
	int i = cpvdistsq(gertyShape->body->v, bombShape->body->v);
    
	if (i > 1800 && player1Winner == NO && player2Winner == NO && gertyPlayer1Alive == YES) {
        
        [(Gerty*)gertyShape->data blowup];
        [self smokeyExplosionGertyPlayer1];
        [self player2IsTheWinnerScript];
    }
    
	return YES;
}

-(BOOL) handleGerty2Collision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	CP_ARBITER_GET_SHAPES(arb, gerty2Shape, bombShape);
	
	//Get a value for "force" generated by collision
	int i = cpvdistsq(gerty2Shape->body->v, bombShape->body->v);
    
	if (i > 1800 && player1Winner == NO && player2Winner == NO && gertyPlayer2Alive == YES) {
        
        [(Gerty2*)gerty2Shape->data blowup];
        [self smokeyExplosionGertyPlayer2];
        [self player1IsTheWinnerScript];
    }
    
	return YES;
}

-(BOOL) handleNinjaCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	CP_ARBITER_GET_SHAPES(arb, ninjaShape, otherShape);
	
	//Get a value for "force" generated by collision
	int i = cpvdistsq(ninjaShape->body->v, otherShape->body->v);
	
	if (i > 600)
	{
		[(Ninja*)ninjaShape->data addDamage:i/600];
	}
	
	//moments:COLLISION_BEGIN, COLLISION_PRESOLVE, COLLISION_POSTSOLVE, COLLISION_SEPARATE
	return YES;
}

-(BOOL) handleBombCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	CP_ARBITER_GET_SHAPES(arb, bombShape, groundLevelShape);
    
    float projectileCollisionForce2 = cpvlength(cpArbiterTotalImpulse(arb));
    
    if (bomb) {
        
        [(Bomb*)bombShape->data startCountDown];
        //bombHasHitRectangleHenceNoBonus1 = NO;
        
        if (projectileCollisionForce2 > 600) {
            
            switch(moment)
            {
                case COLLISION_BEGIN:
                    
                    break;
                    
                case COLLISION_PRESOLVE:
                    
                    
                    break;
                case COLLISION_POSTSOLVE:
                    
                    //audioMarbleHittingTable = [[bomb children] objectAtIndex:1];
                    //[audioMarbleHittingTable play];
                    break;
                    
                case COLLISION_SEPARATE:
                    
                    break;
            }
        }
    }
    
    if (bomb2) {
        
        float projectileCollisionForce2 = cpvlength(cpArbiterTotalImpulse(arb));
        
        //      if (bomb) {
        
        [(Bomb2*)bombShape->data startCountDown];
        //bombHasHitRectangleHenceNoBonus2 = NO;
        
        if (projectileCollisionForce2 > 600) {
            
            switch(moment)
            {
                case COLLISION_BEGIN:
                    
                    break;
                    
                case COLLISION_PRESOLVE:
                    
                    
                    break;
                case COLLISION_POSTSOLVE:
                    
                    //audioMarble2HittingTable = [[bomb2 children] objectAtIndex:1];
                    //[audioMarble2HittingTable play];
                    break;
                    
                case COLLISION_SEPARATE:
                    
                    break;
                    //         }
            }
        }
    }
    
	return YES;
}

-(BOOL) handleBlockTumbleCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	CP_ARBITER_GET_SHAPES(arb, rectangleShapeShape, otherShape);
    
    int i = cpvlength(cpArbiterTotalImpulse(arb));
    
    CCSprite *sprite = rectangleShapeShape->data;
    CDXAudioNode *audioBlockTumbling;
    
    if (i > 600) {
        
        switch(moment)
        {
            case COLLISION_BEGIN:
                
                break;
                
            case COLLISION_PRESOLVE:
                
                
                break;
            case COLLISION_POSTSOLVE:
                
                projectileCollisionForceMultiplier = 1.0;
                
                if (isGo) {
                    
                    audioBlockTumbling = [[sprite children] objectAtIndex:2];
                    [audioBlockTumbling play];
                }
                
                break;
                
            case COLLISION_SEPARATE:
                
                break;
        }
    }
    
    
	return YES;
}

-(BOOL) handleBlockCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	CP_ARBITER_GET_SHAPES(arb, rectangleShapeShape, bombShape);
    
    marbleBlocksInARow = 0;
    
    //Get a value for "force" generated by collision
	projectileCollisionForce = cpvlength(cpArbiterTotalImpulse(arb));
    
    if (cpArbiterIsFirstContact(arb)) {
        
        collisionNormal = cpArbiterGetNormal(arb, 0);
    }
    
    //NSLog (@"Collision Normal = (%f, %f)", collisionNormal.x, collisionNormal.y);
    
    if (rectangleShapeShape->body->p.x < 300 && gertyPlayer1Alive && (cpArbiterIsFirstContact(arb))) {
        
        [(Gerty*)gerty.shape->data sadGertyFace];
    }
    
    if (rectangleShapeShape->body->p.x > 300 && gertyPlayer2Alive && (cpArbiterIsFirstContact(arb))) {
        
        [(Gerty2*)gerty2.shape->data sadGertyFace];
    }
    
    if (player1HasRedBall && _curBomb && rectangleShapeShape->body->p.x > 300) {
        
        [(RectangleShape*)rectangleShapeShape->data burningBlock];
    }
    
    if (player2HasRedBall && _curBombPlayer2 && rectangleShapeShape->body->p.x < 300) {
        
        [(RectangleShape*)rectangleShapeShape->data burningBlock];
    }
    
    if (player1HasBlueBall && _curBomb && rectangleShapeShape->body->p.x > 300) {
        
        [(RectangleShape*)rectangleShapeShape->data icyBlock];
        
        if (projectileCollisionForce/20 > 255) {
            
            [(RectangleShape*)rectangleShapeShape->data addDamage:256];
        }
    }
    
    if (player2HasBlueBall && _curBombPlayer2 && rectangleShapeShape->body->p.x < 300) {
        
        [(RectangleShape*)rectangleShapeShape->data icyBlock];
        
        if (projectileCollisionForce/20 > 255) {
            
            [(RectangleShape*)rectangleShapeShape->data addDamage:256];
        }
    }
    
    if (player1HasBlackBall && bomb && rectangleShapeShape->body->p.x > 300) {
        
        [(Bomb*)bombShape->data startCountDown];
    }
    
    if (player2HasBlackBall && bomb2 && rectangleShapeShape->body->p.x < 300) {
        
        [(Bomb2*)bombShape->data startCountDown];
    }
    
    if (_curBomb && rectangleShapeShape->body->p.x > 300) {
        
        bombHasHitRectangleHenceNoBonus1 = YES;
        player1ProjectileIsZappable = NO;
    }
    
    else if (_curBombPlayer2 && rectangleShapeShape->body->p.x < 300) {
        
        bombHasHitRectangleHenceNoBonus2 = YES;
        player2ProjectileIsZappable = NO;
    }
    
    CCSprite *sprite = rectangleShapeShape->data;
    CDXAudioNode *audioNode;
    
    if (projectileCollisionForce > 800) {
        
        if (isPlayer1 && rectangleShapeShape->body->p.x > 300) {
            
            [self syncShapesOntoPlayer1ThreeTimes];
        }
        
        if (!isPlayer1 && rectangleShapeShape->body->p.x < 300) {
            
            [self syncShapesOntoPlayer2ThreeTimes];
        }
        
        switch(moment)
        {
            case COLLISION_BEGIN:
                
                break;
                
            case COLLISION_PRESOLVE:
                
                
                break;
            case COLLISION_POSTSOLVE:
                
                audioNode = [[sprite children] objectAtIndex:0];
                [audioNode play];
                
                if (projectileCollisionForce < 2000) {
                    
                    projectileCollisionForceMultiplier = 0.3;
                }
                
                else if (projectileCollisionForce > 2000 && projectileCollisionForce < 3000) {
                    
                    projectileCollisionForceMultiplier = 0.7;
                }
                
                else if (projectileCollisionForce > 3000) {
                    
                    projectileCollisionForceMultiplier = 1.0;
                }
                
                break;
                
            case COLLISION_SEPARATE:
                
                break;
        }
    }
    
    
    if (projectileCollisionForce > 20 && (cpArbiterIsFirstContact(arb))) {
        
        [(RectangleShape*)rectangleShapeShape->data addDamage:projectileCollisionForce/20];
        
        RectangleShape *block = rectangleShapeShape->data;
        BOOL blockDead = block.blockIsDead;
        
        // CGPoint blockExplosionDirection = collisionNormal;
        
        if (blockDead == YES) {
            
            /*  CCSprite *sprite = rectangleShapeShape->data;
             CCParticleFireworks *blockExplosion = [[[CCParticleFireworks alloc] initWithTotalParticles:125] autorelease];
             blockExplosion.position = sprite.position;
             blockExplosion.scale = 1.0;
             blockExplosion.duration = 3.0;
             blockExplosion.life = 3.0;
             blockExplosion.speed = 200;
             //blockExplosion.gravity = ccp(-blockExplosionDirection.x*500, -680);
             blockExplosion.autoRemoveOnFinish = YES;
             blockExplosion.blendAdditive = NO;
             [zoombase addChild:blockExplosion];
             
             NSLog (@"-blockExplosionDirection = (%f, %f)", -blockExplosionDirection.x, -blockExplosionDirection.y);
             */
        }
    }
    
    if (bomb && isPlayer1) {
        
        [(Bomb*)bombShape->data startCountDown];
        readyToReceiveBlockNumbersFromPlayer2 = YES;
    }
    
    if (bomb2 && !isPlayer1) {
        
        [(Bomb2*)bombShape->data startCountDown];
        readyToReceiveBlocksPositionsFromPlayer1 = YES;
    }
    
	return YES;
}

-(BOOL) handleTriangleBlockCollision:(CollisionMoment)moment arbiter:(cpArbiter*)arb space:(cpSpace*)space
{
	CP_ARBITER_GET_SHAPES(arb, triangleShapeShape, otherShape);
	
    //Get a value for "force" generated by collision
	int i = cpvdistsq(triangleShapeShape->body->v, otherShape->body->v);
    
    if (i > 600)
	{
        [(TriangleShape*)triangleShapeShape->data addDamage:i/600];
	}
    
	return YES;
}

// Helper code to show a menu to restart the level
// From Cat Nap tutorial
- (void)endScene:(EndReason)endReason {
    
    if (isPlayer1 && !isSinglePlayer) {
        
        if (isGo == YES && player1Winner == NO && player2Winner == NO && player1IsTheWinnerScriptHasBeenPlayed == NO) {
            
            opponentDisconnectedLabel = [CCLabelBMFont labelWithString:@"Opponent Disconnected" fntFile:@"CasualWhite.fnt"];
            
            CGSize winSize = [[CCDirector sharedDirector] winSize];
            CGPoint centerOfScreen = ccp(winSize.width/2, winSize.height/2);
            
            opponentDisconnectedLabel.position = ccp(centerOfScreen.x,219);
            [hudLayer addChild:opponentDisconnectedLabel z:10];
            opponentDisconnectedLabel.scale = 0.7;
            
            opponentDisconnected = YES;
            isGo = NO;
            [self player1IsTheWinnerScript];
            
            playButton.visible = NO;
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
                
                opponentDisconnectedLabel.scale = 0.6;
            }
            
            else {
                
                opponentDisconnectedLabel.scale = 0.6/2;
            }
            
            NSLog (@"Script 1!");
        }
        
        else if (isGo == YES && player1Winner == NO && player2Winner == YES && player2IsTheWinnerScriptHasBeenPlayed == NO) {
            
            CGSize winSize = [[CCDirector sharedDirector] winSize];
            CGPoint centerOfScreen = ccp(winSize.width/2, winSize.height/2);
            
            opponentDisconnectedLabel = [CCLabelBMFont labelWithString:@"You Disconnected" fntFile:@"CasualWhite.fnt"];
            opponentDisconnectedLabel.position = ccp(centerOfScreen.x,219);
            [hudLayer addChild:opponentDisconnectedLabel z:10];
            opponentDisconnectedLabel.scale = 0.7;
            
            opponentDisconnected = YES;
            isGo = NO;
            [self player2IsTheWinnerScript];
            
            playButton.visible = NO;
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
                
                opponentDisconnectedLabel.scale = 0.6;
            }
            
            else {
                
                opponentDisconnectedLabel.scale = 0.6/2;
            }
            
            NSLog (@"Script 2!");
        }
    }
    
    else if (!isPlayer1 && !isSinglePlayer) {
        
        if (isGo == YES && player1Winner == NO && player2Winner == NO && player2IsTheWinnerScriptHasBeenPlayed == NO) {
            
            opponentDisconnectedLabel = [CCLabelBMFont labelWithString:@"Opponent Disconnected" fntFile:@"CasualWhite.fnt"];
            
            CGSize winSize = [[CCDirector sharedDirector] winSize];
            CGPoint centerOfScreen = ccp(winSize.width/2, winSize.height/2);
            
            opponentDisconnectedLabel.position = ccp(centerOfScreen.x,219);
            [hudLayer addChild:opponentDisconnectedLabel z:10];
            opponentDisconnectedLabel.scale = 0.7;
            
            opponentDisconnected = YES;
            isGo = NO;
            [self player2IsTheWinnerScript];
            
            playButton.visible = NO;
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
                
                opponentDisconnectedLabel.scale = 0.6;
            }
            
            else {
                
                opponentDisconnectedLabel.scale = 0.6/2;
            }
            
            NSLog (@"Script 3!");
        }
        
        else if (isGo == YES && player1Winner == YES && player2Winner == NO && player1IsTheWinnerScriptHasBeenPlayed == NO) {
            
            opponentDisconnectedLabel = [CCLabelBMFont labelWithString:@"You Disconnected" fntFile:@"CasualWhite.fnt"];
            
            CGSize winSize = [[CCDirector sharedDirector] winSize];
            CGPoint centerOfScreen = ccp(winSize.width/2, winSize.height/2);
            
            opponentDisconnectedLabel.position = ccp(centerOfScreen.x,219);
            [hudLayer addChild:opponentDisconnectedLabel z:10];
            opponentDisconnectedLabel.scale = 0.7;
            
            
            opponentDisconnected = YES;
            isGo = NO;
            [self player1IsTheWinnerScript];
            
            playButton.visible = NO;
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
                
                opponentDisconnectedLabel.scale = 0.6;
            }
            
            else {
                
                opponentDisconnectedLabel.scale = 0.6/2;
            }
            
            NSLog (@"Script 4!");
        }
    }
    
    if (gameState == kGameStateDone) return;
    [self setGameState:kGameStateDone];
    /*
     if (isPlayer1) {
     if (endReason == kEndReasonWin) {
     [self sendGameOver:true];
     
     } else if (endReason == kEndReasonLose) {
     [self sendGameOver:false];
     }
     }
     */
    
}


// Add right after update method
- (void)tryStartGame {
    
    if (isPlayer1 && gameState == kGameStateWaitingForStart) {
        NSLog (@"I am Player 1 and am waiting for start.");
        [self setGameState:kGameStateActive];
        [self sendGameBegin];
        
        [self setupStringsWithOtherPlayerId:otherPlayerID];
    }
}


#pragma mark GCHelperDelegate

- (void)matchStarted {
    
    CCLOG(@"Match started");
    NSLog(@"Match started");
    
    //This will make sure the other player is still present during multiplayer
    [self runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCDelayTime actionWithDuration:15.0], [CCCallFunc actionWithTarget:self selector:@selector(setPingAnsweredToNo)], nil]]];
    
    if (receivedRandom) {
        [self setGameState:kGameStateWaitingForStart];
    } else {
        [self setGameState:kGameStateWaitingForRandomNumber];
    }
    [self sendRandomNumber];
    [self tryStartGame];
    
    appAbsoluteStartTime = CFAbsoluteTimeGetCurrent();
}

- (void)matchEnded {
    
    NSLog (@"matchEnded method called");
    
    invitationalGame = NO;
    
    [[GCHelper sharedInstance].match disconnect];
    [GCHelper sharedInstance].match = nil;
    [self endScene:kEndReasonDisconnect];
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(NSString *)playerID {
    
    // Store away other player ID for later
    if (otherPlayerID == nil) {
        otherPlayerID = [playerID retain];
    }
    
    Message *message = (Message *) [data bytes];
    if (message->messageType == kMessageTypeRandomNumber) {
        
        MessageRandomNumber * messageInit = (MessageRandomNumber *) [data bytes];
        CCLOG(@"Received random number: %ud, ours %ud", messageInit->randomNumber, ourRandom);
        NSLog(@"Received random number: %ud, ours %ud", messageInit->randomNumber, ourRandom);
        bool tie = false;
        
        if (messageInit->randomNumber == ourRandom) {
            CCLOG(@"TIE!");
            NSLog(@"TIE!");
            tie = true;
            ourRandom = arc4random();
            [self sendRandomNumber];
        } else if (ourRandom > messageInit->randomNumber) {
            CCLOG(@"We are player 1");
            NSLog(@"We are player 1");
            isPlayer1 = YES;
            /*
             player1Label =[CCLabelBMFont labelWithString: [GKLocalPlayer localPlayer].alias fntFile:@"Score.fnt"];
             [player1Label setAnchorPoint:ccp(0.5, 0.5)];
             player1Label.position = ccp(240, 20);
             player1Label.scale = 1.0;
             player1Label.visible = YES;
             [hudLayer addChild:player1Label z:1000];
             NSLog (@"[GKLocalPlayer localPlayer].alias = %@", [GKLocalPlayer localPlayer].alias);
             */
        } else {
            CCLOG(@"We are player 2");
            NSLog(@"We are player 2");
            isPlayer1 = NO;
            /*
             GKPlayer *player = [[GCHelper sharedInstance].playersDict objectForKey:playerID];
             player2Label = [CCLabelBMFont labelWithString:player.alias fntFile:@"Score.fnt"];
             [player2Label setAnchorPoint:ccp(0.5, 0.5)];
             player2Label.position = ccp(240, 20);
             player2Label.scale = 1.0;
             player2Label.visible = YES;
             [hudLayer addChild:player2Label z:1000];
             NSLog (@"player.alias = %@", player.alias);
             */
        }
        
        if (!tie) {
            receivedRandom = YES;
            if (gameState == kGameStateWaitingForRandomNumber) {
                [self setGameState:kGameStateWaitingForStart];
            }
            [self tryStartGame];
        }
        
    } else if (message->messageType == kMessageTypeGameBegin) {
        
        [self setGameState:kGameStateActive];
        [self setupStringsWithOtherPlayerId:otherPlayerID];
        
    } else if (message->messageType == kMessageTypeBlockInfo) {
        
        if (!isPlayer1) {
            
            MessageBlockInfo * receivedDynamicPlacesArrayPointer = (MessageBlockInfo*)malloc([data length]);
            
            [data getBytes:receivedDynamicPlacesArrayPointer length:[data length]];
            
            //NSLog (@"Player2 receiving MessageBlock Info with size of %i bytes", [data length]);
            
            [shapesArrayInPlayer2 removeAllObjects];
            [shapesArrayInPlayer1 removeAllObjects];
            
            shapes = [smgr getShapesAt:ccp(240, 160) radius:1000];
            
            for (NSValue *v in shapes) {
                
                cpShape *shape = [v pointerValue];
                
                for (int i = 0; i < receivedDynamicPlacesArrayPointer->total_number_of_blocks; i++) {
                    
                    if (shape->hashid == receivedDynamicPlacesArrayPointer[i].block_id && shape->collision_type == 3) {
                        
                        cpBodySetPos(shape->body, receivedDynamicPlacesArrayPointer[i].block_position);
                        cpBodySetAngle (shape->body, receivedDynamicPlacesArrayPointer[i].block_angle);
                        //cpBodySetVel(shape->body, receivedDynamicPlacesArrayPointer[i].block_velocity);
                        NSNumber *shapeHashID = [NSNumber numberWithInt: shape->hashid];
                        [shapesArrayInPlayer1 addObject: shapeHashID];
                    }
                }
            }
            
            //Create array of block_id's residing on Player2's device, subtract all block_id's which were received from...
            //...Player1's device, then parse through the remaining blocks inside Player2's block_id array and destroy them
            
            //1)Create Player1's NSMutableArray using receivedDynamicPlacesArrayPointer
            //2)Create Player2's NSMutableArray using the typical strategy
            //3)Subtract the contents of Player1's array from Player2's array.
            //4) Destroy the blocks corresponding to whats left in Player2's array after the subtraction.
            
            NSArray *shapesArrayPlayer2Temp2 = [smgr getShapesAt:ccp(240, 160) radius:1000];
            
            //Create Player2's mutable array using the traditional strategy here
            
            for (NSValue *v in shapesArrayPlayer2Temp2) {
                
                cpShape *shape = [v pointerValue];
                
                if (shape->collision_type == 3) {
                    
                    NSNumber *shapeHashID = [NSNumber numberWithInt: shape->hashid];
                    
                    [shapesArrayInPlayer2 addObject: shapeHashID];
                }
            }
            
            [shapesArrayInPlayer2 removeObjectsInArray: shapesArrayInPlayer1];
            
            for (id key in shapesArrayInPlayer2) {
                
                for (NSValue *v in shapesArrayPlayer2Temp2) {
                    
                    cpShape *shape = [v pointerValue];
                    
                    if (shape->collision_type == 3 && shape->hashid == [key integerValue]) {
                        
                        [(RectangleShape *)shape->data removeFromParentAndCleanup: YES];
                    }
                }
            }
        }
        
    } else if (message->messageType == kMessageTypeBlockNumbersFromPlayer2) {
        
        if (isPlayer1) {
            
            MessageBlockNumberFromPlayer2 * receivedDynamicPlacesArrayPointer = (MessageBlockNumberFromPlayer2*)malloc([data length]);
            
            [data getBytes:receivedDynamicPlacesArrayPointer length:[data length]];
            
            //NSLog (@"Player1 receiving MessageBlock Info with size of %i bytes", [data length]);
            
            [shapesArrayInPlayer1 removeAllObjects];
            [shapesArrayInPlayer2 removeAllObjects];
            
            shapes = [smgr getShapesAt:ccp(240, 160) radius:1000];
            
            for (NSValue *v in shapes) {
                
                cpShape *shape = [v pointerValue];
                
                for (int i = 0; i < receivedDynamicPlacesArrayPointer->total_number_of_blocks; i++) {
                    
                    if (shape->hashid == receivedDynamicPlacesArrayPointer[i].block_id && shape->collision_type == 3) {
                        
                        NSNumber *shapeHashID = [NSNumber numberWithInt: shape->hashid];
                        [shapesArrayInPlayer2 addObject: shapeHashID];
                    }
                }
            }
            
            NSArray *shapesArrayPlayer1Temp = [smgr getShapesAt:ccp(240, 160) radius:1000];
            
            //Create Player2's mutable array using the traditional strategy here
            
            for (NSValue *v in shapesArrayPlayer1Temp) {
                
                cpShape *shape = [v pointerValue];
                
                if (shape->collision_type == 3) {
                    
                    NSNumber *shapeHashID = [NSNumber numberWithInt: shape->hashid];
                    
                    [shapesArrayInPlayer1 addObject: shapeHashID];
                }
            }
            
            [shapesArrayInPlayer1 removeObjectsInArray: shapesArrayInPlayer2];
            
            for (id key in shapesArrayInPlayer1) {
                
                for (NSValue *v in shapesArrayPlayer1Temp) {
                    
                    cpShape *shape = [v pointerValue];
                    
                    if (shape->collision_type == 3 && shape->hashid == [key integerValue]) {
                        
                        [(RectangleShape *)shape->data removeFromParentAndCleanup: YES];
                    }
                }
            }
        }
    } else if (message->messageType == kMessageTypeRequestBlockInfoFromPlayer1) {
        
        [self sendBlocksPositionsFromPlayer1];
        NSLog (@"Player1 should be sendingBlockPositions to Player2");
        
    } else if (message->messageType == kMessageTypeRequestBlockInfoFromPlayer2) {
        
        [self sendBlockNumbersFromPlayer2];
        
    } else if (message->messageType == kMessageTypeAudioChargingShot) {
        
        if (isPlayer1) {
            
            
        }
        
        if (!isPlayer1) {
            
            audioChargingShot = [[sling1 children] objectAtIndex:2];
            audioChargingShot.playMode = kAudioNodeLoopProjectileCharging;
            [audioChargingShot play];
        }
        
    } else if (message->messageType == kMessageTypeAudioIncomingProjectile) {
        
        if (isPlayer1) {
            
            CDXAudioNode *audioIncomingProjectile2 = [[bomb2 children] objectAtIndex:0];
            [audioIncomingProjectile2 play];
        }
        
        if (!isPlayer1) {
            
            CDXAudioNode *audioIncomingProjectile = [[bomb children] objectAtIndex:0];
            [audioIncomingProjectile play];
        }
        
    } else if (message->messageType == kMessageTypeStretchingSling) {
        
        if (!isPlayer1) {
            
            [self player1SlingIsSmoking];
            
            //    if (player1GiantSmokeCloudFrontOpacityIsIncreasing == NO) {
            
            [self increaseBigSmokeCloudOpacity];
            NSLog (@"i am player 2 and have received kMessageTypeStretchingSling");
            NSLog (@"i am player 2 and player1GiantSmokeCloudFrontOpacityIsIncreasing = %i", player1GiantSmokeCloudFrontOpacityIsIncreasing);
            //     }
            
            CDXAudioNodeSlingShot *audioStretchingSling = [[sling1Player2 children] objectAtIndex:0];
            [audioStretchingSling play];
            
            stretchingSling2SoundReady = NO;
            [self resetStretchingSling2SoundReady];
        }
        
        if (isPlayer1) {
            
            [self player2SlingIsSmoking];
            
            //  if (player2GiantSmokeCloudFrontOpacityIsIncreasing == NO) {
            
            [self increasePlayer2BigSmokeCloudOpacity];
            NSLog (@"i am player 1 and have received kMessageTypeStretchingSling");
            NSLog (@"i am player 1 and player2GiantSmokeCloudFrontOpacityIsIncreasing = %i", player2GiantSmokeCloudFrontOpacityIsIncreasing);
            //   }
            
            CDXAudioNodeSlingShot *audioStretchingSling = [[sling1 children] objectAtIndex:0];
            [audioStretchingSling play];
            
            stretchingSlingSoundReady = NO;
            [self resetStretchingSlingSoundReady];
        }
        
    } else if (message->messageType == kMessageTypeAudioProjectileLaunch) {
        
        if (isPlayer1) {
            
            if (player2SlingIsSmoking == YES) {
                
                [self stopAction: player2ChargingSmoke];
                player2SlingIsSmoking = NO;
            }
            
            
            if (player2GiantSmokeCloudFrontOpacityIsIncreasing == YES) {
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.2], [CCCallFunc actionWithTarget:self selector:@selector(reducePlayer2BigSmokeCloudOpacity)], nil]];
            }
            
            CDXAudioNode *audioProjectileLaunch = [[sling1Player2 children] objectAtIndex:1];
            [audioProjectileLaunch play];
        }
        
        if (!isPlayer1) {
            
            if (player1SlingIsSmoking == YES) {
                
                [self stopAction: player1ChargingSmoke];
                player1SlingIsSmoking = NO;
            }
            
            if (player1GiantSmokeCloudFrontOpacityIsIncreasing == YES) {
                
                [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.2], [CCCallFunc actionWithTarget:self selector:@selector(reduceBigSmokeCloudOpacity)], nil]];
            }
            
            CDXAudioNode *audioProjectileLaunch = [[sling1 children] objectAtIndex:1];
            [audioProjectileLaunch play];
        }
        
    } else if (message->messageType == kMessageTypeProjectileBlocked) {
        
        player1BombZapped = YES;
        
        MessageProjectileBlocked * structBlockPointXValueOfMarble1 = (MessageProjectileBlocked *) [data bytes];
        blockPointXValueOfMarble1 = structBlockPointXValueOfMarble1->blockPointXValueOfMarble1;
        
    } else if (message->messageType == kMessageTypeProjectileBlocked2) {
        
        player2BombZapped = YES;
        
        MessageProjectileBlocked2 * structBlockPointXValueOfMarble2 = (MessageProjectileBlocked2 *) [data bytes];
        blockPointXValueOfMarble2 = structBlockPointXValueOfMarble2->blockPointXValueOfMarble2;
        
    } else if (message->messageType == kMessageTypeMove && gertyPlayer2Alive) {
        
        MessageMove * messageSendMove = (MessageMove *) [data bytes];
        
        _curBomb.position = messageSendMove->point;
        //player1ProjectileHasBeenTouched = YES;
        [(Gerty2*)gerty2.shape->data pensiveGertyFace];
        
    } else if (message->messageType == kMessageTypeMove2 && gertyPlayer1Alive) {
        
        MessageMove * messageSendMove = (MessageMove *) [data bytes];
        
        _curBombPlayer2.position = messageSendMove->point;
        //player2ProjectileHasBeenTouched = YES;
        [(Gerty*)gerty.shape->data pensiveGertyFace];
        
    } else if (message->messageType == kMessageTypePlayer1BlocksPositions) {
        
        MessageBlockInfo * messagePlayer1BlocksPositions = (MessageBlockInfo *) [data bytes];
        
        NSLog (@"%i", messagePlayer1BlocksPositions->block_id);
        
    } else if (message->messageType == kMessageTypeIncreaseSkillLevelBonus) {
        
        [self increaseSkillLevelBonus];
        
    } else if (message->messageType == kMessageTypeLaunchProjectile) {
        
        //_curBomb.shape->layers = 1;
        
        MessageLaunchProjectile * messageLaunchProjectile = (MessageLaunchProjectile *) [data bytes];
        
        float receivedShotMultiplier;
        
        if (messageLaunchProjectile->projectileShotMultiplier == 1) {
            
            receivedShotMultiplier = CHARGING_COEFFICIENT_STEP_1;
        }
        
        else if (messageLaunchProjectile->projectileShotMultiplier == 2) {
            
            receivedShotMultiplier = CHARGING_COEFFICIENT_STEP_2;
        }
        
        else if (messageLaunchProjectile->projectileShotMultiplier == 3) {
            
            receivedShotMultiplier = CHARGING_COEFFICIENT_STEP_3;
        }
        
        else if (messageLaunchProjectile->projectileShotMultiplier == 4) {
            
            receivedShotMultiplier = CHARGING_COEFFICIENT_STEP_4;
        }
        
        else if (messageLaunchProjectile->projectileShotMultiplier == 5) {
            
            receivedShotMultiplier = CHARGING_COEFFICIENT_STEP_5;
        }
        
        else {
            
            receivedShotMultiplier = 0;
        }
        
        projectileLaunchMultiplier = messageLaunchProjectile->projectileShotMultiplier;
        
        [smgr morphShapeToActive:_curBomb.shape mass:30];
        float yellowSpeedMultiplier = YELLOW_BALL_SPEED_MULTIPLIER;
        
        marble1RotationalVelocity = messageLaunchProjectile->marbleRotationalVelocity;
        
        if (!player1HasYellowBall && _curBomb) {
            
            [_curBomb applyImpulse:cpvmult(messageLaunchProjectile->launchPoint, handicapCoefficientPlayer1*(receivedShotMultiplier*240 + 240))];
            _curBomb.shape->body->w = marble1RotationalVelocity;
        }
        
        if (player1HasYellowBall && _curBomb) {
            
            float yellowBallLaunchForce = handicapCoefficientPlayer1*(receivedShotMultiplier*240*yellowSpeedMultiplier + 240*yellowSpeedMultiplier);
            [_curBomb applyImpulse:cpvmult(messageLaunchProjectile->launchPoint,yellowBallLaunchForce)];
            _curBomb.shape->body->w = marble1RotationalVelocity;
        }
        
        player1ProjectileHasBeenTouched = NO;
        
    } else if (message->messageType == kMessageTypeLaunchProjectile2) {
        
        //_curBombPlayer2.shape->layers = 2;
        
        MessageLaunchProjectile * messageLaunchProjectile = (MessageLaunchProjectile *) [data bytes];
        
        float receivedShotMultiplier;
        
        if (messageLaunchProjectile->projectileShotMultiplier2 == 1) {
            
            receivedShotMultiplier = CHARGING_COEFFICIENT_STEP_1;
        }
        
        else if (messageLaunchProjectile->projectileShotMultiplier2 == 2) {
            
            receivedShotMultiplier = CHARGING_COEFFICIENT_STEP_2;
        }
        
        else if (messageLaunchProjectile->projectileShotMultiplier2 == 3) {
            
            receivedShotMultiplier = CHARGING_COEFFICIENT_STEP_3;
        }
        
        else if (messageLaunchProjectile->projectileShotMultiplier2 == 4) {
            
            receivedShotMultiplier = CHARGING_COEFFICIENT_STEP_4;
        }
        
        else if (messageLaunchProjectile->projectileShotMultiplier2 == 5) {
            
            receivedShotMultiplier = CHARGING_COEFFICIENT_STEP_5;
        }
        
        else {
            
            receivedShotMultiplier = 0;
        }
        
        projectileLaunchMultiplier2 = messageLaunchProjectile->projectileShotMultiplier2;
        
        [smgr morphShapeToActive:_curBombPlayer2.shape mass:30];
        float yellowSpeedMultiplier = YELLOW_BALL_SPEED_MULTIPLIER;
        
        marble2RotationalVelocity = messageLaunchProjectile->marbleRotationalVelocity;
        
        if (!player2HasYellowBall && _curBombPlayer2) {
            
            [_curBombPlayer2 applyImpulse:cpvmult(messageLaunchProjectile->launchPoint,handicapCoefficientPlayer2*(receivedShotMultiplier*240 + 240))];
            _curBombPlayer2.shape->body->w = -(marble2RotationalVelocity);
        }
        
        if (player2HasYellowBall && _curBombPlayer2) {
            
            float yellowBallLaunchForce = handicapCoefficientPlayer2*(receivedShotMultiplier*240*yellowSpeedMultiplier + 240*yellowSpeedMultiplier);
            [_curBombPlayer2 applyImpulse:cpvmult(messageLaunchProjectile->launchPoint,yellowBallLaunchForce)];
            _curBombPlayer2.shape->body->w = -(marble2RotationalVelocity);
        }
        
        player2ProjectileHasBeenTouched = NO;
        
    } else if (message->messageType == kMessageTypeAppStartTime) {
        
        MessageAppStartTime * structPlayer1CFAbsoluteTimeGetCurrent = (MessageAppStartTime *) [data bytes];
        MessageAppStartTime * structPlayer1AppStartTime = (MessageAppStartTime *) [data bytes];
        
        if (!isPlayer1) {
            
            CFTimeInterval localVariableStructPlayer1CFAbsoluteTimeGetCurrent = structPlayer1CFAbsoluteTimeGetCurrent->player1CFAbsoluteTimeGetCurrent;
            CFTimeInterval localVariablePlayer1AppAbsoluteStartTime = structPlayer1AppStartTime->player1AppAbsoluteStartTime;
            
            appSessionStartTime = localVariableStructPlayer1CFAbsoluteTimeGetCurrent - localVariablePlayer1AppAbsoluteStartTime +(((CFAbsoluteTimeGetCurrent() - localVariableStructPlayer1CFAbsoluteTimeGetCurrent) + (appAbsoluteStartTime - localVariablePlayer1AppAbsoluteStartTime))/2);
            
            timeLabel.position = ccp(450, 30);
        }
        
        
    } else if (message->messageType == kMessageTypeSendToken) {
        
        if (isPlayer1) {
            
            pingAnswered = YES;
            
            if (sentPingTime > 0) {
                
                receivedPingTime = [[NSDate date] timeIntervalSince1970];;
                
                pingTime = receivedPingTime - sentPingTime;
                
                if (pingTime > prelaunchDelayTime) {
                    
                    prelaunchDelayTime = pingTime + 0.5*pingTime;
                    
                    if (prelaunchDelayTime <= 0.15) {
                        
                        prelaunchDelayTime = 0.15;
                    }
                    
                    else if (prelaunchDelayTime >= 1.0) {
                        
                        prelaunchDelayTime = 1.0;
                    }
                    
                    [self sendPrelaunchTimeDelay];
                }
                
                NSLog (@"pingTime = %f", pingTime);
                NSLog (@"prelaunchDelayTime = %f", prelaunchDelayTime);
            }
        }
        
        else if (!isPlayer1)  {
            
            pingAnswered = YES;
            [self sendToken];
        }
        
    } else if (message->messageType == kMessageTypePlayer2MarbleColor) {
        
        MessagePlayer2MarbleColor * structPlayer2MarbleColor = (MessagePlayer2MarbleColor *) [data bytes];
        player2MarbleColor = structPlayer2MarbleColor->marbleColor2;
        doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2 = structPlayer2MarbleColor->doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble2;
        
        //Player2 is setting up Player2 Marble on its device
        
        if (player2BombCreated == NO) {
            
            if (player2BombExists) {
                
                [_curBombPlayer2 removeFromParentAndCleanup: YES];
            }
            
            [self setupBombsPlayer2];
            [self setupNextBombPlayer2];
            NSLog (@"Player2 Marble should be created now!");
        }
        
    } else if (message->messageType == kMessageTypePauseGame) {
        
        if (gamePaused == NO) {
            
            [[CCDirector sharedDirector] pause];
            gamePaused= YES;
            NSLog (@"Game Paused");
        }
        
        else if (gamePaused == YES) {
            
            [[CCDirector sharedDirector] resume];
            gamePaused = NO;
            NSLog (@"Game UNpaused");
        }
        
    } else if (message->messageType == kMessageTypePlayer1MarbleColor) {
        
        MessagePlayer1MarbleColor * structPlayer1MarbleColor = (MessagePlayer1MarbleColor *) [data bytes];
        player1MarbleColor = structPlayer1MarbleColor->marbleColor1;
        doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1 = structPlayer1MarbleColor->doesTheNextMarbleHaveAHighChanceOfBeingASuperMarble1;
        
        //Player1 is setting up Player1 Marble on its device
        
        colorReceivedFromPlayer1 = YES;
        
        if (player1BombCreated == NO) {
            
            if (player1BombExists) {
                
                [_curBomb removeFromParentAndCleanup: YES];
            }
            
            [self setupBombsPlayer1];
            [self setupNextBombPlayer1];
            NSLog (@"Player1 Marble should be created now!");
        }
        
    } else if (message->messageType == kMessageTypeUnlockedMarbles1) {
        
        //This is player2
        MessageUnlockedMarbles1 *structUnlockedMarbles = (MessageUnlockedMarbles1 *) [data bytes];
        
        player1MarblesUnlockedMultiplayerValue = structUnlockedMarbles->unlockedMarbles1;
        player1LevelMultiplayerValue = structUnlockedMarbles->player1LevelStruct;
        player1ExperiencePointsMultiplayerValue = structUnlockedMarbles->player1ExperiencePointsStruct;
        NSLog (@"I am player 2 and received a player1ExperiencePointsMultiplayerValue of %i", player1ExperiencePointsMultiplayerValue);
        
        //If you are player2 and your level is less than player1's level then you should look pensive.
        if (player1LevelMultiplayerValue > player2LevelMultiplayerValue) {
            
            happyGertyTamagachiMultiplayer.visible = YES;
            sadGertyTamagachiMultiplayer.visible = NO;
            uncertainGertyTamagachiMultiplayer.visible = NO;
            cryingGertyTamagachiMultiplayer.visible = NO;
            pensiveGertyTamagachiMultiplayer.visible = NO;
            
            happyGerty2TamagachiMultiplayer.visible = NO;
            sadGerty2TamagachiMultiplayer.visible = NO;
            uncertainGerty2TamagachiMultiplayer.visible = NO;
            cryingGerty2TamagachiMultiplayer.visible = NO;
            pensiveGerty2TamagachiMultiplayer.visible = YES;
        }
        
        //If you are player2 and your level is greater than player1's level then you should look happy.
        else if (player1LevelMultiplayerValue < player2LevelMultiplayerValue) {
            
            happyGertyTamagachiMultiplayer.visible = NO;
            sadGertyTamagachiMultiplayer.visible = NO;
            uncertainGertyTamagachiMultiplayer.visible = NO;
            cryingGertyTamagachiMultiplayer.visible = NO;
            pensiveGertyTamagachiMultiplayer.visible = YES;
            pensiveGertyTamagachiMultiplayer.flipX = YES;
            
            happyGerty2TamagachiMultiplayer.visible = YES;
            sadGerty2TamagachiMultiplayer.visible = NO;
            uncertainGerty2TamagachiMultiplayer.visible = NO;
            cryingGerty2TamagachiMultiplayer.visible = NO;
            pensiveGerty2TamagachiMultiplayer.visible = NO;
        }
        
        //If you are player2 and your level is equal to player1's level then you should look uncertain (straight mouth)
        else if (player1LevelMultiplayerValue == player2LevelMultiplayerValue) {
            
            happyGertyTamagachiMultiplayer.visible = NO;
            sadGertyTamagachiMultiplayer.visible = NO;
            uncertainGertyTamagachiMultiplayer.visible = YES;
            cryingGertyTamagachiMultiplayer.visible = NO;
            pensiveGertyTamagachiMultiplayer.visible = NO;
            
            happyGerty2TamagachiMultiplayer.visible = NO;
            sadGerty2TamagachiMultiplayer.visible = NO;
            uncertainGerty2TamagachiMultiplayer.visible = YES;
            cryingGerty2TamagachiMultiplayer.visible = NO;
            pensiveGerty2TamagachiMultiplayer.visible = NO;
        }
        
        [self gertyVersusScreenUpdateLightsForPlayer1];
        [self gertyVersusScreenUpdateLightsForPlayer2];
        
    } else if (message->messageType == kMessageTypeUnlockedMarbles2) {
        
        //This is player1
        MessageUnlockedMarbles2 *structUnlockedMarbles = (MessageUnlockedMarbles2 *) [data bytes];
        
        player2MarblesUnlockedMultiplayerValue = structUnlockedMarbles->unlockedMarbles2;
        player2LevelMultiplayerValue = structUnlockedMarbles->player2LevelStruct;
        player2ExperiencePointsMultiplayerValue = structUnlockedMarbles->player2ExperiencePointsStruct;
        NSLog (@"I am player 1 and received a player2ExperiencePointsMultiplayerValue of %i", player2ExperiencePointsMultiplayerValue);
        
        //If you are player1 and your level is greater than player2's level then you should look happy
        if (player1LevelMultiplayerValue > player2LevelMultiplayerValue) {
            
            happyGertyTamagachiMultiplayer.visible = YES;
            sadGertyTamagachiMultiplayer.visible = NO;
            uncertainGertyTamagachiMultiplayer.visible = NO;
            cryingGertyTamagachiMultiplayer.visible = NO;
            pensiveGertyTamagachiMultiplayer.visible = NO;
            
            happyGerty2TamagachiMultiplayer.visible = NO;
            sadGerty2TamagachiMultiplayer.visible = NO;
            uncertainGerty2TamagachiMultiplayer.visible = NO;
            cryingGerty2TamagachiMultiplayer.visible = NO;
            pensiveGerty2TamagachiMultiplayer.visible = YES;
        }
        
        //If you are player1 and your level is less than player2's level then you should look pensive
        else if (player1LevelMultiplayerValue < player2LevelMultiplayerValue) {
            
            happyGertyTamagachiMultiplayer.visible = NO;
            sadGertyTamagachiMultiplayer.visible = NO;
            uncertainGertyTamagachiMultiplayer.visible = NO;
            cryingGertyTamagachiMultiplayer.visible = NO;
            pensiveGertyTamagachiMultiplayer.visible = YES;
            pensiveGertyTamagachiMultiplayer.flipX = YES;
            
            happyGerty2TamagachiMultiplayer.visible = YES;
            sadGerty2TamagachiMultiplayer.visible = NO;
            uncertainGerty2TamagachiMultiplayer.visible = NO;
            cryingGerty2TamagachiMultiplayer.visible = NO;
            pensiveGerty2TamagachiMultiplayer.visible = NO;
        }
        
        //If you are player1 and your level is equal to player2's level then you should look uncertain (straight mouth)
        else if (player1LevelMultiplayerValue == player2LevelMultiplayerValue) {
            
            
            happyGertyTamagachiMultiplayer.visible = NO;
            sadGertyTamagachiMultiplayer.visible = NO;
            uncertainGertyTamagachiMultiplayer.visible = YES;
            cryingGertyTamagachiMultiplayer.visible = NO;
            pensiveGertyTamagachiMultiplayer.visible = NO;
            
            happyGerty2TamagachiMultiplayer.visible = NO;
            sadGerty2TamagachiMultiplayer.visible = NO;
            uncertainGerty2TamagachiMultiplayer.visible = YES;
            cryingGerty2TamagachiMultiplayer.visible = NO;
            pensiveGerty2TamagachiMultiplayer.visible = NO;
        }
        
        
        [self gertyVersusScreenUpdateLightsForPlayer1];
        [self gertyVersusScreenUpdateLightsForPlayer2];
        
    } else if (message->messageType == kMessageTypeBonusPointsPlayer1) {
        
        //This is player2
        MessageBonusPointsPlayer1 *structBonusPointsPlayer1 = (MessageBonusPointsPlayer1 *) [data bytes];
        
        bonusPoints1 = structBonusPointsPlayer1->bonusPoints1Struct;
        NSLog (@"I am player2 and bonusPoints1 = %i", bonusPoints1);
        
    } else if (message->messageType == kMessageTypeBonusPointsPlayer2) {
        
        //This is player1
        MessageBonusPointsPlayer2 *structBonusPointsPlayer2 = (MessageBonusPointsPlayer2 *) [data bytes];
        
        bonusPoints2 = structBonusPointsPlayer2->bonusPoints2Struct;
        
    } else if (message->messageType == kMessageTypeProjectileChargingPitch1) {
        
        MessageProjectileChargingPitch * structChargedShotTimeStarted = (MessageProjectileChargingPitch *) [data bytes];
        MessageProjectileChargingPitch * structBlockingChargeBonusPlayer1 = (MessageProjectileChargingPitch *) [data bytes];
        MessageProjectileChargingPitch * structReceivingChargingDataFromPlayer1 = (MessageProjectileChargingPitch *) [data bytes];
        
        receivingChargingDataFromPlayer1 = structReceivingChargingDataFromPlayer1->receivingChargingDataFromPlayer1;
        chargedShotTimeStarted = structChargedShotTimeStarted->chargedShotTimeStarted;
        blockingChargeBonusPlayer1 = structBlockingChargeBonusPlayer1->blockingChargeBonusPlayer1;
        
    } else if (message->messageType == kMessageTypeProjectileChargingPitch2) {
        
        MessageProjectileChargingPitch2 * structChargedShotTimeStarted2 = (MessageProjectileChargingPitch2 *) [data bytes];
        MessageProjectileChargingPitch2 * structBlockingChargeBonusPlayer2 = (MessageProjectileChargingPitch2 *) [data bytes];
        MessageProjectileChargingPitch2 * structReceivingChargingDataFromPlayer2 = (MessageProjectileChargingPitch2 *) [data bytes];
        
        receivingChargingDataFromPlayer2 = structReceivingChargingDataFromPlayer2->receivingChargingDataFromPlayer2;
        chargedShotTimeStarted2 = structChargedShotTimeStarted2->chargedShotTimeStarted2;
        blockingChargeBonusPlayer2 = structBlockingChargeBonusPlayer2->blockingChargeBonusPlayer2;
        
    } else if (message->messageType == kMessageTypePlayer1HandicapInteger) {
        
        //This is Player2 receiving the message
        MessagePlayer1HandicapInteger * structPlayer1HandicapInteger = (MessagePlayer1HandicapInteger *) [data bytes];
        player1HandicapInteger = structPlayer1HandicapInteger->player1HandicapIntegerStruct;
        
        //Move the checkmark button to the correct tick line on Player1's handicap meter depending on the value of player1HandicapInteger received
        
        if (player1HandicapInteger == 1) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapLeftBorder.position.x, 180)]];
            handicapCoefficientPlayer1 = 1.0;
        }
        
        else if (player1HandicapInteger == 2) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapFirstLine.position.x, 180)]];
            handicapCoefficientPlayer1 = 0.83;
        }
        
        else if (player1HandicapInteger == 3) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapSecondLine.position.x, 180)]];
            handicapCoefficientPlayer1 = 0.67;
        }
        
        else if (player1HandicapInteger == 4) {
            
            [firstPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(firstPlayerHandicapRightBorder.position.x, 180)]];
            handicapCoefficientPlayer1 = 0.5;
        }
        
    } else if (message->messageType == kMessageTypePlayer2HandicapInteger) {
        
        //This is Player1 receiving the message
        MessagePlayer2HandicapInteger * structPlayer2HandicapInteger = (MessagePlayer2HandicapInteger *) [data bytes];
        player2HandicapInteger = structPlayer2HandicapInteger->player2HandicapIntegerStruct;
        
        //Move the checkmark button to the correct tick line on Player2's handicap meter depending on the value of player2HandicapInteger received
        
        NSLog (@"I am player1 and player2HandicapInteger = %i", player2HandicapInteger);
        
        if (player2HandicapInteger == 1) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapLeftBorder.position.x, 180)]];
            handicapCoefficientPlayer2 = 1.0;
        }
        
        else if (player2HandicapInteger == 2) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapFirstLine.position.x, 180)]];
            handicapCoefficientPlayer2 = 0.83;
        }
        
        else if (player2HandicapInteger == 3) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapSecondLine.position.x, 180)]];
            handicapCoefficientPlayer2 = 0.67;
        }
        
        else if (player2HandicapInteger == 4) {
            
            [secondPlayerHandicapCheckMarkButton runAction: [CCMoveTo actionWithDuration:0.35 position:ccp(secondPlayerHandicapRightBorder.position.x, 180)]];
            handicapCoefficientPlayer2 = 0.5;
        }
        
    } else if (message->messageType == kMessageTypeGameOver) {
        
        MessageGameOver * messageGameOver = (MessageGameOver *) [data bytes];
        CCLOG(@"Received game over with player 1 won: %d", messageGameOver->player1Won);
        
        if (messageGameOver->player1Won) {
            [self endScene:kEndReasonLose];
        } else {
            [self endScene:kEndReasonWin];
        }
        
    } else if (message->messageType == kMessageTypePlayer1GertyShouldBeDead) {
        
        //This is player2
        player1GertyShouldBeDead = YES;
        
    } else if (message->messageType == kMessageTypePlayer2GertyShouldBeDead) {
        
        //This is player1
        player2GertyShouldBeDead = YES;
        
    } else if (message->messageType == kMessageTypePlayAgain) {
        
        otherPlayerWishesToPlayAgain = YES;
        
    } else if (message->messageType == kMessageTypeOtherPlayerHasLeftMatchFromVersusScreen) {
        
        [self backToMainMenu];
        
    } else if (message->messageType == kMessageTypePrelaunchTimeDelay) {
        
        MessageSendPrelaunchTimeDelay *structPrelaunchTimeDelay = (MessageSendPrelaunchTimeDelay *) [data bytes];
        
        prelaunchDelayTime = structPrelaunchTimeDelay->prelaunchTimeDelayStruct;
        
        NSLog (@"prelaunchDelayTime = %f", prelaunchDelayTime);
        
    } else if (message->messageType == kMessageTypeTeslaGlow) {
        
        if (!isSinglePlayer) {
            
            if (isPlayer1) {
                
                //If you're player1, this message should make 2nd player's tesla glow
                teslaGlow2.opacity = 150;
            }
            
            else if (!isPlayer1) {
                
                //If you're player2, this message should make 1st player's tesla glow
                teslaGlow1.opacity = 150;
            }
        }
        
    } else if (message->messageType == kMessageTypeTeslaGlowOff) {
        
        if (!isSinglePlayer) {
            
            if (isPlayer1) {
                
                //If you're player1, this message should make 2nd player's tesla glow shut off
                teslaGlow2.opacity = 0;
            }
            
            else if (!isPlayer1) {
                
                //If you're player2, this message should make 1st player's tesla glow shut off
                teslaGlow1.opacity = 0;
            }
        }
        
    } else if (message->messageType == kMessagePlayerReadyToStartInGameCountdown) {
        
        if (isPlayer1) {
            
            player2ReadyToStartInGameCountdown = YES;
            
            if (player1ReadyToStartInGameCountdown && !inGameCountdownStarted) {
                
                [self startInGameCountdown];
            }
        }
        
        else if (!isPlayer1) {
            
            player1ReadyToStartInGameCountdown = YES;
            
            if (player2ReadyToStartInGameCountdown && !inGameCountdownStarted) {
                
                [self startInGameCountdown];
            }
        }
        
    } else if (message->messageType == kMessageTypeOpposingPlayersTamagachiColor) {
        
        if (!isPlayer1) {
            
            //Player2 has received tamagachiColor message from player1
            tamagachiColorReceivedFromPlayer1 = YES;
            
            [self sendOpposingPlayersTamagachiColor];
        }
        
        MessageSendOpposingPlayersTamagachiColor *structOpposingPlayersTamagachiColor = (MessageSendOpposingPlayersTamagachiColor *) [data bytes];
        
        MessageSendOpposingPlayersTamagachiColor *structPillarConfiguration = (MessageSendOpposingPlayersTamagachiColor *) [data bytes];
        
        //If you're not Player1, use the pillarConfiguration number sent from player1
        if (!isPlayer1) {
            
            pillarConfiguration = structPillarConfiguration->pillarConfigurationStruct;
        }
        
        NSLog (@"structOpposingPlayersTamagachiColor->opposingPlayersTamagachiColor = %i", structOpposingPlayersTamagachiColor->opposingPlayersTamagachiColor);
        
        if (isPlayer1) {
            
            //Player1 has received tamagachiColor message from player2
            tamagachiColorReceivedFromPlayer2 = YES;
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.2], [CCCallFunc actionWithTarget:self selector:@selector(player1ReadyToStartInGameCountdownMethod)], nil]];
            
            tamagachi2Color = structOpposingPlayersTamagachiColor->opposingPlayersTamagachiColor;
            
            player1InGameLabelStringForPlayer1 = [NSString stringWithFormat:[GKLocalPlayer localPlayer].alias];
            player1InGameLabel = [CCLabelBMFont labelWithString:player1InGameLabelStringForPlayer1 fntFile:@"CasualWhite.fnt"];
            [zoombase addChild: player1InGameLabel z:1000];
            //  }
            
            player1InGameLabel.position = ccp(125, 5);
            player1InGameLabel.color = ccWHITE;
            player1InGameLabel.scale = 0.5;
            player1InGameLabel.visible = YES;
            
            //    if (firstMatchWithThisPlayer == YES) {
            
            player2InGameLabelStringForPlayer1 = [NSString stringWithFormat:player.alias];
            player2InGameLabel = [CCLabelBMFont labelWithString:player2InGameLabelStringForPlayer1 fntFile:@"CasualWhite.fnt"];
            [zoombase addChild: player2InGameLabel z:1000];
            //    }
            
            player2InGameLabel.position = ccp(440, 5);
            player2InGameLabel.color = ccWHITE;
            player2InGameLabel.scale = 0.5;
            player2InGameLabel.visible = YES;
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
                player1Label.scale = 0.8/2;
                player2Label.scale = 0.8/2;
                player1InGameLabel.scale = 1.2/2;
                player2InGameLabel.scale = 1.2/2;
            }
            
            else {
                
                player1Label.scale = 0.8/4;
                player2Label.scale = 0.8/4;
                player1InGameLabel.scale = 1.2/4;
                player2InGameLabel.scale = 1.2/4;
            }
        }
        
        else if (!isPlayer1) {
            
            [self runAction: [CCSequence actions: [CCDelayTime actionWithDuration:1.2], [CCCallFunc actionWithTarget:self selector:@selector(player2ReadyToStartInGameCountdownMethod)], nil]];
            
            tamagachi2Color = tamagachi1Color;
            tamagachi1Color = structOpposingPlayersTamagachiColor->opposingPlayersTamagachiColor;
            
            
            player1InGameLabelStringForPlayer2 = [NSString stringWithFormat:player2.alias];
            player1InGameLabel = [CCLabelBMFont labelWithString:player1InGameLabelStringForPlayer2 fntFile:@"CasualWhite.fnt"];
            [zoombase addChild: player1InGameLabel z:100];
            //    }
            
            player1InGameLabel.position = ccp(125, 5);
            player1InGameLabel.color = ccWHITE;
            player1InGameLabel.scale = 0.5;
            player1InGameLabel.visible = YES;
            
            //   if (firstMatchWithThisPlayer == YES) {
            
            player2InGameLabelStringForPlayer2 = [NSString stringWithFormat:[GKLocalPlayer localPlayer].alias];
            player2InGameLabel = [CCLabelBMFont labelWithString:player2InGameLabelStringForPlayer2 fntFile:@"CasualWhite.fnt"];
            [zoombase addChild: player2InGameLabel z:100];
            //    }
            
            player2InGameLabel.position = ccp(440, 5);
            player2InGameLabel.color = ccWHITE;
            player2InGameLabel.scale = 0.5;
            player2InGameLabel.visible = YES;
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
                player1Label.scale = 0.8/2;
                player2Label.scale = 0.8/2;
                player1InGameLabel.scale = 1.2/2;
                player2InGameLabel.scale = 1.2/2;
            }
            
            else {
                
                player1Label.scale = 0.8/4;
                player2Label.scale = 0.8/4;
                player1InGameLabel.scale = 1.2/4;
                player2InGameLabel.scale = 1.2/4;
            }
        }
        
        
        
        firstPlayer1MarbleSetToGreen = NO;
        firstPlayer2MarbleSetToGreen = NO;
        
        [zoombase removeAllChildrenWithCleanup: YES];
        
        player1Winner = NO;
        player2Winner = NO;
        player1BombExists = NO;
        player2BombExists = NO;
        
        //Note: uncommenting the following subroutine in an effort to make block colors match background colors
        /*
        //Choose a random stage if 'Random Stage Select is YES' or if stage == 0 for some technical reason
        if (checkMarkSpeechBubbleStageSelectIsOnRandomButton || stage == 0) {
            
            checkMarkSpeechBubbleStageSelectIsOnRandomButton = YES;
            int randomLevelRoll = arc4random()%2;
            
            if (randomLevelRoll == 0) {
                
                stage = DAY_TIME_SUBURB;
            }
            
            else if (randomLevelRoll == 1) {
                
                stage = NIGHT_TIME_SUBURB;
            }
        }
        */
        [self setupMarblesAndBlocks];
        
        if (firstMatchWithThisPlayer == YES) {
            
            [self gertyVersusScreen];
        }
        
        [self setupGertyPlayer1];
        [self setupGertyPlayer2];
        
        [self setupBackground];
        
        [self startSpaceManagerAndTimeStep];
        
        //Multiplayer versus screen tamagachi's spacing
        if (firstMatchWithThisPlayer == YES) {
            
            int tamagachiMultiplayerSpacing;
            
            if (deviceIsWidescreen) {
                
                tamagachiMultiplayerSpacing = 25;
            }
            
            if (!deviceIsWidescreen) {
                
                tamagachiMultiplayerSpacing = 0;
            }
            
            [tamagachiMultiplayer runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.3], [CCEaseOut actionWithAction: [CCMoveTo actionWithDuration: 0.6  position: ccp(([linedPaper contentSize].width/2 - 122 + tamagachiMultiplayerSpacing), [linedPaper contentSize].height/2 - 50)] rate: 3.0], nil]];
            [tamagachi2Multiplayer runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.3], [CCEaseOut actionWithAction: [CCMoveTo actionWithDuration: 0.6  position: ccp(([linedPaper contentSize].width/2 + 45 + tamagachiMultiplayerSpacing), [linedPaper contentSize].height/2 - 50)] rate: 3.0], nil]];
            
            // firstMatchWithThisPlayer = NO;
        }
        
        if (isPlayer1) {
            
            [pointingFinger1 runAction: [CCFadeOut actionWithDuration: 0.0]];
            [pointingFinger1 runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(sling1.position.x, sling1.position.y + 30)]];
            [pointingFinger1 runAction: [CCScaleBy actionWithDuration:0.0 scale:0.2]];
            
            [pointingFinger1 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 12.0], [CCFadeIn actionWithDuration:0.0], nil]];
            [pointingFinger1 runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCMoveTo actionWithDuration:0.3 position:ccp(sling1.position.x, sling1.position.y + 35)], [CCMoveTo actionWithDuration:0.3 position:ccp(sling1.position.x, sling1.position.y + 30)],  nil]]];
            
            //run crosshairs animation on gerty2
            [crosshairs2 runAction: [CCFadeOut actionWithDuration: 0.0]];
            [crosshairs2 runAction: [CCScaleTo actionWithDuration:0.0 scale:0.5]];
            
            [crosshairs2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.5], [CCFadeIn actionWithDuration:0.5], nil]];
            [crosshairs2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration:2.0], [CCMoveTo actionWithDuration:0.0 position:ccp(gerty2.position.x + 0, gerty2.position.y + 0)], nil]];
            [crosshairs2 runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCScaleTo actionWithDuration:0.3 scale:0.45], [CCScaleTo actionWithDuration:0.3 scale: 0.3],  nil]]];
            [crosshairs2 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 14.0], [CCFadeOut actionWithDuration:0.4], nil]];
        }
        
        else if (!isPlayer1) {
            
            [pointingFinger1 runAction: [CCFadeOut actionWithDuration: 0.0]];
            [pointingFinger1 runAction: [CCMoveTo actionWithDuration:0.0 position:ccp(sling1Player2.position.x, sling1Player2.position.y + 30)]];
            [pointingFinger1 runAction: [CCScaleBy actionWithDuration:0.0 scale:0.2]];
            
            [pointingFinger1 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 12.0], [CCFadeIn actionWithDuration:0.0], nil]];
            [pointingFinger1 runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCMoveTo actionWithDuration:0.3 position:ccp(sling1Player2.position.x, sling1Player2.position.y + 35)], [CCMoveTo actionWithDuration:0.3 position:ccp(sling1Player2.position.x, sling1Player2.position.y + 30)],  nil]]];
            
            //run crosshairs animation on gerty1
            [crosshairs1 runAction: [CCFadeOut actionWithDuration: 0.0]];
            [crosshairs1 runAction: [CCScaleTo actionWithDuration:0.0 scale:0.5]];
            
            [crosshairs1 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 1.5], [CCFadeIn actionWithDuration:0.5], nil]];
            [crosshairs1 runAction: [CCSequence actions: [CCDelayTime actionWithDuration:2.0], [CCMoveTo actionWithDuration:0.0 position:ccp(gerty.position.x, gerty.position.y + 0)], nil]];
            [crosshairs1 runAction: [CCRepeatForever actionWithAction: [CCSequence actions: [CCScaleTo actionWithDuration:0.3 scale:0.45], [CCScaleTo actionWithDuration:0.3 scale: 0.3],  nil]]];
            [crosshairs1 runAction: [CCSequence actions: [CCDelayTime actionWithDuration: 14.0], [CCFadeOut actionWithDuration:0.4], nil]];
        }
        
        if (isPlayer1) {
            
            NSLog (@"I am player1 tamagachi1Color = %i", tamagachi1Color);
            NSLog (@"I am player1 tamagachi2Color = %i", tamagachi2Color);
        }
        
        else if (!isPlayer1) {
            
            NSLog (@"I am player2 tamagachi1Color = %i", tamagachi1Color);
            NSLog (@"I am player2 tamagachi2Color = %i", tamagachi2Color);
        }
        
        if (isPlayer1) {
            
            player1InGameLabelStringForPlayer1 = [NSString stringWithFormat:[GKLocalPlayer localPlayer].alias];
            player1InGameLabel = [CCLabelBMFont labelWithString:player1InGameLabelStringForPlayer1 fntFile:@"CasualWhite.fnt"];
            [zoombase addChild: player1InGameLabel z:1000];
            //  }
            
            player1InGameLabel.position = ccp(125, 5);
            player1InGameLabel.color = ccWHITE;
            player1InGameLabel.scale = 0.5;
            player1InGameLabel.visible = YES;
            
            //    if (firstMatchWithThisPlayer == YES) {
            
            player2InGameLabelStringForPlayer1 = [NSString stringWithFormat:player.alias];
            player2InGameLabel = [CCLabelBMFont labelWithString:player2InGameLabelStringForPlayer1 fntFile:@"CasualWhite.fnt"];
            [zoombase addChild: player2InGameLabel z:1000];
            //    }
            
            player2InGameLabel.position = ccp(440, 5);
            player2InGameLabel.color = ccWHITE;
            player2InGameLabel.scale = 0.5;
            player2InGameLabel.visible = YES;
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
                player1Label.scale = 0.8/2;
                player2Label.scale = 0.8/2;
                player1InGameLabel.scale = 1.2/2;
                player2InGameLabel.scale = 1.2/2;
            }
            
            else {
                
                player1Label.scale = 0.8/4;
                player2Label.scale = 0.8/4;
                player1InGameLabel.scale = 1.2/4;
                player2InGameLabel.scale = 1.2/4;
            }
        }
        
        else if (!isPlayer1) {
            
            player1InGameLabelStringForPlayer2 = [NSString stringWithFormat:player2.alias];
            player1InGameLabel = [CCLabelBMFont labelWithString:player1InGameLabelStringForPlayer2 fntFile:@"CasualWhite.fnt"];
            [zoombase addChild: player1InGameLabel z:100];
            //    }
            
            player1InGameLabel.position = ccp(125, 5);
            player1InGameLabel.color = ccWHITE;
            player1InGameLabel.scale = 0.5;
            player1InGameLabel.visible = YES;
            
            //   if (firstMatchWithThisPlayer == YES) {
            
            player2InGameLabelStringForPlayer2 = [NSString stringWithFormat:[GKLocalPlayer localPlayer].alias];
            player2InGameLabel = [CCLabelBMFont labelWithString:player2InGameLabelStringForPlayer2 fntFile:@"CasualWhite.fnt"];
            [zoombase addChild: player2InGameLabel z:100];
            //    }
            
            player2InGameLabel.position = ccp(440, 5);
            player2InGameLabel.color = ccWHITE;
            player2InGameLabel.scale = 0.5;
            player2InGameLabel.visible = YES;
            
            if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
                ([UIScreen mainScreen].scale == 2.0) && isIPhoneIPod == NO) {
                player1Label.scale = 0.8/2;
                player2Label.scale = 0.8/2;
                player1InGameLabel.scale = 1.2/2;
                player2InGameLabel.scale = 1.2/2;
            }
            
            else {
                
                player1Label.scale = 0.8/4;
                player2Label.scale = 0.8/4;
                player1InGameLabel.scale = 1.2/4;
                player2InGameLabel.scale = 1.2/4;
            }
        }
        
        firstMatchWithThisPlayer = NO;
    }
}

- (UIViewController *)viewControllerForPresentingModalView {
    return viewController;
}

/*
 - (void)adWhirlWillPresentFullScreenModal
 {
 //  if (self.state == kGameStatePlaying) {
 
 NSLog (@"adWhirlWillPresentFullScreenModal method run.");
 
 if (isGo) {
 
 [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
 }
 
 if (isSinglePlayer) {
 
 [[CCDirector sharedDirector] pause];
 }
 
 //  }
 }
 
 - (void)adWhirlDidDismissFullScreenModal
 {
 NSLog (@"adWhirlDidDismissFullScreenModal method run.");
 
 //   if (self.state == kGameStatePaused)
 //       return;
 
 //  else {
 
 // self.state = kGameStatePlaying;
 
 if (isGo) {
 
 [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
 }
 
 if (isSinglePlayer) {
 
 [[CCDirector sharedDirector] resume];
 }
 
 
 // }
 }
 */

@end

