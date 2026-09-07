

#property copyright "© Copyright Aime"
#property version "45.52"
#property description "Auto Trading EA Robot with Comprehensive Features"
#property description ""
#property description "This is an open-source project for ready-production and real-money"
#property description "Source: Aime Programmer"
#property description ""
#property description "No guarantee of profitability. Use at your own risk. Past performance ≠ future results"
#property description "Built with significant effort, please use and share respectfully"
#property description "I do not sell this EA myself. If sold under my name, treat it as a scam and report it"
#property description "Built and maintained by Aime"
#property strict

#define MT_WMCMD_EXPERTS 32851
#define WM_COMMAND 0x0111
#define GA_ROOT 2
#include <WinAPI\winapi.mqh>
#include <Trade\Trade.mqh>

#include <Controls\Dialog.mqh>
#include <Controls\Edit.mqh>
#include <Controls\Button.mqh>
#include <Controls\Label.mqh>

#define LogPrint if(EnableLogging) Print

enum ENUM_INPUT_TYPE
{
    INPUT_DOLLAR,
    INPUT_PERCENT,
    INPUT_POINTS
};

enum ENUM_RR_RISK_MODE
{
    RR_RISK_MANUAL,
    RR_RISK_ATR
};

enum ENUM_LIMIT_ANCHOR
{
    LIMIT_ANCHOR_FIXED_ATR,
    LIMIT_ANCHOR_EMA,
    LIMIT_ANCHOR_SWING,
    LIMIT_ANCHOR_SMART
};
enum ENUM_AIME_LANGUAGE { AIME_LANG_EN, AIME_LANG_FR, AIME_LANG_RW };
input ENUM_AIME_LANGUAGE DashboardLanguage = AIME_LANG_EN;

input group "+-----------------------------------------+"
input group " Aime Programmer v45.51"
input group " © Copyright Aime"
input group "+-----------------------------------------+"

input group "📊 Indicator Settings"
input int DirectionalBodyLookback = 10;
input int EMAFastPeriod = 5;
input int EMASlowPeriod = 12;
input int SlopeLookback = 3;
input int RSIPeriod = 8;
input int ATRPeriod = 8;
input int ATRAvgLookback = 10;
input double MinVolRatioToTrade = 0.6;
input int ImpulseLookback = 3;
input double ImpulseBoostWeight = 1.0;
input int SignalSmoothingCandles = 3;
input double CurrentCandleBlend = 0.0;
input bool EnableDirectionalEdgeFilter = true;
input double MinimumDirectionalEdge = 0.75;
input bool EnableCandleDirectionFilter = true;
input double MinimumBodyDirectionRatio = 0.55;
input double VelocityWindow = 2.0;
input int RSIOverbought = 80;
input int RSIOversold = 20;
input int RSIMomentumBuy = 60;
input int RSIMomentumSell = 40;

input group "⚖️ Score Weight Settings"
input double TrendWeight = 1.5;
input double SlopeWeight = 1.5;
input double MomentumBaseWeight = 1.0;
input double MomentumTriggerWeight = 0.5;
input double BodyMomentumWeight = 1.5;
input double ChopScoreHigh = 2.0;
input double ChopScoreMed = 1.0;
input double ChopScoreLow = 0.0;
input double VolatilityScoreHigh = 1.0;
input double VolatilityScoreLow = 0.0;
input double PeakScoreWeight = 1.0;
input double WickRejectionWeight = 1.0;
input double MinBodyRatio = 1.5;

input group "📝 Order & Position Settings"
input bool EnableBuyOrders = true;
input bool EnableSellOrders = true;
input bool EnableNewBarEntryOnly = true;
input int EntryRetrySeconds = 5;
input bool EnableMaxSpreadFilter = true;
input double MaxSpreadPoints = 0;
input double MaxSpreadATRRatio = 0.25;
input double SpreadSoftMultiplier = 1.50;
input double SpreadHardMultiplier = 2.00;
input double SpreadSoftSignalBuffer = 0.50;
input double BaseLotSize = 0.01;
input int MaxOpenOrders = 8;
input int MaxTradesPerCandle = 1;
input double ConsecutiveCandleThresholdBoost = 1.0;
input int MaxConsecutiveCandleBoosts = 3;
input double ZonePoints = 500;
input double BuyDuplicateMultiplier = 1.5;
input double SellDuplicateMultiplier = 1.5;
input double MinBreakEvenProfit = 0.5;
input double ProfitThresholdMultiplier = 1.5;
input double LossThresholdMultiplier = 2.0;
input double MinBuySignalScore = 4.5;
input double MinSellSignalScore = 4.5;

input group "🎯 Asset-Class Signal Profiles"
input bool EnableAssetClassProfiles = true;
input double FXBuySignalThreshold = 4.5;
input double FXSellSignalThreshold = 4.5;
input double MetalBuySignalThreshold = 4.0;
input double MetalSellSignalThreshold = 4.0;
input double IndexBuySignalThreshold = 4.0;
input double IndexSellSignalThreshold = 4.0;
input double StockBuySignalThreshold = 4.5;
input double StockSellSignalThreshold = 4.5;
input double CryptoBuySignalThreshold = 5.0;
input double CryptoSellSignalThreshold = 5.0;
input group "Regime-Aware Strategy Controls"
input bool EnableRegimeAwareStrategy = true;
input double TrendThresholdMultiplier = 0.95;
input double BreakoutThresholdMultiplier = 1.00;
input double RangeThresholdMultiplier = 1.10;
input double HighVolThresholdMultiplier = 1.10;
input double LowVolThresholdMultiplier = 1.30;
input double TrendMinEdgeBoost = 0.20;
input double BreakoutMinEdgeBoost = 0.35;
input double RangeMinEdgeBoost = 0.25;
input double HighVolMinEdgeBoost = 0.35;
input double MinATRRatioForTrendEntry = 0.85;
input double MaxATRRatioForRangeEntry = 1.35;
input double BreakoutBodyRatioMinimum = 1.05;
input double RangeRSIMidpointTolerance = 8.0;
input bool EnableRangeMomentumContinuation = true;
input double RangeContinuationMinScore = 5.50;
input double RangeContinuationMinEdge = 1.50;
input double RangeContinuationMinBodyRatio = 0.65;
input double RangeContinuationMinMomentum = 1.00;
input double FXSpreadATRRatio = 0.25;
input double MetalSpreadATRRatio = 0.40;
input double IndexSpreadATRRatio = 0.35;
input double StockSpreadATRRatio = 0.35;
input double CryptoSpreadATRRatio = 0.50;
input double FXMinVolRatio = 0.60;
input double MetalMinVolRatio = 0.50;
input double IndexMinVolRatio = 0.50;
input double StockMinVolRatio = 0.60;
input double CryptoMinVolRatio = 0.50;

input group "🧠 Institutional Strategy Core"
input bool EnableInstitutionalStrategyCore = true;
input double MinDirectionalEdge = 0.75;
input double MinSetupQuality = 0.60;
input double MinTimingQuality = 0.35;
input double RangeMinDirectionalEdge = 1.00;
input double HighVolMinVelocity = 0.55;
input double TrendSeparationATR = 0.80;
input double TrendSlopeATR = 0.12;
input double LowVolATRRatio = 0.65;
input double HighVolATRRatio = 1.60;
input double BreakoutATRExpansion = 1.15;
input double MinBodyToAverageRatio = 0.65;
input bool EnableConcentrationGuard = true;
input int MaxConcurrentFXPositions = 6;
input int MaxConcurrentMetalPositions = 1;
input int MaxConcurrentIndexPositions = 2;
input int MaxConcurrentStockPositions = 3;
input int MaxConcurrentCryptoPositions = 1;
input group "📊 Per-Asset-Class Risk Caps (% of equity, independent of position-count caps above)"
input double MaxFXClassRiskPct = 3.0;      
input double MaxMetalClassRiskPct = 1.5;
input double MaxIndexClassRiskPct = 1.5;
input double MaxStockClassRiskPct = 2.0;   
input double MaxCryptoClassRiskPct = 1.0;  
input group "🧠 Multi-Timeframe Confirmation"
input bool EnableHigherTimeframeConfirmation = true;
input bool RequireHigherTimeframeAlignment = true;
input int ConfirmationFastEMAPeriod = 20;
input int ConfirmationSlowEMAPeriod = 50;
input int ConfirmationRSIPeriod = 14;
input group "Unified Portfolio Decision Engine"
input bool EnablePortfolioCorrelationGuard = true;
input double MaxPortfolioCorrelation = 0.78;
input int CorrelationLookbackBars = 40;
input int MinimumCorrelationBars = 25;
input bool EnableSignalFreshnessGuard = true;
input int MaxSignalAgeBars = 1;
input bool EnableTransitionRegimeGuard = true;
input double TransitionSeparationFraction = 0.50;
input double TransitionRSITolerance = 6.0;
input bool EnableComponentQualityGate = true;
input double MinTrendComponentQuality = 0.45;
input double MinMomentumComponentQuality = 0.40;
input bool EnableStructureAwareStops = true;
input int StructureSLLookback = 20;
input double StructureSLATRMultiplier = 1.20;
input double StructureSLBufferATR = 0.10;
input bool EnablePreTradeRiskRewardGate = true;
input double MinimumEntryRR = 1.50;
input double PreTradeTPATRMultiplier = 2.20;
input bool EnableExecutionFeedback = true;
input double ExecutionSlippageWarningPoints = 0.0;

input group "🎯 Limit Entry Settings"
input bool EnableLimitEntry = false;
input ENUM_LIMIT_ANCHOR LimitEntryAnchor = LIMIT_ANCHOR_FIXED_ATR;
input double LimitEntryATRFraction = 0.25;
input int LimitEntryExpiryBars = 1;
input bool LimitEntryCancelOnFlip = true;

input group "🛡️ Signal Dampening Settings"
input bool EnableSignalDampening = true;
input int MaxLosingPositionsSameDir = 2;
input double LosingPosScorePenalty = 1.5;
input double DrawdownThresholdPct = 3.0;
input double DrawdownScoreBoost = 2.0;
input int ConsecutiveLossesBeforeCooldown = 3;
input int ConsecutiveLossCooldownBars = 3;

input group "🩺 Loss Management Settings"
input bool EnableLossManagement = true;
input int MaxHoldingLossPositions = 2;
input double MinHealthScore = 0.40;
input double MaxAdverseATR = 1.5;
input double HealthTrendWeight = 0.40;
input double HealthRSIWeight = 0.25;
input double HealthATRWeight = 0.25;
input double HealthSwingWeight = 0.10;
input double HealthRSIBuyMin = 40.0;
input double HealthRSISellMax = 60.0;
input int HealthSwingLookback = 20;
input int HealthGraceBars = 2;
input bool EnablePartialClose = true;
input double PartialClose75Pct = 0.25;
input double PartialClose50Pct = 0.50;
input double PartialClose25Pct = 1.00;
input bool EnableHealthSLTightening = true;
input double SLTightenATRMultiplier = 2.0;
input double SLTightenMinHealthPct = 0.50;
input bool EnableBreakEvenOnSpread = true;
input double BreakEvenSpreadMultiplier = 1.5;
input double BreakEvenTriggerRMultiple = 0.5;  
input bool EnableVirtualSLReentry = false;
input bool ReentryRespectsNewBarGate = false;
input double ReentryMinSignalPct = 0.75;
input bool EnableProfitOffsetSL = true;
input int ConsecutiveWinsRequired = 3;
input double MinOffsetProfit = 1.0;

input group "Position Lifecycle Controls"
input bool EnableMaximumHoldingTime = false;
input int MinimumHoldingMinutes = 300;
input int MaximumHoldingMinutes = 1440;
input bool CloseAtMaximumHoldingTime = false;
input bool ProtectOpenPositionsFromNewEntryCooldown = true;

input group "🔀 Hedge Chain Settings"
input bool EnableHedgeChain = false;
input double HedgeTriggerATR = 1.5;
input bool HedgeRequireSignal = true;
input double HedgeMinSignalScore = 4.5;
input bool HedgeAutoLot = true;
input double HedgeRecoveryATR = 1.0;
input double HedgeLotMultiplier = 2.0;
input double HedgeMaxLot = 0.10;
input double HedgeRecoveryPct = 110.0;
input double HedgeRollMinProfit = 0.5;
input int HedgeCycleLevels = 2;
input bool EnableHedgeCycleReset = false;
input double HedgeCyclePartialPct = 50.0;
input int HedgeMaxCycles = 3;
input double HedgeMaxChainLossUSD = 0.0;
input double HedgeMaxChainLossPct = 0.0;
input bool HedgeClearRootSL = true;
input double HedgeTrailATR = 0.5;

input group "🧮 Dynamic Lot Sizing Settings"
input bool EnableDynamicLots = true;
input double EquityDropPercent = 5.0;
input int MaxEquityDropLotSteps = 2;
input double MinSignalStrengthForLot = 8.0;
input double LotStepSize = 0.01;
input double MaxLotSize = 0.05;
input group "🛑 Hard Safety Ceiling (last line of defense — independent of strategy sizing)"
input group "📈 Performance Feedback Gate (NEW — the strategy learning from its own results)"
input bool EnablePerformanceGate = true;
input int MinTradesForPerformanceGate = 20;     
input double MinAcceptableProfitFactor = 0.80;  
input int PerformanceGateRecalcSeconds = 300;   
input double HardAbsoluteMaxLotPerTrade = 0.20;   
input double HardAbsoluteMaxTotalLots = 1.00;     
input double HardAbsoluteMaxAccountRiskPct = 3.0; 

input group "🏦 Equity Settings"
input bool EnableBasketStop = true;
input double MaxBasketLossPct = 8.0;
input double MinEquityPercent = 70.0;
input double MaxDrawdownFromPeak = 0;
input int PauseMinutes = 5;
input double PauseMinutesMultiplier = 1.5;
input int MaxPauseMinutes = 120;
input int MaxMinEquityTriggers = 0;
input bool ResetOnNewPeak = true;
input double TargetEquity = 0;
input double MinimumEquity = 20;

input group "🛡️ Global Risk Governor Settings"
input bool EnableRiskGovernor = true;
input double RiskPerTradePct = 0.25;
input double MaxPortfolioOpenRiskPct = 2.00;
input int MaxPositionsPerSymbol = 1;
input double DailyLossEntryBlockPct = 2.00;
input double DailyLossHardStopPct = 3.00;
input double DrawdownEntryBlockPct = 4.00;
input double DrawdownHardStopPct = 6.00;
input double MarginWarningLevel = 500.0;
input double MarginEntryBlockLevel = 400.0;
input double MarginEmergencyLevel = 300.0;
input bool RiskGovernorRequireStopLoss = true;
input bool RiskGovernorRequireAllPositionsProtected = true;
input bool RiskGovernorFlattenOnDailyHardStop = true;
input bool RiskGovernorFlattenOnDrawdownHardStop = true;
input bool RiskGovernorFlattenOnMarginEmergency = true;
input bool RiskGovernorBlockAfterDailyLoss = true;

input group "🧭 Portfolio Intelligence Settings"
input bool EnablePortfolioIntelligence = true;
input double MaxAssetClassRiskPct = 1.25;
input double MaxExposureFamilyRiskPct = 1.75;
input double MaxCurrencyDirectionalRiskPct = 1.50;
input bool BlockOpposingCurrencyOverload = true;
input double MinimumRiskForPortfolioAttribution = 0.01;

input group "📈 Take Profit Settings"
input bool EnableTakeProfit = false;
input ENUM_INPUT_TYPE TPInputType = INPUT_DOLLAR;
input double TPValue = 10.0;

input group "📉 Stop Loss Settings"
input bool EnableStopLoss = true;
input ENUM_INPUT_TYPE SLInputType = INPUT_PERCENT;
input double SLValue = 10.0;

input group "⚖️ Risk:Reward Settings"
input bool EnableRiskReward = true;  
input ENUM_RR_RISK_MODE RRRiskMode = RR_RISK_ATR;
input ENUM_INPUT_TYPE RRRiskInputType = INPUT_POINTS;
input double RRRiskValue = 200.0;
input double RRAtrMultiplier = 1.5;
input double RiskRewardRatio = 1.5;

input group "💸 Trailing TP/SL Settings"
input bool EnableTrailing = true;
input bool EnableATRProfitTrail = true;
input double ATRProfitTrailStartR = 1.15;
input double ATRProfitTrailMultiplier = 1.10;
input bool EnableProfitLock = true;
input double ProfitLockTriggerR = 0.90;
input double ProfitLockATRBuffer = 0.08;
input bool TrailingEnableBreakEvenLock = true;
input bool TrailingSLOnProfitableOnly = true;
input bool EnableAdaptiveTP = true;
input bool EnableAdaptiveSL = true;
input ENUM_INPUT_TYPE TSInputType = INPUT_DOLLAR;
input double TrailingDistanceValue = 0.2;
input double TrailingValueMultiplier = 0.2;

input group "🤖 Dynamic Trade Identity"
input long DynamicMagicBase = 6927000;
input bool AcceptLegacyMagicNumbers = true;
input bool ShowExternalPositions = true;
input bool BlockEntriesOnUnprotectedExternalPositions = false;
input string LegacyManagedMagicNumbers = "";

input bool EnableDiscordAlerts = false;
input string DiscordWebhookURL = "";
input bool EnableTradingHours = false;
input string TradingStartTime = "00:00";
input string TradingEndTime = "23:59";
input bool EnableReports = true;
input int SendReportEveryHour = 1;
input bool EnableMarketCloseFilter = true;
input int MinutesBeforeClose = 30;
input bool EnableNewsFilter = true;
input int NewsMinutesBefore = 30;
input int NewsMinutesAfter = 30;
input bool EnableLeveragePause = true;
input bool EnableLogging = false;
input bool EnableTradeSounds = true;
input bool EnableThemeToggle = true;

input group "🌐 Multi-Asset Engine Settings"
input bool EnableMultiAsset = true;
input string MultiAssetSymbols = "";
input ENUM_TIMEFRAMES MultiAssetTimeframe = PERIOD_CURRENT;
input int MultiAssetTimerSeconds = 1;
input bool EnableDashboardAutoScroll = false;
input int DashboardAutoScrollSeconds = 0;
input bool IncludeChartSymbolAutomatically = true;
input bool SkipUnavailableSymbols = true;
input bool EnableMarketWatchDiscovery = true;
input int MarketWatchScanSeconds = 10;
input int AssetHealthFailureThreshold = 5;   
input int MaxDiscoveredAssets = 50;          
input bool EnablePortfolioPositionLimit = true;
input int MaxPortfolioPositions = 12;

input group "🧯 Recovery & Execution Protection"
input bool EnableRecoveryEngine = false;
input double RecoveryStartDrawdownPct = 1.50;
input double RecoveryMaxEntryDrawdownPct = 4.00;
input double RecoveryRiskMultiplier = 0.60;
input double RecoveryMaxRiskPct = 0.15;
input double RecoveryBudgetPct = 0.75;
input double RecoveryMinSignalMultiplier = 1.15;
input double RecoveryMinRR = 1.50;
input int RecoveryMaxConsecutiveLosses = 2;
input bool RecoveryRequireTrendAlignment = true;
input bool RecoveryDisableHedgeEscalation = true;
input bool RecoveryStopAfterBudget = true;
input int GlobalTradeLockSeconds = 3;
input int EntryFingerprintSeconds = 10;
input int DashboardMaxTickAgeSeconds = 5;
input bool EnableDecisionTrace = true;
input bool EnableDecisionTraceLogging = false;

input group "🌐 24/7 Crypto & Stock Engine Settings"
input bool EnableCryptoTrading = true;
input string CryptoSymbols = "";
input bool EnableStockTrading = true;
input string StockSymbols = "";
input bool EnableIndexTrading = true;
input string IndexSymbols = "";
input bool EnableSessionBoost = true;
input string SessionBoostStart = "15:00";
input string SessionBoostEnd = "19:00";
input double SessionBoostMultiplier = 1.0;

const string EA_PASSWORD = "";

CDialog passwordDialog;
CEdit passwordEdit;
CButton passwordSubmitBtn;
bool passwordVerified = false;
bool passwordDialogActive = false;

double initialBalance = 0;
double peakEquity = 0;
double lastPeakEquity = 0;
bool targetEquityReached = false;
bool minimumEquityReached = false;
bool minEquityTriggersExceeded = false;
int minEquityTriggerCount = 0;
bool isPaused = false;
int currentPauseDuration = 0;
datetime pauseStartTime = 0;
string g_pauseReason = "NONE";
datetime g_pauseUntil = 0;
bool g_pauseTemporary = false;
bool isOutsideTradingHours = false;
bool isLeverageDiffFromInitial = false;
bool isNearMarketClose = false;
ulong lastProcessedNewsEventID = 0;
string symbolBaseCurrency = "";
string symbolQuoteCurrency = "";
long initialLeverage = 0;
bool isOrderSendLocked = false;
bool marketCloseAlertSent = false;
bool algoTradingStatus = false;

double normHealthTrendWeight = 0;
double normHealthRSIWeight = 0;
double normHealthATRWeight = 0;
double normHealthSwingWeight = 0;

bool g_riskEntryBlocked = false;
bool g_riskHardLocked = false;
bool g_dailyRiskLocked = false;
bool g_peakRiskLocked = false;
int g_riskDayCode = 0;
double g_dayStartBalance = 0.0;
double g_dailyNetPL = 0.0;
double g_dailyLossPct = 0.0;
double g_peakDrawdownPct = 0.0;
double g_marginLevel = 0.0;
double g_portfolioOpenRiskMoney = 0.0;
double g_portfolioOpenRiskPct = 0.0;

datetime startTime = 0;
datetime lastDailyReportTime = 0;
double lastReportEquity = 0;

int totalPauseCount = 0;
double totalPauseDurationMinutes = 0;

int emaFastHandle = INVALID_HANDLE;
int emaSlowHandle = INVALID_HANDLE;
int rsiHandle = INVALID_HANDLE;
int atrSignalHandle = INVALID_HANDLE;

struct SignalStrength
{
    double avgBody;
    double bodySignal;
    double ratio;
    double upperWick;
    double lowerWick;
    double rejection;
    double penaltyBody;
    double penaltyWick;
    double finalScore;
    double trendScore;
    double momentumScore;
    double chopScore;
    double peakScore;
    double volatilityScore;
    double impulseStrength;
    double velocity;
    double normalizedVelocity;
    string reasoning;
};

struct PositionHealth
{
    double healthScore;
    bool trendValid;
    bool momentumValid;
    double adverseATR;
    bool swingValid;
    bool inGracePeriod;
    string reason;
};

struct ManagedPosition
{
    ulong ticket;
    ENUM_POSITION_TYPE type;
    double signalScore;
    double entryPrice;
    int partialCloseLevel;
    bool breakEvenLocked;
    int profitOffsetConsecWins;
    double profitOffsetAccumulated;
    double profitOffsetOriginalSL;
    ulong chainId;
    int hedgeLevel;
    double chainAnchorLoss;
    int cycleNum;
    bool noRehedge;
    bool hedgeGraduated;
    double hedgeLockProfit;
};

ManagedPosition managedPositions[];
int managedPositionCount = 0;

datetime currentBarTime = 0;
int buysOnCurrentBar = 0;
int sellsOnCurrentBar = 0;

datetime lastEntryBarTime = 0;

int consecutiveBuyCandles = 0;
int consecutiveSellCandles = 0;
bool prevBarHadBuys = false;
bool prevBarHadSells = false;

int consecutiveLossCount = 0;
datetime cooldownUntilBarTime = 0;

datetime lastBuyTime = 0;
double lastBuyPrice = 0;
datetime lastSellTime = 0;
double lastSellPrice = 0;

double lastBuySignalScore = 0;
double lastBuySignalScorePrev = 0;
double lastBuyVelocity = 0;
double lastBuyNormalizedVelocity = 0;

double lastSellSignalScore = 0;
double lastSellSignalScorePrev = 0;
double lastSellVelocity = 0;
double lastSellNormalizedVelocity = 0;

bool _buyStrengthValid = false;
bool _sellStrengthValid = false;
SignalStrength _cachedBuyStrength;
SignalStrength _cachedSellStrength;
datetime buyStrengthCacheBarTime = 0;
datetime sellStrengthCacheBarTime = 0;
string buyStrengthCacheSymbol = "";
string sellStrengthCacheSymbol = "";

double g_lastExecutionSlippagePoints = 0.0;
string g_lastExecutionStatus = "NONE";
int g_executionSuccessCount = 0;
int g_executionRejectCount = 0;
datetime g_lastExecutionTime = 0;

string g_strategyRegime = "UNINITIALIZED";
string g_strategyDirection = "WAIT";
string g_strategyFinalDecision = "WAIT";
string g_strategyReason = "SIGNAL PENDING";
double g_strategyEdge = 0.0;
double g_strategySetupQuality = 0.0;
double g_strategyTimingQuality = 0.0;
bool g_strategyDataReady = false;
bool g_strategySetupPass = false;
bool g_strategyTimingPass = false;
string g_strategyDecisionTrace = "";
string g_strategyDecisionStage = "INIT";

struct TradeStats
{
    int count;
    int won;
    int lost;
    double profit;
    double loss;
    double avgProfit;
    double maxProfit;
    double minProfit;
    double avgLoss;
    double maxLoss;
    double minLoss;
};

TradeStats g_cachedDailyStats;
TradeStats g_cachedAllTimeStats;
datetime g_tradeStatsCacheTime=0;
bool g_tradeStatsCacheValid=false;

struct AssetContext
{
    string symbol;
    long magicNumber;
    ENUM_TIMEFRAMES period;
    bool initialized;
    bool quarantined;
    string quarantineReason;
    int consecutiveHealthFailures;   
    double perfProfitFactor;         
    int perfTradeCount;              
    datetime perfLastCalcTime;       
    string baseCurrency;
    string quoteCurrency;
    bool outsideTradingHours;
    bool nearMarketClose;
    bool orderSendLocked;
    bool marketCloseAlertSent;
    int emaFastHandle;
    int emaSlowHandle;
    int rsiHandle;
    int atrSignalHandle;
    ManagedPosition positions[];
    int positionCount;
    datetime currentBarTime;
    int buysOnCurrentBar;
    int sellsOnCurrentBar;
    datetime lastEntryBarTime;
    int consecutiveBuyCandles;
    int consecutiveSellCandles;
    bool prevBarHadBuys;
    bool prevBarHadSells;
    int consecutiveLossCount;
    datetime cooldownUntilBarTime;
    datetime lastBuyTime;
    double lastBuyPrice;
    datetime lastSellTime;
    double lastSellPrice;
    double lastBuySignalScore;
    double lastBuySignalScorePrev;
    double lastBuyVelocity;
    double lastBuyNormalizedVelocity;
    double lastSellSignalScore;
    double lastSellSignalScorePrev;
    double lastSellVelocity;
    double lastSellNormalizedVelocity;
    bool buyStrengthValid;
    bool sellStrengthValid;
    SignalStrength cachedBuyStrength;
    SignalStrength cachedSellStrength;
    datetime buyStrengthCacheBarTime;
    datetime sellStrengthCacheBarTime;
    string buyStrengthCacheSymbol;
    string sellStrengthCacheSymbol;
    string strategyRegime;
    string strategyDirection;
    string strategyFinalDecision;
    string strategyReason;
    double strategyEdge;
    double strategySetupQuality;
    double strategyTimingQuality;
    bool strategyDataReady;
    bool strategySetupPass;
    bool strategyTimingPass;
    string decisionTrace;
    string decisionStage;
    string dataState;
    string dataReason;
    datetime dataLastCheck;
    datetime dataLastReady;
    int dataFailureCount;
    int dataBars;
    bool seriesSynchronized;
    bool indicatorsReady;
    bool feedInitialized;
    bool feedLive;
    long feedLastTickTimeMsc;
    datetime feedLastTickTime;
    double feedLastBid;
    double feedLastAsk;
    ulong feedLastChangeMs;
    datetime feedLastObservedServerTime;
    datetime feedLastBarTime;
    long feedLastBarAgeSeconds;
};

AssetContext g_assets[];
int g_assetCount = 0;
int g_activeIndex = -1;
string g_activeSymbol = "";
ENUM_TIMEFRAMES g_activePeriod = PERIOD_CURRENT;
string g_chartSymbol = "";
ENUM_TIMEFRAMES g_chartPeriod = PERIOD_CURRENT;
bool g_multiAssetInitialized = false;
bool g_portfolioCycleRunning = false;
datetime g_lastPortfolioCycle = 0;
datetime g_lastDashboardScroll = 0;
bool g_emergencyStop = false;
string g_emergencyStopReason = "";
string g_dashboardSelectedSymbol = "";
ulong g_dashboardSelectedPositionTicket = 0;
bool g_darkTheme = true;
datetime g_lastPositionReconcile = 0;
datetime g_lastMarketWatchScan = 0;
bool g_executionCycleRunning = false;
bool g_uiUpdatePending = false;
datetime g_lastEntryAttemptTime = 0;
datetime g_lastEntryAttemptBarTime = 0;
double g_recoveryDebt = 0.0;
double g_recoveryRecovered = 0.0;
double g_recoveryBudgetUsed = 0.0;
datetime g_recoveryCycleStart = 0;
string g_recoveryMode = "NORMAL";
double g_recoveryStartEquity = 0.0;

bool g_accountSnapshotValid = false;
string g_accountSnapshotState = "ACCOUNT DATA UNAVAILABLE";
string g_accountSnapshotReason = "NOT INITIALIZED";
datetime g_accountSnapshotTime = 0;
double g_accountBalanceLive = 0.0;
double g_accountEquityLive = 0.0;
double g_accountFreeMarginLive = 0.0;
double g_accountMarginLive = 0.0;
double g_accountMarginLevelLive = 0.0;
long g_accountLeverageLive = 0;
string g_accountCurrencyLive = "";
string g_protectionState = "NORMAL";
string g_protectionReason = "NONE";
string g_emergencySource = "";

int g_dashPage = 0;
int g_assetFilter = 0;
const int ROWS_PER_PAGE = 5;
int g_dashTab = 0;
bool g_dashMinimized = false;
int g_assetScrollOffset = 0;
bool g_dashboardInitialized = false;
bool g_dashboardRendering = false;
datetime g_lastDashboardUpdate = 0;
MqlTick tick;
struct DashboardPositionSnapshot
{
    ulong ticket;
    string symbol;
    long magic;
    ENUM_POSITION_TYPE type;
    double volume;
    double profit;
    double entryPrice;
    double stopLoss;
    double takeProfit;
    datetime openTime;
};

DashboardPositionSnapshot g_dashboardPositions[];
int g_dashboardPositionCount = 0;
double g_dashboardPositionTotalPL = 0.0;
int g_terminalPositionCount = 0;
int g_externalPositionCount = 0;
int g_externalUnprotectedPositionCount = 0;
double g_externalPositionTotalPL = 0.0;

bool AimeDashboardPositionOwned(ulong ticket)
{
    if(ticket == 0 || !PositionSelectByTicket(ticket)) return false;

    string symbol = PositionGetString(POSITION_SYMBOL);
    long magic = (long)PositionGetInteger(POSITION_MAGIC);
    if(symbol == "" || magic <= 0) return false;

    if(IsAimeMagic(magic)) return true;

    long expectedMagic = GetMagicForSymbol(symbol);
    return expectedMagic > 0 && magic == expectedMagic;
}

void AimeRefreshDashboardPositionSnapshot()
{
    ArrayResize(g_dashboardPositions, 0);
    g_dashboardPositionCount = 0;
    g_dashboardPositionTotalPL = 0.0;
    g_terminalPositionCount = 0;
    g_externalPositionCount = 0;
    g_externalUnprotectedPositionCount = 0;
    g_externalPositionTotalPL = 0.0;

    int total = PositionsTotal();
    for(int i = total - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;

        g_terminalPositionCount++;

        double positionPL = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
        bool owned = AimeDashboardPositionOwned(ticket);

        if(!owned)
        {
            g_externalPositionCount++;
            g_externalPositionTotalPL += positionPL;
            if(PositionGetDouble(POSITION_SL) <= 0.0)
                g_externalUnprotectedPositionCount++;
            continue;
        }

        int n = g_dashboardPositionCount;
        ArrayResize(g_dashboardPositions, n + 1);

        g_dashboardPositions[n].ticket = ticket;
        g_dashboardPositions[n].symbol = PositionGetString(POSITION_SYMBOL);
        g_dashboardPositions[n].magic = (long)PositionGetInteger(POSITION_MAGIC);
        g_dashboardPositions[n].type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        g_dashboardPositions[n].volume = PositionGetDouble(POSITION_VOLUME);
        g_dashboardPositions[n].profit = positionPL;
        g_dashboardPositions[n].entryPrice = PositionGetDouble(POSITION_PRICE_OPEN);
        g_dashboardPositions[n].stopLoss = PositionGetDouble(POSITION_SL);
        g_dashboardPositions[n].takeProfit = PositionGetDouble(POSITION_TP);
        g_dashboardPositions[n].openTime = (datetime)PositionGetInteger(POSITION_TIME);

        g_dashboardPositionTotalPL += g_dashboardPositions[n].profit;
        g_dashboardPositionCount++;
    }
}

int AimeDashboardPositionCountForSymbol(string symbol)
{
    int count = 0;
    for(int i = 0; i < g_dashboardPositionCount; i++)
        if(g_dashboardPositions[i].symbol == symbol)
            count++;
    return count;
}

double ActivePoint()
{
    return SymbolInfoDouble(g_activeSymbol, SYMBOL_POINT);
}

int ActiveDigits()
{
    return (int)SymbolInfoInteger(g_activeSymbol, SYMBOL_DIGITS);
}

void ResetActiveRuntimeState()
{
    symbolBaseCurrency = "";
    symbolQuoteCurrency = "";
    isOutsideTradingHours = false;
    isNearMarketClose = false;
    isOrderSendLocked = false;
    marketCloseAlertSent = false;
    emaFastHandle = INVALID_HANDLE;
    emaSlowHandle = INVALID_HANDLE;
    rsiHandle = INVALID_HANDLE;
    atrSignalHandle = INVALID_HANDLE;
    ArrayResize(managedPositions, 0);
    managedPositionCount = 0;
    currentBarTime = 0;
    buysOnCurrentBar = 0;
    sellsOnCurrentBar = 0;
    lastEntryBarTime = 0;
    consecutiveBuyCandles = 0;
    consecutiveSellCandles = 0;
    prevBarHadBuys = false;
    prevBarHadSells = false;
    consecutiveLossCount = 0;
    cooldownUntilBarTime = 0;
    lastBuyTime = 0;
    lastBuyPrice = 0;
    lastSellTime = 0;
    lastSellPrice = 0;
    lastBuySignalScore = 0;
    lastBuySignalScorePrev = 0;
    lastBuyVelocity = 0;
    lastBuyNormalizedVelocity = 0;
    lastSellSignalScore = 0;
    lastSellSignalScorePrev = 0;
    lastSellVelocity = 0;
    lastSellNormalizedVelocity = 0;
    _buyStrengthValid = false;
    _sellStrengthValid = false;
    buyStrengthCacheBarTime = 0;
    sellStrengthCacheBarTime = 0;
    buyStrengthCacheSymbol = "";
    sellStrengthCacheSymbol = "";
    g_strategyRegime = "UNINITIALIZED";
    g_strategyDirection = "WAIT";
    g_strategyFinalDecision = "WAIT";
    g_strategyReason = "SIGNAL PENDING";
    g_strategyEdge = 0.0;
    g_strategySetupQuality = 0.0;
    g_strategyTimingQuality = 0.0;
    g_strategyDataReady = false;
    g_strategySetupPass = false;
    g_strategyTimingPass = false;
    g_strategyDecisionTrace = "";
    g_strategyDecisionStage = "INIT";
}

void LoadAssetContext(int index)
{
    if(index < 0 || index >= g_assetCount) return;
    g_activeIndex = index;
    g_activeSymbol = g_assets[index].symbol;
    g_activePeriod = g_assets[index].period;

    symbolBaseCurrency = g_assets[index].baseCurrency;
    symbolQuoteCurrency = g_assets[index].quoteCurrency;
    isOutsideTradingHours = g_assets[index].outsideTradingHours;
    isNearMarketClose = g_assets[index].nearMarketClose;
    isOrderSendLocked = g_assets[index].orderSendLocked;
    marketCloseAlertSent = g_assets[index].marketCloseAlertSent;
    emaFastHandle = g_assets[index].emaFastHandle;
    emaSlowHandle = g_assets[index].emaSlowHandle;
    rsiHandle = g_assets[index].rsiHandle;
    atrSignalHandle = g_assets[index].atrSignalHandle;

    ArrayResize(managedPositions, g_assets[index].positionCount);
    for(int i = 0; i < g_assets[index].positionCount; i++)
        managedPositions[i] = g_assets[index].positions[i];
    managedPositionCount = g_assets[index].positionCount;

    currentBarTime = g_assets[index].currentBarTime;
    buysOnCurrentBar = g_assets[index].buysOnCurrentBar;
    sellsOnCurrentBar = g_assets[index].sellsOnCurrentBar;
    lastEntryBarTime = g_assets[index].lastEntryBarTime;
    consecutiveBuyCandles = g_assets[index].consecutiveBuyCandles;
    consecutiveSellCandles = g_assets[index].consecutiveSellCandles;
    prevBarHadBuys = g_assets[index].prevBarHadBuys;
    prevBarHadSells = g_assets[index].prevBarHadSells;
    consecutiveLossCount = g_assets[index].consecutiveLossCount;
    cooldownUntilBarTime = g_assets[index].cooldownUntilBarTime;
    lastBuyTime = g_assets[index].lastBuyTime;
    lastBuyPrice = g_assets[index].lastBuyPrice;
    lastSellTime = g_assets[index].lastSellTime;
    lastSellPrice = g_assets[index].lastSellPrice;
    lastBuySignalScore = g_assets[index].lastBuySignalScore;
    lastBuySignalScorePrev = g_assets[index].lastBuySignalScorePrev;
    lastBuyVelocity = g_assets[index].lastBuyVelocity;
    lastBuyNormalizedVelocity = g_assets[index].lastBuyNormalizedVelocity;
    lastSellSignalScore = g_assets[index].lastSellSignalScore;
    lastSellSignalScorePrev = g_assets[index].lastSellSignalScorePrev;
    lastSellVelocity = g_assets[index].lastSellVelocity;
    lastSellNormalizedVelocity = g_assets[index].lastSellNormalizedVelocity;
    _buyStrengthValid = g_assets[index].buyStrengthValid;
    _sellStrengthValid = g_assets[index].sellStrengthValid;
    _cachedBuyStrength = g_assets[index].cachedBuyStrength;
    _cachedSellStrength = g_assets[index].cachedSellStrength;
    buyStrengthCacheBarTime = g_assets[index].buyStrengthCacheBarTime;
    sellStrengthCacheBarTime = g_assets[index].sellStrengthCacheBarTime;
    buyStrengthCacheSymbol = g_assets[index].buyStrengthCacheSymbol;
    sellStrengthCacheSymbol = g_assets[index].sellStrengthCacheSymbol;
    g_strategyRegime = g_assets[index].strategyRegime;
    if(g_assets[index].buyStrengthCacheSymbol != g_activeSymbol || g_assets[index].buyStrengthCacheBarTime != currentBarTime)
        _buyStrengthValid = false;
    if(g_assets[index].sellStrengthCacheSymbol != g_activeSymbol || g_assets[index].sellStrengthCacheBarTime != currentBarTime)
        _sellStrengthValid = false;
    g_strategyDirection = g_assets[index].strategyDirection;
    g_strategyFinalDecision = g_assets[index].strategyFinalDecision;
    g_strategyReason = g_assets[index].strategyReason;
    g_strategyEdge = g_assets[index].strategyEdge;
    g_strategySetupQuality = g_assets[index].strategySetupQuality;
    g_strategyTimingQuality = g_assets[index].strategyTimingQuality;
    g_strategyDataReady = g_assets[index].strategyDataReady;
    g_strategySetupPass = g_assets[index].strategySetupPass;
    g_strategyTimingPass = g_assets[index].strategyTimingPass;
    g_strategyDecisionTrace = g_assets[index].decisionTrace;
    g_strategyDecisionStage = g_assets[index].decisionStage;
}

void SaveAssetContext()
{
    if(g_activeIndex < 0 || g_activeIndex >= g_assetCount) return;

    g_assets[g_activeIndex].baseCurrency = symbolBaseCurrency;
    g_assets[g_activeIndex].quoteCurrency = symbolQuoteCurrency;
    g_assets[g_activeIndex].outsideTradingHours = isOutsideTradingHours;
    g_assets[g_activeIndex].nearMarketClose = isNearMarketClose;
    g_assets[g_activeIndex].orderSendLocked = isOrderSendLocked;
    g_assets[g_activeIndex].marketCloseAlertSent = marketCloseAlertSent;
    g_assets[g_activeIndex].emaFastHandle = emaFastHandle;
    g_assets[g_activeIndex].emaSlowHandle = emaSlowHandle;
    g_assets[g_activeIndex].rsiHandle = rsiHandle;
    g_assets[g_activeIndex].atrSignalHandle = atrSignalHandle;

    g_assets[g_activeIndex].positionCount = managedPositionCount;
    ArrayResize(g_assets[g_activeIndex].positions, managedPositionCount);
    for(int i = 0; i < managedPositionCount; i++)
        g_assets[g_activeIndex].positions[i] = managedPositions[i];

    g_assets[g_activeIndex].currentBarTime = currentBarTime;
    g_assets[g_activeIndex].buysOnCurrentBar = buysOnCurrentBar;
    g_assets[g_activeIndex].sellsOnCurrentBar = sellsOnCurrentBar;
    g_assets[g_activeIndex].lastEntryBarTime = lastEntryBarTime;
    g_assets[g_activeIndex].consecutiveBuyCandles = consecutiveBuyCandles;
    g_assets[g_activeIndex].consecutiveSellCandles = consecutiveSellCandles;
    g_assets[g_activeIndex].prevBarHadBuys = prevBarHadBuys;
    g_assets[g_activeIndex].prevBarHadSells = prevBarHadSells;
    g_assets[g_activeIndex].consecutiveLossCount = consecutiveLossCount;
    g_assets[g_activeIndex].cooldownUntilBarTime = cooldownUntilBarTime;
    g_assets[g_activeIndex].lastBuyTime = lastBuyTime;
    g_assets[g_activeIndex].lastBuyPrice = lastBuyPrice;
    g_assets[g_activeIndex].lastSellTime = lastSellTime;
    g_assets[g_activeIndex].lastSellPrice = lastSellPrice;
    g_assets[g_activeIndex].lastBuySignalScore = lastBuySignalScore;
    g_assets[g_activeIndex].lastBuySignalScorePrev = lastBuySignalScorePrev;
    g_assets[g_activeIndex].lastBuyVelocity = lastBuyVelocity;
    g_assets[g_activeIndex].lastBuyNormalizedVelocity = lastBuyNormalizedVelocity;
    g_assets[g_activeIndex].lastSellSignalScore = lastSellSignalScore;
    g_assets[g_activeIndex].lastSellSignalScorePrev = lastSellSignalScorePrev;
    g_assets[g_activeIndex].lastSellVelocity = lastSellVelocity;
    g_assets[g_activeIndex].lastSellNormalizedVelocity = lastSellNormalizedVelocity;
    g_assets[g_activeIndex].buyStrengthValid = _buyStrengthValid;
    g_assets[g_activeIndex].sellStrengthValid = _sellStrengthValid;
    g_assets[g_activeIndex].cachedBuyStrength = _cachedBuyStrength;
    g_assets[g_activeIndex].cachedSellStrength = _cachedSellStrength;
    g_assets[g_activeIndex].buyStrengthCacheBarTime = currentBarTime;
    g_assets[g_activeIndex].sellStrengthCacheBarTime = currentBarTime;
    g_assets[g_activeIndex].buyStrengthCacheSymbol = g_activeSymbol;
    g_assets[g_activeIndex].sellStrengthCacheSymbol = g_activeSymbol;
    g_assets[g_activeIndex].strategyRegime = g_strategyRegime;
    g_assets[g_activeIndex].strategyDirection = g_strategyDirection;
    g_assets[g_activeIndex].strategyFinalDecision = g_strategyFinalDecision;
    g_assets[g_activeIndex].strategyReason = g_strategyReason;
    g_assets[g_activeIndex].strategyEdge = g_strategyEdge;
    g_assets[g_activeIndex].strategySetupQuality = g_strategySetupQuality;
    g_assets[g_activeIndex].strategyTimingQuality = g_strategyTimingQuality;
    g_assets[g_activeIndex].strategyDataReady = g_strategyDataReady;
    g_assets[g_activeIndex].strategySetupPass = g_strategySetupPass;
    g_assets[g_activeIndex].strategyTimingPass = g_strategyTimingPass;
    g_assets[g_activeIndex].decisionTrace = g_strategyDecisionTrace;
    g_assets[g_activeIndex].decisionStage = g_strategyDecisionStage;
}

int FindAssetIndex(string symbol)
{
    for(int i = 0; i < g_assetCount; i++)
        if(g_assets[i].symbol == symbol)
            return i;
    return -1;
}

void ReleaseActiveHandles()
{
    if(emaFastHandle != INVALID_HANDLE)
    {
        IndicatorRelease(emaFastHandle);
        emaFastHandle = INVALID_HANDLE;
    }

    if(emaSlowHandle != INVALID_HANDLE)
    {
        IndicatorRelease(emaSlowHandle);
        emaSlowHandle = INVALID_HANDLE;
    }

    if(rsiHandle != INVALID_HANDLE)
    {
        IndicatorRelease(rsiHandle);
        rsiHandle = INVALID_HANDLE;
    }

    if(atrSignalHandle != INVALID_HANDLE)
    {
        IndicatorRelease(atrSignalHandle);
        atrSignalHandle = INVALID_HANDLE;
    }
}

bool CreateAssetHandles()
{
    ReleaseActiveHandles();

    emaFastHandle = iMA(g_activeSymbol, g_activePeriod, EMAFastPeriod, 0, MODE_EMA, PRICE_CLOSE);
    if(emaFastHandle == INVALID_HANDLE)
    {
        ReleaseActiveHandles();
        return false;
    }

    emaSlowHandle = iMA(g_activeSymbol, g_activePeriod, EMASlowPeriod, 0, MODE_EMA, PRICE_CLOSE);
    if(emaSlowHandle == INVALID_HANDLE)
    {
        ReleaseActiveHandles();
        return false;
    }

    rsiHandle = iRSI(g_activeSymbol, g_activePeriod, RSIPeriod, PRICE_CLOSE);
    if(rsiHandle == INVALID_HANDLE)
    {
        ReleaseActiveHandles();
        return false;
    }

    atrSignalHandle = iATR(g_activeSymbol, g_activePeriod, ATRPeriod);
    if(atrSignalHandle == INVALID_HANDLE)
    {
        ReleaseActiveHandles();
        return false;
    }

    return true;
}

string AimeProfileClass(string symbol)
{
    if(symbol == "") return "FX";

    string path = SymbolInfoString(symbol, SYMBOL_PATH);
    string description = SymbolInfoString(symbol, SYMBOL_DESCRIPTION);
    string name = symbol;
    StringToUpper(path);
    StringToUpper(description);
    StringToUpper(name);

    if(StringFind(path, "CRYPTO") >= 0 || StringFind(path, "DIGITAL") >= 0 ||
       StringFind(description, "CRYPTO") >= 0 || StringFind(description, "BITCOIN") >= 0 ||
       StringFind(description, "ETHEREUM") >= 0)
        return "CRYPTO";

    if(StringFind(path, "STOCK") >= 0 || StringFind(path, "SHARES") >= 0 ||
       StringFind(path, "EQUITIES") >= 0 || StringFind(description, "STOCK") >= 0 ||
       StringFind(description, "SHARE") >= 0 || StringFind(description, "EQUITY") >= 0)
        return "STOCK";

    if(StringFind(path, "INDEX") >= 0 || StringFind(path, "INDICES") >= 0 ||
       StringFind(description, "INDEX") >= 0 || StringFind(description, "INDICES") >= 0)
        return "INDEX";

    if(StringFind(path, "METAL") >= 0 || StringFind(path, "COMMODIT") >= 0 ||
       StringFind(description, "GOLD") >= 0 || StringFind(description, "SILVER") >= 0 ||
       StringFind(description, "METAL") >= 0)
        return "METAL";

    long calcMode = SymbolInfoInteger(symbol, SYMBOL_TRADE_CALC_MODE);
    if(calcMode == SYMBOL_CALC_MODE_FOREX || calcMode == SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE)
        return "FX";

    string base = SymbolInfoString(symbol, SYMBOL_CURRENCY_BASE);
    string quote = SymbolInfoString(symbol, SYMBOL_CURRENCY_PROFIT);
    if(base != "" && quote != "") return "FX";

    return "FX";
}

double AimeBuySignalThresholdForSymbol(string symbol)
{
    if(!EnableAssetClassProfiles)
        return MinBuySignalScore;

    string cls = AimeProfileClass(symbol);
    if(cls == "METAL") return MetalBuySignalThreshold;
    if(cls == "INDEX") return IndexBuySignalThreshold;
    if(cls == "STOCK") return StockBuySignalThreshold;
    if(cls == "CRYPTO") return CryptoBuySignalThreshold;
    return FXBuySignalThreshold;
}

double AimeSellSignalThresholdForSymbol(string symbol)
{
    if(!EnableAssetClassProfiles)
        return MinSellSignalScore;

    string cls = AimeProfileClass(symbol);
    if(cls == "METAL") return MetalSellSignalThreshold;
    if(cls == "INDEX") return IndexSellSignalThreshold;
    if(cls == "STOCK") return StockSellSignalThreshold;
    if(cls == "CRYPTO") return CryptoSellSignalThreshold;
    return FXSellSignalThreshold;
}

double AimeMinVolRatioForSymbol(string symbol)
{
    if(!EnableAssetClassProfiles)
        return MinVolRatioToTrade;

    string cls = AimeProfileClass(symbol);
    if(cls == "METAL") return MetalMinVolRatio;
    if(cls == "INDEX") return IndexMinVolRatio;
    if(cls == "STOCK") return StockMinVolRatio;
    if(cls == "CRYPTO") return CryptoMinVolRatio;
    return FXMinVolRatio;
}

double AimeSpreadATRRatioForSymbol(string symbol)
{
    if(!EnableAssetClassProfiles)
        return MaxSpreadATRRatio;

    string cls = AimeProfileClass(symbol);
    if(cls == "METAL") return MetalSpreadATRRatio;
    if(cls == "INDEX") return IndexSpreadATRRatio;
    if(cls == "STOCK") return StockSpreadATRRatio;
    if(cls == "CRYPTO") return CryptoSpreadATRRatio;
    return FXSpreadATRRatio;
}

string AimeSignalProfileName(string symbol)
{
    return EnableAssetClassProfiles ? AimeProfileClass(symbol) : "BASE";
}

double AimeBuySignalThreshold()
{
    return AimeBuySignalThresholdForSymbol(g_activeSymbol);
}

double AimeSellSignalThreshold()
{
    return AimeSellSignalThresholdForSymbol(g_activeSymbol);
}

double AimeMinVolRatio()
{
    return AimeMinVolRatioForSymbol(g_activeSymbol);
}

double AimeSpreadATRRatio()
{
    return AimeSpreadATRRatioForSymbol(g_activeSymbol);
}

bool AimeBrokerSessionOpen(string symbol, string &status)
{
    status = "SESSION UNKNOWN";
    if(symbol == "")
    {
        status = "NO SYMBOL";
        return false;
    }

    long tradeMode = SymbolInfoInteger(symbol, SYMBOL_TRADE_MODE);
    if(tradeMode == SYMBOL_TRADE_MODE_DISABLED)
    {
        status = "TRADING DISABLED";
        return false;
    }

    datetime now = TimeTradeServer();
    if(now <= 0) now = TimeCurrent();
    MqlDateTime dt;
    TimeToStruct(now, dt);
    int currentSeconds = dt.hour * 3600 + dt.min * 60 + dt.sec;

    bool sessionDataFound = false;
    for(int dayOffset = 0; dayOffset <= 1; dayOffset++)
    {
        ENUM_DAY_OF_WEEK day = (ENUM_DAY_OF_WEEK)((dt.day_of_week - dayOffset + 7) % 7);
        for(uint session = 0; session < 64; session++)
        {
            datetime from = 0;
            datetime to = 0;
            if(!SymbolInfoSessionTrade(symbol, day, session, from, to))
                break;

            sessionDataFound = true;
            MqlDateTime sf;
            MqlDateTime st;
            TimeToStruct(from, sf);
            TimeToStruct(to, st);
            int startSeconds = sf.hour * 3600 + sf.min * 60 + sf.sec;
            int endSeconds = st.hour * 3600 + st.min * 60 + st.sec;

            bool contains = false;
            if(startSeconds == endSeconds)
                contains = true;
            else if(startSeconds < endSeconds)
            {
                if(dayOffset == 0)
                    contains = currentSeconds >= startSeconds && currentSeconds < endSeconds;
            }
            else
            {
                if(dayOffset == 0)
                    contains = currentSeconds >= startSeconds;
                else
                    contains = currentSeconds < endSeconds;
            }

            if(contains)
            {
                status = "SESSION OPEN";
                return true;
            }
        }
    }

    if(sessionDataFound)
    {
        status = "MARKET CLOSED";
        return false;
    }

    MqlTick sessionTick;
    if(!SymbolInfoTick(symbol, sessionTick) || sessionTick.time <= 0)
    {
        status = "NO TICK";
        return false;
    }

    status = "SESSION UNKNOWN";
    return false;
}

bool IsAssetTradable(string symbol)
{
    string sessionStatus = "";
    if(!AimeBrokerSessionOpen(symbol, sessionStatus))
        return false;

    if(EnableTradingHours && !IsWithinTradingHours())
        return false;

    return true;
}

string g_magicRoots[];
long   g_magicValues[];

string AimeNormalizeSymbolToken(string symbol)
{
    StringTrimLeft(symbol);
    StringTrimRight(symbol);
    StringToUpper(symbol);

    string out = "";
    int len = StringLen(symbol);
    for(int i = 0; i < len; i++)
    {
        ushort c = StringGetCharacter(symbol, i);
        if((c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9'))
            out += ShortToString((short)c);
    }
    return out;
}

string AimeSymbolIdentity(string symbol)
{
    string base = SymbolInfoString(symbol, SYMBOL_CURRENCY_BASE);
    string quote = SymbolInfoString(symbol, SYMBOL_CURRENCY_PROFIT);
    StringTrimLeft(base);
    StringTrimRight(base);
    StringTrimLeft(quote);
    StringTrimRight(quote);
    StringToUpper(base);
    StringToUpper(quote);

    long calcMode = SymbolInfoInteger(symbol, SYMBOL_TRADE_CALC_MODE);
    if((calcMode == SYMBOL_CALC_MODE_FOREX || calcMode == SYMBOL_CALC_MODE_FOREX_NO_LEVERAGE) &&
       base != "" && quote != "")
        return AimeNormalizeSymbolToken(base + quote);

    return AimeNormalizeSymbolToken(symbol);
}

ulong AimeHashIdentity(string identity, ulong seed)
{
    ulong hash = seed;
    int len = StringLen(identity);
    for(int i = 0; i < len; i++)
    {
        ulong c = (ulong)StringGetCharacter(identity, i);
        hash ^= c;
        hash *= 1099511628211;
    }
    return hash;
}

long AimeGenerateMagic(string symbol)
{
    string identity = AimeSymbolIdentity(symbol);
    if(identity == "") return 0;

    ulong hash = AimeHashIdentity(identity, 1469598103934665603);
    long span = 900000;
    long baseMagic = DynamicMagicBase;
    if(baseMagic < 100000) baseMagic = 100000;
    long offset = (long)(hash % (ulong)span);
    long magic = baseMagic + offset;
    if(magic <= 0) magic = baseMagic + 1;
    return magic;
}

void AimeRegistryAdd(string identity, long magic)
{
    identity = AimeNormalizeSymbolToken(identity);
    if(identity == "" || magic <= 0) return;

    int n = ArraySize(g_magicRoots);
    for(int i = 0; i < n; i++)
    {
        if(g_magicRoots[i] == identity)
        {
            g_magicValues[i] = magic;
            return;
        }
    }

    ArrayResize(g_magicRoots, n + 1);
    ArrayResize(g_magicValues, n + 1);
    g_magicRoots[n] = identity;
    g_magicValues[n] = magic;
}

long AimeLookupRegisteredMagic(string identity)
{
    for(int i = 0; i < ArraySize(g_magicRoots); i++)
        if(g_magicRoots[i] == identity)
            return g_magicValues[i];
    return 0;
}

long AimeEnsureSymbolMagic(string symbol)
{
    string identity = AimeSymbolIdentity(symbol);
    if(identity == "") return 0;

    long existing = AimeLookupRegisteredMagic(identity);
    if(existing > 0) return existing;

    long candidate = AimeGenerateMagic(symbol);
    if(candidate <= 0) return 0;

    for(int salt = 0; salt < 32; salt++)
    {
        bool collision = false;
        for(int i = 0; i < ArraySize(g_magicValues); i++)
        {
            if(g_magicValues[i] == candidate && g_magicRoots[i] != identity)
            {
                collision = true;
                break;
            }
        }
        if(!collision) break;
        ulong h = AimeHashIdentity(identity, 1469598103934665603 + (ulong)salt + 1);
        candidate = MathMax(100000L, DynamicMagicBase) + (long)(h % 900000ULL);
    }

    AimeRegistryAdd(identity, candidate);
    return candidate;
}

void InitializeAimeMagicRegistry()
{
    ArrayResize(g_magicRoots, 0);
    ArrayResize(g_magicValues, 0);

    if(AcceptLegacyMagicNumbers && LegacyManagedMagicNumbers != "")
    {
        string parts[];
        int count = StringSplit(LegacyManagedMagicNumbers, ',', parts);
        for(int i = 0; i < count; i++)
        {
            StringTrimLeft(parts[i]);
            StringTrimRight(parts[i]);
            long magic = (long)StringToInteger(parts[i]);
            if(magic > 0)
                AimeRegistryAdd("LEGACY" + IntegerToString(i), magic);
        }
    }
}

string AimeCanonicalSymbolRoot(string symbol)
{
    return AimeSymbolIdentity(symbol);
}

long GetMagicForSymbol(string symbol)
{
    return AimeEnsureSymbolMagic(symbol);
}

long ActiveMagicNumber()
{
    if(g_activeIndex < 0 || g_activeIndex >= g_assetCount) return 0;
    return g_assets[g_activeIndex].magicNumber;
}

bool IsAimeMagic(long magic)
{
    if(magic <= 0) return false;

    for(int i = 0; i < ArraySize(g_magicValues); i++)
        if(g_magicValues[i] == magic)
            return true;

    return false;
}

bool IsActivePosition(ulong ticket)
{
    if(ticket == 0 || !PositionSelectByTicket(ticket)) return false;
    if(PositionGetString(POSITION_SYMBOL) != g_activeSymbol) return false;
    if((long)PositionGetInteger(POSITION_MAGIC) != ActiveMagicNumber()) return false;
    return true;
}

bool IsActiveOrder(ulong ticket)
{
    if(ticket == 0 || !OrderSelect(ticket)) return false;
    if(OrderGetString(ORDER_SYMBOL) != g_activeSymbol) return false;
    if((long)OrderGetInteger(ORDER_MAGIC) != ActiveMagicNumber()) return false;
    return true;
}

bool IsActiveDeal(ulong ticket)
{
    if(ticket == 0 || !HistoryDealSelect(ticket)) return false;
    if(HistoryDealGetString(ticket, DEAL_SYMBOL) != g_activeSymbol) return false;
    if((long)HistoryDealGetInteger(ticket, DEAL_MAGIC) != ActiveMagicNumber()) return false;
    return true;
}

bool AimePositionBelongsToAsset(ulong ticket, int assetIndex)
{
    if(ticket == 0 || assetIndex < 0 || assetIndex >= g_assetCount) return false;
    if(!PositionSelectByTicket(ticket)) return false;
    string symbol = PositionGetString(POSITION_SYMBOL);
    long magic = (long)PositionGetInteger(POSITION_MAGIC);
    if(symbol != g_assets[assetIndex].symbol) return false;
    if(magic != g_assets[assetIndex].magicNumber) return false;
    return true;
}

bool AimeOrderBelongsToAsset(ulong ticket, int assetIndex)
{
    if(ticket == 0 || assetIndex < 0 || assetIndex >= g_assetCount) return false;
    if(!OrderSelect(ticket)) return false;
    string symbol = OrderGetString(ORDER_SYMBOL);
    long magic = (long)OrderGetInteger(ORDER_MAGIC);
    if(symbol != g_assets[assetIndex].symbol) return false;
    if(magic != g_assets[assetIndex].magicNumber) return false;
    return true;
}

bool AimeRegisterExistingPositionForActiveAsset(ulong ticket)
{
    if(ticket == 0 || g_activeIndex < 0 || g_activeIndex >= g_assetCount) return false;
    if(!AimePositionBelongsToAsset(ticket, g_activeIndex)) return false;
    if(GetManagedPositionIndex(ticket) >= 0) return true;

    ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
    double entryPrice = PositionGetDouble(POSITION_PRICE_OPEN);
    string comment = PositionGetString(POSITION_COMMENT);
    double score = ParseLimitEntryScore(comment);
    if(score <= 0.0)
        score = (type == POSITION_TYPE_BUY) ? AimeBuySignalThreshold() : AimeSellSignalThreshold();

    RegisterManagedPosition(ticket, type, score, entryPrice);
    return true;
}

void AimeReconcileAssetPositions(int assetIndex)
{
    if(assetIndex < 0 || assetIndex >= g_assetCount) return;

    string symbol = g_assets[assetIndex].symbol;
    long magic = g_assets[assetIndex].magicNumber;
    if(symbol == "" || magic <= 0) return;

    ManagedPosition rebuilt[];
    int rebuiltCount = 0;

    for(int p = PositionsTotal() - 1; p >= 0; p--)
    {
        ulong ticket = PositionGetTicket(p);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;

        if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
        if((long)PositionGetInteger(POSITION_MAGIC) != magic) continue;

        ManagedPosition mp;
        ZeroMemory(mp);
        bool preserved = false;

        for(int k = 0; k < g_assets[assetIndex].positionCount; k++)
        {
            if(g_assets[assetIndex].positions[k].ticket == ticket)
            {
                mp = g_assets[assetIndex].positions[k];
                preserved = true;
                break;
            }
        }

        if(!preserved)
        {
            ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

            mp.ticket = ticket;
            mp.type = type;
            mp.entryPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            mp.signalScore = ParseLimitEntryScore(PositionGetString(POSITION_COMMENT));

            if(mp.signalScore <= 0.0)
                mp.signalScore = (type == POSITION_TYPE_BUY)
                    ? AimeBuySignalThresholdForSymbol(symbol)
                    : AimeSellSignalThresholdForSymbol(symbol);

            mp.partialCloseLevel = 0;
            mp.breakEvenLocked = false;
            mp.profitOffsetConsecWins = 0;
            mp.profitOffsetAccumulated = 0.0;
            mp.profitOffsetOriginalSL = PositionGetDouble(POSITION_SL);
            mp.chainId = 0;
            mp.hedgeLevel = 0;
            mp.chainAnchorLoss = 0.0;
            mp.cycleNum = 0;
            mp.noRehedge = false;
            mp.hedgeGraduated = false;
            mp.hedgeLockProfit = 0.0;
        }

        ArrayResize(rebuilt, rebuiltCount + 1);
        rebuilt[rebuiltCount] = mp;
        rebuiltCount++;
    }

    ArrayResize(g_assets[assetIndex].positions, rebuiltCount);
    g_assets[assetIndex].positionCount = rebuiltCount;

    for(int i = 0; i < rebuiltCount; i++)
        g_assets[assetIndex].positions[i] = rebuilt[i];

    if(assetIndex == g_activeIndex)
    {
        ArrayResize(managedPositions, rebuiltCount);
        managedPositionCount = rebuiltCount;

        for(int i = 0; i < rebuiltCount; i++)
            managedPositions[i] = rebuilt[i];
    }
}

void AimeReconcileAllPositions(bool force=false)
{
    if(g_assetCount <= 0 && !g_multiAssetInitialized) return;

    datetime now = TimeCurrent();
    if(!force && g_lastPositionReconcile > 0 && now == g_lastPositionReconcile) return;
    g_lastPositionReconcile = now;

    int positions = PositionsTotal();
    for(int p = positions - 1; p >= 0; p--)
    {
        ulong ticket = PositionGetTicket(p);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;

        string symbol = PositionGetString(POSITION_SYMBOL);
        if(symbol == "") continue;

        long expectedMagic = AimeEnsureSymbolMagic(symbol);
        long actualMagic = (long)PositionGetInteger(POSITION_MAGIC);
        if(expectedMagic <= 0 || actualMagic != expectedMagic)
            continue;

        int idx = FindAssetIndex(symbol);
        if(idx < 0)
            AddAssetContext(symbol, g_chartPeriod);
    }

    int snapshot = g_assetCount;
    for(int i = 0; i < snapshot; i++)
    {
        if(i < 0 || i >= g_assetCount) continue;
        AimeReconcileAssetPositions(i);
    }
}

bool AimeValidatePositionIdentity(ulong ticket,const string expectedSymbol,const long expectedMagic)
{
    if(ticket == 0 || !PositionSelectByTicket(ticket)) return false;
    string symbol = PositionGetString(POSITION_SYMBOL);
    long magic = (long)PositionGetInteger(POSITION_MAGIC);
    if(symbol != expectedSymbol) return false;
    if(magic != expectedMagic) return false;
    if(!IsAimeMagic(magic)) return false;
    return true;
}

bool AimeValidateActivePositionTicket(ulong ticket)
{
    if(ticket == 0 || g_activeIndex < 0 || g_activeIndex >= g_assetCount) return false;
    if(!PositionSelectByTicket(ticket)) return false;

    string symbol = PositionGetString(POSITION_SYMBOL);
    long magic = (long)PositionGetInteger(POSITION_MAGIC);

    if(symbol != g_assets[g_activeIndex].symbol)
    {
        LogPrint("[POSITION ISOLATION] BLOCK symbol mismatch ticket=", ticket, " expected=", g_assets[g_activeIndex].symbol, " actual=", symbol);
        return false;
    }

    if(magic != g_assets[g_activeIndex].magicNumber)
    {
        LogPrint("[POSITION ISOLATION] BLOCK magic mismatch ticket=", ticket, " expected=", g_assets[g_activeIndex].magicNumber, " actual=", magic);
        return false;
    }

    return true;
}

string ResolveAimeBrokerSymbol(string requested)
{
    StringTrimLeft(requested);
    StringTrimRight(requested);
    if(requested == "") return "";

    string requestedToken = AimeNormalizeSymbolToken(requested);
    if(requestedToken == "") return "";

    if(SymbolSelect(requested, true))
        return requested;

    string best = "";
    int bestScore = -1;

    int watchTotal = SymbolsTotal(true);
    for(int i = 0; i < watchTotal; i++)
    {
        string candidate = SymbolName(i, true);
        if(candidate == "") continue;

        string candidateToken = AimeNormalizeSymbolToken(candidate);
        if(candidateToken == "") continue;

        int score = -1;
        if(candidateToken == requestedToken)
            score = 100000;
        else if(StringFind(candidateToken, requestedToken) >= 0)
            score = 10000 - (int)MathAbs(StringLen(candidateToken) - StringLen(requestedToken));

        if(score < 0) continue;
        if(SymbolInfoInteger(candidate, SYMBOL_TRADE_MODE) == SYMBOL_TRADE_MODE_DISABLED) continue;

        if(score > bestScore)
        {
            bestScore = score;
            best = candidate;
        }
    }

    if(best != "")
    {
        SymbolSelect(best, true);
        return best;
    }

    int total = SymbolsTotal(false);
    for(int i = 0; i < total; i++)
    {
        string candidate = SymbolName(i, false);
        if(candidate == "") continue;

        string candidateToken = AimeNormalizeSymbolToken(candidate);
        if(candidateToken == requestedToken || StringFind(candidateToken, requestedToken) >= 0)
        {
            if(SymbolInfoInteger(candidate, SYMBOL_TRADE_MODE) != SYMBOL_TRADE_MODE_DISABLED &&
               SymbolSelect(candidate, true))
                return candidate;
        }
    }

    return "";
}

bool AddAssetContext(string symbol, ENUM_TIMEFRAMES period)
{
    StringTrimLeft(symbol);
    StringTrimRight(symbol);
    if(symbol == "") return false;

    string resolvedSymbol = ResolveAimeBrokerSymbol(symbol);
    if(resolvedSymbol == "")
    {
        if(SkipUnavailableSymbols)
            Print("[MULTI-ASSET] Symbol unavailable: ", symbol);
        return false;
    }

    symbol = resolvedSymbol;

    int existing = FindAssetIndex(symbol);
    if(existing >= 0) return true;

    long symbolMagic = GetMagicForSymbol(symbol);
    if(symbolMagic <= 0)
    {
        Print("[MULTI-ASSET] Dynamic identity generation failed for ", symbol);
        return false;
    }

    if(MaxDiscoveredAssets > 0 && g_assetCount >= MaxDiscoveredAssets)
        return false;

    int previousIndex = g_activeIndex;
    if(previousIndex >= 0 && previousIndex < g_assetCount)
        SaveAssetContext();

    int newIndex = g_assetCount;
    ArrayResize(g_assets, newIndex + 1);
    g_assetCount++;

    g_assets[newIndex].symbol = symbol;
    g_assets[newIndex].magicNumber = symbolMagic;
    g_assets[newIndex].period = period;
    g_assets[newIndex].initialized = false;
    g_assets[newIndex].quarantined = false;
    g_assets[newIndex].quarantineReason = "";
    g_assets[newIndex].consecutiveHealthFailures = 0;
    g_assets[newIndex].perfProfitFactor = -1.0; 
    g_assets[newIndex].perfTradeCount = 0;
    g_assets[newIndex].perfLastCalcTime = 0;
    g_assets[newIndex].emaFastHandle = INVALID_HANDLE;
    g_assets[newIndex].emaSlowHandle = INVALID_HANDLE;
    g_assets[newIndex].rsiHandle = INVALID_HANDLE;
    g_assets[newIndex].atrSignalHandle = INVALID_HANDLE;
    g_assets[newIndex].dataState = "HISTORY WAIT";
    g_assets[newIndex].dataReason = "INITIALIZING DATA ENGINE";
    g_assets[newIndex].seriesSynchronized = false;
    g_assets[newIndex].indicatorsReady = false;
    g_assets[newIndex].feedInitialized = false;
    g_assets[newIndex].feedLive = false;
    g_assets[newIndex].feedLastTickTimeMsc = 0;
    g_assets[newIndex].feedLastTickTime = 0;
    g_assets[newIndex].feedLastBid = 0.0;
    g_assets[newIndex].feedLastAsk = 0.0;
    g_assets[newIndex].feedLastChangeMs = 0;
    g_assets[newIndex].feedLastObservedServerTime = 0;
    g_assets[newIndex].feedLastBarTime = 0;
    g_assets[newIndex].feedLastBarAgeSeconds = -1;
    ArrayResize(g_assets[newIndex].positions, 0);

    g_activeIndex = newIndex;
    g_activeSymbol = symbol;
    g_activePeriod = period;

    ResetActiveRuntimeState();

    symbolBaseCurrency = SymbolInfoString(symbol, SYMBOL_CURRENCY_BASE);
    symbolQuoteCurrency = SymbolInfoString(symbol, SYMBOL_CURRENCY_PROFIT);

    if(!CreateAssetHandles())
    {
        g_assets[newIndex].initialized = true;
        g_assets[newIndex].quarantined = false;
        g_assets[newIndex].quarantineReason = "";
        g_assets[newIndex].dataState = "INDICATOR WAIT";
        g_assets[newIndex].dataReason = "INDICATOR HANDLE RETRY";
        g_assets[newIndex].indicatorsReady = false;
        SaveAssetContext();

        if(previousIndex >= 0 && previousIndex < g_assetCount)
            LoadAssetContext(previousIndex);
        else
        {
            g_activeIndex = -1;
            g_activeSymbol = "";
            g_activePeriod = PERIOD_CURRENT;
        }

        return true;
    }

    g_assets[newIndex].emaFastHandle = emaFastHandle;
    g_assets[newIndex].emaSlowHandle = emaSlowHandle;
    g_assets[newIndex].rsiHandle = rsiHandle;
    g_assets[newIndex].atrSignalHandle = atrSignalHandle;

    currentBarTime = iTime(symbol, period, 0);
    AimeReconcileAssetPositions(newIndex);

    g_assets[newIndex].initialized = true;
    SaveAssetContext();

    if(previousIndex >= 0 && previousIndex < g_assetCount && previousIndex != newIndex)
        LoadAssetContext(previousIndex);

    return true;
}

void AimeScanMarketWatchAssets()
{
    if(!EnableMarketWatchDiscovery || !EnableMultiAsset) return;
    if(g_portfolioCycleRunning || g_executionCycleRunning) return;

    datetime now = TimeCurrent();
    int interval = MathMax(1, MarketWatchScanSeconds);
    if(g_lastMarketWatchScan > 0 && (now - g_lastMarketWatchScan) < interval)
        return;

    g_lastMarketWatchScan = now;

    int total = SymbolsTotal(true);
    int added = 0;
    int eligibleSkippedByCap = 0;

    for(int i = 0; i < total; i++)
    {
        string symbol = SymbolName(i, true);
        if(symbol == "") continue;
        if(FindAssetIndex(symbol) >= 0) continue;
        if(GetMagicForSymbol(symbol) <= 0) continue;

        if(MaxDiscoveredAssets > 0 && g_assetCount >= MaxDiscoveredAssets)
        {
            eligibleSkippedByCap++;
            continue; 
        }

        int before = g_assetCount;
        if(AddAssetContext(symbol, g_activePeriod) && g_assetCount > before)
            added++;
    }

    if(eligibleSkippedByCap > 0)
        LogPrint("[MARKET WATCH] ", eligibleSkippedByCap, " Market Watch symbol(s) NOT tracked — MaxDiscoveredAssets cap (",
                 MaxDiscoveredAssets, ") reached. Raise the input if you want full coverage.");

    for(int qi = 0; qi < g_assetCount; qi++)
    {
        string qsym = g_assets[qi].symbol;
        bool symbolStillTradable = SymbolSelect(qsym, true) && SymbolInfoInteger(qsym, SYMBOL_SELECT) != 0;
        MqlTick qtick;
        bool hasTick = symbolStillTradable && SymbolInfoTick(qsym, qtick) && qtick.time > 0;

        if(!symbolStillTradable || !hasTick)
        {
            g_assets[qi].consecutiveHealthFailures++;
            int threshold = MathMax(1, AssetHealthFailureThreshold);
            if(!g_assets[qi].quarantined && g_assets[qi].consecutiveHealthFailures >= threshold)
            {
                g_assets[qi].quarantined = true;
                g_assets[qi].quarantineReason = !symbolStillTradable ? "SYMBOL UNAVAILABLE" : "NO TICK";
                LogPrint("[QUARANTINE] ", qsym, " flagged: ", g_assets[qi].quarantineReason,
                         " after ", g_assets[qi].consecutiveHealthFailures, " consecutive health failures. ",
                         "New entries blocked; any existing open position on this symbol continues to be managed.");
            }
        }
        else
        {
            g_assets[qi].consecutiveHealthFailures = 0;
            if(g_assets[qi].quarantined)
            {
                LogPrint("[QUARANTINE] ", qsym, " recovered — clearing quarantine, new entries re-enabled.");
                g_assets[qi].quarantined = false;
                g_assets[qi].quarantineReason = "";
            }
        }
    }

    int chartIndex = FindAssetIndex(g_chartSymbol);
    if(chartIndex >= 0)
        LoadAssetContext(chartIndex);

    if(added > 0)
        Print("[MARKET WATCH] Added ", added, " symbols. Contexts=", g_assetCount);
}

bool InitializeMultiAssetEA()
{
    g_multiAssetInitialized = false;
    InitializeAimeMagicRegistry();
    g_chartSymbol = ChartSymbol(0);
    g_chartPeriod = (ENUM_TIMEFRAMES)ChartPeriod(0);
    g_activeSymbol = g_chartSymbol;
    g_activePeriod = (MultiAssetTimeframe == PERIOD_CURRENT) ? g_chartPeriod : MultiAssetTimeframe;

    ArrayResize(g_assets, 0);
    g_assetCount = 0;
    g_activeIndex = -1;

    initialBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    peakEquity = AccountInfoDouble(ACCOUNT_EQUITY);
    lastPeakEquity = peakEquity;
    targetEquityReached = false;
    minimumEquityReached = false;
    minEquityTriggersExceeded = false;
    minEquityTriggerCount = 0;
    isPaused = false;
    pauseStartTime = 0;
    currentPauseDuration = 0;
    g_pauseReason = "NONE";
    g_pauseUntil = 0;
    g_pauseTemporary = false;
    lastProcessedNewsEventID = 0;
    startTime = TimeCurrent();
    lastDailyReportTime = 0;
    lastReportEquity = AccountInfoDouble(ACCOUNT_EQUITY);
    totalPauseCount = 0;
    totalPauseDurationMinutes = 0;
    initialLeverage = AccountInfoInteger(ACCOUNT_LEVERAGE);
    isOrderSendLocked = false;
    algoTradingStatus = TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);

    double healthWeightSum = HealthTrendWeight + HealthRSIWeight + HealthATRWeight + HealthSwingWeight;
    if(healthWeightSum > 0)
    {
        normHealthTrendWeight = HealthTrendWeight / healthWeightSum;
        normHealthRSIWeight = HealthRSIWeight / healthWeightSum;
        normHealthATRWeight = HealthATRWeight / healthWeightSum;
        normHealthSwingWeight = HealthSwingWeight / healthWeightSum;
    }
    else
    {
        normHealthTrendWeight = 0.25;
        normHealthRSIWeight = 0.25;
        normHealthATRWeight = 0.25;
        normHealthSwingWeight = 0.25;
    }

    if(EnableMultiAsset)
    {
        AimeScanMarketWatchAssets();

        if(MultiAssetSymbols != "")
        {
            string symbols[];
            int count = StringSplit(MultiAssetSymbols, ',', symbols);
            for(int i = 0; i < count; i++)
                AddAssetContext(symbols[i], g_activePeriod);
        }

        if(EnableCryptoTrading && CryptoSymbols != "")
        {
            string cryptoSymbols[];
            int cryptoCount = StringSplit(CryptoSymbols, ',', cryptoSymbols);
            for(int i = 0; i < cryptoCount; i++)
                AddAssetContext(cryptoSymbols[i], g_activePeriod);
        }

        if(EnableStockTrading && StockSymbols != "")
        {
            string stockSymbols[];
            int stockCount = StringSplit(StockSymbols, ',', stockSymbols);
            for(int i = 0; i < stockCount; i++)
                AddAssetContext(stockSymbols[i], g_activePeriod);
        }

        if(EnableIndexTrading && IndexSymbols != "")
        {
            string indexSymbols[];
            int indexCount = StringSplit(IndexSymbols, ',', indexSymbols);
            for(int i = 0; i < indexCount; i++)
                AddAssetContext(indexSymbols[i], g_activePeriod);
        }
    }

    if(IncludeChartSymbolAutomatically || !EnableMultiAsset)
        AddAssetContext(g_chartSymbol, g_activePeriod);

    if(g_assetCount <= 0)
        return false;

    for(int i = 0; i < g_assetCount; i++)
    {
        if(g_assets[i].magicNumber <= 0)
        {
            Print("[MAGIC REGISTRY] Invalid magic for ", g_assets[i].symbol);
            return false;
        }
        for(int j = i + 1; j < g_assetCount; j++)
        {
            if(g_assets[i].magicNumber == g_assets[j].magicNumber)
            {
                Print("[MAGIC REGISTRY] Duplicate magic ", g_assets[i].magicNumber, " assigned to ", g_assets[i].symbol, " and ", g_assets[j].symbol);
                return false;
            }
        }
    }

    g_multiAssetInitialized = true;
    Print("[MULTI-ASSET] Engine initialized with ", g_assetCount, " symbol contexts");
    return true;
}

void ReleaseAllAssetHandles()
{
    ReleaseActiveHandles();

    for(int i = 0; i < g_assetCount; i++)
    {
        if(g_assets[i].emaFastHandle != INVALID_HANDLE)
        {
            IndicatorRelease(g_assets[i].emaFastHandle);
            g_assets[i].emaFastHandle = INVALID_HANDLE;
        }

        if(g_assets[i].emaSlowHandle != INVALID_HANDLE)
        {
            IndicatorRelease(g_assets[i].emaSlowHandle);
            g_assets[i].emaSlowHandle = INVALID_HANDLE;
        }

        if(g_assets[i].rsiHandle != INVALID_HANDLE)
        {
            IndicatorRelease(g_assets[i].rsiHandle);
            g_assets[i].rsiHandle = INVALID_HANDLE;
        }

        if(g_assets[i].atrSignalHandle != INVALID_HANDLE)
        {
            IndicatorRelease(g_assets[i].atrSignalHandle);
            g_assets[i].atrSignalHandle = INVALID_HANDLE;
        }
    }
}

bool PortfolioTicketIsChainLeg(ulong ticket)
{
    for(int i = 0; i < g_assetCount; i++)
        for(int j = 0; j < g_assets[i].positionCount; j++)
            if(g_assets[i].positions[j].ticket == ticket && g_assets[i].positions[j].chainId != 0)
                return true;
    return false;
}

double GetPortfolioFloatingPL(bool skipChainLegs = false)
{
    double total = 0.0;
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
        if(!IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) continue;
        if(skipChainLegs && EnableHedgeChain && PortfolioTicketIsChainLeg(ticket)) continue;
        total += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
    }
    return total;
}

void CloseAllPortfolioPositions(bool unProfitableOnly = false, bool skipChainLegs = false)
{
    int attempted=0;
    int closed=0;
    for(int i=PositionsTotal()-1;i>=0;i--)
    {
        ulong ticket=PositionGetTicket(i);
        if(ticket==0 || !PositionSelectByTicket(ticket)) continue;
        if(!IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) continue;
        double profit=PositionGetDouble(POSITION_PROFIT);
        if(unProfitableOnly && profit>=0.0) continue;
        if(skipChainLegs && EnableHedgeChain && PortfolioTicketIsChainLeg(ticket)) continue;
        attempted++;
        if(ClosePosition(ticket)) closed++;
    }
    AimeReconcileAllPositions(true);
    LogPrint("[PORTFOLIO CLOSE] closed=",closed," attempted=",attempted);
}

bool IsWithinSessionBoost()
{
    if(!EnableSessionBoost) return false;
    MqlDateTime dt;
    TimeToStruct(TimeCurrent(), dt);
    int currentMinutes = dt.hour * 60 + dt.min;
    string startParts[];
    string endParts[];
    StringSplit(SessionBoostStart, ':', startParts);
    StringSplit(SessionBoostEnd, ':', endParts);
    if(ArraySize(startParts) != 2 || ArraySize(endParts) != 2) return false;
    int startMins = (int)StringToInteger(startParts[0]) * 60 + (int)StringToInteger(startParts[1]);
    int endMins = (int)StringToInteger(endParts[0]) * 60 + (int)StringToInteger(endParts[1]);
    if(startMins > endMins)
        return (currentMinutes >= startMins || currentMinutes <= endMins);
    return (currentMinutes >= startMins && currentMinutes <= endMins);
}

string AimeGlobalTradeLockName(string symbol)
{
    string clean=AimeNormalizeSymbolToken(symbol);
    return "AIME_TRADE_LOCK_"+(string)AccountInfoInteger(ACCOUNT_LOGIN)+"_"+clean;
}

bool AimeAcquireGlobalTradeLock(string symbol)
{
    if(GlobalTradeLockSeconds<=0) return true;
    string key=AimeGlobalTradeLockName(symbol);
    datetime now=TimeTradeServer();
    if(now<=0) now=TimeCurrent();
    double current=0.0;
    if(GlobalVariableCheck(key)) current=GlobalVariableGet(key);
    double expiry=(double)(now+MathMax(1,GlobalTradeLockSeconds));
    if(current>(double)now) return false;
    if(!GlobalVariableCheck(key))
    {
        GlobalVariableSet(key,0.0);
        current=GlobalVariableGet(key);
    }
    return GlobalVariableSetOnCondition(key,expiry,current);
}

void AimeReleaseGlobalTradeLock(string symbol)
{
    if(GlobalTradeLockSeconds<=0) return;
    string key=AimeGlobalTradeLockName(symbol);
    if(GlobalVariableCheck(key)) GlobalVariableSet(key,0.0);
}

string AimeEntryFingerprintName(string symbol, ENUM_ORDER_TYPE type)
{
    return "AIME_ENTRY_FP_"+(string)AccountInfoInteger(ACCOUNT_LOGIN)+"_"+
           AimeNormalizeSymbolToken(symbol)+"_"+IntegerToString((int)type);
}

bool AimeAcquireEntryFingerprint(string symbol, ENUM_ORDER_TYPE type, datetime barTime)
{
    if(EntryFingerprintSeconds<=0 || barTime<=0) return true;
    string key=AimeEntryFingerprintName(symbol,type);
    double current=GlobalVariableCheck(key)?GlobalVariableGet(key):0.0;
    double target=(double)barTime;
    if(current==target) return false;
    if(!GlobalVariableCheck(key)) GlobalVariableSet(key,0.0);
    current=GlobalVariableGet(key);
    if(current==target) return false;
    return GlobalVariableSetOnCondition(key,target,current);
}

void AimeReleaseEntryFingerprint(string symbol, ENUM_ORDER_TYPE type, datetime barTime)
{
    if(EntryFingerprintSeconds<=0 || barTime<=0) return;
    string key=AimeEntryFingerprintName(symbol,type);
    if(GlobalVariableCheck(key) && GlobalVariableGet(key)==(double)barTime) GlobalVariableSet(key,0.0);
}

int AimeWorkingOrdersForSymbol(string symbol, long magic)
{
    int count=0;
    for(int i=OrdersTotal()-1;i>=0;i--)
    {
        ulong ticket=OrderGetTicket(i);
        if(ticket==0) continue;
        if(OrderGetString(ORDER_SYMBOL)!=symbol) continue;
        if((long)OrderGetInteger(ORDER_MAGIC)!=magic) continue;
        ENUM_ORDER_TYPE t=(ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
        if(t==ORDER_TYPE_BUY_LIMIT || t==ORDER_TYPE_SELL_LIMIT || t==ORDER_TYPE_BUY_STOP || t==ORDER_TYPE_SELL_STOP ||
           t==ORDER_TYPE_BUY_STOP_LIMIT || t==ORDER_TYPE_SELL_STOP_LIMIT) count++;
    }
    return count;
}

bool AimeExecutionExposureAvailable(string symbol, long magic)
{
    int positions=0;
    for(int i=PositionsTotal()-1;i>=0;i--)
    {
        ulong ticket=PositionGetTicket(i);
        if(ticket==0 || !PositionSelectByTicket(ticket)) continue;
        if(PositionGetString(POSITION_SYMBOL)!=symbol) continue;
        if((long)PositionGetInteger(POSITION_MAGIC)!=magic) continue;
        positions++;
    }
    int working=AimeWorkingOrdersForSymbol(symbol,magic);
    if(MaxPositionsPerSymbol>0 && positions+working>=MaxPositionsPerSymbol) return false;
    return true;
}

bool AimeRefreshAccountSnapshot()
{
    long login = AccountInfoInteger(ACCOUNT_LOGIN);
    long leverage = AccountInfoInteger(ACCOUNT_LEVERAGE);
    string currency = AccountInfoString(ACCOUNT_CURRENCY);
    double balance = AccountInfoDouble(ACCOUNT_BALANCE);
    double equity = AccountInfoDouble(ACCOUNT_EQUITY);
    double margin = AccountInfoDouble(ACCOUNT_MARGIN);
    double freeMargin = AccountInfoDouble(ACCOUNT_MARGIN_FREE);
    double marginLevel = AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);

    g_accountSnapshotTime = TimeTradeServer();
    if(g_accountSnapshotTime <= 0) g_accountSnapshotTime = TimeCurrent();

    bool valid = true;
    string reason = "";
    if(login <= 0) { valid=false; reason="ACCOUNT LOGIN UNAVAILABLE"; }
    else if(leverage <= 0) { valid=false; reason="ACCOUNT LEVERAGE UNAVAILABLE"; }
    else if(currency == "") { valid=false; reason="ACCOUNT CURRENCY UNAVAILABLE"; }
    else if(!MathIsValidNumber(balance) || !MathIsValidNumber(equity) || !MathIsValidNumber(margin) || !MathIsValidNumber(freeMargin) || !MathIsValidNumber(marginLevel)) { valid=false; reason="ACCOUNT VALUE INVALID"; }
    else if(balance <= 0.0 && equity <= 0.0) { valid=false; reason="ACCOUNT NOT FUNDED — DEPOSIT REQUIRED"; }
    else if(balance < 0.0 || equity <= 0.0 || freeMargin < 0.0 || margin < 0.0) { valid=false; reason="ACCOUNT VALUE NOT READY"; }

    if(valid)
    {
        g_accountSnapshotValid = true;
        g_accountSnapshotState = "ACCOUNT CONNECTED";
        g_accountSnapshotReason = "LIVE MT5 ACCOUNT DATA";
        g_accountBalanceLive = balance;
        g_accountEquityLive = equity;
        g_accountMarginLive = margin;
        g_accountFreeMarginLive = freeMargin;
        g_accountMarginLevelLive = marginLevel;
        g_accountLeverageLive = leverage;
        g_accountCurrencyLive = currency;
        return true;
    }

    g_accountSnapshotValid = false;
    g_accountSnapshotState = "ACCOUNT DATA UNAVAILABLE";
    g_accountSnapshotReason = reason == "" ? "ACCOUNT SNAPSHOT FAILED" : reason;
    return false;
}

string AimeProtectionStateText()
{
    if(g_emergencyStop) return "EMERGENCY";
    if(g_riskHardLocked) return "RISK HARD LOCK";
    if(g_dailyRiskLocked) return "DAILY LOSS LOCK";
    if(g_peakRiskLocked) return "DRAWDOWN LOCK";
    if(isPaused) return "PAUSED";
    return "NORMAL";
}

void AimeRefreshProtectionState()
{
    g_protectionState = AimeProtectionStateText();
    if(g_emergencyStop) g_protectionReason = g_emergencyStopReason == "" ? "EMERGENCY STOP" : g_emergencyStopReason;
    else if(g_riskHardLocked) g_protectionReason = "RISK HARD LOCK";
    else if(g_dailyRiskLocked) g_protectionReason = "DAILY LOSS LOCK";
    else if(g_peakRiskLocked) g_protectionReason = "DRAWDOWN LOCK";
    else if(isPaused) g_protectionReason = g_pauseReason == "" ? "PAUSED" : g_pauseReason;
    else g_protectionReason = "NONE";
}

void AimeRefreshDashboardLiveState()
{
    AimeRefreshDashboardPositionSnapshot();

    datetime now=TimeTradeServer();
    if(now<=0) now=TimeCurrent();
    bool accountReady=AimeRefreshAccountSnapshot();
    AimeRefreshProtectionState();
    if(!accountReady)
    {
        g_marginLevel=0.0;
        g_dailyNetPL=0.0;
        g_dailyLossPct=0.0;
        g_portfolioOpenRiskMoney=0.0;
        g_portfolioOpenRiskPct=100.0;
        return;
    }
    AimeRefreshDailyRiskBaseline();
    double equity=g_accountEquityLive;
    double balance=g_accountBalanceLive;
    g_marginLevel=g_accountMarginLevelLive;
    if(peakEquity<=0.0) peakEquity=equity;
    if(equity>peakEquity) peakEquity=equity;
    g_peakDrawdownPct=peakEquity>0.0?MathMax(0.0,((peakEquity-equity)/peakEquity)*100.0):0.0;
    g_dailyNetPL=AimeDailyTradingNetPL(AimeRiskDayStart(now),now);
    g_dailyLossPct=g_dayStartBalance>0.0?MathMax(0.0,(-g_dailyNetPL/g_dayStartBalance)*100.0):0.0;
    g_portfolioOpenRiskMoney=AimePortfolioOpenRiskMoney();
    g_portfolioOpenRiskPct=(equity>0.0 && g_portfolioOpenRiskMoney<DBL_MAX/2.0)?(g_portfolioOpenRiskMoney/equity)*100.0:100.0;
    g_recoveryDebt=MathMax(0.0,peakEquity-equity);
    if(g_recoveryDebt<=0.0)
    {
        g_recoveryMode="NORMAL";
        g_recoveryRecovered=0.0;
        g_recoveryBudgetUsed=0.0;
        g_recoveryCycleStart=0;
        g_recoveryStartEquity=equity;
    }
    else if(EnableRecoveryEngine && g_peakDrawdownPct<RecoveryMaxEntryDrawdownPct)
    {
        if(g_recoveryCycleStart==0)
        {
            g_recoveryCycleStart=now;
            g_recoveryStartEquity=equity;
            g_recoveryBudgetUsed=0.0;
        }
        g_recoveryMode=g_peakDrawdownPct>=RecoveryStartDrawdownPct?"RECOVERY":"CAUTION";
        double recovered=MathMax(0.0,equity-g_recoveryStartEquity);
        g_recoveryRecovered=recovered;
    }
    else if(g_peakDrawdownPct>=DrawdownHardStopPct) g_recoveryMode="HARD STOP";
    else g_recoveryMode="DEFENSIVE";
}

double AimeEffectiveRiskPct()
{
    double base=RiskPerTradePct;
    if(!EnableRecoveryEngine || g_recoveryMode!="RECOVERY") return base;
    double reduced=base*RecoveryRiskMultiplier;
    if(RecoveryMaxRiskPct>0.0) reduced=MathMin(reduced,RecoveryMaxRiskPct);
    return MathMax(0.0,reduced);
}

bool AimeRecoveryAllowsSignal(ENUM_ORDER_TYPE type,double score,string &reason)
{
    reason="";
    if(!EnableRecoveryEngine || g_recoveryMode!="RECOVERY") return true;
    if(g_peakDrawdownPct>=RecoveryMaxEntryDrawdownPct) { reason="RECOVERY DRAWdown LIMIT"; return false; }
    if(g_dailyLossPct>=DailyLossEntryBlockPct) { reason="DAILY LOSS LIMIT"; return false; }
    if(RecoveryMaxConsecutiveLosses>0 && consecutiveLossCount>=RecoveryMaxConsecutiveLosses) { reason="RECOVERY LOSS STREAK"; return false; }
    double required=MinSignalStrengthForLot*RecoveryMinSignalMultiplier;
    if(score<required) { reason="RECOVERY SIGNAL QUALITY"; return false; }
    if(RecoveryBudgetPct>0.0 && RecoveryStopAfterBudget)
    {
        double budget=AccountInfoDouble(ACCOUNT_EQUITY)*(RecoveryBudgetPct/100.0);
        if(g_recoveryBudgetUsed>=budget) { reason="RECOVERY BUDGET USED"; return false; }
    }
    if(RecoveryRequireTrendAlignment)
    {
        int idx=FindAssetIndex(g_activeSymbol);
        if(idx>=0 && g_assets[idx].strategyDirection!="" &&
           ((type==ORDER_TYPE_BUY && StringFind(g_assets[idx].strategyDirection,"BUY")<0) ||
            (type==ORDER_TYPE_SELL && StringFind(g_assets[idx].strategyDirection,"SELL")<0)))
        {
            reason="RECOVERY TREND MISALIGNMENT";
            return false;
        }
    }
    return true;
}

void AimeRegisterRecoveryRisk(double riskMoney)
{
    if(!EnableRecoveryEngine || g_recoveryMode!="RECOVERY" || riskMoney<=0.0) return;
    g_recoveryBudgetUsed+=riskMoney;
}

double CalculateDynamicLotSize(double signalScore = 0, ENUM_ORDER_TYPE orderType = ORDER_TYPE_BUY)
{
    if(!EnableDynamicLots) return BaseLotSize;

    double currentLot = BaseLotSize;
    double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);

    double equityDropPercent = 0;
    if(peakEquity > 0)
    {
        equityDropPercent = ((peakEquity - currentEquity) / peakEquity) * 100.0;
    }

    bool inCooldown = (cooldownUntilBarTime > 0 && iTime(g_activeSymbol, g_activePeriod, 0) < cooldownUntilBarTime);
    bool basketBleeding = (EnableBasketStop && GetTotalFloatingPL() < 0);

    int equitySteps = 0;
    if(equityDropPercent > 0 && EquityDropPercent > 0 && signalScore >= MinSignalStrengthForLot
       && !inCooldown && !basketBleeding)
    {
        equitySteps = (int)(equityDropPercent / EquityDropPercent);
        if(MaxEquityDropLotSteps > 0 && equitySteps > MaxEquityDropLotSteps)
            equitySteps = MaxEquityDropLotSteps;
    }

    double equityLotIncrease = equitySteps * LotStepSize;
    if(equitySteps > 0) equityLotIncrease = -equityLotIncrease;
    currentLot += equityLotIncrease;

    if(IsWithinSessionBoost() && signalScore >= MinSignalStrengthForLot)
        currentLot *= SessionBoostMultiplier;

    if(currentLot < BaseLotSize) currentLot = BaseLotSize;
    if(currentLot > MaxLotSize) currentLot = MaxLotSize;

    currentLot = NormalizeDouble(currentLot, 2);

    double minLot = SymbolInfoDouble(g_activeSymbol, SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(g_activeSymbol, SYMBOL_VOLUME_MAX);
    double lotStep = SymbolInfoDouble(g_activeSymbol, SYMBOL_VOLUME_STEP);

    if(currentLot < minLot) currentLot = minLot;
    if(currentLot > maxLot) currentLot = maxLot;

    currentLot = MathFloor(currentLot / lotStep) * lotStep;

    double marginNeeded = 0;

    if(!OrderCalcMargin(orderType, g_activeSymbol, currentLot, orderType == ORDER_TYPE_BUY ? SymbolInfoDouble(g_activeSymbol, SYMBOL_ASK) : SymbolInfoDouble(g_activeSymbol, SYMBOL_BID), marginNeeded))
    {
        LogPrint("ERROR: Failed to calculate margin: ", GetLastError());
        return minLot;
    }

    double availableMargin = AccountInfoDouble(ACCOUNT_MARGIN_FREE);

    if(marginNeeded > availableMargin)
    {
        double symbolLotStep = SymbolInfoDouble(g_activeSymbol, SYMBOL_VOLUME_STEP);
        double maxAffordableLot = minLot;
        double testMargin = 0;

        if (symbolLotStep == 0) symbolLotStep = 0.01;

        double testLot = minLot;

        while(testLot <= currentLot)
        {
            if(OrderCalcMargin(orderType, g_activeSymbol, testLot, orderType == ORDER_TYPE_BUY ? SymbolInfoDouble(g_activeSymbol, SYMBOL_ASK) : SymbolInfoDouble(g_activeSymbol, SYMBOL_BID), testMargin))
            {
                if(testMargin <= availableMargin)
                {
                    maxAffordableLot = testLot;
                    testLot += symbolLotStep;
                }
                else
                {
                    break;
                }
            }
            else
            {
                break;
            }
        }

        currentLot = maxAffordableLot;

        if(currentLot < minLot)
        {
            LogPrint("WARNING: Insufficient margin. Required: $", marginNeeded,
                  ", Available: $", availableMargin);
            return minLot;
        }

        LogPrint("WARNING: Reduced lot from calculated to affordable: ", currentLot,
              " (Required margin: $", marginNeeded, ", Available: $", availableMargin, ")");
    }

    LogPrint("Dynamic Lot Calculation: Base=", BaseLotSize,
             " | Equity Drop Steps=", equitySteps, " (+", equityLotIncrease, ")",
             " | Signal Steps=", (signalScore >= MinSignalStrengthForLot ? (signalScore - MinSignalStrengthForLot) / 2 : 0),
             " | Final Lot=", currentLot);

    return currentLot;
}

int AimeRiskDayCode(datetime t)
{
    MqlDateTime dt;
    TimeToStruct(t, dt);
    return dt.year * 10000 + dt.mon * 100 + dt.day;
}

datetime AimeRiskDayStart(datetime t)
{
    MqlDateTime dt;
    TimeToStruct(t, dt);
    dt.hour = 0;
    dt.min = 0;
    dt.sec = 0;
    return StructToTime(dt);
}

double AimeDailyClosedTradingNetPL(datetime fromTime, datetime toTime)
{
    if(toTime < fromTime) return 0.0;
    if(!HistorySelect(fromTime, toTime)) return 0.0;

    double total = 0.0;
    int deals = HistoryDealsTotal();

    for(int i = 0; i < deals; i++)
    {
        ulong ticket = HistoryDealGetTicket(i);
        if(ticket == 0) continue;

        long magic = HistoryDealGetInteger(ticket, DEAL_MAGIC);
        if(!IsAimeMagic(magic)) continue;

        ENUM_DEAL_TYPE type = (ENUM_DEAL_TYPE)HistoryDealGetInteger(ticket, DEAL_TYPE);
        if(type == DEAL_TYPE_BALANCE || type == DEAL_TYPE_CREDIT) continue;

        total += HistoryDealGetDouble(ticket, DEAL_PROFIT);
        total += HistoryDealGetDouble(ticket, DEAL_SWAP);
        total += HistoryDealGetDouble(ticket, DEAL_COMMISSION);
    }

    return total;
}

double AimeDailyTradingNetPL(datetime fromTime, datetime toTime)
{
    if(toTime < fromTime) return 0.0;

    if(!HistorySelect(fromTime, toTime))
        return GetPortfolioFloatingPL(false);

    double total = 0.0;
    int deals = HistoryDealsTotal();

    for(int i = 0; i < deals; i++)
    {
        ulong ticket = HistoryDealGetTicket(i);
        if(ticket == 0) continue;

        long magic = HistoryDealGetInteger(ticket, DEAL_MAGIC);
        if(!IsAimeMagic(magic)) continue;

        ENUM_DEAL_TYPE type = (ENUM_DEAL_TYPE)HistoryDealGetInteger(ticket, DEAL_TYPE);
        if(type == DEAL_TYPE_BALANCE || type == DEAL_TYPE_CREDIT) continue;

        total += HistoryDealGetDouble(ticket, DEAL_PROFIT);
        total += HistoryDealGetDouble(ticket, DEAL_SWAP);
        total += HistoryDealGetDouble(ticket, DEAL_COMMISSION);
    }

    total += GetPortfolioFloatingPL(false);
    return total;
}

double AimeDailyBalanceFlow(datetime fromTime, datetime toTime)
{
    if(toTime < fromTime) return 0.0;
    if(!HistorySelect(fromTime, toTime)) return 0.0;

    double total = 0.0;
    int deals = HistoryDealsTotal();

    for(int i = 0; i < deals; i++)
    {
        ulong ticket = HistoryDealGetTicket(i);
        if(ticket == 0) continue;

        ENUM_DEAL_TYPE type = (ENUM_DEAL_TYPE)HistoryDealGetInteger(ticket, DEAL_TYPE);
        if(type != DEAL_TYPE_BALANCE && type != DEAL_TYPE_CREDIT) continue;

        total += HistoryDealGetDouble(ticket, DEAL_PROFIT);
    }

    return total;
}

void AimeRefreshDailyRiskBaseline()
{
    datetime now = TimeTradeServer();
    if(now <= 0) now = TimeCurrent();

    int dayCode = AimeRiskDayCode(now);
    if(g_riskDayCode == dayCode && g_dayStartBalance > 0.0)
        return;

    datetime dayStart = AimeRiskDayStart(now);
    double currentBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    double tradingPL = AimeDailyClosedTradingNetPL(dayStart, now);
    double balanceFlow = AimeDailyBalanceFlow(dayStart, now);

    g_dayStartBalance = currentBalance - tradingPL - balanceFlow;
    if(g_dayStartBalance <= 0.0)
        g_dayStartBalance = MathMax(currentBalance, AccountInfoDouble(ACCOUNT_EQUITY));

    g_riskDayCode = dayCode;
    g_dailyRiskLocked = false;
    g_dailyNetPL = 0.0;
    g_dailyLossPct = 0.0;

    LogPrint("[RISK] New risk day baseline equity/balance = ", DoubleToString(g_dayStartBalance, 2));
}

int AimePortfolioExposureSlots()
{
    AimeReconcileAllPositions();
    int count=0;
    for(int i=PositionsTotal()-1;i>=0;i--)
    {
        ulong ticket=PositionGetTicket(i);
        if(ticket==0 || !PositionSelectByTicket(ticket)) continue;
        if(IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) count++;
    }
    return count;
}

int AimeSymbolExposureSlots(string symbol)
{
    int count=0;
    long magic=GetMagicForSymbol(symbol);
    if(magic<=0) return 0;
    for(int i=PositionsTotal()-1;i>=0;i--)
    {
        ulong ticket=PositionGetTicket(i);
        if(ticket==0 || !PositionSelectByTicket(ticket)) continue;
        if(PositionGetString(POSITION_SYMBOL)==symbol && (long)PositionGetInteger(POSITION_MAGIC)==magic) count++;
    }
    return count;
}

bool AimeAllPositionsProtected()
{
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
        if(!IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) continue;

        double sl = PositionGetDouble(POSITION_SL);
        if(sl <= 0.0)
            return false;
    }

    return true;
}

double AimePositionRiskMoney(ulong ticket)
{
    if(ticket == 0 || !PositionSelectByTicket(ticket)) return 0.0;
    if(!IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) return 0.0;

    string symbol = PositionGetString(POSITION_SYMBOL);
    double sl = PositionGetDouble(POSITION_SL);
    double volume = PositionGetDouble(POSITION_VOLUME);
    double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
    ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);

    if(sl <= 0.0) return DBL_MAX;

    ENUM_ORDER_TYPE orderType = (posType == POSITION_TYPE_BUY) ? ORDER_TYPE_BUY : ORDER_TYPE_SELL;
    double projected = 0.0;

    if(!OrderCalcProfit(orderType, symbol, volume, openPrice, sl, projected))
        return DBL_MAX;

    return MathAbs(projected);
}

double AimePortfolioOpenRiskMoney()
{
    double total = 0.0;

    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
        if(!IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) continue;

        double risk = AimePositionRiskMoney(ticket);
        if(risk >= DBL_MAX / 2.0)
            return DBL_MAX;

        total += risk;
    }

    return total;
}

double AimeClassOpenRiskMoney(string cls)
{
    double total = 0.0;

    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
        if(!IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) continue;

        string posSymbol = PositionGetString(POSITION_SYMBOL);
        if(AimeProfileClass(posSymbol) != cls) continue;

        double risk = AimePositionRiskMoney(ticket);
        if(risk >= DBL_MAX / 2.0)
            return DBL_MAX;

        total += risk;
    }

    return total;
}

double AimeClassRiskCapPct(string cls)
{
    if(cls == "METAL")  return MaxMetalClassRiskPct;
    if(cls == "INDEX")  return MaxIndexClassRiskPct;
    if(cls == "STOCK")  return MaxStockClassRiskPct;
    if(cls == "CRYPTO") return MaxCryptoClassRiskPct;
    return MaxFXClassRiskPct;
}

double AimeProjectedRiskMoney(ENUM_ORDER_TYPE orderType, double volume, double entryPrice, double stopPrice)
{
    if(stopPrice <= 0.0 || volume <= 0.0) return DBL_MAX;

    double projected = 0.0;

    if(!OrderCalcProfit(orderType, g_activeSymbol, volume, entryPrice, stopPrice, projected))
        return DBL_MAX;

    return MathAbs(projected);
}

bool AimeValidatePositionSize(double volume, ENUM_ORDER_TYPE orderType, double entryPrice, double stopPrice)
{
    if(volume<=0.0 || entryPrice<=0.0) return false;
    double minVol=SymbolInfoDouble(g_activeSymbol,SYMBOL_VOLUME_MIN);
    double maxVol=SymbolInfoDouble(g_activeSymbol,SYMBOL_VOLUME_MAX);
    double step=SymbolInfoDouble(g_activeSymbol,SYMBOL_VOLUME_STEP);
    if(minVol<=0.0 || maxVol<=0.0 || step<=0.0) return false;
    double normalized=MathRound(volume/step)*step;
    if(MathAbs(normalized-volume)>step*0.25) return false;
    if(volume<minVol || volume>maxVol) return false;
    if(MaxLotSize>0.0 && volume>MaxLotSize+1e-9) return false;
    if(stopPrice>0.0 && RiskPerTradePct>0.0)
    {
        double projected=0.0;
        if(!OrderCalcProfit(orderType,g_activeSymbol,volume,entryPrice,stopPrice,projected)) return false;
        double maxRisk=AccountInfoDouble(ACCOUNT_EQUITY)*(AimeEffectiveRiskPct()/100.0);
        if(maxRisk>0.0 && MathAbs(projected)>maxRisk+0.01) return false;
    }
    return true;
}

bool AimeRiskGovernorAllowsEntry(string &reason)
{
    if(!EnableRiskGovernor)
        return true;

    if(!AimeRefreshAccountSnapshot())
    {
        if(reason != "") reason = g_accountSnapshotReason;
        return false;
    }

    AimeRefreshDailyRiskBaseline();

    datetime now = TimeTradeServer();
    if(now <= 0) now = TimeCurrent();

    double equity = AccountInfoDouble(ACCOUNT_EQUITY);
    g_marginLevel = AccountInfoDouble(ACCOUNT_MARGIN_LEVEL);
    g_riskEntryBlocked = false;

    double tradingPL = AimeDailyTradingNetPL(AimeRiskDayStart(now), now);
    g_dailyNetPL = tradingPL;

    if(g_dayStartBalance > 0.0)
    {
        g_dailyLossPct = MathMax(0.0, (-g_dailyNetPL / g_dayStartBalance) * 100.0);
    }
    else
    {
        g_dailyLossPct = 0.0;
    }

    g_peakDrawdownPct = peakEquity > 0.0
        ? MathMax(0.0, ((peakEquity - equity) / peakEquity) * 100.0)
        : 0.0;

    double openRisk = AimePortfolioOpenRiskMoney();
    g_portfolioOpenRiskMoney = openRisk;
    g_portfolioOpenRiskPct = (equity > 0.0 && openRisk < DBL_MAX / 2.0)
        ? (openRisk / equity) * 100.0
        : 100.0;

    if(g_marginLevel > 0.0 && g_marginLevel <= MarginEmergencyLevel)
    {
        g_riskHardLocked = true;
        if(RiskGovernorFlattenOnMarginEmergency)
        {
            Print("[RISK GOVERNOR] EMERGENCY MARGIN LEVEL ", DoubleToString(g_marginLevel, 2),
                  "% <= ", DoubleToString(MarginEmergencyLevel, 2), "%. Flattening Aime portfolio.");
            CloseAllPortfolioPositions(false, false);
            AimeActivateInternalStop("RISK GOVERNOR HARD STOP");
        }

        if(reason != "") reason = "MARGIN EMERGENCY";
        return false;
    }

    if(g_dailyLossPct >= DailyLossHardStopPct)
    {
        g_dailyRiskLocked = true;
        g_riskHardLocked = true;

        if(RiskGovernorFlattenOnDailyHardStop)
        {
            Print("[RISK GOVERNOR] DAILY HARD STOP ", DoubleToString(g_dailyLossPct, 2),
                  "% >= ", DoubleToString(DailyLossHardStopPct, 2), "%. Flattening Aime portfolio.");
            CloseAllPortfolioPositions(false, false);
            AimeActivateInternalStop("RISK GOVERNOR HARD STOP");
        }

        if(reason != "") reason = "DAILY LOSS HARD STOP";
        return false;
    }

    if(g_peakDrawdownPct >= DrawdownHardStopPct)
    {
        g_peakRiskLocked = true;
        g_riskHardLocked = true;

        if(RiskGovernorFlattenOnDrawdownHardStop)
        {
            Print("[RISK GOVERNOR] DRAWDOWN HARD STOP ", DoubleToString(g_peakDrawdownPct, 2),
                  "% >= ", DoubleToString(DrawdownHardStopPct, 2), "%. Flattening Aime portfolio.");
            CloseAllPortfolioPositions(false, false);
            AimeActivateInternalStop("RISK GOVERNOR HARD STOP");
        }

        if(reason != "") reason = "DRAWDOWN HARD STOP";
        return false;
    }

    if(g_riskHardLocked)
    {
        if(reason != "") reason = "RISK HARD LOCK";
        return false;
    }

    if(RiskGovernorBlockAfterDailyLoss && g_dailyRiskLocked)
    {
        g_riskEntryBlocked = true;
        if(reason != "") reason = "DAILY LOSS LOCK";
        return false;
    }

    if(g_dailyLossPct >= DailyLossEntryBlockPct)
    {
        g_dailyRiskLocked = true;
        g_riskEntryBlocked = true;

        Print("[RISK GOVERNOR] New entries blocked for risk day. Daily loss ",
              DoubleToString(g_dailyLossPct, 2), "% >= ",
              DoubleToString(DailyLossEntryBlockPct, 2), "%");

        if(reason != "") reason = "DAILY LOSS ENTRY BLOCK";
        return false;
    }

    if(g_peakDrawdownPct >= DrawdownEntryBlockPct)
    {
        g_peakRiskLocked = true;
        g_riskEntryBlocked = true;

        if(reason != "") reason = "DRAWDOWN ENTRY BLOCK";
        return false;
    }

    if(g_peakRiskLocked && g_peakDrawdownPct > (DrawdownEntryBlockPct - 1.0))
    {
        g_riskEntryBlocked = true;
        if(reason != "") reason = "DRAWDOWN RECOVERY LOCK";
        return false;
    }

    if(g_marginLevel > 0.0 && g_marginLevel <= MarginEntryBlockLevel)
    {
        g_riskEntryBlocked = true;
        if(reason != "") reason = "MARGIN ENTRY BLOCK";
        return false;
    }

    int portfolioExposure = AimePortfolioExposureSlots();
    if(MaxPortfolioPositions > 0 && portfolioExposure >= MaxPortfolioPositions)
    {
        g_riskEntryBlocked = true;
        if(reason != "") reason = "PORTFOLIO POSITION LIMIT";
        return false;
    }

    if(RiskGovernorRequireAllPositionsProtected && !AimeAllPositionsProtected())
    {
        g_riskEntryBlocked = true;
        if(reason != "") reason = "UNPROTECTED POSITION";
        return false;
    }

    if(MaxPortfolioOpenRiskPct > 0.0 && g_portfolioOpenRiskPct >= MaxPortfolioOpenRiskPct)
    {
        g_riskEntryBlocked = true;
        if(reason != "") reason = "PORTFOLIO OPEN RISK LIMIT";
        return false;
    }

    int symbolExposure = AimeSymbolExposureSlots(g_activeSymbol);
    if(MaxPositionsPerSymbol > 0 && symbolExposure >= MaxPositionsPerSymbol)
    {
        g_riskEntryBlocked = true;
        if(reason != "") reason = "SYMBOL POSITION LIMIT";
        return false;
    }

    return true;
}

bool AimeRiskCheckNewOrder(ENUM_ORDER_TYPE orderType, double volume, double entryPrice, double stopPrice)
{
    if(!g_accountSnapshotValid && !AimeRefreshAccountSnapshot())
    {
        LogPrint("[RISK GOVERNOR] BLOCKED: ",g_accountSnapshotReason);
        return false;
    }
    if(!EnableRiskGovernor)
        return true;

    if(!RiskGovernorRequireStopLoss && stopPrice <= 0.0)
        return true;

    if(RiskGovernorRequireStopLoss && stopPrice <= 0.0)
    {
        LogPrint("[RISK GOVERNOR] BLOCKED: protective stop required for ", g_activeSymbol);
        return false;
    }

    double equity = AccountInfoDouble(ACCOUNT_EQUITY);
    double maxRiskMoney = equity * (AimeEffectiveRiskPct() / 100.0);
    double newRiskMoney = AimeProjectedRiskMoney(orderType, volume, entryPrice, stopPrice);

    if(newRiskMoney >= DBL_MAX / 2.0)
    {
        LogPrint("[RISK GOVERNOR] BLOCKED: unable to calculate order risk for ", g_activeSymbol);
        return false;
    }

    if(maxRiskMoney > 0.0 && newRiskMoney > maxRiskMoney + 0.01)
    {
        LogPrint("[RISK GOVERNOR] BLOCKED: projected trade risk $",
                 DoubleToString(newRiskMoney, 2),
                 " > allowed $", DoubleToString(maxRiskMoney, 2),
                 " (", DoubleToString(RiskPerTradePct, 2), "%)");
        return false;
    }

    double newPortfolioRiskPct = (equity > 0.0)
        ? ((g_portfolioOpenRiskMoney + newRiskMoney) / equity) * 100.0
        : 100.0;

    if(MaxPortfolioOpenRiskPct > 0.0 && newPortfolioRiskPct > MaxPortfolioOpenRiskPct + 0.0001)
    {
        LogPrint("[RISK GOVERNOR] BLOCKED: portfolio open risk would reach ",
                 DoubleToString(newPortfolioRiskPct, 2),
                 "% > limit ", DoubleToString(MaxPortfolioOpenRiskPct, 2), "%");
        return false;
    }

    return true;
}

string AimePauseReasonText()
{
    if(g_pauseReason == "" || g_pauseReason == "NONE")
        return "NONE";
    return g_pauseReason;
}

int AimePauseRemainingSeconds()
{
    if(!isPaused || !g_pauseTemporary || g_pauseUntil <= 0)
        return 0;

    datetime now = TimeTradeServer();
    if(now <= 0) now = TimeCurrent();

    if(g_pauseUntil <= now)
        return 0;

    return (int)(g_pauseUntil - now);
}

string AimePauseRemainingText()
{
    int seconds = AimePauseRemainingSeconds();
    if(seconds <= 0)
        return g_pauseTemporary ? "RESUME DUE" : "RESUME BY CONDITION";

    int hours = seconds / 3600;
    int mins = (seconds % 3600) / 60;
    int secs = seconds % 60;

    if(hours > 0)
        return StringFormat("RESUME %02d:%02d:%02d", hours, mins, secs);

    return StringFormat("RESUME %02d:%02d", mins, secs);
}

void SetTemporaryPauseState(string reason, int minutes)
{
    datetime now = TimeTradeServer();
    if(now <= 0) now = TimeCurrent();

    if(minutes < 1) minutes = 1;

    isPaused = true;
    pauseStartTime = now;
    currentPauseDuration = minutes;
    g_pauseReason = reason;
    g_pauseUntil = now + minutes * 60;
    g_pauseTemporary = true;
}

void SetPersistentPauseState(string reason)
{
    datetime now = TimeTradeServer();
    if(now <= 0) now = TimeCurrent();

    isPaused = true;
    pauseStartTime = now;
    currentPauseDuration = 0;
    g_pauseReason = reason;
    g_pauseUntil = 0;
    g_pauseTemporary = false;
}

void ClearPauseState(string expectedReason = "")
{
    if(expectedReason != "" && g_pauseReason != expectedReason)
        return;

    isPaused = false;
    currentPauseDuration = 0;
    pauseStartTime = 0;
    g_pauseReason = "NONE";
    g_pauseUntil = 0;
    g_pauseTemporary = false;
}

void UpdatePauseLifecycle()
{
    if(!isPaused || !g_pauseTemporary || g_pauseUntil <= 0)
        return;

    datetime now = TimeTradeServer();
    if(now <= 0) now = TimeCurrent();

    if(now < g_pauseUntil)
        return;

    string oldReason = g_pauseReason;
    ClearPauseState();

    LogPrint("TRADING PAUSE EXPIRED - RESUMING ENTRY EVALUATION | Previous Reason: ", oldReason);
}

string AimeEntryBlockReason()
{
    if(g_emergencyStop)
        return "EMERGENCY STOP";

    if(targetEquityReached || minimumEquityReached || minEquityTriggersExceeded)
        return "RISK STOP";

    if(g_riskHardLocked)
        return "RISK HARD LOCK";

    if(g_dailyRiskLocked)
        return "DAILY LOSS LOCK";

    if(g_peakRiskLocked)
        return "DRAWDOWN LOCK";

    if(isPaused)
        return AimePauseReasonText();

    if(isLeverageDiffFromInitial)
        return "LEVERAGE CHANGE";

    if(isOutsideTradingHours)
        return "OUTSIDE SESSION";

    if(isNearMarketClose)
        return "MARKET CLOSE";

    if(IsSpreadTooWide())
        return "SPREAD TOO WIDE";

    return "NONE";
}

bool IsAllowedToOpenPosition()
{
    if(g_emergencyStop)
    {
        LogPrint("OPEN ORDER BLOCKED: EMERGENCY STOP | ", g_emergencyStopReason);
        return false;
    }
    if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) || !MQLInfoInteger(MQL_TRADE_ALLOWED))
    {
        LogPrint("OPEN ORDER BLOCKED: terminal or EA trading permission disabled | ",g_activeSymbol);
        return false;
    }
    string riskReason = "";
    if(!AimeRiskGovernorAllowsEntry(riskReason))
    {
        LogPrint("OPEN ORDER BLOCKED: ", riskReason, " | ", g_activeSymbol);
        return false;
    }

    if(!AimeSymbolReady())
    {
        LogPrint("OPEN ORDER BLOCKED: symbol data or trading properties are not ready for ", g_activeSymbol);
        return false;
    }

    string brokerSessionStatus = "";
    if(!AimeBrokerSessionOpen(g_activeSymbol, brokerSessionStatus))
    {
        LogPrint("OPEN ORDER BLOCKED: ", brokerSessionStatus, " | ", g_activeSymbol);
        return false;
    }

    if(EnableTradingHours && !IsWithinTradingHours())
    {
        LogPrint("OPEN ORDER BLOCKED: configured trading hours are closed | ", g_activeSymbol);
        return false;
    }

    if(EnablePortfolioPositionLimit && MaxPortfolioPositions > 0)
    {
        int portfolioOpen = 0;
        for(int i = PositionsTotal() - 1; i >= 0; i--)
        {
            ulong ticket = PositionGetTicket(i);
            if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
            if(IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC)))
                portfolioOpen++;
        }
        if(portfolioOpen >= MaxPortfolioPositions)
        {
            LogPrint("OPEN ORDER BLOCKED: portfolio position limit reached ", portfolioOpen, " / ", MaxPortfolioPositions);
            return false;
        }
    }

    if (targetEquityReached || minimumEquityReached || minEquityTriggersExceeded)
    {
        LogPrint("+-----------------------------------------+");
        LogPrint("OPEN ORDER BLOCKED!");
        LogPrint("Trading Stopped! Opening new order are not allowed!");
        LogPrint("+-----------------------------------------+");
        return false;
    }

    if (isPaused || isOutsideTradingHours || isLeverageDiffFromInitial)
    {
        LogPrint("+-----------------------------------------+");
        LogPrint("OPEN ORDER BLOCKED!");
        LogPrint("Trading Paused! Opening new order are not allowed during pause period!");
        LogPrint("+-----------------------------------------+");
        return false;
    }

    if(isNearMarketClose)
    {
        LogPrint("+-----------------------------------------+");
        LogPrint("OPEN ORDER BLOCKED!");
        LogPrint("Market closing soon! No opening new positions.");
        LogPrint("+-----------------------------------------+");
        return false;
    }

    string lossLimitReason = AimeLossLimitReason();
    if(lossLimitReason != "")
    {
        LogPrint("OPEN ORDER BLOCKED: ", lossLimitReason);
        return false;
    }

    if (CountOpenOrders() >= MaxOpenOrders)
    {
        LogPrint("+-----------------------------------------+");
        LogPrint("OPEN ORDER BLOCKED!");
        LogPrint("Maximum consecutive open order reached!");
        LogPrint("+-----------------------------------------+");
        return false;
    }

    if (isOrderSendLocked) {
        LogPrint("+-----------------------------------------+");
        LogPrint("OPEN ORDER BLOCKED!");
        LogPrint("An order is still being processed!");
        LogPrint("+-----------------------------------------+");
        return false;
    }

    if (IsSpreadTooWide())
    {
        LogPrint("+-----------------------------------------+");
        LogPrint("OPEN ORDER BLOCKED!");
        LogPrint("Spread too wide for entry.");
        LogPrint("+-----------------------------------------+");
        return false;
    }

    return true;
}

void RunPortfolioGuards()
{
    UpdatePauseLifecycle();
    CheckAlgoTradingStatus();
    CheckPeakEquity();
    CheckTargetEquity();
    CheckMinTradeableEquity();
    CheckEquityDrawdawn();
    CheckLeverageChange();
    string portfolioRiskReason = "";
    AimeRiskGovernorAllowsEntry(portfolioRiskReason);

    if(EnableBasketStop && MaxBasketLossPct > 0)
    {
        double equity = AccountInfoDouble(ACCOUNT_EQUITY);
        double floatingPL = GetPortfolioFloatingPL(true);
        if(equity > 0 && floatingPL < 0)
        {
            double lossPct = (-floatingPL / equity) * 100.0;
            if(lossPct >= MaxBasketLossPct)
            {
                Print("[PORTFOLIO STOP] Floating loss ", DoubleToString(lossPct, 2),
                      "% >= ", DoubleToString(MaxBasketLossPct, 2), "%");
                CloseAllPortfolioPositions(false, true);
                if(!isPaused)
                {
                    int pauseMinutes = (MaxPauseMinutes > 0) ? MathMin(PauseMinutes, MaxPauseMinutes) : PauseMinutes;
                    SetTemporaryPauseState("BASKET LOSS", pauseMinutes);
                    totalPauseCount++;
                    totalPauseDurationMinutes += currentPauseDuration;
                }
            }
        }
    }

    if(targetEquityReached || minimumEquityReached || minEquityTriggersExceeded)
    {
        CloseAllPortfolioPositions();
        AimeActivateInternalStop("RISK GOVERNOR HARD STOP");
    }
}

void UpdateDashboard(bool force = false);

void InvalidateActiveSignalCaches()
{
    _buyStrengthValid = false;
    _sellStrengthValid = false;
    buyStrengthCacheBarTime = 0;
    sellStrengthCacheBarTime = 0;
    buyStrengthCacheSymbol = "";
    sellStrengthCacheSymbol = "";
}

void ProcessActiveAsset(bool runPortfolioGuards)
{
    if(!passwordVerified) return;
    if(g_activeIndex < 0 || g_activeIndex >= g_assetCount) return;

    AimeReconcileAssetPositions(g_activeIndex);

    if(g_assets[g_activeIndex].quarantined) return;

    if(runPortfolioGuards)
        RunPortfolioGuards();

    string dataReason = "";
    bool dataReady = AimePrepareAssetData(g_activeIndex,dataReason);
    long activeBarAge = AimeAssetBarAgeSeconds(g_activeIndex);
    if(!dataReady && dataReason == "")
        dataReason = g_assets[g_activeIndex].dataReason;

    string brokerSessionStatus = "";
    bool brokerSessionOpen = AimeBrokerSessionOpen(g_activeSymbol, brokerSessionStatus);
    isOutsideTradingHours = !brokerSessionOpen || (EnableTradingHours && !IsWithinTradingHours());

    datetime currBarTime = iTime(g_activeSymbol, g_activePeriod, 0);
    bool newBar = (currBarTime > 0 && currentBarTime != currBarTime);

    if(newBar)
    {
        lastBuySignalScorePrev = lastBuySignalScore;
        lastSellSignalScorePrev = lastSellSignalScore;

        if(buysOnCurrentBar > 0)
        {
            consecutiveBuyCandles++;
            prevBarHadBuys = true;
        }
        else
        {
            consecutiveBuyCandles = 0;
            prevBarHadBuys = false;
        }

        if(sellsOnCurrentBar > 0)
        {
            consecutiveSellCandles++;
            prevBarHadSells = true;
        }
        else
        {
            consecutiveSellCandles = 0;
            prevBarHadSells = false;
        }

        currentBarTime = currBarTime;
        buysOnCurrentBar = 0;
        sellsOnCurrentBar = 0;
    }

    if(dataReady)
    {
        InvalidateActiveSignalCaches();
        GetSignalStrength(ORDER_TYPE_BUY);
        GetSignalStrength(ORDER_TYPE_SELL);
        AimeUpdateStrategySnapshot();
    }
    else
    {
        g_strategyDataReady = false;
        g_strategyDirection = "WAIT";
        g_strategyFinalDecision = "WAIT";
        g_strategyEdge = 0.0;
        g_strategySetupQuality = 0.0;
        g_strategyTimingQuality = 0.0;
        g_strategySetupPass = false;
        g_strategyTimingPass = false;
        g_strategyRegime = "DATA_WAIT";
        g_strategyReason = dataReason == "" ? g_assets[g_activeIndex].dataReason : dataReason;
        InvalidateActiveSignalCaches();
    }

    ManagePositions();

    if(targetEquityReached || minimumEquityReached || minEquityTriggersExceeded)
    {
        return;
    }

    if(!dataReady)
    {
        SaveAssetContext();
        return;
    }

    if(!brokerSessionOpen)
    {
        SaveAssetContext();
        return;
    }

    if(EnableTradingHours && !IsWithinTradingHours())
    {
        SaveAssetContext();
        return;
    }

    CheckMarketClose();

    if(newBar || !EnableNewBarEntryOnly)
        CheckForTradingSignal();

}

void ProcessAllAssets()
{
    if(!g_multiAssetInitialized || g_portfolioCycleRunning || g_executionCycleRunning)
        return;

    g_executionCycleRunning = true;
    g_portfolioCycleRunning = true;

    AimeReconcileAllPositions();
    RunPortfolioGuards();

    int snapshot = g_assetCount;

    for(int i = 0; i < snapshot; i++)
    {
        if(i < 0 || i >= g_assetCount) continue;
        if(!g_assets[i].initialized || g_assets[i].quarantined) continue;

        LoadAssetContext(i);
        ProcessActiveAsset(false);
        SaveAssetContext();
    }

    int chartIndex = FindAssetIndex(g_chartSymbol);
    if(chartIndex >= 0)
        LoadAssetContext(chartIndex);

    g_lastPortfolioCycle = TimeCurrent();

    g_portfolioCycleRunning = false;
    g_executionCycleRunning = false;

    AimeScanMarketWatchAssets();
}

bool CreatePasswordDialog()
{
    if(!passwordDialog.Create(0, "PasswordDialog", 0, 10, 10, 324, 120))
        return false;

    passwordDialog.Caption("Enter Password to Use Aime Programmer EA");

    if(!passwordEdit.Create(0, "PasswordEdit", 0, 5, 10, 300, 35))
        return false;

    passwordEdit.Text("");

    if(!passwordDialog.Add(passwordEdit))
        return false;

    if(!passwordSubmitBtn.Create(0, "PasswordSubmit", 0, 5, 45, 100, 75))
        return false;

    passwordSubmitBtn.Text("Submit");

    if(!passwordDialog.Add(passwordSubmitBtn))
        return false;

    return true;
}

bool ValidateExecutionSymbol(const string symbol,const ENUM_ORDER_TYPE order_type,const double volume,const double sl,const double tp)
{
   if(symbol=="" || !SymbolSelect(symbol,true)) return false;
   long trade_mode=0;
   if(!SymbolInfoInteger(symbol,SYMBOL_TRADE_MODE,trade_mode)) return false;
   if(trade_mode==SYMBOL_TRADE_MODE_DISABLED) return false;
   if(order_type==ORDER_TYPE_BUY && trade_mode==SYMBOL_TRADE_MODE_SHORTONLY) return false;
   if(order_type==ORDER_TYPE_SELL && trade_mode==SYMBOL_TRADE_MODE_LONGONLY) return false;
   double vmin=0,vmax=0,vstep=0;
   if(!SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN,vmin) || !SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX,vmax) || !SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP,vstep)) return false;
   if(volume<vmin || volume>vmax || vstep<=0) return false;
   double point=SymbolInfoDouble(symbol,SYMBOL_POINT);
   double bid=SymbolInfoDouble(symbol,SYMBOL_BID);
   double ask=SymbolInfoDouble(symbol,SYMBOL_ASK);
   if(point<=0 || bid<=0 || ask<=0) return false;
   long stops=0,freeze=0;
   SymbolInfoInteger(symbol,SYMBOL_TRADE_STOPS_LEVEL,stops);
   SymbolInfoInteger(symbol,SYMBOL_TRADE_FREEZE_LEVEL,freeze);
   double min_distance=(double)MathMax(stops,freeze)*point;
   if(order_type==ORDER_TYPE_BUY)
   {
      if(sl>0 && bid-sl<min_distance) return false;
      if(tp>0 && tp-bid<min_distance) return false;
   }
   else if(order_type==ORDER_TYPE_SELL)
   {
      if(sl>0 && sl-ask<min_distance) return false;
      if(tp>0 && ask-tp<min_distance) return false;
   }
   return true;
}

void AimeWritePersistentLog(string message, string logType = "INFO")
{
    string fileName = "Aime_EA_Log_" + TimeToString(TimeCurrent(), TIME_DATE) + ".txt";
    int handle = FileOpen(fileName, FILE_TXT | FILE_READ | FILE_WRITE | FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_COMMON, "\t");
    if(handle == INVALID_HANDLE) return;
    FileSeek(handle, 0, SEEK_END);
    FileWriteString(handle, TimeToString(TimeCurrent(), TIME_DATE | TIME_SECONDS) + " [" + logType + "] " + message + "\r\n");
    FileClose(handle);
}

string AimeStateKey(string suffix)
{
    long login=AccountInfoInteger(ACCOUNT_LOGIN);
    return "AIME45_"+IntegerToString((int)login)+"_"+suffix;
}

void AimeSavePersistentState()
{
    GlobalVariableSet(AimeStateKey("EMERGENCY"),g_emergencyStop?1.0:0.0);
    GlobalVariableSet(AimeStateKey("EMERGENCY_SOURCE"),g_emergencySource=="MANUAL"?1.0:(g_emergencySource=="RISK"?2.0:0.0));
    GlobalVariableSet(AimeStateKey("DASHTAB"),(double)g_dashTab);
    GlobalVariableSet(AimeStateKey("THEME"),g_darkTheme?1.0:0.0);
    GlobalVariableSet(AimeStateKey("INITIAL_BALANCE"),initialBalance);
    GlobalVariableSet(AimeStateKey("PEAK_EQUITY"),peakEquity);
    GlobalVariableSet(AimeStateKey("DAY_START_BALANCE"),g_dayStartBalance);
    GlobalVariableSet(AimeStateKey("RISK_DAY"),(double)g_riskDayCode);
    GlobalVariableSet(AimeStateKey("DAILY_LOCK"),g_dailyRiskLocked?1.0:0.0);
    GlobalVariableSet(AimeStateKey("RISK_HARD_LOCK"),g_riskHardLocked?1.0:0.0);
    GlobalVariableSet(AimeStateKey("PEAK_LOCK"),g_peakRiskLocked?1.0:0.0);
    GlobalVariableSet(AimeStateKey("TARGET_REACHED"),targetEquityReached?1.0:0.0);
    GlobalVariableSet(AimeStateKey("MIN_EQUITY_REACHED"),minimumEquityReached?1.0:0.0);
}

void AimeLoadPersistentState()
{
    string k;
    k=AimeStateKey("EMERGENCY"); if(GlobalVariableCheck(k)) g_emergencyStop=GlobalVariableGet(k)>0.5;
    k=AimeStateKey("EMERGENCY_SOURCE"); if(GlobalVariableCheck(k)) { double src=GlobalVariableGet(k); g_emergencySource=src==1.0?"MANUAL":(src==2.0?"RISK":"UNKNOWN"); }
    k=AimeStateKey("DASHTAB"); if(GlobalVariableCheck(k)) g_dashTab=(int)GlobalVariableGet(k);
    k=AimeStateKey("THEME"); if(GlobalVariableCheck(k)) g_darkTheme=GlobalVariableGet(k)>0.5;
    k=AimeStateKey("INITIAL_BALANCE"); if(GlobalVariableCheck(k) && GlobalVariableGet(k)>0.0) initialBalance=GlobalVariableGet(k);
    k=AimeStateKey("PEAK_EQUITY"); if(GlobalVariableCheck(k) && GlobalVariableGet(k)>0.0) peakEquity=MathMax(peakEquity,GlobalVariableGet(k));
    k=AimeStateKey("DAY_START_BALANCE"); if(GlobalVariableCheck(k) && GlobalVariableGet(k)>0.0) g_dayStartBalance=GlobalVariableGet(k);
    k=AimeStateKey("RISK_DAY"); if(GlobalVariableCheck(k)) g_riskDayCode=(int)GlobalVariableGet(k);
    k=AimeStateKey("DAILY_LOCK"); if(GlobalVariableCheck(k)) g_dailyRiskLocked=GlobalVariableGet(k)>0.5;
    k=AimeStateKey("RISK_HARD_LOCK"); if(GlobalVariableCheck(k)) g_riskHardLocked=GlobalVariableGet(k)>0.5;
    k=AimeStateKey("PEAK_LOCK"); if(GlobalVariableCheck(k)) g_peakRiskLocked=GlobalVariableGet(k)>0.5;
    k=AimeStateKey("TARGET_REACHED"); if(GlobalVariableCheck(k)) targetEquityReached=GlobalVariableGet(k)>0.5;
    k=AimeStateKey("MIN_EQUITY_REACHED"); if(GlobalVariableCheck(k)) minimumEquityReached=GlobalVariableGet(k)>0.5;
    if(g_emergencyStop) g_emergencyStopReason="PERSISTED EMERGENCY STOP";
}

void AimePlayTradeSound(string soundType)
{
    if(!EnableTradeSounds) return;
    string file="Aime_Alert_"+soundType+".wav";
    PlaySound(file);
}

string AimeLanguageText(string en,string fr,string rw)
{
    if(DashboardLanguage==AIME_LANG_FR) return fr;
    if(DashboardLanguage==AIME_LANG_RW) return rw;
    return en;
}

void AimeActivateInternalStop(string reason)
{
    g_emergencyStop=true;
    g_emergencyStopReason=reason;
    g_emergencySource="RISK";
    AimeSavePersistentState();
    AimeWritePersistentLog("INTERNAL STOP: "+reason,"RISK");
}

string AimeSessionName()
{
    datetime now = TimeTradeServer();
    if(now <= 0) now = TimeCurrent();
    MqlDateTime dt;
    TimeToStruct(now, dt);
    int h = dt.hour;
    if(h < 8) return "ASIA";
    if(h < 15) return "LONDON";
    if(h < 18) return "NEW YORK";
    return "OFF-SESSION";
}

bool AimeCloseDealAttempt(ulong ticket, string symbol, long magic, ENUM_POSITION_TYPE type, double volume, ENUM_ORDER_TYPE_FILLING filling, uint deviation, MqlTradeResult &result)
{
    if(!PositionSelectByTicket(ticket)) return true;
    MqlTick t;
    if(!SymbolInfoTick(symbol, t)) return false;
    MqlTradeRequest request = {};
    request.action = TRADE_ACTION_DEAL;
    request.position = ticket;
    request.symbol = symbol;
    request.volume = volume;
    request.deviation = deviation;
    request.magic = magic;
    request.type = type == POSITION_TYPE_BUY ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
    request.price = type == POSITION_TYPE_BUY ? t.bid : t.ask;
    request.type_filling = filling;
    return AimeOrderSendWithRetry(request, result, 3);
}

bool ForceClosePosition(ulong ticket)
{
    if(!PositionSelectByTicket(ticket)) return false;
    string symbol = PositionGetString(POSITION_SYMBOL);
    long magic = (long)PositionGetInteger(POSITION_MAGIC);
    if(!IsAimeMagic(magic)) return false;
    if(!SymbolSelect(symbol, true)) return false;
    ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
    double volume = PositionGetDouble(POSITION_VOLUME);
    if(volume <= 0.0) return false;
    uint fillingMask = (uint)SymbolInfoInteger(symbol, SYMBOL_FILLING_MODE);
    long execution = SymbolInfoInteger(symbol, SYMBOL_TRADE_EXEMODE);
    ENUM_ORDER_TYPE_FILLING modes[3];
    int modeCount = 0;
    if((fillingMask & SYMBOL_FILLING_FOK) != 0) modes[modeCount++] = ORDER_FILLING_FOK;
    if((fillingMask & SYMBOL_FILLING_IOC) != 0) modes[modeCount++] = ORDER_FILLING_IOC;
    if(execution != SYMBOL_TRADE_EXECUTION_MARKET) modes[modeCount++] = ORDER_FILLING_RETURN;
    if(modeCount == 0) modes[modeCount++] = GetFillingModeForSymbol(symbol);
    for(int attempt = 0; attempt < modeCount; attempt++)
    {
        if(!PositionSelectByTicket(ticket))
        {
            RemoveManagedPosition(ticket);
            return true;
        }
        volume = PositionGetDouble(POSITION_VOLUME);
        MqlTradeResult result = {};
        bool accepted = AimeCloseDealAttempt(ticket, symbol, magic, type, volume, modes[attempt], 50, result);
        AimeWritePersistentLog(StringFormat("FORCE_CLOSE ticket=%I64u symbol=%s volume=%.8f retcode=%u comment=%s", ticket, symbol, volume, result.retcode, result.comment), accepted ? "TRADE" : "ERROR");
        if(accepted)
        {
            AimePlayTradeSound("Close");
            if(!PositionSelectByTicket(ticket))
            {
                RemoveManagedPosition(ticket);
                return true;
            }
            if(result.retcode == TRADE_RETCODE_DONE_PARTIAL) continue;
        }
    }
    return !PositionSelectByTicket(ticket);
}

void ForceCloseAllPositions()
{
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
        if(IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) ForceClosePosition(ticket);
    }
    AimeReconcileAllPositions();
    UpdateDashboard(true);
}

void ForceCloseSelectedPosition()
{
    ulong ticket = g_dashboardSelectedPositionTicket;
    if(ticket == 0 || !PositionSelectByTicket(ticket))
    {
        g_dashboardSelectedPositionTicket = 0;
        AimeWritePersistentLog("CLOSE_SELECTED requested with no valid selection", "WARN");
        UpdateDashboard(true);
        return;
    }
    ForceClosePosition(ticket);
    if(!PositionSelectByTicket(ticket)) g_dashboardSelectedPositionTicket = 0;
    AimeSavePersistentState();
    UpdateDashboard(true);
}

void ForceDeleteAllAimeOrders()
{
    for(int i = OrdersTotal() - 1; i >= 0; i--)
    {
        ulong ticket = OrderGetTicket(i);
        if(ticket == 0 || !OrderSelect(ticket)) continue;
        if(!IsAimeMagic((long)OrderGetInteger(ORDER_MAGIC))) continue;
        MqlTradeRequest request = {};
        MqlTradeResult result = {};
        request.action = TRADE_ACTION_REMOVE;
        request.order = ticket;
        ResetLastError();
        bool sent = AimeOrderSendWithRetry(request, result, 3);
        AimeWritePersistentLog(StringFormat("DELETE_ORDER ticket=%I64u retcode=%u comment=%s", ticket, result.retcode, result.comment), sent && result.retcode == TRADE_RETCODE_DONE ? "TRADE" : "ERROR");
    }
}

void EmergencyStop()
{
    g_emergencyStop = true;
    g_emergencyStopReason = "MANUAL EMERGENCY STOP";
    g_emergencySource = "MANUAL";
    AimeSavePersistentState();
    AimeWritePersistentLog("EMERGENCY STOP TRIGGERED", "EMERGENCY");
    ForceCloseAllPositions();
    ForceDeleteAllAimeOrders();
    AimeWritePersistentLog("EMERGENCY STOP FLATTEN COMMAND COMPLETED", "EMERGENCY");
    UpdateDashboard(true);
}

void ResumeAfterEmergencyStop()
{
    if(!AimeRefreshAccountSnapshot())
    {
        LogPrint("RESUME BLOCKED: ",g_accountSnapshotReason);
        UpdateDashboard(true);
        return;
    }
    AimeRefreshProtectionState();

    double resumeEquity = AccountInfoDouble(ACCOUNT_EQUITY);
    if(minimumEquityReached && MinimumEquity > 0.0 && resumeEquity > MinimumEquity)
    {
        LogPrint("[RESUME] Clearing stale MINIMUM EQUITY latch — equity $", DoubleToString(resumeEquity,2),
                 " is now above minimum $", DoubleToString(MinimumEquity,2), ".");
        minimumEquityReached = false;
        minEquityTriggerCount = 0;
        minEquityTriggersExceeded = false;
    }
    if(targetEquityReached)
    {
        LogPrint("[RESUME] Clearing TARGET EQUITY latch — explicit user resume overrides it.");
        targetEquityReached = false;
    }

    bool marginHealthy = (g_marginLevel <= 0.0) || (g_marginLevel > MarginEmergencyLevel);
    bool dailyHealthy = g_dailyLossPct < DailyLossHardStopPct;
    bool drawdownHealthy = g_peakDrawdownPct < DrawdownHardStopPct;
    if(g_riskHardLocked && marginHealthy && dailyHealthy && drawdownHealthy)
    {
        LogPrint("[RESUME] Clearing stale RISK HARD LOCK — margin/daily/drawdown all currently healthy.");
        g_riskHardLocked = false;
    }
    if(g_peakRiskLocked && drawdownHealthy)
    {
        LogPrint("[RESUME] Clearing stale PEAK DRAWDOWN LOCK — drawdown ", DoubleToString(g_peakDrawdownPct,2),
                 "% is now below ", DoubleToString(DrawdownHardStopPct,2), "% threshold.");
        g_peakRiskLocked = false;
    }

    if(g_riskHardLocked || g_dailyRiskLocked || g_peakRiskLocked || targetEquityReached || minimumEquityReached || minEquityTriggersExceeded)
    {
        LogPrint("RESUME BLOCKED: active risk hard-stop condition remains. RiskHard=",g_riskHardLocked,
                 " Daily=",g_dailyRiskLocked," Peak=",g_peakRiskLocked," MinEquity=",minimumEquityReached,
                 " MinEquityTriggers=",minEquityTriggersExceeded);
        UpdateDashboard(true);
        return;
    }
    g_emergencyStop = false;
    g_emergencyStopReason = "";
    g_emergencySource = "";
    AimeSavePersistentState();
    AimeWritePersistentLog("EMERGENCY STOP CLEARED BY USER", "CONTROL");
    AimeReconcileAllPositions();
    AimeRefreshProtectionState();
    UpdateDashboard(true);
}

bool VerifyPositionIdentity(const ulong ticket,const string expected_symbol,const long expected_magic)
{
    if(ticket == 0 || expected_symbol == "" || expected_magic <= 0)
        return false;

    if(!PositionSelectByTicket(ticket))
        return false;

    string actualSymbol = PositionGetString(POSITION_SYMBOL);
    long actualMagic = (long)PositionGetInteger(POSITION_MAGIC);

    if(actualSymbol != expected_symbol)
        return false;

    if(actualMagic != expected_magic)
        return false;

    return IsAimeMagic(actualMagic);
}

bool ClosePositionByVerifiedTicket(const ulong ticket,const string expected_symbol,const long expected_magic)
{
   if(!VerifyPositionIdentity(ticket,expected_symbol,expected_magic)) return false;
   CTrade trade;
   trade.SetAsyncMode(false);
   if(!trade.PositionClose(ticket)) return false;
   if(PositionSelectByTicket(ticket)) return false;
   return true;
}

int OnInit()
{
    if(EA_PASSWORD != "")
    {
        passwordVerified = false;
        passwordDialogActive = true;
        if(!CreatePasswordDialog())
        {
            Alert("ERROR: Failed to create password dialog!");
            return(INIT_FAILED);
        }
        Print("Password required. Please enter password in the dialog on chart.");
        return(INIT_SUCCEEDED);
    }

    passwordVerified = true;
    passwordDialogActive = false;

    if(!InitializeMultiAssetEA())
        return(INIT_FAILED);

    AimeRefreshAccountSnapshot();
    AimeLoadPersistentState();
    AimeRefreshProtectionState();
    AimeReconcileAllPositions();

    EventSetTimer(MathMax(1, MultiAssetTimerSeconds));
    UpdateDashboard(true);
    return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
    EventKillTimer();

    if(passwordDialogActive)
    {
        passwordDialog.Destroy();
        passwordDialogActive = false;
    }

    ObjectsDeleteAll(0, "AimeDash_");
    Comment("");

    ReleaseAllAssetHandles();

    Print("Aime Programmer v45.51 Multi-Asset Data Truth Bar Age Deinitialized");
}

void OnTick()
{
    if(!passwordVerified || !g_multiAssetInitialized) return;
    if(g_executionCycleRunning) return;

    int idx = FindAssetIndex(g_chartSymbol);
    if(idx < 0) return;

    g_executionCycleRunning = true;

    LoadAssetContext(idx);
    ProcessActiveAsset(true);
    SaveAssetContext();

    g_executionCycleRunning = false;
}

void OnTimer()
{
    if(!passwordVerified || !g_multiAssetInitialized) return;

    AimeRefreshDashboardLiveState();
    ProcessAllAssets();
    AimeRefreshDashboardLiveState();
    AimeRefreshProtectionState();

    if(!g_dashboardRendering)
        UpdateDashboard(false);
}

void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam)
{
    if(id == CHARTEVENT_OBJECT_CLICK)
    {
        if(sparam == "AimeDash_CloseAll") { ForceCloseAllPositions(); return; }
        if(sparam == "AimeDash_CloseSelected") { ForceCloseSelectedPosition(); return; }
        if(sparam == "AimeDash_ReSync") { AimeReconcileAllPositions(true); AimeSavePersistentState(); UpdateDashboard(true); return; }
        if(sparam == "AimeDash_Emergency") { EmergencyStop(); return; }
        if(sparam == "AimeDash_Resume") { if(g_emergencyStop) ResumeAfterEmergencyStop(); else AimeExportConfig(); return; }
        if(sparam == "AimeDash_Theme") { g_darkTheme=!g_darkTheme; AimeSavePersistentState(); UpdateDashboard(true); return; }
        if(StringFind(sparam,"AimeDash_Asset_")==0)
        {
            int idx=(int)StringToInteger(StringSubstr(sparam,StringLen("AimeDash_Asset_")));
            if(idx>=0 && idx<g_assetCount)
            {
                g_dashboardSelectedSymbol=g_assets[idx].symbol;
                ChartSetSymbolPeriod(0,g_assets[idx].symbol,g_chartPeriod);
                AimeSavePersistentState();
                UpdateDashboard(true);
            }
            return;
        }
        if(StringFind(sparam,"AimeDash_PosMatrix_")==0)
        {
            string ticketText=StringSubstr(sparam,StringLen("AimeDash_PosMatrix_"));
            ulong ticket=(ulong)StringToInteger(ticketText);
            if(ticket>0 && PositionSelectByTicket(ticket))
            {
                g_dashboardSelectedPositionTicket=ticket;
                g_dashboardSelectedSymbol=PositionGetString(POSITION_SYMBOL);
                ChartSetSymbolPeriod(0,g_dashboardSelectedSymbol,g_chartPeriod);
                AimeSavePersistentState();
                UpdateDashboard(true);
            }
            return;
        }
        if(StringFind(sparam,"AimeDash_Pos_")==0)
        {
            string ticketText=StringSubstr(sparam,StringLen("AimeDash_Pos_"));
            for(int i=PositionsTotal()-1;i>=0;i--)
            {
                ulong ticket=PositionGetTicket(i);
                if(ticket==0 || !PositionSelectByTicket(ticket)) continue;
                if(StringFormat("%I64u",ticket)==ticketText && IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC)))
                {
                    g_dashboardSelectedPositionTicket=ticket;
                    AimeSavePersistentState();
                    UpdateDashboard(true);
                    return;
                }
            }
            g_dashboardSelectedPositionTicket=0;
            UpdateDashboard(true);
            return;
        }
        if(sparam == "AimeDash_MinBtn" || sparam == "AimeDash_MinBtnTxt") { g_dashMinimized=!g_dashMinimized; AimeSavePersistentState(); UpdateDashboard(true); return; }
        string tabNames[5]={"AimeDash_TabOverview","AimeDash_TabDecision","AimeDash_TabRisk","AimeDash_TabPositions","AimeDash_TabHealth"};
        for(int t=0;t<5;t++) if(sparam==tabNames[t] || sparam==tabNames[t]+"_BG" || sparam==tabNames[t]+"_TXT") { g_dashTab=t; AimeSavePersistentState(); UpdateDashboard(true); return; }
        for(int i=0;i<6;i++)
        {
            string filterName="AimeDash_Filter"+IntegerToString(i);
            string filterTxt="AimeDash_FilterTxt"+IntegerToString(i);
            string filterBg=filterName+"_BG";
            if(sparam==filterName || sparam==filterTxt || sparam==filterBg) { g_assetFilter=i; g_dashPage=0; g_lastDashboardScroll=TimeLocal(); UpdateDashboard(true); return; }
        }
        if(sparam=="AimeDash_PrevPage" || sparam=="AimeDash_PrevPage_BG" || sparam=="AimeDash_PrevPage_TXT") { g_dashPage--; if(g_dashPage<0) g_dashPage=MathMax(0,GetTotalPages()-1); UpdateDashboard(true); return; }
        if(sparam=="AimeDash_NextPage" || sparam=="AimeDash_NextPage_BG" || sparam=="AimeDash_NextPage_TXT") { int totalPages=GetTotalPages(); g_dashPage++; if(g_dashPage>=totalPages) g_dashPage=0; UpdateDashboard(true); return; }
        if(sparam=="AimeDash_FirstPage" || sparam=="AimeDash_FirstPage_BG" || sparam=="AimeDash_FirstPage_TXT") { g_dashPage=0; UpdateDashboard(true); return; }
        if(sparam=="AimeDash_LastPage" || sparam=="AimeDash_LastPage_BG" || sparam=="AimeDash_LastPage_TXT") { g_dashPage=MathMax(0,GetTotalPages()-1); UpdateDashboard(true); return; }
    }
    if(id == CHARTEVENT_CHART_CHANGE && passwordVerified)
    {
        g_chartSymbol=ChartSymbol(0);
        g_chartPeriod=(ENUM_TIMEFRAMES)ChartPeriod(0);
        int idx=FindAssetIndex(g_chartSymbol);
        if(idx>=0) { g_dashboardSelectedSymbol=g_chartSymbol; LoadAssetContext(idx); }
        else if(AddAssetContext(g_chartSymbol,(MultiAssetTimeframe==PERIOD_CURRENT)?g_chartPeriod:MultiAssetTimeframe)) { idx=FindAssetIndex(g_chartSymbol); if(idx>=0) LoadAssetContext(idx); }
        AimeReconcileAllPositions();
        UpdateDashboard(true);
    }
    if(passwordDialogActive)
    {
        passwordDialog.OnEvent(id,lparam,dparam,sparam);
        if(id==CHARTEVENT_OBJECT_CLICK && sparam=="PasswordSubmit")
        {
            string enteredPassword=passwordEdit.Text();
            if(enteredPassword==EA_PASSWORD)
            {
                passwordDialog.Destroy(); passwordDialogActive=false; passwordVerified=true;
                if(!InitializeMultiAssetEA()) { Alert("EA initialization failed!"); return; }
                AimeLoadPersistentState(); AimeReconcileAllPositions(); EventSetTimer(MathMax(1,MultiAssetTimerSeconds)); UpdateDashboard(true);
            }
            else { Alert("Invalid password! Please try again."); passwordEdit.Text(""); }
        }
    }
}

void OnTradeTransaction(const MqlTradeTransaction &trans,
                         const MqlTradeRequest &request,
                         const MqlTradeResult &result)
{
    if(!passwordVerified || !g_multiAssetInitialized) return;
    if(trans.type != TRADE_TRANSACTION_DEAL_ADD) return;
    if(trans.deal == 0 || !HistoryDealSelect(trans.deal)) return;

    string symbol = HistoryDealGetString(trans.deal, DEAL_SYMBOL);
    long expectedMagic = GetMagicForSymbol(symbol);
    if(expectedMagic <= 0) return;
    if((long)HistoryDealGetInteger(trans.deal, DEAL_MAGIC) != expectedMagic) return;
    g_tradeStatsCacheValid=false;
    AimeWritePersistentLog(StringFormat("DEAL ticket=%I64u position=%I64u symbol=%s magic=%I64d type=%d entry=%d volume=%.8f price=%.10f profit=%.2f swap=%.2f commission=%.2f",trans.deal,(ulong)HistoryDealGetInteger(trans.deal,DEAL_POSITION_ID),symbol,expectedMagic,(int)HistoryDealGetInteger(trans.deal,DEAL_TYPE),(int)HistoryDealGetInteger(trans.deal,DEAL_ENTRY),HistoryDealGetDouble(trans.deal,DEAL_VOLUME),HistoryDealGetDouble(trans.deal,DEAL_PRICE),HistoryDealGetDouble(trans.deal,DEAL_PROFIT),HistoryDealGetDouble(trans.deal,DEAL_SWAP),HistoryDealGetDouble(trans.deal,DEAL_COMMISSION)),"COMPLIANCE");

    if(EnableExecutionFeedback && HistoryDealGetInteger(trans.deal,DEAL_ENTRY)==DEAL_ENTRY_IN)
    {

        double fillPrice = HistoryDealGetDouble(trans.deal, DEAL_PRICE);
        double symPoint = SymbolInfoDouble(symbol, SYMBOL_POINT);
        if(request.price > 0.0 && fillPrice > 0.0 && symPoint > 0.0)
            g_lastExecutionSlippagePoints = MathAbs(fillPrice - request.price) / symPoint;
        else
            g_lastExecutionSlippagePoints = -1.0; 
        g_lastExecutionStatus="FILLED";
        g_executionSuccessCount++;
        g_lastExecutionTime=TimeCurrent();
    }

    int idx = FindAssetIndex(symbol);
    if(idx < 0)
    {
        if(!AddAssetContext(symbol, g_activePeriod)) return;
        idx = FindAssetIndex(symbol);
    }
    if(idx < 0) return;

    LoadAssetContext(idx);
    HandleTradeTransactionActive(trans, request, result);
    SaveAssetContext();
}

void HandleTradeTransactionActive(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result)
{
    if(trans.type != TRADE_TRANSACTION_DEAL_ADD) return;

    ulong dealTicket = trans.deal;
    if(dealTicket == 0) return;
    if(!HistoryDealSelect(dealTicket)) return;

    if(HistoryDealGetString(dealTicket, DEAL_SYMBOL) != g_activeSymbol) return;
    if(HistoryDealGetInteger(dealTicket, DEAL_MAGIC) != ActiveMagicNumber()) return;

    long dealEntry = HistoryDealGetInteger(dealTicket, DEAL_ENTRY);
    ulong posID = (ulong)HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);
    if(posID == 0) return;

    if(dealEntry == DEAL_ENTRY_IN)
    {
        if(GetManagedPositionIndex(posID) != -1) return;

        ENUM_POSITION_TYPE ptype;
        double entryPrice;
        string posComment = "";

        if(PositionSelectByTicket(posID))
        {
            ptype = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            entryPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            posComment = PositionGetString(POSITION_COMMENT);
        }
        else
        {
            ptype = (HistoryDealGetInteger(dealTicket, DEAL_TYPE) == DEAL_TYPE_BUY) ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
            entryPrice = HistoryDealGetDouble(dealTicket, DEAL_PRICE);
        }

        double score = ParseLimitEntryScore(posComment);
        if(score <= 0) score = (ptype == POSITION_TYPE_BUY) ? AimeBuySignalThreshold() : AimeSellSignalThreshold();

        RegisterManagedPosition(posID, ptype, score, entryPrice);

        datetime currBarTime = iTime(g_activeSymbol, g_activePeriod, 0);
        if(currentBarTime != currBarTime)
        {
            currentBarTime = currBarTime;
            buysOnCurrentBar = 0;
            sellsOnCurrentBar = 0;
        }
        if(ptype == POSITION_TYPE_BUY)
        {
            buysOnCurrentBar++;
            lastBuyTime = TimeCurrent();
            lastBuyPrice = entryPrice;
        }
        else
        {
            sellsOnCurrentBar++;
            lastSellTime = TimeCurrent();
            lastSellPrice = entryPrice;
        }

        LogPrint("[LIMIT FILL] Position ", posID, " registered. Type: ",
                 ptype == POSITION_TYPE_BUY ? "BUY" : "SELL",
                 " | Entry: ", entryPrice, " | Score: ", DoubleToString(score, 1));
        return;
    }

    if(dealEntry != DEAL_ENTRY_OUT && dealEntry != DEAL_ENTRY_INOUT) return;

    if(PositionSelectByTicket(posID)) return;

    if(GetManagedPositionIndex(posID) == -1) return;

    double closedProfit = HistoryDealGetDouble(dealTicket, DEAL_PROFIT)
                        + HistoryDealGetDouble(dealTicket, DEAL_SWAP)
                        + HistoryDealGetDouble(dealTicket, DEAL_COMMISSION);

    ProcessClosedPosition(posID, closedProfit);
}

struct PositionLossState
{
    int losingCount;
    int totalCount;
    double totalUnrealizedLoss;
    double worstLossPct;
};

PositionLossState GetOpenPositionLossState(ENUM_POSITION_TYPE direction)
{
    PositionLossState state;
    state.losingCount = 0;
    state.totalCount = 0;
    state.totalUnrealizedLoss = 0;
    state.worstLossPct = 0;

    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0) continue;
        if(!PositionSelectByTicket(ticket)) continue;
        if(PositionGetInteger(POSITION_MAGIC) != ActiveMagicNumber()) continue;
        if(PositionGetString(POSITION_SYMBOL) != g_activeSymbol) continue;

        ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        if(posType != direction) continue;

        state.totalCount++;
        double profit = PositionGetDouble(POSITION_PROFIT);

        if(profit < 0)
        {
            state.losingCount++;
            state.totalUnrealizedLoss += profit;

            double entryPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            double volume = PositionGetDouble(POSITION_VOLUME);
            double contractSize = SymbolInfoDouble(g_activeSymbol, SYMBOL_TRADE_CONTRACT_SIZE);
            if(entryPrice > 0 && volume > 0 && contractSize > 0)
            {
                double lossPct = MathAbs(profit) / (entryPrice * volume * contractSize) * 100.0;
                if(lossPct > state.worstLossPct)
                    state.worstLossPct = lossPct;
            }
        }
    }

    return state;
}

double GetTotalFloatingPL()
{
    double total = 0;
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0) continue;
        if(!PositionSelectByTicket(ticket)) continue;
        if(PositionGetInteger(POSITION_MAGIC) != ActiveMagicNumber()) continue;
        if(PositionGetString(POSITION_SYMBOL) != g_activeSymbol) continue;

        total += PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
    }
    return total;
}

double GetBasketFloatingPL()
{
    if(!EnableHedgeChain) return GetPortfolioFloatingPL(false);
    return GetPortfolioFloatingPL(true);
}

void CheckBasketStop()
{
    if(!EnableBasketStop || MaxBasketLossPct <= 0) return;

    double equity = AccountInfoDouble(ACCOUNT_EQUITY);
    if(equity <= 0) return;

    double floatingPL = GetBasketFloatingPL();
    if(floatingPL >= 0) return;

    double lossPct = (-floatingPL / equity) * 100.0;
    if(lossPct < MaxBasketLossPct) return;

    LogPrint("+-----------------------------------------+");
    LogPrint("BASKET STOP TRIGGERED!");
    LogPrint("Floating Loss (excl. hedge chains): $", DoubleToString(floatingPL, 2),
             " (", DoubleToString(lossPct, 2), "% of equity >= ", DoubleToString(MaxBasketLossPct, 2), "%)");
    LogPrint("Closing all non-chain positions and pausing.");
    LogPrint("+-----------------------------------------+");

    CloseAllPortfolioPositions(false, true);

    if(!isPaused)
    {
        isPaused = true;
        pauseStartTime = TimeTradeServer();
        currentPauseDuration = (MaxPauseMinutes > 0) ? MathMin(PauseMinutes, MaxPauseMinutes) : PauseMinutes;
        totalPauseCount++;
        totalPauseDurationMinutes += currentPauseDuration;
    }

    if(EnableDiscordAlerts)
    {
        string alertMsg = "**Instrument:** " + g_activeSymbol + "\n";
        alertMsg += "**Timeframe:** " + EnumToString(g_activePeriod) + "\n";
        alertMsg += "**Server Time:** " + TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS) + "\n";
        alertMsg += "**Floating Loss:** $" + DoubleToString(floatingPL, 2) + " (" + DoubleToString(lossPct, 2) + "%)\n";
        alertMsg += "**Limit:** " + DoubleToString(MaxBasketLossPct, 2) + "% of equity\n";
        alertMsg += "**Pause Duration:** " + IntegerToString(currentPauseDuration) + " minutes\n";
        alertMsg += "**Action:** All Positions Closed, Trading Paused";

        SendDiscordAlert("🧺 BASKET STOP TRIGGERED", alertMsg, 15158332);
    }
}

string AimeStrategyClassLimit(string cls)
{
    if(cls == "METAL") return IntegerToString(MaxConcurrentMetalPositions);
    if(cls == "INDEX") return IntegerToString(MaxConcurrentIndexPositions);
    if(cls == "STOCK") return IntegerToString(MaxConcurrentStockPositions);
    if(cls == "CRYPTO") return IntegerToString(MaxConcurrentCryptoPositions);
    return IntegerToString(MaxConcurrentFXPositions);
}

int AimeOpenPositionsByClass(string cls)
{
    int count = 0;
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
        long magic = PositionGetInteger(POSITION_MAGIC);
        string symbol = PositionGetString(POSITION_SYMBOL);
        if(!IsAimeMagic(magic)) continue;
        if(AimeProfileClass(symbol) != cls) continue;
        count++;
    }
    return count;
}

string AimeExposureFamily(string symbol)
{
    string cls = AimeProfileClass(symbol);
    if(cls == "STOCK") return "US_RISK_ASSET";
    if(cls == "INDEX") return "US_RISK_ASSET";
    if(cls == "METAL") return "METAL";
    if(cls == "CRYPTO") return "CRYPTO";
    if(cls == "FX")
    {
        string base = SymbolInfoString(symbol, SYMBOL_CURRENCY_BASE);
        string quote = SymbolInfoString(symbol, SYMBOL_CURRENCY_PROFIT);
        if(base == "USD" || quote == "USD") return "FX_USD";
        return "FX_CROSS";
    }
    return cls;
}

double AimeRiskForAssetClass(string cls)
{
    double total = 0.0;
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
        if(!IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) continue;
        string symbol = PositionGetString(POSITION_SYMBOL);
        if(AimeProfileClass(symbol) != cls) continue;
        double risk = AimePositionRiskMoney(ticket);
        if(risk < DBL_MAX / 2.0) total += MathMax(0.0, risk);
    }
    return total;
}

double AimeRiskForExposureFamily(string family)
{
    double total = 0.0;
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
        if(!IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) continue;
        string symbol = PositionGetString(POSITION_SYMBOL);
        if(AimeExposureFamily(symbol) != family) continue;
        double risk = AimePositionRiskMoney(ticket);
        if(risk < DBL_MAX / 2.0) total += MathMax(0.0, risk);
    }
    return total;
}

double AimeSignedCurrencyRisk(string currency)
{
    double total = 0.0;
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
        if(!IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) continue;
        string symbol = PositionGetString(POSITION_SYMBOL);
        if(AimeProfileClass(symbol) != "FX") continue;
        string base = SymbolInfoString(symbol, SYMBOL_CURRENCY_BASE);
        string quote = SymbolInfoString(symbol, SYMBOL_CURRENCY_PROFIT);
        double risk = AimePositionRiskMoney(ticket);
        if(risk >= DBL_MAX / 2.0 || risk < MinimumRiskForPortfolioAttribution) continue;
        ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        double sign = type == POSITION_TYPE_BUY ? 1.0 : -1.0;
        if(base == currency) total += sign * risk;
        if(quote == currency) total -= sign * risk;
    }
    return total;
}

double AimePriceCorrelation(string symbolA, string symbolB, ENUM_TIMEFRAMES tf, int lookback, int minimumBars, bool &ready)
{
    ready=false;
    if(symbolA=="" || symbolB=="" || symbolA==symbolB) { ready=true; return 1.0; }
    int n=MathMax(minimumBars,MathMin(lookback,200));
    if(Bars(symbolA,tf)<n+2 || Bars(symbolB,tf)<n+2) return 0.0;
    double a[],b[];
    ArraySetAsSeries(a,true); ArraySetAsSeries(b,true);
    int ca=CopyClose(symbolA,tf,1,n+1,a);
    int cb=CopyClose(symbolB,tf,1,n+1,b);
    if(ca<n+1 || cb<n+1) return 0.0;
    double sumA=0.0,sumB=0.0,sumAA=0.0,sumBB=0.0,sumAB=0.0;
    int count=0;
    for(int i=0;i<n;i++)
    {
        if(a[i]<=0.0 || a[i+1]<=0.0 || b[i]<=0.0 || b[i+1]<=0.0) continue;
        double ra=a[i]/a[i+1]-1.0;
        double rb=b[i]/b[i+1]-1.0;
        sumA+=ra; sumB+=rb; sumAA+=ra*ra; sumBB+=rb*rb; sumAB+=ra*rb; count++;
    }
    if(count<minimumBars) return 0.0;
    double denA=count*sumAA-sumA*sumA;
    double denB=count*sumBB-sumB*sumB;
    if(denA<=0.0 || denB<=0.0) return 0.0;
    ready=true;
    return (count*sumAB-sumA*sumB)/MathSqrt(denA*denB);
}

bool AimeCorrelationAllows(string symbol, ENUM_ORDER_TYPE orderType, string &reason)
{
    reason="";
    if(!EnablePortfolioCorrelationGuard || MaxPortfolioCorrelation<=0.0) return true;
    int idx=FindAssetIndex(symbol);
    ENUM_TIMEFRAMES tf=idx>=0 ? g_assets[idx].period : g_activePeriod;
    double requested=orderType==ORDER_TYPE_BUY ? 1.0 : -1.0;
    for(int i=PositionsTotal()-1;i>=0;i--)
    {
        ulong ticket=PositionGetTicket(i);
        if(ticket==0 || !PositionSelectByTicket(ticket)) continue;
        if(!IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) continue;
        string ps=PositionGetString(POSITION_SYMBOL);
        if(ps==symbol) continue;
        ENUM_POSITION_TYPE pt=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        double existing=pt==POSITION_TYPE_BUY ? 1.0 : -1.0;
        bool ready=false;
        double corr=AimePriceCorrelation(symbol,ps,tf,CorrelationLookbackBars,MinimumCorrelationBars,ready);
        if(!ready) continue;
        if(corr*requested*existing>=MaxPortfolioCorrelation)
        {
            reason=StringFormat("CORRELATION %s %.2f",ps,corr);
            return false;
        }
    }
    return true;
}

bool AimeSignalFreshEnough(ENUM_ORDER_TYPE orderType, string &reason)
{
    reason="";
    if(!EnableSignalFreshnessGuard) return true;
    datetime cached=orderType==ORDER_TYPE_BUY ? buyStrengthCacheBarTime : sellStrengthCacheBarTime;
    string cachedSymbol=orderType==ORDER_TYPE_BUY ? buyStrengthCacheSymbol : sellStrengthCacheSymbol;
    if(cachedSymbol!=g_activeSymbol || cached<=0) { reason="SIGNAL STALE"; return false; }
    int shift=iBarShift(g_activeSymbol,g_activePeriod,cached,false);
    if(shift<0 || shift>MaxSignalAgeBars)
    {
        reason=StringFormat("SIGNAL AGE %d > %d",shift,MaxSignalAgeBars);
        return false;
    }
    return true;
}

bool AimeComponentQualityGate(ENUM_ORDER_TYPE orderType, string &reason)
{
    reason="";
    if(!EnableComponentQualityGate) return true;
    SignalStrength chosen=orderType==ORDER_TYPE_BUY ? _cachedBuyStrength : _cachedSellStrength;
    double trendQ=MathMin(1.0,MathMax(0.0,chosen.trendScore/3.0));
    double momentumQ=MathMin(1.0,MathMax(0.0,chosen.momentumScore/3.0));
    if(trendQ<MinTrendComponentQuality)
    {
        reason=StringFormat("TREND QUALITY %.2f < %.2f",trendQ,MinTrendComponentQuality);
        return false;
    }
    if(momentumQ<MinMomentumComponentQuality)
    {
        reason=StringFormat("MOMENTUM QUALITY %.2f < %.2f",momentumQ,MinMomentumComponentQuality);
        return false;
    }
    return true;
}

bool AimeRiskRewardGate(ENUM_ORDER_TYPE orderType,double volume,double entry,double sl,double tp,string &reason)
{
    reason="";
    if(!EnablePreTradeRiskRewardGate || MinimumEntryRR<=0.0) return true;
    if(entry<=0.0 || sl<=0.0) { reason="RR INVALID SL"; return false; }
    double theoreticalTP=tp;
    if(theoreticalTP<=0.0)
    {
        double atr=GetCurrentATR();
        if(atr<=0.0) { reason="RR ATR UNAVAILABLE"; return false; }
        double riskDistance=MathAbs(entry-sl);
        double targetDistance=MathMax(riskDistance*MinimumEntryRR,atr*PreTradeTPATRMultiplier);
        theoreticalTP=orderType==ORDER_TYPE_BUY ? entry+targetDistance : entry-targetDistance;
    }
    double loss=0.0,reward=0.0;
    if(!OrderCalcProfit(orderType,g_activeSymbol,volume,entry,sl,loss)) { reason="RR LOSS CALC FAILED"; return false; }
    if(!OrderCalcProfit(orderType,g_activeSymbol,volume,entry,theoreticalTP,reward)) { reason="RR PROFIT CALC FAILED"; return false; }
    double risk=MathAbs(loss),gain=MathAbs(reward);
    if(risk<=0.0) { reason="RR ZERO RISK"; return false; }
    double rr=gain/risk;
    if(rr<MinimumEntryRR)
    {
        reason=StringFormat("RR %.2f < %.2f",rr,MinimumEntryRR);
        return false;
    }
    return true;
}

double AimeStructureSLPoints(ENUM_ORDER_TYPE orderType,double entry,double lot)
{
    if(!EnableStructureAwareStops) return GetSLPoints(lot);
    double atr=GetCurrentATR();
    if(atr<=0.0 || ActivePoint()<=0.0) return GetSLPoints(lot);
    int look=MathMax(5,MathMin(StructureSLLookback,100));
    MqlRates rates[];
    ArraySetAsSeries(rates,true);
    int copied=CopyRates(g_activeSymbol,g_activePeriod,1,look,rates);
    if(copied<5) return GetSLPoints(lot);
    double swing=orderType==ORDER_TYPE_BUY ? DBL_MAX : -DBL_MAX;
    for(int i=0;i<copied;i++)
    {
        if(orderType==ORDER_TYPE_BUY) swing=MathMin(swing,rates[i].low);
        else swing=MathMax(swing,rates[i].high);
    }
    double distance=orderType==ORDER_TYPE_BUY ? entry-swing : swing-entry;
    distance+=atr*StructureSLBufferATR;
    distance=MathMax(distance,atr*StructureSLATRMultiplier);
    if(distance<=0.0) return GetSLPoints(lot);
    return distance/ActivePoint();
}

double AimePreTradeTPPoints(ENUM_ORDER_TYPE orderType,double entry,double sl,double lot)
{
    if(ActivePoint()<=0.0) return GetTPPoints(lot);
    double riskDistance=MathAbs(entry-sl);
    if(riskDistance<=0.0) return GetTPPoints(lot);
    double atr=GetCurrentATR();
    double targetDistance=MathMax(riskDistance*MinimumEntryRR,atr>0.0 ? atr*PreTradeTPATRMultiplier : 0.0);
    double configured=GetTPPoints(lot);
    if(configured>0.0) targetDistance=MathMax(targetDistance,configured*ActivePoint());
    return targetDistance/ActivePoint();
}

bool AimePortfolioIntelligenceAllows(string symbol, ENUM_ORDER_TYPE orderType, double projectedRiskMoney, string &reason)
{
    reason = "";
    if(!EnablePortfolioIntelligence) return true;

    double equity = AccountInfoDouble(ACCOUNT_EQUITY);
    if(equity <= 0.0)
    {
        reason = "INVALID EQUITY";
        return false;
    }

    if(projectedRiskMoney <= 0.0 || projectedRiskMoney >= DBL_MAX / 2.0)
    {
        reason = "INVALID PROJECTED RISK";
        return false;
    }

    double projectedPct = (projectedRiskMoney / equity) * 100.0;
    string correlationReason="";
    if(!AimeCorrelationAllows(symbol,orderType,correlationReason))
    {
        reason=correlationReason;
        return false;
    }
    string cls = AimeProfileClass(symbol);
    double classRiskPct = (AimeRiskForAssetClass(cls) / equity) * 100.0;
    if(MaxAssetClassRiskPct > 0.0 && classRiskPct + projectedPct > MaxAssetClassRiskPct + 0.0001)
    {
        reason = StringFormat("ASSET CLASS RISK %s %.2f%% + %.2f%% > %.2f%%", cls, classRiskPct, projectedPct, MaxAssetClassRiskPct);
        return false;
    }

    string family = AimeExposureFamily(symbol);
    double familyRiskPct = (AimeRiskForExposureFamily(family) / equity) * 100.0;
    if(MaxExposureFamilyRiskPct > 0.0 && familyRiskPct + projectedPct > MaxExposureFamilyRiskPct + 0.0001)
    {
        reason = StringFormat("EXPOSURE FAMILY %s %.2f%% + %.2f%% > %.2f%%", family, familyRiskPct, projectedPct, MaxExposureFamilyRiskPct);
        return false;
    }

    if(AimeProfileClass(symbol) == "FX" && MaxCurrencyDirectionalRiskPct > 0.0)
    {
        string base = SymbolInfoString(symbol, SYMBOL_CURRENCY_BASE);
        string quote = SymbolInfoString(symbol, SYMBOL_CURRENCY_PROFIT);
        if(base != "" && quote != "")
        {
            double direction = orderType == ORDER_TYPE_BUY ? 1.0 : -1.0;
            double baseRisk = AimeSignedCurrencyRisk(base) + direction * projectedRiskMoney;
            double quoteRisk = AimeSignedCurrencyRisk(quote) - direction * projectedRiskMoney;
            double limitMoney = equity * (MaxCurrencyDirectionalRiskPct / 100.0);
            if(MathAbs(baseRisk) > limitMoney + 0.01)
            {
                reason = StringFormat("CURRENCY %s DIRECTIONAL RISK %.2f%% > %.2f%%", base, (MathAbs(baseRisk) / equity) * 100.0, MaxCurrencyDirectionalRiskPct);
                return false;
            }
            if(MathAbs(quoteRisk) > limitMoney + 0.01)
            {
                reason = StringFormat("CURRENCY %s DIRECTIONAL RISK %.2f%% > %.2f%%", quote, (MathAbs(quoteRisk) / equity) * 100.0, MaxCurrencyDirectionalRiskPct);
                return false;
            }
            if(BlockOpposingCurrencyOverload)
            {
                double baseExisting = AimeSignedCurrencyRisk(base);
                double quoteExisting = AimeSignedCurrencyRisk(quote);
                bool baseOpposes = (baseExisting * direction) < 0.0;
                bool quoteOpposes = (quoteExisting * -direction) < 0.0;
                if(baseOpposes && MathAbs(baseExisting) > limitMoney * 0.75)
                {
                    reason = StringFormat("CURRENCY %s OPPOSING EXPOSURE", base);
                    return false;
                }
                if(quoteOpposes && MathAbs(quoteExisting) > limitMoney * 0.75)
                {
                    reason = StringFormat("CURRENCY %s OPPOSING EXPOSURE", quote);
                    return false;
                }
            }
        }
    }

    return true;
}

bool AimeConcentrationAllows(string symbol, string &reason)
{
    reason = "";
    if(!EnableInstitutionalStrategyCore || !EnableConcentrationGuard)
        return true;

    string cls = AimeProfileClass(symbol);
    int limit = (int)StringToInteger(AimeStrategyClassLimit(cls));
    if(limit <= 0)
        return true;

    int openCount = AimeOpenPositionsByClass(cls);
    if(openCount >= limit)
    {
        reason = StringFormat("CONCENTRATION %s %d/%d", cls, openCount, limit);
        return false;
    }

    if(cls == "INDEX")
    {
        int sameIndexFamily = 0;
        for(int i = PositionsTotal() - 1; i >= 0; i--)
        {
            ulong ticket = PositionGetTicket(i);
            if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
            long magic = PositionGetInteger(POSITION_MAGIC);
            string ps = PositionGetString(POSITION_SYMBOL);
            if(!IsAimeMagic(magic)) continue;
            if(AimeProfileClass(ps) != "INDEX") continue;
            sameIndexFamily++;
        }
        if(sameIndexFamily >= limit)
        {
            reason = StringFormat("INDEX CONCENTRATION %d/%d", sameIndexFamily, limit);
            return false;
        }
    }

    if(cls == "METAL")
    {
        int metalCount = AimeOpenPositionsByClass("METAL");
        if(metalCount >= limit)
        {
            reason = StringFormat("METAL CONCENTRATION %d/%d", metalCount, limit);
            return false;
        }
    }

    double classCapPct = AimeClassRiskCapPct(cls);
    if(classCapPct > 0.0)
    {
        double equity = AccountInfoDouble(ACCOUNT_EQUITY);
        if(equity > 0.0)
        {
            double estTradeRisk = equity * (MathMax(0.01, RiskPerTradePct) / 100.0);
            double existingClassRisk = AimeClassOpenRiskMoney(cls);
            double projectedClassPct = ((existingClassRisk + estTradeRisk) / equity) * 100.0;
            if(projectedClassPct > classCapPct + 1e-9)
            {
                reason = StringFormat("CLASS RISK %s %.2f%% > %.2f%% cap", cls, projectedClassPct, classCapPct);
                return false;
            }
        }
    }

    return true;
}

int AimeRequiredDataBars()
{
    int required = 50;
    required = MathMax(required, EMASlowPeriod + SlopeLookback + 10);
    required = MathMax(required, ATRPeriod + MathMax(5, MathMin(16, ATRAvgLookback)) + 10);
    required = MathMax(required, DirectionalBodyLookback + 10);
    required = MathMax(required, SignalSmoothingCandles + 10);
    return required;
}

void AimeSetAssetDataState(int index, string state, string reason, bool ready)
{
    if(index < 0 || index >= g_assetCount) return;
    g_assets[index].dataState = state;
    g_assets[index].dataReason = reason;
    g_assets[index].dataLastCheck = TimeCurrent();
    g_assets[index].strategyDataReady = ready;
    g_assets[index].seriesSynchronized = ready || g_assets[index].seriesSynchronized;
    if(ready)
    {
        g_assets[index].dataLastReady = g_assets[index].dataLastCheck;
        g_assets[index].dataFailureCount = 0;
    }
    else
    {
        g_assets[index].dataFailureCount++;
    }
}

bool AimeRefreshAssetFeed(int index, string &reason)
{
    reason = "";
    if(index < 0 || index >= g_assetCount)
    {
        reason = "INVALID ASSET";
        return false;
    }

    string symbol = g_assets[index].symbol;
    if(symbol == "")
    {
        reason = "EMPTY SYMBOL";
        g_assets[index].feedLive = false;
        return false;
    }

    if(!SymbolSelect(symbol,true))
    {
        reason = "SYMBOL SELECT FAILED";
        g_assets[index].feedLive = false;
        return false;
    }

    MqlTick localTick;
    if(!SymbolInfoTick(symbol,localTick) || localTick.time <= 0 || localTick.bid <= 0.0 || localTick.ask <= 0.0)
    {
        reason = "NO LIVE QUOTE";
        g_assets[index].feedLive = false;
        g_assets[index].feedLastObservedServerTime = TimeTradeServer();
        return false;
    }

    datetime serverNow = TimeTradeServer();
    if(serverNow <= 0) serverNow = TimeCurrent();
    ulong nowMs = GetTickCount64();
    long brokerTickAge = (long)(serverNow - localTick.time);
    if(brokerTickAge < 0)
    {
        if((long)(-brokerTickAge) > 10)
        {
            reason = "TICK CLOCK AHEAD";
            g_assets[index].feedLive = false;
            return false;
        }
        brokerTickAge = 0;
    }

    bool changed = !g_assets[index].feedInitialized ||
                   g_assets[index].feedLastTickTimeMsc != localTick.time_msc ||
                   g_assets[index].feedLastBid != localTick.bid ||
                   g_assets[index].feedLastAsk != localTick.ask;

    if(changed)
        g_assets[index].feedLastChangeMs = nowMs;

    g_assets[index].feedInitialized = true;
    g_assets[index].feedLastTickTimeMsc = localTick.time_msc;
    g_assets[index].feedLastTickTime = localTick.time;
    g_assets[index].feedLastBid = localTick.bid;
    g_assets[index].feedLastAsk = localTick.ask;
    g_assets[index].feedLastObservedServerTime = serverNow;

    long observedAge = 0;
    if(g_assets[index].feedLastChangeMs > 0 && nowMs >= g_assets[index].feedLastChangeMs)
        observedAge = (long)((nowMs - g_assets[index].feedLastChangeMs) / 1000);

    g_assets[index].feedLive = DashboardMaxTickAgeSeconds <= 0 || brokerTickAge <= DashboardMaxTickAgeSeconds;

    if(!g_assets[index].feedLive)
    {
        reason = StringFormat("STALE TICK %lds",brokerTickAge);
        return false;
    }

    return true;
}

long AimeAssetBarAgeSeconds(int index)
{
    if(index < 0 || index >= g_assetCount) return -1;
    string symbol = g_assets[index].symbol;
    ENUM_TIMEFRAMES period = g_assets[index].period;
    datetime bar = iTime(symbol,period,0);
    if(bar <= 0)
    {
        g_assets[index].feedLastBarTime = 0;
        g_assets[index].feedLastBarAgeSeconds = -1;
        return -1;
    }

    datetime now = TimeTradeServer();
    if(now <= 0) now = TimeCurrent();
    long age = (long)(now - bar);
    if(age < 0) age = 0;

    g_assets[index].feedLastBarTime = bar;
    g_assets[index].feedLastBarAgeSeconds = age;
    return age;
}

bool AimeAssetDataGate(int index, string &reason)
{
    reason = "";
    if(index < 0 || index >= g_assetCount)
    {
        reason = "INVALID ASSET";
        return false;
    }

    string sessionStatus = "";
    if(!AimeBrokerSessionOpen(g_assets[index].symbol,sessionStatus))
    {
        reason = sessionStatus == "" ? "SESSION BLOCKED" : sessionStatus;
        AimeAssetBarAgeSeconds(index);
        return false;
    }

    if(!AimeRefreshAssetFeed(index,reason))
        return false;

    long barAge = AimeAssetBarAgeSeconds(index);
    if(barAge < 0)
    {
        reason = "BAR DATA UNAVAILABLE";
        return false;
    }

    return true;
}

bool AimePrepareAssetData(int index, string &reason)
{
    reason = "";
    if(index < 0 || index >= g_assetCount)
    {
        reason = "INVALID ASSET";
        return false;
    }

    string symbol = g_assets[index].symbol;
    ENUM_TIMEFRAMES period = g_assets[index].period;
    int requiredBars = AimeRequiredDataBars();
    g_assets[index].dataLastCheck = TimeCurrent();

    if(symbol == "")
    {
        reason = "EMPTY SYMBOL";
        AimeSetAssetDataState(index,"SYMBOL ERROR",reason,false);
        return false;
    }

    if(!SymbolSelect(symbol,true))
    {
        reason = "SYMBOL SELECT FAILED";
        AimeSetAssetDataState(index,"SYMBOL WAIT",reason,false);
        return false;
    }

    if(!AimeAssetDataGate(index,reason))
    {
        AimeSetAssetDataState(index,"TICK WAIT",reason,false);
        return false;
    }

    long sync = SeriesInfoInteger(symbol,period,SERIES_SYNCHRONIZED);
    int bars = Bars(symbol,period);
    int loaded = 0;

    if(sync == 0 || bars < requiredBars)
    {
        MqlRates preload[];
        ArraySetAsSeries(preload,true);
        ResetLastError();
        loaded = CopyRates(symbol,period,0,requiredBars,preload);
        sync = SeriesInfoInteger(symbol,period,SERIES_SYNCHRONIZED);
        bars = Bars(symbol,period);
        if(sync == 0 || MathMax(bars,loaded) < requiredBars)
        {
            reason = loaded > 0 ? "HISTORY WARMUP" : "HISTORY REQUESTED";
            g_assets[index].dataBars = MathMax(0,MathMax(bars,loaded));
            g_assets[index].seriesSynchronized = (sync != 0);
            AimeSetAssetDataState(index,"HISTORY WAIT",reason,false);
            return false;
        }
    }

    g_assets[index].dataBars = bars;
    g_assets[index].seriesSynchronized = (sync != 0);
    if(bars < requiredBars)
    {
        reason = StringFormat("BARS %d/%d",bars,requiredBars);
        AimeSetAssetDataState(index,"BARS WAIT",reason,false);
        return false;
    }

    int h1=g_assets[index].emaFastHandle;
    int h2=g_assets[index].emaSlowHandle;
    int h3=g_assets[index].rsiHandle;
    int h4=g_assets[index].atrSignalHandle;
    if(h1==INVALID_HANDLE || h2==INVALID_HANDLE || h3==INVALID_HANDLE || h4==INVALID_HANDLE)
    {
        ReleaseActiveHandles();
        if(!CreateAssetHandles())
        {
            reason = "INDICATOR HANDLE RETRY";
            g_assets[index].indicatorsReady = false;
            AimeSetAssetDataState(index,"INDICATOR WAIT",reason,false);
            return false;
        }

        g_assets[index].emaFastHandle = emaFastHandle;
        g_assets[index].emaSlowHandle = emaSlowHandle;
        g_assets[index].rsiHandle = rsiHandle;
        g_assets[index].atrSignalHandle = atrSignalHandle;
    }

    h1 = g_assets[index].emaFastHandle;
    h2 = g_assets[index].emaSlowHandle;
    h3 = g_assets[index].rsiHandle;
    h4 = g_assets[index].atrSignalHandle;

    int bc1=BarsCalculated(h1);
    int bc2=BarsCalculated(h2);
    int bc3=BarsCalculated(h3);
    int bc4=BarsCalculated(h4);
    int minCalc=MathMin(MathMin(bc1,bc2),MathMin(bc3,bc4));
    if(minCalc < 4)
    {
        reason = StringFormat("INDICATORS CALCULATING %d/4",MathMax(0,minCalc));
        g_assets[index].indicatorsReady = false;
        AimeSetAssetDataState(index,"INDICATOR WAIT",reason,false);
        return false;
    }

    g_assets[index].indicatorsReady = true;
    AimeSetAssetDataState(index,"DATA READY","SERIES AND INDICATORS READY",true);
    return true;
}

bool AimeReadRegimeMetrics(double &emaFast, double &emaSlow, double &emaFastPrev, double &rsi, double &atrRatio, double &closePrice, double &rangeHigh, double &rangeLow, double &bodyRatio)
{
    emaFast = 0.0;
    emaSlow = 0.0;
    emaFastPrev = 0.0;
    rsi = 0.0;
    atrRatio = 0.0;
    closePrice = 0.0;
    rangeHigh = 0.0;
    rangeLow = 0.0;
    bodyRatio = 0.0;

    if(g_activeIndex < 0 || g_activeIndex >= g_assetCount)
        return false;

    string dataReason = "";
    if(!AimePrepareAssetData(g_activeIndex,dataReason))
        return false;

    if(emaFastHandle == INVALID_HANDLE || emaSlowHandle == INVALID_HANDLE || rsiHandle == INVALID_HANDLE || atrSignalHandle == INVALID_HANDLE)
    {
        AimeSetAssetDataState(g_activeIndex,"INDICATOR WAIT","INDICATOR HANDLE INVALID",false);
        return false;
    }

    double ef[], es[], rs[], at[];
    ArraySetAsSeries(ef, true);
    ArraySetAsSeries(es, true);
    ArraySetAsSeries(rs, true);
    ArraySetAsSeries(at, true);

    if(CopyBuffer(emaFastHandle, 0, 0, 4, ef) < 4) return false;
    if(CopyBuffer(emaSlowHandle, 0, 0, 2, es) < 2) return false;
    if(CopyBuffer(rsiHandle, 0, 0, 2, rs) < 2) return false;

    int atrNeed = MathMax(5, MathMin(16, ATRAvgLookback));
    if(CopyBuffer(atrSignalHandle, 0, 0, atrNeed, at) < atrNeed) return false;

    MqlRates rates[];
    ArraySetAsSeries(rates, true);
    int lookback = MathMax(5, MathMin(20, DirectionalBodyLookback + 5));
    if(CopyRates(g_activeSymbol, g_activePeriod, 0, lookback, rates) < lookback)
        return false;

    emaFast = ef[0];
    emaSlow = es[0];
    emaFastPrev = ef[MathMin(3, MathMax(1, SlopeLookback))];
    rsi = rs[0];
    closePrice = rates[0].close;

    double sumATR = 0.0;
    int atrCount = 0;
    for(int i = 0; i < atrNeed; i++)
    {
        if(at[i] > 0.0)
        {
            sumATR += at[i];
            atrCount++;
        }
    }
    if(atrCount <= 0 || at[0] <= 0.0)
        return false;

    double avgATR = sumATR / atrCount;
    atrRatio = avgATR > 0.0 ? at[0] / avgATR : 0.0;

    double avgBody = 0.0;
    int bodyCount = 0;
    for(int i = 1; i < lookback && i <= DirectionalBodyLookback; i++)
    {
        avgBody += MathAbs(rates[i].close - rates[i].open);
        bodyCount++;
    }
    if(bodyCount > 0)
        avgBody /= bodyCount;

    double currentBody = MathAbs(rates[0].close - rates[0].open);
    bodyRatio = avgBody > 0.0 ? currentBody / avgBody : 0.0;

    rangeHigh = rates[1].high;
    rangeLow = rates[1].low;
    for(int i = 2; i < lookback; i++)
    {
        if(rates[i].high > rangeHigh) rangeHigh = rates[i].high;
        if(rates[i].low < rangeLow) rangeLow = rates[i].low;
    }

    return true;
}

string AimeDetectMarketRegime(double emaFast, double emaSlow, double emaFastPrev, double rsi, double atrRatio, double closePrice, double rangeHigh, double rangeLow)
{
    double atr = 0.0;
    double point = ActivePoint();
    if(atrSignalHandle != INVALID_HANDLE)
    {
        double buf[];
        ArraySetAsSeries(buf, true);
        if(CopyBuffer(atrSignalHandle, 0, 0, 1, buf) == 1)
            atr = buf[0];
    }

    double separationATR = (atr > 0.0) ? MathAbs(emaFast - emaSlow) / atr : 0.0;
    double slopeATR = (atr > 0.0) ? MathAbs(emaFast - emaFastPrev) / atr : 0.0;

    bool upBreak = atr > 0.0 && closePrice > rangeHigh && (closePrice - rangeHigh) >= atr * (BreakoutATRExpansion - 1.0);
    bool downBreak = atr > 0.0 && closePrice < rangeLow && (rangeLow - closePrice) >= atr * (BreakoutATRExpansion - 1.0);

    if(atrRatio > 0.0 && atrRatio <= LowVolATRRatio)
        return "LOW_VOL";

    if(upBreak && emaFast >= emaSlow && rsi >= 50.0)
        return "BREAKOUT_UP";

    if(downBreak && emaFast <= emaSlow && rsi <= 50.0)
        return "BREAKOUT_DOWN";

    if(atrRatio >= HighVolATRRatio)
        return "HIGH_VOL";

    if(EnableTransitionRegimeGuard && separationATR < TrendSeparationATR * TransitionSeparationFraction &&
       slopeATR < TrendSlopeATR * TransitionSeparationFraction && MathAbs(rsi-50.0) <= TransitionRSITolerance)
        return "TRANSITION";

    if(separationATR >= TrendSeparationATR && slopeATR >= TrendSlopeATR && emaFast > emaSlow && rsi >= 52.0)
        return "TREND_UP";

    if(separationATR >= TrendSeparationATR && slopeATR >= TrendSlopeATR && emaFast < emaSlow && rsi <= 48.0)
        return "TREND_DOWN";

    return "RANGE";
}

double AimeRegimeThresholdMultiplier(string regime)
{
    if(!EnableRegimeAwareStrategy) return 1.0;
    if(regime == "TREND_UP" || regime == "TREND_DOWN") return TrendThresholdMultiplier;
    if(regime == "BREAKOUT_UP" || regime == "BREAKOUT_DOWN") return BreakoutThresholdMultiplier;
    if(regime == "RANGE") return RangeThresholdMultiplier;
    if(regime == "HIGH_VOL") return HighVolThresholdMultiplier;
    if(regime == "LOW_VOL") return LowVolThresholdMultiplier;
    return 1.0;
}

double AimeRegimeEdgeBoost(string regime)
{
    if(!EnableRegimeAwareStrategy) return 0.0;
    if(regime == "TREND_UP" || regime == "TREND_DOWN") return TrendMinEdgeBoost;
    if(regime == "BREAKOUT_UP" || regime == "BREAKOUT_DOWN") return BreakoutMinEdgeBoost;
    if(regime == "RANGE") return RangeMinEdgeBoost;
    if(regime == "HIGH_VOL") return HighVolMinEdgeBoost;
    return 0.0;
}

bool AimeRegimeEntryQuality(ENUM_ORDER_TYPE orderType, double atrRatio, double bodyRatio, double rsi, string &reason)
{
    reason = "";
    if(!EnableRegimeAwareStrategy) return true;
    bool isBuy = orderType == ORDER_TYPE_BUY;
    if(g_strategyRegime == "LOW_VOL")
    {
        reason = "LOW VOLATILITY";
        return false;
    }
    if(g_strategyRegime == "TREND_UP" && !isBuy)
    {
        reason = "TREND UP";
        return false;
    }
    if(g_strategyRegime == "TREND_DOWN" && isBuy)
    {
        reason = "TREND DOWN";
        return false;
    }
    if((g_strategyRegime == "TREND_UP" || g_strategyRegime == "TREND_DOWN") && atrRatio < MinATRRatioForTrendEntry)
    {
        reason = StringFormat("TREND ATR %.2f < %.2f", atrRatio, MinATRRatioForTrendEntry);
        return false;
    }
    if((g_strategyRegime == "BREAKOUT_UP" || g_strategyRegime == "BREAKOUT_DOWN") && bodyRatio < BreakoutBodyRatioMinimum)
    {
        reason = StringFormat("BREAKOUT BODY %.2f < %.2f", bodyRatio, BreakoutBodyRatioMinimum);
        return false;
    }
    if(g_strategyRegime == "BREAKOUT_UP" && !isBuy)
    {
        reason = "BREAKOUT UP";
        return false;
    }
    if(g_strategyRegime == "BREAKOUT_DOWN" && isBuy)
    {
        reason = "BREAKOUT DOWN";
        return false;
    }
    if(g_strategyRegime == "RANGE")
    {
        if(atrRatio > MaxATRRatioForRangeEntry)
        {
            reason = StringFormat("RANGE ATR %.2f > %.2f", atrRatio, MaxATRRatioForRangeEntry);
            return false;
        }
        if(MathAbs(rsi - 50.0) > RangeRSIMidpointTolerance)
        {
            double rangeScore = isBuy ? (_buyStrengthValid ? _cachedBuyStrength.finalScore : 0.0) : (_sellStrengthValid ? _cachedSellStrength.finalScore : 0.0);
            double oppositeScore = isBuy ? (_sellStrengthValid ? _cachedSellStrength.finalScore : 0.0) : (_buyStrengthValid ? _cachedBuyStrength.finalScore : 0.0);
            double rangeEdge = rangeScore - oppositeScore;
            double rangeBodyRatio = 0.0;
            double rangeMomentum = isBuy ? (_buyStrengthValid ? _cachedBuyStrength.momentumScore : 0.0) : (_sellStrengthValid ? _cachedSellStrength.momentumScore : 0.0);
            SignalStrength rangeChosen = isBuy ? _cachedBuyStrength : _cachedSellStrength;
            if(rangeChosen.avgBody > 0.0)
                rangeBodyRatio = rangeChosen.bodySignal / rangeChosen.avgBody;
            double rangeThreshold = isBuy ? AimeBuySignalThreshold() : AimeSellSignalThreshold();
            bool continuation = EnableRangeMomentumContinuation &&
                                rangeScore >= MathMax(RangeContinuationMinScore, rangeThreshold) &&
                                rangeEdge >= RangeContinuationMinEdge &&
                                rangeBodyRatio >= RangeContinuationMinBodyRatio &&
                                rangeMomentum >= RangeContinuationMinMomentum;
            if(!continuation)
            {
                reason = StringFormat("RANGE RSI %.1f OUTSIDE", rsi);
                return false;
            }
        }
    }
    return true;
}

ENUM_TIMEFRAMES AimeConfirmationTimeframe(ENUM_TIMEFRAMES period)
{
    if(period == PERIOD_M1) return PERIOD_M5;
    if(period == PERIOD_M2) return PERIOD_M10;
    if(period == PERIOD_M3) return PERIOD_M15;
    if(period == PERIOD_M4) return PERIOD_M20;
    if(period == PERIOD_M5) return PERIOD_M15;
    if(period == PERIOD_M6) return PERIOD_M30;
    if(period == PERIOD_M10) return PERIOD_M30;
    if(period == PERIOD_M12) return PERIOD_H1;
    if(period == PERIOD_M15) return PERIOD_H1;
    if(period == PERIOD_M20) return PERIOD_H1;
    if(period == PERIOD_M30) return PERIOD_H4;
    if(period == PERIOD_H1) return PERIOD_H4;
    if(period == PERIOD_H2) return PERIOD_H4;
    if(period == PERIOD_H3) return PERIOD_H4;
    if(period == PERIOD_H4) return PERIOD_D1;
    if(period == PERIOD_H6) return PERIOD_D1;
    if(period == PERIOD_H8) return PERIOD_D1;
    if(period == PERIOD_H12) return PERIOD_D1;
    if(period == PERIOD_D1) return PERIOD_W1;
    if(period == PERIOD_W1) return PERIOD_MN1;
    return PERIOD_H4;
}

int AimeHigherTimeframeDirection(string symbol, ENUM_TIMEFRAMES confirmationTF, bool &ready)
{
    ready = false;
    if(symbol == "" || confirmationTF == PERIOD_CURRENT) return 0;
    if(Bars(symbol, confirmationTF) < ConfirmationSlowEMAPeriod + 20) return 0;

    int fastHandle = iMA(symbol, confirmationTF, ConfirmationFastEMAPeriod, 0, MODE_EMA, PRICE_CLOSE);
    int slowHandle = iMA(symbol, confirmationTF, ConfirmationSlowEMAPeriod, 0, MODE_EMA, PRICE_CLOSE);
    int htfRsiHandle = iRSI(symbol, confirmationTF, ConfirmationRSIPeriod, PRICE_CLOSE);

    if(fastHandle == INVALID_HANDLE || slowHandle == INVALID_HANDLE || htfRsiHandle == INVALID_HANDLE)
    {
        if(fastHandle != INVALID_HANDLE) IndicatorRelease(fastHandle);
        if(slowHandle != INVALID_HANDLE) IndicatorRelease(slowHandle);
        if(htfRsiHandle != INVALID_HANDLE) IndicatorRelease(htfRsiHandle);
        return 0;
    }

    double fast[], slow[], rsi[];
    ArraySetAsSeries(fast, true);
    ArraySetAsSeries(slow, true);
    ArraySetAsSeries(rsi, true);

    bool ok = CopyBuffer(fastHandle, 0, 1, 2, fast) >= 2 &&
              CopyBuffer(slowHandle, 0, 1, 2, slow) >= 2 &&
              CopyBuffer(htfRsiHandle, 0, 1, 1, rsi) >= 1;

    IndicatorRelease(fastHandle);
    IndicatorRelease(slowHandle);
    IndicatorRelease(htfRsiHandle);

    if(!ok) return 0;

    ready = true;

    bool up = fast[0] > slow[0] && fast[0] >= fast[1] && rsi[0] >= 50.0;
    bool down = fast[0] < slow[0] && fast[0] <= fast[1] && rsi[0] <= 50.0;

    if(up) return 1;
    if(down) return -1;
    return 0;
}

bool AimeHigherTimeframeGate(ENUM_ORDER_TYPE orderType, string &reason)
{
    reason = "";
    if(!EnableHigherTimeframeConfirmation) return true;

    ENUM_TIMEFRAMES confirmationTF = AimeConfirmationTimeframe(g_activePeriod);
    bool ready = false;
    int direction = AimeHigherTimeframeDirection(g_activeSymbol, confirmationTF, ready);

    if(!ready)
    {
        reason = "HTF DATA NOT READY";
        return !RequireHigherTimeframeAlignment;
    }

    int requested = orderType == ORDER_TYPE_BUY ? 1 : -1;

    if(g_strategyRegime == "TREND_UP" || g_strategyRegime == "BREAKOUT_UP" ||
       g_strategyRegime == "TREND_DOWN" || g_strategyRegime == "BREAKOUT_DOWN")
    {
        if(direction != requested)
        {
            reason = direction == 0 ? "HTF NEUTRAL" : "HTF OPPOSITE";
            return false;
        }
        return true;
    }

    if(direction != 0 && direction != requested)
    {
        reason = "HTF OPPOSITE";
        return false;
    }

    return true;
}

bool AimeInstitutionalStrategyGate(ENUM_ORDER_TYPE orderType, double signalScore, string &reason)
{
    reason = "";
    if(!EnableInstitutionalStrategyCore)
        return true;

    bool isBuy = (orderType == ORDER_TYPE_BUY);
    double buyScore = _buyStrengthValid ? _cachedBuyStrength.finalScore : 0.0;
    double sellScore = _sellStrengthValid ? _cachedSellStrength.finalScore : 0.0;
    double buyThreshold = AimeBuySignalThreshold();
    double sellThreshold = AimeSellSignalThreshold();
    double regimeMultiplier = AimeRegimeThresholdMultiplier(g_strategyRegime);
    buyThreshold *= regimeMultiplier;
    sellThreshold *= regimeMultiplier;

    double dominantScore = isBuy ? buyScore : sellScore;
    double oppositeScore = isBuy ? sellScore : buyScore;
    double edge = dominantScore - oppositeScore;

    g_strategyEdge = edge;

    if(!g_strategyDataReady)
    {
        if(g_activeIndex>=0 && g_activeIndex<g_assetCount && g_assets[g_activeIndex].dataReason!="")
            reason = g_assets[g_activeIndex].dataReason;
        else
            reason = "DATA NOT READY";
        return false;
    }

    string higherTimeframeReason = "";
    if(!AimeHigherTimeframeGate(orderType, higherTimeframeReason))
    {
        reason = higherTimeframeReason;
        return false;
    }

    if(dominantScore < (isBuy ? buyThreshold : sellThreshold))
    {
        reason = StringFormat("SIGNAL %.2f < %.2f", dominantScore, isBuy ? buyThreshold : sellThreshold);
        return false;
    }

    double requiredEdge = MinDirectionalEdge;
    if(g_strategyRegime == "RANGE")
        requiredEdge = MathMax(requiredEdge, RangeMinDirectionalEdge);
    requiredEdge += AimeRegimeEdgeBoost(g_strategyRegime);

    if(edge < requiredEdge)
    {
        reason = StringFormat("EDGE %.2f < %.2f", edge, requiredEdge);
        return false;
    }

    bool regimeDirectionOK = true;
    if(g_strategyRegime == "TREND_UP" || g_strategyRegime == "BREAKOUT_UP")
        regimeDirectionOK = isBuy;
    else if(g_strategyRegime == "TREND_DOWN" || g_strategyRegime == "BREAKOUT_DOWN")
        regimeDirectionOK = !isBuy;
    else if(g_strategyRegime == "LOW_VOL")
        regimeDirectionOK = false;

    if(!regimeDirectionOK)
    {
        reason = "REGIME DIRECTION";
        return false;
    }

    double regimeEmaFast, regimeEmaSlow, regimeEmaPrev, regimeRSI, regimeATRRatio, regimeClose, regimeHigh, regimeLow, regimeBodyRatio;
    if(!AimeReadRegimeMetrics(regimeEmaFast, regimeEmaSlow, regimeEmaPrev, regimeRSI, regimeATRRatio, regimeClose, regimeHigh, regimeLow, regimeBodyRatio))
    {
        reason = "REGIME DATA INVALID";
        return false;
    }

    if(!AimeRegimeEntryQuality(orderType, regimeATRRatio, regimeBodyRatio, regimeRSI, reason))
        return false;

    if(g_strategyRegime == "HIGH_VOL")
    {
        double velocity = isBuy ? _cachedBuyStrength.normalizedVelocity : _cachedSellStrength.normalizedVelocity;
        if(velocity < HighVolMinVelocity)
        {
            reason = StringFormat("HIGH VOL VELOCITY %.2f < %.2f", velocity, HighVolMinVelocity);
            return false;
        }
    }

    double bodyRatio = 0.0;
    SignalStrength chosen = isBuy ? _cachedBuyStrength : _cachedSellStrength;
    if(chosen.avgBody > 0.0)
        bodyRatio = chosen.bodySignal / chosen.avgBody;

    double regimeQuality = 0.0;
    if(g_strategyRegime == "TREND_UP" || g_strategyRegime == "TREND_DOWN") regimeQuality = 0.90;
    else if(g_strategyRegime == "BREAKOUT_UP" || g_strategyRegime == "BREAKOUT_DOWN") regimeQuality = 0.95;
    else if(g_strategyRegime == "RANGE") regimeQuality = 0.65;
    else if(g_strategyRegime == "HIGH_VOL") regimeQuality = 0.70;

    double edgeQuality = MathMin(1.0, edge / MathMax(1.0, (isBuy ? buyThreshold : sellThreshold)));
    double bodyQuality = MathMin(1.0, bodyRatio / MathMax(0.01, MinBodyRatio));
    double momentumQuality = MathMin(1.0, MathMax(0.0, isBuy ? chosen.momentumScore / 3.0 : chosen.momentumScore / 3.0));
    double setupQuality = 0.35 * regimeQuality + 0.30 * edgeQuality + 0.20 * bodyQuality + 0.15 * momentumQuality;
    g_strategySetupQuality = setupQuality;

    if(setupQuality < MinSetupQuality)
    {
        reason = StringFormat("SETUP QUALITY %.2f < %.2f", setupQuality, MinSetupQuality);
        return false;
    }

    g_strategyTimingQuality = MathMin(1.0, MathMax(0.0, chosen.normalizedVelocity));
    if(g_strategyTimingQuality < MinTimingQuality)
    {
        reason = StringFormat("TIMING %.2f < %.2f", g_strategyTimingQuality, MinTimingQuality);
        return false;
    }

    if(g_strategyRegime == "TRANSITION")
    {
        reason="REGIME TRANSITION";
        return false;
    }

    if(!AimeSignalFreshEnough(orderType, reason))
        return false;

    if(!AimeComponentQualityGate(orderType, reason))
        return false;

    if(!AimeConcentrationAllows(g_activeSymbol, reason))
        return false;

    if(!AimePerformanceGateAllows(g_activeIndex, reason))
        return false;

    return true;
}

void AimeBuildDecisionTrace()
{
    g_strategyDecisionTrace = "";
    g_strategyDecisionStage = "INIT";

    if(g_activeIndex < 0 || g_activeIndex >= g_assetCount)
    {
        g_strategyDecisionStage = "DATA";
        g_strategyDecisionTrace = "DATA=INVALID | FINAL=WAIT | REASON=ASSET UNAVAILABLE";
        return;
    }

    AssetContext asset = g_assets[g_activeIndex];
    double buyScore = asset.buyStrengthValid ? asset.cachedBuyStrength.finalScore : 0.0;
    double sellScore = asset.sellStrengthValid ? asset.cachedSellStrength.finalScore : 0.0;
    double buyThreshold = AimeBuySignalThresholdForSymbol(asset.symbol);
    double sellThreshold = AimeSellSignalThresholdForSymbol(asset.symbol);
    bool buyDominant = buyScore > sellScore;
    bool sellDominant = sellScore > buyScore;
    double selectedScore = buyDominant ? buyScore : sellDominant ? sellScore : MathMax(buyScore,sellScore);
    double selectedThreshold = buyDominant ? buyThreshold : sellDominant ? sellThreshold : MathMax(buyThreshold,sellThreshold);
    double edge = MathAbs(buyScore-sellScore);
    SignalStrength selected = buyDominant ? asset.cachedBuyStrength : asset.cachedSellStrength;

    string dataState = asset.strategyDataReady ? "PASS" : "FAIL";
    long traceBarAge = AimeAssetBarAgeSeconds(g_activeIndex);
    string barState = traceBarAge >= 0 ? StringFormat("%lds",traceBarAge) : "N/A";
    string directionState = asset.strategyDirection == "BUY" || asset.strategyDirection == "SELL" ? asset.strategyDirection : asset.strategyDirection;
    string trendState = "N/A";
    string momentumState = "N/A";
    if(buyDominant || sellDominant)
    {
        trendState = selected.trendScore > 0.0 ? "PASS" : "FAIL";
        momentumState = selected.momentumScore > 0.0 ? "PASS" : "FAIL";
    }

    string stage = "QUALIFICATION";
    string reason = asset.strategyReason;
    if(!asset.strategyDataReady) stage = "DATA";
    else if(asset.strategyFinalDecision == "BUY READY" || asset.strategyFinalDecision == "SELL READY") stage = "QUALIFICATION PASS";
    else if(StringFind(reason,"HTF") >= 0) stage = "HTF";
    else if(StringFind(reason,"SIGNAL") >= 0) stage = "SIGNAL SCORE";
    else if(StringFind(reason,"EDGE") >= 0) stage = "DIRECTIONAL EDGE";
    else if(StringFind(reason,"REGIME") >= 0) stage = "REGIME";
    else if(StringFind(reason,"SETUP") >= 0) stage = "SETUP";
    else if(StringFind(reason,"TIMING") >= 0) stage = "TIMING";
    else if(StringFind(reason,"FRESH") >= 0 || StringFind(reason,"QUALITY") >= 0 || StringFind(reason,"CONCENTRATION") >= 0) stage = "QUALITY GATE";
    else if(asset.strategyFinalDecision == "WAIT") stage = "WAIT";
    else if(asset.strategyFinalDecision == "BLOCKED") stage = "BLOCKED";

    g_strategyDecisionStage = stage;
    g_strategyDecisionTrace = StringFormat(
        "DATA=%s | BAR=%s | DIR=%s | SCORE=%.2f/%.2f | EDGE=%.2f | REGIME=%s | TREND=%s | MOM=%s | SETUP=%.2f/%s | TIMING=%.2f/%s | FINAL=%s | REASON=%s",
        dataState,
        barState,
        directionState,
        selectedScore,
        selectedThreshold,
        edge,
        asset.strategyRegime,
        trendState,
        momentumState,
        asset.strategySetupQuality,
        asset.strategySetupPass ? "PASS" : "FAIL",
        asset.strategyTimingQuality,
        asset.strategyTimingPass ? "PASS" : "FAIL",
        asset.strategyFinalDecision,
        reason == "" ? "NONE" : reason);

    if(EnableDecisionTraceLogging && EnableLogging)
        Print("[DECISION TRACE][",asset.symbol,"] ",g_strategyDecisionTrace);
}

void AimeUpdateStrategySnapshot()
{
    g_strategyDataReady = false;
    g_strategyDirection = "WAIT";
    g_strategyFinalDecision = "WAIT";
    g_strategyReason = "SIGNAL PENDING";
    g_strategyEdge = 0.0;
    g_strategySetupQuality = 0.0;
    g_strategyTimingQuality = 0.0;
    g_strategySetupPass = false;
    g_strategyTimingPass = false;
    g_strategyDecisionTrace = "";
    g_strategyDecisionStage = "DATA";

    if(g_activeIndex < 0 || g_activeIndex >= g_assetCount)
    {
        g_strategyRegime = "UNINITIALIZED";
        return;
    }

    string liveGateReason = "";
    if(!AimeAssetDataGate(g_activeIndex,liveGateReason))
    {
        g_strategyRegime = "DATA_WAIT";
        g_strategyReason = liveGateReason == "" ? "MARKET DATA NOT READY" : liveGateReason;
        g_strategyFinalDecision = "BLOCKED";
        AimeBuildDecisionTrace();
        return;
    }

    double emaFast, emaSlow, emaFastPrev, rsi, atrRatio, closePrice, rangeHigh, rangeLow, bodyRatio;
    if(!AimeReadRegimeMetrics(emaFast, emaSlow, emaFastPrev, rsi, atrRatio, closePrice, rangeHigh, rangeLow, bodyRatio))
    {
        g_strategyRegime = "DATA_WAIT";
        g_strategyReason = "DATA NOT READY";
        return;
    }

    g_strategyDataReady = true;
    g_strategyRegime = AimeDetectMarketRegime(emaFast, emaSlow, emaFastPrev, rsi, atrRatio, closePrice, rangeHigh, rangeLow);

    double buyScore = _buyStrengthValid ? _cachedBuyStrength.finalScore : 0.0;
    double sellScore = _sellStrengthValid ? _cachedSellStrength.finalScore : 0.0;
    double buyThreshold = AimeBuySignalThreshold();
    double sellThreshold = AimeSellSignalThreshold();

    if(buyScore >= buyThreshold && buyScore > sellScore)
        g_strategyDirection = "BUY";
    else if(sellScore >= sellThreshold && sellScore > buyScore)
        g_strategyDirection = "SELL";
    else if(buyScore > sellScore)
        g_strategyDirection = "BUY LEAN";
    else if(sellScore > buyScore)
        g_strategyDirection = "SELL LEAN";
    else
        g_strategyDirection = "NEUTRAL";

    if(_buyStrengthValid && _sellStrengthValid)
        g_strategyEdge = MathAbs(buyScore - sellScore);

    if(g_strategyDirection == "BUY" || g_strategyDirection == "SELL")
    {
        ENUM_ORDER_TYPE dir = g_strategyDirection == "BUY" ? ORDER_TYPE_BUY : ORDER_TYPE_SELL;
        double score = g_strategyDirection == "BUY" ? buyScore : sellScore;
        string gateReason = "";
        bool gatePass = AimeInstitutionalStrategyGate(dir, score, gateReason);

        g_strategySetupPass = g_strategySetupQuality >= MinSetupQuality;
        g_strategyTimingPass = g_strategyTimingQuality >= MinTimingQuality;

        if(gatePass)
        {
            g_strategyFinalDecision = g_strategyDirection == "BUY" ? "BUY READY" : "SELL READY";
            g_strategyReason = "STRATEGY PASS";
        }
        else
        {
            g_strategyFinalDecision = "BLOCKED";
            g_strategyReason = gateReason;
        }
    }
    else
    {
        g_strategyFinalDecision = "WAIT";
        if(!_buyStrengthValid && !_sellStrengthValid)
            g_strategyReason = "SIGNAL DATA PENDING";
        else if(buyScore > sellScore)
        {
            double deficit = MathMax(0.0,buyThreshold-buyScore);
            g_strategyReason = StringFormat("BUY SCORE %.2f / %.2f | GAP %.2f",buyScore,buyThreshold,deficit);
        }
        else if(sellScore > buyScore)
        {
            double deficit = MathMax(0.0,sellThreshold-sellScore);
            g_strategyReason = StringFormat("SELL SCORE %.2f / %.2f | GAP %.2f",sellScore,sellThreshold,deficit);
        }
        else
            g_strategyReason = "NO DIRECTIONAL EDGE";
    }
    AimeBuildDecisionTrace();
}

void CheckForTradingSignal()
{
    string liveGateReason = "";
    if(!AimeAssetDataGate(g_activeIndex,liveGateReason))
    {
        g_strategyDataReady = false;
        g_strategyDirection = "WAIT";
        g_strategyFinalDecision = "BLOCKED";
        g_strategyReason = liveGateReason == "" ? "MARKET DATA NOT READY" : liveGateReason;
        g_strategyDecisionStage = "DATA";
        AimeBuildDecisionTrace();
        SaveAssetContext();
        return;
    }

    datetime currBarTime = iTime(g_activeSymbol, g_activePeriod, 0);
    if(currBarTime <= 0) return;

    if(EnableNewBarEntryOnly)
    {
        datetime now = TimeCurrent();
        if(g_lastEntryAttemptBarTime == currBarTime &&
           g_lastEntryAttemptTime > 0 &&
           (now - g_lastEntryAttemptTime) < MathMax(1, EntryRetrySeconds))
            return;

        g_lastEntryAttemptBarTime = currBarTime;
        g_lastEntryAttemptTime = now;
    }

    double buySignal = BuySignal();
    double sellSignal = SellSignal();

    if(buySignal > sellSignal)
    {
        if(!EnableBuyOrders) return;

        string strategyReason = "";
        if(!AimeInstitutionalStrategyGate(ORDER_TYPE_BUY, buySignal, strategyReason))
        {
            g_strategyFinalDecision = "BLOCKED";
            g_strategyReason = strategyReason;
            AimeBuildDecisionTrace();
            SaveAssetContext();
            return;
        }

        g_strategyFinalDecision = "BUY READY";
        g_strategyReason = "STRATEGY PASS";
        AimeBuildDecisionTrace();

        int beforePositions = AimeSymbolExposureSlots(g_activeSymbol);
        int beforeOrders = CountWorkingLimitOrders();

        if(EnableLimitEntry)
            PlaceLimitEntry(ORDER_TYPE_BUY, buySignal);
        else
            OpenPosition(ORDER_TYPE_BUY, buySignal);

        int afterPositions = AimeSymbolExposureSlots(g_activeSymbol);
        int afterOrders = CountWorkingLimitOrders();
        if(afterPositions > beforePositions || afterOrders > beforeOrders)
            lastEntryBarTime = currBarTime;
    }
    else if(buySignal < sellSignal)
    {
        if(!EnableSellOrders) return;

        string strategyReason = "";
        if(!AimeInstitutionalStrategyGate(ORDER_TYPE_SELL, sellSignal, strategyReason))
        {
            g_strategyFinalDecision = "BLOCKED";
            g_strategyReason = strategyReason;
            AimeBuildDecisionTrace();
            SaveAssetContext();
            return;
        }

        g_strategyFinalDecision = "SELL READY";
        g_strategyReason = "STRATEGY PASS";
        AimeBuildDecisionTrace();

        int beforePositions = AimeSymbolExposureSlots(g_activeSymbol);
        int beforeOrders = CountWorkingLimitOrders();

        if(EnableLimitEntry)
            PlaceLimitEntry(ORDER_TYPE_SELL, sellSignal);
        else
            OpenPosition(ORDER_TYPE_SELL, sellSignal);

        int afterPositions = AimeSymbolExposureSlots(g_activeSymbol);
        int afterOrders = CountWorkingLimitOrders();
        if(afterPositions > beforePositions || afterOrders > beforeOrders)
            lastEntryBarTime = currBarTime;
    }
    else
    {
        g_strategyFinalDecision = "WAIT";
        g_strategyReason = "NO DIRECTIONAL EDGE";
        AimeBuildDecisionTrace();
        SaveAssetContext();
    }
}

double BuySignal()
{
    double currentPrice = SymbolInfoDouble(g_activeSymbol, SYMBOL_ASK);

    if(!CheckEntryConditions(POSITION_TYPE_BUY, currentPrice)) return 0;

    SignalStrength strength = GetSignalStrength(ORDER_TYPE_BUY);

    double adjustedScore = strength.finalScore;
    double adjustedThreshold = AimeBuySignalThreshold();

    if(consecutiveBuyCandles > 0 && ConsecutiveCandleThresholdBoost > 0)
    {
        int boostCount = consecutiveBuyCandles;
        if(MaxConsecutiveCandleBoosts > 0 && boostCount > MaxConsecutiveCandleBoosts)
            boostCount = MaxConsecutiveCandleBoosts;

        double candleBoost = boostCount * ConsecutiveCandleThresholdBoost;
        adjustedThreshold += candleBoost;
        LogPrint("[CANDLE ESCALATION] Buy threshold boosted by ", DoubleToString(candleBoost, 1),
                 " (", boostCount, " consecutive trading candles). Threshold: ",
                 DoubleToString(adjustedThreshold, 1));
    }

    if(EnableSignalDampening)
    {
        PositionLossState lossState = GetOpenPositionLossState(POSITION_TYPE_BUY);
        if(lossState.losingCount > 0)
        {
            double penalty = lossState.losingCount * LosingPosScorePenalty;
            adjustedScore -= penalty;
            LogPrint("[DAMPENED] Buy score reduced by ", DoubleToString(penalty, 1),
                     " (", lossState.losingCount, " losing buys). Raw: ",
                     DoubleToString(strength.finalScore, 1), " -> Adjusted: ",
                     DoubleToString(adjustedScore, 1));
        }

        if(peakEquity > 0)
        {
            double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
            double drawdownPct = ((peakEquity - currentEquity) / peakEquity) * 100.0;

            if(drawdownPct >= DrawdownThresholdPct)
            {
                adjustedThreshold += DrawdownScoreBoost;
                LogPrint("[DRAWDOWN GATE] Equity drawdown ", DoubleToString(drawdownPct, 1),
                         "% >= ", DoubleToString(DrawdownThresholdPct, 1),
                         "%. Buy threshold raised to ", DoubleToString(adjustedThreshold, 1));
            }
        }
    }

    if (adjustedScore >= adjustedThreshold)
    {
        LogPrint("BUY SIGNAL RECEIVED (Score: ", DoubleToString(strength.finalScore, 1),
                 " | Adjusted: ", DoubleToString(adjustedScore, 1),
                 " / Threshold: ", DoubleToString(adjustedThreshold, 1), ")");
        LogPrint("Details: Body=", DoubleToString(strength.bodySignal, ActiveDigits()),
                 ", AvgBody=", DoubleToString(strength.avgBody, ActiveDigits()),
                 ", Ratio=", DoubleToString(strength.ratio, 2),
                 ", PenBody=", DoubleToString(strength.penaltyBody, 1),
                 ", PenWick=", DoubleToString(strength.penaltyWick, 1));
        LogPrint("Reasoning: ", strength.reasoning);
        LogPrint("Price: ", currentPrice);

        return adjustedScore;
    }

    return 0;
}

double SellSignal()
{
    double currentPrice = SymbolInfoDouble(g_activeSymbol, SYMBOL_BID);

    if(!CheckEntryConditions(POSITION_TYPE_SELL, currentPrice)) return 0;

    SignalStrength strength = GetSignalStrength(ORDER_TYPE_SELL);

    double adjustedScore = strength.finalScore;
    double adjustedThreshold = AimeSellSignalThreshold();

    if(consecutiveSellCandles > 0 && ConsecutiveCandleThresholdBoost > 0)
    {
        int boostCount = consecutiveSellCandles;
        if(MaxConsecutiveCandleBoosts > 0 && boostCount > MaxConsecutiveCandleBoosts)
            boostCount = MaxConsecutiveCandleBoosts;

        double candleBoost = boostCount * ConsecutiveCandleThresholdBoost;
        adjustedThreshold += candleBoost;
        LogPrint("[CANDLE ESCALATION] Sell threshold boosted by ", DoubleToString(candleBoost, 1),
                 " (", boostCount, " consecutive trading candles). Threshold: ",
                 DoubleToString(adjustedThreshold, 1));
    }

    if(EnableSignalDampening)
    {
        PositionLossState lossState = GetOpenPositionLossState(POSITION_TYPE_SELL);
        if(lossState.losingCount > 0)
        {
            double penalty = lossState.losingCount * LosingPosScorePenalty;
            adjustedScore -= penalty;
            LogPrint("[DAMPENED] Sell score reduced by ", DoubleToString(penalty, 1),
                     " (", lossState.losingCount, " losing sells). Raw: ",
                     DoubleToString(strength.finalScore, 1), " -> Adjusted: ",
                     DoubleToString(adjustedScore, 1));
        }

        if(peakEquity > 0)
        {
            double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
            double drawdownPct = ((peakEquity - currentEquity) / peakEquity) * 100.0;

            if(drawdownPct >= DrawdownThresholdPct)
            {
                adjustedThreshold += DrawdownScoreBoost;
                LogPrint("[DRAWDOWN GATE] Equity drawdown ", DoubleToString(drawdownPct, 1),
                         "% >= ", DoubleToString(DrawdownThresholdPct, 1),
                         "%. Sell threshold raised to ", DoubleToString(adjustedThreshold, 1));
            }
        }
    }

    if (adjustedScore >= adjustedThreshold)
    {
        LogPrint("SELL SIGNAL RECEIVED (Score: ", DoubleToString(strength.finalScore, 1),
                 " | Adjusted: ", DoubleToString(adjustedScore, 1),
                 " / Threshold: ", DoubleToString(adjustedThreshold, 1), ")");
        LogPrint("Details: Body=", DoubleToString(strength.bodySignal, ActiveDigits()),
                 ", AvgBody=", DoubleToString(strength.avgBody, ActiveDigits()),
                 ", Ratio=", DoubleToString(strength.ratio, 2),
                 ", PenBody=", DoubleToString(strength.penaltyBody, 1),
                 ", PenWick=", DoubleToString(strength.penaltyWick, 1));
        LogPrint("Reasoning: ", strength.reasoning);
        LogPrint("Price: ", currentPrice);

        return adjustedScore;
    }

    return 0;
}

bool CheckEntryConditions(ENUM_POSITION_TYPE dir, double price)
{
    datetime currBarTime = iTime(g_activeSymbol, g_activePeriod, 0);
    bool isBuy = (dir == POSITION_TYPE_BUY);
    string dirName = isBuy ? "Buy" : "Sell";

    int sameOnBar = isBuy ? buysOnCurrentBar : sellsOnCurrentBar;
    int oppOnBar = isBuy ? sellsOnCurrentBar : buysOnCurrentBar;

    if(MaxTradesPerCandle > 0)
    {
        int onCandle = (currentBarTime == currBarTime) ? sameOnBar : 0;
        if(onCandle >= MaxTradesPerCandle)
        {
            return false;
        }
    }

    if(oppOnBar > 0)
    {
        return false;
    }

    if(EnableSignalDampening)
    {
        PositionLossState lossState = GetOpenPositionLossState(dir);
        if(lossState.losingCount >= MaxLosingPositionsSameDir)
        {
            LogPrint("[DAMPENED] ", dirName, " BLOCKED: ", lossState.losingCount,
                     " losing ", dirName, "s >= max ", MaxLosingPositionsSameDir);
            return false;
        }
    }

    if(EnableSignalDampening && cooldownUntilBarTime > 0)
    {
        if(currBarTime < cooldownUntilBarTime)
        {
            LogPrint("[COOLDOWN] ", dirName, " BLOCKED: cooldown active until ",
                     TimeToString(cooldownUntilBarTime));
            return false;
        }
        else
        {
            cooldownUntilBarTime = 0;
        }
    }

    ulong lastTicket = GetLastPositionTicket(dir);
    datetime lastTime = isBuy ? lastBuyTime : lastSellTime;
    double lastPrice = isBuy ? lastBuyPrice : lastSellPrice;
    double dupMult = isBuy ? BuyDuplicateMultiplier : SellDuplicateMultiplier;

    if(lastTime > 0 && lastTicket > 0)
    {
        double minDistance = ZonePoints * ActivePoint() * dupMult;
        double distance = MathAbs(price - lastPrice);

        if(distance < minDistance)
        {
            return false;
        }
    }

    if(EnableCandleDirectionFilter)
    {
        MqlRates bar[];
        ArraySetAsSeries(bar,true);
        if(CopyRates(g_activeSymbol,g_activePeriod,1,1,bar) < 1) return false;
        double range=bar[0].high-bar[0].low;
        double body=MathAbs(bar[0].close-bar[0].open);
        double bodyRatio=range>0.0 ? body/range : 0.0;
        bool candleAligned=isBuy ? bar[0].close>bar[0].open : bar[0].close<bar[0].open;
        if(!candleAligned || bodyRatio < MinimumBodyDirectionRatio) return false;
    }

    if(EnableDirectionalEdgeFilter)
    {
        SignalStrength ownStrength=GetSignalStrength(isBuy ? ORDER_TYPE_BUY : ORDER_TYPE_SELL);
        SignalStrength oppStrength=GetSignalStrength(isBuy ? ORDER_TYPE_SELL : ORDER_TYPE_BUY);
        double edge=ownStrength.finalScore-oppStrength.finalScore;
        if(edge < MinimumDirectionalEdge) return false;
    }

    return true;
}

bool IsPositionHoldingTimeExpired(ulong ticket)
{
    if(!EnableMaximumHoldingTime || !CloseAtMaximumHoldingTime || MaximumHoldingMinutes <= 0) return false;
    if(!PositionSelectByTicket(ticket)) return false;

    datetime openTime = (datetime)PositionGetInteger(POSITION_TIME);
    if(openTime <= 0) return false;

    long heldSeconds = (long)(TimeCurrent() - openTime);
    long minimumSeconds = (long)MathMax(0, MinimumHoldingMinutes) * 60;
    long maximumSeconds = (long)MaximumHoldingMinutes * 60;

    if(heldSeconds < minimumSeconds) return false;
    return heldSeconds >= maximumSeconds;
}

void ManageMaximumHoldingTime()
{
    if(!EnableMaximumHoldingTime || !CloseAtMaximumHoldingTime || MaximumHoldingMinutes <= 0) return;

    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;

        long magic = (long)PositionGetInteger(POSITION_MAGIC);
        if(!IsAimeMagic(magic)) continue;

        string symbol = PositionGetString(POSITION_SYMBOL);
        datetime openTime = (datetime)PositionGetInteger(POSITION_TIME);
        if(openTime <= 0) continue;

        long heldSeconds = (long)(TimeCurrent() - openTime);
        long minimumSeconds = (long)MathMax(0, MinimumHoldingMinutes) * 60;
        long maximumSeconds = (long)MaximumHoldingMinutes * 60;
        if(heldSeconds < minimumSeconds || heldSeconds < maximumSeconds) continue;

        double profit = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
        LogPrint("[MAX HOLDING EXIT] ticket=", ticket, " symbol=", symbol, " heldMinutes=", (int)(heldSeconds/60), " P/L=", DoubleToString(profit,2));
        ClosePosition(ticket);
    }
}

void ManagePositions()
{
    SyncManagedPositions();
    ManageMaximumHoldingTime();
    ManageHedgeChains();

    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0) continue;

        if(!PositionSelectByTicket(ticket)) continue;

        if(PositionGetInteger(POSITION_MAGIC) != ActiveMagicNumber()) continue;
        if(PositionGetString(POSITION_SYMBOL) != g_activeSymbol) continue;

        ManageTrailingTPSL(ticket);
    }

    ManageLosingPositions();
    ManagePendingOrders();
}

double ComputeRawScore(ENUM_ORDER_TYPE orderType, int signalIndex)
{
    SignalStrength dummy;
    return ComputeRawScore(orderType, signalIndex, dummy, false);
}

double ComputeRawScore(ENUM_ORDER_TYPE orderType, int signalIndex, SignalStrength &components, bool fillComponents)
{
    bool isBuy = (orderType == ORDER_TYPE_BUY);
    bool isSell = (orderType == ORDER_TYPE_SELL);

    double bufEMA_Fast[], bufEMA_Slow[], bufRSI[], bufATR[];
    ArraySetAsSeries(bufEMA_Fast, true);
    ArraySetAsSeries(bufEMA_Slow, true);
    ArraySetAsSeries(bufRSI, true);
    ArraySetAsSeries(bufATR, true);

    int needed = MathMax(ImpulseLookback, MathMax(DirectionalBodyLookback, ATRAvgLookback)) + 5;

    int slopeBars = (SlopeLookback < 1) ? 1 : SlopeLookback;
    int emaFastCopy = MathMax(3, slopeBars + 1);

    if(CopyBuffer(emaFastHandle, 0, signalIndex, emaFastCopy, bufEMA_Fast) < emaFastCopy) return 0;
    if(CopyBuffer(emaSlowHandle, 0, signalIndex, 3, bufEMA_Slow) < 3) return 0;
    if(CopyBuffer(rsiHandle, 0, signalIndex, 3, bufRSI) < 3) return 0;
    if(CopyBuffer(atrSignalHandle, 0, signalIndex, needed, bufATR) < needed) return 0;

    MqlRates rates[];
    ArraySetAsSeries(rates, true);
    if(CopyRates(g_activeSymbol, g_activePeriod, signalIndex, needed, rates) < needed) return 0;

    double emaFast = bufEMA_Fast[0];
    double emaSlow = bufEMA_Slow[0];

    double emaFastPrev = bufEMA_Fast[slopeBars];
    double trendScore = 0;

    bool trendAligned = false;
    if (isBuy) trendAligned = (emaFast > emaSlow);
    else trendAligned = (emaFast < emaSlow);
    if (trendAligned) trendScore += TrendWeight;

    bool slopeAligned = false;
    if (isBuy) slopeAligned = (emaFast > emaFastPrev);
    else slopeAligned = (emaFast < emaFastPrev);
    if (slopeAligned) trendScore += SlopeWeight;
    if(trendScore > 3.0) trendScore = 3.0;

    double currentBody = MathAbs(rates[0].close - rates[0].open);
    double sumBody = 0;
    int validCandles = 0;
    for(int i=1; i<=DirectionalBodyLookback && i<needed; i++)
    {
        sumBody += MathAbs(rates[i].close - rates[i].open);
        validCandles++;
    }
    double avgRecentBody = (validCandles > 0) ? sumBody / validCandles : currentBody;

    double rsi = bufRSI[0];
    double baseMomentum = 0;

    if (isBuy)
    {
        if (rsi > 50 && rsi < RSIOverbought) baseMomentum += MomentumBaseWeight;
        if (rsi > RSIMomentumBuy) baseMomentum += MomentumTriggerWeight;
        if (currentBody > avgRecentBody) baseMomentum += BodyMomentumWeight;
    }
    else
    {
        if (rsi < 50 && rsi > RSIOversold) baseMomentum += MomentumBaseWeight;
        if (rsi < RSIMomentumSell) baseMomentum += MomentumTriggerWeight;
        if (currentBody > avgRecentBody) baseMomentum += BodyMomentumWeight;
    }

    double momentumScore = baseMomentum;

    double bodyAccel = 0;
    if (avgRecentBody > 0) bodyAccel = currentBody / avgRecentBody;
    if (bodyAccel > 3.0) bodyAccel = 3.0;

    double currentRange = rates[0].high - rates[0].low;
    double sumRange = 0;
    for(int i=1; i<=DirectionalBodyLookback && i<needed; i++)
    {
        sumRange += (rates[i].high - rates[i].low);
    }
    double avgRecentRange = (validCandles > 0) ? sumRange / validCandles : currentRange;

    double rangeAccel = 0;
    if (avgRecentRange > 0) rangeAccel = currentRange / avgRecentRange;
    if (rangeAccel > 3.0) rangeAccel = 3.0;

    int sameDirCount = 0;
    for(int i=0; i<ImpulseLookback && i<needed; i++)
    {
        bool candleBullish = (rates[i].close > rates[i].open);
        bool candleBearish = (rates[i].close < rates[i].open);

        if (isBuy && candleBullish) sameDirCount++;
        else if (isSell && candleBearish) sameDirCount++;
        else break;
    }
    double continuityScore = (double)sameDirCount / ImpulseLookback;
    if(continuityScore > 1.0) continuityScore = 1.0;

    double rawImpulse = (0.5 * bodyAccel + 0.3 * rangeAccel + 0.2 * continuityScore) / 2.0;
    if (rawImpulse > 1.0) rawImpulse = 1.0;
    if (rawImpulse < 0.0) rawImpulse = 0.0;

    momentumScore = momentumScore * (1.0 + ImpulseBoostWeight * rawImpulse);
    if (momentumScore > 3.0) momentumScore = 3.0;

    double currentATR = bufATR[0];
    double avgATR = 0;
    if (needed >= ATRAvgLookback) {
         double sumATR = 0;
         for(int i=0; i<ATRAvgLookback && i<needed; i++) sumATR += bufATR[i];
         avgATR = sumATR / ATRAvgLookback;
    } else {
         avgATR = currentATR;
    }

    double volRatio = 0;
    if(avgATR > 0) volRatio = currentATR / avgATR;

    double activeMinVolRatio = AimeMinVolRatio();
    if(activeMinVolRatio > 0 && volRatio > 0 && volRatio < activeMinVolRatio)
        return 0;

    double chopScore = 0;
    if (volRatio > 1.0) chopScore = ChopScoreHigh;
    else if (volRatio > 0.8) chopScore = ChopScoreMed;
    else chopScore = ChopScoreLow;
    if (chopScore > 2.0) chopScore = 2.0;

    double volatilityScore = (volRatio > 1.2) ? VolatilityScoreHigh : VolatilityScoreLow;

    bool breakout = false;
    double localExtreme = isBuy ? rates[1].high : rates[1].low;
    for(int i=2; i<=5; i++)
    {
         if(isBuy) localExtreme = MathMax(localExtreme, rates[i].high);
         else localExtreme = MathMin(localExtreme, rates[i].low);
    }

    double peakScore = 0;
    if(isBuy && rates[0].close > localExtreme) breakout = true;
    if(isSell && rates[0].close < localExtreme) breakout = true;
    if(breakout) peakScore = PeakScoreWeight;

    double maxOpenClose = MathMax(rates[0].open, rates[0].close);
    double minOpenClose = MathMin(rates[0].open, rates[0].close);
    double upperWick = rates[0].high - maxOpenClose;
    double lowerWick = minOpenClose - rates[0].low;

    double safeBody = MathMax(currentBody, avgRecentBody * MinBodyRatio);
    double penaltyWick = 0;
    double rejection = 0;

    if (safeBody > 0)
    {
        if (isBuy) rejection = upperWick / safeBody;
        else rejection = lowerWick / safeBody;
        penaltyWick = rejection * WickRejectionWeight;
    }

    double rawScore = trendScore + momentumScore + chopScore + peakScore + volatilityScore;
    rawScore -= penaltyWick;

    if (rawScore < 0) rawScore = 0;
    if (rawScore > 10.0) rawScore = 10.0;

    if(fillComponents)
    {
        components.trendScore = trendScore;
        components.momentumScore = momentumScore;
        components.chopScore = chopScore;
        components.peakScore = peakScore;
        components.volatilityScore = volatilityScore;
        components.impulseStrength = rawImpulse;
        components.avgBody = avgRecentBody;
        components.bodySignal = currentBody;
        components.upperWick = upperWick;
        components.lowerWick = lowerWick;
        components.rejection = rejection;
        components.penaltyWick = penaltyWick;
    }

    return rawScore;
}

SignalStrength GetSignalStrength(ENUM_ORDER_TYPE orderType)
{
    if(g_activeIndex < 0 || g_activeIndex >= g_assetCount || g_activeSymbol == "")
    {
        SignalStrength emptyStrength;
        emptyStrength.finalScore = 0.0;
        emptyStrength.reasoning = "NO ACTIVE ASSET";
        return emptyStrength;
    }

    if(orderType == ORDER_TYPE_BUY && _buyStrengthValid && buyStrengthCacheSymbol == g_activeSymbol && buyStrengthCacheBarTime == currentBarTime)
        return _cachedBuyStrength;
    if(orderType == ORDER_TYPE_SELL && _sellStrengthValid && sellStrengthCacheSymbol == g_activeSymbol && sellStrengthCacheBarTime == currentBarTime)
        return _cachedSellStrength;

    SignalStrength strength;
    strength.finalScore = 0;
    strength.trendScore = 0;
    strength.momentumScore = 0;
    strength.chopScore = 0;
    strength.peakScore = 0;
    strength.volatilityScore = 0;
    strength.impulseStrength = 0;
    strength.velocity = 0;
    strength.normalizedVelocity = 0;
    strength.avgBody = 0;
    strength.bodySignal = 0;
    strength.ratio = 0;
    strength.upperWick = 0;
    strength.lowerWick = 0;
    strength.rejection = 0;
    strength.penaltyBody = 0;
    strength.penaltyWick = 0;
    strength.reasoning = "";

    bool isBuy = (orderType == ORDER_TYPE_BUY);

    int N = SignalSmoothingCandles;
    if(N < 1) N = 1;
    if(N > 10) N = 10;
    double blend = CurrentCandleBlend;
    if(blend < 0.0) blend = 0.0;
    if(blend > 1.0) blend = 1.0;

    double weightedSum = 0;
    double weightTotal = 0;

    for(int i = 1; i <= N; i++)
    {
        double score_i = (i == 1)
            ? ComputeRawScore(orderType, i, strength, true)
            : ComputeRawScore(orderType, i);
        double weight = (double)(N - i + 1);
        weightedSum += score_i * weight;
        weightTotal += weight;
    }

    double baseScore = (weightTotal > 0) ? weightedSum / weightTotal : 0;

    double currentScore = ComputeRawScore(orderType, 0);

    double finalScore = baseScore * (1.0 - blend) + currentScore * blend;

    if(finalScore < 0) finalScore = 0;
    if(finalScore > 10.0) finalScore = 10.0;

    strength.finalScore = finalScore;

    double prevScore = 0;
    if (isBuy)
    {
        prevScore = lastBuySignalScorePrev;
    }
    else
    {
        prevScore = lastSellSignalScorePrev;
    }

    double velocity = strength.finalScore - prevScore;
    strength.velocity = velocity;

    strength.normalizedVelocity = (velocity + VelocityWindow) / (2.0 * VelocityWindow);
    if(strength.normalizedVelocity < 0) strength.normalizedVelocity = 0;
    if(strength.normalizedVelocity > 1.0) strength.normalizedVelocity = 1.0;

    if(isBuy) {
        lastBuyVelocity = strength.velocity;
        lastBuyNormalizedVelocity = strength.normalizedVelocity;
    } else {
        lastSellVelocity = strength.velocity;
        lastSellNormalizedVelocity = strength.normalizedVelocity;
    }

    strength.reasoning = StringFormat("T:%.1f M:%.1f(Imp:%.2f) C:%.1f P:%.1f V:%.1f | Vel:%.2f [Smooth:%d Blend:%.0f%%]",
        strength.trendScore, strength.momentumScore, strength.impulseStrength,
        strength.chopScore, strength.peakScore, strength.volatilityScore, strength.normalizedVelocity,
        N, blend * 100);

    if(orderType == ORDER_TYPE_BUY)
    {
        _cachedBuyStrength = strength;
        _buyStrengthValid = true;
        buyStrengthCacheBarTime = currentBarTime;
        buyStrengthCacheSymbol = g_activeSymbol;
    }
    else
    {
        _cachedSellStrength = strength;
        _sellStrengthValid = true;
        sellStrengthCacheBarTime = currentBarTime;
        sellStrengthCacheSymbol = g_activeSymbol;
    }

    return strength;
}

PositionHealth EvaluatePositionHealth(
    ENUM_POSITION_TYPE posType,
    double entryPrice,
    datetime posOpenTime,
    double emaFast,
    double emaSlow,
    double emaFastPrev,
    double rsi,
    double currentATR,
    const MqlRates &rates[],
    int ratesCount)
{
    PositionHealth health;
    health.healthScore = 0;
    health.trendValid = false;
    health.momentumValid = false;
    health.adverseATR = 0;
    health.swingValid = true;
    health.inGracePeriod = false;
    health.reason = "";

    bool isBuy = (posType == POSITION_TYPE_BUY);

    if(HealthGraceBars > 0 && posOpenTime > 0)
    {
        int barsElapsed = iBarShift(g_activeSymbol, g_activePeriod, posOpenTime, false);
        if(barsElapsed < HealthGraceBars)
        {
            health.healthScore = 1.0;
            health.trendValid = true;
            health.momentumValid = true;
            health.swingValid = true;
            health.inGracePeriod = true;
            health.reason = StringFormat("Grace period (%d/%d bars). ", barsElapsed, HealthGraceBars);
            return health;
        }
    }

    double trendScore = 0;
    if(isBuy)
        health.trendValid = (emaFast > emaSlow);
    else
        health.trendValid = (emaFast < emaSlow);

    if(health.trendValid)
    {
        double emaSeparation = MathAbs(emaFast - emaSlow);
        double separationScore = 1.0;
        if(currentATR > 0)
        {
            separationScore = MathMin(1.0, emaSeparation / (currentATR * 0.5));
        }

        double slopeFactor = 1.0;
        if(isBuy)
        {
            if(emaFast <= emaFastPrev) slopeFactor = 0.7;
        }
        else
        {
            if(emaFast >= emaFastPrev) slopeFactor = 0.7;
        }

        trendScore = separationScore * slopeFactor;

        if(slopeFactor < 1.0)
            health.reason += StringFormat("EMA slope weakening (sep=%.1f%% ATR). ",
                currentATR > 0 ? emaSeparation / currentATR * 100 : 0);
    }
    else
    {
        trendScore = 0;
        health.reason += "Trend crossed against position. ";
    }

    double rsiScore = 0;
    if(isBuy)
    {
        double rsiFloor = HealthRSIBuyMin - 15.0;
        if(rsi >= HealthRSIBuyMin)
        {
            rsiScore = 1.0;
            health.momentumValid = true;
        }
        else if(rsi > rsiFloor)
        {
            rsiScore = (rsi - rsiFloor) / (HealthRSIBuyMin - rsiFloor);
            health.momentumValid = false;
            health.reason += StringFormat("RSI weakening (RSI=%.1f, min=%.1f). ", rsi, HealthRSIBuyMin);
        }
        else
        {
            rsiScore = 0;
            health.momentumValid = false;
            health.reason += StringFormat("RSI regime shift (RSI=%.1f, min=%.1f). ", rsi, HealthRSIBuyMin);
        }
    }
    else
    {
        double rsiCeiling = HealthRSISellMax + 15.0;
        if(rsi <= HealthRSISellMax)
        {
            rsiScore = 1.0;
            health.momentumValid = true;
        }
        else if(rsi < rsiCeiling)
        {
            rsiScore = (rsiCeiling - rsi) / (rsiCeiling - HealthRSISellMax);
            health.momentumValid = false;
            health.reason += StringFormat("RSI weakening (RSI=%.1f, max=%.1f). ", rsi, HealthRSISellMax);
        }
        else
        {
            rsiScore = 0;
            health.momentumValid = false;
            health.reason += StringFormat("RSI regime shift (RSI=%.1f, max=%.1f). ", rsi, HealthRSISellMax);
        }
    }

    double currentPrice = isBuy ? SymbolInfoDouble(g_activeSymbol, SYMBOL_BID) : SymbolInfoDouble(g_activeSymbol, SYMBOL_ASK);
    double adverseMove = 0;

    if(isBuy)
        adverseMove = entryPrice - currentPrice;
    else
        adverseMove = currentPrice - entryPrice;

    double atrScore = 1.0;
    if(currentATR > 0 && adverseMove > 0)
    {
        health.adverseATR = adverseMove / currentATR;

        atrScore = MathMax(0.0, 1.0 - (health.adverseATR / MaxAdverseATR));

        if(health.adverseATR > MaxAdverseATR)
            health.reason += StringFormat("Adverse excursion %.1f ATR > Max %.1f ATR. ", health.adverseATR, MaxAdverseATR);
        else if(atrScore < 0.5)
            health.reason += StringFormat("Adverse excursion %.1f ATR (score=%.2f). ", health.adverseATR, atrScore);
    }

    double swingScore = 1.0;
    int swingLookback = MathMax(5, HealthSwingLookback);

    if(ratesCount >= swingLookback)
    {
        int startBar = MathMin(2, ratesCount - 1);

        if(isBuy)
        {
            double swingLow = rates[startBar].low;
            for(int j = startBar + 1; j < swingLookback && j < ratesCount; j++)
                swingLow = MathMin(swingLow, rates[j].low);

            if(currentPrice < swingLow)
            {
                swingScore = 0;
                health.swingValid = false;
                health.reason += StringFormat("Price %.5f broke swing low %.5f (%d bars). ", currentPrice, swingLow, swingLookback);
            }
        }
        else
        {
            double swingHigh = rates[startBar].high;
            for(int j = startBar + 1; j < swingLookback && j < ratesCount; j++)
                swingHigh = MathMax(swingHigh, rates[j].high);

            if(currentPrice > swingHigh)
            {
                swingScore = 0;
                health.swingValid = false;
                health.reason += StringFormat("Price %.5f broke swing high %.5f (%d bars). ", currentPrice, swingHigh, swingLookback);
            }
        }
    }

    health.healthScore = (trendScore  * normHealthTrendWeight)
                       + (rsiScore    * normHealthRSIWeight)
                       + (atrScore    * normHealthATRWeight)
                       + (swingScore  * normHealthSwingWeight);

    if(health.reason == "")  health.reason = "All health checks passed.";

    return health;
}

void ManageLosingPositions()
{
    if(!EnableLossManagement) return;

    double bufEMA_Fast[], bufEMA_Slow[], bufRSI[], bufATR[];
    ArraySetAsSeries(bufEMA_Fast, true);
    ArraySetAsSeries(bufEMA_Slow, true);
    ArraySetAsSeries(bufRSI, true);
    ArraySetAsSeries(bufATR, true);

    if(CopyBuffer(emaFastHandle, 0, 0, 3, bufEMA_Fast) < 3) return;
    if(CopyBuffer(emaSlowHandle, 0, 0, 3, bufEMA_Slow) < 3) return;
    if(CopyBuffer(rsiHandle, 0, 0, 3, bufRSI) < 3) return;
    if(CopyBuffer(atrSignalHandle, 0, 0, 3, bufATR) < 3) return;

    double blend = CurrentCandleBlend;
    if(blend < 0.0) blend = 0.0;
    if(blend > 1.0) blend = 1.0;

    double emaFast = bufEMA_Fast[1] * (1.0 - blend) + bufEMA_Fast[0] * blend;
    double emaSlow = bufEMA_Slow[1] * (1.0 - blend) + bufEMA_Slow[0] * blend;
    double emaFastPrev = bufEMA_Fast[2];
    double rsi = bufRSI[1] * (1.0 - blend) + bufRSI[0] * blend;
    double currentATR = bufATR[1];

    int swingBars = MathMax(5, HealthSwingLookback);
    MqlRates rates[];
    ArraySetAsSeries(rates, true);
    int ratesCopied = CopyRates(g_activeSymbol, g_activePeriod, 1, swingBars, rates);

    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0) continue;
        if(!PositionSelectByTicket(ticket)) continue;
        if(PositionGetInteger(POSITION_MAGIC) != ActiveMagicNumber()) continue;
        if(PositionGetString(POSITION_SYMBOL) != g_activeSymbol) continue;

        ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        datetime posOpenTime = (datetime)PositionGetInteger(POSITION_TIME);
        double volume = PositionGetDouble(POSITION_VOLUME);
        double profit = PositionGetDouble(POSITION_PROFIT);
        double currentSL = PositionGetDouble(POSITION_SL);
        double currentTP = PositionGetDouble(POSITION_TP);
        string positionSymbol = PositionGetString(POSITION_SYMBOL);

        int posIndex = GetManagedPositionIndex(ticket);
        if(posIndex == -1)
        {
            double posEntryPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            RegisterManagedPosition(ticket, posType, 0, posEntryPrice);
            continue;
        }

        if(EnableHedgeChain && managedPositions[posIndex].chainId != 0)
            continue;

        double entryPrice = managedPositions[posIndex].entryPrice;
        double initialScore = managedPositions[posIndex].signalScore;

        PositionHealth health = EvaluatePositionHealth(posType, entryPrice, posOpenTime,
                                                       emaFast, emaSlow, emaFastPrev, rsi, currentATR,
                                                       rates, ratesCopied);

        if(health.inGracePeriod) continue;

        if(EnableBreakEvenOnSpread && !managedPositions[posIndex].breakEvenLocked)
        {
            double spreadPoints = (double)SymbolInfoInteger(positionSymbol, SYMBOL_SPREAD) * ActivePoint();
            double spreadCost = spreadPoints * volume * SymbolInfoDouble(positionSymbol, SYMBOL_TRADE_CONTRACT_SIZE);
            double breakEvenTrigger = spreadCost * BreakEvenSpreadMultiplier;

            double positionRiskMoney = AimePositionRiskMoney(ticket);
            if(positionRiskMoney > 0.0 && positionRiskMoney < DBL_MAX / 2.0)
                breakEvenTrigger = MathMax(breakEvenTrigger, positionRiskMoney * BreakEvenTriggerRMultiple);

            if(profit > breakEvenTrigger)
            {
                double newBESL = NormalizeDouble(entryPrice, ActiveDigits());

                long stopLevel = SymbolInfoInteger(positionSymbol, SYMBOL_TRADE_STOPS_LEVEL);
                double minDist = stopLevel * ActivePoint();
                bool canLockBE = false;

                if(posType == POSITION_TYPE_BUY)
                {
                    double bid = SymbolInfoDouble(positionSymbol, SYMBOL_BID);
                    canLockBE = (newBESL < bid - minDist) && (currentSL == 0 || newBESL > currentSL);
                }
                else
                {
                    double ask = SymbolInfoDouble(positionSymbol, SYMBOL_ASK);
                    canLockBE = (newBESL > ask + minDist) && (currentSL == 0 || newBESL < currentSL);
                }

                if(canLockBE)
                {
                    if(ModifyPosition(ticket, newBESL, currentTP))
                    {
                        managedPositions[posIndex].breakEvenLocked = true;

                        LogPrint("+-----------------------------------------+");
                        LogPrint("[BREAK-EVEN LOCKED] Ticket: ", ticket);
                        LogPrint("Profit: $", DoubleToString(profit, 2), " > Trigger: $", DoubleToString(breakEvenTrigger, 2));
                        LogPrint("SL moved to entry: ", newBESL);
                        LogPrint("+-----------------------------------------+");
                    }
                }
            }
        }

        if(EnablePartialClose && initialScore > 0 && managedPositions[posIndex].partialCloseLevel < 3)
        {
            ENUM_ORDER_TYPE orderType = (posType == POSITION_TYPE_BUY) ? ORDER_TYPE_BUY : ORDER_TYPE_SELL;
            SignalStrength currentStrength = GetSignalStrength(orderType);
            double currentScore = currentStrength.finalScore;
            double signalRatio = currentScore / initialScore;

            if(!PositionSelectByTicket(ticket)) continue;
            volume = PositionGetDouble(POSITION_VOLUME);

            double minVol = SymbolInfoDouble(positionSymbol, SYMBOL_VOLUME_MIN);
            double stepVol = SymbolInfoDouble(positionSymbol, SYMBOL_VOLUME_STEP);

            if(managedPositions[posIndex].partialCloseLevel == 0 && signalRatio <= 0.75)
            {
                double closeVol = NormalizeVolume(volume * PartialClose75Pct);
                double remaining = volume - closeVol;

                if(closeVol >= minVol && remaining >= minVol)
                {
                    if(PartialClosePosition(ticket, closeVol))
                    {
                        managedPositions[posIndex].partialCloseLevel = 1;
                        LogPrint("+-----------------------------------------+");
                        LogPrint("[PARTIAL CLOSE L1] Ticket: ", ticket);
                        LogPrint("Signal: ", DoubleToString(currentScore, 1), " / ", DoubleToString(initialScore, 1), " (", DoubleToString(signalRatio * 100, 0), "%)");
                        LogPrint("Closed: ", closeVol, " lots | Remaining: ", remaining, " lots");
                        LogPrint("+-----------------------------------------+");
                    }
                }
            }

            else if(managedPositions[posIndex].partialCloseLevel == 1 && signalRatio <= 0.50)
            {
                if(!PositionSelectByTicket(ticket)) continue;
                volume = PositionGetDouble(POSITION_VOLUME);

                double closeVol = NormalizeVolume(volume * PartialClose50Pct);
                double remaining = volume - closeVol;

                if(closeVol >= minVol && remaining >= minVol)
                {
                    if(PartialClosePosition(ticket, closeVol))
                    {
                        managedPositions[posIndex].partialCloseLevel = 2;
                        LogPrint("+-----------------------------------------+");
                        LogPrint("[PARTIAL CLOSE L2] Ticket: ", ticket);
                        LogPrint("Signal: ", DoubleToString(currentScore, 1), " / ",
                                 DoubleToString(initialScore, 1), " (", DoubleToString(signalRatio * 100, 0), "%)");
                        LogPrint("Closed: ", closeVol, " lots | Remaining: ", remaining, " lots");
                        LogPrint("+-----------------------------------------+");
                    }
                }
            }

            else if(managedPositions[posIndex].partialCloseLevel == 2 && signalRatio <= 0.25)
            {
                LogPrint("+-----------------------------------------+");
                LogPrint("[PARTIAL CLOSE L3 - FULL EXIT] Ticket: ", ticket);
                LogPrint("Signal: ", DoubleToString(currentScore, 1), " / ",
                         DoubleToString(initialScore, 1), " (", DoubleToString(signalRatio * 100, 0), "%)");
                LogPrint("+-----------------------------------------+");

                managedPositions[posIndex].partialCloseLevel = 3;
                ClosePosition(ticket);

                if(EnableVirtualSLReentry)
                {
                    TryVirtualSLReentry(posType, initialScore);
                }
                continue;
            }
        }

        if(EnableHealthSLTightening && health.healthScore < SLTightenMinHealthPct && currentATR > 0)
        {
            double healthRatio = health.healthScore / SLTightenMinHealthPct;
            if(healthRatio < 0.1) healthRatio = 0.1;

            double slDistance = currentATR * SLTightenATRMultiplier * healthRatio;
            double newTightenedSL = 0;

            if(!PositionSelectByTicket(ticket)) continue;
            currentSL = PositionGetDouble(POSITION_SL);
            currentTP = PositionGetDouble(POSITION_TP);

            long stopLevel = SymbolInfoInteger(positionSymbol, SYMBOL_TRADE_STOPS_LEVEL);
            double minDist = stopLevel * ActivePoint();

            if(posType == POSITION_TYPE_BUY)
            {
                double bid = SymbolInfoDouble(positionSymbol, SYMBOL_BID);
                newTightenedSL = NormalizeDouble(bid - slDistance, ActiveDigits());

                if(managedPositions[posIndex].breakEvenLocked && newTightenedSL < entryPrice)
                    newTightenedSL = NormalizeDouble(entryPrice, ActiveDigits());

                if(currentSL > 0 && newTightenedSL <= currentSL) continue;

                if(newTightenedSL >= bid - minDist) continue;
            }
            else
            {
                double ask = SymbolInfoDouble(positionSymbol, SYMBOL_ASK);
                newTightenedSL = NormalizeDouble(ask + slDistance, ActiveDigits());

                if(managedPositions[posIndex].breakEvenLocked && newTightenedSL > entryPrice)
                    newTightenedSL = NormalizeDouble(entryPrice, ActiveDigits());

                if(currentSL > 0 && newTightenedSL >= currentSL) continue;

                if(newTightenedSL <= ask + minDist) continue;
            }

            if(IsSLValidForSymbol(positionSymbol, posType, newTightenedSL))
            {
                if(ModifyPosition(ticket, newTightenedSL, currentTP))
                {
                    LogPrint("+-----------------------------------------+");
                    LogPrint("[SL TIGHTENED] Ticket: ", ticket);
                    LogPrint("Health: ", DoubleToString(health.healthScore, 2),
                             " (ratio: ", DoubleToString(healthRatio, 2), ")");
                    LogPrint("SL: ", currentSL, " -> ", newTightenedSL,
                             " (ATR dist: ", DoubleToString(slDistance / ActivePoint(), 0), " pts)");
                    LogPrint("+-----------------------------------------+");
                }
            }
        }

        if(EnableProfitOffsetSL && profit < 0
           && managedPositions[posIndex].profitOffsetConsecWins >= ConsecutiveWinsRequired
           && managedPositions[posIndex].profitOffsetAccumulated >= MinOffsetProfit)
        {
            double origSL = managedPositions[posIndex].profitOffsetOriginalSL;

            if(origSL > 0 && entryPrice > 0)
            {
                double tickValue = SymbolInfoDouble(g_activeSymbol, SYMBOL_TRADE_TICK_VALUE);
                double tickSize = SymbolInfoDouble(g_activeSymbol, SYMBOL_TRADE_TICK_SIZE);
                double point = SymbolInfoDouble(g_activeSymbol, SYMBOL_POINT);

                if(tickValue > 0 && tickSize > 0 && point > 0 && volume > 0)
                {
                    double normalizedTickValue = tickValue * volume;
                    double pointsPerTick = tickSize / point;
                    double valuePerPoint = normalizedTickValue / pointsPerTick;

                    double origSLDistPoints = MathAbs(entryPrice - origSL) / ActivePoint();
                    double origRiskUSD = origSLDistPoints * valuePerPoint;

                    double accumulatedProfit = managedPositions[posIndex].profitOffsetAccumulated;
                    double newTargetRiskUSD = origRiskUSD - accumulatedProfit;

                    if(newTargetRiskUSD < origRiskUSD && newTargetRiskUSD > 0)
                    {
                        double newSLDistPoints = newTargetRiskUSD / valuePerPoint;
                        double newSLDistPrice = newSLDistPoints * ActivePoint();

                        double newOffsetSL = 0;

                        if(!PositionSelectByTicket(ticket)) continue;
                        currentSL = PositionGetDouble(POSITION_SL);
                        currentTP = PositionGetDouble(POSITION_TP);

                        long offsetStopLevel = SymbolInfoInteger(positionSymbol, SYMBOL_TRADE_STOPS_LEVEL);
                        double offsetMinDist = offsetStopLevel * ActivePoint();

                        if(posType == POSITION_TYPE_BUY)
                        {
                            double bid = SymbolInfoDouble(positionSymbol, SYMBOL_BID);
                            newOffsetSL = NormalizeDouble(entryPrice - newSLDistPrice, ActiveDigits());

                            if(managedPositions[posIndex].breakEvenLocked && newOffsetSL < entryPrice)
                                newOffsetSL = NormalizeDouble(entryPrice, ActiveDigits());

                            if(currentSL > 0 && newOffsetSL <= currentSL)
                            {
                            }
                            else if(newOffsetSL >= bid - offsetMinDist)
                            {
                            }
                            else if(IsSLValid(posType, newOffsetSL))
                            {
                                if(ModifyPosition(ticket, newOffsetSL, currentTP))
                                {
                                    LogPrint("+-----------------------------------------+");
                                    LogPrint("[PROFIT OFFSET SL] Ticket: ", ticket);
                                    LogPrint("Consecutive Wins: ", managedPositions[posIndex].profitOffsetConsecWins,
                                             " | Accumulated: $", DoubleToString(accumulatedProfit, 2));
                                    LogPrint("Original Risk: $", DoubleToString(origRiskUSD, 2),
                                             " -> New Max Risk: $", DoubleToString(newTargetRiskUSD, 2));
                                    LogPrint("SL: ", currentSL, " -> ", newOffsetSL);
                                    LogPrint("+-----------------------------------------+");
                                }
                            }
                        }
                        else
                        {
                            double ask = SymbolInfoDouble(positionSymbol, SYMBOL_ASK);
                            newOffsetSL = NormalizeDouble(entryPrice + newSLDistPrice, ActiveDigits());

                            if(managedPositions[posIndex].breakEvenLocked && newOffsetSL > entryPrice)
                                newOffsetSL = NormalizeDouble(entryPrice, ActiveDigits());

                            if(currentSL > 0 && newOffsetSL >= currentSL)
                            {
                            }
                            else if(newOffsetSL <= ask + offsetMinDist)
                            {
                            }
                            else if(IsSLValid(posType, newOffsetSL))
                            {
                                if(ModifyPosition(ticket, newOffsetSL, currentTP))
                                {
                                    LogPrint("+-----------------------------------------+");
                                    LogPrint("[PROFIT OFFSET SL] Ticket: ", ticket);
                                    LogPrint("Consecutive Wins: ", managedPositions[posIndex].profitOffsetConsecWins,
                                             " | Accumulated: $", DoubleToString(accumulatedProfit, 2));
                                    LogPrint("Original Risk: $", DoubleToString(origRiskUSD, 2),
                                             " -> New Max Risk: $", DoubleToString(newTargetRiskUSD, 2));
                                    LogPrint("SL: ", currentSL, " -> ", newOffsetSL);
                                    LogPrint("+-----------------------------------------+");
                                }
                            }
                        }
                    }

                    else if(newTargetRiskUSD <= 0)
                    {
                        if(!PositionSelectByTicket(ticket)) continue;
                        currentSL = PositionGetDouble(POSITION_SL);
                        currentTP = PositionGetDouble(POSITION_TP);

                        double beSL = NormalizeDouble(entryPrice, ActiveDigits());
                        long beStopLevel = SymbolInfoInteger(positionSymbol, SYMBOL_TRADE_STOPS_LEVEL);
                        double beMinDist = beStopLevel * ActivePoint();
                        bool canApplyBE = false;

                        if(posType == POSITION_TYPE_BUY)
                        {
                            double bid = SymbolInfoDouble(positionSymbol, SYMBOL_BID);
                            canApplyBE = (beSL < bid - beMinDist) && (currentSL == 0 || beSL > currentSL);
                        }
                        else
                        {
                            double ask = SymbolInfoDouble(positionSymbol, SYMBOL_ASK);
                            canApplyBE = (beSL > ask + beMinDist) && (currentSL == 0 || beSL < currentSL);
                        }

                        if(canApplyBE && IsSLValidForSymbol(positionSymbol, posType, beSL))
                        {
                            if(ModifyPosition(ticket, beSL, currentTP))
                            {
                                managedPositions[posIndex].breakEvenLocked = true;

                                LogPrint("+-----------------------------------------+");
                                LogPrint("[PROFIT OFFSET SL -> BE] Ticket: ", ticket);
                                LogPrint("Accumulated profit ($", DoubleToString(accumulatedProfit, 2),
                                         ") >= Original risk ($", DoubleToString(origRiskUSD, 2), ")");
                                LogPrint("SL moved to break-even: ", beSL);
                                LogPrint("+-----------------------------------------+");
                            }
                        }
                    }
                }
            }
        }

        if(health.healthScore < MinHealthScore)
        {
            LogPrint("+-----------------------------------------+");
            LogPrint("POSITION EXIT TRIGGERED (Health Decay)");
            LogPrint("Ticket: ", ticket, " | Profit: $", DoubleToString(PositionGetDouble(POSITION_PROFIT), 2));
            LogPrint("Health: ", DoubleToString(health.healthScore, 2), " / ", DoubleToString(MinHealthScore, 2));
            LogPrint("Trend: ", health.trendValid ? "OK" : "FAIL",
                     " | RSI: ", health.momentumValid ? "OK" : "FAIL",
                     " | ATR: ", DoubleToString(health.adverseATR, 1), "x",
                     " | Swing: ", health.swingValid ? "OK" : "FAIL");
            LogPrint("Reason: ", health.reason);
            LogPrint("+-----------------------------------------+");

            ClosePosition(ticket);

            if(EnableVirtualSLReentry)
            {
                TryVirtualSLReentry(posType, initialScore);
            }
        }
    }
}

bool PartialClosePosition(ulong ticket, double closeVolume)
{
    if(!PositionSelectByTicket(ticket))
    {
        LogPrint("PartialClose: Position ", ticket, " not found");
        return false;
    }

    string symbol = PositionGetString(POSITION_SYMBOL);
    ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
    long magic = (long)PositionGetInteger(POSITION_MAGIC);
    double volume = PositionGetDouble(POSITION_VOLUME);

    if(!SymbolSelect(symbol, true)) return false;

    double minVol = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
    double stepVol = SymbolInfoDouble(symbol, SYMBOL_VOLUME_STEP);
    if(stepVol <= 0.0) return false;

    double closeVol = MathFloor(closeVolume / stepVol + 1e-9) * stepVol;
    if(closeVol > volume) closeVol = volume;
    closeVol = MathFloor(closeVol / stepVol + 1e-9) * stepVol;
    if(closeVol <= 0.0) return false;

    LockOrderSend(true);
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    request.action = TRADE_ACTION_DEAL;
    request.position = ticket;
    request.symbol = symbol;
    request.volume = closeVol;
    request.deviation = 10;
    request.magic = magic;
    request.type_filling = GetFillingModeForSymbol(symbol);
    request.type = (type == POSITION_TYPE_BUY) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
    request.price = (type == POSITION_TYPE_BUY) ? SymbolInfoDouble(symbol, SYMBOL_BID) : SymbolInfoDouble(symbol, SYMBOL_ASK);

    ResetLastError();
    bool sent = AimeOrderSendWithRetry(request, result, 3);
    bool success = sent && (result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_DONE_PARTIAL);

    LogPrint("[PARTIAL CLOSE] ticket=", ticket, " symbol=", symbol,
             " volume=", DoubleToString(closeVol, 2),
             " retcode=", result.retcode, " comment=", result.comment);
    LockOrderSend(false);
    return success;
}

void TryVirtualSLReentry(ENUM_POSITION_TYPE posType, double initialScore)
{
    if(initialScore <= 0) return;

    if(EnableNewBarEntryOnly && ReentryRespectsNewBarGate)
    {
        datetime reentryBarTime = iTime(g_activeSymbol, g_activePeriod, 0);
        if(lastEntryBarTime == reentryBarTime) return;
    }

    if(targetEquityReached || minimumEquityReached || minEquityTriggersExceeded) return;
    if(isPaused || isOutsideTradingHours || isLeverageDiffFromInitial) return;
    if(isNearMarketClose) return;
    if(isOrderSendLocked) return;
    string reentryLossReason = AimeLossLimitReason();
    if(reentryLossReason != "")
    {
        LogPrint("[VIRTUAL SL RE-ENTRY] BLOCKED: ", reentryLossReason);
        return;
    }
    if(CountOpenOrders() >= MaxOpenOrders) return;

    ENUM_ORDER_TYPE orderType = (posType == POSITION_TYPE_BUY) ? ORDER_TYPE_BUY : ORDER_TYPE_SELL;
    SignalStrength strength = GetSignalStrength(orderType);

    double minReentryScore = initialScore * ReentryMinSignalPct;

    if(strength.finalScore >= minReentryScore)
    {
        if(posType == POSITION_TYPE_BUY && !EnableBuyOrders) return;
        if(posType == POSITION_TYPE_SELL && !EnableSellOrders) return;

        LogPrint("+-----------------------------------------+");
        LogPrint("[VIRTUAL SL RE-ENTRY] Re-entering ", posType == POSITION_TYPE_BUY ? "BUY" : "SELL");
        LogPrint("New Signal: ", DoubleToString(strength.finalScore, 1),
                 " >= Min: ", DoubleToString(minReentryScore, 1),
                 " (", DoubleToString(ReentryMinSignalPct * 100, 0), "% of ",
                 DoubleToString(initialScore, 1), ")");
        LogPrint("+-----------------------------------------+");

        OpenPosition(orderType, strength.finalScore);

        if(EnableNewBarEntryOnly && ReentryRespectsNewBarGate)
            lastEntryBarTime = iTime(g_activeSymbol, g_activePeriod, 0);
    }
    else
    {
        LogPrint("[VIRTUAL SL] No re-entry. Signal: ", DoubleToString(strength.finalScore, 1), " < Required: ", DoubleToString(minReentryScore, 1));
    }
}

int CountLosingPositionsForSymbol(string symbol, long magic)
{
    int count = 0;
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
        if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
        if((long)PositionGetInteger(POSITION_MAGIC) != magic) continue;
        if(PositionGetDouble(POSITION_PROFIT) < 0.0)
            count++;
    }
    return count;
}

string AimeLossLimitReason()
{
    long magic = ActiveMagicNumber();
    int losing = CountLosingPositionsForSymbol(g_activeSymbol, magic);
    if(MaxHoldingLossPositions <= 0 || losing < MaxHoldingLossPositions)
        return "";
    return StringFormat("SYMBOL LOSS LIMIT | %s | LOSING %d/%d", g_activeSymbol, losing, MaxHoldingLossPositions);
}

int CountLosingPositions()
{
    return CountLosingPositionsForSymbol(g_activeSymbol, ActiveMagicNumber());
}

double SymbolPointFor(const string symbol)
{
    double p = SymbolInfoDouble(symbol, SYMBOL_POINT);
    return p > 0 ? p : _Point;
}

int SymbolDigitsFor(const string symbol)
{
    long d = SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    if(d < 0) d = _Digits;
    return (int)d;
}

void ManageTrailingTPSL(ulong ticket)
{
    if (!EnableTrailing) return;

    if(!PositionSelectByTicket(ticket)) return;

    ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
    string positionSymbol = PositionGetString(POSITION_SYMBOL);
    if(positionSymbol == "") return;
    if(!SymbolSelect(positionSymbol, true)) return;

    if(EnableHedgeChain)
    {
        int hpi = GetManagedPositionIndex(ticket);
        if(hpi != -1 && managedPositions[hpi].chainId != 0)
            return;
    }

    double currentSL = PositionGetDouble(POSITION_SL);
    double currentTP = PositionGetDouble(POSITION_TP);
    double entryPrice = PositionGetDouble(POSITION_PRICE_OPEN);
    double currentPrice = (posType == POSITION_TYPE_BUY) ? SymbolInfoDouble(positionSymbol, SYMBOL_BID) : SymbolInfoDouble(positionSymbol, SYMBOL_ASK);
    double profit = PositionGetDouble(POSITION_PROFIT);
    double volume = PositionGetDouble(POSITION_VOLUME);

    ENUM_ORDER_TYPE orderType = (posType == POSITION_TYPE_BUY) ? ORDER_TYPE_BUY : ORDER_TYPE_SELL;
    SignalStrength currentStrength = GetSignalStrength(orderType);
    double currentScore = currentStrength.finalScore;

    double initialScore = 0;
    int posIndex = GetManagedPositionIndex(ticket);
    if(posIndex != -1)
    {
        initialScore = managedPositions[posIndex].signalScore;
    }

    double tpAdjustment = 0;
    double slAdjustment = 0;
    string adaptiveReason = "Normal";

    double scoreDelta = currentScore - initialScore;

    if(initialScore > 0)
    {
        if(EnableAdaptiveTP)
        {
             tpAdjustment = scoreDelta * TrailingValueMultiplier;
        }

        if(EnableAdaptiveSL)
        {
             slAdjustment = scoreDelta * TrailingValueMultiplier;
        }

        if(MathAbs(scoreDelta) > 0)
        {
            adaptiveReason = "Adaptive (Delta: " + DoubleToString(scoreDelta, 1) + ")";
        }
    }

    double newTP = currentTP;

    if(EnableTakeProfit && !EnableRiskReward)
    {
        double effectiveTP = TPValue + tpAdjustment;

        if(effectiveTP < (TrailingValueMultiplier * 0.1)) effectiveTP = TrailingValueMultiplier * 0.1;

        double tpPoints = ConvertToPoints(TPInputType, effectiveTP, volume);
        double targetTP = 0;

        if(posType == POSITION_TYPE_BUY) targetTP = NormalizeDouble(entryPrice + tpPoints * SymbolPointFor(positionSymbol), SymbolDigitsFor(positionSymbol));
        else targetTP = NormalizeDouble(entryPrice - tpPoints * SymbolPointFor(positionSymbol), SymbolDigitsFor(positionSymbol));

        if(MathAbs(targetTP - currentTP) > SymbolPointFor(positionSymbol))
        {
            newTP = targetTP;
        }
    }

    double newSL = currentSL;
    bool shouldModifySL = false;

    double initialRiskPrice = MathAbs(entryPrice-currentSL);
    if(initialRiskPrice <= SymbolPointFor(positionSymbol))
    {
        double atrInit[];
        ArraySetAsSeries(atrInit,true);
        if(CopyBuffer(atrSignalHandle,0,1,1,atrInit) >= 1 && atrInit[0] > 0.0)
            initialRiskPrice = atrInit[0] * StructureSLATRMultiplier;
    }

    double favorableDistance = posType == POSITION_TYPE_BUY ? currentPrice-entryPrice : entryPrice-currentPrice;
    double rMultiple = initialRiskPrice > 0.0 ? favorableDistance/initialRiskPrice : 0.0;

    if(rMultiple >= ProfitLockTriggerR && EnableProfitLock)
    {
        double atrLock[];
        ArraySetAsSeries(atrLock,true);
        double atrValue=0.0;
        if(CopyBuffer(atrSignalHandle,0,1,1,atrLock) >= 1) atrValue=atrLock[0];
        double lockDistance=atrValue>0.0 ? atrValue*ProfitLockATRBuffer : 0.0;
        double lockPrice=posType==POSITION_TYPE_BUY ? entryPrice+lockDistance : entryPrice-lockDistance;
        long stopLevelLock=SymbolInfoInteger(positionSymbol,SYMBOL_TRADE_STOPS_LEVEL);
        long freezeLevelLock=SymbolInfoInteger(positionSymbol,SYMBOL_TRADE_FREEZE_LEVEL);
        double minDistanceLock=MathMax(stopLevelLock,freezeLevelLock)*SymbolPointFor(positionSymbol);
        if(posType==POSITION_TYPE_BUY)
        {
            double maxSL=SymbolInfoDouble(positionSymbol,SYMBOL_BID)-minDistanceLock;
            lockPrice=MathMin(lockPrice,maxSL);
            if(lockPrice>0.0 && (currentSL==0.0 || lockPrice>currentSL))
            {
                newSL=lockPrice;
                shouldModifySL=true;
            }
        }
        else
        {
            double minSL=SymbolInfoDouble(positionSymbol,SYMBOL_ASK)+minDistanceLock;
            lockPrice=MathMax(lockPrice,minSL);
            if(lockPrice>0.0 && (currentSL==0.0 || lockPrice<currentSL))
            {
                newSL=lockPrice;
                shouldModifySL=true;
            }
        }
    }

    if(EnableATRProfitTrail && rMultiple >= ATRProfitTrailStartR)
    {
        double atrTrail[];
        ArraySetAsSeries(atrTrail,true);
        double atrValue=0.0;
        if(CopyBuffer(atrSignalHandle,0,1,1,atrTrail) >= 1) atrValue=atrTrail[0];
        if(atrValue>0.0)
        {
            double trailDistance=atrValue*ATRProfitTrailMultiplier;
            long stopLevelATR=SymbolInfoInteger(positionSymbol,SYMBOL_TRADE_STOPS_LEVEL);
            long freezeLevelATR=SymbolInfoInteger(positionSymbol,SYMBOL_TRADE_FREEZE_LEVEL);
            double minDistanceATR=MathMax(stopLevelATR,freezeLevelATR)*SymbolPointFor(positionSymbol);
            if(posType==POSITION_TYPE_BUY)
            {
                double candidate=currentPrice-trailDistance;
                double maxAllowed=SymbolInfoDouble(positionSymbol,SYMBOL_BID)-minDistanceATR;
                candidate=MathMin(candidate,maxAllowed);
                if(candidate>0.0 && (currentSL==0.0 || candidate>newSL))
                {
                    newSL=candidate;
                    shouldModifySL=true;
                }
            }
            else
            {
                double candidate=currentPrice+trailDistance;
                double minAllowed=SymbolInfoDouble(positionSymbol,SYMBOL_ASK)+minDistanceATR;
                candidate=MathMax(candidate,minAllowed);
                if(candidate>0.0 && (currentSL==0.0 || candidate<newSL))
                {
                    newSL=candidate;
                    shouldModifySL=true;
                }
            }
        }
    }

    double profitThreshold = MinBreakEvenProfit * ProfitThresholdMultiplier;
    bool canTrail = (MinBreakEvenProfit <= 0 || !TrailingSLOnProfitableOnly || profit >= profitThreshold);

    if(canTrail)
    {
        double effectiveDist = TrailingDistanceValue + slAdjustment;

        if(effectiveDist < (TrailingValueMultiplier * 0.1)) effectiveDist = TrailingValueMultiplier * 0.1;

        double finalTrailingPoints;
        double trailingDistancePrice;
        bool useHedgeTrail = (posIndex != -1 && managedPositions[posIndex].hedgeGraduated && HedgeTrailATR > 0);
        double hedgeAtr = 0;
        if(useHedgeTrail)
        {
            double _bufATR[];
            ArraySetAsSeries(_bufATR, true);
            if(CopyBuffer(atrSignalHandle, 0, 0, 2, _bufATR) >= 2) hedgeAtr = _bufATR[1];
        }

        if(useHedgeTrail && hedgeAtr > 0)
        {
            trailingDistancePrice = HedgeTrailATR * hedgeAtr;
            finalTrailingPoints   = trailingDistancePrice / SymbolPointFor(positionSymbol);
        }
        else
        {
            finalTrailingPoints   = ConvertToPoints(TSInputType, effectiveDist, volume);
            trailingDistancePrice = finalTrailingPoints * SymbolPointFor(positionSymbol);
        }

        long stopLevel = SymbolInfoInteger(positionSymbol, SYMBOL_TRADE_STOPS_LEVEL);
        long freezeLevel = SymbolInfoInteger(positionSymbol, SYMBOL_TRADE_FREEZE_LEVEL);

        double minStopDistance = stopLevel * SymbolPointFor(positionSymbol);
        double minFreezeDistance = freezeLevel * SymbolPointFor(positionSymbol);
        double minDistance = MathMax(minStopDistance, minFreezeDistance);

        double breakEvenPrice = CalculateBreakEvenPrice(ticket, posType, entryPrice, volume);

        double calculatedSL = 0;

        if(posType == POSITION_TYPE_BUY)
        {
            double profitPoints = (currentPrice - entryPrice) / SymbolPointFor(positionSymbol);
            if(profitPoints >= finalTrailingPoints)
            {
                calculatedSL = currentPrice - trailingDistancePrice;
                double maxAllowedSL = SymbolInfoDouble(positionSymbol, SYMBOL_BID) - minDistance;

                if(calculatedSL > maxAllowedSL) calculatedSL = maxAllowedSL;

                if(TrailingEnableBreakEvenLock && calculatedSL < breakEvenPrice) calculatedSL = breakEvenPrice;

                if(currentSL == 0 || calculatedSL > currentSL)
                {
                    if(calculatedSL < SymbolInfoDouble(positionSymbol, SYMBOL_BID))
                    {
                        newSL = calculatedSL;
                        shouldModifySL = true;
                    }
                }
            }
        }

        else
        {
            double profitPoints = (entryPrice - currentPrice) / SymbolPointFor(positionSymbol);
            if(profitPoints >= finalTrailingPoints)
            {
                calculatedSL = currentPrice + trailingDistancePrice;
                double minAllowedSL = SymbolInfoDouble(positionSymbol, SYMBOL_ASK) + minDistance;

                if(calculatedSL < minAllowedSL) calculatedSL = minAllowedSL;

                if(TrailingEnableBreakEvenLock && calculatedSL > breakEvenPrice) calculatedSL = breakEvenPrice;

                if(currentSL == 0 || calculatedSL < currentSL)
                {
                    if(calculatedSL > SymbolInfoDouble(positionSymbol, SYMBOL_ASK))
                    {
                        newSL = calculatedSL;
                        shouldModifySL = true;
                    }
                }
            }
        }
    }

    if(posIndex != -1 && managedPositions[posIndex].hedgeLockProfit > 0)
    {
        double lockProfit = managedPositions[posIndex].hedgeLockProfit;
        double tv = SymbolInfoDouble(g_activeSymbol, SYMBOL_TRADE_TICK_VALUE);
        double ts = SymbolInfoDouble(g_activeSymbol, SYMBOL_TRADE_TICK_SIZE);
        if(tv > 0 && ts > 0 && volume > 0)
        {
            double lockDist = (lockProfit / volume) * (ts / tv);
            double bidNow = SymbolInfoDouble(positionSymbol, SYMBOL_BID);
            double askNow = SymbolInfoDouble(positionSymbol, SYMBOL_ASK);
            double baseSL = shouldModifySL ? newSL : currentSL;

            if(posType == POSITION_TYPE_BUY)
            {
                double lockPrice = NormalizeDouble(entryPrice + lockDist, SymbolDigitsFor(positionSymbol));

                if(lockPrice > baseSL && lockPrice < bidNow)
                {
                    newSL = lockPrice;
                    shouldModifySL = true;
                }
            }
            else
            {
                double lockPrice = NormalizeDouble(entryPrice - lockDist, SymbolDigitsFor(positionSymbol));

                if((baseSL == 0 || lockPrice < baseSL) && lockPrice > askNow)
                {
                    newSL = lockPrice;
                    shouldModifySL = true;
                }
            }
        }
    }

    if(!shouldModifySL && MathAbs(newTP - currentTP) < SymbolPointFor(positionSymbol)) return;

    newSL = NormalizeDouble(newSL, SymbolDigitsFor(positionSymbol));
    newTP = NormalizeDouble(newTP, SymbolDigitsFor(positionSymbol));

    if(shouldModifySL && MathAbs(newSL - currentSL) < SymbolPointFor(positionSymbol) && MathAbs(newTP - currentTP) < SymbolPointFor(positionSymbol)) return;

    if(shouldModifySL && !IsSLValid(posType, newSL))
    {
        LogPrint("SL invalid, skipping. Ticket: ", ticket);
        return;
    }

    LogPrint("+-----------------------------------------+");
    LogPrint("POSITION UPDATE (", adaptiveReason, ")");
    LogPrint("Ticket: ", ticket, " | Profit: $", profit);
    LogPrint("Signal: Init=", initialScore, " -> Current=", currentScore, " (Delta: ", scoreDelta, ")");
    if(shouldModifySL) LogPrint("SL: ", currentSL, " -> ", newSL, " (Dist: ", (TrailingDistanceValue + slAdjustment), ")");
    if(MathAbs(newTP - currentTP) > SymbolPointFor(positionSymbol)) LogPrint("TP: ", currentTP, " -> ", newTP, " (Base+Adj: ", (TPValue + tpAdjustment), ")");
    LogPrint("+-----------------------------------------+");

    if(!ModifyPosition(ticket, newSL, newTP))
    {
        LogPrint("Modify failed. Ticket: ", ticket);

        double minSubstantialProfit = MinBreakEvenProfit * 3.0;

        if(MinBreakEvenProfit > 0 && profit >= minSubstantialProfit)
        {
            LogPrint("!! EMERGENCY CLOSE TRIGGERED !!");
            ClosePosition(ticket);
        }
    }
}

void RegisterManagedPosition(ulong ticket, ENUM_POSITION_TYPE type, double signalScore, double entryPrice = 0, ulong chainId = 0, int hedgeLevel = 0, double chainAnchorLoss = 0, int cycleNum = 0)
{
    ArrayResize(managedPositions, managedPositionCount + 1);

    managedPositions[managedPositionCount].ticket = ticket;
    managedPositions[managedPositionCount].type = type;
    managedPositions[managedPositionCount].signalScore = signalScore;
    managedPositions[managedPositionCount].entryPrice = entryPrice;
    managedPositions[managedPositionCount].partialCloseLevel = 0;
    managedPositions[managedPositionCount].breakEvenLocked = false;

    managedPositions[managedPositionCount].profitOffsetConsecWins = 0;
    managedPositions[managedPositionCount].profitOffsetAccumulated = 0;

    managedPositions[managedPositionCount].chainId = chainId;
    managedPositions[managedPositionCount].hedgeLevel = hedgeLevel;
    managedPositions[managedPositionCount].chainAnchorLoss = chainAnchorLoss;
    managedPositions[managedPositionCount].cycleNum = cycleNum;
    managedPositions[managedPositionCount].noRehedge = false;
    managedPositions[managedPositionCount].hedgeGraduated = false;
    managedPositions[managedPositionCount].hedgeLockProfit = 0;

    double origSL = 0;
    if(PositionSelectByTicket(ticket)) origSL = PositionGetDouble(POSITION_SL);
    managedPositions[managedPositionCount].profitOffsetOriginalSL = origSL;

    managedPositionCount++;

    LogPrint("Registered position. Ticket: ", ticket,
             " | Type: ", EnumToString(type),
             " | Score: ", signalScore,
             " | Entry: ", entryPrice,
             " | Managed Positions: ", managedPositionCount);
}

void RemoveManagedPosition(ulong ticket)
{
    for(int i = 0; i < managedPositionCount; i++)
    {
        if(managedPositions[i].ticket == ticket)
        {
            for(int j = i; j < managedPositionCount - 1; j++)
            {
                managedPositions[j] = managedPositions[j + 1];
            }

            managedPositionCount--;
            ArrayResize(managedPositions, managedPositionCount);

            LogPrint("Removed position: ", ticket,
                     " | Remaining Managed Positions: ", managedPositionCount);
            break;
        }
    }
}

void SyncManagedPositions()
{
    for(int i = managedPositionCount - 1; i >= 0; i--)
    {
        if(!PositionSelectByTicket(managedPositions[i].ticket))
        {
            ulong closedTicket = managedPositions[i].ticket;

            double closedProfit = 0;
            bool foundDeal = false;

            datetime fromTime = TimeCurrent() - 86400;
            datetime toTime = TimeCurrent();

            if(HistorySelect(fromTime, toTime))
            {
                int totalDeals = HistoryDealsTotal();
                for(int d = totalDeals - 1; d >= 0; d--)
                {
                    ulong dealTicket = HistoryDealGetTicket(d);
                    if(dealTicket == 0) continue;

                    ulong dealPosition = HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);
                    long dealEntry = HistoryDealGetInteger(dealTicket, DEAL_ENTRY);
                    long dealMagic = HistoryDealGetInteger(dealTicket, DEAL_MAGIC);

                    if(dealPosition == closedTicket && dealEntry == DEAL_ENTRY_OUT && dealMagic == ActiveMagicNumber())
                    {
                        closedProfit = HistoryDealGetDouble(dealTicket, DEAL_PROFIT)
                                     + HistoryDealGetDouble(dealTicket, DEAL_SWAP)
                                     + HistoryDealGetDouble(dealTicket, DEAL_COMMISSION);
                        foundDeal = true;
                        break;
                    }
                }
            }

            if(foundDeal)
                ProcessClosedPosition(closedTicket, closedProfit);
            else
                RemoveManagedPosition(closedTicket);
        }
    }
}

void ProcessClosedPosition(ulong closedTicket, double closedProfit)
{
    if(GetManagedPositionIndex(closedTicket) == -1) return;

    if(EnableSignalDampening)
    {
        if(closedProfit < 0)
        {
            consecutiveLossCount++;
            LogPrint("[LOSS TRACKER] Position ", closedTicket, " closed at loss: $",
                     DoubleToString(closedProfit, 2),
                     ". Consecutive losses: ", consecutiveLossCount);

            if(ConsecutiveLossesBeforeCooldown > 0 && consecutiveLossCount >= ConsecutiveLossesBeforeCooldown)
            {
                datetime currBar = iTime(g_activeSymbol, g_activePeriod, 0);
                cooldownUntilBarTime = currBar + ConsecutiveLossCooldownBars * PeriodSeconds(g_activePeriod);
                LogPrint("[COOLDOWN ACTIVATED] ", consecutiveLossCount,
                         " consecutive losses. No new entries until bar: ",
                         TimeToString(cooldownUntilBarTime));
            }
        }
        else
        {
            if(consecutiveLossCount > 0)
            {
                LogPrint("[LOSS TRACKER] Win streak started. Reset from ",
                         consecutiveLossCount, " consecutive losses.");
            }
            consecutiveLossCount = 0;
        }
    }

    if(EnableProfitOffsetSL)
    {
        for(int p = 0; p < managedPositionCount; p++)
        {
            if(managedPositions[p].ticket == closedTicket) continue;

            if(!PositionSelectByTicket(managedPositions[p].ticket)) continue;
            double posProfit = PositionGetDouble(POSITION_PROFIT);
            if(posProfit >= 0) continue;

            if(closedProfit > 0)
            {
                managedPositions[p].profitOffsetConsecWins++;
                managedPositions[p].profitOffsetAccumulated += closedProfit;

                LogPrint("[PROFIT OFFSET] Ticket ", managedPositions[p].ticket,
                         " | Win #", managedPositions[p].profitOffsetConsecWins,
                         " | +$", DoubleToString(closedProfit, 2),
                         " | Total: $", DoubleToString(managedPositions[p].profitOffsetAccumulated, 2));
            }
            else
            {
                if(managedPositions[p].profitOffsetConsecWins > 0)
                {
                    LogPrint("[PROFIT OFFSET] Ticket ", managedPositions[p].ticket,
                             " | Consecutive wins reset (closed loss: $",
                             DoubleToString(closedProfit, 2), ")");
                }
                managedPositions[p].profitOffsetConsecWins = 0;
                managedPositions[p].profitOffsetAccumulated = 0;
            }
        }
    }

    RemoveManagedPosition(closedTicket);
}

int GetManagedPositionIndex(ulong ticket)
{
    for(int i = 0; i < managedPositionCount; i++)
    {
        if(managedPositions[i].ticket == ticket)
        {
            return i;
        }
    }
    return -1;
}

ulong GetLastPositionTicket(ENUM_POSITION_TYPE type)
{
    ulong lastTicket = 0;
    datetime lastTime = 0;

    for(int i = 0; i < managedPositionCount; i++)
    {
        ulong ticket = managedPositions[i].ticket;

        if(managedPositions[i].type != type) continue;

        if(PositionSelectByTicket(ticket))
        {
             datetime posTime = (datetime)PositionGetInteger(POSITION_TIME);
             if(posTime > lastTime)
             {
                 lastTime = posTime;
                 lastTicket = ticket;
             }
        }
    }

    return lastTicket;
}

bool ValidateOrderIdentity(string intendedSymbol, long intendedMagic, string routeName)
{
    StringTrimLeft(intendedSymbol);
    StringTrimRight(intendedSymbol);

    if(intendedSymbol == "")
    {
        LogPrint("[ORDER ROUTING BLOCK] ", routeName, " | empty intended symbol");
        return false;
    }

    if(g_activeSymbol != intendedSymbol)
    {
        LogPrint("[ORDER ROUTING BLOCK] ", routeName, " | context mismatch | active=", g_activeSymbol, " intended=", intendedSymbol);
        return false;
    }

    long expectedMagic = GetMagicForSymbol(intendedSymbol);
    if(expectedMagic <= 0 || expectedMagic != intendedMagic)
    {
        LogPrint("[ORDER ROUTING BLOCK] ", routeName, " | magic mismatch | symbol=", intendedSymbol, " expected=", expectedMagic, " actual=", intendedMagic);
        return false;
    }

    int idx = FindAssetIndex(intendedSymbol);
    if(idx < 0)
    {
        LogPrint("[ORDER ROUTING BLOCK] ", routeName, " | symbol not present in asset registry: ", intendedSymbol);
        return false;
    }

    if(!SymbolSelect(intendedSymbol, true))
    {
        LogPrint("[ORDER ROUTING BLOCK] ", routeName, " | SymbolSelect failed for ", intendedSymbol);
        return false;
    }

    LogPrint("[ORDER IDENTITY] ", routeName, " | symbol=", intendedSymbol, " | magic=", intendedMagic, " | active=", g_activeSymbol);
    return true;
}

ulong ResolvePositionTicket(string symbol, long magic, ulong dealTicket, ENUM_POSITION_TYPE type)
{
    if(dealTicket > 0 && HistoryDealSelect(dealTicket))
    {
        ulong positionId = (ulong)HistoryDealGetInteger(dealTicket, DEAL_POSITION_ID);
        if(positionId > 0 && PositionSelectByTicket(positionId))
        {
            if(PositionGetString(POSITION_SYMBOL) == symbol &&
               (long)PositionGetInteger(POSITION_MAGIC) == magic)
                return positionId;
        }
    }

    ulong bestTicket = 0;
    datetime bestTime = 0;
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
        if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
        if((long)PositionGetInteger(POSITION_MAGIC) != magic) continue;
        if((ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE) != type) continue;

        datetime t = (datetime)PositionGetInteger(POSITION_TIME);
        if(t >= bestTime)
        {
            bestTime = t;
            bestTicket = ticket;
        }
    }
    return bestTicket;
}

void OpenPosition(ENUM_ORDER_TYPE orderType, double signalScore = 0)
{
    if (!IsAllowedToOpenPosition()) return;

    string spreadReason = "";
    if(!AimeSpreadEntryAllowed(signalScore, spreadReason))
    {
        LogPrint("[SPREAD] ENTRY BLOCKED: ", spreadReason, " | ", g_activeSymbol);
        return;
    }

    if(BlockEntriesOnUnprotectedExternalPositions && g_externalUnprotectedPositionCount > 0)
    {
        LogPrint("[EXTERNAL RISK] ENTRY BLOCKED: ", g_externalUnprotectedPositionCount,
                 " unprotected external position(s) detected.");
        return;
    }

    long routeMagic = ActiveMagicNumber();
    if(!ValidateOrderIdentity(g_activeSymbol, routeMagic, "MARKET_ENTRY")) return;
    string recoveryReason="";
    if(!AimeRecoveryAllowsSignal(orderType,signalScore,recoveryReason))
    {
        LogPrint("[RECOVERY] BLOCKED: ",recoveryReason," | ",g_activeSymbol);
        return;
    }
    if(!AimeExecutionExposureAvailable(g_activeSymbol,routeMagic))
    {
        LogPrint("[EXECUTION] SYMBOL EXPOSURE BLOCK: ",g_activeSymbol);
        return;
    }
    datetime entryBar=iTime(g_activeSymbol,g_activePeriod,0);
    if(!AimeAcquireEntryFingerprint(g_activeSymbol,orderType,entryBar))
    {
        LogPrint("[EXECUTION] DUPLICATE ENTRY BLOCK: ",g_activeSymbol," type=",EnumToString(orderType));
        return;
    }
    if(!AimeAcquireGlobalTradeLock(g_activeSymbol))
    {
        AimeReleaseEntryFingerprint(g_activeSymbol,orderType,entryBar);
        LogPrint("[EXECUTION] GLOBAL TRADE LOCK BUSY: ",g_activeSymbol);
        return;
    }

    LockOrderSend(true);

    MqlTradeRequest request = {};
    MqlTradeCheckResult checkResult = {};
    MqlTradeResult result = {};

    double currentLot = CalculateDynamicLotSize(signalScore, orderType);
    double maxRiskMoney = AccountInfoDouble(ACCOUNT_EQUITY) * (RiskPerTradePct / 100.0);
    if(maxRiskMoney > 0.0 && currentLot > 0.0)
    {
        for(int riskIteration = 0; riskIteration < 5; riskIteration++)
        {
            double riskEntryPrice = (orderType == ORDER_TYPE_BUY) ? SymbolInfoDouble(g_activeSymbol, SYMBOL_ASK) : SymbolInfoDouble(g_activeSymbol, SYMBOL_BID);
            double riskSLPoints = AimeStructureSLPoints(orderType, riskEntryPrice, currentLot);
            if(riskEntryPrice <= 0.0 || riskSLPoints <= 0.0 || ActivePoint() <= 0.0) break;

            double riskSLPrice = orderType == ORDER_TYPE_BUY
                ? NormalizeDouble(riskEntryPrice - riskSLPoints * ActivePoint(), ActiveDigits())
                : NormalizeDouble(riskEntryPrice + riskSLPoints * ActivePoint(), ActiveDigits());

            double projectedRisk = AimeProjectedRiskMoney(orderType, currentLot, riskEntryPrice, riskSLPrice);
            if(projectedRisk <= maxRiskMoney + 0.01 || projectedRisk <= 0.0 || projectedRisk >= DBL_MAX / 2.0) break;

            double ratio = maxRiskMoney / projectedRisk;
            if(ratio <= 0.0 || ratio >= 1.0) break;

            double reducedLot = NormalizeVolume(currentLot * ratio);
            if(reducedLot >= currentLot || reducedLot <= 0.0) break;
            currentLot = reducedLot;
        }
    }

    double ask = SymbolInfoDouble(g_activeSymbol, SYMBOL_ASK);
    double bid = SymbolInfoDouble(g_activeSymbol, SYMBOL_BID);
    double price = (orderType == ORDER_TYPE_BUY) ? ask : bid;

    request.action = TRADE_ACTION_DEAL;
    request.symbol = g_activeSymbol;
    request.volume = currentLot;
    request.type = orderType;
    request.price = price;
    request.deviation = 10;
    request.magic = ActiveMagicNumber();
    request.comment = "Aime|" + g_activeSymbol + "|" + StringFormat("%I64d", ActiveMagicNumber());
    request.type_filling = GetFillingModeForSymbol(g_activeSymbol);

    double slPoints = AimeStructureSLPoints(orderType, price, currentLot);
    double tpPoints = 0.0;

    if(slPoints > 0)
    {
        if(orderType == ORDER_TYPE_BUY)
            request.sl = NormalizeDouble(price - (slPoints * ActivePoint()), ActiveDigits());
        else
            request.sl = NormalizeDouble(price + (slPoints * ActivePoint()), ActiveDigits());
    }

    if(request.sl > 0.0)
        tpPoints = AimePreTradeTPPoints(orderType, price, request.sl, currentLot);

    if(tpPoints > 0)
    {
        if(orderType == ORDER_TYPE_BUY)
            request.tp = NormalizeDouble(price + (tpPoints * ActivePoint()), ActiveDigits());
        else
            request.tp = NormalizeDouble(price - (tpPoints * ActivePoint()), ActiveDigits());
    }

    long stopLevel = SymbolInfoInteger(g_activeSymbol, SYMBOL_TRADE_STOPS_LEVEL);
    long freezeLevel = SymbolInfoInteger(g_activeSymbol, SYMBOL_TRADE_FREEZE_LEVEL);
    double minDistance = MathMax(stopLevel, freezeLevel) * ActivePoint();

    if(orderType == ORDER_TYPE_BUY)
    {
        if(request.sl > 0 && request.sl >= bid - minDistance)
            request.sl = NormalizeDouble(bid - minDistance - ActivePoint(), ActiveDigits());
        if(request.tp > 0 && request.tp <= ask + minDistance)
            request.tp = NormalizeDouble(ask + minDistance + ActivePoint(), ActiveDigits());
    }
    else
    {
        if(request.sl > 0 && request.sl <= ask + minDistance)
            request.sl = NormalizeDouble(ask + minDistance + ActivePoint(), ActiveDigits());
        if(request.tp > 0 && request.tp >= bid - minDistance)
            request.tp = NormalizeDouble(bid - minDistance - ActivePoint(), ActiveDigits());
    }

    request.sl = request.sl > 0 ? NormalizeDouble(request.sl, ActiveDigits()) : 0.0;
    request.tp = request.tp > 0 ? NormalizeDouble(request.tp, ActiveDigits()) : 0.0;

    if(!AimeValidatePositionSize(currentLot,orderType,price,request.sl))
    {
        LogPrint("[POSITION SIZE] BLOCKED volume=",DoubleToString(currentLot,8)," symbol=",g_activeSymbol);
        LockOrderSend(false);
    AimeReleaseGlobalTradeLock(g_activeSymbol);
        return;
    }

    string rrReason="";
    if(!AimeRiskRewardGate(orderType,currentLot,price,request.sl,request.tp,rrReason))
    {
        LogPrint("[RR GATE] BLOCKED: ",rrReason," | ",g_activeSymbol);
        if(EnableExecutionFeedback) g_executionRejectCount++;
        LockOrderSend(false);
    AimeReleaseGlobalTradeLock(g_activeSymbol);
        return;
    }

    currentLot = AimeHardCapSingleTradeLot(currentLot);
    if(currentLot <= 0.0 || !AimeValidatePositionSize(currentLot, orderType, price, request.sl))
    {
        LogPrint("[POSITION SIZE] FINAL VALIDATION BLOCKED volume=", DoubleToString(currentLot,8), " symbol=", g_activeSymbol);
        LockOrderSend(false);
        AimeReleaseGlobalTradeLock(g_activeSymbol);
        AimeReleaseEntryFingerprint(g_activeSymbol,orderType,entryBar);
        return;
    }
    request.volume = currentLot;
    {
        string hardGateReason = "";
        double gateRiskMoney = AimeProjectedRiskMoney(orderType, currentLot, price, request.sl);
        if(!AimeHardSafetyGateAllowsNewExposure(currentLot, gateRiskMoney, hardGateReason))
        {
            LogPrint("[HARD SAFETY] ENTRY BLOCKED: ", hardGateReason, " | ", g_activeSymbol);
            LockOrderSend(false);
            AimeReleaseGlobalTradeLock(g_activeSymbol);
            return;
        }

        string classNow = AimeProfileClass(g_activeSymbol);
        double classCapPctNow = AimeClassRiskCapPct(classNow);
        double equityNow = AccountInfoDouble(ACCOUNT_EQUITY);
        if(classCapPctNow > 0.0 && equityNow > 0.0 && gateRiskMoney < DBL_MAX / 2.0)
        {
            double projectedClassPctNow = ((AimeClassOpenRiskMoney(classNow) + gateRiskMoney) / equityNow) * 100.0;
            if(projectedClassPctNow > classCapPctNow + 1e-9)
            {
                LogPrint("[HARD SAFETY] ENTRY BLOCKED: CLASS RISK ", classNow, " ", DoubleToString(projectedClassPctNow,2),
                         "% > ", DoubleToString(classCapPctNow,2), "% cap | ", g_activeSymbol);
                LockOrderSend(false);
                AimeReleaseGlobalTradeLock(g_activeSymbol);
                return;
            }
        }
    }

    if(!AimeRiskCheckNewOrder(orderType, currentLot, price, request.sl))
    {
        LockOrderSend(false);
    AimeReleaseGlobalTradeLock(g_activeSymbol);
        return;
    }

    double projectedPortfolioRisk = AimeProjectedRiskMoney(orderType, currentLot, price, request.sl);
    string portfolioReason = "";
    if(!AimePortfolioIntelligenceAllows(g_activeSymbol, orderType, projectedPortfolioRisk, portfolioReason))
    {
        LogPrint("[PORTFOLIO INTELLIGENCE] BLOCKED: ", portfolioReason, " | ", g_activeSymbol);
        LockOrderSend(false);
    AimeReleaseGlobalTradeLock(g_activeSymbol);
        return;
    }

    if(!ValidateExecutionSymbol(g_activeSymbol, orderType, currentLot, request.sl, request.tp))
    {
        LogPrint("[EXECUTION BLOCK] Broker validation failed for ", g_activeSymbol);
        LockOrderSend(false);
    AimeReleaseGlobalTradeLock(g_activeSymbol);
        return;
    }

    if(!OrderCheck(request, checkResult))
    {
        LogPrint("OrderCheck failed for ", g_activeSymbol, " retcode=", checkResult.retcode, " comment=", checkResult.comment);
        if(EnableExecutionFeedback) { g_executionRejectCount++; g_lastExecutionStatus="ORDERCHECK REJECT"; g_lastExecutionTime=TimeCurrent(); }
        LockOrderSend(false);
    AimeReleaseGlobalTradeLock(g_activeSymbol);
        return;
    }

    bool orderResult = AimeOrderSendWithRetry(request, result, 3);

    if(orderResult)
    {
        if(result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_DONE_PARTIAL)
        {
            double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
            double equityDropAmount = lastPeakEquity - currentEquity;

            double equityDropPercentage = 0;
            if(lastPeakEquity > 0)
            {
                equityDropPercentage = (equityDropAmount / lastPeakEquity) * 100.0;
            }

            LogPrint("Order opened successfully. Ticket: ", result.order,
                     ", Type: ", orderType == ORDER_TYPE_BUY ? "BUY" : "SELL",
                     ", Lot Size: ", currentLot,
                     ", Signal Score: ", signalScore,
                     " (Peak: $", lastPeakEquity,
                     ", Current: $", currentEquity,
                     ", Drop: ", equityDropPercentage, "%)");

            if(request.sl > 0)
            {
                LogPrint(" | SL: ", request.sl);
            }
            if(request.tp > 0)
            {
                LogPrint(" | TP: ", request.tp, EnableRiskReward ? StringFormat(" (R:R 1:%.2f)", RiskRewardRatio) : "");
            }
            AimePlayTradeSound(orderType==ORDER_TYPE_BUY?"Buy":"Sell");

            ENUM_POSITION_TYPE posType = (orderType == ORDER_TYPE_BUY) ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
            ulong positionTicket = ResolvePositionTicket(g_activeSymbol, ActiveMagicNumber(), result.deal, posType);
            if(positionTicket > 0)
                RegisterManagedPosition(positionTicket, posType, signalScore, price);
            else
                LogPrint("[POSITION REGISTRATION] Could not resolve position ticket after order ", result.order, " for ", g_activeSymbol);

            datetime currBarTime = iTime(g_activeSymbol, g_activePeriod, 0);
            if(currentBarTime != currBarTime)
            {
                currentBarTime = currBarTime;
                buysOnCurrentBar = 0;
                sellsOnCurrentBar = 0;
            }

            if(orderType == ORDER_TYPE_BUY) buysOnCurrentBar++;
            else sellsOnCurrentBar++;

            if(orderType == ORDER_TYPE_BUY)
            {
                lastBuyTime = TimeCurrent();
                lastBuyPrice = price;
            }
            else
            {
                lastSellTime = TimeCurrent();
                lastSellPrice = price;
            }
            lastEntryBarTime = currBarTime;
            AimeRegisterRecoveryRisk(AimeProjectedRiskMoney(orderType,currentLot,price,request.sl));
        }
        else
        {
            LogPrint("Order failed. Return code: ", result.retcode);
        }
    }
    else
    {
        LogPrint("OrderSend error: ", GetLastError());
    }

    bool executionSucceeded=(orderResult && (result.retcode==TRADE_RETCODE_DONE || result.retcode==TRADE_RETCODE_DONE_PARTIAL));
    if(!executionSucceeded) AimeReleaseEntryFingerprint(g_activeSymbol,orderType,entryBar);
    LockOrderSend(false);
    AimeReleaseGlobalTradeLock(g_activeSymbol);
}

double ComputeRecoveryLot(double olderLot, double olderLoss, double atr)
{
    double p = HedgeRecoveryPct / 100.0;
    if(p <= 0) p = 1.0;

    double tickValue  = SymbolInfoDouble(g_activeSymbol, SYMBOL_TRADE_TICK_VALUE);
    double tickSize   = SymbolInfoDouble(g_activeSymbol, SYMBOL_TRADE_TICK_SIZE);
    double targetPrice = HedgeRecoveryATR * atr;
    if(tickValue <= 0 || tickSize <= 0 || targetPrice <= 0) return 0;

    double moneyPerLot = (targetPrice / tickSize) * tickValue;
    if(moneyPerLot <= 0) return 0;

    return p * olderLot + p * olderLoss / moneyPerLot;
}

double ComputeHedgeLot(double olderLot, double olderLoss, double atr)
{
    double lot = 0;
    if(HedgeAutoLot)
        lot = ComputeRecoveryLot(olderLot, olderLoss, atr);

    if(lot <= 0)
        lot = olderLot * HedgeLotMultiplier;

    double stepVol = SymbolInfoDouble(g_activeSymbol, SYMBOL_VOLUME_STEP);
    double minLot = olderLot + (stepVol > 0 ? stepVol : 0.01);
    if(lot < minLot) lot = minLot;

    if(HedgeMaxLot > 0 && lot > HedgeMaxLot) lot = HedgeMaxLot;
    return NormalizeVolume(lot);
}

ulong OpenChainHedge(ulong chainId, ENUM_POSITION_TYPE prevType, double hedgeLot, int newLevel, double anchorLoss, int cycleNum)
{
    if(EnableRecoveryEngine && RecoveryDisableHedgeEscalation && g_recoveryMode=="RECOVERY" && newLevel>1)
    {
        LogPrint("[HEDGE] RECOVERY ESCALATION BLOCKED: ",g_activeSymbol," level=",newLevel);
        return 0;
    }
    long routeMagic = ActiveMagicNumber();
    if(!ValidateOrderIdentity(g_activeSymbol, routeMagic, "HEDGE_ENTRY")) return 0;

    string riskReason = "";
    if(!AimeRiskGovernorAllowsEntry(riskReason))
    {
        LogPrint("[HEDGE] BLOCKED: ", riskReason, " | ", g_activeSymbol);
        return 0;
    }

    LockOrderSend(true);

    MqlTradeRequest request = {};
    MqlTradeResult result = {};

    ENUM_ORDER_TYPE hedgeOrderType = (prevType == POSITION_TYPE_BUY) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;

    hedgeLot = NormalizeVolume(hedgeLot);

    double ask = SymbolInfoDouble(g_activeSymbol, SYMBOL_ASK);
    double bid = SymbolInfoDouble(g_activeSymbol, SYMBOL_BID);
    double price = (hedgeOrderType == ORDER_TYPE_BUY) ? ask : bid;

    request.action = TRADE_ACTION_DEAL;
    request.symbol = g_activeSymbol;
    request.volume = hedgeLot;
    request.type = hedgeOrderType;
    request.price = price;
    request.deviation = 10;
    request.magic = ActiveMagicNumber();
    request.comment = "AimeH|" + g_activeSymbol + "|L" + IntegerToString(newLevel);
    request.type_filling = GetFillingModeForSymbol(g_activeSymbol);

    if(!AimeRiskCheckNewOrder(hedgeOrderType, hedgeLot, price, 0.0))
    {
        LockOrderSend(false);
        return 0;
    }

    hedgeLot = AimeHardCapSingleTradeLot(hedgeLot);
    request.volume = hedgeLot;
    {
        string hardGateReason = "";
        if(!AimeHardSafetyGateAllowsNewExposure(hedgeLot, 0.0, hardGateReason))
        {
            LogPrint("[HARD SAFETY] HEDGE ENTRY BLOCKED: ", hardGateReason, " | ", g_activeSymbol);
            LockOrderSend(false);
            return 0;
        }
    }

    ulong newTicket = 0;
    bool orderResult = AimeOrderSendWithRetry(request, result, 3);

    if(orderResult && result.retcode == TRADE_RETCODE_DONE)
    {
        ENUM_POSITION_TYPE hedgePosType = (hedgeOrderType == ORDER_TYPE_BUY) ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
        ulong positionTicket = ResolvePositionTicket(g_activeSymbol, ActiveMagicNumber(), result.deal, hedgePosType);
        if(positionTicket > 0)
        {
            RegisterManagedPosition(positionTicket, hedgePosType, 0, price, chainId, newLevel, anchorLoss, cycleNum);
            newTicket = positionTicket;
        }
        else
        {
            LogPrint("[HEDGE] Could not resolve position ticket after order ", result.order, " for ", g_activeSymbol);
        }

        LogPrint("+-----------------------------------------+");
        LogPrint("[HEDGE CHAIN] Opened hedge L", newLevel, " | Chain: ", chainId, " | Cycle: ", cycleNum);
        LogPrint("Leg ", result.order, " (", EnumToString(hedgePosType), ")",
                 " | Lot: ", hedgeLot, " | Sizing: ", (HedgeAutoLot ? "Auto-Recover" : "Fixed x" + DoubleToString(HedgeLotMultiplier, 2)));
        LogPrint("+-----------------------------------------+");
    }
    else
    {
        LogPrint("[HEDGE CHAIN] OrderSend failed. Retcode: ", result.retcode, " | Error: ", GetLastError());
    }

    LockOrderSend(false);
    return newTicket;
}

void GraduateChainLeg(ulong ticket)
{
    int idx = GetManagedPositionIndex(ticket);
    if(idx == -1) return;
    managedPositions[idx].chainId         = 0;
    managedPositions[idx].hedgeLevel      = 0;
    managedPositions[idx].chainAnchorLoss = 0;
    managedPositions[idx].cycleNum        = 0;
    managedPositions[idx].hedgeGraduated  = true;
    managedPositions[idx].hedgeLockProfit = 0;
}

void CloseChain(ulong chainId)
{
    for(int z = managedPositionCount - 1; z >= 0; z--)
    {
        if(managedPositions[z].chainId != chainId) continue;
        if(PositionSelectByTicket(managedPositions[z].ticket))
            ClosePosition(managedPositions[z].ticket);
    }
}

void ReleaseChainToLossMgmt(ulong chainId)
{
    int released = 0;
    for(int z = 0; z < managedPositionCount; z++)
    {
        if(managedPositions[z].chainId != chainId) continue;
        managedPositions[z].chainId         = 0;
        managedPositions[z].hedgeLevel      = 0;
        managedPositions[z].chainAnchorLoss = 0;
        managedPositions[z].cycleNum        = 0;
        managedPositions[z].noRehedge       = true;
        managedPositions[z].hedgeGraduated  = true;
        released++;
    }
    LogPrint("[HEDGE CHAIN] Released chain ", chainId, " (", released,
             " legs) to adaptive loss management - no re-hedge.");
}

double ChainLossStopThreshold()
{
    double usd = (HedgeMaxChainLossUSD > 0) ? HedgeMaxChainLossUSD : 0;
    double pct = (HedgeMaxChainLossPct > 0)
                 ? AccountInfoDouble(ACCOUNT_EQUITY) * HedgeMaxChainLossPct / 100.0
                 : 0;
    if(usd > 0 && pct > 0) return MathMin(usd, pct);
    return MathMax(usd, pct);
}

bool ReseedCycle(ulong id, ulong olderTicket, ulong hedgeTicket, double hedgeLot,
                 ENUM_POSITION_TYPE hedgeType, int cycleNum, double atr)
{
    double minL = SymbolInfoDouble(g_activeSymbol, SYMBOL_VOLUME_MIN);
    double step = SymbolInfoDouble(g_activeSymbol, SYMBOL_VOLUME_STEP);
    if(step <= 0) step = 0.01;

    double closeVol = MathFloor((hedgeLot * HedgeCyclePartialPct / 100.0) / step) * step;
    double remaining = hedgeLot - closeVol;
    if(remaining < minL)
    {
        closeVol  = MathFloor((hedgeLot - minL) / step) * step;
        remaining = hedgeLot - closeVol;
    }
    if(closeVol < minL || remaining < minL)
        return false;

    if(!PartialClosePosition(hedgeTicket, closeVol))
    {
        LogPrint("[HEDGE CHAIN RESEED] Partial close failed for ", hedgeTicket,
                 " - chain left intact, releasing to loss management.");
        return false;
    }

    if(olderTicket != 0) ClosePosition(olderTicket);

    if(!PositionSelectByTicket(hedgeTicket)) return false;
    double remLot = PositionGetDouble(POSITION_VOLUME);
    double remPL  = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
    double newAnchor = (remPL < 0) ? -remPL : 0.01;

    int idx = GetManagedPositionIndex(hedgeTicket);
    if(idx == -1) return false;
    managedPositions[idx].chainId         = hedgeTicket;
    managedPositions[idx].hedgeLevel      = 0;
    managedPositions[idx].chainAnchorLoss = newAnchor;
    managedPositions[idx].cycleNum        = cycleNum + 1;

    LogPrint("+-----------------------------------------+");
    LogPrint("[HEDGE CHAIN RESEED] New cycle ", cycleNum + 1, " | Chain ", id);
    LogPrint("Closed older ", olderTicket, "; closed ", DoubleToString(closeVol, 2),
             " of hedge ", hedgeTicket, " (remain ", DoubleToString(remLot, 2),
             ", anchor $", DoubleToString(newAnchor, 2), ")");
    LogPrint("+-----------------------------------------+");

    double hLot = ComputeHedgeLot(remLot, newAnchor, atr);
    if(hLot > remLot)
        OpenChainHedge(hedgeTicket, hedgeType, hLot, 1, newAnchor, cycleNum + 1);
    else
        LogPrint("[HEDGE CHAIN RESEED] Reduced root still can't be hedged within lot ceiling - holding as free leg.");

    return true;
}

void ManageHedgeChains()
{
    if(!EnableHedgeChain) return;

    double bufATR[];
    ArraySetAsSeries(bufATR, true);
    if(CopyBuffer(atrSignalHandle, 0, 0, 2, bufATR) < 2) return;
    double atr = bufATR[1];
    if(atr <= 0) return;

    double bid = SymbolInfoDouble(g_activeSymbol, SYMBOL_BID);
    double ask = SymbolInfoDouble(g_activeSymbol, SYMBOL_ASK);

    ulong chains[];
    int chainCount = 0;
    for(int i = 0; i < managedPositionCount; i++)
    {
        ulong id = managedPositions[i].chainId;
        if(id == 0) continue;
        bool seen = false;
        for(int k = 0; k < chainCount; k++) if(chains[k] == id) { seen = true; break; }
        if(!seen) { ArrayResize(chains, chainCount + 1); chains[chainCount++] = id; }
    }

    for(int c = 0; c < chainCount; c++)
    {
        ulong id = chains[c];

        ulong olderTicket = 0, hedgeTicket = 0;
        int olderLevel = INT_MAX, hedgeLevel = -1;
        double olderPL = 0, hedgePL = 0;
        double hedgeLot = 0;
        ENUM_POSITION_TYPE hedgeType = POSITION_TYPE_BUY;
        double anchorLoss = 0;
        int openLegs = 0;
        int cycleNum = 0;
        double totalPL = 0;

        for(int i = 0; i < managedPositionCount; i++)
        {
            if(managedPositions[i].chainId != id) continue;
            ulong t = managedPositions[i].ticket;
            if(!PositionSelectByTicket(t)) continue;
            openLegs++;
            double pl = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
            totalPL += pl;
            int lvl = managedPositions[i].hedgeLevel;
            cycleNum = managedPositions[i].cycleNum;
            if(managedPositions[i].chainAnchorLoss > 0) anchorLoss = managedPositions[i].chainAnchorLoss;

            if(lvl < olderLevel) { olderLevel = lvl; olderTicket = t; olderPL = pl; }
            if(lvl > hedgeLevel)
            {
                hedgeLevel = lvl;
                hedgeTicket = t;
                hedgePL = pl;
                hedgeLot = PositionGetDouble(POSITION_VOLUME);
                hedgeType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
            }
        }

        if(openLegs == 0) continue;
        if(openLegs == 1)
        {
            if(hedgeTicket != 0) GraduateChainLeg(hedgeTicket);
            continue;
        }

        if(olderPL < 0)
        {
            double olderLoss = -olderPL;
            double coverNeeded = (HedgeRecoveryPct / 100.0) * olderLoss;
            if(hedgePL >= coverNeeded)
            {
                LogPrint("+-----------------------------------------+");
                LogPrint("[HEDGE CHAIN COVERED] Chain ", id);
                LogPrint("Hedge ", hedgeTicket, " profit $", DoubleToString(hedgePL, 2),
                         " >= ", DoubleToString(HedgeRecoveryPct, 0), "% of older ", olderTicket,
                         " loss $", DoubleToString(olderLoss, 2));
                LogPrint("Closing older leg; hedge graduates and trails (SL floored at recovery).");
                LogPrint("+-----------------------------------------+");
                ClosePosition(olderTicket);
                GraduateChainLeg(hedgeTicket);

                int hgi = GetManagedPositionIndex(hedgeTicket);
                if(hgi != -1) managedPositions[hgi].hedgeLockProfit = coverNeeded;
                continue;
            }
        }

        if(hedgePL < 0 && olderPL >= HedgeRollMinProfit)
        {
            bool   levelOk = (hedgeLevel < HedgeCycleLevels);
            double newLot  = levelOk ? ComputeHedgeLot(hedgeLot, -hedgePL, atr) : 0;
            bool   lotOk   = (newLot > hedgeLot);

            if(levelOk && lotOk)
            {
                LogPrint("+-----------------------------------------+");
                LogPrint("[HEDGE CHAIN ROLL] Chain ", id, " | Cycle ", cycleNum);
                LogPrint("Older ", olderTicket, " recovered to $", DoubleToString(olderPL, 2),
                         "; hedge ", hedgeTicket, " losing $", DoubleToString(hedgePL, 2));
                LogPrint("Closing older; opening hedge L", hedgeLevel + 1, " (lot ",
                         DoubleToString(newLot, 2), " > ", DoubleToString(hedgeLot, 2), ").");
                LogPrint("+-----------------------------------------+");
                ClosePosition(olderTicket);
                OpenChainHedge(id, hedgeType, newLot, hedgeLevel + 1, anchorLoss, cycleNum);
                continue;
            }

            string why = (!levelOk) ? "cycle level limit" : "lot ceiling";
            bool cyclesLeft = (HedgeMaxCycles <= 0 || cycleNum + 1 < HedgeMaxCycles);

            if(EnableHedgeCycleReset && cyclesLeft)
            {
                LogPrint("[HEDGE CHAIN] Chain ", id, " cyc ", cycleNum, ": ", why,
                         " reached -> partial-close & reseed new cycle.");
                if(!ReseedCycle(id, olderTicket, hedgeTicket, hedgeLot, hedgeType, cycleNum, atr))
                {
                    LogPrint("[HEDGE CHAIN] Reseed failed (cannot reduce hedge) -> release to loss mgmt.");
                    ReleaseChainToLossMgmt(id);
                }
                continue;
            }
            else
            {
                LogPrint("[HEDGE CHAIN EXHAUSTED] Chain ", id, " cyc ", cycleNum, ": ", why, ", ",
                         (!EnableHedgeCycleReset ? "reseed disabled" : "max cycles reached"),
                         " -> release to adaptive loss management (no re-hedge).");
                ReleaseChainToLossMgmt(id);
                continue;
            }
        }

        double stopThr = ChainLossStopThreshold();
        if(stopThr > 0 && totalPL <= -stopThr)
        {
            LogPrint("+-----------------------------------------+");
            LogPrint("[HEDGE CHAIN STOPPED] Chain ", id, " | Open legs: ", openLegs);
            LogPrint("Total loss $", DoubleToString(totalPL, 2), " <= stop $", DoubleToString(-stopThr, 2));
            LogPrint("Closing all chain legs (loss backstop).");
            LogPrint("+-----------------------------------------+");
            CloseChain(id);
            continue;
        }

    }

    for(int i = 0; i < managedPositionCount; i++)
    {
        if(managedPositions[i].chainId != 0) continue;
        if(managedPositions[i].noRehedge) continue;

        ulong ticket = managedPositions[i].ticket;
        if(!PositionSelectByTicket(ticket)) continue;
        if(PositionGetInteger(POSITION_MAGIC) != ActiveMagicNumber()) continue;
        if(PositionGetString(POSITION_SYMBOL) != g_activeSymbol) continue;

        double pl = PositionGetDouble(POSITION_PROFIT) + PositionGetDouble(POSITION_SWAP);
        if(pl >= 0) continue;

        ENUM_POSITION_TYPE posType = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        double entryPrice = PositionGetDouble(POSITION_PRICE_OPEN);
        double volume = PositionGetDouble(POSITION_VOLUME);
        double curTP = PositionGetDouble(POSITION_TP);
        double curSL = PositionGetDouble(POSITION_SL);

        double adverse = (posType == POSITION_TYPE_BUY) ? (entryPrice - bid) : (ask - entryPrice);
        if(adverse <= 0) continue;
        if((adverse / atr) < HedgeTriggerATR) continue;

        if(HedgeRequireSignal)
        {
            ENUM_ORDER_TYPE hedgeDir = (posType == POSITION_TYPE_BUY) ? ORDER_TYPE_SELL : ORDER_TYPE_BUY;
            double hedgeScore = GetSignalStrength(hedgeDir).finalScore;
            if(hedgeScore < HedgeMinSignalScore)
            {
                LogPrint("[HEDGE CHAIN] Skip start for ", ticket, ": reverse signal ",
                         DoubleToString(hedgeScore, 2), " < ", DoubleToString(HedgeMinSignalScore, 2),
                         " (likely spike) - waiting for confirmation.");
                continue;
            }
        }

        double anchorLoss = -pl;

        double hedgeLot = ComputeHedgeLot(volume, anchorLoss, atr);
        if(hedgeLot <= volume)
        {
            LogPrint("[HEDGE CHAIN] Skip start for ", ticket, ": hedge lot ", DoubleToString(hedgeLot, 2),
                     " not > position lot ", DoubleToString(volume, 2), " (HedgeMaxLot ",
                     DoubleToString(HedgeMaxLot, 2), "). Left to normal management.");
            continue;
        }

        managedPositions[i].chainId         = ticket;
        managedPositions[i].hedgeLevel      = 0;
        managedPositions[i].chainAnchorLoss = anchorLoss;
        managedPositions[i].cycleNum        = 0;
        managedPositions[i].hedgeGraduated  = false;
        managedPositions[i].hedgeLockProfit = 0;

        if(HedgeClearRootSL && curSL != 0) ModifyPosition(ticket, 0, curTP);

        LogPrint("+-----------------------------------------+");
        LogPrint("[HEDGE CHAIN STARTED] First leg ", ticket, " (", EnumToString(posType), ")");
        LogPrint("Start loss: $", DoubleToString(anchorLoss, 2),
                 " | Adverse: ", DoubleToString(adverse / atr, 2), " ATR >= ", DoubleToString(HedgeTriggerATR, 2));
        LogPrint("+-----------------------------------------+");

        OpenChainHedge(ticket, posType, hedgeLot, 1, anchorLoss, 0);
    }
}

double ComputeLimitEntryPrice(ENUM_ORDER_TYPE dir, double atr)
{
    bool isBuy = (dir == ORDER_TYPE_BUY);
    double ref = isBuy ? SymbolInfoDouble(g_activeSymbol, SYMBOL_ASK) : SymbolInfoDouble(g_activeSymbol, SYMBOL_BID);

    long stopLevel = SymbolInfoInteger(g_activeSymbol, SYMBOL_TRADE_STOPS_LEVEL);
    double minStopDist = stopLevel * ActivePoint();
    double maxDist = atr * LimitEntryATRFraction;
    if(maxDist <= 0) return 0;

    double fixedDepthPrice = isBuy ? (ref - maxDist)     : (ref + maxDist);
    double minDistPrice    = isBuy ? (ref - minStopDist) : (ref + minStopDist);

    if(LimitEntryAnchor == LIMIT_ANCHOR_FIXED_ATR)
    {
        double pf = isBuy ? MathMin(fixedDepthPrice, minDistPrice)
                          : MathMax(fixedDepthPrice, minDistPrice);
        return NormalizeDouble(pf, ActiveDigits());
    }

    double anchor = isBuy ? -DBL_MAX : DBL_MAX;
    bool haveAnchor = false;

    if(LimitEntryAnchor == LIMIT_ANCHOR_EMA || LimitEntryAnchor == LIMIT_ANCHOR_SMART)
    {
        double bufEMA[];
        ArraySetAsSeries(bufEMA, true);
        if(CopyBuffer(emaFastHandle, 0, 0, 1, bufEMA) >= 1)
        {
            double ema = bufEMA[0];
            if(isBuy ? (ema < ref) : (ema > ref))
            {
                anchor = isBuy ? MathMax(anchor, ema) : MathMin(anchor, ema);
                haveAnchor = true;
            }
        }
    }

    if(LimitEntryAnchor == LIMIT_ANCHOR_SWING || LimitEntryAnchor == LIMIT_ANCHOR_SMART)
    {
        int look = MathMax(5, HealthSwingLookback);
        MqlRates rates[];
        ArraySetAsSeries(rates, true);
        int copied = CopyRates(g_activeSymbol, g_activePeriod, 1, look, rates);
        if(copied > 0)
        {
            double sw = isBuy ? rates[0].low : rates[0].high;
            for(int j = 1; j < copied; j++)
                sw = isBuy ? MathMin(sw, rates[j].low) : MathMax(sw, rates[j].high);
            if(isBuy ? (sw < ref) : (sw > ref))
            {
                anchor = isBuy ? MathMax(anchor, sw) : MathMin(anchor, sw);
                haveAnchor = true;
            }
        }
    }

    double price = haveAnchor ? anchor : fixedDepthPrice;

    price = isBuy ? MathMax(price, fixedDepthPrice) : MathMin(price, fixedDepthPrice);

    price = isBuy ? MathMin(price, minDistPrice) : MathMax(price, minDistPrice);

    return NormalizeDouble(price, ActiveDigits());
}

void PlaceLimitEntry(ENUM_ORDER_TYPE dir, double signalScore)
{
    if(!IsAllowedToOpenPosition()) return;

    long routeMagic = ActiveMagicNumber();
    if(!ValidateOrderIdentity(g_activeSymbol, routeMagic, "LIMIT_ENTRY")) return;

    if(CountWorkingLimitOrders() > 0) return;

    double bufATR[];
    ArraySetAsSeries(bufATR, true);
    if(CopyBuffer(atrSignalHandle, 0, 0, 1, bufATR) < 1) return;
    double atr = bufATR[0];
    if(atr <= 0) return;

    double entry = ComputeLimitEntryPrice(dir, atr);
    if(entry <= 0) return;

    double currentLot = CalculateDynamicLotSize(signalScore, dir);
    double ref = (dir == ORDER_TYPE_BUY) ? SymbolInfoDouble(g_activeSymbol, SYMBOL_ASK)
                                         : SymbolInfoDouble(g_activeSymbol, SYMBOL_BID);

    LockOrderSend(true);

    MqlTradeRequest request = {};
    MqlTradeCheckResult checkResult = {};
    MqlTradeResult result = {};
    request.action = TRADE_ACTION_PENDING;
    request.symbol = g_activeSymbol;
    request.volume = currentLot;
    request.deviation = 10;
    request.magic = ActiveMagicNumber();
    request.type_time = ORDER_TIME_GTC;
    request.comment = "AimeLE|" + g_activeSymbol + "|" + DoubleToString(signalScore, 2);
    request.price = entry;

    double slPts = AimeStructureSLPoints(dir, entry, currentLot);
    double tpPts = 0.0;
    if(dir == ORDER_TYPE_BUY)
    {
        request.type = ORDER_TYPE_BUY_LIMIT;
        if(slPts > 0)
            request.sl = NormalizeDouble(entry - slPts * ActivePoint(), ActiveDigits());
        if(tpPts > 0)
            request.tp = NormalizeDouble(entry + tpPts * ActivePoint(), ActiveDigits());
    }
    else
    {
        request.type = ORDER_TYPE_SELL_LIMIT;
        if(slPts > 0)
            request.sl = NormalizeDouble(entry + slPts * ActivePoint(), ActiveDigits());
        if(tpPts > 0)
            request.tp = NormalizeDouble(entry - tpPts * ActivePoint(), ActiveDigits());
    }

    long stopLevel = SymbolInfoInteger(g_activeSymbol, SYMBOL_TRADE_STOPS_LEVEL);
    long freezeLevel = SymbolInfoInteger(g_activeSymbol, SYMBOL_TRADE_FREEZE_LEVEL);
    double minDistance = MathMax(stopLevel, freezeLevel) * ActivePoint();

    double ask = SymbolInfoDouble(g_activeSymbol, SYMBOL_ASK);
    double bid = SymbolInfoDouble(g_activeSymbol, SYMBOL_BID);

    if(dir == ORDER_TYPE_BUY)
    {
        if(request.sl > 0 && request.sl >= entry - minDistance)
            request.sl = NormalizeDouble(entry - minDistance - ActivePoint(), ActiveDigits());
        if(request.tp > 0 && request.tp <= entry + minDistance)
            request.tp = NormalizeDouble(entry + minDistance + ActivePoint(), ActiveDigits());
        if(entry >= ask - minDistance)
        {
            LogPrint("LIMIT ENTRY BLOCKED: BUY LIMIT is too close to market on ", g_activeSymbol);
            LockOrderSend(false);
            return;
        }
    }
    else
    {
        if(request.sl > 0 && request.sl <= entry + minDistance)
            request.sl = NormalizeDouble(entry + minDistance + ActivePoint(), ActiveDigits());
        if(request.tp > 0 && request.tp >= entry - minDistance)
            request.tp = NormalizeDouble(entry - minDistance - ActivePoint(), ActiveDigits());
        if(entry <= bid + minDistance)
        {
            LogPrint("LIMIT ENTRY BLOCKED: SELL LIMIT is too close to market on ", g_activeSymbol);
            LockOrderSend(false);
            return;
        }
    }

    request.sl = request.sl > 0 ? NormalizeDouble(request.sl, ActiveDigits()) : 0.0;
    if(request.sl > 0.0)
        tpPts = AimePreTradeTPPoints(dir, entry, request.sl, currentLot);
    if(tpPts > 0.0)
        request.tp = dir == ORDER_TYPE_BUY ? NormalizeDouble(entry + tpPts*ActivePoint(),ActiveDigits())
                                           : NormalizeDouble(entry - tpPts*ActivePoint(),ActiveDigits());
    request.tp = request.tp > 0 ? NormalizeDouble(request.tp, ActiveDigits()) : 0.0;

    if(!AimeValidatePositionSize(currentLot,dir,entry,request.sl))
    {
        LogPrint("[POSITION SIZE] LIMIT BLOCKED volume=",DoubleToString(currentLot,8)," symbol=",g_activeSymbol);
        LockOrderSend(false);
        return;
    }

    string rrReason="";
    if(!AimeRiskRewardGate(dir,currentLot,entry,request.sl,request.tp,rrReason))
    {
        LogPrint("[RR GATE] LIMIT BLOCKED: ",rrReason," | ",g_activeSymbol);
        if(EnableExecutionFeedback) g_executionRejectCount++;
        LockOrderSend(false);
        return;
    }

    if(!AimeRiskCheckNewOrder(dir, currentLot, entry, request.sl))
    {
        LockOrderSend(false);
        return;
    }

    request.volume = AimeHardCapSingleTradeLot(request.volume);
    currentLot = request.volume;
    {
        string hardGateReason = "";
        double gateRiskMoney = AimeProjectedRiskMoney(dir, currentLot, entry, request.sl);
        if(!AimeHardSafetyGateAllowsNewExposure(currentLot, gateRiskMoney, hardGateReason))
        {
            LogPrint("[HARD SAFETY] LIMIT ENTRY BLOCKED: ", hardGateReason, " | ", g_activeSymbol);
            LockOrderSend(false);
            return;
        }
    }

    if(!OrderCheck(request, checkResult))
    {
        LogPrint("LIMIT OrderCheck failed for ", g_activeSymbol, " retcode=", checkResult.retcode, " comment=", checkResult.comment);
        LockOrderSend(false);
        return;
    }

    if(AimeOrderSendWithRetry(request, result, 3) && result.retcode == TRADE_RETCODE_DONE)
    {
        double depthPts = MathAbs(ref - entry) / ActivePoint();
        LogPrint("+-----------------------------------------+");
        LogPrint("[LIMIT ENTRY PLACED] ", dir == ORDER_TYPE_BUY ? "BUY LIMIT" : "SELL LIMIT",
                 " | Anchor: ", EnumToString(LimitEntryAnchor));
        LogPrint("Price: ", entry, " | Depth: ", DoubleToString(depthPts, 0),
                 " pts (cap ", DoubleToString(LimitEntryATRFraction, 2), " ATR)");
        LogPrint("Lot: ", currentLot, " | Signal: ", DoubleToString(signalScore, 1));
        LogPrint("+-----------------------------------------+");
    }
    else
    {
        LogPrint("[LIMIT ENTRY] OrderSend failed. Retcode: ", result.retcode, " Error: ", GetLastError());
    }

    LockOrderSend(false);
}

int CountWorkingLimitOrders()
{
    int count = 0;
    for(int i = OrdersTotal() - 1; i >= 0; i--)
    {
        ulong ticket = OrderGetTicket(i);
        if(ticket == 0) continue;
        if(!OrderSelect(ticket)) continue;
        if(OrderGetInteger(ORDER_MAGIC) != ActiveMagicNumber()) continue;
        if(OrderGetString(ORDER_SYMBOL) != g_activeSymbol) continue;
        ENUM_ORDER_TYPE ot = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
        if(ot == ORDER_TYPE_BUY_LIMIT || ot == ORDER_TYPE_SELL_LIMIT) count++;
    }
    return count;
}

bool DeletePendingOrder(ulong ticket)
{
    LockOrderSend(true);
    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    request.action = TRADE_ACTION_REMOVE;
    request.order = ticket;
    bool ok = AimeOrderSendWithRetry(request, result, 3);
    if(!ok || result.retcode != TRADE_RETCODE_DONE)
        LogPrint("[LIMIT ENTRY] Cancel failed for ", ticket, " Retcode: ", result.retcode, " Error: ", GetLastError());
    LockOrderSend(false);
    return (ok && result.retcode == TRADE_RETCODE_DONE);
}

double ParseLimitEntryScore(string comment)
{
    int p = StringFind(comment, "AimeLE|");
    if(p < 0) return -1;
    return StringToDouble(StringSubstr(comment, p + 7));
}

void ManagePendingOrders()
{
    if(!EnableLimitEntry) return;

    for(int i = OrdersTotal() - 1; i >= 0; i--)
    {
        ulong ticket = OrderGetTicket(i);
        if(ticket == 0) continue;
        if(!OrderSelect(ticket)) continue;
        if(OrderGetInteger(ORDER_MAGIC) != ActiveMagicNumber()) continue;
        if(OrderGetString(ORDER_SYMBOL) != g_activeSymbol) continue;

        ENUM_ORDER_TYPE ot = (ENUM_ORDER_TYPE)OrderGetInteger(ORDER_TYPE);
        if(ot != ORDER_TYPE_BUY_LIMIT && ot != ORDER_TYPE_SELL_LIMIT) continue;

        if(LimitEntryExpiryBars > 0)
        {
            datetime setup = (datetime)OrderGetInteger(ORDER_TIME_SETUP);
            int barsElapsed = iBarShift(g_activeSymbol, g_activePeriod, setup, false);
            if(barsElapsed >= LimitEntryExpiryBars)
            {
                LogPrint("[LIMIT ENTRY] Expired after ", barsElapsed, " bar(s). Cancelling ticket ", ticket);
                DeletePendingOrder(ticket);
                continue;
            }
        }

        if(LimitEntryCancelOnFlip)
        {
            bool buy = (ot == ORDER_TYPE_BUY_LIMIT);
            SignalStrength s = GetSignalStrength(buy ? ORDER_TYPE_BUY : ORDER_TYPE_SELL);
            double thr = buy ? AimeBuySignalThreshold() : AimeSellSignalThreshold();
            if(s.finalScore < thr)
            {
                LogPrint("[LIMIT ENTRY] Signal faded (", DoubleToString(s.finalScore, 1),
                         " < ", DoubleToString(thr, 1), "). Cancelling ticket ", ticket);
                DeletePendingOrder(ticket);
            }
        }
    }
}

bool ClosePosition(ulong ticket)
{
    if(!PositionSelectByTicket(ticket))
    {
        LogPrint("Position ", ticket, " not found");
        return false;
    }
    string symbol = PositionGetString(POSITION_SYMBOL);
    long magic = (long)PositionGetInteger(POSITION_MAGIC);
    if(!IsAimeMagic(magic))
    {
        LogPrint("[CLOSE] Refusing non-Aime position ticket=", ticket, " magic=", magic);
        return false;
    }
    int idx = FindAssetIndex(symbol);
    if(idx < 0)
    {
        AimeWritePersistentLog(StringFormat("CLOSE direct-route ticket=%I64u symbol=%s reason=UNREGISTERED",ticket,symbol),"WARN");
        return ForceClosePosition(ticket);
    }
    if(!AimeValidatePositionIdentity(ticket, symbol, magic))
    {
        AimeWritePersistentLog(StringFormat("CLOSE direct-route ticket=%I64u symbol=%s reason=IDENTITY_VALIDATION",ticket,symbol),"WARN");
        return ForceClosePosition(ticket);
    }
    return ForceClosePosition(ticket);
}

void CloseAllPositions(bool unProfitableOnly = false, bool skipChainLegs = false)
{
    int attempted=0;
    int closed=0;
    for(int i=PositionsTotal()-1;i>=0;i--)
    {
        ulong ticket=PositionGetTicket(i);
        if(ticket==0 || !PositionSelectByTicket(ticket)) continue;
        if(!IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) continue;
        if(unProfitableOnly && PositionGetDouble(POSITION_PROFIT)>=0.0) continue;
        if(skipChainLegs && EnableHedgeChain && PortfolioTicketIsChainLeg(ticket)) continue;
        attempted++;
        if(ClosePosition(ticket)) closed++;
    }
    AimeReconcileAllPositions(true);
    LogPrint("[CLOSE ALL] closed=",closed," attempted=",attempted);
}

bool AimeIsRetryableTradeRetcode(uint retcode)
{
    return retcode == TRADE_RETCODE_REQUOTE ||
           retcode == TRADE_RETCODE_PRICE_CHANGED ||
           retcode == TRADE_RETCODE_PRICE_OFF ||
           retcode == TRADE_RETCODE_TIMEOUT ||
           retcode == TRADE_RETCODE_CONNECTION ||
           retcode == TRADE_RETCODE_TOO_MANY_REQUESTS ||
           retcode == TRADE_RETCODE_LOCKED;
}

void AimeRefreshMarketPrice(MqlTradeRequest &request)
{
    if(request.symbol == "" || request.action != TRADE_ACTION_DEAL)
        return;

    MqlTick t;
    if(!SymbolInfoTick(request.symbol, t))
        return;

    if(request.type == ORDER_TYPE_BUY)
        request.price = t.ask;
    else if(request.type == ORDER_TYPE_SELL)
        request.price = t.bid;
}

int AimeBuildFillingModes(string symbol, ENUM_ORDER_TYPE_FILLING &modes[])
{
    ArrayResize(modes, 0);

    uint flags = (uint)SymbolInfoInteger(symbol, SYMBOL_FILLING_MODE);
    long execution = SymbolInfoInteger(symbol, SYMBOL_TRADE_EXEMODE);

    if((flags & SYMBOL_FILLING_FOK) != 0)
    {
        int n = ArraySize(modes);
        ArrayResize(modes, n + 1);
        modes[n] = ORDER_FILLING_FOK;
    }

    if((flags & SYMBOL_FILLING_IOC) != 0)
    {
        int n = ArraySize(modes);
        ArrayResize(modes, n + 1);
        modes[n] = ORDER_FILLING_IOC;
    }

    if(execution != SYMBOL_TRADE_EXECUTION_MARKET)
    {
        int n = ArraySize(modes);
        ArrayResize(modes, n + 1);
        modes[n] = ORDER_FILLING_RETURN;
    }

    if(ArraySize(modes) == 0)
    {
        ArrayResize(modes, 1);
        modes[0] = execution == SYMBOL_TRADE_EXECUTION_MARKET
            ? ORDER_FILLING_FOK
            : ORDER_FILLING_RETURN;
    }

    return ArraySize(modes);
}

bool AimeOrderSendWithRetry(MqlTradeRequest &request, MqlTradeResult &result, int maxAttempts=3)
{
    if(request.action != TRADE_ACTION_REMOVE && request.symbol == "")
        return false;

    maxAttempts = MathMax(1, MathMin(maxAttempts, 6));
    ZeroMemory(result);

    if(request.action == TRADE_ACTION_REMOVE)
    {
        for(int attempt = 0; attempt < maxAttempts; attempt++)
        {
            ResetLastError();
            bool sent = OrderSend(request, result);
            if(sent && (result.retcode == TRADE_RETCODE_DONE ||
                        result.retcode == TRADE_RETCODE_NO_CHANGES ||
                        result.retcode == TRADE_RETCODE_PLACED))
                return true;

            if(!AimeIsRetryableTradeRetcode(result.retcode))
                return false;

            if(attempt + 1 < maxAttempts)
                Sleep(50 + attempt * 75);
        }
        return false;
    }

    if(request.action == TRADE_ACTION_SLTP)
    {
        for(int attempt = 0; attempt < maxAttempts; attempt++)
        {
            ResetLastError();
            bool sent = OrderSend(request, result);
            if(sent && (result.retcode == TRADE_RETCODE_DONE ||
                        result.retcode == TRADE_RETCODE_NO_CHANGES))
                return true;

            if(!AimeIsRetryableTradeRetcode(result.retcode))
                return false;

            if(attempt + 1 < maxAttempts)
                Sleep(50 + attempt * 75);
        }
        return false;
    }

    ENUM_ORDER_TYPE_FILLING modes[];
    int modeCount = 0;
    if(request.action == TRADE_ACTION_PENDING)
    {
        ArrayResize(modes, 1);
        modes[0] = ORDER_FILLING_RETURN;
        modeCount = 1;
    }
    else
    {
        modeCount = AimeBuildFillingModes(request.symbol, modes);
        if(modeCount <= 0) return false;
    }

    for(int attempt = 0; attempt < maxAttempts; attempt++)
    {
        request.type_filling = modes[attempt % modeCount];

        if(request.action == TRADE_ACTION_DEAL)
            AimeRefreshMarketPrice(request);

        ResetLastError();
        bool sent = OrderSend(request, result);

        if(sent && (result.retcode == TRADE_RETCODE_DONE ||
                    result.retcode == TRADE_RETCODE_DONE_PARTIAL ||
                    result.retcode == TRADE_RETCODE_PLACED ||
                    result.retcode == TRADE_RETCODE_NO_CHANGES))
            return true;

        if(result.retcode==TRADE_RETCODE_TIMEOUT || result.retcode==TRADE_RETCODE_CONNECTION)
        {
            if(request.action==TRADE_ACTION_DEAL)
            {
                Sleep(150);
                AimeReconcileAllPositions(true);
                return false;
            }
        }
        if(!AimeIsRetryableTradeRetcode(result.retcode))
            return false;

        if(attempt + 1 < maxAttempts)
            Sleep(50 + attempt * 75);
    }

    return false;
}

bool ModifyPosition(ulong ticket, double newSL, double newTP)
{
    if(!PositionSelectByTicket(ticket))
    {
        LogPrint("Error: Failed to select position #", ticket);
        return false;
    }

    string symbol = PositionGetString(POSITION_SYMBOL);
    long positionMagic = (long)PositionGetInteger(POSITION_MAGIC);
    if(!AimeValidatePositionIdentity(ticket, symbol, positionMagic))
    {
        LogPrint("[MODIFY] Position identity validation failed ticket=", ticket);
        return false;
    }
    int digits = (int)SymbolInfoInteger(symbol, SYMBOL_DIGITS);
    if(digits < 0) digits = 0;

    double currentSL = PositionGetDouble(POSITION_SL);
    double currentTP = PositionGetDouble(POSITION_TP);
    double normSL = newSL > 0.0 ? NormalizeDouble(newSL, digits) : 0.0;
    double normTP = newTP > 0.0 ? NormalizeDouble(newTP, digits) : 0.0;

    if(normSL == NormalizeDouble(currentSL, digits) && normTP == NormalizeDouble(currentTP, digits))
        return true;

    MqlTradeRequest request = {};
    MqlTradeResult result = {};
    request.action = TRADE_ACTION_SLTP;
    request.position = ticket;
    request.symbol = symbol;
    request.sl = normSL;
    request.tp = normTP;

    ResetLastError();
    bool sent = AimeOrderSendWithRetry(request, result, 3);
    bool success = sent && (result.retcode == TRADE_RETCODE_DONE || result.retcode == TRADE_RETCODE_NO_CHANGES);

    if(success)
        LogPrint("[MODIFY SUCCESS] ticket=", ticket, " symbol=", symbol, " retcode=", result.retcode);
    else
        LogPrint("[MODIFY FAILED] ticket=", ticket, " symbol=", symbol, " sent=", sent ? "true" : "false", " retcode=", result.retcode, " comment=", result.comment, " error=", GetLastError());

    return success;
}

bool AimeSymbolReady()
{
    if(!g_accountSnapshotValid && !AimeRefreshAccountSnapshot()) return false;
    if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED) || !MQLInfoInteger(MQL_TRADE_ALLOWED)) return false;
    if(SymbolInfoInteger(g_activeSymbol,SYMBOL_TRADE_MODE)==SYMBOL_TRADE_MODE_DISABLED) return false;
    if(!SymbolSelect(g_activeSymbol, true)) return false;
    if(SymbolInfoInteger(g_activeSymbol, SYMBOL_SELECT) == 0) return false;
    if(SymbolInfoDouble(g_activeSymbol, SYMBOL_POINT) <= 0.0) return false;
    if(SymbolInfoDouble(g_activeSymbol, SYMBOL_VOLUME_MIN) <= 0.0) return false;
    if(SymbolInfoDouble(g_activeSymbol, SYMBOL_VOLUME_STEP) <= 0.0) return false;
    if(SymbolInfoDouble(g_activeSymbol, SYMBOL_ASK) <= 0.0) return false;
    if(SymbolInfoDouble(g_activeSymbol, SYMBOL_BID) <= 0.0) return false;
    int idx=FindAssetIndex(g_activeSymbol);
    if(idx>=0 && !g_assets[idx].strategyDataReady) return false;
    return true;
}

double AimeActiveSpreadCap()
{
    if(!EnableMaxSpreadFilter) return 0.0;

    double cap = MaxSpreadPoints;
    if(cap > 0.0) return cap;

    if(atrSignalHandle == INVALID_HANDLE) return 0.0;

    double bufATR[];
    ArraySetAsSeries(bufATR, true);
    if(CopyBuffer(atrSignalHandle, 0, 1, 1, bufATR) < 1) return 0.0;

    double point = ActivePoint();
    if(point <= 0.0 || bufATR[0] <= 0.0) return 0.0;

    return (bufATR[0] / point) * AimeSpreadATRRatio();
}

bool AimeSpreadEntryAllowed(double signalScore, string &reason)
{
    reason = "";
    if(!EnableMaxSpreadFilter) return true;

    double spreadPoints = (double)SymbolInfoInteger(g_activeSymbol, SYMBOL_SPREAD);
    double normalCap = AimeActiveSpreadCap();
    if(normalCap <= 0.0) return true;

    double softCap = normalCap * MathMax(1.0, SpreadSoftMultiplier);
    double hardCap = normalCap * MathMax(MathMax(1.0, SpreadHardMultiplier), MathMax(1.0, SpreadSoftMultiplier));

    if(spreadPoints > hardCap)
    {
        reason = StringFormat("SPREAD %.0f > HARD %.0f", spreadPoints, hardCap);
        return false;
    }

    if(spreadPoints > normalCap)
    {
        double required = signalScore > 0.0
            ? (MathMax(AimeBuySignalThreshold(), AimeSellSignalThreshold()) + SpreadSoftSignalBuffer)
            : 0.0;

        if(spreadPoints > softCap && signalScore > 0.0 && signalScore < required)
        {
            reason = StringFormat("SPREAD %.0f HIGH | SCORE %.2f < %.2f", spreadPoints, signalScore, required);
            return false;
        }

        if(spreadPoints > softCap && signalScore <= 0.0)
        {
            reason = StringFormat("SPREAD %.0f HIGH", spreadPoints);
            return false;
        }

        LogPrint("[SPREAD] Elevated but accepted: ", DoubleToString(spreadPoints, 0),
                 " pts | normal=", DoubleToString(normalCap, 0),
                 " | hard=", DoubleToString(hardCap, 0));
    }

    return true;
}

bool IsSpreadTooWide()
{
    if(!EnableMaxSpreadFilter) return false;

    double spreadPoints = (double)SymbolInfoInteger(g_activeSymbol, SYMBOL_SPREAD);
    double normalCap = AimeActiveSpreadCap();
    if(normalCap <= 0.0) return false;

    double hardCap = normalCap * MathMax(1.0, SpreadHardMultiplier);
    if(spreadPoints > hardCap)
    {
        LogPrint("[SPREAD] Hard blocked: spread ", DoubleToString(spreadPoints, 0),
                 " pts > hard cap ", DoubleToString(hardCap, 0), " pts");
        return true;
    }

    return false;
}

void LockOrderSend(bool isLocked)
{
    isOrderSendLocked = isLocked;
}

ENUM_ORDER_TYPE_FILLING GetFillingModeForSymbol(string symbol)
{
    uint filling = (uint)SymbolInfoInteger(symbol, SYMBOL_FILLING_MODE);
    long execution = SymbolInfoInteger(symbol, SYMBOL_TRADE_EXEMODE);

    if((filling & SYMBOL_FILLING_IOC) != 0) return ORDER_FILLING_IOC;
    if((filling & SYMBOL_FILLING_FOK) != 0) return ORDER_FILLING_FOK;
    if(execution != SYMBOL_TRADE_EXECUTION_MARKET) return ORDER_FILLING_RETURN;
    return ORDER_FILLING_FOK;
}

ENUM_ORDER_TYPE_FILLING GetFillingMode()
{
    uint filling = (uint)SymbolInfoInteger(g_activeSymbol, SYMBOL_FILLING_MODE);
    long execution = SymbolInfoInteger(g_activeSymbol, SYMBOL_TRADE_EXEMODE);

    if((filling & SYMBOL_FILLING_IOC) != 0) return ORDER_FILLING_IOC;
    if((filling & SYMBOL_FILLING_FOK) != 0) return ORDER_FILLING_FOK;

    if(execution != SYMBOL_TRADE_EXECUTION_MARKET)
        return ORDER_FILLING_RETURN;

    return ORDER_FILLING_FOK;
}

bool IsSLValidForSymbol(string symbol, ENUM_POSITION_TYPE posType, double sl)
{
    double bid = SymbolInfoDouble(symbol, SYMBOL_BID);
    double ask = SymbolInfoDouble(symbol, SYMBOL_ASK);
    long stopLevel = SymbolInfoInteger(symbol, SYMBOL_TRADE_STOPS_LEVEL);
    long freezeLevel = SymbolInfoInteger(symbol, SYMBOL_TRADE_FREEZE_LEVEL);
    double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
    if(point <= 0.0 || bid <= 0.0 || ask <= 0.0) return false;

    double minDistance = MathMax(stopLevel, freezeLevel) * point;
    if(posType == POSITION_TYPE_BUY) return sl < bid - minDistance;
    return sl > ask + minDistance;
}

bool IsSLValid(ENUM_POSITION_TYPE posType, double sl)
{
    return IsSLValidForSymbol(g_activeSymbol, posType, sl);
}

double NormalizeVolume(double volume)
{
    double minVol = SymbolInfoDouble(g_activeSymbol, SYMBOL_VOLUME_MIN);
    double maxVol = SymbolInfoDouble(g_activeSymbol, SYMBOL_VOLUME_MAX);
    double stepVol = SymbolInfoDouble(g_activeSymbol, SYMBOL_VOLUME_STEP);

    volume = MathMax(volume, minVol);
    volume = MathMin(volume, maxVol);
    volume = MathRound(volume / stepVol) * stepVol;

    return volume;
}

double AimeHardCapSingleTradeLot(double proposedVolume)
{
    double minVol = SymbolInfoDouble(g_activeSymbol, SYMBOL_VOLUME_MIN);
    double maxVol = SymbolInfoDouble(g_activeSymbol, SYMBOL_VOLUME_MAX);
    double stepVol = SymbolInfoDouble(g_activeSymbol, SYMBOL_VOLUME_STEP);

    if(proposedVolume <= 0.0 || minVol <= 0.0 || stepVol <= 0.0)
        return 0.0;

    if(HardAbsoluteMaxLotPerTrade > 0.0 && HardAbsoluteMaxLotPerTrade < minVol)
    {
        LogPrint("[HARD SAFETY] No trade possible: hard lot ceiling ", DoubleToString(HardAbsoluteMaxLotPerTrade, 4),
                 " is below broker minimum ", DoubleToString(minVol, 4), " | ", g_activeSymbol);
        return 0.0;
    }

    if(HardAbsoluteMaxLotPerTrade > 0.0 && proposedVolume > HardAbsoluteMaxLotPerTrade)
    {
        LogPrint("[HARD SAFETY] Volume clamped from ", DoubleToString(proposedVolume, 4),
                 " to HardAbsoluteMaxLotPerTrade=", DoubleToString(HardAbsoluteMaxLotPerTrade, 4),
                 " | ", g_activeSymbol);
        proposedVolume = HardAbsoluteMaxLotPerTrade;
    }

    if(maxVol > 0.0)
        proposedVolume = MathMin(proposedVolume, maxVol);

    proposedVolume = MathFloor(proposedVolume / stepVol + 1e-9) * stepVol;
    if(proposedVolume < minVol - 1e-9)
        return 0.0;

    return NormalizeVolume(proposedVolume);
}

double AimeTotalAimeManagedLots()
{
    double total = 0.0;
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
        if(!IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) continue;
        total += PositionGetDouble(POSITION_VOLUME);
    }
    return total;
}

bool AimeHardSafetyGateAllowsNewExposure(double proposedVolume, double projectedRiskMoney, string &reason)
{
    if(HardAbsoluteMaxTotalLots > 0.0)
    {
        double projectedTotal = AimeTotalAimeManagedLots() + proposedVolume;
        if(projectedTotal > HardAbsoluteMaxTotalLots + 1e-9)
        {
            reason = StringFormat("HARD CAP: total managed volume would be %.2f, ceiling is %.2f",
                                   projectedTotal, HardAbsoluteMaxTotalLots);
            return false;
        }
    }

    if(HardAbsoluteMaxAccountRiskPct > 0.0)
    {
        double equity = AccountInfoDouble(ACCOUNT_EQUITY);
        if(equity > 0.0)
        {
            double existingRisk = AimePortfolioOpenRiskMoney();
            double newRisk = (projectedRiskMoney > 0.0 && projectedRiskMoney < DBL_MAX / 2.0) ? projectedRiskMoney : 0.0;
            double projectedRiskPct = ((existingRisk + newRisk) / equity) * 100.0;
            if(projectedRiskPct > HardAbsoluteMaxAccountRiskPct + 1e-9)
            {
                reason = StringFormat("HARD CAP: projected portfolio risk %.2f%% exceeds ceiling %.2f%%",
                                       projectedRiskPct, HardAbsoluteMaxAccountRiskPct);
                return false;
            }
        }
    }

    reason = "";
    return true;
}

int CountOpenOrders()
{
    int count = 0;

    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);

        if(PositionSelectByTicket(ticket))
        {
            if(PositionGetString(POSITION_SYMBOL) == g_activeSymbol &&
               PositionGetInteger(POSITION_MAGIC) == ActiveMagicNumber())
            {
                count++;
            }
        }
    }

    return count;
}

int CountOpenOrdersByType(ENUM_POSITION_TYPE posType)
{
    int count = 0;

    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);

        if(PositionSelectByTicket(ticket))
        {
            if(PositionGetString(POSITION_SYMBOL) == g_activeSymbol &&
               PositionGetInteger(POSITION_MAGIC) == ActiveMagicNumber() &&
               PositionGetInteger(POSITION_TYPE) == posType)
            {
                count++;
            }
        }
    }

    return count;
}

double CalculateBreakEvenPrice(ulong ticket, ENUM_POSITION_TYPE posType, double entryPrice, double volume)
{
    double ask = SymbolInfoDouble(g_activeSymbol, SYMBOL_ASK);
    double bid = SymbolInfoDouble(g_activeSymbol, SYMBOL_BID);
    double spread = ask - bid;

    double commission = GetPositionRoundTripCommission(ticket);

    double swap = 0;
    if(PositionSelectByTicket(ticket))
    {
        swap = PositionGetDouble(POSITION_SWAP);
    }

    double swapCost = (swap < 0) ? MathAbs(swap) : 0;

    double totalCost = commission + swapCost;

    double tickValue = SymbolInfoDouble(g_activeSymbol, SYMBOL_TRADE_TICK_VALUE);
    double tickSize = SymbolInfoDouble(g_activeSymbol, SYMBOL_TRADE_TICK_SIZE);

    double costInPrice = 0;
    double minProfitInPrice = 0;

    if(tickValue != 0 && volume != 0)
    {
        costInPrice = (totalCost / volume) * (tickSize / tickValue);

        if(MinBreakEvenProfit > 0)
            minProfitInPrice = (MinBreakEvenProfit / volume) * (tickSize / tickValue);
    }

    double breakEvenPrice;
    if(posType == POSITION_TYPE_BUY)
    {
        breakEvenPrice = entryPrice + spread + costInPrice + minProfitInPrice;
    }
    else
    {
        breakEvenPrice = entryPrice - spread - costInPrice - minProfitInPrice;
    }

    return NormalizeDouble(breakEvenPrice, ActiveDigits());
}

double GetPositionRoundTripCommission(ulong positionTicket)
{
    double entryCommission = 0.0;

    if(!HistorySelectByPosition(positionTicket)) return 0.0;

    for(int i = 0; i < HistoryDealsTotal(); i++)
    {
        ulong dealTicket = HistoryDealGetTicket(i);

        if(dealTicket > 0)
        {
            ENUM_DEAL_ENTRY dealEntry = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(dealTicket, DEAL_ENTRY);

            if(dealEntry == DEAL_ENTRY_IN)
            {
                entryCommission += HistoryDealGetDouble(dealTicket, DEAL_COMMISSION);
                break;
            }
        }
    }

    return MathAbs(entryCommission) * 2.0;
}

double ConvertToPoints(ENUM_INPUT_TYPE inputType, double value, double lotSize)
{
    double points = 0;

    switch(inputType)
    {
        case INPUT_POINTS:
            points = value;
            break;

        case INPUT_DOLLAR:
            {
                double tickValue = SymbolInfoDouble(g_activeSymbol, SYMBOL_TRADE_TICK_VALUE);
                double tickSize = SymbolInfoDouble(g_activeSymbol, SYMBOL_TRADE_TICK_SIZE);
                double point = SymbolInfoDouble(g_activeSymbol, SYMBOL_POINT);

                if(tickValue > 0 && tickSize > 0 && lotSize > 0 && point > 0)
                {
                    double normalizedTickValue = tickValue * lotSize;
                    double pointsPerTick = tickSize / point;

                    if(pointsPerTick <= 0)
                    {
                        LogPrint("Error: Invalid pointsPerTick (", pointsPerTick, ")");
                        return 0;
                    }

                    double valuePerPoint = normalizedTickValue / pointsPerTick;

                    points = value / valuePerPoint;
                }
                else
                {
                    LogPrint("Error: Invalid tick value (", tickValue, "), tick size (", tickSize, "), point (", point, "), or lot size (", lotSize, ")");
                }
            }
            break;

        case INPUT_PERCENT:
            {
                double equity = AccountInfoDouble(ACCOUNT_EQUITY);
                double dollarAmount = equity * (value / 100.0);

                double tickValue = SymbolInfoDouble(g_activeSymbol, SYMBOL_TRADE_TICK_VALUE);
                double tickSize = SymbolInfoDouble(g_activeSymbol, SYMBOL_TRADE_TICK_SIZE);
                double point = SymbolInfoDouble(g_activeSymbol, SYMBOL_POINT);

                if(tickValue > 0 && tickSize > 0 && lotSize > 0 && point > 0)
                {
                    double normalizedTickValue = tickValue * lotSize;
                    double pointsPerTick = tickSize / point;

                    if(pointsPerTick <= 0)
                    {
                        LogPrint("Error: Invalid pointsPerTick in percent conversion (", pointsPerTick, ")");
                        return 0;
                    }

                    double valuePerPoint = normalizedTickValue / pointsPerTick;

                    points = dollarAmount / valuePerPoint;
                }
                else
                {
                    LogPrint("Error: Invalid parameters for percent conversion");
                }
            }
            break;
    }

    return points;
}

double GetCurrentATR()
{
    double buf[];
    ArraySetAsSeries(buf, true);
    if(CopyBuffer(atrSignalHandle, 0, 1, 1, buf) < 1) return 0;
    return buf[0];
}

double GetRRRiskPoints(double lotSize)
{
    if(RRRiskMode == RR_RISK_ATR)
    {
        double atr = GetCurrentATR();
        if(atr <= 0 || ActivePoint() <= 0) return 0;
        double atrPoints = atr / ActivePoint();
        return atrPoints * RRAtrMultiplier;
    }

    return ConvertToPoints(RRRiskInputType, RRRiskValue, lotSize);
}

double GetSLPoints(double lotSize)
{
    if(EnableRiskReward)
        return GetRRRiskPoints(lotSize);

    if(EnableStopLoss)
        return ConvertToPoints(SLInputType, SLValue, lotSize);

    return 0;
}

double GetTPPoints(double lotSize)
{
    if(EnableRiskReward)
    {
        double slPts = GetRRRiskPoints(lotSize);
        if(slPts > 0 && RiskRewardRatio > 0)
            return slPts * RiskRewardRatio;
        return 0;
    }

    if(EnableTakeProfit)
        return ConvertToPoints(TPInputType, TPValue, lotSize);

    return 0;
}

string IsHighImpactNewsTime(int minutesBefore, int minutesAfter, ulong &eventID)
{
    MqlCalendarValue values[];

    datetime serverTime = TimeTradeServer();

    int lookRange = (int)MathMax(minutesBefore, minutesAfter);
    datetime start = serverTime - lookRange * 60;
    datetime end = serverTime + lookRange * 60 + 120;

    if(CalendarValueHistory(values, start, end))
    {
        for(int i = 0; i < ArraySize(values); i++)
        {
            MqlCalendarEvent event;
            if(CalendarEventById(values[i].event_id, event))
            {
                if(event.importance == CALENDAR_IMPORTANCE_HIGH)
                {
                    MqlCalendarCountry country;
                    CalendarCountryById(event.country_id, country);

                    if(country.currency != symbolBaseCurrency &&
                       country.currency != symbolQuoteCurrency)
                    {
                        continue;
                    }

                    datetime eventTime = values[i].time;
                    datetime pauseStart = eventTime - minutesBefore * 60;
                    datetime pauseEnd = eventTime + minutesAfter * 60;

                    if(serverTime < pauseStart || serverTime > pauseEnd)
                    {
                        continue;
                    }

                    eventID = values[i].event_id;

                    int secondsUntil = (int)(eventTime - serverTime);
                    int minutesUntil = secondsUntil / 60;

                    string eventDetails = "";
                    eventDetails += "**Event Name:** " + event.name + "\n";
                    eventDetails += "**Country:** " + country.name + " (" + country.code + ")\n";
                    eventDetails += "**Currency:** " + country.currency + "\n";
                    eventDetails += "**Event Time:** " + TimeToString(eventTime, TIME_DATE|TIME_SECONDS) + "\n";
                    eventDetails += "**Time Until:** " + IntegerToString(minutesUntil) + " minutes\n";

                    if(values[i].HasActualValue())
                        eventDetails += "**Actual:** " + DoubleToString(values[i].GetActualValue(), 2) + "\n";
                    if(values[i].HasForecastValue())
                        eventDetails += "**Forecast:** " + DoubleToString(values[i].GetForecastValue(), 2) + "\n";
                    if(values[i].HasPreviousValue())
                        eventDetails += "**Previous:** " + DoubleToString(values[i].GetPreviousValue(), 2) + "\n";

                    eventDetails += "**Importance:** " + EnumToString(event.importance) + "\n";
                    eventDetails += "**Pause Window:** " + TimeToString(pauseStart, TIME_SECONDS) +
                                   " to " + TimeToString(pauseEnd, TIME_SECONDS);

                    LogPrint("High impact event for ", country.currency, ": ", event.name);

                    return eventDetails;
                }
            }
        }
    }

    eventID = 0;
    return "";
}

bool IsWithinTradingHours()
{
    if(!EnableTradingHours) return true;

    datetime currentTime = TimeTradeServer();
    MqlDateTime timeStruct;
    TimeToStruct(currentTime, timeStruct);

    int currentMinutes = timeStruct.hour * 60 + timeStruct.min;

    string startParts[];

    int startCount = StringSplit(TradingStartTime, ':', startParts);
    if(startCount != 2)
    {
        LogPrint("ERROR: Invalid TradingStartTime format. Use HH:MM");
        return false;
    }

    int startHour = (int)StringToInteger(startParts[0]);
    int startMin = (int)StringToInteger(startParts[1]);
    int startMinutes = startHour * 60 + startMin;

    string endParts[];

    int endCount = StringSplit(TradingEndTime, ':', endParts);
    if(endCount != 2)
    {
        LogPrint("ERROR: Invalid TradingEndTime format. Use HH:MM");
        return false;
    }

    int endHour = (int)StringToInteger(endParts[0]);
    int endMin = (int)StringToInteger(endParts[1]);
    int endMinutes = endHour * 60 + endMin;

    if(startMinutes > endMinutes)
    {
        return (currentMinutes >= startMinutes || currentMinutes <= endMinutes);
    }
    else
    {
        return (currentMinutes >= startMinutes && currentMinutes <= endMinutes);
    }
}

void CheckPeakEquity()
{
    double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);

    if(peakEquity <= 0.0)
    {
        peakEquity = currentEquity;
        lastPeakEquity = currentEquity;
        LogPrint("Equity baseline initialized at: $", peakEquity);
        return;
    }

    if(currentEquity > peakEquity)
    {
        peakEquity = currentEquity;
        lastPeakEquity = currentEquity;

        if (ResetOnNewPeak) minEquityTriggerCount = 0;

        LogPrint("New Peak Equity reached: $", peakEquity);

        if(isPaused && g_pauseReason == "EQUITY DRAWDOWN")
        {
            ClearPauseState("EQUITY DRAWDOWN");
            LogPrint("Trading RESUMED - Equity recovered above peak!");
        }
    }
}

void CheckTargetEquity()
{
    double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);

    if(TargetEquity > 0 && !targetEquityReached && currentEquity >= TargetEquity)
    {
        targetEquityReached = true;

        LogPrint("+-----------------------------------------+");
        LogPrint("TARGET EQUITY REACHED!");
        LogPrint("Current Equity: $", currentEquity);
        LogPrint("Target Equity: $", TargetEquity);
        LogPrint("Closing ALL positions and stopping trading...");
        LogPrint("+-----------------------------------------+");

        if(EnableDiscordAlerts)
        {
            string alertMsg = "**Instrument:** " + g_activeSymbol + "\n";
            alertMsg += "**Timeframe:** " + EnumToString(g_activePeriod) + "\n";
            alertMsg += "**Server Time:** " + TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS) + "\n";
            alertMsg += "**Current Equity:** $" + DoubleToString(currentEquity, 2) + "\n";
            alertMsg += "**Target Equity:** $" + DoubleToString(TargetEquity, 2) + "\n";
            alertMsg += "**Peak Equity:** $" + DoubleToString(peakEquity, 2) + "\n";
            alertMsg += "**Profit:** $" + DoubleToString(TargetEquity - initialBalance, 2) + "\n";
            alertMsg += "**Action:** All Positions Closed, Trading Stopped!";

            SendDiscordAlert("🎯 TARGET EQUITY REACHED!", alertMsg, 5763719);
        }

        Alert("TARGET EQUITY REACHED! Closing all positions and stopping trading.");
    }
}

void CheckMinTradeableEquity()
{
    double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);

    if(MinimumEquity > 0 && !minimumEquityReached && currentEquity <= MinimumEquity)
    {
        minimumEquityReached = true;
        LogPrint("+-----------------------------------------+");
        LogPrint("MINIMUM TRADEABLE EQUITY REACHED!");
        LogPrint("Current Equity: $", currentEquity);
        LogPrint("Minimum Equity: $", MinimumEquity);
        LogPrint("Closing ALL positions and stopping trading...");
        LogPrint("+-----------------------------------------+");

        if(EnableDiscordAlerts)
        {
            string alertMsg = "**Instrument:** " + g_activeSymbol + "\n";
            alertMsg += "**Timeframe:** " + EnumToString(g_activePeriod) + "\n";
            alertMsg += "**Server Time:** " + TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS) + "\n";
            alertMsg += "**Current Equity:** $" + DoubleToString(currentEquity, 2) + "\n";
            alertMsg += "**Minimum Equity:** $" + DoubleToString(MinimumEquity, 2) + "\n";
            alertMsg += "**Peak Equity:** $" + DoubleToString(peakEquity, 2) + "\n";
            alertMsg += "**Loss:** $" + DoubleToString(initialBalance - currentEquity, 2) + "\n";
            alertMsg += "**Action:** All Positions Closed, Trading Stopped!";

            SendDiscordAlert("🔴 MINIMUM TRADEABLE EQUITY REACHED", alertMsg, 15158332);
        }

        Alert("MINIMUM TRADEABLE EQUITY REACHED! Closing all positions and stopping trading.");
    }
}

void CheckEquityDrawdawn()
{
    double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);

    double drawdownFromPercent = lastPeakEquity * ((100.0 - MinEquityPercent) / 100.0);

    double allowedDrawdown = (MaxDrawdownFromPeak > 0) ?
    MathMin(drawdownFromPercent, MaxDrawdownFromPeak)
    : drawdownFromPercent;

    double minAllowedEquity = lastPeakEquity - allowedDrawdown;

    if(currentEquity < minAllowedEquity)
    {
        if(!isPaused)
        {
            minEquityTriggerCount++;

            if(MaxMinEquityTriggers > 0 && minEquityTriggerCount > MaxMinEquityTriggers)
            {
                minEquityTriggersExceeded = true;
                LogPrint("+-----------------------------------------+" );
                LogPrint("MAX MIN EQUITY TRIGGERS EXCEEDED!");
                LogPrint("Triggers Used: ", minEquityTriggerCount, " / ", MaxMinEquityTriggers);
                LogPrint("Closing ALL positions and STOPPING TRADING...");
                LogPrint("+-----------------------------------------+" );

                if(EnableDiscordAlerts)
                {
                    string alertMsg = "**Instrument:** " + g_activeSymbol + "\n";
                    alertMsg += "**Timeframe:** " + EnumToString(g_activePeriod) + "\n";
                    alertMsg += "**Server Time:** " + TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS) + "\n";
                    alertMsg += "**Current Equity:** $" + DoubleToString(currentEquity, 2) + "\n";
                    alertMsg += "**Peak Equity:** $" + DoubleToString(lastPeakEquity, 2) + "\n";
                    alertMsg += "**Triggers Used:** " + IntegerToString(minEquityTriggerCount) + " / " + IntegerToString(MaxMinEquityTriggers) + "\n";
                    alertMsg += "**Action:** All Positions Closed, Trading Stopped!";

                    SendDiscordAlert("🔴 MAX MIN EQUITY TRIGGERS EXCEEDED", alertMsg, 15158332);
                }

                Alert("MAX MIN EQUITY TRIGGERS EXCEEDED! Closing all positions and stopping trading.");
                return;
            }

            double calculatedDuration = PauseMinutes * MathPow(PauseMinutesMultiplier, minEquityTriggerCount - 1);
            if(calculatedDuration > INT_MAX) calculatedDuration = INT_MAX;
            int pauseMinutes = (int)MathMin(calculatedDuration, MaxPauseMinutes > 0 ? MaxPauseMinutes : INT_MAX);
            SetTemporaryPauseState("EQUITY DRAWDOWN", pauseMinutes);

            totalPauseCount++;
            totalPauseDurationMinutes += currentPauseDuration;

            double equityDrop = lastPeakEquity - currentEquity;
            double equityDropPercent = (equityDrop / lastPeakEquity) * 100.0;

            double oldPeakEquity = lastPeakEquity;

            lastPeakEquity = AccountInfoDouble(ACCOUNT_BALANCE);

            LogPrint("+-----------------------------------------+");
            LogPrint("EQUITY PROTECTION TRIGGERED!");
            LogPrint("Current Equity: $", currentEquity);
            LogPrint("Peak Equity: $", peakEquity);
            LogPrint("Old Peak Equity: $", oldPeakEquity);
            LogPrint("New Peak Equity (Balance): $", lastPeakEquity);
            LogPrint("Min Allowed (", MinEquityPercent, "%): $", minAllowedEquity);
            LogPrint("Trading PAUSED for ", currentPauseDuration, " minutes");
            LogPrint("Resume Time: ", TimeToString(pauseStartTime + currentPauseDuration * 60));
            LogPrint("+-----------------------------------------+");

            if(EnableDiscordAlerts)
            {
                string alertMsg = "**Instrument:** " + g_activeSymbol + "\n";
                alertMsg += "**Timeframe:** " + EnumToString(g_activePeriod) + "\n";
                alertMsg += "**Server Time:** " + TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS) + "\n";
                alertMsg += "**Current Equity:** $" + DoubleToString(currentEquity, 2) + "\n";
                alertMsg += "**Peak Equity:** $" + DoubleToString(peakEquity, 2) + "\n";
                alertMsg += "**Previous Peak:** $" + DoubleToString(oldPeakEquity, 2) + "\n";
                alertMsg += "**New Peak (Balance):** $" + DoubleToString(lastPeakEquity, 2) + "\n";
                alertMsg += "**Equity Drop:** $" + DoubleToString(equityDrop, 2) + " (" + DoubleToString(equityDropPercent, 2) + "%)\n";
                alertMsg += "**Min Allowed (" + DoubleToString(MinEquityPercent, 0) + "%):** $" + DoubleToString(minAllowedEquity, 2) + "\n";
                alertMsg += "**Trading Paused:** " + IntegerToString(currentPauseDuration) + " minutes\n";
                alertMsg += "**Resume Time:** " + TimeToString(pauseStartTime + currentPauseDuration * 60) + "\n";
                alertMsg += "**Action:** Trading Paused";

                SendDiscordAlert("⚠️ MINIMUM EQUITY PROTECTION TRIGGERED", alertMsg, 16705372);
            }
        }
    }
}

void CheckHighImpactNews()
{
    if(!EnableNewsFilter) return;

    ulong newsEventID = 0;
    string newsDetails = IsHighImpactNewsTime(NewsMinutesBefore, NewsMinutesAfter, newsEventID);

    if(!isPaused && newsDetails != "" && lastProcessedNewsEventID != newsEventID)
    {
        lastProcessedNewsEventID = newsEventID;

        datetime eventTime = 0;
        datetime currentServerTime = TimeTradeServer();
        MqlCalendarValue values[];

        if(CalendarValueHistory(values, currentServerTime - NewsMinutesBefore * 60, currentServerTime + NewsMinutesAfter * 60 + 120))
        {
            for(int i = 0; i < ArraySize(values); i++)
            {
                if(values[i].event_id == newsEventID)
                {
                    eventTime = values[i].time;
                    break;
                }
            }
        }

        if(eventTime > 0)
        {
            int secondsUntilEventEnd = (int)((eventTime + NewsMinutesAfter * 60) - currentServerTime);
            currentPauseDuration = (secondsUntilEventEnd / 60) + 1;
        }
        else
        {
            currentPauseDuration = NewsMinutesAfter;
        }

        SetTemporaryPauseState("HIGH-IMPACT NEWS", currentPauseDuration);
        totalPauseCount++;
        totalPauseDurationMinutes += currentPauseDuration;

        double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);

        LogPrint("+-----------------------------------------+");
        LogPrint("HIGH-IMPACT NEWS EVENT DETECTED!");
        LogPrint("Server Time: ", TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS));
        LogPrint("Current Equity: $", currentEquity);
        LogPrint("Trading PAUSED for ", currentPauseDuration, " minutes");
        LogPrint("Resume Time: ", TimeToString(pauseStartTime + currentPauseDuration * 60));
        LogPrint("+-----------------------------------------+");

        if(EnableDiscordAlerts)
        {
            string alertMsg =  newsDetails + "\n\n";

            alertMsg += "**Instrument:** " + g_activeSymbol + "\n";
            alertMsg += "**Timeframe:** " + EnumToString(g_activePeriod) + "\n";
            alertMsg += "**Server Time:** " + TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS) + "\n";
            alertMsg += "**Current Equity:** $" + DoubleToString(currentEquity, 2) + "\n";
            alertMsg += "**Peak Equity:** $" + DoubleToString(peakEquity, 2) + "\n";
            alertMsg += "**Trading Paused:** " + IntegerToString(currentPauseDuration) + " minutes\n";
            alertMsg += "**Resume Time:** " + TimeToString(pauseStartTime + currentPauseDuration * 60) + "\n";
            alertMsg += "**Action:** Trading Paused";

            SendDiscordAlert("⚠️ HIGH-IMPACT NEWS DETECTED!", alertMsg, 16705372);
        }
    }
}

void CheckTradingHours()
{
    if(!EnableTradingHours) return;

    bool currentlyWithinHours = IsWithinTradingHours();

    if(isOutsideTradingHours && currentlyWithinHours)
    {
        isOutsideTradingHours = false;

        double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);

        LogPrint("+-----------------------------------------+");
        LogPrint("TRADING HOURS STARTED");
        LogPrint("Server Time: ", TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS));
        LogPrint("Trading Period: ", TradingStartTime, " - ", TradingEndTime);
        LogPrint("Current Equity: $", currentEquity);
        LogPrint("+-----------------------------------------+");

        if(EnableDiscordAlerts)
        {
            string alertMsg = "**Instrument:** " + g_activeSymbol + "\n";
            alertMsg += "**Timeframe:** " + EnumToString(g_activePeriod) + "\n";
            alertMsg += "**Server Time:** " + TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS) + "\n";
            alertMsg += "**Trading Period:** " + TradingStartTime + " - " + TradingEndTime + "\n";
            alertMsg += "**Current Equity:** $" + DoubleToString(currentEquity, 2) + "\n";
            alertMsg += "**Peak Equity:** $" + DoubleToString(peakEquity, 2) + "\n";
            alertMsg += "**Action:** Trading Started";

            SendDiscordAlert("🟢 TRADING HOURS STARTED!", alertMsg, 5763719);
        }
    }

    else if(!isOutsideTradingHours && !currentlyWithinHours)
    {
        isOutsideTradingHours = true;

        double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);

        LogPrint("+-----------------------------------------+");
        LogPrint("TRADING HOURS ENDED");
        LogPrint("Server Time: ", TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS));
        LogPrint("Trading Period: ", TradingStartTime, " - ", TradingEndTime);
        LogPrint("Current Equity: $", currentEquity);
        LogPrint("+-----------------------------------------+");

        if(EnableDiscordAlerts)
        {
            string alertMsg = "**Instrument:** " + g_activeSymbol + "\n";
            alertMsg += "**Timeframe:** " + EnumToString(g_activePeriod) + "\n";
            alertMsg += "**Server Time:** " + TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS) + "\n";
            alertMsg += "**Trading Period:** " + TradingStartTime + " - " + TradingEndTime + "\n";
            alertMsg += "**Current Equity:** $" + DoubleToString(currentEquity, 2) + "\n";
            alertMsg += "**Peak Equity:** $" + DoubleToString(peakEquity, 2) + "\n";
            alertMsg += "**Action:** Trading Stopped";

            SendDiscordAlert("🔴 TRADING HOURS ENDED!", alertMsg, 15158332);

            SendTradeReport();
        }
    }
}

void CheckMarketClose()
{
    if(!EnableMarketCloseFilter || MinutesBeforeClose <= 0) return;

    MqlDateTime dt;
    TimeCurrent(dt);
    ENUM_DAY_OF_WEEK dayOfWeek = (ENUM_DAY_OF_WEEK)dt.day_of_week;

    datetime from, to;
    datetime currentTime = TimeCurrent();

    if(SymbolInfoSessionQuote(g_activeSymbol, dayOfWeek, 0, from, to))
    {
        int secondsUntilClose = (int)(to - currentTime);
        int minutesUntilClose = secondsUntilClose / 60;

        if(minutesUntilClose > 0 && minutesUntilClose <= MinutesBeforeClose)
        {
            if(!marketCloseAlertSent && EnableDiscordAlerts)
            {
                double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);

                string alertMsg = "**Instrument:** " + g_activeSymbol + "\n";
                alertMsg += "**Timeframe:** " + EnumToString(g_activePeriod) + "\n";
                alertMsg += "**Server Time:** " + TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS) + "\n";
                alertMsg += "**Market Closes In:** " + IntegerToString(minutesUntilClose) + " minutes\n";
                alertMsg += "**Market Close Time:** " + TimeToString(to, TIME_DATE|TIME_MINUTES) + "\n";
                alertMsg += "**Current Equity:** $" + DoubleToString(currentEquity, 2) + "\n";
                alertMsg += "**Peak Equity:** $" + DoubleToString(peakEquity, 2) + "\n";
                alertMsg += "**Action:** Stopped Opening New Positions";

                SendDiscordAlert("⏰ MARKET CLOSING SOON", alertMsg, 16776960);
                marketCloseAlertSent = true;
            }

            LogPrint("Market closes in ", minutesUntilClose, " minutes. Not opening new positions.");
            isNearMarketClose = true;
            return;
        }

        if(minutesUntilClose > MinutesBeforeClose)
        {
            isNearMarketClose = false;
            marketCloseAlertSent = false;
            return;
        }

        if(currentTime >= to)
        {
            datetime from2, to2;
            if(SymbolInfoSessionQuote(g_activeSymbol, dayOfWeek, 1, from2, to2))
            {
                secondsUntilClose = (int)(to2 - currentTime);
                minutesUntilClose = secondsUntilClose / 60;

                if(minutesUntilClose > 0 && minutesUntilClose <= MinutesBeforeClose)
                {
                    LogPrint("Market closes in ", minutesUntilClose, " minutes. Not opening new positions.");
                    isNearMarketClose = true;
                    return;
                }

                if(minutesUntilClose > MinutesBeforeClose)
                {
                    isNearMarketClose = false;
                    return;
                }
            }
        }
    }

    isNearMarketClose = false;
}

void CheckLeverageChange()
{
    if(!EnableLeveragePause) return;

    long currentLeverage = AccountInfoInteger(ACCOUNT_LEVERAGE);

    if(currentLeverage != initialLeverage && !isLeverageDiffFromInitial)
    {
        isLeverageDiffFromInitial = true;
        SetPersistentPauseState("LEVERAGE CHANGE");

        double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);

        LogPrint("+-----------------------------------------+");
        LogPrint("LEVERAGE CHANGE DETECTED - TRADING PAUSED");
        LogPrint("Initial Leverage: 1:", (int)initialLeverage);
        LogPrint("Current Leverage: 1:", (int)currentLeverage);
        LogPrint("Current Equity: $", currentEquity);
        LogPrint("Trading will resume when leverage returns to 1:", (int)initialLeverage);
        LogPrint("+-----------------------------------------+");

        if(EnableDiscordAlerts)
        {
            string alertMsg = "**Instrument:** " + g_activeSymbol + "\n";
            alertMsg += "**Timeframe:** " + EnumToString(g_activePeriod) + "\n";
            alertMsg += "**Server Time:** " + TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS) + "\n";
            alertMsg += "**Initial Leverage:** 1:" + IntegerToString((int)initialLeverage) + "\n";
            alertMsg += "**Current Leverage:** 1:" + IntegerToString((int)currentLeverage) + "\n";
            alertMsg += "**Current Equity:** $" + DoubleToString(currentEquity, 2) + "\n";
            alertMsg += "**Peak Equity:** $" + DoubleToString(peakEquity, 2) + "\n";
            alertMsg += "**Action:** Trading Paused";

            SendDiscordAlert("⚠️ LEVERAGE CHANGE - TRADING PAUSED", alertMsg, 16705372);
        }

        CloseAllPositions();
    }

    else if(currentLeverage == initialLeverage && isLeverageDiffFromInitial)
    {
        isLeverageDiffFromInitial = false;
        ClearPauseState("LEVERAGE CHANGE");

        double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);

        LogPrint("+-----------------------------------------+");
        LogPrint("LEVERAGE RESTORED - TRADING RESUMED");
        LogPrint("Leverage: 1:", (int)currentLeverage);
        LogPrint("Current Equity: $", currentEquity);
        LogPrint("+-----------------------------------------+");

        if(EnableDiscordAlerts)
        {
            string alertMsg = "**Instrument:** " + g_activeSymbol + "\n";
            alertMsg += "**Timeframe:** " + EnumToString(g_activePeriod) + "\n";
            alertMsg += "**Server Time:** " + TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS) + "\n";
            alertMsg += "**Leverage:** 1:" + IntegerToString((int)currentLeverage) + "\n";
            alertMsg += "**Current Equity:** $" + DoubleToString(currentEquity, 2) + "\n";
            alertMsg += "**Peak Equity:** $" + DoubleToString(peakEquity, 2) + "\n";
            alertMsg += "**Action:** Trading Resumed";

            SendDiscordAlert("▶️ LEVERAGE RESTORED - TRADING RESUMED", alertMsg, 3066993);
        }
    }
}

void CheckTradeReport()
{
    if (!EnableReports) return;

    datetime serverTime = TimeTradeServer();
    MqlDateTime dt;
    TimeToStruct(serverTime, dt);

    bool sendReport = false;

    if (SendReportEveryHour > 0)
    {
        if (lastDailyReportTime == 0)
        {
            lastDailyReportTime = serverTime;
        }
        else if (serverTime - lastDailyReportTime >= SendReportEveryHour * 3600)
        {
            sendReport = true;
        }
    }

    if(!EnableTradingHours && dt.hour == 23 && dt.min == 59)
    {
        MqlDateTime lastReportDt;
        TimeToStruct(lastDailyReportTime, lastReportDt);

        if(lastReportDt.day != dt.day)
        {
            sendReport = true;
        }
    }

    if (sendReport)
    {
        SendTradeReport();
    }
}

void GetTradeStats(TradeStats& daily, TradeStats& allTime)
{
    datetime now=TimeCurrent();
    if(g_tradeStatsCacheValid && now>=g_tradeStatsCacheTime && now-g_tradeStatsCacheTime<5)
    {
        daily=g_cachedDailyStats;
        allTime=g_cachedAllTimeStats;
        return;
    }
    daily.count=0; daily.won=0; daily.lost=0; daily.profit=0; daily.loss=0; daily.avgProfit=0; daily.maxProfit=0; daily.minProfit=DBL_MAX; daily.avgLoss=0; daily.maxLoss=0; daily.minLoss=-DBL_MAX;
    allTime.count=0; allTime.won=0; allTime.lost=0; allTime.profit=0; allTime.loss=0; allTime.avgProfit=0; allTime.maxProfit=0; allTime.minProfit=DBL_MAX; allTime.avgLoss=0; allTime.maxLoss=0; allTime.minLoss=-DBL_MAX;
    datetime dayStart=AimeRiskDayStart(now);
    if(!HistorySelect(0,now)) return;
    int deals=HistoryDealsTotal();
    for(int i=0;i<deals;i++)
    {
        ulong ticket=HistoryDealGetTicket(i);
        if(ticket==0) continue;
        long magic=HistoryDealGetInteger(ticket,DEAL_MAGIC);
        if(!IsAimeMagic(magic)) continue;
        long entry=HistoryDealGetInteger(ticket,DEAL_ENTRY);
        if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_INOUT) continue;
        double profit=HistoryDealGetDouble(ticket,DEAL_PROFIT)+HistoryDealGetDouble(ticket,DEAL_SWAP)+HistoryDealGetDouble(ticket,DEAL_COMMISSION);
        datetime t=(datetime)HistoryDealGetInteger(ticket,DEAL_TIME);
        allTime.count++;
        if(profit>=0.0) { allTime.won++; allTime.profit+=profit; if(profit>allTime.maxProfit) allTime.maxProfit=profit; if(profit<allTime.minProfit) allTime.minProfit=profit; }
        else { allTime.lost++; allTime.loss+=profit; if(profit<allTime.maxLoss) allTime.maxLoss=profit; if(profit>allTime.minLoss) allTime.minLoss=profit; }
        if(t>=dayStart)
        {
            daily.count++;
            if(profit>=0.0) { daily.won++; daily.profit+=profit; if(profit>daily.maxProfit) daily.maxProfit=profit; if(profit<daily.minProfit) daily.minProfit=profit; }
            else { daily.lost++; daily.loss+=profit; if(profit<daily.maxLoss) daily.maxLoss=profit; if(profit>daily.minLoss) daily.minLoss=profit; }
        }
    }
    if(allTime.won>0) allTime.avgProfit=allTime.profit/allTime.won; else allTime.minProfit=0;
    if(allTime.lost>0) allTime.avgLoss=allTime.loss/allTime.lost; else { allTime.minLoss=0; allTime.maxLoss=0; }
    if(daily.won>0) daily.avgProfit=daily.profit/daily.won; else daily.minProfit=0;
    if(daily.lost>0) daily.avgLoss=daily.loss/daily.lost; else { daily.minLoss=0; daily.maxLoss=0; }
    g_cachedDailyStats=daily;
    g_cachedAllTimeStats=allTime;
    g_tradeStatsCacheTime=now;
    g_tradeStatsCacheValid=true;
}

void AimeRefreshSymbolPerformance(int assetIndex)
{
    if(assetIndex < 0 || assetIndex >= g_assetCount) return;

    datetime now = TimeCurrent();
    int interval = MathMax(30, PerformanceGateRecalcSeconds);
    if(g_assets[assetIndex].perfLastCalcTime > 0 && (now - g_assets[assetIndex].perfLastCalcTime) < interval)
        return;

    string sym = g_assets[assetIndex].symbol;
    double grossWin = 0.0, grossLoss = 0.0;
    int tradeCount = 0;

    if(HistorySelect(0, now))
    {
        int deals = HistoryDealsTotal();
        for(int i = 0; i < deals; i++)
        {
            ulong ticket = HistoryDealGetTicket(i);
            if(ticket == 0) continue;
            if(HistoryDealGetString(ticket, DEAL_SYMBOL) != sym) continue;
            if(!IsAimeMagic(HistoryDealGetInteger(ticket, DEAL_MAGIC))) continue;
            long entry = HistoryDealGetInteger(ticket, DEAL_ENTRY);
            if(entry != DEAL_ENTRY_OUT && entry != DEAL_ENTRY_INOUT) continue;

            double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT) + HistoryDealGetDouble(ticket, DEAL_SWAP) + HistoryDealGetDouble(ticket, DEAL_COMMISSION);
            tradeCount++;
            if(profit >= 0.0) grossWin += profit;
            else grossLoss += MathAbs(profit);
        }
    }

    g_assets[assetIndex].perfTradeCount = tradeCount;
    g_assets[assetIndex].perfProfitFactor = (grossLoss > 0.0) ? (grossWin / grossLoss) : (grossWin > 0.0 ? DBL_MAX : -1.0);
    g_assets[assetIndex].perfLastCalcTime = now;
}

bool AimePerformanceGateAllows(int assetIndex, string &reason)
{
    if(!EnablePerformanceGate || assetIndex < 0 || assetIndex >= g_assetCount)
        return true;

    AimeRefreshSymbolPerformance(assetIndex);

    if(g_assets[assetIndex].perfTradeCount < MathMax(1, MinTradesForPerformanceGate))
        return true; 

    double pf = g_assets[assetIndex].perfProfitFactor;
    if(pf >= 0.0 && pf < MinAcceptableProfitFactor)
    {
        reason = StringFormat("PERFORMANCE GATE: %s profit factor %.2f < %.2f over %d trades",
                               g_assets[assetIndex].symbol, pf, MinAcceptableProfitFactor, g_assets[assetIndex].perfTradeCount);
        return false;
    }
    return true;
}

void SendTradeReport()
{
    if(!EnableDiscordAlerts) return;

    double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
    double balance = AccountInfoDouble(ACCOUNT_BALANCE);
    double deposit = initialBalance;

    TradeStats dailyStats;
    TradeStats allTimeStats;
    GetTradeStats(dailyStats, allTimeStats);

    double sessionNetProfit = dailyStats.profit + dailyStats.loss;
    double sessionNetPercent = (balance > 0) ? (sessionNetProfit / balance) * 100.0 : 0.0;

    double allTimeNetProfit = allTimeStats.profit + allTimeStats.loss;
    double allTimeNetPercent = (deposit > 0) ? (allTimeNetProfit / deposit) * 100.0 : 0.0;

    double profitPercent = (balance > 0) ? (allTimeStats.profit / balance) * 100.0 : 0.0;
    double lossPercent = (balance > 0) ? (allTimeStats.loss / balance) * 100.0 : 0.0;

    long durationSeconds = TimeCurrent() - startTime;
    int days = (int)(durationSeconds / 86400);
    int hours = (int)((durationSeconds % 86400) / 3600);
    int minutes = (int)((durationSeconds % 3600) / 60);
    string durationStr = "";
    if(days > 0) durationStr += IntegerToString(days) + "d ";
    if(hours > 0) durationStr += IntegerToString(hours) + "h ";
    durationStr += IntegerToString(minutes) + "m";

    long reportInterval = (lastDailyReportTime > 0) ? (TimeCurrent() - lastDailyReportTime) : durationSeconds;
    int rHours = (int)(reportInterval / 3600);
    int rMinutes = (int)((reportInterval % 3600) / 60);
    string reportDurationStr = "";
    if(rHours > 0) reportDurationStr += IntegerToString(rHours) + "h ";
    reportDurationStr += IntegerToString(rMinutes) + "m";

    string alertMsg = "**Instrument:** " + g_activeSymbol + "\n";
    alertMsg += "**Timeframe:** " + EnumToString(g_activePeriod) + "\n";
    alertMsg += "**Server Time:** " + TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS) + "\n";
    alertMsg += "**Peak Equity:** $" + DoubleToString(peakEquity, 2) + "\n";
    alertMsg += "**Previous Report Equity:** $" + DoubleToString(lastReportEquity, 2) + "\n";
    alertMsg += "**Current Equity:** $" + DoubleToString(currentEquity, 2) + "\n";
    alertMsg += "**Initial Balance:** $" + DoubleToString(deposit, 2) + "\n";
    alertMsg += "**Current Balance:** $" + DoubleToString(balance, 2) + "\n\n";

    alertMsg += "**Trades:** " + IntegerToString(dailyStats.count) + "\n";
    alertMsg += "**Won:** " + IntegerToString(dailyStats.won) + "\n";
    alertMsg += "**Lost:** " + IntegerToString(dailyStats.lost) + "\n";
    alertMsg += "**Profit:** $" + DoubleToString(dailyStats.profit, 2) + "\n";
    alertMsg += "**Loss:** $" + DoubleToString(dailyStats.loss, 2) + "\n";
    alertMsg += "**Net Profit:** $" + DoubleToString(sessionNetProfit, 2) + " (" + DoubleToString(sessionNetPercent, 2) + "%)\n\n";

    alertMsg += "**All Time Trades:** " + IntegerToString(allTimeStats.count) + "\n";
    alertMsg += "**All Time Won:** " + IntegerToString(allTimeStats.won) + "\n";
    alertMsg += "**All Time Lost:** " + IntegerToString(allTimeStats.lost) + "\n";
    alertMsg += "**All Time Profit:** $" + DoubleToString(allTimeStats.profit, 2) + " (" + DoubleToString(profitPercent, 2) + "%)\n";
    alertMsg += "**All Time Loss:** $" + DoubleToString(allTimeStats.loss, 2) + " (" + DoubleToString(lossPercent, 2) + "%)\n";
    alertMsg += "**All Time Net Profit:** $" + DoubleToString(allTimeNetProfit, 2) + " (" + DoubleToString(allTimeNetPercent, 2) + "%)\n\n";

    alertMsg += "**Average Profit:** $" + DoubleToString(allTimeStats.avgProfit, 2) + "\n";
    alertMsg += "**Largest Profit:** $" + DoubleToString(allTimeStats.maxProfit, 2) + "\n";
    alertMsg += "**Smallest Profit:** $" + DoubleToString(allTimeStats.minProfit, 2) + "\n";
    alertMsg += "**Average Loss:** $" + DoubleToString(allTimeStats.avgLoss, 2) + "\n";
    alertMsg += "**Largest Loss:** $" + DoubleToString(allTimeStats.maxLoss, 2) + "\n";
    alertMsg += "**Smallest Loss:** $" + DoubleToString(allTimeStats.minLoss, 2) + "\n\n";

    alertMsg += "**Pauses Triggered:** " + IntegerToString(totalPauseCount) + "\n";
    alertMsg += "**Total Paused Duration:** " + DoubleToString(totalPauseDurationMinutes, 0) + " minutes" + "\n";
    alertMsg += "**Report Generated For:** " + reportDurationStr + "\n";
    alertMsg += "**Run Duration:** " + durationStr + "\n";

    SendDiscordAlert("📊 TRADE REPORT", alertMsg, 16776960);

    lastDailyReportTime = TimeCurrent();
    lastReportEquity = currentEquity;
}

void CheckAlgoTradingStatus()
{
    bool currentStatus = TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);

   if(currentStatus != algoTradingStatus)
   {
      if(currentStatus)
      {
        LogPrint("Algo Trading has been ENABLED");

        double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
        double balance = AccountInfoDouble(ACCOUNT_BALANCE);

        string alertMsg = "**Instrument:** " + g_activeSymbol + "\n";
        alertMsg += "**Timeframe:** " + EnumToString(g_activePeriod) + "\n";
        alertMsg += "**Server Time:** " + TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS) + "\n";
        alertMsg += "**Trading Hours:** " + (EnableTradingHours ? TradingStartTime + " - " + TradingEndTime + "\n" : "DISABLED\n");
        alertMsg += "**Current Equity:** $" + DoubleToString(currentEquity, 2) + "\n";
        alertMsg += "**Peak Equity:** $" + DoubleToString(peakEquity, 2) + "\n";
        alertMsg += "**Current Balance:** $" + DoubleToString(balance, 2) + "\n";
        alertMsg += "**Initial Balance:** $" + DoubleToString(initialBalance, 2) + "\n";
        alertMsg += "**Action:** Trading Started (Algo Trading Enabled)";

        SendDiscordAlert("🟢 AUTOMATED TRADING STARTED", alertMsg, 5763719);
      }
      else
      {
        LogPrint("Algo Trading has been DISABLED");

        double currentEquity = AccountInfoDouble(ACCOUNT_EQUITY);
        double balance = AccountInfoDouble(ACCOUNT_BALANCE);

        string alertMsg = "**Instrument:** " + g_activeSymbol + "\n";
        alertMsg += "**Timeframe:** " + EnumToString(g_activePeriod) + "\n";
        alertMsg += "**Server Time:** " + TimeToString(TimeTradeServer(), TIME_DATE|TIME_SECONDS) + "\n";
        alertMsg += "**Trading Hours:** " + (EnableTradingHours ? TradingStartTime + " - " + TradingEndTime + "\n" : "DISABLED\n");
        alertMsg += "**Current Equity:** $" + DoubleToString(currentEquity, 2) + "\n";
        alertMsg += "**Peak Equity:** $" + DoubleToString(peakEquity, 2) + "\n";
        alertMsg += "**Current Balance:** $" + DoubleToString(balance, 2) + "\n";
        alertMsg += "**Initial Balance:** $" + DoubleToString(initialBalance, 2) + "\n";
        alertMsg += "**Action:** Trading Stopped (Algo Trading Disabled)";

        SendDiscordAlert("🔴 AUTOMATED TRADING STOPPED", alertMsg, 15158332);
      }

      algoTradingStatus = currentStatus;
   }
}

void DisableAlgoTrading()
{
    bool Status = (bool)TerminalInfoInteger(TERMINAL_TRADE_ALLOWED);

    if(Status)
    {
        HANDLE hChart = (HANDLE)ChartGetInteger(ChartID(), CHART_WINDOW_HANDLE);
        PostMessageW(GetAncestor(hChart, GA_ROOT), WM_COMMAND, MT_WMCMD_EXPERTS, 0);
    }
}

bool SendDiscordAlert(string title, string message, int embedColor = 3447003)
{
    if(!EnableDiscordAlerts || DiscordWebhookURL == "") return false;

    StringReplace(message, "\\", "\\\\");
    StringReplace(message, "\"", "\\\"");
    StringReplace(message, "\n", "\\n");

    string json = "";
    json += "{\"embeds\":[{";
    json += "\"title\":\"" + title + "\",";
    json += "\"description\":\"" + message + "\",";
    json += "\"color\":" + IntegerToString(embedColor) + ",";
    json += "\"footer\":{\"text\":\"Aime Programmer v45.51\"}";
    json += "}]}";

    char post[];
    char result[];
    string headers = "Content-Type: application/json\r\n";
    string resultHeaders = "";
    int timeout = 5000;

    StringToCharArray(json, post, 0, WHOLE_ARRAY, CP_UTF8);
    ArrayResize(post, ArraySize(post) - 1);

    int res = WebRequest("POST", DiscordWebhookURL, headers, timeout, post, result, resultHeaders);

    if(res == 200 || res == 204)
    {
        LogPrint("Discord alert sent: ", title);
        return true;
    }
    else
    {
        LogPrint("Discord ERROR: ", res);
        LogPrint("Payload: ", json);
        LogPrint("Response: ", CharArrayToString(result));
        LogPrint("MT5 Error: ", GetLastError());
        return false;
    }
}

void CheckDiscordAlert()
{
    if(DiscordWebhookURL == "")
    {
        Print("WARNING: Discord alerts enabled but webhook URL is empty!");
    }
    else if(StringFind(DiscordWebhookURL, "https://discord.com/api/webhooks/") != 0 &&
            StringFind(DiscordWebhookURL, "https://discordapp.com/api/webhooks/") != 0)
    {
        Print("WARNING: Discord webhook URL format may be incorrect!");
    }
    else
    {
        CheckAlgoTradingStatus();
    }
}

void AimeExportConfig()
{
    string fileName="Aime_v45_Config_"+TimeToString(TimeCurrent(),TIME_DATE)+".ini";
    int h=FileOpen(fileName,FILE_TXT|FILE_WRITE|FILE_COMMON,"=");
    if(h==INVALID_HANDLE)
    {
        AimeWritePersistentLog("CONFIG EXPORT FAILED", "ERROR");
        return;
    }
    FileWriteString(h,"[AIME_PROGRAMMER_45.41_DYNAMIC]\r\n");
    FileWriteString(h,"RiskPerTradePct="+DoubleToString(RiskPerTradePct,8)+"\r\n");
    FileWriteString(h,"MaxPortfolioOpenRiskPct="+DoubleToString(MaxPortfolioOpenRiskPct,8)+"\r\n");
    FileWriteString(h,"MaxPositionsPerSymbol="+IntegerToString(MaxPositionsPerSymbol)+"\r\n");
    FileWriteString(h,"MaxPortfolioPositions="+IntegerToString(MaxPortfolioPositions)+"\r\n");
    FileWriteString(h,"BaseLotSize="+DoubleToString(BaseLotSize,8)+"\r\n");
    FileWriteString(h,"MaxLotSize="+DoubleToString(MaxLotSize,8)+"\r\n");
    FileWriteString(h,"EnableTrailing="+(EnableTrailing?"true":"false")+"\r\n");
    FileWriteString(h,"EnableStopLoss="+(EnableStopLoss?"true":"false")+"\r\n");
    FileWriteString(h,"EnableTakeProfit="+(EnableTakeProfit?"true":"false")+"\r\n");
    FileWriteString(h,"MultiAssetSymbols="+MultiAssetSymbols+"\r\n");
    FileWriteString(h,"CryptoSymbols="+CryptoSymbols+"\r\n");
    FileWriteString(h,"StockSymbols="+StockSymbols+"\r\n");
    FileWriteString(h,"IndexSymbols="+IndexSymbols+"\r\n");
    FileWriteString(h,"EmergencyStop="+(g_emergencyStop?"true":"false")+"\r\n");
    FileWriteString(h,"PeakEquity="+DoubleToString(peakEquity,2)+"\r\n");
    FileWriteString(h,"InitialBalance="+DoubleToString(initialBalance,2)+"\r\n");
    FileClose(h);
    AimeWritePersistentLog("CONFIG EXPORTED: "+fileName,"CONTROL");
    AimePlayTradeSound("Alert");
}

void AimeDashButton(string name,string text,int x,int y,int w,int h,color bg,color border,color textColor)
{
    if(ObjectFind(0,name)<0) ObjectCreate(0,name,OBJ_BUTTON,0,0,0);
    ObjectSetInteger(0,name,OBJPROP_CORNER,CORNER_LEFT_UPPER);
    ObjectSetInteger(0,name,OBJPROP_XDISTANCE,x);
    ObjectSetInteger(0,name,OBJPROP_YDISTANCE,y);
    ObjectSetInteger(0,name,OBJPROP_XSIZE,w);
    ObjectSetInteger(0,name,OBJPROP_YSIZE,h);
    ObjectSetInteger(0,name,OBJPROP_BGCOLOR,bg);
    ObjectSetInteger(0,name,OBJPROP_BORDER_COLOR,border);
    ObjectSetInteger(0,name,OBJPROP_COLOR,textColor);
    ObjectSetInteger(0,name,OBJPROP_FONTSIZE,7);
    ObjectSetString(0,name,OBJPROP_FONT,"Arial Bold");
    ObjectSetString(0,name,OBJPROP_TEXT,text);
    ObjectSetInteger(0,name,OBJPROP_STATE,false);
    ObjectSetInteger(0,name,OBJPROP_SELECTABLE,false);
    ObjectSetInteger(0,name,OBJPROP_SELECTED,false);
    ObjectSetInteger(0,name,OBJPROP_HIDDEN,true);
}

string AimeDealReasonText(ENUM_DEAL_REASON reason)
{
    switch(reason)
    {
        case DEAL_REASON_SL: return "STOP LOSS";
        case DEAL_REASON_TP: return "TAKE PROFIT";
        case DEAL_REASON_SO: return "STOP OUT";
        case DEAL_REASON_EXPERT: return "EXPERT";
        case DEAL_REASON_CLIENT: return "CLIENT";
        case DEAL_REASON_MOBILE: return "MOBILE";
        case DEAL_REASON_WEB: return "WEB";
        case DEAL_REASON_ROLLOVER: return "ROLLOVER";
        case DEAL_REASON_VMARGIN: return "VMARGIN";
        default: return "OTHER";
    }
}
void AimeDashClosedTradeForensics(int x,int y,int w,int h,color panel,color border,color card,color white,color muted,color green,color red,color yellow)
{
    AimeDashRect("AimeDash_ClosedForensics",x,y,w,h,panel,border);
    AimeDashText("AimeDash_ClosedForensicsTitle","RECENT CLOSED TRADES",x+12,y+10,9,white,true);
    datetime now=TimeCurrent();
    datetime from=now-7*86400;
    int rowY=y+32;
    int shown=0;
    if(HistorySelect(from,now))
    {
        int total=HistoryDealsTotal();
        for(int i=total-1;i>=0 && shown<6;i--)
        {
            ulong deal=HistoryDealGetTicket(i);
            if(deal==0) continue;
            long magic=HistoryDealGetInteger(deal,DEAL_MAGIC);
            if(!IsAimeMagic(magic)) continue;
            long entry=HistoryDealGetInteger(deal,DEAL_ENTRY);
            if(entry!=DEAL_ENTRY_OUT && entry!=DEAL_ENTRY_INOUT) continue;
            string symbol=HistoryDealGetString(deal,DEAL_SYMBOL);
            if(symbol=="") continue;
            double net=HistoryDealGetDouble(deal,DEAL_PROFIT)+HistoryDealGetDouble(deal,DEAL_SWAP)+HistoryDealGetDouble(deal,DEAL_COMMISSION);
            ENUM_DEAL_REASON reason=(ENUM_DEAL_REASON)HistoryDealGetInteger(deal,DEAL_REASON);
            long dealType=HistoryDealGetInteger(deal,DEAL_TYPE);
           string side = (dealType == DEAL_TYPE_BUY) ? "BUY" : ((dealType == DEAL_TYPE_SELL) ? "SELL" : "OTHER");

             string text = StringFormat("%s %s  NET %+.2f  %s", symbol, side, net, AimeDealReasonText(reason));
            AimeDashText("AimeDash_ClosedForensicsRow"+IntegerToString(shown),AimeDashTrim(text,58),x+10,rowY,7,net>=0.0?green:red,true);
            shown++;
            rowY+=23;
        }
    }
    if(shown==0)
        AimeDashText("AimeDash_ClosedForensicsNone","NO RECENT AIME CLOSED TRADES",x+12,rowY,7,muted,true);
}

void AimeDashPositionDetails(int x,int y,int w,int h,color panel,color border,color card,color white,color muted,color green,color red,color yellow)
{
    AimeDashRect("AimeDash_PositionPanel",x,y,w,h,panel,border);
    AimeDashText("AimeDash_PositionTitle","BROKER OPEN POSITIONS",x+12,y+10,9,white,true);
    int rowY=y+32;
    int shown=0;
    for(int i=PositionsTotal()-1;i>=0 && shown<6;i--)
    {
        ulong ticket=PositionGetTicket(i);
        if(ticket==0 || !PositionSelectByTicket(ticket)) continue;
        if(!IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) continue;
        string symbol=PositionGetString(POSITION_SYMBOL);
        ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
        double volume=PositionGetDouble(POSITION_VOLUME);
        double profit=PositionGetDouble(POSITION_PROFIT)+PositionGetDouble(POSITION_SWAP);
        double entry=PositionGetDouble(POSITION_PRICE_OPEN);
        double sl=PositionGetDouble(POSITION_SL);
        double tp=PositionGetDouble(POSITION_TP);
        string id=StringFormat("AimeDash_Pos_%I64u",ticket);
        string text=StringFormat("%s  %s  %.2f  P/L %+.2f  E %.5f  SL %.5f  TP %.5f",symbol,type==POSITION_TYPE_BUY?"BUY":"SELL",volume,profit,entry,sl,tp);
        AimeDashButton(id,AimeDashTrim(text,68),x+8,rowY,w-16,22,ticket==g_dashboardSelectedPositionTicket?card:C'22,33,46',border,profit>=0?green:red);
        shown++;
        rowY+=24;
    }
    if(shown==0)
    {
        string extText = g_externalPositionCount > 0
            ? StringFormat("NO AIME POSITIONS | EXTERNAL %d | UNPROTECTED %d",g_externalPositionCount,g_externalUnprotectedPositionCount)
            : "NO AIME POSITIONS";
        AimeDashText("AimeDash_NoPositions",extText,x+12,rowY,7,g_externalUnprotectedPositionCount>0?red:muted,true);
        AimeDashClosedTradeForensics(x+4,y+52,w-8,MathMax(90,h-78),panel,border,card,white,muted,green,red,yellow);
    }
    else
        ObjectDelete(0,"AimeDash_ClosedForensics");
    AimeDashText("AimeDash_SelectedTicket",g_dashboardSelectedPositionTicket>0?StringFormat("SELECTED: %I64u",g_dashboardSelectedPositionTicket):"SELECTED: NONE",x+12,y+h-17,6,yellow,true);
}

void AimeDashRect(string name, int x, int y, int w, int h, color bg, color border)
{
    if(ObjectFind(0, name) < 0)
    {
        ObjectCreate(0, name, OBJ_RECTANGLE_LABEL, 0, 0, 0);
        ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
        ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
        ObjectSetInteger(0, name, OBJPROP_BACK, false);
        ObjectSetInteger(0, name, OBJPROP_BORDER_TYPE, BORDER_FLAT);
        ObjectSetInteger(0, name, OBJPROP_FILL, true);
    }
    ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
    ObjectSetInteger(0, name, OBJPROP_XSIZE, w);
    ObjectSetInteger(0, name, OBJPROP_YSIZE, h);
    ObjectSetInteger(0, name, OBJPROP_BGCOLOR, bg);
    ObjectSetInteger(0, name, OBJPROP_COLOR, border);
}

void AimeDashText(string name, string text, int x, int y, int size, color clr, bool bold = false)
{
    if(ObjectFind(0, name) < 0)
    {
        ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0);
        ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
        ObjectSetInteger(0, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(0, name, OBJPROP_SELECTED, false);
        ObjectSetInteger(0, name, OBJPROP_HIDDEN, true);
        ObjectSetInteger(0, name, OBJPROP_BACK, false);
        ObjectSetInteger(0, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
    }
    ObjectSetInteger(0, name, OBJPROP_XDISTANCE, x);
    ObjectSetInteger(0, name, OBJPROP_YDISTANCE, y);
    ObjectSetInteger(0, name, OBJPROP_FONTSIZE, size);
    ObjectSetInteger(0, name, OBJPROP_COLOR, clr);
    ObjectSetString(0, name, OBJPROP_FONT, bold ? "Arial Bold" : "Arial");
    ObjectSetString(0, name, OBJPROP_TEXT, text);
}

void AimeDashBar(string name, int x, int y, int w, int h, double value, double maximum, color fillColor, color bgColor)
{
    double ratio = maximum > 0.0 ? value / maximum : 0.0;
    if(ratio < 0.0) ratio = 0.0;
    if(ratio > 1.0) ratio = 1.0;
    int fillWidth = (int)MathRound((double)w * ratio);
    AimeDashRect(name + "_BG", x, y, w, h, bgColor, bgColor);
    if(fillWidth > 0)
        AimeDashRect(name + "_FILL", x, y, fillWidth, h, fillColor, fillColor);
    else
        ObjectDelete(0, name + "_FILL");
}

string AimeDashTrim(string value, int maxLength)
{
    if(StringLen(value) <= maxLength) return value;
    if(maxLength < 4) return StringSubstr(value, 0, maxLength);
    return StringSubstr(value, 0, maxLength - 3) + "...";
}

string AimeDashTimeframe()
{
    string tf = EnumToString(g_activePeriod);
    if(StringFind(tf, "PERIOD_") == 0)
        tf = StringSubstr(tf, 7);
    return tf;
}
string AimeDashAssetClass(string symbol)
{
    return AimeProfileClass(symbol);
}

int AimeDashPortfolioOpen()
{
    AimeRefreshDashboardPositionSnapshot();
    return g_dashboardPositionCount;
}

double AimeDashPortfolioVolume()
{
    double volume = 0.0;
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
        if(!IsAimeMagic((long)PositionGetInteger(POSITION_MAGIC))) continue;
        volume += PositionGetDouble(POSITION_VOLUME);
    }
    return volume;
}

int AimeDashSymbolOpen(string symbol)
{
    long magic = GetMagicForSymbol(symbol);
    if(magic <= 0) return 0;
    int count = 0;
    for(int i = PositionsTotal() - 1; i >= 0; i--)
    {
        ulong ticket = PositionGetTicket(i);
        if(ticket == 0 || !PositionSelectByTicket(ticket)) continue;
        if(PositionGetString(POSITION_SYMBOL) != symbol) continue;
        if((long)PositionGetInteger(POSITION_MAGIC) != magic) continue;
        count++;
    }
    return count;
}

string AimeDashSymbolState(int index)
{
    if(index < 0 || index >= g_assetCount) return "UNKNOWN";
    string symbol=g_assets[index].symbol;
    if(g_assets[index].quarantined) return "QUARANTINE";
    if(g_emergencyStop) return "EMERGENCY STOP";
    if(!g_assets[index].initialized) return "INIT";
    if(!SymbolSelect(symbol,true)) return "OFFLINE";
    string sessionState="";
    if(!AimeBrokerSessionOpen(symbol,sessionState))
    {
        if(sessionState=="MARKET CLOSED") return "MARKET CLOSED";
        if(sessionState=="TRADING DISABLED") return "TRADING DISABLED";
        if(sessionState=="SESSION UNKNOWN") return "SESSION UNKNOWN";
    }
    string feedReason = "";
    bool feedReady = AimeRefreshAssetFeed(index,feedReason);
    if(!feedReady)
    {
        if(feedReason=="NO LIVE QUOTE") return "NO TICK";
        return "STALE TICK";
    }
    if(!g_assets[index].strategyDataReady && g_assets[index].dataState != "") return g_assets[index].dataState;
    if(g_assets[index].strategyDataReady) return "DATA READY";
    return "DATA WAIT";
}

color AimeDashStateColor(string state,color ready,color warn,color bad,color neutral)
{
    if(state=="DATA READY" || state=="READY" || state=="ACTIVE") return ready;
    if(state=="QUARANTINE" || state=="NO TICK" || state=="OFFLINE") return bad;
    if(state=="STALE TICK") return warn;
    if(state=="INIT" || state=="STALE" || state=="WAIT") return warn;
    return neutral;
}

bool AimeDashConfiguredHoursOpen()
{
    if(!EnableTradingHours) return true;
    datetime now=TimeTradeServer();
    if(now<=0) now=TimeCurrent();
    MqlDateTime dt;
    TimeToStruct(now,dt);
    int cur=dt.hour*60+dt.min;
    string a[],b[];
    if(StringSplit(TradingStartTime,':',a)!=2 || StringSplit(TradingEndTime,':',b)!=2) return false;
    int st=(int)StringToInteger(a[0])*60+(int)StringToInteger(a[1]);
    int en=(int)StringToInteger(b[0])*60+(int)StringToInteger(b[1]);
    if(st<=en) return cur>=st && cur<=en;
    return cur>=st || cur<=en;
}

string AimeDashSessionState(int index)
{
    if(index<0 || index>=g_assetCount) return "UNKNOWN";
    string status="";
    AimeBrokerSessionOpen(g_assets[index].symbol,status);
    if(status=="SESSION OPEN") return "OPEN";
    if(status=="MARKET CLOSED") return "CLOSED";
    if(status=="TRADING DISABLED") return "DISABLED";
    if(status=="NO TICK") return "NO TICK";
    return AimeDashTrim(status,12);
}

string AimeDashSignalState(int index,double &buyScore,double &sellScore,double &buyThreshold,double &sellThreshold)
{
    buyScore=0.0;
    sellScore=0.0;
    buyThreshold=0.0;
    sellThreshold=0.0;
    if(index<0 || index>=g_assetCount) return "UNKNOWN";
    string symbol=g_assets[index].symbol;
    buyThreshold=AimeBuySignalThresholdForSymbol(symbol);
    sellThreshold=AimeSellSignalThresholdForSymbol(symbol);
    string signalSessionState="";
    if(!AimeBrokerSessionOpen(symbol,signalSessionState))
    {
        if(signalSessionState=="MARKET CLOSED") return "MARKET CLOSED";
        if(signalSessionState=="TRADING DISABLED") return "TRADING DISABLED";
        if(signalSessionState=="SESSION UNKNOWN") return "SESSION UNKNOWN";
    }
    string signalFeedReason = "";
    if(!AimeRefreshAssetFeed(index,signalFeedReason))
    {
        if(signalFeedReason=="NO LIVE QUOTE") return "NO TICK";
        return "STALE TICK";
    }
    if(g_assets[index].buyStrengthValid) buyScore=g_assets[index].cachedBuyStrength.finalScore;
    if(g_assets[index].sellStrengthValid) sellScore=g_assets[index].cachedSellStrength.finalScore;
    if(!g_assets[index].strategyDataReady)
    {
        if(g_assets[index].dataState != "") return AimeDashTrim(g_assets[index].dataState,18);
        return "DATA WAIT";
    }
    if(g_assets[index].strategyRegime == "DATA_WAIT") return "DATA WAIT";
    if(!g_assets[index].buyStrengthValid && !g_assets[index].sellStrengthValid) return "PENDING";
    if(buyScore>=buyThreshold && buyScore>sellScore) return "BUY SIGNAL";
    if(sellScore>=sellThreshold && sellScore>buyScore) return "SELL SIGNAL";
    if(buyScore>sellScore) return "BUY LEAN";
    if(sellScore>buyScore) return "SELL LEAN";
    return "WAIT";
}

string AimeDashDecisionReason(int index)
{
    if(index<0 || index>=g_assetCount) return "ASSET UNAVAILABLE";
    AssetContext asset=g_assets[index];
    if(!asset.initialized) return "ASSET INITIALIZING";
    string reasonSession="";
    if(!AimeBrokerSessionOpen(asset.symbol,reasonSession))
    {
        if(reasonSession=="MARKET CLOSED") return "MARKET CLOSED";
        if(reasonSession=="TRADING DISABLED") return "TRADING DISABLED";
        if(reasonSession=="SESSION UNKNOWN") return "SESSION UNKNOWN";
    }
    string feedReason="";
    if(!AimeRefreshAssetFeed(index,feedReason))
    {
        if(feedReason=="NO LIVE QUOTE") return "NO LIVE QUOTE";
        return feedReason=="" ? "MARKET DATA STALE" : feedReason;
    }
    if(asset.quarantined) return asset.quarantineReason!="" ? asset.quarantineReason : "ASSET QUARANTINED";
    if(!asset.strategyDataReady)
    {
        if(asset.dataReason!="") return AimeDashTrim(asset.dataReason,52);
        if(asset.dataState!="") return AimeDashTrim(asset.dataState,52);
        return "MARKET DATA NOT READY";
    }
    if(asset.strategyReason!="") return AimeDashTrim(asset.strategyReason,52);
    if(asset.strategyFinalDecision=="BUY READY") return "BUY QUALIFICATION PASSED";
    if(asset.strategyFinalDecision=="SELL READY") return "SELL QUALIFICATION PASSED";
    double buyScore=asset.buyStrengthValid ? asset.cachedBuyStrength.finalScore : 0.0;
    double sellScore=asset.sellStrengthValid ? asset.cachedSellStrength.finalScore : 0.0;
    double buyThreshold=AimeBuySignalThresholdForSymbol(asset.symbol);
    double sellThreshold=AimeSellSignalThresholdForSymbol(asset.symbol);
    if(buyScore>sellScore) return StringFormat("BUY %.2f / %.2f | GAP %.2f",buyScore,buyThreshold,MathMax(0.0,buyThreshold-buyScore));
    if(sellScore>buyScore) return StringFormat("SELL %.2f / %.2f | GAP %.2f",sellScore,sellThreshold,MathMax(0.0,sellThreshold-sellScore));
    return "NO DIRECTIONAL EDGE";
}

string AimeDashDecisionStatus(int index)
{
    if(index<0 || index>=g_assetCount) return "UNKNOWN";
    string feedReason="";
    if(!AimeRefreshAssetFeed(index,feedReason)) return "BLOCKED";
    if(!g_assets[index].strategyDataReady) return "BLOCKED";
    string decision=g_assets[index].strategyFinalDecision;
    if(decision=="BUY READY") return "BUY READY";
    if(decision=="SELL READY") return "SELL READY";
    if(decision=="BLOCKED") return "BLOCKED";
    if(decision=="WAIT") return "WAIT";
    return decision=="" ? "WAIT" : AimeDashTrim(decision,18);
}

string AimeDashExecutionState(int index)
{
    if(index<0 || index>=g_assetCount) return "UNKNOWN";
    string symbol=g_assets[index].symbol;
    if(g_assets[index].quarantined) return "QUARANTINE";
    if(!g_assets[index].initialized) return "INIT";
    if(g_emergencyStop) return "EMERGENCY STOP";
    if(!g_accountSnapshotValid && !AimeRefreshAccountSnapshot()) return "ACCOUNT DATA";
    if(!SymbolSelect(symbol,true)) return "OFFLINE";
    string execFeedReason = "";
    if(!AimeRefreshAssetFeed(index,execFeedReason))
    {
        if(execFeedReason=="NO LIVE QUOTE") return "NO TICK";
        return "STALE TICK";
    }
    if(g_riskHardLocked || g_dailyRiskLocked || g_peakRiskLocked) return "RISK BLOCK";
    if(g_marginLevel>0.0 && g_marginLevel<=MarginEntryBlockLevel) return "MARGIN BLOCK";
    if(MaxPortfolioPositions>0 && AimePortfolioExposureSlots()>=MaxPortfolioPositions) return "PORTFOLIO LIMIT";
    long magic=g_assets[index].magicNumber;
    int exposure=AimeSymbolExposureSlots(symbol);
    int losing=CountLosingPositionsForSymbol(symbol,magic);
    if(MaxPositionsPerSymbol>0 && exposure>=MaxPositionsPerSymbol) return "POSITION LIMIT";
    if(MaxHoldingLossPositions>0 && losing>=MaxHoldingLossPositions) return "LOSS LIMIT";
    string session="";
    if(!AimeBrokerSessionOpen(symbol,session))
    {
        if(session=="MARKET CLOSED") return "MARKET CLOSED";
        if(session=="TRADING DISABLED") return "TRADING DISABLED";
        return AimeDashTrim(session,18);
    }
    if(!AimeDashConfiguredHoursOpen()) return "HOURS BLOCK";
    double spreadPoints=0.0,spreadCap=0.0;
    if(AimeAssetSpreadTooWide(index,spreadPoints,spreadCap)) return "SPREAD BLOCK";
    double volRatio=AimeAssetVolatilityRatio(index);
    double minVol=AimeMinVolRatioForSymbol(symbol);
    if(minVol>0.0 && volRatio>0.0 && volRatio<minVol) return "LOW VOL";
    return "EXECUTION READY";
}

string AimeDashSignalAge(int index)
{
    if(index<0 || index>=g_assetCount) return "BAR N/A";
    long sec=AimeAssetBarAgeSeconds(index);
    if(sec<0) return "BAR N/A";
    ENUM_TIMEFRAMES period=g_assets[index].period;
    int tfSeconds=PeriodSeconds(period);
    string ageText;
    if(sec<60) ageText=StringFormat("BAR %ds",(int)sec);
    else if(sec<3600) ageText=StringFormat("BAR %dm",(int)(sec/60));
    else if(sec<86400) ageText=StringFormat("BAR %dh",(int)(sec/3600));
    else ageText=StringFormat("BAR %dd",(int)(sec/86400));
    if(tfSeconds>0 && sec>tfSeconds*2) return ageText+" OLD";
    return ageText;
}

void AimeDashTab(string name, string textValue, int x, int y, int w, bool active, color accent, color bg, color text)
{
    AimeDashRect(name + "_BG", x, y, w, 24, active ? accent : bg, active ? accent : C'72,78,90');
    AimeDashText(name + "_TXT", textValue, x + 10, y + 6, 7, active ? C'22,24,28' : text, true);
}

int GetTotalPages()
{
    int filteredCount = 0;
    for(int i = 0; i < g_assetCount; i++)
    {
        string assetClass = AimeDashAssetClass(g_assets[i].symbol);
        bool include = false;

        switch(g_assetFilter)
        {
            case 0: include = true; break;
            case 1: include = (assetClass == "FX"); break;
            case 2: include = (assetClass == "CRYPTO"); break;
            case 3: include = (assetClass == "STOCK"); break;
            case 4: include = (assetClass == "INDEX"); break;
            case 5: include = (assetClass == "METAL"); break;
        }

        if(include) filteredCount++;
    }

    int totalPages = (filteredCount + ROWS_PER_PAGE - 1) / ROWS_PER_PAGE;
    if(totalPages == 0) totalPages = 1;
    return totalPages;
}

string AimeDashSymbolRealizedPL(string symbol, long magic)
{
    datetime now = TimeCurrent();
    MqlDateTime dt;
    TimeToStruct(now, dt);
    dt.hour = 0;
    dt.min = 0;
    dt.sec = 0;
    datetime dayStart = StructToTime(dt);

    if(!HistorySelect(dayStart, now)) return "$0.00";

    double realized = 0.0;
    int totalDeals = HistoryDealsTotal();
    for(int i = 0; i < totalDeals; i++)
    {
        ulong deal = HistoryDealGetTicket(i);
        if(deal == 0) continue;
        if(HistoryDealGetString(deal, DEAL_SYMBOL) != symbol) continue;
        if((long)HistoryDealGetInteger(deal, DEAL_MAGIC) != magic) continue;
        long entry = HistoryDealGetInteger(deal, DEAL_ENTRY);
        if(entry != DEAL_ENTRY_OUT && entry != DEAL_ENTRY_INOUT) continue;
        realized += HistoryDealGetDouble(deal, DEAL_PROFIT)
                  + HistoryDealGetDouble(deal, DEAL_SWAP)
                  + HistoryDealGetDouble(deal, DEAL_COMMISSION);
    }
    return StringFormat("$%.2f", realized);
}

string AimeDashRowStatus(int index)
{
    double buyScore=0.0,sellScore=0.0,buyThreshold=0.0,sellThreshold=0.0;
    return AimeDashSignalState(index,buyScore,sellScore,buyThreshold,sellThreshold);
}

double AimeAssetVolatilityRatio(int index)
{
    if(index < 0 || index >= g_assetCount) return 0.0;
    int lookback = MathMax(1, ATRAvgLookback);
    int copied = MathMax(1, lookback);
    double buf[];
    ArraySetAsSeries(buf, true);
    if(g_assets[index].atrSignalHandle == INVALID_HANDLE) return 0.0;
    if(CopyBuffer(g_assets[index].atrSignalHandle, 0, 0, copied, buf) < copied) return 0.0;

    double currentATR = buf[0];
    if(currentATR <= 0.0) return 0.0;

    double sumATR = 0.0;
    int count = 0;
    for(int i = 0; i < copied; i++)
    {
        if(buf[i] <= 0.0) continue;
        sumATR += buf[i];
        count++;
    }

    if(count <= 0) return 0.0;
    double avgATR = sumATR / count;
    if(avgATR <= 0.0) return 0.0;
    return currentATR / avgATR;
}

bool AimeAssetSpreadTooWide(int index, double &spreadPoints, double &spreadCap)
{
    spreadPoints = 0.0;
    spreadCap = 0.0;
    if(index < 0 || index >= g_assetCount) return false;
    if(!EnableMaxSpreadFilter) return false;

    string symbol = g_assets[index].symbol;
    spreadPoints = (double)SymbolInfoInteger(symbol, SYMBOL_SPREAD);

    if(MaxSpreadPoints > 0.0)
    {
        spreadCap = MaxSpreadPoints;
    }
    else
    {
        double atrRatio = AimeSpreadATRRatioForSymbol(symbol);
        int handle = g_assets[index].atrSignalHandle;
        if(handle == INVALID_HANDLE) return false;

        double buf[];
        ArraySetAsSeries(buf, true);
        if(CopyBuffer(handle, 0, 0, 1, buf) < 1) return false;

        double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
        if(point <= 0.0 || buf[0] <= 0.0 || atrRatio <= 0.0) return false;

        double atrPoints = buf[0] / point;
        spreadCap = atrPoints * atrRatio;
    }

    double hardCap = spreadCap * MathMax(1.0, SpreadHardMultiplier);
    return hardCap > 0.0 && spreadPoints > hardCap;
}

string AimeAssetEntryDiagnostic(int index, double &buyScore, double &sellScore, double &buyThreshold, double &sellThreshold)
{
    buyScore = 0.0;
    sellScore = 0.0;
    buyThreshold = 0.0;
    sellThreshold = 0.0;

    if(index < 0 || index >= g_assetCount) return "INVALID";
    string symbol = g_assets[index].symbol;

    buyThreshold = AimeBuySignalThresholdForSymbol(symbol);
    sellThreshold = AimeSellSignalThresholdForSymbol(symbol);

    if(!g_assets[index].initialized)
        return "INIT";

    if(g_assets[index].quarantined)
        return "QUARANTINE";

    if(!SymbolSelect(symbol, true))
        return "OFFLINE";

    MqlTick t;
    if(!SymbolInfoTick(symbol, t) || t.time <= 0)
        return "NO TICK";

    if(g_assets[index].buyStrengthValid)
        buyScore = g_assets[index].cachedBuyStrength.finalScore;
    if(g_assets[index].sellStrengthValid)
        sellScore = g_assets[index].cachedSellStrength.finalScore;

    if(g_riskHardLocked || g_dailyRiskLocked || g_peakRiskLocked)
        return "GLOBAL RISK";

    if(g_marginLevel > 0.0 && g_marginLevel <= MarginEntryBlockLevel)
        return "MARGIN";

    if(EnablePerformanceGate)
    {
        string perfReason = "";
        if(!AimePerformanceGateAllows(index, perfReason))
            return "UNDERPERFORMING";
    }

    if(MaxPortfolioPositions > 0 && AimePortfolioExposureSlots() >= MaxPortfolioPositions)
        return "PORTFOLIO";

    if(MaxPortfolioOpenRiskPct > 0.0 && g_portfolioOpenRiskPct >= MaxPortfolioOpenRiskPct)
        return "OPEN RISK";

    long magic = g_assets[index].magicNumber;
    int exposure = AimeSymbolExposureSlots(symbol);
    int losing = CountLosingPositionsForSymbol(symbol, magic);

    if(MaxPositionsPerSymbol > 0 && exposure >= MaxPositionsPerSymbol)
        return "POSITION LIMIT";

    if(MaxHoldingLossPositions > 0 && losing >= MaxHoldingLossPositions)
        return "LOSS LIMIT";

    string brokerSessionStatus = "";
    if(!AimeBrokerSessionOpen(symbol, brokerSessionStatus))
    {
        if(brokerSessionStatus == "MARKET CLOSED") return "MARKET CLOSED";
        return brokerSessionStatus;
    }

    if(EnableTradingHours && !IsWithinTradingHours())
        return "SESSION";

    double spreadPoints = 0.0;
    double spreadCap = 0.0;
    if(AimeAssetSpreadTooWide(index, spreadPoints, spreadCap))
        return "SPREAD";

    double volRatio = AimeAssetVolatilityRatio(index);
    double minVol = AimeMinVolRatioForSymbol(symbol);
    if(minVol > 0.0 && volRatio > 0.0 && volRatio < minVol)
        return "LOW VOL";

    if(!g_assets[index].buyStrengthValid && !g_assets[index].sellStrengthValid)
        return "SIGNAL PENDING";

    if(buyScore >= buyThreshold || sellScore >= sellThreshold)
        return "SIGNAL READY";

    return "WAIT SIGNAL";
}

void UpdateDashboard(bool force=false)
{
    if(g_dashboardRendering) return;
    AimeRefreshDashboardLiveState();
    g_dashboardRendering=true;
    int cw=(int)ChartGetInteger(0,CHART_WIDTH_IN_PIXELS);
    int ch=(int)ChartGetInteger(0,CHART_HEIGHT_IN_PIXELS);
    if(cw<1000) cw=1000;
    if(ch<680) ch=680;
    int x=10;
    int y=10;
    int w=(int)MathMin(1380.0,(double)cw-20.0);
    int h=(int)MathMin(780.0,(double)ch-20.0);
    if(w<960) w=MathMin(960,cw-20);
    if(h<640) h=MathMin(640,ch-20);
    color bg=g_darkTheme?C'8,13,20':C'238,242,246';
    color header=g_darkTheme?C'12,20,30':C'224,230,236';
    color panel=g_darkTheme?C'15,24,35':C'248,250,252';
    color card=g_darkTheme?C'20,31,44':C'232,237,242';
    color card2=g_darkTheme?C'24,37,52':C'218,226,234';
    color border=g_darkTheme?C'52,70,89':C'170,180,190';
    color divider=g_darkTheme?C'40,57,74':C'195,202,210';
    color white=g_darkTheme?C'236,242,247':C'28,36,44';
    color muted=g_darkTheme?C'137,153,170':C'91,103,115';
    color dim=g_darkTheme?C'93,109,125':C'110,120,130';
    color cyan=C'78,201,255';
    color green=C'47,180,100';
    color red=C'230,65,65';
    color yellow=C'220,155,35';
    color orange=C'225,120,35';
    color blue=C'74,139,255';
    if(force || !g_dashboardInitialized)
    {
        ObjectsDeleteAll(0,"AimeDash_");
        g_dashboardInitialized=true;
    }
    AimeDashRect("AimeDash_Frame",x,y,w,h,bg,border);
    int headerH=58;
    bool systemActive=passwordVerified && g_multiAssetInitialized && g_accountSnapshotValid && !isPaused && !g_riskHardLocked && !g_dailyRiskLocked && !g_peakRiskLocked && !g_emergencyStop;
    color accentColor = g_emergencyStop?red:(!g_accountSnapshotValid?yellow:(systemActive?green:orange));
    
    AimeDashRect("AimeDash_AccentStrip",x+1,y+1,w-2,3,accentColor,accentColor);
    AimeDashRect("AimeDash_Header",x+1,y+4,w-2,headerH-3,header,border);
    AimeDashText("AimeDash_Title","AIME PROGRAMMER",x+16,y+11,19,white,true);
    AimeDashText("AimeDash_Subtitle",AimeLanguageText("MULTI-ASSET TRADING COMMAND CENTER","CENTRE DE TRADING MULTI-ACTIFS","CENTRE DE TRADING MULTI-ASSET"),x+17,y+37,8,muted,true);
    string systemText=g_emergencyStop?"EMERGENCY STOP":(!g_accountSnapshotValid?"ACCOUNT DATA WAIT":(systemActive?"SYSTEM ACTIVE":"SYSTEM BLOCKED"));
    
    int pillW=(int)(StringLen(systemText)*7.2)+22;
    int pillX=x+w-198;
    AimeDashRect("AimeDash_ActivePill",pillX,y+9,pillW,18,accentColor,accentColor);
    AimeDashText("AimeDash_Active","● "+systemText,pillX+9,y+13,9,white,true);
    AimeDashText("AimeDash_Server",TimeToString(TimeTradeServer(),TIME_SECONDS),x+w-185,y+34,8,cyan,true);
    AimeDashText("AimeDash_MinBtn","−",x+w-34,y+13,16,muted,true);
    AimeDashButton("AimeDash_CloseAll","CLOSE ALL",x+w-390,y+35,70,20,C'145,45,52',red,white);
    AimeDashButton("AimeDash_CloseSelected","CLOSE SEL",x+w-314,y+35,70,20,C'145,80,35',orange,white);
    AimeDashButton("AimeDash_ReSync","RE-SYNC",x+w-238,y+35,70,20,C'25,85,105',cyan,white);
    AimeDashButton("AimeDash_Emergency",g_emergencyStop?"STOPPED":"EMERGENCY",x+w-162,y+35,76,20,g_emergencyStop?C'80,80,80':red,white,white);
    AimeDashButton("AimeDash_Resume",g_emergencyStop?"RESUME":"EXPORT",x+w-82,y+35,72,20,g_emergencyStop?C'38,105,70':card2,g_emergencyStop?green:cyan,white);
    if(EnableThemeToggle) AimeDashButton("AimeDash_Theme",g_darkTheme?"LIGHT":"DARK",x+w-82,y+10,72,20,card2,cyan,white);
    int navY=y+64;
    string tabNames[5]={"AimeDash_TabOverview","AimeDash_TabDecision","AimeDash_TabRisk","AimeDash_TabPositions","AimeDash_TabHealth"};
    string tabText[5]={AimeLanguageText("OVERVIEW","VUE","INCAMAKE"),AimeLanguageText("DECISION","DECISION","ICYEMEZO"),AimeLanguageText("RISK","RISQUE","RISK"),AimeLanguageText("POSITIONS","POSITIONS","POSITIONS"),AimeLanguageText("HEALTH","SANTE","UBUZIMA")};
    int tabW=86;
    for(int ti=0;ti<5;ti++) AimeDashTab(tabNames[ti],tabText[ti],x+8+ti*(tabW+5),navY,tabW,g_dashTab==ti,cyan,panel,white);
    int filterY=navY+30;
    string filters[6]={AimeLanguageText("ALL","TOUT","BYOSE"),"FX","CRYPTO",AimeLanguageText("STOCK","ACTIONS","IMIGABANE"),"INDEX",AimeLanguageText("METAL","METAUX","IMYUMA")};
    int filterW=63;
    for(int fi=0;fi<6;fi++)
    {
        string fn="AimeDash_Filter"+IntegerToString(fi);
        AimeDashRect(fn,x+8+fi*(filterW+4),filterY,filterW,20,g_assetFilter==fi?card2:panel,g_assetFilter==fi?cyan:divider);
        AimeDashText(fn+"Txt",filters[fi],x+8+fi*(filterW+4)+9,filterY+5,7,g_assetFilter==fi?white:muted,true);
    }
    int contentY=filterY+28;
    int footerH=23;
    int footerY=y+h-footerH-4;
    int contentH=footerY-contentY-6;
    int gap=7;
    int leftW=225;
    int rightW=290;
    int centerW=w-leftW-rightW-gap*3;
    if(centerW<390)
    {
        leftW=210;
        rightW=275;
        centerW=w-leftW-rightW-gap*3;
    }
    int leftX=x+4;
    int centerX=leftX+leftW+gap;
    int rightX=centerX+centerW+gap;
    int topH=214;
    int bottomY=contentY+topH+gap;
    int bottomH=contentH-topH-gap;
    if(bottomH<170) bottomH=170;
    bool accountReady=AimeRefreshAccountSnapshot();
    double balance=g_accountBalanceLive;
    double equity=g_accountEquityLive;
    double floating=accountReady?GetPortfolioFloatingPL(false):0.0;
    double freeMargin=g_accountFreeMarginLive;
    double marginLevel=g_accountMarginLevelLive;
    int open=AimeDashPortfolioOpen();
    double dd=g_peakDrawdownPct;
    double daily=g_dailyNetPL;
    AimeDashRect("AimeDash_Account",leftX,contentY,leftW,topH,panel,border);
    AimeDashText("AimeDash_AccountTitle","ACCOUNT",leftX+12,contentY+10,10,cyan,true);
    string accountState=accountReady?"ACCOUNT CONNECTED":AimeDashTrim(g_accountSnapshotReason,26);
    color accountStateColor=accountReady?green:(StringFind(g_accountSnapshotReason,"NOT FUNDED")>=0?yellow:red);
    if(g_emergencyStop) { accountState="EMERGENCY: "+AimeDashTrim(g_emergencyStopReason,24); accountStateColor=red; }
    AimeDashText("AimeDash_AccountState",accountState,leftX+12,contentY+28,7,accountStateColor,true);
    TradeStats acctDaily, acctAll;
    GetTradeStats(acctDaily, acctAll);
    string aL[8]={"EQUITY","BALANCE","FLOATING P/L","FREE MARGIN","LEVERAGE","AIME / EXT","TOTAL PROFIT","TOTAL LOSS"};
    string aV[8]={accountReady?StringFormat("%.2f",equity):"N/A",accountReady?StringFormat("%.2f",balance):"N/A",accountReady?StringFormat("%s%.2f",floating>=0?"+":"-",MathAbs(floating)):"N/A",accountReady?StringFormat("%.2f",freeMargin):"N/A",accountReady?StringFormat("1:%I64d",g_accountLeverageLive):"N/A",StringFormat("%d / %d",open,g_externalPositionCount),StringFormat("+%.2f",acctAll.profit),StringFormat("-%.2f",MathAbs(acctAll.loss))};
    color aC[8]={white,white,floating>=0?green:red,white,dd>=DrawdownEntryBlockPct?red:yellow,cyan,green,red};

    for(int ai=0;ai<8;ai++)
    {
        int col=ai%3;
        int row=ai/3;
        int ax=leftX+12+col*(leftW/3-3);
        int ay=contentY+47+row*49;
        AimeDashText("AimeDash_AccountL"+IntegerToString(ai),aL[ai],ax,ay,7,muted,true);
        AimeDashText("AimeDash_AccountV"+IntegerToString(ai),aV[ai],ax,ay+15,10,aC[ai],true);
    }
    AimeDashRect("AimeDash_Risk",leftX,bottomY,leftW,bottomH,panel,border);
    AimeDashText("AimeDash_RiskTitle","RISK GOVERNOR",leftX+12,bottomY+10,10,yellow,true);
    bool riskPass=!g_riskHardLocked && !g_dailyRiskLocked && !g_peakRiskLocked && !g_emergencyStop;
    AimeDashText("AimeDash_RiskState",riskPass?"ENTRY CONTROL: PASS":"ENTRY CONTROL: BLOCKED",leftX+12,bottomY+29,8,riskPass?green:red,true);
    double riskPct=g_portfolioOpenRiskPct;
    string rL[8]={"OPEN RISK","DAILY P/L","MARGIN LEVEL","PORTFOLIO SLOTS","SYMBOL LIMIT","RECOVERY","RECOVERY DEBT","PROTECTION"};
    string rV[8]={StringFormat("%.2f%%",riskPct),StringFormat("%s%.2f",daily>=0?"+":"-",MathAbs(daily)),StringFormat("%.0f%%",marginLevel),StringFormat("%d / %d",AimePortfolioExposureSlots(),MaxPortfolioPositions),StringFormat("%d / %d",AimeSymbolExposureSlots(g_chartSymbol),MaxPositionsPerSymbol),g_recoveryMode,StringFormat("%.2f",g_recoveryDebt),"REQUIRED"};
    for(int ri=0;ri<8;ri++)
    {
        int ry=bottomY+45+ri*((bottomH-55)/8);
        AimeDashText("AimeDash_RiskL"+IntegerToString(ri),rL[ri],leftX+12,ry,7,muted,true);
        AimeDashText("AimeDash_RiskV"+IntegerToString(ri),rV[ri],leftX+108,ry,8,(ri==0&&MaxPortfolioOpenRiskPct>0&&riskPct>=MaxPortfolioOpenRiskPct)||(ri==2&&marginLevel>0&&marginLevel<=MarginEntryBlockLevel)?red:white,true);
    }
    int matrixH=topH+gap+bottomH;
    AimeDashRect("AimeDash_Matrix",centerX,contentY,centerW,matrixH,panel,border);
    bool positionsView = (g_dashTab==3);
    AimeDashText("AimeDash_MatrixTitle",positionsView?"OPEN POSITIONS":"MULTI-ASSET COMMAND MATRIX",centerX+12,contentY+10,10,white,true);
    if(positionsView)
    {
        AimeDashText("AimeDash_MatrixMeta",StringFormat("AIME %d | EXT %d | P/L %+.2f",g_dashboardPositionCount,g_externalPositionCount,g_dashboardPositionTotalPL+g_externalPositionTotalPL),centerX+centerW-205,contentY+11,7,(g_dashboardPositionTotalPL+g_externalPositionTotalPL)>=0.0?green:red,true);
    }
    else
        AimeDashText("AimeDash_MatrixMeta",StringFormat("%d ASSETS",g_assetCount),centerX+centerW-70,contentY+11,7,cyan,true);
    int matrixX=centerX+8;
    int matrixW=centerW-16;
    int headY=contentY+36;
    int headH=25;
    AimeDashRect("AimeDash_MatrixHeadBg",matrixX,headY,matrixW,headH,card2,card2);
    int gapX=4;
    int colW[7];
    colW[0]=MathMax(58,(int)(matrixW*0.15));
    colW[1]=MathMax(45,(int)(matrixW*0.10));
    colW[2]=MathMax(65,(int)(matrixW*0.15));
    colW[3]=MathMax(62,(int)(matrixW*0.14));
    colW[4]=MathMax(55,(int)(matrixW*0.12));
    colW[5]=MathMax(62,(int)(matrixW*0.14));
    colW[6]=MathMax(82,(int)(matrixW*0.18));
    int used=0;
    for(int ci=0;ci<7;ci++) used+=colW[ci];
    int available=matrixW-gapX*6;
    int over=used-available;
    if(over>0)
    {
        int shrinkOrder[7]={6,4,3,5,1,2,0};
        for(int si=0;si<7 && over>0;si++)
        {
            int idx=shrinkOrder[si];
            int minW=idx==6?82:(idx==0?54:48);
            int can=colW[idx]-minW;
            int take=MathMin(can,over);
            colW[idx]-=take;
            over-=take;
        }
    }
    int hx[7];
    int cx=matrixX+7;
    string heads[7]={"SYMBOL","CLASS","PRICE","P/L","DATA","SIGNAL","POSITIONS"};
    if(positionsView)
    {
        heads[1]="TYPE";
        heads[4]="VOL";
        heads[5]="P/L %";
        heads[6]="AGE";
    }
    for(int hi=0;hi<7;hi++)
    {
        hx[hi]=cx;
        AimeDashText("AimeDash_Head"+IntegerToString(hi),heads[hi],hx[hi],headY+8,6,muted,true);
        cx+=colW[hi]+gapX;
    }
    int totalPages=positionsView
        ? MathMax(1,(g_dashboardPositionCount+ROWS_PER_PAGE-1)/ROWS_PER_PAGE)
        : GetTotalPages();
    if(g_dashPage>=totalPages) g_dashPage=MathMax(0,totalPages-1);
    int shown=0;
    int skipped=0;
    int rowY=headY+29;
    int matrixBottom=contentY+matrixH;
    int pageAreaH=matrixBottom-rowY-32;
    int rowH=MathMax(30,pageAreaH/MathMax(1,ROWS_PER_PAGE));
    if(rowH>36) rowH=36;
    if(positionsView)
    {
        int positionSkipped = 0;
        for(int pi=0; pi<g_dashboardPositionCount && shown<ROWS_PER_PAGE; pi++)
        {
            string sym = g_dashboardPositions[pi].symbol;
            string cls = AimeDashAssetClass(sym);
            bool include = (g_assetFilter==0) ||
                           (g_assetFilter==1 && cls=="FX") ||
                           (g_assetFilter==2 && cls=="CRYPTO") ||
                           (g_assetFilter==3 && cls=="STOCK") ||
                           (g_assetFilter==4 && cls=="INDEX") ||
                           (g_assetFilter==5 && cls=="METAL");
            if(!include) continue;

            if(positionSkipped < g_dashPage*ROWS_PER_PAGE)
            {
                positionSkipped++;
                continue;
            }

            int yy=rowY+shown*rowH;
            if(shown%2==0) AimeDashRect("AimeDash_RowBg"+IntegerToString(shown),matrixX,yy,matrixW,rowH-2,card,panel);
            else AimeDashRect("AimeDash_RowBg"+IntegerToString(shown),matrixX,yy,matrixW,rowH-2,panel,panel);

            double rowPL=g_dashboardPositions[pi].profit;
            double rowVolume=g_dashboardPositions[pi].volume;
            double entry=g_dashboardPositions[pi].entryPrice;
            double sl=g_dashboardPositions[pi].stopLoss;
            double tp=g_dashboardPositions[pi].takeProfit;
            datetime openTime=g_dashboardPositions[pi].openTime;
            ENUM_POSITION_TYPE posType=g_dashboardPositions[pi].type;

            MqlTick rowTick;
            double rowBid=0.0;
            if(SymbolInfoTick(sym,rowTick))
                rowBid=(posType==POSITION_TYPE_BUY)?rowTick.bid:rowTick.ask;

            int rowDigits=(int)SymbolInfoInteger(sym,SYMBOL_DIGITS);
            double costBasis=MathAbs(entry*rowVolume);
            double rowPLPct=costBasis>0.0?(rowPL/costBasis)*100.0:0.0;
            long ageSeconds=openTime>0?(long)(TimeCurrent()-openTime):0;
            if(ageSeconds<0) ageSeconds=0;

            string priceTxt=rowBid>0.0?DoubleToString(rowBid,rowDigits):"N/A";
            string typeTxt=posType==POSITION_TYPE_BUY?"BUY":"SELL";
            string plTxt=StringFormat("%+.2f",rowPL);
            string volTxt=StringFormat("%.2f",rowVolume);
            string plPctTxt=StringFormat("%+.2f%%",rowPLPct);
            string ageTxt=ageSeconds<3600?StringFormat("%dm",(int)(ageSeconds/60)):
                         (ageSeconds<86400?StringFormat("%dh",(int)(ageSeconds/3600)):
                         StringFormat("%dd",(int)(ageSeconds/86400)));

            string vals[7]={sym,typeTxt,priceTxt,plTxt,volTxt,plPctTxt,ageTxt};
            color vcs[7]={white,posType==POSITION_TYPE_BUY?green:red,white,rowPL>=0.0?green:red,white,rowPLPct>=0.0?green:red,muted};

            int rx=matrixX+7;
            int sizes[7]={8,6,6,6,6,6,6};
            for(int vi=0;vi<7;vi++)
            {
                string shownTxt=vals[vi];
                int maxChars=(int)MathMax(5.0,MathFloor((double)(colW[vi]-6)/5.0));
                shownTxt=AimeDashTrim(shownTxt,maxChars);

                if(vi==0)
                {
                    string posButtonId=StringFormat("AimeDash_PosMatrix_%I64u",g_dashboardPositions[pi].ticket);
                    AimeDashButton(posButtonId,shownTxt,rx,yy+2,colW[vi],rowH-6,
                                   g_dashboardPositions[pi].ticket==g_dashboardSelectedPositionTicket?card:card,
                                   divider,white);
                }
                else
                {
                    AimeDashText("AimeDash_Row"+IntegerToString(vi)+"_"+IntegerToString(shown),
                                 shownTxt,rx,yy+(rowH-2)/2-4,sizes[vi],vcs[vi],true);
                }
                rx+=colW[vi]+gapX;
            }

            shown++;
        }
    }
    else
    {
        for(int mi=0;mi<g_assetCount && shown<ROWS_PER_PAGE;mi++)
        {
            string sym=g_assets[mi].symbol;
            string cls=AimeDashAssetClass(sym);
            bool include=false;
            if(g_assetFilter==0) include=true;
            if(g_assetFilter==1 && cls=="FX") include=true;
            if(g_assetFilter==2 && cls=="CRYPTO") include=true;
            if(g_assetFilter==3 && cls=="STOCK") include=true;
            if(g_assetFilter==4 && cls=="INDEX") include=true;
            if(g_assetFilter==5 && cls=="METAL") include=true;
            if(!include) continue;
            if(skipped<g_dashPage*ROWS_PER_PAGE) { skipped++; continue; }

            string data=AimeDashSymbolState(mi);
            string sess=AimeDashSessionState(mi);
            double bs=0,ss=0,bt=0,stt=0;
            string sig=AimeDashSignalState(mi,bs,ss,bt,stt);
            double sp=0,cap=0;
            bool spreadBlocked=AimeAssetSpreadTooWide(mi,sp,cap);
            string exec=AimeDashExecutionState(mi);
            int yy=rowY+shown*rowH;
            if(shown%2==0) AimeDashRect("AimeDash_RowBg"+IntegerToString(shown),matrixX,yy,matrixW,rowH-2,card,panel);
            else AimeDashRect("AimeDash_RowBg"+IntegerToString(shown),matrixX,yy,matrixW,rowH-2,panel,panel);
            color dataC=AimeDashStateColor(data,green,yellow,red,muted);
            color sigC=StringFind(sig,"BUY")>=0?green:(StringFind(sig,"SELL")>=0?red:yellow);
            color entC=StringFind(exec,"READY")>=0?green:(StringFind(exec,"BLOCK")>=0||StringFind(exec,"LIMIT")>=0||exec=="SPREAD BLOCK"?red:yellow);

            MqlTick rowTick;
            double rowBid=0.0;
            if(SymbolInfoTick(sym,rowTick) && rowTick.bid>0.0) rowBid=rowTick.bid;
            int rowDigits=(int)SymbolInfoInteger(sym,SYMBOL_DIGITS);
            int rowPositions=AimeDashboardPositionCountForSymbol(sym);
            double rowPL=0.0;
            for(int dpi=0; dpi<g_dashboardPositionCount; dpi++)
                if(g_dashboardPositions[dpi].symbol==sym)
                    rowPL+=g_dashboardPositions[dpi].profit;

            string priceTxt=rowBid>0.0?DoubleToString(rowBid,rowDigits):"N/A";
            string vals[7]={sym,cls,priceTxt,StringFormat("%+.2f",rowPL),data,sig,IntegerToString(rowPositions)};
            color vcs[7]={white,muted,white,rowPL>=0.0?green:red,dataC,sigC,rowPositions>0?cyan:muted};

            int rx=matrixX+7;
            int sizes[7]={8,6,6,6,6,6,7};
            for(int vi=0;vi<7;vi++)
            {
                string shownTxt=vals[vi];
                int maxChars=(int)MathMax(5.0,MathFloor((double)(colW[vi]-6)/5.0));
                if(vi==0 || vi==1 || vi==2 || vi==4 || vi==5 || vi==6)
                    shownTxt=AimeDashTrim(shownTxt,maxChars);

                int ty=yy+(rowH-2)/2-4;
                if(vi==0)
                    AimeDashButton("AimeDash_Asset_"+IntegerToString(mi),shownTxt,rx,yy+2,colW[vi],rowH-6,card,divider,white);
                else
                    AimeDashText("AimeDash_Row"+IntegerToString(vi)+"_"+IntegerToString(shown),shownTxt,rx,ty,sizes[vi],vcs[vi],true);
                rx+=colW[vi]+gapX;
            }
            shown++;
        }
    }
    if(shown==0) AimeDashText("AimeDash_NoAssets",positionsView?"NO OPEN POSITIONS":"NO ASSETS MATCH FILTER",matrixX+20,rowY+20,8,muted,true);
    int pageY=matrixBottom-24;
    AimeDashText("AimeDash_Page",StringFormat("PAGE %d / %d",g_dashPage+1,totalPages),centerX+centerW/2-35,pageY,7,muted,true);
    AimeDashText("AimeDash_PrevPage","‹",centerX+centerW-83,pageY-3,14,white,true);
    AimeDashText("AimeDash_NextPage","›",centerX+centerW-58,pageY-3,14,white,true);
    AimeDashText("AimeDash_FirstPage","«",centerX+centerW-105,pageY-2,10,muted,true);
    AimeDashText("AimeDash_LastPage","»",centerX+centerW-43,pageY-2,10,muted,true);
    AimeDashRect("AimeDash_Selected",rightX,contentY,rightW,topH,panel,border);
    string selectedSym=g_dashboardSelectedSymbol!=""?g_dashboardSelectedSymbol:g_chartSymbol;
    int selectedIdx=FindAssetIndex(selectedSym);
    if(selectedIdx<0 && g_assetCount>0) { selectedIdx=FindAssetIndex(g_chartSymbol); if(selectedIdx<0) selectedIdx=0; selectedSym=g_assets[selectedIdx].symbol; }
    MqlTick qt;
    double qBid=0,qAsk=0;
    if(SymbolInfoTick(selectedSym,qt)) { qBid=qt.bid; qAsk=qt.ask; }
    int qDigits=(int)SymbolInfoInteger(selectedSym,SYMBOL_DIGITS);
    string qSignal="UNKNOWN",qExec="UNKNOWN",qSession="UNKNOWN",qData="UNKNOWN";
    double qBuy=0,qSell=0,qBT=0,qST=0,qSpread=0,qCap=0;
    if(selectedIdx>=0)
    {
        qSignal=AimeDashSignalState(selectedIdx,qBuy,qSell,qBT,qST);
        qExec=AimeDashExecutionState(selectedIdx);
        qSession=AimeDashSessionState(selectedIdx);
        qData=AimeDashSymbolState(selectedIdx);
        AimeAssetSpreadTooWide(selectedIdx,qSpread,qCap);
    }
    color qSignalC=StringFind(qSignal,"BUY")>=0?green:(StringFind(qSignal,"SELL")>=0?red:yellow);
    color qExecC=StringFind(qExec,"READY")>=0?green:(StringFind(qExec,"BLOCK")>=0||StringFind(qExec,"LIMIT")>=0?red:yellow);
    AimeDashText("AimeDash_SelectedTitle","SELECTED ASSET",rightX+12,contentY+10,8,muted,true);
    AimeDashText("AimeDash_SelectedSym",selectedSym,rightX+12,contentY+27,17,white,true);
    AimeDashText("AimeDash_SelectedClass",selectedIdx>=0?AimeDashAssetClass(selectedSym):"UNKNOWN",rightX+rightW-65,contentY+30,7,cyan,true);
    long qTickAge=-1;
    if(selectedIdx>=0 && g_assets[selectedIdx].feedLastTickTime>0)
    {
        datetime qNow=TimeTradeServer();
        if(qNow<=0) qNow=TimeCurrent();
        qTickAge=(long)(qNow-g_assets[selectedIdx].feedLastTickTime);
        if(qTickAge<0) qTickAge=0;
    }
    string qTickAgeText=qTickAge>=0?StringFormat("%ds",(int)MathMax(0,qTickAge)):"N/A";
    AimeDashText("AimeDash_SelectedPrice",qBid>0?DoubleToString(qBid,qDigits):"N/A",rightX+12,contentY+52,11,white,true);
    AimeDashText("AimeDash_SelectedExec",qExec,rightX+125,contentY+54,7,qExecC,true);
    AimeDashText("AimeDash_SelectedTickAge",StringFormat("TICK %s",qTickAgeText),rightX+12,contentY+67,6,qTickAge<=2?green:yellow,true);
    int qy=contentY+84;
    string qL[6]={"DATA","SESSION","SIGNAL","BUY / SELL","SPREAD","BAR AGE"};
    string qV[6]={qData,qSession,qSignal,StringFormat("%.2f / %.2f",qBuy,qSell),EnableMaxSpreadFilter?StringFormat("%.0f / %.0f",qSpread,qCap):"OFF",selectedIdx>=0?AimeDashSignalAge(selectedIdx):"N/A"};
    for(int qi=0;qi<6;qi++)
    {
        int qrow=qi/2;
        int qcol=qi%2;
        int qx=rightX+12+qcol*((rightW-28)/2);
        int qyy=qy+qrow*43;
        AimeDashText("AimeDash_QLabel"+IntegerToString(qi),qL[qi],qx,qyy,6,muted,true);
        color qc=qi==2?qSignalC:(qi==4&&qCap>0&&qSpread>qCap?red:white);
        AimeDashText("AimeDash_QValue"+IntegerToString(qi),AimeDashTrim(qV[qi],17),qx,qyy+14,8,qc,true);
    }
    AimeDashRect("AimeDash_Decision",rightX,bottomY,rightW,bottomH,panel,border);
    AimeDashText("AimeDash_DecisionTitle","DECISION & EXECUTION",rightX+12,bottomY+10,10,white,true);
    string finalDecision="WAIT";
    color finalColor=yellow;
    string finalReason="NO QUALIFIED SIGNAL";
    if(selectedIdx>=0)
    {
        finalDecision=AimeDashDecisionStatus(selectedIdx);
        finalReason=AimeDashDecisionReason(selectedIdx);
        if(finalDecision=="BUY READY") finalColor=green;
        else if(finalDecision=="SELL READY" || finalDecision=="BLOCKED") finalColor=red;
    }
    if(g_emergencyStop)
    {
        finalDecision="ENTRY BLOCKED";
        finalColor=red;
        finalReason=g_emergencyStopReason==""?"EMERGENCY STOP":g_emergencyStopReason;
    }
    else if(!accountReady)
    {
        finalDecision="ENTRY BLOCKED";
        finalColor=red;
        finalReason=g_accountSnapshotReason;
    }
    else if(qData=="STALE TICK" || qData=="NO TICK" || qData=="OFFLINE" || qData=="TICK WAIT" || qData=="HISTORY WAIT" || qData=="INDICATOR WAIT" || qData=="MARKET CLOSED" || qData=="SESSION UNKNOWN")
    {
        finalDecision="ENTRY BLOCKED";
        finalColor=red;
        finalReason=qData;
    }
    else if(StringFind(qExec,"BLOCK")>=0 || StringFind(qExec,"LIMIT")>=0 || qExec=="SPREAD BLOCK" || qExec=="MARKET CLOSED" || qExec=="HOURS BLOCK" || qExec=="RISK BLOCK" || qExec=="SESSION UNKNOWN")
    {
        finalDecision="ENTRY BLOCKED";
        finalColor=red;
        finalReason=qExec;
    }
    AimeDashRect("AimeDash_DecisionBanner",rightX+12,bottomY+35,rightW-24,54,card2,divider);
    AimeDashText("AimeDash_DecisionValue",finalDecision,rightX+22,bottomY+46,13,finalColor,true);
    AimeDashText("AimeDash_DecisionReason",AimeDashTrim(finalReason,35),rightX+22,bottomY+67,7,white,true);

    double confidencePct=0.0;
    if(selectedIdx>=0)
    {
        double edgeNorm=MathMin(1.0,g_assets[selectedIdx].strategyEdge/MathMax(0.01,AimeBuySignalThresholdForSymbol(selectedSym)));
        double setupNorm=MathMin(1.0,g_assets[selectedIdx].strategySetupQuality/MathMax(0.01,MinSetupQuality));
        double timingNorm=MathMin(1.0,g_assets[selectedIdx].strategyTimingQuality/MathMax(0.01,MinTimingQuality));
        confidencePct=((edgeNorm+setupNorm+timingNorm)/3.0)*100.0;
        confidencePct=MathMax(0.0,MathMin(100.0,confidencePct));
    }
    color confColor=confidencePct>=80?green:(confidencePct>=45?yellow:red);
    string diagScore="SCORE --";
    string diagEdge="EDGE --";
    string diagSetup="SETUP --";
    string diagTiming="TIMING --";
    if(selectedIdx>=0)
    {
        double dsBuy=g_assets[selectedIdx].buyStrengthValid ? g_assets[selectedIdx].cachedBuyStrength.finalScore : 0.0;
        double dsSell=g_assets[selectedIdx].sellStrengthValid ? g_assets[selectedIdx].cachedSellStrength.finalScore : 0.0;
        double dsThreshold=dsBuy>=dsSell ? AimeBuySignalThresholdForSymbol(selectedSym) : AimeSellSignalThresholdForSymbol(selectedSym);
        diagScore=StringFormat("SCORE %.2f / %.2f",MathMax(dsBuy,dsSell),dsThreshold);
        diagEdge=StringFormat("EDGE %.2f | CONF %.0f%%",g_assets[selectedIdx].strategyEdge,confidencePct);
        diagSetup=StringFormat("SETUP %.2f %s",g_assets[selectedIdx].strategySetupQuality,g_assets[selectedIdx].strategySetupPass?"PASS":"FAIL");
        diagTiming=StringFormat("TIMING %.2f %s",g_assets[selectedIdx].strategyTimingQuality,g_assets[selectedIdx].strategyTimingPass?"PASS":"FAIL");
    }
    AimeDashText("AimeDash_DiagScore",diagScore,rightX+22,bottomY+82,6,muted,true);
    AimeDashText("AimeDash_DiagEdge",diagEdge,rightX+132,bottomY+82,6,confColor,true);
    AimeDashText("AimeDash_DiagSetup",diagSetup,rightX+22,bottomY+94,6,muted,true);
    AimeDashText("AimeDash_DiagTiming",diagTiming,rightX+132,bottomY+94,6,muted,true);
    string traceStage = selectedIdx>=0 ? g_assets[selectedIdx].decisionStage : "INIT";
    string traceText = selectedIdx>=0 ? g_assets[selectedIdx].decisionTrace : "DATA=INVALID | FINAL=WAIT | REASON=ASSET UNAVAILABLE";
    AimeDashText("AimeDash_DecisionStage",StringFormat("STAGE %s",AimeDashTrim(traceStage,18)),rightX+22,bottomY+106,6,cyan,true);
    AimeDashText("AimeDash_DecisionTrace",AimeDashTrim(traceText,58),rightX+22,bottomY+118,5,muted,true);
    int dy=bottomY+113;
    string dL[7]={"STOP LOSS","SPREAD FILTER","PORTFOLIO","PROTECTION","SESSION","SIGNAL","FINAL"};
    string dV[7]={"REQUIRED",EnableMaxSpreadFilter?(qCap>0&&qSpread<=qCap?"PASS":"BLOCKED"):"DISABLED",(MaxPortfolioPositions<=0||AimePortfolioExposureSlots()<MaxPortfolioPositions)?"PASS":"LIMIT","ACTIVE",qSession,qSignal,finalDecision};
    for(int di=0;di<7;di++)
    {
        int dyy=dy+di*24;
        AimeDashText("AimeDash_DLabel"+IntegerToString(di),dL[di],rightX+14,dyy,6,muted,true);
        bool pass=di==0 || dV[di]=="PASS" || (di==3 && !g_riskHardLocked) || (di==4 && dV[di]=="OPEN") || (di==5 && (dV[di]=="BUY SIGNAL" || dV[di]=="SELL SIGNAL"));
        color dc=(di==6?finalColor:(pass?green:(dV[di]=="DISABLED"?muted:red)));
        AimeDashText("AimeDash_DValue"+IntegerToString(di),AimeDashTrim(dV[di],22),rightX+112,dyy,7,dc,true);
    }
        if(g_dashTab==3) AimeDashPositionDetails(rightX,bottomY,rightW,bottomH,panel,border,card2,white,muted,green,red,yellow);
AimeDashRect("AimeDash_Lifecycle",leftX,bottomY,leftW,bottomH,panel,border);
    AimeDashText("AimeDash_LifeTitle","ENGINE HEALTH",leftX+12,bottomY+10,10,cyan,true);
    string eL[6]={"DATA ENGINE","SIGNAL ENGINE","RISK GOVERNOR","EXECUTION","POSITION MANAGER","DASHBOARD"};
    string eV[6]={"READY","READY",riskPass?"READY":"BLOCKED",systemActive?"READY":"LOCKED",open>0?"MANAGING":"STANDBY","STABLE"};
    for(int ei=0;ei<6;ei++)
    {
        int ey=bottomY+44+ei*((bottomH-53)/6);
        AimeDashRect("AimeDash_HealthDot"+IntegerToString(ei),leftX+12,ey+1,8,8,(eV[ei]=="READY"||eV[ei]=="STABLE"||eV[ei]=="MANAGING")?green:(eV[ei]=="BLOCKED"||eV[ei]=="LOCKED"?red:yellow),divider);
        AimeDashText("AimeDash_HealthL"+IntegerToString(ei),eL[ei],leftX+27,ey,7,white,true);
        AimeDashText("AimeDash_HealthV"+IntegerToString(ei),eV[ei],leftX+145,ey,7,(eV[ei]=="READY"||eV[ei]=="STABLE"||eV[ei]=="MANAGING")?green:(eV[ei]=="BLOCKED"||eV[ei]=="LOCKED"?red:yellow),true);
    }
    AimeDashRect("AimeDash_Footer",x+4,footerY,w-8,footerH,panel,border);
    AimeDashText("AimeDash_F0","AIME PROGRAMMER v45.52",x+13,footerY+6,7,cyan,true);
    AimeDashText("AimeDash_F1",StringFormat("TF %s",AimeDashTimeframe()),x+170,footerY+6,7,muted,true);
    AimeDashText("AimeDash_F2",StringFormat("OPEN %d  |  RISK %.2f%%",open,riskPct),x+235,footerY+6,7,muted,true);
    AimeDashText("AimeDash_F3",systemActive?"REAL EXECUTION":"PROTECTION MODE",x+w-145,footerY+6,7,systemActive?green:red,true);
    TradeStats dashDaily,dashAll; GetTradeStats(dashDaily,dashAll);
    double winRate=dashAll.count>0?((double)dashAll.won/dashAll.count)*100.0:0.0;
    double pfWin = dashAll.profit;
    double pfLoss = MathAbs(dashAll.loss);

    double profitFactor = pfLoss > 0.0 ? (pfWin / pfLoss) : (pfWin > 0.0 ? DBL_MAX : 0.0);
    string pfText = (dashAll.count < 20) ? "PF n/a (<20 trades)" : (profitFactor >= DBL_MAX/2.0 ? "PF ∞" : StringFormat("PF %.2f", profitFactor));
    AimeDashText("AimeDash_F4",StringFormat("WR %.1f%%  %s  NET %+.2f  %s",winRate,pfText,dashAll.profit+dashAll.loss,AimeSessionName()),x+w-430,footerY+6,7,muted,true);
    AimeDashText("AimeDash_LiveStamp",StringFormat("LIVE %s",TimeToString(TimeTradeServer(),TIME_SECONDS)),x+w-120,footerY-10,6,cyan,true);
    if(g_emergencyStop) AimeDashText("AimeDash_EmergencyState","EMERGENCY STOP ACTIVE",x+13,footerY-14,7,red,true); else ObjectDelete(0,"AimeDash_EmergencyState");
    if(g_dashTab==3)
    {
        ObjectDelete(0,"AimeDash_Decision");
        ObjectDelete(0,"AimeDash_DecisionTitle");
        ObjectDelete(0,"AimeDash_DecisionBanner");
        ObjectDelete(0,"AimeDash_DecisionValue");
        ObjectDelete(0,"AimeDash_DecisionReason");
        ObjectDelete(0,"AimeDash_DiagScore");
        ObjectDelete(0,"AimeDash_DiagEdge");
        ObjectDelete(0,"AimeDash_DiagSetup");
        ObjectDelete(0,"AimeDash_DiagTiming");
        ObjectDelete(0,"AimeDash_DecisionStage");
        ObjectDelete(0,"AimeDash_DecisionTrace");
        for(int z=0;z<7;z++){ ObjectDelete(0,"AimeDash_DLabel"+IntegerToString(z)); ObjectDelete(0,"AimeDash_DValue"+IntegerToString(z)); }
    }
ChartRedraw(0);
    g_lastDashboardUpdate=TimeLocal();
    g_dashboardRendering=false;
}