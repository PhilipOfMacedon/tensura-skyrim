Scriptname DemonLordsHakiActivationScript extends activemagiceffect  
{Simple script to call the main Demon Lord's Haki spell delayed.}

Import Utility

Spell Property DemonLordsHaki Auto
GlobalVariable Property DemonLordsHakiToggleGlobal Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If DemonLordsHakiToggleGlobal.GetValue() == 0.0
		Utility.Wait(0.25)
	EndIf
	DemonLordsHaki.Cast(akCaster, akCaster)
EndEvent