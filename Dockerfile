FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY DotNetCoreApp/DotNetCoreApp.csproj DotNetCoreApp/
RUN dotnet restore DotNetCoreApp/DotNetCoreApp.csproj
COPY . .
WORKDIR /src/DotNetCoreApp
RUN dotnet build DotNetCoreApp.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish DotNetCoreApp.csproj -c Release -o /app -r linux-x64

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DotNetCoreApp.dll"]
