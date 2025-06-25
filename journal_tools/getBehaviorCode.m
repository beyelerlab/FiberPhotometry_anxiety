function behavior_code = getBehaviorCode(journal,dataFileTag)
ii = find(journal.MouseNum==str2double(dataFileTag(2:end)));
behavior_code = journal.BehaviorCode(ii);