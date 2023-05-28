#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["MVC_Quaggajs.csproj", "MVC_Quaggajs/"]
RUN dotnet restore "MVC_Quaggajs/MVC_Quaggajs.csproj"
COPY . .
WORKDIR "/src/MVC_Quaggajs"
RUN dotnet build "MVC_Quaggajs.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MVC_Quaggajs.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MVC_Quaggajs.dll"]