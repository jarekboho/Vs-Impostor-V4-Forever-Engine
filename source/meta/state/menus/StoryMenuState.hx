package meta.state.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gameObjects.userInterface.*;
import gameObjects.userInterface.menu.*;
import meta.MusicBeat.MusicBeatState;
import meta.data.*;
import meta.data.dependency.FNFSprite;
import meta.data.dependency.Discord;
import meta.data.Song.SwagSong;
import AmongDeathSubstate;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxCamera;
import flixel.math.FlxPoint;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;
	var curDifficulty:Int = 1;

public static var weekUnlocked:Array<Bool> = [true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true];

	var txtWeekTitle:FlxText;
	var txtWeekNumber:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var starsBG:FlxSprite;
	var starsFG:FlxSprite;
	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var weekHealthIcon:HealthIcon;
	var weekHealthIconLose:HealthIcon;

	var ship:FlxSprite;
	var shipAnimOffsets:Map<String, Array<Dynamic>>;

	var weekCircles:FlxTypedGroup<FlxSprite>;
	var weekLines:FlxTypedGroup<FlxSprite>;

	var weekXvalues:Array<Float> = [];
	var weekYvalues:Array<Float> = [];

	public var camSpace:FlxCamera;
	public var camScreen:FlxCamera;

	override function create()
	{
		super.create();

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		#if !html5
		Discord.changePresence('STORY MENU', 'Main Menu');
		#end

		// freeaaaky
		ForeverTools.resetMenuMusic();

		persistentUpdate = persistentDraw = true;

		camSpace = new FlxCamera(0, 100);
		camScreen = new FlxCamera();
		camScreen.bgColor.alpha = 0;

		FlxG.cameras.reset(camSpace);
		FlxG.cameras.add(camScreen);

		FlxCamera.defaultCameras = [camSpace];

		camSpace.zoom = 0.7;

		starsBG = new FlxBackdrop(Paths.image('menus/base/storymenu/starBG'));
		starsBG.setPosition(111.3, 67.95);
        starsBG.antialiasing = true;
        starsBG.updateHitbox();
        starsBG.scrollFactor.set();
        add(starsBG);
        
        starsFG = new FlxBackdrop(Paths.image('menus/base/storymenu/starFG'));
        starsFG.setPosition(54.3, 59.45);
        starsFG.updateHitbox();
        starsFG.antialiasing = true;
        starsFG.scrollFactor.set();
        add(starsFG);

		shipAnimOffsets = new Map<String, Array<Dynamic>>();

		ship = new FlxSprite(0, 0);
		//orbyy
		ship.cameras = [camSpace];

		ship.frames = Paths.getSparrowAtlas('menus/base/storymenu/ship');
		
		ship.animation.addByPrefix('right', 'right', 24, false);
        ship.animation.addByPrefix('down', 'down', 24, false);
        ship.animation.addByPrefix('left', 'left', 24, false);
		ship.animation.addByPrefix('up', 'up', 24, false);

		shipAddOffset('right', 10, 0);
		shipAddOffset('down', -47, 57);
		shipAddOffset('left', -54, 0);
		shipAddOffset('up', -47, -10);

		shipPlayAnim('right');

		weekCircles = new FlxTypedGroup<FlxSprite>();
		add(weekCircles);

		weekLines = new FlxTypedGroup<FlxSprite>();
		add(weekLines);

		scoreText = new FlxText(80, 170, 0, "SCORE: 49324858");
		scoreText.setFormat(Paths.font('AmaticSC-Bold.ttf'), 54, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreText.borderSize = 2;
		scoreText.cameras = [camScreen];

		txtWeekNumber = new FlxText(FlxG.width / 2.4 - 10, 40, 0, "");
		txtWeekNumber.setFormat(Paths.font('AmaticSC-Bold.ttf'), 111, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtWeekNumber.borderSize = 2.6;
		txtWeekNumber.cameras = [camScreen];

		txtWeekTitle = new FlxText(FlxG.width / 2.6, txtWeekNumber.y + 115, 0, "");
		txtWeekTitle.setFormat(Paths.font('AmaticSC-Bold.ttf'), 64, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtWeekTitle.borderSize = 2.2;
		txtWeekTitle.cameras = [camScreen];

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		weekHealthIcon = new HealthIcon('gf', true);
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIcon.y = 55;
		weekHealthIcon.flipX = true;
		weekHealthIcon.cameras = [camScreen];

		weekHealthIconLose = new HealthIcon('gf', true);
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIconLose.y = 55;
		weekHealthIconLose.flipX = true;
		weekHealthIconLose.cameras = [camScreen];

		var ui_tex = Paths.getSparrowAtlas('menus/base/storymenu/campaign_menu_UI_assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);
		grpWeekText.cameras = [camScreen];

		var border:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/base/storymenu/border'));
		add(border);
		border.cameras = [camScreen];

		var back:FlxSprite = new FlxSprite(85, 65).loadGraphic(Paths.image('menus/base/storymenu/menuBack'));
		add(back);
		back.cameras = [camScreen];

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);
		grpLocks.cameras = [camScreen];

		for (i in 0...Main.gameWeeks.length)
		{
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);
			weekThing.cameras = [camScreen];

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = true;
				grpLocks.add(lock);
				lock.cameras = [camScreen];
			}
		}

		trace("Line 213");

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);
		difficultySelectors.cameras = [camScreen];

		trace("Line 219");

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.cameras = [camScreen];
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		for (i in CoolUtil.difficultyArray)
			sprDifficulty.animation.addByPrefix(i.toLowerCase(), i.toUpperCase());
		sprDifficulty.animation.play('easy');
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.cameras = [camScreen];
		difficultySelectors.add(rightArrow);

		trace("Line 246");

		for (i in 0...12)
		{

			var weekCircle:FlxSprite = new FlxSprite(0, 50).loadGraphic(Paths.image('menus/base/storymenu/circle'));

			if (i == 5)
			{
				weekCircle.alpha = 1;
				weekCircle.x = 0;
				weekCircle.y += 400;
			}
			if (i == 6)
			{
				weekCircle.x = -400;
				weekCircle.y += 400;
			}
			if (i == 7)
			{
				weekCircle.x = -800;
				weekCircle.y += 400;
			}
			if (i == 8)
			{
				weekCircle.x = 0;
				weekCircle.y -= 400;
			}
			if (i == 9)
			{
				weekCircle.x = 1200;
				weekCircle.y += 400;
			}
			if (i == 10)
			{
				weekCircle.x = 800;
				weekCircle.y += 400;
			}
			if (i == 11)
			{
				weekCircle.x = 800;
				weekCircle.y -= 400;
			}

			if (i < 5)
			{
				weekCircle.x = i * 400;

				if (i < 4)
				{
					var weekLine:FlxSprite = new FlxSprite(weekCircle.x + 95, 72).loadGraphic(Paths.image('menus/base/storymenu/line'));

					var weekLine2:FlxSprite = new FlxSprite(weekCircle.x + 195, 72).loadGraphic(Paths.image('menus/base/storymenu/line'));

					var weekLine3:FlxSprite = new FlxSprite(weekCircle.x + 295, 72).loadGraphic(Paths.image('menus/base/storymenu/line'));

					weekLines.add(weekLine);
					weekLines.add(weekLine2);
					weekLines.add(weekLine3);
				}
			}

			if (i == 4)
			{
				var weekLine:FlxSprite = new FlxSprite(-4, 165).loadGraphic(Paths.image('menus/base/storymenu/line'));

				var weekLine2:FlxSprite = new FlxSprite(-4, 265).loadGraphic(Paths.image('menus/base/storymenu/line'));

				var weekLine3:FlxSprite = new FlxSprite(-4, 365).loadGraphic(Paths.image('menus/base/storymenu/line'));

				weekLine.angle = 90;
				weekLine2.angle = 90;
				weekLine3.angle = 90;

				weekLines.add(weekLine);
				weekLines.add(weekLine2);
				weekLines.add(weekLine3);

				weekCircle.alpha = 1;
			}

			if (i > 4 && i < 7)
			{
				var weekLine:FlxSprite = new FlxSprite(weekCircle.x - 95, 472).loadGraphic(Paths.image('menus/base/storymenu/line'));

				var weekLine2:FlxSprite = new FlxSprite(weekCircle.x - 195, 472).loadGraphic(Paths.image('menus/base/storymenu/line'));

				var weekLine3:FlxSprite = new FlxSprite(weekCircle.x - 295, 472).loadGraphic(Paths.image('menus/base/storymenu/line'));

				weekLines.add(weekLine);
				weekLines.add(weekLine2);
				weekLines.add(weekLine3);
			}

			if (i == 8)
			{
				var weekLine:FlxSprite = new FlxSprite(-4, -27).loadGraphic(Paths.image('menus/base/storymenu/line'));

				var weekLine2:FlxSprite = new FlxSprite(-4, -127).loadGraphic(Paths.image('menus/base/storymenu/line'));

				var weekLine3:FlxSprite = new FlxSprite(-4, -227).loadGraphic(Paths.image('menus/base/storymenu/line'));

				weekLine.angle = 90;
				weekLine2.angle = 90;
				weekLine3.angle = 90;

				weekLines.add(weekLine);
				weekLines.add(weekLine2);
				weekLines.add(weekLine3);
			}

			if (i == 9)
			{
				var weekLine:FlxSprite = new FlxSprite(1197, 165).loadGraphic(Paths.image('menus/base/storymenu/line'));

				var weekLine2:FlxSprite = new FlxSprite(1197, 265).loadGraphic(Paths.image('menus/base/storymenu/line'));

				var weekLine3:FlxSprite = new FlxSprite(1197, 365).loadGraphic(Paths.image('menus/base/storymenu/line'));

				weekLine.angle = 90;
				weekLine2.angle = 90;
				weekLine3.angle = 90;

				weekLines.add(weekLine);
				weekLines.add(weekLine2);
				weekLines.add(weekLine3);
			}
			if (i == 10)
			{
				var weekLine:FlxSprite = new FlxSprite(797, 165).loadGraphic(Paths.image('menus/base/storymenu/line'));

				var weekLine2:FlxSprite = new FlxSprite(797, 265).loadGraphic(Paths.image('menus/base/storymenu/line'));

				var weekLine3:FlxSprite = new FlxSprite(797, 365).loadGraphic(Paths.image('menus/base/storymenu/line'));

				weekLine.angle = 90;
				weekLine2.angle = 90;
				weekLine3.angle = 90;

				weekLines.add(weekLine);
				weekLines.add(weekLine2);
				weekLines.add(weekLine3);
			}
			if (i == 11)
			{
				var weekLine:FlxSprite = new FlxSprite(797, -27).loadGraphic(Paths.image('menus/base/storymenu/line'));

				var weekLine2:FlxSprite = new FlxSprite(797, -127).loadGraphic(Paths.image('menus/base/storymenu/line'));

				var weekLine3:FlxSprite = new FlxSprite(797, -227).loadGraphic(Paths.image('menus/base/storymenu/line'));

				weekLine.angle = 90;
				weekLine2.angle = 90;
				weekLine3.angle = 90;

				weekLines.add(weekLine);
				weekLines.add(weekLine2);
				weekLines.add(weekLine3);
			}

			weekCircles.add(weekCircle);
			weekXvalues.push(weekCircle.x - 95);
			weekYvalues.push(weekCircle.y - 50);
			trace(weekYvalues[i]);
	
		}

		add(ship);

		FlxG.camera.follow(ship, LOCKON, 1);

		txtTracklist = new FlxText(FlxG.width * 0.75, 55, 0);
		txtTracklist.alignment = CENTER;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 32, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(txtTracklist);
		txtTracklist.cameras = [camScreen];
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);
		add(txtWeekNumber);

		add(weekHealthIcon);
		add(weekHealthIconLose);

		// very unprofessional yoshubs!

		updateText();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		var lerpVal = Main.framerateAdjust(0.5);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, lerpVal));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		ship.x = FlxMath.lerp(ship.x, weekXvalues[curWeek], CoolUtil.boundTo(elapsed * 9, 0, 1));
		ship.y = FlxMath.lerp(ship.y, weekYvalues[curWeek], CoolUtil.boundTo(elapsed * 9, 0, 1));
		starsBG.x = FlxMath.lerp(starsBG.x, starsBG.x - 0.5, CoolUtil.boundTo(elapsed * 9, 0, 1));
		starsFG.x = FlxMath.lerp(starsFG.x, starsFG.x - 1, CoolUtil.boundTo(elapsed * 9, 0, 1));

		txtWeekTitle.text = Main.gameWeeks[curWeek][3].toUpperCase();
		txtWeekTitle.x = ((FlxG.width / 2) - (txtWeekTitle.width / 2));

		if (curWeek == 0)
		{
		weekHealthIcon.changeBfIcon('gf');
		weekHealthIconLose.changeBfIcon('gf');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.visible = false;
		txtTracklist.y = 55;
		shipPlayAnim('right');
		}
		if (curWeek == 1)
		{
		weekHealthIcon.changeBfIcon('dad');
		weekHealthIconLose.changeBfIcon('dad');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.visible = true;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.6;
		txtTracklist.y = 62;
		shipPlayAnim('right');
		}
		if (curWeek == 2)
		{
		weekHealthIcon.changeBfIcon('spooky');
		weekHealthIconLose.changeBfIcon('spooky');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.6;
		txtTracklist.y = 62;
		shipPlayAnim('right');
		}
		if (curWeek == 3)
		{
		weekHealthIcon.changeBfIcon('pico');
		weekHealthIconLose.changeBfIcon('pico');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.6;
		txtTracklist.y = 62;
		shipPlayAnim('right');
		}
		if (curWeek == 4)
		{
		weekHealthIcon.changeBfIcon('mom');
		weekHealthIconLose.changeBfIcon('mom');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.6;
		txtTracklist.y = 62;
		shipPlayAnim('right');
		}
		if (curWeek == 5)
		{
		weekHealthIcon.changeBfIcon('parents');
		weekHealthIconLose.changeBfIcon('parents');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.6;
		txtTracklist.y = 62;
		shipPlayAnim('down');
		}
		if (curWeek == 6)
		{
		weekHealthIcon.changeBfIcon('senpai');
		weekHealthIconLose.changeBfIcon('senpai');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.6;
		txtTracklist.y = 62;
		shipPlayAnim('left');
		}
		if (curWeek == 7)
		{
		weekHealthIcon.changeBfIcon('impostor');
		weekHealthIconLose.changeBfIcon('impostor');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.6;
		txtTracklist.y = 62;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('left');
		}
		if (curWeek == 8)
		{
		weekHealthIcon.changeBfIcon('crewmate');
		weekHealthIconLose.changeBfIcon('crewmate');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 34, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.5;
		txtTracklist.y = 55;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('up');
		}
		if (curWeek == 9)
		{
		weekHealthIcon.changeBfIcon('yellow');
		weekHealthIconLose.changeBfIcon('yellow');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.visible = true;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 26, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.3;
		txtTracklist.y = 58;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('down');
		}
		if (curWeek == 10)
		{
		weekHealthIcon.changeBfIcon('black');
		weekHealthIconLose.changeBfIcon('black');
		txtWeekTitle.color = 0xFFFFFFFF;
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 180;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.visible = false;
		txtTracklist.y = 55;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('down');
		}
		if (curWeek == 11)
		{
		weekHealthIcon.changeBfIcon('black');
		weekHealthIconLose.changeBfIcon('black');
		txtWeekTitle.color = 0xFFFF0000;
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 180;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.visible = false;
		txtTracklist.y = 55;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		camSpace.shake(0.5/FlxMath.distanceToPoint(ship, FlxPoint.get(1505, 0))/2, 0.05);
		camScreen.shake(0.3/FlxMath.distanceToPoint(ship, FlxPoint.get(1505, 0))/2, 0.05);
		shipPlayAnim('up');
		}
		if (curWeek == 12)
		{
		weekHealthIcon.changeBfIcon('monotone');
		weekHealthIconLose.changeBfIcon('monotone');
		txtWeekTitle.color = 0xFFFFFFFF;
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.visible = false;
		txtTracklist.y = 55;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('right');
		}
		if (curWeek == 13)
		{
		weekHealthIcon.changeBfIcon('maroon');
		weekHealthIconLose.changeBfIcon('maroon');
		weekHealthIcon.x = FlxG.width / 2.4 - 135;
		weekHealthIconLose.x = FlxG.width / 2.4 + 220;
		weekHealthIcon.y = 45;
		weekHealthIconLose.y = 45;
		txtTracklist.visible = true;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.6;
		txtTracklist.y = 62;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('right');
		}
		if (curWeek == 14)
		{
		weekHealthIcon.changeBfIcon('gray');
		weekHealthIconLose.changeBfIcon('gray');
		weekHealthIcon.x = FlxG.width / 2.4 - 135;
		weekHealthIconLose.x = FlxG.width / 2.4 + 220;
		weekHealthIcon.y = 45;
		weekHealthIconLose.y = 45;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.6;
		txtTracklist.y = 62;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('right');
		}
		if (curWeek == 15)
		{
		weekHealthIcon.changeBfIcon('pink');
		weekHealthIconLose.changeBfIcon('pink');
		weekHealthIcon.x = FlxG.width / 2.4 - 135;
		weekHealthIconLose.x = FlxG.width / 2.4 + 220;
		weekHealthIcon.y = 40;
		weekHealthIconLose.y = 40;
		txtTracklist.visible = true;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.6;
		txtTracklist.y = 62;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('right');
		}
		if (curWeek == 16)
		{
		weekHealthIcon.changeBfIcon('chef');
		weekHealthIconLose.changeBfIcon('chef');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.visible = false;
		txtTracklist.y = 55;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('right');
		}
		if (curWeek == 17)
		{
		weekHealthIcon.changeBfIcon('jorsawsee');
		weekHealthIconLose.changeBfIcon('jorsawsee');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.visible = true;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 34, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.5;
		txtTracklist.y = 55;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('right');
		}
		if (curWeek == 18)
		{
		weekHealthIcon.changeBfIcon('powers');
		weekHealthIconLose.changeBfIcon('powers');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.visible = false;
		txtTracklist.y = 55;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('right');
		}
		if (curWeek == 19)
		{
		weekHealthIcon.changeBfIcon('henry');
		weekHealthIconLose.changeBfIcon('henry');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 180;
		weekHealthIcon.y = 40;
		weekHealthIconLose.y = 40;
		txtTracklist.visible = true;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 34, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.5;
		txtTracklist.y = 55;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('right');
		}
		if (curWeek == 20)
		{
		weekHealthIcon.changeBfIcon('tomongus');
		weekHealthIconLose.changeBfIcon('tomongus');
		weekHealthIcon.x = FlxG.width / 2.4 - 205;
		weekHealthIconLose.x = FlxG.width / 2.4 + 270;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.visible = true;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.6;
		txtTracklist.y = 62;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('right');
		}
		if (curWeek == 21)
		{
		weekHealthIcon.changeBfIcon('tuesday');
		weekHealthIconLose.changeBfIcon('tuesday');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.visible = false;
		txtTracklist.y = 55;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('right');
		}
		if (curWeek == 22)
		{
		weekHealthIcon.changeBfIcon('fella');
		weekHealthIconLose.changeBfIcon('fella');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 170;
		weekHealthIcon.y = 45;
		weekHealthIconLose.y = 45;
		txtTracklist.visible = true;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 50, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.8;
		txtTracklist.y = 75;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('right');
		}
		if (curWeek == 23)
		{
		weekHealthIcon.changeBfIcon('oldpostor');
		weekHealthIconLose.changeBfIcon('oldpostor');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.visible = true;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 50, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.8;
		txtTracklist.y = 75;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('right');
		}
		if (curWeek == 24)
		{
		weekHealthIcon.changeBfIcon('redkill');
		weekHealthIconLose.changeBfIcon('redkill');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.visible = false;
		txtTracklist.y = 55;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('right');
		}
		if (curWeek == 25)
		{
		weekHealthIcon.changeBfIcon('cval');
		weekHealthIconLose.changeBfIcon('cval');
		weekHealthIcon.x = FlxG.width / 2.4 - 115;
		weekHealthIconLose.x = FlxG.width / 2.4 + 200;
		weekHealthIcon.y = 55;
		weekHealthIconLose.y = 55;
		txtTracklist.visible = true;
		txtTracklist.setFormat(Paths.font('AmaticSC-Bold.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		txtTracklist.borderSize = 1.6;
		txtTracklist.y = 62;
		curDifficulty = 2;
		sprDifficulty.animation.play('hard');
		sprDifficulty.offset.x = 20;
		shipPlayAnim('right');
		}

		weekHealthIcon.animation.curAnim.curFrame = 0;
		weekHealthIconLose.animation.curAnim.curFrame = 1;

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UI_UP_P)
					changeWeek(-1);
				else if (controls.UI_DOWN_P)
					changeWeek(1);

			if(FlxG.mouse.wheel != 0)
			{
				changeWeek(-FlxG.mouse.wheel);
			}

				if (controls.UI_RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.UI_LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.UI_RIGHT_P)
					changeDifficulty(1);
				if (controls.UI_LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
				selectWeek();
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			Main.switchState(this, new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				stopspamming = true;
			}

			PlayState.storyPlaylist = Main.gameWeeks[curWeek][0].copy();
			PlayState.isStoryMode = true;
			selectedWeek = true;

			var diffic:String = '-' + CoolUtil.difficultyFromNumber(curDifficulty).toLowerCase();
			diffic = diffic.replace('-normal', '');

			PlayState.storyDifficulty = curDifficulty;
			PlayState.freeplayDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;

			if (curWeek == 10)
			{
			FlxG.sound.music.fadeOut(1.2, 0);
			camScreen.fade(FlxColor.BLACK, 1.2, false, function()
			{
			camScreen.visible = false;
			camSpace.visible = false;
			openSubState(new AmongDeathSubstate());
			});
			}
			else
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				Main.switchState(this, new PlayState());
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = CoolUtil.difficultyLength - 1;
		if (curDifficulty > CoolUtil.difficultyLength - 1)
			curDifficulty = 0;

		sprDifficulty.offset.x = 0;

		var difficultyString = CoolUtil.difficultyFromNumber(curDifficulty).toLowerCase();
		sprDifficulty.animation.play(difficultyString);
		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.offset.x = 20;
		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= Main.gameWeeks.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = Main.gameWeeks.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText()
	{
		//txtTracklist.text = "Tracks\n";
		txtTracklist.text = "";

		var stringThing:Array<String> = Main.gameWeeks[curWeek][0];
		for (i in stringThing)
			txtTracklist.text += CoolUtil.dashToSpace(i) + "\n";

		//txtTracklist.text += "\n"; // pain
		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x = ((FlxG.width / 2) - (txtTracklist.width / 2)) + 400;

		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
	}

	function shipPlayAnim(animName:String, force:Bool = false, reversed:Bool = false, frame:Int = 0):Void
	{
		ship.animation.play(animName, force, reversed, frame);

		var daOffset = shipAnimOffsets.get(animName);
		if (shipAnimOffsets.exists(animName))
		{
			ship.offset.set(daOffset[0], daOffset[1]);
		}
		else
			ship.offset.set(0, 0);
	}

	function shipAddOffset(name:String, x:Float = 0, y:Float = 0)
	{
		shipAnimOffsets[name] = [x, y];
	}
}