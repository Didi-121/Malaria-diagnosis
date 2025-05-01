%Didier Aguilar
%Lenin Garnica
%Albert Constantino
%Mauricio Rodriguez

positive_plate_width = 8; negative_plate_width = 5;
space = 10; 
d_between_plates = 2; charges_quantity = 50;
Q = 1000; individual_charge = Q / charges_quantity; ke = 9e9;

points_in_space = 50;
x = linspace(0, space +1 , points_in_space);
y = linspace(0, space+1, points_in_space);

positive_x_positions = linspace(0, positive_plate_width, charges_quantity);
negative_x_positions = linspace(0, negative_plate_width, charges_quantity);
healty_positions_x = linspace(0,positive_plate_width,charges_quantity);

create_parabola = @(x,a,c) a .* x.^2 + c;
positive_y_positions = create_parabola(positive_x_positions, -1/7,10);
negative_y_positions = create_parabola(negative_x_positions, -1/3, -d_between_plates + 10);
healty_positions_y =  create_parabola(healty_positions_x, -1/5, -d_between_plates/2 + 10);

% %Potencial
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
xlim([x(1) x(end)])
ylim([y(1) y(end)])
hold on
plot(positive_x_positions, positive_y_positions, "ks", "LineWidth", 3)
plot(negative_x_positions, negative_y_positions, "ws", "LineWidth", 3)

%equipotenciales y campo
%Reutilizamos V y [X, Y] calculados en la parte de potencial
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

%-------Blood cells 
figure;
hold on;
plot(positive_x_positions, positive_y_positions, "rs", "LineWidth", 3)
plot(negative_x_positions, negative_y_positions, "bs", "LineWidth", 3)
axis( [x(1) x(end) y(1) y(end)] )
%triangulo separador
fill([6 5.4 (6+5.4)/2], [1.5 1.5 2], 'k')

while true
answer = input("Ingrese 1 para continuar, 0 para salir ");
if answer == 0
    break
end
disp("Que tan enferma quiere ver la celula?")
rad_per = input("del 0 al 100% " + ...
    "...(ingresar numero sin %)");

if rad_per > 49
    rad= 1 *rad_per/100;
    dt=0.2; %time step im Arbitrary units
    qe=1e-6; %erythrocyte charges magnitude
    Q=1e-3; %Charge magnitude per electrode in C
    dq=Q/charges_quantity; %charge differential magnitude
    ymax = negative_y_positions(1) + d_between_plates/2;
    ymin = positive_y_positions(end);
    
    path=animatedline('LineWidth',2,'linestyle',':','Color','r' );
    dx=rad;
    xe=0; ye= ymax;
    vy=-1; vx=1.23;
    while ye>ymin+dx
        addpoints(path,xe,ye);
        head=scatter(xe,ye,100,'filled');
        drawnow
        for k=1:charges_quantity
            rnp=sqrt((xe-dx-positive_x_positions(k))^2+(ye- positive_y_positions (k))^2);
            rnn=sqrt((xe-dx-negative_x_positions(k))^2+(ye-negative_y_positions(k))^2);
            rpp=sqrt((xe-positive_x_positions(k))^2+(ye-positive_y_positions(k))^2);
            rpn=sqrt((xe-negative_x_positions(k))^2+(ye-negative_y_positions(k))^2);
            Fpp=ke*dq*qe/rpp^2;
            Fpn=ke*dq*qe/rpn^2;
            Fnp=ke*dq*qe/rnp^2;
            Fnn=ke*dq*qe/rnn^2;
    
            theta_pp = atan2(ye - positive_y_positions(k), xe - positive_x_positions(k));
            theta_pn = atan2(ye - negative_y_positions(k), xe - negative_x_positions(k));
            theta_np = atan2(ye - positive_y_positions(k), xe - dx - positive_x_positions(k));
            theta_nn = atan2(ye - negative_y_positions(k), xe - dx - negative_x_positions(k));
            Fx = Fpp * cos(theta_pp) + Fpn * cos(theta_pn) + Fnp * cos(theta_np) + Fnn * cos(theta_nn)*100;
        end
        a=Fx/1;
        vx=vx+a*dt;
        xe=xe+vx*dt+0.5*a*dt^2;
        ye=ye+dt*vy;
        if ye > ymin+dx
        delete(head);
        end
    end

else
healthy_path = animatedline('LineWidth', 2, 'LineStyle', ':', 'Color', 'g');
for k = 1:charges_quantity
    addpoints(healthy_path, healty_positions_x(k), healty_positions_y(k));
    head=scatter(healty_positions_x(k),healty_positions_y(k),100,'filled');
    drawnow;
    delete(head); 
end
end
end