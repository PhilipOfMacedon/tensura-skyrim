Scriptname AddExplosionEffect extends ActiveMagicEffect  

import Game
import Utility
import Debug

Explosion Property ExplosionEffect Auto
Sound Property SoundFX Auto

Event OnEffectStart(Actor Target, Actor Caster)
	Caster.PlaceAtMe(ExplosionEffect)
	SoundFX.Play(Target)
EndEvent