# Cookie Cats: Does Moving the First Gate Affect Retention?

Cookie Cats is a mobile puzzle game where players progress through levels. At certain levels, players hit a gate; to pass the gate they must wait or make an in-app purchase before they can keep playing. This project analyzes an A/B test that move the first gate from level 30 to level 40, comparing the player retention rates between the two versions. 

**Live dashboard:** [link, added after GitHub Pages is set up]

![Dashboard screenshot](dashboard_screenshot.png)

## The Question
Gates force players to take a break or to pay. That break keeps players from burning out and losing interest in the game, or it could frustrate them enought to quit the game. Where the first gate sits affects a players decision to come back to the game, and retention of free to play games like Cookie Cats relies on the consistency of its players. This analysis asks: **does moving the first gate from level 30 to level 40 change how many players return after 1 day and after 7 days?**

## Data
- Source: [Mobile Games A/B Testing - Cookie Cats (Kaggle)](https://www.kaggle.com/datasets/mursideyarkin/mobile-games-ab-testing-cookie-cats)
- 90,189 players, randomly assigned to one of two versions: `gate_30` (44,700 players) or `gate_40` (45,489 players)
- Columns:
  - `userid`: unique player ID
  - `version`: which gate placement the player got
  - `sum_gamerounds`: rounds played in the first 14 days after install
  - `retention_1` / `retention_7`: whether the player came back 1 day / 7 days after installing (1 = yes, 0 = no)

## Data Validation
Before analyzing, I checked the data for problems:
- **No duplicate players.** Every `userid` appears once.
- **3,994 players never played a round.** They were never exposed to the game, let alone a gate, so I excluded them.
- **One impossible value.** The top player logged 49,854 rounds in 14 days. Assuming about 3 minutes per round, that's roughly 10,700 minutes of play per day, when a day has only 1,440. I excluded any player above (1440 / 3) × 14 = 6,720 rounds, which removed only this one player. The next-highest player had 2,961 rounds.

## Data Validation
Before analyzing, I checked the data for problems:
- **No duplicate players.** Every `userid` appears once.
- **3,994 players never played a round.** They were never exposed to the game, let alone a gate, so I excluded them.
- **One impossible value.** The top player logged 49,854 rounds in 14 days. Assuming about 3 minutes per round, that's roughly 10,700 minutes of play per day, which is impossible. I excluded any player above (1440 / 3) × 14 = 6,720 rounds, which removed only this one player. The next-highest player had 2,961 rounds.

After cleaning, 86,194 players remained. The data is heavily skewed: the median player played **18 rounds**, while the mean was **53.7**. Most players play very little, and a smaller group plays a lot.

## Findings
**Day-7 retention was significantly higher for gate_30 than for gate_40** (19.84% vs. 19.03%, p = 0.003, chi-square test). That is a 0.81 percentage-point gap, or roughly a 4% relative drop in players returning after a week when the gate is moved to level 40.

On **day 1, there was no significant difference** (46.75% vs. 46.22%, p = 0.12). This makes sense: on day 1, most players likely had not played long enough to reach either gate, but by day 7 many had.

**Where the difference comes from.** About 61% of players in both versions played fewer than 30 rounds, so many likely never reached a gate at all. Breaking day-7 retention down by rounds played:
- The largest gap was among players with **40–99 rounds** (32.9% for gate_30 vs. 29.4% for gate_40, p < 0.001), the group most likely to have reached a gate.
- Players with 1–10, 30–39, and 100+ rounds retained at nearly identical rates in both versions.
- There was also a smaller gap among players with 11–29 rounds (8.4% vs. 7.6%, p = 0.04). Players with fewer than 30 rounds shouldn't have reached either gate, so this result is unexpected and may be partly due to chance.

## Recommendation
I would recommend that the game developers keep the first gate at level 30. It produced significantly higher 7-day retention, and moving the gate later showed no benefit on day 1 or day 7.

## Limitations
- **Rounds aren't levels.** Players can replay levels, so rounds played only approximates who reached each gate.
- **The rounds breakdown is descriptive, not causal.** The gate can change how many rounds a player ends up playing, so players in the same rounds bucket aren't perfectly comparable across versions.
- **Many players never reached a gate.** For them, the two versions were identical, which likely dilutes the measured effect. The true impact on players who reached the gate may be larger.
- **Retention isn't the only goal.** The data doesn't include revenue, so the effect on in-app purchases is unknown.


## Tools
SQL (SQLite, JupySQL), Python (pandas, SciPy), JavaScript (Apache ECharts)

## How to Run
1. Download the CSV from Kaggle into `data/`
2. Run `analysis.ipynb`
3. In the `dashboard` folder, run `python3 -m http.server` and open http://localhost:8000