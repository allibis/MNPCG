clc; clear; close all

% caricamento del file svg
fileID = fopen('C:/Users/allibis/Downloads/allibis.svg', 'r');
svg_content = fread(fileID, '*char')';
fclose(fileID);

path_pattern = 'd="([^"]*)"';
path_matches = regexp(svg_content, path_pattern, 'tokens');

commands = regexp(path_matches{2}, '[MmLlHhVvCcSsQqTtAaZz][^MmLlHhVvCcSsQqTtAaZz]*', 'match');


x = []; y = [];
for i = 1:size(commands{1}, 2)
    axis equal
    actual = commands{1}{i};
    % Estrai numeri dal comando
    numbers = regexp(actual(2:end), '[-+]?\d*\.?\d+', 'match');
    coords = str2double(numbers);
    switch actual(1)
        case 'M'
            x(1) = coords(1);
            y(1) = -coords(2);
            disp(actual)
            disp([x,y])
        case 'L'
            x(2) = coords(1);
            y(2) = -coords(2); 

            plot(x, y, 'r-')
            disp(actual)
            disp([x(:) y(:)])

            x = [coords(1)];
            y = [-coords(2)];
            hold on
        case 'Q'
            x(2) = coords(1);
            y(2) = -coords(2);
            x(3) = coords(3);
            y(3) = -coords(4);

            P = [x(:) y(:)];
            w = [1 1 1];
            ti = [0 0 0 1 1 1];
            Q = de_boor_razionale(P,w,ti);
            plot(Q(:,1), Q(:,2), 'r-');
            disp(actual)
            disp(P)
            x = [coords(3)];
            y = [-coords(4)];
            hold on

        case 'Z'
            x = []; y = [];

        otherwise
            disp(actual);


    end
    
    
    
end