FROM mrc.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS BUILD
WORKDIR /src
COPY ["PizzariaWebApi/PizzariaWebApi.csproj", "PizzariaWebApi/"]
RUN dotnet restore "PizzariaWebApi/PizzariaWebApi.csproj"
COPY . .
WORKDIR "/src/PizzariaWebApi"
RUN dotnet build "PizzariaWebApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PizzariaWebApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT [ "dotnet", "PizzariaWebApi.dll" ]