getgenv().hbu = {
    MainTab = {
        PlayerOptions = {
            MovementControl = {
                SpeedControl = {
                    Attributes = {
                        WalkSpeedMod = {
                            Enabled = { State = true },
                            Value = { BaseValue = 30 }, -- Default value for WalkSpeed
                            MovementType = "WalkSpeed" -- {WalkSpeed , CFrame}
                        }
                    }
                },
                ThirdPersonView = {
                    Enabled = { State = false }
                }
            },
            RotationHandler = {
                Spinbot = {
                    Settings = {
                        Enabled = { State = false },
                        Speed = { Value = 10 }
                    },
                    State = { CurrentState = "Passive" }
                }
            }
        }
    },
    AssistiveTab = {
        AimSettings = {
            MainSystems = {
                SilentAim = {
                    Enabled = { State = true },
                    Prediction = {
                        PredictionControl = {
                            Enabled = { State = false },
                            Amount = { BaseValue = 1.0 }
                        }
                    },
                    Display = {
                        TargetNameType = { Current = "DisplayName" },
                        ShowTargetName = { State = false }
                    }
                }
            }
        }
    },
    EnhancementsTab = {
        WeaponEnhancements = {
            Modifications = {
                RecoilControl = {
                    NoRecoil = { State = true },
                    RecoilAmount = { BaseValue = 0 }
                },
                BulletBehavior = {
                    SpreadReduction = { State = true },
                    SpreadAmount = { BaseValue = 0 }
                },
                QuickShot = {
                    Enabled = { State = true },
                    AttackSpeed = { Value = 0 }
                }
            }
        }
    },
    SkinChangerTab = {
        WeaponSkins = {
            Enabled = { State = false },
            Skins = {
                ["Bow"] = { "Compound Bow" },
                ["Assault Rifle"] = { "AK-47" },
                ["Chainsaw"] = { "Blobsaw" },
                ["RPG"] = { "Nuke Launcher" },
                ["Burst Rifle"] = { "Aqua Burst" },
                ["Exogun"] = { "Singularity" },
                ["Fists"] = { "Boxing Gloves" },
                ["Flamethrower"] = { "Lamethrower" },
                ["Flare Gun"] = { "Dynamite Gun" },
                ["Freeze Ray"] = { "Bubble Ray" },
                ["Grenade"] = { "Water Balloon" },
                ["Grenade Launcher"] = { "Swashbuckler" },
                ["Handgun"] = { "Blaster" },
                ["Katana"] = { "Lightning Bolt" },
                ["Minigun"] = { "Lasergun 3000" },
                ["Paintball Gun"] = { "Boba Gun" },
                ["Revolver"] = { "Sheriff" },
                ["Slingshot"] = { "Goalpost" },
                ["Subspace Tripmine"] = { "Don't Press" },
                ["Uzi"] = { "Electro Uzi" },
                ["Sniper"] = { "Pixel Sniper" },
                ["Knife"] = { "Karambit" }
            }
        }
    }
}

local activeWeapons = {}
local playerName = game:GetService("Players").LocalPlayer.Name
local assetFolder = game:GetService("Players").LocalPlayer.PlayerScripts.Assets.ViewModels
local Functions = {}

local players = game:GetService("Players")
local run_service = game:GetService("RunService")
local replicated_storage = game:GetService("ReplicatedStorage")
local user_input_service = game:GetService("UserInputService")
local camera = workspace.CurrentCamera
local localplayer = players.LocalPlayer
local playerscripts = localplayer.PlayerScripts
local aa_rotation = 0

local camera_controller = require(playerscripts.Controllers.CameraController)
local constants = require(replicated_storage.Modules.CONSTANTS) -- Assuming constants.BASE_WALKSPEED is defined here
local fighter_controller = require(playerscripts.Controllers.FighterController)
local mechanics_controller = require(playerscripts.Controllers.MechanicsController)

local storage: table = {closest_player = nil}
local funcs: table = {}

run_service.Stepped:Connect(function()
    if getgenv().hbu.MainTab.PlayerOptions.MovementControl.SpeedControl.Attributes.WalkSpeedMod.Enabled.State then
        if getgenv().hbu.MainTab.PlayerOptions.MovementControl.SpeedControl.Attributes.WalkSpeedMod.MovementType == "WalkSpeed" then
            constants.BASE_WALKSPEED = getgenv().hbu.MainTab.PlayerOptions.MovementControl.SpeedControl.Attributes.WalkSpeedMod.Value.BaseValue
        elseif getgenv().hbu.MainTab.PlayerOptions.MovementControl.SpeedControl.Attributes.WalkSpeedMod.MovementType == "CFrame" then
            localplayer.Character.HumanoidRootPart.CFrame = localplayer.Character.HumanoidRootPart.CFrame + localplayer.Character.Humanoid.MoveDirection * getgenv().hbu.MainTab.PlayerOptions.MovementControl.SpeedControl.Attributes.WalkSpeedMod.Value.BaseValue
        end
    end
end)


funcs.get_players = function() 
    local player_list = {}
    for _, object in workspace:GetChildren() do
        if (object.Name:find("Dummy") or players:GetPlayerFromCharacter(object) and object.Name ~= localplayer.Name) then
            player_list[#player_list + 1] = object
        elseif object.Name == "HurtEffect" then
            for _, hurt_player in object:GetChildren() do
                player_list[#player_list + 1] = hurt_player
            end
        end
    end
    return player_list
end

funcs.get_closest_player = function()
    local closest, closest_distance = nil, math.huge
    for _, player in funcs.get_players() do
        if player:FindFirstChild("HumanoidRootPart") then
            local w2s, onscreen = camera:WorldToViewportPoint(player.HumanoidRootPart.Position)
            local distance = (Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2) - Vector2.new(w2s.X, w2s.Y)).Magnitude
            if onscreen and distance < closest_distance then
                closest = player
                closest_distance = distance
            end
        end
    end
    return closest
end

funcs.get_weapon = function(fighter)
    return fighter.EquippedItem
end

funcs.get_fighter = function(player)
    return fighter_controller:GetFighter(player)
end

funcs.calculate_prediction = function(origin_pos, end_pos, end_velocity, bullet_speed)
    if getgenv().hbu.AssistiveTab.AimSettings.MainSystems.SilentAim.Prediction.PredictionControl.Enabled.State then
        local distance = (origin_pos - end_pos).Magnitude
        local travel_time = distance / bullet_speed
        local prediction_amount = getgenv().hbu.AssistiveTab.AimSettings.MainSystems.SilentAim.Prediction.PredictionControl.Amount.BaseValue
        return end_velocity * travel_time * prediction_amount
    end
    return Vector3.new(0, 0, 0)
end

local render_stepped
render_stepped = run_service.RenderStepped:Connect(function()
    local closest = storage.closest_player
    local weapon = funcs.get_weapon(funcs.get_fighter(players.LocalPlayer))

    -- Check if third-person mode is enabled and switch the POV accordingly
    if getgenv().hbu.MainTab.PlayerOptions.MovementControl.ThirdPersonView.Enabled.State then
        camera_controller:SetPOV(false, 0, false)
    end

    if closest and closest:FindFirstChild("HumanoidRootPart") then
        local onscreen = camera:WorldToViewportPoint(closest.HumanoidRootPart.Position)
    end

    if getgenv().hbu.AssistiveTab.AimSettings.MainSystems.SilentAim.Enabled.State then
        if user_input_service:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) and (closest and weapon and weapon.Info.ProjectileSpeed) then
            local end_pos = closest.Head.Position
            local predicted_velocity = funcs.calculate_prediction(weapon.ViewModel._body_model.BodyPrimary.Position, end_pos, closest.HumanoidRootPart.Velocity, weapon.Info.ProjectileSpeed)
            local predicted_pos = closest.Head.Position + Vector3.new(predicted_velocity.X, 0, predicted_velocity.Z)
            camera_controller:MimicRotation(CFrame.new(camera.CFrame.Position, predicted_pos))
        end
    end

    storage.closest_player = funcs.get_closest_player()
end)

local old_namecall
old_namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local arguments = {...}
    local namecall_method = getnamecallmethod()
    local weapon = funcs.get_weapon(funcs.get_fighter(players.LocalPlayer))

    if namecall_method == "ViewportPointToRay" then
        if weapon and weapon.Info and weapon.Info.ProjectileSpeed then
            local closest_player = storage.closest_player
            local origin_pos = weapon.ViewModel._body_model.BodyPrimary.Position
            local predicted_velocity = funcs.calculate_prediction(origin_pos, closest_player.Head.Position, closest_player.HumanoidRootPart.Velocity, weapon.Info.ProjectileSpeed) or Vector3.zero
            local predicted_pos = closest_player.Head.Position + Vector3.new(predicted_velocity.X, 0, predicted_velocity.Z)
            return Ray.new(origin_pos, (predicted_pos - origin_pos).Unit)
        end
    elseif namecall_method == "FireServer" and self.Name == "UseItem" then
        if typeof(arguments[3]) == "table" and weapon and weapon.Info.Type then
            arguments[3]["\2"] = (weapon.Info.Type ~= "Melee") and getgenv().hbu.EnhancementsTab.WeaponEnhancements.Modifications.BulletBehavior.SpreadReduction.State
        end
    end

    return old_namecall(self, ...)
end)

local old_upd_rotation
old_upd_rotation = hookfunction(mechanics_controller._UpdateCharacterRotation, function(self)
    if getgenv().hbu.MainTab.PlayerOptions.RotationHandler.Spinbot.Settings.Enabled.State then
        if self.LocalFighter and self.LocalFighter.Entity then
            local rootpart = self.LocalFighter.Entity.RootPart
            if rootpart then
                aa_rotation += getgenv().hbu.MainTab.PlayerOptions.RotationHandler.Spinbot.Settings.Speed.Value
                rootpart.CFrame = CFrame.new(rootpart.Position) * CFrame.Angles(0, aa_rotation, 0)
            end
        end
    else
        old_upd_rotation(self)
    end
end)

local function setupGunMods()
if getgenv().hbu and
   getgenv().hbu.EnhancementsTab and
   getgenv().hbu.EnhancementsTab.WeaponEnhancements and
   getgenv().hbu.EnhancementsTab.WeaponEnhancements.Modifications and
   ((getgenv().hbu.EnhancementsTab.WeaponEnhancements.Modifications.NoRecoil and getgenv().hbu.EnhancementsTab.WeaponEnhancements.Modifications.NoRecoil.State) or
   (getgenv().hbu.EnhancementsTab.WeaponEnhancements.Modifications.SpreadReduction and getgenv().hbu.EnhancementsTab.WeaponEnhancements.Modifications.SpreadReduction.State) or
   (getgenv().hbu.EnhancementsTab.WeaponEnhancements.Modifications.QuickShot and getgenv().hbu.EnhancementsTab.WeaponEnhancements.Modifications.QuickShot.Enabled.State)) then
        local clientItemModule = require(localplayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
        local inputFunc = clientItemModule.Input
        local oldInputFunc = inputFunc

        inputFunc = function(...)
            local args = {...}
            if type(args[1]) == "table" then
                if getgenv().hbu.EnhancementsTab.WeaponEnhancements.Modifications.NoRecoil.State then
                    args[1].Info.ShootRecoil = getgenv().hbu.EnhancementsTab.WeaponEnhancements.Modifications.RecoilControl.RecoilAmount.BaseValue
                end
                if getgenv().hbu.EnhancementsTab.WeaponEnhancements.Modifications.SpreadReduction.State then
                    args[1].Info.ShootSpread = getgenv().hbu.EnhancementsTab.WeaponEnhancements.Modifications.SpreadReduction.SpreadAmount.BaseValue
                end
                if getgenv().hbu.EnhancementsTab.WeaponEnhancements.Modifications.QuickShot.Enabled.State then
                    args[1].Info.QuickShotCooldown = getgenv().hbu.EnhancementsTab.WeaponEnhancements.Modifications.QuickShot.AttackSpeed.Value
                end
            end
            return oldInputFunc(...)
        end
    end
end

setupGunMods()