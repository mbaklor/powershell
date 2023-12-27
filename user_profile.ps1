# Prompt
function prompt
{
    $loc = $executionContext.SessionState.Path.CurrentLocation;

    $out = "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
    if ($loc.Provider.Name -eq "FileSystem")
    {
        $out += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
    }
    return $out
}

# # Bash touch function
# function touch([string]$filetotouch)
# {
#     if(test-path $filetotouch)
#     {
#         Set-ItemProperty -Path $filetotouch -Name LastWriteTime -Value (get-date)
#         # “File $filetotouch timestamp succesfully updated”
#     } else
#     {
#         Set-Content -Path ($filetotouch) -Value ($null);
#         # “File $filetotouch succesfully created”
#     }
# }

Set-PSReadLineKeyHandler -Chord UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord DownArrow -Function HistorySearchForward

Set-PSReadLineKeyHandler -Chord Ctrl+f -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert("ffd")
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}

function conf([Parameter(Mandatory=$true)][string]$config)
{
    if ($config -eq "-?")
    {
        "edit configs of powershell or neovim"
        " "
        "   valid inputs:"
        "   conf [ps | nvim]"
    }
    if ($config -eq "nvim")
    {
        pushd $env:LOCALAPPDATA/nvim;
        nvim .;
        popd;
    }
    if ($config -eq "ps")
    {
        pushd ~/.config/powershell;
        nvim user_profile.ps1;
        popd
        . $PROFILE;
    }
}

function ffd()
{
    fd -d 1 -t d -u . $dev | fzf | cd
}

function hdir([string]$new_dir)
{
    mkdir $new_dir;
    cd $new_dir;
}

# Git pull nvim config
function gitnvim([string]$cmd)
{
    git -C $env:LOCALAPPDATA/nvim $cmd
}

function which([string]$cmd)
{
    (Get-Command $cmd | Format-Table -HideTableHeaders | Out-String).Trim()
}

function wf()
{
    if (Test-Path wails.json && Test-Path frontend)
    {
        cd frontend
        npm run dev
    }
}

# Terminal Icons
Import-Module Terminal-Icons


# Aliases
Set-Alias touch ni
Set-Alias grep findstr
Set-Alias lg lazygit
Set-Alias ex explorer
# del alias:diff -Force
# Set-Alias diff 'C:\Program Files\Git\usr\bin\diff.exe'
