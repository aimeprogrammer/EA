# 🚀 EA Production Requirements - Complete AI Prompt

## Current Status: v46 Base Architecture
**What You Have:**
- ✅ Unified DecisionEngine (regime detection, signal scoring)
- ✅ OrderExecutionManager (validation, spread/margin checks)
- ✅ PositionManager (lifecycle, partial closes, trailing stops)
- ✅ RiskManager (position sizing, portfolio risk, daily stats)
- ✅ Core OnTick() entry logic

**What You're MISSING (Production-Critical):**

---

## 🔴 TIER 1: CRITICAL GAPS (Cannot Trade Without)

### 1. MULTI-ASSET ENGINE (Symbol Loop)
**Status:** Missing entirely
**Impact:** EA only trades 1 symbol on default chart
**What's needed:**
```
- Array of symbol contexts
- Portfolio cycle loop (iterate all symbols each tick)
- Per-symbol state management (signals, positions, regime)
- Asset discovery (from input string or MarketWatch)
- Symbol filter logic (FX, Metals, Crypto, Stocks, Indices)
- Position reconciliation across all symbols
- Portfolio correlation checking (prevent over-hedging)
```

**Implementation Required:**
- `SymbolPortfolio` class to manage multi-asset state
- `OnPortfolioCycle()` function to loop through symbols
- `LoadSymbolContext()` / `SaveSymbolContext()` for state persistence
- `g_symbols[]` array + symbol count tracking
- Async execution model (don't process all symbols sequentially)

---

### 2. POSITION TRACKING & RECONCILIATION
**Status:** Partially implemented
**Impact:** Positions may be orphaned; state mismatches between EA and terminal
**What's needed:**
```
- Position existence verification per tick
- Ticket-to-PositionLifecycle lookup (hash map or array)
- Closed position history archival
- Position synchronization with terminal
- External position detection (positions not opened by EA)
- Unprotected position warnings (SL = 0)
- Magic number validation
```

**Implementation Required:**
- `PositionTracker` class with ticket management
- `ReconcilePositions()` function (run each tick)
- `ArchiveClosedPositions()` for history
- `g_positionMap[]` or linked list structure
- Position state machine enforcement

---

### 3. RECOVERY ENGINE (Reconnection Handling)
**Status:** Missing entirely
**Impact:** EA crashes/disconnects = orphaned positions, lost sync
**What's needed:**
```
- Terminal connection status detection
- Auto-recovery on reconnect
- Lost position state restoration
- Trade history replay from broker
- Socket reconnection retry logic
- Tick data validation (stale data detection)
- Pending order recovery
```

**Implementation Required:**
- `ConnectionManager` class
- `OnConnectionLost()` / `OnConnectionRestored()` handlers
- `ReplayTradeHistory()` function
- `g_connectionLostTime` tracking
- Network error handling in OrderExecutionManager
- Exponential backoff for retries

---

### 4. EXECUTION LOGGING & AUDIT TRAIL
**Status:** Basic LogPrint only
**Impact:** Cannot debug failures; no compliance trail
**What's needed:**
```
- File-based logging (JSON or CSV format)
- Log rotation (daily/weekly)
- Execution timestamps (millisecond precision)
- Signal calculation trace (why entry/skip)
- Risk calculation details
- Order rejection reasons
- Position close reasons with profit/loss
- Account state snapshots
- Performance metrics per trade
```

**Implementation Required:**
- `ExecutionLogger` class
- `LogEntry` struct with timestamp, type, details
- `FlushLogsToFile()` function (daily batch)
- `LogDirectory` input parameter
- Structured JSON serialization
- Log line formatting for analysis

---

### 5. POSITION STATE MACHINE
**Status:** Enum exists but not enforced
**Impact:** Positions can get stuck in wrong state; no closure validation
**What's needed:**
```
State Transitions:
  ENTRY_PENDING → ENTERED (order fills)
  ENTERED → TRAILING (profit > threshold)
  ENTERED → CLOSING (manual exit, SL/TP hit)
  TRAILING → CLOSING (price reversion)
  CLOSING → CLOSED (position fully closed)
  Any → ERROR (validation failure)

Validation:
- Cannot exit position that's still pending
- Cannot trail stop that hasn't entered yet
- Cannot close already-closed position
- Duration tracking (barsHeld enforcement)
```

**Implementation Required:**
- `ValidateStateTransition(from, to)` function
- `StateHistory[]` array (audit trail)
- Transition timestamp logging
- State change callbacks
- Automatic state cleanup on position close

---

## 🟠 TIER 2: HIGH-PRIORITY GAPS (Severely Limit Performance)

### 6. TIMEFRAME CONFIRMATION (Multi-Timeframe Analysis)
**Status:** Missing
**Impact:** Entries taken against larger timeframe trends (whipsawed)
**What's needed:**
```
- Higher timeframe EMA alignment check
- HTF RSI confirmation
- HTF trend vs current timeframe trend validation
- Breakout confirmation from 4H/D1
- Pullback entry wait in strong trends
- Divergence detection (price higher, momentum lower)
```

**Implementation Required:**
- `TimeframeConfirmationEngine` class
- `CheckHTFAlignment(symbol, currentTF)` function
- Separate indicator handles for H4, D1
- Correlation between timeframes
- Weight adjustment based on HTF strength

---

### 7. MARKET HOURS & SESSION FILTERS
**Status:** Input parameters exist, logic missing
**Impact:** Trades during low-liquidity sessions, gap risk overnight
**What's needed:**
```
- Trading hours enforcement (per session type)
- Market close detection (last 30 min filter)
- Market open gap handling
- Session-based signal strength adjustment
- US market hours validation (for stocks/indices)
- Asian session filter
- European session filter
```

**Implementation Required:**
- `SessionManager` class
- `IsWithinTradingHours()` function
- `GetCurrentSession()` function
- Time zone handling
- Market close countdown timer

---

### 8. NEWS FILTER & ECONOMIC CALENDAR
**Status:** Input parameters only
**Impact:** Big slippage/gaps during news events
**What's needed:**
```
- Economic calendar data integration
- High-impact event detection
- Entry blocking N minutes before news
- Position holding through news (SL widening before events)
- Post-news volatility adjustment
- News impact weighting by currency
- Event severity classification
```

**Implementation Required:**
- `NewsFilter` class
- External calendar API (forexfactory, tradingeconomics)
- `GetUpcomingNews(symbol, minutes)` function
- Volatility surge detection
- `NewsBlockUntil` timestamp per symbol

---

### 9. PERFORMANCE TRACKING & METRICS
**Status:** Basic daily stats only
**Impact:** Cannot optimize; no feedback loop
**What's needed:**
```
- Win rate calculation
- Profit factor (gross profit / gross loss)
- Sharpe ratio (risk-adjusted returns)
- Maximum drawdown % tracking
- Recovery factor
- Average trade duration
- Best/worst trade analysis
- Monthly/weekly summaries
- Equity curve tracking
```

**Implementation Required:**
- `PerformanceAnalyzer` class
- `TradeMetrics` struct
- `CalculateProfitFactor()` function
- `CalculateSharpeRatio()` function
- Time-series equity history
- Export to CSV for analysis

---

### 10. EMERGENCY STOP & CIRCUIT BREAKER
**Status:** Input parameters only
**Impact:** Cannot stop losing streaks; account blows up
**What's needed:**
```
- Consecutive loss counter (N losses = halt)
- Drawdown circuit breaker (exit all on X%)
- Daily loss halt (close all positions at daily max loss)
- Peak-to-trough drawdown monitoring
- Automatic cooldown after N losses
- Manual pause override
- Equity waterline protection
```

**Implementation Required:**
- `CircuitBreakerManager` class
- `CheckEmergencyStop()` function
- `FlattenAllPositions()` function
- `PauseUntil(datetime)` mechanism
- Reason tracking (why halted)

---

## 🟡 TIER 3: MEDIUM-PRIORITY GAPS (Reduce Profitability)

### 11. CORRELATION & PORTFOLIO GUARD
**Status:** Input parameters only
**Impact:** Overconcentration in correlated pairs
**What's needed:**
```
- Correlation matrix calculation (price correlations)
- Asset class diversification check
- Currency pair correlation (EURUSD vs EURGBP)
- Metal correlation (Gold vs Silver)
- Risk aggregation by currency pair family
- Blocking entry if portfolio already exposed
- Position size reduction for correlated assets
```

**Implementation Required:**
- `CorrelationMatrix` class
- `CalculateCorrelation(symbol1, symbol2, bars)` function
- `GetExposedCurrencies()` function
- Correlation threshold enforcement
- Time-series correlation update

---

### 12. DYNAMIC LOT SIZING
**Status:** Input parameters only
**Impact:** Fixed lot size ignores account changes
**What's needed:**
```
- Kelly Criterion lot sizing option
- Equity-based lot scaling
- Win streak scaling (increase after wins)
- Drawdown-based lot reduction
- Signal strength-based lot adjustment
- Volatility-based lot scaling (lower vol = bigger lot)
- Minimum/maximum lot enforcement
```

**Implementation Required:**
- `LotSizingEngine` class
- `CalculateLotByKelly()` function
- `CalculateLotByEquityPercent()` function
- `CalculateLotByWinStreak()` function
- Lot history tracking

---

### 13. HEDGING MECHANISM
**Status:** Input parameters (EnableHedgeChain), logic missing
**Impact:** Cannot protect against reversals
**What's needed:**
```
- Hedge position creation (opposite direction)
- Hedge closure when original recovers
- Hedge scaling (multiple layers for big losses)
- Hedge profitability requirements
- Hedge SL/TP independent from root position
- Hedge cost tracking
- Hedge exit triggers
```

**Implementation Required:**
- `HedgeManager` class
- `OpenHedge(originalTicket)` function
- `CloseHedge(hedgeTicket)` function
- `CheckHedgeProfitability()` function
- Hedge chain tracking

---

### 14. TRAILING STOP IMPLEMENTATION
**Status:** Logic sketched, not fully implemented
**Impact:** Profits not locked in; holding through reversals
**What's needed:**
```
- Percentage-based trailing stop
- ATR-based trailing stop (most important)
- Donchian channel trailing
- Moving average trailing
- Profit lock-in mechanism (move SL to breakeven)
- Trailing acceleration (accelerate SL on strong moves)
- Trailing deceleration (slower SL update in choppy markets)
- Manual SL override capability
```

**Implementation Required:**
- Enhanced `UpdateStopLevels()` function
- Multiple trailing algorithms
- Trailing history (SL progression tracking)
- Profit lock-in thresholds
- Re-entry after trailing stop hit

---

### 15. ASSET-CLASS SPECIFIC LOGIC
**Status:** Input parameters only
**Impact:** Using same rules for FX, metals, stocks, crypto (wrong)
**What's needed:**
```
FX-Specific:
- Pip-based volatility adjustment
- Major pairs strategy vs exotic pairs
- Correlation with economic data

Metals-Specific:
- Gold risk-off behavior
- Silver industrial demand
- Seasonal patterns

Crypto-Specific:
- 24/7 trading rules
- Regulatory news impact
- Exchange-specific liquidity

Stocks-Specific:
- Earnings seasonality
- Market hours only
- Dividend adjustments
```

**Implementation Required:**
- `AssetClassStrategy` classes (FX, Metal, Crypto, Stock, Index)
- `DetectAssetClass(symbol)` function
- Asset-specific signal weighting
- Time-based adjustments per asset

---

## 🟢 TIER 4: NICE-TO-HAVE FEATURES (Polish & Optimization)

### 16. DASHBOARD & UI
- Real-time trade visualization
- Equity curve display
- Risk metrics panel
- Symbol status indicator
- Performance leaderboard

### 17. BACKTESTING FRAMEWORK
- Tick-by-tick backtesting
- Walk-forward optimization
- Monte Carlo analysis
- Out-of-sample testing
- Parameter sensitivity analysis

### 18. MACHINE LEARNING FEEDBACK
- Pattern recognition from closed trades
- Win/loss signal classification
- Dynamic threshold optimization
- Regime detection refinement

### 19. EXTERNAL API INTEGRATION
- Telegram/Discord alerts
- Webhook notifications
- Cloud sync (trade data)
- Remote control capability

### 20. RISK ANALYTICS
- Value at Risk (VaR) calculation
- Expected Shortfall
- Sortino ratio
- Calmar ratio

---

## 🔧 IMPLEMENTATION PRIORITY ROADMAP

### Week 1-2 (CRITICAL)
1. Multi-Asset Engine
2. Position Tracking & Reconciliation
3. Execution Logging

### Week 3-4 (HIGH)
4. Recovery Engine
5. Emergency Stop / Circuit Breaker
6. Position State Machine

### Week 5-6 (MEDIUM)
7. Timeframe Confirmation
8. Performance Tracking
9. Market Hours Filter
10. News Filter

### Week 7-8 (OPTIMIZATION)
11. Dynamic Lot Sizing
12. Correlation Guard
13. Hedging Mechanism
14. Trailing Stop Refinement

### Week 9-10 (POLISH)
15-20. Dashboard, backtesting, APIs, analytics

---

## 📋 VALIDATION CHECKLIST FOR PRODUCTION

Before deploying, verify:

- [ ] Position reconciliation runs every tick without error
- [ ] All positions have valid SL and TP
- [ ] Portfolio risk never exceeds MaxPortfolioOpenRiskPct
- [ ] Emergency stop triggers and closes all positions
- [ ] Multi-asset cycle completes in <500ms
- [ ] Logs persist to disk daily
- [ ] Connection loss triggers recovery (no orphaned positions)
- [ ] Trailing stops update price-synchronized
- [ ] Partial closes work on 25/50 thresholds
- [ ] Risk-reward ratio enforced at entry
- [ ] No duplicate entries on same bar
- [ ] Spread filter prevents wide-spread entries
- [ ] Magic number validation works
- [ ] Statistics calculation is accurate
- [ ] Backtesting matches live performance (within 5%)

---

## 🎯 SUCCESS METRICS FOR PRODUCTION

**Minimum Thresholds:**
- Win Rate: > 45%
- Profit Factor: > 1.5
- Max Drawdown: < 20% of equity
- Sharpe Ratio: > 1.0
- Recovery Factor: > 2.0
- Consecutive Losses Before Halt: 3-5

**Monthly Target:**
- ROI: 5-15% (depending on risk profile)
- Sortino Ratio: > 1.5
- Average Trade Duration: 1-4 hours
- Slippage Average: < 1 pip (FX)

---

## 💡 Quick Implementation Hints

**For Multi-Asset:**
```
Loop each tick:
  for(int i = 0; i < g_symbolCount; i++)
    ProcessSymbol(g_symbols[i])
```

**For Recovery:**
```
On reconnect:
  1. Query all open positions from terminal
  2. Rebuild g_positionMap from tickets
  3. Sync regime/signal state from saved files
  4. Resume normal operation
```

**For Emergency Stop:**
```
if(consecutiveLosses >= MaxLosses || 
   drawdownPct >= MaxDrawdownPercent)
    FlattenAllPositions()
```

---

## 📞 Next Steps

1. **Read this entire document**
2. **Prioritize your feature focus** (TIER 1 = non-negotiable)
3. **Implement 1-2 CRITICAL features per cycle**
4. **Test each thoroughly before moving on**
5. **Never skip logging - it's your forensic tool**

Good luck! 🚀
