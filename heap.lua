--[[
	heap.lua
	Implementacion simple de un heap binario de maximos en Lua, implementado con una tabla.
	Copyright: Franco Lucchesi (2020)
	Licencia: GNU General Public License v3.0
	
	En un heap de maximos, sus dos hijos deben ser menor o iguales al padre.
	Trabaja enteramente con elementos comparables (solo cadenas o numeros).
	
	
	
	Primitivas:
	*crear:      crea un nuevo hash y lo devuelve, si se le da un arreglo lo arma basado en ese
	
	*cantidad:   devuelve cuantos elementos hay en el heap (0 si esta vacio)
	*esta_vacio: esta vacio el heap? (true si lo esta, false si no)
	
	*insertar:   inserta un elemento en la posicion correcta del heap
	*remover:    remueve primer elemento del heap
	
	*imprimir:   escribe en pantalla como se ve el arreglo interno del heap
	*maximo:     devuelve el elemento mas grande
	
	
	
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

local function upheap(heap, hijo)
	local posPadre = math.floor(hijo/2);
	--Si el padre no existe, abortar.
	if not heap.datos[posPadre] then return; end
	
	--Si el hijo es mayor al padre...
	if heap.datos[hijo] > heap.datos[posPadre] then
		--No es un heap, intercambiar y volver a llamar a upheap.
		heap.datos[hijo], heap.datos[posPadre] = heap.datos[posPadre], heap.datos[hijo];
		upheap(heap, posPadre);
	end
end

local function downheap(heap, padre)
	local hijoUno, hijoDos = 2*padre, 2*padre+1;
	--Si no tiene hijos, abortar.
	if not (heap.datos[hijoUno] or heap.datos[hijoDos]) then return; end
	
	--Buscar el hijo mayor
	local hijoMayor = 0;
	if heap.datos[hijoUno] and heap.datos[hijoDos] then
		--Tiene dos hijos, buscar cual de los dos es mas grande.
		hijoMayor = heap.datos[hijoUno] > heap.datos[hijoDos] and hijoUno or hijoDos;
	else
		--Tiene un hijo, el mayor es el unico hijo presente.
		hijoMayor = heap.datos[hijoUno] and hijoUno or hijoDos;
	end
	
	--Si el hijo es mayor al padre...
	if heap.datos[hijoMayor] > heap.datos[padre] then
		--Intercambiar y volver a llamar a downheap
		heap.datos[hijoMayor], heap.datos[padre] = heap.datos[padre], heap.datos[hijoMayor];
		downheap(heap, hijoMayor);
	end
end

local function heapify(heap)
	--Convierte el arreglo del heap en un heap, aplicando downheap del ultimo al primero.
	for i = #heap.datos, 1, -1 do downheap(heap, i); end
end



----- PRIMITIVAS DEL HEAP -----

function heap:insertar(dato)
	--Agregar elemento al final y aplicar upheap
	table.insert(self.datos, dato);
	upheap(self, #self.datos);  
end

function heap:remover()
	--Conseguir primer elemento.
	local elem = self.datos[1];
	if elem then
		--Intercambiar el primer y ultimo elemento.
		self.datos[1], self.datos[#self.datos] = self.datos[#self.datos], self.datos[1];
		--Remover el ultimo elemento y llamar a downheap en el principio.
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
	 --En un heap de maximos, el mas grande siempre es el primer elemento.
	return self.datos[1];
end

function heap:imprimir()
	print("[" .. table.concat(self.datos, ", ") .. "]");
end

function heap:nuevo(arr)
	--Crea un nuevo heap.
	local nuevoHeap = { datos = {} };
	
	--Si se paso un arreglo...
	if arr then
		--Copiar todos los elementos y aplicar heapify.
		for i = 1,#arr do nuevoHeap.datos[i] = arr[i]; end
		heapify(nuevoHeap);
	end
	
	--Definir que busque sus metodos en heap.
	setmetatable(nuevoHeap, {__index = self});
	return nuevoHeap;
end



return heap;
