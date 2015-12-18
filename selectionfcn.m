function selection = selectionfcn(expectation,threshold)
    selection = find(expectation >= threshold);
    if ~isempty(selection)
        selection = selection(randi(length(selection)));     
    else
        selection = 1;
    end
end
