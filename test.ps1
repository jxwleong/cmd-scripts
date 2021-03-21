Enum VirtualKeyCode
{
    ARROW_UP = 38
    ARROW_DOWN = 40
    ENTER = 13   
}


function Invoke-UdfCountdownWithMessage
{
 [CmdletBinding()]
        param (
              [string]$message = "Countdown: ",
              [int]$seconds = 5
            )
    do {
        Write-Host -NoNewline `r"$message$seconds"
        Sleep 1
        $seconds--
    } while ($seconds -gt 0)
}


# https://community.spiceworks.com/scripts/show/4656-powershell-create-menu-easily-add-arrow-key-driven-menu-to-scripts
function Create-Menu (){
    
    Param(
        [Parameter(Mandatory=$True)][String]$MenuTitle,
        [Parameter(Mandatory=$True)][array]$MenuOptions
    )

    $MaxValue = $MenuOptions.count-1
    $Selection = 0
    $EnterPressed = $False
    
    Clear-Host

    While($EnterPressed -eq $False){
        
        Write-Host "$MenuTitle"

        For ($i=0; $i -le $MaxValue; $i++){
            
            If ($i -eq $Selection){
                Write-Host -BackgroundColor Cyan -ForegroundColor Black "[ $($MenuOptions[$i]) ]"
            } Else {
                Write-Host "  $($MenuOptions[$i])  "
            }

        }

        $KeyInput = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown").virtualkeycode

        Switch($KeyInput){
            $([VirtualKeyCode]::ENTER.value__){
                $EnterPressed = $True
                Return $Selection
                Clear-Host
                break
            }

            $([VirtualKeyCode]::ARROW_UP.value__){
                If ($Selection -eq 0){
                    $Selection = $MaxValue
                } Else {
                    $Selection -= 1
                }
                Clear-Host
                break
            }

            $([VirtualKeyCode]::ARROW_DOWN.value__){
                If ($Selection -eq $MaxValue){
                    $Selection = 0
                } Else {
                    $Selection +=1
                }
                Clear-Host
                break
            }
            Default{
                Clear-Host
            }
        }
    }
}

#Invoke-UdfCountdownWithMessage -seconds 1
$MenuSelection = Create-Menu "Bank" "PBE", "OCBC"
if ($MenuSelection -eq 0) 
{
    start https://www.pbebank.com/
    exit
}