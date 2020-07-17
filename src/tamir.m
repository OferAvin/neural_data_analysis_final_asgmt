fs = P_C_S.samplingfrequency;       % sampling frequency, Hz
dt = 1/fs;                          % time step [sec]

left_index = find(P_C_S.attribute(3,:)==1);
right_index = find(P_C_S.attribute(4,:)==1);
first_visualization(P_C_S.data,P_C_S.attribute,3,5,4)
first_visualization(P_C_S.data,P_C_S.attribute,4,5,4)
%pwelch(P_C_S.data(left_index,:,1), windowTP, overlapTP, f, fs);
