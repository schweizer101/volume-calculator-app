# 1. Build Stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy the specific project file and restore dependencies
COPY ["VolumeCalculatorApp.csproj", "./"]
RUN dotnet restore "VolumeCalculatorApp.csproj"

# Copy the rest of the files and build the app
COPY . .
RUN dotnet build "VolumeCalculatorApp.csproj" -c Release -o /app/build

# 2. Publish Stage
FROM build AS publish
RUN dotnet publish "VolumeCalculatorApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

# 3. Runtime Stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=publish /app/publish .

# Set environment variables and expose the port
ENV ASPNETCORE_URLS=http://+:${PORT:-8080}
EXPOSE 8080

# Execute the DLL created by the build process
ENTRYPOINT ["dotnet", "VolumeCalculatorApp.dll"]