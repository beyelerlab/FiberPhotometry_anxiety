function index = getJournalIndex(journal,dataFileTag)

try
    index = find(journal.MouseNum==str2double(dataFileTag(2:end)));
catch exception
    index = strcmp(journal.MouseNum, dataFileTag(2:end));
    index = find(index);
end

