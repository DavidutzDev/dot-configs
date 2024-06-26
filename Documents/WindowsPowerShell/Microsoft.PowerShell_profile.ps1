# $ENV:STARSHIP_CONFIG = "$HOME\.starship\starship.toml"
# $ENV:STARSHIP_DISTRO = ""
# Invoke-Expression (&starship init powershell)
$POSH_CONFIG = "$HOME\.oh-my-posh\material.toml"
oh-my-posh init pwsh --config $POSH_CONFIG | Invoke-Expression

# Import the Chocolatey Profile that contains the necessary coe to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for etails.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# Import PowerShell ReadLine module 
Import-Module PSReadLine
Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Setup Zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Import Nvims script for mulitple profiles on nvim
function nvim_lazy()
{
  $env:NVIM_APPNAME="nvim-lazy"
  nvim $args
}

function nvims()
{
  $items = "default"
  $config = $items | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0

  if ([string]::IsNullOrEmpty($config))
  {
    Write-Output "Nothing selected"
    break
  }
 
  if ($config -eq "default")
  {
    $config = ""
  }

  $env:NVIM_APPNAME=$config
  nvim $args
}

# Custom Command Aliases
function Remove-Dir([string]$path) { Remove-Item -Recurse -Force $path}
Set-Alias -Name rmd -Value Remove-Dir
function Copy-Dir([string]$path) { Copy-Dir -Recurse -Path $path }
Set-Alias -Name cpd -Value Copy-Dir
Set-Alias -Name pwsh -Value powershell.exe
function SetLocDev { Set-Location -Path "G:\NextCloud Sync\Dev\" }
Set-Alias -Name cdd -Value SetLocDev
function LsCol([string]$path) { eza -lh $path }
Set-Alias -Name l -Value LsCol
Set-Alias -Name cl -Value clear
function Neovim([string]$path) { nvim $path }
Set-Alias -Name n -Value Neovim

# Clear screen to prevent issue with starship (-nologo)
clear
