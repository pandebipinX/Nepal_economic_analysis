# Nepal's Agricultural Economy: Production Trends, Structural Transformation & Risk

## Problem Statement
Agriculture has historically anchored Nepal's economy, but its role is shifting as other sectors expand. This project asks: **how is Nepal's agricultural production actually evolving, is the economy undergoing genuine structural transformation, and where does agricultural growth carry the most risk/volatility?**

This is Phase 1 (Modules 1) of a broader portfolio project examining the links between climate, agriculture, and Nepal's economy — food security, trade, and the agriculture-climate link are covered in later phases (see Roadmap below).

## Why This Matters
Agriculture still directly affects food security, rural incomes, and inflation for a large share of Nepal's population, even as its GDP share shrinks. Understanding *how* it's shrinking (which sector is absorbing that share), *which crops* are driving or dragging growth, and *how volatile* that growth is matters for anyone thinking about agricultural policy, rural livelihoods, or investment risk in the sector.

## Data Sources
- Crop-level agriculture production data — area, production, and productivity by year, split by food vs. cash crop (2011–2023)
- Sector-wise GDP data (2010–2024)
- Food & beverage CPI data
- Livestock production data by category

## Tech Stack
Python (pandas, numpy, matplotlib, seaborn) · PostgreSQL · SQLAlchemy · SQL (CTEs, window functions, pivot tables)

## Methodology
1. **ETL** — cleaned raw data and loaded it into PostgreSQL as normalized tables (`agriculture_production`, `gdp_data`, `cpi_data`, `livestock_production`)
2. **Trend analysis** — production, area, and productivity by crop and crop type (food vs. cash) over time
3. **Growth analysis** — year-over-year % change and CAGR (2011–2023), overall and per crop
4. **Growth decomposition** — how much of production growth came from area expansion vs. yield/productivity improvement
5. **Risk analysis** — Coefficient of Variation (CV = std/mean) per crop to flag high-volatility crops
6. **Structural transformation analysis** — agriculture's share of GDP vs. Industry and Services over time
7. **Cross-domain check** — food crop production against food & beverage CPI
8. **Livestock trends** — production by category

## Key Findings

**Structural shift, but toward services, not industry.**
Agriculture's share of national GDP fell from 33.8% (2011) to 29.0% (2024) — a 4.8-point decline. Over the same period, Services grew from 51.2% to 54.8% of GDP (+3.6 pts) and Industry from 15.0% to 16.2% (+1.2 pts). Services is absorbing nearly all of the share agriculture is losing — a sign Nepal's transformation is skipping industrialization and moving straight into a services-led economy.

**Growth is real but not yet structural.**
Cash crops are growing faster than food crops in percentage terms, but food crops still dominate total volume, and their shares move inversely year to year — consistent with a subsistence-driven economy shifting between crop types rather than diversifying into high-value commercial agriculture.

**Food crops carry more volatility than cash crops** — a pattern consistent with weather/climate exposure — pointing to a missed opportunity: Nepal isn't capturing the export or income potential of higher-value crops.

**Winners and laggards (2011–2023 CAGR):**
| Crop | CAGR | Note |
|---|---|---|
| Maize | +3.2%/yr | Fastest-growing major crop |
| Potato | +2.3%/yr | Strong grower |
| Paddy | +1.0%/yr | Modest growth rate but largest absolute contributor (+652 units) |
| Millet | -0.4%/yr | Declining |
| Barley | -2.8%/yr | Declining fastest |

**Risk profile (Coefficient of Variation):** Honey is by far the highest-volatility crop (CV = 0.68), followed by buckwheat (0.27) and oilseeds (0.17); millet, despite its decline, is the most stable (CV = 0.05) — a classic risk-return tradeoff smallholders face when choosing what to plant.

**Agriculture is a shock amplifier for the broader economy.** Agricultural growth is more volatile than total GDP growth, and swings in agricultural output show up directly in overall GDP growth — agriculture still matters for short-term macro performance even as its GDP share shrinks.

**Livestock:** chicken and duck production are growing fastest, even though milk remains the largest-volume category — suggesting poultry is the more dynamic part of the livestock sub-sector right now.

## Roadmap / Next Steps
- Deepen the food-security angle (consumption, self-sufficiency ratios)
- Bring in trade data (agricultural imports/exports) to test whether domestic production gaps are being filled by imports
- Add the tourism-agriculture linkage module
- Introduce climate variables (rainfall, temperature) explicitly, to test whether the volatility seen in food crops and specific high-CV crops is climate-driven — this is the connective layer to the broader climate-economy focus of this portfolio

## Limitations
- Doesn't yet incorporate climate/weather data directly — volatility is inferred, not tested against a climate variable (planned next).
- Crop coverage limited to categories present in the source dataset; some recent years may be partial.
- Growth decomposition and CAGR are exploratory measures and would benefit from further sensitivity checks (e.g., outlier years).

## Reproducing This Analysis
1. Clone the repo and install dependencies (`pandas`, `numpy`, `matplotlib`, `seaborn`, `sqlalchemy`, `psycopg2`)
2. Set up a local PostgreSQL instance and create a database
3. Set credentials as environment variables (`.env` file, not hardcoded) and load with `python-dotenv`
4. Load the cleaned CSVs into PostgreSQL, then run the notebook top to bottom

## Skills Demonstrated
SQL (window functions, CTEs, pivoting), Python/pandas EDA, PostgreSQL schema design, applied economic analysis (CAGR, growth decomposition, volatility/risk measurement), data storytelling for a non-technical audience

---
**Author:** Bipin Pandey · [LinkedIn](https://linkedin.com/in/bipin-pandey-860289287) · pandebipin321@gmail.com
