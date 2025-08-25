package meta.state.menus;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.ColorTween;
import flixel.util.FlxColor;
import gameObjects.userInterface.HealthIcon;
import lime.utils.Assets;
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.FNFSprite;
import meta.data.*;
import meta.data.Song.SwagSong;
import meta.data.dependency.Discord;
import meta.data.font.Alphabet;
import openfl.media.Sound;
import sys.FileSystem;
import sys.thread.Mutex;
import sys.thread.Thread;
import meta.state.charting.*;
import flixel.addons.display.FlxBackdrop;

using StringTools;

class FreeplayState extends MusicBeatState
{
	//
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curSongPlaying:Int = -1;
	var curDifficulty:Int = 1;

	var space:FlxSprite;
	var starsBG:FlxBackdrop;
	var starsFG:FlxBackdrop;
	var upperBar:FlxSprite;
	var upperBarOverlay:FlxSprite;
	var portrait:FlxSprite;
	var porGlow:FlxSprite;

	private var portraitTween:FlxTween;
	private var portraitAlphaTween:FlxTween;

	var crossImage:FlxSprite;

	var upScroll:Bool;
	var downScroll:Bool;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	var songThread:Thread;
	var threadActive:Bool = true;
	var mutex:Mutex;
	var songToPlay:Sound = null;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	private var mainColor = FlxColor.WHITE;
	private var scoreBG:FlxSprite;

	private var existingSongs:Array<String> = [];
	private var existingDifficulties:Array<Array<String>> = [];

	override function create()
	{
		super.create();

		mutex = new Mutex();

		/**
			Wanna add songs? They're in the Main state now, you can just find the week array and add a song there to a specific week.
			Alternatively, you can make a folder in the Songs folder and put your songs there, however, this gives you less
			control over what you can display about the song (color, icon, etc) since it will be pregenerated for you instead.
		**/
		// load in all songs that exist in folder
		var folderSongs:Array<String> = CoolUtil.returnAssetsLibrary('songs', 'assets');

		///*
		for (i in 0...Main.gameWeeks.length)
		{
			addWeek(Main.gameWeeks[i][0], i, Main.gameWeeks[i][1], Main.gameWeeks[i][2]);
			for (j in cast(Main.gameWeeks[i][0], Array<Dynamic>))
				existingSongs.push(j.toLowerCase());
		}

		// */

		for (i in folderSongs)
		{
			if (!existingSongs.contains(i.toLowerCase()))
			{
				var icon:String = 'gf';
				//var chartExists:Bool = FileSystem.exists(Paths.songJson(i, i));
				var chartExists:Bool = FileSystem.exists(Paths.songJson(i, i  + '-hard'));
				if (chartExists)
				{
					var castSong:SwagSong = Song.loadFromJson(i + '-hard', i);
					icon = (castSong != null) ? castSong.player2 : 'gf';
					addSong(CoolUtil.spaceToDash(castSong.song), 1, icon, FlxColor.WHITE);
				}
			}
		}

		// LOAD MUSIC
		// ForeverTools.resetMenuMusic();

		#if !html5
		Discord.changePresence('FREEPLAY MENU', 'Main Menu');
		#end

		// LOAD CHARACTERS

		space = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		space.antialiasing = true;
		space.updateHitbox();
		space.scrollFactor.set();
		add(space);

		starsBG = new FlxBackdrop(Paths.image('menus/base/starBG'));
		starsBG.setPosition(111.3, 67.95);
		starsBG.antialiasing = true;
		starsBG.updateHitbox();
		starsBG.scrollFactor.set();
		add(starsBG);

		starsFG = new FlxBackdrop(Paths.image('menus/base/starFG'));
		starsFG.setPosition(54.3, 59.45);
		starsFG.updateHitbox();
		starsFG.antialiasing = true;
		starsFG.scrollFactor.set();
		add(starsFG);

		porGlow = new FlxSprite(-11.1, -12.65).loadGraphic(Paths.image('menus/base/backGlow'));
		porGlow.antialiasing = true;
		porGlow.updateHitbox();
		porGlow.scrollFactor.set();
		porGlow.color = FlxColor.RED;
		add(porGlow);

		portrait = new FlxSprite();
		portrait.frames = Paths.getSparrowAtlas('menus/base/portraits');

		portrait.animation.addByIndices('red', 'Character', [1], null, 24, true);
		portrait.animation.addByIndices('Sussus-Moogus', 'Character', [1], null, 24, true);
		portrait.animation.addByIndices('Sabotage', 'Character', [1], null, 24, true);
		portrait.animation.addByIndices('Meltdown', 'Character', [1], null, 24, true);
		portrait.animation.addByIndices('yellow', 'Character', [2], null, 24, true);
		portrait.animation.addByIndices('Mando', 'Character', [2], null, 24, true);
		portrait.animation.addByIndices('Dlow', 'Character', [2], null, 24, true);
		portrait.animation.addByIndices('green', 'Character', [3], null, 24, true);
		portrait.animation.addByIndices('Sussus-Toogus', 'Character', [3], null, 24, true);
		portrait.animation.addByIndices('Lights-Down', 'Character', [3], null, 24, true);
		portrait.animation.addByIndices('Reactor', 'Character', [3], null, 24, true);
		portrait.animation.addByIndices('tomo', 'Character', [4], null, 24, true);
		portrait.animation.addByIndices('Sussy-Bussy', 'Character', [4], null, 24, true);
		portrait.animation.addByIndices('Rivals', 'Character', [4], null, 24, true);
		portrait.animation.addByIndices('Tomongus-Tuesday', 'Character', [4], null, 24, true);
		portrait.animation.addByIndices('ham', 'Character', [5], null, 24, true);
		portrait.animation.addByIndices('Chewmate', 'Character', [5], null, 24, true);
		portrait.animation.addByIndices('black', 'Character', [6], null, 24, true);
		portrait.animation.addByIndices('Danger', 'Character', [6], null, 24, true);
		portrait.animation.addByIndices('Double-Kill', 'Character', [6], null, 24, true);
		portrait.animation.addByIndices('Defeat', 'Character', [6], null, 24, true);
		portrait.animation.addByIndices('white', 'Character', [7], null, 24, true);
		portrait.animation.addByIndices('Oversight', 'Character', [7], null, 24, true);
		portrait.animation.addByIndices('para', 'Character', [8], null, 24, true);
		portrait.animation.addByIndices('Ejected', 'Character', [8], null, 24, true);
		portrait.animation.addByIndices('pink', 'Character', [9], null, 24, true);
		portrait.animation.addByIndices('Heartbeat', 'Character', [9], null, 24, true);
		portrait.animation.addByIndices('Pinkwave', 'Character', [9], null, 24, true);
		portrait.animation.addByIndices('Pretender', 'Character', [9], null, 24, true);
		portrait.animation.addByIndices('maroon', 'Character', [10], null, 24, true);
		portrait.animation.addByIndices('Ashes', 'Character', [10], null, 24, true);
		portrait.animation.addByIndices('Magmatic', 'Character', [10], null, 24, true);
		portrait.animation.addByIndices('grey', 'Character', [11], null, 24, true);
		portrait.animation.addByIndices('Delusion', 'Character', [11], null, 24, true);
		portrait.animation.addByIndices('Blackout', 'Character', [11], null, 24, true);
		portrait.animation.addByIndices('Neurotic', 'Character', [11], null, 24, true);
		portrait.animation.addByIndices('chef', 'Character', [12], null, 24, true);
		portrait.animation.addByIndices('Sauces-Moogus', 'Character', [12], null, 24, true);
		portrait.animation.addByIndices('tit', 'Character', [13], null, 24, true);
		portrait.animation.addByIndices('Titular', 'Character', [13], null, 24, true);
		portrait.animation.addByIndices('ellie', 'Character', [14], null, 24, true);
		portrait.animation.addByIndices('Reinforcements', 'Character', [14], null, 24, true);
		portrait.animation.addByIndices('rhm', 'Character', [15], null, 24, true);
		portrait.animation.addByIndices('Armed', 'Character', [15], null, 24, true);
		portrait.animation.addByIndices('loggo', 'Character', [16], null, 24, true);
		portrait.animation.addByIndices('Christmas', 'Character', [16], null, 24, true);
		portrait.animation.addByIndices('Spookpostor', 'Character', [16], null, 24, true);
		portrait.animation.addByIndices('clow', 'Character', [17], null, 24, true);
		portrait.animation.addByIndices('ziffy', 'Character', [18], null, 24, true);
		portrait.animation.addByIndices('chips', 'Character', [19], null, 24, true);
		portrait.animation.addByIndices('Chippin', 'Character', [19], null, 24, true);
		portrait.animation.addByIndices('Chipping', 'Character', [19], null, 24, true);
		portrait.animation.addByIndices('oldpostor', 'Character', [20], null, 24, true);
		portrait.animation.addByIndices('Alpha-Moogus', 'Character', [20], null, 24, true);
		portrait.animation.addByIndices('Actin-Sus', 'Character', [20], null, 24, true);
		portrait.animation.addByIndices('top', 'Character', [21], null, 24, true);
		portrait.animation.addByIndices('Top-10', 'Character', [21], null, 24, true);
		portrait.animation.addByIndices('jorsawsee', 'Character', [22], null, 24, true);
		portrait.animation.addByIndices('O2', 'Character', [22], null, 24, true);
		portrait.animation.addByIndices('warchief', 'Character', [23], null, 24, true);
		portrait.animation.addByIndices('Voting-Time', 'Character', [23], null, 24, true);
		portrait.animation.addByIndices('Victory', 'Character', [23], null, 24, true);
		portrait.animation.addByIndices('redmungus', 'Character', [24], null, 24, true);
		portrait.animation.addByIndices('bananungus', 'Character', [25], null, 24, true);
		portrait.animation.addByIndices('powers', 'Character', [26], null, 24, true);
		portrait.animation.addByIndices('ROOMCODE', 'Character', [26], null, 24, true);
		portrait.animation.addByIndices('kills', 'Character', [27], null, 24, true);
		portrait.animation.addByIndices('Ow', 'Character', [27], null, 24, true);
		portrait.animation.addByIndices('jerma', 'Character', [28], null, 24, true);
		portrait.animation.addByIndices('Insane-Streamer', 'Character', [28], null, 24, true);
		portrait.animation.addByIndices('who', 'Character', [29], null, 24, true);
		portrait.animation.addByIndices('Who', 'Character', [29], null, 24, true);
		portrait.animation.addByIndices('monotone', 'Character', [30], null, 24, true);
		portrait.animation.addByIndices('Identity-Crisis', 'Character', [30], null, 24, true);
		portrait.animation.addByIndices('charles', 'Character', [31], null, 24, true);
		portrait.animation.addByIndices('Greatest-Plan', 'Character', [31], null, 24, true);
		portrait.animation.addByIndices('finale', 'Character', [32], null, 24, true);
		portrait.animation.addByIndices('Finale', 'Character', [32], null, 24, true);
		portrait.animation.addByIndices('pop', 'Character', [33], null, 24, true);
		portrait.animation.addByIndices('Drippypop', 'Character', [33], null, 24, true);
		portrait.animation.addByIndices('torture', 'Character', [34], null, 24, true);
		portrait.animation.addByIndices('Torture', 'Character', [34], null, 24, true);
		portrait.animation.addByIndices('dave', 'Character', [35], null, 24, true);
		portrait.animation.addByIndices('Crewicide', 'Character', [35], null, 24, true);
		portrait.animation.addByIndices('bpmar', 'Character', [36], null, 24, true);
		portrait.animation.addByIndices('Boiling-Point', 'Character', [36], null, 24, true);
		portrait.animation.addByIndices('grinch', 'Character', [37], null, 24, true);
		portrait.animation.addByIndices('redmunp', 'Character', [38], null, 24, true);
		portrait.animation.addByIndices('Turbulence', 'Character', [38], null, 24, true);
		portrait.animation.addByIndices('nuzzus', 'Character', [39], null, 24, true);
		portrait.animation.addByIndices('Sussus-Nuzzus', 'Character', [39], null, 24, true);
		portrait.animation.addByIndices('monotoner', 'Character', [40], null, 24, true);
		portrait.animation.addByIndices('Monotone-Attack', 'Character', [40], null, 24, true);
		portrait.animation.addByIndices('idk', 'Character', [41], null, 24, true);
		portrait.animation.addByIndices('Idk', 'Character', [41], null, 24, true);
		portrait.animation.addByIndices('esculent', 'Character', [42], null, 24, true);
		portrait.animation.addByIndices('Esculent', 'Character', [42], null, 24, true);
		portrait.animation.play('red');
		portrait.antialiasing = true;
		portrait.setPosition(304.65, -100);
		portrait.updateHitbox();
		portrait.scrollFactor.set();
		add(portrait);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);
		}

		upperBar = new FlxSprite(-2, -1.4).loadGraphic(Paths.image('menus/base/topBar'));
		upperBar.antialiasing = true;
		upperBar.updateHitbox();
		upperBar.scrollFactor.set();
		add(upperBar);

		crossImage = new FlxSprite(12.50, 8.05).loadGraphic(Paths.image('menus/base/menuBack'));
		crossImage.antialiasing = true;
		crossImage.scrollFactor.set();
		crossImage.updateHitbox();
		add(crossImage);

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);

		scoreBG = new FlxSprite(scoreText.x - scoreText.width, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.alignment = CENTER;
		diffText.font = scoreText.font;
		diffText.x = scoreBG.getGraphicMidpoint().x;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, songColor:FlxColor)
	{
		///*
		var coolDifficultyArray = [];
		for (i in CoolUtil.difficultyArray)
			if (FileSystem.exists(Paths.songJson(songName, songName + '-' + i))
				|| (FileSystem.exists(Paths.songJson(songName, songName)) && i == "NORMAL"))
				coolDifficultyArray.push(i);

		if (coolDifficultyArray.length > 0)
		{ //*/
			songs.push(new SongMetadata(songName, weekNum, songCharacter, songColor));
			existingDifficulties.push(coolDifficultyArray);
		}
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>, ?songColor:Array<FlxColor>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];
		if (songColor == null)
			songColor = [FlxColor.WHITE];

		var num:Array<Int> = [0, 0];
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num[0]], songColor[num[1]]);

			if (songCharacters.length != 1)
				num[0]++;
			if (songColor.length != 1)
				num[1]++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		starsBG.x = FlxMath.lerp(starsBG.x, starsBG.x - 0.5, CoolUtil.boundTo(elapsed * 9, 0, 1));
		starsFG.x = FlxMath.lerp(starsFG.x, starsFG.x - 1, CoolUtil.boundTo(elapsed * 9, 0, 1));
		FlxTween.color(porGlow, 0.35, porGlow.color, mainColor);

		var lerpVal = Main.framerateAdjust(0.1);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, lerpVal));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
			upScroll = FlxG.mouse.wheel > 0;
			downScroll = FlxG.mouse.wheel < 0;

			if (upScroll)
				changeSelection(-1);
			else if (downScroll)
				changeSelection(1);
		if (upP)
			changeSelection(-1);
		else if (downP)
			changeSelection(1);

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		if (controls.UI_RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			threadActive = false;
			Main.switchState(this, new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(),
				CoolUtil.difficultyArray.indexOf(existingDifficulties[curSelected][curDifficulty]));

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			PlayState.freeplayDifficulty = CoolUtil.difficultyArray.indexOf(existingDifficulties[curSelected][curDifficulty]);

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);

			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();

			threadActive = false;
			Main.switchState(this, new PlayState());
		}

		// Adhere the position of all the things (I'm sorry it was just so ugly before I had to fix it Shubs)
		scoreText.text = "PERSONAL BEST:" + lerpScore;
		scoreText.x = FlxG.width - scoreText.width - 5;
		scoreBG.width = scoreText.width + 8;
		scoreBG.x = FlxG.width - scoreBG.width;
		diffText.x = scoreBG.x + (scoreBG.width / 2) - (diffText.width / 2);

		mutex.acquire();
		if (songToPlay != null)
		{
			FlxG.sound.playMusic(songToPlay);

			if (FlxG.sound.music.fadeTween != null)
				FlxG.sound.music.fadeTween.cancel();

			FlxG.sound.music.volume = 0.0;
			FlxG.sound.music.fadeIn(1.0, 0.0, 1.0);

			songToPlay = null;
		}
		mutex.release();
	}

	var lastDifficulty:String;

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;
		if (lastDifficulty != null && change != 0)
			while (existingDifficulties[curSelected][curDifficulty] == lastDifficulty)
				curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = existingDifficulties[curSelected].length - 1;
		if (curDifficulty > existingDifficulties[curSelected].length - 1)
			curDifficulty = 0;

		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);

		diffText.text = '< ' + existingDifficulties[curSelected][curDifficulty] + ' >';
		lastDifficulty = existingDifficulties[curSelected][curDifficulty];
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('hover'), 0.5);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);

		// set up color stuffs
		mainColor = songs[curSelected].songColor;

		// song switching stuffs

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		//

		trace("curSelected: " + curSelected);

		changeDiff();
		changeSongPlaying();
	}

	function changeSongPlaying()
	{
		if (songThread == null)
		{
			songThread = Thread.create(function()
			{
				while (true)
				{
					if (!threadActive)
					{
						trace("Killing thread");
						return;
					}

					var index:Null<Int> = Thread.readMessage(false);
					if (index != null)
					{
						if (index == curSelected && index != curSongPlaying)
						{
							trace("Loading index " + index);

							var inst:Sound = Paths.inst(songs[curSelected].songName);

							if (index == curSelected && threadActive)
							{
								mutex.acquire();
								songToPlay = inst;
								mutex.release();
								portrait.animation.play(songs[curSelected].songName);
								portrait.x = 504.65;
								portrait.alpha = 0;
								portraitTween = FlxTween.tween(portrait, {x: 304.65}, 0.3, {ease: FlxEase.expoOut});
								portraitAlphaTween = FlxTween.tween(portrait, {alpha: 1}, 0.3, {ease: FlxEase.expoOut});

								curSongPlaying = curSelected;
							}
							else
								trace("Nevermind, skipping " + index);
						}
						else
							trace("Skipping " + index);
					}
				}
			});
		}

		songThread.sendMessage(curSelected);
	}

	var playingSongs:Array<FlxSound> = [];
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var songColor:FlxColor = FlxColor.WHITE;

	public function new(song:String, week:Int, songCharacter:String, songColor:FlxColor)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.songColor = songColor;
	}
}
