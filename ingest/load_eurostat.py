import pandas as pd
import duckdb

df = pd.read_csv(
    "data/raw/tour_occ_arn2.tsv",
    sep="\t",
    na_values=[":"],            # Eurostat marks missing as ":"
)

# Split the first column "freq,c_resid,unit,nace_r2,geo\TIME_PERIOD"
key_col = df.columns[0]
keys = df[key_col].str.split(",", expand=True)
keys.columns = key_col.split("\\")[0].split(",")
df = pd.concat([keys, df.drop(columns=[key_col])], axis=1)

# Wide → long
df_long = df.melt(
    id_vars=keys.columns.tolist(),
    var_name="period",
    value_name="arrivals",
)
df_long["arrivals"] = pd.to_numeric(df_long["arrivals"], errors="coerce")

con = duckdb.connect("data/tourism.duckdb")
con.execute("CREATE OR REPLACE TABLE raw_eurostat AS SELECT * FROM df_long")
print(con.execute("SELECT COUNT(*) FROM raw_eurostat").fetchone())