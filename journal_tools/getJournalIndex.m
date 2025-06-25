function index = getJournalIndex(journal,dataFileTag)
index = find(journal.MouseNum==str2double(dataFileTag(2:end)));
