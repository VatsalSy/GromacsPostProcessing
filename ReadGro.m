%% This function will read .gro files & save them as .mat files
% Author: Vatsal Sanjay
% vatsalsanjay@gmail.com
% Physics of Fluids
function [] = ReadGro(filename, tinit, dt, Description, matfilename)
%% Details
% .gro file (filename) have time appended data of MD simulations. Generated
% by (without quotes):
% trjconv -f "trajectoryFile".trr -o "filename" -b "tinit" -e "tend" -dt "dt"
tic
%% Preprocessing the variables
fprintf('%s\n%s\n', Description, matfilename);
DATA = {[]};
fileID = fopen(filename);
counter = 1;
%% while loop to read the data file (.gro)
while ~feof(fileID) % navigate through the file
    DATA{counter}.t = tinit + dt*(counter-1); % time for current frame

    [~] = fgetl(fileID);  % this reads and ignores the first line
    Natoms = fgetl(fileID); % number of atom

    DATA{counter}.Natoms = sscanf(Natoms,'%d'); % save number of atoms
    DATA{counter}.X = zeros(DATA{counter}.Natoms,1);
    DATA{counter}.Y = zeros(DATA{counter}.Natoms,1);
    DATA{counter}.Z = zeros(DATA{counter}.Natoms,1);

    DATA{counter}.U = zeros(DATA{counter}.Natoms,1);
    DATA{counter}.V = zeros(DATA{counter}.Natoms,1);
    DATA{counter}.W = zeros(DATA{counter}.Natoms,1);

    for i = 1:1:DATA{counter}.Natoms
        gline = fgetl(fileID);

        DATA{counter}.X(i) = str2double(gline(21:28));
        DATA{counter}.Y(i) = str2double(gline(29:36));
        DATA{counter}.Z(i) = str2double(gline(37:44));

        DATA{counter}.U(i) = str2double(gline(45:52));
        DATA{counter}.V(i) = str2double(gline(53:60));
        DATA{counter}.W(i) = str2double(gline(61:68));
    end
    gline = fgetl(fileID);
    temp = sscanf(gline,'%f');
    DATA{counter}.Lx = temp(1);
    DATA{counter}.Ly = temp(2);
    DATA{counter}.Lz = temp(3);
    fprintf('Done ti = %d: t = %g\n',counter,DATA{counter}.t);
    counter = counter+1;
end
%% Saving the data as .mat file (matfilename)
save(matfilename,'DATA','Description')
toc
end
