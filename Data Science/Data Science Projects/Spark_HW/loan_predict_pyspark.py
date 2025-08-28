### importing libraries
from pyspark.sql import SparkSession
from pyspark.sql.functions import col
from pyspark.ml.feature import QuantileDiscretizer, StringIndexer, VectorAssembler
from pyspark.ml.classification import LogisticRegression, DecisionTreeClassifier, RandomForestClassifier
from pyspark.ml.evaluation import MulticlassClassificationEvaluator


### starting spark session
spark = SparkSession.builder.appName('loan_predict').getOrCreate()

spark.sparkContext.setLogLevel("ERROR")

### reading and creating datafrAME
df = spark.read.csv('/app/loan_data.csv', header=True, inferSchema=True)

### QUICK EDA
df.printSchema()

df.show(20)

print('count: ',df.count())

for c in df.columns:
    print('null count: ',df.filter(col(c).isNull()).count())

#for c in df.columns:
    #print(df.groupby(c).count().show())


# checking for outliers in columns with continous number values
df.select("ApplicantIncome", "CoapplicantIncome", "LoanAmount").describe().show()

df.groupBy("Gender").pivot("Loan_Status").count().show()
df.groupBy("Property_Area").pivot("Loan_Status").count().show()

### TAKING CARE OF NULL VALUES
selected_columns = ["Gender", "Married", "Dependents", "Education", "Property_Area",
    "ApplicantIncome", "CoapplicantIncome", "LoanAmount", "Loan_Amount_Term", "Credit_History",
    "Loan_Status"]

df = df.select(*selected_columns)

# Fill categorical nulls with Unknown
df = df.na.fill({
    'Gender': 'Unknown',
    'Married': 'Unknown',
    'Dependents': 'Unknown'
})

# Fill LoanAmount nulls with median
loanamount_median = df.approxQuantile("LoanAmount", [0.5], 0)[0]
df = df.na.fill({"LoanAmount": loanamount_median})

# Fill numeric nulls with mode
df = df.na.fill({
    'Loan_Amount_Term': 360,
    'Credit_History': 1
})

# Discretize continuous columns into 4 bins
for colname in ["ApplicantIncome", "CoapplicantIncome", "LoanAmount"]:
    discretizer = QuantileDiscretizer(numBuckets=4, inputCol=colname, outputCol=colname + "_disc")
    df = discretizer.fit(df).transform(df)

# encode target
loan_indexer = StringIndexer(inputCol="Loan_Status", outputCol="label", handleInvalid="keep").fit(df)
df = loan_indexer.transform(df)

# encode string inputs
input_cols = ["Gender", "Married", "Dependents", "Education", "Property_Area"]
for c in input_cols:
    input_indexer = StringIndexer(inputCol=c, outputCol=c + "_enc", handleInvalid="keep").fit(df)
    df = input_indexer.transform(df)

# assembling our features
feature_cols = [
    "Gender_enc","Married_enc","Dependents_enc","Education_enc","Property_Area_enc",
    "ApplicantIncome_disc","CoapplicantIncome_disc","LoanAmount_disc",
    "Loan_Amount_Term","Credit_History"
]
df = VectorAssembler(inputCols=feature_cols, outputCol="features").transform(df)

# splitting data into training and testing sets
train_df, test_df = df.randomSplit([0.8, 0.2], seed=42)

# creating evaluator
evaluator = MulticlassClassificationEvaluator(labelCol="label", predictionCol="prediction", metricName="accuracy")

# Logistic Regression model
lr = LogisticRegression(featuresCol="features", labelCol="label")
lr_model = lr.fit(train_df)
lr_pred = lr_model.transform(test_df)
acc_lr = evaluator.evaluate(lr_pred)

# Decision Tree model
dt = DecisionTreeClassifier(featuresCol="features", labelCol="label")
dt_model = dt.fit(train_df)
dt_pred = dt_model.transform(test_df)
acc_dt = evaluator.evaluate(dt_pred)

# Random Forest model
rf = RandomForestClassifier(featuresCol="features", labelCol="label")
rf_model = rf.fit(train_df)
rf_pred = rf_model.transform(test_df)
acc_rf = evaluator.evaluate(rf_pred)

print(f'lr accuracy: {acc_lr}')
print(f'dt accuracy: {acc_dt}')
print(f'rf accuracy: {acc_rf}')

with open("/app/output.txt", "w") as f:
    f.write(f"LogisticRegression accuracy: {acc_lr}\n")
    f.write(f"DecisionTree accuracy: {acc_dt}\n")
    f.write(f"RandomForest accuracy: {acc_rf}\n")

spark.stop()
# docker run --rm -it -v "%cd%:/app" bitnami/spark:3.5 bash -c "pip install numpy && spark-submit --master local[*] /app/loan_predict_pyspark.py"