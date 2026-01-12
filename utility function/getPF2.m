function data=getPF2(index)
switch(index)
    case 1
        data=load('./PF/circle.pf');
    case 2
        data=load('./PF/concave.pf');
    case 3
        data=load('./PF/concave.pf');
    case 4
        data=load('./PF/circle.pf');
    case 5
        data=load('./PF/convex.pf');
    case 6
        data=load('./PF/circle.pf');
end
end