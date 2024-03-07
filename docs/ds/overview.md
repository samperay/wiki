## Data Science Methodology

**Module 1: From Problem to Approach**

Business Understanding
Analytic Approach

**Module 2: From Requirements to Collection**

Data Requirements
Data Collection

**Module 3: From Understanding to Preparation**

Data Understanding
Data Preparation

**Module 4: From Modeling to Evaluation**

Modeling
Evaluation

**Module 5: From Deployment to Feedback**

Deployment
Feedback


## Business understanding

Data science methodology begins with spending the time to seek clarification, to attain what can be referred to as a business understanding. Having this understanding is placed at the beginning of the methodology because getting clarity around the problem to be solved, allows you to determine which data will be used to answer the core question.

Establishing a clearly defined question starts with understanding the GOAL of the person who is asking the question.
For example, if a business owner asks:  "How can we reduce the costs of performing an activity?"

We need to understand, is the goal to improve the efficiency of the activity?
Or is it to increase the businesses profitability?

Once the goal is clarified, the next piece of the puzzle is to figure out the objectives
that are in support of the goal. By breaking down the objectives, structured discussions can take place where priorities
can be identified in a way that can lead to organizing and planning on how to tackle the problem.Depending on the problem, different stakeholders will need to be engaged in the discussion to help determine requirements and clarify questions.

Case study for "Business Understanding"
In the case study, the question being asked is: What is the best way to allocate the limited
healthcare budget to maximize its use in providing quality care?

This question is one that became a hot topic for an American healthcare insurance provider.
As public funding for readmissions was decreasing, this insurance company was at risk of having
to make up for the cost difference,which could potentially increase rates for its customers.
Knowing that raising insurance rates was not going to be a popular move, the insurance
company sat down with the health care authorities in its region and brought in IBM data scientists
to see how data science could be applied to the question at hand.
Before even starting to collect data, the goals and objectives needed to be defined.
After spending time to determine the goals and objectives, the team prioritized "patient
readmissions" as an effective area for review.
With the goals and objectives in mind, it was found that approximately 30% of individuals
who finish rehab treatment would be readmitted to a rehab center within one year; and that
50% would be readmitted within five years.
After reviewing some records, it was discovered that the patients with congestive heart failure
were at the top of the readmission list.
It was further determined that a decision-tree model could be applied to review this scenario,
to determine why this was occurring.
To gain the business understanding that would guide the analytics team in formulating and
performing their first project, the IBM Data scientists, proposed and delivered an on-site
workshop to kick things off.
The key business sponsors involvement throughout the project was critical, in that the sponsor:
- Set overall direction
- Remained engaged and provided guidance.
- Ensured necessary support, where needed.
- Finally, four business requirements were identified for whatever model would be built.
Namely:
Predicting readmission outcomes for those patients with Congestive Heart Failure
Predicting readmission risk.
Understanding the combination of events that led to the predicted outcome
Applying an easy-to-understand process to new patients, regarding their readmission risk.

## Analytic Approach

Once the problem to be addressed is defined, the appropriate analytic approach for the problem is selected in the context of the business requirements.

Once a strong understanding of the question is established, the analytic approach can be selected. This means identifying what type of patterns will be needed to address the question most effectively. 

- Question is to **determine probabilities** of an action, then a **predictive model** might be used.

- Question is to **show relationships**, **a descriptive approach** maybe be required. This would be one that would look at clusters of similar activities based on events and preferences.

- Question is to **Statistical analysis applies** to problems that **require counts**.

- Question requires a **yes/ no answer**, then a **classification approach to predicting a response** would be suitable.

Machine Learning can be used to **identify relationships and trends in data** that might otherwise not be accessible or identified.

In the case where the question is to learn about human behaviour, then an appropriate response would be to use Clustering Association approaches.

**Case study related to applying Analytic Approach.**,  a decision tree classification model was used to identify the combination
of conditions leading to each patient's outcome.

In this approach, examining the variables in each of the nodes along each path to a leaf, led to a respective threshold value. This means the decision tree classifier provides both the predicted outcome, as well as the likelihood of that outcome, based on the proportion at the dominant outcome, yes or no, in each group.

From this information, the analysts can obtain the readmission risk, or the likelihood of a yes for each patient. If the dominant outcome is yes, then the risk is simply the proportion of yes patients in the leaf. If it is no, then the risk is 1 minus the proportion of no patients in the leaf.

A decision tree classification model is easy for non-data scientists to understand and apply, to score new patients for their risk of readmission. Clinicians can readily see what conditions are causing a patient to be scored as high-risk and multiple models can be built and applied at various points during hospital stay. This gives a moving picture of the patient's risk and how it is evolving with the various treatments being applied. For these reasons, the decision tree classification approach was chosen for building the Congestive Heart Failure readmission model.

## Data Requirements

Building on the understanding of the problem at hand, and then using the analytical approach selected, the Data Scientist is ready to get started.

Now let's look at some examples of the data requirements within the data science methodology.

Prior to undertaking the data collection and data preparation stages of the methodology, it's vital to define the data requirements for decision-tree classification. This includes identifying the necessary data content, formats and sources for initial data collection.

So now, let's look at the **case study** related to applying "Data Requirements".

In the case study, the first task was to define the data requirements for the decision tree classification approach that was selected. This included selecting a suitable patient cohort from the health insurance providers member base. In order to compile the complete clinical histories, three criteria were identified for inclusion in the cohort.

First, a patient needed to be admitted as in-patient within the provider service area, so they'd have access to the necessary information.
Second, they focused on patients with a primary diagnosis of congestive heart failure during
one full year.
Third, a patient must have had continuous enrollment for at least six months, prior to the primary admission for congestive heart failure, so that complete medical history could be compiled.

Congestive heart failure patients who also had been diagnosed as having other significant medical conditions, were excluded from the cohort because those conditions would cause higher-than-average re-admission rates and, thus, could skew the results. Then the content, format, and representations of the data needed for decision tree classification
were defined. This modeling technique requires one record per patient, with columns representing the variables in the model. To model the readmission outcome, there needed to be data covering all aspects of the patient's clinical history. This content would include admissions, primary, secondary, and tertiary diagnoses, procedures, prescriptions, and other services provided either during hospitalization or throughout
patient/doctor visits. 

Thus, a particular patient could have thousands of records, representing all their related
attributes. To get to the one record per patient format, the data scientists rolled up the transactional
records to the patient level, creating a number of new variables to represent that information.

This was a job for the data preparation stage, so thinking ahead and anticipating subsequent
stages is important.

## Data Collection

Collecting data requires that you know the source or, know where to find the data elements that are needed.

After the initial data collection is performed, an assessment by the data scientist takes place to determine whether or not they have what they need.

Once the data ingredients are collected, then in the data collection stage, the data scientist will have a good understanding of what they will be working with. Techniques such as **descriptive statistics and visualization** can be applied to the data set, **to assess the content, quality, and initial insights** about the data. Gaps in data will be identified and plans to either fill or make substitutions will have to be made. In essence, the ingredients are now sitting on the cutting board.

So now, let's look at the **case study** related to applying "Data Collection".

demographic, clinical and coverage information of patients, provider information, claims records, as well as pharmaceutical and other information related to all the diagnoses of the congestive heart failure patients.

For this case study, certain drug information was also needed, but that data source was not yet integrated with the rest of the data sources. This leads to an important point: It is alright to defer decisions about unavailable data, and attempt to acquire it at a later stage.

For example, this can even be done after getting some intermediate results from the predictive modeling. If those results suggest that the drug information might be important in obtaining a good model, then the time to try to get it would be invested. As it turned out though, they were able to build a reasonably good model without this drug information.

DBAs and programmers often work together to extract data from various sources, and then merge it. This allows for removing redundant data, making it available for the next stage of the methodology, which is **data understanding**.

At this stage, if necessary, data scientists and analytics team members can discuss various ways to better manage their data, including automating certain processes in the database, so that data collection is easier and faster.

## Data Understanding

Data understanding encompasses all activities related to **constructing the data set**. Essentially, the data understanding section of the data science methodology answers the question: 
**Is the data that you collected representative of the problem to be solved?**

**Case Study:**

In order to understand the data related to congestive heart failure admissions, descriptive statistics needed to be run against the data columns that would become variables in the model.

- First, these **statistics** included Hearst, univariates, and statistics on each variable, such as mean, median, minimum, maximum, and standard deviation.

- Second, **pairwise correlations** were used, to see how closely certain variables were related, and which ones, if any, were very highly correlated, meaning that they would be essentially redundant, thus making only one relevant for modeling.

- Third, **histograms** of the variables were examined to understand their distributions. Histograms are a good way to understand how values or a variable are distributed, and which sorts of data preparation may be needed to make the variable more useful in a model.

For example, for a categorical variable that has too many distinct values to be informative in a model, the histogram would help them decide how to consolidate those values. **The univariates, statistics, and histograms** are also used to assess data quality.

From the information provided, certain values can be re-coded or perhaps even dropped if necessary, such as when a certain variable has many missing values. The question then becomes, does "missing" mean anything? Sometimes a missing value might mean "no", or "0" (zero), or at other times it simply means "we don't know". Or, if a variable contains invalid or misleading values, such as a numeric variable called "age" that contains 0 to 100 and also 999, where that "triple-9" actually means "missing", but would be treated as a valid value unless we corrected it.

Initially, the meaning of congestive heart failure admission was decided on the basis of a primary diagnosis of congestive heart failure. But working through the data understanding stage revealed that the initial definition was not capturing all of the congestive heart failure admissions that were expected, based on clinical experience. This meant looping back to the data collection stage and adding secondary and tertiary diagnoses, and building a more comprehensive definition of congestive heart failure admission.

This is just one example of the interactive processes in the methodology. The more one works with the problem and the data, the more one learns and therefore the more refinement that can be done within the model, ultimately leading to a better solution
to the problem.

## Data Preparation

In a sense, data preparation is similar to washing freshly picked vegetables in so far as unwanted elements, such as dirt or imperfections, are removed. Together with data collection and data understanding, data preparation is the most time-consuming phase of a data science project, typically taking seventy percent and even up to even ninety percent of the overall project time. Automating some of the data collection and preparation processes in the database, can reduce this time to as little as 50 percent.

**Case Study:**

Transforming data in the data preparation phase is the process of getting the data into a state where it may be easier to work with. Specifically, the data preparation stage of the methodology answers the question: What are the ways in which data is prepared?

To work effectively with the data, it must be prepared in a way that addresses missing or invalid values and removes duplicates, toward ensuring that everything is properly formatted.

**Feature engineering is also part of data preparation**. It is the process of using domain knowledge of the data to create features that make the machine learning algorithms work. **A feature is a characteristic that might help when solving a problem**. Features within the data are important to **predictive models** and will influence the results you want to achieve.

Feature engineering is critical when machine learning tools are being applied to analyze the data. When working with text, text analysis steps for coding the data are required to be able to manipulate the data. The data scientist needs to know what they're looking for within their dataset to address the question. 

The text analysis is critical to ensure that the proper groupings are set, and that the programming is not overlooking what is hidden within. The data preparation phase sets the stage for the next steps in addressing the question. While this phase may take a while to do, if done right the results will support the project. If this is skipped over, then the outcome will not be up to par and may have you back at the drawing board. It is vital to take your time in this area, and use the tools available to automate common steps to accelerate data preparation. Make sure to pay attention to the detail in this area. After all, it takes just one bad ingredient to ruin a fine meal.

## Modelling

Modelling is the stage in the data science methodology where the data scientist has the chance to sample the sauce and determine if it's bang on or in need of more seasoning!

**two key questions:**
First, what is the purpose of data modeling, and second, what are some characteristics of this process?

Data Modelling focuses on developing models that are either descriptive or predictive.

An example of a descriptive model might examine things like: if a person did this, then they're likely to prefer that.

A predictive model tries to yield yes/no, or stop/go type outcomes.

These models are based on the analytic approach that was taken, either statistically driven or machine learning driven.
The data scientist will use a training set for predictive modelling. A training set is a set of historical data in which the outcomes are already known. The training set acts like a gauge to determine if the model needs to be calibrated.
In this stage, the data scientist will play around with different algorithms to ensure that the variables in play are actually required.

The success of data compilation, preparation and modelling, depends on the understanding of the problem at hand, and the appropriate analytical approach being taken. The data supports the answering of the question, and like the quality of the ingredients in cooking, sets the stage for the outcome. Constant refinement, adjustments and tweaking are necessary within each step to ensure the outcome is one that is solid.

In John Rollins' descriptive Data Science Methodology, the framework is geared to do 3 things: 
First, understand the question at hand. 
Second, select an analytic approach or method to solve the problem, and
third, obtain, understand, prepare, and model the data.

The end goal is to move the data scientist to a point where a data model can be built to answer the question.
With dinner just about to be served and a hungry guest at the table, the key question is: Have I made enough to eat? Well, let's hope so.

In this stage of the methodology, model evaluation, deployment, and feedback loops ensure that the answer is near and relevant. This relevance is critical to the data science field overall, as it ís a fairly new field of study, and we are interested in the possibilities it has to offer. The more people that benefit from the outcomes of this practice, the further the field will develop.

## Evaluation

A model evaluation goes hand-in-hand with model building as such, the modeling and evaluation stages are done iteratively. Model evaluation is performed during model development and before the model is deployed.

Evaluation allows the quality of the model to be assessed but it's also an opportunity to see if it meets the initial request. Evaluation answers the question: Does the model used really answer the initial question or does it need to be adjusted?

Model evaluation can have two main phases.

The first is the diagnostic measures phase, which is used to ensure the model is working as intended.
If the model is a predictive model, a decision tree can be used to evaluate if the answer the model can output, is aligned to the initial design. It can be used to see where there are areas that require adjustments.
If the model is a descriptive model, one in which relationships are being assessed, then a testing set with known outcomes can be applied, and the model can be refined as needed.

The second phase of evaluation that may be used is statistical significance testing. This type of evaluation can be applied to the model to ensure that the data is being properly handled and interpreted within the model.
This is designed to avoid unnecessary second guessing when the answer is revealed.

**Case Study:**

Let's look at one way to find the optimal model through a diagnostic measure based on
tuning one of the parameters in model building. Specifically we'll see how to tune the relative cost of misclassifying yes and no outcomes. As shown in this table, four models were built with four different relative misclassification costs.
As we see, each value of this model-building parameter increases the true-positive rate, or sensitivity, of the accuracy in predicting yes, at the expense of lower accuracy in predicting no, that is, an increasing false-positive rate.

The question then becomes, which model is best based on tuning this parameter?
For budgetary reasons, the risk-reducing intervention could not be applied to most or all congestive heart failure patients, many of whom would not have been readmitted anyway. On the other hand, the intervention would not be as effective in improving patient care as it should be, with not enough high-risk congestive heart failure patients targeted.

So, how do we determine which model was optimal?
As you can see on this slide, the optimal model is the one giving the maximum separation between the blue ROC curve relative to the red base line. We can see that model 3, with a relative misclassification cost of 4-to-1, is the best of the 4 models. And just in case you were wondering, ROC stands for receiver operating characteristic curve, which was first developed during World War II to detect enemy aircraft on radar. It has since been used in many other fields as well. Today it is commonly used in machine learning and data mining. The ROC curve is a useful diagnostic tool in determining the optimal classification model.

This curve quantifies how well a binary classification model performs, declassifying the yes and no outcomes when some discrimination criterion is varied. In this case, the criterion is a relative misclassification cost.
By plotting the true-positive rate against the false-positive rate for different values of the relative misclassification cost, the ROC curve helped in selecting the optimal model.

## Deployment

While a data science model will provide an answer, the key to making the answer relevant and useful to address the initial question, involves getting the stakeholders familiar with the tool produced.

In a business scenario, stakeholders have different specialties that will help make this happen, such as the solution owner, marketing, application developers, and IT administration. Once the model is evaluated and the data scientist is confident it will work, it is deployed
and put to the ultimate test. Depending on the purpose of the model, it may be rolled out to a limited group of users or in a test environment, to build up confidence in applying the outcome for use across the board.

**Case Study**

In preparation for solution deployment, the next step was to assimilate the knowledge for the business group who would be designing and managing the intervention program to reduce readmission risk. In this scenario, the business people translated the model results so that the clinical staff could understand how to identify high-risk patients and design suitable intervention actions.

The goal, of course, was to reduce the likelihood that these patients would be readmitted within 30 days after discharge.
During the business requirements stage, the Intervention Program Director and her team had wanted an application that would provide automated, near real-time risk assessments of congestive heart failure. It also had to be easy for clinical staff to use, and preferably through browser-based application on a tablet, that each staff member could carry around. This patient data was generated throughout the hospital stay. It would be automatically prepared in a format needed by the model and each patient would be scored near the time of discharge. Clinicians would then have the most up-to-date risk assessment for each patient, helping
them to select which patients to target for intervention after discharge. As part of solution deployment, the Intervention team would develop and deliver training for the clinical staff. Also, processes for tracking and monitoring patients receiving the intervention would
have to be developed in collaboration with IT developers and database administrators, so that the results could go through the feedback stage and the model could be refined over time.

This map is an example of a solution deployed through a Cognos application. In this case, the case study was hospitalization risk for patients with juvenile diabetes. Like the congestive heart failure use case, this one used decision tree classification to create a risk model that would serve as the foundation for this application. The map gives an overview of hospitalization risk nationwide, with an interactive analysis of predicted risk by a variety of patient conditions and other characteristics. This slide shows an interactive summary report of risk by patient population within a given node of the model, so that clinicians could understand the combination of conditions for this subgroup of patients. And this report gives a detailed summary on an individual patient, including the patient's
predicted risk and details about the clinical history, giving a concise summary for the doctor.


## Feedback

Once in play, feedback from the users will help to refine the model and assess it for performance and impact. The value of the model will be dependent on successfully incorporating feedback and making adjustments for as long as the solution is required. Throughout the Data Science Methodology, each step sets the stage for the next. Making the methodology cyclical, ensures refinement at each stage in the game. The feedback process is rooted in the notion that, the more you know, the more that you'll
want to know.

Once the model is evaluated and the data scientist is confident it'll work, it is deployed and put to the ultimate test: actual, real-time use in the field.

**Case Study**

The plan for the feedback stage included these steps:

First, the review process would be defined and put into place, with overall responsibility for measuring the results of a "flying to risk" model of the congestive heart failure risk population. Clinical management executives would have overall responsibility for the review process.

Second, congestive heart failure patients receiving intervention would be tracked and their re-admission outcomes recorded.

Third, the intervention would then be measured to determine how effective it was in reducing
re-admissions.

For ethical reasons, congestive heart failure patients would not be split into controlled and treatment groups. Instead, readmission rates would be compared before and after the implementation of the model to measure its impact. After the deployment and feedback stages, the impact of the intervention program on re-admission rates would be reviewed after the first year of its implementation. Then the model would be refined, based on all of the data compiled after model implementation and the knowledge gained throughout these stages. Other refinements included: Incorporating information about participation in the intervention program, and possibly refining the model to incorporate detailed pharmaceutical data.

If you recall, data collection was initially deferred because the pharmaceutical data was not readily available at the time. But after feedback and practical experience with the model, it might be determined that adding that data could be worth the investment of effort and time. We also have to allow for the possibility that other refinements might present themselves during the feedback stage. Also, the intervention actions and processes would be reviewed and very likely refined as well, based on the experience and knowledge gained through initial deployment and feedback.

Finally, the refined model and intervention actions would be redeployed, with the feedback process continued throughout the life of the Intervention program.

