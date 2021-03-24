FROM mcr.microsoft.com/dotnet/core/sdk:3.1.300 AS build
WORKDIR /src
RUN ls .
COPY . .
RUN dotnet publish logappsanywhere.csproj --configuration release --output app
 
FROM mcr.microsoft.com/azure-functions/dotnet:3.0.13614-appservice as runtime
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true \
    FUNCTIONS_V2_COMPATIBILITY_MODE=true
# Set required environment variables, see https://github.com/Azure/logicapps/issues/129
ENV WEBSITE_HOSTNAME localhost 
ENV WEBSITE_SITE_NAME logappsanywhere
ENV AZURE_FUNCTIONS_ENVIRONMENT Development
 
COPY --from=build /src/app/bin /home/site/wwwroot
RUN ls /home/site/wwwroot