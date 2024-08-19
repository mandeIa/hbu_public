getgenv().hbu = {
    CoreSystems = {
        MainOps = {
            VelocityDynamics = "Normal",
            Framework = {
                Status = true,
                FFA_State = true,
                Authorization = {
                    License = "License",
                    Version = {1.1}
                },
                OffsetConfig = {
                    Active = false,
                    Pos = {
                        X_Coordinate = {Value = 0},
                        Y_Coordinate = {Value = 0}
                    }
                },
                TargetingMode = {
                    Primary = "Target", -- Options: "Target", "FOV"
                }
            },
            Predictive = {
                BulletTrajectory = {
                    Enabled = true,
                    HitDetection = {
                        TargetParts = {"Head", "Chest"},
                        Strategy = "NearestPoint", -- Options: "None" , "NearestPoint", "NearestPart"
                        Strategy_Mode = "1", -- Options: "1", "2"
                        Settings = {
                            Prediction = {
                                Activation = true,
                                Multiplier = 0.119
                            },
                        }
                    },
                    CursorRelation = true,
                    VisualFeedback = {
                        Active = true,
                        Customization = {
                            SizeFactor = {Value = 5},
							Color = Color3.fromRGB(255,255,255)
                        }
                    },
                    GroundImpactAvoidance = {
                        Active = false,
                        Threshold = {Value = 0.15}
                    }
                }
            }
        },
        Assistive = {
            Module = {
                TargetParts = {"Head", "Chest"},
                ActivationState = true,
                DynamicZoneState = false,
                GetNearestPartOnTargetToCursor = true,
                Guarding = {
                    Safety = true,
                    HotKey = "C",
                    PredictiveLogic = {
                        Enabled = true,
                        Factor = 0.11299513513
                    }
                },
                Control = {
                    StutterLevel = {Value = 0.3},
                    EasingMethod = "Linear"
                },
                AerialShots = {
                    SmoothFactor = {
                        GroundSmooth = 0.035
                    }
                },
                Stability = {
                    JitterControl = {
                        Active = true,
                        Axis = {
                            X_Axis = {Value = 7.5},
                            Y_Axis = {Value = 7.5},
                            Z_Axis = {Value = 7.5}
                        }
                    },
                }
            }
        },
        Validation = {
            SafetyChecks = {
                Barriers = {
                    WallDetection = false,
                    VisibilityCheck = false,
                    ForceFieldDetection = false
                },
                TeamStatus = {
                    AllyCheck = false,
                    HealthStatus = true,
                    FriendRecognition = false,
                    GroupCheck = false
                }
            }
        },
        FOVControl = {
            Settings = {
                ScopeMode = "Static", -- Options: "Static", "Dynamic"
                Zones = {
                    DynamicFieldOfView = {Value = 100},
                    SilentScope = {
                        Visibility = false,
                        FillState = true,
                        RadiusSize = {Value = 100},
						Color = Color3.fromRGB(255,255,255)
                    },
                    AimAssistScope = {
                        Visibility = false,
                        FillState = true,
                        RadiusSize = {Value = 85},
						Color = Color3.fromRGB(255,255,255)
                    },
                    DynamicRadiusScope = {
                        Visibility = false,
                        FillState = false,
                        RadiusSize = {Value = 100},
						Color = Color3.fromRGB(255,255,255)
                    }
                }
            }
        },
        Arsenal = {
            WeaponConfigs = {
				ActivationState = false,
                Loadout = {
                    DoubleBarrel = {
                        ScopeArc = {Value = 100},
                    },
                    Revolver = {
                        ScopeArc = {Value = 100},
                    },
                    TacticalSG = {
                        ScopeArc = {Value = 100},
                    }
                }
            },
            UnlockConditions = {
                OnKnockDown = true
            }
        }
    }
}
