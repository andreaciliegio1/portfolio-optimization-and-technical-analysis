function mfi(prezzi, date, titolo, high, low, volume)

%% MFI

f=14;
n=size(prezzi,1);
for i=1:n
    vec(i,:)=[high(i),low(i),prezzi(i)];
    prezzo_medio(i)=mean(vec(i,:));
    Money_flow(i)=prezzo_medio(i)*volume(i);
end
for i=1:(n-1)
    if prezzo_medio(i+1)>prezzo_medio(i)
        up_down(i)=1;
    else 
        up_down(i)=0;
    end
end
for i=1:(n-f)
    for j=i:i+(f-1)
        if up_down(j)==1
            vec_pos(j)=Money_flow(j+1);
            vec_neg(j)=0;
        elseif up_down(j)==0
            vec_neg(j)=Money_flow(j+1);
            vec_pos(j)=0;
        end
    end
    somme_positivi(i)=sum(vec_pos(i:i+(f-1))); somme_negativi(i)=sum(vec_neg(i:i+(f-1)));
    MFR(i)=somme_positivi(i)/somme_negativi(i);
    MFI(i)=100-(100/(1+MFR(i)));
end
%plotting
% Rappresentazione grafica dell'andamento del titolo (prezzi, in blu) e dell'indicatore MFI (arancione)

hold on
plot(date((f+1):end),prezzi((f+1):end), "LineWidth",1.5);
plot(date((f+1):end),MFI,"LineWidth",1.5)
hold off
title("MFI")
legend({titolo,"MFI"})
xlim([date(f+1),date(end)])