FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019

LABEL maintainer="Tino Gruse"
LABEL version="0.1.0"

# Install IISRewrite Module
ADD https://download.microsoft.com/download/1/2/8/128E2E22-C1B9-44A4-BE2A-5859ED1D4592/rewrite_amd64_en-US.msi c:/inetpub/rewrite_amd64_en-US.msi
RUN powershell -Command Start-Process c:/inetpub/rewrite_amd64_en-US.msi -ArgumentList "/qn" -Wait

# Remove Default HTML Page
RUN powershell -NoProfile -Command Remove-Item -Recurse C:\inetpub\wwwroot\*

# Create log directory
RUN mkdir -p C:/data/log

# Copy LogMonitor folder
COPY LogMonitor C:/LogMonitor

# Set workdir
WORKDIR /inetpub/wwwroot

# Start IIS Remote Management and monitor IIS
ENTRYPOINT C:\LogMonitor\LogMonitor.exe C:\ServiceMonitor.exe w3svc
