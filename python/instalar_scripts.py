import sys
import zipfile
import os
import subprocess

import importlib

from pathlib import Path

def Instalar(ruta):
	if ruta == None:		
		ruta = str(Path.home())
	print (ruta)
	if os.path.isdir(ruta + '/.sdmed'):
		print ("Existe el directorio "+ ruta + './sdmed')
		print("La instalación sobreescribirá los archivos existentes. ¿Continuar?")
		print ("(S/N)")
		respuesta = input()
		if respuesta == 'S' or respuesta == 's':
			Descomprimir(ruta)	
	else:
		Descomprimir(ruta)
		
	print ("¿Buscar e instalar dependencias?")
	print ("(S/N)")		
	respuesta = input()
	if respuesta == 'S' or respuesta == 's':
		InstalarDependencias(ruta)
	print ("Terminado. Pulsa una tecla para cerrar...")
	input()		
			
def InstalarDependencias(ruta):
	#buscar e instalar pipreqs si no lo esta
	pipreqs = "pipreqs"	
	if not DependenciaInstalada(pipreqs):
		print ("Se necesita intalar pipreqs. ¿Continuar?")
		print ("(S/N)")
		respuesta = input()
		if respuesta == 'S' or respuesta == 's':
			subprocess.check_call([sys.executable, "-m", "pip", "install", pipreqs])
	#instalar las dependencias
	ruta_scripts = ruta + "/.sdmed/python_plugins/"
	print ("ruta scripts " + ruta_scripts)
	ejecutar = "pipreqs --force --encoding=utf8 " + ruta_scripts
	print (ejecutar)
	subprocess.Popen(ejecutar, shell=True)
	with open(ruta_scripts + 'requirements.txt') as f:
		dependencias = f.readlines()
		print("Se instalarán las siguientes dependencias")
		if len(dependencias)>0:
			for dependencia in dependencias:
				if not DependenciaInstalada(dependencia.split("==")[0]):
					print(dependencia)
					subprocess.check_call([sys.executable, "-m", "pip", "install", dependencia])
		else:
			print ("Todas las dependencias estan satisfechas")
					
def DependenciaInstalada(dependencia):
	instalado = importlib.util.find_spec(dependencia)
	return instalado is not None
	
def Descomprimir(ruta ,nombrearchivo=None):
	if nombrearchivo == None:
		nombrearchivo = "sdmed.zip"
	archivozip = nombrearchivo
	if not nombrearchivo.endswith ('.zip'):
		archivozip += '.zip'
	print ("extraer " +archivozip +' en: '+ ruta)
	zipobj = zipfile.ZipFile(archivozip, 'r')
	zipobj.extractall(ruta)
	
if __name__ == "__main__":
	ruta = None
	if len(sys.argv)>1:
		ruta = sys.argv[1]
	Instalar(ruta)
