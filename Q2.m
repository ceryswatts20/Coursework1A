%% b - Plot Root Locus and unit-step response
% Zero at s = -3
zeros = [-3];
% Poles at s = -1, -5
poles = [0 -1 -5];
% Gain
K = 1
% Get open-loop transfer function; zeros, poles, gain = 1
plantOLTF = zpk(zeros, poles, K)

% Plot Root Locus
rlocus(plantOLTF)
grid on

% Save Closed-loop poles, associated feedback gain values
[r, k] = rlocus(plantOLTF);

% Set gain value for damping ratio = 0.7071
K = 0.985;
% Numerator coefficients
num = [K 3*K];
% Denominator coefficients
den = [1 6 (5+K) 3*K];
% Get closed-loop transfer function
plantCLTF1 = tf(num, den)

plantWithK = zpk(zeros, poles, K)
% Converts OLTF to CLTF - plantWithK = OLTF, 1 = H(s) as it's unity feedback
% control)
plantCLTF = feedback(plantWithK, 1)

figure
step(plantCLTF)
grid on
title('Unit-Step Response of Resulting Closed Loop System')

%% c - Root Locus for phase-led compensated system
K = 1;
% Phase-led compensator
phaseNum = [K 2*K];
phaseDen = [1 6];
phase = tf(phaseNum, phaseDen);
% Compensated plant - compensator in cascade (series) with plant
compPlantOLTF = plantOLTF*phase

% Plot compensated root locus
figure
rlocus(compPlantOLTF)
grid on
% Returns K (gain) at specified CL pole
K_pos = rlocfind(compPlantOLTF, -1.6+1.24j)
K_neg = rlocfind(compPlantOLTF, -1.6-1.24j)

% Get zeros from compensated plant OLTF
z = zero(compPlantOLTF);
% Get poles from compensated plant OLTF
p = pole(compPlantOLTF);
% Get compensated plant OLTF with desired K
compPlantOLTFwithK = zpk(z, p, K_pos)
% Get compensated plant CLTF
compPlantCLTF = feedback(compPlantOLTFwithK, 1)

% Get numerator and denominator coefficients of CLTF
[num den] = tfdata(compPlantCLTF);
% Get other closed-loop poles
clPoles = roots(cell2mat(den))

% No 'figure' so this root locus will cover the previous which isn't needed
% Plot root locus of compensated system with desired K
rlocus(compPlantOLTFwithK)
title('Root Locus Plot (K = 18.9325)')
grid on

%% d - Plot unit step response for phase-lead compensator
% Set gain value for damping ratio = 0.7071
K = 1.49;
% Get OLTF
phaseNum = [K 2*K];
phaseDen = [1 6];
phase = tf(phaseNum, phaseDen);
compPlantD = plantOLTF*phase
% Converts OLTF to CLTF - compPlant = OLTF, 1 = H(s) (1 as it's unity feedback
% control)
compPlantCLTFd = feedback(compPlantD, 1)

figure
step(compPlantCLTFd)
grid on
title('Unit-Step Response of Compensated Closed Loop System')

%% e - Plot root loci and step responses from b and d on same figure for comparison
figure
% Part b root locus
rlocus(plantOLTF, '--r')
hold on
% Part d root locus
rlocus(compPlantOLTFwithK, 'b')
grid on
title('Root Locus Comparison')
legend('Uncompensated', 'Phase-lead Compensated')

figure
step(compPlantCLTFd, plantCLTF)
legend('Compensated System', 'Uncompensated System')
grid on
title('Unit-Step Response of Uncompensated and Compensated Closed Loop Systems')

%% f - Bode plots of compenstated and uncompensated OLTFs
figure 
bode(plantOLTF, compPlantD)
grid on
legend('Uncompensated OLTF', 'Compensated OLTF')
title('Bode Plot for Compensated and Uncompensated OLTF')

% Get gain margin, phase margin and crossover frequencies
[Gm3,Pm3,Wcg3,Wcp3] = margin(plantOLTF)
[Gm4,Pm4,Wcg4,Wcp4] = margin(compPlantD)