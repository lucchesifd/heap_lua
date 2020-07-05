--[[
	heap.lua
	Implementacion simple de un heap binario de maximos en Lua, implementado con una tabla.
	Copyright: Franco Lucchesi (2020)
	Licencia: GNU General Public License v3.0
	
	En un heap de maximos, el padre debe ser mayor o igual que los hijos.
	Trabaja enteramente con elementos comparables (solo cadenas o numeros).
	
	
	
	Primitivas:
	*crear:      crea un nuevo heap y lo devuelve, si se le da una tabla lo arma basado en esa.
	
	*cantidad:   devuelve cuantos elementos hay en el heap (0 si esta vacio.)
	*esta_vacio: esta vacio el heap? (true si lo esta, false si no.)
	
	*insertar:   inserta un elemento en la posicion correcta del heap.
	*remover:    remueve el primer elemento del heap y lo devuelve (nil si el heap esta vacio.)
	
	*imprimir:   escribe en pantalla como esta armado el arreglo interno del heap.
	*maximo:     devuelve el elemento mas grande del heap (nil si el heap esta vacio.)
	
	
	
	Ejemplo de uso:
	local heap = require "heap";

	local heapPrueba = heap:nuevo();
	heapPrueba:insertar(7);
	heapPrueba:insertar(2);
	heapPrueba:insertar(10);
	heapPrueba:insertar(5);
	heapPrueba:insertar(1);

	while not heapPrueba:vacio() do
		print(heapPrueba:remover());
	end
]]--

local heap = {};



----- FUNCIONES AUXILIARES -----

local function upheap(heap, posHijo)
	--Calcular la posicion del padre.
	local posPadre = math.floor(posHijo/2);
	--Si el padre no existe, abortar.
	if not heap.datos[posPadre] then return; end
	
	--Si el hijo es mayor al padre...
	if heap.datos[posHijo] > heap.datos[posPadre] then
		--No es un heap, intercambiarlos y volver a llamar a upheap en ese elemento.
		heap.datos[posHijo], heap.datos[posPadre] = heap.datos[posPadre], heap.datos[posHijo];
		upheap(heap, posPadre);
	end
end

local function downheap(heap, posPadre)
	--Calcular la posicion de los dos hijos.
	local posHijoUno, posHijoDos = 2*posPadre, 2*posPadre+1;
	--Si no tiene hijos, abortar.
	if not (heap.datos[posHijoUno] or heap.datos[posHijoDos]) then return; end
	
	--Buscar el hijo con mayor valor.
	local posHijoMayor = 0;
	if heap.datos[posHijoUno] and heap.datos[posHijoDos] then
		--Tiene dos hijos. buscar cual de los dos es mas grande.
		posHijoMayor = heap.datos[posHijoUno] > heap.datos[posHijoDos] and posHijoUno or posHijoDos;
	else
		--Tiene un hijo. el mayor es el unico hijo presente.
		posHijoMayor = heap.datos[posHijoUno] and posHijoUno or posHijoDos;
	end
	
	--Si el hijo es mayor al padre...
	if heap.datos[posHijoMayor] > heap.datos[posPadre] then
		--No es un heap, intercambiarlos y volver a llamar a downheap en ese elemento.
		heap.datos[posHijoMayor], heap.datos[posPadre] = heap.datos[posPadre], heap.datos[posHijoMayor];
		downheap(heap, posHijoMayor);
	end
end

local function heapify(heap)
	--Convierte la tabla del heap en un heap, aplicando downheap del ultimo al primero.
	for i = #heap.datos, 1, -1 do
		downheap(heap, i);
	end
end



----- PRIMITIVAS DEL HEAP -----

function heap:insertar(dato)
	--Agregar elemento al final y aplicar upheap.
	table.insert(self.datos, dato);
	upheap(self, #self.datos);  
end

function heap:remover()
	--Conseguir primer elemento.
	local elem = self.datos[1];
	if elem then
		--Intercambiar el primer y ultimo elemento (colocandolo en la raiz).
		self.datos[1], self.datos[#self.datos] = self.datos[#self.datos], self.datos[1];
		--Eliminar el ultimo elemento y llamar a downheap en la raiz.
		table.remove(self.datos, #self.datos);
		downheap(self, 1);
	end
	return elem;
end

function heap:cantidad()
	return #self.datos;
end

function heap:vacio()
	return #self.datos == 0;
end

function heap:maximo()
	 --En un heap de maximos, el mas grande siempre sera el primer elemento.
	return self.datos[1];
end

function heap:imprimir()
	print("[" .. table.concat(self.datos, ", ") .. "]");
end

function heap:nuevo(arr)
	--Crea un nuevo heap.
	local nuevoHeap = { datos = {} };
	
	--Si se paso una tabla...
	if type(arr) == "table" then
		--Copiar todos los elementos y aplicar heapify.
		for i = 1,#arr do nuevoHeap.datos[i] = arr[i]; end
		heapify(nuevoHeap);
	end
	
	--Definir que busque sus metodos en heap.
	setmetatable(nuevoHeap, {__index = self});
	return nuevoHeap;
end



return heap;
