# Use the official Microsoft ASP.NET Core runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Install Node.js for React build process
RUN apt-get update && \
    apt-get install -y nodejs npm && \
    npm install -g n && \
    n stable && \
    ln -sf /usr/local/bin/node /usr/bin/node && \
    apt-get purge -y nodejs npm

WORKDIR /src
COPY ["RankingAspNetCore_ReactApp/RankingAspNetCore_ReactApp.csproj", "./RankingAspNetCore_ReactApp/"]
RUN dotnet restore "./RankingAspNetCore_ReactApp/RankingAspNetCore_ReactApp.csproj"
COPY . .
WORKDIR "/src/RankingAspNetCore_ReactApp"
RUN dotnet build "RankingAspNetCore_ReactApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "RankingAspNetCore_ReactApp.csproj" -c Release -o /app/publish

# Final stage/image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "RankingAspNetCore_ReactApp.dll"]
