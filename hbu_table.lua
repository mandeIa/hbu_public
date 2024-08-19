getgenv().hbu = {
    CoreSystems = {
        MainOps = {
            VelocityDynamics = "Normal",
            Framework = {
                Status = true,
                FFA_State = true,
                Authorization = {
                    License = "License",
                    Version = {1,0,0}
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
                        TargetParts = {"Head", "Torso"},
                        Strategy = "NearestPoint", -- Options: "None" , "NearestPoint", "NearestPart"
                        Strategy_Mode = "1", -- Options: "1", "2"
                        Settings = {
                            Prediction = {
                                Activation = true,
                                Multiplier = 0.115
                            },
                            Accuracy = {
                                Chance = 100
                            }
                        }
                    },
                    CursorRelation = true,
                    VisualFeedback = {
                        Active = true,
                        Customization = {
                            SizeFactor = {Value = 2.5},
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
                TargetParts = {"Head", "Torso"},
                ActivationState = true,
                DynamicZoneState = false,
                GetNearestPartOnTargetToCursor = false,
                Guarding = {
                    Safety = true,
                    HotKey = "C",
                    PredictiveLogic = {
                        Enabled = true,
                        Factor = 0.123
                    }
                },
                Control = {
                    StutterLevel = {Value = 0.3},
                    EasingMethod = "Linear"
                },
                AerialShots = {
                    SmoothFactor = {
                        GroundSmooth = 0.025
                    }
                },
                Stability = {
                    JitterControl = {
                        Active = true,
                        Axis = {
                            X_Axis = {Value = 5},
                            Y_Axis = {Value = 5},
                            Z_Axis = {Value = 5}
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
                        RadiusSize = {Value = 100}
                    },
                    AimAssistScope = {
                        Visibility = false,
                        FillState = true,
                        RadiusSize = {Value = 85}
                    },
                    DynamicRadiusScope = {
                        Visibility = false,
                        FillState = false,
                        RadiusSize = {Value = 100}
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
                        AccuracyFactor = {
                            Chance = {Value = 100}
                        },
                    },
                    Revolver = {
                        ScopeArc = {Value = 100},
                        AccuracyFactor = {
                            Chance = {Value = 100}
                        },
                    },
                    TacticalSG = {
                        ScopeArc = {Value = 100},
                        AccuracyFactor = {
                            Chance = {Value = 100}
                        },
                    }
                }
            },
            UnlockConditions = {
                OnKnockDown = true
            }
        }
    }
}
