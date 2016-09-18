function Hangman(arg1,arg2)
%Hangman
%RJ Wynn

%==========================
persistent h rows cols t 
persistent HEIGHT WIDTH BWIDTH BHEIGHT textHndl textHnd2
persistent word wrongGuess guessLetter tempChar wordShowLetters errorCount correctCount

if nargin < 1,
   arg1 = 'start';
end;

if strcmp(arg1,'start') ;
    %Variables
    load wordList
    rndNumber = randi(216);
    word = wordList{rndNumber};
    wordShowLetters = '';
    wrongGuess = 0;
    guessLetter = '';
    tempChar = 0;
    errorCount = 0;
    correctCount =0;
    rows = 2;             % 16;
    cols = 13;             % 30;
    xoff = 0;
   
    BWIDTH = 50;
    SWIDTH = 0;
    BHEIGHT = 50;
    SHEIGHT = 0;
    WIDTH = BWIDTH + SWIDTH;
    HEIGHT = BHEIGHT + SHEIGHT;
%===========================
    for i = 1:length(word)
        if word(i) > 90
                word(i) = word(i) - 32;
        end 
    end

%===========================

    for i = 1:length(word)
        if i == 1
            
            wordShowLetters = strcat(wordShowLetters,'_');
        else
            wordShowLetters = strcat(wordShowLetters,' _');
        end
    end
   
    f = figure('Visible','off',...
      'Color','white',...
      'Position',[360,500,750,500],...
      'Name','Hangman',...
      'Resize','off',...
      'NumberTitle','off',...
      'WindowButtonDownFcn','Hangman(''windowbuttondownfcn'')',...
      'WindowButtonUpFcn','Hangman(''windowbuttonupfcn'')');
    movegui(f,'center');

   a = axes('Units','pixels',...
      'PlotBoxAspectRatio',[1 1 1],...
      'Position',[WIDTH+xoff,HEIGHT,cols*WIDTH-SWIDTH,rows*HEIGHT-SHEIGHT],...
      'Color','none',...
      'Box','on', ...
      'XLim',[0 cols*WIDTH-SWIDTH],...
      'YLim',[0 rows*HEIGHT-SHEIGHT], ...
      'XColor','k','YColor','k',...
      'YDir','reverse', ...
      'Tag','mainaxes', ...
      'Xtick',[],'Ytick',[]);
   hold on;      % so we can do small images later
   
   textHndl = uicontrol('Style','text',...
      'BackgroundColor',192/255*[1 1 1], ...
      'Units','pixels',...
      'FontSize',24, ...
      'FontWeight','bold', ...
      'Position', [WIDTH (rows+3)*HEIGHT 13*WIDTH WIDTH],...
      'String',wordShowLetters);
  
  textHnd2 = uicontrol('Style','text',...
      'BackgroundColor',192/255*[1 1 1], ...
      'Units','pixels',...
      'FontSize',32, ...
      'FontWeight','bold', ...
      'Position', [WIDTH (rows+2)*HEIGHT 13*WIDTH WIDTH],...
      'String','');
  
   uicontrol( ...
      'Style','pushbutton', ...
      'Position',[10,470,70,30], ...
      'String','New Game', ...
      'Callback',@pushbutton1_Callback);
  
    set(f,'menubar', 'none');
  
    Hangman('picture',0);

    %hbuttonA = uicontrol('Style','pushbutton','String','New Game','Position',[10,470,70,30],'Callback',@Hangman);
 
    h = gobjects(rows,cols);         % button handles
    t = gobjects(rows,cols);         % text handles
   %for m = 1:rows
   %   line('XData',[0,cols*WIDTH],'YData',[m*HEIGHT m*HEIGHT],...
   %      'Color','k','LineWidth',1);
   %end
   %for n = 1:cols
   %   line('XData',[n*WIDTH,n*WIDTH],'YData',[0,rows*HEIGHT],...
   %      'Color','k','LineWidth',1);
   %end
    for m = 1:rows
      for n = 1:cols
         if m == 2
             tempChar = char(64+n);
         else
             tempChar = char(77+n);
         end
          h(m,n) = uicontrol('Style','Pushbutton',...
            'Units','pixels',...
            'String',tempChar,...
            'Position',[n*WIDTH+xoff,m*HEIGHT,BWIDTH,BHEIGHT],...
            'UserData',[m,n]);     % stuff m,n into UserData
      end
    end

    for m = 1:rows
      for n = 1:cols
         set(h(m,n),'Visible','on','Callback','Hangman(''buttondown'')');
         if t(m,n) ~= 0            % delete any text
            delete(t(m,n));
            t(m,n) = gobjects(1) ;
         end
         
      end
    end

    set(a,'Visible','off');
    set(f,'Visible','off');
    axes(findobj(gcf,'Tag','mainaxes'));
    set(gcf, ...
      'Visible','on', ...
      'Color',192/255*[1 1 1]);  % only after all is built
  
elseif strcmp(arg1,'buttondown')

   axes(findobj(gcf,'Tag','mainaxes'));
   userdata = get(gco,'UserData');
   m = userdata(1);
   n = userdata(2);
   if m == 2
          guessLetter = char(64+n);
      else
          guessLetter = char(77+n);
   end
    set(h(m,n),'Visible','off');
      
    if wrongGuess < 6
        for i=1:length(word)
            if guessLetter == word(i)
          
                wordShowLetters((2*i-1)) = word(i);
                set(textHndl,'String',wordShowLetters);
                correctCount = correctCount+1;
            else
                errorCount = errorCount + 1;
                
                
            end
        end
        if correctCount == length(word)
            load handel;
            p = audioplayer(y, Fs);
            play(p, [1 (get(p, 'SampleRate') * 3)]);
            set(textHnd2,'String','YOU WIN!');
        end
        if errorCount == length(word)
            wrongGuess = wrongGuess + 1;
            Hangman('picture',wrongGuess);
            
        end
        errorCount = 0;
    end
    
elseif strcmp(arg1,'picture')
    switch arg2
        case 0
            im=imread('hangman0.jpg');
            plot(randn(1,100))
            axes('position',[0.35,0.7,0.3,0.3])
            imshow(im)
        case 1
            im=imread('hangman1.jpg');
            plot(randn(1,100))
            axes('position',[0.35,0.7,0.3,0.3])
            imshow(im)
        case 2
            im=imread('hangman2.jpg');
            plot(randn(1,100))
            axes('position',[0.35,0.7,0.3,0.3])
            imshow(im)
        case 3
            im=imread('hangman3.jpg');
            plot(randn(1,100))
            axes('position',[0.35,0.7,0.3,0.3])
            imshow(im)
        case 4
            im=imread('hangman4.jpg');
            plot(randn(1,100))
            axes('position',[0.35,0.7,0.3,0.3])
            imshow(im)
        case 5
            im=imread('hangman5.jpg');
            plot(randn(1,100))
            axes('position',[0.35,0.7,0.3,0.3])
            imshow(im)
        case 6
            im=imread('hangman6.jpg');
            plot(randn(1,100))
            axes('position',[0.35,0.7,0.3,0.3])
            imshow(im)
            for i=1:length(word)
                wordShowLetters((2*i-1)) = word(i);
                set(textHndl,'String',wordShowLetters);
            end     
        
            set(textHnd2,'String','YOU LOSE!');
        end    
    end
end   

function pushbutton1_Callback(hObject, eventdata, handles)
    close        
    Hangman
end




 