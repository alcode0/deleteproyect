#!/bin/bash

dotnet new sln -n MiSolucion
dotnet new webapi -n MiProyectoAPI
dotnet new classlib -n MiProyectoBiblioteca
dotnet sln MiSolucion.sln add MiProyectoAPI/MiProyectoAPI.csproj
dotnet sln MiSolucion.sln add MiProyectoBiblioteca/MiProyectoBiblioteca.csproj
dotnet add MiProyectoAPI reference MiProyectoBiblioteca
