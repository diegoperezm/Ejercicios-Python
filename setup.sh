#!/bin/bash

echo "Iniciando configuración del entorno..."

#  Crear entorno virtual si no existe
 if [ ! -d "venv" ]; then
     python -m venv venv
         echo "Entorno virtual creado."
         else
             echo "Usando el entorno virtual existente."
             fi

             # Activar entorno virtual
             source venv/bin/activate

             # Instalar dependencias
             pip install --upgrade pip
             pip install -r requirements.txt

             echo "Dependencias instaladas."

             # Leer datos de pyproject.toml
             PROJECT_NAME=$(python -c "import toml; print(toml.load('pyproject.toml')['tool']['sphinx']['project'])")
             AUTHOR=$(python -c "import toml; print(toml.load('pyproject.toml')['tool']['sphinx']['author'])")
             VERSION=$(python -c "import toml; print(toml.load('pyproject.toml')['tool']['sphinx']['version'])")

             echo "Usando los siguientes datos para la documentación:"
             echo "  - Proyecto: $PROJECT_NAME"
             echo "  - Autor: $AUTHOR"
             echo "  - Versión: $VERSION"


	     #  Generar documentación con Sphinx
	     DOCS_DIR="docs"
	     
	     # Crear estructura de documentación solo si no existe
	      if [ ! -d "$DOCS_DIR" ]; then
	          echo "Creando estructura inicial de documentación..."
	              sphinx-quickstart --quiet --sep -p "$PROJECT_NAME" -a "$AUTHOR" -v "$VERSION" -r "$VERSION" -l es docs
	              else
	                  echo "Estructura de documentación ya existe. Saltando sphinx-quickstart."
	              fi
            #gregar extensiones a conf.py
             if [ -f "docs/source/conf.py" ]; then
	        echo "Modificando docs/source/conf.py para agregar las extensiones necesarias..."
	        sed -i "s/^extensions = \[\]/extensions = ['sphinx.ext.autodoc', 'sphinx.ext.napoleon', 'numpydoc']/" docs/source/conf.py
                sed -i "s/^html_theme = .*/html_theme = 'python_docs_theme'/" docs/source/conf.py
                sed -i "1i\\
import os\\
import sys\\
sys.path.insert(0, os.path.abspath(os.path.join(os.getcwd(), '..', '..', 'src')))" docs/source/conf.py
             else
	       echo " No se encontró docs/source/conf.py. Verifica la estructura de documentación."
             fi

	     # Generar archivos .rst a partir del código fuente
	     if [ -d "src" ]; then
	         echo "Generando documentación a partir de los archivos Python..."
	             sphinx-apidoc -o docs/source src
		     echo "   modules" >> docs/source/index.rst 
                     
	             else
	                 echo " No se encontró el directorio 'src'. Asegúrate de que tu código esté en 'src'."
	                 fi
	    
	                 # Generar la documentación HTML
	                 echo "Generando documentación HTML..."
	                 make -C docs html

	                 echo " Documentación generada en docs/_build/html"

             echo "Setup completado. Usa 'source venv/bin/activate' para activar el entorno."

