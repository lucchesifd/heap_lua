--[[ Otro ejemplo de uso del heap. ]]--

local heap = require "heap"

--Crear un nuevo heap, con 10 elementos ya existentes fuera de orden
local prueba = heap:nuevo({-500,300,1000,200,-250,400,750,500,0,-750});

--Meter 100 numeros al azar en el heap
for i = 1,100 do
	prueba:insertar(math.random(1,100));
end

--Escribir valores
print("\nArreglo interno:");
prueba:imprimir();

print("\nSacar todo:");
while not prueba:vacio() do
	io.write(prueba:remover(), " ");
end
io.write("\n");
