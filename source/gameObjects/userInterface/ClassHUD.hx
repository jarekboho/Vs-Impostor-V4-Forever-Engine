package gameObjects.userInterface;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import meta.CoolUtil;
import meta.InfoHud;
import meta.data.Conductor;
import meta.data.Timings;
import meta.state.PlayState;
import meta.MusicBeat.MusicBeatState;

using StringTools;

class ClassHUD extends FlxTypedGroup<FlxBasic>
{
	// set up variables and stuff here

	public var finaleBarRed:FlxSprite;
	public var finaleBarBlue:FlxSprite;

	// votingtime
	var vt_light:FlxSprite;
	var bars:FlxSprite;

	var ass2:FlxSprite;

	var infoBar:FlxText; // small side bar like kade engine that tells you engine info
	public var scoreBar:FlxText;

	var scoreLast:Float = -1;
	var scoreDisplay:String;

	public var healthBarBG:FlxSprite;
	public var healthBar:FlxBar;

	private var SONG = PlayState.SONG;
	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	private var stupidHealth:Float = 0;

	private var timingsMap:Map<String, FlxText> = [];

	// eep
	public function new()
	{
		// call the initializations and stuffs
		super();

		vt_light = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/voting/light_voting'));
		vt_light.updateHitbox();
		vt_light.antialiasing = true;
		vt_light.scrollFactor.set(1, 1);
		vt_light.active = false;
		vt_light.blend = 'add';
		vt_light.alpha = 0.46;

		bars = new FlxSprite(0, 0).loadGraphic(Paths.image('backgrounds/bars'));
		bars.scrollFactor.set();
		bars.screenCenter();

		if (PlayState.SONG.stage.toLowerCase() == 'voting')
		{
			add(vt_light);
			add(bars);
		}
		if (PlayState.SONG.stage.toLowerCase() == 'finalem')
		{
			add(bars);
		}
		if (PlayState.SONG.stage.toLowerCase() == 'monotone')
		{
			add(bars);
		}

		ass2 = new FlxSprite(0, FlxG.height * 1).loadGraphic(Paths.image('backgrounds/jerma/vignette'));
		ass2.scrollFactor.set();
		ass2.screenCenter();

		if (PlayState.SONG.stage.toLowerCase() == 'jerma')
		{
		add(ass2);
		}

		// fnf mods
		var scoreDisplay:String = 'beep bop bo skdkdkdbebedeoop brrapadop';

		// le healthbar setup
		var barY = FlxG.height * 0.875;
		if (Init.trueSettings.get('Downscroll'))
			barY = 64;

		healthBarBG = new FlxSprite(0,
			barY).loadGraphic(Paths.image(ForeverTools.returnSkinAsset('healthBar', PlayState.assetModifier, PlayState.changeableSkin, 'UI')));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8));
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
		// healthBar
		add(healthBar);

		if(PlayState.SONG.stage.toLowerCase() == 'finalem'){
			finaleBarRed = new FlxSprite(0, 530).loadGraphic(Paths.image('backgrounds/finalem/healthBarFinaleRed'));
			finaleBarRed.setGraphicSize(Std.int(finaleBarRed.width * 0.6));
			finaleBarRed.updateHitbox();
			finaleBarRed.x = (FlxG.width / 2) - (finaleBarRed.width / 2);
			finaleBarRed.visible = false;
			finaleBarRed.antialiasing = true;
			add(finaleBarRed);

			finaleBarBlue = new FlxSprite(0, 530).loadGraphic(Paths.image('backgrounds/finalem/healthBarFinaleBlue'));
			finaleBarBlue.setGraphicSize(Std.int(finaleBarBlue.width * 0.6));
			finaleBarBlue.updateHitbox();
			finaleBarBlue.x = (FlxG.width / 2) - (finaleBarBlue.width / 2);
			finaleBarBlue.visible = false;
			finaleBarBlue.antialiasing = true;
			add(finaleBarBlue);

			if (Init.trueSettings.get('Downscroll')){
				var pos = FlxG.height - (finaleBarRed.y + finaleBarRed.height);
				finaleBarRed.y = pos;
				finaleBarRed.flipY = true;
				finaleBarBlue.y = pos;
				finaleBarBlue.flipY = true;
			}
		}

		iconP1 = new HealthIcon(SONG.player1, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		if (PlayState.missLimited)
		{
			healthBar.visible = false;
			healthBarBG.visible = false;
		}

		if (PlayState.SONG.stage.toLowerCase() == 'victory')
		{
		healthBar.visible = false;
		healthBarBG.visible = false;
		iconP1.visible = false;
		iconP2.visible = false;
		}

		scoreBar = new FlxText(FlxG.width / 2, healthBarBG.y + 40, 0, scoreDisplay, 20);
		scoreBar.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		updateScoreText();
		scoreBar.scrollFactor.set();
		add(scoreBar);

		// small info bar, kinda like the KE watermark
		// based on scoretxt which I will set up as well
		var infoDisplay:String = CoolUtil.dashToSpace(PlayState.SONG.song) + ' - ' + CoolUtil.difficultyFromNumber(PlayState.freeplayDifficulty);
		var engineDisplay:String = "Forever Engine v" + Main.gameVersion;
		var engineBar:FlxText = new FlxText(0, FlxG.height - 30, 0, engineDisplay, 16);
		engineBar.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		engineBar.updateHitbox();
		engineBar.x = FlxG.width - engineBar.width - 5;
		engineBar.scrollFactor.set();
		add(engineBar);

		var engineBar:FlxText = new FlxText(0, FlxG.height - 45, 0, "VS Impostor v4.1.0", 16);
		engineBar.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		engineBar.updateHitbox();
		engineBar.x = FlxG.width - engineBar.width - 5;
		engineBar.scrollFactor.set();
		add(engineBar);

		infoBar = new FlxText(5, FlxG.height - 30, 0, infoDisplay, 20);
		infoBar.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoBar.scrollFactor.set();
		add(infoBar);

		if (PlayState.SONG.stage.toLowerCase() == 'nuzzus')
		{
		scoreBar.setFormat(Paths.font("apple_kid.ttf"), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		healthBar.visible = false;
		healthBarBG.visible = false;
		iconP1.visible = false;
		iconP2.visible = false;
		}

		// counter
		if (Init.trueSettings.get('Counter') != 'None') {
			var judgementNameArray:Array<String> = [];
			for (i in Timings.judgementsMap.keys())
				judgementNameArray.insert(Timings.judgementsMap.get(i)[0], i);
			judgementNameArray.sort(sortByShit);
			for (i in 0...judgementNameArray.length) {
				var textAsset:FlxText = new FlxText(5 + (!left ? (FlxG.width - 10) : 0),
					(FlxG.height / 2)
					- (counterTextSize * (judgementNameArray.length / 2))
					+ (i * counterTextSize), 0,
					'', counterTextSize);
				if (!left)
					textAsset.x -= textAsset.text.length * counterTextSize;
				textAsset.setFormat(Paths.font("vcr.ttf"), counterTextSize, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				textAsset.scrollFactor.set();
				timingsMap.set(judgementNameArray[i], textAsset);
				add(textAsset);
			}
		}
		updateScoreText();
	}

	var counterTextSize:Int = 18;

	function sortByShit(Obj1:String, Obj2:String):Int
		return FlxSort.byValues(FlxSort.ASCENDING, Timings.judgementsMap.get(Obj1)[0], Timings.judgementsMap.get(Obj2)[0]);

	var left = (Init.trueSettings.get('Counter') == 'Left');

	override public function update(elapsed:Float)
	{
		// pain, this is like the 7th attempt
		healthBar.percent = (PlayState.health * 50);

		var iconLerp = 0.5;
		iconP1.setGraphicSize(Std.int(FlxMath.lerp(iconP1.initialWidth, iconP1.width, iconLerp)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(iconP2.initialWidth, iconP2.width, iconLerp)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		if(PlayState.SONG.stage.toLowerCase() != 'finalem'){
		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
		}
		else{
			iconP1.x = finaleBarRed.x + (finaleBarRed.width / 1.4) + 50;
			iconP2.x = finaleBarRed.x - 120;
			iconP1.y = healthBar.y - (iconP1.height / 2) + 7;
			if (healthBar.percent > 80)
				iconP2.y = healthBar.y - (iconP2.height / 2) - 50;
			else
				iconP2.y = healthBar.y - (iconP2.height / 2) - 28;
			if (Init.trueSettings.get('Downscroll')){
				iconP2.y += 40;
			}
			iconP2.scale.set(0.8, 0.8);
		}

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if(PlayState.curStage.toLowerCase() == 'finalem'){
			if (healthBar.percent > 80)
				iconP2.animation.play('mad');
			else
				iconP2.animation.play('calm');
		}
		else{
		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;
		}
	}

	private final divider:String = ' - ';

	public function updateScoreText()
	{
		var importSongScore = PlayState.songScore;
		var importPlayStateCombo = PlayState.combo;
		var importMisses = PlayState.misses;
		if (PlayState.SONG.stage.toLowerCase() == 'victory')
		{
		scoreBar.text = 'Score: Who cares? You already won!';
		}
		else
		{
		scoreBar.text = 'Score: $importSongScore';
		}

		// testing purposes
		var displayAccuracy:Bool = Init.trueSettings.get('Display Accuracy');
		if (displayAccuracy)
		{
		if (PlayState.SONG.stage.toLowerCase() == 'victory')
		{
			scoreBar.text += divider + 'Accuracy: ' + Std.string(Math.floor(Timings.getAccuracy() * 100) / 100) + '%' + Timings.comboDisplay;
			scoreBar.text += divider + 'Combo Breaks: ' + Std.string(PlayState.misses);
			scoreBar.text += divider + 'Rank: ' + Std.string(Timings.returnScoreRating().toUpperCase());
		}
		else
		{
			scoreBar.text += divider + 'Accuracy: ' + Std.string(Math.floor(Timings.getAccuracy() * 100) / 100) + '%' + Timings.comboDisplay;
			scoreBar.text += divider + 'Combo Breaks: ' + Std.string(PlayState.misses);
			scoreBar.text += divider + 'Rank: ' + Std.string(Timings.returnScoreRating().toUpperCase());
		}
		}

		scoreBar.x = ((FlxG.width / 2) - (scoreBar.width / 2));

		// update counter
		if (Init.trueSettings.get('Counter') != 'None')
		{
			for (i in timingsMap.keys()) {
				timingsMap[i].text = '${(i.charAt(0).toUpperCase() + i.substring(1, i.length))}: ${Timings.gottenJudgements.get(i)}';
				timingsMap[i].x = (5 + (!left ? (FlxG.width - 10) : 0) - (!left ? (6 * counterTextSize) : 0));
			}
		}

		// update playstate
		PlayState.detailsSub = scoreBar.text;
		PlayState.updateRPC(false);
	}

	public function beatHit()
	{
		if(PlayState.SONG.stage.toLowerCase() != 'finalem'){
		if (!Init.trueSettings.get('Reduced Movements'))
		{
			iconP1.setGraphicSize(Std.int(iconP1.width + 45));
			iconP2.setGraphicSize(Std.int(iconP2.width + 45));

			iconP1.updateHitbox();
			iconP2.updateHitbox();
		}
		}
		//
	}
}