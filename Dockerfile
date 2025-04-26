# Etapa de construcción
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
# Instalar clang y zlib1g-dev para soporte nativo si es necesario
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    clang zlib1g-dev
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["ChatApi/ChatApi.csproj", "ChatApi/"]
RUN dotnet restore "./ChatApi/ChatApi.csproj"
COPY . .
WORKDIR "/src/ChatApi"
RUN dotnet build "./ChatApi.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Etapa de publicación
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./ChatApi.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=true

# Etapa final: imagen más ligera para producción
FROM mcr.microsoft.com/dotnet/runtime-deps:9.0 AS final
WORKDIR /app
EXPOSE 8080
COPY --from=publish /app/publish .
ENTRYPOINT ["./ChatApi"]
