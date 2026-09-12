function supertrend(prezzi, date, titolo, high, low, volume)

%% Supertrend

multiplier=2;
f=14;
n=size(prezzi,1);
for i=1:n
    CH_CL(i)=high(i)-low(i);
end
for i=1:(n-1)
    CH_PC(i)=high(i+1)-prezzi(i);
    CL_PC(i)=low(i+1)-prezzi(i);
    vec(i,:)=[CH_CL(i+1),CH_PC(i),CL_PC(i)];
    TrueRange(i)=max(vec(i,:));
end
for i=1:(n-f)
    ATR(i)=mean(TrueRange(i:i+(f-1)));
    vec_HL(i,:)=[high(i+f),low(i+f)]; % HL = high-low
    mean_vec_HL(i)=mean(vec_HL(i,:));
    UBB(i)=mean_vec_HL(i)+(ATR(i)*multiplier); % UBB=Upper Band Basic
    LBB(i)=mean_vec_HL(i)-(ATR(i)*multiplier); % LBB=Lower Band Basic
end
previous_UB=0;
for i=1:(n-f)
    if UBB(i)<previous_UB
        UB(i)=UBB(i);
    elseif prezzi(i+(f-1))>previous_UB
        UB(i)=UBB(i);
    else
        UB(i)=previous_UB;
    end
    previous_UB=UB(i);
end
previous_LB=0;
for i=1:(n-f)
    if LBB(i)>previous_LB
        LB(i)=LBB(i);
    elseif prezzi(i+(f-1))<previous_LB
        LB(i)=LBB(i);
    else
        LB(i)=previous_LB;
    end
    previous_LB=LB(i);
end
previous_UB=0;
previous_LB=0;
previous_ST=0; % ST=SuperTrend
for i=1:(n-f)
    if previous_ST==previous_UB && prezzi(i+f)<UB(i)
        ST(i)=UB(i);
    elseif previous_ST==previous_UB && prezzi(i+f)>UB(i)
        ST(i)=LB(i);
    elseif previous_ST==previous_LB && prezzi(i+f)>LB(i)
        ST(i)=LB(i);
    elseif previous_ST==previous_LB && prezzi(i+f)<LB(i)
        ST(i)=UB(i);
    end
    previous_UB=UB(i);
    previous_LB=LB(i);
    previous_ST=ST(i);
end
%plotting
% Rappresentazione grafica dell'andamento del titolo (prezzi, in blu), e dell'indicatore SuperTrend (arancione)

hold on
plot(date((f+1):end),prezzi((f+1):end));
plot(date((f+1):end),ST,"LineWidth",1) % ST=SuperTrend
hold off
title("SuperTrend")
legend({titolo,"ST"})
xlim([date(f+1),date(end)])