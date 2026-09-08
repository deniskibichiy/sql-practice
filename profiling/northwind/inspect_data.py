#import pandas as pd
import pandas as pd
#customers
customers = pd.read_csv(
    "customers.csv",
    sep="|",
    header = "infer"
)

#orders

orders = pd.read_csv(
    "orders.csv",
    sep = "|",
    header = "infer"
)


#regions
regions = pd.read_csv(
    "datasets/Northwind/regions.csv",
    sep = "|"
)
# Transforming columns to remain with only relevant columns

## Find out how many null values we have in each column
orders.isnull().sum()

# Since ShippedRegion contains 507 null values, this column deserves dropping
# Save only the columns you want to a new file
orders.drop(columns=["ShipAddress", "ShipPostalCode"]).to_csv(
    "orders_clean.csv", index=False
)




