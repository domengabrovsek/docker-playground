# script to build | tag | deploy docker images

param (
  $Tag = "",
  $Deploy = $false,
  $RegistryUsername = "domengabrovsek",
  $RegistryName = "",
  $UseCache = $true,
  $BuildContext = ".",
  $PushImage = $false
)

function BuildImage {
  param (
    $Tag,
    $BuildContext,
    $UseCache
  )

  # build command
  $Command = "docker build -t $Tag $BuildContext"

  # build without cache if specified
  if($UseCache -eq $false) {
    $Command = "$Command --no-cache"
  }

  Write-Host "1) Building docker image: '$Tag', using cache: $UseCache" -ForegroundColor Cyan;
  if($BuildContext -eq ".") { Write-Host "Build context was not specified, using defaults '.'" -ForegroundColor Red }
  Write-Host "Executing: $Command " -ForegroundColor Yellow;

  # run the command
  Invoke-Expression $Command

  Write-Host "`nDocker image built." -ForegroundColor Cyan;  
}

function TagImage {
  param (
    $Tag,
    $RegistryName,
    $RegistryUsername
  )

  # tag command
  $FullName = "$Tag $RegistryUsername/${RegistryName}:$Tag"
  $Command = "docker tag $FullName"

  Write-Host "`n2) Tagging docker image: $Tag as $FullName" -ForegroundColor Cyan;
  Write-Host "Executing: $Command" -ForegroundColor Yellow;

  # run the command and exit if it fails
  Invoke-Expression $Command

  Write-Host "`nDocker image: $Tag tagged as $FullName." -ForegroundColor Cyan;
}

function PushImage {
  param (
    $Tag,
    $RegistryName,
    $RegistryUsername
  )

  # push command
  $FullName = "$RegistryUsername/${RegistryName}:$Tag"
  $Command = "docker push $FullName"

  Write-Host "`n3) Pushing docker image to registry: $FullName" -ForegroundColor Cyan;
  Write-Host "Executing: $Command"  -ForegroundColor Yellow;

  # run the command and exit if it fails
  Invoke-Expression $Command

  Write-Host "Docker image pushed." -ForegroundColor Cyan;
}

if($Tag -eq "") { Write-Host "Please provide image name." }
elseif($RegistryName -eq "") { Write-Host "Please provide registry name." }
else {

  Write-Host "`n"

  # build the image
  BuildImage -Tag $Tag -BuildContext $BuildContext -UseCache $UseCache

  # tag the image
  TagImage -Tag $Tag -RegistryName $RegistryName -RegistryUsername $RegistryUsername
  
  # deploy the image if specified
  if($PushImage -eq $true) { PushImage -Tag $Tag -RegistryName $RegistryName -RegistryUsername $RegistryUsername }
}
