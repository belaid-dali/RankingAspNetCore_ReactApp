#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["RankingAspNetCore_ReactApp/RankingAspNetCore_ReactApp.csproj", "RankingAspNetCore_ReactApp/"]
RUN dotnet restore "RankingAspNetCore_ReactApp/RankingAspNetCore_ReactApp.csproj"
COPY . .
WORKDIR "/src/RankingAspNetCore_ReactApp"
RUN dotnet build "RankingAspNetCore_ReactApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "RankingAspNetCore_ReactApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RankingAspNetCore_ReactApp.dll"]
