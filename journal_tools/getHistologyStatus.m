function status = getHistologyStatus(journal,dataFileTag)
ii = find(journal.MouseNum==str2double(dataFileTag(2:end)));
status = journal.HistologyCode(ii);