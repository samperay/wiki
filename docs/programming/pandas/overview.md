# Pandas Olympics Cheat Sheet (.md)
_A complete, example-driven quick reference using your [attached dataset](./olympics-data.xlsx) (`bios`, `results`). All examples are one-liners unless noted._

---

## Setup
```python
import pandas as pd, numpy as np
bios = pd.read_excel("olympics-data.xlsx", sheet_name="bios")
results = pd.read_excel("olympics-data.xlsx", sheet_name="results")
```
Columns:

- **bios**: athlete_id, name, born_date, born_city, born_region, born_country, NOC, height_cm, weight_kg, died_date
- **results**: year, type, discipline, event, as, athlete_id, noc, team, place, tied, medal

---

## Create & Initialize DataFrames
```python
pd.DataFrame({"A":[1,2], "B":["x","y"]})                           # from dict
pd.DataFrame([{"A":1,"B":"x"},{"A":2,"B":"y"}])                     # list of dicts
pd.DataFrame(np.arange(6).reshape(3,2), columns=["A","B"])          # from numpy
pd.date_range("2020-01-01", periods=5, freq="D").to_frame("date")   # date range
pd.DataFrame(columns=["A","B"])                                     # empty schema
```

---

## I/O (Read & Write)
```python
pd.read_csv("file.csv")                                            # read CSV
df.to_csv("out.csv", index=False)                                  # write CSV
pd.read_excel("file.xlsx", sheet_name="bios")                      # read Excel
df.to_excel("out.xlsx", index=False, sheet_name="S1")              # write Excel
pd.read_parquet("file.parquet")                                    # read Parquet
df.to_parquet("out.parquet", index=False)                          # write Parquet
pd.read_json("file.json")                                          # read JSON
df.to_json("out.json", orient="records", lines=False)              # write JSON
```

---

## Inspect & Explore
```python
bios.head(3); bios.info(); bios.describe(include="all")             # quick look
bios.shape; bios.columns.tolist(); bios.dtypes                      # schema
bios.nunique(); bios.isna().sum()                                   # counts
bios["NOC"].value_counts()                                          # freq
results.sample(5, random_state=0)                                   # random rows
```

---

## Selecting, Filtering, Assigning
```python
bios[["name","NOC"]]                                               # select cols
bios.loc[bios["born_country"].eq("FRA"), ["name","born_city"]]     # filter eq
bios.query("height_cm > 190 and NOC == 'France'")                  # query str
bios.iloc[:5, :3]                                                  # by position
bios.assign(bmi=lambda d: d["weight_kg"] / (d["height_cm"]/100)**2)# add col
bios.drop(columns=["died_date"])                                   # drop col
results.loc[results["medal"].notna(), ["year","athlete_id","medal"]]# non-null
```

---

## Missing Data
```python
bios.fillna({"height_cm": bios["height_cm"].median()})             # fill by stat
bios["height_cm"].fillna(0)                                        # fill scalar
bios.dropna(subset=["height_cm","weight_kg"])                      # drop subset
bios["born_date"] = pd.to_datetime(bios["born_date"], errors="coerce")  # coerce
bios.interpolate(numeric_only=True)                                # interpolate
```

---

## Type Handling
```python
bios["height_cm"] = pd.to_numeric(bios["height_cm"], errors="coerce") # numeric
bios["NOC"] = bios["NOC"].astype("category")                           # category
results["year"] = results["year"].astype("int64")                       # cast int
results["tied"] = results["tied"].astype("bool")                        # cast bool
```

---

## Datetime Features
```python
bios["born_date"] = pd.to_datetime(bios["born_date"], errors="coerce")  # parse
bios["born_year"] = bios["born_date"].dt.year                           # year
bios["born_month"] = bios["born_date"].dt.month                         # month
bios.set_index("born_date").sort_index().last("5Y")                     # recent 5y
```

---

## GroupBy & Aggregations (Olympics Examples)
```python
results.groupby("noc")["medal"].count().sort_values(ascending=False)     # medals by NOC (non-null)
results.groupby(["year","noc"], as_index=False)["athlete_id"].nunique()  # unique athletes per year/NOC
bios.groupby("NOC")["height_cm"].agg(["mean","median","count"])          # height stats by NOC
results.groupby("discipline").agg(events=("event","nunique"))            # events per discipline
```

---

## Transform & Window Ops
```python
bios["z_height"] = (bios["height_cm"] - bios["height_cm"].mean())/bios["height_cm"].std()    # z-score
results["rank_in_year"] = results.groupby("year")["place"].rank(method="dense", ascending=True) # rank
results.sort_values(["year","place"]).groupby("year")["place"].rolling(3).mean().reset_index(level=0, drop=True) # rolling mean
```

---

## Pivot, Crosstab, Reshape
```python
pd.pivot_table(results, index="year", columns="noc", values="medal", aggfunc="count", fill_value=0) # medals heatmap
pd.crosstab(results["discipline"], results["medal"]).fillna(0)                                     # discipline x medal
results.melt(id_vars=["year","noc"], value_vars=["medal","place"], var_name="metric", value_name="val") # wide->long
```

---

## Merge / Join (bios ↔ results)
```python
res_bios = results.merge(bios[["athlete_id","name","NOC","height_cm","weight_kg"]], on="athlete_id", how="left") # enrich
bios_only = bios[~bios["athlete_id"].isin(results["athlete_id"])]                                                # anti-join style
```

---

## Concatenate & Append
```python
pd.concat([results.query("year < 2000"), results.query("year >= 2000")], ignore_index=True) # stack rows
pd.concat([bios.set_index("athlete_id"), bios.set_index("athlete_id")], axis=1)             # concat cols
```

---

## Sorting & Ranking
```python
results.sort_values(["year","noc","place"], ascending=[True, True, True])                   # sort
results["noc_rank"] = results.groupby("year")["noc"].rank(method="dense")                   # rank within year
```

---

## String Ops
```python
bios["born_city"].str.title()                                                                # title case
results["event"].str.contains("Doubles", na=False)                                           # contains
results["event_clean"] = results["event"].str.replace(r"\s+\(Olympic\)", "", regex=True)  # regex replace
results["pair"] = results["team"].fillna("").str.split(",").str[:2].str.join(",")            # first two teammates
```

---

## Categorical Optimization
```python
results["discipline"] = pd.Categorical(results["discipline"])                                # category
results["medal"] = pd.Categorical(results["medal"], ordered=True, categories=["Bronze","Silver","Gold"]) # ordered
```

---

## Index Tricks & MultiIndex
```python
mi = results.set_index(["year","noc"]).sort_index()                                          # multiindex
mi.loc[(slice(2000,2012), "USA"), :]                                                         # slice by MI
results.reset_index(drop=True)                                                               # reset
```

---

## Window Functions (Rolling/Expanding/EWM)
```python
results.sort_values("year").groupby("noc")["place"].rolling(5, min_periods=1).mean().reset_index(level=0, drop=True) # rolling mean
results.groupby("noc")["place"].expanding().mean().reset_index(level=0, drop=True)                                   # expanding mean
results.sort_values("year").groupby("noc")["place"].apply(lambda s: s.ewm(alpha=0.3).mean())                          # EWM
```

---

## Conditional Logic & One-Hot
```python
results["medal_flag"] = np.where(results["medal"].notna(), 1, 0)                           # binary flag
pd.get_dummies(results["medal"], prefix="medal")                                            # one-hot encode
```

---

## Time-Series Resampling (by year)
```python
(results.assign(date=pd.to_datetime(results["year"].astype(str) + "-01-01"))
        .set_index("date")
        .resample("10Y")["athlete_id"].count())                                             # decadal counts
```

---

## Deduplication & QC
```python
results.drop_duplicates(subset=["year","athlete_id","event"])                               # unique participations
assert bios["athlete_id"].is_unique                                                         # enforce unique key
```

---

## Performance Tips
```python
pd.read_csv("big.csv", chunksize=1_000_000)                                                 # chunked ingest
results["discipline"] = results["discipline"].astype("category")                            # categorical
results.to_parquet("fast.parquet", index=False)                                             # columnar storage
```

---

## Handy Patterns (Olympics Use-Cases)
```python
# Top 3 medal-heavy NOCs per discipline
(results.dropna(subset=["medal"])
        .groupby(["discipline","noc"]).size().reset_index(name="medals")
        .sort_values(["discipline","medals"], ascending=[True,False])
        .groupby("discipline").head(3))

# BMI distribution (needs height & weight) for living athletes
(bios.query("height_cm.notna() and weight_kg.notna() and died_date.isna()")
     .assign(bmi=lambda d: d["weight_kg"]/((d["height_cm"]/100)**2))
     .groupby("NOC")["bmi"].describe())
```

---

## Export Results
```python
summary = results.groupby(["year","noc"], as_index=False)["athlete_id"].nunique()
summary.to_excel("athletes_by_year_noc.xlsx", index=False)                                  # Excel
summary.to_markdown("summary.md", index=False)                                              # Markdown table
```

---

### End-to-End One-Liner Example
```python
(pd.read_excel("olympics-data.xlsx", sheet_name="results")
   .merge(pd.read_excel("olympics-data.xlsx", sheet_name="bios")[["athlete_id","NOC"]], on="athlete_id", how="left")
   .dropna(subset=["medal"])
   .groupby(["year","NOC"], as_index=False).size()
   .sort_values(["year","size"], ascending=[True,False])
   .to_csv("medals_per_year_noc.csv", index=False))
```

---
