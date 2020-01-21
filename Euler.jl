using CSV, DataFrames

belt80   = CSV.read("C:\\Users\\Guest\\Desktop\\training\\mob_belt\\codes\\Mobile_Belt\\82180.csv")
mobile80 = CSV.read("C:\\Users\\Guest\\Desktop\\training\\mob_belt\\codes\\Mobile_Belt\\82180_mobileAcc.csv")
belt83   = CSV.read("C:\\Users\\Guest\\Desktop\\training\\mob_belt\\codes\\Mobile_Belt\\82183.csv")
mobile83 = CSV.read("C:\\Users\\Guest\\Desktop\\training\\mob_belt\\codes\\Mobile_Belt\\82183_mobileAcc.csv")

x_mob = []
y_mob = []
z_mob = []
x_belt= []
y_belt= []
z_belt= []

x_mob2 = []
y_mob2 = []
z_mob2 = []
x_belt2= []
y_belt2= []
z_belt2= []

for i in  1:1874
    for j in  1:2824
        if (mobile80[1][i]==belt80[1][j])
            amp1 = √((mobile80[2][i]*mobile80[2][i])+(mobile80[3][i]*mobile80[3][i])+(mobile80[4][i]*mobile80[4][i]))
            amp2 = √((belt80[2][j]*belt80[2][j])+(belt80[3][j]*belt80[3][j])+(belt80[4][j]*belt80[4][j]))
            append!(x_mob,mobile80[2][i]/amp1)
            append!(y_mob,mobile80[3][i]/amp1)
            append!(z_mob,mobile80[4][i]/amp1)
            append!(x_belt,belt80[2][i]/amp2)
            append!(y_belt,belt80[3][i]/amp2)
            append!(z_belt,belt80[4][i]/amp2)

        end
    end
end

for i in  1:2074
    for j in  1:2924
        if (mobile83[1][i]==belt83[1][j])
            amp1 = √((mobile83[2][i]*mobile83[2][i])+(mobile83[3][i]*mobile83[3][i])+(mobile83[4][i]*mobile83[4][i]))
            amp2 = √((belt83[2][j]*belt83[2][j])+(belt83[3][j]*belt83[3][j])+(belt83[4][j]*belt83[4][j]))

            append!(x_mob2,mobile83[2][i]/amp1)
            append!(y_mob2,mobile83[3][i]/amp1)
            append!(z_mob2,mobile83[4][i]/amp1)
            append!(x_belt2,belt83[2][i]/amp2)
            append!(y_belt2,belt83[3][i]/amp2)
            append!(z_belt2,belt83[4][i]/amp2)
        end
    end
end


#  Now we have normalized x,y,z & x',y',z' coordinates

# using JuMP, Ipopt
# function solve2(x1,y1,z1,x2,y2,z2)
#     m = Model((with_optimizer(Ipopt.Optimizer)))
#     @variable(m, a1)
#     @variable(m, a2)
#     @variable(m, a3)
#     @NLconstraint(m,(((x1*((cos(a1)*cos(a2)*cos(a3))-(sin(a3)*sin(a1))))+(y1*( (cos(a3)*cos(a2)*sin(a1))+(cos(a1)*sin(a3)) ))+(z1*-1*sin(a2)*cos(a3))) ==x2 ))
#     @NLconstraint(m,((((x1*(-1*sin(a3)*cos(a2)*cos(a1))-(sin(a1)*cos(a3))))+ (y1*((-1*sin(a1)*cos(a2)*sin(a3))+(cos(a3)*cos(a1))))+ (z1*sin(a2)*sin(a3)) )==y2))
#     @NLconstraint(m, ( ((x1*cos(a1)*sin(a2))+(y1*sin(a1)*sin(a2))+(z1*cos(a2))) == z2 ) )
#     solve(m)
#     return a1,a2,a3
# end

using NLsolve
angle1 = []
angle2 = []
angle3 = []
angle21 = []
angle22 = []
angle23 = []

for i in 1:length(x_belt)
    #a,aa,aaa = solve(x_mob[i],y_mob[i],z_mob[i],x_belt[i],y_belt[i],z_belt[i])
    function f!(F, a)
        F[1] = ((x_mob[i]*((cos(a[1])*cos(a[2])*cos(a[3]))-(sin(a[3])*sin(a[1]))))+(y_mob[i]*( (cos(a[3])*cos(a[2])*sin(a[1]))+(cos(a[1])*sin(a[3])) ))+(z_mob[i]*-1*sin(a[2])*cos(a[3]))) -x_belt[i]
        F[2] = (((x_mob[i]*(-1*sin(a[3])*cos(a[2])*cos(a[1]))-(sin(a[1])*cos(a[3]))))+ (y_mob[i]*((-1*sin(a[1])*cos(a[2])*sin(a[3]))+(cos(a[3])*cos(a[1]))))+ (z_mob[i]*sin(a[2])*sin(a[3])) )-y_belt[i]
        F[3] = ((x_mob[i]*cos(a[1])*sin(a[2]))+(y_mob[i]*sin(a[1])*sin(a[2]))+(z_mob[i]*cos(a[2]))) - z_belt[i]

    end
    x = nlsolve(f!, [1.0,1.0,1.0])

    append!(angle1,rad2deg(x.zero[1]))
    #print(x.zero[1],"\n")
    append!(angle2,rad2deg(x.zero[2]))
    #print(x.zero[2],"\n")
    append!(angle3,rad2deg(x.zero[3]))
    #print(x.zero[3],"\n")

end
for i in 1:length(x_belt2)
    function f2!(F2, a2)
        F2[1] = ((x_mob2[i]*((cos(a2[1])*cos(a2[2])*cos(a2[3]))-(sin(a2[3])*sin(a2[1]))))+(y_mob2[i]*( (cos(a2[3])*cos(a2[2])*sin(a2[1]))+(cos(a2[1])*sin(a2[3])) ))+(z_mob2[i]*-1*sin(a2[2])*cos(a2[3]))) -x_belt2[i]
        F2[2] = (((x_mob2[i]*(-1*sin(a2[3])*cos(a2[2])*cos(a2[1]))-(sin(a2[1])*cos(a2[3]))))+ (y_mob2[i]*((-1*sin(a2[1])*cos(a2[2])*sin(a2[3]))+(cos(a2[3])*cos(a2[1]))))+ (z_mob[i]*sin(a2[2])*sin(a2[3])) )-y_belt2[i]
        F2[3] = ((x_mob2[i]*cos(a2[1])*sin(a2[2]))+(y_mob2[i]*sin(a2[1])*sin(a2[2]))+(z_mob2[i]*cos(a2[2]))) - z_belt2[i]
    end
        y = nlsolve(f2!, [1.0,1.0,1.0])
        append!(angle21,rad2deg(y.zero[1]))
        append!(angle22,rad2deg(y.zero[2]))
        append!(angle23,rad2deg(y.zero[3]))
end

angles = hcat(angle1,angle2,angle3)
angles2 =hcat(angle21,angle22,angle23)
compare = hcat(angles[1:71,:],angles2)

mat = [ [ cos(angle1[1])*cos(angle2[1])*cos(angle3[1]) ,     (cos(angle3[1])*cos(angle2[1])*sin(angle1[1]))+(cos(angle1[1])*sin(angle3[1]))     ,-1*sin(angle2[1])*cos(angle3[1])]
,[(-1*sin(angle3[1])*cos(angle2[1])*cos(angle1[1]))-(sin(angle1[1])*cos(angle3[1])) , (-1*sin(angle1[1])*cos(angle2[1])*sin(angle3[1]))+(cos(angle3[1])*cos(angle1[1])) , (sin(angle2[2])*sin(angle3[1])) ]
,[cos(angle1[1])*sin(angle2[1])   ,   sin(angle1[1])*sin(angle2[1])  , cos(angle2[1])] ]
