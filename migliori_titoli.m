function winners = migliori_titoli(Quote_Vincenti)
    winners = zeros(size(Quote_Vincenti));
    for i=1:size(Quote_Vincenti,2)
        for j=1:size(Quote_Vincenti,1)
            [value,index] = max(Quote_Vincenti(:,i));
             winners(j,i) = index;
            Quote_Vincenti(index,i) = NaN;
        end
    end
end