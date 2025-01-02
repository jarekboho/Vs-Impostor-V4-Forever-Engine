import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import meta.MusicBeat.MusicBeatSubState;
import meta.state.PlayState;
import meta.CoolUtil;
import meta.data.*;
import meta.data.Song.SwagSong;

class AmongDeathSubstate extends MusicBeatSubState
{

	var missAmountArrow:FlxSprite;
	var missTxt:FlxText;
	public var dummySprites:FlxTypedGroup<FlxSprite>;
	public var maximumMissLimit:Int = 5;

	public var camUpper:FlxCamera;
	public var camOther:FlxCamera;

	public function new()
	{
		super();

		camUpper = new FlxCamera();
		camOther = new FlxCamera();
		camUpper.bgColor.alpha = 0;
		camOther.bgColor.alpha = 0;
		FlxG.cameras.add(camUpper);
		FlxG.cameras.add(camOther);

		cameras = [camUpper];

		dummySprites = new FlxTypedGroup<FlxSprite>();
		for (i in 0...6)
		{
			var dummypostor:FlxSprite = new FlxSprite((i * 150) + 200, 450).loadGraphic(Paths.image('menus/base/dummypostor${i + 1}'));
			dummypostor.alpha = 0;
			dummypostor.ID = i;
			dummySprites.add(dummypostor);
			switch(i){
				case 2 | 3:
					dummypostor.y += 40;
				case 4 | 5:
					dummypostor.y += 65;
			}
		}
		add(dummySprites);

		missAmountArrow = new FlxSprite(0, 400).loadGraphic(Paths.image('menus/base/missAmountArrow'));
		missAmountArrow.alpha = 0;
		add(missAmountArrow);

		missTxt = new FlxText(0, 150, FlxG.width, "", 20);
		missTxt.setFormat(Paths.font("vcr.ttf"), 100, FlxColor.RED, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		missTxt.antialiasing = false;
        missTxt.scrollFactor.set();
		missTxt.alpha = 0;
		missTxt.borderSize = 3;
        add(missTxt);

		changeMissAmount(0);
		openMissLimit();
	}

	public var canControl:Bool = false;
	public var hasEnteredMissSelection:Bool = false;
	public var isClosing:Bool = false;

	override public function update(elapsed:Float)
	{	
		var rightP = controls.UI_RIGHT_P;
		var leftP = controls.UI_LEFT_P;
		var accepted = controls.ACCEPT;

		if(accepted && hasEnteredMissSelection == true)
		{
			FlxG.sound.play(Paths.sound('amongkill'), 0.9);
			hasEnteredMissSelection = false;

			var blackScreen:FlxSprite = new FlxSprite().makeGraphic(1920, 1080, FlxColor.BLACK);
			add(blackScreen);

			missTxt.alpha = 0;
		 	missAmountArrow.alpha = 0;

		 	dummySprites.forEach(function(spr:FlxSprite)
			{
				spr.alpha = 0;	
			});
			var _difficulty:Int = 2; // TODO: make this the actual diff
			var _week:Int = 10;

			// Nevermind that's stupid lmao
			PlayState.storyPlaylist = Main.gameWeeks[_week][0].copy();
			PlayState.isStoryMode = true;

			var diffic:String = '-' + CoolUtil.difficultyFromNumber(_difficulty).toLowerCase();
			//diffic = diffic.replace('-normal', '');

			PlayState.storyDifficulty = _difficulty;
			PlayState.freeplayDifficulty = _difficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = _week;
			PlayState.campaignScore = 0;
			
			FlxTween.tween(camUpper, {alpha: 0}, 0.25, {
				ease: FlxEase.circOut,
				onComplete: function(tween:FlxTween)
				{
					trace('CURRENT WEEK: ' + Main.gameWeeks[_week][3].toUpperCase());
					Main.switchState(this, new PlayState());
				}
			});
		}
		if (rightP)
		{
			if (hasEnteredMissSelection)
				changeMissAmount(-1);
			
			FlxG.sound.play(Paths.sound('panelAppear'), 0.5);
		}

		if (leftP)
		{
			if (hasEnteredMissSelection)
				changeMissAmount(1);
	
			FlxG.sound.play(Paths.sound('panelDisappear'), 0.5);
		}
	}

	function changeMissAmount(change:Int)
	{
		PlayState.missLimitCount += change;
		if (PlayState.missLimitCount > maximumMissLimit)
			PlayState.missLimitCount = 0;
		if (PlayState.missLimitCount < 0)
			PlayState.missLimitCount = maximumMissLimit;

		dummySprites.forEach(function(spr:FlxSprite)
		{
			if((5 - spr.ID) == PlayState.missLimitCount){
				missAmountArrow.x = spr.x;
				missTxt.text = '${PlayState.missLimitCount}/5 COMBO BREAKS';
				missTxt.x = ((FlxG.width / 2) - (missTxt.width / 2));
			}
		});
	}

	function openMissLimit()
	{
		missAmountArrow.alpha = 1;
		missTxt.alpha = 1;
		dummySprites.forEach(function(spr:FlxSprite)
		{
			spr.alpha = 1;
		});
		hasEnteredMissSelection = true;
	}
}
