function ticker(s1, s2)
n1 = str2num(s1);
n2 = str2num(s2);
for i=n1:n2
    pause(1);
    fprintf("%d\n", i);
end