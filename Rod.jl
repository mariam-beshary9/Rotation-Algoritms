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

ampi1 = []

for i in  1:1874
    for j in  1:2824
        if (mobile80[1][i]==belt80[1][j])
            amp1 = √((mobile80[2][i]*mobile80[2][i])+(mobile80[3][i]*mobile80[3][i])+(mobile80[4][i]*mobile80[4][i]))
            append!(ampi1,amp1)
            amp2 = √((belt80[2][j]*belt80[2][j])+(belt80[3][j]*belt80[3][j])+(belt80[4][j]*belt80[4][j]))

            append!(x_mob,mobile80[2][i])
            append!(y_mob,mobile80[3][i])
            append!(z_mob,mobile80[4][i])
            append!(x_belt,belt80[2][i]*amp1/amp2)
            append!(y_belt,belt80[3][i]*amp1/amp2)
            append!(z_belt,belt80[4][i]*amp1/amp2)

        end
    end
end
ampi21 = []

for i in  1:2074
    for j in  1:2924
        if (mobile83[1][i]==belt83[1][j])
            amp21 = √((mobile83[2][i]*mobile83[2][i])+(mobile83[3][i]*mobile83[3][i])+(mobile83[4][i]*mobile83[4][i]))
            amp22 = √((belt83[2][j]*belt83[2][j])+(belt83[3][j]*belt83[3][j])+(belt83[4][j]*belt83[4][j]))
            append!(ampi21,amp21)

            append!(x_mob2,mobile83[2][i])
            append!(y_mob2,mobile83[3][i])
            append!(z_mob2,mobile83[4][i])
            append!(x_belt2,belt83[2][i]*amp21/amp22)
            append!(y_belt2,belt83[3][i]*amp21/amp22)
            append!(z_belt2,belt83[4][i]*amp21/amp22)
        end
    end
end
v1 = []
v2 = []
v3 = []
using LinearAlgebra
for i in 1:length(x_mob)
    x = hcat(x_mob[i],y_mob[i],z_mob[i])
    y = hcat(x_belt[i],y_belt[i],z_belt[i])
    d =LinearAlgebra.cross(vec(x),vec(y))
    append!(v1,d[1])
    append!(v2,d[2])
    append!(v3,d[3])
end
ampi = []
vect = hcat(v1,v2,v3)
for j in 1:82
    am = √((vect[j,1]*vect[j,1])+(vect[j,2]*vect[j,2])+(vect[j,3]*vect[j,3]))
    vect[j,1] = vect[j,1]/am
    vect[j,2] = vect[j,2]/am
    vect[j,3] = vect[j,3]/am
    append!(ampi,am)

end
vect
θ1 = []
for k in 1:82
    if ampi[k]/(ampi1[k]*ampi1[k])<=1  && ampi[k]/(ampi1[k]*ampi1[k]) >= -1
    append!(θ1,rad2deg(asin(ampi[k]/(ampi1[k]*ampi1[k]))))
    #print(rad2deg(asin(ampi[k]/(ampi1[k]*ampi2[k]))),"\n")
end

end
θ1

v21 = []
v22 = []
v23 = []

for i in 1:length(x_mob2)
    x2 = hcat(x_mob2[i],y_mob2[i],z_mob2[i])
    y2 = hcat(x_belt2[i],y_belt2[i],z_belt2[i])
    d2 =LinearAlgebra.cross(vec(x2),vec(y2))
    append!(v21,d2[1])
    append!(v22,d2[2])
    append!(v23,d2[3])
end
ampii = []
vecto = hcat(v21,v22,v23)
for j in 1:71
    am = √((vecto[j,1]*vecto[j,1])+(vecto[j,2]*vecto[j,2])+(vecto[j,3]*vecto[j,3]))
    vecto[j,1] = vecto[j,1]/am
    vecto[j,2] = vecto[j,2]/am
    vecto[j,3] = vecto[j,3]/am
    append!(ampii,am)

end
vecto
θ2 = []
for k in 1:71
    if ampii[k]/(ampi21[k]*ampi21[k])<=1  && ampii[k]/(ampi21[k]*ampi21[k]) >= -1
    append!(θ2,rad2deg(asin(ampii[k]/(ampi21[k]*ampi21[k]))))
    #print(rad2deg(asin(ampii[k]/(ampi21[k]*ampi21[k]))),"\n")
end

end
θ2
th=hcat(θ1[1:35],θ2[1:35])
#using Plots
#plotly() # Choose the Plotly.jl backend for web interactivity
#plot!(th)
CSV.write("rod.csv",  DataFrame(th), writeheader=false)
