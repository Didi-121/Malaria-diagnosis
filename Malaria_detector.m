%Didier Aguilar
%Lenin Garnica
%Albert Constantino
%Mauricio Rodriguez

positive_plate_width = 16; negative_plate_width = 10;
space = 10; 
d_between_plates = 1; charges_quantity = 50;
Q = 1000; individual_charge = Q / charges_quantity; ke = 9e9;

points_in_space = 50;
x = linspace(-space, space, points_in_space);
y = linspace(-space,1, points_in_space);

positive_x_positions = linspace(-positive_plate_width/2, positive_plate_width/2, charges_quantity);
negative_x_positions = linspace(-negative_plate_width/2, negative_plate_width/2, charges_quantity);

create_parabola = @(x,a,c) a .* x.^2 + c;
positive_y_positions = create_parabola(positive_x_positions, -1/7, 0);
negative_y_positions = create_parabola(negative_x_positions, -1/3, -d_between_plates);

figure;
hold on;
plot(positive_x_positions, positive_y_positions, "rs", "LineWidth", 3)
plot(negative_x_positions, negative_y_positions, "bs", "LineWidth", 3)
axis( [x(1) x(end) y(1) y(end)] )
hold off; 

%Potencial
V = zeros(points_in_space, points_in_space); % matriz del potencial
s = 1e-3;  % para evitar división por cero

for i = 1:charges_quantity
    for ix = 1:points_in_space
        for iy = 1:points_in_space
            rx = x(ix);
            ry = y(iy);

            % Potencial de carga positiva
            dxp = rx - positive_x_positions(i);
            dyp = ry - positive_y_positions(i);
            rp = sqrt(dxp^2 + dyp^2) + s;
            V(ix, iy) = V(ix, iy) + ke * individual_charge / rp;

            % Potencial de carga negativa
            dxn = rx - negative_x_positions(i);
            dyn = ry - negative_y_positions(i);
            rn = sqrt(dxn^2 + dyn^2) + s;
            V(ix, iy) = V(ix, iy) - ke * individual_charge / rn;
        end
    end
end
[X, Y] = meshgrid(x, y); % Malla para graficar

figure
pcolor(X, Y, V')  % Mapa de color del potencial
shading interp
colormap jet
colorbar
title('Potencial eléctrico')
xlabel('x')
ylabel('y')
xlim([-space space])
ylim([-space 0])
hold on
plot(positive_x_positions, positive_y_positions, "ks", "LineWidth", 3)
plot(negative_x_positions, negative_y_positions, "ws", "LineWidth", 3)

% equipotenciales y campo
% Reutilizamos V y [X, Y] calculados en la parte de potencial
figure
pcolor(X, Y, V');
shading interp
colormap jet
colorbar
hold on

% Líneas equipotenciales gracias a la función contour (30)
contour(X, Y, V', 20, '-k', 'LineWidth', 0.5);

% Campo eléctrico usando la función "gradient" de matlab (gradiente de V)
[Ex, Ey] = gradient(-V');
streamslice(X, Y, Ex, Ey, 1, 'color', 'g'); % Líneas de flujo verdes

title('Líneas equipotenciales y Campo Eléctrico');
xlabel('x'); ylabel('y');
hold off;

