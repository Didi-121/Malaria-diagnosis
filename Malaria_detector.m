%Didier Aguilar

%Plate length is recomended to be divisible by 4 
positive_plate_length = 24; negative_plate_length=12;
positive_plate_width= positive_plate_length / 8 ; 
negative_plate_width=   negative_plate_length / 8;
space = 30;
d_between_plates = 1;

charges_quantity=20; %more than 4 and divisible by 4
total_charge=1000; individual_charge = Q/charges_quantity; ke= 9e9; 

points_in_space=50;
x = linspace(-space,space,n);
y = linspace(-space,space,n);

%variables use to create a vector with the x positions
charges_quantity = charges_quantity / 4;
a = linspace(-d_between_plates/2 , - positive_plate_width, charges_quantity);
b = linspace(-positive_plate_width, -d_between_plates/2, charges_quantity);
c = linspace(d_between_plates/2, negative_plate_width, charges_quantity);
d = linspace(negative_plate_width, d_between_plates/2, charges_quantity);
positive_x_positions = [a,b,a,b]; 
negative_x_positions = [c,d,c,d];  
charges_quantity = charges_quantity *4;

positive_y_positions= linspace(-positive_plate_length/2, ...
    positive_plate_length/2, charges_quantity);
negative_y_positions= linspace(-negative_plate_length/2, ...
    negative_plate_length/2,charges_quantity);

disp(length(negative_x_positions))
disp(negative_x_positions)

hold on 
grid on
for i=1:charges_quantity
    plot(positive_x_positions(i),positive_y_positions(i), "rs", "LineWidth",3)
    plot(negative_x_positions(i),negative_y_positions(i), "bs", "LineWidth",3)
end