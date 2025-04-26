# Etapa de construcción
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copiar el archivo .csproj y restaurar las dependencias
COPY ["ChatApi.csproj", "./"]
RUN dotnet restore

# Copiar el resto del código
COPY . .
RUN dotnet build "ChatApi.csproj" -c Release -o /app/build
RUN dotnet publish "ChatApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Etapa final (Imagen con el runtime)
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "ChatApi.dll"]
