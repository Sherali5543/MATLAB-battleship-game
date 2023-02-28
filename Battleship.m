%Battleship game constructed ontop of Matlab graph feature

%Grid construction
close all
plotgrid

choice = menu('How would you like to play','Player vs Player','Exit');


[datap1, datap2] = createShips;
switch choice
    case 1
        for i = 1:6
            datap1 = shipplace(datap1,i);
            plotships(datap1(i))
        end
        pause(1)
        clf
        plotgrid
        disp('Player 2')
        
        for i = 1:6
            datap2 = shipplace(datap2,i);
            plotships(datap2(i))
        end
        pause(1)
        clf
        plotgrid
        game = 1;
        rowp1 = 1;
        row2p1 = 1;
        hitp1 = [];
        missp1 = [];
        rowp2 = 1;
        row2p2 = 1;
        hitp2 = [];
        missp2 = [];
        while game == 1
            check = 0;
            
            clf
            disp('Player 1')
            plotgrid
            if ~(isempty(hitp1))
                plot(hitp1(:,1),hitp1(:,2),'xr')
            end
            if ~(isempty(missp1))
                plot(missp1(:,1),missp1(:,2),'ob')
            end
            while check == 0
                xshot = input('Where would you like to shoot?(x) ');
                yshot = input('Where would you like to shoot?(y) ');
                check = errorcheck(xshot,yshot);
                if check == 0
                    disp('Out of bounds! Try again!')
                end
            end
            shot = [xshot yshot];
            for i = 1:6
                check2 = 3;
                while check2 == 3
                    check2 = shotchecker(shot,datap2,hitp1,missp1);
                    if check2 == 3
                        check = 0;
                    end
                    while check == 0
                        xshot = input('Where would you like to shoot?(x) ');
                        yshot = input('Where would you like to shoot?(y) ');
                        check = errorcheck(xshot,yshot);
                        if check == 0
                            disp('Out of bounds! Try again!')
                        end
                    end
                    shot = [xshot yshot];
                end
                if check2 == 0
                    disp('HIT!')
                    hitp1 = hitplotter(shot,hitp1,rowp1);
                    rowp1 = rowp1+1;
                    break
                elseif check2 == 1
                    disp('Miss!')
                    missp1 = missplotter(shot,missp1,rowp1);
                    row2p1 = row2p1+1;
                    break
                end
            end
            pause(1)
            game = gamefinishcheck(hitp1,datap2);
            if game == 0
                disp('Game over! Player 1 wins!')
                break
            end
            clf
            disp('Player 2')
            plotgrid
            if ~(isempty(hitp2))
                plot(hitp2(:,1),hitp2(:,2),'xr')
            end
            if ~(isempty(missp2))
                plot(missp2(:,1),missp2(:,2),'ob')
            end
            %Player 2
            check = 0;
            while check == 0
                xshot = input('Where would you like to shoot?(x) ');
                yshot = input('Where would you like to shoot?(y) ');
                check = errorcheck(xshot,yshot);
                if check == 0
                    disp('Out of bounds! Try again!')
                end
            end
            shot = [xshot yshot];
            for i = 1:6
                check2 = 3;
                while check2 == 3
                    [check2] = shotchecker(shot,datap2,hitp2,missp2);
                    if check2 == 3
                        check = 0;
                    end
                    while check == 0
                        xshot = input('Where would you like to shoot?(x) ');
                        yshot = input('Where would you like to shoot?(y) ');
                        check = errorcheck(xshot,yshot);
                        if check == 0
                            disp('Out of bounds! Try again!')
                        end
                    end
                    shot = [xshot yshot];
                end
                if check2 == 0
                    disp('HIT!')
                    hitp2 = hitplotter(shot,hitp2,rowp2);
                    rowp2 = rowp2+1;
                    break
                end
                if check2 == 1
                    disp('Miss!')
                    missp2 = missplotter(shot,missp2,rowp2);
                    row2p2 = row2p2+1;
                    break
                end
            end
            pause(1)
            game = gamefinishcheck(hitp2,datap1);
            if game == 0
                disp('Game over! Player 2 wins!')
                break
            end
        end
end

function check = gamefinishcheck(hitdata,playerdata)
[rows,~] = size(hitdata);
runsum = 0;
check = 1;
for i = 1:6
    shipsize = length(playerdata(i).Coord);
    for j = 1:rows
        for k = 1:shipsize
            temp = hitdata(j,:) == playerdata(i).Coord(k);
            temp = sum(temp);
            index = find(temp == 2);
            if ~(isempty(index))
                runsum = runsum+temp;
            end
        end
    end
end
if runsum == 44
    check = 0;
end
end

function [missdata] = missplotter(shot,missdata,row)
missdata(row,:) = shot;
for i = 1:row
    plot(missdata(:,1),missdata(:,2),'ob')
end
end

function [hitdata] = hitplotter(shot,hitdata,row)
hitdata(row,:) = shot;
for i = 1:row
    plot(hitdata(:,1),hitdata(:,2),'xr')
end
end

function [check] = shotchecker(shot,data,hitdata,missdata)
check = 0;
notsamehit = 1;
notsamemiss = 1;
if ~(isempty(hitdata))
    same = (shot == hitdata);
    same = sum(same');
    same = find(same == 2);
    if ~isempty(same)
        notsamehit = 0;
    end
end

if ~(isempty(missdata))
    same = (shot == missdata);
    same = sum(same');
    same = find(same == 2);
    if ~(isempty(same))
        notsamemiss = 0;
    end
end

if notsamehit == 1 && notsamemiss == 1
    for i = 1:6
        temp = shot == data(i).Coord;
        temp = sum(temp');
        index = find(temp==2);
        if isempty(index)
            check = 1;
        else
            check = 0;
            break
        end
    end
else
    disp('You''ve already shot there!')
    check = 3;
end
end

function check = errorcheck(xshot,yshot)
if (xshot>10 | xshot<1 | yshot>10 | yshot<1)...
        & isa(xshot,'double') & isscalar(xshot) & round(xshot) == xshot ...
        & isa(yshot,'double') & isscalar(yshot) & round(yshot) == yshot
    check = 0;
else
    check =1;
end
end

function data = shipplace(data,row)
check = 0;
check2 = 0;
check3 = 0;
fprintf('%s\n',data(row).Shiptype)
switch data(row).Shiptype
    case {'Aircraft Carrier' , 'Battleship'}
        size = 5;
    case 'Cruiser'
        size = 4;
    case {'Destroyer' , 'Submarine'}
        size = 3;
    case 'Patrol Boat'
        size = 2;
end
while check == 0
    temp = input('Where would you like to place this ship?(x) ');
    while isempty(temp)
        disp('Input a number please')
        temp = input('Where would you like to place this ship?(x) ');
    end
    data(row).Coord(1) = temp;
    checkplace = numcheck(data(row).Coord(1));
    while checkplace == 0
        data(row).Coord(1) = input('Where would you like to place this ship?(x) ');
        checkplace = numcheck(data(row).Coord(1));
    end
    
    temp2 = input('Where would you like to place this ship?(y) ');
    while isempty(temp2)
        disp('Input a number please')
        temp2 = input('Where would you like to place this ship?(y) ');
    end
    data(row).Coord(2) = temp2;
    checkplace = numcheck(data(row).Coord(2));
    while checkplace == 0
        data(row).Coord(2) = input('Where would you like to place this ship?(y) ');
        checkplace = numcheck(data(row).Coord(2));
    end
    
    if row ~= 1
        for i = 1:row-1
            check = placementCheck(data(row),data(i));
            if check == 0
                disp('A ship exists there!')
                break
            end
        end
    else
        disp('GOOd');
        check = 1;
    end
end
startx = data(row).Coord(1);
starty = data(row).Coord(2);
while check2 == 0
    while check3 == 0
        data(row).Direction = input('Which direction do you want this ship to face?  ','s');
        [data(row),check3] = AssignCoord(data(row),size,startx,starty);
    end
    coordplace = data(row).Coord;
    if row ~=1
        [check2,check3] = compareship(coordplace,data,size,row);
    else
        check2 = 1;
        data(row) = AssignCoord(data(row),size,startx,starty);
    end
end
end

function check = numcheck(userinput)
if userinput >= 1 & userinput <= 10 & isa(userinput, ...
        'double') & isscalar(userinput) & round(userinput) == userinput
    check = 1;
else
    check = 0;
    disp('Outside of domain, please try again!')
end
end

function plotships(data)
temp = plot(data.Coord(:,1),data.Coord(:,2));
set(temp,'lineWidth',10)
end

function [data,check] = AssignCoord(data,size,startx,starty)
check = 1;
temp = 0;
successful = 0;
switch lower(data.Direction)
    case 'up'
        coordy = [starty:starty+(size-1)];
        coordx = repmat(startx,1,size);
        successful = 1;
    case 'down'
        coordy = [starty-(size-1):starty];
        coordx = repmat(startx,1,size);
        successful = 1;
    case 'left'
        coordx = [startx-(size-1):startx];
        coordy = repmat(starty,1,size);
        successful = 1;
    case 'right'
        coordx = [startx:startx+(size-1)];
        coordy = repmat(starty,1,size);
        successful = 1;
end

if successful == 1
    for i = 1:size
        if coordx(i) >10 | coordx(i) < 1 | coordy(i) > 10 | coordy(i) < 1
            temp = 1;
            break
        end
    end
    if temp == 1
        check = 0;
        disp('Can''t be orientated that way, out of bounds')
    end
    if temp == 0
        data.Coord = [coordx' coordy'];
    end
else
    disp('Invalid Input')
    check = 0;
end
end

function [check,prevcheck] = compareship(coordplace,data,size,row)
loopexit = 1;
check = 1;
prevcheck = 1;
for comparenum = 1:row-1
    counter = length(data(comparenum).Coord);
    for linenum = 1:counter
        coordcompare = data(comparenum).Coord(linenum,:);
        for i = 1:size
            if coordplace(i,:) == coordcompare
                check = 0;
                prevcheck = 0;
                loopexit = 0;
                disp('A ship is in the way! Please choose another orientation!')
                if loopexit == 0
                    break
                end
            end
        end
        if loopexit == 0
            break
        end
    end
    if loopexit == 0
        break
    end
end
end

function [datap1, datap2]=createShips
datap1(6) = struct('Shiptype','Patrol Boat','Coord',[],'Direction',[]); %Preallocate
datap1(1) = struct('Shiptype','Aircraft Carrier','Coord',[],'Direction',[]);
datap1(2) = struct('Shiptype','Battleship','Coord',[],'Direction',[]);
datap1(3) = struct('Shiptype','Cruiser','Coord',[],'Direction',[]);
datap1(4) = struct('Shiptype','Destroyer','Coord',[],'Direction',[]);
datap1(5) = struct('Shiptype','Submarine','Coord',[],'Direction',[]);

datap2(6) = struct('Shiptype','Patrol Boat','Coord',[],'Direction',[]); %Preallocate
datap2(1) = struct('Shiptype','Aircraft Carrier','Coord',[],'Direction',[]);
datap2(2) = struct('Shiptype','Battleship','Coord',[],'Direction',[]);
datap2(3) = struct('Shiptype','Cruiser','Coord',[],'Direction',[]);
datap2(4) = struct('Shiptype','Destroyer','Coord',[],'Direction',[]);
datap2(5) = struct('Shiptype','Submarine','Coord',[],'Direction',[]);
end

function check = placementCheck(placeShip,compareShip)
checker = placeShip.Coord == compareShip.Coord;
checker = sum(checker');
checker = find(checker == 2);
if isempty(checker)
    check = 1;
else
    check = 0;
end
end

function plotgrid
hold on
grid on
xlim([-1 11]) %set x axis
ylim([-1 11])
for i = 0:10
    plot([i+0.5 i+0.5], [-1 11],'k')
    plot([-1 11],[i+0.5 i+0.5],'k')
end
set(gca,'XTick',[1:1:10])
set(gca,'YTick',[1:1:10])
end
