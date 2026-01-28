function import_kdenlive_xml(filename)
[filepath,name,ext] = fileparts(filename);
s = xml2struct(filename);
chains =  s.mlt.chain
chain_id = size(chains,2)
if chain_id>1
    chain = chains{1,chain_id}
else
    chain = chains
end
n_properties = size(chain.property,2);
i_marker = 0
for i_property=1:n_properties
    n = chain.property{i_property}.Attributes.name;
    if strcmp(n,'kdenlive:markers')
        i_marker = i_property
    end
end

if i_marker
    txt_tmp = chain.property{i_marker}.Text;
    json_decoded = jsondecode(txt_tmp);
    fod = fopen([filepath filesep name '_events.txt'],'w');
    for i=1:size(json_decoded,1)
        fprintf(fod,"%d\n",json_decoded(i).pos);
    end
    fclose(fod);
else
    fod = fopen([filepath filesep name '_events.txt'],'w');
    fprintf(fod,"no_events\n");
    fclose(fod);
    fprintf('problem with kdenlive file')
end


    
