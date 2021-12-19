
require("LifeBoatAPI.Tools.Builder.LBBuilder")

local luaDocsAddonPath = LBFilepath:new(arg[1]);
local luaDocsMCPath = LBFilepath:new(arg[2]);
local outputDir = LBFilepath:new(arg[3]);
local params = {boilerPlate = arg[4]};
local rootDirs = {};

for i=5, #arg do
    table.insert(rootDirs, LBFilepath:new(arg[i]));
end

local _builder = LBBuilder:new(rootDirs, outputDir, luaDocsMCPath, luaDocsAddonPath)
_builder:buildAddonScript([[Timers2.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Timers2.lua]]), params)
_builder:buildAddonScript([[Timers.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Timers.lua]]), params)
_builder:buildAddonScript([[Main.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Main.lua]]), params)
_builder:buildAddonScript([[Tools\LifeBoatAPI\Tools\Simulator\LBSimulatorInputHelpers.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Tools\LifeBoatAPI\Tools\Simulator\LBSimulatorInputHelpers.lua]]), params)
_builder:buildAddonScript([[Tools\LifeBoatAPI\Tools\Simulator\LBSimulator_InputOutputAPI.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Tools\LifeBoatAPI\Tools\Simulator\LBSimulator_InputOutputAPI.lua]]), params)
_builder:buildAddonScript([[Tools\LifeBoatAPI\Tools\Simulator\LBSimulatorConfig.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Tools\LifeBoatAPI\Tools\Simulator\LBSimulatorConfig.lua]]), params)
_builder:buildAddonScript([[Tools\LifeBoatAPI\Tools\Simulator\LBSimulator_ScreenAPI.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Tools\LifeBoatAPI\Tools\Simulator\LBSimulator_ScreenAPI.lua]]), params)
_builder:buildAddonScript([[Tools\LifeBoatAPI\Tools\Simulator\LBSimulator.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Tools\LifeBoatAPI\Tools\Simulator\LBSimulator.lua]]), params)
_builder:buildAddonScript([[Addons_InDev\Thenable\Thenable.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_InDev\Thenable\Thenable.lua]]), params)
_builder:buildAddonScript([[Addons_InDev\Thenable\LBBase.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_InDev\Thenable\LBBase.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\LifeBoatAPI.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\LifeBoatAPI.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Addon\LBAddon.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Addon\LBAddon.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Addon\LBWorldTiles.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Addon\LBWorldTiles.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Utils\LBTable.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Utils\LBTable.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Utils\LBStringMatch.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Utils\LBStringMatch.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Utils\LBStringBuilder.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Utils\LBStringBuilder.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Utils\LBString.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Utils\LBString.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Entity\LBObject.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Entity\LBObject.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Entity\LBVehicle.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Entity\LBVehicle.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Entity\LBPlayer.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Entity\LBPlayer.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Entity\LBNPC.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Entity\LBNPC.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Math\LBMatrix.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Math\LBMatrix.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Math\LBVec.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Math\LBVec.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Entity\LBFire.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Entity\LBFire.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Entity\LBEntityBase.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Entity\LBEntityBase.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Entity\LBCharacter.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Entity\LBCharacter.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Entity\LBAnimal.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Entity\LBAnimal.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Utils\LBIteratorProtection.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Utils\LBIteratorProtection.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\UI\LBNotification.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\UI\LBNotification.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Utils\LBEvent.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Utils\LBEvent.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Utils\LBBase.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Utils\LBBase.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Collections\LBVehicleManager.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Collections\LBVehicleManager.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Collections\LBPlayerManager.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Collections\LBPlayerManager.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Collections\LBGlobalEventHandler.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Collections\LBGlobalEventHandler.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Admin\LBServer.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Admin\LBServer.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\Admin\LBGameSettings.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\Admin\LBGameSettings.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\UI\Popups\LBWorldPopup.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\UI\Popups\LBWorldPopup.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\UI\Popups\LBScreenPopup.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\UI\Popups\LBScreenPopup.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\UI\MapMarkers\LBMapMarkers.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\UI\MapMarkers\LBMapMarkers.lua]]), params)
_builder:buildAddonScript([[Addons_NotIncluded\LifeBoatAPI\UI\Popups\LBPopupBase.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Addons_NotIncluded\LifeBoatAPI\UI\Popups\LBPopupBase.lua]]), params)
_builder:buildAddonScript([[Microcontroller\LifeBoatAPI\Screen\LBUITree.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Microcontroller\LifeBoatAPI\Screen\LBUITree.lua]]), params)
_builder:buildAddonScript([[Microcontroller\LifeBoatAPI\Maths\LBAngles.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Microcontroller\LifeBoatAPI\Maths\LBAngles.lua]]), params)
_builder:buildAddonScript([[Microcontroller\LifeBoatAPI\Utils\LBTable.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Microcontroller\LifeBoatAPI\Utils\LBTable.lua]]), params)
_builder:buildAddonScript([[Microcontroller\LifeBoatAPI\Utils\LBCopy.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Microcontroller\LifeBoatAPI\Utils\LBCopy.lua]]), params)
_builder:buildAddonScript([[Microcontroller\LifeBoatAPI\Maths\LBVec2.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Microcontroller\LifeBoatAPI\Maths\LBVec2.lua]]), params)
_builder:buildAddonScript([[Microcontroller\LifeBoatAPI\Maths\LBVec3.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Microcontroller\LifeBoatAPI\Maths\LBVec3.lua]]), params)
_builder:buildAddonScript([[Microcontroller\LifeBoatAPI\Instruments\Weapons\LBWeapons.lua]], LBFilepath:new([[c:\personal\STORMWORKS_VSCodeExtension\Extension\assets\LifeBoatAPI\Microcontroller\LifeBoatAPI\Instruments\Weapons\LBWeapons.lua]]), params)