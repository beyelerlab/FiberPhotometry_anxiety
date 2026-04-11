f = "S:\_Lea\1.Data\PhotoM\20251210_aIC_NAc_pIC\20251218_FS\Analysis\input"
order_file = "S:\_Lea\1.Data\PhotoM\20251210_aIC_NAc_pIC\20251218_FS\experiment_schedule.txt"
t = readtable(order_file)
for i=1:size(t,1)
    mouse1 = t.box1(i);
    mouse1 = mouse1{:};
    mouse2 = t.box2(i);
    mouse2 = mouse2{:};
    fprintf("copy\n")
    s = sprintf("%s\\%s-bonsai.txt",f,mouse2);
    fprintf("%s\n", s)
    fprintf("=>\n")
    d = sprintf("%s\\%s-bonsai.txt",f,mouse1);
    fprintf("%s\n", d)
    copyfile(s, d)
end


