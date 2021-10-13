/*
Title: MaxLOD Script
Author: Hyundo Yoo
Email: guseh7@gmail.com
2021.10.12
*/

macroScript LODTool
category:"LOD Macro"
buttontext:"LOD Tool"
toolTip:"LOD Tool"
(
	LB_GETCOUNT= 0x18B
	LB_GETSEL = 0x187
	WM_LBUTTONDOWN = 0x0201
	WM_LBUTTONUP = 0x0202

	-- UI Part
	if LODTool !=undefined do destroyDialog LODTool
	rollout LODTool " LOD Tool" width:146
	(
		group "Group"
		(
			button bt_group_make "Make as Group" width:120 align:#left
			button bt_group_break "Break Group" width:120 align:#left
		)
		
		group "LOD"
		(
			button bt_lod_make "Make as LOD" width:120 align:#left
			button bt_lod_break "Break LOD" width:120 align:#left
		)
			
		on bt_group_make pressed  do
		(
			lod0name = undefined
			tempSelection = getCurrentSelection()
			if tempSelection.count != 0 do
			(
				for i = 1 to tempSelection.count do
			(
				s = tempSelection[i] as string
				if (findString s "UCX") != undefined then
				(
					deselect(tempSelection[i])
				)
				if (findString s "LOD0") != undefined then
				(
					lod0name = tempSelection[i].name
				)
			)
				tempGroup = group selection name: (lod0name)
				select tempGroup
			)
		)
			
		on bt_group_break pressed  do
		(
			tempSelection = getCurrentSelection()		
			for obj = tempSelection do
			(
				if isGroupHead obj then ungroup obj
			)
		)

		on bt_lod_make pressed  do
		(
			max Utility mode
			UtilityPanel.OpenUtility Level_of_Detail
			panel = (windows.getChildHWND #max "Create New Set")
			CreateNewSetButton = (windows.getChildHWND (UIAccessor.GetParentWindow panel[3]) "Create New Set")
			UIAccessor.PressButton CreateNewSetButton[1]
		)
		
		on bt_lod_break pressed do
		(
			hwnd = (windows.getChildrenHWND #max)
			list_box = for c in hwnd where c[4] == "ListBox" do
			(
				exit with c[1]
			)
			count = windows.SendMessage list_box LB_GETCOUNT 0 0
			items = for i=0 to count-1 where (windows.SendMessage 0x001004F6 LB_GETSEL i 0) == 1 collect (i+1)

			max Utility mode
			UtilityPanel.OpenUtility Level_of_Detail
			for i=0 to 10 do
			(
				windows.sendMessage list_box WM_LBUTTONDOWN 1 0  -- Press left mouse button	
				windows.sendMessage list_box WM_LBUTTONUP 1 0  -- Raise left mouse button
				panel = (windows.getChildHWND #max "Remove From Set")
				RemoveFromSetButton = (windows.getChildHWND (UIAccessor.GetParentWindow panel[3]) "Remove From Set")
				UIAccessor.PressButton RemoveFromSetButton[1]
			)
		)
	)
)