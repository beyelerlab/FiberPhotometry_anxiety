function peth_matrix=get_peth(synch_event,timeserie,edges)

Trial_Number=length(synch_event);
Bin_Number=length(edges);
peth_matrix=nan(Trial_Number,Bin_Number-1);

for i = 1 : Trial_Number
    tmp = timeserie-synch_event(i);
    h=histcounts(tmp,edges);
%     [h,~]=histc(tmp,edges);
    peth_matrix(i,:) = h(1:end);
end