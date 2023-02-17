%% Plant Transfer Function
% Numerator coefficients
plantNum = [750];
% Denominator coefficients
plantDen = [1 36 205 750];
% Get transfer function
plant = tf(plantNum, plantDen)

%% Reduced Order Model Transfer Function
% Numerator coefficients
reducedNum = [750];
% Denominator coefficients
reducedDen = conv([1 6 25], 30);
% Get transfer function
reducedOrder = tf(reducedNum, reducedDen)

%% c - Get step response for plant and reduced 2nd order model; step value = 10, t=0-2.5s
% Get CLTFs
plantCLTF = feedback(plant, 1)
reducedOrderCLTF = feedback(reducedOrder, 1)
% Set step value = 10
opt = stepDataOptions('StepAmplitude', 10);
% Plot step responses of plant and reduced order model
step(plantCLTF, reducedOrderCLTF, 2.5, opt)
grid on
legend('Plant', 'Reduced 2nd Order System')
title('Step Responses of the Plant and Reduced 2nd Order Models')

%% d - Determine rise time, peak time and percent overshoot
% Can also be read off the graph by double clicking and selecting
% characteristics
[yP, toutP] = step(plantCLTF, 2.5, opt);
plantInfo = stepinfo(yP, toutP, 5, 0)
[yR, toutR] = step(reducedOrderCLTF, 2.5, opt);
reducedInfo = stepinfo(yR, toutR, 5, 0)

%% e & f - Plot Bode diagrams for f = 0.1-100 rads/sec & compare frequency responses
w = {0.1 100};
figure
% Both bode plots in one figure
bode(plant, reducedOrder, w)
title('Bode Plot for Plant and Reduced 2nd Order Model')
legend
grid on