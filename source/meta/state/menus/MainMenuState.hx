package meta.state.menus;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.FNFSprite;
import meta.data.dependency.Discord;
import flixel.addons.display.FlxBackdrop;

using StringTools;

/**
	This is the main menu state! Not a lot is going to change about it so it'll remain similar to the original, but I do want to condense some code and such.
	Get as expressive as you can with this, create your own menu!
**/
class MainMenuState extends MusicBeatState
{
	var menuItems:FlxTypedGroup<FlxSprite>;
	var curSelected:Float = 0;

	var camFollow:FlxObject;
	var starFG:FlxBackdrop;
	var starBG:FlxBackdrop;
	var redImpostor:FlxSprite;
	var greenImpostor:FlxSprite;
	var vignette:FlxSprite;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'options'];
	var canSnap:Array<Float> = [];

	// the create 'state'
	override function create()
	{
		super.create();

		// set the transitions to the previously set ones
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		// make sure the music is playing
		ForeverTools.resetMenuMusic();

		#if !html5
		Discord.changePresence('MENU SCREEN', 'Main Menu');
		#end

		// uh
		persistentUpdate = persistentDraw = true;

		// background

		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		if(FlxG.save.data.antialiasing)
			{
				bg.antialiasing = true;
			}
		add(bg);

		starFG = new FlxBackdrop(Paths.image('menus/base/title/starFG'));
		starFG.updateHitbox();
		starFG.antialiasing = true;
		starFG.scrollFactor.set();
		add(starFG);
		starFG.scrollFactor.x = 0;
		starFG.scrollFactor.y = 0.18;

		starBG = new FlxBackdrop(Paths.image('menus/base/title/starBG'));
		starBG.updateHitbox();
		starBG.antialiasing = true;
		starBG.scrollFactor.set();
		add(starBG);
		starBG.scrollFactor.x = 0;
		starBG.scrollFactor.y = 0.18;

		redImpostor = new FlxSprite(350, -160);
		redImpostor.frames = Paths.getSparrowAtlas('menus/base/title/redmenu');
		redImpostor.animation.addByPrefix('idle', 'red idle', 24, true);
		redImpostor.animation.addByPrefix('select', 'red select', 24, false);
		redImpostor.animation.play('idle');
		redImpostor.antialiasing = true;
		redImpostor.updateHitbox();
		redImpostor.active = true;
		redImpostor.scale.set(0.7, 0.7);
		redImpostor.scrollFactor.set();
		add(redImpostor);
		redImpostor.scrollFactor.x = 0;
		redImpostor.scrollFactor.y = 0.18;

		greenImpostor = new FlxSprite(-300, -60);
		greenImpostor.frames = Paths.getSparrowAtlas('menus/base/title/greenmenu');
		greenImpostor.animation.addByPrefix('idle', 'green idle', 24, true);
		greenImpostor.animation.addByPrefix('select', 'green select', 24, false);
		greenImpostor.animation.play('idle');
		greenImpostor.antialiasing = true;
		greenImpostor.updateHitbox();
		greenImpostor.active = true;
		greenImpostor.scale.set(0.7, 0.7);
		greenImpostor.scrollFactor.set();
		add(greenImpostor);
		greenImpostor.scrollFactor.x = 0;
		greenImpostor.scrollFactor.y = 0.18;

		vignette = new FlxSprite(0, 0).loadGraphic(Paths.image('menus/base/title/vignette'));
		vignette.antialiasing = true;
		vignette.updateHitbox();
		vignette.active = false;
		vignette.scrollFactor.set();
		add(vignette);

		// add the camera
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		// add the menu items
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		// create the menu items themselves
		var tex = Paths.getSparrowAtlas('menus/base/title/FNF_main_menu_assets');

		// loop through the menu options
		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 80 + (i * 200));
			menuItem.frames = tex;
			// add the animations in a cool way (real
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			canSnap[i] = -1;
			// set the id
			menuItem.ID = i;
			// menuItem.alpha = 0;

			// placements
			menuItem.screenCenter(X);
			// if the id is divisible by 2
			if (menuItem.ID % 2 == 0)
				menuItem.x += 1000;
			else
				menuItem.x -= 1000;

			// actually add the item
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			menuItem.updateHitbox();

			/*
				FlxTween.tween(menuItem, {alpha: 1, x: ((FlxG.width / 2) - (menuItem.width / 2))}, 0.35, {
					ease: FlxEase.smootherStepInOut,
					onComplete: function(tween:FlxTween)
					{
						canSnap[i] = 0;
					}
			});*/
		}

		// set the camera to actually follow the camera object that was created before
		var camLerp = Main.framerateAdjust(0.10);
		FlxG.camera.follow(camFollow, null, camLerp);

		updateSelection();

		// from the base game lol

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "Forever Engine v" + Main.gameVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 36, 0, "VS Impostor v4.1.0", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		//
	}

	// var colorTest:Float = 0;
	var selectedSomethin:Bool = false;
	var counterControl:Float = 0;

	override function update(elapsed:Float)
	{
		// colorTest += 0.125;
		// bg.color = FlxColor.fromHSB(colorTest, 100, 100, 0.5);
		starFG.x -= 0.03;
		starBG.x -= 0.01;

		var up = controls.UI_UP;
		var down = controls.UI_DOWN;
		var up_p = controls.UI_UP_P;
		var down_p = controls.UI_DOWN_P;
		var controlArray:Array<Bool> = [up, down, up_p, down_p];

		if ((controlArray.contains(true)) && (!selectedSomethin))
		{
			for (i in 0...controlArray.length)
			{
				// here we check which keys are pressed
				if (controlArray[i] == true)
				{
					// if single press
					if (i > 1)
					{
						// up is 2 and down is 3
						// paaaaaiiiiiiinnnnn
						if (i == 2)
							curSelected--;
						else if (i == 3)
							curSelected++;

						FlxG.sound.play(Paths.sound('scrollMenu'));
					}
					/* idk something about it isn't working yet I'll rewrite it later
						else
						{
							// paaaaaaaiiiiiiiinnnn
							var curDir:Int = 0;
							if (i == 0)
								curDir = -1;
							else if (i == 1)
								curDir = 1;

							if (counterControl < 2)
								counterControl += 0.05;

							if (counterControl >= 1)
							{
								curSelected += (curDir * (counterControl / 24));
								if (curSelected % 1 == 0)
									FlxG.sound.play(Paths.sound('scrollMenu'));
							}
					}*/

					if (curSelected < 0)
						curSelected = optionShit.length - 1;
					else if (curSelected >= optionShit.length)
						curSelected = 0;
				}
				//
			}
		}
		else
		{
			// reset variables
			counterControl = 0;
		}

		if ((controls.ACCEPT) && (!selectedSomethin))
		{
			//
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			greenImpostor.animation.play('select');
			redImpostor.animation.play('select');

			FlxTween.tween(starFG, {y: starFG.y + 500}, 0.7, {ease: FlxEase.quadInOut});
			FlxTween.tween(starBG, {y: starBG.y + 500}, 0.7, {ease: FlxEase.quadInOut, startDelay: 0.2});
			FlxTween.tween(greenImpostor, {y: greenImpostor.y + 800}, 0.7, {ease: FlxEase.quadInOut, startDelay: 0.24});
			FlxTween.tween(redImpostor, {y: redImpostor.y + 800}, 0.7, {ease: FlxEase.quadInOut, startDelay: 0.3});
			FlxG.camera.fade(FlxColor.BLACK, 0.7, false);

			menuItems.forEach(function(spr:FlxSprite)
			{
				if (curSelected != spr.ID)
				{
					FlxTween.tween(spr, {alpha: 0, x: FlxG.width * 2}, 0.4, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							spr.kill();
						}
					});
				}
				else
				{
					FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						var daChoice:String = optionShit[Math.floor(curSelected)];

						switch (daChoice)
						{
							case 'story mode':
								Main.switchState(this, new StoryMenuState());
							case 'freeplay':
								Main.switchState(this, new FreeplayState());
							case 'options':
								transIn = FlxTransitionableState.defaultTransIn;
								transOut = FlxTransitionableState.defaultTransOut;
								Main.switchState(this, new OptionsMenuState());
						}
					});
				}
			});
		}

		if (Math.floor(curSelected) != lastCurSelected)
			updateSelection();

		super.update(elapsed);

		menuItems.forEach(function(menuItem:FlxSprite)
		{
			menuItem.screenCenter(X);
		});
	}

	var lastCurSelected:Int = 0;

	private function updateSelection()
	{
		// reset all selections
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();
		});

		// set the sprites and all of the current selection
		camFollow.setPosition(menuItems.members[Math.floor(curSelected)].getGraphicMidpoint().x,
			menuItems.members[Math.floor(curSelected)].getGraphicMidpoint().y);

		if (menuItems.members[Math.floor(curSelected)].animation.curAnim.name == 'idle')
			menuItems.members[Math.floor(curSelected)].animation.play('selected');

		menuItems.members[Math.floor(curSelected)].updateHitbox();

		lastCurSelected = Math.floor(curSelected);
	}
}