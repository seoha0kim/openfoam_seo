clear; close all; clc;
%% PURPOSE: solves for the spatial component of the steady-state monofrequent aeolian vibration
% of a single conductor span with a Stockbridge-type damper attached by using EBP(Energy Balance Principle).
% Date: 18.08.30        Modified: 20.04.28
% Jaegu Choi, Seungyong YOO

%% Load the cable(conductor) and sb damper parameters
data = xlsread('Input data.xlsx');
Cond = data(1:8);           % Conductor Parameters
mass_leng = Cond(1);        % conductor mass per length (kg/m)
D_cable = Cond(2);          % conductor diameter (m)
L_cable = Cond(5);          % conductor length (m)
T_cable = Cond(6);          % conductor tension (N)
Damp = data(11:13);         % Damper Parameters
x1 = Damp(3);               % distance b/w damper and clamp [m]

%% Load SB damper test result
Diana = diana();            % Diana data
Diana(:,1);                                              % Test frequency
Diana(:,10) = (Diana(:,2)+Diana(:,4)+Diana(:,6)) / 3;    % Mean of magnitude(before the fatigue test, N/mm)
Diana(:,11) = (Diana(:,3)+Diana(:,5)+Diana(:,7)) / 3;    % Mean of phase(phase difference between moving velocity and force, deg)
Diana(:,12) =  Diana(:,8)./(Diana(:,1))*1000;            % damper mechanical impedance(Z(i*omega)=-m*omega^2+i*c*omega+K) after the fatigue test, (N-s/m))
Diana(:,13) =  Diana(:,9)*pi/180;                        % phase(phase difference after the fatigue test, rad)

%% Variable
freq = 2:1:50; % Analysis frequency range
Ymax = zeros(1,size(freq,2)); % Equilibrim Amplitude (m)
Ymax_wo = zeros(1,size(freq,2)); % Equilibrim Amplitude (m)
Ymax_wo1 = zeros(1,size(freq,2)); % Equilibrim Amplitude (m)
Ymax_1 = zeros(1,size(freq,2)); % Equilibrim Amplitude (m)
A = 0.01:0.01:D_cable*1.5*2;  % Assumed cable vibration amplitude(single vibration amplitude) -> not more that 150% of cable diameter (meter)

A1 = 0.01:0.001:D_cable*1.5*2;  % Assumed cable vibration amplitude(single vibration amplitude) -> not more that 150% of cable diameter (meter)

for f = 1:size(freq,2)
    for i = 1:size(A,2)

        % %% Wind energy
        Ewa(f,i) = (807.4*(A(i)/D_cable).^1.953 - 767.6*(A(i)/D_cable).^2 - 3.2*(A(i)/D_cable).^3 - 78.2*(A(i)/D_cable).^4)*(D_cable^4)*(freq(f)^3)*L_cable;  % Riegert & Currie Polynomial
        Ewb(f,i) = (-99.73*(A(i)/D_cable)^3 - 101.62*(A(i)/D_cable)^2 - 0.1627*(A(i)/D_cable) + 0.2256)*((D_cable^4)*(freq(f)^3)*L_cable);                    % Carrol and Diana & Falco

       %% Conductor energy %%
        d = 1000*D_cable;       % conductor diameter (mm)
        RS = Cond(7);           % rated strength of conductor (kN) -> EI/I*A*sig_allow_of_material
        K = d/sqrt(RS*mass_leng); % proportionality factor that characterizes the conductor self-damping properties, range of 1.5 to 2 for classical conductor material
        p = 2.44; u = 5.63; v = 2.76;   % conductor self-damping exponent, Noiseux
        % p = 2.50; u = 5.75; v = 2.8;  % conductor self-damping exponent, Seppa,Noiseux
        % p = 2.43; u = 5.50; v = 2.0;  % conductor self-damping exponent, Politecnico di Milano
        Ec(f,i) = L_cable*K*((A(i)/D_cable).^p)*(freq(f)^u)/(T_cable^v);

       %% Damper energy %%
        cw = sqrt(T_cable/mass_leng);   % wave velocity (m/s)
        kw(f) = 2*pi*freq(f)/cw;        % wave number (rad/m)
        Z(f) = interp1(Diana(:,1), Diana(:,12), freq(f));        % damper mechanical impedance(at the shaker test(absolute ratio between force and velocity) (N-s/m)
        alpha(f) = interp1(Diana(:,1), Diana(:,13), freq(f));    % phase angle between force and velocity at the shaker test (rad)
        r(f) = T_cable/(Z(f)*cw);
        h(f) = -(sin(kw(f)*x1)^2*(sin(2*kw(f)*x1) + 2*r(f)*sin(alpha(f)))) / (sin(kw(f)*x1)^2 + r(f)^2 + 2*r(f)*sin(kw(f)*x1)*sin(kw(f)*x1 + alpha(f)));
        g(f) = (sin(kw(f)*x1)^2*cos(2*kw(f)*x1) + r(f)^2 + r(f)*sin(2*kw(f)*x1)*sin(alpha(f))) / (sin(kw(f)*x1)^2 + r(f)^2 + 2*r(f)*sin(kw(f)*x1)*sin(kw(f)*x1 + alpha(f)));
        Ed(f,i) = 0.25*T_cable*cw*kw(f)^2*(1 - (h(f)^2 + g(f)^2))/(1 + (h(f)^2 + g(f)^2))*D_cable^2*(A(i)/D_cable).^2;

       %% Ymax %%
        fun = @(A) (Ewind_fun(A, D_cable, freq(f), L_cable) - (Econ_fun(A, D_cable, freq(f), K, L_cable, T_cable, p, u, v) + Edamp_fun(A, D_cable, T_cable, cw, kw(f), h(f), g(f))));
        lb = 0.0001;                % trial lower boundary for conductor peak to peak amplitude (m) !=0
        ub = D_cable*1.5*2;         % trial upper boundary for conductor peak to peak amplitude (m)
        Amp = fzero(fun, [lb ub]);
        Ymax(f) = Amp;              % single vibration amplitude(half of pk-pk amplitude)

        [~,id] = min(abs(fun(A1)));
        Ymax_1(f) = A1(id);

        fun = @(A) (Ewind_fun(A, D_cable, freq(f), L_cable) - (Econ_fun(A, D_cable, freq(f), K, L_cable, T_cable, p, u, v)));
        lb = 0.0001;                % trial lower boundary for conductor peak to peak amplitude (m) !=0
        ub = D_cable*1.5*2;         % trial upper boundary for conductor peak to peak amplitude (m)
        Amp = fzero(fun, [lb ub]);
        Ymax_wo(f) = Amp;              % single vibration amplitude(half of pk-pk amplitude)

        [~,id] = min(abs(fun(A)));
        Ymax_wo1(f) = A(id);
    end
end

%% Graph
% figure
% plot(freq,Ewa-Ewb)
figure
plot(A, Ec);title('Power Dissipated by the Conductor Self-Damping (W)');xlabel('Amplitude (m)');ylabel('Power (W)');
figure
plot(A, Ed);title('Power Dissipated by the SB Damper (W)');xlabel('Amplitude (m)');ylabel('Power (W)');
% legend('Ew','Ec+Ed')
figure
plot(A, Ewa-Ec-Ed);title('Power Equilibrium Ewa-Ec-Ed');xlabel('Amplitude (m)');ylabel('Power (W)');
xlim([0 0.11]); % SEE last plot - Vibration Amplitude : Max Amplitude
figure
plot(Ymax);title('Vibration Amplitude');xlabel('Frequency (Hz)');ylabel('Amplitude (m)');
hold on; plot(Ymax_1);
% hold on; plot(Ymax_wo); plot(Ymax_wo1);

function y = Ewind_fun(A, D, f, L)
y = (807.4*(A/D).^1.953 - 767.6*(A/D).^2 - 3.2*(A/D).^3 - 78.2*(A/D).^4).*((D.^4)*(f^3)*L);
end

function y = Econ_fun(A, D, f, K, L, T, p, u, v)
y = L*K*((A/D).^p)*(f^u)/(T^v);
end

function y = Edamp_fun(A, D, T, cw, kw, h, g)
y = 0.25*T*cw*kw^2*(1 - (h^2 + g^2))/(1 + (h^2 + g^2))*D^2*(A/D).^2;
end

figure(4)