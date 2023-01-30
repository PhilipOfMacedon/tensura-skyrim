Scriptname DeadEndRainbowScript Extends ActiveMagicEffect
import Game
import Utility
import Debug

Actor Property PlayerRef Auto
int Property MaxHitCount auto
Explosion Property soulExplosionEffect Auto
EffectShader Property deadBodyShader Auto
EffectShader Property HitShader Auto

Function ResetTargetAVs(Actor Target)
	Target.SetAV("variable09", 0)
	Target.SetAV("confidence", 2)
	Target.SetAV("speedmult", 100)
	Target.SetAV("weaponspeedmult", 1)
	Target.SetAV("leftweaponspeedmult", 1)
EndFunction

Event OnEffectStart(Actor Target, Actor Caster)
	If (Target != PlayerRef)
		If (Target.IsDead())
			HitShader.Stop(Target)
			ResetTargetAVs(Target)
			Utility.Wait(1)
			Dispel()
		Else
			HitShader.Play(Target, -1)
			Target.SetAV("variable09", Target.GetAV("variable09") + 1)
			If (Target.GetAV("variable09") == MaxHitCount - 1)
				Target.SetAV("confidence", 0)
			ElseIf (Target.GetAV("variable09") >= MaxHitCount)
				Bool TargetImportant = (Target.GetActorBase().IsProtected() || Target.GetActorBase().IsEssential())
				String TargetName = Target.GetDisplayName()
				If (TargetImportant && Target.GetAV("variable09") == MaxHitCount)
					Target.Kill(Caster)
					If (PlayerRef == Caster)
						debug.Notification(TargetName + " is important, hit again to apply divine justice...")
					EndIf
				Else
					If (TargetImportant)
						Target.GetActorBase().SetProtected(False)
						Target.GetActorBase().SetEssential(False)
					EndIf
					ResetTargetAVs(Target)
					HitShader.Stop(Target)
					deadBodyShader.Play(Target, 5)
					Target.Kill(Caster)
					Target.PlaceAtMe(soulExplosionEffect)
					;Target.PlaceAtMe(GetFormFromFile(0x000C9ED4, "Skyrim.ESM"));Place explosion at the target
					If (PlayerRef == Caster)
						debug.Notification("I've destroyed " + TargetName + "'s soul.")
					EndIf	
				EndIf
			EndIf
		EndIf
	Else
		debug.Notification("True Dragonborns are impervious to soul attacks.")
	EndIf
EndEvent