## Kalman Filter

#### Models
Directly in Windows (languages,libraries,setup)
 - R version 3.3 (dlm,ggplot2,zoo,gridExtra,KFAS)
 - Rstudio

#### Report
- pdf

#### Summary
Forecasting the commodity value is a challenging process due to the stochastic non-linear
nature of the financial market. While there have been a number studies on statistical and
filtering techniques for stock market prediction, this paper improves on the current literature
by investigating the novel development of Kalman filters techniques applied to iron ore
prices.

The forecasting capabilities of Kalman filters are studied and compared to traditional
Autoregressive Integrated Moving Average (ARIMA) models. The comparison was
conducted through the efficient modelling and forecasting of monthly commodity prices of
iron ore over 30 years.

The study signifies the important role of parameter estimates obtained in both ARIMA and
the Kalman process when devising optimal approaches to forecasting long term iron ore
prices. Results of the study will show the best performing models obtained by comparison of
statistical performance metrics and the potential in developing automatic prediction system
for commodity prices, patterns and volatility in the economic sector for applications such as
risk management, asset pricing and allocation.

For the project, we split the dataset into a training series for model build and parameter
estimation and a testing series for forecast models ARIMA and KF comparison. 
<p align="center">
<img src="lib\images\figure1.png" width=700>
</p>

#### Kalman Filter

Under the assumption that our data is in the form of a Gaussian distribution we will apply an
iterate measurement update and motion prediction through linear equations. Kalman filters
can combine measurements from one state and system dynamics to give better estimates of
both the unmeasured and measured states. 

The first step obtains a priori estimates of probability of states, then Bayes rules updates to
calculate a better estimate of probability. Bayes rules are describe below,
Consider two normal probability distributions given by,
<p align="center">
<img src="lib\images\two_normal_dist.png" width=250>
</p>

Bayesian probability is therefore given by,
<p align="center">
<img src="lib\images\bayes_two_normal_dist.png" width=400>
</p>

The final form of the Kalman filter state propagation (prediction) and measurement update with dynamic system in the following form ([Kalman, 1960](http://160.78.24.2/Public/Kalman/Kalman1960.pdf)). 

<p align="center">
<img src="lib\images\final_kalman_form.png" width=600>
<img src="lib\images\lemma.png" width=400>
</p>


#### Performance Measures
To evaluating the performance of the non-linear and linear based models the following.

- Coefficient of Determination (r^2) , Root Mean Square Error (RMSE), Relative Root Mean Square Error (RRMSE), Mean Absolute Error (MAE), Mean Absolute Percentage Error (MAPE) 


<p align="center">
<img src="lib\images\performance_metrics.png" width=350>
</p>
<p align="center">
<img src="lib\images\figure2.png" width=500>
</p>

Overall, the study highlights the appropriateness of the ARIMA and Kalman
approaches to modelling for forecasting a year of iron ore prices. Although findings showed
traditional methods of ARIMA outperforming Kalman, it did highlight the advantages of the
Kalman in modelling the change in future prices. 