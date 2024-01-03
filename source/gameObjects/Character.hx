package gameObjects;

/**
	The character class initialises any and all characters that exist within gameplay. For now, the character class will
	stay the same as it was in the original source of the game. I'll most likely make some changes afterwards though!
**/
import flixel.FlxG;
import flixel.addons.util.FlxSimplex;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import gameObjects.userInterface.HealthIcon;
import meta.*;
import meta.data.*;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;
import openfl.utils.Assets as OpenFlAssets;
import gameObjects.userInterface.notes.*;

using StringTools;

typedef CharacterData = {
	var offsetX:Float;
	var offsetY:Float;
	var camOffsetX:Float;
	var camOffsetY:Float;
	var quickDancer:Bool;
}

class Character extends FNFSprite
{
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var characterData:CharacterData;
	public var adjustPos:Bool = true;

	public var idleSuffix:String = '';

	public var specialAnim:Bool = false;

	public var mostRecentHitNote:Note = null;

	public function new(?isPlayer:Bool = false)
	{
		super(x, y);
		this.isPlayer = isPlayer;
	}

	public function setCharacter(x:Float, y:Float, character:String):Character
	{
		curCharacter = character;
		var tex:FlxAtlasFrames;
		antialiasing = true;

		characterData = {
			offsetY: 0,
			offsetX: 0, 
			camOffsetY: 0,
			camOffsetX: 0,
			quickDancer: false
		};

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				tex = Paths.getSparrowAtlas('characters/GF_assets');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'gf-christmas':
				tex = Paths.getSparrowAtlas('characters/gfChristmas');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'gf-car':
				tex = Paths.getSparrowAtlas('characters/gfCar');
				frames = tex;
				animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
					false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'invisigf':
				tex = Paths.getSparrowAtlas('characters/invisigf');
				frames = tex;
				animation.addByPrefix('idle', 'idle', 24, true);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'ghostgf':
				tex = Paths.getSparrowAtlas('characters/ghostgf');
				frames = tex;
				animation.addByPrefix('cheer', 'gf cheer', 24, false);
				//animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'gf idle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'gf idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('scared', 'gf fade in', 24);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'gfr':
				tex = Paths.getSparrowAtlas('characters/gf_reactor');
				frames = tex;
				//animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByPrefix('danceLeft', 'gf dance left', 24, false);
				animation.addByPrefix('danceRight', 'gf dance right', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'gf-fall':
				tex = Paths.getSparrowAtlas('characters/gffall');
				frames = tex;
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'gfdanger':
				tex = Paths.getSparrowAtlas('characters/gf_danger');
				frames = tex;
				//animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'gfpolus':
				tex = Paths.getSparrowAtlas('characters/gfpolus');
				frames = tex;
				//animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'gfdead':
				tex = Paths.getSparrowAtlas('characters/gfdead');
				frames = tex;
				animation.addByPrefix('danceLeft', 'gf speaker', 24, false);
				animation.addByPrefix('danceRight', 'gf speaker', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'gfmira':
				tex = Paths.getSparrowAtlas('characters/gfmira');
				frames = tex;
				//animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'tuesdaygf':
				tex = Paths.getSparrowAtlas('characters/tuesdaygf');
				frames = tex;
				//animation.addByIndices('sad', 'idle', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'idle', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'oldgf':
				tex = Paths.getSparrowAtlas('characters/oldgf');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				//animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'drippico':
				tex = Paths.getSparrowAtlas('characters/drippico');
				frames = tex;
				animation.addByPrefix('idle', 'mongo', 24, false);
				animation.addByPrefix('singLEFT', 'singLEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'singRIGHT', 24, false);
				animation.addByPrefix('singUP', 'singUP', 24, false);
				animation.addByPrefix('singDOWN', 'singDOWN', 24, false);
				animation.addByPrefix('kill', 'picomongo', 24, false);
				animation.addByPrefix('idle-alt', 'idleshit', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'henrygf':
				tex = Paths.getSparrowAtlas('characters/henrygf');
				frames = tex;
				//animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'gf-farmer':
				tex = Paths.getSparrowAtlas('characters/farmer_gf');
				frames = tex;
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'loggogf':
				tex = Paths.getSparrowAtlas('characters/loggoattack');
				frames = tex;
				animation.addByPrefix('idle', 'loggfriend instance 1', 24, true);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'gf-pixel':
				tex = Paths.getSparrowAtlas('characters/gfPixel');
				frames = tex;
				animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
				animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				addOffset('danceLeft', 0);
				addOffset('danceRight', 0);

				playAnim('danceRight');

				setGraphicSize(Std.int(width * PlayState.daPixelZoom));
				updateHitbox();
				antialiasing = false;

			case 'gf-tankmen':
				frames = Paths.getSparrowAtlas('characters/gfTankmen');

				animation.addByIndices('sad', 'GF Crying at Gunpoint', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing at Gunpoint', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing at Gunpoint', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'dad':
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('characters/DADDY_DEAREST');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');
			case 'spooky':
				tex = Paths.getSparrowAtlas('characters/spooky_kids_assets');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				setGraphicSize(Std.int(width * 1));

				characterData.quickDancer = true;

				playAnim('danceRight');
			case 'mom':
				tex = Paths.getSparrowAtlas('characters/Mom_Assets');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!

				// maybe youre just dumb for not telling him to name it that
				// dw im also dumb
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'mom-car':
				tex = Paths.getSparrowAtlas('characters/momCar');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByIndices('idlePost', 'Mom Idle', [10, 11, 12, 13], "", 24, true);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');
			case 'monster':
				tex = Paths.getSparrowAtlas('characters/Monster_Assets');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster Right note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster left note', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'monster-christmas':
				tex = Paths.getSparrowAtlas('characters/monsterChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster left note', 24, false);
				animation.addByPrefix('singLEFT', 'Monster Right note', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');
			case 'pico':
				tex = Paths.getSparrowAtlas('characters/Pico_FNF_assetss');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				if (isPlayer)
				{
					animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				}
				else
				{
					// Need to be flipped! REDO THIS LATER!
					animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
					animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
					animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				}

				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'picolobby':
				frames = Paths.getSparrowAtlas('characters/picolobbest');
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico Note Right Miss', 24, false);
				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24);
				animation.addByPrefix('firstDeath', 'picoDeathSTART', 24, false);
				animation.addByPrefix('deathLoop', 'picoDeathLOOP', 24);
				animation.addByPrefix('deathConfirm', 'picoDeathCONFIRM', 24);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf':
				frames = Paths.getSparrowAtlas('characters/BOYFRIEND');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

				characterData.offsetY = 70;
			/*
				case 'bf-og':
					frames = Paths.getSparrowAtlas('characters/og/BOYFRIEND');

					animation.addByPrefix('idle', 'BF idle dance', 24, false);
					animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
					animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
					animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
					animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
					animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
					animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
					animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
					animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
					animation.addByPrefix('hey', 'BF HEY', 24, false);
					animation.addByPrefix('scared', 'BF idle shaking', 24);
					animation.addByPrefix('firstDeath', "BF dies", 24, false);
					animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
					animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

					playAnim('idle');

					flipX = true;
			 */

			case 'bf-dead':
				frames = Paths.getSparrowAtlas('characters/BF_DEATH');

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('firstDeath');

				flipX = true;

			case 'bf-genericdeath':
				frames = Paths.getSparrowAtlas('characters/genericdeath');

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				setGraphicSize(Std.int(width * 0.6));

				playAnim('firstDeath');

				flipX = true;

			case 'bfg-dead':
				frames = Paths.getSparrowAtlas('characters/bfghostDEAD');

				animation.addByPrefix('firstDeath', "death", 24, false);
				animation.addByPrefix('deathLoop', "loop death", 24, true);
				animation.addByPrefix('deathConfirm', "confirm death", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('firstDeath');

				flipX = true;

			case 'bf-running-death':
				frames = Paths.getSparrowAtlas('characters/bfrun_death');

				animation.addByPrefix('firstDeath', "death", 24, false);
				animation.addByPrefix('deathLoop', "loop death", 24, true);
				animation.addByPrefix('deathConfirm', "confirm death", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('firstDeath');

				flipX = true;

			case 'bf-defeat-dead':
				frames = Paths.getSparrowAtlas('characters/bf_defeat_death');

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('firstDeath');

				flipX = true;

			case 'bf-defeat-dead-balls':
				frames = Paths.getSparrowAtlas('characters/bf_defeat_death_balls');

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('firstDeath');

				flipX = true;

			case 'bf-pretender':
				frames = Paths.getSparrowAtlas('characters/pretender');
				animation.addByPrefix('firstDeath', 'pink dies', 24, false);
				animation.addByPrefix('deathLoop', 'death loop', 24, true);
				animation.addByPrefix('deathConfirm', 'death confirm', 24, false);

				setGraphicSize(Std.int(width * 0.9));

				playAnim('idle');

			case 'bf-picolobby':
				frames = Paths.getSparrowAtlas('characters/picolobbest');
				animation.addByPrefix('firstDeath', 'picoDeathSTART', 24, false);
				animation.addByPrefix('deathLoop', 'picoDeathLOOP', 24, true);
				animation.addByPrefix('deathConfirm', 'picoDeathCONFIRM', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf-henryphone':
				frames = Paths.getSparrowAtlas('characters/henry_i_phone');
				animation.addByPrefix('firstDeath', 'henry dies', 24, false);
				animation.addByPrefix('deathLoop', 'Henry Death loop', 24, true);
				animation.addByPrefix('deathConfirm', 'Henry death enter', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf-deathkills':
				frames = Paths.getSparrowAtlas('characters/deathkills');
				animation.addByPrefix('firstDeath', 'death start', 24, false);
				animation.addByPrefix('deathLoop', 'death loop', 24, true);
				animation.addByPrefix('deathConfirm', 'death confirm', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf-whitewhodie':
				frames = Paths.getSparrowAtlas('characters/whodies');
				animation.addByPrefix('firstDeath', 'dies', 24, false);
				animation.addByIndices('deathLoop', 'dies', [55, 56], "", 24, false);
				animation.addByIndices('deathConfirm', 'dies', [55, 56], "", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf-blackp':
				frames = Paths.getSparrowAtlas('characters/mini_black');

				animation.addByPrefix('firstDeath', "firstdeath", 24, false);
				animation.addByPrefix('deathLoop', "loopdeath", 24, true);
				animation.addByPrefix('deathConfirm', "confirmdeath", 24, false);

				setGraphicSize(Std.int(width * 1.2));

				playAnim('idle');

				flipX = true;

			case 'bf-amongbf':
				frames = Paths.getSparrowAtlas('characters/amongboy');

				animation.addByPrefix('firstDeath', "dead start", 24, false);
				animation.addByPrefix('deathLoop', "dead loop", 24, true);
				animation.addByPrefix('deathConfirm', "dead confirm", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf-alien':
				frames = Paths.getSparrowAtlas('characters/ALIEN');

				animation.addByPrefix('firstDeath', 'firstDEATH', 24, false);
				animation.addByPrefix('deathLoop', 'firstDEATH', 24, false);
				animation.addByIndices('deathConfirm', "firstDEATH", [23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1], "", 24, false);

				setGraphicSize(Std.int(width * 0.5));

				playAnim('idle');

				flipX = true;

			case 'bf-holding-gf':
				frames = Paths.getSparrowAtlas('characters/bfAndGF');

				animation.addByPrefix('idle', 'BF idle dance w gf', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf-holding-gf-dead':
				frames = Paths.getSparrowAtlas('characters/bfHoldingGF-DEAD');

				animation.addByPrefix('firstDeath', "BF Dies with GF", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead with GF Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY confirm holding gf", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('firstDeath');

			case 'bf-christmas':
				var tex = Paths.getSparrowAtlas('characters/bfChristmas');
				frames = tex;
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singUPmiss', 'miUP', 24, false);
				animation.addByPrefix('singLEFTmiss', 'miLEFT', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'miRIGHT', 24, false);
				animation.addByPrefix('singDOWNmiss', 'miDOWN', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				setGraphicSize(Std.int(width * 3));

				playAnim('idle');

				flipX = true;

				antialiasing = false;
			case 'bf-car':
				var tex = Paths.getSparrowAtlas('characters/bfCar');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByIndices('idlePost', 'BF idle dance', [8, 9, 10, 11, 12, 13, 14], "", 24, true);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bfg':
				frames = Paths.getSparrowAtlas('characters/bfghost');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'whitebf':
				frames = Paths.getSparrowAtlas('characters/whitebf');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bfr':
				frames = Paths.getSparrowAtlas('characters/bfr');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf-fall':
				frames = Paths.getSparrowAtlas('characters/bfFly');

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUPmiss', 'MISS 2up', 24, false);
				animation.addByPrefix('singLEFTmiss', 'MISS 0left', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'MISS 3right', 24, false);
				animation.addByPrefix('singDOWNmiss', 'MISS 1down', 24, false);
				animation.addByPrefix('firstDeath', 'dead 0START', 24, false);
				animation.addByPrefix('deathLoop', 'dead 1MID', 24, true);
				animation.addByPrefix('deathConfirm', 'dead 2END', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bfshock':
				frames = Paths.getSparrowAtlas('characters/bfshock');

				animation.addByPrefix('idle', 'BF idle dance', 24, true);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf-running':
				frames = Paths.getSparrowAtlas('characters/bf_running');

				animation.addByPrefix('idle', 'idle', 24, true);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUPmiss', 'm up', 24, false);
				animation.addByPrefix('singLEFTmiss', 'm left', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'm right', 24, false);
				animation.addByPrefix('singDOWNmiss', 'm down', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf-legs':
				frames = Paths.getSparrowAtlas('characters/bf_legs');

				animation.addByIndices('danceLeft', 'run legs', [11, 12, 13, 14, 15, 16, 17, 18, 19, 20], "", 24, false);
				animation.addByIndices('danceRight', 'run legs', [1, 2, 3, 4, 5, 6, 7, 8, 9], "", 24, false);
				animation.addByIndices('danceLeftmiss', 'miss run legs', [11, 12, 13, 14, 15, 16, 17, 18, 19, 20], "", 24, false);
				animation.addByIndices('danceRightmiss', 'miss run legs', [1, 2, 3, 4, 5, 6, 7, 8, 9], "", 24, false);

				setGraphicSize(Std.int(width * 1));

				characterData.quickDancer = true;

				playAnim('danceRight');

				flipX = true;

			case 'bf-legsmiss':
				frames = Paths.getSparrowAtlas('characters/bf_legs');

				animation.addByIndices('danceLeft', 'miss run legs', [11, 12, 13, 14, 15, 16, 17, 18, 19, 20], "", 24, false);
				animation.addByIndices('danceRight', 'miss run legs', [1, 2, 3, 4, 5, 6, 7, 8, 9], "", 24, false);

				setGraphicSize(Std.int(width * 1));

				characterData.quickDancer = true;

				playAnim('danceRight');

				flipX = true;

			case 'bf-defeat-normal':
				frames = Paths.getSparrowAtlas('characters/BF_Defeat_Nomal');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUPmiss', 'miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'miss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'miss', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf-defeat-scared':
				frames = Paths.getSparrowAtlas('characters/BF_Defeat_Scared');

				animation.addByPrefix('idle', 'BF idle dance afraid', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUPmiss', 'miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'miss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'miss', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bfpolus':
				frames = Paths.getSparrowAtlas('characters/bfpolus');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf-lava':
				frames = Paths.getSparrowAtlas('characters/bflava');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bfairship':
				frames = Paths.getSparrowAtlas('characters/bfairship');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bfmira':
				frames = Paths.getSparrowAtlas('characters/bfmira');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bfsauce':
				frames = Paths.getSparrowAtlas('characters/bfsauce');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('singUP-alt', 'BF NOTE UP VIBRATO', 24, false);
				animation.addByPrefix('singDOWN-alt', 'BF NOTE DOWN VIBRATO', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf_turb':
				frames = Paths.getSparrowAtlas('characters/bf_turb');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWNh', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('firstDeath', 'BF dies', 24, false);
				animation.addByIndices('deathLoop', "BF dies", [17, 18], "", 24);
				animation.addByIndices('deathConfirm', "BF dies", [17, 18], "", 24);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bfsusreal':
				frames = Paths.getSparrowAtlas('characters/bfsusreal');

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUPmiss', 'missup', 24, false);
				animation.addByPrefix('singLEFTmiss', 'missleft', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'missright', 24, false);
				animation.addByPrefix('singDOWNmiss', 'missdown', 24, false);
				animation.addByPrefix('pull', 'bf pull', 24, false);
				animation.addByPrefix('shoot', 'bf blow', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'susfriend':
				frames = Paths.getSparrowAtlas('characters/susfriend');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'dripbf':
				frames = Paths.getSparrowAtlas('characters/DrippyBF');

				animation.addByPrefix('idle', 'BF Idle Dance', 24, false);
				animation.addByPrefix('singUP', 'UpNote', 24, false);
				animation.addByPrefix('singLEFT', 'RightNote', 24, false);
				animation.addByPrefix('singRIGHT', 'LeftNote', 24, false);
				animation.addByPrefix('singDOWN', 'DownNote', 24, false);
				animation.addByPrefix('singUPmiss', 'UpMiss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'RightMiss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'LeftMiss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'DownMiss', 24, false);

				setGraphicSize(Std.int(width * 1.1));

				playAnim('idle');

				flipX = true;

			case 'redp':
				frames = Paths.getSparrowAtlas('characters/red_stuffs');

				animation.addByPrefix('idle', 'Ridle', 24, false);
				animation.addByPrefix('singUP', 'Rup', 24, false);
				animation.addByPrefix('singLEFT', 'Rright', 24, false);
				animation.addByPrefix('singRIGHT', 'Rleft', 24, false);
				animation.addByPrefix('singDOWN', 'Rdown', 24, false);
				animation.addByPrefix('singUPmiss', 'Rmissup', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Rmissright', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Rmissleft', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Rmissdown', 24, false);
				animation.addByPrefix('hey', 'Rhey', 24, false);
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'greenp':
				frames = Paths.getSparrowAtlas('characters/green_stuffs');

				animation.addByPrefix('idle', 'Gidle', 24, false);
				animation.addByPrefix('singUP', 'Gup', 24, false);
				animation.addByPrefix('singLEFT', 'Gright', 24, false);
				animation.addByPrefix('singRIGHT', 'Gleft', 24, false);
				animation.addByPrefix('singDOWN', 'Gdown', 24, false);
				animation.addByPrefix('singUPmiss', 'Gmiss up', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Gmiss right', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Gmiss left', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Gmiss down', 24, false);
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'blackp':
				frames = Paths.getSparrowAtlas('characters/mini_black');

				animation.addByPrefix('idle', 'note idle', 24, true);
				animation.addByPrefix('singUP', 'note up', 24, false);
				animation.addByPrefix('singLEFT', 'note right', 24, false);
				animation.addByPrefix('singRIGHT', 'note left', 24, false);
				animation.addByPrefix('singDOWN', 'note down', 24, false);
				animation.addByPrefix('singUPmiss', 'miss up', 24, false);
				animation.addByPrefix('singLEFTmiss', 'miss right', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'miss left', 24, false);
				animation.addByPrefix('singDOWNmiss', 'miss down', 24, false);
				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				setGraphicSize(Std.int(width * 1.2));

				playAnim('idle');

				flipX = true;

			case 'amongbf':
				frames = Paths.getSparrowAtlas('characters/amongboy');

				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'right', 24, false);
				animation.addByPrefix('singRIGHT', 'left', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUPmiss', 'mup', 24, false);
				animation.addByPrefix('singLEFTmiss', 'mright', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'mleft', 24, false);
				animation.addByPrefix('singDOWNmiss', 'mdown', 24, false);
				animation.addByPrefix('firstDeath', "dead start", 24, false);
				animation.addByPrefix('deathLoop', "dead loop", 24, true);
				animation.addByPrefix('deathConfirm', "dead confirm", 24, false);
				animation.addByPrefix('hey', 'v', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'stick-bf':
				frames = Paths.getSparrowAtlas('characters/stick-bf');

				animation.addByPrefix('idle', 'stick idle', 24, false);
				animation.addByPrefix('singUP', 'stick note up', 24, false);
				animation.addByPrefix('singLEFT', 'stick note right', 24, false);
				animation.addByPrefix('singRIGHT', 'stick note left', 24, false);
				animation.addByPrefix('singDOWN', 'stick note down', 24, false);
				animation.addByPrefix('singUPmiss', 'note up miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'note right miss', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'note left miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'note down miss', 24, false);
				animation.addByPrefix('hey', 'stick hey', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf-geoff':
				frames = Paths.getSparrowAtlas('characters/bfGEOFF');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('scared', 'BF idle shaking', 24, true);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf-opp':
				frames = Paths.getSparrowAtlas('characters/BOYFRIEND');

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf-pixel':
				frames = Paths.getSparrowAtlas('characters/bfPixel');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUPmiss', 'missup', 24, false);
				animation.addByPrefix('singLEFTmiss', 'missleft', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'missright', 24, false);
				animation.addByPrefix('singDOWNmiss', 'missdown', 24, false);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bfsus-pixel':
				frames = Paths.getSparrowAtlas('characters/bfSus');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUPmiss', 'missup', 24, false);
				animation.addByPrefix('singLEFTmiss', 'missleft', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'missright', 24, false);
				animation.addByPrefix('singDOWNmiss', 'missdown', 24, false);
				animation.addByPrefix('shoot', 'shoot', 24, false);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;
			case 'bf-pixel-dead':
				frames = Paths.getSparrowAtlas('characters/bfPixelsDEAD');
				animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
				animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
				animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
				animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
				animation.play('firstDeath');

				// pixel bullshit
				setGraphicSize(Std.int(width * 6));
				updateHitbox();
				antialiasing = false;
				flipX = true;

				characterData.offsetY = 180;

			case 'idkbf':
				frames = Paths.getSparrowAtlas('characters/idkbf');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'right', 24, false);
				animation.addByPrefix('singRIGHT', 'left', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);

				setGraphicSize(Std.int(width * 0.8));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;

				flipX = true;

			case 'bf-idk-dead':
				frames = Paths.getSparrowAtlas('characters/idk_bf_dead');
				animation.addByPrefix('firstDeath', 'first death', 24, false);
				animation.addByPrefix('deathLoop', 'first death', 24, false);
				animation.addByPrefix('deathConfirm', 'first death', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bf-pixel-opponent':
				frames = Paths.getSparrowAtlas('characters/bfPixel');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singUPmiss', 'missup', 24, false);
				animation.addByPrefix('singLEFTmiss', 'missleft', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'missright', 24, false);
				animation.addByPrefix('singDOWNmiss', 'missdown', 24, false);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				width -= 100;
				height -= 100;

				antialiasing = false;

				flipX = true;

			case 'senpai':
				frames = Paths.getSparrowAtlas('characters/senpai');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'senpai-angry':
				frames = Paths.getSparrowAtlas('characters/senpai');
				animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;

			case 'spirit':
				frames = Paths.getPackerAtlas('characters/spirit');
				animation.addByPrefix('idle', "idle spirit_", 24, false);
				animation.addByPrefix('singUP', "up_", 24, false);
				animation.addByPrefix('singRIGHT', "right_", 24, false);
				animation.addByPrefix('singLEFT', "left_", 24, false);
				animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				playAnim('idle');

				antialiasing = false;
				characterData.quickDancer = true;

			case 'parents-christmas':
				frames = Paths.getSparrowAtlas('characters/mom_dad_christmas_assets');
				animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'impostor':
				frames = Paths.getSparrowAtlas('characters/impostor');
				animation.addByPrefix('idle', 'impostor idle', 24, false);
				animation.addByPrefix('singUP', 'impostor up2', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down', 24, false);
				animation.addByPrefix('singLEFT', 'imposter left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'sabotage':
				frames = Paths.getSparrowAtlas('characters/impostorS');
				animation.addByPrefix('idle', 'impostor idle', 24, false);
				animation.addByPrefix('singUP', 'impostor up', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down', 24, false);
				animation.addByPrefix('singLEFT', 'impostor left', 24, false);
				animation.addByPrefix('hey', 'red look', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'impostor2':
				frames = Paths.getSparrowAtlas('characters/impostor2');
				animation.addByPrefix('idle', 'impostor idle', 24, false);
				animation.addByPrefix('singUP', 'impostor up2', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down', 24, false);
				animation.addByPrefix('singLEFT', 'imposter left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'crewmate':
				frames = Paths.getSparrowAtlas('characters/crewmate');
				animation.addByPrefix('idle', 'green idle', 24, false);
				animation.addByPrefix('singUP', 'green up', 24, false);
				animation.addByPrefix('singRIGHT', 'green right', 24, false);
				animation.addByPrefix('singDOWN', 'green down', 24, false);
				animation.addByPrefix('singLEFT', 'green left', 24, false);
				animation.addByPrefix('bopL', 'silly dance left', 24, false);
				animation.addByPrefix('bopR', 'silly dance right', 24, false);
				animation.addByPrefix('notice', 'green notice', 24, false);
				animation.addByPrefix('handbye', 'green unwave', 24, false);
				animation.addByPrefix('wave', 'green wave', 24, true);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'impostor3':
				frames = Paths.getSparrowAtlas('characters/impostor3');
				animation.addByPrefix('idle', 'impostor idle', 24, false);
				animation.addByPrefix('singUP', 'impostor up2', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down', 24, false);
				animation.addByPrefix('singLEFT', 'imposter left', 24, false);
				animation.addByPrefix('liveReaction', 'bwomp', 24, false);
				animation.addByPrefix('danceLeft', 'impostor dance left', 24, false);
				animation.addByPrefix('danceRight', 'impostor dance right', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'whitegreen':
				frames = Paths.getSparrowAtlas('characters/whitegreen');
				animation.addByPrefix('idle', 'impostor idle', 24, false);
				animation.addByPrefix('singUP', 'impostor up2', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down', 24, false);
				animation.addByPrefix('singLEFT', 'imposter left', 24, false);
				animation.addByPrefix('danceLeft', 'impostor dance left', 24, false);
				animation.addByPrefix('danceRight', 'impostor dance right', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'impostorr':
				frames = Paths.getSparrowAtlas('characters/impostorr');
				animation.addByPrefix('idle', 'impostor idle', 24, false);
				animation.addByPrefix('singUP', 'impostor up2', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down', 24, false);
				animation.addByPrefix('singLEFT', 'imposter left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'parasite':
				frames = Paths.getSparrowAtlas('characters/parasite');
				animation.addByPrefix('idle', 'idle instance 1', 24, true);
				animation.addByPrefix('singUP', 'up instance 1', 24, false);
				animation.addByPrefix('singRIGHT', 'right instance 1', 24, false);
				animation.addByPrefix('singDOWN', 'down instance 1', 24, false);
				animation.addByPrefix('singLEFT', 'left instance 1', 24, false);

				setGraphicSize(Std.int(width * 2));

				playAnim('idle');

			case 'yellow':
				frames = Paths.getSparrowAtlas('characters/yellow');
				animation.addByPrefix('idle', 'yellow idle', 24, false);
				animation.addByPrefix('singUP', 'yellow up', 24, false);
				animation.addByPrefix('singRIGHT', 'yellow right', 24, false);
				animation.addByPrefix('singDOWN', 'yellow down', 24, false);
				animation.addByPrefix('singLEFT', 'yellow left', 24, false);
				animation.addByPrefix('death', 'death', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'reaction':
				frames = Paths.getSparrowAtlas('characters/live_reaction');
				animation.addByPrefix('idle', 'yellow idle', 24, false);
				animation.addByPrefix('first', 'yellow reaction first', 24, false);
				animation.addByPrefix('second', 'yellow reaction second', 24, false);
				animation.addByPrefix('third', 'yellow reaction third', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'white':
				frames = Paths.getSparrowAtlas('characters/white');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'black-run':
				frames = Paths.getSparrowAtlas('characters/blackrun');
				animation.addByPrefix('idle', 'BLACK IDLE', 24, true);
				animation.addByPrefix('singUP', 'BLACK UP', 24, false);
				animation.addByPrefix('singRIGHT', 'BLACK RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'BLACK DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'BLACK LEFT', 24, false);
				animation.addByPrefix('scream', 'BLACK SCREAM', 24, false);

				setGraphicSize(Std.int(width * 1.3));

				characterData.quickDancer = true;

				playAnim('idle');

			case 'blacklegs':
				frames = Paths.getSparrowAtlas('characters/blacklegs');
				animation.addByIndices('danceLeft', 'legs', [0, 1, 2, 3, 4, 5, 6, 7], "", 24, false);
				animation.addByIndices('danceRight', 'legs', [8, 9, 10, 11, 12, 13, 14, 15, 16], "", 24, false);
				animation.addByPrefix('singUP', 'BLACK UP', 24, false);
				animation.addByPrefix('singRIGHT', 'BLACK RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'BLACK DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'BLACK LEFT', 24, false);
				animation.addByPrefix('scream', 'BLACK SCREAM', 24, false);

				setGraphicSize(Std.int(width * 1.3));

				playAnim('danceRight');

			case 'blackalt':
				frames = Paths.getSparrowAtlas('characters/blackalt');
				animation.addByPrefix('idle', 'idle alt', 24, true);
				animation.addByPrefix('singUP', 'up alt', 24, false);
				animation.addByPrefix('singRIGHT', 'right alt', 24, false);
				animation.addByPrefix('singDOWN', 'down alt', 24, false);
				animation.addByPrefix('singLEFT', 'left alt', 24, false);

				setGraphicSize(Std.int(width * 1.3));

				playAnim('idle');

			case 'whitedk':
				frames = Paths.getSparrowAtlas('characters/whitedk');
				animation.addByPrefix('idle', 'idle_w', 24, false);
				animation.addByPrefix('singUP', 'up_w', 24, false);
				animation.addByPrefix('singRIGHT', 'right_w', 24, false);
				animation.addByPrefix('singDOWN', 'down_w', 24, false);
				animation.addByPrefix('singLEFT', 'left_w', 24, false);

				setGraphicSize(Std.int(width * 1.1));

				playAnim('idle');

			case 'blackdk':
				frames = Paths.getSparrowAtlas('characters/blackdk');
				animation.addByPrefix('idle', 'idle', 24, true);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'black':
				frames = Paths.getSparrowAtlas('characters/black');
				animation.addByPrefix('idle', 'black idle remast', 24, true);
				animation.addByPrefix('singUP', 'black up', 24, false);
				animation.addByPrefix('singRIGHT', 'black right', 24, false);
				animation.addByPrefix('singDOWN', 'black down', 24, false);
				animation.addByPrefix('singLEFT', 'black left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'blackKill':
				frames = Paths.getSparrowAtlas('characters/defeat_death');
				animation.addByPrefix('idle', 'black', 24, false);
				animation.addByPrefix('kill1', 'black kill 1', 24, false);
				animation.addByPrefix('kill2', 'black kill 2', 24, false);
				animation.addByPrefix('kill3', 'black kill 3', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'blackold':
				frames = Paths.getSparrowAtlas('characters/blackold');
				animation.addByPrefix('idle', 'BLACK IDLE', 24, true);
				animation.addByPrefix('singUP', 'BLACK UP', 24, false);
				animation.addByPrefix('singRIGHT', 'BLACK RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'BLACK DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'BLACK LEFT', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'blackparasite':
				frames = Paths.getSparrowAtlas('characters/blackparasite');
				animation.addByPrefix('idle', 'abomination black idle instance 1', 24, true);
				animation.addByPrefix('singUP', 'BLACK UP', 24, false);
				animation.addByPrefix('singRIGHT', 'right ske instance 1', 24, false);
				animation.addByPrefix('singDOWN', 'black down instance 1', 24, false);
				animation.addByPrefix('singLEFT', 'left  instance 1', 24, false);

				setGraphicSize(Std.int(width * 2));

				playAnim('idle');

			case 'bfscary':
				frames = Paths.getSparrowAtlas('characters/bfscary');
				animation.addByPrefix('idle', 'Bf idle', 24, false);
				animation.addByPrefix('singUP', 'BF up', 24, false);
				animation.addByPrefix('singRIGHT', 'BF left', 24, false);
				animation.addByPrefix('singDOWN', 'BF down', 24, false);
				animation.addByPrefix('singLEFT', 'BF right', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'monotone':
				frames = Paths.getSparrowAtlas('characters/monotone');
				animation.addByPrefix('idle', 'Sidle', 24, false);
				animation.addByPrefix('singUP', 'Sup', 24, false);
				animation.addByPrefix('singRIGHT', 'Sright', 24, false);
				animation.addByPrefix('singDOWN', 'Sdown', 24, false);
				animation.addByPrefix('singLEFT', 'Sleft', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'maroon':
				frames = Paths.getSparrowAtlas('characters/maroon');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('hey', 'hey', 24, false);

				setGraphicSize(Std.int(width * 0.9));

				playAnim('idle');

			case 'maroonp':
				frames = Paths.getSparrowAtlas('characters/maroonP');
				animation.addByPrefix('idle', 'idle', 24, true);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'grey':
				frames = Paths.getSparrowAtlas('characters/grey');
				animation.addByIndices('danceLeft', 'idle', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'idle', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				setGraphicSize(Std.int(width * 0.9));

				characterData.quickDancer = true;

				playAnim('danceRight');

			case 'pink':
				frames = Paths.getSparrowAtlas('characters/pink');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 0.9));

				playAnim('idle');

			case 'pretender':
				frames = Paths.getSparrowAtlas('characters/pretender');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Left', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Right', 24, false);
				animation.addByPrefix('singUPmiss', 'mup', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'mleft', 24, false);
				animation.addByPrefix('singDOWNmiss', 'mdown', 24, false);
				animation.addByPrefix('singLEFTmiss', 'mright', 24, false);
				animation.addByPrefix('firstDeath', 'pink dies', 24, false);
				animation.addByPrefix('deathLoop', 'death loop', 24, true);
				animation.addByPrefix('deathConfirm', 'death confirm', 24, false);

				setGraphicSize(Std.int(width * 0.9));

				playAnim('idle');

			case 'chefogus':
				frames = Paths.getSparrowAtlas('characters/chefogus');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('singUP-alt', 'vup', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Vdown', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'jorsawsee':
				frames = Paths.getSparrowAtlas('characters/jorsawsee');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'meangus':
				frames = Paths.getSparrowAtlas('characters/meangus');
				animation.addByPrefix('idle', 'idle', 12, false);
				animation.addByPrefix('singUP', 'up', 12, false);
				animation.addByPrefix('singRIGHT', 'left', 12, false);
				animation.addByPrefix('singDOWN', 'down', 12, false);
				animation.addByPrefix('singLEFT', 'right', 12, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'warchief':
				frames = Paths.getSparrowAtlas('characters/warchief');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'jelqer':
				frames = Paths.getSparrowAtlas('characters/jelqer');
				animation.addByPrefix('danceLeft', 'jelqer dance left', 24, false);
				animation.addByPrefix('danceRight', 'jelqer dance right', 24, false);
				animation.addByPrefix('singUP', 'jelqer up', 24, false);
				animation.addByPrefix('singRIGHT', 'jelqer right', 24, false);
				animation.addByPrefix('singDOWN', 'jelqer down', 24, false);
				animation.addByPrefix('singLEFT', 'jelqer left', 24, false);

				setGraphicSize(Std.int(width * 1.1));

				characterData.quickDancer = true;

				playAnim('danceRight');

			case 'mungus':
				frames = Paths.getSparrowAtlas('characters/mungus');
				animation.addByPrefix('idle', 'idle', 12, false);
				animation.addByPrefix('singUP', 'up', 12, false);
				animation.addByPrefix('singRIGHT', 'right', 12, false);
				animation.addByPrefix('singDOWN', 'down', 12, false);
				animation.addByPrefix('singLEFT', 'left', 12, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'madgus':
				frames = Paths.getSparrowAtlas('characters/madgus');
				animation.addByPrefix('danceLeft', 'DANCELEFT', 12, false);
				animation.addByPrefix('danceRight', 'DANCERIGHT', 12, false);
				animation.addByPrefix('singUP', 'up', 12, false);
				animation.addByPrefix('singRIGHT', 'right', 12, false);
				animation.addByPrefix('singDOWN', 'down', 12, false);
				animation.addByPrefix('singLEFT', 'left', 12, false);
				animation.addByPrefix('bwah', 'scream', 12, false);

				characterData.quickDancer = true;

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'redmungusp':
				frames = Paths.getSparrowAtlas('characters/Redmungus');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				setGraphicSize(Std.int(width * 1.4));

				playAnim('idle');

			case 'jorsawghost':
				frames = Paths.getSparrowAtlas('characters/jorsawdead');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				setGraphicSize(Std.int(width * 0.9));

				playAnim('idle');

			case 'powers':
				frames = Paths.getSparrowAtlas('characters/powers');
				animation.addByPrefix('idle', 'power idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('idle-alt', 'sax idle', 24, false);
				animation.addByPrefix('singUP-alt', 'sax up', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'sax right', 24, false);
				animation.addByPrefix('singDOWN-alt', 'sax down', 24, false);
				animation.addByPrefix('singLEFT-alt', 'sax left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'henry':
				frames = Paths.getSparrowAtlas('characters/HENRY_ASSS');
				animation.addByPrefix('idle', 'Henry Idle', 24, false);
				animation.addByPrefix('singUP', 'Henry Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Henry Right', 24, false);
				animation.addByPrefix('singDOWN', 'Henry Down', 24, false);
				animation.addByPrefix('singLEFT', 'Henry Left', 24, false);
				animation.addByPrefix('shock', 'henry shock omg', 24, false);
				animation.addByPrefix('armed', 'Henry React Arm', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'charles':
				frames = Paths.getSparrowAtlas('characters/charles');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('oh', 'oh', 24, false);
				animation.addByPrefix('perfect', 'perfect', 24, false);

				setGraphicSize(Std.int(width * 0.8));

				playAnim('idle');

			case 'henryphone':
				frames = Paths.getSparrowAtlas('characters/henry_i_phone');
				animation.addByPrefix('idle', 'Henry Idle', 24, false);
				animation.addByPrefix('singUP', 'Henry Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Henry Left', 24, false);
				animation.addByPrefix('singDOWN', 'Henry Down', 24, false);
				animation.addByPrefix('singLEFT', 'Henry Right', 24, false);
				animation.addByPrefix('singUPmiss', 'Henry Miss Up', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Henry Miss Left', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Henry Miss Down', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Henry Miss Right', 24, false);
				animation.addByPrefix('firstDeath', 'henry dies', 24, false);
				animation.addByPrefix('deathLoop', 'Henry Death loop', 24, true);
				animation.addByPrefix('deathConfirm', 'Henry death enter', 24, false);
				animation.addByPrefix('intro', 'Henry Greatest Plan Intro', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'ellie':
				frames = Paths.getSparrowAtlas('characters/Ellie_Assets');
				animation.addByPrefix('idle', 'Ellie Idle', 24, false);
				animation.addByPrefix('singUP', 'Ellie Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Ellie Right', 24, false);
				animation.addByPrefix('singDOWN', 'Ellie Down', 24, false);
				animation.addByPrefix('singLEFT', 'Ellie Left', 24, false);
				animation.addByPrefix('enter', 'Ellie Enter Animation', 24, false);
				animation.addByPrefix('armed', 'Ellie React Arm', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'rhm':
				frames = Paths.getSparrowAtlas('characters/rhm');
				animation.addByPrefix('idle', 'RHM Idle', 24, false);
				animation.addByPrefix('singUP', 'RHM Up', 24, false);
				animation.addByPrefix('singRIGHT', 'RHM Right', 24, false);
				animation.addByPrefix('singDOWN', 'RHM down new', 24, false);
				animation.addByPrefix('singLEFT', 'RHM left pose', 24, false);
				animation.addByPrefix('intro', 'RHM intro new', 24, false);
				animation.addByPrefix('animation', 'rhm animation', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'reginald':
				frames = Paths.getSparrowAtlas('characters/Reginald_Assets');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'tomongus':
				frames = Paths.getSparrowAtlas('characters/tomongus');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('huh', 'huh', 24, false);

				setGraphicSize(Std.int(width * 6));

				playAnim('idle');

				antialiasing = false;

			case 'hamster':
				frames = Paths.getSparrowAtlas('characters/hamster');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 6));

				playAnim('idle');

				antialiasing = false;

			case 'tuesday':
				frames = Paths.getSparrowAtlas('characters/tuesday');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);
				animation.addByPrefix('prep', 'anim 1', 24, false);
				animation.addByPrefix('shot', 'anim 2', 24, false);
				animation.addByPrefix('idle-alt', 'tomidle', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'fella':
				frames = Paths.getSparrowAtlas('characters/fella');
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);

				setGraphicSize(Std.int(width * 3));

				playAnim('idle');

				antialiasing = false;

			case 'boo':
				frames = Paths.getSparrowAtlas('characters/jollyFella');
				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'LEFT', 24, false);

				setGraphicSize(Std.int(width * 3));

				playAnim('idle');

				antialiasing = false;

			case 'oldpostor':
				frames = Paths.getSparrowAtlas('characters/oldpostor');
				animation.addByPrefix('idle', 'Impostor Idle', 12, true);
				animation.addByPrefix('singUP', 'Impostor Up', 12, true);
				animation.addByPrefix('singRIGHT', 'Impostor Forward', 12, true);
				animation.addByPrefix('singDOWN', 'Impostor Down', 12, true);
				animation.addByPrefix('singLEFT', 'Impostor Backwards', 12, true);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'red':
				frames = Paths.getSparrowAtlas('characters/red');
				animation.addByPrefix('idle', 'red idle', 24, false);
				animation.addByPrefix('singUP', 'red up', 24, false);
				animation.addByPrefix('singRIGHT', 'red right', 24, false);
				animation.addByPrefix('singDOWN', 'red down', 24, false);
				animation.addByPrefix('singLEFT', 'red left', 24, false);

				setGraphicSize(Std.int(width * 0.8));

				playAnim('idle');

			case 'blue':
				frames = Paths.getSparrowAtlas('characters/blue');
				animation.addByPrefix('idle', 'blue idle', 24, false);
				animation.addByPrefix('singUP', 'blue up', 24, false);
				animation.addByPrefix('singRIGHT', 'blue left', 24, false);
				animation.addByPrefix('singDOWN', 'blue down', 24, false);
				animation.addByPrefix('singLEFT', 'blue right', 24, false);

				setGraphicSize(Std.int(width * 0.8));

				playAnim('idle');

				flipX = true;

			case 'bluehit':
				frames = Paths.getSparrowAtlas('characters/bluehit');
				animation.addByPrefix('idle', 'hit idle', 24, false);
				animation.addByPrefix('singUP', 'hit up', 24, false);
				animation.addByPrefix('singRIGHT', 'hit left', 24, false);
				animation.addByPrefix('singDOWN', 'hit down', 24, false);
				animation.addByPrefix('singLEFT', 'hit right', 24, false);

				setGraphicSize(Std.int(width * 0.8));

				playAnim('idle');

				flipX = true;

			case 'bluewhonormal':
				frames = Paths.getSparrowAtlas('characters/bluewhonormal');
				animation.addByPrefix('idle', 'blue idle normal', 24, false);
				animation.addByPrefix('singUP', 'normal blue up', 24, false);
				animation.addByPrefix('singRIGHT', 'normal blue left', 24, false);
				animation.addByPrefix('singDOWN', 'normal blue down', 24, false);
				animation.addByPrefix('singLEFT', 'normal blue right', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'bluewho':
				frames = Paths.getSparrowAtlas('characters/bluewho');
				animation.addByPrefix('idle', 'blue idle', 24, false);
				animation.addByPrefix('singUP', 'blue up', 24, false);
				animation.addByPrefix('singRIGHT', 'blue left', 24, false);
				animation.addByPrefix('singDOWN', 'blue down', 24, false);
				animation.addByPrefix('singLEFT', 'blue right', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'whitewho':
				frames = Paths.getSparrowAtlas('characters/whitewho');
				animation.addByPrefix('idle', 'white idle', 24, false);
				animation.addByPrefix('singUP', 'white up', 24, false);
				animation.addByPrefix('singRIGHT', 'white left', 24, false);
				animation.addByPrefix('singDOWN', 'white down', 24, false);
				animation.addByPrefix('singLEFT', 'white right', 24, false);
				animation.addByPrefix('singUPmiss', 'miss up', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'miss left', 24, false);
				animation.addByPrefix('singDOWNmiss', 'miss down', 24, false);
				animation.addByPrefix('singLEFTmiss', 'miss right', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'whitemad':
				frames = Paths.getSparrowAtlas('characters/whitemad');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'left', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'right', 24, false);
				animation.addByPrefix('singUPmiss', 'miss up', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'miss left', 24, false);
				animation.addByPrefix('singDOWNmiss', 'miss down', 24, false);
				animation.addByPrefix('singLEFTmiss', 'miss right', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'jerma':
				frames = Paths.getSparrowAtlas('characters/jerma');
				animation.addByPrefix('idle', 'IdleJerma', 24, false);
				animation.addByPrefix('singUP', 'UpJerma', 24, false);
				animation.addByPrefix('singRIGHT', 'RightJerma', 24, false);
				animation.addByPrefix('singDOWN', 'DownJerma', 24, false);
				animation.addByPrefix('singLEFT', 'LeftJerma', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'nuzzus':
				frames = Paths.getSparrowAtlas('characters/nuzzus');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				setGraphicSize(Std.int(width * 5));

				playAnim('idle');

				antialiasing = false;

			case 'idk':
				frames = Paths.getSparrowAtlas('characters/idk');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				setGraphicSize(Std.int(width * 0.8));

				playAnim('idle');

				antialiasing = false;

			case 'esculent':
				frames = Paths.getSparrowAtlas('characters/esculent');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				setGraphicSize(Std.int(width * 0.6));

				playAnim('idle');

			case 'drippypop':
				frames = Paths.getSparrowAtlas('characters/drippy');
				animation.addByPrefix('idle', 'DripIdle', 24, false);
				animation.addByPrefix('singUP', 'DripUp', 24, false);
				animation.addByPrefix('singRIGHT', 'DripRight', 24, false);
				animation.addByPrefix('singDOWN', 'DripDown', 24, false);
				animation.addByPrefix('singLEFT', 'DripLeft', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'dave':
				frames = Paths.getSparrowAtlas('characters/Dave');
				animation.addByPrefix('idle', 'Dave Idle', 12, false);
				animation.addByPrefix('singUP', 'Dave Up', 12, false);
				animation.addByPrefix('singRIGHT', 'Dave Right', 12, false);
				animation.addByPrefix('singDOWN', 'Dave Down', 12, false);
				animation.addByPrefix('singLEFT', 'Dave Left', 12, false);
				animation.addByPrefix('die', 'Dave Death', 12, false);

				setGraphicSize(Std.int(width * 0.9));

				playAnim('idle');

			case 'attack':
				frames = Paths.getSparrowAtlas('characters/attack');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'clowfoe':
				frames = Paths.getSparrowAtlas('characters/clowfoefnf');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'left', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'right', 24, false);

				setGraphicSize(Std.int(width * 0.7));

				playAnim('idle');

				flipX = true;

			case 'fabs':
				frames = Paths.getSparrowAtlas('characters/fabs');
				animation.addByPrefix('idle', 'fabs idle', 24, false);
				animation.addByPrefix('singUP', 'fabs up', 24, false);
				animation.addByPrefix('singRIGHT', 'fabs right', 24, false);
				animation.addByPrefix('singDOWN', 'fabs down', 24, false);
				animation.addByPrefix('singLEFT', 'fabs left', 24, false);

				setGraphicSize(Std.int(width * 0.9));

				playAnim('idle');

			case 'biddle':
				frames = Paths.getSparrowAtlas('characters/biddle');
				animation.addByPrefix('idle', 'biddle idle', 24, false);
				animation.addByPrefix('singUP', 'biddle up', 24, false);
				animation.addByPrefix('singRIGHT', 'biddle right', 24, false);
				animation.addByPrefix('singDOWN', 'biddle down', 24, false);
				animation.addByPrefix('singLEFT', 'biddle left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'top':
				frames = Paths.getSparrowAtlas('characters/top10');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'cval':
				frames = Paths.getSparrowAtlas('characters/cval');
				animation.addByPrefix('idle', 'Cval Idle', 24, false);
				animation.addByPrefix('singUP', 'Cval Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Cval Right', 24, false);
				animation.addByPrefix('singDOWN', 'Cval Down', 24, false);
				animation.addByPrefix('singLEFT', 'Cval Left', 24, false);
				animation.addByPrefix('pip', 'Cval Hi pip', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'pip':
				frames = Paths.getSparrowAtlas('characters/pip');
				animation.addByPrefix('idle', 'Pip Idle', 24, false);
				animation.addByPrefix('singUP', 'Pip Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Pip Right', 24, false);
				animation.addByPrefix('singDOWN', 'Pip Down', 24, false);
				animation.addByPrefix('singLEFT', 'Pip Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'pip_evil':
				frames = Paths.getSparrowAtlas('characters/pip_evil');
				animation.addByPrefix('idle', 'Pip Idle', 24, false);
				animation.addByPrefix('singUP', 'Pip Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Pip Right', 24, false);
				animation.addByPrefix('singDOWN', 'Pip Down', 24, false);
				animation.addByPrefix('singLEFT', 'Pip Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'cvaltorture':
				frames = Paths.getSparrowAtlas('characters/cvaltorture');
				animation.addByPrefix('idle', 'cvale', 24, false);
				animation.addByPrefix('singUP', 'cval up', 24, false);
				animation.addByPrefix('singRIGHT', 'cval right', 24, false);
				animation.addByPrefix('singDOWN', 'cval down', 24, false);
				animation.addByPrefix('singLEFT', 'cval left', 24, false);
				animation.addByPrefix('GETOUT', 'cval rozebud', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'piptorture':
				frames = Paths.getSparrowAtlas('characters/piptorture');
				animation.addByPrefix('idle', 'piple', 24, false);
				animation.addByPrefix('singUP', 'pip up', 24, false);
				animation.addByPrefix('singRIGHT', 'pip righ', 24, false);
				animation.addByPrefix('singDOWN', 'pip down', 24, false);
				animation.addByPrefix('singLEFT', 'pip lef', 24, false);
				animation.addByPrefix('rozebud?', 'piprozebud', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'ziffytorture':
				frames = Paths.getSparrowAtlas('characters/ziffytorture');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up Normal', 24, false);
				animation.addByPrefix('singRIGHT', 'Left Normal', 24, false);
				animation.addByPrefix('singDOWN', 'Down Normal', 24, false);
				animation.addByPrefix('singLEFT', 'Right Normal', 24, false);
				animation.addByPrefix('singUPmiss', 'missUp', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'missLeft', 24, false);
				animation.addByPrefix('singDOWNmiss', 'missDown', 24, false);
				animation.addByPrefix('singLEFTmiss', 'missRight', 24, false);
				animation.addByPrefix('singUP-alt', 'Up Yell', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'Right Yell', 24, false);
				animation.addByPrefix('singDOWN-alt', 'Down Yell', 24, false);
				animation.addByPrefix('singLEFT-alt', 'Left Yell', 24, false);
				animation.addByPrefix('ROZEBUD', 'Rozebud', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

				flipX = true;

			case 'alien':
				frames = Paths.getSparrowAtlas('characters/ALIEN');

				animation.addByPrefix('idle', 'IDLE', 24, false);
				animation.addByPrefix('singUP', 'UP', 24, false);
				animation.addByPrefix('singLEFT', 'RIGHT', 24, false);
				animation.addByPrefix('singRIGHT', 'LEFT', 24, false);
				animation.addByPrefix('singDOWN', 'DOWN', 24, false);
				animation.addByPrefix('singUPmiss', 'mUP', 24, false);
				animation.addByPrefix('singLEFTmiss', 'mRIGHT', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'mLEFT', 24, false);
				animation.addByPrefix('singDOWNmiss', 'mDOWN', 24, false);
				animation.addByPrefix('firstDeath', 'firstDEATH', 24, false);
				animation.addByPrefix('deathLoop', 'firstDEATH', 24, false);
				animation.addByIndices('deathConfirm', "firstDEATH", [23, 21, 19, 17, 15, 13, 11, 9, 7, 5, 3, 1], "", 24);

				setGraphicSize(Std.int(width * 0.5));

				playAnim('idle');

				flipX = true;

			case 'blackPlaceholder':
				frames = Paths.getSparrowAtlas('characters/black_placeholder');
				animation.addByPrefix('idle', 'black idle (placeholder)', 24, true);
				animation.addByPrefix('singUP', 'black idle (placeholder)', 24, true);
				animation.addByPrefix('singRIGHT', 'black idle (placeholder)', 24, true);
				animation.addByPrefix('singDOWN', 'black idle (placeholder)', 24, true);
				animation.addByPrefix('singLEFT', 'black idle (placeholder)', 24, true);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'blackpostor':
				frames = Paths.getSparrowAtlas('characters/blackpostor');
				animation.addByPrefix('idle', 'impostor idle', 24, false);
				animation.addByPrefix('singUP', 'impostor up2', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down', 24, false);
				animation.addByPrefix('singLEFT', 'imposter left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'crewmate-dance':
				frames = Paths.getSparrowAtlas('characters/crewmate');
				animation.addByPrefix('idle', 'green idle', 24, false);
				animation.addByPrefix('singUP', 'green up', 24, false);
				animation.addByPrefix('singRIGHT', 'green right', 24, false);
				animation.addByPrefix('singDOWN', 'green down', 24, false);
				animation.addByPrefix('singLEFT', 'green left', 24, false);
				animation.addByPrefix('bopL', 'silly dance left', 24, false);
				animation.addByPrefix('bopR', 'silly dance right', 24, false);
				animation.addByPrefix('notice', 'green notice', 24, false);
				animation.addByPrefix('handbye', 'green unwave', 24, false);
				animation.addByPrefix('wave', 'green wave', 24, true);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'dead':
				frames = Paths.getSparrowAtlas('characters/deadpostor');
				animation.addByPrefix('idle', 'idle', 24, true);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down2', 24, false);
				animation.addByPrefix('singLEFT', 'left2', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'dt':
				frames = Paths.getSparrowAtlas('characters/dt');
				animation.addByPrefix('idle', 'mungus idle instance 1', 24, true);
				animation.addByPrefix('singUP', 'parashite up instance 1', 24, false);
				animation.addByPrefix('singRIGHT', 'parasite right new instance 1', 24, false);
				animation.addByPrefix('singDOWN', 'paracite down instance 1', 24, false);
				animation.addByPrefix('singLEFT', 'parasite left instance 1', 24, false);
				animation.addByPrefix('singUP-alt', 'parasite up redsing instance 1', 24, false);
				animation.addByPrefix('singRIGHT-alt', 'parasite right redsing instance 1', 24, false);
				animation.addByPrefix('singDOWN-alt', 'parasite down redsing instance 1', 24, false);
				animation.addByPrefix('singLEFT-alt', 'parasite left redsing instance 1', 24, false);

				setGraphicSize(Std.int(width * 2.6));

				playAnim('idle');

			case 'fuckgus':
				frames = Paths.getSparrowAtlas('characters/REAL_FUCKMUNGUS');
				animation.addByPrefix('danceLeft', 'idle', 12, false);
				animation.addByPrefix('danceRight', 'DANCERIGHT', 12, false);
				animation.addByPrefix('singUP', 'up', 12, false);
				animation.addByPrefix('singRIGHT', 'right', 12, false);
				animation.addByPrefix('singDOWN', 'down', 12, false);
				animation.addByPrefix('singLEFT', 'left', 12, false);
				animation.addByPrefix('FUCK', 'FUUUUCK', 12, false);
				animation.addByPrefix('FUCKlooper', 'Ye', 12, true);

				characterData.quickDancer = true;

				setGraphicSize(Std.int(width * 1));

				playAnim('danceRight');

			case 'ghost':
				frames = Paths.getSparrowAtlas('characters/ghost');
				animation.addByPrefix('idle', 'Ghost Idle', 24, false);
				animation.addByPrefix('singUP', 'Ghost Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Ghost Left', 24, false);
				animation.addByPrefix('singDOWN', 'Ghost Down', 24, false);
				animation.addByPrefix('singLEFT', 'Ghost Right', 24, false);

				setGraphicSize(Std.int(width * 0.9));

				playAnim('idle');

				flipX = true;

			case 'henryplayer':
				frames = Paths.getSparrowAtlas('characters/henry');
				animation.addByPrefix('idle', 'Henry Idle', 24, false);
				animation.addByPrefix('singUP', 'Henry Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Henry Left', 24, false);
				animation.addByPrefix('singDOWN', 'Henry Down', 24, false);
				animation.addByPrefix('singLEFT', 'Henry Right', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'impostorv2':
				frames = Paths.getSparrowAtlas('characters/impostorv2');
				animation.addByPrefix('idle', 'impostor idle', 24, false);
				animation.addByPrefix('singUP', 'impostor up', 24, false);
				animation.addByPrefix('singRIGHT', 'impostor right', 24, false);
				animation.addByPrefix('singDOWN', 'impostor down', 24, false);
				animation.addByPrefix('singLEFT', 'imposter left', 24, false);
				animation.addByPrefix('hello', 'Hello bitches', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'jorsawdead':
				frames = Paths.getSparrowAtlas('characters/jorsawdead');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				setGraphicSize(Std.int(width * 0.9));

				playAnim('idle');

			case 'kyubicrasher':
				frames = Paths.getSparrowAtlas('characters/kyubi');
				animation.addByPrefix('idle', 'coryidle', 24, false);
				animation.addByPrefix('singUP', 'coryup', 24, false);
				animation.addByPrefix('singRIGHT', 'coryright', 24, false);
				animation.addByPrefix('singDOWN', 'corydown', 24, false);
				animation.addByPrefix('singLEFT', 'coryleft', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'loggo':
				frames = Paths.getSparrowAtlas('characters/loggo');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singUP', 'up', 24, false);
				animation.addByPrefix('singRIGHT', 'right', 24, false);
				animation.addByPrefix('singDOWN', 'down', 24, false);
				animation.addByPrefix('singLEFT', 'left', 24, false);

				setGraphicSize(Std.int(width * 2.3));

				playAnim('idle');

				antialiasing = false;

			case 'pinkexe':
				frames = Paths.getSparrowAtlas('characters/pinkexe');
				animation.addByPrefix('idle', 'Pink Idle', 24, false);
				animation.addByPrefix('singUP', 'Pink Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Pink Right', 24, false);
				animation.addByPrefix('singDOWN', 'Pink Down', 24, false);
				animation.addByPrefix('singLEFT', 'Pink Left', 24, false);

				setGraphicSize(Std.int(width * 0.9));

				playAnim('idle');

			case 'pinkplayable':
				frames = Paths.getSparrowAtlas('characters/pink');
				animation.addByPrefix('idle', 'Idle', 24, false);
				animation.addByPrefix('singUP', 'Up', 24, false);
				animation.addByPrefix('singRIGHT', 'Right', 24, false);
				animation.addByPrefix('singDOWN', 'Down', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 0.9));

				playAnim('idle');

			case 'powers_sax':
				frames = Paths.getSparrowAtlas('characters/powers');
				animation.addByPrefix('idle', 'sax idle', 24, false);
				animation.addByPrefix('singUP', 'sax up', 24, false);
				animation.addByPrefix('singRIGHT', 'sax right', 24, false);
				animation.addByPrefix('singDOWN', 'sax down', 24, false);
				animation.addByPrefix('singLEFT', 'sax left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'ziffy':
				frames = Paths.getSparrowAtlas('characters/ziffyfnf');
				animation.addByPrefix('idle', 'ziffy idle', 24, false);
				animation.addByPrefix('singUP', 'ziffy up', 24, false);
				animation.addByPrefix('singRIGHT', 'ziffy right', 24, false);
				animation.addByPrefix('singDOWN', 'ziffy down', 24, false);
				animation.addByPrefix('singLEFT', 'ziffy left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'crab':
				frames = Paths.getSparrowAtlas('characters/pets/crab');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'dog':
				frames = Paths.getSparrowAtlas('characters/pets/dog');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'elliepet':
				frames = Paths.getSparrowAtlas('characters/pets/ellie');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'frankendog':
				frames = Paths.getSparrowAtlas('characters/pets/frankendog');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'ham':
				frames = Paths.getSparrowAtlas('characters/pets/ham');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'hamsterpet':
				frames = Paths.getSparrowAtlas('characters/pets/hamster');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'minicrewmate':
				frames = Paths.getSparrowAtlas('characters/pets/minicrewmate');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'nothing':
				frames = Paths.getSparrowAtlas('characters/pets/nothing');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'snowball':
				frames = Paths.getSparrowAtlas('characters/pets/snowball');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'stickmin':
				frames = Paths.getSparrowAtlas('characters/pets/stickmin');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'tomong':
				frames = Paths.getSparrowAtlas('characters/pets/tomong');
				animation.addByPrefix('idle', 'idle', 24, false);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			case 'ufo':
				frames = Paths.getSparrowAtlas('characters/pets/ufo');
				animation.addByPrefix('idle', 'idle', 24, true);
				animation.addByPrefix('singLEFT', 'Left', 24, false);

				setGraphicSize(Std.int(width * 1));

				playAnim('idle');

			default:
				// set up animations if they aren't already

				// fyi if you're reading this this isn't meant to be well made, it's kind of an afterthought I wanted to mess with and
				// I'm probably not gonna clean it up and make it an actual feature of the engine I just wanted to play other people's mods but not add their files to
				// the engine because that'd be stealing assets
				var fileNew = curCharacter + 'Anims';
				if (OpenFlAssets.exists(Paths.offsetTxt(fileNew)))
				{
					var characterAnims:Array<String> = CoolUtil.coolTextFile(Paths.offsetTxt(fileNew));
					var characterName:String = characterAnims[0].trim();
					frames = Paths.getSparrowAtlas('characters/$characterName');
					for (i in 1...characterAnims.length)
					{
						var getterArray:Array<Array<String>> = CoolUtil.getAnimsFromTxt(Paths.offsetTxt(fileNew));
						animation.addByPrefix(getterArray[i][0], getterArray[i][1].trim(), 24, false);
					}
				}
				else 
					return setCharacter(x, y, 'bf'); 					
		}

		// set up offsets cus why not
		if (OpenFlAssets.exists(Paths.offsetTxt(curCharacter + 'Offsets')))
		{
			var characterOffsets:Array<String> = CoolUtil.coolTextFile(Paths.offsetTxt(curCharacter + 'Offsets'));
			for (i in 0...characterOffsets.length)
			{
				var getterArray:Array<Array<String>> = CoolUtil.getOffsetsFromTxt(Paths.offsetTxt(curCharacter + 'Offsets'));
				addOffset(getterArray[i][0], Std.parseInt(getterArray[i][1]), Std.parseInt(getterArray[i][2]));
			}
		}

		dance();

		if (isPlayer) // fuck you ninjamuffin lmao
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
				flipLeftRight();
			//
		}
		else if (curCharacter.startsWith('bf'))
			flipLeftRight();

		if (adjustPos) {
			x += characterData.offsetX;
			trace('character ${curCharacter} scale ${scale.y}');
			y += (characterData.offsetY - (frameHeight * scale.y));
		}

		this.x = x;
		this.y = y;
		
		return this;
	}

	function flipLeftRight():Void
	{
		// get the old right sprite
		var oldRight = animation.getByName('singRIGHT').frames;

		// set the right to the left
		animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;

		// set the left to the old right
		animation.getByName('singLEFT').frames = oldRight;

		// insert ninjamuffin screaming I think idk I'm lazy as hell

		if (animation.getByName('singRIGHTmiss') != null)
		{
			var oldMiss = animation.getByName('singRIGHTmiss').frames;
			animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
			animation.getByName('singLEFTmiss').frames = oldMiss;
		}
	}

	override function update(elapsed:Float)
	{
		if (!isPlayer)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				dance();
				holdTimer = 0;
			}
		}

			if(specialAnim && animation.curAnim.finished)
			{
				specialAnim = false;
				dance();
			}

		var curCharSimplified:String = simplifyCharacter();
		switch (curCharSimplified)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
				if ((animation.curAnim.name.startsWith('sad')) && (animation.curAnim.finished))
					playAnim('danceLeft');
		}

		// Post idle animation (think Week 4 and how the player and mom's hair continues to sway after their idle animations are done!)
		if (animation.curAnim.finished && animation.curAnim.name == 'idle')
		{
			// We look for an animation called 'idlePost' to switch to
			if (animation.getByName('idlePost') != null)
				// (( WE DON'T USE 'PLAYANIM' BECAUSE WE WANT TO FEED OFF OF THE IDLE OFFSETS! ))
				animation.play('idlePost', true, false, 0);
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(?forced:Bool = false)
	{
		if (!debugMode)
		{
			var curCharSimplified:String = simplifyCharacter();
			switch (curCharSimplified)
			{
				case 'gf':
					if ((!animation.curAnim.name.startsWith('hair')) && (!animation.curAnim.name.startsWith('sad')))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', forced);
						else
							playAnim('danceLeft', forced);
					}
				default:
					// Left/right dancing, think Skid & Pump
					if (animation.getByName('danceLeft') != null && animation.getByName('danceRight') != null) {
						danced = !danced;
						if (danced)
							playAnim('danceRight', forced);
						else
							playAnim('danceLeft', forced);
					}
					else
						playAnim('idle', forced);
					if (idleSuffix == '-alt')
						playAnim('idle-alt', forced);
			}
		}
	}

	override public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (animation.getByName(AnimName) != null)
			super.playAnim(AnimName, Force, Reversed, Frame);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
				danced = true;
			else if (AnimName == 'singRIGHT')
				danced = false;

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
				danced = !danced;
		}
	}

	public function simplifyCharacter():String
	{
		var base = curCharacter;

		if (base.contains('-'))
			base = base.substring(0, base.indexOf('-'));
		return base;
	}
}