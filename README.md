The repository contains 2 projects: 
1) Credit Card Customer:
  A manager at the bank is disturbed with more and more customers leaving their credit card services. They would really appreciate if one could predict for them who is gonna get churnedso they can proactively go to
the customer to provide them better services and turn customers' decisions in the opposite direction.
  Now, this dataset consists of 10,000 customers mentioning their age, salary, marital_status, credit card limit, credit card category, etc.
  Column names of the dataset: 
    CLIENTNUM : Unique client identifier.
    Attrition_Flag : Indicates whether the customer's account is active or has churned.
    Customer_Age : Age of the customer.
    Gender : Gender of the customer.
    Dependent_count : Number of dependents of the customer.
    Education_Level : Educational level of the customer.
    Marital_Status : Marital status of the customer.
    Income_Category : Income category of the customer.
    Card_Category : Category of the credit card held by the customer.
    Months_on_book : Number of months the customer has been a bank client.
    Total_Relationship_Count : Total number of bank products held by the customer.
    Months_Inactive_12_mon : Number of months with inactivity in the last 12 months.
    Contacts_Count_12_mon : Number of contacts with the bank in the last 12 months.
    Credit_Limit : Credit limit on the credit card.
    Total_Revolving_Bal : Total revolving balance on the credit card.
    Avg_Open_To_Buy : Average open to buy credit line on the credit card.
    Total_Amt_Chng_Q4_Q1 : Change in transaction amount over the last four quarters.
    Total_Trans_Amt : Total transaction amount in the last 12 months.
    Total_Trans_Ct : Total transaction count in the last 12 months.
    Total_Ct_Chng_Q4_Q1 : Change in transaction count over the last four quarters.
    Avg_Utilization_Ratio : Average utilization ratio of the credit card.
2) London Bike Sharing:
   Columns names of dataset:
    "timestamp" - timestamp field for grouping the data
    "cnt" - the count of a new bike shares
    "t1" - real temperature in C
    "t2" - temperature in C "feels like"
    "hum" - humidity in percentage
    "wind_speed" - wind speed in km/h
    "weather_code" - category of the weather
    "is_holiday" - boolean field - 1 holiday / 0 non holiday
    "is_weekend" - boolean field - 1 if the day is weekend
    "season" - category field meteorological seasons: 0-spring ; 1-summer; 2-fall; 3-winter.
    "weathe_code" category description:
    1 = Clear ; mostly clear but have some values with haze/fog/patches of fog/ fog in vicinity 2 = scattered clouds / few clouds 3 = Broken clouds 4 = Cloudy 7 = Rain/ light Rain shower/ Light rain 10 = rain with
    thunderstorm 26 = snowfall 94 = Freezing Fog

Lisence:
These licence terms and conditions apply to TfL's free transport data service and are based on version 2.0 of the Open Government Licence with specific amendments for Transport for London (the "Licence").
 TfL may at any time revise this Licence without notice. It is up to you ("You") to regularly review the Licence, which will be available on this website, in case there are any changes. Your continued use of the
 transport data feeds You have opted to receive ("Information") after a change has been made to the Licence will be treated as Your acceptance of that change. 
 
The data is acquired from 3 sources:
  Https://cycling.data.tfl.gov.uk/ 'Contains OS data © Crown copyright and database rights 2016' and Geomni UK Map data © and database rights [2019] 'Powered by TfL Open Data'
  freemeteo.com - weather data
  https://www.gov.uk/bank-holidays
  From 1/1/2015 to 31/12/2016
  The data from cycling dataset is grouped by "Start time", this represent the count of new bike shares grouped by hour. The long duration shares are not taken in the count.
