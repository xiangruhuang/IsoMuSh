load('0.mat');

for i = 1:1000
  Si = S{i};
  S_map_i = S_map{i};
  name=num2str(i-1);
  save(strcat([name, '.mat']), 'Si', 'S_map_i');
end
