FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
RUN groupadd -r Sravan && useradd -r -g Sravan Sravan

WORKDIR /app

RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_16.x  | bash -
RUN apt-get -y install nodejs

COPY . ./

RUN chown -R Sravan:Sravan /app

USER Sravan

RUN dotnet restore

RUN dotnet build "dotnet6.csproj" -c Release

RUN dotnet publish "dotnet6.csproj" -c Release -o publish


FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base

RUN useradd -ms /bin/bash Sravan
RUN echo 'Sravan:Docker' | chpasswd


ENV ASPNETCORE_URLS http://*:5000

EXPOSE 5000:5000
ENTRYPOINT ["dotnet", "dotnet6.dll"]