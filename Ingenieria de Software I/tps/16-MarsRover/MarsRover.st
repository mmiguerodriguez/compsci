!classDefinition: #MarsRoverTest category: 'MarsRover'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverTest methodsFor: 'assertions' stamp: 'RI 10/6/2021 15:56:37'!
assertRoverInPosition: aPosition andDirection: aDirection afterReceiving: aMessage shouldBeAt: anExpectedPosition facing: anExpectedDirection

	| rover |
	
	rover := MarsRover at: aPosition facing: aDirection.
	
	rover process: aMessage.
	
	self assert: true equals: (rover isAt: anExpectedPosition facing: anExpectedDirection).! !


!MarsRoverTest methodsFor: 'movement' stamp: 'RI 10/6/2021 15:57:45'!
test02RoverMovesForwardFacingNorth

	self assertRoverInPosition: 1@2 andDirection: North afterReceiving: 'f' shouldBeAt: 1@3 facing: North.! !

!MarsRoverTest methodsFor: 'movement' stamp: 'RI 10/6/2021 15:58:02'!
test03RoverMovesBackwardsFacingNorth

	self assertRoverInPosition: 1@2 andDirection: North afterReceiving: 'b' shouldBeAt: 1@1 facing: North.! !

!MarsRoverTest methodsFor: 'movement' stamp: 'RI 10/6/2021 15:59:25'!
test06RoverMovesForwardFacingWest

	self assertRoverInPosition: 1@2 andDirection: West afterReceiving: 'f' shouldBeAt: 0@2 facing: West.! !

!MarsRoverTest methodsFor: 'movement' stamp: 'RI 10/6/2021 15:59:48'!
test07RoverMovesBackwardsFacingWest

	self assertRoverInPosition: 1@2 andDirection: West afterReceiving: 'b' shouldBeAt: 2@2 facing: West.! !

!MarsRoverTest methodsFor: 'movement' stamp: 'RI 10/6/2021 16:02:11'!
test13RoverMovesForwardFacingSouth
	
	self assertRoverInPosition: 1@2 andDirection: South afterReceiving: 'f' shouldBeAt: 1@1 facing: South.! !

!MarsRoverTest methodsFor: 'movement' stamp: 'RI 10/6/2021 16:02:48'!
test14RoverMovesForwardFacingEast
	
	self assertRoverInPosition: 1@2 andDirection: East afterReceiving: 'f' shouldBeAt: 2@2 facing: East.! !

!MarsRoverTest methodsFor: 'movement' stamp: 'RI 10/6/2021 16:03:05'!
test15RoverMovesBackwardsFacingEast

	self assertRoverInPosition: 1@2 andDirection: East afterReceiving: 'b' shouldBeAt: 0@2 facing: East.! !

!MarsRoverTest methodsFor: 'movement' stamp: 'RI 10/6/2021 16:03:30'!
test16RoverMovesBackwardsFacingSouth

	self assertRoverInPosition: 1@2 andDirection: South afterReceiving: 'b' shouldBeAt: 1@3 facing: South.! !


!MarsRoverTest methodsFor: 'rotation' stamp: 'RI 10/6/2021 15:58:23'!
test04RoverRotatesRightFacingNorthShouldFaceEast

	self assertRoverInPosition: 1@2 andDirection: North afterReceiving: 'r' shouldBeAt: 1@2 facing: East.! !

!MarsRoverTest methodsFor: 'rotation' stamp: 'RI 10/6/2021 15:58:51'!
test05RoverRotatesLeftFacingNorthShouldFaceWest

	self assertRoverInPosition: 1@2 andDirection: North afterReceiving: 'l' shouldBeAt: 1@2 facing: West.! !

!MarsRoverTest methodsFor: 'rotation' stamp: 'RI 10/6/2021 16:00:11'!
test08RoverRotatesLeftFacingWestShouldFaceSouth

	self assertRoverInPosition: 1@2 andDirection: West afterReceiving: 'l' shouldBeAt: 1@2 facing: South.! !

!MarsRoverTest methodsFor: 'rotation' stamp: 'RI 10/6/2021 16:00:37'!
test09RoverRotatesRightFacingWestShouldFaceNorth

	self assertRoverInPosition: 1@2 andDirection: West afterReceiving: 'r' shouldBeAt: 1@2 facing: North.! !

!MarsRoverTest methodsFor: 'rotation' stamp: 'RI 10/6/2021 16:03:48'!
test17RoverRotatesRightFacingEastShouldFaceSouth

	self assertRoverInPosition: 1@2 andDirection: East afterReceiving: 'r' shouldBeAt: 1@2 facing: South.! !

!MarsRoverTest methodsFor: 'rotation' stamp: 'RI 10/6/2021 16:04:04'!
test18RoverRotatesLeftFacingEastShouldFaceNorth
	
	self assertRoverInPosition: 1@2 andDirection: East afterReceiving: 'l' shouldBeAt: 1@2 facing: North.! !

!MarsRoverTest methodsFor: 'rotation' stamp: 'RI 10/6/2021 16:04:29'!
test19RoverRotatesRightFacingSouthShouldFaceWest

	self assertRoverInPosition: 1@2 andDirection: South afterReceiving: 'r' shouldBeAt: 1@2 facing: West.! !

!MarsRoverTest methodsFor: 'rotation' stamp: 'RI 10/6/2021 16:04:46'!
test20RoverRotatesLeftFacingSouthShouldFaceEast
	
	self assertRoverInPosition: 1@2 andDirection: South afterReceiving: 'l' shouldBeAt: 1@2 facing: East.! !


!MarsRoverTest methodsFor: 'other commands' stamp: 'RI 10/6/2021 15:57:20'!
test01RoverStaysInTheSamePlaceWithoutCommands

	self assertRoverInPosition: 1@2 andDirection: North afterReceiving: '' shouldBeAt: 1@2 facing: North.! !

!MarsRoverTest methodsFor: 'other commands' stamp: 'MR 10/7/2021 14:32:46'!
test10RoverReceivingOnlyInvalidCommandShouldDoNothing

	self assertRoverInPosition: 1@2 andDirection: North afterReceiving: 'x' shouldBeAt: 1@2 facing: North.! !

!MarsRoverTest methodsFor: 'other commands' stamp: 'RI 10/6/2021 16:01:23'!
test11RoverReceivingValidCommandsShouldExecuteAll

	self assertRoverInPosition: 1@2 andDirection: North afterReceiving: 'ff' shouldBeAt: 1@4 facing: North.! !

!MarsRoverTest methodsFor: 'other commands' stamp: 'RI 10/6/2021 16:01:42'!
test12RoverReceivingInvalidCommandShouldEndExecution

	self assertRoverInPosition: 1@2 andDirection: North afterReceiving: 'fxf' shouldBeAt: 1@3 facing: North.! !


!classDefinition: #MarsRover category: 'MarsRover'!
Object subclass: #MarsRover
	instanceVariableNames: 'position direction'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRover methodsFor: 'initialization' stamp: 'RI 10/5/2021 15:38:37'!
initializeAt: aPosition facing: aDirection

	position := aPosition.
	direction := aDirection new.! !


!MarsRover methodsFor: 'processing' stamp: 'RI 10/6/2021 15:30:31'!
getCommandsFromMessage: aMessage

	| aSequenceOfCommands |	
	
	aSequenceOfCommands := OrderedCollection new.
	
	aMessage do: [:aCharacter | | command |	
		command := MarsRoverCommand initializeFor: aCharacter.
		
		command isValid ifFalse: [^aSequenceOfCommands].
		aSequenceOfCommands add: command.
	].

	^aSequenceOfCommands.! !

!MarsRover methodsFor: 'processing' stamp: 'MR 10/7/2021 14:36:24'!
process: aMessage

	| aSequenceOfCommands |

	aSequenceOfCommands := self getCommandsFromMessage: aMessage.
	self processCommands: aSequenceOfCommands.! !

!MarsRover methodsFor: 'processing' stamp: 'RI 10/5/2021 16:06:12'!
processCommands: aSequenceOfCommands
	
	aSequenceOfCommands do: [:aCommand |
		aCommand execute: self.
	].! !


!MarsRover methodsFor: 'comparing' stamp: 'RI 10/5/2021 15:39:32'!
isAt: aPosition facing: aDirection

	^(position = aPosition) and: [direction class = aDirection].! !


!MarsRover methodsFor: 'movement primitives' stamp: 'RI 10/6/2021 15:24:13'!
faceEast
	
	direction := East new.! !

!MarsRover methodsFor: 'movement primitives' stamp: 'RI 10/6/2021 15:24:56'!
faceNorth
	
	direction := North new.! !

!MarsRover methodsFor: 'movement primitives' stamp: 'RI 10/6/2021 15:25:06'!
faceSouth
	
	direction := South new.! !

!MarsRover methodsFor: 'movement primitives' stamp: 'RI 10/6/2021 15:25:13'!
faceWest
	
	direction := West new.! !

!MarsRover methodsFor: 'movement primitives' stamp: 'RI 10/6/2021 14:29:05'!
moveEast
	
	position := position + (1@0).! !

!MarsRover methodsFor: 'movement primitives' stamp: 'RI 10/6/2021 14:28:55'!
moveNorth
	
	position := position + (0@1).! !

!MarsRover methodsFor: 'movement primitives' stamp: 'RI 10/6/2021 14:29:14'!
moveSouth
	
	position := position - (0@1).! !

!MarsRover methodsFor: 'movement primitives' stamp: 'RI 10/6/2021 14:29:22'!
moveWest
	
	position := position - (1@0).! !


!MarsRover methodsFor: 'movement' stamp: 'RI 10/5/2021 15:34:47'!
moveBackwards
	
	direction moveBackwards: self.! !

!MarsRover methodsFor: 'movement' stamp: 'RI 10/5/2021 15:34:43'!
moveForward
	
	direction moveForward: self.! !

!MarsRover methodsFor: 'movement' stamp: 'RI 10/5/2021 15:35:15'!
rotateLeft
	
	direction rotateLeft: self.! !

!MarsRover methodsFor: 'movement' stamp: 'RI 10/5/2021 15:35:24'!
rotateRight
	
	direction rotateRight: self.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'initialization' stamp: 'RI 10/4/2021 21:38:25'!
at: aPosition facing: aDirection 
	
	^MarsRover new initializeAt: aPosition facing: aDirection.! !


!classDefinition: #MarsRoverCommand category: 'MarsRover'!
Object subclass: #MarsRoverCommand
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverCommand methodsFor: 'execution' stamp: 'RI 10/5/2021 14:30:25'!
execute: aRover
	
	self subclassResponsibility.! !


!MarsRoverCommand methodsFor: 'validation' stamp: 'RI 10/5/2021 15:04:01'!
isValid
	
	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverCommand class' category: 'MarsRover'!
MarsRoverCommand class
	instanceVariableNames: ''!

!MarsRoverCommand class methodsFor: 'comparing' stamp: 'RI 10/6/2021 15:13:31'!
isFor: aCommand

	self subclassResponsibility.! !


!MarsRoverCommand class methodsFor: 'initialization' stamp: 'RI 10/6/2021 15:12:46'!
initializeFor: aCommand
	
	^(self subclasses detect: [:subclass | subclass isFor: aCommand] ifNone: [Invalid]) new.! !


!classDefinition: #Invalid category: 'MarsRover'!
MarsRoverCommand subclass: #Invalid
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!Invalid methodsFor: 'validation' stamp: 'RI 10/5/2021 15:44:31'!
isValid

	^false.! !


!Invalid methodsFor: 'execution' stamp: 'RI 10/5/2021 15:03:01'!
execute: aRover! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Invalid class' category: 'MarsRover'!
Invalid class
	instanceVariableNames: ''!

!Invalid class methodsFor: 'comparing' stamp: 'RI 10/6/2021 15:16:24'!
isFor: aCommand

	^false! !


!classDefinition: #MoveBackwards category: 'MarsRover'!
MarsRoverCommand subclass: #MoveBackwards
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MoveBackwards methodsFor: 'validation' stamp: 'RI 10/5/2021 15:45:08'!
isValid

	^true! !


!MoveBackwards methodsFor: 'execution' stamp: 'RI 10/5/2021 15:37:34'!
execute: aRover

	aRover moveBackwards.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MoveBackwards class' category: 'MarsRover'!
MoveBackwards class
	instanceVariableNames: ''!

!MoveBackwards class methodsFor: 'comparing' stamp: 'RI 10/6/2021 15:15:53'!
isFor: aCommand

	^aCommand = $b! !


!classDefinition: #MoveForward category: 'MarsRover'!
MarsRoverCommand subclass: #MoveForward
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MoveForward methodsFor: 'validation' stamp: 'RI 10/5/2021 15:44:51'!
isValid

	^true! !


!MoveForward methodsFor: 'execution' stamp: 'RI 10/5/2021 14:31:27'!
execute: aRover

	aRover moveForward.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MoveForward class' category: 'MarsRover'!
MoveForward class
	instanceVariableNames: ''!

!MoveForward class methodsFor: 'comparing' stamp: 'RI 10/6/2021 15:16:14'!
isFor: aCommand

	^aCommand = $f! !


!classDefinition: #RotateLeft category: 'MarsRover'!
MarsRoverCommand subclass: #RotateLeft
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!RotateLeft methodsFor: 'validation' stamp: 'RI 10/5/2021 15:44:46'!
isValid

	^true! !


!RotateLeft methodsFor: 'execution' stamp: 'RI 10/5/2021 14:31:37'!
execute: aRover

	aRover rotateLeft.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RotateLeft class' category: 'MarsRover'!
RotateLeft class
	instanceVariableNames: ''!

!RotateLeft class methodsFor: 'comparing' stamp: 'RI 10/6/2021 15:16:36'!
isFor: aCommand

	^aCommand = $l! !


!classDefinition: #RotateRight category: 'MarsRover'!
MarsRoverCommand subclass: #RotateRight
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!RotateRight methodsFor: 'validation' stamp: 'RI 10/5/2021 15:44:41'!
isValid

	^true! !


!RotateRight methodsFor: 'execution' stamp: 'RI 10/5/2021 14:31:45'!
execute: aRover

	aRover rotateRight.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RotateRight class' category: 'MarsRover'!
RotateRight class
	instanceVariableNames: ''!

!RotateRight class methodsFor: 'comparing' stamp: 'RI 10/6/2021 15:16:42'!
isFor: aCommand

	^aCommand = $r! !


!classDefinition: #MarsRoverDirection category: 'MarsRover'!
Object subclass: #MarsRoverDirection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!MarsRoverDirection methodsFor: 'movement' stamp: 'RI 10/5/2021 15:18:41'!
moveBackwards: aRover

	self subclassResponsibility.! !

!MarsRoverDirection methodsFor: 'movement' stamp: 'RI 10/5/2021 15:18:35'!
moveForward: aRover

	self subclassResponsibility.! !


!MarsRoverDirection methodsFor: 'rotation' stamp: 'RI 10/5/2021 15:18:47'!
rotateLeft: aRover

	self subclassResponsibility.! !

!MarsRoverDirection methodsFor: 'rotation' stamp: 'RI 10/5/2021 15:18:50'!
rotateRight: aRover

	self subclassResponsibility.! !


!classDefinition: #East category: 'MarsRover'!
MarsRoverDirection subclass: #East
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!East methodsFor: 'rotation' stamp: 'RI 10/6/2021 14:27:17'!
rotateLeft: aRover

	aRover faceNorth.! !

!East methodsFor: 'rotation' stamp: 'RI 10/6/2021 14:27:23'!
rotateRight: aRover

	aRover faceSouth.! !


!East methodsFor: 'movement' stamp: 'RI 10/6/2021 14:30:25'!
moveBackwards: aRover

	aRover moveWest.! !

!East methodsFor: 'movement' stamp: 'RI 10/6/2021 14:30:20'!
moveForward: aRover

	aRover moveEast.! !


!classDefinition: #North category: 'MarsRover'!
MarsRoverDirection subclass: #North
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!North methodsFor: 'rotation' stamp: 'RI 10/6/2021 14:26:16'!
rotateLeft: aRover

	aRover faceWest.! !

!North methodsFor: 'rotation' stamp: 'RI 10/6/2021 14:26:22'!
rotateRight: aRover

	aRover faceEast.! !


!North methodsFor: 'movement' stamp: 'RI 10/6/2021 14:30:00'!
moveBackwards: aRover

	aRover moveSouth.! !

!North methodsFor: 'movement' stamp: 'RI 10/6/2021 14:29:53'!
moveForward: aRover

	aRover moveNorth.! !


!classDefinition: #South category: 'MarsRover'!
MarsRoverDirection subclass: #South
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!South methodsFor: 'rotation' stamp: 'RI 10/6/2021 14:27:37'!
rotateLeft: aRover

	aRover faceEast.! !

!South methodsFor: 'rotation' stamp: 'RI 10/6/2021 14:27:43'!
rotateRight: aRover

	aRover faceWest.! !


!South methodsFor: 'movement' stamp: 'RI 10/6/2021 14:30:12'!
moveBackwards: aRover

	aRover moveNorth.! !

!South methodsFor: 'movement' stamp: 'RI 10/6/2021 14:30:06'!
moveForward: aRover

	aRover moveSouth.! !


!classDefinition: #West category: 'MarsRover'!
MarsRoverDirection subclass: #West
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover'!

!West methodsFor: 'rotation' stamp: 'RI 10/6/2021 14:27:52'!
rotateLeft: aRover

	aRover faceSouth.! !

!West methodsFor: 'rotation' stamp: 'RI 10/6/2021 14:28:04'!
rotateRight: aRover

	aRover faceNorth.! !


!West methodsFor: 'movement' stamp: 'RI 10/6/2021 14:30:43'!
moveBackwards: aRover

	aRover moveEast.! !

!West methodsFor: 'movement' stamp: 'RI 10/6/2021 14:30:34'!
moveForward: aRover

	aRover moveWest.! !
