# Portfolio Optimization & Technical Analysis

MATLAB project combining portfolio optimization, strategy selection, technical analysis and risk measurement.

## Overview

The project develops and compares different portfolio allocation strategies and evaluates their performance through an out-of-sample analysis.

The analysis also applies technical indicators to selected securities and includes Value at Risk (VaR) and Expected Shortfall (ES) calculations for risk assessment.

## Portfolio Optimization Strategies

The project implements four portfolio allocation approaches:

- Most Diversified Portfolio (MDP)
- Risk Parity
- Mean-Variance Optimization with no short selling
- Mean-Variance Optimization with short selling

The strategies are executed over rolling samples and compared using Sharpe ratios to identify the best-performing approach.

## Technical Analysis

For the securities selected through the portfolio analysis, several technical indicators are implemented:

- Simple Moving Averages (SMA)
- Weighted Moving Average (WMA)
- Exponential Moving Average (EMA)
- Bollinger Bands
- Envelopes
- Momentum
- Relative Strength Index (RSI)
- Money Flow Index (MFI)
- SuperTrend

## Risk Measurement

The project also evaluates portfolio risk using:

- Parametric Value at Risk (VaR)
- Historical Value at Risk (VaR)
- Expected Shortfall (ES)

## Technologies

- MATLAB
- Portfolio Optimization
- Quantitative Finance
- Technical Analysis
- Risk Management

## Project Structure

The repository contains the main MATLAB script, portfolio optimization functions, technical analysis functions and risk measurement modules.

The main entry point is:

`ANDREA_CILIEGIO_2148291.m`

## Data

The main script reads market data from an Excel file named `Basedati.xlsx`.

The dataset is not included in the repository at this stage.

## Author

Andrea Ciliegio
