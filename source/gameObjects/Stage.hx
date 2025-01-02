package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.particles.FlxParticle;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.effects.FlxTrail;
import flixel.effects.particles.FlxEmitter;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import gameObjects.background.*;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;
import WalkingCrewmate;
import WiggleEffect.WiggleEffectType;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic>
{
	var halloweenBG:FNFSprite;
	var phillyCityLights:FlxTypedGroup<FNFSprite>;
	var phillyTrain:FNFSprite;
	var trainSound:FlxSound;

	public var limo:FNFSprite;

	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	var fastCar:FNFSprite;

	var upperBoppers:FNFSprite;
	var bottomBoppers:FNFSprite;
	var santa:FNFSprite;

	var bgGirls:BackgroundGirls;

	//polus
	var speaker:FlxSprite;
	public var snow:FlxSprite;
	public var crowd2:FlxSprite;

	//toogus
	public var bfvent:FlxSprite;
	public var ldSpeaker:FlxSprite;
	public var saxguy:FlxSprite;
	var walker:WalkingCrewmate;

	//reactor2
	public var toogusorange:FlxSprite;
	public var toogusblue:FlxSprite;
	var tooguswhite:FlxSprite;
	public var mainoverlay:FlxSprite;

	//ejected
	public var cloudScroll:FlxTypedGroup<FlxSprite>;
	var farClouds:FlxTypedGroup<FlxSprite>;
	var fgCloud:FlxSprite;
	var rightBuildings:Array<FlxSprite>;
	var leftBuildings:Array<FlxSprite>;
	var middleBuildings:Array<FlxSprite>;
	public var speedLines:FlxBackdrop;
	var bigCloudSpeed:Float = 10;
	var speedPass:Array<Float> = [11000, 11000, 11000, 11000];
	var farSpeedPass:Array<Float> = [11000, 11000, 11000, 11000, 11000, 11000, 11000];

	//airshipRoom
	public var whiteAwkward:FlxSprite;
	public var henryTeleporter:FlxSprite;

	//airship
	var airshipPlatform:FlxTypedGroup<FlxSprite>;
	var airFarClouds:FlxTypedGroup<FlxSprite>;
	var airMidClouds:FlxTypedGroup<FlxSprite>;
	var airCloseClouds:FlxTypedGroup<FlxSprite>;
	var airSpeedlines:FlxTypedGroup<FlxSprite>;
	public var airshipskyflash:FlxSprite;
	var airBigCloud:FlxSprite;

	//cargo
	public var cargoDark:FlxSprite;
	public var cargoAirsip:FlxSprite;
	public var cargoDarkFG:FlxSprite;
	public var mainoverlayDK:FlxSprite;
	public var defeatDKoverlay:FlxSprite;

	//defeat
	var defeatthing:FlxSprite;
	public var bodies2:FlxSprite;
	public var bodies:FlxSprite;
	public var defeatblack:FlxSprite;
	public var bodiesfront:FlxSprite;
	public var lightoverlay:FlxSprite;
	public var defeatDark:Bool = false;

	//finalem
	public var finaleFlashbackStuff:FlxSprite;
	public var defeatFinaleStuff:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var finaleLight:FlxSprite;
	public var finaleBGStuff:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	public var finaleFGStuff:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	public var finaleDarkFG:FlxSprite;

	//monotone
	var bg2:FlxSprite;
	var bgblue:FlxSprite;
	var bgred:FlxSprite;
	var bgblue2:FlxSprite;
	var bgred2:FlxSprite;
	var bgblue3:FlxSprite;
	var bgred3:FlxSprite;
	public var plagueBGBLUE:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	public var plagueBGRED:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	public var plagueBGPURPLE:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var wires:FlxSprite;
	var bggreen:FlxSprite;
	public var plagueBGGREEN:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	public var darkMono:FlxSprite;

	//polus2
	public var snow2:FlxSprite;

	//polus3
	public var emberEmitter:FlxEmitter;
	public var lavaOverlay:FlxSprite;

	//grey
	var crowd:FlxSprite = new FlxSprite();

	//plantroom
	var cloud1:FlxBackdrop;
	var cloud2:FlxBackdrop;
	var cloud3:FlxBackdrop;
	var cloud4:FlxBackdrop;
	var cloudbig:FlxBackdrop;
	public var greymira:FlxSprite;
	public var greytender:FlxSprite;
	public var ventNotSus:FlxSprite;
	public var cyanmira:FlxSprite;
	public var longfuckery:FlxSprite;
	public var noootomatomongus:FlxSprite;
	var oramira:FlxSprite;
	public var bluemira:FlxSprite;
	public var pot:FlxSprite;
	public var vines:FlxSprite;
	public var pretenderDark:FlxSprite;
	public var heartEmitter:FlxEmitter;

	//pretender
	var gfDeadPretender:FlxSprite;

	//chef
	var gray:FlxSprite = new FlxSprite();
	var saster:FlxSprite = new FlxSprite();
	public var chefBluelight:FlxSprite;
	public var chefBlacklight:FlxSprite;

	//lounge
	var loungebg:FlxSprite;
	public var loungelight:FlxSprite;
	public var o2dark:FlxSprite;
	public var o2lighting:FlxSprite;
	public var o2WTF:FlxSprite;

	//voting
	public var table:FlxSprite;

	//turbulence
	var turbFrontCloud:FlxTypedGroup<FlxSprite>;
	var backerclouds:FlxSprite;
	var hotairballoon:FlxSprite;
	var midderclouds:FlxSprite;
	public var hookarm:FlxSprite;
	public var clawshands:FlxSprite;
	public var turblight:FlxSprite;
	public var turbSpeed:Float = 1.0;

	//victory
	var VICTORY_TEXT:FlxSprite;
	var bg_vic:FlxSprite;
	public var bg_jelq:FlxSprite;
	public var bg_war:FlxSprite;
	public var bg_jor:FlxSprite;
	public var spotlights:FlxSprite;
	public var vicPulse:FlxSprite;
	public var fog_front:FlxSprite;

	//henry
	public var armedGuy:FlxSprite;
	public var armedDark:FlxSprite;
	public var dustcloud:FlxSprite;

	//loggo
	var peopleloggo:FlxSprite;
	var fireloggo:FlxSprite;

	//who
	public var meeting:FlxSprite;
	public var whoAngered:FlxSprite;
	public var furiousRage:FlxSprite;
	public var emergency:FlxSprite;
	public var space:FlxSprite;
	public var starsBG:FlxBackdrop;
	public var starsFG:FlxBackdrop;

	//dave
	public var daveDIE:FlxSprite;

	//attack
	public var nickt:FlxSprite;
	public var nicktmvp:FlxSprite;
	public var toogusblue2:FlxSprite;
	public var thebackground:FlxSprite;

	//warehouse
	var torfloor:FlxSprite;
	var torwall:FlxSprite;
	public var torglasses:FlxSprite;
	public var windowlights:FlxSprite;
	public var leftblades:FlxSprite;
	public var rightblades:FlxSprite;
	public var ROZEBUD_ILOVEROZEBUD_HEISAWESOME:FlxSprite; // this is the var name and you can't stop me -rzbd

	//tripletrouble
	public var wiggleEffect:WiggleEffect;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var foreground:FlxTypedGroup<FlxBasic>;

	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;
	public var MOM_X:Float = 100;
	public var MOM_Y:Float = 100;

	public function new(curStage)
	{
		super();
		this.curStage = curStage;

		/// get hardcoded stage type if chart is fnf style
		if (PlayState.determinedChartType == "FNF")
		{
			// this is because I want to avoid editing the fnf chart type
			// custom stage stuffs will come with forever charts
			if (PlayState.SONG.stage == null)
			{
			switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()))
			{
				case 'spookeez' | 'south' | 'monster':
					curStage = 'spooky';
				case 'pico' | 'blammed' | 'philly-nice':
					curStage = 'philly';
				case 'milf' | 'satin-panties' | 'high':
					curStage = 'highway';
				case 'cocoa' | 'eggnog':
					curStage = 'mall';
				case 'winter-horrorland':
					curStage = 'mallEvil';
				case 'senpai' | 'roses':
					curStage = 'school';
				case 'thorns':
					curStage = 'schoolEvil';
				default:
					curStage = 'stage';
			}
			}
			else
			curStage = PlayState.SONG.stage;

			PlayState.curStage = curStage;
		}

		// to apply to foreground use foreground.add(); instead of add();
		foreground = new FlxTypedGroup<FlxBasic>();

		//
		switch (curStage)
		{
			case 'spooky':
				curStage = 'spooky';
				// halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('backgrounds/' + curStage + '/halloween_bg');

				halloweenBG = new FNFSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				add(halloweenBG);

			// isHalloween = true;
			case 'philly':
				curStage = 'philly';

				var bg:FNFSprite = new FNFSprite(-100).loadGraphic(Paths.image('backgrounds/' + curStage + '/sky'));
				bg.scrollFactor.set(0.1, 0.1);
				add(bg);

				var city:FNFSprite = new FNFSprite(-10).loadGraphic(Paths.image('backgrounds/' + curStage + '/city'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				add(city);

				phillyCityLights = new FlxTypedGroup<FNFSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:FNFSprite = new FNFSprite(city.x).loadGraphic(Paths.image('backgrounds/' + curStage + '/win' + i));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}

				var streetBehind:FNFSprite = new FNFSprite(-40, 50).loadGraphic(Paths.image('backgrounds/' + curStage + '/behindTrain'));
				add(streetBehind);

				phillyTrain = new FNFSprite(2000, 360).loadGraphic(Paths.image('backgrounds/' + curStage + '/train'));
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				// var cityLights:FNFSprite = new FNFSprite().loadGraphic(AssetPaths.win0.png);

				var street:FNFSprite = new FNFSprite(-40, streetBehind.y).loadGraphic(Paths.image('backgrounds/' + curStage + '/street'));
				add(street);
			case 'highway':
				curStage = 'highway';
				PlayState.defaultCamZoom = 0.90;

				var skyBG:FNFSprite = new FNFSprite(-120, -50).loadGraphic(Paths.image('backgrounds/' + curStage + '/limoSunset'));
				skyBG.scrollFactor.set(0.1, 0.1);
				add(skyBG);

				var bgLimo:FNFSprite = new FNFSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bgLimo');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				add(bgLimo);

				grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				add(grpLimoDancers);

				for (i in 0...5)
				{
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancers.add(dancer);
				}

				var overlayShit:FNFSprite = new FNFSprite(-500, -600).loadGraphic(Paths.image('backgrounds/' + curStage + '/limoOverlay'));
				overlayShit.alpha = 0.5;
				// add(overlayShit);

				// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

				// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

				// overlayShit.shader = shaderBullshit;

				var limoTex = Paths.getSparrowAtlas('backgrounds/' + curStage + '/limoDrive');

				limo = new FNFSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				fastCar = new FNFSprite(-300, 160).loadGraphic(Paths.image('backgrounds/' + curStage + '/fastCarLol'));
			// loadArray.add(limo);
			case 'mall':
				curStage = 'mall';
				PlayState.defaultCamZoom = 0.80;

				var bg:FNFSprite = new FNFSprite(-1000, -500).loadGraphic(Paths.image('backgrounds/' + curStage + '/bgWalls'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				upperBoppers = new FNFSprite(-240, -90);
				upperBoppers.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/upperBop');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				add(upperBoppers);

				var bgEscalator:FNFSprite = new FNFSprite(-1100, -600).loadGraphic(Paths.image('backgrounds/' + curStage + '/bgEscalator'));
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				add(bgEscalator);

				var tree:FNFSprite = new FNFSprite(370, -250).loadGraphic(Paths.image('backgrounds/' + curStage + '/christmasTree'));
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				add(tree);

				bottomBoppers = new FNFSprite(-300, 140);
				bottomBoppers.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bottomBop');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				add(bottomBoppers);

				var fgSnow:FNFSprite = new FNFSprite(-600, 700).loadGraphic(Paths.image('backgrounds/' + curStage + '/fgSnow'));
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				add(fgSnow);

				santa = new FNFSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/santa');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				add(santa);
			case 'mallEvil':
				curStage = 'mallEvil';
				var bg:FNFSprite = new FNFSprite(-400, -500).loadGraphic(Paths.image('backgrounds/mall/evilBG'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				add(bg);

				var evilTree:FNFSprite = new FNFSprite(300, -300).loadGraphic(Paths.image('backgrounds/mall/evilTree'));
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				add(evilTree);

				var evilSnow:FNFSprite = new FNFSprite(-200, 700).loadGraphic(Paths.image("backgrounds/mall/evilSnow"));
				evilSnow.antialiasing = true;
				add(evilSnow);
			case 'school':
				curStage = 'school';

				PlayState.defaultCamZoom = 1;

				var bgSky:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/stars'));
				add(bgSky);
				bgSky.antialiasing = false;
				bgSky.scrollFactor.set(0.1, 0.1);

				var repositionShit = -200;

				var bgStreet:FNFSprite = new FNFSprite(repositionShit, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/weebStreet'));
				add(bgStreet);
				bgStreet.antialiasing = false;
				bgStreet.scrollFactor.set(0.95, 0.95);

				var widShit = Std.int(bgStreet.width * 6);

				bgStreet.setGraphicSize(widShit);
				bgStreet.updateHitbox();
			case 'schoolEvil':
				var posX = 400;
				var posY = 200;
				var bg:FNFSprite = new FNFSprite(posX, posY);
				bg.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/animatedEvilSchool');
				bg.animation.addByPrefix('idle', 'background 2', 24);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 0.9);
				bg.scale.set(6, 6);
				add(bg);

			case 'polus':
				curStage = 'polus';
				PlayState.defaultCamZoom = 0.75;

				var sky:FlxSprite = new FlxSprite(-400, -400).loadGraphic(Paths.image('backgrounds/' + curStage + '/polus_custom_sky'));
				sky.antialiasing = true;
				sky.scrollFactor.set(0.5, 0.5);
				sky.setGraphicSize(Std.int(sky.width * 1.4));
				sky.active = false;
				add(sky);

				var rocks:FlxSprite = new FlxSprite(-700, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/polusrocks'));
				rocks.updateHitbox();
				rocks.antialiasing = true;
				rocks.scrollFactor.set(0.6, 0.6);
				rocks.active = false;
				add(rocks);

				var hills:FlxSprite = new FlxSprite(-1050, -180.55).loadGraphic(Paths.image('backgrounds/' + curStage + '/polusHills'));
				hills.updateHitbox();
				hills.antialiasing = true;
				hills.scrollFactor.set(0.9, 0.9);
				hills.active = false;
				add(hills);

				var warehouse:FlxSprite = new FlxSprite(50, -400).loadGraphic(Paths.image('backgrounds/' + curStage + '/polus_custom_lab'));
				warehouse.updateHitbox();
				warehouse.antialiasing = true;
				warehouse.scrollFactor.set(1, 1);
				warehouse.active = false;
				add(warehouse);

				var ground:FlxSprite = new FlxSprite(-1350, 80).loadGraphic(Paths.image('backgrounds/' + curStage + '/polus_custom_floor'));
				ground.updateHitbox();
				ground.antialiasing = true;
				ground.scrollFactor.set(1, 1);
				ground.active = false;
				add(ground);

				speaker = new FlxSprite(300, 185);
				speaker.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/speakerlonely');
				speaker.animation.addByPrefix('bop', 'speakers lonely', 24, false);
				speaker.animation.play('bop');
				speaker.setGraphicSize(Std.int(speaker.width * 1));
				speaker.antialiasing = false;
				speaker.scrollFactor.set(1, 1);
				speaker.active = true;
				speaker.antialiasing = true;
				if (PlayState.SONG.song.toLowerCase() == 'sabotage')
				{
					add(speaker);
				}
				if (PlayState.SONG.song.toLowerCase() == 'meltdown')
				{
					var bfdead:FlxSprite = new FlxSprite(600, 525).loadGraphic(Paths.image('backgrounds/' + curStage + '/bfdead'));
					bfdead.setGraphicSize(Std.int(bfdead.width * 0.8));
					bfdead.updateHitbox();
					bfdead.antialiasing = true;
					bfdead.scrollFactor.set(1, 1);
					bfdead.active = false;
					add(speaker);
					add(bfdead);
				}

				snow = new FlxSprite(0, -250);
				snow.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/snow');
				snow.animation.addByPrefix('cum', 'cum', 24);
				snow.animation.play('cum');
				snow.scrollFactor.set(1, 1);
				snow.antialiasing = true;
				snow.updateHitbox();
				snow.setGraphicSize(Std.int(snow.width * 2));

				crowd2 = new FlxSprite(-900, 150);
				crowd2.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/boppers_meltdown');
				crowd2.animation.addByPrefix('bop', 'BoppersMeltdown', 24, false);
				crowd2.animation.play('bop');
				crowd2.scrollFactor.set(1.5, 1.5);
				crowd2.antialiasing = true;
				crowd2.updateHitbox();
				crowd2.scale.set(1, 1);

			case 'toogus':
				curStage = 'toogus';
				PlayState.defaultCamZoom = 0.9;
				var bg:FlxSprite = new FlxSprite(-1600, 50).loadGraphic(Paths.image('backgrounds/' + curStage + '/mirabg'));
				bg.setGraphicSize(Std.int(bg.width * 1.06));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var fg:FlxSprite = new FlxSprite(-1600, 50).loadGraphic(Paths.image('backgrounds/' + curStage + '/mirafg'));
				fg.setGraphicSize(Std.int(fg.width * 1.06));
				fg.antialiasing = true;
				fg.scrollFactor.set(1, 1);
				fg.active = false;
				add(fg);

				if (PlayState.SONG.song.toLowerCase() == 'sussus-toogus')
				{
					walker = new WalkingCrewmate(FlxG.random.int(0, 1), [-700, 1850], 50, 0.8);
					add(walker);

					var walker2:WalkingCrewmate = new WalkingCrewmate(FlxG.random.int(2, 3), [-700, 1850], 50, 0.8);
					add(walker2);

					var walker3:WalkingCrewmate = new WalkingCrewmate(FlxG.random.int(4, 5), [-700, 1850], 50, 0.8);
					add(walker3);
				}

				if (PlayState.SONG.song.toLowerCase() == 'lights-down')
				{
					bfvent = new FlxSprite(70, 200);
					bfvent.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bf_mira_vent');
					bfvent.animation.addByPrefix('vent', 'bf vent', 24, false);
					bfvent.animation.play('vent');
					bfvent.scrollFactor.set(1, 1);
					bfvent.active = true;
					bfvent.antialiasing = true;
					bfvent.alpha = 0.001;
					add(bfvent);
				}

				var tbl:FlxSprite = new FlxSprite(-1600, 50).loadGraphic(Paths.image('backgrounds/' + curStage + '/table_bg'));
				tbl.setGraphicSize(Std.int(tbl.width * 1.06));
				tbl.antialiasing = true;
				tbl.scrollFactor.set(1, 1);
				tbl.active = false;
				add(tbl);

				if (PlayState.SONG.song.toLowerCase() == 'lights-down')
				{
					ldSpeaker = new FlxSprite(400, 420);
					ldSpeaker.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/stereo_taken');
					ldSpeaker.animation.addByPrefix('boom', 'stereo boom', 24, false);
					ldSpeaker.scrollFactor.set(1, 1);
					ldSpeaker.active = true;
					ldSpeaker.antialiasing = true;
					ldSpeaker.visible = false;
					add(ldSpeaker);
				}

				saxguy = new FlxSprite(0, 0);
				saxguy.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/cyan_toogus');
				saxguy.animation.addByPrefix('bop', 'Cyan Dancy', 24, true);
				saxguy.animation.play('bop');
				saxguy.updateHitbox();
				saxguy.antialiasing = true;
				saxguy.scrollFactor.set(1, 1);
				saxguy.setGraphicSize(Std.int(saxguy.width * 1));
				saxguy.active = true;

			case 'reactor2':
				curStage = 'reactor2';
				PlayState.defaultCamZoom = 0.7;

				var bg0:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/wallbgthing'));
				bg0.updateHitbox();
				bg0.antialiasing = true;
				bg0.scrollFactor.set(1, 1);
				bg0.active = false;
				add(bg0);

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/floornew'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				toogusorange = new FlxSprite(875, 915);
				toogusorange.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/yellowcoti');
				toogusorange.animation.addByPrefix('bop', 'Pillars with crewmates instance 1', 24, false);
				toogusorange.animation.play('bop');
				toogusorange.setGraphicSize(Std.int(toogusorange.width * 1));
				toogusorange.scrollFactor.set(1, 1);
				toogusorange.active = true;
				toogusorange.antialiasing = true;
				add(toogusorange);

				var bg2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/backbars'));
				bg2.updateHitbox();
				bg2.antialiasing = true;
				bg2.scrollFactor.set(1, 1);
				bg2.active = false;
				add(bg2);

				toogusblue = new FlxSprite(450, 995);
				toogusblue.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/browngeoff');
				toogusblue.animation.addByPrefix('bop', 'Pillars with crewmates instance 1', 24, false);
				toogusblue.animation.play('bop');
				toogusblue.setGraphicSize(Std.int(toogusblue.width * 1));
				toogusblue.scrollFactor.set(1, 1);
				toogusblue.active = true;
				toogusblue.antialiasing = true;
				add(toogusblue);

				var bg3:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/frontpillars'));
				bg3.updateHitbox();
				bg3.antialiasing = true;
				bg3.scrollFactor.set(1, 1);
				bg3.active = false;
				add(bg3);

				tooguswhite = new FlxSprite(1200, 100);
				tooguswhite.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/ball lol');
				tooguswhite.animation.addByPrefix('bop', 'core instance 1', 24, false);
				tooguswhite.animation.play('bop');
				tooguswhite.scrollFactor.set(1, 1);
				tooguswhite.active = true;
				tooguswhite.antialiasing = true;
				add(tooguswhite);

				var lightoverlay:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/frontblack'));
				lightoverlay.antialiasing = true;
				lightoverlay.scrollFactor.set(1, 1);
				lightoverlay.active = false;

				var mainoverlay:FlxSprite = new FlxSprite(750, 100).loadGraphic(Paths.image('backgrounds/' + curStage + '/yeahman'));
				mainoverlay.antialiasing = true;
				mainoverlay.animation.addByPrefix('bop', 'Reactor Overlay Top instance 1', 24, true);
				mainoverlay.animation.play('bop');
				mainoverlay.scrollFactor.set(1, 1);
				mainoverlay.active = false;

			case 'ejected':
				PlayState.defaultCamZoom = 0.45;
				curStage = 'ejected';
				cloudScroll = new FlxTypedGroup<FlxSprite>();
				farClouds = new FlxTypedGroup<FlxSprite>();
				var sky:FlxSprite = new FlxSprite(-2372.25, -4181.7).loadGraphic(Paths.image('backgrounds/' + curStage + '/sky'));
				sky.antialiasing = true;
				sky.updateHitbox();
				sky.scrollFactor.set(0, 0);
				add(sky);

				fgCloud = new FlxSprite(-2660.4, -402).loadGraphic(Paths.image('backgrounds/' + curStage + '/fgClouds'));
				fgCloud.antialiasing = true;
				fgCloud.updateHitbox();
				fgCloud.scrollFactor.set(0.2, 0.2);
				add(fgCloud);

				for (i in 0...farClouds.members.length)
				{
					add(farClouds.members[i]);
				}
				add(farClouds);

				rightBuildings = [];
				leftBuildings = [];
				middleBuildings = [];
				for (i in 0...2)
				{
					var rightBuilding = new FlxSprite(1022.3, -390.45);
					rightBuilding.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/buildingSheet');
					rightBuilding.animation.addByPrefix('1', 'BuildingB1', 24, false);
					rightBuilding.animation.addByPrefix('2', 'BuildingB2', 24, false);
					rightBuilding.animation.play('1');
					rightBuilding.antialiasing = true;
					rightBuilding.updateHitbox();
					rightBuilding.scrollFactor.set(0.5, 0.5);
					add(rightBuilding);
					rightBuildings.push(rightBuilding);
				}

				for (i in 0...2)
				{
					var middleBuilding = new FlxSprite(-76.15, 1398.5);
					middleBuilding.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/buildingSheet');
					middleBuilding.animation.addByPrefix('1', 'BuildingA1', 24, false);
					middleBuilding.animation.addByPrefix('2', 'BuildingA2', 24, false);
					middleBuilding.animation.play('1');
					middleBuilding.antialiasing = true;
					middleBuilding.updateHitbox();
					middleBuilding.scrollFactor.set(0.5, 0.5);
					add(middleBuilding);
					middleBuildings.push(middleBuilding);
				}

				for (i in 0...2)
				{
					var leftBuilding = new FlxSprite(-1099.3, 7286.55);
					leftBuilding.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/buildingSheet');
					leftBuilding.animation.addByPrefix('1', 'BuildingB1', 24, false);
					leftBuilding.animation.addByPrefix('2', 'BuildingB2', 24, false);
					leftBuilding.animation.play('1');
					leftBuilding.antialiasing = true;
					leftBuilding.updateHitbox();
					leftBuilding.scrollFactor.set(0.5, 0.5);
					add(leftBuilding);
					leftBuildings.push(leftBuilding);
				}

				rightBuildings[0].y = 6803.1;
				middleBuildings[0].y = 8570.5;
				leftBuildings[0].y = 14050.2;

				for (i in 0...3)
				{
					// now i could add the clouds manually
					// but i wont!!! trolled
					var newCloud:FlxSprite = new FlxSprite();
					newCloud.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/scrollingClouds');
					newCloud.animation.addByPrefix('idle', 'Cloud' + i, 24, false);
					newCloud.animation.play('idle');
					newCloud.updateHitbox();
					newCloud.alpha = 1;

					switch (i)
					{
						case 0:
							newCloud.setPosition(-9.65, -224.35);
							newCloud.scrollFactor.set(0.8, 0.8);
						case 1:
							newCloud.setPosition(-1342.85, -350.45);
							newCloud.scrollFactor.set(0.6, 0.6);
						case 2:
							newCloud.setPosition(1784.65, -957.05);
							newCloud.scrollFactor.set(1.3, 1.3);
						case 3:
							newCloud.setPosition(-2217.45, -1377.65);
							newCloud.scrollFactor.set(1, 1);
					}
					cloudScroll.add(newCloud);
				}

				for (i in 0...7)
				{
					var newCloud:FlxSprite = new FlxSprite();
					newCloud.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/scrollingClouds');
					newCloud.animation.addByPrefix('idle', 'Cloud' + i, 24, false);
					newCloud.animation.play('idle');
					newCloud.updateHitbox();
					newCloud.alpha = 0.5;

					switch (i)
					{
						case 0:
							newCloud.setPosition(-1308, -1039.9);
						case 1:
							newCloud.setPosition(464.3, -890.5);
						case 2:
							newCloud.setPosition(2458.45, -1085.85);
						case 3:
							newCloud.setPosition(-666.95, -172.05);
						case 4:
							newCloud.setPosition(-1616.6, 1016.95);
						case 5:
							newCloud.setPosition(1714.25, 200.45);
						case 6:
							newCloud.setPosition(-167.05, 710.25);
					}
					farClouds.add(newCloud);
				}

				speedLines = new FlxBackdrop(Paths.image('backgrounds/' + curStage + '/speedLines'));
				speedLines.antialiasing = true;
				speedLines.updateHitbox();
				speedLines.scrollFactor.set(1.3, 1.3);
				speedLines.alpha = 0.3;

			case 'airshipRoom': // thanks fabs
				PlayState.defaultCamZoom = 0.7;

				var element8 = new FlxSprite(-1468, -995).loadGraphic(Paths.image('backgrounds/' + curStage + '/fartingSky'));
				element8.antialiasing = true;
				element8.scale.set(1, 1);
				element8.updateHitbox();
				element8.scrollFactor.set(0.3, 0.3);
				add(element8);

				var element5 = new FlxSprite(-1125, 284).loadGraphic(Paths.image('backgrounds/' + curStage + '/backSkyyellow'));
				element5.antialiasing = true;
				element5.scale.set(1, 1);
				element5.updateHitbox();
				element5.scrollFactor.set(0.4, 0.7);
				add(element5);

				var element6 = new FlxSprite(1330, 283).loadGraphic(Paths.image('backgrounds/' + curStage + '/yellow cloud 3'));
				element6.antialiasing = true;
				element6.scale.set(1, 1);
				element6.updateHitbox();
				element6.scrollFactor.set(0.5, 0.8);
				add(element6);

				var element7 = new FlxSprite(-837, 304).loadGraphic(Paths.image('backgrounds/' + curStage + '/yellow could 2'));
				element7.antialiasing = true;
				element7.scale.set(1, 1);
				element7.updateHitbox();
				element7.scrollFactor.set(0.6, 0.9);
				add(element7);

				var element2 = new FlxSprite(-1387, -1231).loadGraphic(Paths.image('backgrounds/' + curStage + '/window'));
				element2.antialiasing = true;
				element2.scale.set(1, 1);
				element2.updateHitbox();
				element2.scrollFactor.set(1, 1);
				add(element2);

				var element4 = new FlxSprite(-1541, 242).loadGraphic(Paths.image('backgrounds/' + curStage + '/cloudYellow 1'));
				element4.antialiasing = true;
				element4.scale.set(1, 1);
				element4.updateHitbox();
				element4.scrollFactor.set(0.8, 0.8);
				add(element4);

				var element1 = new FlxSprite(-642, 325).loadGraphic(Paths.image('backgrounds/' + curStage + '/backDlowFloor'));
				element1.antialiasing = true;
				element1.scale.set(1, 1);
				element1.updateHitbox();
				element1.scrollFactor.set(0.9, 1);
				add(element1);

				var element0 = new FlxSprite(-2440, 336).loadGraphic(Paths.image('backgrounds/' + curStage + '/DlowFloor'));
				element0.antialiasing = true;
				element0.scale.set(1, 1);
				element0.updateHitbox();
				element0.scrollFactor.set(1, 1);
				add(element0);

				var element3 = new FlxSprite(-1113, -1009).loadGraphic(Paths.image('backgrounds/' + curStage + '/glowYellow'));
				element3.antialiasing = true;
				element3.blend = ADD;
				element3.scale.set(1, 1);
				element3.updateHitbox();
				element3.scrollFactor.set(1, 1);
				add(element3);

				whiteAwkward = new FlxSprite(298, 480);
				whiteAwkward.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/white_awkward');
				whiteAwkward.animation.addByPrefix('sweat', 'fetal position', 24, true);
				whiteAwkward.animation.addByPrefix('stare', 'white stare', 24, false);
				whiteAwkward.animation.play('sweat');
				whiteAwkward.antialiasing = true;
				add(whiteAwkward);

				if (PlayState.isStoryMode && PlayState.SONG.song.toLowerCase() != 'oversight')
				{
					henryTeleporter = new FlxSprite(998, 620).loadGraphic(Paths.image('backgrounds/' + curStage + '/Teleporter'));
					henryTeleporter.antialiasing = true;
					henryTeleporter.scale.set(1, 1);
					henryTeleporter.updateHitbox();
					henryTeleporter.scrollFactor.set(1, 1);
					henryTeleporter.visible = true;
					add(henryTeleporter);
				}

			case 'airship':
				PlayState.defaultCamZoom = 1.3;
			    airshipPlatform = new FlxTypedGroup<FlxSprite>();
				airFarClouds = new FlxTypedGroup<FlxSprite>();
				airMidClouds = new FlxTypedGroup<FlxSprite>();
				airCloseClouds = new FlxTypedGroup<FlxSprite>();
				airSpeedlines = new FlxTypedGroup<FlxSprite>();

				var sky:FlxSprite = new FlxSprite(-1404, -897.55).loadGraphic(Paths.image('backgrounds/' + curStage + '/sky'));
				sky.antialiasing = true;
				sky.updateHitbox();
				sky.scale.set(1.5, 1.5);
				sky.scrollFactor.set(0, 0);
				add(sky);

				airshipskyflash = new FlxSprite(0, -200);
				airshipskyflash.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/screamsky');
				airshipskyflash.animation.addByPrefix('bop', 'scream sky  instance 1', 24, false);
				airshipskyflash.setGraphicSize(Std.int(airshipskyflash.width * 3));
				airshipskyflash.antialiasing = false;
				airshipskyflash.scrollFactor.set(1, 1);
				airshipskyflash.active = true;
				add(airshipskyflash);
				airshipskyflash.alpha = 0;

				for (i in 0...2)
				{
					var cloud:FlxSprite = new FlxSprite(-1148.05, -142.2).loadGraphic(Paths.image('backgrounds/' + curStage + '/farthestClouds'));
					switch (i)
					{
						case 1:
							cloud.setPosition(-5678.95, -142.2);
						case 2:
							cloud.setPosition(3385.95, -142.2);
					}
					cloud.antialiasing = true;
					cloud.updateHitbox();
					cloud.scrollFactor.set(0.1, 0.1);
					airFarClouds.add(cloud);
				}
				add(airFarClouds);

				for (i in 0...2)
				{
					var cloud:FlxSprite = new FlxSprite(-1162.4, 76.55).loadGraphic(Paths.image('backgrounds/' + curStage + '/backClouds'));
					switch (i)
					{
						case 1:
							cloud.setPosition(3352.4, 76.55);
						case 2:
							cloud.setPosition(-5651.4, 76.55);
					}
					cloud.antialiasing = true;
					cloud.updateHitbox();
					cloud.scrollFactor.set(0.2, 0.2);
					airMidClouds.add(cloud);
				}
				add(airMidClouds);

				var airship:FlxSprite = new FlxSprite(1114.75, -873.05).loadGraphic(Paths.image('backgrounds/' + curStage + '/airship'));
				airship.antialiasing = true;
				airship.updateHitbox();
				airship.scrollFactor.set(0.25, 0.25);
				add(airship);

				var fan:FlxSprite = new FlxSprite(2285.4, 102);
				fan.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/airshipFan');
				fan.animation.addByPrefix('idle', 'ala avion instance 1', 24, true);
				fan.animation.play('idle');
				fan.updateHitbox();
				fan.antialiasing = true;
				fan.scrollFactor.set(0.27, 0.27);
				add(fan);

				airBigCloud = new FlxSprite(3507.15, -744.2).loadGraphic(Paths.image('backgrounds/' + curStage + '/bigCloud'));
				airBigCloud.antialiasing = true;
				airBigCloud.updateHitbox();
				airBigCloud.scrollFactor.set(0.4, 0.4);
				add(airBigCloud);

				for (i in 0...2)
				{
					var cloud:FlxSprite = new FlxSprite(-1903.9, 422.15).loadGraphic(Paths.image('backgrounds/' + curStage + '/frontClouds'));
					switch (i)
					{
						case 1:
							cloud.setPosition(-9900.2, 422.15);
						case 2:
							cloud.setPosition(6092.2, 422.15);
					}
					cloud.antialiasing = true;
					cloud.updateHitbox();
					cloud.scrollFactor.set(0.3, 0.3);
					airCloseClouds.add(cloud);
				}
				add(airCloseClouds);

				for (i in 0...2)
				{
					var platform:FlxSprite = new FlxSprite(-1454.2, 282.25).loadGraphic(Paths.image('backgrounds/' + curStage + '/fgPlatform'));
					switch (i)
					{
						case 1:
							platform.setPosition(-7184.8, 282.25);

						case 2:
							platform.setPosition(4275.15, 282.25);
					}
					platform.antialiasing = true;
					platform.updateHitbox();
					platform.scrollFactor.set(1, 1);
					add(platform);
					airshipPlatform.add(platform);
				}

				airshipskyflash = new FlxSprite(0, -300);
				airshipskyflash.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/screamsky');
				airshipskyflash.animation.addByPrefix('bop', 'scream sky  instance 1', 24, false);
				airshipskyflash.setGraphicSize(Std.int(airshipskyflash.width * 3));
				airshipskyflash.antialiasing = false;
				airshipskyflash.scrollFactor.set(1, 1);
				airshipskyflash.active = true;
				add(airshipskyflash);
				airshipskyflash.alpha = 0;

			case 'cargo': // double kill
				PlayState.defaultCamZoom = 0.7;
				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/cargo'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				cargoDark = new FlxSprite(-1000, -1000).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
				cargoDark.antialiasing = true;
				cargoDark.updateHitbox();
				cargoDark.scrollFactor.set();
				cargoDark.alpha = 0.001;
				add(cargoDark);
				
				cargoAirsip = new FlxSprite(2200, 800).loadGraphic(Paths.image('backgrounds/' + curStage + '/airshipFlashback'));
				cargoAirsip.antialiasing = true;
				cargoAirsip.updateHitbox();
				cargoAirsip.scrollFactor.set(1,1);
				cargoAirsip.setGraphicSize(Std.int(cargoAirsip.width * 1.3));
				cargoAirsip.alpha = 0.001;
				add(cargoAirsip);

				cargoDarkFG = new FlxSprite(-1000, -1000).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
				cargoDarkFG.antialiasing = true;
				cargoDarkFG.updateHitbox();
				cargoDarkFG.scrollFactor.set();

				mainoverlayDK = new FlxSprite(-100, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/overlay ass dk'));
				mainoverlayDK.antialiasing = true;
				mainoverlayDK.scrollFactor.set(1, 1);
				mainoverlayDK.active = false;
				mainoverlayDK.alpha = 0.6;
				mainoverlayDK.blend = ADD;

				defeatDKoverlay = new FlxSprite(900, 350).loadGraphic(Paths.image('backgrounds/' + curStage + '/iluminao omaga'));
				defeatDKoverlay.antialiasing = true;
				defeatDKoverlay.scrollFactor.set(1, 1);
				defeatDKoverlay.active = false;
				defeatDKoverlay.blend = ADD;
				defeatDKoverlay.alpha = 0.001;

			case 'defeat':
				curStage = 'defeat';
				PlayState.defaultCamZoom = 0.6;

				defeatthing = new FlxSprite(-400, -150);
				defeatthing.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/defeat');
				defeatthing.animation.addByPrefix('bop', 'defeat', 24, false);
				defeatthing.animation.play('bop');
				defeatthing.setGraphicSize(Std.int(defeatthing.width * 1.3));
				defeatthing.antialiasing = true;
				defeatthing.scrollFactor.set(0.8, 0.8);
				defeatthing.active = true;
				add(defeatthing);

				bodies2 = new FlxSprite(-500, 150).loadGraphic(Paths.image('backgrounds/' + curStage + '/lol thing'));
				bodies2.antialiasing = true;
				bodies2.setGraphicSize(Std.int(bodies2.width * 1.3));
				bodies2.scrollFactor.set(0.9, 0.9);
				bodies2.active = false;
				bodies2.alpha = 0;
				add(bodies2);

				bodies = new FlxSprite(-2760, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/deadBG'));
				bodies.setGraphicSize(Std.int(bodies.width * 0.4));
				bodies.antialiasing = true;
				bodies.scrollFactor.set(0.9, 0.9);
				bodies.active = false;
				bodies.alpha = 0;
				add(bodies);

				defeatblack = new FlxSprite().makeGraphic(FlxG.width * 4, FlxG.height + 700, FlxColor.BLACK);
				defeatblack.alpha = 0;
				defeatblack.screenCenter(X);
				defeatblack.screenCenter(Y);
				add(defeatblack);

				mainoverlayDK = new FlxSprite(250, 125).loadGraphic(Paths.image('backgrounds/' + curStage + '/defeatfnf'));
				mainoverlayDK.antialiasing = true;
				mainoverlayDK.scrollFactor.set(1, 1);
				mainoverlayDK.active = false;
				mainoverlayDK.setGraphicSize(Std.int(mainoverlayDK.width * 2));
				mainoverlayDK.alpha = 0;
				add(mainoverlayDK);

				bodiesfront = new FlxSprite(-2830, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/deadFG'));
				bodiesfront.setGraphicSize(Std.int(bodiesfront.width * 0.4));
				bodiesfront.antialiasing = true;
				bodiesfront.scrollFactor.set(0.5, 1);
				bodiesfront.active = false;
				bodiesfront.alpha = 0;

				PlayState.missLimited = true;

				lightoverlay = new FlxSprite(-550, -100).loadGraphic(Paths.image('backgrounds/' + curStage + '/iluminao omaga'));
				lightoverlay.antialiasing = true;
				lightoverlay.scrollFactor.set(1, 1);
				lightoverlay.active = false;
				lightoverlay.blend = ADD;

			case 'finalem':
				curStage = 'finalem';
				PlayState.defaultCamZoom = 0.4;

				finaleFlashbackStuff = new FlxSprite(-290, -160);
				finaleFlashbackStuff.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/finaleFlashback');
				finaleFlashbackStuff.animation.addByPrefix('moog', 'finaleFlashback moog', 24, false);
				finaleFlashbackStuff.animation.addByPrefix('toog', 'finaleFlashback toog', 24, false);
				finaleFlashbackStuff.animation.addByPrefix('doog', 'finaleFlashback doog', 24, false);
				finaleFlashbackStuff.animation.play('moog');
				finaleFlashbackStuff.setGraphicSize(Std.int(finaleFlashbackStuff.width * 1.6));
				finaleFlashbackStuff.antialiasing = true;
				finaleFlashbackStuff.scrollFactor.set();
				finaleFlashbackStuff.active = true;
				finaleFlashbackStuff.alpha = 0.001;

				defeatthing = new FlxSprite(-400, 2000);
				defeatthing.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/defeat');
				defeatthing.animation.addByPrefix('bop', 'defeat', 24, false);
				defeatthing.animation.play('bop');
				defeatthing.setGraphicSize(Std.int(defeatthing.width * 1.3));
				defeatthing.antialiasing = true;
				defeatthing.scrollFactor.set(0.8, 0.8);
				defeatthing.active = true;
				defeatFinaleStuff.add(defeatthing);

				mainoverlayDK = new FlxSprite(250, 475).loadGraphic(Paths.image('backgrounds/' + curStage + '/defeatfnf'));
				mainoverlayDK.antialiasing = true;
				mainoverlayDK.scrollFactor.set(1, 1);
				mainoverlayDK.active = false;
				mainoverlayDK.setGraphicSize(Std.int(mainoverlayDK.width * 2));
				mainoverlayDK.alpha = 0;
				defeatFinaleStuff.add(mainoverlayDK);

				var bg0:FlxSprite = new FlxSprite(-600, -400).loadGraphic(Paths.image('backgrounds/' + curStage + '/bgg'));
				bg0.updateHitbox();
				bg0.antialiasing = true;
				bg0.scrollFactor.set(0.8, 0.8);
				bg0.active = true;
				bg0.scale.set(1.1, 1.1);

				var bg1:FlxSprite = new FlxSprite(800, -270).loadGraphic(Paths.image('backgrounds/' + curStage + '/dead'));
				bg1.updateHitbox();
				bg1.antialiasing = true;
				bg1.scrollFactor.set(0.8, 0.8);
				bg1.active = true;
				bg1.scale.set(1.1, 1.1);
				
				var bg2:FlxSprite = new FlxSprite(-790, -530).loadGraphic(Paths.image('backgrounds/' + curStage + '/bg'));
				bg2.updateHitbox();
				bg2.antialiasing = true;
				bg2.scrollFactor.set(0.9, 0.9);
				bg2.active = true;
				bg2.scale.set(1.1, 1.1);

				var bg3:FlxSprite = new FlxSprite(370, 1200).loadGraphic(Paths.image('backgrounds/' + curStage + '/splat'));
				bg3.updateHitbox();
				bg3.antialiasing = true;
				bg3.scrollFactor.set(1, 1);
				bg3.active = true;
				bg3.scale.set(1.1, 1.1);

				var bg4:FlxSprite = new FlxSprite(990, -380).loadGraphic(Paths.image('backgrounds/' + curStage + '/lamp'));
				bg4.updateHitbox();
				bg4.antialiasing = true;
				bg4.scrollFactor.set(1, 1);
				bg4.active = true;
				bg4.scale.set(1.1, 1.1);

				var bg5:FlxSprite = new FlxSprite(-750, 160).loadGraphic(Paths.image('backgrounds/' + curStage + '/fore'));
				bg5.updateHitbox();
				bg5.antialiasing = true;
				bg5.scrollFactor.set(1, 1);
				bg5.active = true;
				bg5.scale.set(1.1, 1.1);

				finaleLight = new FlxSprite(-230, -200);
				finaleLight.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/light');
				finaleLight.animation.addByPrefix('bop', 'light', 24, false);
				finaleLight.animation.play('bop');
				finaleLight.setGraphicSize(Std.int(finaleLight.width * 1.1));
				finaleLight.antialiasing = true;
				finaleLight.scrollFactor.set(0.8, 0.8);
				finaleLight.active = true;
				finaleLight.blend = ADD;

				var dark:FlxSprite = new FlxSprite(-950, -160).loadGraphic(Paths.image('backgrounds/' + curStage + '/dark'));
				dark.updateHitbox();
				dark.antialiasing = true;
				dark.scrollFactor.set(1, 1);
				dark.active = true;
				dark.scale.set(1.3, 1.3);
				dark.blend = MULTIPLY;
				
				finaleBGStuff.add(bg0);
				finaleBGStuff.add(bg1);
				finaleBGStuff.add(bg2);
				finaleFGStuff.add(bg3);
				finaleFGStuff.add(bg4);
				finaleFGStuff.add(bg5);
				finaleFGStuff.add(dark);
				finaleFGStuff.add(finaleLight);

				finaleBGStuff.visible = false;
				finaleFGStuff.visible = false;
				defeatFinaleStuff.visible = true;

				add(defeatFinaleStuff);
				add(finaleBGStuff);

				finaleDarkFG = new FlxSprite(-1000, -1000).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
				finaleDarkFG.antialiasing = true;
				finaleDarkFG.updateHitbox();
				finaleDarkFG.scrollFactor.set();

			case 'monotone': // emihead made peak
				curStage = 'monotone';
				PlayState.defaultCamZoom = 1;

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/SkeldBack'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 2));
				add(bg);

				defeatthing = new FlxSprite(0, 0);
				defeatthing.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/defeat');
				defeatthing.animation.addByPrefix('bop', 'defeat', 24, false);
				defeatthing.animation.play('bop');
				defeatthing.setGraphicSize(Std.int(defeatthing.width * 3));
				defeatthing.antialiasing = true;
				defeatthing.scrollFactor.set(1, 1);
				defeatthing.active = true;
				plagueBGPURPLE.add(defeatthing);

				bg2 = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/week1flashback'));
				bg2.updateHitbox();
				bg2.antialiasing = true;
				bg2.scrollFactor.set(1, 1);
				bg2.active = false;
				bg2.setGraphicSize(Std.int(bg.width * 2));

				// blue red and purple back things

				bgblue = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/BackThings'));
				bgblue.updateHitbox();
				bgblue.antialiasing = true;
				bgblue.scrollFactor.set(1, 1);
				bgblue.active = false;
				bgblue.setGraphicSize(Std.int(bgblue.width * 2));
				plagueBGBLUE.add(bgblue);

				bgred = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/backthingsred'));
				bgred.updateHitbox();
				bgred.antialiasing = true;
				bgred.scrollFactor.set(1, 1);
				bgred.active = false;
				bgred.setGraphicSize(Std.int(bgred.width * 2));
				plagueBGRED.add(bgred);

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/Floor'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 2));
				add(bg);

				// blue red and purple reactors

				bgblue2 = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/Reactor'));
				bgblue2.updateHitbox();
				bgblue2.antialiasing = true;
				bgblue2.scrollFactor.set(1, 1);
				bgblue2.active = false;
				bgblue2.setGraphicSize(Std.int(bgblue2.width * 2));
				plagueBGBLUE.add(bgblue2);

				bgred2  = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/ReactorRed'));
				bgred2.updateHitbox();
				bgred2.antialiasing = true;
				bgred2.scrollFactor.set(1, 1);
				bgred2.active = false;
				bgred2.setGraphicSize(Std.int(bgred2.width * 2));
				plagueBGRED.add(bgred2);

				// lights

				bgblue3 = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/Reactorlight'));
				bgblue3.updateHitbox();
				bgblue3.antialiasing = true;
				bgblue3.scrollFactor.set(1, 1);
				bgblue3.active = false;
				bgblue3.setGraphicSize(Std.int(bgblue3.width * 2));
				bgblue3.blend = ADD;
				plagueBGBLUE.add(bgblue3);

				bgred3 = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/ReactorLightRed'));
				bgred3.updateHitbox();
				bgred3.antialiasing = true;
				bgred3.scrollFactor.set(1, 1);
				bgred3.active = false;
				bgred3.setGraphicSize(Std.int(bgred3.width * 2));
				bgred3.blend = ADD;
				plagueBGRED.add(bgred3);

				add(plagueBGBLUE);
				add(plagueBGRED);
				add(plagueBGPURPLE);

				plagueBGBLUE.visible = true;
				plagueBGRED.visible = false;
				plagueBGPURPLE.visible = false;

				wires = new FlxSprite(0, -100).loadGraphic(Paths.image('backgrounds/' + curStage + '/wires1'));
				wires.updateHitbox();
				wires.antialiasing = true;
				wires.scrollFactor.set(1, 1);
				wires.active = false;
				wires.setGraphicSize(Std.int(wires.width * 1));
				add(wires);

				bggreen = new FlxSprite(0, -1000).loadGraphic(Paths.image('backgrounds/' + curStage + '/evilejected'));
				bggreen.updateHitbox();
				bggreen.antialiasing = true;
				bggreen.scrollFactor.set(0.7, 0.7);
				bggreen.active = false;
				bggreen.setGraphicSize(Std.int(bg.width * 2));
				plagueBGGREEN.add(bggreen);

				bggreen = new FlxSprite(0, -1000).loadGraphic(Paths.image('backgrounds/' + curStage + '/brombom'));
				bggreen.updateHitbox();
				bggreen.antialiasing = true;
				bggreen.scrollFactor.set(0.8, 0.8);
				bggreen.active = false;
				bggreen.setGraphicSize(Std.int(bg.width * 2));
				plagueBGGREEN.add(bggreen);

				add(plagueBGGREEN);
				plagueBGGREEN.visible = false;

				speedLines = new FlxBackdrop(Paths.image('backgrounds/' + curStage + '/speedLines'));
				speedLines.antialiasing = true;
				speedLines.updateHitbox();
				speedLines.scrollFactor.set(1.3, 1.3);
				speedLines.alpha = 0.3;
				plagueBGGREEN.add(speedLines);

				darkMono = new FlxSprite(0, 0).makeGraphic(1280, 720, 0xff000000);
				add(darkMono);
				darkMono.visible = false;

				saxguy = new FlxSprite(0, 0);
				saxguy.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/dialogue');
				saxguy.animation.addByPrefix('bop', 'dialogue', 24, false);
				
				saxguy.updateHitbox();
				
				saxguy.antialiasing = true;
				saxguy.scrollFactor.set(1, 1);
				saxguy.active = true;
				saxguy.screenCenter();
				
				saxguy.visible = false;

			case 'polus2':
				curStage = 'polus2';
				PlayState.defaultCamZoom = 1;

				var sky:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/newsky'));
				sky.antialiasing = true;
				sky.scrollFactor.set(1, 1);
				sky.active = false;
				sky.setGraphicSize(Std.int(sky.width * 0.75));
				add(sky);

				var cloud:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/newcloud'));
				cloud.antialiasing = true;
				cloud.scrollFactor.set(1, 1);
				cloud.active = false;
				cloud.setGraphicSize(Std.int(cloud.width * 0.75));
				cloud.alpha = 0.59;
				add(cloud);

				var rocks:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/newrocks'));
				rocks.antialiasing = true;
				rocks.scrollFactor.set(1, 1);
				rocks.active = false;
				rocks.setGraphicSize(Std.int(rocks.width * 0.75));
				rocks.alpha = 0.49;
				add(rocks);

				var backwall:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/backwall'));
				backwall.antialiasing = true;
				backwall.scrollFactor.set(1, 1);
				backwall.active = false;
				backwall.setGraphicSize(Std.int(backwall.width * 0.75));
				add(backwall);

				var stage:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/newstage'));
				stage.antialiasing = true;
				stage.scrollFactor.set(1, 1);
				stage.active = false;
				stage.setGraphicSize(Std.int(stage.width * 0.75));
				add(stage);

				snow2 = new FlxSprite(1150, 600);
				snow2.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/snowback');
				snow2.animation.addByPrefix('cum', 'Snow group instance 1', 24);
				snow2.animation.play('cum');
				snow2.scrollFactor.set(1, 1);
				snow2.antialiasing = true;
				snow2.alpha = 0.53;
				snow2.updateHitbox();
				snow2.setGraphicSize(Std.int(snow2.width * 2));

				snow = new FlxSprite(1150, 800);
				snow.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/snowfront');
				snow.animation.addByPrefix('cum', 'snow fall front instance 1', 24);
				snow.animation.play('cum');
				snow.scrollFactor.set(1, 1);
				snow.antialiasing = true;
				snow.alpha = 0.37;
				snow.updateHitbox();
				snow.setGraphicSize(Std.int(snow.width * 2));

			case 'polus3':
				curStage = 'polus3';
				PlayState.defaultCamZoom = 0.7;			

				var lava = new FlxSprite(-400, -650);
				lava.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/wallBP');
				lava.animation.addByPrefix('bop', 'Back wall and lava', 24, true);
				lava.animation.play('bop');
				lava.setGraphicSize(Std.int(lava.width * 1));
				lava.antialiasing = false;
				lava.scrollFactor.set(1, 1);
				lava.active = true;
				add(lava);

				var ground:FlxSprite = new FlxSprite(1050, 650).loadGraphic(Paths.image('backgrounds/' + curStage + '/platform'));
				ground.updateHitbox();
				ground.setGraphicSize(Std.int(ground.width * 1));
				ground.antialiasing = true;
				ground.scrollFactor.set(1, 1);
				ground.active = false;
				add(ground);

				var bubbles = new FlxSprite(800, 850);
				bubbles.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/bubbles');
				bubbles.animation.addByPrefix('bop', 'Lava Bubbles', 24, true);
				bubbles.animation.play('bop');
				bubbles.setGraphicSize(Std.int(bubbles.width * 1));
				bubbles.antialiasing = false;
				bubbles.scrollFactor.set(1, 1);
				bubbles.active = true;
				add(bubbles);

				emberEmitter = new FlxEmitter(-1200, 1000);

				for (i in 0 ... 150)
       		 	{
					var p = new FlxParticle();
					p.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/ember');
					p.animation.addByPrefix('ember', 'ember', 24, true);
					p.animation.play('ember');
        			p.exists = false;
					p.animation.curAnim.curFrame = FlxG.random.int(0, 9);
					p.blend = ADD;
        			emberEmitter.add(p);
        		}
				emberEmitter.launchMode = FlxEmitterMode.SQUARE;
				emberEmitter.velocity.set(-50, -400, 50, -800, -100, 0, 100, -800);
				emberEmitter.scale.set(1, 1, 0.8, 0.8, 0, 0, 0, 0);
				emberEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
				emberEmitter.width = 4200.45;
				emberEmitter.alpha.set(1, 1);
				emberEmitter.lifespan.set(4, 4.5);
				//heartEmitter.loadParticles(Paths.image('backgrounds/' + curStage + '/littleheart'), 500, 16, true);
						
				emberEmitter.start(false, FlxG.random.float(0.3, 0.4), 100000);

				lavaOverlay = new FlxSprite(1000, -50).loadGraphic(Paths.image('backgrounds/' + curStage + '/overlaythjing'));
				lavaOverlay.updateHitbox();
				lavaOverlay.scale.set(1.5, 1.5);
				lavaOverlay.blend = ADD;
				lavaOverlay.alpha = 0.7;
				lavaOverlay.antialiasing = true;
				lavaOverlay.scrollFactor.set(1, 1);

			case 'grey': // SHIT ASS
				curStage = 'grey';
				PlayState.defaultCamZoom = 0.8;
				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/graybg'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var thebackground = new FlxSprite(1930, 400);
				thebackground.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/grayglowy');
				thebackground.animation.addByPrefix('bop', 'jar??', 24, true);
				thebackground.animation.play('bop');
				thebackground.antialiasing = true;
				thebackground.scrollFactor.set(1, 1);
				thebackground.setGraphicSize(Std.int(thebackground.width * 1));
				thebackground.active = true;
				add(thebackground);

				crowd = new FlxSprite(240, 350);
				crowd.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/grayblack');
				crowd.animation.addByPrefix('bop', 'whoisthismf', 24, false);
				crowd.animation.play('bop');
				crowd.antialiasing = true;
				crowd.scrollFactor.set(1, 1);
				crowd.setGraphicSize(Std.int(crowd.width * 1));
				crowd.active = true;
				add(crowd);

			case 'plantroom': // pink stage
				PlayState.defaultCamZoom = 0.7;
				var bg:FlxSprite = new FlxSprite(-1500, -800).loadGraphic(Paths.image('backgrounds/' + curStage + '/bg sky'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var bg:FlxSprite = new FlxSprite(-1300, -100).loadGraphic(Paths.image('backgrounds/' + curStage + '/cloud fathest'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var bg:FlxSprite = new FlxSprite(-1300, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/cloud front'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				cloud1 = new FlxBackdrop(Paths.image('backgrounds/' + curStage + '/cloud 1'));
				cloud1.setPosition(0, -1000);
				cloud1.updateHitbox();
				cloud1.antialiasing = true;
				cloud1.scrollFactor.set(1, 1);
				add(cloud1);

				cloud2 = new FlxBackdrop(Paths.image('backgrounds/' + curStage + '/cloud 2'));
				cloud2.setPosition(0, -1200);
				cloud2.updateHitbox();
				cloud2.antialiasing = true;
				cloud2.scrollFactor.set(1, 1);
				add(cloud2);

				cloud3 = new FlxBackdrop(Paths.image('backgrounds/' + curStage + '/cloud 3'));
				cloud3.setPosition(0, -1400);
				cloud3.updateHitbox();
				cloud3.antialiasing = true;
				cloud3.scrollFactor.set(1, 1);
				add(cloud3);

				cloud4 = new FlxBackdrop(Paths.image('backgrounds/' + curStage + '/cloud 4'));
				cloud4.setPosition(0, -1600);
				cloud4.updateHitbox();
				cloud4.antialiasing = true;
				cloud4.scrollFactor.set(1, 1);
				add(cloud4);

				cloudbig = new FlxBackdrop(Paths.image('backgrounds/' + curStage + '/bigcloud'));
				cloudbig.setPosition(0, -1200);
				cloudbig.updateHitbox();
				cloudbig.antialiasing = true;
				cloudbig.scrollFactor.set(1, 1);
				add(cloudbig);

				var bg:FlxSprite = new FlxSprite(-1200, -750).loadGraphic(Paths.image('backgrounds/' + curStage + '/glasses'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				greymira = new FlxSprite(-260, -75);
				greymira.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/crew');
				greymira.animation.addByPrefix('bop', 'grey', 24, false);
				greymira.animation.play('bop');
				greymira.antialiasing = true;
				greymira.scrollFactor.set(1, 1);
				greymira.active = true;
				add(greymira);

					greytender = new FlxSprite(-518, -55);
					greytender.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/grey_pretender');
					greytender.animation.addByPrefix('anim', 'gray anim', 24, false);
					greytender.antialiasing = true;
					greytender.scrollFactor.set(1, 1);
					greytender.active = true;
					greytender.alpha = 0.001;
					add(greytender);

				ventNotSus = new FlxSprite(-100, -200);
				ventNotSus.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/black_pretender');
				ventNotSus.animation.addByPrefix('anim', 'black', 24, false);
				ventNotSus.antialiasing = true;
				ventNotSus.scrollFactor.set(1, 1);
				ventNotSus.active = true;
				add(ventNotSus);

				var bg:FlxSprite = new FlxSprite(0, -650).loadGraphic(Paths.image('backgrounds/' + curStage + '/what is this'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				cyanmira = new FlxSprite(740, -50);
				cyanmira.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/crew');
				cyanmira.animation.addByPrefix('bop', 'tomatomongus', 24, false);
				cyanmira.animation.play('bop');
				cyanmira.antialiasing = true;
				cyanmira.scrollFactor.set(1, 1);
				cyanmira.active = true;
				add(cyanmira);

				longfuckery = new FlxSprite(270, -30);
				longfuckery.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/longus_leave');
				longfuckery.animation.addByPrefix('anim', 'longus anim', 24, false);
				longfuckery.antialiasing = true;
				longfuckery.scrollFactor.set(1, 1);
				longfuckery.active = true;
				longfuckery.alpha = 0.001;
				add(longfuckery);

				noootomatomongus = new FlxSprite(770, 135);
				noootomatomongus.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/tomato_pretender');
				noootomatomongus.animation.addByPrefix('anim', 'tomatongus anim', 24, false);
				noootomatomongus.antialiasing = true;
				noootomatomongus.scrollFactor.set(1, 1);
				noootomatomongus.active = true;
				noootomatomongus.alpha = 0.001;
				add(noootomatomongus);

				oramira = new FlxSprite(1000, 125);
				oramira.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/crew');
				oramira.animation.addByPrefix('bop', 'RHM', 24, false);
				oramira.animation.play('bop');
				oramira.antialiasing = true;
				oramira.scrollFactor.set(1.2, 1);
				oramira.active = true;
				add(oramira);

				var bg:FlxSprite = new FlxSprite(-800, -10).loadGraphic(Paths.image('backgrounds/' + curStage + '/lmao'));
				bg.antialiasing = true;
				bg.setGraphicSize(Std.int(bg.width * 0.9));
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				bluemira = new FlxSprite(-1300, 0);
				bluemira.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/crew');
				bluemira.animation.addByPrefix('bop', 'blue', 24, false);
				bluemira.animation.play('bop');
				bluemira.antialiasing = true;
				bluemira.scrollFactor.set(1.2, 1);
				bluemira.active = true;
				
				pot = new FlxSprite(-1550, 650).loadGraphic(Paths.image('backgrounds/' + curStage + '/front pot'));
				pot.antialiasing = true;
				pot.setGraphicSize(Std.int(pot.width * 1));
				pot.scrollFactor.set(1.2, 1);
				pot.active = false;
				

				vines = new FlxSprite(-1200, -1200);
				vines.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/vines');
				vines.animation.addByPrefix('bop', 'green', 24, true);
				vines.animation.play('bop');
				vines.antialiasing = true;
				vines.scrollFactor.set(1.4, 1);
				vines.active = true;

				pretenderDark = new FlxSprite(-800, -500);
				pretenderDark.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/pretender_dark');
				pretenderDark.animation.addByPrefix('anim', 'amongdark', 24, false);
				pretenderDark.antialiasing = true;
				pretenderDark.scrollFactor.set(1, 1);
				pretenderDark.active = true;

				
				heartEmitter = new FlxEmitter(-1200, 1000);

				for (i in 0 ... 100)
       		 	{
					var p = new FlxParticle();
					p.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/littleheart');
					p.animation.addByPrefix('littleheart', 'littleheart', 24, true);
					p.animation.play('littleheart');
        			p.exists = false;
					p.animation.curAnim.curFrame = FlxG.random.int(0, 2);
        			heartEmitter.add(p);
        		}
				heartEmitter.launchMode = FlxEmitterMode.SQUARE;
				heartEmitter.velocity.set(-50, -400, 50, -800, -100, 0, 100, -800);
				heartEmitter.scale.set(3.4, 3.4, 3.4, 3.4, 0, 0, 0, 0);
				heartEmitter.drag.set(0, 0, 0, 0, 5, 5, 10, 10);
				heartEmitter.width = 4200.45;
				heartEmitter.alpha.set(1, 1);
				heartEmitter.lifespan.set(4, 4.5);
				//heartEmitter.loadParticles(Paths.image('backgrounds/' + curStage + '/littleheart'), 500, 16, true);
						
				heartEmitter.start(false, FlxG.random.float(0.3, 0.4), 100000);

				heartEmitter.emitting = false;
			
			case 'pretender': // pink stage
				PlayState.defaultCamZoom = 0.7;
				var bg:FlxSprite = new FlxSprite(-1500, -800).loadGraphic(Paths.image('backgrounds/' + curStage + '/bg sky'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var bg:FlxSprite = new FlxSprite(-1300, -100).loadGraphic(Paths.image('backgrounds/' + curStage + '/cloud fathest'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var bg:FlxSprite = new FlxSprite(-1300, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/cloud front'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				cloud1 = new FlxBackdrop(Paths.image('backgrounds/' + curStage + '/cloud 1'));
				cloud1.setPosition(0, -1000);
				cloud1.updateHitbox();
				cloud1.antialiasing = true;
				cloud1.scrollFactor.set(1, 1);
				add(cloud1);

				cloud2 = new FlxBackdrop(Paths.image('backgrounds/' + curStage + '/cloud 2'));
				cloud2.setPosition(0, -1200);
				cloud2.updateHitbox();
				cloud2.antialiasing = true;
				cloud2.scrollFactor.set(1, 1);
				add(cloud2);

				cloud3 = new FlxBackdrop(Paths.image('backgrounds/' + curStage + '/cloud 3'));
				cloud3.setPosition(0, -1400);
				cloud3.updateHitbox();
				cloud3.antialiasing = true;
				cloud3.scrollFactor.set(1, 1);
				add(cloud3);

				cloud4 = new FlxBackdrop(Paths.image('backgrounds/' + curStage + '/cloud 4'));
				cloud4.setPosition(0, -1600);
				cloud4.updateHitbox();
				cloud4.antialiasing = true;
				cloud4.scrollFactor.set(1, 1);
				add(cloud4);

				cloudbig = new FlxBackdrop(Paths.image('backgrounds/' + curStage + '/bigcloud'));
				cloudbig.setPosition(0, -1200);
				cloudbig.updateHitbox();
				cloudbig.antialiasing = true;
				cloudbig.scrollFactor.set(1, 1);
				add(cloudbig);

				var bg:FlxSprite = new FlxSprite(-1200, -750).loadGraphic(Paths.image('backgrounds/' + curStage + '/ground'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var bg:FlxSprite = new FlxSprite(0, -650).loadGraphic(Paths.image('backgrounds/' + curStage + '/front plant'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var bg:FlxSprite = new FlxSprite(1000, 230).loadGraphic(Paths.image('backgrounds/' + curStage + '/knocked over plant'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var bg:FlxSprite = new FlxSprite(-800, 260).loadGraphic(Paths.image('backgrounds/' + curStage + '/knocked over plant 2'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var deadmungus:FlxSprite = new FlxSprite(950, 250).loadGraphic(Paths.image('backgrounds/' + curStage + '/tomatodead'));
				deadmungus.antialiasing = true;
				deadmungus.scrollFactor.set(1, 1);
				deadmungus.active = false;
				add(deadmungus);

				gfDeadPretender = new FlxSprite(0, 100);
				gfDeadPretender.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/gf_dead_p');
				gfDeadPretender.animation.addByPrefix('bop', 'GF Dancing Beat', 24, false);
				gfDeadPretender.animation.play('bop');
				gfDeadPretender.setGraphicSize(Std.int(gfDeadPretender.width * 1.1));
				gfDeadPretender.antialiasing = true;
				gfDeadPretender.active = true;
				add(gfDeadPretender);

				var ripbozo:FlxSprite = new FlxSprite(700, 450).loadGraphic(Paths.image('backgrounds/' + curStage + '/ripbozo'));
				ripbozo.antialiasing = true;
				ripbozo.setGraphicSize(Std.int(ripbozo.width * 0.7));
				add(ripbozo);

				var rhmdead:FlxSprite = new FlxSprite(1350, 450).loadGraphic(Paths.image('backgrounds/' + curStage + '/rhm dead'));
				rhmdead.antialiasing = true;
				rhmdead.scrollFactor.set(1, 1);
				rhmdead.active = false;
				add(rhmdead);

				bluemira = new FlxSprite(-1150, 400);
				bluemira.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/blued');
				bluemira.animation.addByPrefix('bop', 'bob bop', 24, false);
				bluemira.animation.play('bop');
				bluemira.antialiasing = true;
				bluemira.scrollFactor.set(1.2, 1);
				bluemira.active = true;
				
				pot = new FlxSprite(-1550, 650).loadGraphic(Paths.image('backgrounds/' + curStage + '/front pot'));
				pot.antialiasing = true;
				pot.setGraphicSize(Std.int(pot.width * 1));
				pot.scrollFactor.set(1.2, 1);
				pot.active = false;

				vines = new FlxSprite(-1450, -550).loadGraphic(Paths.image('backgrounds/' + curStage + '/green'));
				vines.antialiasing = true;
				vines.setGraphicSize(Std.int(vines.width * 1));
				vines.scrollFactor.set(1.2, 1);
				vines.active = false;

			case 'chef': // mayhew has gone mad
				PlayState.defaultCamZoom = 0.8;

				var wall:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/Back Wall Kitchen'));
				wall.antialiasing = true;
				wall.scrollFactor.set(1, 1);
				wall.setGraphicSize(Std.int(wall.width * 0.8));
				wall.active = false;
				add(wall);

				var floor:FlxSprite = new FlxSprite(-850, 1000).loadGraphic(Paths.image('backgrounds/' + curStage + '/Chef Floor'));
				floor.antialiasing = true;
				floor.scrollFactor.set(1, 1);
				floor.active = false;
				add(floor);

				var backshit:FlxSprite = new FlxSprite(-50, 170).loadGraphic(Paths.image('backgrounds/' + curStage + '/Back Table Kitchen'));
				backshit.antialiasing = true;
				backshit.scrollFactor.set(1, 1);
				backshit.setGraphicSize(Std.int(backshit.width * 0.8));
				backshit.active = false;
				add(backshit);

				var oven:FlxSprite = new FlxSprite(1600, 400).loadGraphic(Paths.image('backgrounds/' + curStage + '/oven'));
				oven.antialiasing = true;
				oven.scrollFactor.set(1, 1);
				oven.setGraphicSize(Std.int(oven.width * 0.8));
				oven.active = false;
				add(oven);

				gray = new FlxSprite(1000, 525);
				gray.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/Boppers');
				gray.animation.addByPrefix('bop', 'grey', 24, false);
				gray.animation.play('bop');
				gray.antialiasing = true;
				gray.scrollFactor.set(1, 1);
				gray.setGraphicSize(Std.int(gray.width * 0.8));
				gray.active = true;
				add(gray);

				saster = new FlxSprite(1300, 525);
				saster.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/Boppers');
				saster.animation.addByPrefix('bop', 'saster', 24, false);
				saster.animation.play('bop');
				saster.antialiasing = true;
				saster.scrollFactor.set(1, 1);
				saster.setGraphicSize(Std.int(saster.width * 1.2));
				saster.active = true;
				add(saster);

				var frontable:FlxSprite = new FlxSprite(800, 700).loadGraphic(Paths.image('backgrounds/' + curStage + '/Kitchen Counter'));
				frontable.antialiasing = true;
				frontable.scrollFactor.set(1, 1);
				frontable.active = false;
				add(frontable);

				chefBluelight = new FlxSprite(0, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/bluelight'));
				chefBluelight.antialiasing = true;
				chefBluelight.scrollFactor.set(1, 1);
				chefBluelight.active = false;
				chefBluelight.blend = ADD;

				chefBlacklight = new FlxSprite(0, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/black_overhead_shadow'));
				chefBlacklight.antialiasing = true;
				chefBlacklight.scrollFactor.set(1, 1);
				chefBlacklight.active = false;

			case 'lounge': // lotowncorry + 02
				PlayState.defaultCamZoom = 0.9;

				var loungebg:FlxSprite = new FlxSprite(-264.6, -66.25).loadGraphic(Paths.image('backgrounds/' + curStage + '/lounge'));
				loungebg.antialiasing = true;
				loungebg.scrollFactor.set(1, 1);
				loungebg.active = false;
				add(loungebg);

				var loungelight:FlxSprite = new FlxSprite(-368.5, -135.55).loadGraphic(Paths.image('backgrounds/' + curStage + '/loungelight'));
				loungelight.antialiasing = true;
				loungelight.scrollFactor.set(1, 1);
				loungelight.active = false;
				loungelight.alpha = 0.33;
				loungelight.blend = ADD;

				o2lighting = new FlxSprite(-0, -0).loadGraphic(Paths.image('backgrounds/' + curStage + '/O2lighting'));
				o2lighting.antialiasing = true;
				o2lighting.alpha = 0.001;
				o2lighting.scrollFactor.set();
				o2lighting.setGraphicSize(Std.int(o2lighting.width * 1.2));

				o2dark = new FlxSprite(-300).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
				o2dark.antialiasing = true;
				o2dark.scrollFactor.set(1, 1);
				o2dark.alpha = 0.001;

				o2WTF = new FlxSprite(400, 300);
				o2WTF.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/wtf');
				o2WTF.animation.addByPrefix('w', 'wtf what', 24, false);
				o2WTF.animation.addByPrefix('t', 'wtf the', 24, false);
				o2WTF.animation.addByPrefix('f', 'wtf fuck', 24, false);
				o2WTF.animation.play('f');
				o2WTF.scrollFactor.set();
				o2WTF.alpha = 0.001;

			case 'voting': // lotowncorry + 02
				PlayState.defaultCamZoom = 1.3;

				var otherroom:FlxSprite = new FlxSprite(387.3, 194.1).loadGraphic(Paths.image('backgrounds/' + curStage + '/backer_groung_voting'));
				otherroom.antialiasing = true;
				otherroom.scrollFactor.set(0.8, 0.8);
				otherroom.active = false;
				add(otherroom);

				var votingbg:FlxSprite = new FlxSprite(-315.15, 52.85).loadGraphic(Paths.image('backgrounds/' + curStage + '/main_bg_meeting'));
				votingbg.antialiasing = true;
				votingbg.scrollFactor.set(0.95, 0.95);
				votingbg.active = false;
				add(votingbg);

				var chairs:FlxSprite = new FlxSprite(-7.9, 644.85).loadGraphic(Paths.image('backgrounds/' + curStage + '/CHAIRS!!!!!!!!!!!!!!!'));
				chairs.antialiasing = true;
				chairs.scrollFactor.set(1.0, 1.0);
				chairs.active = false;
				add(chairs);

				table = new FlxSprite(209.4, 679.55).loadGraphic(Paths.image('backgrounds/' + curStage + '/table_voting'));
				table.antialiasing = true;
				table.scrollFactor.set(1.0, 1.0);
				table.active = false;

			case 'turbulence': // TURBULENCE!!!
				PlayState.defaultCamZoom = 0.6;

				airSpeedlines = new FlxTypedGroup<FlxSprite>();

				turbFrontCloud = new FlxTypedGroup<FlxSprite>();	

				var turbsky:FlxSprite = new FlxSprite(-866.9, -400.05).loadGraphic(Paths.image('backgrounds/' + curStage + '/turbsky'));
				turbsky.antialiasing = true;
				turbsky.scrollFactor.set(0.5, 0.5);
				turbsky.active = false;
				add(turbsky);
				
				backerclouds = new FlxSprite(1296.55, 175.55).loadGraphic(Paths.image('backgrounds/' + curStage + '/backclouds'));
				backerclouds.antialiasing = true;
				backerclouds.scrollFactor.set(0.65, 0.65);
				backerclouds.active = false;
				add(backerclouds);

				hotairballoon = new FlxSprite(134.7, 147.05).loadGraphic(Paths.image('backgrounds/' + curStage + '/hotairballoon'));
				hotairballoon.antialiasing = true;
				hotairballoon.scrollFactor.set(0.65, 0.65);
				hotairballoon.active = false;
				add(hotairballoon);

				midderclouds = new FlxSprite(-313.55, 253.05).loadGraphic(Paths.image('backgrounds/' + curStage + '/midclouds'));
				midderclouds.antialiasing = true;
				midderclouds.scrollFactor.set(0.8, 0.8);
				midderclouds.active = false;
				add(midderclouds);

				hookarm = new FlxSprite(-597.85, 888.4).loadGraphic(Paths.image('backgrounds/' + curStage + '/clawback'));
				hookarm.antialiasing = true;
				hookarm.scrollFactor.set(1, 1);
				hookarm.active = false;

				clawshands = new FlxSprite(1873, 690.1);
				clawshands.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/clawfront');
				clawshands.animation.addByPrefix('squeeze', 'clawhands', 24, false);
				clawshands.animation.play('squeeze');
				clawshands.antialiasing = true;
				clawshands.scrollFactor.set(1, 1);
				clawshands.active = true;

				var turblight:FlxSprite = new FlxSprite(-83.1, -876.7).loadGraphic(Paths.image('backgrounds/' + curStage + '/TURBLIGHTING'));
				turblight.antialiasing = true;
				turblight.scrollFactor.set(1.3, 1.3);
				turblight.active = false;
				turblight.alpha = 0.41;
				turblight.blend = ADD;

			case 'victory': // victory
				PlayState.defaultCamZoom = 0.75;

				VICTORY_TEXT = new FlxSprite(410, 75);
				VICTORY_TEXT.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/victorytext');
				VICTORY_TEXT.animation.addByPrefix('expand', 'VICTORY', 24, false);
				VICTORY_TEXT.animation.play('expand');
				VICTORY_TEXT.antialiasing = true;
				VICTORY_TEXT.scrollFactor.set(0.8, 0.8);
				VICTORY_TEXT.active = true;
				add(VICTORY_TEXT);

				bg_vic = new FlxSprite(-97.75, 191.85);
				bg_vic.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/vic_bgchars');
				bg_vic.animation.addByPrefix('bop', 'lol thing', 24, false);
				bg_vic.animation.play('bop');
				bg_vic.antialiasing = true;
				bg_vic.scrollFactor.set(0.9, 0.9);
				bg_vic.active = true;
				add(bg_vic);

				var fog_back:FlxSprite = new FlxSprite(338.15, 649.4).loadGraphic(Paths.image('backgrounds/' + curStage + '/fog_back'));
				fog_back.antialiasing = true;
				fog_back.scrollFactor.set(0.95, 0.95);
				fog_back.active = false;
				fog_back.alpha = 0.16;
				add(fog_back);

				bg_jelq = new FlxSprite(676.05, 478.3);
				bg_jelq.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/vic_jelq');
				bg_jelq.animation.addByPrefix('bop', 'jelqeranim', 24, false);
				bg_jelq.animation.play('bop');
				bg_jelq.antialiasing = true;
				bg_jelq.scrollFactor.set(0.975, 0.975);
				bg_jelq.alpha = 0;
				bg_jelq.active = true;
				add(bg_jelq);

				bg_war = new FlxSprite(693.7, 421.9);
				bg_war.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/vic_war');
				bg_war.animation.addByPrefix('bop', 'warchiefbganim', 24, false);
				bg_war.animation.play('bop');
				bg_war.antialiasing = true;
				bg_war.scrollFactor.set(0.975, 0.975);
				bg_war.alpha = 0;
				bg_war.active = true;
				add(bg_war);
				
				bg_jor = new FlxSprite(998.6, 408.9);
				bg_jor.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/vic_jor');
				bg_jor.animation.addByPrefix('bop', 'jorsawseebganim', 24, false);
				bg_jor.animation.play('bop');
				bg_jor.antialiasing = true;
				bg_jor.scrollFactor.set(0.975, 0.975);
				bg_jor.alpha = 0;
				bg_jor.active = true;
				add(bg_jor);

				var fog_mid:FlxSprite = new FlxSprite(-192.9, 607.25).loadGraphic(Paths.image('backgrounds/' + curStage + '/fog_mid'));
				fog_mid.antialiasing = true;
				fog_mid.scrollFactor.set(0.975, 0.975);
				fog_mid.active = false;
				fog_mid.alpha = 0.19;
				add(fog_mid);

				var spotlights:FlxSprite = new FlxSprite(119.4, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/victory_spotlights'));
				spotlights.antialiasing = true;
				spotlights.scrollFactor.set(1, 1);
				spotlights.active = false;
				spotlights.alpha = 0.69;
				spotlights.blend = ADD;

				vicPulse = new FlxSprite(-269.85, 261.05);
				vicPulse.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/victory_pulse');
				vicPulse.animation.addByPrefix('pulsate', 'animatedlight', 24, false);
				vicPulse.animation.play('pulsate');
				vicPulse.antialiasing = true;
				vicPulse.scrollFactor.set(1, 1);
				vicPulse.blend = ADD;
				vicPulse.active = true;

				var fog_front:FlxSprite = new FlxSprite(-875.8, 873.70).loadGraphic(Paths.image('backgrounds/' + curStage + '/fog_front'));
				fog_front.antialiasing = true;
				fog_front.scrollFactor.set(1.5, 1.5);
				fog_front.active = false;
				fog_front.alpha = 0.44;

			case 'powstage': // powers!
				PlayState.defaultCamZoom = 0.8;

				var bg:FlxSprite = new FlxSprite(-1119.5, -649).loadGraphic(Paths.image('backgrounds/' + curStage + '/roomcodebg'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var crate:FlxSprite = new FlxSprite(-74.65, 530.85).loadGraphic(Paths.image('backgrounds/' + curStage + '/box'));
				crate.antialiasing = true;
				crate.scrollFactor.set(1, 1);
				crate.active = false;
				add(crate);

			case 'henry': // stick Min
				PlayState.defaultCamZoom = 0.9;
				var bg:FNFSprite = new FNFSprite(-1600, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagehenry'));
				add(bg);
				bg.scrollFactor.set(1, 1);

				if(PlayState.SONG.song.toLowerCase() == 'reinforcements'){
					trace('enry');

					armedGuy = new FlxSprite(-800, -300);
					armedGuy.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/i_schee_u_enry');
					armedGuy.animation.addByPrefix('crash', 'rhm intro shadow', 16, false);
					armedGuy.antialiasing = true;
					armedGuy.alpha = 0.001;
				}
					trace('enry');

					armedDark = new FlxSprite(-300).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					armedDark.alpha = 0;
					add(armedDark);

					dustcloud = new FlxSprite(120, 450);
					dustcloud.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/Dust_Cloud');
					dustcloud.animation.addByPrefix('dust', 'dust clouds', 24, false);
					dustcloud.antialiasing = true;

			case 'charles': // harles
				PlayState.defaultCamZoom = 0.9;

				var bg:FNFSprite = new FNFSprite(-1600, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagehenry'));
				add(bg);
				bg.scrollFactor.set(1, 1);

			case 'tomtus': // emihead made peak
				curStage = 'tomtus';
				PlayState.defaultCamZoom = 1;

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/space'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/tuesday'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

			case 'loggo': // loggo normal
				PlayState.defaultCamZoom = 0.7;

				var bg:FNFSprite = new FNFSprite(0, 200).loadGraphic(Paths.image('backgrounds/' + curStage + '/space'));
				add(bg);
				bg.setGraphicSize(Std.int(bg.width * 3));
				bg.antialiasing = false;
				bg.scrollFactor.set(0.8, 0.8);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/normalOne'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 3));
				stageFront.updateHitbox();
				add(stageFront);
				stageFront.antialiasing = false;
				stageFront.scrollFactor.set(0.9, 0.9);

				peopleloggo = new FlxSprite(150, 1200);
				peopleloggo.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/people');
				peopleloggo.animation.addByPrefix('bop', 'the guys', 24, false);
				peopleloggo.animation.play('bop');
				peopleloggo.setGraphicSize(Std.int(peopleloggo.width * 3));
				peopleloggo.antialiasing = false;
				peopleloggo.scrollFactor.set(0.9, 0.9);
				peopleloggo.active = true;
				add(peopleloggo);

				fireloggo = new FlxSprite(150, 1200);
				fireloggo.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/stockingFire');
				fireloggo.animation.addByPrefix('bop', 'stocking fire', 24, true);
				fireloggo.animation.play('bop');
				fireloggo.setGraphicSize(Std.int(fireloggo.width * 3));
				fireloggo.antialiasing = false;
				fireloggo.scrollFactor.set(0.9, 0.9);
				fireloggo.active = true;
				add(fireloggo);

			case 'loggo2': // dark loggo
				PlayState.defaultCamZoom = 5;
				var bg:FNFSprite = new FNFSprite(0, 200).loadGraphic(Paths.image('backgrounds/' + curStage + '/space'));
				add(bg);
				bg.setGraphicSize(Std.int(bg.width * 3));
				bg.antialiasing = false;
				bg.scrollFactor.set(0.8, 0.8);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/placeholder Hell'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 3));
				stageFront.updateHitbox();
				add(stageFront);
				stageFront.antialiasing = false;
				bg.scrollFactor.set(0.9, 0.9);

				peopleloggo = new FlxSprite(150, 1200);
				peopleloggo.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/people');
				peopleloggo.animation.addByPrefix('bop', 'the guys', 24, false);
				peopleloggo.animation.play('bop');
				peopleloggo.setGraphicSize(Std.int(peopleloggo.width * 3));
				peopleloggo.antialiasing = false;
				peopleloggo.scrollFactor.set(0.9, 0.9);
				peopleloggo.active = true;
				add(peopleloggo);

			case 'alpha': // SHIT ASS
				PlayState.defaultCamZoom = 0.9;
				curStage = 'alpha';
				var bg:FNFSprite = new FNFSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/HOTASS'));
				add(bg);
				bg.scrollFactor.set(0.9, 0.9);

			case 'kills':
				PlayState.defaultCamZoom = 0.9;
				var bg:FNFSprite = new FNFSprite(-620, -227).loadGraphic(Paths.image('backgrounds/' + curStage + '/killbg'));
				add(bg);

			case 'who': // dead dead guy
				PlayState.defaultCamZoom = 0.7;
				var bg:FlxSprite = new FlxSprite(0, 100).loadGraphic(Paths.image('backgrounds/' + curStage + '/deadguy'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				meeting = new FlxSprite(300, 1075);
				meeting.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/meeting');
				meeting.animation.addByPrefix('bop', 'meeting buzz', 16, false);
				meeting.antialiasing = true;
				meeting.scrollFactor.set(1, 1);
				meeting.active = true;
				meeting.setGraphicSize(Std.int(meeting.width * 1.2));
				meeting.alpha = 0.001;

				whoAngered = new FlxSprite(-1000, 975).loadGraphic(Paths.image('backgrounds/' + curStage + '/mad mad dude'));
				whoAngered.antialiasing = true;
				whoAngered.alpha = 0.001;

				furiousRage = new FlxSprite(450, 905).loadGraphic(Paths.image('backgrounds/' + curStage + '/KILLYOURSELF'));
				furiousRage.antialiasing = true;
				furiousRage.setGraphicSize(Std.int(furiousRage.width * 0.7));
				furiousRage.alpha = 0.001;

				emergency = new FlxSprite(400, 1175).loadGraphic(Paths.image('backgrounds/' + curStage + '/emergency'));
				emergency.antialiasing = true;
				emergency.setGraphicSize(Std.int(emergency.width * 0.5));
				emergency.alpha = 0.001;

				space = new FlxSprite(-1000, -1000).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
				space.antialiasing = true;
				space.updateHitbox();
				space.scrollFactor.set();
				add(space);
				space.visible = false;

				starsBG = new FlxBackdrop(Paths.image('backgrounds/' + curStage + '/starBG'));
				starsBG.setPosition(111.3, 67.95);
				starsBG.antialiasing = true;
				starsBG.updateHitbox();
				starsBG.scrollFactor.set();
				add(starsBG);
				starsBG.visible = false;

				starsFG = new FlxBackdrop(Paths.image('backgrounds/' + curStage + '/starFG'));
				starsFG.setPosition(54.3, 59.45);
				starsFG.updateHitbox();
				starsFG.antialiasing = true;
				starsFG.scrollFactor.set();
				add(starsFG);
				starsFG.visible = false;

			case 'jerma': // fuck you neato
				PlayState.defaultCamZoom = 0.9;
				var bg:FNFSprite = new FNFSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/jerma'));
				add(bg);
				bg.scrollFactor.set(1, 1);

			case 'nuzzus': // SHIT ASS
				curStage = 'nuzzus';
				PlayState.defaultCamZoom = 1;
				var thebackground = new FlxSprite(0, 0);
				thebackground.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/nuzzus');
				thebackground.animation.addByPrefix('bop', 'bg', 24, true);
				thebackground.animation.play('bop');
				thebackground.antialiasing = false;
				thebackground.scrollFactor.set(1, 1);
				thebackground.setGraphicSize(Std.int(thebackground.width * 5));
				thebackground.active = true;
				add(thebackground);

			case 'idk':
				curStage = 'idk';
				PlayState.defaultCamZoom = 1.6;

				var sky:FlxSprite = new FlxSprite(0,0).loadGraphic(Paths.image('backgrounds/' + curStage + '/toby'));
				sky.antialiasing = false;
				sky.scrollFactor.set(1, 1);
				sky.active = false;
				add(sky);

			case 'esculent': // esculent
				PlayState.defaultCamZoom = 1.2;

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/background'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.5));
				add(bg);

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/scary ass shadow'));
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.5));
				add(bg);

			case 'drippypop': // SHIT ASS
				curStage = 'drippypop';
				PlayState.defaultCamZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/ng'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

			case 'dave': // crewicide
				curStage = 'dave';
				PlayState.defaultCamZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/DAVE'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				daveDIE = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/DAVEdie'));
				daveDIE.updateHitbox();
				daveDIE.antialiasing = true;
				daveDIE.scrollFactor.set(1, 1);
				daveDIE.active = false;
				daveDIE.alpha = 0.00000001;
				add(daveDIE);

			case 'attack': // monotone attack
				curStage = 'attack';
				PlayState.defaultCamZoom = 0.75;

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/monotoneback'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				// people in shop bg

				peopleloggo = new FlxSprite(850, 850);
				peopleloggo.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/crowd');
				peopleloggo.animation.addByPrefix('bop', 'tess n gus fring instance 1', 24, false);
				peopleloggo.animation.play('bop');
				peopleloggo.antialiasing = true;
				peopleloggo.scrollFactor.set(1, 1);
				peopleloggo.active = true;
				add(peopleloggo);
				
				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/fg'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

				nickt = new FlxSprite(600, 700);
				nickt.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/nick t');
				nickt.animation.addByPrefix('bop', 'nick t idle', 24, false);
				nickt.animation.play('bop');
				nickt.scrollFactor.set(1, 1);
				nickt.active = true;
				nickt.antialiasing = true;
				add(nickt);

				nicktmvp = new FlxSprite(600, 700);
				nicktmvp.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/nick t');
				nicktmvp.animation.addByPrefix('bop', 'nick t animation', 24, false);
				nicktmvp.animation.play('bop');
				nicktmvp.scrollFactor.set(1, 1);
				nicktmvp.active = true;
				nicktmvp.antialiasing = true;
				add(nicktmvp);

				nickt.visible = true;
				nicktmvp.visible = false;

				// cooper
				toogusorange = new FlxSprite(1250, 625);
				toogusorange.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/offbi');
				toogusorange.animation.addByPrefix('bop', 'offbi', 24, false);
				toogusorange.animation.play('bop');
				toogusorange.scrollFactor.set(1, 1);
				toogusorange.active = true;
				toogusorange.antialiasing = true;
				add(toogusorange);

				toogusblue = new FlxSprite(850, 665);
				toogusblue.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/orbyy');
				toogusblue.animation.addByPrefix('bop', 'orbyy', 24, false);
				toogusblue.animation.play('bop');
				toogusblue.scrollFactor.set(1, 1);
				toogusblue.active = true;
				toogusblue.antialiasing = true;
				add(toogusblue);

				toogusblue2 = new FlxSprite(725, 665);
				toogusblue2.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/orbyy');
				toogusblue2.animation.addByPrefix('bop', 'shutup', 24, false);
				toogusblue2.animation.play('bop');
				toogusblue2.scrollFactor.set(1, 1);
				toogusblue2.active = true;
				toogusblue2.antialiasing = true;
				add(toogusblue2);
				toogusblue2.visible = false;

				thebackground = new FlxSprite(950, 775);
				thebackground.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/loggoattack');
				thebackground.animation.addByPrefix('bop', 'loggfriend', 24, false);
				thebackground.animation.play('bop');
				thebackground.antialiasing = true;
				thebackground.scrollFactor.set(1, 1);
				thebackground.setGraphicSize(Std.int(thebackground.width * 1));
				thebackground.active = true;
				add(thebackground);

				crowd = new FlxSprite(1950, 750);
				crowd.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/cooper');
				crowd.animation.addByPrefix('bop', 'bg seat 1 instance 1', 24, false);
				crowd.animation.play('bop');
				crowd.antialiasing = true;
				crowd.scrollFactor.set(1, 1);
				crowd.active = true;
				add(crowd);

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/backlights'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				bg.blend = ADD;
				add(bg);

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/lamp'));
				bg.updateHitbox();
				bg.antialiasing = true;
				bg.scrollFactor.set(1, 1);
				bg.active = false;
				add(bg);

			case 'piptowers':
				PlayState.defaultCamZoom = 0.58;
				var sky:FNFSprite = new FNFSprite(-1100, -800).loadGraphic(Paths.image('backgrounds/' + curStage + '/back'));
				sky.scrollFactor.set(0, 0);
				add(sky);

				var back:FNFSprite = new FNFSprite(-1100, -800).loadGraphic(Paths.image('backgrounds/' + curStage + '/backBuildings'));
				back.scrollFactor.set(0.2, 0.2);
				add(back);

				var sign:FNFSprite = new FNFSprite(-1100, -800).loadGraphic(Paths.image('backgrounds/' + curStage + '/bg2'));
				sign.scrollFactor.set(0.4, 0.4);
				add(sign);

				var main:FNFSprite = new FNFSprite(-1100, -800).loadGraphic(Paths.image('backgrounds/' + curStage + '/mainBuildings'));
				main.scrollFactor.set(0.4, 0.4);
				add(main);

				var glow:FNFSprite = new FNFSprite(-1100, -800).loadGraphic(Paths.image('backgrounds/' + curStage + '/glow'));
				glow.scrollFactor.set(0.5, 0.5);
				glow.blend = ADD;
				add(glow);

				var balcony:FNFSprite = new FNFSprite(-1100, -800).loadGraphic(Paths.image('backgrounds/' + curStage + '/balcony'));
				balcony.scrollFactor.set(1, 1);
				add(balcony);

			case 'warehouse': //ziffy tourture
				curStage = 'warehouse';
				PlayState.defaultCamZoom = 1;
				torfloor = new FlxSprite(-1376.3, 494.65).loadGraphic(Paths.image('backgrounds/' + curStage + '/tort_floor'));
				torfloor.updateHitbox();
				torfloor.antialiasing = true;
				torfloor.scrollFactor.set(1, 1);
				torfloor.active = false;
				add(torfloor);

				torwall = new FlxSprite(-921.95, -850).loadGraphic(Paths.image('backgrounds/' + curStage + '/torture_wall'));
				torwall.updateHitbox();
				torwall.antialiasing = true;
				torwall.scrollFactor.set(0.8, 0.8);
				torwall.active = false;
				add(torwall);

				torglasses = new FlxSprite(551.8, 594.3).loadGraphic(Paths.image('backgrounds/' + curStage + '/torture_glasses_preblended'));
				torglasses.updateHitbox();
				torglasses.antialiasing = true;
				torglasses.scrollFactor.set(1.2, 1.2);
				torglasses.active = false;	

				windowlights = new FlxSprite(-159.2, -605.95).loadGraphic(Paths.image('backgrounds/' + curStage + '/windowlights'));
				windowlights.antialiasing = true;
				windowlights.scrollFactor.set(1, 1);
				windowlights.active = false;
				windowlights.alpha = 0.31;
				windowlights.blend = ADD;

				leftblades = new FlxSprite(213.05, -670);
				leftblades.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/leftblades');
				leftblades.animation.addByPrefix('spin', 'blad', 24, false);
				leftblades.animation.play('spin');
				leftblades.antialiasing = true;
				leftblades.scrollFactor.set(1.4, 1.4);
				leftblades.active = true;

				rightblades = new FlxSprite(827.75, -670);
				rightblades.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/rightblades');
				rightblades.animation.addByPrefix('spin', 'blad', 24, false);
				rightblades.animation.play('spin');
				rightblades.antialiasing = true;
				rightblades.scrollFactor.set(1.4, 1.4);
				rightblades.active = true;

				ROZEBUD_ILOVEROZEBUD_HEISAWESOME = new  FlxSprite(-390, -190);
				ROZEBUD_ILOVEROZEBUD_HEISAWESOME.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/torture_roze');
				ROZEBUD_ILOVEROZEBUD_HEISAWESOME.animation.addByPrefix('thing', '', 24, false);
				ROZEBUD_ILOVEROZEBUD_HEISAWESOME.antialiasing = true;
				ROZEBUD_ILOVEROZEBUD_HEISAWESOME.visible = false;

			case 'banana':
				curStage = 'banana';
				PlayState.defaultCamZoom = 1.0;

			case 'finale':
				curStage = 'finale';
				PlayState.defaultCamZoom = 0.4;

				defeatthing = new FlxSprite(-400, -150);
				defeatthing.frames = Paths.getSparrowAtlas('backgrounds/' + curStage + '/defeat');
				defeatthing.animation.addByPrefix('bop', 'defeat', 24, false);
				defeatthing.animation.play('bop');
				defeatthing.setGraphicSize(Std.int(defeatthing.width * 1.3));
				defeatthing.antialiasing = true;
				defeatthing.scrollFactor.set(0.8, 0.8);
				defeatthing.active = true;
				add(defeatthing);

				var bg0:FlxSprite = new FlxSprite(-600, -400).loadGraphic(Paths.image('backgrounds/' + curStage + '/bgg'));
				bg0.updateHitbox();
				bg0.antialiasing = true;
				bg0.scrollFactor.set(0.8, 0.8);
				bg0.active = true;
				bg0.scale.set(1.1, 1.1);
				add(bg0);

				var bg1:FlxSprite = new FlxSprite(800, -270).loadGraphic(Paths.image('backgrounds/' + curStage + '/dead'));
				bg1.updateHitbox();
				bg1.antialiasing = true;
				bg1.scrollFactor.set(0.8, 0.8);
				bg1.active = true;
				bg1.scale.set(1.1, 1.1);
				add(bg1);

				var bg2:FlxSprite = new FlxSprite(-790, -530).loadGraphic(Paths.image('backgrounds/' + curStage + '/bg'));
				bg2.updateHitbox();
				bg2.antialiasing = true;
				bg2.scrollFactor.set(0.9, 0.9);
				bg2.active = true;
				bg2.scale.set(1.1, 1.1);
				add(bg2);

				var bgg:FNFSprite = new FNFSprite(-600, -400).loadGraphic(Paths.image('backgrounds/' + curStage + '/bgg'));
				bgg.scrollFactor.set(0.8, 0.8);

				var dead:FNFSprite = new FNFSprite(800, -270).loadGraphic(Paths.image('backgrounds/' + curStage + '/dead'));
				dead.scrollFactor.set(0.8, 0.8);

				var bg:FNFSprite = new FNFSprite(-790, -530).loadGraphic(Paths.image('backgrounds/' + curStage + '/bg'));
				bg.scrollFactor.set(1, 1);

				var lamp:FNFSprite = new FNFSprite(1190, -280).loadGraphic(Paths.image('backgrounds/' + curStage + '/lamp'));

				add(bgg);
				add(dead);
				add(bg);
				add(lamp);

				bgg.scale.set(1.1, 1.1);
				dead.scale.set(1.1, 1.1);
				bg.scale.set(1.1, 1.1);
				lamp.scale.set(1.1, 1.1);

			case 'monochrome':
				curStage = 'monochrome';
				PlayState.defaultCamZoom = 0.6;

			case 'pink':
				curStage = 'pink';
				PlayState.defaultCamZoom = 0.9;

			case 'skinny':
				curStage = 'skinny';
				PlayState.defaultCamZoom = 0.9;

			case 'tripletrouble':
				curStage = 'tripletrouble';
				PlayState.defaultCamZoom = 0.9;

				var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/' + curStage + '/ttv4'));
				bg.setGraphicSize(Std.int(bg.width * 1));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;
				add(bg);

				var fg:FlxSprite = new FlxSprite(300, 300).loadGraphic(Paths.image('backgrounds/' + curStage + '/ttv4fg'));
				fg.setGraphicSize(Std.int(fg.width * 1));
				fg.antialiasing = true;
				fg.scrollFactor.set(1, 1);
				fg.active = false;
				add(fg);

				wiggleEffect = new WiggleEffect();
				wiggleEffect.effectType = WiggleEffectType.DREAMY;
				wiggleEffect.waveAmplitude = 0.1;
				wiggleEffect.waveFrequency = 5;
				wiggleEffect.waveSpeed = 1;
				bg.shader = wiggleEffect.shader;

			case 'youtuber':
				curStage = 'youtuber';
				PlayState.defaultCamZoom = 1.0;

			default:
				PlayState.defaultCamZoom = 0.9;
				curStage = 'stage';
				var bg:FNFSprite = new FNFSprite(-600, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/stageback'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.9, 0.9);
				bg.active = false;

				// add to the final array
				add(bg);

				var stageFront:FNFSprite = new FNFSprite(-650, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagefront'));
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				stageFront.antialiasing = true;
				stageFront.scrollFactor.set(0.9, 0.9);
				stageFront.active = false;

				// add to the final array
				add(stageFront);

				var stageCurtains:FNFSprite = new FNFSprite(-500, -300).loadGraphic(Paths.image('backgrounds/' + curStage + '/stagecurtains'));
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				stageCurtains.antialiasing = true;
				stageCurtains.scrollFactor.set(1.3, 1.3);
				stageCurtains.active = false;

				// add to the final array
				add(stageCurtains);
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curStage)
	{
		var gfVersion:String = 'gf';

		switch (curStage)
		{
			case 'highway':
				gfVersion = PlayState.SONG.player3;
				if (PlayState.SONG.player3 == null)
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = PlayState.SONG.player3;
				if (PlayState.SONG.player3 == null)
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = PlayState.SONG.player3;
				if (PlayState.SONG.player3 == null)
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = PlayState.SONG.player3;
				if (PlayState.SONG.player3 == null)
				gfVersion = 'gf-pixel';
			default:
				gfVersion = PlayState.SONG.player3;
				if (PlayState.SONG.player3 == null)
				gfVersion = 'gf';
		}

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, boyfriend:Character, dad:Character, gf:Character, camPos:FlxPoint):Void
	{
		var characterArray:Array<Character> = [dad, boyfriend];
		for (char in characterArray) {
			switch (char.curCharacter)
			{
				case 'gf':
					char.setPosition(gf.x, gf.y);
					gf.visible = false;
				/*
					if (isStoryMode)
					{
						camPos.x += 600;
						tweenCamIn();
				}*/
				/*
				case 'spirit':
					var evilTrail = new FlxTrail(char, null, 4, 24, 0.3, 0.069);
					evilTrail.changeValuesEnabled(false, false, false, false);
					add(evilTrail);
					*/
			}
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character, mom:Character, pet:Character):Void
	{
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'highway':
				boyfriend.y -= 220;
				boyfriend.x += 260;
			case 'mall':
				boyfriend.x += 200;
				dad.x -= 400;
				dad.y += 20;
			case 'mallEvil':
				boyfriend.x += 320;
			case 'school':
				dad.setPosition(100, 100);
				gf.setPosition(650, 310);
				boyfriend.setPosition(1000, 180);
				pet.setPosition(1000, 180);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'schoolEvil':
				dad.x -= 150;
				dad.y += 50;
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;
			case 'polus':
				dad.setPosition(0, -150);
				gf.setPosition(300, -120);
				boyfriend.setPosition(870, -150);
				pet.setPosition(870, -150);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'toogus':
				boyfriend.setPosition(970, 50);
				dad.setPosition(0, 50);
				gf.setPosition(400, 80);
				pet.setPosition(970, 50);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'reactor2':
				boyfriend.setPosition(1950, 750);
				dad.setPosition(1100, 750);
				gf.setPosition(1400, 775);
				pet.setPosition(1950, 750);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'ejected':
				boyfriend.setPosition(1008.6, 504);
				dad.setPosition(-775.75, 274.3);
				gf.setPosition(114.4, 78.45);
				pet.setPosition(1008.6, 504);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'airshipRoom':
				boyfriend.setPosition(700, 90);
				dad.setPosition(-220, 90);
				gf.setPosition(135, 90);
				pet.setPosition(700, 90);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'airship':
				boyfriend.setPosition(1650.75, -120);
				dad.setPosition(500, -100);
				gf.setPosition(850, -90);
				pet.setPosition(1650.75, -120);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'cargo':
				boyfriend.setPosition(2550, 650);
				dad.setPosition(1250, 680);
				gf.setPosition(2500, 600);
				mom.setPosition(1600, 650);
				pet.setPosition(2550, 650);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'defeat':
				boyfriend.setPosition(1000, 100);
				dad.setPosition(210, 100);
				gf.setPosition(400, 100);
				pet.setPosition(1000, 100);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'finalem':
				boyfriend.setPosition(1250, 540);
				dad.setPosition(0, 530);
				gf.setPosition(1000, 100);
				pet.setPosition(1250, 540);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'monotone':
				boyfriend.setPosition(1400, 400);
				dad.setPosition(80, 400);
				gf.setPosition(1200, 400);
				pet.setPosition(1400, 400);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'polus2':
				boyfriend.setPosition(1950, 885);
				dad.setPosition(950, 930);
				gf.setPosition(1350, 860);
				pet.setPosition(1950, 885);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'polus3':
				boyfriend.setPosition(1970, 10);
				dad.setPosition(950, -70);
				gf.setPosition(1500, 130);
				pet.setPosition(1970, 10);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'grey':
				boyfriend.setPosition(1900, 300);
				dad.setPosition(750, 350);
				gf.setPosition(1300, 350);
				pet.setPosition(1900, 300);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'plantroom':
				boyfriend.setPosition(600, -20);
				dad.setPosition(-400, 0);
				gf.setPosition(0, 0);
				pet.setPosition(600, -20);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'pretender':
				boyfriend.setPosition(600, -20);
				dad.setPosition(-400, 40);
				gf.setPosition(0, 0);
				pet.setPosition(600, -20);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'chef':
				boyfriend.setPosition(1600, 425);
				dad.setPosition(500, 425);
				gf.setPosition(1000, 300);
				pet.setPosition(1600, 425);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'lounge':
				boyfriend.setPosition(970, 280);
				dad.setPosition(250, 260);
				gf.setPosition(400, 130);
				pet.setPosition(970, 280);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'voting':
				boyfriend.setPosition(1494, 282);
				dad.setPosition(-26, 292);
				gf.setPosition(226, 232);
				mom.setPosition(1194, 192);
				pet.setPosition(1494, 282);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'turbulence':
				boyfriend.setPosition(1970, 420);
				dad.setPosition(750, 160);
				gf.setPosition(400, 130);
				pet.setPosition(1970, 420);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'victory':
				boyfriend.setPosition(1290, 190);
				dad.setPosition(280, 190);
				gf.setPosition(400, 130);
				pet.setPosition(1290, 190);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'powstage':
				boyfriend.setPosition(1030, 200);
				dad.setPosition(100, 200);
				gf.setPosition(400, 130);
				pet.setPosition(1030, 200);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'henry':
				boyfriend.setPosition(1100, 200);
				dad.setPosition(270, 200);
				gf.setPosition(525, 230);
				mom.setPosition(-60, 210);
				pet.setPosition(1100, 200);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'charles':
				boyfriend.setPosition(250, 195);
				dad.setPosition(-1200, 20);
				gf.setPosition(550, 190);
				mom.setPosition(1110, 160);
				pet.setPosition(250, 195);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'tomtus':
				boyfriend.setPosition(1200, 250);
				dad.setPosition(400, 250);
				gf.setPosition(650, 280);
				pet.setPosition(1200, 250);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
 			case 'loggo':
				boyfriend.setPosition(570, 1300);
				dad.setPosition(0, 1300);
				gf.setPosition(400, 130);
				pet.setPosition(570, 1300);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
 			case 'loggo2':
				boyfriend.setPosition(570, 1300);
				dad.setPosition(0, 1300);
				gf.setPosition(400, 130);
				pet.setPosition(570, 1300);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
 			case 'alpha':
				boyfriend.setPosition(770, 100);
				dad.setPosition(100, 100);
				gf.setPosition(400, 130);
				pet.setPosition(770, 100);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
 			case 'kills':
				boyfriend.setPosition(465, 112);
				dad.setPosition(180, 100);
				gf.setPosition(300, -1000);
				pet.setPosition(465, 112);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
 			case 'who':
				boyfriend.setPosition(1450, 750);
				dad.setPosition(400, 775);
				gf.setPosition(800, 730);
				pet.setPosition(1450, 750);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
 			case 'jerma':
				boyfriend.setPosition(1200, 300);
				dad.setPosition(400, 250);
				gf.setPosition(600, 330);
				pet.setPosition(1200, 300);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
 			case 'nuzzus':
				boyfriend.setPosition(770, 100);
				dad.setPosition(-195, -100);
				gf.setPosition(-250, 0);
				pet.setPosition(770, 100);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
 			case 'idk':
				boyfriend.setPosition(400, -230);
				dad.setPosition(20, -180);
				gf.setPosition(450, 500);
				pet.setPosition(400, -230);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
 			case 'esculent':
				boyfriend.setPosition(1000, -1200);
				dad.setPosition(820, 50);
				gf.setPosition(750, 130);
				pet.setPosition(1000, -1200);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
 			case 'drippypop':
				boyfriend.setPosition(1425, 195);
				dad.setPosition(700, 250);
				gf.setPosition(950, 270);
				pet.setPosition(1425, 195);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
 			case 'dave':
				boyfriend.setPosition(1200, 350);
				dad.setPosition(200, 350);
				gf.setPosition(400, 130);
				pet.setPosition(1200, 350);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'attack':
				boyfriend.setPosition(1500, 700);
				dad.setPosition(550, 800);
				gf.setPosition(200, 550);
				mom.setPosition(1600, 450);
				pet.setPosition(1500, 700);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
 			case 'piptowers':
				boyfriend.setPosition(870, 100);
				dad.setPosition(0, 120);
				gf.setPosition(400, 130);
				pet.setPosition(870, 100);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'warehouse':
				boyfriend.setPosition(440, -110);
				dad.setPosition(1120, 50);
				gf.setPosition(310, 0);
				mom.setPosition(-343, 50);
				pet.setPosition(440, -110);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'banana':
				dad.setPosition(350, 185);
				gf.setPosition(630, 155);
				boyfriend.setPosition(1150, 185);
				pet.setPosition(1150, 185);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'finale':
				boyfriend.setPosition(1250, 540);
				dad.setPosition(0, 530);
				gf.setPosition(1000, 100);
				pet.setPosition(1250, 540);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'monochrome':
				dad.setPosition(0, 100);
				gf.setPosition(5400, 130);
				boyfriend.setPosition(5570, 100);
				pet.setPosition(5570, 100);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'pink':
				dad.setPosition(500, 600);
				gf.setPosition(400, 130);
				boyfriend.setPosition(1500, 600);
				pet.setPosition(1500, 600);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'skinny':
				dad.setPosition(265, 98);
				gf.setPosition(400, -1200);
				boyfriend.setPosition(770, 100);
				pet.setPosition(770, 100);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'tripletrouble':
				dad.setPosition(800, 450);
				gf.setPosition(400, 130);
				boyfriend.setPosition(1470, 450);
				pet.setPosition(1470, 450);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
			case 'youtuber':
				dad.setPosition(420, 0);
				gf.setPosition(280, 30);
				boyfriend.setPosition(910, -355);
				pet.setPosition(910, -355);
				repositionPlayersOffset(curStage, boyfriend, dad, gf, mom);
		}
	}

	public function repositionPlayersOffset(curStage, boyfriend:Character, dad:Character, gf:Character, mom:Character):Void
	{
		// REPOSITIONING PER STAGE
		switch (PlayState.SONG.player2)
		{
			case 'dad':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'spooky':
				dad.y += 200;
				dad.x += 0;
				DAD_Y = 200;
				DAD_X = 0;
			case 'pico':
				dad.y += 300;
				dad.x += 0;
				DAD_Y = 300;
				DAD_X = 0;
			case 'picolobby':
				dad.y += 300;
				dad.x += 20;
				DAD_Y = 300;
				DAD_X = 20;
			case 'mom':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'mom-car':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'parents-christmas':
				dad.y += -500;
				dad.x += 0;
				DAD_Y = -500;
				DAD_X = 0;
			case 'monster-christmas':
				dad.y += 130;
				dad.x += 0;
				DAD_Y = 130;
				DAD_X = 0;
			case 'monster':
				dad.y += 100;
				dad.x += 0;
				DAD_Y = 100;
				DAD_X = 0;
			case 'senpai':
				dad.y += 360;
				dad.x += 150;
				DAD_Y = 360;
				DAD_X = 150;
			case 'senpai-angry':
				dad.y += 360;
				dad.x += 150;
				DAD_Y = 360;
				DAD_X = 150;
			case 'spirit':
				dad.y += 100;
				dad.x += -150;
				DAD_Y = 100;
				DAD_X = -150;
			case 'impostor':
				dad.y += 100;
				dad.x += 0;
				DAD_Y = 100;
				DAD_X = 0;
			case 'sabotage':
				dad.y += 100;
				dad.x += 0;
				DAD_Y = 100;
				DAD_X = 0;
			case 'impostor2':
				dad.y += 100;
				dad.x += 0;
				DAD_Y = 100;
				DAD_X = 0;
			case 'crewmate':
				dad.y += 130;
				dad.x += 0;
				DAD_Y = 130;
				DAD_X = 0;
			case 'impostor3':
				dad.y += 80;
				dad.x += 0;
				DAD_Y = 80;
				DAD_X = 0;
			case 'whitegreen':
				dad.y += 80;
				dad.x += 0;
				DAD_Y = 80;
				DAD_X = 0;
			case 'impostorr':
				dad.y += 80;
				dad.x += 0;
				DAD_Y = 80;
				DAD_X = 0;
			case 'parasite':
				dad.y += 100;
				dad.x += 70;
				DAD_Y = 100;
				DAD_X = 70;
			case 'yellow':
				dad.y += 160;
				dad.x += 0;
				DAD_Y = 160;
				DAD_X = 0;
			case 'reaction':
				dad.y += 160;
				dad.x += 0;
				DAD_Y = 160;
				DAD_X = 0;
			case 'white':
				dad.y += 90;
				dad.x += -120;
				DAD_Y = 90;
				DAD_X = -120;
			case 'black-run':
				dad.y += -240;
				dad.x += -290;
				DAD_Y = -240;
				DAD_X = -290;
			case 'blacklegs':
				dad.y += -240;
				dad.x += -290;
				DAD_Y = -240;
				DAD_X = -290;
			case 'blackalt':
				dad.y += -100;
				dad.x += -190;
				DAD_Y = -100;
				DAD_X = -190;
			case 'whitedk':
				dad.y += 280;
				dad.x += 400;
				DAD_Y = 280;
				DAD_X = 400;
			case 'blackdk':
				dad.y += 0;
				dad.x += -320;
				DAD_Y = 0;
				DAD_X = -320;
			case 'black':
				dad.y += 80;
				dad.x += 180;
				DAD_Y = 80;
				DAD_X = 180;
			case 'blackKill':
				dad.y += 80;
				dad.x += 180;
				DAD_Y = 80;
				DAD_X = 180;
			case 'blackold':
				dad.y += -30;
				dad.x += -340;
				DAD_Y = -30;
				DAD_X = -340;
			case 'blackparasite':
				dad.y += -30;
				dad.x += -340;
				DAD_Y = -30;
				DAD_X = -340;
			case 'bfscary':
				dad.y += 150;
				dad.x += 90;
				DAD_Y = 150;
				DAD_X = 90;
			case 'monotone':
				dad.y += -40;
				dad.x += -150;
				DAD_Y = -40;
				DAD_X = -150;
			case 'maroon':
				dad.y += 80;
				dad.x += 110;
				DAD_Y = 80;
				DAD_X = 110;
			case 'maroonp':
				dad.y += 90;
				dad.x += 100;
				DAD_Y = 90;
				DAD_X = 100;
			case 'grey':
				dad.y += 220;
				dad.x += 0;
				DAD_Y = 220;
				DAD_X = 0;
			case 'pink':
				dad.y += 200;
				dad.x += -20;
				DAD_Y = 200;
				DAD_X = -20;
			case 'pretender':
				dad.y += 100;
				dad.x += 60;
				DAD_Y = 100;
				DAD_X = 60;
			case 'chefogus':
				dad.y += 80;
				dad.x += 200;
				DAD_Y = 80;
				DAD_X = 200;
			case 'jorsawsee':
				dad.y += -10;
				dad.x += -130;
				DAD_Y = -10;
				DAD_X = -130;
			case 'meangus':
				dad.y += 430;
				dad.x += 160;
				DAD_Y = 430;
				DAD_X = 160;
			case 'warchief':
				dad.y += 190;
				dad.x += -150;
				DAD_Y = 190;
				DAD_X = -150;
			case 'jelqer':
				dad.y += 160;
				dad.x += -110;
				DAD_Y = 160;
				DAD_X = -110;
			case 'mungus':
				dad.y += 430;
				dad.x += 210;
				DAD_Y = 430;
				DAD_X = 210;
			case 'madgus':
				dad.y += 430;
				dad.x += 210;
				DAD_Y = 430;
				DAD_X = 210;
			case 'redmungusp':
				dad.y += -20;
				dad.x += -240;
				DAD_Y = -20;
				DAD_X = -240;
			case 'jorsawghost':
				dad.y += -20;
				dad.x += 110;
				DAD_Y = -20;
				DAD_X = 110;
			case 'powers':
				dad.y += 180;
				dad.x += 20;
				DAD_Y = 180;
				DAD_X = 20;
			case 'henry':
				dad.y += 50;
				dad.x += 0;
				DAD_Y = 50;
				DAD_X = 0;
			case 'charles':
				dad.y += 0;
				dad.x += -200;
				DAD_Y = 0;
				DAD_X = -200;
			case 'henryphone':
				dad.y += 90;
				dad.x += 0;
				DAD_Y = 90;
				DAD_X = 0;
			case 'ellie':
				dad.y += 30;
				dad.x += -30;
				DAD_Y = 30;
				DAD_X = -30;
			case 'rhm':
				dad.y += 150;
				dad.x += -190;
				DAD_Y = 150;
				DAD_X = -190;
			case 'reginald':
				dad.y += 10;
				dad.x += -80;
				DAD_Y = 10;
				DAD_X = -80;
			case 'tomongus':
				dad.y += 496;
				dad.x += 113;
				DAD_Y = 496;
				DAD_X = 113;
			case 'hamster':
				dad.y += 510;
				dad.x += 133;
				DAD_Y = 510;
				DAD_X = 133;
			case 'tuesday':
				dad.y += 110;
				dad.x += 100;
				DAD_Y = 110;
				DAD_X = 100;
			case 'fella':
				dad.y += 470;
				dad.x += 150;
				DAD_Y = 470;
				DAD_X = 150;
			case 'boo':
				dad.y += 340;
				dad.x += 60;
				DAD_Y = 340;
				DAD_X = 60;
			case 'oldpostor':
				dad.y += 60;
				dad.x += 0;
				DAD_Y = 60;
				DAD_X = 0;
			case 'red':
				dad.y += 100;
				dad.x += 40;
				DAD_Y = 100;
				DAD_X = 40;
			case 'blue':
				dad.y += 100;
				dad.x += 40;
				DAD_Y = 100;
				DAD_X = 40;
			case 'bluehit':
				dad.y += 100;
				dad.x += 40;
				DAD_Y = 100;
				DAD_X = 40;
			case 'bluewhonormal':
				dad.y += 110;
				dad.x += 0;
				DAD_Y = 110;
				DAD_X = 0;
			case 'bluewho':
				dad.y += 110;
				dad.x += 0;
				DAD_Y = 110;
				DAD_X = 0;
			case 'whitewho':
				dad.y += 100;
				dad.x += 0;
				DAD_Y = 100;
				DAD_X = 0;
			case 'whitemad':
				dad.y += 90;
				dad.x += 0;
				DAD_Y = 90;
				DAD_X = 0;
			case 'jerma':
				dad.y += 10;
				dad.x += 0;
				DAD_Y = 10;
				DAD_X = 0;
			case 'nuzzus':
				dad.y += 301;
				dad.x += 264;
				DAD_Y = 301;
				DAD_X = 264;
			case 'idk':
				dad.y += 100;
				dad.x += 40;
				DAD_Y = 100;
				DAD_X = 40;
			case 'esculent':
				dad.y += -50;
				dad.x += 100;
				DAD_Y = -50;
				DAD_X = 100;
			case 'drippypop':
				dad.y += 90;
				dad.x += 0;
				DAD_Y = 90;
				DAD_X = 0;
			case 'dave':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'attack':
				dad.y += 110;
				dad.x += 0;
				DAD_Y = 110;
				DAD_X = 0;
			case 'clowfoe':
				dad.y += 250;
				dad.x += -75;
				DAD_Y = 250;
				DAD_X = -75;
			case 'fabs':
				dad.y += 80;
				dad.x += 0;
				DAD_Y = 80;
				DAD_X = 0;
			case 'biddle':
				dad.y += 100;
				dad.x += 0;
				DAD_Y = 100;
				DAD_X = 0;
			case 'top':
				dad.y += -130;
				dad.x += -90;
				DAD_Y = -130;
				DAD_X = -90;
			case 'cval':
				dad.y += 110;
				dad.x += -100;
				DAD_Y = 110;
				DAD_X = -100;
			case 'pip':
				dad.y += 110;
				dad.x += -100;
				DAD_Y = 110;
				DAD_X = -100;
			case 'pip_evil':
				dad.y += 110;
				dad.x += -100;
				DAD_Y = 110;
				DAD_X = -100;
			case 'cvaltorture':
				dad.y += -70;
				dad.x += -60;
				DAD_Y = -70;
				DAD_X = -60;
			case 'piptorture':
				dad.y += 95;
				dad.x += -200;
				DAD_Y = 95;
				DAD_X = -200;
			case 'ziffytorture':
				dad.y += 170;
				dad.x += 60;
				DAD_Y = 170;
				DAD_X = 60;
			case 'alien':
				dad.y += 290;
				dad.x += -90;
				DAD_Y = 290;
				DAD_X = -90;
			case 'blackPlaceholder':
				dad.y += 290;
				dad.x += 0;
				DAD_Y = 290;
				DAD_X = 0;
			case 'blackpostor':
				dad.y += 160;
				dad.x += -100;
				DAD_Y = 160;
				DAD_X = -100;
			case 'crewmate-dance':
				dad.y += 130;
				dad.x += 0;
				DAD_Y = 130;
				DAD_X = 0;
			case 'dead':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'dt':
				dad.y += 130;
				dad.x += 0;
				DAD_Y = 130;
				DAD_X = 0;
			case 'fuckgus':
				dad.y += 436;
				dad.x += 144;
				DAD_Y = 436;
				DAD_X = 144;
			case 'ghost':
				dad.y += 70;
				dad.x += 0;
				DAD_Y = 70;
				DAD_X = 0;
			case 'henryplayer':
				dad.y += 150;
				dad.x += -20;
				DAD_Y = 150;
				DAD_X = -20;
			case 'impostorv2':
				dad.y += 100;
				dad.x += 0;
				DAD_Y = 100;
				DAD_X = 0;
			case 'jorsawdead':
				dad.y += -20;
				dad.x += 110;
				DAD_Y = -20;
				DAD_X = 110;
			case 'kyubicrasher':
				dad.y += -90;
				dad.x += -210;
				DAD_Y = -90;
				DAD_X = -210;
			case 'loggo':
				dad.y += 160;
				dad.x += 220;
				DAD_Y = 160;
				DAD_X = 220;
			case 'pinkexe':
				dad.y += 50;
				dad.x += 40;
				DAD_Y = 50;
				DAD_X = 40;
			case 'pinkplayable':
				dad.y += 100;
				dad.x += 60;
				DAD_Y = 100;
				DAD_X = 60;
			case 'powers_sax':
				dad.y += 200;
				dad.x += -10;
				DAD_Y = 200;
				DAD_X = -10;
			case 'ziffy':
				dad.y += 80;
				dad.x += 0;
				DAD_Y = 80;
				DAD_X = 0;
			case 'bf':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'bfg':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'whitebf':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'bfr':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'bf-fall':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'bfshock':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'bf-running':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'bf-legs':
				dad.y += 360;
				dad.x += -10;
				DAD_Y = 360;
				DAD_X = -10;
			case 'bf-legsmiss':
				dad.y += 360;
				dad.x += -10;
				DAD_Y = 360;
				DAD_X = -10;
			case 'bf-defeat-normal':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'bf-defeat-scared':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'bfpolus':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'bf-lava':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'bfairship':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'bfmira':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'bfsauce':
				dad.y += 220;
				dad.x += 0;
				DAD_Y = 220;
				DAD_X = 0;
			case 'bf_turb':
				dad.y += 410;
				dad.x += 0;
				DAD_Y = 410;
				DAD_X = 0;
			case 'bfsusreal':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'susfriend':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'dripbf':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'redp':
				dad.y += 590;
				dad.x += -20;
				DAD_Y = 590;
				DAD_X = -20;
			case 'greenp':
				dad.y += 590;
				dad.x += -20;
				DAD_Y = 590;
				DAD_X = -20;
			case 'blackp':
				dad.y += 510;
				dad.x += -40;
				DAD_Y = 510;
				DAD_X = -40;
			case 'amongbf':
				dad.y += 520;
				dad.x += 0;
				DAD_Y = 520;
				DAD_X = 0;
			case 'stick-bf':
				dad.y += 320;
				dad.x += 70;
				DAD_Y = 320;
				DAD_X = 70;
			case 'bf-geoff':
				dad.y += 350;
				dad.x += 1;
				DAD_Y = 350;
				DAD_X = 1;
			case 'bf-opp':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'bfghost':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'bf-car':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'bf-christmas':
				dad.y += 430;
				dad.x += 210;
				DAD_Y = 430;
				DAD_X = 210;
			case 'bf-pixel':
				dad.y += 375;
				dad.x += -5;
				DAD_Y = 375;
				DAD_X = -5;
			case 'bfsus-pixel':
				dad.y += 383;
				dad.x += -17;
				DAD_Y = 383;
				DAD_X = -17;
			case 'idkbf':
				dad.y += 100;
				dad.x += 40;
				DAD_Y = 100;
				DAD_X = 40;
			case 'bf-pixel-opponent':
				dad.y += 480;
				dad.x += 80;
				DAD_Y = 480;
				DAD_X = 80;
			case 'bf-holding-gf':
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
			case 'gf':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'gf-christmas':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'gf-car':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'invisigf':
				dad.y += 80;
				dad.x += 0;
				DAD_Y = 80;
				DAD_X = 0;
			case 'ghostgf':
				dad.y += -80;
				dad.x += 200;
				DAD_Y = -80;
				DAD_X = 200;
			case 'gfr':
				dad.y += 260;
				dad.x += 190;
				DAD_Y = 260;
				DAD_X = 190;
			case 'gf-fall':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'gfdanger':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'gfpolus':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'gfdead':
				dad.y += 350;
				dad.x += 40;
				DAD_Y = 350;
				DAD_X = 40;
			case 'gfmira':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'tuesdaygf':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'oldgf':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'drippico':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'henrygf':
				dad.y += -80;
				dad.x += 0;
				DAD_Y = -80;
				DAD_X = 0;
			case 'gf-farmer':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'loggogf':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
			case 'gf-pixel':
				dad.y += 0;
				dad.x += 0;
				DAD_Y = 0;
				DAD_X = 0;
				default:
				dad.y += 350;
				dad.x += 0;
				DAD_Y = 350;
				DAD_X = 0;
		}
		switch (PlayState.SONG.player1)
		{
			case 'dad':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'spooky':
				boyfriend.x += 0;
				boyfriend.y += 200;
				BF_X = 0;
				BF_Y = 200;
			case 'pico':
				boyfriend.x += 0;
				boyfriend.y += 300;
				BF_X = 0;
				BF_Y = 300;
			case 'picolobby':
				boyfriend.x += 20;
				boyfriend.y += 300;
				BF_X = 20;
				BF_Y = 300;
			case 'mom':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'mom-car':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'parents-christmas':
				boyfriend.x += 0;
				boyfriend.y += -500;
				BF_X = 0;
				BF_Y = -500;
			case 'monster-christmas':
				boyfriend.x += 0;
				boyfriend.y += 130;
				BF_X = 0;
				BF_Y = 130;
			case 'monster':
				boyfriend.x += 0;
				boyfriend.y += 100;
				BF_X = 0;
				BF_Y = 100;
			case 'senpai':
				boyfriend.x += 150;
				boyfriend.y += 360;
				BF_X = 150;
				BF_Y = 360;
			case 'senpai-angry':
				boyfriend.x += 150;
				boyfriend.y += 360;
				BF_X = 150;
				BF_Y = 360;
			case 'spirit':
				boyfriend.x += -150;
				boyfriend.y += 100;
				BF_X = -150;
				BF_Y = 100;
			case 'impostor':
				boyfriend.x += 0;
				boyfriend.y += 100;
				BF_X = 0;
				BF_Y = 100;
			case 'sabotage':
				boyfriend.x += 0;
				boyfriend.y += 100;
				BF_X = 0;
				BF_Y = 100;
			case 'impostor2':
				boyfriend.x += 0;
				boyfriend.y += 100;
				BF_X = 0;
				BF_Y = 100;
			case 'crewmate':
				boyfriend.x += 0;
				boyfriend.y += 130;
				BF_X = 0;
				BF_Y = 130;
			case 'impostor3':
				boyfriend.x += 0;
				boyfriend.y += 80;
				BF_X = 0;
				BF_Y = 80;
			case 'whitegreen':
				boyfriend.x += 0;
				boyfriend.y += 80;
				BF_X = 0;
				BF_Y = 80;
			case 'impostorr':
				boyfriend.x += 0;
				boyfriend.y += 80;
				BF_X = 0;
				BF_Y = 80;
			case 'parasite':
				boyfriend.x += 70;
				boyfriend.y += 100;
				BF_X = 70;
				BF_Y = 100;
			case 'yellow':
				boyfriend.x += 0;
				boyfriend.y += 160;
				BF_X = 0;
				BF_Y = 160;
			case 'reaction':
				boyfriend.x += 0;
				boyfriend.y += 160;
				BF_X = 0;
				BF_Y = 160;
			case 'white':
				boyfriend.x += -120;
				boyfriend.y += 90;
				BF_X = -120;
				BF_Y = 90;
			case 'black-run':
				boyfriend.x += -290;
				boyfriend.y += -240;
				BF_X = -290;
				BF_Y = -240;
			case 'blacklegs':
				boyfriend.x += -290;
				boyfriend.y += -240;
				BF_X = -290;
				BF_Y = -240;
			case 'blackalt':
				boyfriend.x += -190;
				boyfriend.y += -100;
				BF_X = -190;
				BF_Y = -100;
			case 'whitedk':
				boyfriend.x += 400;
				boyfriend.y += 280;
				BF_X = 400;
				BF_Y = 280;
			case 'blackdk':
				boyfriend.x += -320;
				boyfriend.y += 0;
				BF_X = -320;
				BF_Y = 0;
			case 'black':
				boyfriend.x += 180;
				boyfriend.y += 80;
				BF_X = 180;
				BF_Y = 80;
			case 'blackKill':
				boyfriend.x += 180;
				boyfriend.y += 80;
				BF_X = 180;
				BF_Y = 80;
			case 'blackold':
				boyfriend.x += -340;
				boyfriend.y += -30;
				BF_X = -340;
				BF_Y = -30;
			case 'blackparasite':
				boyfriend.x += -340;
				boyfriend.y += -30;
				BF_X = -340;
				BF_Y = -30;
			case 'boyfriendscary':
				boyfriend.x += 90;
				boyfriend.y += 150;
				BF_X = 90;
				BF_Y = 150;
			case 'monotone':
				boyfriend.y += -40;
				boyfriend.x += -150;
				BF_X = -40;
				BF_Y = -150;
			case 'maroon':
				boyfriend.x += 110;
				boyfriend.y += 80;
				BF_X = 110;
				BF_Y = 80;
			case 'maroonp':
				boyfriend.x += 100;
				boyfriend.y += 90;
				BF_X = 100;
				BF_Y = 90;
			case 'grey':
				boyfriend.x += 0;
				boyfriend.y += 220;
				BF_X = 0;
				BF_Y = 220;
			case 'pink':
				boyfriend.x += -20;
				boyfriend.y += 200;
				BF_X = -20;
				BF_Y = 200;
			case 'pretender':
				boyfriend.x += 60;
				boyfriend.y += 100;
				BF_X = 60;
				BF_Y = 100;
			case 'chefogus':
				boyfriend.x += 200;
				boyfriend.y += 80;
				BF_X = 200;
				BF_Y = 80;
			case 'jorsawsee':
				boyfriend.x += -130;
				boyfriend.y += -10;
				BF_X = -130;
				BF_Y = -10;
			case 'meangus':
				boyfriend.x += 160;
				boyfriend.y += 430;
				BF_X = 160;
				BF_Y = 430;
			case 'warchief':
				boyfriend.x += -150;
				boyfriend.y += 190;
				BF_X = -150;
				BF_Y = 190;
			case 'jelqer':
				boyfriend.y += 160;
				boyfriend.x += -110;
				BF_X = 160;
				BF_Y = -110;
			case 'mungus':
				boyfriend.x += 210;
				boyfriend.y += 430;
				BF_X = 210;
				BF_Y = 430;
			case 'madgus':
				boyfriend.x += 210;
				boyfriend.y += 430;
				BF_X = 210;
				BF_Y = 430;
			case 'redmungusp':
				boyfriend.x += -240;
				boyfriend.y += -20;
				BF_X = -240;
				BF_Y = -20;
			case 'jorsawghost':
				boyfriend.x += 110;
				boyfriend.y += -20;
				BF_X = 110;
				BF_Y = -20;
			case 'powers':
				boyfriend.x += 20;
				boyfriend.y += 180;
				BF_X = 20;
				BF_Y = 180;
			case 'henry':
				boyfriend.x += 0;
				boyfriend.y += 50;
				BF_X = 0;
				BF_Y = 50;
			case 'charles':
				boyfriend.x += -200;
				boyfriend.y += 0;
				BF_X = -200;
				BF_Y = 0;
			case 'henryphone':
				boyfriend.x += 0;
				boyfriend.y += 90;
				BF_X = 0;
				BF_Y = 90;
			case 'ellie':
				boyfriend.x += -30;
				boyfriend.y += 30;
				BF_X = -30;
				BF_Y = 30;
			case 'rhm':
				boyfriend.x += -190;
				boyfriend.y += 150;
				BF_X = -190;
				BF_Y = 150;
			case 'reginald':
				boyfriend.x += -80;
				boyfriend.y += 10;
				BF_X = -80;
				BF_Y = 10;
			case 'tomongus':
				boyfriend.x += 113;
				boyfriend.y += 496;
				BF_X = 113;
				BF_Y = 496;
			case 'hamster':
				boyfriend.x += 133;
				boyfriend.y += 510;
				BF_X = 133;
				BF_Y = 510;
			case 'tuesday':
				boyfriend.x += 100;
				boyfriend.y += 110;
				BF_X = 100;
				BF_Y = 110;
			case 'fella':
				boyfriend.x += 150;
				boyfriend.y += 470;
				BF_X = 150;
				BF_Y = 470;
			case 'boo':
				boyfriend.x += 60;
				boyfriend.y += 340;
				BF_X = 60;
				BF_Y = 340;
			case 'oldpostor':
				boyfriend.x += 0;
				boyfriend.y += 60;
				BF_X = 0;
				BF_Y = 60;
			case 'red':
				boyfriend.x += 40;
				boyfriend.y += 100;
				BF_X = 40;
				BF_Y = 100;
			case 'blue':
				boyfriend.x += 40;
				boyfriend.y += 100;
				BF_X = 40;
				BF_Y = 100;
			case 'bluehit':
				boyfriend.x += 40;
				boyfriend.y += 100;
				BF_X = 40;
				BF_Y = 100;
			case 'bluewhonormal':
				boyfriend.x += 0;
				boyfriend.y += 110;
				BF_X = 0;
				BF_Y = 110;
			case 'bluewho':
				boyfriend.x += 0;
				boyfriend.y += 110;
				BF_X = 0;
				BF_Y = 110;
			case 'whitewho':
				boyfriend.x += 0;
				boyfriend.y += 100;
				BF_X = 0;
				BF_Y = 100;
			case 'whitemad':
				boyfriend.x += 0;
				boyfriend.y += 90;
				BF_X = 0;
				BF_Y = 90;
			case 'jerma':
				boyfriend.x += 0;
				boyfriend.y += 10;
				BF_X = 0;
				BF_Y = 10;
			case 'nuzzus':
				boyfriend.x += 264;
				boyfriend.y += 301;
				BF_X = 264;
				BF_Y = 301;
			case 'idk':
				boyfriend.x += 40;
				boyfriend.y += 100;
				BF_X = 40;
				BF_Y = 100;
			case 'esculent':
				boyfriend.x += 100;
				boyfriend.y += -50;
				BF_X = 100;
				BF_Y = -50;
			case 'drippypop':
				boyfriend.x += 0;
				boyfriend.y += 90;
				BF_X = 0;
				BF_Y = 90;
			case 'dave':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'attack':
				boyfriend.x += 0;
				boyfriend.y += 110;
				BF_X = 0;
				BF_Y = 110;
			case 'clowfoe':
				boyfriend.x += -75;
				boyfriend.y += 250;
				BF_X = -75;
				BF_Y = 250;
			case 'fabs':
				boyfriend.x += 0;
				boyfriend.y += 80;
				BF_X = 0;
				BF_Y = 80;
			case 'biddle':
				boyfriend.x += 0;
				boyfriend.y += 100;
				BF_X = 0;
				BF_Y = 100;
			case 'top':
				boyfriend.x += -90;
				boyfriend.y += -130;
				BF_X = -90;
				BF_Y = -130;
			case 'cval':
				boyfriend.x += -100;
				boyfriend.y += 110;
				BF_X = -100;
				BF_Y = 110;
			case 'pip':
				boyfriend.x += -100;
				boyfriend.y += 110;
				BF_X = -100;
				BF_Y = 110;
			case 'pip_evil':
				boyfriend.x += -100;
				boyfriend.y += 110;
				BF_X = -100;
				BF_Y = 110;
			case 'cvaltorture':
				boyfriend.x += -60;
				boyfriend.y += -70;
				BF_X = -60;
				BF_Y = -70;
			case 'piptorture':
				boyfriend.x += -200;
				boyfriend.y += 95;
				BF_X = -200;
				BF_Y = 95;
			case 'ziffytorture':
				boyfriend.x += 60;
				boyfriend.y += 170;
				BF_X = 60;
				BF_Y = 170;
			case 'alien':
				boyfriend.x += -90;
				boyfriend.y += 290;
				BF_X = -90;
				BF_Y = 290;
			case 'blackPlaceholder':
				boyfriend.x += 0;
				boyfriend.y += 290;
				BF_X = 0;
				BF_Y = 290;
			case 'blackpostor':
				boyfriend.x += -100;
				boyfriend.y += 160;
				BF_X = -100;
				BF_Y = 160;
			case 'crewmate-dance':
				boyfriend.x += 0;
				boyfriend.y += 130;
				BF_X = 0;
				BF_Y = 130;
			case 'dead':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'dt':
				boyfriend.x += 0;
				boyfriend.y += 130;
				BF_X = 0;
				BF_Y = 130;
			case 'fuckgus':
				boyfriend.x += 144;
				boyfriend.y += 436;
				BF_X = 144;
				BF_Y = 436;
			case 'ghost':
				boyfriend.x += 0;
				boyfriend.y += 70;
				BF_X = 0;
				BF_Y = 70;
			case 'henryplayer':
				boyfriend.x += -20;
				boyfriend.y += 150;
				BF_X = -20;
				BF_Y = 150;
			case 'impostorv2':
				boyfriend.x += 0;
				boyfriend.y += 100;
				BF_X = 0;
				BF_Y = 100;
			case 'jorsawdead':
				boyfriend.x += 110;
				boyfriend.y += -20;
				BF_X = 110;
				BF_Y = -20;
			case 'kyubicrasher':
				boyfriend.x += -210;
				boyfriend.y += -90;
				BF_X = -210;
				BF_Y = -90;
			case 'loggo':
				boyfriend.x += 220;
				boyfriend.y += 160;
				BF_X = 220;
				BF_Y = 160;
			case 'pinkexe':
				boyfriend.x += 40;
				boyfriend.y += 50;
				BF_X = 40;
				BF_Y = 50;
			case 'pinkplayable':
				boyfriend.x += 60;
				boyfriend.y += 100;
				BF_X = 60;
				BF_Y = 100;
			case 'powers_sax':
				boyfriend.x += -10;
				boyfriend.y += 200;
				BF_X = -10;
				BF_Y = 200;
			case 'ziffy':
				boyfriend.x += 0;
				boyfriend.y += 80;
				BF_X = 0;
				BF_Y = 80;
			case 'bf':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'bfg':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'whitebf':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'bfr':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'bf-fall':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'bfshock':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'bf-running':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'bf-legs':
				boyfriend.x += -10;
				boyfriend.y += 360;
				BF_X = -10;
				BF_Y = 360;
			case 'bf-legsmiss':
				boyfriend.x += -10;
				boyfriend.y += 360;
				BF_X = -10;
				BF_Y = 360;
			case 'bf-defeat-normal':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'bf-defeat-scared':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'bfpolus':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'bf-lava':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'bfairship':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'bfmira':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'bfsauce':
				boyfriend.x += 0;
				boyfriend.y += 220;
				BF_X = 0;
				BF_Y = 220;
			case 'bf_turb':
				boyfriend.x += 0;
				boyfriend.y += 410;
				BF_X = 0;
				BF_Y = 410;
			case 'bfsusreal':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'susfriend':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'dripbf':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'redp':
				boyfriend.x += -20;
				boyfriend.y += 590;
				BF_X = -20;
				BF_Y = 590;
			case 'greenp':
				boyfriend.x += -20;
				boyfriend.y += 590;
				BF_X = -20;
				BF_Y = 590;
			case 'blackp':
				boyfriend.x += -40;
				boyfriend.y += 510;
				BF_X = -40;
				BF_Y = 510;
			case 'amongbf':
				boyfriend.x += 0;
				boyfriend.y += 520;
				BF_X = 0;
				BF_Y = 520;
			case 'stick-bf':
				boyfriend.x += 70;
				boyfriend.y += 320;
				BF_X = 70;
				BF_Y = 320;
			case 'bf-geoff':
				boyfriend.x += 1;
				boyfriend.y += 350;
				BF_X = 1;
				BF_Y = 350;
			case 'bf-opp':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'bfghost':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'bf-car':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'bf-christmas':
				boyfriend.x += 210;
				boyfriend.y += 430;
				BF_X = 210;
				BF_Y = 430;
			case 'bf-pixel':
				boyfriend.x += -5;
				boyfriend.y += 375;
				BF_X = -5;
				BF_Y = 375;
			case 'bfsus-pixel':
				boyfriend.x += -17;
				boyfriend.y += 383;
				BF_X = -17;
				BF_Y = 383;
			case 'idkbf':
				boyfriend.x += 40;
				boyfriend.y += 100;
				BF_X = 40;
				BF_Y = 100;
			case 'bf-pixel-opponent':
				boyfriend.x += 80;
				boyfriend.y += 480;
				BF_X = 80;
				BF_Y = 480;
			case 'bf-holding-gf':
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
			case 'gf':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'gf-christmas':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'gf-car':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'invisigf':
				boyfriend.x += 0;
				boyfriend.y += 80;
				BF_X = 0;
				BF_Y = 80;
			case 'ghostgf':
				boyfriend.x += 200;
				boyfriend.y += -80;
				BF_X = 200;
				BF_Y = -80;
			case 'gfr':
				boyfriend.x += 190;
				boyfriend.y += 260;
				BF_X = 190;
				BF_Y = 160;
			case 'gf-fall':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'gfdanger':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'gfpolus':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'gfdead':
				boyfriend.x += 40;
				boyfriend.y += 350;
				BF_X = 40;
				BF_Y = 350;
			case 'gfmira':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'tuesdaygf':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'oldgf':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'drippico':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'henrygf':
				boyfriend.x += 0;
				boyfriend.y += -80;
				BF_X = 0;
				BF_Y = -80;
			case 'gf-farmer':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'loggogf':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
			case 'gf-pixel':
				boyfriend.x += 0;
				boyfriend.y += 0;
				BF_X = 0;
				BF_Y = 0;
				default:
				boyfriend.x += 0;
				boyfriend.y += 350;
				BF_X = 0;
				BF_Y = 350;
		}
		switch (PlayState.SONG.player3)
		{
			case 'dad':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'spooky':
				gf.x += 0;
				gf.y += 200;
				GF_X = 0;
				GF_Y = 200;
			case 'pico':
				gf.x += 0;
				gf.y += 300;
				GF_X = 0;
				GF_Y = 300;
			case 'picolobby':
				gf.x += 20;
				gf.y += 300;
				GF_X = 20;
				GF_Y = 300;
			case 'mom':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'mom-car':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'parents-christmas':
				gf.x += 0;
				gf.y += -500;
				GF_X = 0;
				GF_Y = -500;
			case 'monster-christmas':
				gf.x += 0;
				gf.y += 130;
				GF_X = 0;
				GF_Y = 130;
			case 'monster':
				gf.x += 0;
				gf.y += 100;
				GF_X = 0;
				GF_Y = 100;
			case 'senpai':
				gf.x += 150;
				gf.y += 360;
				GF_X = 150;
				GF_Y = 360;
			case 'senpai-angry':
				gf.x += 150;
				gf.y += 360;
				GF_X = 150;
				GF_Y = 360;
			case 'spirit':
				gf.x += -150;
				gf.y += 100;
				GF_X = -150;
				GF_Y = 100;
			case 'impostor':
				gf.x += 0;
				gf.y += 100;
				GF_X = 0;
				GF_Y = 100;
			case 'sabotage':
				gf.x += 0;
				gf.y += 100;
				GF_X = 0;
				GF_Y = 100;
			case 'impostor2':
				gf.x += 0;
				gf.y += 100;
				GF_X = 0;
				GF_Y = 100;
			case 'crewmate':
				gf.x += 0;
				gf.y += 130;
				GF_X = 0;
				GF_Y = 130;
			case 'impostor3':
				gf.x += 0;
				gf.y += 80;
				GF_X = 0;
				GF_Y = 80;
			case 'whitegreen':
				gf.x += 0;
				gf.y += 80;
				GF_X = 0;
				GF_Y = 80;
			case 'impostorr':
				gf.x += 0;
				gf.y += 80;
				GF_X = 0;
				GF_Y = 80;
			case 'parasite':
				gf.x += 70;
				gf.y += 100;
				GF_X = 70;
				GF_Y = 100;
			case 'yellow':
				gf.x += 0;
				gf.y += 160;
				GF_X = 0;
				GF_Y = 160;
			case 'reaction':
				gf.x += 0;
				gf.y += 160;
				GF_X = 0;
				GF_Y = 160;
			case 'white':
				gf.x += -120;
				gf.y += 90;
				GF_X = -120;
				GF_Y = 90;
			case 'black-run':
				gf.x += -290;
				gf.y += -240;
				GF_X = -290;
				GF_Y = -240;
			case 'blacklegs':
				gf.x += -290;
				gf.y += -240;
				GF_X = -290;
				GF_Y = -240;
			case 'blackalt':
				gf.x += -190;
				gf.y += -100;
				GF_X = -190;
				GF_Y = -100;
			case 'whitedk':
				gf.x += 400;
				gf.y += 280;
				GF_X = 400;
				GF_Y = 280;
			case 'blackdk':
				gf.x += -320;
				gf.y += 0;
				GF_X = -320;
				GF_Y = 0;
			case 'black':
				gf.x += 180;
				gf.y += 80;
				GF_X = 180;
				GF_Y = 80;
			case 'blackKill':
				gf.x += 180;
				gf.y += 80;
				GF_X = 180;
				GF_Y = 80;
			case 'blackold':
				gf.x += -340;
				gf.y += -30;
				GF_X = -340;
				GF_Y = -30;
			case 'blackparasite':
				gf.x += -340;
				gf.y += -30;
				GF_X = -340;
				GF_Y = -30;
			case 'bfscary':
				gf.x += 90;
				gf.y += 150;
				GF_X = 90;
				GF_Y = 150;
			case 'monotone':
				gf.y += -40;
				gf.x += -150;
				GF_X = -40;
				GF_Y = -150;
			case 'maroon':
				gf.x += 110;
				gf.y += 80;
				GF_X = 110;
				GF_Y = 80;
			case 'maroonp':
				gf.x += 100;
				gf.y += 90;
				GF_X = 100;
				GF_Y = 90;
			case 'grey':
				gf.x += 0;
				gf.y += 220;
				GF_X = 0;
				GF_Y = 220;
			case 'pink':
				gf.x += -20;
				gf.y += 200;
				GF_X = -20;
				GF_Y = 200;
			case 'pretender':
				gf.x += 60;
				gf.y += 100;
				GF_X = 60;
				GF_Y = 100;
			case 'chefogus':
				gf.x += 200;
				gf.y += 80;
				GF_X = 200;
				GF_Y = 80;
			case 'jorsawsee':
				gf.x += -130;
				gf.y += -10;
				GF_X = -130;
				GF_Y = -10;
			case 'meangus':
				gf.x += 160;
				gf.y += 430;
				GF_X = 160;
				GF_Y = 430;
			case 'warchief':
				gf.x += -150;
				gf.y += 190;
				GF_X = -150;
				GF_Y = 190;
			case 'jelqer':
				gf.y += 160;
				gf.x += -110;
				GF_X = 160;
				GF_Y = -110;
			case 'mungus':
				gf.x += 210;
				gf.y += 430;
				GF_X = 210;
				GF_Y = 430;
			case 'madgus':
				gf.x += 210;
				gf.y += 430;
				GF_X = 210;
				GF_Y = 430;
			case 'redmungusp':
				gf.x += -240;
				gf.y += -20;
				GF_X = -240;
				GF_Y = -20;
			case 'jorsawghost':
				gf.x += 110;
				gf.y += -20;
				GF_X = 110;
				GF_Y = -20;
			case 'powers':
				gf.x += 20;
				gf.y += 180;
				GF_X = 20;
				GF_Y = 180;
			case 'henry':
				gf.x += 0;
				gf.y += 50;
				GF_X = 0;
				GF_Y = 50;
			case 'charles':
				gf.x += -200;
				gf.y += 0;
				GF_X = -200;
				GF_Y = 0;
			case 'henryphone':
				gf.x += 0;
				gf.y += 90;
				GF_X = 0;
				GF_Y = 90;
			case 'ellie':
				gf.x += -30;
				gf.y += 30;
				GF_X = -30;
				GF_Y = 30;
			case 'rhm':
				gf.x += -190;
				gf.y += 150;
				GF_X = -190;
				GF_Y = 150;
			case 'reginald':
				gf.x += -80;
				gf.y += 10;
				GF_X = -80;
				GF_Y = 10;
			case 'tomongus':
				gf.x += 113;
				gf.y += 496;
				GF_X = 113;
				GF_Y = 496;
			case 'hamster':
				gf.x += 133;
				gf.y += 510;
				GF_X = 133;
				GF_Y = 510;
			case 'tuesday':
				gf.x += 100;
				gf.y += 110;
				GF_X = 100;
				GF_Y = 110;
			case 'fella':
				gf.x += 150;
				gf.y += 470;
				GF_X = 150;
				GF_Y = 470;
			case 'boo':
				gf.x += 60;
				gf.y += 340;
				GF_X = 60;
				GF_Y = 340;
			case 'oldpostor':
				gf.x += 0;
				gf.y += 60;
				GF_X = 0;
				GF_Y = 60;
			case 'red':
				gf.x += 40;
				gf.y += 100;
				GF_X = 40;
				GF_Y = 100;
			case 'blue':
				gf.x += 40;
				gf.y += 100;
				GF_X = 40;
				GF_Y = 100;
			case 'bluehit':
				gf.x += 40;
				gf.y += 100;
				GF_X = 40;
				GF_Y = 100;
			case 'bluewhonormal':
				gf.x += 0;
				gf.y += 110;
				GF_X = 0;
				GF_Y = 110;
			case 'bluewho':
				gf.x += 0;
				gf.y += 110;
				GF_X = 0;
				GF_Y = 110;
			case 'whitewho':
				gf.x += 0;
				gf.y += 100;
				GF_X = 0;
				GF_Y = 100;
			case 'whitemad':
				gf.x += 0;
				gf.y += 90;
				GF_X = 0;
				GF_Y = 90;
			case 'jerma':
				gf.x += 0;
				gf.y += 10;
				GF_X = 0;
				GF_Y = 10;
			case 'nuzzus':
				gf.x += 264;
				gf.y += 301;
				GF_X = 264;
				GF_Y = 301;
			case 'idk':
				gf.x += 40;
				gf.y += 100;
				GF_X = 40;
				GF_Y = 100;
			case 'esculent':
				gf.x += 100;
				gf.y += -50;
				GF_X = 100;
				GF_Y = -50;
			case 'drippypop':
				gf.x += 0;
				gf.y += 90;
				GF_X = 0;
				GF_Y = 90;
			case 'dave':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'attack':
				gf.x += 0;
				gf.y += 110;
				GF_X = 0;
				GF_Y = 110;
			case 'clowfoe':
				gf.x += -75;
				gf.y += 250;
				GF_X = -75;
				GF_Y = 250;
			case 'fabs':
				gf.x += 0;
				gf.y += 80;
				GF_X = 0;
				GF_Y = 80;
			case 'biddle':
				gf.x += 0;
				gf.y += 100;
				GF_X = 0;
				GF_Y = 100;
			case 'top':
				gf.x += -90;
				gf.y += -130;
				GF_X = -90;
				GF_Y = -130;
			case 'cval':
				gf.x += -100;
				gf.y += 110;
				GF_X = -100;
				GF_Y = 110;
			case 'pip':
				gf.x += -100;
				gf.y += 110;
				GF_X = -100;
				GF_Y = 110;
			case 'pip_evil':
				gf.x += -100;
				gf.y += 110;
				GF_X = -100;
				GF_Y = 110;
			case 'cvaltorture':
				gf.x += -60;
				gf.y += -70;
				GF_X = -60;
				GF_Y = -70;
			case 'piptorture':
				gf.x += -200;
				gf.y += 95;
				GF_X = -200;
				GF_Y = 95;
			case 'ziffytorture':
				gf.x += 60;
				gf.y += 170;
				GF_X = 60;
				GF_Y = 170;
			case 'alien':
				gf.x += -90;
				gf.y += 290;
				GF_X = -90;
				GF_Y = 290;
			case 'blackPlaceholder':
				gf.x += 0;
				gf.y += 290;
				GF_X = 0;
				GF_Y = 290;
			case 'blackpostor':
				gf.x += -100;
				gf.y += 160;
				GF_X = -100;
				GF_Y = 160;
			case 'crewmate-dance':
				gf.x += 0;
				gf.y += 130;
				GF_X = 0;
				GF_Y = 130;
			case 'dead':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'dt':
				gf.x += 0;
				gf.y += 130;
				GF_X = 0;
				GF_Y = 130;
			case 'fuckgus':
				gf.x += 144;
				gf.y += 436;
				GF_X = 144;
				GF_Y = 436;
			case 'ghost':
				gf.x += 0;
				gf.y += 70;
				GF_X = 0;
				GF_Y = 70;
			case 'henryplayer':
				gf.x += -20;
				gf.y += 150;
				GF_X = -20;
				GF_Y = 150;
			case 'impostorv2':
				gf.x += 0;
				gf.y += 100;
				GF_X = 0;
				GF_Y = 100;
			case 'jorsawdead':
				gf.x += 110;
				gf.y += -20;
				GF_X = 110;
				GF_Y = -20;
			case 'kyubicrasher':
				gf.x += -210;
				gf.y += -90;
				GF_X = -210;
				GF_Y = -90;
			case 'loggo':
				gf.x += 220;
				gf.y += 160;
				GF_X = 220;
				GF_Y = 160;
			case 'pinkexe':
				gf.x += 40;
				gf.y += 50;
				GF_X = 40;
				GF_Y = 50;
			case 'pinkplayable':
				gf.x += 60;
				gf.y += 100;
				GF_X = 60;
				GF_Y = 100;
			case 'powers_sax':
				gf.x += -10;
				gf.y += 200;
				GF_X = -10;
				GF_Y = 200;
			case 'ziffy':
				gf.x += 0;
				gf.y += 80;
				GF_X = 0;
				GF_Y = 80;
			case 'bf':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'bfg':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'whitebf':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'bfr':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'bf-fall':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'bfshock':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'bf-running':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'bf-legs':
				gf.x += -10;
				gf.y += 360;
				GF_X = -10;
				GF_Y = 360;
			case 'bf-legsmiss':
				gf.x += -10;
				gf.y += 360;
				GF_X = -10;
				GF_Y = 360;
			case 'bf-defeat-normal':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'bf-defeat-scared':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'bfpolus':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'bf-lava':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'bfairship':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'bfmira':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'bfsauce':
				gf.x += 0;
				gf.y += 220;
				GF_X = 0;
				GF_Y = 220;
			case 'bf_turb':
				gf.x += 0;
				gf.y += 410;
				GF_X = 0;
				GF_Y = 410;
			case 'bfsusreal':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'susfriend':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'dripbf':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'redp':
				gf.x += -20;
				gf.y += 590;
				GF_X = -20;
				GF_Y = 590;
			case 'greenp':
				gf.x += -20;
				gf.y += 590;
				GF_X = -20;
				GF_Y = 590;
			case 'blackp':
				gf.x += -40;
				gf.y += 510;
				GF_X = -40;
				GF_Y = 510;
			case 'amongbf':
				gf.x += 0;
				gf.y += 520;
				GF_X = 0;
				GF_Y = 520;
			case 'stick-bf':
				gf.x += 70;
				gf.y += 320;
				GF_X = 70;
				GF_Y = 320;
			case 'bf-geoff':
				gf.x += 1;
				gf.y += 350;
				GF_X = 1;
				GF_Y = 350;
			case 'bf-opp':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'bfghost':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'bf-car':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'bf-christmas':
				gf.x += 210;
				gf.y += 430;
				GF_X = 210;
				GF_Y = 430;
			case 'bf-pixel':
				gf.x += -5;
				gf.y += 375;
				GF_X = -5;
				GF_Y = 375;
			case 'bfsus-pixel':
				gf.x += -17;
				gf.y += 383;
				GF_X = -17;
				GF_Y = 383;
			case 'idkbf':
				gf.x += 40;
				gf.y += 100;
				GF_X = 40;
				GF_Y = 100;
			case 'bf-pixel-opponent':
				gf.x += 80;
				gf.y += 480;
				GF_X = 80;
				GF_Y = 480;
			case 'bf-holding-gf':
				gf.x += 0;
				gf.y += 350;
				GF_X = 0;
				GF_Y = 350;
			case 'gf':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'gf-christmas':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'gf-car':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'invisigf':
				gf.x += 0;
				gf.y += 80;
				GF_X = 0;
				GF_Y = 80;
			case 'ghostgf':
				gf.x += 200;
				gf.y += -80;
				GF_X = 200;
				GF_Y = -80;
			case 'gfr':
				gf.x += 190;
				gf.y += 260;
				GF_X = 190;
				GF_Y = 260;
			case 'gf-fall':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'gfdanger':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'gfpolus':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'gfdead':
				gf.x += 40;
				gf.y += 350;
				GF_X = 40;
				GF_Y = 350;
			case 'gfmira':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'tuesdaygf':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'oldgf':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'drippico':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'henrygf':
				gf.x += 0;
				gf.y += -80;
				GF_X = 0;
				GF_Y = -80;
			case 'gf-farmer':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'loggogf':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
			case 'gf-pixel':
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
				default:
				gf.x += 0;
				gf.y += 0;
				GF_X = 0;
				GF_Y = 0;
		}
		switch (PlayState.SONG.player4)
		{
			case 'dad':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'spooky':
				mom.x += 0;
				mom.y += 200;
				MOM_X = 0;
				MOM_Y = 200;
			case 'pico':
				mom.x += 0;
				mom.y += 300;
				MOM_X = 0;
				MOM_Y = 300;
			case 'picolobby':
				mom.x += 20;
				mom.y += 300;
				MOM_X = 20;
				MOM_Y = 300;
			case 'mom':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'mom-car':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'parents-christmas':
				mom.x += 0;
				mom.y += -500;
				MOM_X = 0;
				MOM_Y = -500;
			case 'monster-christmas':
				mom.x += 0;
				mom.y += 130;
				MOM_X = 0;
				MOM_Y = 130;
			case 'monster':
				mom.x += 0;
				mom.y += 100;
				MOM_X = 0;
				MOM_Y = 100;
			case 'senpai':
				mom.x += 150;
				mom.y += 360;
				MOM_X = 150;
				MOM_Y = 360;
			case 'senpai-angry':
				mom.x += 150;
				mom.y += 360;
				MOM_X = 150;
				MOM_Y = 360;
			case 'spirit':
				mom.x += -150;
				mom.y += 100;
				MOM_X = -150;
				MOM_Y = 100;
			case 'impostor':
				mom.x += 0;
				mom.y += 100;
				MOM_X = 0;
				MOM_Y = 100;
			case 'sabotage':
				mom.x += 0;
				mom.y += 100;
				MOM_X = 0;
				MOM_Y = 100;
			case 'impostor2':
				mom.x += 0;
				mom.y += 100;
				MOM_X = 0;
				MOM_Y = 100;
			case 'crewmate':
				mom.x += 0;
				mom.y += 130;
				MOM_X = 0;
				MOM_Y = 130;
			case 'impostor3':
				mom.x += 0;
				mom.y += 80;
				MOM_X = 0;
				MOM_Y = 80;
			case 'whitegreen':
				mom.x += 0;
				mom.y += 80;
				MOM_X = 0;
				MOM_Y = 80;
			case 'impostorr':
				mom.x += 0;
				mom.y += 80;
				MOM_X = 0;
				MOM_Y = 80;
			case 'parasite':
				mom.x += 70;
				mom.y += 100;
				MOM_X = 70;
				MOM_Y = 100;
			case 'yellow':
				mom.x += 0;
				mom.y += 160;
				MOM_X = 0;
				MOM_Y = 160;
			case 'reaction':
				mom.x += 0;
				mom.y += 160;
				MOM_X = 0;
				MOM_Y = 160;
			case 'white':
				mom.x += -120;
				mom.y += 90;
				MOM_X = -120;
				MOM_Y = 90;
			case 'black-run':
				mom.x += -290;
				mom.y += -240;
				MOM_X = -290;
				MOM_Y = -240;
			case 'blacklegs':
				mom.x += -290;
				mom.y += -240;
				MOM_X = -290;
				MOM_Y = -240;
			case 'blackalt':
				mom.x += -190;
				mom.y += -100;
				MOM_X = -190;
				MOM_Y = -100;
			case 'whitedk':
				mom.x += 400;
				mom.y += 280;
				MOM_X = 400;
				MOM_Y = 280;
			case 'blackdk':
				mom.x += -320;
				mom.y += 0;
				MOM_X = -320;
				MOM_Y = 0;
			case 'black':
				mom.x += 180;
				mom.y += 80;
				MOM_X = 180;
				MOM_Y = 80;
			case 'blackKill':
				mom.x += 180;
				mom.y += 80;
				MOM_X = 180;
				MOM_Y = 80;
			case 'blackold':
				mom.x += -340;
				mom.y += -30;
				MOM_X = -340;
				MOM_Y = -30;
			case 'blackparasite':
				mom.x += -340;
				mom.y += -30;
				MOM_X = -340;
				MOM_Y = -30;
			case 'boyfriendscary':
				mom.x += 90;
				mom.y += 150;
				MOM_X = 90;
				MOM_Y = 150;
			case 'monotone':
				mom.y += -40;
				mom.x += -150;
				MOM_X = -40;
				MOM_Y = -150;
			case 'maroon':
				mom.x += 110;
				mom.y += 80;
				MOM_X = 110;
				MOM_Y = 80;
			case 'maroonp':
				mom.x += 100;
				mom.y += 90;
				MOM_X = 100;
				MOM_Y = 90;
			case 'grey':
				mom.x += 0;
				mom.y += 220;
				MOM_X = 0;
				MOM_Y = 220;
			case 'pink':
				mom.x += -20;
				mom.y += 200;
				MOM_X = -20;
				MOM_Y = 200;
			case 'pretender':
				mom.x += 60;
				mom.y += 100;
				MOM_X = 60;
				MOM_Y = 100;
			case 'chefogus':
				mom.x += 200;
				mom.y += 80;
				MOM_X = 200;
				MOM_Y = 80;
			case 'jorsawsee':
				mom.x += -130;
				mom.y += -10;
				MOM_X = -130;
				MOM_Y = -10;
			case 'meangus':
				mom.x += 160;
				mom.y += 430;
				MOM_X = 160;
				MOM_Y = 430;
			case 'warchief':
				mom.x += -150;
				mom.y += 190;
				MOM_X = -150;
				MOM_Y = 190;
			case 'jelqer':
				mom.y += 160;
				mom.x += -110;
				MOM_X = 160;
				MOM_Y = -110;
			case 'mungus':
				mom.x += 210;
				mom.y += 430;
				MOM_X = 210;
				MOM_Y = 430;
			case 'madgus':
				mom.x += 210;
				mom.y += 430;
				MOM_X = 210;
				MOM_Y = 430;
			case 'redmungusp':
				mom.x += -240;
				mom.y += -20;
				MOM_X = -240;
				MOM_Y = -20;
			case 'jorsawghost':
				mom.x += 110;
				mom.y += -20;
				MOM_X = 110;
				MOM_Y = -20;
			case 'powers':
				mom.x += 20;
				mom.y += 180;
				MOM_X = 20;
				MOM_Y = 180;
			case 'henry':
				mom.x += 0;
				mom.y += 50;
				MOM_X = 0;
				MOM_Y = 50;
			case 'charles':
				mom.x += -200;
				mom.y += 0;
				MOM_X = -200;
				MOM_Y = 0;
			case 'henryphone':
				mom.x += 0;
				mom.y += 90;
				MOM_X = 0;
				MOM_Y = 90;
			case 'ellie':
				mom.x += -30;
				mom.y += 30;
				MOM_X = -30;
				MOM_Y = 30;
			case 'rhm':
				mom.x += -190;
				mom.y += 150;
				MOM_X = -190;
				MOM_Y = 150;
			case 'reginald':
				mom.x += -80;
				mom.y += 10;
				MOM_X = -80;
				MOM_Y = 10;
			case 'tomongus':
				mom.x += 113;
				mom.y += 496;
				MOM_X = 113;
				MOM_Y = 496;
			case 'hamster':
				mom.x += 133;
				mom.y += 510;
				MOM_X = 133;
				MOM_Y = 510;
			case 'tuesday':
				mom.x += 100;
				mom.y += 110;
				MOM_X = 100;
				MOM_Y = 110;
			case 'fella':
				mom.x += 150;
				mom.y += 470;
				MOM_X = 150;
				MOM_Y = 470;
			case 'boo':
				mom.x += 60;
				mom.y += 340;
				MOM_X = 60;
				MOM_Y = 340;
			case 'oldpostor':
				mom.x += 0;
				mom.y += 60;
				MOM_X = 0;
				MOM_Y = 60;
			case 'red':
				mom.x += 40;
				mom.y += 100;
				MOM_X = 40;
				MOM_Y = 100;
			case 'blue':
				mom.x += 40;
				mom.y += 100;
				MOM_X = 40;
				MOM_Y = 100;
			case 'bluehit':
				mom.x += 40;
				mom.y += 100;
				MOM_X = 40;
				MOM_Y = 100;
			case 'bluewhonormal':
				mom.x += 0;
				mom.y += 110;
				MOM_X = 0;
				MOM_Y = 110;
			case 'bluewho':
				mom.x += 0;
				mom.y += 110;
				MOM_X = 0;
				MOM_Y = 110;
			case 'whitewho':
				mom.x += 0;
				mom.y += 100;
				MOM_X = 0;
				MOM_Y = 100;
			case 'whitemad':
				mom.x += 0;
				mom.y += 90;
				MOM_X = 0;
				MOM_Y = 90;
			case 'jerma':
				mom.x += 0;
				mom.y += 10;
				MOM_X = 0;
				MOM_Y = 10;
			case 'nuzzus':
				mom.x += 264;
				mom.y += 301;
				MOM_X = 264;
				MOM_Y = 301;
			case 'idk':
				mom.x += 40;
				mom.y += 100;
				MOM_X = 40;
				MOM_Y = 100;
			case 'esculent':
				mom.x += 100;
				mom.y += -50;
				MOM_X = 100;
				MOM_Y = -50;
			case 'drippypop':
				mom.x += 0;
				mom.y += 90;
				MOM_X = 0;
				MOM_Y = 90;
			case 'dave':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'attack':
				mom.x += 0;
				mom.y += 110;
				MOM_X = 0;
				MOM_Y = 110;
			case 'clowfoe':
				mom.x += -75;
				mom.y += 250;
				MOM_X = -75;
				MOM_Y = 250;
			case 'fabs':
				mom.x += 0;
				mom.y += 80;
				MOM_X = 0;
				MOM_Y = 80;
			case 'biddle':
				mom.x += 0;
				mom.y += 100;
				MOM_X = 0;
				MOM_Y = 100;
			case 'top':
				mom.x += -90;
				mom.y += -130;
				MOM_X = -90;
				MOM_Y = -130;
			case 'cval':
				mom.x += -100;
				mom.y += 110;
				MOM_X = -100;
				MOM_Y = 110;
			case 'pip':
				mom.x += -100;
				mom.y += 110;
				MOM_X = -100;
				MOM_Y = 110;
			case 'pip_evil':
				mom.x += -100;
				mom.y += 110;
				MOM_X = -100;
				MOM_Y = 110;
			case 'cvaltorture':
				mom.x += -60;
				mom.y += -70;
				MOM_X = -60;
				MOM_Y = -70;
			case 'piptorture':
				mom.x += -200;
				mom.y += 95;
				MOM_X = -200;
				MOM_Y = 95;
			case 'ziffytorture':
				mom.x += 60;
				mom.y += 170;
				MOM_X = 60;
				MOM_Y = 170;
			case 'alien':
				mom.x += -90;
				mom.y += 290;
				MOM_X = -90;
				MOM_Y = 290;
			case 'blackPlaceholder':
				mom.x += 0;
				mom.y += 290;
				MOM_X = 0;
				MOM_Y = 290;
			case 'blackpostor':
				mom.x += -100;
				mom.y += 160;
				MOM_X = -100;
				MOM_Y = 160;
			case 'crewmate-dance':
				mom.x += 0;
				mom.y += 130;
				MOM_X = 0;
				MOM_Y = 130;
			case 'dead':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'dt':
				mom.x += 0;
				mom.y += 130;
				MOM_X = 0;
				MOM_Y = 130;
			case 'fuckgus':
				mom.x += 144;
				mom.y += 436;
				MOM_X = 144;
				MOM_Y = 436;
			case 'ghost':
				mom.x += 0;
				mom.y += 70;
				MOM_X = 0;
				MOM_Y = 70;
			case 'henryplayer':
				mom.x += -20;
				mom.y += 150;
				MOM_X = -20;
				MOM_Y = 150;
			case 'impostorv2':
				mom.x += 0;
				mom.y += 100;
				MOM_X = 0;
				MOM_Y = 100;
			case 'jorsawdead':
				mom.x += 110;
				mom.y += -20;
				MOM_X = 110;
				MOM_Y = -20;
			case 'kyubicrasher':
				mom.x += -210;
				mom.y += -90;
				MOM_X = -210;
				MOM_Y = -90;
			case 'loggo':
				mom.x += 220;
				mom.y += 160;
				MOM_X = 220;
				MOM_Y = 160;
			case 'pinkexe':
				mom.x += 40;
				mom.y += 50;
				MOM_X = 40;
				MOM_Y = 50;
			case 'pinkplayable':
				mom.x += 60;
				mom.y += 100;
				MOM_X = 60;
				MOM_Y = 100;
			case 'powers_sax':
				mom.x += -10;
				mom.y += 200;
				MOM_X = -10;
				MOM_Y = 200;
			case 'ziffy':
				mom.x += 0;
				mom.y += 80;
				MOM_X = 0;
				MOM_Y = 80;
			case 'bf':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'bfg':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'whitebf':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'bfr':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'bf-fall':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'bfshock':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'bf-running':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'bf-legs':
				mom.x += -10;
				mom.y += 360;
				MOM_X = -10;
				MOM_Y = 360;
			case 'bf-legsmiss':
				mom.x += -10;
				mom.y += 360;
				MOM_X = -10;
				MOM_Y = 360;
			case 'bf-defeat-normal':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'bf-defeat-scared':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'bfpolus':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'bf-lava':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'bfairship':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'bfmira':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'bfsauce':
				mom.x += 0;
				mom.y += 220;
				MOM_X = 0;
				MOM_Y = 220;
			case 'bf_turb':
				mom.x += 0;
				mom.y += 410;
				MOM_X = 0;
				MOM_Y = 410;
			case 'bfsusreal':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'susfriend':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'dripbf':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'redp':
				mom.x += -20;
				mom.y += 590;
				MOM_X = -20;
				MOM_Y = 590;
			case 'greenp':
				mom.x += -20;
				mom.y += 590;
				MOM_X = -20;
				MOM_Y = 590;
			case 'blackp':
				mom.x += -40;
				mom.y += 510;
				MOM_X = -40;
				MOM_Y = 510;
			case 'amongbf':
				mom.x += 0;
				mom.y += 520;
				MOM_X = 0;
				MOM_Y = 520;
			case 'stick-bf':
				mom.x += 70;
				mom.y += 320;
				MOM_X = 70;
				MOM_Y = 320;
			case 'bf-geoff':
				mom.x += 1;
				mom.y += 350;
				MOM_X = 1;
				MOM_Y = 350;
			case 'bf-opp':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'bfghost':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'bf-car':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'bf-christmas':
				mom.x += 210;
				mom.y += 430;
				MOM_X = 210;
				MOM_Y = 430;
			case 'bf-pixel':
				mom.x += -5;
				mom.y += 375;
				MOM_X = -5;
				MOM_Y = 375;
			case 'bfsus-pixel':
				mom.x += -17;
				mom.y += 383;
				MOM_X = -17;
				MOM_Y = 383;
			case 'idkbf':
				mom.x += 40;
				mom.y += 100;
				MOM_X = 40;
				MOM_Y = 100;
			case 'bf-pixel-opponent':
				mom.x += 80;
				mom.y += 480;
				MOM_X = 80;
				MOM_Y = 480;
			case 'bf-holding-gf':
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
			case 'gf':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'gf-christmas':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'gf-car':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'invisigf':
				mom.x += 0;
				mom.y += 80;
				MOM_X = 0;
				MOM_Y = 80;
			case 'ghostgf':
				mom.x += 200;
				mom.y += -80;
				MOM_X = 200;
				MOM_Y = -80;
			case 'gfr':
				mom.x += 190;
				mom.y += 260;
				MOM_X = 190;
				MOM_Y = 260;
			case 'gf-fall':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'gfdanger':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'gfpolus':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'gfdead':
				mom.x += 40;
				mom.y += 350;
				MOM_X = 40;
				MOM_Y = 350;
			case 'gfmira':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'tuesdaygf':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'oldgf':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'drippico':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'henrygf':
				mom.x += 0;
				mom.y += -80;
				MOM_X = 0;
				MOM_Y = -80;
			case 'gf-farmer':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'loggogf':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
			case 'gf-pixel':
				mom.x += 0;
				mom.y += 0;
				MOM_X = 0;
				MOM_Y = 0;
				default:
				mom.x += 0;
				mom.y += 350;
				MOM_X = 0;
				MOM_Y = 350;
		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var startedMoving:Bool = false;

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		// trace('update backgrounds');
		switch (PlayState.curStage)
		{
			case 'highway':
				// trace('highway update');
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});
			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'polus':
				if (curBeat % 1 == 0)
				{
					speaker.animation.play('bop');
				}
				if (curBeat % 2 == 0)
				{
					crowd2.animation.play('bop');
				}
			case 'reactor2':
				if (curBeat % 4 == 0)
				{
					toogusorange.animation.play('bop', true);
					toogusblue.animation.play('bop', true);
					tooguswhite.animation.play('bop', true);
				}
			case 'defeat':
				if (curBeat % 4 == 0)
				{
					defeatthing.animation.play('bop', true);
				}
			case 'finalem':
				if(curBeat % 4 == 0)
					finaleLight.animation.play('bop');
			case 'polus2':
				if (curBeat % 2 == 0)
				{
					crowd.animation.play('bop');
				}
			case 'grey':
				if (curBeat % 2 == 0)
				{
					crowd.animation.play('bop');
				}
			case 'plantroom':
				if (curBeat % 2 == 0)
				{
					cyanmira.animation.play('bop', true);
					greymira.animation.play('bop', true);
					oramira.animation.play('bop', true);
				}
				if (curBeat % 1 == 0)
				{
					bluemira.animation.play('bop', true);
				}
			case 'pretender':
				if(curBeat % 2 == 0){	
					bluemira.animation.play('bop');
				}
				if (curBeat % 1 == 0)
				{
					gfDeadPretender.animation.play('bop');
				}
			case 'chef':
				if (curBeat % 2 == 0)
				{
					gray.animation.play('bop');
					saster.animation.play('bop');
				}
			case 'turbulence':
				if (curBeat % 2 == 0)
				{
					clawshands.animation.play('squeeze', true);
				}
			case 'victory':
				if (curBeat % 2 == 0)
				{
					VICTORY_TEXT.animation.play('expand', true);
					bg_war.animation.play('bop', true);
					bg_jor.animation.play('bop', true);
				}
				if (curBeat % 1 == 0)
				{
					bg_vic.animation.play('bop', true);
					vicPulse.animation.play('pulsate', true);
					bg_jelq.animation.play('bop', true);
				}
			case 'loggo' | 'loggo2':
				if (curBeat % 2 == 0)
				{
					peopleloggo.animation.play('bop', true);
				}
			case 'attack':
				if (curBeat % 2 == 0)
				{
					crowd.animation.play('bop');
					peopleloggo.animation.play('bop');
					nickt.animation.play('bop');
					
				}
				if (curBeat % 1 == 0)
				{
					toogusorange.animation.play('bop');
					toogusblue.animation.play('bop');
					thebackground.animation.play('bop');
				}

			case 'philly':
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					var lastLight:FlxSprite = phillyCityLights.members[0];

					phillyCityLights.forEach(function(light:FNFSprite)
					{
						// Take note of the previous light
						if (light.visible == true)
							lastLight = light;

						light.visible = false;
					});

					// To prevent duplicate lights, iterate until you get a matching light
					while (lastLight == phillyCityLights.members[curLight])
					{
						curLight = FlxG.random.int(0, phillyCityLights.length - 1);
					}

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;

					FlxTween.tween(phillyCityLights.members[curLight], {alpha: 0}, Conductor.stepCrochet * .016);
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		switch (PlayState.curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos(gf);
						trainFrameTiming = 0;
					}
				}
			case 'toogus':
		{
			saxguy.x = FlxMath.lerp(saxguy.x, saxguy.x + 15, CoolUtil.boundTo(elapsed * 9, 0, 1));
		}
			case 'ejected':
				// make sure that the clouds exist
				if (cloudScroll.members.length == 3)
				{
					for (i in 0...cloudScroll.members.length)
					{
						cloudScroll.members[i].y = FlxMath.lerp(cloudScroll.members[i].y, cloudScroll.members[i].y - speedPass[i],
							CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (cloudScroll.members[i].y < -1789.65)
						{
							// im not using flxbackdrops so this is how we're doing things today
							var randomScale = FlxG.random.float(1.5, 2.2);
							var randomScroll = FlxG.random.float(1, 1.3);

							speedPass[i] = FlxG.random.float(1100, 1300);

							cloudScroll.members[i].scale.set(randomScale, randomScale);
							cloudScroll.members[i].scrollFactor.set(randomScroll, randomScroll);
							cloudScroll.members[i].x = FlxG.random.float(-3578.95, 3259.6);
							cloudScroll.members[i].y = 2196.15;
						}
					}
				}
				if (farClouds.members.length == 7)
				{
					for (i in 0...farClouds.members.length)
					{
						farClouds.members[i].y = FlxMath.lerp(farClouds.members[i].y, farClouds.members[i].y - farSpeedPass[i],
							CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (farClouds.members[i].y < -1614)
						{
							var randomScale = FlxG.random.float(0.2, 0.5);
							var randomScroll = FlxG.random.float(0.2, 0.4);

							farSpeedPass[i] = FlxG.random.float(1100, 1300);

							farClouds.members[i].scale.set(randomScale, randomScale);
							farClouds.members[i].scrollFactor.set(randomScroll, randomScroll);
							farClouds.members[i].x = FlxG.random.float(-2737.85, 3485.4);
							farClouds.members[i].y = 1738.6;
						}
					}
				}
				// AAAAAAAAAAAAAAAAAAAA
				if (leftBuildings.length > 0)
				{
					for (i in 0...leftBuildings.length)
					{
						leftBuildings[i].y = middleBuildings[i].y + 5888;
					}
				}
				if (middleBuildings.length > 0)
				{
					for (i in 0...middleBuildings.length)
					{
						if (middleBuildings[i].y < -11759.9)
						{
							middleBuildings[i].y = 3190.5;
							middleBuildings[i].animation.play(FlxG.random.bool(50) ? '1' : '2');
						}
						middleBuildings[i].y = FlxMath.lerp(middleBuildings[i].y, middleBuildings[i].y - 1300, CoolUtil.boundTo(elapsed * 9, 0, 1));
					}
				}
				if (rightBuildings.length > 0)
				{
					for (i in 0...rightBuildings.length)
					{
						rightBuildings[i].y = leftBuildings[i].y;
					}
				}
				speedLines.y = FlxMath.lerp(speedLines.y, speedLines.y - 1350, CoolUtil.boundTo(elapsed * 9, 0, 1));

				if (fgCloud != null)
				{
					fgCloud.y = FlxMath.lerp(fgCloud.y, fgCloud.y - 0.01, CoolUtil.boundTo(elapsed * 9, 0, 1));
				}
			case 'airship':
				if (airCloseClouds.members.length > 0)
				{
					for (i in 0...airCloseClouds.members.length)
					{
						airCloseClouds.members[i].x = FlxMath.lerp(airCloseClouds.members[i].x, airCloseClouds.members[i].x - 50,
							CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (airCloseClouds.members[i].x < -10400.2)
						{
							airCloseClouds.members[i].x = 5582.2;
						}
					}
				}
				if (airMidClouds.members.length > 0)
				{
					for (i in 0...airMidClouds.members.length)
					{
						airMidClouds.members[i].x = FlxMath.lerp(airMidClouds.members[i].x, airMidClouds.members[i].x - 13, CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (airMidClouds.members[i].x < -6153.4)
						{
							airMidClouds.members[i].x = 2852.4;
						}
					}
				}
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
				if (airFarClouds.members.length > 0)
				{
					for (i in 0...airFarClouds.members.length)
					{
						airFarClouds.members[i].x = FlxMath.lerp(airFarClouds.members[i].x, airFarClouds.members[i].x - 7, CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (airFarClouds.members[i].x < -6178.95)
						{
							airFarClouds.members[i].x = 2874.95;
						}
					}
				}
				if (airshipPlatform.members.length > 0)
				{
					for (i in 0...airshipPlatform.members.length)
					{
						airshipPlatform.members[i].x = FlxMath.lerp(airshipPlatform.members[i].x, airshipPlatform.members[i].x - 300,
							CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (airshipPlatform.members[i].x < -7184.8)
						{
							airshipPlatform.members[i].x = 4275.15;
						}
					}
				}
				if (airBigCloud != null)
				{
					airBigCloud.x = FlxMath.lerp(airBigCloud.x, airBigCloud.x - bigCloudSpeed, CoolUtil.boundTo(elapsed * 9, 0, 1));
					if (airBigCloud.x < -4163.7)
					{
						airBigCloud.x = FlxG.random.float(3931.5, 4824.05);
						airBigCloud.y = FlxG.random.float(-1087.5, -307.35);
						bigCloudSpeed = FlxG.random.float(7, 15);
					}
				}
			case 'plantroom' | 'pretender':
		{
			cloud1.x = FlxMath.lerp(cloud1.x, cloud1.x - 1, CoolUtil.boundTo(elapsed * 9, 0, 1));
			cloud2.x = FlxMath.lerp(cloud2.x, cloud2.x - 3, CoolUtil.boundTo(elapsed * 9, 0, 1));
			cloud3.x = FlxMath.lerp(cloud3.x, cloud3.x - 2, CoolUtil.boundTo(elapsed * 9, 0, 1));
			cloud4.x = FlxMath.lerp(cloud4.x, cloud4.x - 0.1, CoolUtil.boundTo(elapsed * 9, 0, 1));
			cloudbig.x = FlxMath.lerp(cloudbig.x, cloudbig.x - 0.5, CoolUtil.boundTo(elapsed * 9, 0, 1));
		}
			case 'turbulence':
				boyfriend.y = (Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 1.0) * 15) + 770;
				hookarm.y = (Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 1.0) * 15) + 850;
				clawshands.y = (Math.sin((Conductor.songPosition / 1000) * (Conductor.bpm / 60) * 1.0) * 15) + 650;

				midderclouds.x = FlxMath.lerp(midderclouds.x, midderclouds.x + 175 * turbSpeed,
					CoolUtil.boundTo(elapsed * 9, 0, 1));
				if (midderclouds.x > 5140.05)
				{
					midderclouds.x = -3352.1;
				}

				hotairballoon.x = FlxMath.lerp(hotairballoon.x, hotairballoon.x + 75 * turbSpeed,
					CoolUtil.boundTo(elapsed * 9, 0, 1));
				if (hotairballoon.x > 3140.05)
				{
					hotairballoon.x = -1352.1;
				}

				backerclouds.x = FlxMath.lerp(backerclouds.x, backerclouds.x + 55 * turbSpeed,
					CoolUtil.boundTo(elapsed * 9, 0, 1));
				if (backerclouds.x > 5140.05)
				{
					backerclouds.x = -1352.1;
				}

				if (airSpeedlines.members.length > 0)
				{
					for (i in 0...airSpeedlines.members.length)
					{
						airSpeedlines.members[i].x = FlxMath.lerp(airSpeedlines.members[i].x, airSpeedlines.members[i].x + 350 * turbSpeed,
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
						turbFrontCloud.members[i].x = FlxMath.lerp(turbFrontCloud.members[i].x, turbFrontCloud.members[i].x + 400 * turbSpeed,
							CoolUtil.boundTo(elapsed * 9, 0, 1));
						if (turbFrontCloud.members[i].x > 5140.05)
						{
							turbFrontCloud.members[i].x = -4352.1;
						}
					}
				}
		}
	}

	// PHILLY STUFFS!
	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	function updateTrainPos(gf:Character):Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset(gf);
		}
	}

	function trainReset(gf:Character):Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}