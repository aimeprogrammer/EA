#property copyright "© Copyright Aime"
#property version "46.00"
#property description "Production-Ready EA with Refactored Architecture"
#property strict

#include <Trade\Trade.mqh>
#include <WinAPI\winapi.mqh>

#define LogPrint if(EnableLogging) Print
#define MT_WMCMD_EXPERTS 32851
#define WM_COMMAND 0x0111
#define GA_ROOT 2

enum ENUM_INPUT_TYPE { INPUT_DOLLAR, INPUT_PERCENT, INPUT_POINTS };
enum ENUM_RR_RISK_MODE { RR_RISK_MANUAL, RR_RISK_ATR };
enum ENUM_LIMIT_ANCHOR { LIMIT_ANCHOR_FIXED_ATR, LIMIT_ANCHOR_EMA, LIMIT_ANCHOR_SWING, LIMIT_ANCHOR_SMART };
enum ENUM_AIME_LANGUAGE { AIME_LANG_EN, AIME_LANG_FR, AIME_LANG_RW };

input ENUM_AIME_LANGUAGE DashboardLanguage = AIME_LANG_EN;

input group "📊 Indicator Settings";
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

input group "⚖️ Score Weight Settings";
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

input group "📝 Order & Position Settings";
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

input group "🎯 Asset-Class Signal Profiles";
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

input group "🧠 Institutional Strategy Core";
input bool EnableInstitutionalStrategyCore = true;
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
input double MaxFXClassRiskPct = 3.0;
input double MaxMetalClassRiskPct = 1.5;
input double MaxIndexClassRiskPct = 1.5;
input double MaxStockClassRiskPct = 2.0;
input double MaxCryptoClassRiskPct = 1.0;

input group "🧯 Risk Management Core";
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

input group "⚖️ Risk:Reward Settings";
input bool EnableRiskReward = true;
input ENUM_RR_RISK_MODE RRRiskMode = RR_RISK_ATR;
input ENUM_INPUT_TYPE RRRiskInputType = INPUT_POINTS;
input double RRRiskValue = 200.0;
input double RRAtrMultiplier = 1.5;
input double RiskRewardRatio = 1.5;
input double MinimumEntryRR = 1.50;

input group "💸 Trailing & Take Profit";
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
input double PreTradeTPATRMultiplier = 2.20;

input group "🩺 Loss Management";
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
input bool EnableProfitOffsetSL = true;
input int ConsecutiveWinsRequired = 3;
input double MinOffsetProfit = 1.0;

input group "🏦 Equity Management";
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

input group "⏰ Session & Schedule";
input bool EnableTradingHours = false;
input string TradingStartTime = "00:00";
input string TradingEndTime = "23:59";
input bool EnableMarketCloseFilter = true;
input int MinutesBeforeClose = 30;
input bool EnableNewsFilter = true;
input int NewsMinutesBefore = 30;
input int NewsMinutesAfter = 30;

input group "🌐 Multi-Asset";
input bool EnableMultiAsset = true;
input string MultiAssetSymbols = "";
input ENUM_TIMEFRAMES MultiAssetTimeframe = PERIOD_CURRENT;
input int MultiAssetTimerSeconds = 1;
input bool EnableMarketWatchDiscovery = true;
input int MarketWatchScanSeconds = 10;
input int MaxDiscoveredAssets = 50;
input bool EnablePortfolioPositionLimit = true;
input int MaxPortfolioPositions = 12;

input group "🔧 Execution & Logging";
input bool EnableLogging = false;
input bool EnableTradeSounds = true;
input long DynamicMagicBase = 6927000;
input bool AcceptLegacyMagicNumbers = true;
input bool ShowExternalPositions = true;
input int GlobalTradeLockSeconds = 3;
input int EntryFingerprintSeconds = 10;
input int DashboardMaxTickAgeSeconds = 5;
input bool EnableDecisionTrace = true;

const string EA_PASSWORD = "";

struct SignalDecision
{
    bool valid;
    string direction;
    double strength;
    double confidence;
    string regime;
    double edgeQuality;
    double timingQuality;
    string failureReason;
    datetime validUntil;
};

struct RiskValidation
{
    bool passed;
    double calculatedRisk;
    double calculatedTP;
    double calculatedSL;
    double riskRewardRatio;
    string blockedReason;
    double portfolioImpact;
    int positionsForSymbol;
};

struct OrderRequest
{
    string symbol;
    ENUM_POSITION_TYPE type;
    double volume;
    double entryPrice;
    double stopLossPrice;
    double takeProfitPrice;
    string reason;
    long magicNumber;
};

struct OrderResult
{
    bool success;
    ulong ticket;
    string errorMessage;
    double executionPrice;
    datetime executionTime;
    double slippage;
};

enum POSITION_STATE { STATE_ENTRY_PENDING, STATE_ENTERED, STATE_TRAILING, STATE_CLOSING, STATE_CLOSED, STATE_ERROR };

struct PositionLifecycle
{
    ulong ticket;
    ENUM_POSITION_TYPE type;
    string symbol;
    long magic;
    double entryPrice;
    datetime entryTime;
    double initialVolume;
    double riskAmount;
    double targetProfit;
    double minRRRatio;
    double hardSL;
    double trailingSL;
    double breakEvenSL;
    double targetTP;
    double adaptiveTP;
    double partialTP1;
    double partialTP2;
    int partialCloseLevel;
    int barsHeld;
    double maxProfit;
    double maxLoss;
    bool profitLocked;
    bool trailingActive;
    bool closed;
    double closePrice;
    datetime closeTime;
    int closeReason;
    double finalProfit;
    POSITION_STATE state;
};

struct RiskProfile
{
    double riskPerTrade;
    double maxDrawdown;
    double minRRRatio;
    double dailyMaxLoss;
    double maxConcurrentRisk;
};

struct RiskCalculation
{
    double accountRisk;
    double volumeToTrade;
    double stopLossPrice;
    double takeProfitPrice;
    double calculatedRR;
    bool meetsMinimumRR;
    string reason;
};

struct DailyStats
{
    datetime tradeDate;
    int tradeCount;
    double totalProfit;
    double totalLoss;
    double netResult;
    double maxDrawdown;
    bool dailyLimitExceeded;
};

class DecisionEngine
{
public:
    SignalDecision EvaluateSignal(string symbol, ENUM_TIMEFRAMES tf)
    {
        SignalDecision sig = {0, "WAIT", 0, 0, "UNINITIALIZED", 0, 0, "DATA PENDING", 0};
        
        if (!IsDataReady(symbol, tf))
        {
            sig.failureReason = "DATA NOT READY";
            return sig;
        }
        
        string regime = IdentifyRegime(symbol, tf);
        
        double trendScore = CalculateTrendScore(symbol, tf);
        double momentumScore = CalculateMomentumScore(symbol, tf);
        double structureScore = CalculateStructureScore(symbol, tf);
        double timeScore = CalculateTimingScore(symbol, tf);
        
        double weightedSignal = AggregateByRegime(regime, trendScore, momentumScore, structureScore, timeScore);
        double confidence = CalculateConfidence(trendScore, momentumScore, structureScore, regime);
        
        string direction = DetermineDirection(weightedSignal, confidence);
        
        if (!PassesQualityGates(direction, weightedSignal, regime))
        {
            sig.failureReason = "QUALITY GATE FAILED";
            return sig;
        }
        
        sig.valid = true;
        sig.direction = direction;
        sig.strength = weightedSignal;
        sig.confidence = confidence;
        sig.regime = regime;
        sig.edgeQuality = CalculateEdgeQuality(trendScore, structureScore);
        sig.timingQuality = timeScore / 10.0;
        sig.validUntil = TimeCurrent() + PeriodSeconds(PERIOD_CURRENT);
        
        return sig;
    }

private:
    bool IsDataReady(string symbol, ENUM_TIMEFRAMES tf)
    {
        return Bars(symbol, tf) > MathMax(EMASlowPeriod, ATRAvgLookback) * 2;
    }
    
    string IdentifyRegime(string symbol, ENUM_TIMEFRAMES tf)
    {
        double atr = GetATRValue(symbol, tf, ATRPeriod);
        double atrMA = GetATRAverage(symbol, tf, ATRAvgLookback);
        double atrRatio = atrMA > 0 ? atr / atrMA : 1.0;
        
        double rsi = GetRSIValue(symbol, tf, RSIPeriod);
        double emaFast = GetEMA(symbol, tf, EMAFastPeriod);
        double emaSlow = GetEMA(symbol, tf, EMASlowPeriod);
        double trendStrength = atr > 0 ? MathAbs(emaFast - emaSlow) / atr : 0;
        
        if (trendStrength > TrendSeparationATR)
            return rsi > 50 ? "TREND_UP" : "TREND_DOWN";
        if (atrRatio > 1.2)
            return "BREAKOUT";
        if (atrRatio < 0.8)
            return "RANGE_TIGHT";
        return "RANGE_NORMAL";
    }
    
    double CalculateTrendScore(string symbol, ENUM_TIMEFRAMES tf)
    {
        double emaFast = GetEMA(symbol, tf, EMAFastPeriod);
        double emaSlow = GetEMA(symbol, tf, EMASlowPeriod);
        double rsi = GetRSIValue(symbol, tf, RSIPeriod);
        
        double slope = (emaFast - emaSlow) / EmaSlopeDivisor(symbol, tf);
        double rsiTrend = (rsi - 50.0) / 50.0;
        
        return (MathAbs(slope) * 5.0 + MathAbs(rsiTrend) * 5.0) / 2.0;
    }
    
    double CalculateMomentumScore(string symbol, ENUM_TIMEFRAMES tf)
    {
        double rsi = GetRSIValue(symbol, tf, RSIPeriod);
        double momentum = 0;
        
        if (rsi > RSIMomentumBuy)
            momentum = MathMin(10.0, 5.0 + (rsi - RSIMomentumBuy) / 10.0);
        else if (rsi < RSIMomentumSell)
            momentum = MathMin(10.0, 5.0 + (RSIMomentumSell - rsi) / 10.0);
        else
            momentum = 5.0;
        
        return momentum;
    }
    
    double CalculateStructureScore(string symbol, ENUM_TIMEFRAMES tf)
    {
        double close = Close(symbol, tf, 0);
        double high = High(symbol, tf, 0);
        double low = Low(symbol, tf, 0);
        double bodySize = MathAbs(close - Open(symbol, tf, 0));
        double range = high - low;
        
        return range > 0 ? (bodySize / range) * 10.0 : 5.0;
    }
    
    double CalculateTimingScore(string symbol, ENUM_TIMEFRAMES tf)
    {
        double close = Close(symbol, tf, 0);
        double high = High(symbol, tf, 0);
        double low = Low(symbol, tf, 0);
        double range = high - low;
        
        if (range <= 0) return 5.0;
        
        double position = (close - low) / range;
        return position > 0.5 ? (position * 10.0) : ((1.0 - position) * 10.0);
    }
    
    double AggregateByRegime(string regime, double trend, double momentum, double structure, double timing)
    {
        if (regime == "TREND_UP" || regime == "TREND_DOWN")
            return (trend * 0.40 + momentum * 0.30 + structure * 0.20 + timing * 0.10);
        if (regime == "BREAKOUT")
            return (structure * 0.35 + momentum * 0.35 + trend * 0.20 + timing * 0.10);
        return (momentum * 0.35 + structure * 0.35 + timing * 0.20 + trend * 0.10);
    }
    
    double CalculateConfidence(double trend, double momentum, double structure, string regime)
    {
        double maxScore = MathMax(trend, MathMax(momentum, structure));
        double minScore = MathMin(trend, MathMin(momentum, structure));
        double spread = maxScore - minScore;
        double agreement = 1.0 - (spread / 10.0);
        
        return MathMax(0, MathMin(1, agreement * 0.6 + 0.4));
    }
    
    string DetermineDirection(double strength, double confidence)
    {
        if (strength < 4.5 || confidence < 0.4)
            return "WAIT";
        return strength >= 5.5 ? "BUY" : "SELL";
    }
    
    bool PassesQualityGates(string direction, double strength, string regime)
    {
        if (direction == "WAIT") return false;
        
        double minStrength = 4.5;
        if (regime == "TREND_UP" || regime == "TREND_DOWN")
            minStrength = 4.8;
        if (regime == "BREAKOUT")
            minStrength = 5.2;
        
        return strength >= minStrength;
    }
    
    double CalculateEdgeQuality(double trend, double structure)
    {
        return (trend * 0.6 + structure * 0.4) / 10.0;
    }
    
    double EmaSlopeDivisor(string symbol, ENUM_TIMEFRAMES tf)
    {
        double atr = GetATRValue(symbol, tf, ATRPeriod);
        return atr > 0 ? atr : 1.0;
    }
};

class OrderExecutionManager
{
public:
    OrderResult ExecuteOrder(OrderRequest& req)
    {
        OrderResult result = {false, 0, "", 0, 0, 0};
        
        if (!ValidateOrderRequest(req, result)) return result;
        if (!CheckAccountState(req.symbol, result)) return result;
        if (!ValidateStopLevels(req, result)) return result;
        if (!CheckSpreadLimits(req.symbol, result)) return result;
        
        MqlTick tick;
        if (!SymbolInfoTick(req.symbol, tick))
        {
            result.errorMessage = "Cannot get current tick";
            return result;
        }
        
        CTrade trade;
        trade.SetDeviationInPoints(20);
        trade.SetAsyncMode(false);
        
        bool orderPlaced = false;
        if (req.type == POSITION_TYPE_BUY)
            orderPlaced = trade.Buy(req.volume, req.symbol, 0, req.stopLossPrice, req.takeProfitPrice);
        else
            orderPlaced = trade.Sell(req.volume, req.symbol, 0, req.stopLossPrice, req.takeProfitPrice);
        
        if (orderPlaced)
        {
            result.success = true;
            result.ticket = trade.ResultOrder();
            result.executionPrice = trade.ResultPrice();
            result.executionTime = TimeCurrent();
            result.slippage = CalculateSlippage(req.entryPrice, result.executionPrice);
        }
        else
        {
            result.errorMessage = trade.ResultRetcodeDescription();
        }
        
        return result;
    }

private:
    bool ValidateOrderRequest(OrderRequest& req, OrderResult& result)
    {
        if (req.symbol == "" || req.volume <= 0)
        {
            result.errorMessage = "Invalid symbol or volume";
            return false;
        }
        
        if (req.stopLossPrice == 0 || req.takeProfitPrice == 0)
        {
            result.errorMessage = "SL and TP must be non-zero";
            return false;
        }
        
        if (req.type == POSITION_TYPE_BUY)
        {
            if (req.stopLossPrice >= req.entryPrice || req.takeProfitPrice <= req.entryPrice)
            {
                result.errorMessage = "Invalid SL/TP for BUY";
                return false;
            }
        }
        else
        {
            if (req.stopLossPrice <= req.entryPrice || req.takeProfitPrice >= req.entryPrice)
            {
                result.errorMessage = "Invalid SL/TP for SELL";
                return false;
            }
        }
        
        return true;
    }
    
    bool CheckAccountState(string symbol, OrderResult& result)
    {
        double freeMargin = AccountInfoDouble(ACCOUNT_FREEMARGIN);
        double equity = AccountInfoDouble(ACCOUNT_EQUITY);
        double balance = AccountInfoDouble(ACCOUNT_BALANCE);
        
        if (freeMargin < 100)
        {
            result.errorMessage = "Insufficient margin";
            return false;
        }
        
        if (equity < balance * 0.5)
        {
            result.errorMessage = "Equity fallen below 50% of balance";
            return false;
        }
        
        return true;
    }
    
    bool ValidateStopLevels(OrderRequest& req, OrderResult& result)
    {
        double minStopDistance = SymbolInfoInteger(req.symbol, SYMBOL_TRADE_STOPS_LEVEL) 
                                * SymbolInfoDouble(req.symbol, SYMBOL_POINT);
        
        double slDistance = MathAbs(req.entryPrice - req.stopLossPrice);
        double tpDistance = MathAbs(req.takeProfitPrice - req.entryPrice);
        
        if (slDistance < minStopDistance || tpDistance < minStopDistance)
        {
            result.errorMessage = "SL or TP too close to entry";
            return false;
        }
        
        return true;
    }
    
    bool CheckSpreadLimits(string symbol, OrderResult& result)
    {
        MqlTick tick;
        if (!SymbolInfoTick(symbol, tick))
        {
            result.errorMessage = "Cannot get tick";
            return false;
        }
        
        double spread = (tick.ask - tick.bid) / SymbolInfoDouble(symbol, SYMBOL_POINT);
        double atr = GetATRValue(symbol, PERIOD_CURRENT, ATRPeriod);
        double atrPoints = atr / SymbolInfoDouble(symbol, SYMBOL_POINT);
        
        if (spread > (atrPoints * MaxSpreadATRRatio))
        {
            result.errorMessage = "Spread too wide";
            return false;
        }
        
        return true;
    }
    
    double CalculateSlippage(double expected, double actual)
    {
        return MathAbs(expected - actual);
    }
};

class PositionManager
{
public:
    void UpdatePosition(PositionLifecycle& pos)
    {
        if (!PositionSelectByTicket(pos.ticket))
        {
            pos.closed = true;
            return;
        }
        
        double currentPrice = PositionGetDouble(POSITION_PRICE_CURRENT);
        double profit = PositionGetDouble(POSITION_PROFIT);
        
        pos.barsHeld++;
        if (profit > pos.maxProfit) pos.maxProfit = profit;
        if (profit < pos.maxLoss) pos.maxLoss = profit;
        
        UpdateStopLevels(pos, currentPrice);
        CheckPartialCloses(pos, profit);
        UpdateTakeProfitAdaptively(pos, currentPrice);
    }

private:
    void UpdateStopLevels(PositionLifecycle& pos, double currentPrice)
    {
        double point = SymbolInfoDouble(pos.symbol, SYMBOL_POINT);
        double atr = GetATRValue(pos.symbol, PERIOD_CURRENT, ATRPeriod);
        
        if (pos.type == POSITION_TYPE_BUY)
        {
            double newTrailingSL = currentPrice - (atr * 1.5);
            if (newTrailingSL > pos.trailingSL)
                pos.trailingSL = newTrailingSL;
            
            if (currentPrice > pos.entryPrice + (atr * 0.5))
            {
                if (pos.breakEvenSL < pos.entryPrice)
                    pos.breakEvenSL = pos.entryPrice + (20 * point);
            }
        }
        else
        {
            double newTrailingSL = currentPrice + (atr * 1.5);
            if (newTrailingSL < pos.trailingSL)
                pos.trailingSL = newTrailingSL;
            
            if (currentPrice < pos.entryPrice - (atr * 0.5))
            {
                if (pos.breakEvenSL > pos.entryPrice)
                    pos.breakEvenSL = pos.entryPrice - (20 * point);
            }
        }
        
        double effectiveSL = MathMax(pos.breakEvenSL, pos.trailingSL);
        if (effectiveSL > pos.hardSL)
        {
            CTrade trade;
            trade.PositionModify(pos.ticket, effectiveSL, pos.adaptiveTP);
        }
    }
    
    void CheckPartialCloses(PositionLifecycle& pos, double profit)
    {
        if (!EnablePartialClose) return;
        
        if (pos.type == POSITION_TYPE_BUY)
        {
            if (pos.partialCloseLevel < 1 && PositionGetDouble(POSITION_PRICE_CURRENT) >= pos.partialTP1)
            {
                ClosePartial(pos, 0.25, "PARTIAL_TP1");
                pos.partialCloseLevel = 1;
            }
            else if (pos.partialCloseLevel >= 1 && PositionGetDouble(POSITION_PRICE_CURRENT) >= pos.partialTP2)
            {
                ClosePartial(pos, 0.25, "PARTIAL_TP2");
                pos.partialCloseLevel = 2;
            }
        }
        else
        {
            if (pos.partialCloseLevel < 1 && PositionGetDouble(POSITION_PRICE_CURRENT) <= pos.partialTP1)
            {
                ClosePartial(pos, 0.25, "PARTIAL_TP1");
                pos.partialCloseLevel = 1;
            }
            else if (pos.partialCloseLevel >= 1 && PositionGetDouble(POSITION_PRICE_CURRENT) <= pos.partialTP2)
            {
                ClosePartial(pos, 0.25, "PARTIAL_TP2");
                pos.partialCloseLevel = 2;
            }
        }
    }
    
    void ClosePartial(PositionLifecycle& pos, double percentage, string reason)
    {
        double closeVolume = PositionGetDouble(POSITION_VOLUME) * percentage;
        CTrade trade;
        trade.Close(pos.ticket, (ulong)closeVolume);
    }
    
    void UpdateTakeProfitAdaptively(PositionLifecycle& pos, double currentPrice)
    {
        if (!EnableAdaptiveTP) return;
        
        double trend = GetTrendStrength(pos.symbol);
        if (trend > 0.8)
        {
            double atr = GetATRValue(pos.symbol, PERIOD_CURRENT, ATRPeriod);
            double newTP = pos.targetTP + (atr * 0.5);
            if (newTP > pos.adaptiveTP)
            {
                pos.adaptiveTP = newTP;
                CTrade trade;
                trade.PositionModify(pos.ticket, pos.trailingSL, pos.adaptiveTP);
            }
        }
    }
};

class RiskManager
{
public:
    RiskCalculation CalculatePositionRisk(string symbol, ENUM_POSITION_TYPE type, 
                                         double entryPrice, double slPrice, RiskProfile& profile)
    {
        RiskCalculation calc = {0, 0, 0, 0, 0, false, ""};
        
        double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
        double tickValue = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
        double equity = AccountInfoDouble(ACCOUNT_EQUITY);
        
        calc.accountRisk = equity * (profile.riskPerTrade / 100.0);
        
        double slDistance = MathAbs(entryPrice - slPrice) / point;
        
        if (slDistance <= 0)
        {
            calc.reason = "Invalid SL distance";
            return calc;
        }
        
        calc.volumeToTrade = (calc.accountRisk * point) / (slDistance * tickValue);
        
        double minLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
        double maxLot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
        
        if (calc.volumeToTrade < minLot)
        {
            calc.reason = "Volume too small";
            return calc;
        }
        
        if (calc.volumeToTrade > maxLot)
        {
            calc.reason = "Volume too large";
            return calc;
        }
        
        double tpDistance = slDistance * profile.minRRRatio;
        
        if (type == POSITION_TYPE_BUY)
        {
            calc.stopLossPrice = slPrice;
            calc.takeProfitPrice = entryPrice + (tpDistance * point);
        }
        else
        {
            calc.stopLossPrice = slPrice;
            calc.takeProfitPrice = entryPrice - (tpDistance * point);
        }
        
        calc.calculatedRR = tpDistance / slDistance;
        calc.meetsMinimumRR = (calc.calculatedRR >= profile.minRRRatio);
        
        if (!calc.meetsMinimumRR)
            calc.reason = "RR ratio below minimum";
        
        return calc;
    }
    
    DailyStats GetDailyStats()
    {
        DailyStats stats = {D'2000.01.01', 0, 0, 0, 0, 0, false};
        stats.tradeDate = TimeCurrent();
        
        double runningProfit = 0;
        double runningMin = 0;
        
        int total = HistoryDealsTotal();
        for (int i = 0; i < total; i++)
        {
            if (!HistoryDealSelect(i)) continue;
            
            datetime dealTime = (datetime)HistoryDealGetInteger(i, DEAL_TIME);
            double dealProfit = HistoryDealGetDouble(i, DEAL_PROFIT);
            
            if (dealProfit > 0)
                stats.totalProfit += dealProfit;
            else
                stats.totalLoss += MathAbs(dealProfit);
            
            stats.tradeCount++;
            runningProfit += dealProfit;
            
            if (runningProfit < runningMin)
                runningMin = runningProfit;
        }
        
        stats.netResult = stats.totalProfit - stats.totalLoss;
        stats.maxDrawdown = MathAbs(runningMin);
        stats.dailyLimitExceeded = (stats.maxDrawdown > (AccountInfoDouble(ACCOUNT_BALANCE) * 0.03));
        
        return stats;
    }
    
    bool CheckPortfolioRisk(string symbol, double newRisk, double& portfolioRisk)
    {
        portfolioRisk = 0;
        
        int total = PositionsTotal();
        for (int i = 0; i < total; i++)
        {
            if (!PositionSelectByIndex(i)) continue;
            
            double positionProfit = PositionGetDouble(POSITION_PROFIT);
            double volume = PositionGetDouble(POSITION_VOLUME);
            double openPrice = PositionGetDouble(POSITION_PRICE_OPEN);
            double currentPrice = PositionGetDouble(POSITION_PRICE_CURRENT);
            
            if (positionProfit < 0)
                portfolioRisk += MathAbs(positionProfit);
        }
        
        portfolioRisk += newRisk;
        
        double equity = AccountInfoDouble(ACCOUNT_EQUITY);
        double maxRisk = equity * (MaxPortfolioOpenRiskPct / 100.0);
        
        return portfolioRisk <= maxRisk;
    }
};

DecisionEngine g_decisionEngine;
OrderExecutionManager g_orderManager;
PositionManager g_positionManager;
RiskManager g_riskManager;

int OnInit()
{
    initialBalance = AccountInfoDouble(ACCOUNT_BALANCE);
    peakEquity = initialBalance;
    lastPeakEquity = initialBalance;
    
    return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
}

void OnTick()
{
    if (isOrderSendLocked) return;
    
    SignalDecision signal = g_decisionEngine.EvaluateSignal(_Symbol, PERIOD_CURRENT);
    
    if (!signal.valid) return;
    
    if (!EnableBuyOrders && signal.direction == "BUY") return;
    if (!EnableSellOrders && signal.direction == "SELL") return;
    
    double currentPrice = SymbolInfoDouble(_Symbol, SYMBOL_BID);
    
    double atr = GetATRValue(_Symbol, PERIOD_CURRENT, ATRPeriod);
    double slPrice = signal.direction == "BUY" ? currentPrice - (atr * 1.5) : currentPrice + (atr * 1.5);
    
    RiskProfile profile;
    profile.riskPerTrade = RiskPerTradePct;
    profile.maxDrawdown = 5.0;
    profile.minRRRatio = RiskRewardRatio;
    profile.dailyMaxLoss = DailyLossHardStopPct;
    profile.maxConcurrentRisk = MaxPortfolioOpenRiskPct;
    
    RiskCalculation riskCalc = g_riskManager.CalculatePositionRisk(_Symbol, 
                                                                    signal.direction == "BUY" ? POSITION_TYPE_BUY : POSITION_TYPE_SELL,
                                                                    currentPrice, slPrice, profile);
    
    if (!riskCalc.meetsMinimumRR)
    {
        LogPrint("Entry blocked: ", riskCalc.reason);
        return;
    }
    
    double portfolioRisk = 0;
    if (!g_riskManager.CheckPortfolioRisk(_Symbol, riskCalc.accountRisk, portfolioRisk))
    {
        LogPrint("Entry blocked: Portfolio risk exceeded");
        return;
    }
    
    OrderRequest req;
    req.symbol = _Symbol;
    req.type = signal.direction == "BUY" ? POSITION_TYPE_BUY : POSITION_TYPE_SELL;
    req.volume = riskCalc.volumeToTrade;
    req.entryPrice = currentPrice;
    req.stopLossPrice = riskCalc.stopLossPrice;
    req.takeProfitPrice = riskCalc.takeProfitPrice;
    req.reason = signal.regime;
    req.magicNumber = DynamicMagicBase;
    
    OrderResult result = g_orderManager.ExecuteOrder(req);
    
    if (result.success)
    {
        LogPrint("Order placed: Ticket=", result.ticket, " Price=", result.executionPrice, " Slippage=", result.slippage);
    }
    else
    {
        LogPrint("Order failed: ", result.errorMessage);
    }
}

double GetATRValue(string symbol, ENUM_TIMEFRAMES timeframe, int period)
{
    int handle = iATR(symbol, timeframe, period);
    if (handle < 0) return 0;
    
    double atr[];
    if (CopyBuffer(handle, 0, 0, 1, atr) <= 0) return 0;
    
    return atr[0];
}

double GetATRAverage(string symbol, ENUM_TIMEFRAMES timeframe, int lookback)
{
    double sum = 0;
    for (int i = 0; i < lookback; i++)
        sum += GetATRValue(symbol, timeframe, ATRPeriod);
    return sum / lookback;
}

double GetRSIValue(string symbol, ENUM_TIMEFRAMES timeframe, int period)
{
    int handle = iRSI(symbol, timeframe, period, PRICE_CLOSE);
    if (handle < 0) return 50;
    
    double rsi[];
    if (CopyBuffer(handle, 0, 0, 1, rsi) <= 0) return 50;
    
    return rsi[0];
}

double GetEMA(string symbol, ENUM_TIMEFRAMES timeframe, int period)
{
    int handle = iMA(symbol, timeframe, period, 0, MODE_EMA, PRICE_CLOSE);
    if (handle < 0) return 0;
    
    double ema[];
    if (CopyBuffer(handle, 0, 0, 1, ema) <= 0) return 0;
    
    return ema[0];
}

double GetTrendStrength(string symbol)
{
    double emaFast = GetEMA(symbol, PERIOD_CURRENT, EMAFastPeriod);
    double emaSlow = GetEMA(symbol, PERIOD_CURRENT, EMASlowPeriod);
    double atr = GetATRValue(symbol, PERIOD_CURRENT, ATRPeriod);
    
    return atr > 0 ? MathAbs(emaFast - emaSlow) / atr : 0;
}

double Close(string symbol, ENUM_TIMEFRAMES timeframe, int bar)
{
    double close[];
    if (CopyClose(symbol, timeframe, bar, 1, close) <= 0) return 0;
    return close[0];
}

double Open(string symbol, ENUM_TIMEFRAMES timeframe, int bar)
{
    double open[];
    if (CopyOpen(symbol, timeframe, bar, 1, open) <= 0) return 0;
    return open[0];
}

double High(string symbol, ENUM_TIMEFRAMES timeframe, int bar)
{
    double high[];
    if (CopyHigh(symbol, timeframe, bar, 1, high) <= 0) return 0;
    return high[0];
}

double Low(string symbol, ENUM_TIMEFRAMES timeframe, int bar)
{
    double low[];
    if (CopyLow(symbol, timeframe, bar, 1, low) <= 0) return 0;
    return low[0];
}

bool IsAimeMagic(long magic)
{
    return magic >= DynamicMagicBase && magic < DynamicMagicBase + 10000;
}

long GetMagicForSymbol(string symbol)
{
    return DynamicMagicBase;
}
