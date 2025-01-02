package meta.state;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxSoundAsset;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import gameObjects.*;
import gameObjects.userInterface.*;
import gameObjects.userInterface.notes.*;
import gameObjects.userInterface.notes.Strumline.UIStaticArrow;
import meta.*;
import meta.MusicBeat.MusicBeatState;
import meta.data.*;
import meta.data.Song.SwagSong;
import meta.data.Section.SwagSection;
import meta.state.charting.*;
import meta.state.menus.*;
import meta.subState.*;
import openfl.display.GraphicsShader;
import openfl.events.KeyboardEvent;
import openfl.filters.ShaderFilter;
import openfl.media.Sound;
import openfl.utils.Assets;
import sys.io.File;
import flixel.text.FlxText;
import openfl.display.BlendMode;
import meta.data.dependency.FNFSprite;
import ShopState.BeansPopup;
import HeatwaveShader;
import ChromaticAbberation;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

#if !html5
import meta.data.dependency.Discord;
#end

class PlayState extends MusicBeatState
{

	public static var startTimer:FlxTimer;

	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 2;
	public static var freeplayDifficulty:Int = 2;

	public static var songMusic:FlxSound;
	public static var vocals:FlxSound;

	public static var campaignScore:Int = 0;

	public static var dadOpponent:Character;
	public static var gf:Character;
	public static var boyfriend:Boyfriend;
	public static var mom:Character;
	public static var bfLegs:Boyfriend;
	public static var bfLegsmiss:Boyfriend;
	public static var dadlegs:Character;

	var bfAnchorPoint:Array<Float> = [0, 0];
	var dadAnchorPoint:Array<Float> = [0, 0];

	public static var assetModifier:String = 'base';
	public static var changeableSkin:String = 'default';

	private var unspawnNotes:Array<Note> = [];
	private var ratingArray:Array<String> = [];
	private var allSicks:Bool = true;

	// if you ever wanna add more keys
	private var numberOfKeys:Int = 4;

	// get it cus release
	// I'm funny just trust me
	private var curSection:Int = 0;
	private var camFollow:FlxObject;
	private var camFollowPos:FlxObject;

	// Discord RPC variables
	public static var songDetails:String = "";
	public static var detailsSub:String = "";
	public static var detailsPausedText:String = "";

	private static var prevCamFollow:FlxObject;

	private var curSong:String = "";
	private var gfSpeed:Int = 1;

	public static var health:Float = 1; // mario
	public static var combo:Int = 0;

	public static var misses:Int = 0;

	public var generatedMusic:Bool = false;

	private var startingSong:Bool = false;
	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var inCutscene:Bool = false;

	var canPause:Bool = true;

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	public static var camHUD:FlxCamera;
	public static var camGame:FlxCamera;
	public static var dialogueHUD:FlxCamera;

	public var camOther:FlxCamera;

	public var camDisplaceX:Float = 0;
	public var camDisplaceY:Float = 0; // might not use depending on result
	public static var cameraSpeed:Float = 1;

	public static var defaultCamZoom:Float = 1.05;

	public static var forceZoom:Array<Float>;

	public static var songScore:Int = 0;

	var storyDifficultyText:String = "";

	public static var iconRPC:String = "";

	public static var songLength:Float = 0;

	private var stageBuild:Stage;

	public static var uiHUD:ClassHUD;

	public static var daPixelZoom:Float = 6;
	public static var determinedChartType:String = "";

	// strumlines
	private var dadStrums:Strumline;
	private var boyfriendStrums:Strumline;

	public static var strumLines:FlxTypedGroup<Strumline>;
	public static var strumHUD:Array<FlxCamera> = [];

	private var allUIs:Array<FlxCamera> = [];

	// stores the last judgement object
	public static var lastRating:FlxSprite;
	// stores the last combo objects in an array
	public static var lastCombo:Array<FlxSprite>;

	var flashSprite:FlxSprite;

	// guh
	var loBlack:FlxSprite;

	var airSpeedlines:FlxTypedGroup<FlxSprite>;

	var lightoverlay:FlxSprite;

	var heartsImage:FlxSprite;
	var pinkVignette:FlxSprite;
	var pinkVignette2:FlxSprite;

	var turbFrontCloud:FlxTypedGroup<FlxSprite>;

	var victoryDarkness:FlxSprite;

	//jermasorry
	var scaryJerma:FlxSprite;

	// torture
	var windowlights:FlxSprite;
	var leftblades:FlxSprite;
	var rightblades:FlxSprite;
	var montymole:FlxSprite;
	var torlight:FlxSprite;
	var startDark:FlxSprite;
	var ziffyStart:FlxSprite;
	var bladeDistance:Float = 120;

	var light:FNFSprite;

	var repositionDadCameraOffset:Bool = false;
	var repositionBoyfriendCameraOffset:Bool = false;
	private var isCameraOnForcedPos:Bool = false;

	var pet:Character;

	private var task:TaskSong;

	public static var gfxHud:Array<Dynamic> = [
		[0, 1, 2, 3],
		[0, 2, 3, 0, 1, 3],
		[0, 2, 3, 4, 0, 1, 3],
		[0, 1, 2, 3, 4, 0, 1, 2, 3]
	];

	public static var charDir:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT', 'UP'];

	public var dadGhostTween:FlxTween = null;
	public var momGhostTween:FlxTween = null;
	public var bfGhostTween:FlxTween = null;
	public var momGhost:FlxSprite = null;
	public var dadGhost:FlxSprite = null;
	public var bfGhost:FlxSprite = null;

	var charShader:BWShader;

	public var tweeningChar:Bool = false;
	var bfStartpos:FlxPoint;
	var dadStartpos:FlxPoint;
	var gfStartpos:FlxPoint;

	var KillNotes:Bool = false;

	var twistShit:Float = 1;
	var twistAmount:Float = 1;
	var camTwistIntensity:Float = 0;
	var camTwistIntensity2:Float = 3;
	var camTwist:Bool = false;

	var camBopInterval:Int = 4;
	var camBopIntensity:Float = 1;

	var cargoDarken:Bool;
	var cargoReadyKill:Bool;
	var showDlowDK:Bool;

	var opponent2sing:Bool = false;
	var bothOpponentsSing:Bool = false;

	var heatwaveShader:HeatwaveShader;
	var caShader:ChromaticAbberation;
	var chromAmount:Float = 0;
	var chromFreq:Int = 1;
	var chromTween:FlxTween;

	var isChrom:Bool;

	var vignetteTween:FlxTween;
	var whiteTween:FlxTween;
	var pinkCanPulse:Bool = false;
	var heartColorShader:ColorShader = new ColorShader(0);

	var cameraLocked:Bool = false;

	var turbEnding:Bool = false;

	var charlesEnter:Bool = false;

	var daAlt = '-alt';

	// at the beginning of the playstate
	override public function create()
	{
		super.create();

		// reset any values and variables that are static
		songScore = 0;
		combo = 0;
		health = 1;
		misses = 0;
		// sets up the combo object array
		lastCombo = [];

		defaultCamZoom = 1.05;
		cameraSpeed = 1;
		forceZoom = [0, 0, 0, 0];

		Timings.callAccuracy();

		assetModifier = 'base';
		changeableSkin = 'default';

		// stop any existing music tracks playing
		resetMusic();
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// create the game camera
		camGame = new FlxCamera();

		// create the hud camera (separate so the hud stays on screen)
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		camOther = new FlxCamera();
		camOther.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		allUIs.push(camHUD);
		FlxCamera.defaultCameras = [camGame];

		if (isStoryMode && SONG.song.toLowerCase() == 'mando')
		{
		FlxG.mouse.visible = true;
		}
		if (isStoryMode && SONG.song.toLowerCase() == 'dlow')
		{
		FlxG.mouse.visible = true;
		}
		if (isStoryMode && SONG.song.toLowerCase() == 'oversight')
		{
		FlxG.mouse.visible = false;
		}

		if (isStoryMode && SONG.song.toLowerCase() == 'danger')
		{
		FlxG.mouse.visible = false;
		}
		if (isStoryMode && SONG.song.toLowerCase() == 'double-kill')
		{
		FlxG.mouse.visible = false;
		}

		if (isStoryMode && SONG.song.toLowerCase() == 'titular')
		{
		FlxG.mouse.visible = false;
		}
		if (isStoryMode && SONG.song.toLowerCase() == 'greatest-plan')
		{
		FlxG.mouse.visible = false;
		}
		if (isStoryMode && SONG.song.toLowerCase() == 'reinforcements')
		{
		FlxG.mouse.visible = false;
		}
		if (isStoryMode && SONG.song.toLowerCase() == 'armed')
		{
		FlxG.mouse.visible = false;
		}

		missLimited = false;

		// default song
		if (SONG == null)
			SONG = Song.loadFromJson('test', 'test');

		if (charShader == null)
		{
		charShader = new BWShader(0.01, 0.12, true);
		}

		if (PlayState.SONG.stage.toLowerCase() == 'airship')
		{
			camGame.height = FlxG.height + 200;
			camGame.y -= 100;
		}

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		/// here we determine the chart type!
		// determine the chart type here
		determinedChartType = "FNF";

		//

		// set up a class for the stage type in here afterwards
		curStage = "";
		// call the song's stage if it exists
		if (SONG.stage != null)
			curStage = SONG.stage;

		// cache shit
		displayRating('sick', 'early', true);
		popUpCombo(true);
		//

		stageBuild = new Stage(curStage);
		add(stageBuild);

		/*
			Everything related to the stages aside from things done after are set in the stage class!
			this means that the girlfriend's type, boyfriend's position, dad's position, are all there

			It serves to clear clutter and can easily be destroyed later. The problem is,
			I don't actually know if this is optimised, I just kinda roll with things and hope
			they work. I'm not actually really experienced compared to a lot of other developers in the scene,
			so I don't really know what I'm doing, I'm just hoping I can make a better and more optimised
			engine for both myself and other modders to use!
		 */

		// set up characters here too
		gf = new Character();
		gf.adjustPos = false;
		gf.setCharacter(300, 100, stageBuild.returnGFtype(curStage));
		gf.scrollFactor.set(0.95, 0.95);
		if (curStage == 'ejected')
		{
		gf.scrollFactor.set(0.7, 0.7);
		}

		switch(gf.curCharacter){
			case 'gfpolus':
				if (curStage != 'polus2' || curStage != 'polus3'){
					gf.y -= 50;
				}
		}

		if (curStage == 'cargo')
		{
		gf.alpha = 0;
		}
		if (curStage == 'defeat')
		{
		gf.alpha = 0;
		}
		if (curStage == 'finalem')
		{
		gf.alpha = 0;
		}
		if (curStage == 'monotone')
		{
		gf.alpha = 0;
		}
		if (curStage == 'polus3')
		{
		gf.alpha = 0;
		}
		if (curStage == 'pretender')
		{
		gf.alpha = 0;
		}
		if (curStage == 'chef')
		{
		gf.alpha = 0;
		}
		if (curStage == 'lounge')
		{
		gf.alpha = 0;
		}
		if (curStage == 'victory')
		{
		gf.alpha = 0;
		}
		if (curStage == 'who')
		{
		gf.alpha = 0;
		}
		if (curStage == 'jerma')
		{
		gf.alpha = 0;
		}
		if (curStage == 'nuzzus')
		{
		gf.alpha = 0;
		}
		if (curStage == 'idk')
		{
		gf.alpha = 0;
		}
		if (curStage == 'esculent')
		{
		gf.alpha = 0;
		boyfriend.alpha = 0;
		}
		if (curStage == 'dave')
		{
		gf.alpha = 0;
		}
		if (curStage == 'piptowers')
		{
		gf.alpha = 0;
		}
		if (curStage == 'warehouse')
		{
		gf.alpha = 0;
		}
		if (curStage == 'finale')
		{
		gf.alpha = 0;
		}
		if (curStage == 'youtuber')
		{
		gf.alpha = 0;
		}

		if (curStage == 'turbulence')
		{
		remove(gf, true);
		insert(0, gf);
		}

		mom = new Character().setCharacter(0, 0, SONG.player4);
		dadOpponent = new Character().setCharacter(50, 850, SONG.player2);
		boyfriend = new Boyfriend();
		boyfriend.setCharacter(750, 850, SONG.player1);
		// if you want to change characters later use setCharacter() instead of new or it will break

		if(curStage.toLowerCase() == 'turbulence')
		{
			dadOpponent.scrollFactor.set(0.8, 0.9);
			mom.scrollFactor.set(1, 1);
		}
		if(curStage.toLowerCase() == 'warehouse') 
		{
			dadOpponent.scrollFactor.set(1.6, 1.6);
			mom.scrollFactor.set(1.6, 1.6);
		}

		pet = new Character().setCharacter(0, 0, SONG.pet);
		pet.alpha = 0.001;

		var camPos:FlxPoint = new FlxPoint(gf.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

		stageBuild.repositionPlayers(curStage, boyfriend, dadOpponent, gf, mom, pet);
		stageBuild.dadPosition(curStage, boyfriend, dadOpponent, gf, camPos);

		pet.x += 285;
		pet.y += 790;

		changeableSkin = Init.trueSettings.get("UI Skin");
		if ((curStage.startsWith("school")) && ((determinedChartType == "FNF")))
			assetModifier = 'pixel';

		if ((curStage.startsWith("idk")) && ((determinedChartType == "FNF")))
			assetModifier = 'pixel';

		// add characters
		add(gf);

		loBlack = new FlxSprite().makeGraphic(FlxG.width * 4, FlxG.height + 700, FlxColor.BLACK);
		loBlack.alpha = 0;
		loBlack.screenCenter(X);
		loBlack.screenCenter(Y);
		add(loBlack);

		dadGhost = new FlxSprite();
		momGhost = new FlxSprite();
		bfGhost = new FlxSprite();

		if (curStage == 'cargo'){
		add(momGhost);
		add(mom);
		}

		add(bfGhost);
		if (curStage != 'defeat'){
		if (curStage != 'finalem'){
		if (curStage != 'warehouse'){
		add(dadGhost);
		}
		}
		}

		// add limo cus dumb layering
		if (curStage == 'highway')
			add(stageBuild.limo);

		if (SONG.player2 == 'black-run')
		{
		dadlegs = new Character().setCharacter(0, 0, 'blacklegs');
		add(dadlegs);
		}

		if (curStage != 'defeat'){
		if (curStage != 'finalem'){
		if (curStage != 'warehouse'){
		if (curStage != 'youtuber'){
		add(dadOpponent);
		}
		}
		}
		}

		if (SONG.player2 == 'black-run')
		{
			dadlegs.x = dadOpponent.x;
			dadlegs.y = dadOpponent.y;
		}

		if (curStage == 'voting'){
		add(momGhost);
		add(mom);
		}

		if (curStage == 'charles'){
		add(momGhost);
		add(mom);
		mom.flipX = false;
		}

		if (curStage == 'henry'){
		if (SONG.song.toLowerCase() == 'armed')
		{
		add(momGhost);
		add(mom);
		}
		}

		if (curStage == 'attack'){
		add(momGhost);
		add(mom);
		}

		if (curStage == 'turbulence')
		{
			add(stageBuild.hookarm);
		}

		if (SONG.player1 == 'bf-running')
		{
		bfLegs = new Boyfriend();
		bfLegs.setCharacter(0, 0, 'bf-legs');
		add(bfLegs);
		bfLegsmiss = new Boyfriend();
		bfLegsmiss.setCharacter(0, 0, 'bf-legsmiss');
		add(bfLegsmiss);
		}

		if (curStage.toLowerCase() == 'charles')
		{
			SONG.player1 = 'henryphone';
		}

		add(boyfriend);

		dadGhost.visible = false;
		dadGhost.antialiasing = true;
		dadGhost.scale.copyFrom(dadOpponent.scale);
		dadGhost.updateHitbox();
		momGhost.visible = false;
		momGhost.antialiasing = true;
		momGhost.scale.copyFrom(mom.scale);
		momGhost.updateHitbox();
		bfGhost.visible = false;
		
			
		bfGhost.antialiasing = true;
		bfGhost.scale.copyFrom(boyfriend.scale);
		bfGhost.updateHitbox();
		if(curStage.toLowerCase() == 'school')
		{
			bfGhost.antialiasing = false;
			dadGhost.antialiasing = false;
		}
		else
		{
			bfGhost.antialiasing = true;
			dadGhost.antialiasing = true;
		}

		if(SONG.player1 == 'bf-running')
		{
			bfLegs.x = boyfriend.x;
			bfLegs.y = boyfriend.y;
			bfLegsmiss.x = boyfriend.x;
			bfLegsmiss.y = boyfriend.y;
		}

		bfAnchorPoint[0] = boyfriend.x;
		bfAnchorPoint[1] = boyfriend.y;
		dadAnchorPoint[0] = boyfriend.x;
		dadAnchorPoint[1] = boyfriend.y;

		if (curStage.toLowerCase() != 'alpha' && curStage.toLowerCase() != 'defeat'  && curStage.toLowerCase() != 'who' && !SONG.allowPet)
		{
			pet.alpha = 1;
			add(pet);
		}

		if (SONG.pet == null)
		{
		pet.visible = false;
		SONG.pet = 'nothing';
		}
		else
		pet.visible = true;

		if (curStage == 'defeat'){
			add(dadOpponent);
			add(stageBuild.bodiesfront);
		}

		if (curStage == 'finalem'){
			add(dadOpponent);
			add(stageBuild.finaleFGStuff);
			add(stageBuild.finaleFlashbackStuff);
		}

		if (curStage == 'voting'){
			add(stageBuild.table);

					var madgus:Character = new Character().setCharacter(0, 0, 'madgus');
					add(madgus);
					madgus.alpha = 0.00001;
		}

		switch(curStage.toLowerCase()){
			case 'polus':
				add(stageBuild.snow);
				if (SONG.song.toLowerCase() == 'sabotage')
				{
					var ghostgf:Character = new Character();
					ghostgf.setCharacter(0, 0, 'ghostgf');
					add(ghostgf);
					ghostgf.alpha = 0.00001;
				}
				if (SONG.song.toLowerCase() == 'meltdown')
				{
					add(stageBuild.crowd2);
				}
			case 'toogus':
				if (SONG.song.toLowerCase() == 'lights-down')
				{
					var whitebf:Boyfriend = new Boyfriend();
					whitebf.setCharacter(0, 0, 'whitebf');
					add(whitebf);
					whitebf.alpha = 0.00001;

					var whitegreen:Character = new Character().setCharacter(0, 0, 'whitegreen');
					add(whitegreen);
					whitegreen.alpha = 0.00001;
				}
			case 'reactor2':
				add(stageBuild.lightoverlay);
				add(stageBuild.mainoverlay);
			case 'ejected':
				bfStartpos = new FlxPoint(1008.6 + stageBuild.BF_X, 504 + stageBuild.BF_Y);
				gfStartpos = new FlxPoint(114.4 + stageBuild.GF_X, 78.45 + stageBuild.GF_Y);
				dadStartpos = new FlxPoint(-775.75 + stageBuild.DAD_X, 274.3 + stageBuild.DAD_Y);
				for (i in 0...stageBuild.cloudScroll.members.length)
				{
					add(stageBuild.cloudScroll.members[i]);
				}
				add(stageBuild.cloudScroll);
				add(stageBuild.speedLines);
			case 'airshiproom':
				if (SONG.song.toLowerCase() == 'dlow')
				{
					var bfshock:Boyfriend = new Boyfriend();
					bfshock.setCharacter(0, 0, 'bfshock');
					add(bfshock);
					bfshock.alpha = 0.00001;

					var reaction:Character = new Character().setCharacter(0, 0, 'reaction');
					add(reaction);
					reaction.alpha = 0.00001;
				}
			case 'airship':

				airSpeedlines = new FlxTypedGroup<FlxSprite>();

				for (i in 0...2)
				{
					var speedline:FlxSprite = new FlxSprite(-912.75, -1035.95).loadGraphic(Paths.image('backgrounds/' + curStage + '/speedlines'));
					switch (i)
					{
						case 1:
							speedline.setPosition(-3352.1, -1035.95);
						case 2:
							speedline.setPosition(5140.05, -1035.95);
					}
					speedline.antialiasing = true;
					speedline.alpha = 0.2;
					speedline.updateHitbox();
					speedline.scrollFactor.set(1.3, 1.3);
					add(speedline);
					airSpeedlines.add(speedline);
				}

					var blackalt:Character = new Character().setCharacter(0, 0, 'blackalt');
					add(blackalt);
					blackalt.alpha = 0.00001;

			case 'cargo':
				add(stageBuild.mainoverlayDK);
				add(stageBuild.defeatDKoverlay);
				add(stageBuild.cargoDarkFG);

					var bfdefeatnormal:Boyfriend = new Boyfriend();
					bfdefeatnormal.setCharacter(0, 0, 'bf-defeat-normal');
					add(bfdefeatnormal);
					bfdefeatnormal.alpha = 0.00001;
			case 'defeat':
				add(stageBuild.lightoverlay);

					var blackKill:Character = new Character().setCharacter(0, 0, 'blackKill');
					add(blackKill);
					blackKill.alpha = 0.00001;

					var bfdefeatscared:Boyfriend = new Boyfriend();
					bfdefeatscared.setCharacter(0, 0, 'bf-defeat-scared');
					add(bfdefeatscared);
					bfdefeatscared.alpha = 0.00001;

					var bf:Boyfriend = new Boyfriend();
					bf.setCharacter(0, 0, 'bf');
					add(bf);
					bf.alpha = 0.00001;

					var blackold:Character = new Character().setCharacter(0, 0, 'blackold');
					add(blackold);
					blackold.alpha = 0.00001;
			case 'finalem':
				lightoverlay = new FlxSprite(-550, 250).loadGraphic(Paths.image('backgrounds/' + curStage + '/iluminao omaga'));
				lightoverlay.antialiasing = true;
				lightoverlay.scrollFactor.set(1, 1);
				lightoverlay.active = false;
				lightoverlay.blend = ADD;
				add(lightoverlay);
				add(stageBuild.finaleDarkFG);

					var blackparasite:Character = new Character().setCharacter(0, 0, 'blackparasite');
					add(blackparasite);
					blackparasite.alpha = 0.00001;
			case 'monotone':
				var lightoverlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/overlay'));
				lightoverlay.antialiasing = true;
				lightoverlay.scrollFactor.set(1, 1);
				lightoverlay.active = false;
				lightoverlay.setGraphicSize(Std.int(lightoverlay.width * 2));
				lightoverlay.blend = MULTIPLY;
				add(lightoverlay);

				var lightoverlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/overlay2'));
				lightoverlay.antialiasing = true;
				lightoverlay.scrollFactor.set(1, 1);
				lightoverlay.active = false;
				lightoverlay.blend = ADD;
				lightoverlay.setGraphicSize(Std.int(lightoverlay.width * 2));
				add(lightoverlay);

					var monotone:Character = new Character().setCharacter(0, 0, 'monotone');
					add(monotone);
					monotone.alpha = 0.00001;

					var impostor:Character = new Character().setCharacter(0, 0, 'impostor');
					add(impostor);
					impostor.alpha = 0.00001;

					var bffall:Boyfriend = new Boyfriend();
					bffall.setCharacter(0, 0, 'bf-fall');
					add(bffall);
					bffall.alpha = 0.00001;

					var parasite:Character = new Character().setCharacter(0, 0, 'parasite');
					add(parasite);
					parasite.alpha = 0.00001;

					var blackdk:Character = new Character().setCharacter(0, 0, 'blackdk');
					add(blackdk);
					blackdk.alpha = 0.00001;
			case 'polus2':
				add(stageBuild.snow2);
				add(stageBuild.snow);

				var mainoverlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/newoverlay'));
				mainoverlay.antialiasing = true;
				mainoverlay.scrollFactor.set(1, 1);
				mainoverlay.active = false;
				mainoverlay.setGraphicSize(Std.int(mainoverlay.width * 0.75));
				mainoverlay.alpha = 0.44;
				mainoverlay.blend = ADD;
				add(mainoverlay);

				var lightoverlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/newoverlay'));
				lightoverlay.antialiasing = true;
				lightoverlay.scrollFactor.set(1, 1);
				lightoverlay.active = false;
				lightoverlay.setGraphicSize(Std.int(lightoverlay.width * 0.75));
				lightoverlay.alpha = 0.21;
				lightoverlay.blend = ADD;
				add(lightoverlay);
			case 'polus3':
				add(stageBuild.emberEmitter);
				add(stageBuild.lavaOverlay);
			case 'grey':
				var lightoverlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/grayfg'));
				lightoverlay.antialiasing = true;
				lightoverlay.scrollFactor.set(1, 1);
				lightoverlay.active = false;
				lightoverlay.alpha = 1;
				add(lightoverlay);

				var lightoverlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/graymultiply'));
				lightoverlay.antialiasing = true;
				lightoverlay.scrollFactor.set(1, 1);
				lightoverlay.active = false;
				lightoverlay.alpha = 1;
				lightoverlay.blend = MULTIPLY;
				add(lightoverlay);

				var lightoverlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/grayoverlay'));
				lightoverlay.antialiasing = true;
				lightoverlay.scrollFactor.set(1, 1);
				lightoverlay.active = false;
				lightoverlay.alpha = 0.4;
				lightoverlay.blend = MULTIPLY;
				add(lightoverlay);
			case 'plantroom':
				pinkVignette = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/vignette'));
				pinkVignette.cameras = [camHUD];
				pinkVignette.alpha = 0;
				pinkVignette.antialiasing = true;
				pinkVignette.blend = ADD;

				pinkVignette2 = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/vignette2'));
				pinkVignette2.cameras = [camHUD];
				pinkVignette2.antialiasing = true;
				pinkVignette2.alpha = 0;
				add(pinkVignette2);
				add(pinkVignette);

				heartsImage = new FlxSprite(-25, 0);
				heartsImage.cameras = [camOther];
				heartsImage.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/hearts');
				heartsImage.animation.addByPrefix('boil', 'Symbol 2', 24, true);
				heartsImage.animation.play('boil');
				heartsImage.antialiasing = true;
				heartsImage.alpha = 0;
				add(heartsImage);

				add(stageBuild.bluemira);
				add(stageBuild.pot);
				add(stageBuild.vines);
				add(stageBuild.pretenderDark);
				add(stageBuild.heartEmitter);
			case 'pretender':
				add(stageBuild.bluemira);
				add(stageBuild.pot);
				add(stageBuild.vines);

				var pretenderLighting:FlxSprite = new FlxSprite(-1670, -700).loadGraphic(Paths.image('backgrounds/' + curStage + '/lightingpretender'));
				pretenderLighting.antialiasing = true;
				add(pretenderLighting);
			case 'chef':
				add(stageBuild.chefBluelight);
				add(stageBuild.chefBlacklight);
			case 'lounge':
				add(stageBuild.loungelight);
				add(stageBuild.o2lighting);
				add(stageBuild.o2dark);
				add(stageBuild.o2WTF);

					var meangus:Character = new Character().setCharacter(0, 0, 'meangus');
					add(meangus);
					meangus.alpha = 0.00001;
			case 'turbulence':
				add(stageBuild.hookarm);
				add(stageBuild.clawshands);

				airSpeedlines = new FlxTypedGroup<FlxSprite>();

				turbFrontCloud = new FlxTypedGroup<FlxSprite>();

				for (i in 0...2)
					{
						var frontercloud:FlxSprite = new FlxSprite(-1399.75,1012.65).loadGraphic(Paths.image('backgrounds/' + curStage + '/frontclouds'));
						switch (i)
						{
							case 1:
								frontercloud.setPosition(-1399.75, 1012.65);
	
							case 2:
								frontercloud.setPosition(4102, 1012.65);
						}
						frontercloud.antialiasing = true;
						frontercloud.updateHitbox();
						frontercloud.scrollFactor.set(1, 1);
						add(frontercloud);
						turbFrontCloud.add(frontercloud);
					}

				add(stageBuild.turblight);

				for (i in 0...2)
				{
					var speedline:FlxSprite = new FlxSprite(912.75, -1035.95).loadGraphic(Paths.image('backgrounds/' + curStage + '/speedlines'));
					switch (i)
					{
						case 1:
							speedline.setPosition(3352.1, 135.95);
						case 2:
							speedline.setPosition(-5140.05, 135.95);
					}
					speedline.antialiasing = true;
					speedline.alpha = 0.2;
					speedline.updateHitbox();
					speedline.scrollFactor.set(1.3, 1.3);
					add(speedline);
					airSpeedlines.add(speedline);
				}
				add(airSpeedlines);
			case 'victory':
				add(stageBuild.spotlights);
				add(stageBuild.vicPulse);
				add(stageBuild.fog_front);

					var jelqer:Character = new Character().setCharacter(0, 0, 'jelqer');
					add(jelqer);
					jelqer.alpha = 0.00001;

					var jorsawghost:Character = new Character().setCharacter(0, 0, 'jorsawghost');
					add(jorsawghost);
					jorsawghost.alpha = 0.00001;
			case 'henry':
				add(stageBuild.armedGuy);
			case 'school':
		if (SONG.song.toLowerCase() == 'rivals')
		{
		var bfsuspixel:Boyfriend = new Boyfriend();
		bfsuspixel.setCharacter(0, 0, 'bfsus-pixel');
		add(bfsuspixel);
		bfsuspixel.alpha = 0.00001;

		var hamster:Character = new Character().setCharacter(0, 0, 'hamster');
		add(hamster);
		hamster.alpha = 0.00001;
		}
			case 'loggo2':
				var darknessLojo:FlxSprite = new FlxSprite(-800, -0).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
				darknessLojo.antialiasing = true;
				darknessLojo.alpha = 0.5;
				add(darknessLojo);
			case 'kills':
					var bluehit:Boyfriend = new Boyfriend();
					bluehit.setCharacter(0, 0, 'bluehit');
					add(bluehit);
					bluehit.alpha = 0.00001;
			case 'who':
				add(stageBuild.meeting);
				add(stageBuild.furiousRage);
				add(stageBuild.emergency);
				add(stageBuild.whoAngered);

					var bluewho:Character = new Character().setCharacter(0, 0, 'bluewho');
					add(bluewho);
					bluewho.alpha = 0.00001;

					var whitemad:Boyfriend = new Boyfriend();
					whitemad.setCharacter(0, 0, 'whitemad');
					add(whitemad);
					whitemad.alpha = 0.00001;
			case 'jerma': // fuck you neato
				scaryJerma = new FlxSprite(300, 150);
				scaryJerma.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/jermaSCARY');
				scaryJerma.animation.addByPrefix('w', 'sussyjerma', 24, false);
				scaryJerma.setGraphicSize(Std.int(scaryJerma.width * 1.6));
				scaryJerma.scrollFactor.set();
				scaryJerma.alpha = 0.001;
				add(scaryJerma);
			case 'piptowers':
					var pipevil:Boyfriend = new Boyfriend();
					pipevil.setCharacter(0, 0, 'pip_evil');
					add(pipevil);
					pipevil.alpha = 0.00001;
			case 'warehouse':
				add(stageBuild.torglasses);
				add(stageBuild.windowlights);
				add(stageBuild.leftblades);
				add(stageBuild.rightblades);
				add(stageBuild.ROZEBUD_ILOVEROZEBUD_HEISAWESOME);
				add(dadGhost);
				add(dadOpponent);
				add(momGhost);
				add(mom);

				montymole = new FlxSprite(14.05, 439.7);
				montymole.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/monty');
				montymole.animation.addByPrefix('idle', 'mole idle', 24, true);
				montymole.animation.play('idle');
				montymole.antialiasing = true;
				montymole.scrollFactor.set(1.6, 1.6);
				montymole.active = true;
				add(montymole);
				
				torlight = new FlxSprite(-410, -480.45).loadGraphic(Paths.image('backgrounds/' + curStage + '/torture_glow2'));
				torlight.antialiasing = true;
				torlight.scrollFactor.set(1, 1);
				torlight.active = false;
				torlight.alpha = 0.25;
				torlight.blend = ADD;
				add(torlight);

				startDark = new FlxSprite().makeGraphic(2000, 2000, 0xFF000000);
				startDark.screenCenter(XY);
				startDark.scrollFactor.set(0, 0);
				add(startDark);

				ziffyStart = new FlxSprite();
				ziffyStart.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/torture_startZiffy');
				ziffyStart.animation.addByPrefix('idle', 'Opening', 24, false);
				ziffyStart.visible = false;
				ziffyStart.screenCenter(XY);
				ziffyStart.scrollFactor.set(0, 0);
				add(ziffyStart);
			case 'finale':
				var splat:FNFSprite = new FNFSprite(370, 1200).loadGraphic(Paths.image('backgrounds/' + curStage + '/splat'));

				var fore:FNFSprite = new FNFSprite(-750, 160).loadGraphic(Paths.image('backgrounds/' + curStage + '/fore'));
				fore.scrollFactor.set(1.1, 1.1);

				var dark:FNFSprite = new FNFSprite(-720, -350).loadGraphic(Paths.image('backgrounds/' + curStage + '/dark'));
				dark.scrollFactor.set(1.05, 1.05);

				light = new FNFSprite(-230, -100);
				light.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/light');
				light.animation.addByPrefix('finale/light', 'light', 24, true);
				light.blend = 'add';
				dark.blend = 'multiply';

				add(splat);
				add(fore);
				add(dark);
				add(light);

				fore.scale.set(1.1, 1.1);
				splat.scale.set(1.1, 1.1);
				dark.scale.set(1.1, 1.1);
				light.scale.set(1.1, 1.1);
			case 'tripletrouble':

					var black:Character = new Character().setCharacter(0, 0, 'black');
					add(black);
					black.alpha = 0.00001;

					var grey:Character = new Character().setCharacter(0, 0, 'grey');
					add(grey);
					grey.alpha = 0.00001;

					var maroon:Character = new Character().setCharacter(0, 0, 'maroon');
					add(maroon);
					maroon.alpha = 0.00001;
			case 'youtuber':
				add(dadGhost);
				add(dadOpponent);
		}

		victoryDarkness = new FlxSprite(0, 0).makeGraphic(3000, 3000, 0xff000000);
		victoryDarkness.alpha = 0;

		if (SONG.song.toLowerCase() == 'victory')
		{
		add(victoryDarkness);
		}

		flashSprite = new FlxSprite(0, 0).makeGraphic(1920, 1080, 0xFFb30000);
		add(flashSprite);
		flashSprite.alpha = 0;
		flashSprite.cameras = [camOther];

		var textPath = Paths.txt("songs/" + SONG.song.toLowerCase().replace(' ', '-') + "/info");
		if (sys.FileSystem.exists(textPath))
		{
			trace('it exists');
			task = new TaskSong(0, 200, "songs/" + SONG.song.toLowerCase().replace(' ', '-'));
			task.cameras = [camOther];
			add(task);
		}

		add(stageBuild.foreground);

		// force them to dance
		dadOpponent.dance();
		gf.dance();
		boyfriend.dance();

		// set song position before beginning
		Conductor.songPosition = -(Conductor.crochet * 4);

		// EVERYTHING SHOULD GO UNDER THIS, IF YOU PLAN ON SPAWNING SOMETHING LATER ADD IT TO STAGEBUILD OR FOREGROUND
		// darken everything but the arrows and ui via a flxsprite
		var darknessBG:FlxSprite = new FlxSprite(FlxG.width * -0.5, FlxG.height * -0.5).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		darknessBG.alpha = (100 - Init.trueSettings.get('Stage Opacity')) / 100;
		darknessBG.scrollFactor.set(0, 0);
		add(darknessBG);

		// strum setup
		strumLines = new FlxTypedGroup<Strumline>();

		// generate the song
		generateSong(SONG.song);

		// set the camera position to the center of the stage
		camPos.set(gf.x + (gf.frameWidth / 2), gf.y + (gf.frameHeight / 2));

		// create the game camera
		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(camPos.x, camPos.y);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(camPos.x, camPos.y);
		// check if the camera was following someone previously
		if (prevCamFollow != null) {
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);
		add(camFollowPos);

		// actually set the camera up
		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		// initialize ui elements
		startingSong = true;
		startedCountdown = true;

		//
		var placement = (FlxG.width / 2);
		dadStrums = new Strumline(placement - (FlxG.width / 4), this, dadOpponent, false, true, false, 4, Init.trueSettings.get('Downscroll'));
		dadStrums.visible = !Init.trueSettings.get('Centered Notefield');
		boyfriendStrums = new Strumline(placement + (!Init.trueSettings.get('Centered Notefield') ? (FlxG.width / 4) : 0), this, boyfriend, true, false, true,
			4, Init.trueSettings.get('Downscroll'));

		strumLines.add(dadStrums);
		strumLines.add(boyfriendStrums);

		// strumline camera setup
		strumHUD = [];
		for (i in 0...strumLines.length)
		{
			// generate a new strum camera
			strumHUD[i] = new FlxCamera();
			strumHUD[i].bgColor.alpha = 0;

			//strumHUD[i].cameras = [camHUD];
			allUIs.push(strumHUD[i]);
			FlxG.cameras.add(strumHUD[i]);
			// set this strumline's camera to the designated camera
			strumLines.members[i].cameras = [strumHUD[i]];
		}
		add(strumLines);

		uiHUD = new ClassHUD();
		add(uiHUD);
		uiHUD.cameras = [camHUD];
		//

		FlxG.cameras.add(camOther);

		// create a hud over the hud camera for dialogue
		dialogueHUD = new FlxCamera();
		dialogueHUD.bgColor.alpha = 0;
		FlxG.cameras.add(dialogueHUD);

		//
		keysArray = [
			copyKey(Init.gameControls.get('LEFT')[0]),
			copyKey(Init.gameControls.get('DOWN')[0]),
			copyKey(Init.gameControls.get('UP')[0]),
			copyKey(Init.gameControls.get('RIGHT')[0])
		];

		FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		
		Paths.clearUnusedMemory();

		// call the funny intro cutscene depending on the song
		if (!skipCutscenes())
			songIntroCutscene();
		else
			startCountdown();

		/**
		 * SHADERS
		 *
		 * This is a highly experimental code by gedehari to support runtime shader parsing.
		 * Usually, to add a shader, you would make it a class, but now, I modified it so
		 * you can parse it from a file.
		 *
		 * This feature is planned to be used for modcharts
		 * (at this time of writing, it's not available yet).
		 *
		 * This example below shows that you can apply shaders as a FlxCamera filter.
		 * the GraphicsShader class accepts two arguments, one is for vertex shader, and
		 * the second is for fragment shader.
		 * Pass in an empty string to use the default vertex/fragment shader.
		 *
		 * Next, the Shader is passed to a new instance of ShaderFilter, neccesary to make
		 * the filter work. And that's it!
		 *
		 * To access shader uniforms, just reference the `data` property of the GraphicsShader
		 * instance.
		 *
		 * Thank you for reading! -gedehari
		 */

		// Uncomment the code below to apply the effect

		/*
		var shader:GraphicsShader = new GraphicsShader("", File.getContent("./assets/shaders/vhs.frag"));
		FlxG.camera.setFilters([new ShaderFilter(shader)]);
		*/
		if (curStage == 'polus3')
		{
				caShader = new ChromaticAbberation(0);
				add(caShader);
				caShader.amount = -0.2;
				var filter2:ShaderFilter = new ShaderFilter(caShader.shader);

				heatwaveShader = new HeatwaveShader();
				add(heatwaveShader);
				var filter:ShaderFilter = new ShaderFilter(heatwaveShader.shader);
				camGame.setFilters([filter, filter2]);
		}
		if (curStage == 'grey')
		{
				caShader = new ChromaticAbberation(0);
				add(caShader);
				caShader.amount = -0.5;
				var filter:ShaderFilter = new ShaderFilter(caShader.shader);
				camGame.setFilters([filter]);
		}
	}

	public static function copyKey(arrayToCopy:Array<FlxKey>):Array<FlxKey>
	{
		var copiedArray:Array<FlxKey> = arrayToCopy.copy();
		var i:Int = 0;
		var len:Int = copiedArray.length;

		while (i < len)
		{
			if (copiedArray[i] == NONE)
			{
				copiedArray.remove(NONE);
				--i;
			}
			i++;
			len = copiedArray.length;
		}
		return copiedArray;
	}
	
	var keysArray:Array<Dynamic>;

	public function onKeyPress(event:KeyboardEvent):Void {
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		var stringArrow:String = '';

		if ((key >= 0)
			&& !boyfriendStrums.autoplay
			&& (FlxG.keys.checkStatus(eventKey, JUST_PRESSED))
			&& (FlxG.keys.enabled && !paused && (FlxG.state.active || FlxG.state.persistentUpdate)))
		{
			if (generatedMusic)
			{
				var previousTime:Float = Conductor.songPosition;
				Conductor.songPosition = songMusic.time;
				// improved this a little bit, maybe its a lil
				var possibleNoteList:Array<Note> = [];
				var pressedNotes:Array<Note> = [];

				boyfriendStrums.allNotes.forEachAlive(function(daNote:Note)
				{
					if ((daNote.noteData == key) && daNote.canBeHit && !daNote.isSustainNote && !daNote.tooLate && !daNote.wasGoodHit)
						possibleNoteList.push(daNote);
				});
				possibleNoteList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

				// if there is a list of notes that exists for that control
				if (possibleNoteList.length > 0)
				{
					var eligable = true;
					var firstNote = true;
					// loop through the possible notes
					for (coolNote in possibleNoteList)
					{
						for (noteDouble in pressedNotes)
						{
							if (Math.abs(noteDouble.strumTime - coolNote.strumTime) < 10)
								firstNote = false;
							else
								eligable = false;
						}

						if (eligable) {
							goodNoteHit(coolNote, boyfriend, boyfriendStrums, firstNote); // then hit the note
							pressedNotes.push(coolNote);
						}
						// end of this little check
					}
					//
				}
				else // else just call bad notes
					if (!Init.trueSettings.get('Ghost Tapping'))
						missNoteCheck(true, key, boyfriend, true);
				Conductor.songPosition = previousTime;
			}

			if (boyfriendStrums.receptors.members[key] != null 
			&& boyfriendStrums.receptors.members[key].animation.curAnim.name != 'confirm')
				boyfriendStrums.receptors.members[key].playAnim('pressed');
		}

		/*
		if (key == 2)
		{
			if (boyfriend.animation.curAnim.name == 'idle' && boyfriend.curCharacter == 'greenp')
			{
				boyfriend.playAnim('singUP', true);
				boyfriend.animation.curAnim.curFrame = 5;
				boyfriend.holdTimer = 0.6;
			}
		}
		if (key == 1)
		{
			if (boyfriend.animation.curAnim.name == 'idle' && boyfriend.curCharacter == 'redp')
			{
				boyfriend.playAnim('hey', true);
				boyfriend.specialAnim = true;
				boyfriend.holdTimer = 0.6;
			}
		}
		*/
	}

	public function onKeyRelease(event:KeyboardEvent):Void {
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);

		if (FlxG.keys.enabled && !paused && (FlxG.state.active || FlxG.state.persistentUpdate)) {
			// receptor reset
			if (key >= 0 && boyfriendStrums.receptors.members[key] != null)
				boyfriendStrums.receptors.members[key].playAnim('static');
		}
	}

	private function getKeyFromEvent(key:FlxKey):Int {
		if (key != NONE)
		{
			for (i in 0...keysArray.length)
			{
				for (j in 0...keysArray[i].length)
				{
					if (key == keysArray[i][j])
						return i;
				}
			}
		}
		return -1;
	}

	override public function destroy() {
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);

		super.destroy();
	}

	function henryTeleport()
	{
		canPause = false;
		
		vocals.volume = 0;
		vocals.pause();
		KillNotes = true;
		FlxTween.tween(FlxG.sound.music, {volume: 0}, 5, {ease: FlxEase.expoOut});

		var colorShader:ColorShader = new ColorShader(0);
		boyfriend.shader = colorShader.shader;

		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});

		isCameraOnForcedPos = true;
		camFollow.x = 750;
		camFollow.y = 500;
		dadOpponent.setCharacter(0, 0, 'reaction');
		dadOpponent.setPosition(800, 450);
		dadOpponent.y += 160;
		dadOpponent.x += 0;
		dadOpponent.setPosition(-240, 175);
		dadOpponent.animation.play('first', true);
		dadOpponent.specialAnim = true;

		FlxG.sound.play(Paths.sound('teleport_sound'), 1);

		new FlxTimer().start(0.45, function(tmr:FlxTimer)
		{
			colorShader.amount = 1;
			FlxTween.tween(colorShader, {amount: 0}, 0.73, {ease: FlxEase.expoOut});
		});

		new FlxTimer().start(1.28, function(tmr:FlxTimer)
		{
			colorShader.amount = 1;
			gf.shader = colorShader.shader;
			pet.shader = colorShader.shader;
			FlxTween.tween(colorShader, {amount: 0.1}, 0.55, {ease: FlxEase.expoOut});
		});

		new FlxTimer().start(1.93, function(tmr:FlxTimer)
		{
			colorShader.amount = 1;
			FlxTween.tween(colorShader, {amount: 0.2}, 0.2, {ease: FlxEase.expoOut});
			dadOpponent.animation.play('second', true);
			dadOpponent.specialAnim = true;
		});

		new FlxTimer().start(2.23, function(tmr:FlxTimer)
		{
			colorShader.amount = 1;
			FlxTween.tween(colorShader, {amount: 0.4}, 0.22, {ease: FlxEase.expoOut});
		});
		new FlxTimer().start(2.55, function(tmr:FlxTimer)
		{
			colorShader.amount = 1;
			FlxTween.tween(colorShader, {amount: 0.8}, 0.05, {ease: FlxEase.expoOut});
		});

		new FlxTimer().start(2.7, function(tmr:FlxTimer)
		{
			colorShader.amount = 1;
			FlxTween.tween(boyfriend, {"scale.y": 0}, 0.7, {ease: FlxEase.expoOut});
			FlxTween.tween(boyfriend, {"scale.x": 3.5}, 0.7, {ease: FlxEase.expoOut});
		});

		new FlxTimer().start(2.8, function(tmr:FlxTimer)
		{
			FlxTween.tween(gf, {"scale.y": 0}, 0.7, {ease: FlxEase.expoOut});
			FlxTween.tween(gf, {"scale.x": 3.5}, 0.7, {ease: FlxEase.expoOut});
		});

		new FlxTimer().start(2.9, function(tmr:FlxTimer)
		{
			stageBuild.whiteAwkward.animation.play('stare');
			dadOpponent.animation.play('third', true);
			dadOpponent.specialAnim = true;
		});

		new FlxTimer().start(4.5, function(tmr:FlxTimer)
		{
			FlxG.camera.fade(FlxColor.BLACK, 1.4, false, function()
			{
				Main.switchState(this, new HenryState());
			}, true);
		});
	}

	var staticDisplace:Int = 0;

	var lastSection:Int = 0;

	override public function update(elapsed:Float)
	{
		stageBuild.stageUpdateConstant(elapsed, boyfriend, gf, dadOpponent);

		super.update(elapsed);
		missLimitManager();

		flashSprite.alpha = FlxMath.lerp(flashSprite.alpha, 0, CoolUtil.boundTo(elapsed * 9, 0, 1));

		if (curStage == 'toogus')
		{
			stageBuild.saxguy.x = FlxMath.lerp(stageBuild.saxguy.x, stageBuild.saxguy.x + 15, CoolUtil.boundTo(elapsed * 9, 0, 1));
		}

		switch (curStage)
		{
			case 'ejected':
				for (hud in allUIs)
				hud.y = Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 1.0) * 15;
				for (hud in allUIs)
				hud.angle = Math.sin((Conductor.songPosition / 1200) * (Conductor.bpm / 60) * -1.0) * 1.2;
			case 'airship':
				camGame.shake(0.0008, 0.01);
				camGame.y = Math.sin((Conductor.songPosition / 280) * (Conductor.bpm / 60) * 1.0) * 2 - 100;
				for (hud in allUIs)
				hud.y = Math.sin((Conductor.songPosition / 300) * (Conductor.bpm / 60) * 1.0) * 0.6;
				for (hud in allUIs)
				hud.angle = Math.sin((Conductor.songPosition / 350) * (Conductor.bpm / 60) * -1.0) * 0.6;
				if (airSpeedlines.members.length > 0)
				{
					for (i in 0...airSpeedlines.members.length)
					{
						airSpeedlines.members[i].x = FlxMath.lerp(airSpeedlines.members[i].x, airSpeedlines.members[i].x - 350,
							CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (airSpeedlines.members[i].x < -5140.05)
						{
							airSpeedlines.members[i].x = 3352.1;
						}
					}
				}
			case 'cargo':
				if(cargoDarken){
					stageBuild.cargoDark.alpha = FlxMath.lerp(stageBuild.cargoDark.alpha, 1, CoolUtil.boundTo(elapsed * 1.4, 0, 1));
					dadOpponent.alpha = FlxMath.lerp(dadOpponent.alpha, 0.001, CoolUtil.boundTo(elapsed * 1.4, 0, 1));
					mom.alpha = FlxMath.lerp(mom.alpha, 0.001, CoolUtil.boundTo(elapsed * 1.4, 0, 1));
					pet.alpha = FlxMath.lerp(pet.alpha, 0.001, CoolUtil.boundTo(elapsed * 1.4, 0, 1));
					stageBuild.mainoverlayDK.alpha = FlxMath.lerp(stageBuild.mainoverlayDK.alpha, 0.001, CoolUtil.boundTo(elapsed * 1.4, 0, 1));
				}
				if(showDlowDK){
					stageBuild.cargoAirsip.alpha = FlxMath.lerp(stageBuild.cargoAirsip.alpha, 0.45, CoolUtil.boundTo(elapsed * 0.1, 0, 1));
				}
				if (Conductor.songPosition >= 0 && Conductor.songPosition < 1200 ){
					stageBuild.cargoDarkFG.alpha -= 0.005;
					FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 1, CoolUtil.boundTo(elapsed * 3, 0, 1));
				}
				if (cargoReadyKill){
					stageBuild.cargoDarkFG.alpha += 0.015;
					FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 1, CoolUtil.boundTo(elapsed * 3, 0, 1));
				}
			case 'finalem':
				if (Conductor.songPosition >= 0 && Conductor.songPosition < 9600){
					stageBuild.finaleDarkFG.alpha = FlxMath.lerp(stageBuild.finaleDarkFG.alpha, 0, CoolUtil.boundTo(elapsed * 0.5, 0, 1));
					FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 1, CoolUtil.boundTo(elapsed * 0.01, 0, 1));
				}
			case 'monotone':
				stageBuild.speedLines.y = FlxMath.lerp(stageBuild.speedLines.y, stageBuild.speedLines.y - 1350, CoolUtil.boundTo(elapsed * 9, 0, 1));
			case 'turbulence':
				for (hud in allUIs)
				hud.y = Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 1.0) * 15;
				for (hud in allUIs)
				hud.angle = Math.sin((Conductor.songPosition / 1200) * (Conductor.bpm / 60) * -1.0) * 1.2;
				if (airSpeedlines.members.length > 0)
				{
					for (i in 0...airSpeedlines.members.length)
					{
						airSpeedlines.members[i].x = FlxMath.lerp(airSpeedlines.members[i].x, airSpeedlines.members[i].x + 350 * stageBuild.turbSpeed,
							CoolUtil.boundTo(elapsed * 9, 0, 1));

						if (airSpeedlines.members[i].x > 5140.05)
						{
							airSpeedlines.members[i].x = -3352.1;
						}
					}
				}

				if (turbFrontCloud.members.length > 0)
				{
					for (i in 0...turbFrontCloud.members.length)
					{
						turbFrontCloud.members[i].x = FlxMath.lerp(turbFrontCloud.members[i].x, turbFrontCloud.members[i].x + 400 * stageBuild.turbSpeed,
							CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (turbFrontCloud.members[i].x > 5140.05)
						{
							turbFrontCloud.members[i].x = -4352.1;
						}
					}
				}
		}

		if (curStage == "ejected")
		{
		camGame.shake(0.002, 0.1);

			if (!tweeningChar)
			{
				tweeningChar = true;
				FlxTween.tween(boyfriend,
					{x: FlxG.random.float(bfStartpos.x - 15, bfStartpos.x + 15), y: FlxG.random.float(bfStartpos.y - 15, bfStartpos.y + 15)}, 0.4, {
						ease: FlxEase.smoothStepInOut,
						onComplete: function(twn:FlxTween)
						{
							tweeningChar = false;
						}
					});
				FlxTween.tween(gf, {
					x: FlxG.random.float(gfStartpos.x - 10, gfStartpos.x + 10),
					y: FlxG.random.float(gfStartpos.y - 10, gfStartpos.y + 10)
				}, 0.4, {
					ease: FlxEase.smoothStepInOut
				});
				FlxTween.tween(dadOpponent,
					{x: FlxG.random.float(dadStartpos.x - 15, dadStartpos.x + 15), y: FlxG.random.float(dadStartpos.y - 15, dadStartpos.y + 15)}, 0.4, {
						ease: FlxEase.smoothStepInOut
					});
			}
		}

		if (curStage == "airshipRoom")
		{
		if (isStoryMode && SONG.song.toLowerCase() != 'oversight')
		{
		if (FlxG.mouse.overlaps(stageBuild.henryTeleporter))
		{
		if(FlxG.mouse.pressed)
		{
		stageBuild.henryTeleporter.visible = false;
		henryTeleport();
		}
		}
		}
		}

		var legPosY = [13, 7, -3, -1, -1, 2, 7, 9, 7, 2, 0, 0, 3, 1, 3, 7, 13];
		var legPosX = [3, 4, 4, 5, 5, 4, 3, 2, 0, 0, -3, -4, -4, -5, -5, -4, -3];

		if (boyfriend.curCharacter == 'bf-running')
		{
			if (boyfriend.animation.curAnim.name.startsWith("sing"))
			{
				bfLegs.alpha = 1;
				boyfriend.y = bfAnchorPoint[1] + legPosY[bfLegs.animation.curAnim.curFrame];
			}
			else
				bfLegs.alpha = 1;
		}

		if (boyfriend.curCharacter == 'bf-running')
			{
				if (boyfriend.animation.curAnim.name.endsWith("miss"))
				{
					bfLegsmiss.alpha = 1;
					boyfriend.y = bfAnchorPoint[1] + legPosY[bfLegsmiss.animation.curAnim.curFrame];
				}
				else
					bfLegsmiss.alpha = 0;
			}

			if (boyfriend.curCharacter == 'bf-running')
				{
					if (boyfriend.animation.curAnim.name.endsWith("miss"))
					{
						bfLegs.alpha = 0;
						boyfriend.y = bfAnchorPoint[1] + legPosY[bfLegs.animation.curAnim.curFrame];
					}
					else
						bfLegs.alpha = 1;
				}

		if (dadOpponent.curCharacter == 'black-run')
		{
			dadOpponent.y = dadAnchorPoint[1] + legPosY[dadlegs.animation.curAnim.curFrame];
		}

		if(uiHUD.finaleBarRed != null){
			var redClip = new FlxRect(0, 0, 19 + (1160 - (health * 580)), uiHUD.finaleBarRed.frameHeight);
			var blueClip = new FlxRect(19 + (1160 - (health * 580)), 0, uiHUD.finaleBarBlue.frameWidth - (19 + (1160 - (health * 580))), uiHUD.finaleBarBlue.frameHeight);
			uiHUD.finaleBarRed.clipRect = redClip;
			uiHUD.finaleBarBlue.clipRect = blueClip;
		}

				if(turbEnding){
					dadOpponent.x = FlxMath.lerp(dadOpponent.x, dadOpponent.x + 650,
						CoolUtil.boundTo(elapsed * 9, 0, 1));
					dadOpponent.y = FlxMath.lerp(dadOpponent.y, dadOpponent.y + 200,
						CoolUtil.boundTo(elapsed * 9, 0, 1));
					dadOpponent.angle = FlxMath.lerp(dadOpponent.angle, dadOpponent.angle + 120,
						CoolUtil.boundTo(elapsed * 9, 0, 1));
				}

		if(charlesEnter)
		{
			dadOpponent.x = FlxMath.lerp(dadOpponent.x, -600, CoolUtil.boundTo(elapsed * 2.1, 0, 1));
		}

		if (curStage == 'nuzzus'){
			health = 1;
		}

		if (curStage == 'warehouse'){
			stageBuild.leftblades.x = (213.05 + bladeDistance) - (60 * health);
			stageBuild.rightblades.x = (827.75 - bladeDistance) + (60 * health);
		}

		if (curStage == "tripletrouble")
		{
			stageBuild.wiggleEffect.update(elapsed);
		}

		if (KillNotes)
		{
		unspawnNotes = [];
		vocals.volume = 0;
		vocals.pause();
		}

		if (health > 2)
			health = 2;

		// dialogue checks
		if (dialogueBox != null && dialogueBox.alive) {
			// wheee the shift closes the dialogue
			if (FlxG.keys.justPressed.SHIFT)
				dialogueBox.closeDialog();

			// the change I made was just so that it would only take accept inputs
			if (controls.ACCEPT && dialogueBox.textStarted)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				dialogueBox.curPage += 1;

				if (dialogueBox.curPage == dialogueBox.dialogueData.dialogue.length)
					dialogueBox.closeDialog()
				else
					dialogueBox.updateDialog();
			}

		}

		if (!inCutscene) {
			// pause the game if the game is allowed to pause and enter is pressed
			if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
			{
				// update drawing stuffs
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;

				// open pause substate
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				updateRPC(true);
			}

			// make sure you're not cheating lol
			if (!isStoryMode)
			{
				// charting state (more on that later)
				if ((FlxG.keys.justPressed.SEVEN) && (!startingSong))
				{
					resetMusic();
					if (Init.trueSettings.get('Use Forever Chart Editor'))
						Main.switchState(this, new ChartingState());
					else
						Main.switchState(this, new OriginalChartingState());
				}

				if ((FlxG.keys.justPressed.SIX))
					boyfriendStrums.autoplay = !boyfriendStrums.autoplay;

		if ((FlxG.keys.justPressed.EIGHT) && (!startingSong))
		{
			/* 	 8 for opponent char
			   SHIFT+8 for player char
				 CTRL+SHIFT+8 for gf
			   ALT+8 for player char   */
			if (FlxG.keys.pressed.ALT)
					FlxG.switchState(new AnimationDebug(mom.curCharacter));
				else
			if (FlxG.keys.pressed.SHIFT)
				if (FlxG.keys.pressed.CONTROL)
					FlxG.switchState(new AnimationDebug(gf.curCharacter));
				else
					FlxG.switchState(new AnimationDebug(PlayState.SONG.player1));
			else
				FlxG.switchState(new AnimationDebug(PlayState.SONG.player2));
		}
			}

			///*
			if (startingSong)
			{
				if (startedCountdown)
				{
					Conductor.songPosition += elapsed * 1000;
					if (Conductor.songPosition >= 0)
						startSong();
				}
			}
			else
			{
				// Conductor.songPosition = FlxG.sound.music.time;
				Conductor.songPosition += elapsed * 1000;

				if (!paused)
				{
					songTime += FlxG.game.ticks - previousFrameTime;
					previousFrameTime = FlxG.game.ticks;

					// Interpolation type beat
					if (Conductor.lastSongPos != Conductor.songPosition)
					{
						songTime = (songTime + Conductor.songPosition) / 2;
						Conductor.lastSongPos = Conductor.songPosition;
						// Conductor.songPosition += FlxG.elapsed * 1000;
						// trace('MISSED FRAME');
					}
				}

				// Conductor.lastSongPos = FlxG.sound.music.time;
				// song shit for testing lols
			}

			// boyfriend.playAnim('singLEFT', true);
			// */

			if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !isCameraOnForcedPos)
			{
				var curSection = Std.int(curStep / 16);
				if (curSection != lastSection) {
					// section reset stuff
					var lastMustHit:Bool = PlayState.SONG.notes[lastSection].mustHitSection;
					if (PlayState.SONG.notes[curSection].mustHitSection != lastMustHit) {
						camDisplaceX = 0;
						camDisplaceY = 0;
					}
					lastSection = Std.int(curStep / 16);
				}

				if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection)
				{
					var char = dadOpponent;

					var getCenterX = char.getMidpoint().x + 0;
					var getCenterY = char.getMidpoint().y - 0;

					switch (curStage)
					{
						case 'stage':
						repositionDadCameraOffset = true;
						case 'spooky':
						repositionDadCameraOffset = true;
						case 'philly':
						repositionDadCameraOffset = true;
						case 'highway':
						repositionDadCameraOffset = true;
						case 'mall':
						repositionDadCameraOffset = true;
						case 'mallEvil':
						repositionDadCameraOffset = true;
						case 'schoolEvil':
						repositionDadCameraOffset = true;
						case 'polus':
							getCenterX = 470;
							getCenterY = 250;
						case 'toogus':
							getCenterX = 500;
							getCenterY = 475;
						case 'reactor2':
							getCenterX = 1725;
							getCenterY = 1100;
							if (SONG.song.toLowerCase() == 'reactor')
							{
							if (curBeat >= 64 && curBeat <= 128)
							{
							getCenterX = 1450;
							getCenterY = 1150;
							}
							if (curBeat >= 128  && curBeat <= 192)
							{
							getCenterX = 1725;
							getCenterY = 1100;
							}
							if (curBeat >= 192 && curBeat <= 224)
							{
							getCenterX = 1450;
							getCenterY = 1150;
							}
							if (curBeat >= 224 && curBeat <= 256)
							{
							getCenterX = 1725;
							getCenterY = 1100;
							}
							if (curBeat >= 256 && curBeat <= 320)
							{
							getCenterX = 1450;
							getCenterY = 1150;
							}
							if (curBeat >= 320 && curBeat <= 384)
							{
							getCenterX = 1725;
							getCenterY = 1100;
							}
							if (curBeat >= 384 && curBeat <= 479)
							{
							getCenterX = 1450;
							getCenterY = 1150;
							}
							if (curBeat >= 479 && curBeat <= 544)
							{
							getCenterX = 1725;
							getCenterY = 1200;
							}
							if (curBeat >= 544 && curBeat <= 608)
							{
							getCenterX = 1725;
							getCenterY = 1100;
							}
							if (curBeat >= 608 && curBeat <= 672)
							{
							getCenterX = 1725;
							getCenterY = 1200;
							}
							if (curBeat >= 672)
							{
							getCenterX = 1725;
							getCenterY = 1100;
							}
							}
						case 'ejected':
							getCenterX = 275;
							getCenterY = 550;
						case 'airshipRoom':
							getCenterX = 300;
							getCenterY = 500;
						case 'airship':
							getCenterX = 700;
							getCenterY = -2000;
							if (SONG.song.toLowerCase() == 'danger')
							{
							if (curStep >= 1 && curBeat <= 64)
							{
							getCenterX = 1634.05;
							getCenterY = -54.3;
							}
							if (curBeat >= 64 && curBeat <= 96)
							{
							getCenterX = 800;
							getCenterY = 150;
							}
							if (curBeat >= 96 && curBeat <= 128)
							{
							getCenterX = 700;
							getCenterY = 150;
							}
							if (curBeat >= 128 && curBeat <= 155)
							{
							getCenterX = 800;
							getCenterY = 150;
							}
							if (curBeat >= 155 && curBeat <= 160)
							{
							getCenterX = 450;
							getCenterY = 150;
							}
							if (curBeat >= 160 && curBeat <= 192)
							{
							getCenterX = 800;
							getCenterY = 150;
							}
							if (curBeat >= 192 && curBeat <= 256)
							{
							getCenterX = 700;
							getCenterY = 150;
							}
							if (curBeat >= 256  && curBeat <= 288)
							{
							getCenterX = 800;
							getCenterY = 150;
							}
							if (curBeat >= 288 && curBeat <= 320)
							{
							getCenterX = 700;
							getCenterY = 150;
							}
							if (curBeat >= 320 && curBeat <= 384)
							{
							getCenterX = 1634.05;
							getCenterY = -54.3;
							}
							if (curBeat >= 384)
							{
							getCenterX = 700;
							getCenterY = 150;
							}
							}
						case 'cargo':
							getCenterX = 2000;
							getCenterY = 1050;
							if (SONG.song.toLowerCase() == 'double-kill')
							{
							if (curBeat >= 552  && curBeat <= 556)
							{
							getCenterX = 1650;
							getCenterY = 1180;
							}
							if (curBeat >= 556)
							{
							getCenterX = 2000;
							getCenterY = 1050;
							}
							}
						case 'defeat':
							getCenterX = 750;
							getCenterY = 500;
							if (SONG.song.toLowerCase() == 'defeat')
							{
							if (curBeat >= 16 && curBeat <= 32)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 32 && curBeat <= 48)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 48 && curBeat <= 68)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 68 && curBeat <= 100)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 100 && curBeat <= 164)
							{
							getCenterX = 500;
							getCenterY = 500;
							}
							if (curBeat >= 164 && curBeat <= 194)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 194 && curBeat <= 196)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 196  && curBeat <= 212)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 212 && curBeat <= 228)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 228 && curBeat <= 244)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 244 && curBeat <= 260)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 260 && curBeat <= 292)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 292 && curBeat <= 360)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 360 && curBeat <= 424)
							{
							getCenterX = 500;
							getCenterY = 500;
							}
							if (curBeat >= 424 && curBeat <= 456)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 456 && curBeat <= 472)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 488)
							{
							getCenterX = 700;
							getCenterY = 150;
							}
							}
						case 'finalem':
							getCenterX = 750;
							getCenterY = 800;
							if (SONG.song.toLowerCase() == 'finale')
							{
							if (curBeat >= 32 && curBeat <= 48)
							{
							getCenterX = 450;
							getCenterY = 1000;
							}
							if (curBeat >= 48 && curBeat <= 64)
							{
							getCenterX = 1250;
							getCenterY = 1000;
							}
							if (curBeat >= 64 && curBeat <= 68)
							{
							getCenterX = 1400;
							getCenterY = 1050;
							defaultCamZoom = 1.2;
							}
							if (curBeat >= 68)
							{
							getCenterX = 500;
							getCenterY = 600;
							defaultCamZoom = 0.4;
							}
							}
						case 'monotone':
							getCenterX = 950;
							getCenterY = 700;
							if (SONG.song.toLowerCase() == 'identity-crisis')
							{
							if (curBeat >= 32 && curBeat <= 81)
							{
							getCenterX = 950;
							getCenterY = 700;
							}
							if (curBeat >= 81 && curBeat <= 88)
							{
							getCenterX = 850;
							getCenterY = 750;
							}
							if (curBeat >= 88 && curBeat <= 95)
							{
							getCenterX = 700;
							getCenterY = 800;
							}
							if (curBeat >= 95 && curBeat <= 112)
							{
							getCenterX = 850;
							getCenterY = 750;
							}
							if (curBeat >= 112 && curBeat <= 128)
							{
							getCenterX = 950;
							getCenterY = 700;
							}
							if (curBeat >= 128 && curBeat <= 192)
							{
							getCenterX = 850;
							getCenterY = 750;
							}
							if (curBeat >= 192 && curBeat <= 208)
							{
							getCenterX = 950;
							getCenterY = 700;
							}
							if (curBeat >= 208 && curBeat <= 224)
							{
							getCenterX = 850;
							getCenterY = 750;
							}
							if (curBeat >= 224 && curBeat <= 254)
							{
							getCenterX = 950;
							getCenterY = 700;
							}
							if (curBeat >= 254 && curBeat <= 262)
							{
							getCenterX = 1300;
							getCenterY = 800;
							}
							if (curBeat >= 262 && curBeat <= 270)
							{
							getCenterX = 1400;
							getCenterY = 800;
							}
							if (curBeat >= 270 && curBeat <= 278)
							{
							getCenterX = 1450;
							getCenterY = 800;
							}
							if (curBeat >= 278 && curBeat <= 294)
							{
							getCenterX = 1500;
							getCenterY = 800;
							}
							if (curBeat >= 294 && curBeat <= 312)
							{
							getCenterX = 850;
							getCenterY = 700;
							}
							if (curBeat >= 312 && curBeat <= 328)
							{
							getCenterX = 850;
							getCenterY = 750;
							}
							if (curBeat >= 328 && curBeat <= 334)
							{
							getCenterX = 650;
							getCenterY = 750;
							}
							if (curBeat >= 334 && curBeat <= 344)
							{
							getCenterX = 650;
							getCenterY = 750;
							}
							if (curBeat >= 344 && curBeat <= 360)
							{
							getCenterX = 1400;
							getCenterY = 800;
							}
							if (curBeat >= 360 && curBeat <= 456)
							{
							getCenterX = 950;
							getCenterY = 700;
							}
							if (curBeat >= 456)
							{
							getCenterX = 850;
							getCenterY = 750;
							}
							}
						case 'polus2':
							getCenterX = 1600;
							getCenterY = 1300;
						case 'polus3':
							defaultCamZoom = 0.6;
							getCenterX = 1760;
							getCenterY = 380;
						case 'grey':
							getCenterX = 1300;
							getCenterY = 700;
						case 'plantroom':
							getCenterX = 100;
							getCenterY = 200;
						case 'pretender':
							getCenterX = 100;
							getCenterY = 200;
						case 'chef':
							getCenterX = 1200;
							getCenterY = 800;
							if (SONG.song.toLowerCase() == 'sauces-moogus')
							{
							if (curBeat >= 112 && curBeat <= 113)
							{
							getCenterX = 1180;
							getCenterY = 820;
							}
							if (curBeat >= 113 && curBeat <= 114)
							{
							getCenterX = 1160;
							getCenterY = 840;
							}
							if (curBeat >= 114 && curBeat <= 115)
							{
							getCenterX = 1140;
							getCenterY = 860;
							}
							if (curBeat >= 115 && curBeat <= 116)
							{
							getCenterX = 1120;
							getCenterY = 880;
							}
							if (curBeat >= 116 && curBeat <= 304)
							{
							getCenterX = 1200;
							getCenterY = 800;
							}
							if (curBeat >= 304 && curBeat <= 305)
							{
							getCenterX = 1180;
							getCenterY = 820;
							}
							if (curBeat >= 305 && curBeat <= 306)
							{
							getCenterX = 1160;
							getCenterY = 840;
							}
							if (curBeat >= 306 && curBeat <= 307)
							{
							getCenterX = 1140;
							getCenterY = 860;
							}
							if (curBeat >= 307 && curBeat <= 308)
							{
							getCenterX = 1120;
							getCenterY = 880;
							}
							if (curBeat >= 308 && curBeat <= 320)
							{
							getCenterX = 1200;
							getCenterY = 800;
							}
							if (curBeat >= 320 && curBeat <= 321)
							{
							getCenterX = 1180;
							getCenterY = 820;
							}
							if (curBeat >= 321 && curBeat <= 322)
							{
							getCenterX = 1160;
							getCenterY = 840;
							}
							if (curBeat >= 322 && curBeat <= 323)
							{
							getCenterX = 1140;
							getCenterY = 860;
							}
							if (curBeat >= 323 && curBeat <= 324)
							{
							getCenterX = 1120;
							getCenterY = 880;
							}
							}
						case 'lounge':
							getCenterX = 700;
							getCenterY = 700;
							if (SONG.song.toLowerCase() == 'o2')
							{
							if (curBeat >= 120)
							{
							getCenterX = 840;
							getCenterY = 700;
							}
							}
						case 'voting':
						repositionDadCameraOffset = true;
		if (SONG.song.toLowerCase() == 'voting-time')
		{
		if (curStep >= 16 && curStep <= 50)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 50 && curStep <= 80)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 80 && curStep <= 112)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 112 && curStep <= 120)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 120 && curStep <= 128)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 128 && curStep <= 136)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 136 && curStep <= 138)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 138 && curStep <= 140)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 140 && curStep <= 144)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 144 && curStep <= 208)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 208 && curStep <= 240)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 240 && curStep <= 248)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 248 && curStep <= 256)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 256 && curStep <= 272)
		{
		repositionDadCameraOffset = false;
							getCenterX = 960;
							getCenterY = 540;
		}
		if (curStep >= 272 && curStep <= 288)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 288 && curStep <= 304)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 304 && curStep <= 320)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 320 && curStep <= 336)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 336 && curStep <= 352)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 352 && curStep <= 360)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 360 && curStep <= 368)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 368 && curStep <= 384)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 384 && curStep <= 392)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 392 && curStep <= 400)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 400 && curStep <= 431)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 431 && curStep <= 463)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 463 && curStep <= 479)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 479 && curStep <= 495)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 495 && curStep <= 500)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 500 && curStep <= 504)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 504 && curStep <= 508)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 508 && curStep <= 511)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 511 && curStep <= 527)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 527 && curStep <= 561)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 561 && curStep <= 577)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 577 && curStep <= 590)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 590 && curStep <= 626)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 626 && curStep <= 642)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 642 && curStep <= 653)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 653 && curStep <= 720)
		{
		repositionDadCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 720 && curStep <= 752)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 752 && curStep <= 780)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 780 && curStep <= 832)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 832 && curStep <= 899)
		{
		repositionDadCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 899 && curStep <= 902)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 902 && curStep <= 905)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 905 && curStep <= 908)
		{
		repositionDadCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 908 && curStep <= 912)
		{
		repositionDadCameraOffset = false;
							getCenterX = 960;
							getCenterY = 540;
		}
		if (curStep >= 912 && curStep <= 976)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 976 && curStep <= 1044)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 1044 && curStep <= 1060)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1060 && curStep <= 1076)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1076 && curStep <= 1092)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1092 && curStep <= 1140)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1140 && curStep <= 1160)
		{
		repositionDadCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 1160 && curStep <= 1162)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1162 && curStep <= 1164)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 1164 && curStep <= 1166)
		{
		repositionDadCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 1166 && curStep <= 1168)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1168 && curStep <= 1176)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1176 && curStep <= 1184)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 1184 && curStep <= 1200)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1200 && curStep <= 1208)
		{
		repositionDadCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 1208 && curStep <= 1216)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1216 && curStep <= 1224)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1224 && curStep <= 1232)
		{
		repositionDadCameraOffset = false;
							getCenterX = 960;
							getCenterY = 540;
		}
		if (curStep >= 1232 && curStep <= 1240)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1240 && curStep <= 1248)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 1248 && curStep <= 1264)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1264 && curStep <= 1272)
		{
		repositionDadCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 1272 && curStep <= 1280)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1280 && curStep <= 1288)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1288 && curStep <= 1296)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 1296 && curStep <= 1300)
		{
		repositionDadCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1300 && curStep <= 1304)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1304 && curStep <= 1308)
		{
		repositionDadCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 1308 && curStep <= 1312)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1312)
		{
		repositionDadCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		}
						case 'turbulence':
							getCenterX = 1200;
							getCenterY = 500;
						case 'victory':
							getCenterX = 1000;
							getCenterY = 550;
						case 'powstage':
							getCenterX = 500;
							getCenterY = 600;
						case 'henry':
							getCenterX = 700;
							getCenterY = 550;
						case 'charles':
							getCenterX = 700;
							getCenterY = 500;
							if (SONG.song.toLowerCase() == 'greatest-plan')
							{
							if (curStep >= 32)
							{
							getCenterX = 130;
							getCenterY = 450;
							}
							}
						case 'school':
							getCenterX = 500;
							getCenterY = 475;
						case 'tomtus':
							getCenterX = 850;
							getCenterY = 650;
							if (SONG.song.toLowerCase() == 'tomongus-tuesday')
							{
							if (curStep >= 983)
							{
							getCenterX = 1000;
							getCenterY = 650;
							defaultCamZoom = 0.9;
							}
							}
						case 'loggo':
							getCenterX = 420.95;
							getCenterY = 1700;
						case 'loggo2':
							getCenterX = 420.95;
							getCenterY = 1700;
						case 'alpha':
						repositionDadCameraOffset = true;
						case 'kills':
							getCenterX = 500;
							getCenterY = 600;
						case 'who':
							getCenterX = 1100;
							getCenterY = 1150;
		if (SONG.song.toLowerCase() == 'who')
		{
		if (curStep >= 384 && curStep <= 397)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 397 && curStep <= 402)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 402 && curStep <= 412)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 412 && curStep <= 424)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 424 && curStep <= 448)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 448 && curStep <= 504)
		{
							getCenterX = 1100;
							getCenterY = 1150;
		}
		if (curStep >= 504 && curStep <= 512)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 512 && curStep <= 529)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 529 && curStep <= 560)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 560 && curStep <= 576)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 576 && curStep <= 612)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 612 && curStep <= 630)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 630 && curStep <= 642)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 642 && curStep <= 662)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 662 && curStep <= 688)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 688 && curStep <= 697)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 697 && curStep <= 708)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 708 && curStep <= 712)
		{
							getCenterX = 1100;
							getCenterY = 1150;
		}
		if (curStep >= 712 && curStep <= 728)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 728 && curStep <= 768)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 768 && curStep <= 784)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 784 && curStep <= 791)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 791 && curStep <= 800)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 800 && curStep <= 818)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 818 && curStep <= 824)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 824 && curStep <= 830)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 830 && curStep <= 844)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 844 && curStep <= 852)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 852 && curStep <= 864)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 864 && curStep <= 880)
		{
							getCenterX = 1100;
							getCenterY = 1150;
		}
		if (curStep >= 880 && curStep <= 896)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 896 && curStep <= 904)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 904 && curStep <= 912)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 912 && curStep <= 928)
		{
							getCenterX = 1100;
							getCenterY = 1150;
		}
		if (curStep >= 928 && curStep <= 942)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 942 && curStep <= 960)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 960 && curStep <= 976)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 976 && curStep <= 986)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 986 && curStep <= 992)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 992 && curStep <= 1025)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 1025 && curStep <= 1040)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 1040 && curStep <= 1056)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 1056 && curStep <= 1088)
		{
							getCenterX = 1100;
							getCenterY = 1150;
		}
		if (curStep >= 1088 && curStep <= 1120)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 1120 && curStep <= 1168)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 1168)
		{
							getCenterX = 1100;
							getCenterY = 1150;
		}
		}
						case 'jerma':
							defaultCamZoom = 0.9;
							getCenterX = 900;
							getCenterY = 450;
						case 'nuzzus':
							getCenterX = 125;
							getCenterY = 250;
						case 'idk':
							getCenterX = 420;
							getCenterY = 300;
						case 'esculent':
							getCenterX = 1200;
							getCenterY = 700;
						case 'drippypop':
							getCenterX = 1200;
							getCenterY = 600;
							if (SONG.song.toLowerCase() == 'drippypop')
							{
							if (curBeat >= 286 && curBeat <= 304)
							{
							getCenterX = 1300;
							getCenterY = 350;
							}
							if (curBeat >= 304 && curBeat <= 318)
							{
							getCenterX = 1200;
							getCenterY = 600;
							}
							if (curBeat >= 318 && curBeat <= 336)
							{
							getCenterX = 1300;
							getCenterY = 350;
							}
							if (curBeat >= 336 && curBeat <= 384)
							{
							getCenterX = 1200;
							getCenterY = 600;
							}
							if (curBeat >= 384 && curBeat <= 401)
							{
							getCenterX = 1300;
							getCenterY = 350;
							}
							if (curBeat >= 401)
							{
							getCenterX = 1200;
							getCenterY = 600;
							}
							}
						case 'dave':
							getCenterX = 820;
							getCenterY = 700;
						case 'attack':
							getCenterX = 1000;
							getCenterY = 1050;
							if (SONG.song.toLowerCase() == 'monotone-attack')
							{
							if (curBeat >= 64 && curBeat <= 80)
							{
							getCenterX = 1225;
							getCenterY = 1000;
							}
							if (curBeat >= 80 && curBeat <= 95)
							{
							getCenterX = 1225;
							getCenterY = 1000;
							}
							if (curBeat >= 95 && curBeat <= 99)
							{
							getCenterX = 1000;
							getCenterY = 900;
							}
							if (curBeat >= 99 && curBeat <= 196)
							{
							getCenterX = 1000;
							getCenterY = 1050;
							}
							if (curBeat >= 196 && curBeat <= 229)
							{
							getCenterX = 1225;
							getCenterY = 1000;
							}
							if (curBeat >= 229 && curBeat <= 276)
							{
							getCenterX = 1225;
							getCenterY = 1000;
							}
							if (curBeat >= 276 && curBeat <= 292)
							{
							getCenterX = 1225;
							getCenterY = 1000;
							}
							if (curBeat >= 292 && curBeat <= 324)
							{
							getCenterX = 1000;
							getCenterY = 1050;
							}
							if (curBeat >= 324 && curBeat <= 355)
							{
							getCenterX = 1225;
							getCenterY = 1000;
							}
							if (curBeat >= 355 && curBeat <= 360)
							{
							getCenterX = 1000;
							getCenterY = 900;
							}
							if (curBeat >= 360)
							{
							getCenterX = 1225;
							getCenterY = 1000;
							}
							}
						case 'piptowers':
							getCenterX = 600;
							getCenterY = 450;
							if (SONG.song.toLowerCase() == 'chippin')
							{
							if (curStep >= 448)
							{
							getCenterX = 750;
							getCenterY = 300;
							}
							}
							if (SONG.song.toLowerCase() == 'chipping')
							{
							if (curStep >= 448)
							{
							getCenterX = 750;
							getCenterY = 300;
							}
							}
						case 'warehouse':
							defaultCamZoom = 0.9;
							getCenterX = 640;
							getCenterY = 350;
						case 'banana':
						repositionDadCameraOffset = true;
						case 'finale':
							defaultCamZoom = 0.4;
							getCenterX = 500;
							getCenterY = 600;
						case 'monochrome':
						repositionDadCameraOffset = true;
						case 'pink':
						repositionDadCameraOffset = true;
						case 'skinny':
						repositionDadCameraOffset = true;
						case 'tripletrouble':
							getCenterX = 1270;
							getCenterY = 850;
						case 'youtuber':
							getCenterX = 640;
							getCenterY = 360;
					}

					if (repositionDadCameraOffset)
					{
				getCenterX = char.getMidpoint().x + 150;
				getCenterY = char.getMidpoint().y - 100;
		switch (PlayState.SONG.player2)
		{
			case 'dad':
				getCenterX += 0;
				getCenterY += 0;
			case 'spooky':
				getCenterX += 0;
				getCenterY += 0;
			case 'pico':
				getCenterX += 0;
				getCenterY += 0;
			case 'picolobby':
				getCenterX += 50;
				getCenterY += 70;
			case 'mom':
				getCenterX += 0;
				getCenterY += 0;
			case 'mom-car':
				getCenterX += 0;
				getCenterY += 0;
			case 'parents-christmas':
				getCenterX += 0;
				getCenterY += 0;
			case 'monster-christmas':
				getCenterX += 0;
				getCenterY += 0;
			case 'monster':
				getCenterX += 0;
				getCenterY += 0;
			case 'senpai':
				getCenterX += -240;
				getCenterY += -330;
			case 'senpai-angry':
				getCenterX += -240;
				getCenterY += -330;
			case 'spirit':
				getCenterX += 0;
				getCenterY += 0;
			case 'impostor':
				getCenterX += -130;
				getCenterY += 290;
			case 'sabotage':
				getCenterX += -130;
				getCenterY += 290;
			case 'impostor2':
				getCenterX += -130;
				getCenterY += 290;
			case 'crewmate':
				getCenterX += 30;
				getCenterY += 230;
			case 'impostor3':
				getCenterX += -100;
				getCenterY += 290;
			case 'whitegreen':
				getCenterX += -130;
				getCenterY += 290;
			case 'impostorr':
				getCenterX += -130;
				getCenterY += 290;
			case 'parasite':
				getCenterX += -200;
				getCenterY += -160;
			case 'yellow':
				getCenterX += 0;
				getCenterY += 200;
			case 'reaction':
				getCenterX += 0;
				getCenterY += 200;
			case 'white':
				getCenterX += 30;
				getCenterY += 230;
			case 'black-run':
				getCenterX += -880;
				getCenterY += -100;
			case 'blacklegs':
				getCenterX += -880;
				getCenterY += -100;
			case 'blackalt':
				getCenterX += -880;
				getCenterY += -100;
			case 'whitedk':
				getCenterX += -460;
				getCenterY += 60;
			case 'blackdk':
				getCenterX += -70;
				getCenterY += 110;
			case 'black':
				getCenterX += -880;
				getCenterY += -100;
			case 'blackKill':
				getCenterX += -880;
				getCenterY += -100;
			case 'blackold':
				getCenterX += -253;
				getCenterY += 140;
			case 'blackparasite':
				getCenterX += -253;
				getCenterY += 140;
			case 'bfscary':
				getCenterX += -30;
				getCenterY += 200;
			case 'monotone':
				getCenterX += -20;
				getCenterY += 190;
			case 'maroon':
				getCenterX += -130;
				getCenterY += 260;
			case 'maroonp':
				getCenterX += -130;
				getCenterY += 260;
			case 'grey':
				getCenterX += 500;
				getCenterY += 0;
			case 'pink':
				getCenterX += -70;
				getCenterY += 110;
			case 'pretender':
				getCenterX += -190;
				getCenterY += 200;
			case 'chefogus':
				getCenterX += -30;
				getCenterY += 200;
			case 'jorsawsee':
				getCenterX += -130;
				getCenterY += 290;
			case 'meangus':
				getCenterX += -70;
				getCenterY += -70;
			case 'warchief':
				getCenterX += 110;
				getCenterY += 140;
			case 'jelqer':
				getCenterX += 10;
				getCenterY += 230;
			case 'mungus':
				getCenterX += 200;
				getCenterY += -200;
			case 'madgus':
				getCenterX += 200;
				getCenterY += -200;
			case 'redmungusp':
				getCenterX += -120;
				getCenterY += 300;
			case 'jorsawghost':
				getCenterX += -130;
				getCenterY += 300;
			case 'powers':
				getCenterX += -60;
				getCenterY += 140;
			case 'henry':
				getCenterX += -60;
				getCenterY += 110;
			case 'charles':
				getCenterX += 60;
				getCenterY += 60;
			case 'henryphone':
				getCenterX += 0;
				getCenterY += 0;
			case 'ellie':
				getCenterX += -260;
				getCenterY += 110;
			case 'rhm':
				getCenterX += 0;
				getCenterY += -20;
			case 'reginald':
				getCenterX += -60;
				getCenterY += 110;
			case 'tomongus':
				getCenterX += -70;
				getCenterY += -220;
			case 'hamster':
				getCenterX += -240;
				getCenterY += -340;
			case 'tuesday':
				getCenterX += -130;
				getCenterY += 290;
			case 'fella':
				getCenterX += -270;
				getCenterY += -200;
			case 'boo':
				getCenterX += -260;
				getCenterY += -200;
			case 'oldpostor':
				getCenterX += -130;
				getCenterY += 0;
			case 'red':
				getCenterX += -80;
				getCenterY += 390;
			case 'blue':
				getCenterX += 80;
				getCenterY += 400;
			case 'bluehit':
				getCenterX += 80;
				getCenterY += 200;
			case 'bluewhonormal':
				getCenterX += -130;
				getCenterY += 290;
			case 'bluewho':
				getCenterX += -130;
				getCenterY += 290;
			case 'whitewho':
				getCenterX += -130;
				getCenterY += 290;
			case 'whitemad':
				getCenterX += -130;
				getCenterY += 290;
			case 'jerma':
				getCenterX += -60;
				getCenterY += 110;
			case 'nuzzus':
				getCenterX += -60;
				getCenterY += 110;
			case 'idk':
				getCenterX += -80;
				getCenterY += 390;
			case 'esculent':
				getCenterX += -130;
				getCenterY += 290;
			case 'drippypop':
				getCenterX += -60;
				getCenterY += 100;
			case 'dave':
				getCenterX += -300;
				getCenterY += 160;
			case 'attack':
				getCenterX += -20;
				getCenterY += 190;
			case 'clowfoe':
				getCenterX += -20;
				getCenterY += 190;
			case 'fabs':
				getCenterX += 1000;
				getCenterY += 110;
			case 'biddle':
				getCenterX += -20;
				getCenterY += 190;
			case 'top':
				getCenterX += -130;
				getCenterY += 290;
			case 'cval':
				getCenterX += 0;
				getCenterY += 0;
			case 'pip':
				getCenterX += 0;
				getCenterY += 0;
			case 'pip_evil':
				getCenterX += 0;
				getCenterY += 0;
			case 'cvaltorture':
				getCenterX += -610;
				getCenterY += 90;
			case 'piptorture':
				getCenterX += -610;
				getCenterY += 90;
			case 'ziffytorture':
				getCenterX += -145;
				getCenterY += 70;
			case 'alien':
				getCenterX += 0;
				getCenterY += 0;
			case 'blackPlaceholder':
				getCenterX += -430;
				getCenterY += -190;
			case 'blackpostor':
				getCenterX += 110;
				getCenterY += 200;
			case 'crewmate-dance':
				getCenterX += 30;
				getCenterY += 230;
			case 'dead':
				getCenterX += -70;
				getCenterY += -30;
			case 'dt':
				getCenterX += -910;
				getCenterY += -410;
			case 'fuckgus':
				getCenterX += -270;
				getCenterY += 10;
			case 'ghost':
				getCenterX += -80;
				getCenterY += 80;
			case 'henryplayer':
				getCenterX += 20;
				getCenterY += 50;
			case 'impostorv2':
				getCenterX += -130;
				getCenterY += 290;
			case 'jorsawdead':
				getCenterX += -130;
				getCenterY += 300;
			case 'kyubicrasher':
				getCenterX += -185;
				getCenterY += 190;
			case 'loggo':
				getCenterX += -400;
				getCenterY += -300;
			case 'pinkexe':
				getCenterX += -190;
				getCenterY += 200;
			case 'pinkplayable':
				getCenterX += -190;
				getCenterY += 200;
			case 'powers_sax':
				getCenterX += -130;
				getCenterY += 120;
			case 'ziffy':
				getCenterX += 0;
				getCenterY += 110;
			case 'bf':
				getCenterX += 100;
				getCenterY += -40;
			case 'bfg':
				getCenterX += 0;
				getCenterY += 0;
			case 'whitebf':
				getCenterX += 0;
				getCenterY += 0;
			case 'bfr':
				getCenterX += 0;
				getCenterY += 0;
			case 'bf-fall':
				getCenterX += 500;
				getCenterY += -100;
			case 'bfshock':
				getCenterX += 0;
				getCenterY += 0;
			case 'bf-running':
				getCenterX += 0;
				getCenterY += 0;
			case 'bf-legs':
				getCenterX += 0;
				getCenterY += 0;
			case 'bf-legsmiss':
				getCenterX += 0;
				getCenterY += 0;
			case 'bf-defeat-normal':
				getCenterX += 0;
				getCenterY += 0;
			case 'bf-defeat-scared':
				getCenterX += 0;
				getCenterY += 0;
			case 'bfpolus':
				getCenterX += 0;
				getCenterY += 0;
			case 'bf-lava':
				getCenterX += 0;
				getCenterY += 0;
			case 'bfairship':
				getCenterX += 0;
				getCenterY += 0;
			case 'bfmira':
				getCenterX += 0;
				getCenterY += 0;
			case 'bfsauce':
				getCenterX += 0;
				getCenterY += 0;
			case 'bf_turb':
				getCenterX += 0;
				getCenterY += 0;
			case 'bfsusreal':
				getCenterX += 300;
				getCenterY += -30;
			case 'susfriend':
				getCenterX += 0;
				getCenterY += 0;
			case 'dripbf':
				getCenterX += 0;
				getCenterY += 0;
			case 'redp':
				getCenterX += 70;
				getCenterY += -120;
			case 'greenp':
				getCenterX += 70;
				getCenterY += -120;
			case 'blackp':
				getCenterX += 70;
				getCenterY += -120;
			case 'amongbf':
				getCenterX += 70;
				getCenterY += -120;
			case 'stick-bf':
				getCenterX += 160;
				getCenterY += -40;
			case 'bf-geoff':
				getCenterX += 0;
				getCenterY += 0;
			case 'bf-opp':
				getCenterX += 0;
				getCenterY += 0;
			case 'bfghost':
				getCenterX += 100;
				getCenterY += -40;
			case 'bf-car':
				getCenterX += 0;
				getCenterY += 0;
			case 'bf-christmas':
				getCenterX += 200;
				getCenterY += -200;
			case 'bf-pixel':
				getCenterX += 180;
				getCenterY += -140;
			case 'bfsus-pixel':
				getCenterX += 180;
				getCenterY += -140;
			case 'idkbf':
				getCenterX += -80;
				getCenterY += 390;
			case 'bf-pixel-opponent':
				getCenterX += 50;
				getCenterY += -160;
			case 'bf-holding-gf':
				getCenterX += 0;
				getCenterY += 0;
			case 'gf':
				getCenterX += 0;
				getCenterY += 100;
			case 'gf-christmas':
				getCenterX += 0;
				getCenterY += 0;
			case 'gf-car':
				getCenterX += 0;
				getCenterY += 0;
			case 'invisigf':
				getCenterX += -880;
				getCenterY += -100;
			case 'ghostgf':
				getCenterX += 0;
				getCenterY += 0;
			case 'gfr':
				getCenterX += 300;
				getCenterY += 600;
			case 'gf-fall':
				getCenterX += 0;
				getCenterY += 0;
			case 'gfdanger':
				getCenterX += 0;
				getCenterY += 0;
			case 'gfpolus':
				getCenterX += 0;
				getCenterY += 0;
			case 'gfdead':
				getCenterX += 0;
				getCenterY += 0;
			case 'gfmira':
				getCenterX += 0;
				getCenterY += 0;
			case 'tuesdaygf':
				getCenterX += 0;
				getCenterY += 0;
			case 'oldgf':
				getCenterX += 0;
				getCenterY += 0;
			case 'drippico':
				getCenterX += 0;
				getCenterY += 0;
			case 'henrygf':
				getCenterX += 0;
				getCenterY += 0;
			case 'gf-farmer':
				getCenterX += 0;
				getCenterY += 0;
			case 'loggogf':
				getCenterX += 0;
				getCenterY += 0;
			case 'gf-pixel':
				getCenterX += -20;
				getCenterY += 80;
				default:
				getCenterX += 100;
				getCenterY += -40;
		}
					}

					camFollow.setPosition(getCenterX + camDisplaceX + char.characterData.camOffsetX,
						getCenterY + camDisplaceY + char.characterData.camOffsetY);

					if (char.curCharacter == 'mom')
						vocals.volume = 1;
				}
				else
				{
					var char = boyfriend;

					var getCenterX = char.getMidpoint().x - 0;
					var getCenterY = char.getMidpoint().y - 0;

					switch (curStage)
					{
						case 'stage':
						repositionBoyfriendCameraOffset = true;
						case 'spooky':
						repositionBoyfriendCameraOffset = true;
						case 'philly':
						repositionBoyfriendCameraOffset = true;
						case 'highway':
						repositionBoyfriendCameraOffset = true;
						case 'mall':
						repositionBoyfriendCameraOffset = true;
						case 'mallEvil':
						repositionBoyfriendCameraOffset = true;
						case 'schoolEvil':
						repositionBoyfriendCameraOffset = true;
						case 'polus':
							getCenterX = 820;
							getCenterY = 250;
						case 'toogus':
							getCenterX = 900;
							getCenterY = 475;
						case 'reactor2':
							getCenterX = 1725;
							getCenterY = 1100;
							if (SONG.song.toLowerCase() == 'reactor')
							{
							if (curBeat >= 64 && curBeat <= 128)
							{
							getCenterX = 1950;
							getCenterY = 1150;
							}
							if (curBeat >= 128  && curBeat <= 192)
							{
							getCenterX = 1725;
							getCenterY = 1100;
							}
							if (curBeat >= 192 && curBeat <= 224)
							{
							getCenterX = 1950;
							getCenterY = 1150;
							}
							if (curBeat >= 224 && curBeat <= 256)
							{
							getCenterX = 1725;
							getCenterY = 1100;
							}
							if (curBeat >= 256 && curBeat <= 320)
							{
							getCenterX = 1950;
							getCenterY = 1150;
							}
							if (curBeat >= 320 && curBeat <= 384)
							{
							getCenterX = 1725;
							getCenterY = 1100;
							}
							if (curBeat >= 384 && curBeat <= 479)
							{
							getCenterX = 1950;
							getCenterY = 1150;
							}
							if (curBeat >= 479 && curBeat <= 544)
							{
							getCenterX = 1725;
							getCenterY = 1200;
							}
							if (curBeat >= 544 && curBeat <= 608)
							{
							getCenterX = 1725;
							getCenterY = 1100;
							}
							if (curBeat >= 608 && curBeat <= 672)
							{
							getCenterX = 1725;
							getCenterY = 1200;
							}
							if (curBeat >= 672)
							{
							getCenterX = 1725;
							getCenterY = 1100;
							}
							}
						case 'ejected':
							getCenterX = 275;
							getCenterY = 550;
						case 'airshipRoom':
							getCenterX = 700;
							getCenterY = 500;
						case 'airship':
							getCenterX = 1634.05;
							getCenterY = -54.3;
							if (SONG.song.toLowerCase() == 'danger')
							{
							if (curStep >= 1 && curBeat <= 64)
							{
							getCenterX = 1634.05;
							getCenterY = -54.3;
							}
							if (curBeat >= 64 && curBeat <= 96)
							{
							getCenterX = 1200;
							getCenterY = 150;
							}
							if (curBeat >= 96 && curBeat <= 128)
							{
							getCenterX = 1200;
							getCenterY = 150;
							}
							if (curBeat >= 128 && curBeat <= 155)
							{
							getCenterX = 1200;
							getCenterY = 150;
							}
							if (curBeat >= 155 && curBeat <= 160)
							{
							getCenterX = 450;
							getCenterY = 150;
							}
							if (curBeat >= 160 && curBeat <= 192)
							{
							getCenterX = 1200;
							getCenterY = 150;
							}
							if (curBeat >= 192 && curBeat <= 256)
							{
							getCenterX = 1200;
							getCenterY = 150;
							}
							if (curBeat >= 256 && curBeat <= 288)
							{
							getCenterX = 1200;
							getCenterY = 150;
							}
							if (curBeat >= 288 && curBeat <= 320)
							{
							getCenterX = 1200;
							getCenterY = 150;
							}
							if (curBeat >= 320 && curBeat <= 384)
							{
							getCenterX = 1634.05;
							getCenterY = -54.3;
							}
							if (curBeat >= 384)
							{
							getCenterX = 1200;
							getCenterY = 150;
							}
							}
						case 'cargo':
							getCenterX = 2300;
							getCenterY = 1050;
							if (SONG.song.toLowerCase() == 'double-kill')
							{
							if (curBeat >= 356  && curBeat <= 420)
							{
							getCenterX = 2750;
							getCenterY = 1150;
							}
							if (curBeat >= 420  && curBeat <= 552)
							{
							getCenterX = 2300;
							getCenterY = 1050;
							}
							}
						case 'defeat':
							getCenterX = 750;
							getCenterY = 500;
							if (SONG.song.toLowerCase() == 'defeat')
							{
							if (curBeat >= 16 && curBeat <= 32)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 32 && curBeat <= 48)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 48 && curBeat <= 68)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 68 && curBeat <= 100)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 100 && curBeat <= 164)
							{
							getCenterX = 900;
							getCenterY = 500;
							}
							if (curBeat >= 164 && curBeat <= 194)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 194 && curBeat <= 196)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 196  && curBeat <= 212)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 212 && curBeat <= 228)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 228 && curBeat <= 244)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 244 && curBeat <= 260)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 260 && curBeat <= 292)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 292 && curBeat <= 360)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 360 && curBeat <= 424)
							{
							getCenterX = 900;
							getCenterY = 500;
							}
							if (curBeat >= 424 && curBeat <= 456)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 456 && curBeat <= 472)
							{
							getCenterX = 750;
							getCenterY = 500;
							}
							if (curBeat >= 488)
							{
							getCenterX = 700;
							getCenterY = 150;
							}
							}
						case 'finalem':
							getCenterX = 750;
							getCenterY = 800;
							if (SONG.song.toLowerCase() == 'finale')
							{
							if (curBeat >= 32 && curBeat <= 48)
							{
							getCenterX = 450;
							getCenterY = 1000;
							}
							if (curBeat >= 48 && curBeat <= 64)
							{
							getCenterX = 1250;
							getCenterY = 1000;
							}
							if (curBeat >= 64 && curBeat <= 68)
							{
							getCenterX = 1400;
							getCenterY = 1050;
							defaultCamZoom = 1.2;
							}
							if (curBeat >= 68)
							{
							getCenterX = 700;
							getCenterY = 700;
							defaultCamZoom = 0.5;
							}
							}
						case 'monotone':
							getCenterX = 950;
							getCenterY = 700;
							if (SONG.song.toLowerCase() == 'identity-crisis')
							{
							if (curBeat >= 32 && curBeat <= 81)
							{
							getCenterX = 950;
							getCenterY = 700;
							}
							if (curBeat >= 81 && curBeat <= 88)
							{
							getCenterX = 1050;
							getCenterY = 750;
							}
							if (curBeat >= 88 && curBeat <= 95)
							{
							getCenterX = 700;
							getCenterY = 800;
							}
							if (curBeat >= 95 && curBeat <= 112)
							{
							getCenterX = 1050;
							getCenterY = 750;
							}
							if (curBeat >= 112 && curBeat <= 128)
							{
							getCenterX = 950;
							getCenterY = 700;
							}
							if (curBeat >= 128 && curBeat <= 192)
							{
							getCenterX = 1050;
							getCenterY = 750;
							}
							if (curBeat >= 192 && curBeat <= 208)
							{
							getCenterX = 950;
							getCenterY = 700;
							}
							if (curBeat >= 208 && curBeat <= 224)
							{
							getCenterX = 1050;
							getCenterY = 750;
							}
							if (curBeat >= 224 && curBeat <= 254)
							{
							getCenterX = 950;
							getCenterY = 700;
							}
							if (curBeat >= 254 && curBeat <= 262)
							{
							getCenterX = 1300;
							getCenterY = 800;
							}
							if (curBeat >= 262 && curBeat <= 270)
							{
							getCenterX = 1400;
							getCenterY = 800;
							}
							if (curBeat >= 270 && curBeat <= 278)
							{
							getCenterX = 1450;
							getCenterY = 800;
							}
							if (curBeat >= 278 && curBeat <= 294)
							{
							getCenterX = 1500;
							getCenterY = 800;
							}
							if (curBeat >= 294 && curBeat <= 312)
							{
							getCenterX = 850;
							getCenterY = 700;
							}
							if (curBeat >= 312 && curBeat <= 328)
							{
							getCenterX = 1050;
							getCenterY = 750;
							}
							if (curBeat >= 328 && curBeat <= 334)
							{
							getCenterX = 650;
							getCenterY = 750;
							}
							if (curBeat >= 334 && curBeat <= 344)
							{
							getCenterX = 650;
							getCenterY = 750;
							}
							if (curBeat >= 344 && curBeat <= 360)
							{
							getCenterX = 1300;
							getCenterY = 800;
							}
							if (curBeat >= 360 && curBeat <= 456)
							{
							getCenterX = 950;
							getCenterY = 700;
							}
							if (curBeat >= 456)
							{
							getCenterX = 1050;
							getCenterY = 750;
							}
							}
						case 'polus2':
							getCenterX = 1800;
							getCenterY = 1300;
						case 'polus3':
							defaultCamZoom = 0.7;
							getCenterX = 1900;
							getCenterY = 435;
						case 'grey':
							getCenterX = 1800;
							getCenterY = 700;
						case 'plantroom':
							getCenterX = 380;
							getCenterY = 200;
						case 'pretender':
							getCenterX = 380;
							getCenterY = 200;
						case 'chef':
							getCenterX = 1400;
							getCenterY = 800;
						case 'lounge':
							getCenterX = 1000;
							getCenterY = 700;
							if (SONG.song.toLowerCase() == 'o2')
							{
							if (curBeat >= 120)
							{
							getCenterX = 1500;
							getCenterY = 700;
							}
							}
						case 'voting':
						repositionBoyfriendCameraOffset = true;
		if (SONG.song.toLowerCase() == 'voting-time')
		{
		if (curStep >= 16 && curStep <= 50)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 50 && curStep <= 80)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 80 && curStep <= 112)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 112 && curStep <= 120)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 120 && curStep <= 128)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 128 && curStep <= 136)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 136 && curStep <= 138)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 138 && curStep <= 140)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 140 && curStep <= 144)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 144 && curStep <= 208)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 208 && curStep <= 240)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 240 && curStep <= 248)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 248 && curStep <= 256)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 256 && curStep <= 272)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 960;
							getCenterY = 540;
		}
		if (curStep >= 272 && curStep <= 288)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 288 && curStep <= 304)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 304 && curStep <= 320)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 320 && curStep <= 336)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 336 && curStep <= 352)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 352 && curStep <= 360)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 360 && curStep <= 368)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 368 && curStep <= 384)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 384 && curStep <= 392)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 392 && curStep <= 400)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 400 && curStep <= 431)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 431 && curStep <= 463)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 463 && curStep <= 479)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 479 && curStep <= 495)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 495 && curStep <= 500)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 500 && curStep <= 504)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 504 && curStep <= 508)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 508 && curStep <= 511)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 511 && curStep <= 527)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 527 && curStep <= 561)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 561 && curStep <= 577)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 577 && curStep <= 590)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 590 && curStep <= 626)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 626 && curStep <= 642)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 642 && curStep <= 653)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 653 && curStep <= 720)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 720 && curStep <= 752)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 752 && curStep <= 780)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 780 && curStep <= 832)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 832 && curStep <= 899)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 899 && curStep <= 902)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 902 && curStep <= 905)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 905 && curStep <= 908)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 908 && curStep <= 912)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 960;
							getCenterY = 540;
		}
		if (curStep >= 912 && curStep <= 976)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 976 && curStep <= 1044)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 1044 && curStep <= 1060)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1060 && curStep <= 1076)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1076 && curStep <= 1092)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1092 && curStep <= 1140)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1140 && curStep <= 1160)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 1160 && curStep <= 1162)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1162 && curStep <= 1164)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 1164 && curStep <= 1166)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 1166 && curStep <= 1168)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1168 && curStep <= 1176)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1176 && curStep <= 1184)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 1184 && curStep <= 1200)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1200 && curStep <= 1208)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 1208 && curStep <= 1216)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1216 && curStep <= 1224)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1224 && curStep <= 1232)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 960;
							getCenterY = 540;
		}
		if (curStep >= 1232 && curStep <= 1240)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1240 && curStep <= 1248)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 1248 && curStep <= 1264)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1264 && curStep <= 1272)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 1272 && curStep <= 1280)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1280 && curStep <= 1288)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1288 && curStep <= 1296)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		if (curStep >= 1296 && curStep <= 1300)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 460;
							getCenterY = 700;
		}
		if (curStep >= 1300 && curStep <= 1304)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1304 && curStep <= 1308)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 480;
							getCenterY = 680;
		}
		if (curStep >= 1308 && curStep <= 1312)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1450;
							getCenterY = 680;
		}
		if (curStep >= 1312)
		{
		repositionBoyfriendCameraOffset = false;
							getCenterX = 1470;
							getCenterY = 700;
		}
		}
						case 'turbulence':
							getCenterX = 1750.95;
							getCenterY = 900;
						case 'victory':
							getCenterX = 1000;
							getCenterY = 550;
						case 'powstage':
							getCenterX = 1000;
							getCenterY = 600;
						case 'henry':
							getCenterX = 1000;
							getCenterY = 550;
						case 'charles':
							getCenterX = 700;
							getCenterY = 500;
							if (SONG.song.toLowerCase() == 'greatest-plan')
							{
							if (curStep >= 32)
							{
							getCenterX = 130;
							getCenterY = 450;
							}
							}
						case 'school':
							getCenterX = 800;
							getCenterY = 475;
						case 'tomtus':
							getCenterX = 1200;
							getCenterY = 650;
							if (SONG.song.toLowerCase() == 'tomongus-tuesday')
							{
							if (curStep >= 983)
							{
							getCenterX = 1000;
							getCenterY = 650;
							defaultCamZoom = 0.9;
							}
							}
						case 'loggo':
							getCenterX = 652.9;
							getCenterY = 1700;
						case 'loggo2':
							getCenterX = 652.9;
							getCenterY = 1700;
						case 'alpha':
						repositionBoyfriendCameraOffset = true;
						case 'kills':
							getCenterX = 500;
							getCenterY = 600;
						case 'who':
							getCenterX = 1100;
							getCenterY = 1150;
		if (SONG.song.toLowerCase() == 'who')
		{
		if (curStep >= 384 && curStep <= 397)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 397 && curStep <= 402)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 402 && curStep <= 412)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 412 && curStep <= 424)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 424 && curStep <= 448)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 448 && curStep <= 504)
		{
							getCenterX = 1100;
							getCenterY = 1150;
		}
		if (curStep >= 504 && curStep <= 512)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 512 && curStep <= 529)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 529 && curStep <= 560)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 560 && curStep <= 576)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 576 && curStep <= 612)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 612 && curStep <= 630)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 630 && curStep <= 642)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 642 && curStep <= 662)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 662 && curStep <= 688)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 688 && curStep <= 697)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 697 && curStep <= 708)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 708 && curStep <= 712)
		{
							getCenterX = 1100;
							getCenterY = 1150;
		}
		if (curStep >= 712 && curStep <= 728)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 728 && curStep <= 768)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 768 && curStep <= 784)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 784 && curStep <= 791)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 791 && curStep <= 800)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 800 && curStep <= 818)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 818 && curStep <= 824)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 824 && curStep <= 830)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 830 && curStep <= 844)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 844 && curStep <= 852)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 852 && curStep <= 864)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 864 && curStep <= 880)
		{
							getCenterX = 1100;
							getCenterY = 1150;
		}
		if (curStep >= 880 && curStep <= 896)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 896 && curStep <= 904)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 904 && curStep <= 912)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 912 && curStep <= 928)
		{
							getCenterX = 1100;
							getCenterY = 1150;
		}
		if (curStep >= 928 && curStep <= 942)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 942 && curStep <= 960)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 960 && curStep <= 976)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 976 && curStep <= 986)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 986 && curStep <= 992)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 992 && curStep <= 1025)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 1025 && curStep <= 1040)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 1040 && curStep <= 1056)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 1056 && curStep <= 1088)
		{
							getCenterX = 1100;
							getCenterY = 1150;
		}
		if (curStep >= 1088 && curStep <= 1120)
		{
							getCenterX = boyfriend.getMidpoint().x - 150;
							getCenterY = boyfriend.getMidpoint().y + 150;
		}
		if (curStep >= 1120 && curStep <= 1168)
		{
							getCenterX = dadOpponent.getMidpoint().x + 150;
							getCenterY = dadOpponent.getMidpoint().y + 150;
		}
		if (curStep >= 1168)
		{
							getCenterX = 1100;
							getCenterY = 1150;
		}
		}
						case 'jerma':
							defaultCamZoom = 0.8;
							getCenterX = 1000;
							getCenterY = 600;
						case 'nuzzus':
							getCenterX = 125;
							getCenterY = 250;
						case 'idk':
							getCenterX = 420;
							getCenterY = 300;
						case 'esculent':
							getCenterX = 1200;
							getCenterY = 700;
						case 'drippypop':
							getCenterX = 1350;
							getCenterY = 600;
							if (SONG.song.toLowerCase() == 'drippypop')
							{
							if (curBeat >= 286 && curBeat <= 304)
							{
							getCenterX = 1300;
							getCenterY = 350;
							}
							if (curBeat >= 304 && curBeat <= 318)
							{
							getCenterX = 1350;
							getCenterY = 600;
							}
							if (curBeat >= 318 && curBeat <= 336)
							{
							getCenterX = 1300;
							getCenterY = 350;
							}
							if (curBeat >= 336 && curBeat <= 384)
							{
							getCenterX = 1350;
							getCenterY = 600;
							}
							if (curBeat >= 384 && curBeat <= 401)
							{
							getCenterX = 1300;
							getCenterY = 350;
							}
							if (curBeat >= 401)
							{
							getCenterX = 1350;
							getCenterY = 600;
							}
							}
						case 'dave':
							getCenterX = 1000;
							getCenterY = 720;
						case 'attack':
							getCenterX = 1400;
							getCenterY = 1050;
							if (SONG.song.toLowerCase() == 'monotone-attack')
							{
							if (curBeat >= 64 && curBeat <= 80)
							{
							getCenterX = 1225;
							getCenterY = 1000;
							}
							if (curBeat >= 80 && curBeat <= 95)
							{
							getCenterX = 1225;
							getCenterY = 1000;
							}
							if (curBeat >= 95 && curBeat <= 99)
							{
							getCenterX = 1000;
							getCenterY = 900;
							}
							if (curBeat >= 99 && curBeat <= 196)
							{
							getCenterX = 1400;
							getCenterY = 1050;
							}
							if (curBeat >= 196 && curBeat <= 229)
							{
							getCenterX = 1225;
							getCenterY = 1000;
							}
							if (curBeat >= 229 && curBeat <= 276)
							{
							getCenterX = 1225;
							getCenterY = 1000;
							}
							if (curBeat >= 276 && curBeat <= 292)
							{
							getCenterX = 1225;
							getCenterY = 1000;
							}
							if (curBeat >= 292 && curBeat <= 324)
							{
							getCenterX = 1400;
							getCenterY = 1050;
							}
							if (curBeat >= 324 && curBeat <= 355)
							{
							getCenterX = 1225;
							getCenterY = 1000;
							}
							if (curBeat >= 355 && curBeat <= 360)
							{
							getCenterX = 1000;
							getCenterY = 900;
							}
							if (curBeat >= 360)
							{
							getCenterX = 1225;
							getCenterY = 1000;
							}
							}
						case 'piptowers':
							getCenterX = 800;
							getCenterY = 450;
							if (SONG.song.toLowerCase() == 'chippin')
							{
							if (curStep >= 448)
							{
							getCenterX = 750;
							getCenterY = 300;
							}
							}
							if (SONG.song.toLowerCase() == 'chipping')
							{
							if (curStep >= 448)
							{
							getCenterX = 750;
							getCenterY = 300;
							}
							}
						case 'warehouse':
							defaultCamZoom = 1.2;
							getCenterX = 640;
							getCenterY = 350;
						case 'banana':
						repositionBoyfriendCameraOffset = true;
						case 'finale':
							defaultCamZoom = 0.5;
							getCenterX = 700;
							getCenterY = 700;
						case 'monochrome':
						repositionBoyfriendCameraOffset = true;
						case 'pink':
						repositionBoyfriendCameraOffset = true;
						case 'skinny':
						repositionBoyfriendCameraOffset = true;
						case 'tripletrouble':
							getCenterX = 1270;
							getCenterY = 850;
						case 'youtuber':
							getCenterX = 640;
							getCenterY = 360;
					}

					if (repositionBoyfriendCameraOffset)
					{
				getCenterX = char.getMidpoint().x - 100;
				getCenterY = char.getMidpoint().y - 100;
		switch (PlayState.SONG.player1)
		{
			case 'dad':
				getCenterX -= 0;
				getCenterY += 0;
			case 'spooky':
				getCenterX -= 0;
				getCenterY += 0;
			case 'pico':
				getCenterX -= 0;
				getCenterY += 0;
			case 'picolobby':
				getCenterX -= 50;
				getCenterY += 70;
			case 'mom':
				getCenterX -= 0;
				getCenterY += 0;
			case 'mom-car':
				getCenterX -= 0;
				getCenterY += 0;
			case 'parents-christmas':
				getCenterX -= 0;
				getCenterY += 0;
			case 'monster-christmas':
				getCenterX -= 0;
				getCenterY += 0;
			case 'monster':
				getCenterX -= 0;
				getCenterY += 0;
			case 'senpai':
				getCenterX -= -240;
				getCenterY += -330;
			case 'senpai-angry':
				getCenterX -= -240;
				getCenterY += -330;
			case 'spirit':
				getCenterX -= 0;
				getCenterY += 0;
			case 'impostor':
				getCenterX -= -130;
				getCenterY += 290;
			case 'sabotage':
				getCenterX -= -130;
				getCenterY += 290;
			case 'impostor2':
				getCenterX -= -130;
				getCenterY += 290;
			case 'crewmate':
				getCenterX -= 30;
				getCenterY += 230;
			case 'impostor3':
				getCenterX -= -100;
				getCenterY += 290;
			case 'whitegreen':
				getCenterX -= -130;
				getCenterY += 290;
			case 'impostorr':
				getCenterX -= -130;
				getCenterY += 290;
			case 'parasite':
				getCenterX -= -200;
				getCenterY += -160;
			case 'yellow':
				getCenterX -= 0;
				getCenterY += 200;
			case 'reaction':
				getCenterX -= 0;
				getCenterY += 200;
			case 'white':
				getCenterX -= 30;
				getCenterY += 230;
			case 'black-run':
				getCenterX -= -880;
				getCenterY += -100;
			case 'blacklegs':
				getCenterX -= -880;
				getCenterY += -100;
			case 'blackalt':
				getCenterX -= -880;
				getCenterY += -100;
			case 'whitedk':
				getCenterX -= -460;
				getCenterY += 60;
			case 'blackdk':
				getCenterX -= -70;
				getCenterY += 110;
			case 'black':
				getCenterX -= -880;
				getCenterY += -100;
			case 'blackKill':
				getCenterX -= -880;
				getCenterY += -100;
			case 'blackold':
				getCenterX -= -253;
				getCenterY += 140;
			case 'blackparasite':
				getCenterX -= -253;
				getCenterY += 140;
			case 'bfscary':
				getCenterX -= -30;
				getCenterY += 200;
			case 'monotone':
				getCenterX -= -20;
				getCenterY += 190;
			case 'maroon':
				getCenterX -= -130;
				getCenterY += 260;
			case 'maroonp':
				getCenterX -= -130;
				getCenterY += 260;
			case 'grey':
				getCenterX -= 500;
				getCenterY += 0;
			case 'pink':
				getCenterX -= -70;
				getCenterY += 110;
			case 'pretender':
				getCenterX -= -190;
				getCenterY += 200;
			case 'chefogus':
				getCenterX -= -30;
				getCenterY += 200;
			case 'jorsawsee':
				getCenterX -= -130;
				getCenterY += 290;
			case 'meangus':
				getCenterX -= -70;
				getCenterY += -70;
			case 'warchief':
				getCenterX -= 110;
				getCenterY += 140;
			case 'jelqer':
				getCenterX -= 10;
				getCenterY += 230;
			case 'mungus':
				getCenterX -= 200;
				getCenterY += -200;
			case 'madgus':
				getCenterX -= 200;
				getCenterY += -200;
			case 'redmungusp':
				getCenterX -= -120;
				getCenterY += 300;
			case 'jorsawghost':
				getCenterX -= -130;
				getCenterY += 300;
			case 'powers':
				getCenterX -= -60;
				getCenterY += 140;
			case 'henry':
				getCenterX -= -60;
				getCenterY += 110;
			case 'charles':
				getCenterX -= 60;
				getCenterY += 60;
			case 'henryphone':
				getCenterX -= 0;
				getCenterY += 0;
			case 'ellie':
				getCenterX -= -260;
				getCenterY += 110;
			case 'rhm':
				getCenterX -= 0;
				getCenterY += -20;
			case 'reginald':
				getCenterX -= -60;
				getCenterY += 110;
			case 'tomongus':
				getCenterX -= -70;
				getCenterY += -220;
			case 'hamster':
				getCenterX -= -240;
				getCenterY += -340;
			case 'tuesday':
				getCenterX -= -130;
				getCenterY += 290;
			case 'fella':
				getCenterX -= -270;
				getCenterY += -200;
			case 'boo':
				getCenterX -= -260;
				getCenterY += -200;
			case 'oldpostor':
				getCenterX -= -130;
				getCenterY += 0;
			case 'red':
				getCenterX -= -80;
				getCenterY += 390;
			case 'blue':
				getCenterX -= 80;
				getCenterY += 400;
			case 'bluehit':
				getCenterX -= 80;
				getCenterY += 200;
			case 'bluewhonormal':
				getCenterX -= -130;
				getCenterY += 290;
			case 'bluewho':
				getCenterX -= -130;
				getCenterY += 290;
			case 'whitewho':
				getCenterX -= -130;
				getCenterY += 290;
			case 'whitemad':
				getCenterX -= -130;
				getCenterY += 290;
			case 'jerma':
				getCenterX -= -60;
				getCenterY += 110;
			case 'nuzzus':
				getCenterX -= -60;
				getCenterY += 110;
			case 'idk':
				getCenterX -= -80;
				getCenterY += 390;
			case 'esculent':
				getCenterX -= -130;
				getCenterY += 290;
			case 'drippypop':
				getCenterX -= -60;
				getCenterY += 100;
			case 'dave':
				getCenterX -= -300;
				getCenterY += 160;
			case 'attack':
				getCenterX -= -20;
				getCenterY += 190;
			case 'clowfoe':
				getCenterX -= -20;
				getCenterY += 190;
			case 'fabs':
				getCenterX -= 1000;
				getCenterY += 110;
			case 'biddle':
				getCenterX -= -20;
				getCenterY += 190;
			case 'top':
				getCenterX -= -130;
				getCenterY += 290;
			case 'cval':
				getCenterX -= 0;
				getCenterY += 0;
			case 'pip':
				getCenterX -= 0;
				getCenterY += 0;
			case 'pip_evil':
				getCenterX -= 0;
				getCenterY += 0;
			case 'cvaltorture':
				getCenterX -= -610;
				getCenterY += 90;
			case 'piptorture':
				getCenterX -= -610;
				getCenterY += 90;
			case 'ziffytorture':
				getCenterX -= -145;
				getCenterY += 70;
			case 'alien':
				getCenterX -= 0;
				getCenterY += 0;
			case 'blackPlaceholder':
				getCenterX -= -430;
				getCenterY += -190;
			case 'blackpostor':
				getCenterX -= 110;
				getCenterY += 200;
			case 'crewmate-dance':
				getCenterX -= 30;
				getCenterY += 230;
			case 'dead':
				getCenterX -= -70;
				getCenterY += -30;
			case 'dt':
				getCenterX -= -910;
				getCenterY += -410;
			case 'fuckgus':
				getCenterX -= -270;
				getCenterY += 10;
			case 'ghost':
				getCenterX -= -80;
				getCenterY += 80;
			case 'henryplayer':
				getCenterX -= 20;
				getCenterY += 50;
			case 'impostorv2':
				getCenterX -= -130;
				getCenterY += 290;
			case 'jorsawdead':
				getCenterX -= -130;
				getCenterY += 300;
			case 'kyubicrasher':
				getCenterX -= -185;
				getCenterY += 190;
			case 'loggo':
				getCenterX -= -400;
				getCenterY += -300;
			case 'pinkexe':
				getCenterX -= -190;
				getCenterY += 200;
			case 'pinkplayable':
				getCenterX -= -190;
				getCenterY += 200;
			case 'powers_sax':
				getCenterX -= -130;
				getCenterY += 120;
			case 'ziffy':
				getCenterX -= 0;
				getCenterY += 110;
			case 'bf':
				getCenterX -= 100;
				getCenterY += -40;
			case 'bfg':
				getCenterX -= 0;
				getCenterY += 0;
			case 'whitebf':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bfr':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bf-fall':
				getCenterX -= 500;
				getCenterY += -100;
			case 'bfshock':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bf-running':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bf-legs':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bf-legsmiss':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bf-defeat-normal':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bf-defeat-scared':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bfpolus':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bf-lava':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bfairship':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bfmira':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bfsauce':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bf_turb':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bfsusreal':
				getCenterX -= 300;
				getCenterY += -30;
			case 'susfriend':
				getCenterX -= 0;
				getCenterY += 0;
			case 'dripbf':
				getCenterX -= 0;
				getCenterY += 0;
			case 'redp':
				getCenterX -= 70;
				getCenterY += -120;
			case 'greenp':
				getCenterX -= 70;
				getCenterY += -120;
			case 'blackp':
				getCenterX -= 70;
				getCenterY += -120;
			case 'amongbf':
				getCenterX -= 70;
				getCenterY += -120;
			case 'stick-bf':
				getCenterX -= 160;
				getCenterY += -40;
			case 'bf-geoff':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bf-opp':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bfghost':
				getCenterX -= 100;
				getCenterY += -40;
			case 'bf-car':
				getCenterX -= 0;
				getCenterY += 0;
			case 'bf-christmas':
				getCenterX -= 200;
				getCenterY += -200;
			case 'bf-pixel':
				getCenterX -= 180;
				getCenterY += -140;
			case 'bfsus-pixel':
				getCenterX -= 180;
				getCenterY += -140;
			case 'idkbf':
				getCenterX -= -80;
				getCenterY += 390;
			case 'bf-pixel-opponent':
				getCenterX -= 50;
				getCenterY += -160;
			case 'bf-holding-gf':
				getCenterX -= 0;
				getCenterY += 0;
			case 'gf':
				getCenterX -= 0;
				getCenterY += 100;
			case 'gf-christmas':
				getCenterX -= 0;
				getCenterY += 0;
			case 'gf-car':
				getCenterX -= 0;
				getCenterY += 0;
			case 'invisigf':
				getCenterX -= -880;
				getCenterY += -100;
			case 'ghostgf':
				getCenterX -= 0;
				getCenterY += 0;
			case 'gfr':
				getCenterX -= 300;
				getCenterY += 600;
			case 'gf-fall':
				getCenterX -= 0;
				getCenterY += 0;
			case 'gfdanger':
				getCenterX -= 0;
				getCenterY += 0;
			case 'gfpolus':
				getCenterX -= 0;
				getCenterY += 0;
			case 'gfdead':
				getCenterX -= 0;
				getCenterY += 0;
			case 'gfmira':
				getCenterX -= 0;
				getCenterY += 0;
			case 'tuesdaygf':
				getCenterX -= 0;
				getCenterY += 0;
			case 'oldgf':
				getCenterX -= 0;
				getCenterY += 0;
			case 'drippico':
				getCenterX -= 0;
				getCenterY += 0;
			case 'henrygf':
				getCenterX -= 0;
				getCenterY += 0;
			case 'gf-farmer':
				getCenterX -= 0;
				getCenterY += 0;
			case 'loggogf':
				getCenterX -= 0;
				getCenterY += 0;
			case 'gf-pixel':
				getCenterX -= -20;
				getCenterY += 80;
				default:
				getCenterX -= 100;
				getCenterY += -40;
		}
					}

					camFollow.setPosition(getCenterX + camDisplaceX - char.characterData.camOffsetX,
						getCenterY + camDisplaceY + char.characterData.camOffsetY);
				}
			}

			var lerpVal = (elapsed * 2.4) * cameraSpeed;

			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

			var easeLerp = 0.95;
			// camera stuffs
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom + forceZoom[0], FlxG.camera.zoom, easeLerp);
			for (hud in allUIs)
				hud.zoom = FlxMath.lerp(1 + forceZoom[1], hud.zoom, easeLerp);

			// not even forcezoom anymore but still
			FlxG.camera.angle = FlxMath.lerp(0 + forceZoom[2], FlxG.camera.angle, easeLerp);
			for (hud in allUIs)
				hud.angle = FlxMath.lerp(0 + forceZoom[3], hud.angle, easeLerp);

			if (health <= 0 && startedCountdown && !boyfriendStrums.autoplay && !KillNotes)
			{
				// startTimer.active = false;
				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				resetMusic();

				if(curSong.toLowerCase() != 'defeat'){
				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				}
				else{
					KillNotes = true;
					vocals.volume = 0;
					vocals.pause();
					
					canPause = false;
					paused = true;

					FlxG.sound.music.volume = 0;
					
					dadOpponent.setCharacter(0, 0, 'blackKill');
					dadOpponent.setPosition(210, 100);
					dadOpponent.y += 80;
					dadOpponent.x += 180;
					isCameraOnForcedPos = true;
					camFollow.x = 550;
					camFollow.y = 500;

					FlxG.sound.play(Paths.sound('edefeat', 'impostor'), 1);

					for (hud in allUIs)
					FlxTween.tween(hud, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});

					uiHUD.iconP1.visible = false;
					uiHUD.iconP2.visible = false;

					defaultCamZoom = 0.65;
					dadOpponent.setPosition(-15, 163);
					dadOpponent.playAnim('kill1');

					new FlxTimer().start(1.8, function(tmr:FlxTimer)
					{
						dadOpponent.playAnim('kill2');

						defaultCamZoom = 0.5;
						isCameraOnForcedPos = true;
						camFollow.x = 750;
						camFollow.y = 450;
					});
					new FlxTimer().start(2.7, function(tmr:FlxTimer)
					{
						dadOpponent.playAnim('kill3');
					});
					new FlxTimer().start(3.4, function(tmr:FlxTimer)
					{
						openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
					});
				}

				// discord stuffs should go here
			}

			// spawn in the notes from the array
			if ((unspawnNotes[0] != null) && ((unspawnNotes[0].strumTime - Conductor.songPosition) < 3500))
			{
				var dunceNote:Note = unspawnNotes[0];
				// push note to its correct strumline
				strumLines.members[Math.floor((dunceNote.noteData + (dunceNote.mustPress ? 4 : 0)) / numberOfKeys)].push(dunceNote);
				unspawnNotes.splice(unspawnNotes.indexOf(dunceNote), 1);
			}

			noteCalls();
		}

	}

	function noteCalls()
	{
		// reset strums
		for (strumline in strumLines)
		{
			// handle strumline stuffs
			var i = 0;
			for (uiNote in strumline.receptors)
			{
				if (strumline.autoplay)
					strumCallsAuto(uiNote);
			}

			if (strumline.splashNotes != null)
				for (i in 0...strumline.splashNotes.length)
				{
					strumline.splashNotes.members[i].x = strumline.receptors.members[i].x - 48;
					strumline.splashNotes.members[i].y = strumline.receptors.members[i].y + (Note.swagWidth / 6) - 56;
				}
		}

		// if the song is generated
		if (generatedMusic && startedCountdown)
		{
			for (strumline in strumLines)
			{
				// set the notes x and y
				var downscrollMultiplier = 1;
				if (Init.trueSettings.get('Downscroll'))
					downscrollMultiplier = -1;
				
				strumline.allNotes.forEachAlive(function(daNote:Note)
				{
					var roundedSpeed = FlxMath.roundDecimal(daNote.noteSpeed, 2);
					var receptorPosY:Float = strumline.receptors.members[Math.floor(daNote.noteData)].y + Note.swagWidth / 6;
					var psuedoY:Float = (downscrollMultiplier * -((Conductor.songPosition - daNote.strumTime) * (0.45 * roundedSpeed)));
					var psuedoX = 25 + daNote.noteVisualOffset;

					daNote.y = receptorPosY
						+ (Math.cos(flixel.math.FlxAngle.asRadians(daNote.noteDirection)) * psuedoY)
						+ (Math.sin(flixel.math.FlxAngle.asRadians(daNote.noteDirection)) * psuedoX);
					// painful math equation
					daNote.x = strumline.receptors.members[Math.floor(daNote.noteData)].x
						+ (Math.cos(flixel.math.FlxAngle.asRadians(daNote.noteDirection)) * psuedoX)
						+ (Math.sin(flixel.math.FlxAngle.asRadians(daNote.noteDirection)) * psuedoY);

					// also set note rotation
					daNote.angle = -daNote.noteDirection;

					// shitty note hack I hate it so much
					var center:Float = receptorPosY + Note.swagWidth / 2;
					if (daNote.isSustainNote) {
						daNote.y -= ((daNote.height / 2) * downscrollMultiplier);
						if ((daNote.animation.curAnim.name.endsWith('holdend')) && (daNote.prevNote != null)) {
							daNote.y -= ((daNote.prevNote.height / 2) * downscrollMultiplier);
							if (Init.trueSettings.get('Downscroll')) {
								daNote.y += (daNote.height * 2);
								if (daNote.endHoldOffset == Math.NEGATIVE_INFINITY) {
									// set the end hold offset yeah I hate that I fix this like this
									daNote.endHoldOffset = (daNote.prevNote.y - (daNote.y + daNote.height));
									trace(daNote.endHoldOffset);
								}
								else
									daNote.y += daNote.endHoldOffset;
							} else // this system is funny like that
								daNote.y += ((daNote.height / 2) * downscrollMultiplier);
						}
						
						if (Init.trueSettings.get('Downscroll'))
						{
							daNote.flipY = true;
							if ((daNote.parentNote != null && daNote.parentNote.wasGoodHit) 
								&& daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center
								&& (strumline.autoplay || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
							{
								var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
								swagRect.height = (center - daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;
								daNote.clipRect = swagRect;
							}
						}
						else
						{
							if ((daNote.parentNote != null && daNote.parentNote.wasGoodHit)
								&& daNote.y + daNote.offset.y * daNote.scale.y <= center
								&& (strumline.autoplay || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
							{
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (center - daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;
								daNote.clipRect = swagRect;
							}
						}
					}

					// hell breaks loose here, we're using nested scripts!
					mainControls(daNote, strumline.character, strumline, strumline.autoplay);

					// check where the note is and make sure it is either active or inactive
					if (daNote.y > FlxG.height) {
						daNote.active = false;
						daNote.visible = false;
					} else {
						daNote.visible = true;
						daNote.active = true;
					}

					if (!daNote.tooLate && daNote.strumTime < Conductor.songPosition - (Timings.msThreshold) && !daNote.wasGoodHit)
					{
						if ((!daNote.tooLate) && (daNote.mustPress)) {
							if (!daNote.isSustainNote)
							{
								daNote.tooLate = true;
								for (note in daNote.childrenNotes)
									note.tooLate = true;
								
								vocals.volume = 0;
								missNoteCheck((Init.trueSettings.get('Ghost Tapping')) ? true : false, daNote.noteData, boyfriend, true);
								// ambiguous name
								Timings.updateAccuracy(0);
							}
							else if (daNote.isSustainNote)
							{
								if (daNote.parentNote != null)
								{
									var parentNote = daNote.parentNote;
									if (!parentNote.tooLate)
									{
										var breakFromLate:Bool = false;
										for (note in parentNote.childrenNotes)
										{
											trace('hold amount ${parentNote.childrenNotes.length}, note is late?' + note.tooLate + ', ' + breakFromLate);
											if (note.tooLate && !note.wasGoodHit)
												breakFromLate = true;
										}
										if (!breakFromLate)
										{
											missNoteCheck((Init.trueSettings.get('Ghost Tapping')) ? true : false, daNote.noteData, boyfriend, true);
											for (note in parentNote.childrenNotes)
												note.tooLate = true;
										}
										//
									}
								}
							}
						}
					
					}

					// if the note is off screen (above)
					if ((((!Init.trueSettings.get('Downscroll')) && (daNote.y < -daNote.height))
					|| ((Init.trueSettings.get('Downscroll')) && (daNote.y > (FlxG.height + daNote.height))))
					&& (daNote.tooLate || daNote.wasGoodHit))
						destroyNote(strumline, daNote);
				});


				// unoptimised asf camera control based on strums
				strumCameraRoll(strumline.receptors, (strumline == boyfriendStrums));
			}
			
		}
		
		// reset bf's animation
		var holdControls:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		if ((boyfriend != null && boyfriend.animation != null)
			&& (boyfriend.holdTimer > Conductor.stepCrochet * (4 / 1000)
			&& (!holdControls.contains(true) || boyfriendStrums.autoplay)))
		{
			if (boyfriend.animation.curAnim.name.startsWith('sing')
			&& !boyfriend.animation.curAnim.name.endsWith('miss'))
				boyfriend.dance();
		}
	}

	function destroyNote(strumline:Strumline, daNote:Note)
	{
		daNote.active = false;
		daNote.exists = false;

		var chosenGroup = (daNote.isSustainNote ? strumline.holdsGroup : strumline.notesGroup);
		// note damage here I guess
		daNote.kill();
		if (strumline.allNotes.members.contains(daNote))
			strumline.allNotes.remove(daNote, true);
		if (chosenGroup.members.contains(daNote))
			chosenGroup.remove(daNote, true);
		daNote.destroy();
	}

	function doGhostAnim(char:String, stringArrow:String)
		{
			var ghost:FlxSprite = dadGhost;
			var player:Character = dadOpponent;
	
			switch(char.toLowerCase().trim()){
				case 'bf' | 'boyfriend' | '0':
					ghost = bfGhost;
					player = boyfriend;
				case 'dad' | 'opponent' | '1':
					ghost = dadGhost;
					player = dadOpponent;
				case 'mom' | 'opponent2' | '3':
					ghost = momGhost;
					player = mom;
			}
	
									
			ghost.frames = player.frames;
			ghost.animation.copyFrom(player.animation);
			ghost.x = player.x;
			ghost.y = player.y;
			ghost.animation.play(stringArrow, true);
			ghost.offset.set(player.animOffsets.get(stringArrow)[0], player.animOffsets.get(stringArrow)[1]);
			ghost.flipX = player.flipX;
			ghost.flipY = player.flipY;
			ghost.blend = HARDLIGHT;
			ghost.alpha = 0.8;
			ghost.visible = true;

			switch(curStage.toLowerCase()){
				case 'who' | 'voting' | 'nuzzus' | 'idk':
					//erm
				case 'cargo' | 'finalem':
					FlxG.camera.zoom += 0.015;
					camHUD.zoom += 0.015;
				default:
					FlxG.camera.zoom += 0.015;
					camHUD.zoom += 0.03;
			}
	
			switch (char.toLowerCase().trim())
			{
				case 'bf' | 'boyfriend' | '0':
					if (bfGhostTween != null)
						bfGhostTween.cancel();
					bfGhostTween = FlxTween.tween(bfGhost, {alpha: 0}, 0.75, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							bfGhostTween = null;
						}
					});
	
				case 'dad' | 'opponent' | '1':
					if (dadGhostTween != null)
						dadGhostTween.cancel();
					dadGhostTween = FlxTween.tween(dadGhost, {alpha: 0}, 0.75, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							dadGhostTween = null;
						}
					});
				case 'mom' | 'opponent2' | '3':
					if (momGhostTween != null)
						momGhostTween.cancel();
					momGhostTween = FlxTween.tween(momGhost, {alpha: 0}, 0.75, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							momGhostTween = null;
						}
					});
			}
		}

	function goodNoteHit(coolNote:Note, character:Character, characterStrums:Strumline, ?canDisplayJudgement:Bool = true)
	{
		if (!coolNote.wasGoodHit) {
			coolNote.wasGoodHit = true;
			vocals.volume = 1;

			characterPlayAnimation(coolNote, character);

					switch (curStage)
					{
						case 'airshipRoom':
							defaultCamZoom = 0.6;
						case 'polus2':
							defaultCamZoom = 0.7;
						case 'plantroom':
							defaultCamZoom = 0.5;
						case 'pretender':
							defaultCamZoom = 0.5;
						case 'victory':
							defaultCamZoom = 0.7;
						case 'henry':
							defaultCamZoom = 0.7;
						case 'tomtus':
							defaultCamZoom = 0.9;
						case 'loggo2':
							defaultCamZoom = 0.9;
						case 'dave':
							defaultCamZoom = 0.8;
						case 'tripletrouble':
							defaultCamZoom = 0.7;
					}

			if (characterStrums.receptors.members[coolNote.noteData] != null)
				characterStrums.receptors.members[coolNote.noteData].playAnim('confirm', true);

			// special thanks to sam, they gave me the original system which kinda inspired my idea for this new one
			if (canDisplayJudgement) {
				// get the note ms timing
				var noteDiff:Float = Math.abs(coolNote.strumTime - Conductor.songPosition);
				// get the timing
				if (coolNote.strumTime < Conductor.songPosition)
					ratingTiming = "late";
				else
					ratingTiming = "early";

				// loop through all avaliable judgements
				var foundRating:String = 'miss';
				var lowestThreshold:Float = Math.POSITIVE_INFINITY;
				for (myRating in Timings.judgementsMap.keys())
				{
					var myThreshold:Float = Timings.judgementsMap.get(myRating)[1];
					if (noteDiff <= myThreshold && (myThreshold < lowestThreshold))
					{
						foundRating = myRating;
						lowestThreshold = myThreshold;
					}
				}

				if (!coolNote.isSustainNote) {
					increaseCombo(foundRating, coolNote.noteData, character);
					popUpScore(foundRating, ratingTiming, characterStrums, coolNote);
					if (coolNote.childrenNotes.length > 0)
						Timings.notesHit++;
					healthCall(Timings.judgementsMap.get(foundRating)[3]);
				} else if (coolNote.isSustainNote) {
					// call updated accuracy stuffs
					if (coolNote.parentNote != null) {
						Timings.updateAccuracy(100, true, coolNote.parentNote.childrenNotes.length);
						healthCall(100 / coolNote.parentNote.childrenNotes.length);
					}
				}
			}

			if (!coolNote.isSustainNote)
				destroyNote(characterStrums, coolNote);
			//
		}
	}

	function missNoteCheck(?includeAnimation:Bool = false, direction:Int = 0, character:Character, popMiss:Bool = false, lockMiss:Bool = false)
	{
		if (includeAnimation)
		{
			var stringDirection:String = UIStaticArrow.getArrowFromNumber(direction);

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			character.playAnim('sing' + stringDirection.toUpperCase() + 'miss', lockMiss);
		}
		decreaseCombo(popMiss);

		//
	}

	function characterPlayAnimation(coolNote:Note, character:Character)
	{
		// alright so we determine which animation needs to play
		// get alt strings and stuffs
		var stringArrow:String = '';
		var altString:String = '';

		var baseString = 'sing' + UIStaticArrow.getArrowFromNumber(coolNote.noteData).toUpperCase();

		// I tried doing xor and it didnt work lollll
		if (coolNote.noteAlt > 0)
			altString = '-alt';
		if (((SONG.notes[Math.floor(curStep / 16)] != null) && (SONG.notes[Math.floor(curStep / 16)].altAnim))
			&& (character.animOffsets.exists(baseString + '-alt')))
		{
			if (altString != '-alt')
				altString = '-alt';
			else
				altString = '';
		}

		stringArrow = baseString + altString;
		// if (coolNote.foreverMods.get('string')[0] != "")
		//	stringArrow = coolNote.noteString;

		if (coolNote.noteType != 'GF Sing')
		{
		if (coolNote.noteType != 'Hey!')
		{
		if (coolNote.noteType != 'Alt Animation')
		{
		if (coolNote.noteType != 'No Animation')
		{
		if (coolNote.noteType != 'Opponent 2 Sing')
		{
		if (opponent2sing != true)
		{
		character.playAnim(stringArrow, true);
		character.holdTimer = 0;
		}
		}
		}
		}
		}
		}

		if (opponent2sing == true && coolNote.mustPress)
		{
		boyfriend.playAnim(stringArrow, true);
		boyfriend.holdTimer = 0;
		}

		if (coolNote.noteType == 'GF Sing')
		{
		gf.playAnim(stringArrow, true);
		gf.holdTimer = 0;
		}

		if (coolNote.noteType == 'Hey!')
		{
		character.playAnim('hey');
		character.specialAnim = true;
		character.holdTimer = 0.6;
		gf.playAnim('cheer', true);
		gf.specialAnim = true;
		gf.holdTimer = 0.6;
		}

		if (coolNote.noteType == 'Alt Animation' && !coolNote.mustPress)
		{
		dadOpponent.playAnim(stringArrow + daAlt, true);
		dadOpponent.holdTimer = 0;
		}

		if (coolNote.noteType == 'Alt Animation' && coolNote.mustPress)
		{
		boyfriend.playAnim(stringArrow + daAlt, true);
		boyfriend.holdTimer = 0;
		}

		if (coolNote.noteType == 'Opponent 2 Sing')
		{
		mom.playAnim(stringArrow, true);
		mom.holdTimer = 0;
		}
		if (opponent2sing == true && !coolNote.mustPress)
		{
		mom.playAnim(stringArrow, true);
		mom.holdTimer = 0;
		}
		if (opponent2sing == true && coolNote.noteType == 'Opponent 2 Sing')
		{
		dadOpponent.playAnim(stringArrow, true);
		dadOpponent.holdTimer = 0;
		}

		if (coolNote.noteType == 'Both Opponents Sing')
		{
		mom.playAnim(stringArrow, true);
		mom.holdTimer = 0;
		}
		if (bothOpponentsSing == true && !coolNote.mustPress)
		{
		mom.playAnim(stringArrow, true);
		mom.holdTimer = 0;
		}

		if (curStage == 'kills')
		{
		if (!coolNote.mustPress)
		{
		boyfriend.playAnim(stringArrow, true);
		boyfriend.holdTimer = 0;
		}
		if (!coolNote.mustPress && boyfriend.curCharacter == 'blue')
		{
		boyfriend.setCharacter(0, 0, 'bluehit');
		boyfriend.setPosition(465, 112);
		boyfriend.x += 40;
		boyfriend.y += 100;
		}
		if (coolNote.mustPress && boyfriend.curCharacter == 'bluehit')
		{
		boyfriend.setCharacter(0, 0, 'blue');
		boyfriend.setPosition(465, 112);
		boyfriend.x += 40;
		boyfriend.y += 100;
		}
		}

		var animToPlay:String = 'sing' + charDir[gfxHud[0][Std.int(Math.abs(coolNote.noteData))]];

		if (coolNote.noteType != 'Opponent 2 Sing')
		{
		if (coolNote.noteType != 'Both Opponents Sing')
		{
		if (coolNote.noteType != 'GF Sing')
		{
		if (coolNote.mustPress)
		{
			if(coolNote.noteType != 'No Animation') {
					if (boyfriend.mostRecentHitNote != null && boyfriend.mostRecentHitNote.strumTime == coolNote.strumTime)
					{
						if (boyfriend.mostRecentHitNote.sustainLength > coolNote.sustainLength)
						{
							if (!coolNote.isSustainNote)
								doGhostAnim('bf', animToPlay);
						}
						else
						{
						animToPlay = 'sing' + charDir[gfxHud[0][Std.int(Math.abs(boyfriend.mostRecentHitNote.noteData))]];
							if (!boyfriend.mostRecentHitNote.isSustainNote)
								doGhostAnim('bf', animToPlay);
						}
					}

				if (!coolNote.isSustainNote)
					boyfriend.mostRecentHitNote = coolNote;
			}
		}
		}
		}
		}
		if (opponent2sing != true)
		{
		if (bothOpponentsSing != true)
		{
		if (coolNote.noteType != 'Both Opponents Sing')
		{
		if (coolNote.noteType != 'GF Sing')
		{
		if (!coolNote.mustPress)
		{
			if(coolNote.noteType != 'No Animation') {
					if (dadOpponent.mostRecentHitNote != null && dadOpponent.mostRecentHitNote.strumTime == coolNote.strumTime)
					{
						if (dadOpponent.mostRecentHitNote.sustainLength > coolNote.sustainLength)
						{
							if (!coolNote.isSustainNote)
								doGhostAnim('dad', animToPlay);
						}
						else
						{
						animToPlay = 'sing' + charDir[gfxHud[0][Std.int(Math.abs(dadOpponent.mostRecentHitNote.noteData))]];
							if (!dadOpponent.mostRecentHitNote.isSustainNote)
								doGhostAnim('dad', animToPlay);
						}
					}

				if (!coolNote.isSustainNote)
					dadOpponent.mostRecentHitNote = coolNote;
			}
		}
		}
		}
		}
		}
			if(coolNote.noteType == 'Opponent 2 Sing') {
					if (mom.mostRecentHitNote != null && mom.mostRecentHitNote.strumTime == coolNote.strumTime)
					{
						if (mom.mostRecentHitNote.sustainLength > coolNote.sustainLength)
						{
							if (!coolNote.isSustainNote)
								doGhostAnim('mom', animToPlay);
						}
						else
						{
						animToPlay = 'sing' + charDir[gfxHud[0][Std.int(Math.abs(mom.mostRecentHitNote.noteData))]];
							if (!mom.mostRecentHitNote.isSustainNote)
								doGhostAnim('mom', animToPlay);
						}
					}

				if (!coolNote.isSustainNote)
					mom.mostRecentHitNote = coolNote;
			}
		if (opponent2sing == true && !coolNote.mustPress)
		{
			if(coolNote.noteType != 'No Animation') {
					if (mom.mostRecentHitNote != null && mom.mostRecentHitNote.strumTime == coolNote.strumTime)
					{
						if (mom.mostRecentHitNote.sustainLength > coolNote.sustainLength)
						{
							if (!coolNote.isSustainNote)
								doGhostAnim('mom', animToPlay);
						}
						else
						{
						animToPlay = 'sing' + charDir[gfxHud[0][Std.int(Math.abs(mom.mostRecentHitNote.noteData))]];
							if (!mom.mostRecentHitNote.isSustainNote)
								doGhostAnim('mom', animToPlay);
						}
					}

				if (!coolNote.isSustainNote)
					mom.mostRecentHitNote = coolNote;
			}
		}
		if (opponent2sing == true && !coolNote.mustPress)
		{
			if(coolNote.noteType == 'Opponent 2 Sing') {
					if (dadOpponent.mostRecentHitNote != null && dadOpponent.mostRecentHitNote.strumTime == coolNote.strumTime)
					{
						if (dadOpponent.mostRecentHitNote.sustainLength > coolNote.sustainLength)
						{
							if (!coolNote.isSustainNote)
								doGhostAnim('dad', animToPlay);
						}
						else
						{
						animToPlay = 'sing' + charDir[gfxHud[0][Std.int(Math.abs(mom.mostRecentHitNote.noteData))]];
							if (!dadOpponent.mostRecentHitNote.isSustainNote)
								doGhostAnim('dad', animToPlay);
						}
					}

				if (!coolNote.isSustainNote)
					dadOpponent.mostRecentHitNote = coolNote;
			}
		}
	}

	private function strumCallsAuto(cStrum:UIStaticArrow, ?callType:Int = 1, ?daNote:Note):Void
	{
		switch (callType)
		{
			case 1:
				// end the animation if the calltype is 1 and it is done
				if ((cStrum.animation.finished) && (cStrum.canFinishAnimation))
					cStrum.playAnim('static');
			default:
				// check if it is the correct strum
				if (daNote.noteData == cStrum.ID)
				{
					// if (cStrum.animation.curAnim.name != 'confirm')
					cStrum.playAnim('confirm'); // play the correct strum's confirmation animation (haha rhymes)

					// stuff for sustain notes
					if ((daNote.isSustainNote) && (!daNote.animation.curAnim.name.endsWith('holdend')))
						cStrum.canFinishAnimation = false; // basically, make it so the animation can't be finished if there's a sustain note below
					else
						cStrum.canFinishAnimation = true;
				}
		}
	}

	private function mainControls(daNote:Note, char:Character, strumline:Strumline, autoplay:Bool):Void
	{
		var notesPressedAutoplay = [];

		// here I'll set up the autoplay functions
		if (autoplay)
		{
			// check if the note was a good hit
			if (daNote.strumTime <= Conductor.songPosition)
			{
				// use a switch thing cus it feels right idk lol
				// make sure the strum is played for the autoplay stuffs
				/*
					charStrum.forEach(function(cStrum:UIStaticArrow)
					{
						strumCallsAuto(cStrum, 0, daNote);
					});
				 */

				// kill the note, then remove it from the array
				var canDisplayJudgement = false;
				if (strumline.displayJudgements)
				{
					canDisplayJudgement = true;
					for (noteDouble in notesPressedAutoplay)
					{
						if (noteDouble.noteData == daNote.noteData)
						{
							// if (Math.abs(noteDouble.strumTime - daNote.strumTime) < 10)
							canDisplayJudgement = false;
							// removing the fucking check apparently fixes it
							// god damn it that stupid glitch with the double judgements is annoying
						}
						//
					}
					notesPressedAutoplay.push(daNote);
				}
				goodNoteHit(daNote, char, strumline, canDisplayJudgement);
			}
			//
		} 

		var holdControls:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		if (!autoplay) {
			// check if anything is held
			if (holdControls.contains(true))
			{
				// check notes that are alive
				strumline.allNotes.forEachAlive(function(coolNote:Note)
				{
					if ((coolNote.parentNote != null && coolNote.parentNote.wasGoodHit)
					&& coolNote.canBeHit && coolNote.mustPress
					&& !coolNote.tooLate && coolNote.isSustainNote
					&& holdControls[coolNote.noteData])
						goodNoteHit(coolNote, char, strumline);
				});
			}
		}
	}

	private function strumCameraRoll(cStrum:FlxTypedGroup<UIStaticArrow>, mustHit:Bool)
	{
		if (!Init.trueSettings.get('No Camera Note Movement'))
		{
			var camDisplaceExtend:Float = 15;
			if (PlayState.SONG.notes[Std.int(curStep / 16)] != null)
			{
				if ((PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && mustHit)
					|| (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection && !mustHit))
				{
					camDisplaceX = 0;
					if (cStrum.members[0].animation.curAnim.name == 'confirm')
						camDisplaceX -= camDisplaceExtend;
					if (cStrum.members[3].animation.curAnim.name == 'confirm')
						camDisplaceX += camDisplaceExtend;
					
					camDisplaceY = 0;
					if (cStrum.members[1].animation.curAnim.name == 'confirm')
						camDisplaceY += camDisplaceExtend;
					if (cStrum.members[2].animation.curAnim.name == 'confirm')
						camDisplaceY -= camDisplaceExtend;
				}
			}
		}
		//
	}

	override public function onFocus():Void
	{
		if (!paused)
			updateRPC(false);
		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		updateRPC(true);
		super.onFocusLost();
	}

	public static function updateRPC(pausedRPC:Bool)
	{
		#if !html5
		var displayRPC:String = (pausedRPC) ? detailsPausedText : songDetails;

		if (health > 0)
		{
			if (Conductor.songPosition > 0 && !pausedRPC)
				Discord.changePresence(displayRPC, detailsSub, iconRPC, true, songLength - Conductor.songPosition);
			else
				Discord.changePresence(displayRPC, detailsSub, iconRPC);
		}
		#end
	}

	var animationsPlay:Array<Note> = [];

	private var ratingTiming:String = "";

	function popUpScore(baseRating:String, timing:String, strumline:Strumline, coolNote:Note)
	{
		// set up the rating
		var score:Int = 50;

		// notesplashes
		if (baseRating == "sick")
			// create the note splash if you hit a sick
			createSplash(coolNote, strumline);
		else
 			// if it isn't a sick, and you had a sick combo, then it becomes not sick :(
			if (allSicks)
				allSicks = false;

		displayRating(baseRating, timing);
		Timings.updateAccuracy(Timings.judgementsMap.get(baseRating)[3]);
		score = Std.int(Timings.judgementsMap.get(baseRating)[2]);

		songScore += score;

		popUpCombo();
	}

	public function createSplash(coolNote:Note, strumline:Strumline)
	{
		// play animation in existing notesplashes
		var noteSplashRandom:String = (Std.string((FlxG.random.int(0, 1) + 1)));
		if (strumline.splashNotes != null)
			strumline.splashNotes.members[coolNote.noteData].playAnim('anim' + noteSplashRandom, true);
	}

	private var createdColor = FlxColor.fromRGB(204, 66, 66);

	function popUpCombo(?cache:Bool = false)
	{
		var comboString:String = Std.string(combo);
		var negative = false;
		if ((comboString.startsWith('-')) || (combo == 0))
			negative = true;
		var stringArray:Array<String> = comboString.split("");
		// deletes all combo sprites prior to initalizing new ones
		if (lastCombo != null)
		{
			while (lastCombo.length > 0)
			{
				lastCombo[0].kill();
				lastCombo.remove(lastCombo[0]);
			}
		}

		for (scoreInt in 0...stringArray.length)
		{
			// numScore.loadGraphic(Paths.image('UI/' + pixelModifier + 'num' + stringArray[scoreInt]));
			var numScore = ForeverAssets.generateCombo('combo', stringArray[scoreInt], (!negative ? allSicks : false), assetModifier, changeableSkin, 'UI',
				negative, createdColor, scoreInt);
			if(curStage == 'idk') {
				numScore.visible = false;
            }
			add(numScore);
			// hardcoded lmao
			if (!Init.trueSettings.get('Simply Judgements'))
			{
				add(numScore);
				FlxTween.tween(numScore, {alpha: 0}, 0.2, {
					onComplete: function(tween:FlxTween)
					{
						numScore.kill();
					},
					startDelay: Conductor.crochet * 0.002
				});
			}
			else
			{
				add(numScore);
				// centers combo
				numScore.y += 10;
				numScore.x -= 95;
				numScore.x -= ((comboString.length - 1) * 22);
				lastCombo.push(numScore);
				FlxTween.tween(numScore, {y: numScore.y + 20}, 0.1, {type: FlxTweenType.BACKWARD, ease: FlxEase.circOut});
			}
			// hardcoded lmao
			if (Init.trueSettings.get('Fixed Judgements'))
			{
				if (!cache)
					numScore.cameras = [camHUD];
				numScore.y += 50;
			}
				numScore.x += 100;
		}
	}

	function decreaseCombo(?popMiss:Bool = false)
	{
			if (PlayState.SONG.stage.toLowerCase() == 'victory') //sowwy
				{
				if (health < 2)
					{
					health = 2;
					}
				}
			else
				{
		// painful if statement
		if (((combo > 5) || (combo < 0)) && (gf.animOffsets.exists('sad')))
			gf.playAnim('sad');

		if (combo > 0)
			combo = 0; // bitch lmao
		else
			combo--;

		// misses
		songScore -= 10;
		misses++;

		// display negative combo
		if (popMiss)
		{
			// doesnt matter miss ratings dont have timings
			displayRating("miss", 'late');
			healthCall(Timings.judgementsMap.get("miss")[3]);
		}
		popUpCombo();

		// gotta do it manually here lol
		Timings.updateFCDisplay();
				}
	}

	function increaseCombo(?baseRating:String, ?direction = 0, ?character:Character)
	{
		// trolled this can actually decrease your combo if you get a bad/shit/miss
		if (baseRating != null)
		{
			if (Timings.judgementsMap.get(baseRating)[3] > 0)
			{
				if (combo < 0)
					combo = 0;
				combo += 1;
			}
			else
				missNoteCheck(true, direction, character, false, true);
		}
	}

	public function displayRating(daRating:String, timing:String, ?cache:Bool = false)
	{
		/* so you might be asking
			"oh but if the rating isn't sick why not just reset it"
			because miss judgements can pop, and they dont mess with your sick combo
		 */
		var rating = ForeverAssets.generateRating('$daRating', (daRating == 'sick' ? allSicks : false), timing, assetModifier, changeableSkin, 'UI');
		if(curStage == 'idk') {
			rating.visible = false;
		}
		add(rating);
		if (!Init.trueSettings.get('Simply Judgements'))
		{
		if (curStage == 'ejected')
			rating.acceleration.y = -550;
		if (curStage == 'airship')
		{
			rating.velocity.x = -250;
			rating.acceleration.x = -550;
		}
		}

		if (!Init.trueSettings.get('Simply Judgements'))
		{
			add(rating);

			FlxTween.tween(rating, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					rating.kill();
				},
				startDelay: Conductor.crochet * 0.00125
			});
		}
		else
		{
			if (lastRating != null) {
				lastRating.kill();
			}
			add(rating);
			lastRating = rating;
			FlxTween.tween(rating, {y: rating.y + 20}, 0.2, {type: FlxTweenType.BACKWARD, ease: FlxEase.circOut});
			FlxTween.tween(rating, {"scale.x": 0, "scale.y": 0}, 0.1, {
				onComplete: function(tween:FlxTween)
				{
					rating.kill();
				},
				startDelay: Conductor.crochet * 0.00125
			});
		}
		// */

		if (!cache) {
			if (Init.trueSettings.get('Fixed Judgements')) {
				// bound to camera
				rating.cameras = [camHUD];
				rating.screenCenter();
			}
			
			// return the actual rating to the array of judgements
			Timings.gottenJudgements.set(daRating, Timings.gottenJudgements.get(daRating) + 1);

			// set new smallest rating
			if (Timings.smallestRating != daRating) {
				if (Timings.judgementsMap.get(Timings.smallestRating)[0] < Timings.judgementsMap.get(daRating)[0])
					Timings.smallestRating = daRating;
			}
		}
	}

	function healthCall(?ratingMultiplier:Float = 0)
	{
		// health += 0.012;
		var healthBase:Float = 0.06;
		health += (healthBase * (ratingMultiplier / 100));
	}

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		if (PlayState.SONG.stage.toLowerCase() == 'finalem')
		{
		if (SONG.song.toLowerCase() == 'finale')
		{
		FlxTween.tween(dadStrums.receptors.members[0], {x: -1000}, 0.5, {ease: FlxEase.cubeInOut});
		FlxTween.tween(dadStrums.receptors.members[1], {x: -1000}, 0.5, {ease: FlxEase.cubeInOut});
		FlxTween.tween(dadStrums.receptors.members[2], {x: -1000}, 0.5, {ease: FlxEase.cubeInOut});
		FlxTween.tween(dadStrums.receptors.members[3], {x: -1000}, 0.5, {ease: FlxEase.cubeInOut});
		}
		}

		if (!paused)
		{
			songMusic.play();
			songMusic.onComplete = songEndSpecificActions;
			vocals.play();

			resyncVocals();

			#if !html5
			// Song duration in a float, useful for the time left feature
			songLength = songMusic.length;

			// Updating Discord Rich Presence (with Time Left)
			updateRPC(false);
			#end
		}
	}

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		songDetails = CoolUtil.dashToSpace(SONG.song) + ' - ' + CoolUtil.difficultyFromNumber(storyDifficulty);

		// String for when the game is paused
		detailsPausedText = "Paused - " + songDetails;

		// set details for song stuffs
		detailsSub = "";

		// Updating Discord Rich Presence.
		updateRPC(false);

		curSong = songData.song;
		songMusic = new FlxSound().loadEmbedded(Paths.inst(SONG.song), false, true);

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(SONG.song), false, true);
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(songMusic);
		FlxG.sound.list.add(vocals);

		// generate the chart
		unspawnNotes = ChartLoader.generateChartType(SONG, determinedChartType);

		// sometime my brain farts dont ask me why these functions were separated before

		// sort through them
		unspawnNotes.sort(sortByShit);
		// give the game the heads up to be able to start
		generatedMusic = true;

		Timings.accuracyMaxCalculation(unspawnNotes);
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);

	function resyncVocals():Void
	{
		trace('resyncing vocal time ${vocals.time}');
		songMusic.pause();
		vocals.pause();
		Conductor.songPosition = songMusic.time;
		vocals.time = Conductor.songPosition;
		songMusic.play();
		vocals.play();
		trace('new vocal time ${Conductor.songPosition}');
	}

	override function stepHit()
	{
		super.stepHit();
		///*
		if (songMusic.time >= Conductor.songPosition + 20 || songMusic.time <= Conductor.songPosition - 20)
			resyncVocals();
		//*/
		if (curStage == 'polus')
		{
		if (SONG.song.toLowerCase() == 'sussus-moogus')
		{
		if (curStep == 376)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 380)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 384)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 392)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 400)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 408)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 416)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 424)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 432)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 440)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 448)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 456)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 464)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 472)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 480)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 488)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 496)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 504)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 512)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 520)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 528)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 536)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 544)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 552)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 560)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 568)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 576)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 584)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 592)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 600)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 608)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 616)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 624)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 632)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1152)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1216)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1272)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1276)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1280)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1288)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1296)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1304)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1312)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1320)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1328)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1336)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1344)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1352)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1360)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1368)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1376)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1384)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1392)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1400)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1408)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1416)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1424)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1432)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1440)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1448)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1456)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1464)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1472)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1480)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1488)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1496)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1504)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1512)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1520)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1528)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		}
		if (SONG.song.toLowerCase() == 'sabotage')
		{
		if (curStep == 64)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 96)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 128)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 160)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 192)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 224)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 256)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 288)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 320)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 352)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 384)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 415)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 447)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 479)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 511)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 575)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 639)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 671)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 703)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 735)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 815)
		{
		gf.setCharacter(0, 0, 'ghostgf');
		gf.setPosition(300, -120);
		gf.x += 200;
		gf.y += -80;
		gf.playAnim('cheer', false);
		dadOpponent.playAnim('hey', false);
		gf.specialAnim = true;
		}
		if (curStep == 831)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 863)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 895)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 927)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 959)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 991)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1023)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1055)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1087)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1119)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1151)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1183)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1215)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1247)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1279)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1311)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1343)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1375)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1407)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1439)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1471)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1535)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		}
		if (SONG.song.toLowerCase() == 'meltdown')
		{
		if (curStep == 1)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 32)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 64)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 96)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 128)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 144)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 160)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 176)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 192)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 208)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 224)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 240)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 256)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 272)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 288)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 304)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 320)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 336)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 352)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 368)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 384)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 400)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 416)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 432)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 448)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 464)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 480)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 496)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 512)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 544)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 576)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 608)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 640)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 672)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 704)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 736)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 768)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 784)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 800)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 816)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 832)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 848)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 864)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 880)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 896)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 912)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 928)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 944)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 960)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 976)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 992)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1008)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1024)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1056)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1088)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1120)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1152)
		{
		FlxG.camera.zoom += 0.045;
		camHUD.zoom += 0.06;
		}
		if (curStep == 1156)
		{
		camGame.visible = false;
		for (hud in allUIs)
		hud.visible = false;
		}
		}
		}
		if (curStage == 'toogus')
		{
		if (SONG.song.toLowerCase() == 'sussus-toogus')
		{
		if (curStep == 1)
		{
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
		}
		if (curStep == 112)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		dadOpponent.playAnim('bopL', false);
		}
		if (curStep == 116)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		dadOpponent.playAnim('bopR', false);
		}
		if (curStep == 120)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		dadOpponent.playAnim('bopL', false);
		}
		if (curStep == 124)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		dadOpponent.playAnim('bopR', false);
		}
		if (curStep == 127)
		{
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
		}
		if (curStep == 240)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 244)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 248)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 252)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 368)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 372)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 376)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 380)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 496)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 500)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 504)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 508)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 624)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 628)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 632)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 636)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 880)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 884)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 888)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 892)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 896)
		{
		stageBuild.saxguy.setPosition(-550, 275);
		add(stageBuild.saxguy);
		dadOpponent.playAnim('notice', false);
		}
		if (curStep == 905)
		{
		dadOpponent.playAnim('wave', true);
		}
		if (curStep == 1016)
		{
		dadOpponent.playAnim('handbye', false);
		}
		if (curStep == 1264)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1268)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1272)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1276)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		}
		if (SONG.song.toLowerCase() == 'lights-down')
		{
		if (curStep == 256)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		pet.alpha = 0;
		dadOpponent.setCharacter(0, 0, 'whitegreen');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'whitebf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = charShader.shader;
		uiHUD.iconP2.shader = charShader.shader;
		loBlack.alpha = 1;
		}
		if (curStep == 511)
		{
		camGame.flash(FlxColor.BLACK, 0.35);
		pet.alpha = 1;
		dadOpponent.setCharacter(0, 0, 'impostor3');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = null;
		uiHUD.iconP2.shader = null;
		loBlack.alpha = 0;
		}
		if (curStep == 639)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		pet.alpha = 0;
		dadOpponent.setCharacter(0, 0, 'whitegreen');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'whitebf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = charShader.shader;
		uiHUD.iconP2.shader = charShader.shader;
		loBlack.alpha = 1;
		}
		if (curStep == 767)
		{
		camGame.flash(FlxColor.BLACK, 0.35);
		pet.alpha = 1;
		dadOpponent.setCharacter(0, 0, 'impostor3');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = null;
		uiHUD.iconP2.shader = null;
		loBlack.alpha = 0;
		}
		if (curStep == 783)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		pet.alpha = 0;
		dadOpponent.setCharacter(0, 0, 'whitegreen');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'whitebf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = charShader.shader;
		uiHUD.iconP2.shader = charShader.shader;
		loBlack.alpha = 1;
		}
		if (curStep == 799)
		{
		camGame.flash(FlxColor.BLACK, 0.35);
		pet.alpha = 1;
		dadOpponent.setCharacter(0, 0, 'impostor3');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = null;
		uiHUD.iconP2.shader = null;
		loBlack.alpha = 0;
		}
		if (curStep == 808)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		pet.alpha = 0;
		dadOpponent.setCharacter(0, 0, 'whitegreen');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'whitebf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = charShader.shader;
		uiHUD.iconP2.shader = charShader.shader;
		loBlack.alpha = 1;
		}
		if (curStep == 815)
		{
		camGame.flash(FlxColor.BLACK, 0.35);
		pet.alpha = 1;
		dadOpponent.setCharacter(0, 0, 'impostor3');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = null;
		uiHUD.iconP2.shader = null;
		loBlack.alpha = 0;
		}
		if (curStep == 831)
		{
		camGame.flash(FlxColor.BLACK, 0.35);
		pet.alpha = 1;
		dadOpponent.setCharacter(0, 0, 'impostor3');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = null;
		uiHUD.iconP2.shader = null;
		loBlack.alpha = 0;
		}
		if (curStep == 1087)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		pet.alpha = 0;
		dadOpponent.setCharacter(0, 0, 'whitegreen');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'whitebf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = charShader.shader;
		uiHUD.iconP2.shader = charShader.shader;
		loBlack.alpha = 1;
		}
		if (curStep == 1103)
		{
		camGame.flash(FlxColor.BLACK, 0.35);
		pet.alpha = 1;
		dadOpponent.setCharacter(0, 0, 'impostor3');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = null;
		uiHUD.iconP2.shader = null;
		loBlack.alpha = 0;
		}
		if (curStep == 1119)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		pet.alpha = 0;
		dadOpponent.setCharacter(0, 0, 'whitegreen');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'whitebf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = charShader.shader;
		uiHUD.iconP2.shader = charShader.shader;
		loBlack.alpha = 1;
		}
		if (curStep == 1135)
		{
		camGame.flash(FlxColor.BLACK, 0.35);
		pet.alpha = 1;
		dadOpponent.setCharacter(0, 0, 'impostor3');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = null;
		uiHUD.iconP2.shader = null;
		loBlack.alpha = 0;
		}
		if (curStep == 1151)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		pet.alpha = 0;
		dadOpponent.setCharacter(0, 0, 'whitegreen');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'whitebf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = charShader.shader;
		uiHUD.iconP2.shader = charShader.shader;
		loBlack.alpha = 1;
		}
		if (curStep == 1167)
		{
		camGame.flash(FlxColor.BLACK, 0.35);
		pet.alpha = 1;
		dadOpponent.setCharacter(0, 0, 'impostor3');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = null;
		uiHUD.iconP2.shader = null;
		loBlack.alpha = 0;
		}
		if (curStep == 1183)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		pet.alpha = 0;
		dadOpponent.setCharacter(0, 0, 'whitegreen');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'whitebf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = charShader.shader;
		uiHUD.iconP2.shader = charShader.shader;
		loBlack.alpha = 1;
		}
		if (curStep == 1188)
		{
		camGame.flash(FlxColor.BLACK, 0.35);
		pet.alpha = 1;
		dadOpponent.setCharacter(0, 0, 'impostor3');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = null;
		uiHUD.iconP2.shader = null;
		loBlack.alpha = 0;
		}
		if (curStep == 1192)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		pet.alpha = 0;
		dadOpponent.setCharacter(0, 0, 'whitegreen');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'whitebf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = charShader.shader;
		uiHUD.iconP2.shader = charShader.shader;
		loBlack.alpha = 1;
		}
		if (curStep == 1196)
		{
		camGame.flash(FlxColor.BLACK, 0.35);
		pet.alpha = 1;
		dadOpponent.setCharacter(0, 0, 'impostor3');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = null;
		uiHUD.iconP2.shader = null;
		loBlack.alpha = 0;
		}
		if (curStep == 1199)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		pet.alpha = 0;
		dadOpponent.setCharacter(0, 0, 'whitegreen');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'whitebf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = charShader.shader;
		uiHUD.iconP2.shader = charShader.shader;
		loBlack.alpha = 1;
		}
		if (curStep == 1208)
		{
		camGame.flash(FlxColor.BLACK, 0.35);
		pet.alpha = 1;
		dadOpponent.setCharacter(0, 0, 'impostor3');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = null;
		uiHUD.iconP2.shader = null;
		loBlack.alpha = 0;
		}
		if (curStep == 1215)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		pet.alpha = 0;
		dadOpponent.setCharacter(0, 0, 'whitegreen');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'whitebf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = charShader.shader;
		uiHUD.iconP2.shader = charShader.shader;
		loBlack.alpha = 1;
		}
		if (curStep == 1439)
		{
		camGame.flash(FlxColor.BLACK, 0.35);
		pet.alpha = 1;
		dadOpponent.setCharacter(0, 0, 'impostor3');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = null;
		uiHUD.iconP2.shader = null;
		loBlack.alpha = 0;
		}
		if (curStep == 1471)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		pet.alpha = 0;
		dadOpponent.setCharacter(0, 0, 'whitegreen');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'whitebf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = charShader.shader;
		uiHUD.iconP2.shader = charShader.shader;
		loBlack.alpha = 1;
		}
		if (curStep == 1599)
		{
		dadOpponent.setCharacter(0, 0, 'impostor3');
		dadOpponent.setPosition(0, 50);
		dadOpponent.y += 80;
		dadOpponent.x += 0;
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(970, 50);
		boyfriend.x += 0;
		boyfriend.y += 350;
		uiHUD.iconP1.shader = null;
		uiHUD.iconP2.shader = null;
		loBlack.alpha = 0;

		boyfriend.visible = false;
		gf.visible = false;
		for (hud in allUIs)
		hud.visible = false;

		dadOpponent.playAnim('liveReaction', false);
		stageBuild.bfvent.animation.play('vent');
		stageBuild.bfvent.alpha = 1;
		stageBuild.ldSpeaker.animation.play('boom');
		stageBuild.ldSpeaker.visible = true;
		}
		if (curStep == 1631)
		{
		camGame.visible = false;
		}
		}
		}
		if (curStage == 'reactor2')
		{
		if (SONG.song.toLowerCase() == 'reactor')
		{
		if (curStep == 1)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 32)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 64)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 96)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 128)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 160)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 192)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 224)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 256)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curBeat == 64)
		{
					defaultCamZoom = 0.8;
		}
		if (curStep == 288)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 320)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 352)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 384)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 416)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 448)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 480)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 496)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 504)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 512)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curBeat == 128)
		{
					defaultCamZoom = 0.7;
		}
		if (curStep == 544)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 576)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 608)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 640)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 672)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 704)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 736)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 768)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curBeat == 192)
		{
					defaultCamZoom = 0.8;
		}
		if (curStep == 800)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 832)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 864)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 896)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curBeat == 224)
		{
					defaultCamZoom = 0.8;
		}
		if (curStep == 928)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 960)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 992)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1024)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curBeat == 256)
		{
					defaultCamZoom = 0.8;
		}
		if (curStep == 1056)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1088)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1120)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1152)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1184)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1216)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1248)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1280)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curBeat == 320)
		{
					defaultCamZoom = 0.7;
		}
		if (curStep == 1312)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1344)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1376)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1408)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1440)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1472)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1504)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1536)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curBeat == 384)
		{
					defaultCamZoom = 0.8;
		}
		if (curStep == 1568)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1600)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1632)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1664)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1696)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1728)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1760)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1792)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1824)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1856)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1888)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curBeat == 479)
		{
					defaultCamZoom = 0.9;
		}
		if (curStep == 1920)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1952)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1984)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2016)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2048)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2080)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2112)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2144)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2176)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curBeat == 544)
		{
					defaultCamZoom = 0.8;
		}
		if (curStep == 2208)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2240)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2272)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2304)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2336)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2368)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2400)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2432)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curBeat == 608)
		{
					defaultCamZoom = 0.9;
		}
		if (curStep == 2464)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2496)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2528)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2560)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2592)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2624)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2656)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2688)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curBeat == 672)
		{
					defaultCamZoom = 0.7;
		}
		if (curStep == 2720)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2752)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2784)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2816)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2848)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		}
		}
		if (curStage == 'ejected')
		{
		if (SONG.song.toLowerCase() == 'ejected')
		{
		if (curStep == 256)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		camGame.visible = true;
		for (hud in allUIs)
		hud.alpha = 1;
		}
		}
		}
		if (curStage == 'airshipRoom')
		{
		if (SONG.song.toLowerCase() == 'dlow')
		{
		if (curStep == 68)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 76)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 84)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 92)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 96)
		{
		forceZoom = [0.04, 0, 0, 0];
		}
		if (curStep == 100)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 104)
		{
		forceZoom = [0.08, 0, 0, 0];
		}
		if (curStep == 108)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 110)
		{
		camBopIntensity = 0;
		camBopInterval = 100;
		}
		if (curStep == 111)
		{
		forceZoom = [0.15, 0, 0, 0];
		}
		if (curStep == 112)
		{
		FlxG.camera.zoom += 0.010;
		camHUD.zoom += 0.03;
		}
		if (curStep == 127)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 128)
		{
		camTwist = true;
		camTwistIntensity = 0.1;
		camTwistIntensity2 = 0.6;
		}
		if (curStep == 129)
		{
		camBopIntensity = 1.2;
		camBopInterval = 1;
		}
		if (curStep == 272)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 278)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 284)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 304)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 310)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 316)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 336)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 342)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 348)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 368)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 374)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 380)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 384)
		{
		camTwist = false;
		camTwistIntensity = 0;
		camTwistIntensity2 = 0;
		for (hud in allUIs)
		FlxTween.tween(hud, {angle: 0}, 1, {ease: FlxEase.sineInOut});
		FlxTween.tween(camGame, {angle: 0}, 1, {ease: FlxEase.sineInOut});
		}
		if (curStep == 399)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 415)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 431)
		{
		forceZoom = [0.02, 0, 0, 0];
		}
		if (curStep == 440)
		{
		forceZoom = [0.06, 0, 0, 0];
		}
		if (curStep == 447)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 463)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 479)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 495)
		{
		forceZoom = [0.02, 0, 0, 0];
		}
		if (curStep == 504)
		{
		forceZoom = [0.06, 0, 0, 0];
		}
		if (curStep == 511)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 629)
		{
		camBopIntensity = 100;
		camBopInterval = 100;
		}
		if (curStep == 632)
		{
		forceZoom = [0.15, 0, 0, 0];
		}
		if (curStep == 638)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 639)
		{
		camBopIntensity = 1;
		camBopInterval = 1;
		camTwist = true;
		camTwistIntensity = 0.1;
		camTwistIntensity2 = 0.6;
		}
		if (curStep == 783)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 790)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 796)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 815)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 822)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 828)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 847)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 854)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 860)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 879)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 886)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 892)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 895)
		{
		camBopIntensity = 0.8;
		camBopInterval = 1;
		camTwist = false;
		camTwistIntensity = 0;
		camTwistIntensity2 = 0;
		for (hud in allUIs)
		FlxTween.tween(hud, {angle: 0}, 1, {ease: FlxEase.sineInOut});
		FlxTween.tween(camGame, {angle: 0}, 1, {ease: FlxEase.sineInOut});
		}
		if (curStep == 1023)
		{
		camBopIntensity = 0.6;
		camBopInterval = 2;
		}
		if (curStep == 1028)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 1036)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 1044)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 1052)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 1060)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 1068)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 1076)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 1084)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 1092)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 1100)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 1108)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 1116)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 1119)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 1124)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 1128)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 1132)
		{
		FlxG.camera.zoom += 0.006;
		camHUD.zoom += 0.013;
		}
		if (curStep == 1135)
		{
		camBopIntensity = 1;
		camBopInterval = 100;
		}
		if (curStep == 1148)
		{
		forceZoom = [0.2, 0, 0, 0];
		}
		if (curStep == 1151)
		{
		camBopIntensity = 1.3;
		camBopInterval = 1;
		camTwist = true;
		camTwistIntensity = 0.2;
		camTwistIntensity2 = 0.8;
		}
		if (curStep == 1153)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 1279)
		{
		camTwist = true;
		camTwistIntensity = 0.3;
		camTwistIntensity2 = 1;
		}
		if (curStep == 1295)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 1302)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 1308)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 1327)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 1334)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 1340)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 1359)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 1366)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 1372)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 1391)
		{
		camTwist = true;
		camTwistIntensity = 0.7;
		camTwistIntensity2 = 1.4;
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 1398)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 1400)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 1404)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 1405)
		{
		forceZoom = [0.15, 0, 0, 0];
		}
		if (curStep == 1407)
		{
		camTwist = true;
		camTwistIntensity = 0.9;
		camTwistIntensity2 = 1.7;
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 1414)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 1416)
		{
		forceZoom = [0.25, 0, 0, 0];
		}
		if (curStep == 1419)
		{
		forceZoom = [0.3, 0, 0, 0];
		}
		if (curStep == 1420)
		{
		FlxG.camera.zoom += 0.01;
		camHUD.zoom += 0.02;
		}
		if (curStep == 1422)
		{
		camTwist = false;
		camTwistIntensity = 0;
		camTwistIntensity2 = 0;
		for (hud in allUIs)
		FlxTween.tween(hud, {angle: 0}, 1, {ease: FlxEase.sineInOut});
		FlxTween.tween(camGame, {angle: 0}, 1, {ease: FlxEase.sineInOut});
		}
		if (curStep == 1423)
		{
		camBopIntensity = 100;
		camBopInterval = 100;
		camGame.flash(FlxColor.WHITE, 0.35);
		dadOpponent.playAnim('death', false);
		boyfriend.setCharacter(0, 0, 'bfshock');
		boyfriend.setPosition(700, 90);
		boyfriend.x += 0;
		boyfriend.y += 350;
		FlxG.camera.zoom += 0.17;
		camHUD.zoom += 0.04;
		}
		if (curStep == 1425)
		{
		forceZoom = [0, 0, 0, 0];
		}
		}
		if (SONG.song.toLowerCase() == 'oversight')
		{
		if (curStep == 1)
		{
		camBopIntensity = 0.5;
		camBopInterval = 8;
		}
		if (curStep == 64)
		{
		camBopIntensity = 0.6;
		camBopInterval = 4;
		}
		if (curStep == 127)
		{
		camBopIntensity = 0.8;
		camBopInterval = 1;
		}
		if (curStep == 255)
		{
		camBopIntensity = 1.1;
		camBopInterval = 1;
		}
		if (curStep == 384)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 387)
		{
		forceZoom = [0.075, 0, 0, 0];
		}
		if (curStep == 390)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 392)
		{
		forceZoom = [0.15, 0, 0, 0];
		}
		if (curStep == 394)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 395)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 396)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 398)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 400)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 410)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 411)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 416)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 419)
		{
		forceZoom = [0.075, 0, 0, 0];
		}
		if (curStep == 422)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 424)
		{
		forceZoom = [0.15, 0, 0, 0];
		}
		if (curStep == 426)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 427)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 428)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 430)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 432)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 440)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 442)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 444)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 446)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 448)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 451)
		{
		forceZoom = [0.075, 0, 0, 0];
		}
		if (curStep == 454)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 456)
		{
		forceZoom = [0.15, 0, 0, 0];
		}
		if (curStep == 458)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 459)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 460)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 462)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 464)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 474)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 475)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 480)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 483)
		{
		forceZoom = [0.075, 0, 0, 0];
		}
		if (curStep == 486)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 488)
		{
		forceZoom = [0.15, 0, 0, 0];
		}
		if (curStep == 490)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 491)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 492)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 494)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 496)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 504)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 506)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 508)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 510)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 511)
		{
		forceZoom = [0.12, 0, 0, 0];
		}
		if (curStep == 512)
		{
		camBopIntensity = 1.2;
		camBopInterval = 1;
		}
		if (curStep == 639)
		{
		camBopIntensity = 0.6;
		camBopInterval = 4;
		}
		if (curStep == 640)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 704)
		{
		camBopIntensity = 0.3;
		camBopInterval = 1;
		}
		if (curStep == 720)
		{
		camBopIntensity = 0.4;
		camBopInterval = 1;
		}
		if (curStep == 736)
		{
		camBopIntensity = 0.5;
		camBopInterval = 1;
		}
		if (curStep == 752)
		{
		camBopIntensity = 0.6;
		camBopInterval = 1;
		}
		if (curStep == 768)
		{
		camBopIntensity = 1.2;
		camBopInterval = 1;
		}
		if (curStep == 895)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 899)
		{
		forceZoom = [0.075, 0, 0, 0];
		}
		if (curStep == 902)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 904)
		{
		forceZoom = [0.15, 0, 0, 0];
		}
		if (curStep == 906)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 907)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 908)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 910)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 911)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 922)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 923)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 927)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 931)
		{
		forceZoom = [0.075, 0, 0, 0];
		}
		if (curStep == 934)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 936)
		{
		forceZoom = [0.15, 0, 0, 0];
		}
		if (curStep == 938)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 939)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 940)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 942)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 943)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 952)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 954)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 956)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 958)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 959)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 963)
		{
		forceZoom = [0.075, 0, 0, 0];
		}
		if (curStep == 966)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 968)
		{
		forceZoom = [0.5, 0, 0, 0];
		}
		if (curStep == 970)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 971)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 972)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 974)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 975)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 986)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 987)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 991)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 995)
		{
		forceZoom = [0.075, 0, 0, 0];
		}
		if (curStep == 998)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 1000)
		{
		forceZoom = [0.15, 0, 0, 0];
		}
		if (curStep == 1002)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 1003)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 1004)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 1006)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 1007)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 1016)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 1018)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 1020)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 1022)
		{
		FlxG.camera.zoom += 0.005;
		camHUD.zoom += 0.005;
		}
		if (curStep == 1023)
		{
		camBopIntensity = 1.2;
		camBopInterval = 100;
		}
		}
		}
		if (curStage == 'airship')
		{
		if (SONG.song.toLowerCase() == 'danger')
		{
		if (curStep == 1)
		{
					defaultCamZoom = 0.3;
		}
		if (curBeat == 64)
		{
					defaultCamZoom = 0.4;
		}
		if (curBeat == 96)
		{
					defaultCamZoom = 0.6;
		}
		if (curBeat == 128)
		{
					defaultCamZoom = 0.4;
		}
		if (curBeat == 155)
		{
					defaultCamZoom = 0.8;
		}
		if (curStep == 624)
		{
		dadOpponent.playAnim('scream', false);
		}
		if (curStep == 632)
		{
		stageBuild.airshipskyflash.alpha = 1;
		stageBuild.airshipskyflash.animation.play('bop', false);
		}
		if (curStep == 639)
		{
		dadOpponent.setCharacter(0, 0, 'blackalt');
		dadOpponent.setPosition(500, -100);
		dadOpponent.y += -100;
		dadOpponent.x += -190;
		}
		if (curStep == 640)
		{
		stageBuild.airshipskyflash.alpha = 0;
		}
		if (curBeat == 160)
		{
					defaultCamZoom = 0.4;
		}
		if (curStep == 656)
		{
		FlxTween.tween(gf, {x: -2000}, 4, { ease: FlxEase.quartIn });
		}
		if (curBeat == 192)
		{
					defaultCamZoom = 0.6;
		}
		if (curBeat == 256)
		{
					defaultCamZoom = 0.4;
		}
		if (curBeat == 288)
		{
					defaultCamZoom = 0.6;
		}
		if (curBeat == 320)
		{
					defaultCamZoom = 0.3;
		}
		if (curBeat == 384)
		{
					defaultCamZoom = 0.6;
		}
		}
		}
		if (curStage == 'cargo')
		{
		if (SONG.song.toLowerCase() == 'double-kill')
		{
		if (curStep == 16)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		defaultCamZoom = 0.8;
		stageBuild.cargoDarkFG.alpha = 0;
		for (hud in allUIs)
		hud.alpha = 1;
		}
		if (curStep == 144)
		{
		opponent2sing = true;
		changeDadIcon("black");
		}
		if (curStep == 272)
		{
		opponent2sing = false;
		changeDadIcon("white");
		}
		if (curStep == 336)
		{
		opponent2sing = true;
		changeDadIcon("black");
		}
		if (curStep == 528)
		{
		opponent2sing = false;
		changeDadIcon("white");
		}
		if (curStep == 656)
		{
		opponent2sing = true;
		changeDadIcon("black");
		}
		if (curStep == 780)
		{
		opponent2sing = false;
		changeDadIcon("white");
		}
		if (curStep == 784)
		{
		bothOpponentsSing = true;
		changeDadIcon("whiteblack");
		}
		if (curStep == 1024)
		{
		bothOpponentsSing = false;
		changeDadIcon("white");
		}
		if (curStep == 1056)
		{
		opponent2sing = true;
		changeDadIcon("black");
		}
		if (curStep == 1072)
		{
		opponent2sing = false;
		changeDadIcon("white");
		}
		if (curStep == 1088)
		{
		bothOpponentsSing = true;
		changeDadIcon("whiteblack");
		}
		if (curStep == 1104)
		{
		bothOpponentsSing = false;
		changeDadIcon("white");
		}
		if (curStep == 1120)
		{
		opponent2sing = true;
		changeDadIcon("black");
		}
		if (curStep == 1136)
		{
		opponent2sing = false;
		changeDadIcon("white");
		}
		if (curStep == 1152)
		{
		bothOpponentsSing = true;
		changeDadIcon("whiteblack");
		}
		if (curStep == 1168)
		{
		bothOpponentsSing = false;
		changeDadIcon("white");
		}
		if (curStep == 1296)
		{
		opponent2sing = true;
		changeDadIcon("black");
		}
		if (curStep == 1424)
		{
		cargoDarken = true;
		camGame.flash(FlxColor.BLACK, 0.55);
		}
		if (curBeat >= 356 && curBeat < 420)
		{
		defaultCamZoom = 1.1;
		}
		if (curStep == 1552)
		{
		showDlowDK = true;
		}
		if (curStep == 1680)
		{
		showDlowDK = false;
		cargoDarken = false;
		stageBuild.cargoAirsip.alpha = 0.001;
		stageBuild.cargoDark.alpha = 0.001;
		dadOpponent.alpha = 1;
		mom.alpha = 1;
		pet.alpha = 1;
		stageBuild.mainoverlayDK.alpha = 0.6;
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.3;
		}
		if (curBeat == 420)
		{
		defaultCamZoom = 0.8;
		}
		if (curStep == 1696)
		{
		opponent2sing = false;
		changeDadIcon("white");
		}
		if (curStep == 1824)
		{
		opponent2sing = true;
		changeDadIcon("black");
		}
		if (curStep == 1936)
		{
		opponent2sing = false;
		changeDadIcon("white");
		}
		if (curStep == 1952)
		{
		bothOpponentsSing = true;
		changeDadIcon("whiteblack");
		}
		if (curStep == 2192)
		{
		bothOpponentsSing = false;
		changeDadIcon("white");
		}
		if (curBeat >= 552 && curBeat < 556)
		{
		defaultCamZoom = 1.2;
		}
		if (curBeat == 556)
		{
		defaultCamZoom = 0.8;
		}
		if (curStep == 2351)
		{
		opponent2sing = true;
		changeDadIcon("black");
		}
		if (curStep == 2607)
		{
		opponent2sing = false;
		changeDadIcon("white");
		}
		if (curStep == 2735)
		{
		opponent2sing = true;
		changeDadIcon("black");
		}
		if (curStep == 2799)
		{
		opponent2sing = false;
		changeDadIcon("white");
		}
		if (curStep == 2879)
		{
		opponent2sing = true;
		changeDadIcon("black");
		}
		if (curStep == 2943)
		{
		opponent2sing = false;
		changeDadIcon("white");
		}
		if (curStep == 3007)
		{
		opponent2sing = true;
		changeDadIcon("black");
		}
		if (curStep == 3071)
		{
		opponent2sing = false;
		changeDadIcon("white");
		}
		if (curStep == 3135)
		{
		bothOpponentsSing = true;
		changeDadIcon("whiteblack");
		}
		if (curStep == 3199)
		{
		bothOpponentsSing = false;
		changeDadIcon("white");
		}
		if (curStep == 3263)
		{
		bothOpponentsSing = true;
		changeDadIcon("whiteblack");
		}
		if (curStep == 3327)
		{
		bothOpponentsSing = false;
		changeDadIcon("white");
		}
		if (curStep == 3391)
		{
		cargoReadyKill = true;
		}
		if (curStep == 3394)
		{
		opponent2sing = true;
		changeDadIcon("black");
		}
		if (curStep == 3407)
		{
		camGame.flash(FlxColor.BLACK, 2.75);
		boyfriend.setCharacter(0, 0, 'bf-defeat-normal');
		boyfriend.setPosition(2550, 650);
		boyfriend.x += 0;
		boyfriend.y += 350;
		stageBuild.defeatDKoverlay.alpha = 1;
		stageBuild.mainoverlayDK.alpha = 0;
		stageBuild.cargoDarkFG.alpha = 0;
		stageBuild.cargoDark.alpha = 1;
		cargoReadyKill = false;
		dadOpponent.alpha = 0;
		pet.alpha = 0;
		uiHUD.healthBar.alpha = 0;
		uiHUD.healthBarBG.alpha = 0;
		uiHUD.iconP1.alpha = 0;
		uiHUD.iconP2.alpha = 0;
		}
		if (curBeat == 916)
		{
		FlxTween.tween(camGame, {zoom: 0.4}, 20, {ease: FlxEase.linear});
		}
		if (curStep == 3920)
		{
		camGame.flash(FlxColor.RED, 2.75);
		mom.alpha = 0;
		boyfriend.alpha = 0;
		for (hud in allUIs)
		hud.visible = false;
		stageBuild.defeatDKoverlay.alpha = 0;
		}
		}
		}
		if (curStage == 'defeat')
		{
		if (SONG.song.toLowerCase() == 'defeat')
		{
		if (curBeat == 16)
		{
					defaultCamZoom = 0.6;
		}

		if (curBeat == 32)
		{
					defaultCamZoom = 0.7;
		}

		if (curBeat == 48)
		{
					defaultCamZoom = 0.8;
		}

		if (curBeat == 68)
		{
					                defaultCamZoom = 0.5;
							FlxTween.tween(stageBuild.bodies, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
							FlxTween.tween(stageBuild.bodies2, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
							FlxTween.tween(stageBuild.bodiesfront, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
							camGame.flash(FlxColor.WHITE, 0.35);
							boyfriend.setCharacter(0, 0, 'bf-defeat-scared');
							boyfriend.setPosition(1000, 100);
							boyfriend.x += 0;
							boyfriend.y += 350;
		}

		if (curBeat == 100)
		{
					defaultCamZoom = 0.6;
		}

		if (curStep == 464)
		{
							boyfriend.setCharacter(0, 0, 'bf-defeat-scared');
							boyfriend.setPosition(1000, 100);
							boyfriend.x += 0;
							boyfriend.y += 350;
		}

		if (curBeat == 164)
		{
					defaultCamZoom = 0.5;
		}

		if (curBeat == 194)
		{
					defaultCamZoom = 0.6;
		}

		if (curBeat == 196)
		{
					defaultCamZoom = 0.6;
		}

		if (curBeat == 212)
		{
					defaultCamZoom = 0.7;
		}

		if (curBeat == 228)
		{
					defaultCamZoom = 0.8;
		}

		if (curBeat == 244)
		{
					defaultCamZoom = 0.85;
		}

		if (curBeat == 260)
		{
					defaultCamZoom = 0.6;
		}

		if (curBeat == 292)
		{
					                defaultCamZoom = 0.75;
							FlxTween.tween(stageBuild.bodies, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
							FlxTween.tween(stageBuild.bodies2, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
							FlxTween.tween(stageBuild.bodiesfront, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
							stageBuild.lightoverlay.alpha = 0;
							stageBuild.mainoverlayDK.alpha = 1;
							camGame.flash(FlxColor.WHITE, 0.35);
							dadOpponent.setCharacter(0, 0, 'blackold');
							dadOpponent.setPosition(210, 100);
							dadOpponent.y += -30;
							dadOpponent.x += -340;
							boyfriend.setCharacter(0, 0, 'bf');
							boyfriend.setPosition(1000, 100);
							boyfriend.x += 0;
							boyfriend.y += 350;
							stageBuild.defeatblack.alpha += 1;
							stageBuild.defeatDark = true;
							uiHUD.scoreBar.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
							uiHUD.iconP1.visible = false;
							uiHUD.iconP2.visible = false;
		}

		if (curStep == 1424)
		{
		FlxG.camera.zoom += 1;
		camHUD.zoom += 0.03;
		}

		if (curBeat == 360)
		{
					                defaultCamZoom = 0.6;
							FlxTween.tween(stageBuild.bodies, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
							FlxTween.tween(stageBuild.bodies2, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
							FlxTween.tween(stageBuild.bodiesfront, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
							stageBuild.lightoverlay.alpha = 1;
							stageBuild.mainoverlayDK.alpha = 0;
							camGame.flash(FlxColor.WHITE, 0.35);
							dadOpponent.setCharacter(0, 0, 'black');
							dadOpponent.setPosition(210, 100);
							dadOpponent.y += 80;
							dadOpponent.x += 180;
							boyfriend.setCharacter(0, 0, 'bf-defeat-scared');
							boyfriend.setPosition(1000, 100);
							boyfriend.x += 0;
							boyfriend.y += 350;
							stageBuild.defeatblack.alpha = 0;
							stageBuild.defeatDark = false;
							uiHUD.scoreBar.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
							uiHUD.iconP1.visible = true;
							uiHUD.iconP2.visible = true;
		}

		if (curBeat == 424)
		{
					defaultCamZoom = 0.7;
		}

		if (curBeat == 456)
		{
					defaultCamZoom = 0.8;
		}

		if (curBeat == 472)
		{
					defaultCamZoom = 0.9;
		}

		if (curBeat == 488)
		{
					defaultCamZoom = 50;
		}
		}
		}

		if (curStage == 'finalem')
		{
		if (SONG.song.toLowerCase() == 'finale')
		{
		if (curStep == 64)
		{
		stageBuild.finaleFlashbackStuff.alpha = 0.5;
		stageBuild.finaleFlashbackStuff.animation.play('moog');
		}

		if (curStep == 80)
		{
		stageBuild.finaleFlashbackStuff.animation.play('toog');
		}

		if (curStep == 96)
		{
		stageBuild.finaleFlashbackStuff.animation.play('doog');
		}

		if (curStep == 112)
		{
		FlxG.camera.fade(FlxColor.WHITE, 1.2, false, function()
		{
		FlxG.camera.fade(FlxColor.RED, 0.6, true);
		stageBuild.finaleFlashbackStuff.alpha = 0;
		});
		}

		if (curStep == 128)
		{
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
		}

		if (curBeat == 32)
		{
		defaultCamZoom = 0.8;
		}

		if (curBeat == 67)
		{
		defaultCamZoom = 2.4;
		}

		if (curStep == 272)
		{
					health = 0.1;
					stageBuild.finaleBGStuff.visible = true;
					stageBuild.finaleFGStuff.visible = true;
					stageBuild.defeatFinaleStuff.visible = false;
					lightoverlay.visible = false;
					uiHUD.healthBar.visible = false;
					uiHUD.healthBarBG.visible = false;
					uiHUD.iconP1.visible = true;
					uiHUD.iconP2.visible = true;
					uiHUD.finaleBarRed.visible = true;
					uiHUD.finaleBarBlue.visible = true;
					uiHUD.scoreBar.setFormat(Paths.font("vcr.ttf"), 16, 0xFFff1266, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
					camGame.flash(0xFFff1266, 0.75);
					dadOpponent.setCharacter(0, 0, 'blackparasite');
					dadOpponent.setPosition(0, 530);
					dadOpponent.y += -30;
					dadOpponent.x += -340;
					changeDadIcon("blackparasite");
		}

		if (curBeat == 492)
		{
		FlxTween.tween(camGame, {zoom: 2.4}, 1.2, {ease: FlxEase.circIn});
		}

		if (curStep == 1984)
		{
		camOther.flash(0xFFff1266, 5);
		for (hud in allUIs)
		hud.visible = false;
		camGame.visible = false;
		}
		}
		}

		if (curStage == 'monotone')
		{
		if (SONG.song.toLowerCase() == 'identity-crisis')
		{
		if (curBeat == 6)
		{
		FlxTween.tween(camGame, {zoom: 0.4}, 20, {ease: FlxEase.linear});
		}

		if (curBeat == 32)
		{
					defaultCamZoom = 0.4;
		}

		if (curStep == 255)
		{
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
		}

		if (curBeat == 81)
		{
					defaultCamZoom = 0.45;
		}

		if (curBeat == 88)
		{
					defaultCamZoom = 0.8;
		}

		if (curStep == 383)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		dadOpponent.setCharacter(0, 0, 'monotone');
		dadOpponent.setPosition(80, 400);
		dadOpponent.y += -40;
		dadOpponent.x += -150;
		changeDadIcon("monotone");
		}

		if (curBeat == 95)
		{
					defaultCamZoom = 0.5;
		}

		if (curBeat == 112)
		{
					defaultCamZoom = 0.5;
		}

		if (curBeat == 128)
		{
					defaultCamZoom = 0.6;
		}

		if (curStep == 547)
		{
		camGame.flash(FlxColor.WHITE, 0.55);
		stageBuild.darkMono.cameras = [camOther];
		stageBuild.darkMono.visible = true;
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
		}

		if (curStep == 576)
		{
		stageBuild.saxguy.cameras = [camOther];
		stageBuild.saxguy.setGraphicSize(Std.int(stageBuild.saxguy.width * 0.6));
		add(stageBuild.saxguy);
		stageBuild.saxguy.visible = true;
		stageBuild.saxguy.animation.play('bop');
		}

		if (curStep == 640)
		{
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
		camGame.flash(FlxColor.WHITE, 0.55);
		stageBuild.darkMono.visible = false;
		stageBuild.saxguy.visible = false;
		dadOpponent.setCharacter(0, 0, 'impostor');
		dadOpponent.setPosition(80, 400);
		dadOpponent.y += 100;
		dadOpponent.x += 0;
		changeDadIcon("impostor");
		stageBuild.plagueBGBLUE.visible = false;
		stageBuild.plagueBGRED.visible = true;
		stageBuild.plagueBGPURPLE.visible = false;
		stageBuild.plagueBGGREEN.visible = false;
		}

		if (curBeat == 192)
		{
					defaultCamZoom = 0.5;
		}

		if (curBeat == 208)
		{
					defaultCamZoom = 0.6;
		}

		if (curStep == 896)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		stageBuild.plagueBGBLUE.visible = true;
		stageBuild.plagueBGRED.visible = false;
		stageBuild.plagueBGPURPLE.visible = false;
		stageBuild.plagueBGGREEN.visible = false;
		dadOpponent.setCharacter(0, 0, 'monotone');
		dadOpponent.setPosition(80, 400);
		dadOpponent.y += -40;
		dadOpponent.x += -150;
		changeDadIcon("monotone");
		}

		if (curBeat == 224)
		{
					defaultCamZoom = 0.5;
		}

		if (curBeat == 254)
		{
					defaultCamZoom = 0.6;
		}

		if (curBeat == 262)
		{
					defaultCamZoom = 0.7;
		}

		if (curBeat == 270)
		{
					defaultCamZoom = 0.8;
		}

		if (curBeat == 278)
		{
					defaultCamZoom = 0.9;
		}

		if (curStep == 1151)
		{
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
		camGame.flash(FlxColor.WHITE, 0.55);
		stageBuild.darkMono.visible = true;
		}

		if (curStep == 1176)
		{
		stageBuild.plagueBGBLUE.visible = false;
		stageBuild.plagueBGRED.visible = false;
		stageBuild.plagueBGPURPLE.visible = false;
		stageBuild.plagueBGGREEN.visible = true;
		boyfriend.setCharacter(0, 0, 'bf-fall');
		boyfriend.setPosition(1400, 400);
		boyfriend.x += 0;
		boyfriend.y += 350;
		dadOpponent.setCharacter(0, 0, 'parasite');
		dadOpponent.setPosition(80, 400);
		dadOpponent.y += 100;
		dadOpponent.x += 70;
		changeDadIcon("parasite");
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
		camGame.flash(FlxColor.WHITE, 0.55);
		stageBuild.darkMono.visible = false;
		stageBuild.saxguy.visible = false;
		}

		if (curBeat == 294)
		{
					defaultCamZoom = 0.4;
		}

		if (curBeat == 312)
		{
					defaultCamZoom = 0.45;
		}

		if (curBeat == 328)
		{
					defaultCamZoom = 0.55;
		}

		if (curStep == 1327)
		{
		FlxG.camera.zoom += -0.015;
		camHUD.zoom += 0.03;
		}

		if (curStep == 1330)
		{
		FlxG.camera.zoom += -0.015;
		camHUD.zoom += 0.03;
		}

		if (curStep == 1332)
		{
		FlxG.camera.zoom += -0.015;
		camHUD.zoom += 0.03;
		}

		if (curStep == 1334)
		{
		FlxG.camera.zoom += -0.015;
		camHUD.zoom += 0.03;
		}

		if (curStep == 1336)
		{
		FlxG.camera.zoom += -0.030;
		camHUD.zoom += 0.03;
		}

		if (curBeat == 334)
		{
					defaultCamZoom = 0.45;
		}

		if (curBeat == 344)
		{
					defaultCamZoom = 0.7;
		}

		if (curBeat == 360)
		{
					defaultCamZoom = 0.5;
		}

		if (curStep == 1447)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
		camGame.flash(FlxColor.WHITE, 0.55);
		stageBuild.darkMono.visible = true;
		}

		if (curStep == 1694)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		stageBuild.plagueBGBLUE.visible = true;
		stageBuild.plagueBGRED.visible = false;
		stageBuild.plagueBGPURPLE.visible = false;
		stageBuild.plagueBGGREEN.visible = false;
		dadOpponent.setCharacter(0, 0, 'monotone');
		dadOpponent.setPosition(80, 400);
		dadOpponent.y += -40;
		dadOpponent.x += -150;
		changeDadIcon("monotone");
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(1400, 400);
		boyfriend.x += 0;
		boyfriend.y += 350;
		}

		if (curStep == 1695)
		{
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
		camGame.flash(FlxColor.WHITE, 0.55);
		stageBuild.darkMono.visible = false;
		stageBuild.saxguy.visible = false;
		}

		if (curBeat == 456)
		{
					defaultCamZoom = 0.6;
		}

		if (curStep == 1952)
		{
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
		camGame.flash(FlxColor.WHITE, 0.55);
		stageBuild.darkMono.visible = true;
		}

		if (curStep == 1976)
		{
		stageBuild.plagueBGBLUE.visible = false;
		stageBuild.plagueBGRED.visible = false;
		stageBuild.plagueBGPURPLE.visible = true;
		stageBuild.plagueBGGREEN.visible = false;
		dadOpponent.setCharacter(0, 0, 'blackdk');
		dadOpponent.setPosition(80, 400);
		dadOpponent.y += 0;
		dadOpponent.x += -320;
		changeDadIcon("black");
		}

		if (curStep == 1978)
		{
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
		camGame.flash(FlxColor.WHITE, 0.55);
		stageBuild.darkMono.visible = false;
		stageBuild.saxguy.visible = false;
		}

		if (curStep == 2247)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		}

		if (curStep == 2248)
		{
		camGame.flash(FlxColor.WHITE, 0.55);
		stageBuild.darkMono.visible = true;
		}

		if (curStep == 2276)
		{
		dadOpponent.setCharacter(0, 0, 'monotone');
		dadOpponent.setPosition(80, 400);
		dadOpponent.y += -40;
		dadOpponent.x += -150;
		changeDadIcon("monotone");
		stageBuild.plagueBGBLUE.visible = true;
		stageBuild.plagueBGRED.visible = false;
		stageBuild.plagueBGPURPLE.visible = false;
		stageBuild.plagueBGGREEN.visible = false;
		camGame.flash(FlxColor.WHITE, 0.55);
		stageBuild.darkMono.visible = false;
		stageBuild.saxguy.visible = false;
		}

		if (curStep == 2816)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		dadOpponent.setCharacter(0, 0, 'impostor');
		dadOpponent.setPosition(80, 400);
		dadOpponent.y += 100;
		dadOpponent.x += 0;
		changeDadIcon("impostor");
		stageBuild.plagueBGBLUE.visible = false;
		stageBuild.plagueBGRED.visible = true;
		stageBuild.plagueBGPURPLE.visible = false;
		stageBuild.plagueBGGREEN.visible = false;
		}

		if (curStep == 2878)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		boyfriend.setCharacter(0, 0, 'bf-fall');
		boyfriend.setPosition(1400, 400);
		boyfriend.x += 0;
		boyfriend.y += 350;
		dadOpponent.setCharacter(0, 0, 'parasite');
		dadOpponent.setPosition(80, 400);
		dadOpponent.y += 100;
		dadOpponent.x += 70;
		changeDadIcon("parasite");
		stageBuild.plagueBGBLUE.visible = false;
		stageBuild.plagueBGRED.visible = false;
		stageBuild.plagueBGPURPLE.visible = false;
		stageBuild.plagueBGGREEN.visible = true;
		}

		if (curStep == 3072)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		dadOpponent.setCharacter(0, 0, 'blackdk');
		dadOpponent.setPosition(80, 400);
		dadOpponent.y += 0;
		dadOpponent.x += -320;
		changeDadIcon("black");
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(1400, 400);
		boyfriend.x += 0;
		boyfriend.y += 350;
		stageBuild.plagueBGBLUE.visible = false;
		stageBuild.plagueBGRED.visible = false;
		stageBuild.plagueBGPURPLE.visible = true;
		stageBuild.plagueBGGREEN.visible = false;
		}

		if (curStep == 3198)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		stageBuild.plagueBGBLUE.visible = false;
		stageBuild.plagueBGRED.visible = true;
		stageBuild.plagueBGPURPLE.visible = false;
		stageBuild.plagueBGGREEN.visible = false;
		dadOpponent.setCharacter(0, 0, 'impostor');
		dadOpponent.setPosition(80, 400);
		dadOpponent.y += 100;
		dadOpponent.x += 0;
		changeDadIcon("impostor");
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(1400, 400);
		boyfriend.x += 0;
		boyfriend.y += 350;
		}

		if (curStep == 3280)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		boyfriend.setCharacter(0, 0, 'bf-fall');
		boyfriend.setPosition(1400, 400);
		boyfriend.x += 0;
		boyfriend.y += 350;
		dadOpponent.setCharacter(0, 0, 'parasite');
		dadOpponent.setPosition(80, 400);
		dadOpponent.y += 100;
		dadOpponent.x += 70;
		changeDadIcon("parasite");
		stageBuild.plagueBGBLUE.visible = false;
		stageBuild.plagueBGRED.visible = false;
		stageBuild.plagueBGPURPLE.visible = false;
		stageBuild.plagueBGGREEN.visible = true;
		}

		if (curStep == 3296)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		dadOpponent.setCharacter(0, 0, 'blackdk');
		dadOpponent.setPosition(80, 400);
		dadOpponent.y += 0;
		dadOpponent.x += -320;
		changeDadIcon("black");
		boyfriend.setCharacter(0, 0, 'bf');
		boyfriend.setPosition(1400, 400);
		boyfriend.x += 0;
		boyfriend.y += 350;
		stageBuild.plagueBGBLUE.visible = false;
		stageBuild.plagueBGRED.visible = false;
		stageBuild.plagueBGPURPLE.visible = true;
		stageBuild.plagueBGGREEN.visible = false;
		}

		if (curStep == 3328)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		dadOpponent.setCharacter(0, 0, 'monotone');
		dadOpponent.setPosition(80, 400);
		dadOpponent.y += -40;
		dadOpponent.x += -150;
		changeDadIcon("monotone");
		stageBuild.plagueBGBLUE.visible = true;
		stageBuild.plagueBGRED.visible = false;
		stageBuild.plagueBGPURPLE.visible = false;
		stageBuild.plagueBGGREEN.visible = false;
		}
		}
		}

		if (curStage == 'polus2')
		{
		if (SONG.song.toLowerCase() == 'magmatic')
		{
		if (curStep == 1184)
		{
		dadOpponent.playAnim('hey', true);
		}
		}
		}

		if (curStage == 'polus3')
		{
		if (SONG.song.toLowerCase() == 'boiling-point')
		{
		if (curStep == 120)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 124)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 128)
		{
		camBopIntensity = 1.1;
		camBopInterval = 1;
		}
		if (curStep == 302)
		{
		var theAmount:Float = -0.7;
		theAmount = -0.7;
		var theSpeed:Float = 0.2;
		theSpeed = 0.2;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 320)
		{
		var theAmount:Float = -2;
		theAmount = -2;
		var theSpeed:Float = 0.05;
		theSpeed = 0.05;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});

		camGame.shake(0.01, 1);
		camHUD.shake(0.01, 1);
		}
		if (curStep == 322)
		{
		var theAmount:Float = -0.1;
		theAmount = -0.1;
		var theSpeed:Float = 1.2;
		theSpeed = 1.2;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 366)
		{
		var theAmount:Float = -0.7;
		theAmount = -0.7;
		var theSpeed:Float = 0.3;
		theSpeed = 0.3;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 367)
		{
		camBopIntensity = 0;
		camBopInterval = 9999;
		}
		if (curStep == 383)
		{
		camBopIntensity = 1;
		camBopInterval = 1;
		}
		if (curStep == 384)
		{
		var theAmount:Float = -0.1;
		theAmount = -0.1;
		var theSpeed:Float = 1.5;
		theSpeed = 1.5;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 430)
		{
		var theAmount:Float = -0.8;
		theAmount = -0.8;
		var theSpeed:Float = 0.2;
		theSpeed = 0.2;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 447)
		{
		var theAmount:Float = -2.1;
		theAmount = -2.1;
		var theSpeed:Float = 0.05;
		theSpeed = 0.05;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 448)
		{
		var theAmount:Float = 0.01;
		theAmount = 0.01;
		var theSpeed:Float = 0.01;
		theSpeed = 0.01;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});

		camGame.shake(0.01, 1);
		camHUD.shake(0.01, 1);
		}
		if (curStep == 449)
		{
		var theAmount:Float = -0.2;
		theAmount = -0.2;
		var theSpeed:Float = 2;
		theSpeed = 2;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 512)
		{
		forceZoom = [0.1, 0, 0, 0];

		var theAmount:Float = -0.2;
		theAmount = -0.2;
		var theSpeed:Float = 2;
		theSpeed = 2;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 640)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 749)
		{
		camBopIntensity = 0;
		camBopInterval = 9999;
		}
		if (curStep == 750)
		{
		var theAmount:Float = -0.75;
		theAmount = -0.75;
		var theSpeed:Float = 0.2;
		theSpeed = 0.2;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 758)
		{
		var theAmount:Float = -0.85;
		theAmount = -0.85;
		var theSpeed:Float = 0.2;
		theSpeed = 0.2;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 767)
		{
		camBopIntensity = 1;
		camBopInterval = 1;
		}
		if (curStep == 768)
		{
		var theAmount:Float = -0.2;
		theAmount = -0.2;
		var theSpeed:Float = 1.2;
		theSpeed = 1.2;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 879)
		{
		camBopIntensity = 1.3;
		camBopInterval = 1;
		}
		if (curStep == 896)
		{
		camBopIntensity = 1.2;
		camBopInterval = 1;
		}
		if (curStep == 1088)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 1116)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 1120)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 1132)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 1136)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 1149)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 1150)
		{
		var theAmount:Float = -0.2;
		theAmount = -0.2;
		var theSpeed:Float = 0.2;
		theSpeed = 0.2;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 1151)
		{
		camBopIntensity = 0;
		camBopInterval = 999;
		}
		if (curStep == 1167)
		{
		camBopIntensity = 1;
		camBopInterval = 1;
		}
		if (curStep == 1168)
		{
		var theAmount:Float = -0.2;
		theAmount = -0.2;
		var theSpeed:Float = 1.2;
		theSpeed = 1.2;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 1214)
		{
		forceZoom = [-0.05, 0, 0, 0];
		}
		if (curStep == 1218)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 1278)
		{
		forceZoom = [-0.05, 0, 0, 0];
		}
		if (curStep == 1282)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 1295)
		{
		camBopIntensity = 1.1;
		camBopInterval = 1;
		}
		if (curStep == 1296)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 1341)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 1342)
		{
		var theAmount:Float = -0.8;
		theAmount = -0.8;
		var theSpeed:Float = 0.2;
		theSpeed = 0.2;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 1359)
		{
		var theAmount:Float = -0.2;
		theAmount = -0.2;
		var theSpeed:Float = 0.9;
		theSpeed = 0.9;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 1423)
		{
		camBopIntensity = 1.2;
		camBopInterval = 1;
		}
		if (curStep == 1424)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 1551)
		{
		camBopIntensity = 0;
		camBopInterval = 99;
		}
		if (curStep == 1552)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 1560)
		{
		var theAmount:Float = -0.35;
		theAmount = -0.35;
		var theSpeed:Float = 2;
		theSpeed = 2;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 1567)
		{
		camBopIntensity = 1.1;
		camBopInterval = 1;
		}
		if (curStep == 1676)
		{
		var theAmount:Float = -1.4;
		theAmount = -1.4;
		var theSpeed:Float = 0.2;
		theSpeed = 0.2;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 1692)
		{
		var theAmount:Float = -0.4;
		theAmount = -0.4;
		var theSpeed:Float = 1;
		theSpeed = 1;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 1695)
		{
		camBopIntensity = 1.15;
		camBopInterval = 1;
		}
		if (curStep == 1741)
		{
		var theAmount:Float = -1.5;
		theAmount = -1.5;
		var theSpeed:Float = 0.2;
		theSpeed = 0.2;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 1759)
		{
		var theAmount:Float = -0.45;
		theAmount = -0.45;
		var theSpeed:Float = 0.6;
		theSpeed = 0.6;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 1816)
		{
		var theAmount:Float = -0.55;
		theAmount = -0.55;
		var theSpeed:Float = 2;
		theSpeed = 2;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 1836)
		{
		camBopIntensity = 1.2;
		camBopInterval = 1;
		}
		if (curStep == 1888)
		{
		camBopIntensity = 1.24;
		camBopInterval = 1;
		}
		if (curStep == 1952)
		{
		camBopIntensity = 1.28;
		camBopInterval = 1;
		}
		if (curStep == 2016)
		{
		camBopIntensity = 1.32;
		camBopInterval = 1;
		}
		if (curStep == 2079)
		{
		var theAmount:Float = -0.9;
		theAmount = -0.9;
		var theSpeed:Float = 8;
		theSpeed = 8;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		if (curStep == 2080)
		{
		camBopIntensity = 1.36;
		camBopInterval = 1;
		}
		if (curStep == 2144)
		{
		camBopIntensity = 1.42;
		camBopInterval = 1;
		}
		if (curStep == 2207)
		{
		camBopIntensity = 0;
		camBopInterval = 99;
		}
		if (curStep == 2208)
		{
		var theAmount:Float = -0.5;
		theAmount = -0.5;
		var theSpeed:Float = 0.5;
		theSpeed = 0.5;

		if(chromTween != null) chromTween.cancel();
		chromTween = FlxTween.tween(caShader, {amount: theAmount}, theSpeed, {ease: FlxEase.sineOut});
		}
		}
		}

		if (curStage == 'grey')
		{
		if (SONG.song.toLowerCase() == 'delusion')
		{
		if (curStep == 1)
		{
		camBopIntensity = 1.1;
		camBopInterval = 8;
		isChrom = true;
		chromAmount = 0.35;
		chromFreq = 8;
		}
		if (curStep == 96)
		{
		camBopIntensity = 1;
		camBopInterval = 1;
		isChrom = true;
		chromAmount = 0.45;
		chromFreq = 1;
		}
		if (curStep == 144)
		{
		isChrom = false;
		chromAmount = 0;
		}
		if (curStep == 145)
		{
		camBopIntensity = 0;
		camBopInterval = 999;
		}
		if (curStep == 160)
		{
		isChrom = true;
		chromAmount = 0.65;
		chromFreq = 1;
		camBopIntensity = 1.2;
		camBopInterval = 1;
		}
		if (curStep == 288)
		{
		isChrom = true;
		chromAmount = 0.75;
		chromFreq = 1;
		}
		if (curStep == 416)
		{
		flashSprite.alpha = 1;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		isChrom = false;
		chromAmount = 0;
		camBopIntensity = 1;
		camBopInterval = 4;
		}
		if (curStep == 544)
		{
		camBopIntensity = 1.2;
		camBopInterval = 1;
		isChrom = true;
		chromAmount = 0.65;
		chromFreq = 1;
		}
		if (curStep == 769)
		{
		isChrom = false;
		chromAmount = 0;
		}
		if (curStep == 770)
		{
		camBopIntensity = 1;
		camBopInterval = 9999;
		}
		if (curStep == 1056)
		{
		flashSprite.alpha = 1;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1180)
		{
		flashSprite.alpha = 1;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		}
		if (SONG.song.toLowerCase() == 'blackout')
		{
		if (curStep == 255)
		{
		FlxG.camera.zoom += 0.025;
		camHUD.zoom += 0.05;
		}
		if (curStep == 256)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 259)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 260)
		{
		FlxG.camera.zoom += 0.025;
		camHUD.zoom += 0.05;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 264)
		{
		FlxG.camera.zoom += 0.025;
		camHUD.zoom += 0.05;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 266)
		{
		FlxG.camera.zoom += 0.050;
		camHUD.zoom += 0.05;
		}
		if (curStep == 268)
		{
		FlxG.camera.zoom += 0.050;
		camHUD.zoom += 0.05;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 270)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 271)
		{
		FlxG.camera.zoom += 0.35;
		camHUD.zoom += 0.10;
		}
		if (curStep == 367)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 376)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 383)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 392)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 496)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 504)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 512)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 520)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 688)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 694)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 720)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 726)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 752)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 756)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 760)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 764)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 768)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 772)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 776)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 780)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 784)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 788)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 792)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 796)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 800)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 804)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 808)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 812)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 928)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 936)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 944)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 952)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1056)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1064)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1071)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1080)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1311)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1320)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1327)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1336)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1503)
		{
		FlxG.camera.zoom += 0.025;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1508)
		{
		FlxG.camera.zoom += 0.025;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1512)
		{
		FlxG.camera.zoom += 0.025;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1516)
		{
		FlxG.camera.zoom += 0.050;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1518)
		{
		FlxG.camera.zoom += 0.050;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1680)
		{
		FlxG.camera.zoom += 0.025;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1688)
		{
		FlxG.camera.zoom += 0.025;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1696)
		{
		FlxG.camera.zoom += 0.025;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1700)
		{
		FlxG.camera.zoom += 0.025;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1704)
		{
		FlxG.camera.zoom += 0.025;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1706)
		{
		FlxG.camera.zoom += 0.050;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1708)
		{
		FlxG.camera.zoom += 0.050;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1710)
		{
		FlxG.camera.zoom += 0.1;
		camHUD.zoom += 0.05;
		}
		if (curStep == 1711)
		{
		FlxG.camera.zoom += 0.35;
		camHUD.zoom += 0.10;
		}
		}
		}

		if (curStage == 'plantroom')
		{
		if (SONG.song.toLowerCase() == 'heartbeat')
		{
		if (curStep == 272)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 279)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 283)
		{
		forceZoom = [0.15, 0, 0, 0];
		}
		if (curStep == 286)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 287)
		{
		camTwist = true;
		camTwistIntensity = 0.1;
		camTwistIntensity2 = 0.6;
		}
		if (curStep == 288)
		{
		forceZoom = [0, 0, 0, 0];
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;

		pinkCanPulse = true;

		heartsImage.alpha = 1;
		pinkVignette.alpha = 1;
		pinkVignette2.alpha = 0.3;

		var fadeTime:Float = 1*1.2;
		fadeTime = 1*1.2;

		heartColorShader.amount = 1;
		FlxTween.tween(heartColorShader, {amount: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		stageBuild.heartEmitter.emitting = true;

		camBopIntensity = 1.2;
		camBopInterval = 1;
		}
		if (curStep == 406)
		{
		camTwist = false;
		camTwistIntensity = 0;
		camTwistIntensity2 = 0;
		}
		if (curStep == 412)
		{
		forceZoom = [0.07, 0, 0, 0];
		}
		if (curStep == 416)
		{
		camBopIntensity = 1;
		camBopInterval = 4;
		forceZoom = [0, 0, 0, 0];

		var fadeTime:Float = 2*1.2;
		fadeTime = 2*1.2;

		if(vignetteTween != null) vignetteTween.cancel();
		if(whiteTween != null) whiteTween.cancel();

		heartsImage.alpha = 1;
		pinkVignette.alpha = 1;
		pinkVignette2.alpha = 0.4;

		heartColorShader.amount = 1;

		FlxTween.tween(heartsImage, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(heartColorShader, {amount: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(pinkVignette, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(pinkVignette2, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});

		pinkCanPulse = false;
		stageBuild.heartEmitter.emitting = false;
		}
		if (curStep == 528)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 535)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 539)
		{
		forceZoom = [0.15, 0, 0, 0];
		}
		if (curStep == 542)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 543)
		{
		camTwist = true;
		camTwistIntensity = 0.2;
		camTwistIntensity2 = 0.7;
		}
		if (curStep == 544)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;

		pinkCanPulse = true;

		heartsImage.alpha = 1;
		pinkVignette.alpha = 1;
		pinkVignette2.alpha = 0.3;

		var fadeTime:Float = 1*1.2;
		fadeTime = 1*1.2;

		heartColorShader.amount = 1;
		FlxTween.tween(heartColorShader, {amount: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		stageBuild.heartEmitter.emitting = true;

		camBopIntensity = 1.3;
		camBopInterval = 1;
		}
		if (curStep == 604)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 605)
		{
		camBopIntensity = 1;
		camBopInterval = 999;
		}
		if (curStep == 607)
		{
		camTwist = true;
		camTwistIntensity = 0.3;
		camTwistIntensity2 = 0.8;
		}
		if (curStep == 608)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 612)
		{
		forceZoom = [0.1, 0, 0, 0];
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 616)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 620)
		{
		forceZoom = [0.1, 0, 0, 0];
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 624)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 636)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 640)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 644)
		{
		forceZoom = [0.1, 0, 0, 0];
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 647)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 652)
		{
		forceZoom = [0.1, 0, 0, 0];
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 656)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 659)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 662)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 665)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 672)
		{
		forceZoom = [0, 0, 0, 0];
		camBopIntensity = 1;
		camBopInterval = 4;
		camTwist = false;
		camTwistIntensity = 0;
		camTwistIntensity2 = 0;

		var fadeTime:Float = 5*1.2;
		fadeTime = 5*1.2;

		if(vignetteTween != null) vignetteTween.cancel();
		if(whiteTween != null) whiteTween.cancel();

		heartsImage.alpha = 1;
		pinkVignette.alpha = 1;
		pinkVignette2.alpha = 0.4;

		heartColorShader.amount = 1;

		FlxTween.tween(heartsImage, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(heartColorShader, {amount: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(pinkVignette, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(pinkVignette2, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});

		pinkCanPulse = false;
		stageBuild.heartEmitter.emitting = false;
		}
		if (curStep == 736)
		{
		forceZoom = [0, 0, 0, 0];
		}
		if (curStep == 784)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 788)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 791)
		{
		forceZoom = [0.1, 0, 0, 0];
		}
		if (curStep == 795)
		{
		forceZoom = [0.15, 0, 0, 0];
		}
		if (curStep == 798)
		{
		forceZoom = [0.05, 0, 0, 0];
		}
		if (curStep == 799)
		{
		camBopIntensity = 0;
		camBopInterval = 99;
		}
		if (curStep == 800)
		{
		forceZoom = [0, 0, 0, 0];
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 818)
		{
		FlxG.camera.zoom += 0.2;
		camHUD.zoom += 0.07;
		}
		}
		if (SONG.song.toLowerCase() == 'pinkwave')
		{
		if (curStep == 136)
		{
		pinkCanPulse = true;

		heartsImage.alpha = 1;
		pinkVignette.alpha = 1;
		pinkVignette2.alpha = 0.3;

		var fadeTime:Float = 1*1.2;
		fadeTime = 1*1.2;

		heartColorShader.amount = 1;
		FlxTween.tween(heartColorShader, {amount: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		stageBuild.heartEmitter.emitting = true;

		camBopIntensity = 1.2;
		camBopInterval = 1;
		camTwist = false;
		camTwistIntensity = 0;
		camTwistIntensity2 = 0;
		}
		if (curStep == 264)
		{
		var fadeTime:Float = 2*1.2;
		fadeTime = 2*1.2;

		if(vignetteTween != null) vignetteTween.cancel();
		if(whiteTween != null) whiteTween.cancel();

		heartsImage.alpha = 1;
		pinkVignette.alpha = 1;
		pinkVignette2.alpha = 0.4;

		heartColorShader.amount = 1;

		FlxTween.tween(heartsImage, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(heartColorShader, {amount: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(pinkVignette, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(pinkVignette2, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});

		pinkCanPulse = false;
		stageBuild.heartEmitter.emitting = false;
		}
		if (curStep == 520)
		{
		pinkCanPulse = true;

		heartsImage.alpha = 1;
		pinkVignette.alpha = 1;
		pinkVignette2.alpha = 0.3;

		var fadeTime:Float = 1*1.2;
		fadeTime = 1*1.2;

		heartColorShader.amount = 1;
		FlxTween.tween(heartColorShader, {amount: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		stageBuild.heartEmitter.emitting = true;
		}
		if (curStep == 648)
		{
		var fadeTime:Float = 2*1.2;
		fadeTime = 2*1.2;

		if(vignetteTween != null) vignetteTween.cancel();
		if(whiteTween != null) whiteTween.cancel();

		heartsImage.alpha = 1;
		pinkVignette.alpha = 1;
		pinkVignette2.alpha = 0.4;

		heartColorShader.amount = 1;

		FlxTween.tween(heartsImage, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(heartColorShader, {amount: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(pinkVignette, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(pinkVignette2, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});

		pinkCanPulse = false;
		stageBuild.heartEmitter.emitting = false;
		}
		if (curStep == 776)
		{
		pinkCanPulse = true;

		heartsImage.alpha = 1;
		pinkVignette.alpha = 1;
		pinkVignette2.alpha = 0.3;

		var fadeTime:Float = 1*1.2;
		fadeTime = 1*1.2;

		heartColorShader.amount = 1;
		FlxTween.tween(heartColorShader, {amount: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		stageBuild.heartEmitter.emitting = true;
		}
		if (curStep == 904)
		{
		var fadeTime:Float = 2*1.2;
		fadeTime = 2*1.2;

		if(vignetteTween != null) vignetteTween.cancel();
		if(whiteTween != null) whiteTween.cancel();

		heartsImage.alpha = 1;
		pinkVignette.alpha = 1;
		pinkVignette2.alpha = 0.4;

		heartColorShader.amount = 1;

		FlxTween.tween(heartsImage, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(heartColorShader, {amount: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(pinkVignette, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(pinkVignette2, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});

		pinkCanPulse = false;
		stageBuild.heartEmitter.emitting = false;
		}
		if (curStep == 1032)
		{
		pinkCanPulse = true;

		heartsImage.alpha = 1;
		pinkVignette.alpha = 1;
		pinkVignette2.alpha = 0.3;

		var fadeTime:Float = 1*1.2;
		fadeTime = 1*1.2;

		heartColorShader.amount = 1;
		FlxTween.tween(heartColorShader, {amount: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		stageBuild.heartEmitter.emitting = true;
		}
		if (curStep == 1160)
		{
		var fadeTime:Float = 2*1.2;
		fadeTime = 2*1.2;

		if(vignetteTween != null) vignetteTween.cancel();
		if(whiteTween != null) whiteTween.cancel();

		heartsImage.alpha = 1;
		pinkVignette.alpha = 1;
		pinkVignette2.alpha = 0.4;

		heartColorShader.amount = 1;

		FlxTween.tween(heartsImage, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(heartColorShader, {amount: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(pinkVignette, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(pinkVignette2, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});

		pinkCanPulse = false;
		stageBuild.heartEmitter.emitting = false;
		}
		if (curStep == 1288)
		{
		pinkCanPulse = true;

		heartsImage.alpha = 1;
		pinkVignette.alpha = 1;
		pinkVignette2.alpha = 0.3;

		var fadeTime:Float = 1*1.2;
		fadeTime = 1*1.2;

		heartColorShader.amount = 1;
		FlxTween.tween(heartColorShader, {amount: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		stageBuild.heartEmitter.emitting = true;
		}
		if (curStep == 1470)
		{
		var fadeTime:Float = 2*1.2;
		fadeTime = 2*1.2;

		if(vignetteTween != null) vignetteTween.cancel();
		if(whiteTween != null) whiteTween.cancel();

		heartsImage.alpha = 1;
		pinkVignette.alpha = 1;
		pinkVignette2.alpha = 0.4;

		heartColorShader.amount = 1;

		FlxTween.tween(heartsImage, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(heartColorShader, {amount: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(pinkVignette, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});
		FlxTween.tween(pinkVignette2, {alpha: 0}, fadeTime, {ease: FlxEase.cubeInOut});

		pinkCanPulse = false;
		stageBuild.heartEmitter.emitting = false;
		}
		}
		}

		if (curStage == 'chef')
		{
		if (SONG.song.toLowerCase() == 'sauces-moogus')
		{
		if (curStep == 1)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2)
		{
		FlxG.camera.zoom += -0.015;
		camHUD.zoom += -0.03;
		}
		if (curStep == 4)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 6)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 8)
		{
		FlxG.camera.zoom += -0.015;
		camHUD.zoom += -0.03;
		}
		if (curStep == 10)
		{
		FlxG.camera.zoom += -0.015;
		camHUD.zoom += -0.03;
		}
		if (curStep == 11)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 68)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 69)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 132)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 133)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 144)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 171)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep >= 171  && curStep <= 176)
		{
		defaultCamZoom = 1;
		}
		if (curStep == 172)
		{
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curBeat == 44)
		{
		defaultCamZoom = 0.8;
		}
		if (curStep >= 206  && curStep <= 207)
		{
		defaultCamZoom = 1;
		}
		if (curStep >= 399  && curStep <= 404)
		{
		defaultCamZoom = 1;
		}
		if (curStep == 404)
		{
		defaultCamZoom = 0.8;
		}
		if (curBeat == 112)
		{
		defaultCamZoom = 0.9;
		}
		if (curBeat == 113)
		{
		defaultCamZoom = 1;
		}
		if (curBeat == 114)
		{
		defaultCamZoom = 1.1;
		}
		if (curBeat == 115)
		{
		defaultCamZoom = 1.2;
		}
		if (curBeat == 116)
		{
		defaultCamZoom = 0.8;
		}
		if (curStep == 580)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 588)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 644)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 652)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 708)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 716)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 772)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 780)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep >= 1164  && curStep <= 1172)
		{
		defaultCamZoom = 1;
		}
		if (curStep == 1172)
		{
		defaultCamZoom = 0.8;
		}
		if (curBeat == 304)
		{
		defaultCamZoom = 0.9;
		}
		if (curBeat == 305)
		{
		defaultCamZoom = 1;
		}
		if (curBeat == 306)
		{
		defaultCamZoom = 1.1;
		}
		if (curBeat == 307)
		{
		defaultCamZoom = 1.2;
		}
		if (curBeat == 308)
		{
		defaultCamZoom = 0.8;
		}
		if (curBeat == 320)
		{
		defaultCamZoom = 0.9;
		}
		if (curBeat == 321)
		{
		defaultCamZoom = 1;
		}
		if (curBeat == 322)
		{
		defaultCamZoom = 1.1;
		}
		if (curBeat == 323)
		{
		defaultCamZoom = 1.2;
		}
		if (curBeat == 324)
		{
		defaultCamZoom = 0.7;
		isCameraOnForcedPos = true;
		camFollow.x = 1300;
		camFollow.y = 700;
		}
		}
		}

		if (curStage == 'lounge')
		{
		if (SONG.song.toLowerCase() == 'o2')
		{
		if (curStep == 272)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 288)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 304)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 320)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 336)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 352)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 368)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 384)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 392)
		{
		FlxG.camera.fade(FlxColor.BLACK, 0.7, false, function()
		{
		pet.alpha = 0;
		});
		}
		if (curStep == 400)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 403)
		{
		uiHUD.healthBar.visible = false;
		uiHUD.healthBarBG.visible = false;
		uiHUD.iconP1.visible = false;
		uiHUD.iconP2.visible = false;
		dadStrums.visible = false;
		FlxG.camera.fade(FlxColor.BLACK, 0.01, true);
		stageBuild.o2dark.alpha = 1;
		stageBuild.o2WTF.alpha = 1;
		stageBuild.o2WTF.animation.play('w');
		}
		if (curStep == 404)
		{
		stageBuild.o2WTF.animation.play('t');
		}
		if (curStep == 407)
		{
		stageBuild.o2WTF.animation.play('f');
		}
		if (curStep == 408)
		{
		stageBuild.o2WTF.alpha = 0;
		for (hud in allUIs)
		hud.alpha = 0.001;
		camGame.flash(FlxColor.RED, 0.75);
		}
		if (curStep == 416)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 432)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 448)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 464)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 480)
		{
		dadOpponent.setCharacter(0, 0, 'meangus');
		dadOpponent.setPosition(250, 260);
		dadOpponent.y += 430;
		dadOpponent.x += 160;
		}
		if (curStep == 481)
		{
		stageBuild.o2dark.alpha = 0;
		stageBuild.o2lighting.alpha = 1;
		stageBuild.o2WTF.alpha = 0;
		FlxG.camera.fade(FlxColor.BLACK, 1, true);
		}
		if (curStep == 496)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 512)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 528)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 540)
		{
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
		}
		if (curStep == 544)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 560)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 576)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 592)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 608)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 624)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 640)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 656)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 672)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 688)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 704)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 720)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 736)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		}
		}
		if (curStage == 'voting')
		{
		if (SONG.song.toLowerCase() == 'voting-time')
		{
		if (curStep == 16)
		{
					cameraLocked = true;
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 50)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 80)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 112)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 120)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 128)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 136)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 138)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 140)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 144)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 208)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 240)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 248)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 256)
		{
					defaultCamZoom = 0.7;
					camFollowPos.setPosition(960, 540);
					FlxG.camera.focusOn(camFollow.getPosition());
		}
		if (curStep == 272)
		{
					camGame.flash(FlxColor.WHITE, 0.35);
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 288)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 304)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 320)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 336)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 352)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 360)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 368)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 384)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 392)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 400)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 431)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 463)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 479)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 495)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 500)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 504)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 508)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 511)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 527)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 561)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 577)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 590)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 626)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 642)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 653)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(480, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("thejelqer");
		}
		if (curStep == 720)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 752)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 780)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 832)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(480, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("thejelqer");
		}
		if (curStep == 899)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 902)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 905)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(480, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("thejelqer");
		}
		if (curStep == 908)
		{
					defaultCamZoom = 0.7;
					camFollowPos.setPosition(960, 540);
					FlxG.camera.focusOn(camFollow.getPosition());
		}
		if (curStep == 912)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 976)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 1044)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 1060)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 1076)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 1092)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 1140)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(480, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("thejelqer");
		}
		if (curStep == 1160)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 1162)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 1164)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(480, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("thejelqer");
		}
		if (curStep == 1166)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 1167)
		{
					camGame.flash(FlxColor.WHITE, 0.35);
		}
		if (curStep == 1168)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
					mom.setCharacter(0, 0, 'madgus');
					mom.setPosition(1194, 192);
					mom.x += 210;
					mom.y += 430;
		}
		if (curStep == 1176)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 1184)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 1200)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(480, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("thejelqer");
		}
		if (curStep == 1208)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 1216)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 1224)
		{
					defaultCamZoom = 0.7;
					camFollowPos.setPosition(960, 540);
					FlxG.camera.focusOn(camFollow.getPosition());
					FlxG.camera.zoom += 0.015;
					camHUD.zoom += 0.001;
		}
		if (curStep == 1227)
		{
					FlxG.camera.zoom += 0.015;
					camHUD.zoom += 0.001;
		}
		if (curStep == 1230)
		{
					FlxG.camera.zoom += 0.015;
					camHUD.zoom += 0.001;
		}
		if (curStep == 1232)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
					FlxG.camera.zoom += -0.045;
					camHUD.zoom += -0.003;
		}
		if (curStep == 1240)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 1248)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 1264)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(480, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("thejelqer");
		}
		if (curStep == 1272)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
		}
		if (curStep == 1280)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
		}
		if (curStep == 1288)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
		}
		if (curStep == 1296)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(460, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("warchief");
					FlxG.camera.zoom += 0.015;
					camHUD.zoom += 0.001;
		}
		if (curStep == 1300)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
					FlxG.camera.zoom += 0.015;
					camHUD.zoom += 0.001;
		}
		if (curStep == 1304)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(480, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("thejelqer");
					FlxG.camera.zoom += 0.015;
					camHUD.zoom += 0.001;
		}
		if (curStep == 1308)
		{
					defaultCamZoom = 1.25;
					camFollowPos.setPosition(1450, 680);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeDadIcon("redmungus");
					FlxG.camera.zoom += 0.015;
					camHUD.zoom += 0.001;
		}
		if (curStep == 1312)
		{
					defaultCamZoom = 1.2;
					camFollowPos.setPosition(1470, 700);
					FlxG.camera.focusOn(camFollow.getPosition());
					changeBFIcon("bf");
					mom.playAnim('bwah', false);
					FlxG.camera.zoom += -0.06;
					camHUD.zoom += -0.004;
		}
		}
		}
		if (curStage == 'turbulence')
		{
		if (SONG.song.toLowerCase() == 'turbulence')
		{
		if (curStep == 800)
		{
					stageBuild.turbSpeed = 1.2;
		}
		if (curStep == 816)
		{
					stageBuild.turbSpeed = 1.4;
		}
		if (curStep == 944)
		{
					stageBuild.turbSpeed = 1.6;
		}
		if (curStep == 1040)
		{
					stageBuild.turbSpeed = 1.8;
		}
		if (curStep == 1056)
		{
					stageBuild.turbSpeed = 1.9;
		}
		if (curStep == 1072)
		{
					stageBuild.turbSpeed = 2;
		}
		if (curStep == 1136)
		{
					stageBuild.turbSpeed = 2.2;
		}
		if (curStep == 1200)
		{
					stageBuild.turbSpeed = 3;
		}
		if (curStep == 1209)
		{
					turbEnding = true;
		}
		}
		}
		if (curStage == 'victory')
		{
		if (SONG.song.toLowerCase() == 'victory')
		{
		if (curStep == 1)
		{
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
		}
		if (curStep == 120)
		{
		victoryDarkness.alpha = 1;
		FlxG.sound.play(Paths.sound('playerdisconnect'));
		}
		if (curStep == 121)
		{
		stageBuild.bg_jelq.alpha = 1;
		stageBuild.bg_jelq.x = (835.65);
		stageBuild.bg_jelq.y = (458.3);
		}
		if (curStep == 128)
		{
		victoryDarkness.alpha = 0;
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
		}
		if (curStep == 447)
		{
		victoryDarkness.alpha = 1;
		FlxG.sound.play(Paths.sound('playerdisconnect'));
		}
		if (curStep == 449)
		{
		dadOpponent.setCharacter(0, 0, 'jelqer');
		dadOpponent.setPosition(280, 190);
		dadOpponent.y += 160;
		dadOpponent.x += -110;
		}
		if (curStep == 450)
		{
		stageBuild.bg_jelq.alpha = 0;
		}
		if (curStep == 451)
		{
		stageBuild.bg_war.alpha = 1;
		stageBuild.bg_war.x = (853.3);
		stageBuild.bg_war.y = (421.9);
		}
		if (curStep == 463)
		{
		victoryDarkness.alpha = 0;
		}
		if (curStep == 716)
		{
		victoryDarkness.alpha = 1;
		FlxG.sound.play(Paths.sound('playerdisconnect'));
		dadOpponent.setCharacter(0, 0, 'jorsawghost');
		dadOpponent.setPosition(280, 190);
		dadOpponent.y += -20;
		dadOpponent.x += 110;
		}
		if (curStep == 717)
		{
		stageBuild.bg_war.alpha = 1;
		stageBuild.bg_war.x = (693.7);
		stageBuild.bg_war.y = (421.9);
		stageBuild.bg_jelq.alpha = 1;
		stageBuild.bg_jelq.x = (982.75);
		stageBuild.bg_jelq.y = (458.3);
		}
		if (curStep == 720)
		{
		victoryDarkness.alpha = 0;
		}
		if (curStep == 722)
		{
		stageBuild.bg_jelq.alpha = 1;
		stageBuild.bg_jelq.x = (982.75);
		stageBuild.bg_jelq.y = (458.3);
		}
		if (curStep == 724)
		{
		victoryDarkness.alpha = 0;
		}
		if (curStep == 976)
		{
		victoryDarkness.alpha = 1;
		FlxG.sound.play(Paths.sound('playerdisconnect'));
		}
		if (curStep == 977)
		{
		dadOpponent.setCharacter(0, 0, 'warchief');
		dadOpponent.setPosition(280, 190);
		dadOpponent.y += 190;
		dadOpponent.x += -150;
		}
		if (curStep == 978)
		{
		stageBuild.bg_war.alpha = 0;
		}
		if (curStep == 979)
		{
		stageBuild.bg_jor.alpha = 1;
		}
		if (curStep == 980)
		{
		stageBuild.bg_jelq.alpha = 0;
		}
		if (curStep == 981)
		{
		stageBuild.bg_jelq.alpha = 1;
		stageBuild.bg_jelq.x = (676.05);
		stageBuild.bg_jelq.y = (458.3);
		}
		if (curStep == 992)
		{
		victoryDarkness.alpha = 0;
		}
		if (curStep == 1052)
		{
		victoryDarkness.alpha = 1;
		FlxG.sound.play(Paths.sound('playerdisconnect'));
		}
		if (curStep == 1053)
		{
		stageBuild.bg_war.alpha = 1;
		stageBuild.bg_war.x = (693.7);
		stageBuild.bg_war.y = (421.9);
		}
		if (curStep == 1054)
		{
		stageBuild.bg_jor.alpha = 1;
		stageBuild.bg_jelq.alpha = 0;
		dadOpponent.setCharacter(0, 0, 'jelqer');
		dadOpponent.setPosition(280, 190);
		dadOpponent.y += 160;
		dadOpponent.x += -110;
		}
		if (curStep == 1056)
		{
		victoryDarkness.alpha = 0;
		}
		if (curStep == 1116)
		{
		victoryDarkness.alpha = 1;
		FlxG.sound.play(Paths.sound('playerdisconnect'));
		stageBuild.bg_jor.alpha = 0;
		}
		if (curStep == 1117)
		{
		stageBuild.bg_jelq.alpha = 1;
		stageBuild.bg_jelq.x = (982.75);
		stageBuild.bg_jelq.y = (458.3);
		stageBuild.bg_war.alpha = 1;
		stageBuild.bg_war.x = (693.7);
		stageBuild.bg_war.y = (421.9);
		}
		if (curStep == 1118)
		{
		dadOpponent.setCharacter(0, 0, 'jorsawghost');
		dadOpponent.setPosition(280, 190);
		dadOpponent.y += -20;
		dadOpponent.x += 110;
		}
		if (curStep == 1120)
		{
		victoryDarkness.alpha = 0;
		}
		}
		}
		if (curStage == 'henry')
		{
		if (SONG.song.toLowerCase() == 'reinforcements')
		{
		if (curStep == 696)
		{
					add(mom);
					dadOpponent.playAnim('shock', false);
					mom.playAnim('enter', false);
					changeDadIcon("ellie");
					dadOpponent.specialAnim = true;
		}
		}
		if (SONG.song.toLowerCase() == 'armed')
		{
		if (curStep == 2351)
		{
					var colorShader:ColorShader = new ColorShader(0);
					boyfriend.shader = colorShader.shader;
					gf.shader = colorShader.shader;
					pet.shader = colorShader.shader;

					for (hud in allUIs)
					FlxTween.tween(hud, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});

					FlxG.sound.play(Paths.sound('teleport_sound'), 1);

					new FlxTimer().start(0.45, function(tmr:FlxTimer)
					{
						colorShader.amount = 1;
						FlxTween.tween(colorShader, {amount: 0}, 0.73, {ease: FlxEase.expoOut});
					});

					new FlxTimer().start(1.28, function(tmr:FlxTimer)
					{
						colorShader.amount = 1;
						FlxTween.tween(colorShader, {amount: 0.1}, 0.55, {ease: FlxEase.expoOut});
					});

					new FlxTimer().start(1.93, function(tmr:FlxTimer)
					{
						colorShader.amount = 1;
						FlxTween.tween(colorShader, {amount: 0.2}, 0.2, {ease: FlxEase.expoOut});
					});

					new FlxTimer().start(2.23, function(tmr:FlxTimer)
					{
						colorShader.amount = 1;
						FlxTween.tween(colorShader, {amount: 0.4}, 0.22, {ease: FlxEase.expoOut});
					});
					new FlxTimer().start(2.55, function(tmr:FlxTimer)
					{
						colorShader.amount = 1;
						FlxTween.tween(colorShader, {amount: 0.8}, 0.05, {ease: FlxEase.expoOut});
					});

					new FlxTimer().start(2.7, function(tmr:FlxTimer)
					{
						colorShader.amount = 1;
						FlxTween.tween(boyfriend, {"scale.y": 0}, 0.7, {ease: FlxEase.expoOut});
						FlxTween.tween(boyfriend, {"scale.x": 3.5}, 0.7, {ease: FlxEase.expoOut});
					});

					new FlxTimer().start(2.8, function(tmr:FlxTimer)
					{
						FlxTween.tween(gf, {"scale.y": 0}, 0.7, {ease: FlxEase.expoOut});
						FlxTween.tween(gf, {"scale.x": 3.5}, 0.7, {ease: FlxEase.expoOut});
					});
		}
		}
		}
		if (curStage == 'charles')
		{
		if (SONG.song.toLowerCase() == 'greatest-plan')
		{
		if (curStep == 32)
		{
					defaultCamZoom = 1.3;
		}
		if (curStep == 40)
		{
		changeDadIcon("bf");
		changeBFIcon("henry");
		FlxG.camera.zoom += 0.2;
		camHUD.zoom += 0.03;
		}
		if (curStep == 41)
		{
		changeDadIcon("charles");
		FlxG.camera.zoom += 0.2;
		camHUD.zoom += 0.03;
		}
		if (curStep == 45)
		{
					charlesEnter = true;
		}
		if (curStep == 52)
		{
					dadOpponent.playAnim('oh', false);
		}
		if (curStep == 818)
		{
					dadOpponent.playAnim('perfect', false);
		}
		}
		}
		if (curStage == 'school')
		{
		if (SONG.song.toLowerCase() == 'rivals')
		{
		if (curStep == 1034)
		{
		boyfriend.setCharacter(0, 0, 'bfsus-pixel');
		boyfriend.setPosition(1000, 180);
		boyfriend.x += -17;
		boyfriend.y += 383;

		boyfriend.playAnim('shoot', false);

		FlxG.sound.play(Paths.sound('tomongus_Shot'));

		camGame.flash(FlxColor.WHITE, 0.35);

		dadOpponent.setCharacter(0, 0, 'hamster');
		dadOpponent.setPosition(100, 100);
		dadOpponent.y += 510;
		dadOpponent.x += 133;
		}
		}
		}
		if (curStage == 'tomtus')
		{
		if (SONG.song.toLowerCase() == 'tomongus-tuesday')
		{
		if (curStep == 983)
		{
		defaultCamZoom = 0.8;
		}
		if (curStep == 985)
		{
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
		}
		if (curStep == 987)
		{
		FlxG.sound.play(Paths.sound('soundTuesday'));
		dadOpponent.playAnim('prep', false);
		}
		if (curStep == 991)
		{
		boyfriend.playAnim('shoot', false);
		}
		if (curStep == 994)
		{
		dadOpponent.playAnim('shot', false);
		dadOpponent.idleSuffix = '-alt';
		dadOpponent.specialAnim = true;
		}
		}
		}
		if (curStage == 'who')
		{
		if (SONG.song.toLowerCase() == 'who')
		{
		if (curStep == 384)
		{
		cameraLocked = true;
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 397)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 402)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 412)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 424)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 448)
		{
		cameraLocked = false;
		defaultCamZoom = 0.7;
		camFollowPos.setPosition(1100, 1150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 504)
		{
		cameraLocked = true;
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 512)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 529)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 560)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 576)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 612)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 630)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 642)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 662)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 688)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 697)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 708)
		{
		cameraLocked = false;
		defaultCamZoom = 0.7;
		camFollowPos.setPosition(1100, 1150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 712)
		{
		cameraLocked = true;
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 728)
		{
		//defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 768)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 784)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 791)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 800)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 818)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 824)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 830)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 844)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 852)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		dadOpponent.setCharacter(0, 0, 'bluewho');
		dadOpponent.setPosition(400, 775);
		dadOpponent.y += 110;
		dadOpponent.x += 0;
		}
		if (curStep == 864)
		{
		cameraLocked = false;
		defaultCamZoom = 0.7;
		camFollowPos.setPosition(1100, 1150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 872)
		{
		boyfriend.setCharacter(0, 0, 'whitemad');
		boyfriend.setPosition(1450, 750);
		boyfriend.x += 0;
		boyfriend.y += 90;
		}
		if (curStep == 880)
		{
		cameraLocked = true;
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 896)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 904)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 912)
		{
		cameraLocked = false;
		defaultCamZoom = 0.7;
		camFollowPos.setPosition(1100, 1150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 928)
		{
		cameraLocked = true;
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 942)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 960)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 976)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 985)
		{
		boyfriend.setCharacter(0, 0, 'whitewho');
		boyfriend.setPosition(1450, 750);
		boyfriend.x += 0;
		boyfriend.y += 100;
		}
		if (curStep == 986)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 992)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 1022)
		{
		boyfriend.setCharacter(0, 0, 'whitemad');
		boyfriend.setPosition(1450, 750);
		boyfriend.x += 0;
		boyfriend.y += 90;
		}
		if (curStep == 1025)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 1040)
		{
		dadOpponent.setCharacter(0, 0, 'bluewhonormal');
		dadOpponent.setPosition(400, 775);
		dadOpponent.y += 110;
		dadOpponent.x += 0;
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 1055)
		{
		boyfriend.setCharacter(0, 0, 'whitewho');
		boyfriend.setPosition(1450, 750);
		boyfriend.x += 0;
		boyfriend.y += 100;
		}
		if (curStep == 1056)
		{
		cameraLocked = false;
		defaultCamZoom = 0.7;
		camFollowPos.setPosition(1100, 1150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 1067)
		{
		dadOpponent.setCharacter(0, 0, 'bluewho');
		dadOpponent.setPosition(400, 775);
		dadOpponent.y += 110;
		dadOpponent.x += 0;
		}
		if (curStep == 1080)
		{
		boyfriend.setCharacter(0, 0, 'whitemad');
		boyfriend.setPosition(1450, 750);
		boyfriend.x += 0;
		boyfriend.y += 90;
		}
		if (curStep == 1088)
		{
		cameraLocked = true;
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(boyfriend.getMidpoint().x - 150, boyfriend.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 1120)
		{
		defaultCamZoom = 1.2;
		camFollowPos.setPosition(dadOpponent.getMidpoint().x + 150, dadOpponent.getMidpoint().y + 150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		if (curStep == 1152)
		{
		for (hud in allUIs)
		hud.visible = false;
		stageBuild.meeting.alpha = 1;
		stageBuild.meeting.animation.play('bop');
		stageBuild.meeting.animation.finishCallback = function(pog:String)
		{
		stageBuild.furiousRage.alpha = 1;
		stageBuild.emergency.alpha = 1;
		}
		}
		if (curStep == 1168)
		{
		stageBuild.furiousRage.alpha = 0.001;
		stageBuild.emergency.alpha = 0.001;
		stageBuild.meeting.alpha = 0.001;
		boyfriend.visible = false;
		dadOpponent.visible = false;
		stageBuild.space.visible = true;
		stageBuild.starsBG.visible = true;
		stageBuild.starsFG.visible = true;
		stageBuild.whoAngered.alpha = 1;
		FlxTween.angle(stageBuild.whoAngered, 0, 720, 10);
		FlxTween.tween(stageBuild.whoAngered, {x: 3000}, 10);
		defaultCamZoom = 0.5;
		FlxG.camera.zoom = 0.5;
		camFollowPos.setPosition(1100, 1150);
		FlxG.camera.focusOn(camFollowPos.getPosition());
		}
		}
		}

		if (curStage == 'jerma')
		{
		if (SONG.song.toLowerCase() == 'insane-streamer')
		{
		if (curStep == 998)
		{
					scaryJerma.animation.play('w');
					scaryJerma.alpha = 1;
		}
		if (curStep == 1024)
		{
					scaryJerma.alpha = 0;
					FlxG.camera.zoom += 0.9;
					camHUD.zoom += 0.9;
		}
		}
		}

		if (curStage == 'esculent')
		{
		if (SONG.song.toLowerCase() == 'esculent')
		{
		if (curStep == 512)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 528)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 544)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 560)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 576)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 592)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 608)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 624)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 640)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 656)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 672)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 688)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 703)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 719)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 735)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 751)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 767)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 783)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 799)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 815)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 831)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 847)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 863)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 879)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 895)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 911)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 927)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 943)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 959)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 975)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 991)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1007)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1023)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1039)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1055)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1071)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1087)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1103)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1119)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1135)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1151)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1167)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1183)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1199)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1215)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1231)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1247)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1263)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1279)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1295)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1311)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1327)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1343)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1359)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1375)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1391)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1664)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1680)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1696)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1712)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1728)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1744)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1760)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1776)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1792)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1808)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1824)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1840)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1856)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1872)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1888)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1904)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1920)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1936)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1952)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 1984)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2016)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2048)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2080)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2112)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		if (curStep == 2144)
		{
		flashSprite.alpha = 0.4;
		FlxG.camera.zoom += 0.015;
		camHUD.zoom += 0.03;
		}
		}
		}

		if (curStage == 'drippypop')
		{
		if (SONG.song.toLowerCase() == 'drippypop')
		{
		if (curStep == 1137)
		{
		gf.playAnim('kill', false);
		}
		if (curStep == 1138)
		{
		gf.idleSuffix = '-alt';
		}
		if (curBeat == 286)
		{
					defaultCamZoom = 1.1;
		}
		if (curBeat == 304)
		{
					defaultCamZoom = 0.9;
		}
		if (curBeat == 318)
		{
					defaultCamZoom = 1.1;
		}
		if (curBeat == 336)
		{
					defaultCamZoom = 0.9;
		}
		if (curBeat == 384)
		{
					defaultCamZoom = 1.1;
		}
		if (curBeat == 401)
		{
					defaultCamZoom = 0.9;
		}
		}
		}
		if (curStage == 'dave')
		{
		if (SONG.song.toLowerCase() == 'crewicide')
		{
		if (curStep == 2043)
		{
		dadOpponent.playAnim('die', false);
		}
		if (curStep == 2064)
		{
		camGame.shake(0.05, 0.6);
		camHUD.shake(0.05, 0.6);

		stageBuild.daveDIE.alpha = 1;
		dadOpponent.alpha = 0;
		FlxG.sound.play(Paths.sound('davewindowsmash'));
		}
		}
		}
		if (curStage == 'attack')
		{
		if (SONG.song.toLowerCase() == 'monotone-attack')
		{
		if (curBeat == 64)
		{
					defaultCamZoom = 0.6;
		}
		if (curBeat == 80)
		{
					defaultCamZoom = 0.7;
		}
		if (curBeat == 95)
		{
					defaultCamZoom = 0.9;
					stageBuild.toogusblue.visible = false;
					stageBuild.toogusblue2.visible = true;
					stageBuild.toogusblue2.animation.play('bop');
		}
		if (curBeat == 99)
		{
					defaultCamZoom = 0.75;
					stageBuild.toogusblue.visible = true;
					stageBuild.toogusblue2.visible = false;
		}
		if (curBeat == 196)
		{
					defaultCamZoom = 0.6;
		}
		if (curBeat == 229)
		{
					defaultCamZoom = 0.7;
		}
		if (curBeat == 276)
		{
					defaultCamZoom = 0.6;
		}
		if (curBeat == 292)
		{
					defaultCamZoom = 0.75;
		}
		if (curBeat == 324)
		{
					defaultCamZoom = 0.7;
		}
		if (curBeat == 355)
		{
					defaultCamZoom = 0.9;
		}
		if (curStep == 1428)
		{
					stageBuild.nickt.visible = false;
					stageBuild.nicktmvp.visible = true;
					stageBuild.nicktmvp.animation.play('bop');

					for (hud in allUIs)
					FlxTween.tween(hud, {alpha: 0}, 0.4);
					FlxTween.tween(stageBuild.toogusorange, {alpha: 0.1}, 0.4);
					FlxTween.tween(stageBuild.toogusblue, {alpha: 0.1}, 0.4);
					FlxTween.tween(stageBuild.thebackground, {alpha: 0.1}, 0.4);
					FlxTween.tween(gf, {alpha: 0.1}, 0.4);
					FlxTween.tween(mom, {alpha: 0.1}, 0.4);
					FlxTween.tween(dadOpponent, {alpha: 0.25}, 0.4);
					FlxTween.tween(boyfriend, {alpha: 0.25}, 0.4);
		}
		if (curBeat == 360)
		{
					defaultCamZoom = 0.6;
					stageBuild.nickt.visible = true;
					stageBuild.nicktmvp.visible = false;
					stageBuild.nicktmvp.animation.play('bop');

					for (hud in allUIs)
					FlxTween.tween(hud, {alpha: 1}, 0.4);
					FlxTween.tween(stageBuild.toogusorange, {alpha: 1}, 0.4);
					FlxTween.tween(stageBuild.toogusblue, {alpha: 1}, 0.4);
					FlxTween.tween(stageBuild.thebackground, {alpha: 1}, 0.4);
					FlxTween.tween(mom, {alpha: 1}, 0.4);
					FlxTween.tween(gf, {alpha: 1}, 0.4);
					FlxTween.tween(dadOpponent, {alpha: 1}, 0.4);
					FlxTween.tween(boyfriend, {alpha: 1}, 0.4);
		}
		}
		}
		if (curStage == 'piptowers')
		{
		if (SONG.song.toLowerCase() == 'chippin')
		{
		if (curStep == 1)
		{
					defaultCamZoom = 0.75;
		}
		if (curStep == 284)
		{
		dadOpponent.playAnim('pip', false);
		dadOpponent.specialAnim = true;
		}
		if (curStep == 316)
		{
		boyfriend.setCharacter(0, 0, 'pip_evil');
		boyfriend.flipX = true;
		boyfriend.setPosition(870, 100);
		boyfriend.x += -100;
		boyfriend.y += 110;
		}
		if (curStep == 448)
		{
					defaultCamZoom = 0.4;
		}
		}
		if (SONG.song.toLowerCase() == 'chipping')
		{
		if (curStep == 1)
		{
					defaultCamZoom = 0.75;
		}
		if (curStep == 284)
		{
		dadOpponent.playAnim('pip', false);
		dadOpponent.specialAnim = true;
		}
		if (curStep == 316)
		{
		boyfriend.setCharacter(0, 0, 'pip_evil');
		boyfriend.flipX = true;
		boyfriend.setPosition(870, 100);
		boyfriend.x += -100;
		boyfriend.y += 110;
		}
		if (curStep == 448)
		{
					defaultCamZoom = 0.4;
		}
		}
		}
		if (curStage == 'warehouse')
		{
		if (SONG.song.toLowerCase() == 'torture')
		{
		if (curStep == 128)
		{
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
		}
		if (curStep == 1024)
		{
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 0}, 0.7, {ease: FlxEase.quadInOut});
		boyfriend.playAnim('ROZEBUD', false);
		boyfriend.specialAnim = true;
		}
		if (curStep == 1027)
		{
		mom.playAnim('rozebud?', false);
		mom.specialAnim = true;
		}
		if (curStep == 1045)
		{
		dadOpponent.playAnim('GETOUT', false);
		dadOpponent.specialAnim = true;
		}
		if (curStep == 1085)
		{
		for (hud in allUIs)
		FlxTween.tween(hud, {alpha: 1}, 0.7, {ease: FlxEase.quadInOut});
		}
		}
		}
		if (curStage == 'tripletrouble')
		{
		if (SONG.song.toLowerCase() == 'triple-trouble')
		{
		if (curStep == 1039)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		}
		if (curStep == 1040)
		{
		dadOpponent.setCharacter(0, 0, 'black');
		dadOpponent.setPosition(800, 450);
		dadOpponent.y += 80;
		dadOpponent.x += 180;
		changeDadIcon("black");
		}
		if (curStep == 1295)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		}
		if (curStep == 1296)
		{
		dadOpponent.setCharacter(0, 0, 'grey');
		dadOpponent.setPosition(800, 450);
		dadOpponent.y += 220;
		dadOpponent.x += 0;
		changeDadIcon("gray");
		}
		if (curStep == 2319)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		}
		if (curStep == 2320)
		{
		dadOpponent.setCharacter(0, 0, 'black');
		dadOpponent.setPosition(800, 450);
		dadOpponent.y += 80;
		dadOpponent.x += 180;
		changeDadIcon("black");
		}
		if (curStep == 2831)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		}
		if (curStep == 2832)
		{
		dadOpponent.setCharacter(0, 0, 'maroon');
		dadOpponent.setPosition(800, 450);
		dadOpponent.y += 80;
		dadOpponent.x += 110;
		changeDadIcon("maroon");
		}
		if (curStep == 4111)
		{
		camGame.flash(FlxColor.WHITE, 0.35);
		}
		if (curStep == 4112)
		{
		dadOpponent.setCharacter(0, 0, 'black');
		dadOpponent.setPosition(800, 450);
		dadOpponent.y += 80;
		dadOpponent.x += 180;
		changeDadIcon("black");
		}
		}
		}

		if (camTwist)
		{
			if (curStep % 4 == 0)
			{
				for (hud in allUIs)
				FlxTween.tween(hud, {y: -6 * camTwistIntensity2}, Conductor.stepCrochet * 0.002, {ease: FlxEase.circOut});
				FlxTween.tween(camGame.scroll, {y: 12}, Conductor.stepCrochet * 0.002, {ease: FlxEase.sineIn});
			}

			if (curStep % 4 == 2)
			{
				for (hud in allUIs)
				FlxTween.tween(hud, {y: 0}, Conductor.stepCrochet * 0.002, {ease: FlxEase.sineIn});
				FlxTween.tween(camGame.scroll, {y: 0}, Conductor.stepCrochet * 0.002, {ease: FlxEase.sineIn});
			}
		}
	}

	function changeDadIcon(id:String) // thth an kj you bob mod you are epic!!!!1!! - fabs
	{
		uiHUD.iconP2.changeDadIcon(id);
	}

	function changeBFIcon(id:String) // thth an kj you bob mod you are epic!!!!1!! - fabs
	{
		uiHUD.iconP1.changeBfIcon(id);
	}

	private function charactersDance(curBeat:Int)
	{
		if ((curBeat % gfSpeed == 0) 
		&& ((gf.animation.curAnim.name.startsWith("idle")
		|| gf.animation.curAnim.name.startsWith("dance"))))
			gf.dance();

		if ((boyfriend.animation.curAnim.name.startsWith("idle") 
		|| boyfriend.animation.curAnim.name.startsWith("dance")) 
			&& (curBeat % 2 == 0 || boyfriend.characterData.quickDancer) && boyfriend.curCharacter != 'bf-running')
			boyfriend.dance();

		// added this for opponent cus it wasn't here before and skater would just freeze
		if ((dadOpponent.animation.curAnim.name.startsWith("idle") 
		|| dadOpponent.animation.curAnim.name.startsWith("dance"))  
			&& (curBeat % 2 == 0 || dadOpponent.characterData.quickDancer))
			dadOpponent.dance();

		if ((mom.animation.curAnim.name.startsWith("idle") 
		|| mom.animation.curAnim.name.startsWith("dance"))  
			&& (curBeat % 2 == 0 || mom.characterData.quickDancer))
			mom.dance();

		if ((pet.animation.curAnim.name.startsWith("idle") 
		|| pet.animation.curAnim.name.startsWith("dance")) 
			&& (curBeat % 2 == 0 || pet.characterData.quickDancer))
			pet.dance();
	}

	public static var missLimited:Bool = false;
	public static var missLimitCount:Int = 5;

	public function missLimitManager()
	{
		if (missLimited)
		{
			health = 1;
			if (misses > missLimitCount)
				health = 0;
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if ((FlxG.camera.zoom < 1.35 && curBeat % camBopInterval == 0) && (!Init.trueSettings.get('Reduced Movements')))
		{
			FlxG.camera.zoom += 0.015 * camBopIntensity;
			camHUD.zoom += 0.05 * camBopIntensity;
			for (hud in strumHUD)
				hud.zoom += 0.05 * camBopIntensity;
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
			}
		}

		uiHUD.beatHit();

		//
		charactersDance(curBeat);

		if (curBeat % 1 == 0)
		{
			if (boyfriend.curCharacter == 'bf-running')
				bfLegs.dance();
			if (boyfriend.animation.curAnim.name != null
				&& !boyfriend.animation.curAnim.name.startsWith("sing")
				&& boyfriend.curCharacter == 'bf-running')
			{
				boyfriend.dance();
			}
		}

		if (curBeat % 1 == 0)
			{
				if (boyfriend.curCharacter == 'bf-running')
					bfLegsmiss.dance();
			}

		if (curBeat % 1 == 0)
		{
			if (dadOpponent.curCharacter == 'black-run')
				dadlegs.dance();
		}

		if (curBeat % 1 == 0)
		{
			if (dadOpponent.curCharacter == 'blackalt')
				dadlegs.dance();
		}

		if (camTwist)
		{
			if (curBeat % 2 == 0)
			{
				twistShit = twistAmount;
			}
			else
			{
				twistShit = -twistAmount;
			}
			camHUD.angle = twistShit * camTwistIntensity2;
			camGame.angle = twistShit * camTwistIntensity2;
				for (hud in allUIs)
			FlxTween.tween(hud, {angle: twistShit * camTwistIntensity}, Conductor.stepCrochet * 0.002, {ease: FlxEase.circOut});
				for (hud in allUIs)
			FlxTween.tween(hud, {x: -twistShit * camTwistIntensity}, Conductor.crochet * 0.001, {ease: FlxEase.linear});
			FlxTween.tween(camGame, {angle: twistShit * camTwistIntensity}, Conductor.stepCrochet * 0.002, {ease: FlxEase.circOut});
			FlxTween.tween(camGame, {x: -twistShit * camTwistIntensity}, Conductor.crochet * 0.001, {ease: FlxEase.linear});
		}

		switch (curStage)
		{
			case 'grey':
				if(curBeat % chromFreq == 0){
					if(chromTween != null) chromTween.cancel();
					caShader.amount = chromAmount;
					chromTween = FlxTween.tween(caShader, {amount: 0}, 0.45, {ease: FlxEase.sineOut});
				}
			case 'plantroom':
				if (curBeat % 2 == 1 && pinkCanPulse)
				{
					pinkVignette.alpha = 1;
					if(vignetteTween != null) vignetteTween.cancel();
					vignetteTween = FlxTween.tween(pinkVignette, {alpha: 0.2}, 1.2, {ease: FlxEase.sineOut});

					if(whiteTween != null) whiteTween.cancel();
					heartColorShader.amount = 0.5;
					whiteTween = FlxTween.tween(heartColorShader, {amount: 0}, 0.75, {ease: FlxEase.sineOut});
				}
			case 'warehouse':
				stageBuild.leftblades.animation.play('spin', true);
				stageBuild.rightblades.animation.play('spin', true);

				if (SONG.song.toLowerCase() == 'torture')
				{
				if(curBeat == 2){
					ziffyStart.visible = true;
					ziffyStart.animation.play("idle", true);
					ziffyStart.screenCenter(XY);
					ziffyStart.y -= 120;
				}

				if(curBeat == 24){
					ziffyStart.visible = false;
					ziffyStart.destroy();
				}

				if(curBeat == 32){
					FlxTween.tween(startDark, {alpha: 0}, (Conductor.crochet*28)/1000, {onComplete: function(t){
						startDark.destroy();
					}});
				}

				if(curBeat == 62){
					FlxG.sound.play(Paths.sound('ziffSaw'), 1);
					FlxTween.tween(stageBuild.leftblades, {y: stageBuild.leftblades.y + 300}, (Conductor.crochet*4)/1000, {ease: FlxEase.quintOut});
					FlxTween.tween(stageBuild.rightblades, {y: stageBuild.rightblades.y + 300}, (Conductor.crochet*4)/1000, {ease: FlxEase.quintOut});
				}

				if(curBeat == 256){ 	
					stageBuild.ROZEBUD_ILOVEROZEBUD_HEISAWESOME.visible = true;
					stageBuild.ROZEBUD_ILOVEROZEBUD_HEISAWESOME.animation.play("thing");
					stageBuild.ROZEBUD_ILOVEROZEBUD_HEISAWESOME.animation.finishCallback = function(name){
						stageBuild.ROZEBUD_ILOVEROZEBUD_HEISAWESOME.destroy();
					}
					FlxTween.tween(camGame, {zoom: defaultCamZoom - 0.5}, 4*Conductor.crochet/1000, {ease: FlxEase.quintOut});
				}

				if(curBeat == 32){
					task = new TaskSong(0, 200, "songs/" + SONG.song.toLowerCase().replace(' ', '-'), 1);
					task.cameras = [camOther];
					add(task);
					task.start();
				}
				else if(curBeat == 128){
					task = new TaskSong(0, 200, "songs/" + SONG.song.toLowerCase().replace(' ', '-'), 2);
					task.cameras = [camOther];
					add(task);
					task.start();
				}
				else if(curBeat == 160){
					task = new TaskSong(0, 200, "songs/" + SONG.song.toLowerCase().replace(' ', '-'), 3);
					task.cameras = [camOther];
					add(task);
					task.start();
				}
				else if(curBeat == 224){
					task = new TaskSong(0, 200, "songs/" + SONG.song.toLowerCase().replace(' ', '-'), 4);
					task.cameras = [camOther];
					add(task);
					task.start();
				}
				else if(curBeat == 256){
					task = new TaskSong(0, 200, "songs/" + SONG.song.toLowerCase().replace(' ', '-'), 5);
					task.cameras = [camOther];
					add(task);
					task.start();
				}
				else if(curBeat == 272){
					task = new TaskSong(0, 200, "songs/" + SONG.song.toLowerCase().replace(' ', '-'), 6);
					task.cameras = [camOther];
					add(task);
					task.start();
					health = 0.05;
				}
				else if(curBeat == 336){
					task = new TaskSong(0, 200, "songs/" + SONG.song.toLowerCase().replace(' ', '-'), 7);
					task.cameras = [camOther];
					add(task);
					task.start();
				}
				}
			case 'finale':
				if (curBeat % 4 == 0)
				{
				light.animation.play('finale/light', true);
				}
		}

		// stage stuffs
		stageBuild.stageUpdate(curBeat, boyfriend, gf, dadOpponent);
	}

	//
	//
	/// substate stuffs
	//
	//

	public static function resetMusic()
	{
		// simply stated, resets the playstate's music for other states and substates
		if (songMusic != null)
			songMusic.stop();

		if (vocals != null)
			vocals.stop();
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			// trace('null song');
			if (songMusic != null)
			{
				//	trace('nulled song');
				songMusic.pause();
				vocals.pause();
				//	trace('nulled song finished');
			}

			// trace('ui shit break');
			if ((startTimer != null) && (!startTimer.finished))
				startTimer.active = false;
		}

		// trace('open substate');
		super.openSubState(SubState);
		// trace('open substate end ');
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (songMusic != null && !startingSong)
				resyncVocals();

			if ((startTimer != null) && (!startTimer.finished))
				startTimer.active = true;
			paused = false;

			///*
			updateRPC(false);
			// */
		}

		super.closeSubState();
	}

	/*
		Extra functions and stuffs
	 */
	/// song end function at the end of the playstate lmao ironic I guess
	private var endSongEvent:Bool = false;

	function endSong():Void
	{
		canPause = false;
		songMusic.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);

		if (!isStoryMode)
		{
			var beansValue:Int = Std.int(songScore / 600);
			add(new BeansPopup(beansValue, camOther));
			new FlxTimer().start(4, function(tmr:FlxTimer)
			{
			Main.switchState(this, new FreeplayState());
			});
		}
		else
		{
			// set the campaign's score higher
			campaignScore += songScore;

			// remove a song from the story playlist
			storyPlaylist.remove(storyPlaylist[0]);

			// check if there aren't any songs left
			if (storyPlaylist.length <= 0)
			{
				var beansValue:Int = Std.int(campaignScore / 600);
				add(new BeansPopup(beansValue, camOther));
				new FlxTimer().start(4, function(tmr:FlxTimer)
				{
				// play menu music
				ForeverTools.resetMenuMusic();

				// set up transitions
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				// change to the menu state
				Main.switchState(this, new StoryMenuState());

				// save the week's score if the score is valid
				if (SONG.validScore)
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty);

				// flush the save
				FlxG.save.flush();
				});
			}
			else if (storyPlaylist.length >= 0)
			{
				var difficulty:String = "";

				if (storyDifficulty == 0)
					difficulty = '-easy';

				if (storyDifficulty == 2)
					difficulty = '-hard';

				trace('LOADING NEXT SONG');
				trace(storyPlaylist[0].toLowerCase() + difficulty);

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;

				FlxG.sound.music.stop();
				vocals.stop();

					SONG = Song.loadFromJson(storyPlaylist[0].toLowerCase() + difficulty, storyPlaylist[0]);
					Main.switchState(this, new PlayState());
			}
			else
				songEndSpecificActions();
		}
		//
	}

	private function songEndSpecificActions()
	{
		if (!skipCutscenes())
		{
		switch (SONG.song.toLowerCase())
		{
			case 'eggnog':
				// make the lights go out
				var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
					-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
				blackShit.scrollFactor.set();
				add(blackShit);
				camHUD.visible = false;

				// oooo spooky
				FlxG.sound.play(Paths.sound('Lights_Shut_off'));

				// call the song end
				var eggnogEndTimer:FlxTimer = new FlxTimer().start(Conductor.crochet / 1000, function(timer:FlxTimer) {
					endSong();
				}, 1);

			case 'pinkwave':
					if (SONG.stage.toLowerCase() == 'plantroom')
					{
					isCameraOnForcedPos = true;
					camFollow.x = 400;
					camFollow.y = 150;

					stageBuild.greymira.alpha = 0;
					stageBuild.cyanmira.alpha = 0;
					stageBuild.greytender.alpha = 1;
					stageBuild.noootomatomongus.alpha = 1;
					stageBuild.longfuckery.alpha = 1;
					stageBuild.noootomatomongus.animation.play('anim');
					stageBuild.longfuckery.animation.play('anim');
					stageBuild.greytender.animation.play('anim');
					stageBuild.ventNotSus.animation.play('anim');
					stageBuild.pretenderDark.animation.play('anim');
					FlxG.sound.play(Paths.sound('pretender_kill'));
					defaultCamZoom = 0.75;

					for (hud in allUIs)
					FlxTween.tween(hud, {alpha: 0}, 0.4);
					FlxTween.tween(gf, {alpha: 0.1}, 0.4);
					FlxTween.tween(dadOpponent, {alpha: 0.25}, 0.4);
					FlxTween.tween(boyfriend, {alpha: 0.25}, 0.4);

					new FlxTimer().start(9, function(tmr:FlxTimer)
					{
						endSong();
					});
					}
					else
					endSong();

			case 'pretender':
					if (SONG.stage.toLowerCase() == 'pretender')
					{
					isCameraOnForcedPos = true;
					camFollow.x = 400;
					camFollow.y = 150;
					endSong();
					}
					else
					endSong();

			case 'reinforcements':
						if (SONG.stage.toLowerCase() == 'henry')
						{
						for (hud in allUIs)
						FlxTween.tween(hud, {alpha: 0}, 0.4);
						FlxG.sound.play(Paths.sound('rhm_crash'));
						dadOpponent.playAnim('armed');
						mom.playAnim('armed');

						new FlxTimer().start(2.1, function(tmr:FlxTimer)
						{
							camGame.shake(0.005, 0.9);
						});

						new FlxTimer().start(2.8, function(tmr:FlxTimer)
						{
							stageBuild.armedGuy.alpha = 1;
							stageBuild.armedGuy.animation.play('crash');
						});
						new FlxTimer().start(3, function(tmr:FlxTimer)
						{
							camGame.alpha = 0;
							camOther.flash(FlxColor.WHITE, 3);
						});
						new FlxTimer().start(6, function(tmr:FlxTimer)
						{
						endSong();
						});
						}
						else
						endSong();
			default:
				endSong();
		}
		}
		else
				endSong();
	}

	private function callDefaultSongEnd()
	{
		var difficulty:String = '-' + CoolUtil.difficultyFromNumber(storyDifficulty).toLowerCase();
		difficulty = difficulty.replace('-normal', '');

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + difficulty, PlayState.storyPlaylist[0]);
		ForeverTools.killMusic([songMusic, vocals]);

		// deliberately did not use the main.switchstate as to not unload the assets
		FlxG.switchState(new PlayState());
	}

	var dialogueBox:DialogueBox;

	public function songIntroCutscene()
	{
		switch (curSong.toLowerCase())
		{
			case "winter-horrorland":
				inCutscene = true;
				var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				add(blackScreen);
				blackScreen.scrollFactor.set();
				camHUD.visible = false;

				new FlxTimer().start(0.1, function(tmr:FlxTimer)
				{
					remove(blackScreen);
					FlxG.sound.play(Paths.sound('Lights_Turn_On'));
					camFollow.y = -2050;
					camFollow.x += 200;
					FlxG.camera.focusOn(camFollow.getPosition());
					FlxG.camera.zoom = 1.5;

					new FlxTimer().start(0.8, function(tmr:FlxTimer)
					{
						camHUD.visible = true;
						remove(blackScreen);
						FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
							ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween)
							{
								startCountdown();
							}

						});

					});
				});
			case 'roses':
				// the same just play angery noise LOL
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));
				callTextbox();
			case 'thorns':
				inCutscene = true;
				for (hud in allUIs)
					hud.visible = false;

				var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
				red.scrollFactor.set();

				var senpaiEvil:FlxSprite = new FlxSprite();
				senpaiEvil.frames = Paths.getSparrowAtlas('cutscene/senpai/senpaiCrazy');
				senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
				senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
				senpaiEvil.scrollFactor.set();
				senpaiEvil.updateHitbox();
				senpaiEvil.screenCenter();

				add(red);
				add(senpaiEvil);
				senpaiEvil.alpha = 0;
				new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
				{
					senpaiEvil.alpha += 0.15;
					if (senpaiEvil.alpha < 1)
						swagTimer.reset();
					else
					{
						senpaiEvil.animation.play('idle');
						FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
						{
							remove(senpaiEvil);
							remove(red);
							FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
							{
								for (hud in allUIs)
									hud.visible = true;
								callTextbox();
							}, true);
						});
						new FlxTimer().start(3.2, function(deadTime:FlxTimer)
						{
							FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
						});
					}
				});
				case "armed":
				if (SONG.stage.toLowerCase() == 'henry')
				{
					inCutscene = true;
					boyfriend.alpha = 0.001;
					gf.alpha = 0.001;
					mom.alpha = 0.001;
					pet.alpha = 0.001;
					stageBuild.armedDark.alpha = 1;

					dadOpponent.playAnim('intro', false);
					stageBuild.dustcloud.animation.play('dust');
					add(stageBuild.dustcloud);

					new FlxTimer().start(3.2, function(tmr:FlxTimer)
					{
						FlxTween.tween(gf, {alpha: 1}, 1.5);
						FlxTween.tween(mom, {alpha: 1}, 1.5);
						FlxTween.tween(boyfriend, {alpha: 1}, 1.5);
						FlxTween.tween(pet, {alpha: 1}, 1.5);
						FlxTween.tween(stageBuild.armedDark, {alpha: 0}, 1.5);
					});

					new FlxTimer().start(6, function(tmr:FlxTimer)
					{
						callTextbox();
					});
				}
				else
				callTextbox();
				case "torture":
				if (SONG.stage.toLowerCase() == 'warehouse')
				{
				for (hud in allUIs)
				hud.alpha = 0;
				callTextbox();
				}
				else
				callTextbox();
			default:
				callTextbox();
		}
		//
	}

	function callTextbox() {
		var dialogPath = Paths.json(SONG.song.toLowerCase() + '/dialogue');
		if (sys.FileSystem.exists(dialogPath))
		{
			startedCountdown = false;

			dialogueBox = DialogueBox.createDialogue(sys.io.File.getContent(dialogPath));
			dialogueBox.cameras = [dialogueHUD];
			dialogueBox.whenDaFinish = startCountdown;

			add(dialogueBox);
		}
		else
		if (SONG.song.toLowerCase() == 'torture')
		{
		if (curStage.toLowerCase() == 'warehouse')
		{
		instantStart();
		}
		}
		else
			startCountdown();
	}

	function instantStart():Void{

		if (PlayState.SONG.stage.toLowerCase() == 'defeat')
		{
		if (SONG.song.toLowerCase() == 'defeat')
		{
		dadStrums.visible = false;
		}
		}

		startedCountdown = true;
		canPause = true;

		new FlxTimer().start(0.3, function(t){
			startSong();
		});

	}

	public static function skipCutscenes():Bool {
		// pretty messy but an if statement is messier
		if (Init.trueSettings.get('Skip Text') != null
		&& Std.isOfType(Init.trueSettings.get('Skip Text'), String)) {
			switch (cast(Init.trueSettings.get('Skip Text'), String))
			{
				case 'never':
					return false;
				case 'freeplay only':
					if (!isStoryMode)
						return true;
					else
						return false;
				default:
					return true;
			}
		}
		return false;
	}

	public static var swagCounter:Int = 0;

	private function startCountdown():Void
	{
		switch(curStage.toLowerCase()){
			case 'ejected':
				if (SONG.song.toLowerCase() == 'ejected')
				{
				camGame.visible = false;
				for (hud in allUIs)
				hud.alpha = 0;
				}
			case 'cargo':
				if (SONG.song.toLowerCase() == 'double-kill')
				{
				for (hud in allUIs)
				hud.alpha = 0;
				}
			case 'defeat':
				if (SONG.song.toLowerCase() == 'defeat')
				{
		uiHUD.scoreBar.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				}
			case 'finalem':
				if (SONG.song.toLowerCase() == 'finale')
				{
				for (hud in allUIs)
				hud.alpha = 0.001;
				uiHUD.healthBar.visible = false;
				uiHUD.healthBarBG.visible = false;
				uiHUD.iconP1.visible = false;
				uiHUD.iconP2.visible = false;
				uiHUD.scoreBar.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				}
			case 'monotone':
				if (SONG.song.toLowerCase() == 'identity-crisis')
				{
				for (hud in allUIs)
				hud.alpha = 0;
				}
		case 'charles':
		if (SONG.song.toLowerCase() == 'greatest-plan')
		{
		changeDadIcon("henry");
		changeBFIcon("bf");
		boyfriend.playAnim('intro', false);
		boyfriend.specialAnim = true;
		}
			case 'warehouse':
				if (SONG.song.toLowerCase() == 'torture')
				{
				for (hud in allUIs)
				hud.alpha = 0;
				}
		}

		if (PlayState.SONG.stage.toLowerCase() == 'defeat')
		{
		if (SONG.song.toLowerCase() == 'defeat')
		{
		dadStrums.visible = false;
		}
		}

		inCutscene = false;
		Conductor.songPosition = -(Conductor.crochet * 5);
		swagCounter = 0;

		camHUD.visible = true;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			startedCountdown = true;

			charactersDance(curBeat);

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', [
				ForeverTools.returnSkinAsset('ready', assetModifier, changeableSkin, 'UI'),
				ForeverTools.returnSkinAsset('set', assetModifier, changeableSkin, 'UI'),
				ForeverTools.returnSkinAsset('go', assetModifier, changeableSkin, 'UI')
			]);

			var introAlts:Array<String> = introAssets.get('default');
			for (value in introAssets.keys())
			{
				if (value == PlayState.curStage)
					introAlts = introAssets.get(value);
			}

			switch (swagCounter)
			{
				case 0:
					FlxG.sound.play(Paths.sound('intro3-' + assetModifier), 0.6);
					Conductor.songPosition = -(Conductor.crochet * 4);
						if (task != null)
						{
							task.start();
						}
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (assetModifier == 'pixel')
						ready.setGraphicSize(Std.int(ready.width * PlayState.daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro2-' + assetModifier), 0.6);

					Conductor.songPosition = -(Conductor.crochet * 3);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					if (assetModifier == 'pixel')
						set.setGraphicSize(Std.int(set.width * PlayState.daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('intro1-' + assetModifier), 0.6);

					Conductor.songPosition = -(Conductor.crochet * 2);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					if (assetModifier == 'pixel')
						go.setGraphicSize(Std.int(go.width * PlayState.daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introGo-' + assetModifier), 0.6);

					Conductor.songPosition = -(Conductor.crochet * 1);
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}